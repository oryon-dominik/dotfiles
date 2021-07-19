function download
    cd ~/downloads
    curl --location --remote-header-name --remote-name $argv
    cd -
end
