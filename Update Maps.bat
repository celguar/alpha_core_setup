@echo off
:beginning
mode con: cols=40 lines=30
SET NAME=Alpha Core Updater
TITLE %NAME%
set mainfolder=%CD%
cls
more < "%mainfolder%\alpha_tools\header_install.txt"
echo.
rem CHECK EVERYTHING
if not exist "%mainfolder%\alpha_core" (
echo    Alpha Core missing!
goto error_install
)
if not exist "%mainfolder%\alpha_core\etc\config\config.yml" (
echo    Config is missing!
goto error_install
)
:core_download
echo    Downloading Maps...
ping -n 3 127.0.0.1>nul
rem if exist "%mainfolder%\alpha_core\etc\maps.7z" del "%mainfolder%\alpha_core\etc\maps.7z"
if exist "%mainfolder%\alpha_core\etc\maps.7z" goto maps_extract
"%mainfolder%\alpha_tools\wget.exe" -q --show-progress "https://github.com/celguar/alpha_core_setup/releases/download/v1.0/maps.7z" -O "%mainfolder%\alpha_core\etc\maps.7z"
:maps_extract
rmdir /Q /S "%mainfolder%\alpha_core\etc\maps"
cls
more < "%mainfolder%\alpha_tools\header_install.txt"
echo.
echo    Extracting Maps...
ping -n 3 127.0.0.1>nul
cd "%mainfolder%\alpha_core\etc"
"%mainfolder%\alpha_tools\7za.exe" -y -spf e "%mainfolder%\alpha_core\etc\maps.7z" > nul
cd "%mainfolder%"

:end_download
cls
more < "%mainfolder%\alpha_tools\header_install.txt"
echo.
echo    Extraction Complete!
ping -n 3 127.0.0.1>nul

:set_server_localhost
cls
more < "%mainfolder%\alpha_tools\header_install.txt"
echo.
echo    Setting Config to use maps...
ping -n 3 127.0.0.1>nul
"%mainfolder%\alpha_tools\fart.exe" "%mainfolder%\alpha_core\etc\config\config.yml" "use_map_tiles: False" "use_map_tiles: True"

:end_install
cls
more < "%mainfolder%\alpha_tools\header_install.txt"
echo.
echo    Maps Update Complete!
ping -n 5 127.0.0.1>nul
exit

:error_install
echo.
echo    Run Setup Alpha Core.bat
echo    to complete installation
ping -n 5 127.0.0.1>nul
exit
