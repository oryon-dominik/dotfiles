# Load dotenv from provided path
function LoadDotEnv {
    [CmdletBinding(SupportsShouldProcess = $true, ConfirmImpact = 'Low')]
    Param([parameter(Mandatory=$true)] [String[]] $dotenv)

    # does env exist?
    if (!( Test-Path $dotenv)) {
        Write-Warning "Failed to load environment variables from $dotenv"
    }
    else {
        $environment_variables = Get-Content $dotenv -ErrorAction Stop
        foreach ($line in $environment_variables) {
            if (!$line) { continue };
            if ($line.StartsWith("#")) { continue };  # skip comments
            if ($line.Trim()) {
                $line = $line.Replace("`"","")
                $kvp = $line -split "=",2
                if ($PSCmdlet.ShouldProcess("$($kvp[0])", "set value $($kvp[1])")) {
                    [Environment]::SetEnvironmentVariable($kvp[0].Trim(), $kvp[1].Trim(), "Process") | Out-Null
                }
            }
        }
    }
}
