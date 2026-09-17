# Настройка

> [!TIP]
> **🇬🇧 English version:** [CONFIGURATION.md](CONFIGURATION.md)

Полное руководство по настройке lazyvimx.

## 📑 Содержание

- [Быстрый старт](#🚀-быстрый-старт)
- [Функция setup](#⚙️-функция-setup)
- [Цветовые схемы](#🎨-цветовые-схемы)
- [Группы буферов](#🗂️-группы-буферов)
- [Включение экстр](#🧩-включение-экстр)
- [Опции Vim](#✍️-опции-vim)
- [Интеграции](#🔗-интеграции)
- [Продвинутая настройка](#🧠-продвинутая-настройка)

## 🚀 Быстрый старт

### Минимум

```lua
-- lua/config/lazy.lua
return {
	spec = {
		{ "lazyvimx/nvim", name = "lazyvimx", import = "lazyvimx.boot" },
	},
}
```

lazyvimx с настройками по умолчанию; все экстры доступны через `:LazyExtras`, но выключены.

### Рекомендуемый вариант

```lua
-- lua/config/lazy.lua
return {
	spec = {
		{ "lazyvimx/nvim", name = "lazyvimx", import = "lazyvimx.boot" },
		{ import = "lazyvimx.extras.core.all" }, -- всё сразу
	},
}
```

### Способы передать опции

**Способ 1 — `opts` в спеке плагина (рекомендуется):**

```lua
{
	"lazyvimx/nvim",
	name = "lazyvimx",
	import = "lazyvimx.boot",
	opts = {
		colorscheme = "catppuccin",
		bufferline_groups = {
			["React"] = "%.tsx$",
		},
	},
}
```

**Способ 2 — вызов `setup()`:**

```lua
-- lua/config/lazyvimx.lua
require("lazyvimx").setup({
	colorscheme = "catppuccin",
	bufferline_groups = {
		["React"] = "%.tsx$",
	},
})
```

Оба способа равнозначны.

## ⚙️ Функция setup

Опции глубоко сливаются с настройками по умолчанию (`vim.tbl_deep_extend`).

### Схема конфигурации

```lua
{
	-- Имя семейства цветовых схем по умолчанию
	colorscheme = "catppuccin",

	-- Семейства: для каждого — список тёмных и список светлых вариантов.
	-- Первый элемент каждого списка — вариант по умолчанию.
	colorscheme_households = {
		[household: string] = {
			{ dark_1, dark_2, ... },   -- [1] тёмные варианты
			{ light_1, light_2, ... }, -- [2] светлые варианты
		},
	},

	-- Кастомные группы буферов для bufferline
	bufferline_groups = {
		[group_name: string] = pattern, -- lua-паттерн по пути файла
	},
}
```

### Настройки по умолчанию

```lua
{
	colorscheme = "catppuccin",

	colorscheme_households = {
		catppuccin = {
			{
				"catppuccin-macchiato", "catppuccin-frappe", "catppuccin-mocha", "catppuccin",
				"catppuccin-darkroast", "catppuccin-draculatte", "catppuccin-espresso",
				"catppuccin-gruvbrew", "catppuccin-kanagato", "catppuccin-nightbrew",
				"catppuccin-nordiccino", "catppuccin-rosetto", "catppuccin-solarbica",
			},
			{ "catppuccin-latte" },
		},
		tokyonight = {
			{ "tokyonight-storm", "tokyonight-moon", "tokyonight-night" },
			{ "tokyonight-day" },
		},
		nord = {
			{ "nord" },
			{ "nord-light" },
		},
	},

	bufferline_groups = {},
}
```

Дополнительные варианты catppuccin (darkroast, nightbrew и другие) добавляет плагин
[catppuccin-barista](https://github.com/aimuzov/catppuccin-barista.nvim), который подключается
оверрайдом `overrides/other/catppuccin.lua`.

## 🎨 Цветовые схемы

### Как выбирается вариант

При старте (и по сигналу от системы) lazyvimx определяет тему ОС и берёт вариант из
семейства:

1. Тёмная система → список `[1]`, светлая → список `[2]`
2. Если включена экстра `perf.restore-last-colorscheme` и последний использованный вариант
   есть в этом списке — восстанавливается он
3. Иначе берётся первый вариант списка

Определение темы ОС: на macOS — `defaults read -g AppleInterfaceStyle`, на Linux —
`gsettings` (gtk-theme или color-scheme).

### Своё семейство

```lua
require("lazyvimx").setup({
	colorscheme = "gruvbox",
	colorscheme_households = {
		gruvbox = {
			{ "gruvbox" },       -- тёмный
			{ "gruvbox-light" }, -- светлый
		},
	},
})
```

Имена вариантов должны начинаться с имени семейства (`<household>` или `<household>-<суффикс>`) —
по этому префиксу lazyvimx понимает, к какому семейству относится текущая тема.

**Важно:** кастомизации хайлайтов lazyvimx распространяются только на Catppuccin, Tokyo Night
и Nord. Для других тем понадобятся свои оверрайды.

### Переключение вручную

```vim
:colorscheme catppuccin-latte
:colorscheme tokyonight-storm
```

### Автопереключение вслед за системой

Включается оверрайдом (входит в `core.overrides`):

```lua
{ import = "lazyvimx.overrides.lazyvim.auto-switch-colorscheme-on-signal" }
```

Оверрайд подписывается на autocmd `Signal`: чтобы Neovim переключил тему, внешний
наблюдатель за темой ОС должен послать процессу сигнал (например, SIGUSR1). Пример такого
наблюдателя для macOS — [ThemeSwitcher](https://github.com/aimuzov/dotfiles/tree/main/private_Library/ThemeSwitcher)
из dotfiles автора.

## 🗂️ Группы буферов

Группировка буферов в bufferline по lua-паттернам пути файла.

```lua
require("lazyvimx").setup({
	bufferline_groups = {
		["React"] = "%.tsx$",           -- по расширению
		["Styles"] = "%.s?css$",
		["Tests"] = "%.test%.",         -- по фрагменту имени
		["Components"] = "components/", -- по директории
	},
})
```

Помимо ваших групп всегда есть встроенные: закреплённые буферы (pinned, с иконкой ),
терминальные буферы (term) и всё остальное (ungrouped).

Группы работают через оверрайд `overrides/bufferline/add-groups.lua` (входит в
`core.overrides`).

## 🧩 Включение экстр

### Способ 1 — UI

1. `:LazyExtras`
2. Секция lazyvimx помечена иконкой 󰬟
3. `x` — включить выбранную экстру
4. Перезапустить Neovim

### Способ 2 — импорты в конфиге

```lua
-- lua/plugins/lazyvimx.lua
return {
	{ import = "lazyvimx.extras.ui.better-diagnostic" },
	{ import = "lazyvimx.extras.ui.winbar" },
	{ import = "lazyvimx.extras.motions.langmapper" },
}
```

### Способ 3 — всё сразу

```lua
{ import = "lazyvimx.extras.core.all" }
```

Или только реестр экстр, без оверрайдов и кеймапов:

```lua
{ import = "lazyvimx.extras.core.extras" }
```

Список всех экстр с описаниями — на странице [Экстры](EXTRAS.ru.md).

## ✍️ Опции Vim

lazyvimx задаёт свои опции по событию `LazyVimOptionsDefaults` (см. `boot.lua`).

### Отступы

```lua
vim.o.expandtab = false      -- табы, не пробелы
vim.o.smarttab = true
vim.o.shiftwidth = 4
vim.o.tabstop = 4
vim.o.softtabstop = 4
vim.o.autoindent = true
```

### Бэкапы и swap

```lua
vim.o.swapfile = false
vim.o.backup = true
vim.o.backupdir = "~/.local/state/nvim/backup/"
```

### Прозрачность UI

```lua
vim.o.pumblend = 15          -- меню автодополнения
vim.o.winblend = 5           -- плавающие окна
```

### Таймауты

```lua
vim.o.timeout = true
vim.o.timeoutlen = 500       -- ожидание продолжения комбинации
vim.o.ttimeoutlen = 0        -- без ожидания для кодов клавиш
```

### Прочее

```lua
vim.o.showmode = false       -- режим показывает statusline
vim.o.showbreak = "↪"        -- маркер переноса строки
vim.o.conceallevel = 2
vim.o.smoothscroll = true
vim.o.autochdir = false
vim.o.spelllang = ""
vim.o.shell = vim.fn.getenv("SHELL")
vim.opt.listchars = { eol = " ", space = " ", tab = "  " }
vim.opt.fillchars:append({ diff = " ", eob = " " })
```

### Как переопределить

Свои значения — в `lua/config/options.lua` (LazyVim выполняет его после дефолтов):

```lua
vim.o.expandtab = true
vim.o.shiftwidth = 2
vim.o.tabstop = 2
```

Либо по тому же событию:

```lua
vim.api.nvim_create_autocmd("User", {
	pattern = "LazyVimOptionsDefaults",
	callback = function()
		vim.o.expandtab = true
		vim.o.shiftwidth = 2
	end,
})
```

## 🔗 Интеграции

### Chezmoi

После `:Lazy update` оверрайд `auto-apply-chezmoi-on-lazy-update` (входит в `core.overrides`)
выполняет:

```bash
chezmoi add ~/.config/nvim/lazy-lock.json ~/.config/nvim/lazyvim.json
```

Единственное условие — установленная утилита `chezmoi`. Если она не нужна или не установлена,
ничего не происходит.

### VSCode

При запуске внутри VSCode (расширение vscode-neovim, `vim.g.vscode = true`) оверрайд
`overrides/lazyvim/vscode.lua` включается автоматически:

- индикатор режима синхронизируется со статус-баром VSCode (нужно расширение
  `neovim-ui-indicator`)
- `<leader>cr` вызывает нативное переименование VSCode
- `Snacks.terminal` заменяется на `LazyVim.terminal`
- `<leader>l` и `<leader>qq` отключены

### macOS

- **Тема ОС** — `defaults read -g AppleInterfaceStyle` (для автопереключения цветовой схемы)
- **Корзина** — удаление файлов в neo-tree идёт через утилиту `trash`, если она установлена
  (`brew install trash`); иначе — обычное удаление
- **Открытие файлов** — команда `open` в neo-tree

## 🧠 Продвинутая настройка

### Порядок загрузки

1. `boot.lua` — глобальные переменные и подписка на `LazyVimOptionsDefaults`
2. Плагины LazyVim
3. `require("lazyvimx").setup()` — слияние конфига
4. Экстры и оверрайды, которые вы импортировали
5. Ваши `lua/plugins/*.lua`

### Локальный конфиг проекта

```lua
{ import = "lazyvimx.extras.perf.local-config" }
```

Затем в корне проекта:

```lua
-- .nvim.lua или .config/nvim.lua
vim.opt_local.shiftwidth = 2
vim.opt_local.expandtab = true
```

### Условное включение экстр

```lua
return {
	{
		import = "lazyvimx.extras.ui.winbar",
		cond = function()
			return not vim.g.vscode
		end,
	},
}
```

### Переопределение кеймапов

```lua
-- lua/plugins/keys.lua
return {
	{
		"LazyVim/LazyVim",
		keys = {
			{ "<leader>\\", false }, -- выключить кеймап lazyvimx
			{ "<leader>|", "<cmd>vsplit<cr>", desc = "Vertical Split" },
		},
	},
}
```

### Выборочные оверрайды

Вместо `core.overrides` импортируйте категории по отдельности:

```lua
return {
	{ import = "lazyvimx.overrides.lazyvim" },
	{ import = "lazyvimx.overrides.snacks" },
	-- bufferline пропускаем
	{ import = "lazyvimx.overrides.other" },
}
```

### Отладка конфигурации

```vim
" Текущий конфиг lazyvimx
:lua vim.print(require("lazyvimx").config)

" Загруженные модули экстр
:lua vim.print(require("lazy.core.config").spec.modules)

" Включена ли конкретная экстра
:lua print(require("lazyvimx.util.general").has_extra("ui.winbar"))
```

## 🚑 Если что-то не работает

Типовые проблемы — экстры не видны в `:LazyExtras`, тема не переключается, группы буферов не
появляются — разобраны на странице [Решение проблем](TROUBLESHOOTING.ru.md).

## 📚 См. также

- [Экстры](EXTRAS.ru.md) — справочник экстр
- [API](API.ru.md) — утилиты
- [Архитектура](ARCHITECTURE.ru.md) — устройство
