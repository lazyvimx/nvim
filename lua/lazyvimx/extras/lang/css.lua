local cssls_setup = function()
	local capabilities = vim.lsp.protocol.make_client_capabilities()

	capabilities.textDocument.completion.completionItem.snippetSupport = true
	require("lspconfig").cssls.setup({ capabilities = capabilities })

	return true
end

return {
	desc = "CSS/SCSS language support with LSP, treesitter, and formatting via Prettier and Stylelint",

	{
		"neovim/nvim-lspconfig",
		opts = {
			servers = { cssls = {} },
			setup = { cssls = cssls_setup },
		},
	},

	{
		"nvim-treesitter/nvim-treesitter",
		opts = function(_, opts)
			opts.ensure_installed = opts.ensure_installed or {}
			vim.list_extend(opts.ensure_installed, { "css", "scss" })
		end,
	},

	{
		"stevearc/conform.nvim",
		optional = true,

		opts = function(_, opts)
			opts.formatters_by_ft = opts.formatters_by_ft or {}
			opts.formatters_by_ft.css = opts.formatters_by_ft.css or {}

			if LazyVim.has_extra("formatting.prettier") then
				vim.list_extend(opts.formatters_by_ft.css, { "prettier" })
			end

			vim.list_extend(opts.formatters_by_ft.css, { "stylelint" })
		end,
	},

	{
		"neovim/nvim-lspconfig",
		optional = true,
		opts = function(_, opts)
			if LazyVim.has_extra("linting.eslint") then
				if opts.servers.stylelint_lsp == nil then
					opts.servers.stylelint_lsp = { filetypes = {}, mason = false }
				end

				table.insert(opts.servers.stylelint_lsp.filetypes, "css")
			end
		end,
	},
}
