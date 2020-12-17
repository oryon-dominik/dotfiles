# imports secret key from $env_DOTFILES/$settings.local_location/.secrets
# to add a secret:
# - store the key inside a file in <$settings.local_location/.secrets> with its pure value
# - name the file exactly how you want the ENV-name to be

Param(
    [Parameter( Mandatory = $true)]
    $is_admin = "False"
)


if($is_admin) {

    # TODO: move the decrypt from sysstart to a function

    $files_path = "$env:DOTFILES\local\.secrets\"
    if (!( Test-Path $files_path)) {
        Write-Warning "secrets not found. You probably did not finish your setup."
    }
    else {
        $files = Get-ChildItem $files_path
        foreach ($_ in $files){
            $name = [System.IO.Path]::GetFileNameWithoutExtension($_.FullName)
            $key = [IO.File]::ReadAllText($_.FullName)
            Set-Item "env:$name" $key
        }

        $name = ''
        $key = ''

        # TODO: move the encrypt from sysstart to a function
    }
}
