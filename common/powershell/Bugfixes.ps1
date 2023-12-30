#!/usr/bin/env pwsh
# Bugfix for TabExpansion ignoring tilde since pwsh > 7.4
# https://github.com/PowerShell/PowerShell/issues/20750#issuecomment-1822567842
#experimental response to https://github.com/PowerShell/PowerShell/issues/20750
function TabExpansion2 {
    <# Options include:
        RelativeFilePaths - [bool]
            Always resolve file paths using Resolve-Path -Relative.
            The default is to use some heuristics to guess if relative or absolute is better.

    To customize your own custom options, pass a hashtable to CompleteInput, e.g.
            return [System.Management.Automation.CommandCompletion]::CompleteInput($inputScript, $cursorColumn,
                @{ RelativeFilePaths=$false }
    #>
    [CmdletBinding(DefaultParameterSetName = 'ScriptInputSet')]
    [OutputType([System.Management.Automation.CommandCompletion])]
    param (
        [Parameter(ParameterSetName = 'ScriptInputSet', Mandatory = $true, Position = 0)]
        [string] $inputScript,

        [Parameter(ParameterSetName = 'ScriptInputSet', Position = 1)]
        [int] $cursorColumn = $inputScript.Length,

        [Parameter(ParameterSetName = 'AstInputSet', Mandatory = $true, Position = 0)]
        [System.Management.Automation.Language.Ast] $ast,

        [Parameter(ParameterSetName = 'AstInputSet', Mandatory = $true, Position = 1)]
        [System.Management.Automation.Language.Token[]] $tokens,

        [Parameter(ParameterSetName = 'AstInputSet', Mandatory = $true, Position = 2)]
        [System.Management.Automation.Language.IScriptPosition] $positionOfCursor,

        [Parameter(ParameterSetName = 'ScriptInputSet', Position = 2)]
        [Parameter(ParameterSetName = 'AstInputSet', Position = 3)]
        [Hashtable] $options = $null
    )
    end   {
        # if the we're using AstInput parameter set or the cursor is at the end of line do what the standard function does.
        if     ($psCmdlet.ParameterSetName -eq 'AstInputSet')    {return [System.Management.Automation.CommandCompletion]::CompleteInput($ast, $tokens, $positionOfCursor, $options)}
        elseif ($cursorColumn -ne $inputScript.Length)           {return [System.Management.Automation.CommandCompletion]::CompleteInput($inputScript,  $cursorColumn,     $options)}
        # if we are given ~~ or (e.g.) ~~My with no trailing expand it to [matching] named default directories paths
        elseif ($inputScript -match ' ~~(\w*)$')                 {return [System.Management.Automation.CommandCompletion]::new(
            [System.Management.Automation.CompletionResult[]](
                [enum]::GetNames([System.Environment+SpecialFolder]).
                    where({$_ -like "$($Matches[1])*" -and [System.Environment]::GetFolderPath($_) }).
                        foreach({[System.Management.Automation.CompletionResult]::new(" ~~$_")}) |
                            Sort-Object -Property CompletionText
            ) ,
            0,
            ($inputScript.Length - $Matches[0].Length ),
            $Matches[0].Length
        )}
        else {
            # if we are given (e.g.) ~~MyDocuments\ with a trailing \ and the name is a default directory replace it with the directory e.g. ~~windows\ [tab] will tab expand things in c:\windows
            if ($inputScript -match ' ~~(\w+)\\(\S*)$' -and $Matches[1] -in [enum]::GetNames([System.Environment+SpecialFolder])  ) {
                $is2 = ($inputScript -replace '~~(\w+)\\(\S*)$',  [System.Environment]::GetFolderPath($Matches[1])) + "\" + $Matches[2]
            }
            else {
                $global:is2 = ((($inputScript -replace
                    '(?<= "?''?)~(?=\S*$)',$env:USERPROFILE)         -replace  # replace ~ if preceded by space and optional quotes, and followed by more path (but not with spaces or closing ')
                    '(?<= "?''?[\.\\]*)\.(?=\.\.\S*$)','..\')        -replace  # transform ... into ..\.. (for as many extra dots as there are before the last 2)
                    '(?<= "?''?[\.\\]+)\.$|(?<= )\.$', '.\')         -replace #  add \ to a path ending in $
                    '(?<= )\^$',(Split-Path -Parent -Path $profile.CurrentUserAllHosts)  #replace ^ with profile directory
            }
            $global:result = [System.Management.Automation.CommandCompletion]::CompleteInput($is2,  $is2.Length,     $options)
            $global:result.ReplacementLength = $result.Replacementlength + $inputScript.Length - $is2.Length
   # poss solution to  https://github.com/PowerShell/PowerShell/issues/20765
    #         if ($result.CompletionMatches.Where({$_.CompletionText -match '\($' } )) {
     #            $result.CompletionMatches = [System.Management.Automation.CompletionResult[]] $result.CompletionMatches.ForEach({
      #              [System.Management.Automation.CompletionResult]::new(($_.CompletionText -replace '\($',''),$_.ListItemText,$_.resultType,    $_.ToolTip)
       #         })
        #    }
            return $result
        }
    }
}
