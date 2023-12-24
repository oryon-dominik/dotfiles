# PSReadLine provides fish-like auto-suggestions, included in powershell since 7.2
Import-Module PSReadLine
$PSReadLineOptions = @{
    PredictionSource = "HistoryAndPlugin"
    # PredictionViewStyle = "ListView"
    # HistorySaveStyle = "SaveIncrementally"
    HistoryNoDuplicates = $true
    EditMode = "Windows"
}
Set-PSReadLineOption @PSReadLineOptions

Set-PSReadLineKeyHandler -Key Ctrl+e -ScriptBlock {  # ! we are using mcFly instead
    [Microsoft.PowerShell.PSConsoleReadLine]::SwitchPredictionView()
}
Set-PSReadLineKeyHandler -Key Shift+Tab -ScriptBlock {
    [Microsoft.PowerShell.PSConsoleReadLine]::AcceptSuggestion()
    Set-PSReadLineOption -PredictionViewStyle "InlineView"
}
Set-PSReadLineKeyHandler -Key Shift+End -Function AcceptSuggestion
Set-PSReadLineKeyHandler -Key RightArrow `
                         -BriefDescription ForwardCharAndAcceptNextSuggestionWord `
                         -LongDescription "Move cursor one character to the right in the current editing line and accept the next word in suggestion when it's at the end of current editing line" `
                         -ScriptBlock {
    param($key, $arg)

    $line = $null
    $cursor = $null
    [Microsoft.PowerShell.PSConsoleReadLine]::GetBufferState([ref]$line, [ref]$cursor)

    if ($cursor -lt $line.Length) {
        [Microsoft.PowerShell.PSConsoleReadLine]::ForwardChar($key, $arg)
    } else {
        [Microsoft.PowerShell.PSConsoleReadLine]::AcceptNextSuggestionWord($key, $arg)
    }
}
