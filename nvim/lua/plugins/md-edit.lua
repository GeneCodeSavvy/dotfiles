-- Doom-style Markdown list/table/quote continuation on Enter.
-- https://github.com/yousefhadder/markdown-plus.nvim
--
-- Default markdown-plus keymaps stay off: maplocalleader is Space, same as
-- leader, so those maps would collide with window and toggle bindings.

local function feed(keys, remap)
	vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes(keys, true, false, true), remap and "m" or "n", false)
end

local function confirm_completion()
	local ok, cmp = pcall(require, "cmp")
	if ok and cmp.visible() then
		cmp.confirm({ select = true })
		return true
	end
	return false
end

local function native_insert_newline()
	local row, col = unpack(vim.api.nvim_win_get_cursor(0))
	local line = vim.api.nvim_get_current_line()
	local indent = (line:sub(1, col):match("^%s*") or "")
	vim.api.nvim_buf_set_text(0, row - 1, col, row - 1, col, { "", indent })
	vim.api.nvim_win_set_cursor(0, { row + 1, #indent })
end

---Parse a blockquote / callout prefix. Returns prefix (including trailing
---spaces after the last `>`) and the remainder of the line, or nil.
local function parse_quote(line)
	if not line:match("^%s*>") then
		return nil
	end
	local i = 1
	while line:sub(i, i):match("%s") do
		i = i + 1
	end
	if line:sub(i, i) ~= ">" then
		return nil
	end
	while i <= #line do
		if line:sub(i, i) == ">" then
			i = i + 1
			while line:sub(i, i) == " " or line:sub(i, i) == "\t" do
				i = i + 1
			end
		else
			break
		end
	end
	return line:sub(1, i - 1), line:sub(i)
end

local function with_trailing_space(prefix)
	if prefix:match("%s$") then
		return prefix
	end
	return prefix .. " "
end

local function list_item_text(list_info, marker)
	local checkbox = list_info.checkbox and " [ ]" or ""
	return list_info.indent .. marker .. checkbox .. " "
end

local function continue_quoted_list(prefix, rest, row, above)
	local parser = require("markdown-plus.list.parser")
	local list_info = parser.parse_list_line(rest)
	if not list_info then
		return nil
	end
	local marker
	if above then
		-- get_previous_marker reads the previous buffer line, which is still quoted,
		-- so pass row 1 to get the initial marker for this list type.
		marker = parser.get_previous_marker(list_info, 1)
	else
		marker = parser.get_next_marker(list_info)
	end
	return with_trailing_space(prefix) .. list_item_text(list_info, marker)
end

---Insert-mode Enter inside a quote or callout. Returns true if it handled the key.
local function quote_insert_enter()
	local line = vim.api.nvim_get_current_line()
	local prefix, rest = parse_quote(line)
	if not prefix then
		return false
	end

	local row, col = unpack(vim.api.nvim_win_get_cursor(0))
	local next_prefix = with_trailing_space(prefix)
	local list = require("markdown-plus.list")
	local list_info = list.parse_list_line(rest)

	if rest:match("^%s*$") then
		local indent = line:match("^(%s*)") or ""
		vim.api.nvim_set_current_line(indent)
		vim.api.nvim_win_set_cursor(0, { row, #indent })
		return true
	end

	if list_info and list.is_empty_list_item(rest, list_info) then
		vim.api.nvim_set_current_line(next_prefix)
		vim.api.nvim_win_set_cursor(0, { row, #next_prefix })
		return true
	end

	local after = line:sub(col + 1)
	local before = line:sub(1, col)
	if #after > 0 then
		vim.api.nvim_set_current_line(before)
	end

	local new_line
	local cursor_col
	if list_info then
		new_line = continue_quoted_list(prefix, rest, row, false)
		cursor_col = #new_line
		if after:match("%S") then
			new_line = new_line .. after:match("^%s*(.*)")
		end
	else
		-- Body line, including callout headers like `> [!NOTE]`.
		new_line = next_prefix
		cursor_col = #next_prefix
		if after:match("%S") and not rest:match("^%[!%w+%]") then
			new_line = next_prefix .. after:match("^%s*(.*)")
		end
	end

	vim.api.nvim_buf_set_lines(0, row, row, false, { new_line })
	vim.api.nvim_win_set_cursor(0, { row + 1, cursor_col })
	return true
end

local function quote_normal_new(above)
	local line = vim.api.nvim_get_current_line()
	local prefix, rest = parse_quote(line)
	if not prefix then
		return false
	end

	local row = vim.api.nvim_win_get_cursor(0)[1]
	local new_line = continue_quoted_list(prefix, rest, row, above)
	if not new_line then
		new_line = with_trailing_space(prefix)
	end

	if above then
		vim.api.nvim_buf_set_lines(0, row - 1, row - 1, false, { new_line })
		vim.api.nvim_win_set_cursor(0, { row, #new_line })
	else
		vim.api.nvim_buf_set_lines(0, row, row, false, { new_line })
		vim.api.nvim_win_set_cursor(0, { row + 1, #new_line })
	end
	vim.cmd("startinsert!")
	return true
end

local function in_code_block()
	return require("markdown-plus.utils").is_in_code_block()
end

local function insert_enter()
	if confirm_completion() then
		return
	end

	local mp = require("markdown-plus")
	if mp.table and mp.table.is_in_table() then
		mp.table.insert_row_below()
		return
	end

	if in_code_block() then
		native_insert_newline()
		return
	end

	if quote_insert_enter() then
		return
	end

	if mp.in_list_context("enter") then
		require("markdown-plus.list").handle_enter()
		return
	end

	native_insert_newline()
end

local function list_line_info()
	local list = require("markdown-plus.list")
	local row = vim.api.nvim_win_get_cursor(0)[1]
	return list.parse_list_line(vim.api.nvim_get_current_line(), row)
end

local function new_list_item_below()
	if in_code_block() then
		feed("o", false)
		return
	end
	if quote_normal_new(false) then
		return
	end
	if list_line_info() then
		require("markdown-plus.list").handle_normal_o()
		return
	end
	feed("o", false)
end

local function new_list_item_above()
	if in_code_block() then
		feed("O", false)
		return
	end
	if quote_normal_new(true) then
		return
	end
	if list_line_info() then
		require("markdown-plus.list").handle_normal_O()
		return
	end
	feed("O", false)
end

local function map_buffer(bufnr)
	local map_opts = { buffer = bufnr, silent = true }
	vim.keymap.set("i", "<CR>", insert_enter, vim.tbl_extend("force", map_opts, { desc = "New list item, quote, or table row" }))
	vim.keymap.set(
		"i",
		"<S-CR>",
		insert_enter,
		vim.tbl_extend("force", map_opts, { desc = "New list item, quote, or table row" })
	)
	vim.keymap.set("n", "o", new_list_item_below, vim.tbl_extend("force", map_opts, { desc = "New list item or quote below" }))
	vim.keymap.set("n", "O", new_list_item_above, vim.tbl_extend("force", map_opts, { desc = "New list item or quote above" }))
	vim.keymap.set("n", "<leader>mi", function()
		require("markdown-plus.callouts").insert_callout_prompt()
	end, vim.tbl_extend("force", map_opts, { desc = "Insert markdown callout" }))
	vim.keymap.set("x", "<leader>mi", function()
		require("markdown-plus.callouts").wrap_selection_in_callout()
	end, vim.tbl_extend("force", map_opts, { desc = "Wrap selection in callout" }))
	vim.keymap.set("n", "<leader>mC", function()
		require("markdown-plus.callouts").toggle_callout_type()
	end, vim.tbl_extend("force", map_opts, { desc = "Cycle callout type" }))
end

return {
	"yousefhadder/markdown-plus.nvim",
	ft = "markdown",
	opts = {
		features = {
			list_management = true,
			table = true,
			quotes = true,
			callouts = true,
			html_block_awareness = true,
			text_formatting = false,
			thematic_break = false,
			links = false,
			images = false,
			headers_toc = false,
			code_block = false,
			footnotes = false,
		},
		keymaps = { enabled = false },
		table = {
			keymaps = {
				enabled = false,
				insert_mode_navigation = false,
			},
		},
	},
	config = function(_, opts)
		require("markdown-plus").setup(opts)

		vim.api.nvim_create_autocmd("FileType", {
			group = vim.api.nvim_create_augroup("markdown-edit-enter", { clear = true }),
			pattern = "markdown",
			callback = function(event)
				map_buffer(event.buf)
			end,
		})

		if vim.bo.filetype == "markdown" then
			map_buffer(vim.api.nvim_get_current_buf())
		end
	end,
}
