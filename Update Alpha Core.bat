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
if not exist "%mainfolder%\alpha_python" (
echo    Python missing!
goto error_install
)
if not exist "%mainfolder%\alpha_mariadb" (
echo    MariaDB missing!
goto error_install
)
if not exist "%mainfolder%\alpha_python\include" (
echo    Python packages missing!
goto error_install
)
if not exist "%mainfolder%\alpha_mariadb\data" (
echo    MariaDB Data missing!
goto error_install
)
if not exist "%mainfolder%\alpha_mariadb\data\alpha_world" (
echo    World DB missing!
goto error_install
)
if not exist "%mainfolder%\alpha_mariadb\data\alpha_realm" (
echo    Realm DB missing!
goto error_install
)
if not exist "%mainfolder%\alpha_mariadb\data\alpha_dbc" (
echo    Dbc DB missing!
goto error_install
)
if not exist "%mainfolder%\alpha_core\etc\config\config.yml" (
echo    Config is missing!
goto error_install
)
if not exist "%mainfolder%\alpha_downloads" mkdir "%mainfolder%\alpha_downloads"
:backup_maps
if exist "%mainfolder%\alpha_core\etc\maps" (
move "%mainfolder%\alpha_core\etc\maps" "%mainfolder%\alpha_downloads\maps">nul
)
:core_download
echo    Downloading Update...
echo.
ping -n 2 127.0.0.1>nul
if exist "%mainfolder%\alpha_downloads\alpha_core_master.zip" del "%mainfolder%\alpha_downloads\alpha_core_master.zip"
rem "%mainfolder%\alpha_tools\wget.exe" -q --show-progress "https://github.com/The-Alpha-Project/alpha-core/archive/refs/heads/master.zip" -O "%mainfolder%\alpha_core_master.zip"
curl -L -o "%mainfolder%\alpha_downloads\alpha_core_master.zip" "https://github.com/The-Alpha-Project/alpha-core/archive/refs/heads/master.zip"
:core_extract
rmdir /Q /S "%mainfolder%\alpha_core"
cls
more < "%mainfolder%\alpha_tools\header_install.txt"
echo.
echo    Extracting Update...
ping -n 2 127.0.0.1>nul
rem tar -xf alpha-core-master.zip "%mainfolder%"
rem "%mainfolder%\alpha_tools\7za.exe" -y -spf e "%mainfolder%\alpha_core_master.zip" > nul
tar -xf "%mainfolder%\alpha_downloads\alpha_core_master.zip"
rename "%mainfolder%\alpha-core-master" "alpha_core"

:end_core_update
echo.
echo    Alpha Core Updated!
ping -n 2 127.0.0.1>nul

:database_update
cls
more < "%mainfolder%\alpha_tools\header_install.txt"
echo.
echo    Updating Alpha Core DB...
ping -n 2 127.0.0.1>nul
echo.
cd "%mainfolder%\alpha_tools"
echo    Starting MariaDB...
ping -n 2 127.0.0.1>nul
start "" /min "%mainfolder%\alpha_tools\start_mariadb.bat"
cd "%mainfolder%"
:update_world
echo.
echo    Reinstalling World DB...
ping -n 2 127.0.0.1>nul
"%mainfolder%\alpha_mariadb\bin\mariadb.exe" --user=root --password=pwd --port=3306 -e "drop database if exists alpha_world";
"%mainfolder%\alpha_mariadb\bin\mariadb.exe" --user=root --password=pwd --port=3306 -e "create database alpha_world";
"%mainfolder%\alpha_mariadb\bin\mariadb.exe" --user=root --password=pwd --port=3306 alpha_world -e "source alpha_core\etc\databases\world\world.sql"
echo.
echo    Updating World DB...
ping -n 2 127.0.0.1>nul
"%mainfolder%\alpha_mariadb\bin\mariadb.exe" --user=root --password=pwd --port=3306 alpha_world -e "source alpha_core\etc\databases\world\updates\updates.sql"
:update_realm
echo.
echo    Updating Realm DB...
ping -n 2 127.0.0.1>nul
"%mainfolder%\alpha_mariadb\bin\mariadb.exe" --user=root --password=pwd --port=3306 alpha_realm -e "source alpha_core\etc\databases\realm\updates\updates.sql"
:update_dbc
echo.
echo    Updating Dbc DB...
ping -n 2 127.0.0.1>nul
"%mainfolder%\alpha_mariadb\bin\mariadb.exe" --user=root --password=pwd --port=3306 alpha_dbc -e "source alpha_core\etc\databases\dbc\updates\updates.sql"
:set_server_localhost
rem echo.
rem echo    Setting Address to 127.0.0.1...
rem ping -n 3 127.0.0.1>nul
rem "%mainfolder%\alpha_mariadb\bin\mariadb.exe" --user=root --password=pwd --port=3306 -e "UPDATE `alpha_realm`.`realmlist` SET `realm_name` = 'Alpha Core', `proxy_address`='127.0.0.1', `realm_address`='127.0.0.1' WHERE  `realm_id`=1";
:end_db_install
echo.
echo    Alpha Core DB Updated!
ping -n 2 127.0.0.1>nul
echo.
echo    Stopping MariaDB...
ping -n 2 127.0.0.1>nul
cd "%mainfolder%\alpha_tools"
start "" /min "%mainfolder%\alpha_tools\stop_mariadb.bat"
cd "%mainfolder%"

