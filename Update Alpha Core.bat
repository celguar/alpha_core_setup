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
if not exist "%mainfolder%\alpha_python\get-pip.py" (
echo    Python Pip module missing!
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
:core_download
echo    Downloading Update...
ping -n 3 127.0.0.1>nul
if exist "%mainfolder%\alpha_core_master.zip" del "%mainfolder%\alpha_core_master.zip"
"%mainfolder%\alpha_tools\wget.exe" -q --show-progress "https://github.com/The-Alpha-Project/alpha-core/archive/refs/heads/master.zip" -O "%mainfolder%\alpha_core_master.zip"
rem curl -m -LJO https://github.com/The-Alpha-Project/alpha-core/archive/refs/heads/master.zip
:core_extract
rmdir /Q /S "%mainfolder%\alpha_core"
cls
more < "%mainfolder%\alpha_tools\header_install.txt"
echo.
echo    Extracting Update...
ping -n 3 127.0.0.1>nul
rem tar -xf alpha-core-master.zip "%mainfolder%"
"%mainfolder%\alpha_tools\7za.exe" -y -spf e "%mainfolder%\alpha_core_master.zip" > nul
rename "%mainfolder%\alpha-core-master" "alpha_core"

:end_download
cls
more < "%mainfolder%\alpha_tools\header_install.txt"
echo.
echo    Extraction Complete!
ping -n 3 127.0.0.1>nul

:database_update
cls
more < "%mainfolder%\alpha_tools\header_install.txt"
echo.
echo    Updating Alpha Core DB...
ping -n 3 127.0.0.1>nul
echo.
cd "%mainfolder%\alpha_tools"
echo    Starting MariaDB...
ping -n 3 127.0.0.1>nul
start "" /min "%mainfolder%\alpha_tools\start_mariadb.bat"
cd "%mainfolder%"
:update_world
echo.
echo    Updating World DB...
ping -n 3 127.0.0.1>nul
"%mainfolder%\alpha_mariadb\bin\mariadb.exe" --user=root --password=pwd --port=3306 alpha_world -e "source alpha_core\etc\databases\world\updates\updates.sql"
:update_realm
echo.
echo    Updating Realm DB...
ping -n 3 127.0.0.1>nul
"%mainfolder%\alpha_mariadb\bin\mariadb.exe" --user=root --password=pwd --port=3306 alpha_realm -e "source alpha_core\etc\databases\realm\updates\updates.sql"
:update_dbc
echo.
echo    Updating Dbc DB...
ping -n 3 127.0.0.1>nul
"%mainfolder%\alpha_mariadb\bin\mariadb.exe" --user=root --password=pwd --port=3306 alpha_dbc -e "source alpha_core\etc\databases\dbc\updates\updates.sql"
:set_server_localhost
echo.
echo    Setting Address to 127.0.0.1...
ping -n 3 127.0.0.1>nul
"%mainfolder%\alpha_mariadb\bin\mariadb.exe" --user=root --password=pwd --port=3306 -e "UPDATE `alpha_realm`.`realmlist` SET `realm_name` = 'Alpha Core', `proxy_address`='127.0.0.1', `realm_address`='127.0.0.1' WHERE  `realm_id`=1";
:end_db_install
cls
more < "%mainfolder%\alpha_tools\header_install.txt"
echo.
echo    Alpha Core DB Updated!
ping -n 3 127.0.0.1>nul
echo.
echo    Stopping MariaDB...
ping -n 3 127.0.0.1>nul
cd "%mainfolder%\alpha_tools"
start "" /min "%mainfolder%\alpha_tools\stop_mariadb.bat"
cd "%mainfolder%"

:config_rename
cls
more < "%mainfolder%\alpha_tools\header_install.txt"
if exist "%mainfolder%\alpha_core\etc\config\config.yml" goto set_server_localhost
echo.
echo    Renaming Config...
ping -n 3 127.0.0.1>nul
echo.
echo    config.yml.dist --^> config.yml
ping -n 3 127.0.0.1>nul
if exist "%mainfolder%\alpha_core\etc\config\config.yml.dist" rename "%mainfolder%\alpha_core\etc\config\config.yml.dist" "config.yml"
rem xcopy /y "%mainfolder%\alpha_core\etc\config\config.yml.dist" "%mainfolder%\alpha_core\etc\config\config.yml">nul

:set_server_localhost
cls
more < "%mainfolder%\alpha_tools\header_install.txt"
echo.
echo    Setting Config to 127.0.0.1...
ping -n 3 127.0.0.1>nul
"%mainfolder%\alpha_tools\fart.exe" "%mainfolder%\alpha_core\etc\config\config.yml" "host: 0.0.0.0" "host: 127.0.0.1"

:set_gm_acc_default
cls
more < "%mainfolder%\alpha_tools\header_install.txt"
echo.
echo    Setting Config to 127.0.0.1...
echo.
echo    Setting GM acc as default...
ping -n 3 127.0.0.1>nul
"%mainfolder%\alpha_tools\fart.exe" "%mainfolder%\alpha_core\etc\config\config.yml" "auto_create_gm_accounts: False" "auto_create_gm_accounts: True"

:fix_python_paths
rem cls
rem more < "%mainfolder%\alpha_tools\header_install.txt"
cls
more < "%mainfolder%\alpha_tools\header_install.txt"
echo.
echo    Setting Config to 127.0.0.1...
echo.
echo    Setting GM acc as default...
echo.
echo    Fixing Python Path...
ping -n 3 127.0.0.1>nul
set properpath=%mainfolder%
set "properpath=%properpath:\=/%"
"%mainfolder%\alpha_tools\fart.exe" -C "%mainfolder%\alpha_core\main.py" "from time import sleep" "from time import sleep\r\n\r\nimport sys\r\nsys.path.insert(0, 'path_placeholder')"
"%mainfolder%\alpha_tools\fart.exe" "%mainfolder%\alpha_core\main.py" "path_placeholder" "%properpath%/alpha_core/"

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
