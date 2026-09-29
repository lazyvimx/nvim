local blend = require("lazyvimx.util.general").color_blend

local function colors_get(style)
	local colors = require("tokyonight.colors").setup({
		style = style ~= "" and style or "moon",
		on_colors = function() end,
		on_highlights = override_highlights,
	})

	return colors
end

local override_highlights = function(hl, c)
	hl.BlinkCmpDoc = { bg = c.bg_dark, blend = 15 }
	hl.BlinkCmpDocBorder = { link = "BlinkCmpDoc" }
	hl.BlinkCmpDocSeparator = { fg = blend(c.bg_dark, c.fg, 10) }
	hl.BlinkCmpMenu = { link = "Pmenu" }
	hl.BlinkCmpMenuSelection = { bg = blend(c.bg_dark, c.fg_dark, 10) }
	hl.BlinkCmpScrollBarGutter = { bg = blend(c.bg_dark, c.fg_dark, 15) }
	hl.BlinkCmpScrollBarThumb = { bg = blend(c.bg_dark, c.fg_dark, 25) }
	hl.BufferLineCustomGroupLabel = { bg = c.bg_dark, fg = c.fg }
	hl.BufferLineCustomGroupSep = { bg = c.bg_dark, fg = c.blue }
	hl.CursorLine = { bg = blend(c.bg, c.blue, 10) }
	hl.EdgyTitle = { bg = c.bg_dark, fg = c.bg_dark }
	hl.FlashBackdrop = { fg = blend(c.bg, c.blue2, 15) }
	hl.FlashPrompt = { bg = c.bg_dark }
	hl.FlashPromptSep = { fg = blend(c.bg_dark, c.fg, 50) }
	hl.LineNr = { fg = c.fg_gutter }
	hl.FloatBorder = { fg = blend(c.bg, c.blue2, 50) }
	hl.FloatTitle = { fg = blend(c.bg, c.blue2, 50) }
	hl.InlineFold = { fg = c.blue, bold = true }
	hl.LspReferenceRead = { bg = "none", fg = blend(c.fg, c.magenta2, 50), bold = true }
	hl.LspReferenceText = { bg = "none", fg = blend(c.fg, c.magenta2, 50), bold = true }
	hl.LspReferenceWrite = { bg = "none", fg = blend(c.fg, c.magenta2, 50), bold = true }
	hl.NeoTreeCursorLine = { bg = blend(c.bg_dark1, c.blue, 10) }
	hl.NeoTreeFloatBorder = { link = "FloatBorder" }
	hl.NeoTreeFloatNormal = { link = "NormalFloat" }
	hl.NeoTreeFloatTitle = { link = "FloatTitle" }
	hl.NeoTreeIndentMarker = { fg = blend(c.bg_dark1, c.fg, 10) }
	hl.NeoTreeNormal = { bg = c.bg_dark }
	hl.NeoTreeNormalActive = { bg = blend(c.bg_dark1, c.bg, 20) }
	hl.NeoTreeNormalNC = { bg = c.bg_dark }
	hl.NeoTreeTabActive = { fg = c.fg, bg = blend(c.bg, c.fg, 10) }
	hl.NeoTreeTabInactive = { fg = c.fg, bg = c.bg }
	hl.NeoTreeTabSeparatorActive = { bg = blend(c.bg, c.fg, 10), fg = c.bg }
	hl.NeoTreeTabSeparatorInactive = { bg = c.bg, fg = c.bg }
	hl.NeoTreeWinSeparator = { bg = c.bg, fg = c.bg }
	hl.ScrollView = { bg = blend(c.bg, c.fg, 10), blend = 15 }
	hl.SnacksDashboardBorder = { fg = blend(c.bg, c.fg_gutter, 50) }
	hl.SnacksDashboardDesc = { fg = c.fg }
	hl.SnacksDashboardFooter = { fg = c.fg_dark }
	hl.SnacksDashboardHeader1 = { fg = c.fg_dark }
	hl.SnacksDashboardHeader2 = { fg = blend(c.bg, c.blue0, 50) }
	hl.SnacksDashboardHeader3 = { fg = blend(c.bg, c.blue1, 50) }
	hl.SnacksDashboardHeader4 = { fg = blend(c.bg, c.blue2, 50) }
	hl.SnacksDashboardHeader5 = { fg = blend(c.bg, c.blue5, 50) }
	hl.SnacksDashboardHeader6 = { fg = blend(c.bg, c.blue1, 50) }
	hl.SnacksDashboardHeader7 = { fg = blend(c.bg, c.blue0, 50) }
	hl.SnacksDashboardHeader8 = { fg = c.fg_dark }
	hl.SnacksDashboardIcon = { fg = c.yellow }
	hl.SnacksDashboardKey = { bg = blend(c.bg, c.bg, 50), fg = c.orange }
	hl.SnacksDashboardKeyBorder = { bg = blend(c.bg, c.bg, 50), fg = blend(c.bg, c.fg_gutter, 50) }
	hl.SnacksDashboardSpecial = { fg = blend(c.bg, c.magenta, 50) }
	hl.SnacksIndent = { fg = blend(c.bg, c.fg, 5) }
	hl.SnacksIndentScope = { fg = blend(c.bg, c.fg, 15) }
	hl.SnacksPickerBoxTitle = { link = "FloatBorder" }
	hl.SnacksPickerInputBorder = { fg = blend(c.bg, c.blue2, 25) }
	hl.SnacksPickerInputCursorLine = { bg = c.bg }
	hl.SymbolUsageContent = { fg = blend(c.fg_gutter, c.fg, 10) }
	hl.SymbolUsageDef = { fg = c.red }
	hl.SymbolUsageImpl = { fg = c.yellow }
	hl.SymbolUsageRef = { fg = c.blue }
	hl.TabLineFill = { bg = c.bg_dark }
	hl.TreesitterContext = { bg = c.bg, blend = 10 }
	hl.TreesitterContextBottom = { fg = blend(c.bg, c.fg, 15), blend = 0, underline = true }
	hl.TreesitterContextLineNumber = { bg = c.bg }
	hl.TroubleNormal = { bg = c.bg }
	hl.TroubleNormalNC = { bg = c.bg }
	hl.Visual = { bg = blend(c.bg, c.blue, 10) }
	hl.VisualWhitespace = { bg = blend(c.bg, c.blue, 10), fg = blend(c.fg_gutter, c.fg, 10) }
	hl.WhichKeyBorder = { link = "FloatBorder" }
	hl.WhichKeyNormal = { link = "FloatNormal" }
	hl.WinSeparator = { fg = blend(c.bg, c.bg_dark, 60) }
