local desc = "Deletes [No Name] buffers if they have not been modified"

local function create_autocmd_delete_noname_buf()
	vim.api.nvim_create_autocmd("BufHidden", {
		desc = desc,
		callback = function(args)
			if args.file == "" and vim.bo[args.buf].buftype == "" and not vim.bo[args.buf].modified then
				vim.schedule(function()
					pcall(Snacks.bufdelete, args.buf, { force = true })
				end)
			end
		end,
	})
end

return {
	"lazyvimx/nvim",
	name = "lazyvimx",
	desc = desc,
	opts = create_autocmd_delete_noname_buf,
}
