@echo off
:beginning
mode con: cols=40 lines=30
SET NAME=Alpha Core Address Changer
TITLE %NAME%
set mainfolder=%CD%
cls
more < "%mainfolder%\alpha_tools\header_install.txt"
echo.
rem CHECK EVERYTHING
tasklist /FI "IMAGENAME eq python.exe" 2>NUL | find /I /N "python.exe">NUL
if "%ERRORLEVEL%"=="0" (
echo    Alpha Core is running!
ping -n 2 127.0.0.1>nul
echo.
echo    Stop server before changing address!
ping -n 5 127.0.0.1>nul
exit
)
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

:check_mariadb_path
if not exist "%mainfolder%\alpha_mariadb\portable_install_path.txt" goto fix_mariadb_path
set /p mariadb_install_path=<"%mainfolder%\alpha_mariadb\portable_install_path.txt"
:compare_mariadb_path
if "%mariadb_install_path%"=="%mainfolder%" goto db_start
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

:db_start
if exist "%mainfolder%\alpha_mariadb\server_address.txt" del "%mainfolder%\alpha_mariadb\server_address.txt"
cls
more < "%mainfolder%\alpha_tools\header_install.txt"
echo.
cd "%mainfolder%\alpha_tools"
echo    Starting MariaDB...
ping -n 2 127.0.0.1>nul
start "" /min "%mainfolder%\alpha_tools\start_mariadb.bat"
cd "%mainfolder%"

:db_load_address
echo.
echo    Checking address in DB...
ping -n 2 127.0.0.1>nul
"%mainfolder%\alpha_mariadb\bin\mysql.exe" --user=root --password=pwd --default-character-set=utf8 --port=3306 -e "SELECT `proxy_address` INTO OUTFILE '../server_address.txt' FROM `alpha_realm`.`realmlist` WHERE `realm_id`=1";
if not exist "%mainfolder%\alpha_mariadb\server_address.txt" (
echo.
echo    Failed to load address!
ping -n 2 127.0.0.1>nul
goto db_stop
)
set /p current_server_address=<"%mainfolder%\alpha_mariadb\server_address.txt"
echo.
echo    Current server address: %current_server_address%
ping -n 2 127.0.0.1>nul
echo.
set /P new_server_address=Enter address (X=cancel):
if "%new_server_address%"=="" goto error_empty_address
if "%new_server_address%"=="x" goto db_stop
if "%new_server_address%"=="X" goto db_stop
>"%mainfolder%\alpha_mariadb\server_address.txt" echo %new_server_address%

cls
more < "%mainfolder%\alpha_tools\header_install.txt"
echo.
echo    New server address: %new_server_address%
ping -n 2 127.0.0.1>nul

:db_apply_address
echo.
echo    Applying address to DB...
ping -n 2 127.0.0.1>nul
"%mainfolder%\alpha_mariadb\bin\mysql.exe" --user=root --password=pwd --default-character-set=utf8 --port=3306 -e "UPDATE `alpha_realm`.`realmlist` SET `proxy_address`='%new_server_address%', `realm_address`='%new_server_address%' WHERE  `realm_id`=1";

:config_apply_address
echo.
echo    Applying address to config...
ping -n 2 127.0.0.1>nul
"%mainfolder%\alpha_tools\fart.exe" "%mainfolder%\alpha_core\etc\config\config.yml" "host: %current_server_address% #worldserver" "host: %new_server_address% #worldserver">nul

:end_install
echo.
echo    Done!
ping -n 2 127.0.0.1>nul
goto db_stop

:error_empty_address
cls
more < "%mainfolder%\alpha_tools\header_install.txt"
echo.
echo    Empty Address entered!
ping -n 5 127.0.0.1>nul
goto db_stop

:error_install
echo.
echo    Run Setup Alpha Core.bat
echo    to complete installation
ping -n 5 127.0.0.1>nul
goto db_stop

:db_stop
echo.
echo    Stopping MariaDB...
ping -n 2 127.0.0.1>nul
cd "%mainfolder%\alpha_tools"
start "" /min "%mainfolder%\alpha_tools\stop_mariadb.bat"
cd "%mainfolder%"
exit
