@echo off
echo Shutting down the MySQL server.
"..\alpha_mariadb\bin\mysqladmin.exe" -u root -ppwd shutdown
exit