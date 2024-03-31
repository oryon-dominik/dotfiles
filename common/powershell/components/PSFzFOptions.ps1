# replace 'Ctrl+t' and 'Ctrl+r' with your preferred bindings:
try {
    Set-PsFzfOption -PSReadlineChordReverseHistory 'Ctrl+shift+r'
    Set-PsFzfOption -PSReadlineChordProvider 'Ctrl+d'
    # I'm not using Tab completion via fzf ATM
    # Set-PSReadLineKeyHandler -Key Tab -ScriptBlock { Invoke-FzfTabCompletion }

} catch [System.Management.Automation.CommandNotFoundException] {
    # error handling for non-existing module
    Write-Host "Set-PsFzfOption is not recognized. Skipping."
}
