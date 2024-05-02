@echo off
SET NAME=Alpha Core Map
TITLE %NAME%
COLOR 07

echo.
echo    Alpha Core - Map
echo.
echo    Starting...
echo.
"..\alpha_python\python.exe" "%mainfolder%\alpha_map\main.py"
exit