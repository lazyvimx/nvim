# Примеры конфигураций lazyvimx

Готовые конфигурации под разные сценарии. В каждой директории — `init.lua`, который можно
скопировать в `~/.config/nvim/init.lua` и запустить Neovim.

## Какой выбрать

### [Minimal](minimal/)

Только оверрайды плагинов, без экстр. Для тех, кто хочет контролировать каждую включённую
фичу и добавлять экстры по одной.

### [Full-Featured](full-featured/)

`core.all`: все 50 экстр, 39 оверрайдов и кеймапы. Для тех, кто хочет всё из коробки.

### [VSCode User](vscode-user/)

Для расширения VSCode Neovim: только движения и инструменты кода, без UI-экстр — интерфейс
рисует VSCode.

### [Russian Keyboard](russian-keyboard/)

С langmapper: Vim-движения работают на русской раскладке без переключения.

## Как использовать

1. Выберите пример под свой сценарий
2. Скопируйте его `init.lua` в `~/.config/nvim/init.lua`
3. Запустите Neovim — всё установится само
4. Донастройте при желании

## Кастомизация

Любой пример расширяется одинаково.

**Свои плагины** — `~/.config/nvim/lua/plugins/my-plugin.lua`:

```lua
return {
	"author/plugin-name",
	opts = {},
}
```

**Больше экстр** — через `:LazyExtras` или в конфиге:

```lua
{ import = "lazyvimx.extras.ui.winbar" },
{ import = "lazyvimx.extras.git.gitlab" },
```

**Опции lazyvimx** — `~/.config/nvim/lua/plugins/lazyvimx.lua`:

```lua
return {
	"lazyvimx/nvim",
	name = "lazyvimx",
	opts = {
		colorscheme = "tokyonight",
		bufferline_groups = {
			["Tests"] = "%.test%.",
		},
	},
}
```

## Нужна помощь?

- [Настройка](../docs/CONFIGURATION.ru.md)
- [Справочник экстр](../docs/EXTRAS.ru.md)
- [FAQ](../docs/FAQ.ru.md)
- [Решение проблем](../docs/TROUBLESHOOTING.ru.md)
