# Справочник API

> [!TIP]
> **🇬🇧 English version:** [API.md](API.md)

Утилиты и модули lazyvimx, которые можно использовать в своей конфигурации.

## 📑 Содержание

- [Главный модуль](#📦-главный-модуль)
- [util.general](#🧰-utilgeneral)
- [util.layout](#🪟-utillayout)
- [boot.lua](#🚀-bootlua)

---

## 📦 Главный модуль

**Модуль:** `lazyvimx` (`lua/lazyvimx/init.lua`)

### `setup(opts)`

Слить пользовательские опции с настройками по умолчанию.

```lua
require("lazyvimx").setup({
	colorscheme = "tokyonight",
	bufferline_groups = {
		["React"] = "%.tsx$",
	},
})
```

Схема опций и значения по умолчанию — в
[Настройка](CONFIGURATION.ru.md#⚙️-функция-setup). Обычно вызывать `setup()` вручную не
нужно: опции из спека плагина `"lazyvimx"` попадают сюда сами (в `boot.lua` у спека
стоит `config = true`).

### `config`

Текущая конфигурация (после слияния).

```lua
local config = require("lazyvimx").config
print(config.colorscheme) -- "catppuccin"
```

---

## 🧰 util.general

**Модуль:** `lazyvimx.util.general` (`lua/lazyvimx/util/general.lua`)

### `color_blend(color_first, color_second, percentage)`

Смешать два hex-цвета в заданной пропорции.

```lua
function M.color_blend(color_first: string, color_second: string, percentage: number): string
```

- `color_first`, `color_second` — цвета вида `"#RRGGBB"`
- `percentage` — доля второго цвета, 0–100

```lua
local util = require("lazyvimx.util.general")

util.color_blend("#FF0000", "#0000FF", 50) -- "#7F007F"
util.color_blend("#FF0000", "#FFFFFF", 25) -- чуть светлее красного
```

Основной инструмент кастомизации хайлайтов — активно используется в оверрайдах тем.

### `popen_get_result(cmd)`

Выполнить shell-команду и вернуть вывод одной строкой (без хвостовых пробелов и переводов
строк). При ошибке — пустая строка.

```lua
function M.popen_get_result(cmd: string): string
```

```lua
util.popen_get_result("echo hello") -- "hello"
```

### `theme_is_dark()`

Тёмная ли тема у системы.

```lua
function M.theme_is_dark(): boolean
```

- **macOS:** `defaults read -g AppleInterfaceStyle`
- **Linux:** `gsettings get org.gnome.desktop.interface gtk-theme`, при недоступности —
  `color-scheme`

### `get_flavor(colorscheme_household_last?)`

Вариант цветовой схемы под текущую тему системы.

```lua
function M.get_flavor(colorscheme_household_last?: string): string
```

- `colorscheme_household_last` — имя семейства; по умолчанию `config.colorscheme`

**Логика:**

1. `theme_is_dark()` выбирает список: `[1]` — тёмные, `[2]` — светлые
2. Если установлен `last-color.nvim` (экстра `perf.restore-last-colorscheme`) и последний
   использованный вариант есть в этом списке — возвращается он
3. Иначе — первый вариант списка

```lua
-- В тёмном режиме с настройками по умолчанию:
util.get_flavor("catppuccin") -- "catppuccin-macchiato"
```

### `get_dotfiles_path()`

Значение переменной окружения `DOTFILES_SRC_PATH` или пустая строка. Утилита для
пользовательских конфигов; сам lazyvimx её сейчас не использует.

```lua
function M.get_dotfiles_path(): string
```

### `has_extra(extra)`

Включена ли экстра lazyvimx.

```lua
function M.has_extra(extra: string): boolean
```

- `extra` — имя без префикса: `"ui.winbar"`, `"git.gitlab"`

Проверяет и загруженные модули lazy.nvim, и список экстр в `lazyvim.json`.

```lua
if util.has_extra("ui.winbar") then
	-- настроить интеграцию
end
```

Для экстр самого LazyVim есть аналог — `LazyVim.has_extra("ui.edgy")`.

### `warn_missing_extra(extra_name)`

Фабрика коллбэка: показать предупреждение, если экстра не включена. Используется в экстрах с
зависимостями (например, `git.gitlab` предупреждает про `ui.diff-view`).

```lua
function M.warn_missing_extra(extra_name: string): function
```

```lua
{
	"folke/snacks.nvim",
	opts = require("lazyvimx.util.general").warn_missing_extra("ui.diff-view"),
}
```

---

## 🪟 util.layout

**Модуль:** `lazyvimx.util.layout` (`lua/lazyvimx/util/layout.lua`)

Единые размеры сайдбаров и панелей: edgy, diffview и другие плагины берут размеры отсюда,
поэтому панели согласованы, а ресайз одной запоминается для всех.

**Внутреннее состояние:**

```lua
local size = {
	left = 40,
	right = 80,
	top = 10,
	bottom = 10,
}

M.step = 3 -- шаг ресайза
```

### `get_size(pos)`

Текущий размер позиции.

```lua
function M.get_size(pos: "left"|"right"|"top"|"bottom"): number
```

```lua
local layout = require("lazyvimx.util.layout")

layout.get_size("left")   -- 40
layout.get_size("bottom") -- 10
```

### `get_size_create(pos)`

То же, но возвращает функцию — для плагинов, которые принимают размер-коллбэк (edgy):

```lua
{
	"folke/edgy.nvim",
	opts = {
		left = { size = layout.get_size_create("left") },
	},
}
```

### `increase_create(dir)` / `decrease_create(dir)`

Фабрики функций ресайза edgy-окна на `M.step` с запоминанием нового размера.

```lua
function M.increase_create(dir: "width"|"height"): function
function M.decrease_create(dir: "width"|"height"): function
```

Так устроены кеймапы `<C-Up>` / `<C-Down>` / `<C-Left>` / `<C-Right>` в `core.keys`:

```lua
opts.keys = {
	["<c-Up>"] = layout.increase_create("height"),
	["<c-Down>"] = layout.decrease_create("height"),
	["<c-Left>"] = layout.decrease_create("width"),
	["<c-Right>"] = layout.increase_create("width"),
}
```

---

## 🚀 boot.lua

**Модуль:** `lazyvimx.boot` (`lua/lazyvimx/boot.lua`)

Точка входа: `{ "lazyvimx/nvim", name = "lazyvimx", import = "lazyvimx.boot" }`. Внутренние функции, напрямую
не вызываются:

| Функция                    | Что делает                                                                                    |
| -------------------------- | --------------------------------------------------------------------------------------------- |
| `set_global()`             | `vim.g.lazyvim_check_order = false`, `vim.g.xtras_prios = {}`, `vim.g.lazyvim_explorer = "neo-tree"` |
| `vimopts_create_autocmd()` | подписка на `LazyVimOptionsDefaults` для установки опций Vim                                  |
| `update_root_lsp_ignore()` | добавляет `eslint` в `vim.g.root_lsp_ignore`                                                  |
| `insert_extras()`          | регистрирует источник экстр lazyvimx (иконка 󰬟) в UI `:LazyExtras`                            |
| `set_colorscheme()`        | ставит цветовую схему через `get_flavor()`                                                         |
| `has_plugins_dir()`        | подключает `lua/plugins/*.lua` пользователя, если они есть                                    |

Порядок спеков в `boot.lua` и bootstrap-процесс описаны в
[Архитектура](ARCHITECTURE.ru.md#🚀-процесс-загрузки).

---

## 📋 Сводка

| Модуль         | Функции                                                                                                             | Назначение          |
| -------------- | ------------------------------------------------------------------------------------------------------------------- | ------------------- |
| `lazyvimx`     | `setup()`, `config`                                                                                                 | Конфигурация        |
| `util.general` | `color_blend()`, `popen_get_result()`, `theme_is_dark()`, `get_flavor()`, `get_dotfiles_path()`, `has_extra()`, `warn_missing_extra()` | Общие утилиты       |
| `util.layout`  | `get_size()`, `get_size_create()`, `increase_create()`, `decrease_create()`, `step`                                  | Размеры панелей     |

## 📚 См. также

- [Настройка](CONFIGURATION.ru.md) — настройка
- [Архитектура](ARCHITECTURE.ru.md) — устройство
- [Экстры](EXTRAS.ru.md) — справочник экстр
