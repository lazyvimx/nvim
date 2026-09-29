# Архитектура

> [!TIP]
> **🇬🇧 English version:** [ARCHITECTURE.md](ARCHITECTURE.md)

Как lazyvimx устроен изнутри.

## 📑 Содержание

- [Обзор](#🔭-обзор)
- [Процесс загрузки](#🚀-процесс-загрузки)
- [Система конфигурации](#⚙️-система-конфигурации)
- [Система экстр](#🧩-система-экстр)
- [Система оверрайдов](#🔧-система-оверрайдов)
- [Утилиты](#🧰-утилиты)
- [Точки интеграции](#🔗-точки-интеграции)

## 🔭 Обзор

lazyvimx — слой поверх LazyVim, а не форк: ничего в LazyVim не заменяется, все улучшения
подключаются штатным механизмом lazy.nvim (спеки, `import`, `optional`, `cond`).

### Принципы

1. **Не вмешиваться** — LazyVim работает как обычно, всё дополнительное опционально
2. **Модульность** — одна фича = один файл
3. **Расширяемость** — свои плагины и оверрайды подключаются рядом
4. **Лёгкость** — ленивые загрузки, условная активация
5. **Дружба с окружением** — chezmoi, VSCode, системная тема

### Три вида модулей

| Вид           | Где                       | Что это                                                     |
| ------------- | ------------------------- | ----------------------------------------------------------- |
| **Экстры**    | `lua/lazyvimx/extras/`    | Опциональные фичи; включаются явно (`:LazyExtras` / import) |
| **Оверрайды** | `lua/lazyvimx/overrides/` | Правки настроек существующих плагинов; включаются наборами  |
| **Утилиты**   | `lua/lazyvimx/util/`      | Общие функции для экстр, оверрайдов и пользовательских конфигов |

## 🚀 Процесс загрузки

### Защита от прямого запуска

`init.lua` в корне репозитория не настраивает ничего — только предупреждает, если репозиторий
по ошибке используется как самостоятельный конфиг Neovim.

### boot.lua

Точка входа — `{ "lazyvimx/nvim", name = "lazyvimx", import = "lazyvimx.boot" }`. Модуль возвращает
последовательность спеков:

```lua
return {
	{ import = "system.plug", enabled = set_global },            -- 1
	{ import = "system.plug", enabled = vimopts_create_autocmd }, -- 2

	{ "LazyVim/LazyVim", branch = "main" },                       -- 3
	{ "LazyVim/LazyVim", opts = update_root_lsp_ignore },         -- 4
	{ "LazyVim/LazyVim", opts = insert_extras },                  -- 5
	{ "LazyVim/LazyVim", import = "lazyvim.plugins" },            -- 6
	{ "LazyVim/LazyVim", opts = set_colorscheme },                -- 7

	{ "lazyvimx/nvim", name = "lazyvimx", dependencies = { "LazyVim/LazyVim" }, vscode = true, config = true }, -- 8

	{ import = "plugins", enabled = has_plugins_dir },            -- 9
}
```

Спеки `system.plug` — трюк: несуществующий плагин с функцией в `enabled` выполняет побочный
эффект на этапе разбора спеков, до загрузки чего-либо.

1. **Глобальные переменные**: `lazyvim_check_order = false`, `xtras_prios = {}`,
   `lazyvim_explorer = "neo-tree"`
2. **Опции Vim**: подписка на `LazyVimOptionsDefaults` — значения применятся, когда LazyVim
   выставит свои дефолты (отступы табами по 4, `backup` вместо swap, `winblend`/`pumblend`,
   таймауты и т.д.)
3. LazyVim закрепляется на ветке `main`
4. `eslint` добавляется в `root_lsp_ignore` (не влияет на определение корня проекта)
5. **Регистрация экстр**: секция lazyvimx (иконка 󰬟) появляется в `:LazyExtras`
6. Загружаются плагины LazyVim
7. **Цветовая схема**: выбирается вариант под текущую тему системы (`get_flavor()`)
8. Сам lazyvimx: `config = true` вызывает `require("lazyvimx").setup(opts)` с опциями из спека
9. Пользовательские `lua/plugins/*.lua`, если директория непустая

## ⚙️ Система конфигурации

### Поток данных

1. Дефолты объявлены в `lua/lazyvimx/init.lua`
2. Пользовательские опции приходят из `opts` спека (или прямого вызова `setup()`)
3. `vim.tbl_deep_extend("force", defaults, opts)` — глубокое слияние
4. Результат доступен всем модулям: `require("lazyvimx").config`

### Опции

- `colorscheme` — семейство цветовых схем по умолчанию
- `colorscheme_households` — семейства: списки тёмных и светлых вариантов
- `bufferline_groups` — пользовательские группы буферов

Формат и значения по умолчанию — на странице [Настройка](CONFIGURATION.ru.md#⚙️-функция-setup).

### Выбор варианта цветовой схемы

`util/general.lua`, функция `get_flavor()`:

```lua
function M.get_flavor(colorscheme_household_last)
	local config = require("lazyvimx").config
	local flavor_index = M.theme_is_dark() and 1 or 2 -- [1] тёмные, [2] светлые

	-- если есть last-color.nvim — пробуем восстановить последний вариант
	-- (только внутри списка, соответствующего текущей теме системы)

	local flavor_list = config.colorscheme_households[colorscheme_household_last or config.colorscheme]
	return flavor_list[flavor_index][1]
end
```

Семейство определяется по префиксу имени темы до первого дефиса: `catppuccin-latte` →
`catppuccin`, `nord-light` → `nord`.

## 🧩 Система экстр

### Структура

```
extras/
├── core/          # Сборные модули (5): all, colorschemes, extras, keys, overrides
├── ui/            # Интерфейс (22)
├── motions/       # Навигация (6)
├── buf/           # Буферы (4)
├── git/           # Git (4)
├── lang/          # Языки (4)
├── perf/          # Производительность (4)
├── coding/        # Инструменты кода (2)
├── linting/       # Линтеры (2)
├── colorschemes/  # Цветовые схемы (1)
├── dap/           # Отладка (1)
└── test/          # Тестирование (1)
```

51 функциональная экстра; описания — на странице [Экстры](EXTRAS.ru.md).

### Шаблон экстры

Каждая экстра — модуль, возвращающий спек lazy.nvim. Поле `desc` показывается в
`:LazyExtras`:

```lua
return {
	"author/plugin.nvim",
	desc = "Что делает экстра",
	opts = { ... },
}
```

### Сборные модули core

- `core.all` — импортирует остальные четыре плюс уведомление о рекомендуемых экстрах LazyVim
- `core.extras` — реестр всех функциональных экстр (49 импортов; `ui.better-progressbar` — с
  условием `TERM=xterm-ghostty`)
- `core.overrides` — все 4 категории оверрайдов
- `core.colorschemes` — дополнительные цветовые схемы
- `core.keys` — кеймапы, привязанные к плагинам (`optional = true`: нет плагина — нет кеймапа)

### Условная активация

Экстры с внешними зависимостями активируются через `cond` и предупреждают через
`warn_missing_extra()`:

```lua
-- dap/vscode-js.lua
cond = function()
	return not vim.g.vscode and LazyVim.has_extra("dap.core")
end
```

Некоторые модули отключают себя целиком: `ui.simple-mode` и VSCode-оверрайд возвращают `{}`
если условие не выполнено.

## 🔧 Система оверрайдов

Оверрайды меняют настройки существующих плагинов, не заменяя их. Все спеки —
`optional = true`: если плагина нет, оверрайд не делает ничего.

### Структура

```
overrides/
├── lazyvim/     # LazyVim (9): язык-специфика (clangd, oxc, svelte), chezmoi,
│                #   автопереключение темы, VSCode, pretty path, контекстное меню
├── snacks/      # Snacks.nvim (9): дашборд, lazygit (тема, follow worktree),
│                #   отключение анимаций и backdrop, повторяемое удаление буферов
├── bufferline/  # Bufferline (6): группы, повторяемое перемещение, стиль табов
└── other/       # Прочие (15): avante, blink, catppuccin, dap-ui, edgy, flash, gitsigns,
                 #   lazy, lspconfig, lualine, neo-tree, noice, sidekick, tokyonight, trouble
```

Итого 39 модулей. Категория импортируется целиком — lazy.nvim подхватывает все `.lua`-файлы
директории:

```lua
{ import = "lazyvimx.overrides.snacks" }
```

### Типовые приёмы

**Расширение opts** — самый частый:

```lua
return {
	"plugin/name",
	optional = true,
	opts = { option = value },
}
```

**Подмена функции** — когда опций недостаточно:

```lua
-- overrides/lazyvim/lualine-pretty-path.lua
opts = function()
	LazyVim.lualine.pretty_path = function(opts) --[[ своя реализация ]] end
end
```

**Autocmd** — реакция на события:

```lua
-- overrides/lazyvim/auto-switch-colorscheme-on-signal.lua
vim.api.nvim_create_autocmd("Signal", {
	callback = vim.schedule_wrap(colorscheme_update),
})
```

**Обёртка** — модификация поведения с сохранением оригинала:

```lua
-- extras/motions/langmapper.lua
local normkey_orig = Snacks.util.normkey
Snacks.util.normkey = function(key)
	return normkey_orig(translate_key(key, "default", "ru"))
end
```

## 🧰 Утилиты

### util/general.lua

Смешивание цветов, определение темы системы, выбор варианта цветовой схемы, проверка экстр.
Полный справочник — на странице [API](API.ru.md#🧰-utilgeneral).

### util/layout.lua

Единый источник размеров панелей (левая — 40, правая — 80, верх/низ — 10, шаг ресайза — 3).
Использует edgy (размеры и кеймапы ресайза) и diffview (панели файлов и истории) — поэтому
сайдбары согласованы между собой. Справочник — на странице [API](API.ru.md#🪟-utillayout).

## 🔗 Точки интеграции

### LazyVim

- регистрация экстр в `:LazyExtras`
- использование `LazyVim.*`-утилит (`has_extra`, `root`, `lualine.pretty_path`, `pick`)
- расширение опций LazyVim через спеки

### lazy.nvim

- всё подключается спеками и `import`
- `optional = true` — деградация без ошибок
- `cond` / `enabled` — условная загрузка

### Внешние инструменты

- **chezmoi** — `chezmoi add` лок-файлов после `:Lazy update`
- **VSCode** — режим для vscode-neovim (индикатор режима, адаптированные кеймапы)
- **Система** — тема ОС (macOS `defaults` / Linux `gsettings`), сигналы для переключения
  темы, `trash` и `open` в neo-tree

## ⚡ Производительность

- экстры не включены — кода не существует: реестр это только `import`-список
- почти все плагины ленивые: события (`VeryLazy`, `BufReadPre`), команды, кеймапы
- `perf.*`-экстры добавляют уборку: остановка неактивных LSP, закрытие старых буферов

## 🧱 Как расширять

### Своя экстра

Файл в подходящей категории:

```lua
-- lua/lazyvimx/extras/<категория>/<имя>.lua
return {
	"author/plugin.nvim",
	desc = "Описание для :LazyExtras",
	opts = { ... },
}
```

И строка в реестре `extras/core/extras.lua`:

```lua
{ import = "lazyvimx.extras.<категория>.<имя>" },
```

### Свой оверрайд

Файл в категории `overrides/` — подхватится при импорте категории автоматически:

```lua
-- lua/lazyvimx/overrides/other/my-override.lua
return {
	"plugin/name",
	optional = true,
	opts = { ... },
}
```

## 🐞 Отладка

```vim
" Загруженные модули спеков
:lua vim.print(require("lazy.core.config").spec.modules)

" Текущий конфиг lazyvimx
:lua vim.print(require("lazyvimx").config)

" Профилирование загрузки
:Lazy profile
```
