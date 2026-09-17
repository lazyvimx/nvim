-- Конфиг Neovim для записи демо-гифок. Живёт в изолированном XDG-профиле
-- (см. запись в тейпах), а lazyvimx берёт из рабочей копии репозитория —
-- гифки показывают текущий код, а не то, что лежит на GitHub.

-- docs/demo/profile/config/nvim/init.lua -> корень репозитория
local repo_root = vim.fs.normalize(vim.fn.fnamemodify(debug.getinfo(1, "S").source:sub(2), ":p:h") .. "/../../../../..")

-- Набор экстр задаёт тейп через DEMO_EXTRAS; сами импорты лежат
-- в lua/plugins/demo.lua — см. комментарий там про порядок загрузки.
local lazy_opts = {
	spec = { { "lazyvimx/nvim", name = "lazyvimx", dir = repo_root, import = "lazyvimx.boot" } },

	-- Установку делает warmup.sh в headless: на камере окно установки
	-- lazy.nvim не должно появляться никогда.
	install = { missing = false, colorscheme = { "catppuccin", "tokyonight" } },
	checker = { enabled = false },
	change_detection = { enabled = false },

	ui = {
		backdrop = 100,
		border = "rounded",
		icons = { keys = "󰥻" },
	},
}

local lazy_path = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
local lazy_url = "https://github.com/folke/lazy.nvim.git"

if not vim.loop.fs_stat(lazy_path) then
	vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazy_url, lazy_path })
end

vim.opt.rtp:prepend(lazy_path)

require("lazy").setup(lazy_opts)
