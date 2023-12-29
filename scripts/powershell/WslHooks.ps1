# Hooks for WindowsSubsystemForLinux (WSL) commands
Import-WslCommand "sed", "awk", "base64", "apt", "sudo", "strings", "objdump"
# TODO: fix the command chain from mcfly, that is obviously broken

# assure bash-completion is installed in WSL
# $ sudo apt install bash-completion

$WslDefaultParameterValues = @{}
$WslDefaultParameterValues["-d"] = "Ubuntu-20.04"
$WslDefaultParameterValues["sed"] = ""
$WslDefaultParameterValues["awk"] = ""

# $WslEnvironmentVariables["<name>"] = "<value>"
