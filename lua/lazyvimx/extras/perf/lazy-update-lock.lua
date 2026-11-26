local function guard(name, command)
	local lock_path = require("lazy.core.config").options.root .. "/.update.lock"
	local flags = vim.uv.constants
	local open_flags = require("bit").bor(flags.O_CREAT, flags.O_RDWR, flags.O_EXLOCK, flags.O_NONBLOCK)

	return function(opts)
		-- macOS releases the exclusive lock when the descriptor closes, even if Neovim crashes.
		local fd, err, code = vim.uv.fs_open(lock_path, open_flags, 384)
		if not fd then
			if code == "EAGAIN" or code == "EWOULDBLOCK" then
				vim.notify("A Lazy plugin update is already running.", vim.log.levels.WARN)
			else
				vim.notify("Cannot lock Lazy plugin updates: " .. tostring(err), vim.log.levels.ERROR)
			end
			return
		end

		local function release()
			if fd then
				vim.uv.fs_close(fd)
				fd = nil
			end
		end

		-- Sync signals completion after clean, install and update. The other commands return a runner.
		local on_sync
		if name == "sync" then
			on_sync = vim.api.nvim_create_autocmd("User", { pattern = "LazySync", once = true, callback = release })
		end

		local ok, runner = pcall(command, opts)
		if not ok then
			if on_sync and fd then
				vim.api.nvim_del_autocmd(on_sync)
			end
			release()
			error(runner, 0)
		end
		if runner then
			runner:wait(release)
		end
		return runner
	end
end

return {
	"folke/lazy.nvim",
	desc = "Prevent concurrent lazy.nvim updates across Neovim sessions on macOS",
	init = function()
		if vim.fn.has("mac") == 0 then
			return
		end

		local commands = require("lazy.view.commands").commands
		for _, name in ipairs({ "sync", "update", "restore" }) do
			commands[name] = guard(name, commands[name])
		end
	end,
}
