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
"%mainfolder%\alpha_tools\wget.exe" -q --show-progress "https://github.com/The-Alpha-Project/alpha-core/archive/refs/heads/master.zip" -O "%mainfolder%\alpha_downloads\alpha_core_master.zip"
rem curl -L -o "alpha_core_master.zip" "https://github.com/The-Alpha-Project/alpha-core/archive/refs/heads/master.zip"
:core_extract
rmdir /Q /S "%mainfolder%\alpha_core"
cls
more < "%mainfolder%\alpha_tools\header_install.txt"
echo.
echo    Extracting Update...
ping -n 2 127.0.0.1>nul
rem tar -xf alpha-core-master.zip "%mainfolder%"
"%mainfolder%\alpha_tools\7za.exe" -y -spf e "%mainfolder%\alpha_downloads\alpha_core_master.zip" > nul
rem tar -xf "alpha_core_master.zip"
rename "%mainfolder%\alpha-core-master" "alpha_core"

:end_core_update
echo.
echo    Alpha Core Updated!
ping -n 2 127.0.0.1>nul

:check_mariadb_path
if not exist "%mainfolder%\alpha_mariadb\portable_install_path.txt" goto fix_mariadb_path
set /p mariadb_install_path=<"%mainfolder%\alpha_mariadb\portable_install_path.txt"
:compare_mariadb_path
if "%mariadb_install_path%"=="%mainfolder%" goto database_update
:fix_mariadb_path
rem fix mariadb path
echo    MariaDB path changed!
ping -n 2 127.0.0.1>nul
echo.
echo    Fixing...
ping -n 2 127.0.0.1>nul
rem cd "%mainfolder%\mariadb\bin"
if not exist "%mainfolder%\alpha_mariadb\data" mkdir "%mainfolder%\alpha_mariadb\data"
rem "%mainfolder%\alpha_mariadb\bin\mysql_install_db.exe" --datadir="%mainfolder%\alpha_mariadb\data" --password=pwd
set properdbpath=%mainfolder%
set "properdbpath=%properdbpath:\=/%"
echo [mysqld] > "%mainfolder%\alpha_mariadb\data\my.ini"
echo datadir=%properdbpath%/alpha_mariadb/data >> "%mainfolder%\alpha_mariadb\data\my.ini"
echo [client] >> "%mainfolder%\alpha_mariadb\data\my.ini"
echo plugin-dir=%properdbpath%/alpha_mariadb/lib/plugin >> "%mainfolder%\alpha_mariadb\data\my.ini"
>"%mainfolder%\alpha_mariadb\portable_install_path.txt" echo %mainfolder%
echo.
echo    MariaDB Initialized!
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
"%mainfolder%\alpha_mariadb\bin\mysql.exe" --user=root --password=pwd --default-character-set=utf8 --port=3306 -e "drop database if exists alpha_world";
"%mainfolder%\alpha_mariadb\bin\mysql.exe" --user=root --password=pwd --default-character-set=utf8 --port=3306 -e "create database alpha_world";
"%mainfolder%\alpha_mariadb\bin\mysql.exe" --user=root --password=pwd --default-character-set=utf8 --port=3306 --database=alpha_world < "%mainfolder%\alpha_core\etc\databases\world\world.sql"
echo.
echo    Updating World DB...
ping -n 2 127.0.0.1>nul
"%mainfolder%\alpha_mariadb\bin\mysql.exe" --user=root --password=pwd --default-character-set=utf8 --port=3306 --database=alpha_world < "%mainfolder%\alpha_core\etc\databases\world\updates\updates.sql"
:update_realm
echo.
echo    Updating Realm DB...
ping -n 2 127.0.0.1>nul
"%mainfolder%\alpha_mariadb\bin\mysql.exe" --user=root --password=pwd --default-character-set=utf8 --port=3306 --database=alpha_realm < "%mainfolder%\alpha_core\etc\databases\realm\updates\updates.sql"
:update_dbc
echo.
echo    Updating Dbc DB...
ping -n 2 127.0.0.1>nul
"%mainfolder%\alpha_mariadb\bin\mysql.exe" --user=root --password=pwd --default-character-set=utf8 --port=3306 --database=alpha_dbc < "%mainfolder%\alpha_core\etc\databases\dbc\updates\updates.sql"
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
"%mainfolder%\alpha_tools\fart.exe" "%mainfolder%\alpha_core\etc\config\config.yml" "host: 0.0.0.0" "host: %current_server_address% #worldserver">nul

:set_gm_acc_default
echo.
echo    Setting GM acc as default...
ping -n 2 127.0.0.1>nul
"%mainfolder%\alpha_tools\fart.exe" "%mainfolder%\alpha_core\etc\config\config.yml" "auto_create_gm_accounts: False" "auto_create_gm_accounts: True">nul

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
"%mainfolder%\alpha_tools\fart.exe" "%mainfolder%\alpha_core\etc\config\config.yml" "use_map_tiles: False" "use_map_tiles: True">nul

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
