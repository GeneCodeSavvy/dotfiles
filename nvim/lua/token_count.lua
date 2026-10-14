-- Async file token counts for mini.statusline, via ttok (tiktoken).
-- Statusline only reads the cache; ttok runs on BufEnter and BufWritePost.

local M = {}

local MAX_BYTES = 512 * 1024
local MODEL = "gpt-5"

---@class token_count.Entry
---@field path string
---@field mtime string
---@field label string
---@field job vim.SystemObj?

---@type table<integer, token_count.Entry>
local cache = {}

local ttok_path ---@type string|nil
local ttok_checked = false

local function resolve_ttok()
	if ttok_checked then
		return ttok_path
	end
	ttok_checked = true
	if vim.fn.executable("ttok") == 1 then
		ttok_path = "ttok"
		return ttok_path
	end
	local fallback = vim.fn.expand("~/.local/bin/ttok")
	if vim.fn.executable(fallback) == 1 then
		ttok_path = fallback
		return ttok_path
	end
	return nil
end

local function format_count(n)
	if n >= 1000000 then
		return string.format("%.1fM tok", n / 1000000)
	end
	if n >= 1000 then
		return string.format("%.1fk tok", n / 1000)
	end
	return string.format("%d tok", n)
end

---@return string|nil, uv.fs_stat.result|nil
local function buf_file(bufnr)
	local name = vim.api.nvim_buf_get_name(bufnr)
	if name == "" then
		return nil
	end
	local stat = vim.uv.fs_stat(name)
	if not stat or stat.type ~= "file" then
		return nil
	end
	return name, stat
end

local function should_skip(bufnr)
	if not vim.api.nvim_buf_is_valid(bufnr) then
		return true
	end
	return vim.bo[bufnr].buftype ~= ""
end

---@param bufnr? integer
function M.get(bufnr)
	bufnr = bufnr or vim.api.nvim_get_current_buf()
	local entry = cache[bufnr]
	if not entry then
		return ""
	end
	return entry.label
end

---@param bufnr? integer
function M.recount(bufnr)
	bufnr = bufnr or vim.api.nvim_get_current_buf()
	if should_skip(bufnr) then
		cache[bufnr] = nil
		return
	end

	local exe = resolve_ttok()
	if not exe then
		cache[bufnr] = nil
		return
	end

	local path, stat = buf_file(bufnr)
	if not path or not stat then
		cache[bufnr] = nil
		return
	end

	if stat.size > MAX_BYTES then
		cache[bufnr] = { path = path, mtime = "", label = "" }
		return
	end

	local mtime = tostring(stat.mtime.sec) .. "." .. tostring(stat.mtime.nsec)
	local existing = cache[bufnr]
	if existing and existing.path == path and existing.mtime == mtime then
		return
	end

	if existing and existing.job then
		existing.job:kill(15)
	end

	---@type token_count.Entry
	local entry = {
		path = path,
		mtime = mtime,
		label = (existing and existing.path == path and existing.label) or "",
		job = nil,
	}
	cache[bufnr] = entry

	entry.job = vim.system({ exe, "-m", MODEL, "--allow-special", "-i", path }, { text = true }, function(result)
		vim.schedule(function()
			local current = cache[bufnr]
			if not current or current.mtime ~= mtime then
				return
			end
			current.job = nil
			if result.code ~= 0 then
				return
			end
			local n = tonumber((result.stdout or ""):match("%d+"))
			if not n then
				return
			end
			current.label = format_count(n)
			vim.cmd.redrawstatus()
		end)
	end)
end

function M.setup()
	local group = vim.api.nvim_create_augroup("token_count", { clear = true })
	vim.api.nvim_create_autocmd({ "BufEnter", "BufWritePost" }, {
		group = group,
		callback = function(args)
			M.recount(args.buf)
		end,
	})
	vim.api.nvim_create_autocmd("BufDelete", {
		group = group,
		callback = function(args)
			cache[args.buf] = nil
		end,
	})
	vim.api.nvim_create_user_command("TokenCount", function()
		local bufnr = vim.api.nvim_get_current_buf()
		cache[bufnr] = nil
		M.recount(bufnr)
	end, { desc = "Recount tokens in the current file" })

	-- BufEnter may already have fired for the first file.
	vim.schedule(function()
		M.recount()
	end)
end

return M
