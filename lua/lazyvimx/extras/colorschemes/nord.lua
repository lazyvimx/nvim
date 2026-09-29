local blend = require("lazyvimx.util.general").color_blend

function flatten_palette(p)
	return {
		bg = p.polar_night.origin,
		bg_darkness = blend(p.polar_night.origin, "#000000", 22),
		bg_dark = blend(p.polar_night.origin, "#000000", 18),
		bg_bright = p.polar_night.bright,
		bg_brighter = p.polar_night.brighter,
		bg_brightest = p.polar_night.brightest,
		bg_light = p.polar_night.light,

		fg = p.snow_storm.origin,
		fg_brighter = p.snow_storm.brighter,
		fg_brightest = p.snow_storm.brightest,

		teal = p.frost.polar_water,
		cyan = p.frost.ice,
		blue = p.frost.artic_water,
		blue_dark = p.frost.artic_ocean,

		red = p.aurora.red,
		orange = p.aurora.orange,
		yellow = p.aurora.yellow,
		green = p.aurora.green,
		purple = p.aurora.purple,
	}
end

local override_highlights = function(hl, colors)
	local c = flatten_palette(colors)

	hl.BlinkCmpDoc = { bg = c.bg_bright, blend = 15 }
	hl.BlinkCmpDocBorder = { link = "BlinkCmpDoc" }
	hl.BlinkCmpDocSeparator = { fg = blend(c.bg_bright, c.fg, 10) }
	hl.BlinkCmpMenu = { link = "Pmenu" }
	hl.BlinkCmpMenuSelection = { bg = blend(c.bg_bright, c.fg, 10) }
	hl.BlinkCmpScrollBarGutter = { bg = blend(c.bg_bright, c.fg, 15) }
	hl.BlinkCmpScrollBarThumb = { bg = blend(c.bg_bright, c.fg, 25) }
	hl.BufferLineCustomGroupLabel = { bg = c.bg_dark, fg = c.fg }
	hl.BufferLineCustomGroupSep = { bg = c.bg_dark, fg = c.blue }
	hl.CursorLine = { bg = blend(c.bg, c.blue, 10) }
	hl.EdgyTitle = { bg = c.bg_bright, fg = c.bg_bright }
	hl.FlashBackdrop = { fg = blend(c.bg, c.blue, 15) }
	hl.FlashPrompt = { bg = c.bg_darkness }
	hl.FlashPromptSep = { fg = blend(c.bg_dark, c.fg, 50) }
	hl.FloatBorder = { fg = blend(c.bg, c.cyan, 50) }
	hl.FloatTitle = { fg = blend(c.bg, c.cyan, 50) }
	hl.InlineFold = { fg = c.blue, bold = true }
	hl.LspReferenceRead = { bg = "none", fg = blend(c.fg, c.purple, 50), bold = true }
	hl.LspReferenceText = { bg = "none", fg = blend(c.fg, c.purple, 50), bold = true }
	hl.LspReferenceWrite = { bg = "none", fg = blend(c.fg, c.purple, 50), bold = true }
	hl.NeoTreeCursorLine = { bg = blend(c.bg_dark, c.blue_dark, 15) }
	hl.NeoTreeFloatBorder = { link = "FloatBorder" }
	hl.NeoTreeFloatNormal = { link = "NormalFloat" }
	hl.NeoTreeFloatTitle = { link = "FloatTitle" }
	hl.NeoTreeIndentMarker = { fg = blend(c.bg_dark, c.fg, 10) }
	hl.NeoTreeNormal = { bg = c.bg_dark }
	hl.NeoTreeNormalActive = { bg = blend(c.bg_dark, c.bg, 30) }
	hl.NeoTreeNormalNC = { bg = c.bg_dark }
	hl.NeoTreeTabActive = { fg = c.fg, bg = blend(c.bg, c.blue, 15) }
	hl.NeoTreeTabInactive = { fg = c.fg, bg = c.bg }
	hl.NeoTreeTabSeparatorActive = { bg = blend(c.bg, c.blue, 15), fg = c.bg }
	hl.NeoTreeTabSeparatorInactive = { bg = c.bg, fg = c.bg }
	hl.NeoTreeWinSeparator = { bg = c.bg, fg = c.bg }
	hl.ScrollView = { bg = blend(c.bg, c.fg, 10), blend = 15 }
	hl.SnacksDashboardBorder = { fg = blend(c.bg, c.bg_brightest, 50) }
	hl.SnacksDashboardDesc = { fg = c.fg }
	hl.SnacksDashboardFooter = { fg = c.bg_light }
	hl.SnacksDashboardHeader1 = { fg = c.bg_light }
	hl.SnacksDashboardHeader2 = { fg = blend(c.bg, c.blue_dark, 50) }
	hl.SnacksDashboardHeader3 = { fg = blend(c.bg, c.blue, 50) }
	hl.SnacksDashboardHeader4 = { fg = blend(c.bg, c.cyan, 50) }
	hl.SnacksDashboardHeader5 = { fg = blend(c.bg, c.teal, 50) }
	hl.SnacksDashboardHeader6 = { fg = blend(c.bg, c.cyan, 50) }
	hl.SnacksDashboardHeader7 = { fg = blend(c.bg, c.blue, 50) }
	hl.SnacksDashboardHeader8 = { fg = c.bg_light }
	hl.SnacksDashboardIcon = { fg = c.yellow }
	hl.SnacksDashboardKey = { bg = c.bg, fg = c.orange }
	hl.SnacksDashboardKeyBorder = { bg = c.bg, fg = blend(c.bg, c.bg_brightest, 50) }
	hl.SnacksDashboardSpecial = { fg = blend(c.bg, c.purple, 50) }
	hl.SnacksIndent = { fg = blend(c.bg, c.fg, 5) }
	hl.SnacksIndentScope = { fg = blend(c.bg, c.fg, 15) }
	hl.SnacksPickerBoxTitle = { link = "FloatBorder" }
	hl.SnacksPickerInputBorder = { fg = blend(c.bg, c.cyan, 25) }
	hl.SnacksPickerInputCursorLine = { bg = c.bg }
	hl.NoiceFormatEvent = { fg = c.bg_light }
	hl.NoiceFormatKind = { fg = c.bg_brightest }
	hl.NoiceLspProgressTitle = { fg = c.bg_light }
	hl.StatusLine = { bg = c.bg_dark }
	hl.SymbolUsageContent = { fg = blend(c.bg_brightest, c.fg, 10) }
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
	hl.VisualWhitespace = { bg = blend(c.bg, c.blue, 10), fg = c.bg_brightest }
	hl.WhichKeyBorder = { link = "FloatBorder" }
	hl.WhichKeyNormal = { link = "NormalFloat" }
	hl.WinSeparator = { fg = c.bg_dark }
