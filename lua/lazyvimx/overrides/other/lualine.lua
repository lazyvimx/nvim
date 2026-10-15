-- Хуки расширений в opts выровнены таблицей, по одному в строку.
--# selene: allow(multiple_statements)

local mode_icon_map = {
	["NORMAL"] = "󰰓",
	["O-PENDING"] = "",
	["VISUAL"] = "󰰫",
	["V-LINE"] = "󰰬",
	["V-BLOCK"] = "󰰪",
	["V-REPLACE"] = "󰬝",
	["SELECT"] = "󰰢",
	["S-LINE"] = "󰰣",
	["S-BLOCK"] = "󰰡",
	["INSERT"] = "󰰄",
	["COMMAND"] = "󰯲",
	["EX"] = "󰰱",
	["REPLACE"] = "󰰟",
	["MORE"] = "󰰐",
	["CONFIRM"] = "󰯳",
	["SHELL"] = "󰰡",
	["TERMINAL"] = "󰰤",
}

local function cond_hidden_always()
	return false
end

return {
	"nvim-lualine/lualine.nvim",
	optional = true,

	opts = function(_, opts)
		-- stylua: ignore start
		require("lualine.extensions.lazy").sections.lualine_a =		{ function() return "󰒲  lazy " end }
		require("lualine.extensions.mason").sections.lualine_a =	{ function() return " mason " end }

		require("lualine.extensions.fugitive").sections.lualine_a =	{ function() return "  git  " end }
		require("lualine.extensions.fugitive").sections.lualine_b =	{ function() return " " .. vim.fn.FugitiveHead() end }

		require("lualine.extensions.neo-tree").sections.lualine_a =	{ function() return "󱉭  root " end }
		require("lualine.extensions.neo-tree").sections.lualine_b =	{ function() return vim.fn.fnamemodify(vim.fn.getcwd(), ':~') end }
		-- stylua: ignore end

		table.insert(opts.extensions, "fugitive")
		table.insert(opts.extensions, "mason")

		opts.options.component_separators = { left = "", right = "" }
		opts.options.section_separators = { left = "", right = "" }

		opts.sections.lualine_a = {
			{
				function()
					local mode_name_upper = require("lualine.utils.mode").get_mode()
					local mode_name_lower = mode_name_upper:lower()
					local mode_icon_raw = mode_icon_map[mode_name_upper]
					local mode_icon_safety = mode_icon_raw == nil and "" or mode_icon_raw

					return mode_icon_safety .. " " .. mode_name_lower
				end,
			},
		}

		opts.sections.lualine_b = { { "branch", icon = "" } }

		opts.sections.lualine_y = {
			{ "location", padding = { left = 1, right = 1 } },
			{
				function()
					local current_line = vim.fn.line(".")
					local total_lines = vim.fn.line("$")
					local chars = { "", "󰪞", "󰪟", "󰪠", "󰪡", "󰪢", "󰪣", "󰪤", "󰪥" }
					local line_ratio = current_line / total_lines
					local index = math.ceil(line_ratio * #chars)

					return chars[index]
				end,
				separator = " ",
				padding = { left = 1, right = 1 },
			},
		}

		opts.sections.lualine_c[4].cond = cond_hidden_always
		opts.sections.lualine_c[3].cond = cond_hidden_always

		opts.sections.lualine_z = {}
	end,
}
