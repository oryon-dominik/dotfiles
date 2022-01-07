# Hooks for WindowsSubsystemForLinux (WSL) commands
Import-WslCommand "sed", "awk", "base64"

# mkae sure-bash-completion is installed in WSL
# $ sudo apt install bash-completion

$WslDefaultParameterValues = @{}
$WslDefaultParameterValues["-d"] = "Ubuntu-20.04"
$WslDefaultParameterValues["sed"] = ""
$WslDefaultParameterValues["awk"] = ""

# $WslEnvironmentVariables["<name>"] = "<value>"
