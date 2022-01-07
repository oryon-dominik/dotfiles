
function cliTube {
    $cliTube_path = Join-Path -Path $script_location -ChildPath "\python\cliTube.py"
    if (!( Test-Path $cliTube_path)) {
        Write-Warning "could not find $cliTube_path"
        return
    }
    python $cliTube_path $args
}
Set-Alias -Name tube -Value cliTube -Description "Plays Youtube Search-Results"  # needs cliTube.py in $script_location


function hockey { # Plays Highlights from different hockey leagues.
    $nhl_path = Join-Path -Path $env:PROJECTS -ChildPath '\hockeytube\hockey.py'
    if (!( Test-Path $nhl_path)) {
        Write-Warning "could not find $nhl_path"
        return
    }
    python $nhl_path $args
}
function nhl {
    if (!$args) { $arguments = 0 } else { $arguments = $args }
    hockey --league "NHL" $arguments
}
function hawks {
    if (!$args) { $arguments = 0 } else { $arguments = $args }
    hockey --league "NHL" --team "Blackhawks" $arguments
}
Remove-Alias -Name del
function del {
    if (!$args) { $arguments = 0 } else { $arguments = $args }
    hockey --league "DEL" $arguments
}
function deg {
    if (!$args) { $arguments = 0 } else { $arguments = $args }
    hockey --league "DEL" --team "Düsseldorfer EG" $arguments
}
