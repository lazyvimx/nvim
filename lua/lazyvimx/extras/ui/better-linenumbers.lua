return {
	"LazyVim/LazyVim",
	desc = "Smart line number display that disables relative numbers in command-line mode and all numbers in terminals",
	opts = function()
		local function set_relnum_back(win)
			vim.api.nvim_create_autocmd("CmdlineLeave", {
				once = true,
				callback = function()
					vim.wo[win].relativenumber = true
				end,
			})
		end

		vim.api.nvim_create_autocmd("CmdlineEnter", {
			desc = "Disables `relativenumber` when entering command line mode and enables it again when leaving",
			callback = function()
				local win = vim.api.nvim_get_current_win()

				if vim.wo[win].relativenumber then
					vim.wo[win].relativenumber = false
					vim.cmd("redraw")
					set_relnum_back(win)
				end
			end,
		})

		vim.api.nvim_create_autocmd("TermOpen", {
			desc = "Disable line numbers for terminal",
			callback = function()
				vim.opt_local.number = false
				vim.opt_local.relativenumber = false
			end,
		})
	end,
}
