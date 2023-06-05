@echo off
SET NAME=Alpha Core Server
TITLE %NAME%
COLOR 07

echo.
echo    Alpha Core - Server
echo.
echo    Starting...
echo.
"..\alpha_python\python.exe" "%mainfolder%\alpha_core\main.py"
exit