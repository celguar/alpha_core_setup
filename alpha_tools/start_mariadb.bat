@echo off
SET NAME=Alpha Core Database
TITLE %NAME%
COLOR 09

echo.
echo    Alpha Core - MariaDB Server
echo.

"..\alpha_mariadb\bin\mysqld" --console --max_allowed_packet=128M --port=3306
exit