:config_update
set current_server_address=127.0.0.1
if exist "%mainfolder%\alpha_mariadb\server_address.txt" set /p current_server_address=<"%mainfolder%\alpha_mariadb\server_address.txt"
rem update backup original config
if not exist "%mainfolder%\alpha_core\backup" mkdir "%mainfolder%\alpha_core\backup"
xcopy /y "%mainfolder%\alpha_core\etc\config\config.yml.dist" "%mainfolder%\alpha_core\backup">nul
cls
more < "%mainfolder%\alpha_tools\header_install.txt"
if exist "%mainfolder%\alpha_core\etc\config\config.yml" goto set_server_localhost
echo.
echo    Renaming Config...
ping -n 2 127.0.0.1>nul
echo.
echo    config.yml.dist --^> config.yml
ping -n 2 127.0.0.1>nul
if exist "%mainfolder%\alpha_core\etc\config\config.yml.dist" rename "%mainfolder%\alpha_core\etc\config\config.yml.dist" "config.yml"

:set_server_localhost
echo.
echo    Applying old address...
ping -n 2 127.0.0.1>nul
rem "%mainfolder%\alpha_tools\fart.exe" "%mainfolder%\alpha_core\etc\config\config.yml" "host: 0.0.0.0" "host: 127.0.0.1"
setlocal enableextensions disabledelayedexpansion

    set "search=host: 0.0.0.0"
    set "replace=host: %current_server_address% #worldserver"

    set "textFile=%mainfolder%\alpha_core\etc\config\config.yml"

    for /f "delims=" %%i in ('type "%textFile%" ^& break ^> "%textFile%" ') do (
        set "line=%%i"
        setlocal enabledelayedexpansion
        >>"%textFile%" echo(!line:%search%=%replace%!
        endlocal
    )
endlocal

:set_gm_acc_default
echo.
echo    Setting GM acc as default...
ping -n 2 127.0.0.1>nul
rem "%mainfolder%\alpha_tools\fart.exe" "%mainfolder%\alpha_core\etc\config\config.yml" "auto_create_gm_accounts: False" "auto_create_gm_accounts: True"
setlocal enableextensions disabledelayedexpansion

    set "search=auto_create_gm_accounts: False"
    set "replace=auto_create_gm_accounts: True"

    set "textFile=%mainfolder%\alpha_core\etc\config\config.yml"

    for /f "delims=" %%i in ('type "%textFile%" ^& break ^> "%textFile%" ') do (
        set "line=%%i"
        setlocal enabledelayedexpansion
        >>"%textFile%" echo(!line:%search%=%replace%!
        endlocal
    )
endlocal

:restore_maps
if not exist "%mainfolder%\alpha_downloads\maps" goto backup_main_py    
cls
more < "%mainfolder%\alpha_tools\header_install.txt"
echo.
echo    Restoring Maps...
ping -n 2 127.0.0.1>nul
rem remove exising folder
if exist "%mainfolder%\alpha_core\etc\maps" rmdir /Q /S "%mainfolder%\alpha_core\etc\maps"
move "%mainfolder%\alpha_downloads\maps" "%mainfolder%\alpha_core\etc\maps">nul

:set_server_maps
echo.
echo    Setting Config to use maps...
ping -n 2 127.0.0.1>nul
rem "%mainfolder%\alpha_tools\fart.exe" "%mainfolder%\alpha_core\etc\config\config.yml" "use_map_tiles: False" "use_map_tiles: True"
setlocal enableextensions disabledelayedexpansion

    set "search=use_map_tiles: False"
    set "replace=use_map_tiles: True"

    set "textFile=%mainfolder%\alpha_core\etc\config\config.yml"

    for /f "delims=" %%i in ('type "%textFile%" ^& break ^> "%textFile%" ') do (
        set "line=%%i"
        setlocal enabledelayedexpansion
        >>"%textFile%" echo(!line:%search%=%replace%!
        endlocal
    )
endlocal

:backup_main_py
if not exist "%mainfolder%\alpha_core\backup" mkdir "%mainfolder%\alpha_core\backup">nul
if not exist "%mainfolder%\alpha_core\backup\main.py" xcopy /y "%mainfolder%\alpha_core\main.py" "%mainfolder%\alpha_core\backup">nul

:end_install
cls
more < "%mainfolder%\alpha_tools\header_install.txt"
echo.
echo    Alpha Core Update Complete!
ping -n 5 127.0.0.1>nul
exit

:error_install
echo.
echo    Run Setup Alpha Core.bat
echo    to complete installation
ping -n 5 127.0.0.1>nul
exit
