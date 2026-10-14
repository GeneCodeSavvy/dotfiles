return { -- Collection of various small independent plugins/modules
	"echasnovski/mini.nvim",
	config = function()
		-- Better Around/Inside textobjects
		--
		-- Examples:
		--  - va)  - [V]isually select [A]round [)]paren
		--  - yinq - [Y]ank [I]nside [N]ext [Q]uote
		--  - ci'  - [C]hange [I]nside [']quote
		require("mini.ai").setup({ n_lines = 500 })

		-- Move around text and selections easily
		require("mini.move").setup()

		-- Simple and easy statusline.
		--  You could remove this setup call if you don't like it,
		--  and try some other statusline plugin
		local statusline = require("mini.statusline")
		-- set use_icons to true if you have a Nerd Font
		statusline.setup({ use_icons = vim.g.have_nerd_font })

		-- You can configure sections in the statusline by overriding their
		-- default behavior. For example, here we set the section for
		-- cursor location to LINE:COLUMN
		---@diagnostic disable-next-line: duplicate-set-field
		statusline.section_location = function()
			return "%2l:%-2v"
		end

		require("token_count").setup()
		local orig_fileinfo = statusline.section_fileinfo
		---@diagnostic disable-next-line: duplicate-set-field
		statusline.section_fileinfo = function(args)
			local info = orig_fileinfo(args)
			if MiniStatusline.is_truncated(args.trunc_width) or vim.bo.buftype ~= "" then
				return info
			end
			local tokens = require("token_count").get()
			if tokens == "" then
				return info
			end
			if info == "" then
				return tokens
			end
			return info .. " " .. tokens
		end

		-- ... and there is more!
		--  Check out: https://github.com/echasnovski/mini.nvim
	end,
}
