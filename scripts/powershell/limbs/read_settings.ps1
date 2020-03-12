# reads settings
# for a deeper inside into hashtable-objects have a look in # https://powershellexplained.com/2016-10-28-powershell-everything-you-wanted-to-know-about-pscustomobject/

# requirements:
# $env:DEN_ROOT has to be set to your configs location
# the paths below may be customized
$env_settings = "\local\env_settings.json"
$env_settings_example = "\local\env_settings_example.json"

$settings_path = Join-Path -Path $env:DEN_ROOT -ChildPath $env_settings
if (Test-Path $settings_path) { 
    $settings = Get-Content -Raw -Path $settings_path | ConvertFrom-Json
}
else{
    $settings_path = Join-Path -Path $env:DEN_ROOT -ChildPath $env_settings_example
    if (Test-Path $settings_path) { 
        $settings = Get-Content -Raw -Path $settings_path | ConvertFrom-Json
    }
    else {
        Write-Host "settings $settings_path not found"
    }
}