end

local override_bufferline_hls = function()
	local c = flatten_palette(require("nord.colors").palette)

	return function()
		local hls = {
			background = { bg = c.bg_dark },
			buffer_visible = { fg = c.bg_light, italic = false },
			fill = { bg = c.bg_dark },
			modified_visible = { fg = c.orange },
			offset_separator = { bg = c.bg_dark },
			tab_close = { bg = c.bg_dark },
			diagnostic = { bg = c.bg_dark },
			separator = { bg = c.bg_dark, fg = c.bg_dark },
			group_separator = { bg = c.bg_dark, fg = c.bg_dark },
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

			hls[key].italic = false

			local key_selected = key .. "_selected"
			local key_visible = key .. "_visible"

			if hls[key_selected] == nil then
				hls[key_selected] = {}
			end

			if hls[key_visible] == nil then
				hls[key_visible] = {}
			end

			hls[key_selected].bg = c.bg
			hls[key_selected].italic = false
			hls[key_visible].bg = c.bg_dark
			hls[key_visible].italic = false
		end

		return hls
	end
end

local lualine_theme_create = function(c)
	local colors = {
		["normal"] = c.blue,
		["insert"] = c.green,
		["visual"] = c.purple,
		["replace"] = c.red,
		["command"] = c.yellow,
		["terminal"] = c.teal,
		["inactive"] = c.bg_dark,
	}

	local theme = {}

	for mode, color in pairs(colors) do
		theme[mode] = {
			a = { bg = blend(c.bg_dark, color, 70), fg = c.bg_dark },
			b = { bg = blend(c.bg_dark, color, 15), fg = color },
			c = { bg = c.bg_dark, fg = mode == "inactive" and c.bg_light or c.fg },
			x = { bg = c.bg_dark, fg = c.bg_light },
		}
	end

	return theme
end

local lualine_opts_override = function(opts)
	local c = flatten_palette(require("nord.colors").palette)

	opts.options.theme = lualine_theme_create(c)

	for _, wb in pairs({ opts.inactive_winbar, opts.winbar }) do
		for _, section in pairs(wb.lualine_c) do
			section.color.bg = c.bg
		end
	end
end

return {
	"gbprod/nord.nvim",
	desc = "Nord colorscheme with custom highlight overrides for UI plugins",

	opts = {
		styles = {
			comments = { italic = false },
			keywords = { italic = false },
			bufferline = {
				current = {},
				modified = { italic = false },
			},
		},

		on_highlights = override_highlights,
	},

	specs = {
		{
			"nvim-lualine/lualine.nvim",
			dependencies = { { "gbprod/nord.nvim", optional = true } },
			optional = true,

			opts = function(_, opts)
				if vim.g.colors_name and vim.g.colors_name:find("nord", 1, true) then
					lualine_opts_override(opts)
				end

				vim.api.nvim_create_autocmd("ColorScheme", {
					desc = "Setup lualine theme after colorscheme changed",
					pattern = "nord*",
					callback = function()
						lualine_opts_override(opts)
						require("lualine").setup(opts)
					end,
				})
			end,
		},

		{
			"akinsho/bufferline.nvim",
			dependencies = { { "gbprod/nord.nvim", optional = true } },
			optional = true,

			opts = function(_, opts)
				if vim.g.colors_name and vim.g.colors_name:find("nord", 1, true) then
					opts.highlights = override_bufferline_hls()
				end

				vim.api.nvim_create_autocmd("ColorScheme", {
					desc = "Setup bufferline theme after colorscheme changed",
					pattern = "nord*",
					callback = function()
						opts.highlights = override_bufferline_hls()

						require("bufferline.highlights").reset_icon_hl_cache()
						require("bufferline").setup(opts)
					end,
				})
			end,
		},
	},
}
