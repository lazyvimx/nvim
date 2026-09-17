![lazyvimx](https://raw.githubusercontent.com/lazyvimx/nvim/assets/banner.jpeg)

<div align="center">

[![Релиз](https://img.shields.io/github/v/release/lazyvimx/nvim?style=flat-square&label=релиз)](https://github.com/lazyvimx/nvim/releases)
[![Лицензия](https://img.shields.io/github/license/lazyvimx/nvim?style=flat-square&label=лицензия)](https://github.com/lazyvimx/nvim/blob/main/LICENSE)
[![Звёзды](https://img.shields.io/github/stars/lazyvimx/nvim?style=flat-square&label=звёзды)](https://github.com/lazyvimx/nvim/stargazers)
![Neovim](https://img.shields.io/badge/Neovim-0.10+-green?style=flat-square)
![Extras](https://img.shields.io/badge/экстры-50-purple?style=flat-square)

## [📖 Документация: lazyvimx.aimuzov.online](https://lazyvimx.aimuzov.online/ru/)

</div>

> [!TIP]
> **🇬🇧 English version:** [README.md](README.md)

**Слой улучшений поверх [LazyVim](https://github.com/LazyVim/LazyVim): 50 опциональных экстр и
39 оверрайдов плагинов.**

Идея простая: LazyVim остаётся как есть, а всё остальное — доводка интерфейса, навигация,
git-воркфлоу, поддержка русской раскладки — включается по кусочкам. Не нравится экстра — не
включаете, и её будто нет.

## 📑 Содержание

- [Возможности](#✨-возможности) · [Установка](#📦-установка) · [Структура](#🗂️-структура-проекта) · [Core-модули](#🎯-core-модули)
- [Документация](#📚-документация) · [Заметные экстры](#🎨-заметные-экстры) · [Кеймапы](#⌨️-кеймапы) · [Конфигурация](#🔧-конфигурация)
- [Интеграции](#🤝-интеграции) · [Философия](#🌟-философия) · [Статистика](#📊-статистика) · [Ссылки](#🔗-ссылки)

## ✨ Возможности

### 🎨 Интерфейс

- **Глубокая кастомизация тем** — Catppuccin, Tokyo Night и Nord
- **Автопереключение светлой/тёмной темы** вслед за системной ([macOS](https://github.com/aimuzov/dotfiles/tree/main/private_Library/ThemeSwitcher))
- **Единый стиль UI** — скруглённые рамки, согласованные размеры окон, кастомные иконки
- **Улучшенный дашборд** с ASCII-артом и анимацией
- **Счётчики использований символов** прямо в коде, как в JetBrains IDE
- **Диагностика одной строкой** у курсора

### 🚀 Продуктивность

- **Умные буферы** — группы в bufferline, автоочистка, изоляция по табам
- **Навигация по синтаксическому дереву** — перемещение и перестановка узлов
- **Движения по подсловам** — `w`/`e`/`b` понимают camelCase
- **Git-воркфлоу** — ревью GitLab MR из редактора, разрешение конфликтов, просмотр удалённых репозиториев
- **Отладка JS/TS** через js-debug-adapter

### ⚙️ Удобства

- **Русская раскладка** через langmapper — без переключения на английскую
- **Безопасная работа с sshfs-маунтами** — запись «на месте», без побитых прав и симлинков
- **Автосинхронизация в chezmoi** при обновлениях плагинов
- **Локальные конфиги проектов** (`.nvim.lua`)
- **Режим VSCode** для гибридного воркфлоу
- **Автообновление пакетов Mason**

## 📦 Установка

### Требования

- Neovim >= 0.10.0
- Lua 5.1 или LuaJIT в `PATH` (`brew install luajit`) — нужно экстре
  `motions.better-move-between-words`: [luarocks.nvim](https://github.com/vhyrro/luarocks.nvim)
  собирает рок `luautf8` для движений по не-ASCII подсловам и без системного Lua падает

### 🚀 Выберите свой вариант

**Впервые здесь?** В [examples/](examples/) лежат готовые конфигурации:

- **[Minimal](examples/minimal/)** — только оверрайды, самый быстрый старт
- **[Full-Featured](examples/full-featured/)** — все 50 экстр
- **[VSCode User](examples/vscode-user/)** — для расширения VSCode Neovim
- **[Russian Keyboard](examples/russian-keyboard/)** — с поддержкой русской раскладки

### Быстрый старт

> **💡 Живой пример**: [конфигурация автора](https://github.com/aimuzov/dotfiles/blob/main/dot_config/nvim/init.lua).

1. **Создайте `~/.config/nvim/init.lua`:**

```lua
local lazy_opts = {
	spec = { { "lazyvimx/nvim", name = "lazyvimx", import = "lazyvimx.boot" } },

	install = { colorscheme = { "catppuccin", "tokyonight" } },
	checker = { enabled = true, notify = false },
	change_detection = { enabled = false },
	diff = { cmd = "diffview.nvim" },

	ui = {
		backdrop = 100,
		border = "rounded",
		icons = { keys = "󰥻" },
	},
}

-- Bootstrap lazy.nvim
local lazy_path = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
local lazy_url = "https://github.com/folke/lazy.nvim.git"

if not vim.loop.fs_stat(lazy_path) then
	vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazy_url, lazy_path })
end

vim.opt.rtp:prepend(lazy_path)

require("lazy").setup(lazy_opts)
```

2. **Запустите Neovim:**

```bash
nvim
```

На первом запуске lazyvimx сам установит LazyVim и все нужные плагины.

3. **Настройте lazyvimx (по желанию):**

**Вариант А** — `opts` прямо в `init.lua`:

```lua
local lazy_opts = {
  spec = {
    {
      "lazyvimx/nvim",
      name = "lazyvimx",
      import = "lazyvimx.boot",
      opts = {
        colorscheme = "catppuccin",
        bufferline_groups = {
          -- ["имя группы"] = "lua-паттерн",
        },
      },
    },
  },
  -- ... остальные настройки
}
```

**Вариант Б** — отдельный файл `~/.config/nvim/lua/plugins/lazyvimx.lua`:

```lua
return {
  "lazyvimx/nvim",
  name = "lazyvimx",
  opts = {
    colorscheme = "catppuccin",
    bufferline_groups = {
      -- ["имя группы"] = "lua-паттерн",
    },
  },
}
```

Все опции, включая настройку светлых/тёмных вариантов тем (`colorscheme_households`), — в
[Настройка](docs/CONFIGURATION.ru.md).

4. **Включите экстры:**

Через UI `:LazyExtras` (рекомендуется) или импортами в конфиге:

```lua
-- lua/plugins/extras.lua
return {
  -- Все оверрайды плагинов
  { import = "lazyvimx.extras.core.overrides" },
  -- Дальше — что нужно
  { import = "lazyvimx.extras.ui.better-diagnostic" },
  { import = "lazyvimx.extras.motions.langmapper" },
}
```

## 🗂️ Структура проекта

```
lazyvimx/
├── lua/lazyvimx/
│   ├── boot.lua              # Bootstrap-конфигурация
│   ├── init.lua              # Главный модуль с setup()
│   ├── extras/               # Опциональные модули (50 + 5 core)
│   │   ├── core/             # Сборные модули: all, overrides, extras, keys, colorschemes
│   │   ├── ui/               # Интерфейс (21)
│   │   ├── motions/          # Навигация (6)
│   │   ├── buf/              # Буферы (4)
│   │   ├── git/              # Git (4)
│   │   ├── lang/             # Языки (4)
│   │   ├── perf/             # Производительность (4)
│   │   ├── coding/           # Инструменты кода (2)
│   │   ├── linting/          # Линтеры (2)
│   │   ├── colorschemes/     # Цветовые схемы (1)
│   │   ├── dap/              # Отладка (1)
│   │   └── test/             # Тестирование (1)
│   ├── overrides/            # Кастомизация плагинов (39)
│   │   ├── lazyvim/          # LazyVim (9)
│   │   ├── snacks/           # Snacks.nvim (9)
│   │   ├── bufferline/       # Bufferline (6)
│   │   └── other/            # Прочие плагины (15)
│   └── util/                 # Утилиты
│       ├── general.lua       # Общие (цвета, тема системы, проверка экстр)
│       └── layout.lua        # Размеры сайдбаров и панелей
└── init.lua                  # Защита от прямого запуска репозитория
```

## 🎯 Core-модули

### Рекомендуемая настройка

Включите всё разом — `core.all` через `:LazyExtras` или импортом:

```lua
{ import = "lazyvimx.extras.core.all" }
```

Внутри:

- **overrides** — все 39 кастомизаций плагинов
- **extras** — все функциональные экстры
- **colorschemes** — дополнительные цветовые схемы
- **keys** — кастомные кеймапы
- плюс уведомление, если не хватает рекомендуемых экстр LazyVim

### По отдельности

```lua
{ import = "lazyvimx.extras.core.overrides" }     -- Оверрайды плагинов
{ import = "lazyvimx.extras.core.extras" }        -- Все экстры
{ import = "lazyvimx.extras.core.keys" }          -- Кеймапы
{ import = "lazyvimx.extras.core.colorschemes" }  -- Цветовые схемы
```

## 📚 Документация

- **[EXTRAS.ru.md](docs/EXTRAS.ru.md)** — справочник по всем 50 экстрам ([🇬🇧](docs/EXTRAS.md))
- **[CONFIGURATION.ru.md](docs/CONFIGURATION.ru.md)** — настройка и опции ([🇬🇧](docs/CONFIGURATION.md))
- **[KEYBINDINGS.ru.md](docs/KEYBINDINGS.ru.md)** — все кеймапы ([🇬🇧](docs/KEYBINDINGS.md))
- **[ARCHITECTURE.ru.md](docs/ARCHITECTURE.ru.md)** — как всё устроено ([🇬🇧](docs/ARCHITECTURE.md))
- **[API.ru.md](docs/API.ru.md)** — утилиты и функции ([🇬🇧](docs/API.md))
- **[FAQ.ru.md](docs/FAQ.ru.md)** — частые вопросы ([🇬🇧](docs/FAQ.md))
- **[TROUBLESHOOTING.ru.md](docs/TROUBLESHOOTING.ru.md)** — решение проблем ([🇬🇧](docs/TROUBLESHOOTING.md))

## 🎨 Заметные экстры

### Интерфейс

- `ui.better-diagnostic` — диагностика одной строкой у курсора
- `ui.better-float` — единый стиль плавающих окон
- `ui.symbol-usage` — счётчики использований символов
- `ui.better-explorer` — файловый менеджер Yazi
- `ui.winbar` — путь к файлу над окном

### Навигация

- `motions.langmapper` — **русская раскладка без переключения**
- `motions.better-move-between-words` — движения по подсловам (нужен Lua 5.1/LuaJIT в `PATH`, см. Требования)
- `motions.sibling-swap` — перестановка узлов tree-sitter
- `motions.splitting-joining-blocks` — разбивка/склейка блоков кода

### Git

- `git.gitlab` — ревью GitLab MR из редактора
- `git.conflicts` — визуальное разрешение конфликтов
- `git.remote-view` — открытие удалённых репозиториев локально

### Прочее

- `buf.remote-mounts` — безопасная работа с sshfs
- `coding.comments` — комментирование с контекстом и генерация JSDoc
- `test.jest` — Jest в Neotest

## ⌨️ Кеймапы

lazyvimx добавляет 60+ кастомных кеймапов. Самые ходовые:

**Каждый день**:

- `<leader><space>` — найти файлы (smart)
- `<leader>cr` — LSP-переименование с живым превью
- `gr` — референсы в peek-окне
- `H` / `L` — предыдущий/следующий буфер
- `<leader>fy` — файловый менеджер Yazi
- `w` / `b` / `e` — движения по подсловам

**Продуктивность**:

- `d` — удаление без копирования в регистр
- `<C-S-j>` / `<C-S-k>` — перемещение строк
- `<C-,>` / `<C-.>` — перестановка параметров и элементов массива
- `<leader>ct` — разбить/склеить блок кода
- `gx` / `gX` — открыть удалённый git-репозиторий

**Git и GitLab**:

- `<leader>gL*` — весь воркфлоу GitLab MR (ревью, комментарии, approve, merge)
- `go` — открыть файл или выделение в GitHub/GitLab

**📖 Полный список**: [Кеймапы](docs/KEYBINDINGS.ru.md) — с описаниями и указанием,
какая экстра нужна для каждого кеймапа.

## 🔧 Конфигурация

### Цветовые схемы

lazyvimx переключает светлый/тёмный вариант темы вслед за системой:

```lua
require("lazyvimx").setup({
	colorscheme = "catppuccin",
})
```

Варианты собраны в «семейства» (`colorscheme_households`): для каждой темы — список тёмных и
список светлых. Из коробки настроены Catppuccin, Tokyo Night и Nord; тёмная система — берётся
тёмный вариант, светлая — светлый. Подробности и формат — в
[Настройка](docs/CONFIGURATION.ru.md#🎨-цветовые-схемы).

### Группы буферов

Кастомные группы в bufferline:

```lua
require("lazyvimx").setup({
	bufferline_groups = {
		["React"] = "%.tsx$",
		["Tests"] = "%.test%.",
	},
})
```

## 🤝 Интеграции

### Chezmoi

При обновлении плагинов lazyvimx добавляет `lazy-lock.json` и `lazyvim.json` в chezmoi —
если утилита `chezmoi` установлена.

### VSCode

Режим для расширения VSCode Neovim:

- синхронизация индикатора режима со статус-баром
- адаптированные кеймапы
- переименование через нативный VSCode

### macOS

- определение системной темы для автопереключения цветовых схем
- удаление файлов в корзину в neo-tree

## 🌟 Философия

1. **Не ломать LazyVim** — все улучшения опциональны и включаются экстрами
2. **Единый стиль** — общая тема и визуальный язык во всех плагинах
3. **Умные дефолты** — работает из коробки, настраивается при желании
4. **Внимание к деталям** — от рамок окон до поведения курсора

## 📊 Статистика

- **50 опциональных экстр** в 11 категориях
- **39 оверрайдов** для глубокой кастомизации
- **Сотни кастомных хайлайтов** для Catppuccin, Tokyo Night и Nord
- **60+ кастомных кеймапов**

## 🔗 Ссылки

- [Пример использования](https://github.com/aimuzov/dotfiles/blob/main/dot_config/nvim/init.lua)
- [Обсуждение](https://t.me/aimuzov_dotfiles)
- [LazyVim](https://github.com/LazyVim/LazyVim)

## 📈 Активность

![Repo Activity](https://repobeats.axiom.co/api/embed/f5453bcfc3ad93005a4d3b73d0681450ff7ca5d3.svg "Repobeats analytics image")

## 🤝 Контрибьютинг

Баги и идеи — в [issues](https://github.com/lazyvimx/nvim/issues). Как устроен проект и
как написать свою экстру — в [Гайд контрибьютора](CONTRIBUTING.ru.md).

## 📄 Лицензия

Лицензия та же, что у LazyVim.

## 🙏 Благодарности

Построен поверх превосходного [LazyVim](https://github.com/LazyVim/LazyVim) от
[folke](https://github.com/folke).

---

**Автор**: Aleksey Imuzov ([@aimuzov](https://github.com/aimuzov))
