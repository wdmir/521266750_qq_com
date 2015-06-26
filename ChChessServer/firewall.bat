cho off
cls
set var=9300

:continue
set /a var+=1

echo add port %var%
netsh firewall add portopening TCP %var%  ftp_data_%var%

if %var% lss 9310 goto continue

echo complete
pause