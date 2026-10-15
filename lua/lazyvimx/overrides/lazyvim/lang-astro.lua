return {
	{
		"stevearc/conform.nvim",
		optional = true,
		opts = function(_, opts)
			if not LazyVim.has_extra("lang.astro") then
				return
			end

			require("conform").formatters.stylelint = require("lazyvimx.util.stylelint").conform_formatter

			-- Апстрим ставит только prettier, без stylelint.
			if LazyVim.has_extra("formatting.prettier") then
				opts.formatters_by_ft = opts.formatters_by_ft or {}
				opts.formatters_by_ft.astro = { "prettier", "stylelint" }
			end
		end,
	},

	{
		"neovim/nvim-lspconfig",
		optional = true,
		opts = function(_, opts)
			if LazyVim.has_extra("lang.astro") and LazyVim.has_extra("linting.eslint") then
				opts.servers.stylelint_lsp = opts.servers.stylelint_lsp or { filetypes = {}, mason = false }
				table.insert(opts.servers.stylelint_lsp.filetypes, "astro")
			end
		end,
	},
}
