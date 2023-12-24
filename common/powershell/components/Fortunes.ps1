# Inspired from: https://www.bgreco.net/fortune
function fortune($datfilename = 'fortunes.dat') {
    # Datfiles and text fortunes should be read from the common fortunes directory.
    # ! If you want to use a different directory, you'll have to modify this.
    $path = Join-Path -Path $env:DOTFILES -Childpath "common/fortunes/$datfilename"
    if(!(Test-Path $Path)) {
        throw "Fortune File not found: $path"
        return
    }

    $extension = [IO.Path]::GetExtension($path)
        if ($extension -eq ".dat" ) {
            $dat = New-Object "System.IO.FileStream" $path, 'Open', 'Read', 'Read'
            [byte[]] $dat_bytes = New-Object byte[] 8
            $seek = (Get-Random -Minimum 7 -Maximum ([int]($dat.Length / 4))) * 4
            [void] $dat.Seek($seek, 'Begin')
            [void] $dat.Read($dat_bytes, 0, 8)
            [array]::Reverse($dat_bytes) # Swap endianness
            $start = [BitConverter]::ToInt32($dat_bytes, 4)
            $end = [BitConverter]::ToInt32($dat_bytes, 0)
            $len = $end - $start - 2
            $dat.Close()

            $cookie = New-Object "System.IO.FileStream" $Path, 'Open', 'Read', 'Read'
            [byte[]] $cookie_bytes = New-Object byte[] $len
            [void] $cookie.Seek($start, 'Begin')
            [void] $cookie.Read($cookie_bytes, 0, $len)
            # If you want multiple encodings you'll have to do it yourself
            [System.Text.Encoding]::UTF8.GetString($cookie_bytes)
            $cookie.Close()
        } else {
            [System.IO.File]::ReadAllText($Path) -replace "`r`n", "`n" -split "`n%`n" | Get-Random
        }
}
