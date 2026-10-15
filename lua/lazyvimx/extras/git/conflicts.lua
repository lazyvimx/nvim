local interval = 3000

local function notifier_create(text, level)
	return function()
		vim.notify("Conflict " .. text .. " in '" .. vim.fn.expand("%:.") .. "'", level)
	end
end

return {
	"akinsho/git-conflict.nvim",
	desc = "A plugin to visualise and resolve conflicts in neovim",

	opts = function()
		local throttle = require("git-conflict.utils").throttle
		local notifier_detected = throttle(interval, notifier_create("detected", vim.log.levels.WARN))
		local notifier_resolved = throttle(interval, notifier_create("resolved", vim.log.levels.INFO))

		vim.api.nvim_create_autocmd("User", {
			pattern = "GitConflictDetected",
			callback = notifier_detected,
		})

		vim.api.nvim_create_autocmd("User", {
			pattern = "GitConflictResolved",
			callback = notifier_resolved,
		})
	end,
}
