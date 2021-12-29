#!/usr/bin/env pwsh

Write-Host "Converting all Flac in current directory to WAV."
$files = Get-ChildItem "."
foreach ($f in $files){
    if ($f.Name -Like "*.flac") {
        $outfile = '.\WAV\' + $f.BaseName + '.wav';
        ffmpeg -i $f.Name $outfile
    } else {
        Write-Host "$f.Name is not a flac file. Skipping."
    }
}
