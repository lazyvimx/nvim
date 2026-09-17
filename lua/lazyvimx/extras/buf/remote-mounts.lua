local desc = "Safe and lightweight editing of files on network mounts (sshfs and alike)"

local mount_roots = {
	vim.fs.normalize("~/mnt"),
}

local function is_on_mount(path)
	if path == "" then
		return false
	end

	path = vim.fs.normalize(path)

	for _, root in ipairs(mount_roots) do
		if path == root or vim.startswith(path, root .. "/") then
			return true
		end
	end

	return false
end

local function create_autocmd_setup_mounted_buf()
	vim.api.nvim_create_autocmd({ "BufReadPre", "BufNewFile" }, {
		desc = desc,
		callback = function(args)
			if not is_on_mount(args.match) then
				return
			end

			vim.b[args.buf].remote_mount = true

			-- Every swap/undo flush is a network roundtrip
			vim.bo[args.buf].swapfile = false
			vim.bo[args.buf].undofile = false

			-- Formatters have no business rewriting someone else's configs
			vim.b[args.buf].autoformat = false

			-- Writing via tempfile + rename drops the owner, mode and symlink on sshfs,
			-- which is not something to discover on a file under /etc
			vim.api.nvim_set_option_value("backupcopy", "yes", { buf = args.buf })
		end,
	})

	vim.api.nvim_create_autocmd("LspAttach", {
		desc = desc,
		callback = function(args)
			if not vim.b[args.buf].remote_mount then
				return
			end

			vim.schedule(function()
				pcall(vim.lsp.buf_detach_client, args.buf, args.data.client_id)
			end)
		end,
	})
end

return {
	"lazyvimx/nvim",
	name = "lazyvimx",
	desc = desc,
	opts = create_autocmd_setup_mounted_buf,
}
