# Hooks for WindowsSubsystemForLinux (WSL) commands
# https://github.com/mikebattista/PowerShell-WSL-Interop

# Import-WslCommand "sed", "awk", "base64", "apt", "sudo", "objdump"
# TODO: Fix this. With the command chain from mcfly, that is obviously broken.

function strings {
    wsl strings $args
}

function sed {
    wsl sed $args
}

function awk {
    wsl awk $args
}


# assure bash-completion is installed in WSL
# $ sudo apt install bash-completion

$WslDefaultParameterValues = @{}
$WslDefaultParameterValues["-d"] = "Ubuntu-20.04"
$WslDefaultParameterValues["sed"] = ""
$WslDefaultParameterValues["awk"] = ""

# $WslEnvironmentVariables["<name>"] = "<value>"
