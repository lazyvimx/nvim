return {
	desc = "QML / Quickshell support with qmlls LSP, qmljs treesitter, and qmlformat",

	{
		"neovim/nvim-lspconfig",
		opts = {
			servers = {
				qmlls = {
					-- qmlls ships with Qt and must match the Qt that Quickshell uses
					mason = false,
					cmd = { vim.fn.executable("qmlls6") == 1 and "qmlls6" or "qmlls" },
				},
			},
		},
	},

	{
		"nvim-treesitter/nvim-treesitter",
		opts = function(_, opts)
			opts.ensure_installed = opts.ensure_installed or {}
			vim.list_extend(opts.ensure_installed, { "qmljs", "qmldir" })
		end,
	},

	{
		"stevearc/conform.nvim",
		optional = true,
		opts = {
			formatters_by_ft = { qml = { "qmlformat" } },
		},
	},
}
