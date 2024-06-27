function yarn {
    # Powershell equivalent of https://github.com/yarnpkg/yarn/issues/7620
    # Fix yarn without args will display help instead of initialising directly into the current directory.

    if ($env:DOTFILES_SKIP_YARN -eq $true) {
        Write-Host "Skipping yarn, env:DOTFILES_SKIP_YARN is $true."
        return
    }

    # $yarn = "$(yarn global bin)\yarn.cmd"
    # To avoid the slow call to yarn global bin.. hardcode it's global path -
    # we are depending on nvm (installed via scoop) here, so 'yarn global bin' might be wrong anyways.
    $yarn = "$env:SCOOP\apps\yarn\current\bin\yarn.cmd" -replace ' ', '` '  # escape spaces in program files path
    # $yarn = "$env:SCOOP\persist\nvm\nodejs\nodejs\yarn.cmd" -replace ' ', '` '  # escape spaces in program files path
    # 

    if ($args.Count -lt 1) {
        # No real arguments provided, display help
        Invoke-Expression -Command "$yarn --help"
    } else {
        # Execute the yarn command with the arguments provided
        Invoke-Expression -Command "$yarn $args"
    }
}

function npm {
    $npm = "$env:SCOOP\persist\nvm\nodejs\nodejs\npm.cmd" -replace ' ', '` '  # escape spaces in program files path
    # Execute the npm command with the arguments provided
    Invoke-Expression -Command "$npm $args"
}
