local M = {}

-- В svelte/astro стили живут внутри разметки, без postcss-html stylelint их не распарсит.
local html_like = { svelte = true, astro = true }

function M.conform_formatter(bufnr)
	local filetype = vim.api.nvim_get_option_value("filetype", { buf = bufnr })
	local prepend_args = html_like[filetype] and { "--custom-syntax", "postcss-html" } or {}
	local command = require("conform.util").find_executable({ "node_modules/.bin/stylelint" }, "stylelint")

	return {
		command = command,
		prepend_args = prepend_args,
	}
end

return M
