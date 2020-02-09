
$files = Get-ChildItem "."
foreach ($f in $files){
    $outfile = '.\WAV\' + $f.BaseName + '.wav';
    ffmpeg -i $f.Name $outfile
}