end

local override_bufferline_hls = function(colorscheme_name)
	local c = colors_get(colorscheme_name:sub(12))

	return function()
		local hls = {
			background = { bg = c.bg_dark },
			buffer_visible = { fg = c.fg_dark },
			fill = { bg = c.bg_dark },
			modified_visible = { fg = c.orange },
			offset_separator = { bg = c.bg_dark1 },
			tab_close = { bg = c.bg_dark },
			diagnostic = { bg = c.bg_dark },
			separator = { bg = c.bg_dark, fg = c.bg_dark1 },
			group_separator = { bg = c.bg_dark, fg = c.bg_dark1 },
			indicator_visible = { fg = c.orange, bg = c.bg_dark },
			indicator_selected = { fg = c.orange },
			tab = { bg = c.bg_dark },
			tab_selected = { fg = c.fg, bold = true },
			tab_separator = { bg = c.bg_dark, fg = c.bg_dark },
			warning = { bg = c.bg_dark, fg = c.orange },
			tab_separator_selected = { bg = c.bg, fg = c.bg },
			trunc_marker = { bg = c.bg_dark },
		}

		local items = {
			"buffer",
			"close_button",
			"diagnostic",
			"error",
			"duplicate",
			"error_diagnostic",
			"hint",
			"hint_diagnostic",
			"info",
			"info_diagnostic",
			"info_diagnostic",
			"modified",
			"separator",
			"numbers",
			"pick",
			"warning",
			"warning_diagnostic",
		}

		for _, key in ipairs(items) do
			if hls[key] == nil then
				hls[key] = { bg = c.bg_dark }
			end

			local key_selected = key .. "_selected"
			local key_visible = key .. "_visible"

			if hls[key_selected] == nil then
				hls[key_selected] = {}
			end

			if hls[key_visible] == nil then
				hls[key_visible] = {}
			end

			hls[key_selected].bg = c.bg
			hls[key_visible].bg = c.bg_dark
		end

		return hls
	end
end

local lualine_theme_create = function(c)
	local colors = {
		["normal"] = c.blue,
		["insert"] = c.green,
		["visual"] = c.magenta,
		["replace"] = c.red,
		["command"] = c.yellow,
		["terminal"] = c.green1,
		["inactive"] = c.bg_statusline,
	}

	local theme = {}

	for mode, color in pairs(colors) do
		theme[mode] = {
			a = { bg = blend(c.bg_dark, color, 70), fg = c.bg_dark },
			b = { bg = blend(c.bg_dark, color, 15), fg = color },
			c = { bg = c.bg_dark, fg = mode == "inactive" and c.fg_dark or c.fg },
			x = { bg = c.bg_dark, fg = c.fg_dark },
		}
	end

	return theme
end

local lualine_opts_override = function(opts, colorscheme_name)
	local colors = colors_get(colorscheme_name:sub(12))

	opts.options.theme = lualine_theme_create(colors)

	for _, wb in pairs({ opts.inactive_winbar, opts.winbar }) do
		for _, section in pairs(wb.lualine_c) do
			section.color.bg = colors.bg
		end
	end
end

return {
	{
		"folke/tokyonight.nvim",
		optional = true,

		opts = {
			styles = {
				comments = { italic = false },
				keywords = { italic = false },
				floats = "normal",
			},

			plugins = {
				auto = true,
				bufferline = false,
			},

			on_highlights = override_highlights,
			cache = false,
		},
	},

	{
		"nvim-lualine/lualine.nvim",
		dependencies = { { "folke/tokyonight.nvim", optional = true } },
		optional = true,

		opts = function(_, opts)
			if vim.g.colors_name and vim.g.colors_name:find("tokyonight", 1, true) then
				lualine_opts_override(opts, vim.g.colors_name)
			end

			vim.api.nvim_create_autocmd("ColorScheme", {
				desc = "Setup lualine theme after colorscheme changed",
				pattern = "tokyonight*",
				callback = function(data)
					lualine_opts_override(opts, data.match)
					require("lualine").setup(opts)
				end,
			})
		end,
	},

	{
		"akinsho/bufferline.nvim",
		dependencies = { { "folke/tokyonight.nvim", optional = true } },
		optional = true,

		opts = function(_, opts)
			if vim.g.colors_name and vim.g.colors_name:find("tokyonight", 1, true) then
				opts.highlights = override_bufferline_hls(vim.g.colors_name)
			end

			vim.api.nvim_create_autocmd("ColorScheme", {
				desc = "Setup bufferline theme after colorscheme changed",
				pattern = "tokyonight*",
				callback = function(data)
					opts.highlights = override_bufferline_hls(data.match)

					require("bufferline.highlights").reset_icon_hl_cache()
					require("bufferline").setup(opts)
				end,
			})
		end,
	},
}
