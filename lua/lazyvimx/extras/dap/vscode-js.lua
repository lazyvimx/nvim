return {
	desc = "This is a DAP-based JavaScript debugger using js-debug-adapter from mason",

	{
		"mfussenegger/nvim-dap",
		optional = true,

		cond = function()
			return not vim.g.vscode and LazyVim.has_extra("dap.core")
		end,

		dependencies = {
			"rcarriga/nvim-dap-ui",
			{
				"mason-org/mason.nvim",
				opts = function(_, opts)
					opts.ensure_installed = opts.ensure_installed or {}
					if not vim.tbl_contains(opts.ensure_installed, "js-debug-adapter") then
						table.insert(opts.ensure_installed, "js-debug-adapter")
					end
				end,
			},
		},

		opts = function()
			local dap = require("dap")

			for _, adapterType in ipairs({ "node", "chrome" }) do
				local pwaType = "pwa-" .. adapterType
				if not dap.adapters[pwaType] then
					dap.adapters[pwaType] = {
						type = "server",
						host = "localhost",
						port = "${port}",
						executable = {
							command = "js-debug-adapter",
							args = { "${port}" },
						},
					}
				end
			end

			for _, language in ipairs({ "typescript", "javascript", "svelte", "astro" }) do
				dap.configurations[language] = {
					{
						type = "pwa-chrome",
						name = "Launch Chrome to debug client",
						request = "launch",
						url = "http://localhost:8080",
						sourceMaps = true,
						webRoot = "${workspaceFolder}",
						skipFiles = { "**/node_modules/**/*", "**/src/*" },
					},

					{
						type = "pwa-node",
						request = "attach",
						processId = require("dap.utils").pick_process,
						name = "Attach debugger to existing `node --inspect` process",
						sourceMaps = true,
						resolveSourceMapLocations = {
							"${workspaceFolder}/**",
							"!**/node_modules/**",
						},
						cwd = "${workspaceFolder}/src",
						skipFiles = { "${workspaceFolder}/node_modules/**/*.js" },
					},

					language == "javascript" and {
						type = "pwa-node",
						request = "launch",
						name = "Launch file in new node process",
						program = "${file}",
						cwd = "${workspaceFolder}",
					} or nil,
				}
			end
		end,
	},

	{
		"folke/snacks.nvim",
		optional = true,
		opts = require("lazyvimx.util.general").warn_missing_extra("dap.core"),
	},
}
