# Environment-Variables in powershell

> How-to set environment variables with powershell

## Usage

Add the absolute path you want to add into your global *path*-env as temporary environment variable

```powershell
$new_path = "C:\<somepath>"
```

Now extract the current machines path

```powershell
$system_path = [Environment]::GetEnvironmentVariable("PATH", "Machine")
```

or the local user-space path

```powershell
$user_env = [Environment]::GetEnvironmentVariable("PATH", "User")
```

Either add the `$new_path` permanently to user-space

```powershell
[Environment]::SetEnvironmentVariable("PATH", "$user_env;$new_path", "User")
```

or the machines space

```powershell
[Environment]::SetEnvironmentVariable("PATH", "$system_path;$new_path", "Machine")
```

You could also just add the path temporarily with

```powershell
$env:path += ";$new_path"
```
