# Гифка для EXTRAS: ui.better-live-rename.
#
#   cd docs/demo && sh warmup.sh && vhs tapes/ui-better-live-rename.tape
#
# Сценарий: <leader>cr открывает поле с живым превью, новое имя видно
# во всех вхождениях ещё до подтверждения. Клавиши шлёт drive.sh.

Output gifs/ui-better-live-rename.gif
Output videos/ui-better-live-rename.mp4

Set Shell "bash"
Set FontFamily "JBMonoNL Demo Light"
Set LineHeight 1.55
Set FontSize 15
Set Width 1200
Set Height 604
Set Padding 0
Set Theme "Catppuccin Macchiato"
Set TypingSpeed 150ms
Set Framerate 24

Hide
Type "export XDG_CONFIG_HOME=/Users/aimuzov/Projects/lazyvimx/nvim/docs/demo/profile/config XDG_DATA_HOME=/Users/aimuzov/Projects/lazyvimx/nvim/docs/demo/profile/data XDG_STATE_HOME=/Users/aimuzov/Projects/lazyvimx/nvim/docs/demo/profile/state XDG_CACHE_HOME=/Users/aimuzov/Projects/lazyvimx/nvim/docs/demo/profile/cache"
Enter
Type "rm -f /tmp/vhs-demo.sock; (sh drive.sh 3 5 ' cr' 3 'ciwcart_total' 2.5 '<CR>' >/dev/null 2>&1 &)"
Enter
Type "cd work && DEMO_EXTRAS=ui.better-live-rename nvim --listen /tmp/vhs-demo.sock app.lua"
Enter
Sleep 20s
Type "3G"
Sleep 1s
Type "gg03w"
Sleep 500ms
Type "3G"
Sleep 500ms
Type "gg03w"
Sleep 1s
Show
Sleep 16s
Hide
Type ":qa!"
Enter
