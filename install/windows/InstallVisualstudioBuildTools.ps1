#!/usr/bin/env pwsh


function InstallVisualstudioBuildTools {

    $installed = @()
    # Install visual studio build tools.
    # https://aka.ms/vs/17/release/vs_BuildTools.exe

    Write-Host "Installing Visual Studio, please wait... you should customize your visualstudio installation to include all neccessary build tools (C/C++)."

    # Define the URL of the Visual Studio Build Tools setup executable
    $visualStudioBuildToolsURL = "https://aka.ms/vs/17/release/vs_BuildTools.exe"
    # Define the path where you want to save the downloaded file
    $visualStudioBuildToolsdownloadPath = "$env:USERPROFILE\Downloads\vs_BuildTools.exe"
    # Download the file
    Invoke-WebRequest -Uri $visualStudioBuildToolsurl -OutFile $visualStudioBuildToolsdownloadPath

    # Install Visual Studio Build Tools
    # Start-Process -FilePath $visualStudioBuildToolsdownloadPath -ArgumentList "/S /v/qn" -Wait
    # Start-Process -FilePath $visualStudioBuildToolsdownloadPath -Wait
    $installed += "Visual Studio Build Tools"

    # Optionally, you can remove the downloaded file after installation
    # Remove-Item -Path $visualStudioBuildToolsdownloadPath

    return $installed
}
