:: Restart the windows printer service to avoid hanging printer jobs.
net stop spooler
del /Q /F /S "%windir%\System32\spool\PRINTERS\*.*"
net start spooler
