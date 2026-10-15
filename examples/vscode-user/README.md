# Конфигурация lazyvimx для VSCode

Для пользователей расширения [VSCode Neovim](https://marketplace.visualstudio.com/items?itemName=asvetliakov.vscode-neovim):
только то, что имеет смысл внутри VSCode.

## Что включено

- ✅ Базовый LazyVim
- ✅ Оверрайды lazyvimx (включая режим VSCode)
- ✅ Экстры движений — все работают в VSCode
- ✅ Комментирование с контекстом
- ❌ UI-экстры — интерфейс рисует VSCode
- ❌ LSP, отладка, тесты — этим занимается VSCode

## Возможности

### Режим VSCode

Включается автоматически, когда Neovim запущен внутри VSCode:

- индикатор режима синхронизируется со статус-баром (расширение `neovim-ui-indicator`)
- `<leader>cr` вызывает нативное переименование VSCode
- конфликтующие кеймапы отключены

### Движения

- **spider** — `w`/`b`/`e` по подсловам
- **sibling-swap** — перестановка параметров: `<C-,>` / `<C-.>`
- **treewalker** — навигация по дереву: `<C-A-h/j/k/l>`
- **treesj** — разбить/склеить блок: `<leader>ct`
- **stay-in-place** — курсор не убегает при сдвигах

## Установка

1. Установите расширение VSCode Neovim
2. Скопируйте `init.lua` в `~/.config/nvim/init.lua`
3. Укажите пути в settings.json VSCode:

    ```json
    {
      "vscode-neovim.neovimExecutablePaths.darwin": "/opt/homebrew/bin/nvim",
      "vscode-neovim.neovimInitVimPaths.darwin": "~/.config/nvim/init.lua"
    }
    ```

4. Перезапустите VSCode

## Рекомендуемые расширения VSCode

- **neovim-ui-indicator** — режим Neovim в статус-баре
- **GitLens** — вместо git-экстр lazyvimx
- **Error Lens** — inline-диагностика (аналог `ui.better-diagnostic`)

## Чего не включать

UI-экстры, explorer, DAP и LSP-экстры в VSCode не нужны — эти роли выполняет сам VSCode.
Многие экстры и так отключают себя при `vim.g.vscode`.
