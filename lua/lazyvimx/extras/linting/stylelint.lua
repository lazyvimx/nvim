-- Server startup must not depend on recognizing the stylelint config path: resolve the root
-- via LazyVim's shared detector (the same one used everywhere in this config), while stylelint
-- itself locates the config (including the non-standard `.config/stylelintrc.js`) through
-- cosmiconfig relative to the document path.
local function root_dir(bufnr, on_dir)
	on_dir(LazyVim.root.get({ buf = bufnr }))
end

return {
	desc = "Stylelint CSS linter installation via Mason and stylelint_lsp diagnostics setup",

	{
		"mason-org/mason.nvim",
		opts = { ensure_installed = { "stylelint-language-server" } },
	},

	{
		"neovim/nvim-lspconfig",
		optional = true,
		opts = function(_, opts)
			if not LazyVim.has_extra("linting.eslint") then
				return
			end

			opts.servers.stylelint_lsp = opts.servers.stylelint_lsp or { filetypes = {}, mason = false }
			opts.servers.stylelint_lsp.root_dir = root_dir
			-- `validate` is extended with `svelte` and others: without it the server won't send the
			-- matching documents to stylelint. Extra filetypes are harmless — only actually attached
			-- ones get validated (those added to `filetypes` in `lang/css.lua` and
			-- `overrides/lazyvim/lang-svelte.lua`).
			opts.servers.stylelint_lsp.settings = vim.tbl_deep_extend("force", opts.servers.stylelint_lsp.settings or {}, {
				stylelint = {
					validate = { "css", "postcss", "scss", "less", "html", "vue", "svelte" },
				},
			})
		end,
	},
}
