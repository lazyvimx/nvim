# Решение проблем

> [!TIP]
> **🇬🇧 English version:** [TROUBLESHOOTING.md](TROUBLESHOOTING.md)

Типовые проблемы и способы их решить.

## 📑 Содержание

- [Установка](#📦-установка)
- [Экстры](#🧩-экстры)
- [Цветовые схемы](#🎨-цветовые-схемы)
- [Производительность](#⚡-производительность)
- [Кеймапы](#⌨️-кеймапы)
- [LSP](#🧠-lsp)
- [macOS](#🍎-macos)
- [Куда идти за помощью](#🆘-куда-идти-за-помощью)

## 📦 Установка

### Экстры lazyvimx не видны в :LazyExtras

1. Проверьте импорт boot-модуля:

   ```lua
   { "lazyvimx/nvim", name = "lazyvimx", import = "lazyvimx.boot" }
   ```

2. Проверьте, зарегистрирован ли источник экстр (должна быть запись с иконкой 󰬟):

   ```vim
   :lua vim.print(require("lazyvim.util.extras").sources)
   ```

3. Перезапустите Neovim и обновите плагины: `:Lazy update`.

### Плагины не устанавливаются

1. Проверьте версию: `:version` — нужен Neovim >= 0.10.0
2. Посмотрите лог: `:Lazy log`
3. Крайняя мера — переустановка плагинов с нуля:

   ```bash
   rm -rf ~/.local/share/nvim/lazy
   nvim
   ```

### Опции из setup() игнорируются

1. Опции должны попадать в спек плагина `"lazyvimx"` (поле `opts`) или в явный вызов
   `require("lazyvimx").setup()`
2. Проверьте результат слияния:

   ```vim
   :lua vim.print(require("lazyvimx").config)
   ```

## 🧩 Экстры

### Экстра включена, но не работает

1. Перезапустите Neovim — экстры применяются при старте
2. Проверьте зависимости. Некоторые экстры требуют другие:
   - `git.gitlab` → `ui.diff-view`
   - `dap.vscode-js` → экстра LazyVim `dap.core`
   - `test.jest` → экстра LazyVim `test.core`
   - `ui.better-progressbar` → терминал Ghostty
3. Посмотрите предупреждения: `:messages` (ищите «Missing extra»)
4. Проверьте, что экстра действительно загружена:

   ```vim
   :lua print(require("lazyvimx.util.general").has_extra("ui.winbar"))
   ```

### Группы буферов не появляются

1. Нужен оверрайд `add-groups` (входит в `core.overrides`):

   ```lua
   { import = "lazyvimx.extras.core.overrides" }
   ```

2. Проверьте конфиг:

   ```vim
   :lua vim.print(require("lazyvimx").config.bufferline_groups)
   ```

3. Проверьте паттерн на текущем файле:

   ```vim
   :lua print(vim.fn.expand("%"):match("%.tsx$"))
   ```

### Счётчики symbol-usage не показываются

1. LSP должен быть запущен: `:LspInfo`
2. Экстра `ui.symbol-usage` включена: `:LazyExtras`
3. В insert-режиме счётчики скрываются намеренно (`ui.better-insert-mode`)
4. Перезапустите LSP: `:LspRestart`

## 🎨 Цветовые схемы

### Тема не переключается вслед за системой

1. Оверрайд включён? Нужен `core.overrides` (или точечно
   `overrides.lazyvim.auto-switch-colorscheme-on-signal`)
2. Переключение срабатывает по autocmd `Signal` — процессу Neovim должен приходить сигнал от
   внешнего наблюдателя за темой ОС (см.
   [Настройка](CONFIGURATION.ru.md#автопереключение-вслед-за-системой))
3. Проверьте определение темы:

   ```vim
   :lua print(require("lazyvimx.util.general").theme_is_dark())
   ```

4. Проверка вручную:

   ```vim
   :lua vim.api.nvim_exec_autocmds("Signal", {})
   ```

### Выбирается не тот вариант темы

1. Посмотрите семейства:

   ```vim
   :lua vim.print(require("lazyvimx").config.colorscheme_households)
   ```

2. Что вернёт выбор варианта:

   ```vim
   :lua print(require("lazyvimx.util.general").get_flavor())
   ```

3. Если включена `perf.restore-last-colorscheme` — восстанавливается последний
   использованный вариант; смените тему вручную, и выбор запомнится

### Своя цветовая схема не применяется

1. Тема должна быть установлена как плагин (`lazy = false, priority = 1000`)
2. Семейство добавлено в `colorscheme_households`, имена вариантов начинаются с имени
   семейства
3. Кастомные хайлайты lazyvimx на сторонние темы не распространяются

## ⚡ Производительность

### Долгий старт

1. Профилируйте:

   ```bash
   nvim --startuptime startup.log
   sort -nk2 startup.log | tail -20
   ```

   и `:Lazy profile`

2. Включайте меньше экстр: `core.overrides` + точечные импорты вместо `core.all`

### Высокое потребление памяти

1. `{ import = "lazyvimx.extras.perf.stop-inactive-lsp" }` — остановка неактивных LSP
2. `{ import = "lazyvimx.extras.buf.delete-inactive" }` — закрытие старых буферов

### Лагает интерфейс

1. Анимации Snacks уже отключены оверрайдом `disable-animation` (входит в `core.overrides`)
2. Попробуйте выключить тяжёлые UI-экстры: `ui.scrollbar`, `ui.symbol-usage`,
   `ui.highlighted-colors`
3. Проверьте сам терминал — скорость отрисовки сильно различается

## ⌨️ Кеймапы

### Кеймапы lazyvimx не работают

1. `core.keys` включён?

   ```lua
   { import = "lazyvimx.extras.core.keys" }
   ```

2. Кеймапы привязаны к плагинам: нет плагина (экстра выключена) — нет кеймапа. Смотрите
   колонку «Требуется» на странице [Кеймапы](KEYBINDINGS.ru.md)
3. Кто занял клавишу:

   ```vim
   :verbose map <leader>cr
   ```

4. Leader — пробел: `:echo mapleader`

### Русская раскладка не работает

1. Экстра включена?

   ```lua
   { import = "lazyvimx.extras.motions.langmapper" }
   ```

2. Перезапустите Neovim после включения
3. Проверьте маппинг конкретной клавиши:

   ```vim
   :verbose map ц
   ```

### Конфликт кеймапов

Отключите кеймап lazyvimx в своём конфиге:

```lua
return {
	{
		"LazyVim/LazyVim",
		keys = {
			{ "<leader>cr", false },
		},
	},
}
```

## 🧠 LSP

### LSP не запускается

1. `:LspInfo` — статус клиентов
2. `:Mason` — установлен ли сервер
3. `:LspLog` — лог ошибок

### Диагностика не отображается

1. С экстрой `ui.better-diagnostic` родной virtual text отключён — диагностика показывается
   у курсора одной строкой
2. Проверьте конфигурацию:

   ```vim
   :lua vim.print(vim.diagnostic.config())
   ```

### На sshfs-маунте не работает LSP и автоформат

Так задумано: экстра `buf.remote-mounts` отключает LSP, автоформат, swap и undo для буферов
внутри `~/mnt` — ради скорости и сохранности прав файлов. Не подходит — выключите экстру.

## 🍎 macOS

### Тема системы не определяется

1. Проверьте команду:

   ```bash
   defaults read -g AppleInterfaceStyle
   ```

   В тёмном режиме вернёт «Dark», в светлом — ошибку (это нормально)

2. Проверьте из Neovim:

   ```vim
   :lua print(require("lazyvimx.util.general").theme_is_dark())
   ```

### Файлы удаляются мимо корзины

Установите утилиту `trash`:

```bash
brew install trash
```

Без неё neo-tree удаляет файлы обычным способом.

### Chezmoi-синхронизация не срабатывает

1. Утилита установлена? `which chezmoi`
2. Синхронизация срабатывает по событию `LazyUpdate` — то есть после `:Lazy update`
3. Оверрайд входит в `core.overrides`; точечно:

   ```lua
   { import = "lazyvimx.overrides.lazyvim.auto-apply-chezmoi-on-lazy-update" }
   ```

## 🆘 Куда идти за помощью

1. [FAQ](FAQ.ru.md)
2. [Issues на GitHub](https://github.com/lazyvimx/nvim/issues)
3. [Обсуждение в Telegram](https://t.me/aimuzov_dotfiles)

В issue приложите:

- версию Neovim (`:version`) и ОС
- шаги воспроизведения на минимальном конфиге:

  ```lua
  local lazy_opts = {
  	spec = {
  		{ "lazyvimx/nvim", name = "lazyvimx", import = "lazyvimx.boot" },
  		{ import = "lazyvimx.extras.core.all" },
  	},
  }
  ```

- сообщения об ошибках: `:Lazy log`, `:messages`

## 🐞 Отладка

```vim
" Модули спеков
:lua vim.print(require("lazy.core.config").spec.modules)

" Конфиг lazyvimx
:lua vim.print(require("lazyvimx").config)

" Профилирование
:Lazy profile

" Автокоманды интеграций
:autocmd Signal
:autocmd User LazyUpdate
```
