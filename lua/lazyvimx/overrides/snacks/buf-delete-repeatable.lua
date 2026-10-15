local buf_delete_repeatable_create = function(force)
	return function()
		local M = {}

		function M.buf_delete(bufnr, with_force)
			local buffer_filetype = vim.api.nvim_get_option_value("filetype", { buf = bufnr })

			if buffer_filetype ~= "snacks_dashboard" then
				Snacks.bufdelete(bufnr, { force = with_force })
				vim.cmd([[redraw!]])
			end

			M.buffer_delete_repeat()
		end

		function M.buffer_delete_repeat()
			local char = vim.fn.getcharstr()

			if char == "d" then
				M.buf_delete(vim.fn.bufnr())
			elseif char == "D" then
				M.buf_delete(vim.fn.bufnr(), true)
			elseif char ~= nil then
				vim.api.nvim_feedkeys(vim.keycode(char), "m", true)
			end
		end

		M.buf_delete(vim.fn.bufnr(), force)
	end
end

return {
	"folke/snacks.nvim",

	keys = {
		{ "<leader>bd", buf_delete_repeatable_create(false), desc = "Delete buffer" },
		{ "<leader>bD", buf_delete_repeatable_create(true), desc = "Delete buffer (force)" },
	},
}
