# requirements: git installed

# init respositories to update
$respository_path = Join-Path -Path $env:DEN_ROOT -ChildPath $settings.git_pulls
if (Test-Path -Path $respository_path -PathType Leaf) { 
    $repositories = Get-Content $respository_path
}
else{
        Write-Host "repository config $respository_path not found"
        $repositories = $null
}

# read current path
$current_path = $pwd

# pull the repos
foreach($repo in $repositories) 
{ 
    Write-Host "Updating" $repo
    Set-Location -Path $repo
    $git_command = "git pull"
    Invoke-Expression $git_command
}

$repositories = $null

Write-Host "Switching back to your directory.."
Set-Location -Path $current_path
Write-Host "Repository update finished :-)"
