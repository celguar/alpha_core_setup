@echo off
:beginning
mode con: cols=40 lines=30
SET NAME=Alpha Core Installer
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
:maps_download
if exist "%mainfolder%\alpha_core\etc\maps" (
echo    Maps already added!
ping -n 2 127.0.0.1>nul
goto set_server_maps
)
if not exist "%mainfolder%\alpha_downloads" mkdir "%mainfolder%\alpha_downloads"
if exist "%mainfolder%\alpha_downloads\maps.zip" goto maps_extract
echo    Downloading Maps...
ping -n 2 127.0.0.1>nul
"%mainfolder%\alpha_tools\wget.exe" -q --show-progress "https://github.com/celguar/alpha_core_setup/releases/download/v1.0/maps.zip" -O "%mainfolder%\alpha_downloads\maps.zip"
rem curl -L -o "%mainfolder%\alpha_core\etc\maps.zip" "https://github.com/celguar/alpha_core_setup/releases/download/v1.0/maps.zip"
:maps_extract
cls
more < "%mainfolder%\alpha_tools\header_install.txt"
echo.
echo    Extracting Maps...
ping -n 2 127.0.0.1>nul
cd "%mainfolder%\alpha_core\etc"
"%mainfolder%\alpha_tools\7za.exe" -y -spf e "%mainfolder%\alpha_downloads\maps.zip" > nul
rem tar -xf "%mainfolder%\alpha_core\etc\maps.zip" -C "%mainfolder%\alpha_core\etc"
cd "%mainfolder%"

:end_download
echo.
echo    Extraction Complete!
ping -n 2 127.0.0.1>nul

:set_server_maps
echo.
echo    Setting Config to use maps...
ping -n 2 127.0.0.1>nul
"%mainfolder%\alpha_tools\fart.exe" "%mainfolder%\alpha_core\etc\config\config.yml" "use_map_tiles: False" "use_map_tiles: True">nul

:end_install
echo.
echo    Maps Installation Complete!
ping -n 5 127.0.0.1>nul
exit

:error_install
echo.
echo    Run Setup Alpha Core.bat
echo    to complete installation
ping -n 5 127.0.0.1>nul
exit
