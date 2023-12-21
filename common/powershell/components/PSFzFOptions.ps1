# replace 'Ctrl+t' and 'Ctrl+r' with your preferred bindings:
Set-PsFzfOption -PSReadlineChordProvider 'Ctrl+d' -PSReadlineChordReverseHistory 'Ctrl+shift+r'
# I'm not using Tab completion via fzf ATM
# Set-PSReadLineKeyHandler -Key Tab -ScriptBlock { Invoke-FzfTabCompletion }
