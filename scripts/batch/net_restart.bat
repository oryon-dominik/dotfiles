:: Restart the windows Host Network Service to avoid errors like:
:: "Ports are not available" and "An attempt was made to access a socket in a
:: way forbidden by its access permissions"
net stop hns
echo Restarting the Host Network Service...
net start hns
