local desc = "Fold a selection into an inline label, keeping its highlights and extmarks"

-- Every fold lives in its own namespace, so unfolding drops all of its marks at once
local folds = {}

local function line_len(row)
	return #vim.api.nvim_buf_get_lines(0, row, row + 1, true)[1]
end

-- Native folds are linewise and can't be made by hand with foldmethod=expr, so the text
-- stays in the buffer behind inline virtual text and keeps its highlights and extmarks
local function fold(first, last, start_col, end_col, label)
	local ns = vim.api.nvim_create_namespace("")
	local tail_hidden = first == last or end_col >= line_len(last)

	vim.api.nvim_buf_set_extmark(0, ns, first, start_col, {
		end_col = first == last and end_col or line_len(first),
		conceal = "",
		virt_text = { { label, "InlineFold" } },
		virt_text_pos = "inline",
		invalidate = true,
	})

	local hidden_last = tail_hidden and last or last - 1

	if hidden_last > first then
		vim.api.nvim_buf_set_extmark(0, ns, first + 1, 0, {
			end_row = hidden_last,
			conceal_lines = "",
			invalidate = true,
		})
	end

	-- Joining the tail with the head would lose its highlights, so it keeps its own line
	if not tail_hidden then
		vim.api.nvim_buf_set_extmark(0, ns, last, 0, { end_col = end_col, conceal = "", invalidate = true })
	end

	folds[ns] = true

	vim.opt_local.conceallevel = math.max(vim.wo.conceallevel, 2)
	-- Otherwise the cursor line reveals the text right next to the label
	vim.opt_local.concealcursor = "nvic"
end

-- The exact cursor position wins, then any fold on the line, e.g. a multiline tail
local function fold_at_cursor()
	local row, col = unpack(vim.api.nvim_win_get_cursor(0))
	local ranges = { { { row - 1, col }, { row - 1, col } }, { { row - 1, 0 }, { row - 1, -1 } } }

	for _, range in ipairs(ranges) do
		local marks = vim.api.nvim_buf_get_extmarks(0, -1, range[1], range[2], { overlap = true, details = true })

		for _, mark in ipairs(marks) do
			if folds[mark[4].ns_id] then
				return mark[4].ns_id
			end
		end
	end
end

local function fold_selection()
	local mode = vim.fn.mode()

	if mode == "\22" then
		return vim.notify("Blockwise selection can't be folded inline", vim.log.levels.WARN)
	end

	local region = vim.fn.getregionpos(vim.fn.getpos("v"), vim.fn.getpos("."), { type = mode })
	local head, tail = region[1][1], region[#region][2]
	local first, last = head[2] - 1, tail[2] - 1
	local start_col = mode == "V" and 0 or head[3] - 1
	local end_col = math.min(tail[3], line_len(last))

	vim.api.nvim_feedkeys(vim.keycode("<esc>"), "nx", false)

	vim.ui.input({ prompt = "Fold label: " }, function(label)
		if label ~= nil then
			fold(first, last, start_col, end_col, label ~= "" and label or "…")
		end
	end)
end

-- Where the cursor goes instead of concealed text, nil when it's visible. The label
-- counts as the start of the fold: that's where the cursor is drawn on it
local function snap(row, col, prev)
	local marks = vim.api.nvim_buf_get_extmarks(0, -1, { row, 0 }, { row, -1 }, { overlap = true, details = true })
	local backward = prev and (prev[1] > row or prev[1] == row and prev[2] > col)
	local same_row = prev and prev[1] == row

	for _, mark in ipairs(marks) do
		local ns, start_col, details = mark[4].ns_id, mark[3], mark[4]

		if folds[ns] then
			-- The head is always the first mark of its namespace
			local head = vim.api.nvim_buf_get_extmark_by_id(0, ns, 1, {})

			if details.conceal_lines then
				local below = details.end_row + 1

				if backward or below >= vim.api.nvim_buf_line_count(0) then
					return head[1], head[2]
				end

				return below, 0
			elseif details.virt_text then
				if col > start_col and col < details.end_col then
					if same_row and not backward and details.end_col < line_len(row) then
						return row, details.end_col
					end

					return row, start_col
				end
			elseif col < details.end_col then
				if same_row and backward then
					return head[1], head[2]
				end

				return row, details.end_col
			end
		end
	end
end

local prev_pos = {}

local function keep_cursor_visible()
	if next(folds) == nil then
		return
	end

	local win = vim.api.nvim_get_current_win()
	local row, col = unpack(vim.api.nvim_win_get_cursor(win))
	local pos, prev = { row - 1, col }, prev_pos[win]

	-- A fold may lead into another one, e.g. its hidden lines into the tail
	for _ = 1, 3 do
		local next_row, next_col = snap(pos[1], pos[2], prev)

		if not next_row then
			break
		end

		pos = { next_row, next_col }
	end

	if pos[1] ~= row - 1 or pos[2] ~= col then
		vim.api.nvim_win_set_cursor(win, { pos[1] + 1, pos[2] })
	end

	prev_pos[win] = pos
end

-- The label is a part of the line, so it keeps the line background unlike a native fold
local function set_hl()
	local folded = vim.api.nvim_get_hl(0, { name = "Folded", link = false })

	vim.api.nvim_set_hl(0, "InlineFold", { fg = folded.fg, italic = folded.italic, default = true })
end

local function unfold_at_cursor()
	local ns = fold_at_cursor()

	if ns then
		vim.api.nvim_buf_clear_namespace(0, ns, 0, -1)
		folds[ns] = nil
	else
		vim.api.nvim_feedkeys(vim.v.count1 .. "zF", "n", false)
	end
end

return {
	"lazyvimx/nvim",
	name = "lazyvimx",
	desc = desc,
	opts = function()
		local group = vim.api.nvim_create_augroup("lazyvimx_inline_fold", { clear = true })

		set_hl()

		vim.api.nvim_create_autocmd("ColorScheme", { group = group, callback = set_hl })
		vim.api.nvim_create_autocmd("CursorMoved", { group = group, callback = keep_cursor_visible })

		vim.keymap.set("x", "zF", fold_selection, { desc = "Fold selection inline" })
		vim.keymap.set("n", "zF", unfold_at_cursor, { desc = "Unfold inline fold" })
	end,
}
