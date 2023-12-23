#!/usr/bin/env pwsh


function DownloadAndInstallGoogleDriveFileStream {

    $installed = @()

    # Add google-drive-filestream.
    # https://dl.google.com/drive-file-stream/GoogleDriveSetup.exe

    # Define the URL of the Google Drive File Stream setup executable
    $googleDriveFilestreamURL = "https://dl.google.com/drive-file-stream/GoogleDriveSetup.exe"
    # Define the path where you want to save the downloaded file
    $googleDriveFilestreamdownloadPath = "$env:USERPROFILE\Downloads\GoogleDriveSetup.exe"
    # Download the file
    Invoke-WebRequest -Uri $googleDriveFilestreamurl -OutFile $googleDriveFilestreamdownloadPath

    # Install Google Drive File Stream
    # Start-Process -FilePath $googleDriveFilestreamdownloadPath -ArgumentList "/S /v/qn" -Wait
    # Start-Process -FilePath $googleDriveFilestreamdownloadPath -Wait
    $installed += "GoogleDrive FileStream"

    # Optionally, you can remove the downloaded file after installation
    # Remove-Item -Path $googleDriveFilestreamdownloadPath

    return $installed
}
