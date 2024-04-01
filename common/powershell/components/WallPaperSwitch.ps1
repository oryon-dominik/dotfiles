function Set-WallPaper { # Thanks to https://www.joseespitia.com/2017/09/15/set-wallpaper-powershell-function/
    param (
        [parameter(Mandatory=$True)][string]$ImagePath,
        [parameter(Mandatory=$False)][ValidateSet('Fill', 'Fit', 'Stretch', 'Tile', 'Center', 'Span')][string]$Style
    )
    $WallpaperStyle = Switch ($Style) {
        "Fill" {"10"}
        "Fit" {"6"}
        "Stretch" {"2"}
        "Tile" {"0"}
        "Center" {"0"}
        "Span" {"22"}
    
    }
    if ($Style -eq "Tile") { $Tile = 1 } else { $Tile = 0 }
    New-ItemProperty -Path "HKCU:\Control Panel\Desktop" -Name WallpaperStyle -PropertyType String -Value $WallpaperStyle -Force
    New-ItemProperty -Path "HKCU:\Control Panel\Desktop" -Name TileWallpaper -PropertyType String -Value $Tile -Force

    Add-Type -TypeDefinition @"
    using System; using System.Runtime.InteropServices;
    public class Params {
        [DllImport("User32.dll",CharSet=CharSet.Unicode)]
        public static extern int SystemParametersInfo (
            Int32 uAction,
            Int32 uParam,
            String lpvParam,
            Int32 fuWinIni
        );
    }
"@
    $SPI_SETDESKWALLPAPER = 0x0014
    $UpdateIniFile = 0x01
    $SendChangeEvent = 0x02
    $fWinIni = $UpdateIniFile -bor $SendChangeEvent
    $ret = [Params]::SystemParametersInfo($SPI_SETDESKWALLPAPER, 0, $ImagePath, $fWinIni)
}

function ToggleWallpaper {
    $currentWP = Split-Path (Get-ItemProperty -Path 'HKCU:\Control Panel\Desktop' -Name Wallpaper).Wallpaper -Leaf
    if ($currentWP -eq "surface.png") {
        Set-WallPaper -Image "$env:DOTFILES_SHARED/files/images/conosole/console_zen.png" -Style Fill
    } else {
        Set-WallPaper -Image "$env:DOTFILES_SHARED/files/images/backgrounds/surface.png" -Style Fill
    }
}
