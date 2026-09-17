# Частые вопросы (FAQ)

> [!TIP]
> **🇬🇧 English version:** [FAQ.md](FAQ.md)

## 📑 Содержание

- [Общее](#💬-общее)
- [Установка](#📦-установка)
- [Настройка](#⚙️-настройка)
- [Экстры](#🧩-экстры)
- [Производительность](#⚡-производительность)
- [Интеграции](#🔗-интеграции)

## 💬 Общее

### Что такое lazyvimx?

Слой улучшений для [LazyVim](https://github.com/LazyVim/LazyVim): 50 опциональных экстр и 39
оверрайдов плагинов. LazyVim остаётся основой, lazyvimx добавляет полировку интерфейса и
воркфлоу — и только то, что вы включили.

### Чем lazyvimx отличается от LazyVim?

lazyvimx **расширяет** LazyVim, а не заменяет:

- **LazyVim** — фундамент: продуманная базовая конфигурация Neovim
- **lazyvimx** — надстройка: доводка UI, навигация, git-воркфлоу, русская раскладка

Всё, что умеет LazyVim, продолжает работать как раньше.

### Можно ли использовать lazyvimx без LazyVim?

Нет. lazyvimx построен поверх LazyVim и требует его — это не самостоятельная конфигурация.

### Насколько это стабильно?

Проект следует semver и обновляется регулярно. Все экстры опциональны — что не включено, то
не влияет.

### Как обновлять?

Как обычные плагины:

```vim
:Lazy update
```

История изменений — в файле [CHANGELOG](../CHANGELOG.md).

## 📦 Установка

### Минимальные требования

- **Neovim** >= 0.10.0
- **Git** (для lazy.nvim)

LazyVim установится автоматически.

### Как установить?

См. [Быстрый старт](../README.ru.md#быстрый-старт) в README: создать `init.lua` с импортом
`lazyvimx.boot`, запустить Neovim — остальное произойдёт само.

### Можно ли перейти с готового конфига LazyVim?

Да, lazyvimx совместим с существующими конфигурациями LazyVim:

1. Сделайте бэкап: `cp -r ~/.config/nvim ~/.config/nvim.backup`
2. Замените спек LazyVim в `init.lua` на импорт `lazyvimx.boot`
3. Перезапустите Neovim

Ваши плагины из `lua/plugins/` продолжат работать.

### Куда класть свои плагины?

Туда же, куда и в LazyVim — в `~/.config/nvim/lua/plugins/`:

```lua
-- ~/.config/nvim/lua/plugins/my-plugin.lua
return {
	"author/plugin-name",
	opts = {},
}
```

## ⚙️ Настройка

### Как настроить lazyvimx?

Через `opts` в спеке плагина или `setup()`:

```lua
require("lazyvimx").setup({
	colorscheme = "catppuccin",
	bufferline_groups = {
		["React"] = "%.tsx$",
	},
})
```

Все опции — на странице [Настройка](CONFIGURATION.ru.md).

### Как сменить цветовую схему?

```lua
require("lazyvimx").setup({ colorscheme = "tokyonight" })
```

Или напрямую: `:colorscheme tokyonight-storm`.

### Как работает автопереключение темы?

lazyvimx определяет светлый/тёмный режим системы и берёт соответствующий вариант из
«семейства» темы (`colorscheme_households`). Для переключения на лету нужен внешний
наблюдатель, посылающий процессу Neovim сигнал — подробности в
[Настройка](CONFIGURATION.ru.md#🎨-цветовые-схемы).

### Можно ли отключить часть оверрайдов?

Да — вместо `core.overrides` импортируйте категории выборочно:

```lua
{ import = "lazyvimx.overrides.lazyvim" },
{ import = "lazyvimx.overrides.snacks" },
-- bufferline пропускаем
{ import = "lazyvimx.overrides.other" },
```

## 🧩 Экстры

### Что такое экстра?

Опциональный модуль с готовой настройкой одной фичи. Например:

- `ui.better-diagnostic` — диагностика одной строкой у курсора
- `motions.langmapper` — русская раскладка
- `git.gitlab` — ревью GitLab MR

Все 50 — на странице [Экстры](EXTRAS.ru.md).

### Как включить экстру?

**Через UI** (рекомендуется): `:LazyExtras`, секция lazyvimx с иконкой 󰬟, `x` для включения,
перезапуск.

**Через конфиг:**

```lua
{ import = "lazyvimx.extras.ui.better-diagnostic" },
```

**Всё сразу:**

```lua
{ import = "lazyvimx.extras.core.all" },
```

### Нужно ли включать всё?

Нет. Разумные варианты:

- минимальный — только `core.overrides`
- полный — `core.all`
- свой — оверрайды плюс отдельные экстры по вкусу

### С каких экстр начать?

- `core.overrides` — доводка всех плагинов
- `ui.better-diagnostic` — читаемая диагностика
- `ui.better-float` — единый стиль окон
- `motions.langmapper` — если печатаете на русской раскладке
- `git.conflicts` — если случаются конфликты

### Можно ли написать свою экстру?

Да — это обычный файл со спеком lazy.nvim, см.
[Архитектура](ARCHITECTURE.ru.md#🧱-как-расширять) и
[Гайд контрибьютора](../CONTRIBUTING.ru.md).

## ⚡ Производительность

### lazyvimx тормозит?

Нет. Всё грузится лениво, выключенные экстры не существуют для lazy.nvim вовсе. Влияние на
старт минимально и растёт только с числом включённых экстр.

### Как ускорить?

1. Включайте только нужное — `core.overrides` вместо `core.all`
2. Профилируйте: `:Lazy profile` и `nvim --startuptime startup.log`
3. `perf.stop-inactive-lsp` и `buf.delete-inactive` подчищают память в долгих сессиях

## 🔗 Интеграции

### Работает ли с VSCode Neovim?

Да, режим VSCode включается автоматически (`vim.g.vscode`): синхронизация индикатора режима,
адаптированные кеймапы, нативное переименование. Готовый пример —
[examples/vscode-user](../examples/vscode-user/).

### Работает ли с chezmoi?

Да: после `:Lazy update` лок-файлы автоматически добавляются в chezmoi, если утилита
установлена. Подробности — на странице [Настройка](CONFIGURATION.ru.md#chezmoi).

### Работает ли на Linux/Windows?

Работает. Замечания:

- определение темы системы есть на macOS и Linux (gsettings); на Windows — нет
- корзина в neo-tree — через утилиту `trash` (есть — используется, нет — обычное удаление)

### Можно ли подключить свою цветовую схему?

Да — добавьте своё семейство в `colorscheme_households`
([формат](CONFIGURATION.ru.md#🎨-цветовые-схемы)). Но кастомные хайлайты lazyvimx есть только для
Catppuccin, Tokyo Night и Nord.

## ❓ Остались вопросы?

- 📖 [Документация](./)
- 🔧 [Решение проблем](TROUBLESHOOTING.ru.md)
- 💬 [Обсуждение в Telegram](https://t.me/aimuzov_dotfiles)
- 🐛 [Сообщить о проблеме](https://github.com/lazyvimx/nvim/issues)
