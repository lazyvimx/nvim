local function prettier_svelte_formatter()
	local formatter = require("conform.formatters.prettier")
	formatter.args = { "--stdin-filepath", "$FILENAME" }

	return formatter
end

return {
	{
		"stevearc/conform.nvim",
		optional = true,
		opts = function(_, opts)
			if LazyVim.has_extra("lang.svelte") then
				opts.formatters["prettier_svelte"] = prettier_svelte_formatter()

				require("conform").formatters.stylelint = require("lazyvimx.util.stylelint").conform_formatter

				if LazyVim.has_extra("formatting.prettier") then
					opts.formatters_by_ft = opts.formatters_by_ft or {}
					opts.formatters_by_ft.svelte = { "prettier_svelte", "stylelint" }
				end
			end
		end,
	},

	{
		"neovim/nvim-lspconfig",
		optional = true,
		opts = function(_, opts)
			if LazyVim.has_extra("lang.svelte") then
				if LazyVim.has_extra("linting.eslint") then
					opts.servers.stylelint_lsp = opts.servers.stylelint_lsp or { filetypes = {}, mason = false }
					table.insert(opts.servers.stylelint_lsp.filetypes, "svelte")
				end
			end
		end,
	},
}
