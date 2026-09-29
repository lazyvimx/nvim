# Кеймапы

> [!TIP]
> **🇬🇧 English version:** [KEYBINDINGS.md](KEYBINDINGS.md)

Все кастомные кеймапы lazyvimx.

## 📑 Содержание

- [Как это работает](#⚙️-как-это-работает)
- [Базовые операции](#🧰-базовые-операции)
- [Файлы и буферы](#🗂️-файлы-и-буферы)
- [Навигация и движения](#🧭-навигация-и-движения)
- [Окна](#🪟-окна)
- [LSP и код](#🧠-lsp-и-код)
- [Git](#🔀-git)
- [GitLab](#🦊-gitlab)
- [DAP (отладка)](#🐞-dap-отладка)
- [Кастомизация](#🎛️-кастомизация)

## ⚙️ Как это работает

Кеймапы включаются модулем `core.keys` (входит в `core.all`):

```lua
{ import = "lazyvimx.extras.core.keys" }
```

Каждый кеймап привязан к своему плагину: если плагин не установлен (соответствующая экстра
выключена) — кеймап просто не появится. В колонке «Требуется» указано, какая экстра
приносит плагин.

**Leader** — пробел (дефолт LazyVim). Источник истины —
[extras/core/keys.lua](../lua/lazyvimx/extras/core/keys.lua).

## 🧰 Базовые операции

| Кеймап           | Режим   | Описание                             | Требуется |
| ---------------- | ------- | ------------------------------------ | --------- |
| `d`              | n, v    | Удаление без копирования в регистр   | core.keys |
| `<C-S-j>`        | n, i, v | Переместить строку/выделение вниз    | core.keys |
| `<C-S-k>`        | n, i, v | Переместить строку/выделение вверх   | core.keys |
| `<leader>\`      | n       | Разделить окно вправо                | core.keys |
| `<leader>ch`     | n       | Открыть shell (cht.sh)               | core.keys |
| `<leader>ll`     | n       | Открыть дашборд Lazy                 | core.keys |
| `<leader>lx`     | n       | Открыть Lazy extras                  | core.keys |
| `<leader>uz`     | n       | Zen-режим (zoom)                     | core.keys |
| `<leader>uq`     | n       | Открыть дашборд                      | core.keys |
| `<leader><tab>r` | n       | Переименовать таб                    | core.keys |

В VSCode кеймапы `<leader>\`, `<leader>ch`, `<leader>ll`, `<leader>lx` не создаются.

## 🗂️ Файлы и буферы

| Кеймап            | Режим | Описание                        | Требуется          |
| ----------------- | ----- | ------------------------------- | ------------------ |
| `<leader><space>` | n     | Найти файлы (smart)             | core.keys          |
| `<leader>fy`      | n     | Файловый менеджер Yazi          | ui.better-explorer |
| `<leader>fY`      | n     | Yazi (предыдущая сессия)        | ui.better-explorer |
| `<leader>bg`      | n, v  | Выбрать буфер                   | core.keys          |
| `<leader>bm[`     | n     | Переместить буфер назад         | core.keys          |
| `<leader>bm]`     | n     | Переместить буфер вперёд        | core.keys          |
| `<leader>b<tab>`  | n     | Перенести буфер в другой таб    | buf.tab-scope      |
| `H`               | n     | Предыдущий буфер                | core.keys          |
| `L`               | n     | Следующий буфер                 | core.keys          |

## 🧭 Навигация и движения

| Кеймап    | Режим   | Описание                            | Требуется                         |
| --------- | ------- | ----------------------------------- | --------------------------------- |
| `[x`      | n       | Перейти к treesitter-контексту      | LazyVim ui.treesitter-context     |
| `w`       | n, o, x | Слово вперёд (по подсловам)         | motions.better-move-between-words |
| `b`       | n, o, x | Слово назад (по подсловам)          | motions.better-move-between-words |
| `e`       | n, o, x | Конец слова (по подсловам)          | motions.better-move-between-words |
| `cw`      | n       | Изменить слово (по подсловам)       | motions.better-move-between-words |
| `<C-f>`   | i       | Слово вперёд в insert               | motions.better-move-between-words |
| `<C-b>`   | i       | Слово назад в insert                | motions.better-move-between-words |
| `<C-A-h>` | n       | Узел слева (treewalker)             | motions.sibling-move              |
| `<C-A-l>` | n       | Узел справа (treewalker)            | motions.sibling-move              |
| `<C-A-j>` | n       | Узел ниже (treewalker)              | motions.sibling-move              |
| `<C-A-k>` | n       | Узел выше (treewalker)              | motions.sibling-move              |
| `<C-A-.>` | n       | Поменять узел с нижним              | motions.sibling-move              |
| `<C-A-,>` | n       | Поменять узел с верхним             | motions.sibling-move              |

## 🪟 Окна

Ресайз работает и для edgy-сайдбаров — новый размер запоминается (см.
[util.layout](API.ru.md#🪟-utillayout)).

| Кеймап      | Режим   | Описание               | Требуется |
| ----------- | ------- | ---------------------- | --------- |
| `<C-Up>`    | n, v, t | Увеличить высоту окна  | core.keys |
| `<C-Down>`  | n, v, t | Уменьшить высоту окна  | core.keys |
| `<C-Left>`  | n, v, t | Уменьшить ширину окна  | core.keys |
| `<C-Right>` | n, v, t | Увеличить ширину окна  | core.keys |

## 🧠 LSP и код

| Кеймап       | Режим | Описание                              | Требуется                        |
| ------------ | ----- | ------------------------------------- | -------------------------------- |
| `gr`         | n     | Референсы в peek-окне (glance)        | ui.peek-preview                  |
| `<leader>cr` | n     | Переименование с превью (live-rename) | ui.better-live-rename            |
| `<leader>cw` | n, v  | Обернуть в Emmet-аббревиатуру         | coding.emmet                     |
| `<C-.>`      | n     | Поменять узел с правым                | motions.sibling-swap             |
| `<C-,>`      | n     | Поменять узел с левым                 | motions.sibling-swap             |
| `<leader>ct` | n     | Разбить/склеить блок (автоматически)  | motions.splitting-joining-blocks |
| `<leader>c\` | n     | Разбить блок                          | motions.splitting-joining-blocks |
| `<leader>cj` | n     | Склеить блок                          | motions.splitting-joining-blocks |
| `<leader>ac` | n, x  | Скопировать позицию курсора/выделения | core.overrides (sidekick)        |
| `zF`         | x     | Свернуть выделение в метку            | ui.inline-fold                   |
| `zF`         | n     | Развернуть фолд под курсором          | ui.inline-fold                   |

`<leader>ac` кладёт в буфер обмена ссылку вида `@файл :L10:C5` — удобно для промптов
AI-агентам.

## 🔀 Git

| Кеймап        | Режим | Описание                            | Требуется       |
| ------------- | ----- | ----------------------------------- | --------------- |
| `<leader>ghP` | n     | Превью hunk'а                       | core.keys       |
| `go`          | n     | Открыть файл в браузере (GBrowse)   | git.fugitive    |
| `go`          | v     | Открыть диапазон в браузере         | git.fugitive    |
| `gx`          | n     | Открыть удалённый репозиторий       | git.remote-view |
| `gX`          | n     | Ввести `author/repo` и открыть      | git.remote-view |

## 🦊 GitLab

**Требуется**: экстра `git.gitlab`.

| Кеймап        | Режим | Описание                           |
| ------------- | ----- | ---------------------------------- |
| `<leader>gLr` | n     | Ревью MR                           |
| `<leader>gLe` | n     | Выбрать MR                         |
| `<leader>gLs` | n     | Сводка MR                          |
| `<leader>gLd` | n     | Дерево обсуждений                  |
| `<leader>gLc` | n     | Комментарий                        |
| `<leader>gLc` | v     | Комментарий к нескольким строкам   |
| `<leader>gLC` | v     | Комментарий с предложением правки  |
| `<leader>gLn` | n     | Заметка                            |
| `<leader>gLm` | n     | К обсуждению из диагностики        |
| `<leader>gLA` | n     | Approve                            |
| `<leader>gLR` | n     | Отозвать approve                   |
| `<leader>gLM` | n     | Merge                              |
| `<leader>gLp` | n     | Пайплайн                           |
| `<leader>gLo` | n     | Открыть в браузере                 |

## 🐞 DAP (отладка)

**Требуется**: `dap.vscode-js` (или другая DAP-экстра, приносящая `nvim-dap`).

| Кеймап  | Режим | Описание   |
| ------- | ----- | ---------- |
| `<F5>`  | n     | Продолжить |
| `<F10>` | n     | Step over  |
| `<F11>` | n     | Step into  |
| `<F12>` | n     | Step out   |

## 🎛️ Кастомизация

### Отключить кеймап

```lua
-- lua/plugins/keys.lua
return {
	{
		"LazyVim/LazyVim",
		keys = {
			{ "<leader>cr", false },
		},
	},
}
```

### Переопределить

```lua
return {
	{
		"LazyVim/LazyVim",
		keys = {
			{ "<leader>cr", "<cmd>lua vim.lsp.buf.rename()<cr>", desc = "Rename (default)" },
		},
	},
}
```

### Добавить свой

```lua
-- lua/config/keymaps.lua
vim.keymap.set("n", "<leader>xx", "<cmd>MyCommand<cr>", { desc = "My Command" })
```

### Русская раскладка

С экстрой `motions.langmapper` все кеймапы работают и на русской раскладке — переключаться не
нужно:

```lua
{ import = "lazyvimx.extras.motions.langmapper" }
```

### Конфликты

```vim
" Кто занял кеймап
:verbose map <leader>cr

" Все маппинги клавиши
:map <leader>cr
```

Все кеймапы видны в which-key: нажмите leader и подождите, либо `:WhichKey <leader>g`.

## 📚 См. также

- [Кеймапы LazyVim](https://www.lazyvim.org/keymaps) — базовые кеймапы
- [Экстры](EXTRAS.ru.md) — справочник экстр
- [Решение проблем](TROUBLESHOOTING.ru.md#⌨️-кеймапы) — если кеймапы не работают
