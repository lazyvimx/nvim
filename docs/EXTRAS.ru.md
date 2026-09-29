# Справочник экстр

> [!TIP]
> **🇬🇧 English version:** [EXTRAS.md](EXTRAS.md)

Полный справочник по всей 51 экстре lazyvimx.

## 📑 Содержание

- [Обзор](#📖-обзор)
- [Core-модули](#🧩-core-модули)
- [UI (22)](#🎨-ui)
- [Coding (2)](#✍️-coding)
- [Motions (6)](#🧭-motions)
- [Buf (4)](#🗂️-buf)
- [Git (4)](#🔀-git)
- [Lang (4)](#🌐-lang)
- [Linting (2)](#🧹-linting)
- [Colorschemes (1)](#🌈-colorschemes)
- [DAP (1)](#🐞-dap)
- [Perf (4)](#⚡-perf)
- [Test (1)](#🧪-test)
- [Сводная таблица](#📊-сводная-таблица)

## 📖 Обзор

Экстра — это необязательный модуль с готовой настройкой плагина или поведения поверх LazyVim.
Каждую можно включить отдельно: через UI `:LazyExtras` (секция lazyvimx помечена иконкой 󰬟)
или импортом в конфиге.

**Через UI:**

```vim
:LazyExtras
```

**Через конфиг:**

```lua
{ import = "lazyvimx.extras.<категория>.<имя>" }
```

**Включить всё сразу:**

```lua
{ import = "lazyvimx.extras.core.all" }
```

---

## 🧩 Core-модули

Core — не фичи, а «сборные» модули: они включают наборы других экстр, оверрайдов и кеймапов.

### core.all

**Импорт:** `lazyvimx.extras.core.all`

Весь lazyvimx целиком: оверрайды, все экстры, цветовые схемы и кастомные кеймапы.

**Включает:**

- `core.colorschemes` — дополнительные цветовые схемы
- `core.overrides` — все 39 оверрайдов
- `core.extras` — все 49 экстр из реестра
- `core.keys` — кастомные кеймапы

Дополнительно при старте проверяет, включены ли рекомендуемые экстры самого LazyVim, и
показывает уведомление, если чего-то не хватает: `coding.mini-surround`, `coding.yanky`,
`ui.edgy`, `ui.treesitter-context`.

### core.overrides

**Импорт:** `lazyvimx.extras.core.overrides`

**Рекомендуется:** да

Все оверрайды плагинов — 39 модулей в 4 категориях:

- LazyVim (9 модулей)
- Snacks.nvim (9 модулей)
- Bufferline (6 модулей)
- прочие плагины (15 модулей)

Подробнее — на странице [Архитектура](./ARCHITECTURE.ru.md#система-оверрайдов).

### core.extras

**Импорт:** `lazyvimx.extras.core.extras`

Реестр всех 49 функциональных экстр (все категории, кроме `colorschemes`) — один импорт вместо
сорока девяти. `ui.better-progressbar` из реестра включается только под Ghostty
(`TERM=xterm-ghostty`).

### core.colorschemes

**Импорт:** `lazyvimx.extras.core.colorschemes`

Дополнительные цветовые схемы. Сейчас включает одну экстру — `colorschemes.nord`.

### core.keys

**Импорт:** `lazyvimx.extras.core.keys`

Кастомные кеймапы для фич lazyvimx. Кеймапы привязаны к плагинам: если плагин не установлен,
его кеймапы просто не появятся.

Полный список — на странице [Кеймапы](./KEYBINDINGS.ru.md).

---

## 🎨 UI

Экстры, улучшающие внешний вид и интерфейс.

### ui.better-colorcolumn

![Демо](https://raw.githubusercontent.com/lazyvimx/nvim/assets/demo/ui-better-colorcolumn.gif)

**Импорт:** `lazyvimx.extras.ui.better-colorcolumn`

Вертикальная линия-ограничитель на 120-м столбце — виртуальным символом `│` вместо
залитой колонки.

**Плагин:** [`lukas-reineke/virt-column.nvim`](https://github.com/lukas-reineke/virt-column.nvim)

### ui.better-cursorline

![Демо](https://raw.githubusercontent.com/lazyvimx/nvim/assets/demo/ui-better-cursorline.gif)

**Импорт:** `lazyvimx.extras.ui.better-cursorline`

Cursorline только в активном окне; номер строки подсвечивается всегда. Служебные буферы
(дашборд, neo-tree, терминалы и т.п.) исключены.

**Плагин:** [`tummetott/reticle.nvim`](https://github.com/tummetott/reticle.nvim)

### ui.better-diagnostic

![Демо](https://raw.githubusercontent.com/lazyvimx/nvim/assets/demo/ui-better-diagnostic.gif)

**Импорт:** `lazyvimx.extras.ui.better-diagnostic`

Диагностика одной строкой у курсора — с иконками, цветами и кастомными стрелками. Родной
virtual text отключается.

**Плагин:** [`rachartier/tiny-inline-diagnostic.nvim`](https://github.com/rachartier/tiny-inline-diagnostic.nvim)

### ui.better-explorer

![Демо](https://raw.githubusercontent.com/lazyvimx/nvim/assets/demo/ui-better-explorer.gif)

**Импорт:** `lazyvimx.extras.ui.better-explorer`

Файловый менеджер [Yazi](https://github.com/sxyazi/yazi) во весь экран, без рамок, с богатым
превью файлов.

**Плагин:** [`mikavilpas/yazi.nvim`](https://github.com/mikavilpas/yazi.nvim)

**Кеймапы:** `<leader>fy` — открыть Yazi, `<leader>fY` — открыть предыдущую сессию Yazi
(через `core.keys`).

### ui.better-float

![Демо](https://raw.githubusercontent.com/lazyvimx/nvim/assets/demo/ui-better-float.gif)

**Импорт:** `lazyvimx.extras.ui.better-float`

Единый стиль плавающих окон: скруглённые рамки и согласованные размеры для DAP UI, gitsigns,
Mason, LSP-окон, neo-tree, noice, терминалов Snacks, lazygit и fzf-lua.

### ui.better-insert-mode

![Демо](https://raw.githubusercontent.com/lazyvimx/nvim/assets/demo/ui-better-insert-mode.gif)

**Импорт:** `lazyvimx.extras.ui.better-insert-mode`

В insert-режиме прячет отвлекающие элементы: treesitter-контекст, счётчики symbol-usage,
индент-гайды и colorcolumn. При выходе из insert всё возвращается.

### ui.better-linenumbers

![Демо](https://raw.githubusercontent.com/lazyvimx/nvim/assets/demo/ui-better-linenumbers.gif)

**Импорт:** `lazyvimx.extras.ui.better-linenumbers`

Отключает относительные номера строк в командном режиме (чтобы `:` показывал абсолютные) и
все номера — в терминальных буферах.

### ui.better-live-rename

![Демо](https://raw.githubusercontent.com/lazyvimx/nvim/assets/demo/ui-better-live-rename.gif)

**Импорт:** `lazyvimx.extras.ui.better-live-rename`

LSP-переименование с живым превью прямо в буфере. Подтверждение — `<CR>`, отмена — `<C-c>`.

**Плагин:** [`saecki/live-rename.nvim`](https://github.com/saecki/live-rename.nvim)

**Кеймапы:** `<leader>cr` (через `core.keys`).

### ui.better-progressbar

**Импорт:** `lazyvimx.extras.ui.better-progressbar`

Прогресс LSP-задач в нативном прогресс-баре терминала Ghostty (escape-последовательность
OSC 9;4) вместо уведомлений в редакторе. Показывает проценты, если сервер их сообщает, и
«пульсирующий» индикатор, если нет. Уведомления noice о прогрессе LSP отключаются.

**Требует:** Ghostty (`TERM=xterm-ghostty`); в других терминалах экстра лишь покажет
предупреждение.

### ui.better-reference-highlight

![Демо](https://raw.githubusercontent.com/lazyvimx/nvim/assets/demo/ui-better-reference-highlight.gif)

**Импорт:** `lazyvimx.extras.ui.better-reference-highlight`

Подсветка LSP-референсов жирным цветом текста вместо заливки фона: rosewater у Catppuccin,
смесь с magenta у Tokyo Night.

**Темы:** Catppuccin, Tokyo Night.

### ui.better-whitespace

![Демо](https://raw.githubusercontent.com/lazyvimx/nvim/assets/demo/ui-better-whitespace.gif)

**Импорт:** `lazyvimx.extras.ui.better-whitespace`

Показ пробельных символов в visual-режиме, как в VSCode: пробелы `·`, табы `→`, nbsp `␣`,
конец строки `↩`.

**Плагин:** [`mcauley-penney/visual-whitespace.nvim`](https://github.com/mcauley-penney/visual-whitespace.nvim)

### ui.bolder-separators

![Демо](https://raw.githubusercontent.com/lazyvimx/nvim/assets/demo/ui-bolder-separators.gif)

**Импорт:** `lazyvimx.extras.ui.bolder-separators`

Жирные Unicode-разделители окон: `━`, `┃`, `┳`, `┻`, `╋`, `┫`, `┣`.

### ui.diff-view

![Демо](https://raw.githubusercontent.com/lazyvimx/nvim/assets/demo/ui-diff-view.gif)

**Импорт:** `lazyvimx.extras.ui.diff-view`

Diffview с размерами панелей из общей layout-утилиты: панель файлов слева, история снизу —
согласованно с остальными сайдбарами.

**Плагин:** [`sindrets/diffview.nvim`](https://github.com/sindrets/diffview.nvim)

**Команды:** `:DiffviewOpen`, `:DiffviewFileHistory`.

### ui.highlighted-ansi-escape

![Демо](https://raw.githubusercontent.com/lazyvimx/nvim/assets/demo/ui-highlighted-ansi-escape.gif)

**Импорт:** `lazyvimx.extras.ui.highlighted-ansi-escape`

Рендер ANSI escape-последовательностей настоящими цветами: логи, вывод DAP REPL
(раскрашивается автоматически).

**Плагин:** [`m00qek/baleia.nvim`](https://github.com/m00qek/baleia.nvim)

**Команды:** `:BaleiaColorize` — раскрасить текущий буфер, `:BaleiaLogs` — показать лог плагина.

### ui.highlighted-colors

![Демо](https://raw.githubusercontent.com/lazyvimx/nvim/assets/demo/ui-highlighted-colors.gif)

**Импорт:** `lazyvimx.extras.ui.highlighted-colors`

Индикатор 󱓻 в цвете каждого hex-кода в конце строки.

**Плагин:** [`brenoprata10/nvim-highlight-colors`](https://github.com/brenoprata10/nvim-highlight-colors)

### ui.inline-fold

**Импорт:** `lazyvimx.extras.ui.inline-fold`

Сворачивает выделение в метку: `Some text EXAMPLE WORDS text` → `Some text … text`.
Нативные фолды только построчные и не создаются вручную при `foldmethod=expr`, поэтому
текст остаётся в буфере и прячется за виртуальным текстом — после разворачивания подсветка
и extmarks на месте. Построчное выделение схлопывается в одну строку с меткой; посимвольное
на несколько строк оставляет хвост последней строки на отдельной строке.

**Кеймапы:** `zF` в visual-режиме — свернуть выделение (спросит метку), `zF` в normal —
развернуть под курсором.

### ui.peek-preview

![Демо](https://raw.githubusercontent.com/lazyvimx/nvim/assets/demo/ui-peek-preview.gif)

**Импорт:** `lazyvimx.extras.ui.peek-preview`

Peek-окно для LSP-локаций, как в VSCode. Если результат один — сразу прыжок, если несколько —
превью со списком.

**Плагин:** [`dnlhc/glance.nvim`](https://github.com/dnlhc/glance.nvim)

**Кеймапы:** `gr` — референсы через Glance (через `core.keys`).

### ui.scrollbar

![Демо](https://raw.githubusercontent.com/lazyvimx/nvim/assets/demo/ui-scrollbar.gif)

**Импорт:** `lazyvimx.extras.ui.scrollbar`

Скроллбар только в активном окне. Прячется в insert-режиме и в служебных буферах.

**Плагин:** [`dstein64/nvim-scrollview`](https://github.com/dstein64/nvim-scrollview)

### ui.simple-mode

![Демо](https://raw.githubusercontent.com/lazyvimx/nvim/assets/demo/ui-simple-mode.gif)

**Импорт:** `lazyvimx.extras.ui.simple-mode`

Минимальный интерфейс для чтения man-страниц: при запуске `nvim +Man! <команда>` отключаются
statusline, bufferline, neo-tree и номера строк.

### ui.showkeys

![Демо](https://raw.githubusercontent.com/lazyvimx/nvim/assets/demo/ui-showkeys.gif)

**Импорт:** `lazyvimx.extras.ui.showkeys`

Плашка с нажимаемыми клавишами в углу экрана — для скринкастов, демо и парного
программирования. Включается командой `:ShowkeysToggle`. Все демо-гифки этой документации
записаны с ней.

**Плагин:** [`nvzone/showkeys`](https://github.com/nvzone/showkeys)

### ui.symbol-usage

![Демо](https://raw.githubusercontent.com/lazyvimx/nvim/assets/demo/ui-symbol-usage.gif)

**Импорт:** `lazyvimx.extras.ui.symbol-usage`

Счётчики использований символов в конце строки, как в JetBrains IDE: `󰌹 3 usages`. Показ
определений и реализаций выключен по умолчанию, для вложенных функций — суммарный счётчик.

**Плагин:** [`Wansmer/symbol-usage.nvim`](https://github.com/Wansmer/symbol-usage.nvim)

### ui.winbar

![Демо](https://raw.githubusercontent.com/lazyvimx/nvim/assets/demo/ui-winbar.gif)

**Импорт:** `lazyvimx.extras.ui.winbar`

Winbar с иконкой типа файла и коротким путём (pretty path из LazyVim), жирным шрифтом на
прозрачном фоне. В служебных буферах не показывается.

**Плагин:** [`nvim-lualine/lualine.nvim`](https://github.com/nvim-lualine/lualine.nvim)

---

## ✍️ Coding

### coding.comments

![Демо](https://raw.githubusercontent.com/lazyvimx/nvim/assets/demo/coding-comments.gif)

**Импорт:** `lazyvimx.extras.coding.comments`

Комментирование с учётом контекста tree-sitter (правильный commentstring в JSX, Vue и т.п.)
плюс генерация JSDoc/TSDoc-документации.

**Плагины:** [`nvim-mini/mini.comment`](https://github.com/nvim-mini/mini.comment), [`JoosepAlviste/nvim-ts-context-commentstring`](https://github.com/JoosepAlviste/nvim-ts-context-commentstring),
`kkoomen/vim-doge`

**Кеймапы:** `gcc` — комментарий (mini.comment), `gcd` — сгенерировать документацию (doge).

### coding.emmet

**Импорт:** `lazyvimx.extras.coding.emmet`

Разворачивание Emmet-аббревиатур: `div.container>ul>li*3` → готовая разметка. Плюс команда
`:EmmetWrap` — обернуть выделение в аббревиатуру.

**Плагины:** [`neovim/nvim-lspconfig`](https://github.com/neovim/nvim-lspconfig) (emmet_language_server), [`olrtg/nvim-emmet`](https://github.com/olrtg/nvim-emmet)

**Кеймапы:** `<leader>cw` — обернуть в аббревиатуру (через `core.keys`).

---

## 🧭 Motions

### motions.better-cursor-move

![Демо](https://raw.githubusercontent.com/lazyvimx/nvim/assets/demo/motions-better-cursor-move.gif)

**Импорт:** `lazyvimx.extras.motions.better-cursor-move`

Курсор не убегает при сдвигах (`>`, `<`) и фильтрах. Работает и в VSCode.

**Плагин:** [`gbprod/stay-in-place.nvim`](https://github.com/gbprod/stay-in-place.nvim)

### motions.better-move-between-words

![Демо](https://raw.githubusercontent.com/lazyvimx/nvim/assets/demo/motions-better-move-between-words.gif)

**Импорт:** `lazyvimx.extras.motions.better-move-between-words`

Движения `w`/`e`/`b` по подсловам: останавливаются внутри camelCase и пропускают незначащую
пунктуацию. UTF-8, работает и в VSCode.

**Плагин:** [`chrisgrieser/nvim-spider`](https://github.com/chrisgrieser/nvim-spider)

**Кеймапы:** `w`/`e`/`b`, `cw`, а в insert-режиме `<C-f>`/`<C-b>` (через `core.keys`).

**Требует:** Lua 5.1 или LuaJIT в `PATH` (`brew install luajit`) — без системного Lua не
собирается luarocks.nvim, а без рока `luautf8` подслова в не-ASCII тексте не видны.

### motions.langmapper

![Демо](https://raw.githubusercontent.com/lazyvimx/nvim/assets/demo/motions-langmapper.gif)

**Импорт:** `lazyvimx.extras.motions.langmapper`

**Рекомендуется:** да

Русская раскладка без переключения: все кеймапы автоматически транслируются. Настроены
langmap для RU-раскладки, хак `getcharstr` (чтобы работали ожидающие ввода команды вроде `f`),
интеграция с which-key и Snacks.

**Плагин:** [`Wansmer/langmapper.nvim`](https://github.com/Wansmer/langmapper.nvim)

### motions.sibling-move

![Демо](https://raw.githubusercontent.com/lazyvimx/nvim/assets/demo/motions-sibling-move.gif)

**Импорт:** `lazyvimx.extras.motions.sibling-move`

Перемещение по синтаксическому дереву: между параметрами, элементами массива, соседними
узлами. Цель подсвечивается на 250 мс.

**Плагин:** [`aaronik/treewalker.nvim`](https://github.com/aaronik/treewalker.nvim)

**Кеймапы:** `<C-A-h/j/k/l>` — навигация, `<C-A-,>`/`<C-A-.>` — перестановка узлов
(через `core.keys`).

### motions.sibling-swap

![Демо](https://raw.githubusercontent.com/lazyvimx/nvim/assets/demo/motions-sibling-swap.gif)

**Импорт:** `lazyvimx.extras.motions.sibling-swap`

Перестановка соседних узлов tree-sitter: параметров функций, элементов массива, свойств
объекта. Узел под курсором подсвечивается.

**Плагин:** [`Wansmer/sibling-swap.nvim`](https://github.com/Wansmer/sibling-swap.nvim)

**Кеймапы:** `<C-,>` — поменять с левым, `<C-.>` — с правым (через `core.keys`).

### motions.splitting-joining-blocks

![Демо](https://raw.githubusercontent.com/lazyvimx/nvim/assets/demo/motions-splitting-joining-blocks.gif)

**Импорт:** `lazyvimx.extras.motions.splitting-joining-blocks`

Разбивка и склейка блоков кода через tree-sitter: объекты, массивы, аргументы, JSX.

**Плагин:** [`Wansmer/treesj`](https://github.com/Wansmer/treesj)

**Кеймапы:** `<leader>ct` — переключить, `<leader>c\` — разбить, `<leader>cj` — склеить
(через `core.keys`).

```javascript
// <leader>ct превращает
{ foo: 'bar', baz: 'qux' }
// в
{
  foo: 'bar',
  baz: 'qux'
}
// и обратно
```

---

## 🗂️ Buf

### buf.delete-inactive

**Импорт:** `lazyvimx.extras.buf.delete-inactive`

Автоматически закрывает буферы после 30 минут неактивности (с уведомлением). Удаление файла
с диска буфер не трогает.

**Плагин:** [`chrisgrieser/nvim-early-retirement`](https://github.com/chrisgrieser/nvim-early-retirement)

### buf.delete-no-name

**Импорт:** `lazyvimx.extras.buf.delete-no-name`

Убирает пустые `[No Name]`-буферы: как только такой буфер прячется и он не изменён — он
удаляется.

### buf.remote-mounts

**Импорт:** `lazyvimx.extras.buf.remote-mounts`

Безопасное и лёгкое редактирование файлов на сетевых маунтах (sshfs и подобных).

**Что делает для буферов внутри `~/mnt`:**

- `backupcopy=yes` — запись «на месте», без временного файла и rename
- отключает swapfile и undofile (каждая их запись — сетевой roundtrip)
- отключает автоформатирование (`vim.b.autoformat`)
- отцепляет LSP-клиентов от таких буферов

Запись «на месте» сохраняет владельца, права и симлинки файла — это важно для конфигов под
`/etc` на удалённой машине: запись через временный файл их теряет.

### buf.tab-scope

![Демо](https://raw.githubusercontent.com/lazyvimx/nvim/assets/demo/buf-tab-scope.gif)

**Импорт:** `lazyvimx.extras.buf.tab-scope`

У каждого таба — свой список буферов. Bufferline и навигация по буферам работают в пределах
текущего таба.

**Плагин:** [`tiagovla/scope.nvim`](https://github.com/tiagovla/scope.nvim)

**Кеймапы:** `<leader>b<tab>` — перенести буфер в другой таб (через `core.keys`).

---

## 🔀 Git

### git.conflicts

![Демо](https://raw.githubusercontent.com/lazyvimx/nvim/assets/demo/git-conflicts.gif)

**Импорт:** `lazyvimx.extras.git.conflicts`

Подсветка и разрешение git-конфликтов прямо в буфере. Уведомления об обнаружении и
разрешении конфликта (не чаще раза в 3 секунды).

**Плагин:** [`akinsho/git-conflict.nvim`](https://github.com/akinsho/git-conflict.nvim)

### git.fugitive

**Импорт:** `lazyvimx.extras.git.fugitive`

Классический fugitive со всеми git-командами плюс `:GBrowse` для GitHub и GitLab. Токен
GitLab берётся из переменной окружения `GITLAB_TOKEN`.

**Плагины:** [`tpope/vim-fugitive`](https://github.com/tpope/vim-fugitive), [`tpope/vim-rhubarb`](https://github.com/tpope/vim-rhubarb), [`shumphrey/fugitive-gitlab.vim`](https://github.com/shumphrey/fugitive-gitlab.vim)

**Кеймапы:** `go` — открыть файл (или выделенный диапазон) в браузере (через `core.keys`).

### git.gitlab

**Импорт:** `lazyvimx.extras.git.gitlab`

Ревью GitLab MR не выходя из редактора: дерево обсуждений, комментарии к диффам,
approve/revoke, merge (настроен squash).

**Плагин:** [`harrisoncramer/gitlab.nvim`](https://github.com/harrisoncramer/gitlab.nvim)

**Требует:** экстру `ui.diff-view` (без неё покажет предупреждение).

**Кеймапы:** `<leader>gL*` — весь MR-воркфлоу (через `core.keys`), см.
[Кеймапы](./KEYBINDINGS.ru.md#gitlab).

### git.remote-view

**Импорт:** `lazyvimx.extras.git.remote-view`

Открытие удалённых репозиториев локально: клонирует во временную директорию и открывает в
новом табе — с README, если он есть, иначе с neo-tree.

**Плагин:** [`moyiz/git-dev.nvim`](https://github.com/moyiz/git-dev.nvim)

**Команды:** `:GitDevOpen <uri>`, `:GitDevRemoteOpen`, `:GitDevRemoteEnterAndOpen`.

**Кеймапы:** `gx` — открыть URL под курсором, `gX` — ввести `author/repo` и открыть
(через `core.keys`).

---

## 🌐 Lang

### lang.css

**Импорт:** `lazyvimx.extras.lang.css`

Поддержка CSS/SCSS: LSP `cssls` со сниппетами, tree-sitter-парсеры, форматирование через
stylelint (и prettier, если включена экстра LazyVim `formatting.prettier`), диагностика
stylelint_lsp при включённой `linting.eslint`.

### lang.ejs

**Импорт:** `lazyvimx.extras.lang.ejs`

Подсветка EJS-шаблонов: файлы `.ejs` регистрируются как eruby с парсером
`embedded_template`.

### lang.json

**Импорт:** `lazyvimx.extras.lang.json`

JSONC (JSON с комментариями) подсвечивается парсером json.

### lang.skhd

**Импорт:** `lazyvimx.extras.lang.skhd`

Подсветка конфигов [skhd.zig](https://github.com/jackielii/skhd.zig) (`skhdrc`) собственной
tree-sitter-грамматикой.

**Плагин:** [`aimuzov/tree-sitter-skhdrc`](https://github.com/aimuzov/tree-sitter-skhdrc)

---

## 🧹 Linting

### linting.cspell

**Импорт:** `lazyvimx.extras.linting.cspell`

Проверка орфографии cspell для всех типов файлов. Включается только если cspell установлен
локально в проекте (например, через npm) — глобальный бинарник не подхватывается.

**Плагин:** [`mfussenegger/nvim-lint`](https://github.com/mfussenegger/nvim-lint)

### linting.stylelint

**Импорт:** `lazyvimx.extras.linting.stylelint`

Устанавливает stylelint-language-server через Mason. При включённой экстре LazyVim
`linting.eslint` настраивает `stylelint_lsp`: корень проекта определяется детектором LazyVim,
а список проверяемых типов расширен (css, scss, less, html, vue, svelte и другие).

---

## 🌈 Colorschemes

### colorschemes.nord

![Демо](https://raw.githubusercontent.com/lazyvimx/nvim/assets/demo/colorschemes-nord.gif)

**Импорт:** `lazyvimx.extras.colorschemes.nord` (входит в `core.colorschemes`)

Цветовая схема Nord с сотней кастомных хайлайтов под плагины lazyvimx: blink.cmp, bufferline,
neo-tree, snacks-дашборд, symbol-usage и другие. Включает собственные темы для lualine и
bufferline, тёмный (`nord`) и светлый (`nord-light`) варианты.

**Плагин:** [`gbprod/nord.nvim`](https://github.com/gbprod/nord.nvim)

---

## 🐞 DAP

### dap.vscode-js

**Импорт:** `lazyvimx.extras.dap.vscode-js`

Отладка JavaScript/TypeScript (и Svelte) через `js-debug-adapter` из Mason. Три конфигурации:

1. Запуск Chrome для отладки клиента (localhost:8080)
2. Подключение к процессу `node --inspect`
3. Запуск текущего файла в node (только JavaScript)

**Требует:** экстру LazyVim `dap.core` (без неё не активируется и покажет предупреждение).
В VSCode отключена.

**Кеймапы:** `<F5>` / `<F10>` / `<F11>` / `<F12>` (через `core.keys`).

---

## ⚡ Perf

### perf.auto-update-deps

**Импорт:** `lazyvimx.extras.perf.auto-update-deps`

Автообновление всех пакетов Mason при старте: LSP-серверов, отладчиков, линтеров и
форматтеров — включая установленные вручную через `:MasonInstall`.

**Плагин:** [`WhoIsSethDaniel/mason-tool-installer.nvim`](https://github.com/WhoIsSethDaniel/mason-tool-installer.nvim)

### perf.local-config

**Импорт:** `lazyvimx.extras.perf.local-config`

Локальный конфиг проекта: при открытии проекта тихо подгружается `.nvim.lua` или
`.config/nvim.lua` из его корня.

**Плагин:** [`klen/nvim-config-local`](https://github.com/klen/nvim-config-local)

```lua
-- .nvim.lua
vim.opt_local.shiftwidth = 2
vim.opt_local.expandtab = true
```

### perf.restore-last-colorscheme

**Импорт:** `lazyvimx.extras.perf.restore-last-colorscheme`

Запоминает последнюю выбранную цветовую схему и восстанавливает её при старте — в рамках
логики светлых/тёмных вариантов lazyvimx (см.
[Настройка](./CONFIGURATION.ru.md#цветовые-схемы)).

**Плагин:** [`raddari/last-color.nvim`](https://github.com/raddari/last-color.nvim)

### perf.stop-inactive-lsp

**Импорт:** `lazyvimx.extras.perf.stop-inactive-lsp`

Останавливает LSP-клиентов, к буферам которых давно не обращались, и освобождает память.

**Плагин:** [`zeioth/garbage-day.nvim`](https://github.com/zeioth/garbage-day.nvim)

---

## 🧪 Test

### test.jest

**Импорт:** `lazyvimx.extras.test.jest`

Jest-адаптер для Neotest: запуск тестов из редактора, вывод результатов, обнаружение тестов
самим Jest, переменная окружения `CI=true`.

**Плагины:** [`nvim-neotest/neotest`](https://github.com/nvim-neotest/neotest), [`haydenmeade/neotest-jest`](https://github.com/haydenmeade/neotest-jest)

**Требует:** экстру LazyVim `test.core` (без неё не активируется).

---

## 📊 Сводная таблица

| Категория    | Кол-во | Что внутри                                 |
| ------------ | ------ | ------------------------------------------ |
| UI           | 22     | Интерфейс и внешний вид                    |
| Motions      | 6      | Навигация и перемещения по коду            |
| Buf          | 4      | Управление буферами                        |
| Git          | 4      | Git и GitLab                               |
| Lang         | 4      | Поддержка языков                           |
| Perf         | 4      | Производительность и удобство              |
| Coding       | 2      | Инструменты написания кода                 |
| Linting      | 2      | Линтеры                                    |
| Colorschemes | 1      | Цветовые схемы                                 |
| DAP          | 1      | Отладка                                    |
| Test         | 1      | Тестирование                               |
| **Итого**    | **51** | плюс 5 core-модулей для включения наборами |

## 🚀 С чего начать

1. `core.all` — всё сразу; либо `core.overrides` + отдельные экстры по вкусу
2. `motions.langmapper` — если печатаете на русской раскладке
3. `ui.better-diagnostic` — читаемая диагностика
4. `ui.better-float` — единый стиль окон
5. `git.conflicts` — если случаются конфликты
6. `coding.comments` — комментирование с контекстом

## 🔗 См. также

- [Настройка](CONFIGURATION.ru.md) — настройка
- [Кеймапы](KEYBINDINGS.ru.md) — кеймапы
- [API](API.ru.md) — утилиты
- [Архитектура](ARCHITECTURE.ru.md) — устройство
