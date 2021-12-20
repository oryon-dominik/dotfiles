#!/usr/bin/env pwsh

$files = Get-ChildItem "."
foreach ($f in $files){
    if ($f.Name -Like "*.flac") {
        $outfile = '.\WAV\' + $f.BaseName + '.wav';
        ffmpeg -i $f.Name $outfile
    } else {
        Write-Host "$f.Name is not a flac file. Skipping."
    }
}
