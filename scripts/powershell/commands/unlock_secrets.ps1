# imports secret key from $env_DEN_ROOT/.secrets
# to add a secret:
# - store the key inside a file in <.secrets> with its pure value
# - name the file exactly how you want the ENV-name to be

Param(
    [Parameter( Mandatory = $true)]
    $is_admin = "False"    
)


if($is_admin) {

    # TODO: move the decrypt from sysstart to a function

    $files = Get-ChildItem "$env:DEN_ROOT\.secrets\"

    foreach ($_ in $files){
        $name = [System.IO.Path]::GetFileNameWithoutExtension($_.FullName)
        $key = [IO.File]::ReadAllText($_.FullName)
        Set-Item "env:$name" $key
    }
    
    $name = ''
    $key = ''

    # TODO: move the encrypt from sysstart to a function

}
