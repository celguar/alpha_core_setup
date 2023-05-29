@echo off
SET NAME=Alpha Core Server
TITLE %NAME%
COLOR 09

echo.
echo    Alpha Core - Server
echo.
echo    Stopping...
echo.
rem "..\alpha_python\python.exe" "%mainfolder%\alpha_core\main.py"
tasklist /FI "IMAGENAME eq python.exe" 2>NUL | find /I /N "python.exe">NUL
if "%ERRORLEVEL%"=="0" taskkill /f /im python.exe
exit