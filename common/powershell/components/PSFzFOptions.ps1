# replace 'Ctrl+t' and 'Ctrl+r' with your preferred bindings:
Set-PsFzfOption -PSReadlineChordReverseHistory 'Ctrl+shift+r'
Set-PsFzfOption -PSReadlineChordProvider 'Ctrl+d'
# I'm not using Tab completion via fzf ATM
# Set-PSReadLineKeyHandler -Key Tab -ScriptBlock { Invoke-FzfTabCompletion }
