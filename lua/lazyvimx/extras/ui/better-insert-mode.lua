return {
	desc = "Automatically hide distracting UI elements (context, indent, symbols, column) during insert mode",

	{
		"nvim-treesitter/nvim-treesitter-context",
		optional = true,
		opts = function()
			vim.api.nvim_create_autocmd("InsertEnter", {
				callback = function()
					require("treesitter-context").disable()
				end,
			})

			vim.api.nvim_create_autocmd("InsertLeave", {
				callback = function()
					require("treesitter-context").enable()
				end,
			})
		end,
	},

	{
		"Wansmer/symbol-usage.nvim",
		optional = true,

		opts = function()
			vim.api.nvim_create_autocmd("InsertEnter", {
				callback = function(event)
					require("symbol-usage.buf").clear_buffer(event.buf)
				end,
			})

			vim.api.nvim_create_autocmd("InsertLeave", {
				callback = function(event)
					require("symbol-usage.buf").attach_buffer(event.buf)
				end,
			})
		end,
	},

	{
		"folke/snacks.nvim",
		optional = true,

		opts = function()
			vim.api.nvim_create_autocmd("InsertEnter", {
				callback = function()
					require("snacks").indent.disable()
				end,
			})

			vim.api.nvim_create_autocmd("InsertLeave", {
				callback = function()
					require("snacks").indent.enable()
				end,
			})
		end,
	},

	{
		"lukas-reineke/virt-column.nvim",
		optional = true,

		opts = function()
			vim.api.nvim_create_autocmd("InsertEnter", {
				callback = function()
					require("virt-column").update({ enabled = false })
				end,
			})

			vim.api.nvim_create_autocmd("InsertLeave", {
				callback = function()
					require("virt-column").update({ enabled = true })
				end,
			})
		end,
	},
}
