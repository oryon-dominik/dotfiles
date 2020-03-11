
# inspired by https://github.com/rajivharris/Set-PsEnv
function LoadDotEnv {
    param($dotenv = "$env:DEN_ROOT\.local\.env")

    # does env exist?
    if (!( Test-Path $dotenv)) {
        Throw "could not open local environment settings: $dotenv"
    }

    $environment_variables = Get-Content $dotenv -ErrorAction Stop

    foreach ($line in $environment_variables) {
        if ($line.StartsWith("#")) { continue };
        if ($line.Trim()) {
            $line = $line.Replace("`"","")
            $kvp = $line -split "=",2
            if ($PSCmdlet.ShouldProcess("$($kvp[0])", "set value $($kvp[1])")) {
                [Environment]::SetEnvironmentVariable($kvp[0].Trim(), $kvp[1].Trim(), "Process") | Out-Null
            }
        }
    }

}

LoadDotEnv
