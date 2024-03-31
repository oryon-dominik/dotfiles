function Greet() {
    param (
        [string]$pronoun = "commander"
    )

    try {
        lolcat "$env:DOTFILES/common/powershell/intro" # Print the intro-graphic via rust-lolcat
    } catch {
        Write-Host "Greeting failed. Dotfiles setup and essential software installation probably not complete. Consult the docs. Exiting."
        Exit 1
    }
    # Fortune Cookie
    . "$env:DOTFILES/common/powershell/components/Fortunes.ps1"
    echo " " | lolcat
    echo "Welcome on board $pronoun $env:username!" | lolcat
    echo " " | lolcat
    fortune('anarchism.txt') | lolcat
    echo " " | lolcat
}
