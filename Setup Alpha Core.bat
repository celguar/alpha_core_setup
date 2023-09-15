@echo off
:beginning
mode con: cols=40 lines=30
SET NAME=Alpha Core Installer
TITLE %NAME%
set mainfolder=%CD%
cls
more < "%mainfolder%\alpha_tools\header_install.txt"
if not exist "%mainfolder%\alpha_downloads" mkdir "%mainfolder%\alpha_downloads"
:core_download
if exist "%mainfolder%\alpha_core" goto python_download
if exist "%mainfolder%\alpha_downloads\alpha_core_master.zip" goto core_extract
echo.
echo    Downloading Alpha Core...
ping -n 2 127.0.0.1>nul
"%mainfolder%\alpha_tools\wget.exe" -q --show-progress "https://github.com/The-Alpha-Project/alpha-core/archive/refs/heads/master.zip" -O "%mainfolder%\alpha_downloads\alpha_core_master.zip"
rem curl -L -o "alpha_core_master.zip" "https://github.com/The-Alpha-Project/alpha-core/archive/refs/heads/master.zip"
:core_extract
if exist "%mainfolder%\alpha_core" goto python_download
cls
more < "%mainfolder%\alpha_tools\header_install.txt"
echo.
echo    Extracting Alpha Core...
ping -n 2 127.0.0.1>nul
"%mainfolder%\alpha_tools\7za.exe" -y -spf e "%mainfolder%\alpha_downloads\alpha_core_master.zip" > nul
rem tar -xf "alpha_core_master.zip"
rename "%mainfolder%\alpha-core-master" "alpha_core"
rem CHECK INSTALL
if not exist "%mainfolder%\alpha_core" (
echo    Failed to install Alpha Core!
ping -n 2 127.0.0.1>nul
echo.
echo    Possible vcredist++ missing
ping -n 2 127.0.0.1>nul
echo.
echo    Exiting installer...
ping -n 3 127.0.0.1>nul
exit
)
:python_download
if exist "%mainfolder%\alpha_downloads\python_3.9.9_win64.zip" goto python_extract
cls
more < "%mainfolder%\alpha_tools\header_install.txt"
echo.
echo    Downloading Python 3.9...
ping -n 2 127.0.0.1>nul
"%mainfolder%\alpha_tools\wget.exe" -q --show-progress "https://www.python.org/ftp/python/3.9.9/python-3.9.9-embed-amd64.zip" -O "%mainfolder%\alpha_downloads\python_3.9.9_win64.zip"
rem curl -L -o "python_3.9.9_win64.zip" "https://www.python.org/ftp/python/3.9.9/python-3.9.9-embed-amd64.zip"
:python_extract
if exist "%mainfolder%\alpha_python" goto mariadb_download
cls
more < "%mainfolder%\alpha_tools\header_install.txt"
echo.
echo    Extracting Python...
ping -n 2 127.0.0.1>nul
if not exist "%mainfolder%\alpha_python" mkdir "%mainfolder%\alpha_python"
"%mainfolder%\alpha_tools\7za.exe" -y -spf e -o"%mainfolder%\alpha_python" "%mainfolder%\alpha_downloads\python_3.9.9_win64.zip" > nul
rem tar -xf "%mainfolder%\python_3.9.9_win64.zip" -C "%mainfolder%\alpha_python"
if not exist "%mainfolder%\alpha_python\python.exe" (
echo    Failed to install Python!
ping -n 2 127.0.0.1>nul
echo.
echo    Possible vcredist++ missing
ping -n 2 127.0.0.1>nul
echo.
echo    Exiting installer...
ping -n 3 127.0.0.1>nul
exit
)
:mariadb_download
if exist "%mainfolder%\alpha_mariadb" goto python_install
rem if exist "%mainfolder%\mariadb_10.11.3_win64.zip" goto mariadb_extract
if exist "%mainfolder%\alpha_downloads\mariadb_10.4.12_win64.zip" goto mariadb_extract
cls
more < "%mainfolder%\alpha_tools\header_install.txt"
echo.
rem echo    Downloading MariaDB 10.11.3...
echo    Downloading MariaDB 10.4.12...
ping -n 2 127.0.0.1>nul
"%mainfolder%\alpha_tools\wget.exe" -q --show-progress "https://archive.mariadb.org/mariadb-10.4.12/winx64-packages/mariadb-10.4.12-winx64.zip" -O "%mainfolder%\alpha_downloads\mariadb_10.4.12_win64.zip"
rem curl -L -o "mariadb_10.11.3_win64.zip" "https://mirrors.xtom.ee/mariadb/mariadb-10.11.3/winx64-packages/mariadb-10.11.3-winx64.zip"
:mariadb_extract
cls
more < "%mainfolder%\alpha_tools\header_install.txt"
echo.
echo    Extracting MariaDB...
ping -n 2 127.0.0.1>nul
rem "%mainfolder%\alpha_tools\7za.exe" -y -spf e "%mainfolder%\mariadb_10.11.3_win64.zip" > nul
"%mainfolder%\alpha_tools\7za.exe" -y -spf e "%mainfolder%\alpha_downloads\mariadb_10.4.12_win64.zip" > nul
rem tar -xf "%mainfolder%\mariadb_10.11.3_win64.zip"
rem rename "%mainfolder%\mariadb-10.11.3-winx64" "alpha_mariadb"
rename "%mainfolder%\mariadb-10.4.12-winx64" "alpha_mariadb"
if not exist "%mainfolder%\alpha_mariadb" (
echo    Failed to install MariaDB!
ping -n 2 127.0.0.1>nul
echo.
echo    Possible vcredist++ missing
ping -n 2 127.0.0.1>nul
echo.
echo    Exiting installer...
ping -n 3 127.0.0.1>nul
exit
)

:end_download
cls
more < "%mainfolder%\alpha_tools\header_install.txt"
echo.
echo    Extraction Complete!
ping -n 2 127.0.0.1>nul

:python_install
if exist "%mainfolder%\alpha_python\api-ms-win-core-path-l1-1-0.dll" goto pip_install
cls
more < "%mainfolder%\alpha_tools\header_install.txt"
echo.
echo    Preparing Python...
ping -n 2 127.0.0.1>nul
:compatibility_dll
cls
more < "%mainfolder%\alpha_tools\header_install.txt"
echo.
echo    Downloading Windows 7
echo    compatibility module for Python...
ping -n 2 127.0.0.1>nul
"%mainfolder%\alpha_tools\wget.exe" -q --show-progress "https://github.com/nalexandru/api-ms-win-core-path-HACK/releases/download/0.3.1/api-ms-win-core-path-blender-0.3.1.zip" -O "%mainfolder%\alpha_downloads\api-ms-win-core-path-blender-0.3.1.zip"
echo.
echo    Extracting...
ping -n 2 127.0.0.1>nul
cd "%mainfolder%\alpha_downloads"
"%mainfolder%\alpha_tools\7za.exe" -y -spf e "%mainfolder%\alpha_downloads\api-ms-win-core-path-blender-0.3.1.zip" > nul
xcopy /y "%mainfolder%\alpha_downloads\api-ms-win-core-path-blender\x64\api-ms-win-core-path-l1-1-0.dll" "%mainfolder%\alpha_python">nul
rem del "%mainfolder%\alpha_downloads\api-ms-win-core-path-blender-0.3.1.zip"
rmdir /Q /S "%mainfolder%\alpha_downloads\api-ms-win-core-path-blender"
cd "%mainfolder%"

:python_prepare
cls
more < "%mainfolder%\alpha_tools\header_install.txt"
echo.
echo    Preparing Python...
:pip_download
if exist "%mainfolder%\alpha_downloads\get-pip.py" goto pip_install
cls
more < "%mainfolder%\alpha_tools\header_install.txt"
echo.
echo    Preparing Python...
echo.
echo    Downloading Pip...
ping -n 2 127.0.0.1>nul
"%mainfolder%\alpha_tools\wget.exe" -q "https://bootstrap.pypa.io/get-pip.py" -O "%mainfolder%\alpha_downloads\get-pip.py"
rem curl -L -o "%mainfolder%\alpha_python\get-pip.py" "https://bootstrap.pypa.io/get-pip.py"
:pip_install
if exist "%mainfolder%\alpha_python\Scripts\pip3.exe" goto pip_requirements
cls
more < "%mainfolder%\alpha_tools\header_install.txt"
echo.
echo    Preparing Python...
echo.
echo    Downloading Pip...
echo.
echo    Installing Pip...
ping -n 2 127.0.0.1>nul
cd "%mainfolder%\alpha_python"
"%mainfolder%\alpha_python\python.exe" "%mainfolder%\alpha_downloads\get-pip.py"
cd "%mainfolder%"
:pip_requirements
if exist "%mainfolder%\alpha_python\include" goto mariadb_install
cls
more < "%mainfolder%\alpha_tools\header_install.txt"
echo.
echo    Preparing Python...
echo.
echo    Downloading Pip...
echo.
echo    Installing Pip...
echo.
echo    Enabling Pip...
ping -n 2 127.0.0.1>nul
"%mainfolder%\alpha_tools\fart.exe" "%mainfolder%\alpha_python\python39._pth" "#import site" "import site"
cls
more < "%mainfolder%\alpha_tools\header_install.txt"
echo.
echo    Preparing Python...
echo.
echo    Downloading Pip...
echo.
echo    Installing Pip...
echo.
echo    Enabling Pip...
echo.
echo    Pip Enabled!
ping -n 2 127.0.0.1>nul
cls
more < "%mainfolder%\alpha_tools\header_install.txt"
echo.
echo    Installing Python Requirements...
ping -n 2 127.0.0.1>nul
cd "%mainfolder%\alpha_core"
"%mainfolder%\alpha_python\python.exe" -m pip install -r requirements.txt
cd "%mainfolder%"
cls
more < "%mainfolder%\alpha_tools\header_install.txt"
echo.
echo    Python Requirements Installed!
ping -n 2 127.0.0.1>nul

:mariadb_install
rem save path to file
>"%mainfolder%\alpha_mariadb\portable_install_path.txt" echo %mainfolder%
if exist "%mainfolder%\alpha_mariadb\data\mysql" goto database_install
cls
more < "%mainfolder%\alpha_tools\header_install.txt"
echo.
echo    Preparing MariaDB...
ping -n 2 127.0.0.1>nul
echo.
rem cd "%mainfolder%\mariadb\bin"
if not exist "%mainfolder%\alpha_mariadb\data" mkdir "%mainfolder%\alpha_mariadb\data"
"%mainfolder%\alpha_mariadb\bin\mysql_install_db.exe" --datadir="%mainfolder%\alpha_mariadb\data" --password=pwd
rem save path to file
>"%mainfolder%\alpha_mariadb\portable_install_path.txt" echo %mainfolder%
cls
more < "%mainfolder%\alpha_tools\header_install.txt"
echo.
echo    MariaDB Initialized!
ping -n 2 127.0.0.1>nul

:database_install
cls
more < "%mainfolder%\alpha_tools\header_install.txt"
echo.
echo    Installing Alpha Core DB...
ping -n 2 127.0.0.1>nul
echo.
cd "%mainfolder%\alpha_tools"
echo    Starting MariaDB...
ping -n 2 127.0.0.1>nul
start "" /min "%mainfolder%\alpha_tools\start_mariadb.bat"
cd "%mainfolder%"
:install_world
if exist "%mainfolder%\alpha_mariadb\data\alpha_world" goto install_realm
echo.
echo    Installing World DB
ping -n 2 127.0.0.1>nul
echo     - Create World DB...
ping -n 2 127.0.0.1>nul
"%mainfolder%\alpha_mariadb\bin\mysql.exe" --user=root --password=pwd --default-character-set=utf8 --port=3306 -e "drop database if exists alpha_world";
"%mainfolder%\alpha_mariadb\bin\mysql.exe" --user=root --password=pwd --default-character-set=utf8 --port=3306 -e "create database alpha_world";
echo     - Populate World DB...
ping -n 2 127.0.0.1>nul
"%mainfolder%\alpha_mariadb\bin\mysql.exe" --user=root --password=pwd --default-character-set=utf8 --port=3306 --database=alpha_world < "%mainfolder%\alpha_core\etc\databases\world\world.sql"
echo     - Update World DB...
ping -n 2 127.0.0.1>nul
"%mainfolder%\alpha_mariadb\bin\mysql.exe" --user=root --password=pwd --default-character-set=utf8 --port=3306 --database=alpha_world < "%mainfolder%\alpha_core\etc\databases\world\updates\updates.sql"
:install_realm
if exist "%mainfolder%\alpha_mariadb\data\alpha_realm" goto install_dbc
echo.
echo    Installing Realm DB
ping -n 2 127.0.0.1>nul
echo     - Create Realm DB...
ping -n 2 127.0.0.1>nul
"%mainfolder%\alpha_mariadb\bin\mysql.exe" --user=root --password=pwd --default-character-set=utf8 --port=3306 -e "drop database if exists alpha_realm";
"%mainfolder%\alpha_mariadb\bin\mysql.exe" --user=root --password=pwd --default-character-set=utf8 --port=3306 -e "create database alpha_realm";
echo     - Populate Realm DB...
ping -n 2 127.0.0.1>nul
"%mainfolder%\alpha_mariadb\bin\mysql.exe" --user=root --password=pwd --default-character-set=utf8 --port=3306 --database=alpha_realm < "%mainfolder%\alpha_core\etc\databases\realm\realm.sql"
echo     - Update Realm DB...
ping -n 2 127.0.0.1>nul
"%mainfolder%\alpha_mariadb\bin\mysql.exe" --user=root --password=pwd --default-character-set=utf8 --port=3306 --database=alpha_realm < "%mainfolder%\alpha_core\etc\databases\realm\updates\updates.sql"
:install_dbc
if exist "%mainfolder%\alpha_mariadb\data\alpha_dbc" goto set_server_localhost
echo.
echo    Installing Dbc DB
ping -n 2 127.0.0.1>nul
echo     - Create Dbc DB...
ping -n 2 127.0.0.1>nul
"%mainfolder%\alpha_mariadb\bin\mysql.exe" --user=root --password=pwd --default-character-set=utf8 --port=3306 -e "drop database if exists alpha_dbc";
"%mainfolder%\alpha_mariadb\bin\mysql.exe" --user=root --password=pwd --default-character-set=utf8 --port=3306 -e "create database alpha_dbc";
echo     - Populate Dbc DB...
ping -n 2 127.0.0.1>nul
"%mainfolder%\alpha_mariadb\bin\mysql.exe" --user=root --password=pwd --default-character-set=utf8 --port=3306 --database=alpha_dbc < "%mainfolder%\alpha_core\etc\databases\dbc\dbc.sql"
echo     - Update Dbc DB...
ping -n 2 127.0.0.1>nul
"%mainfolder%\alpha_mariadb\bin\mysql.exe" --user=root --password=pwd --default-character-set=utf8 --port=3306 --database=alpha_dbc < "%mainfolder%\alpha_core\etc\databases\dbc\updates\updates.sql"
:set_server_localhost
echo.
echo    Setting Address to 127.0.0.1...
ping -n 2 127.0.0.1>nul
"%mainfolder%\alpha_mariadb\bin\mysql.exe" --user=root --password=pwd --default-character-set=utf8 --port=3306 -e "UPDATE `alpha_realm`.`realmlist` SET `realm_name` = 'Alpha Core', `proxy_address`='127.0.0.1', `realm_address`='127.0.0.1' WHERE  `realm_id`=1";
:end_db_install
cls
more < "%mainfolder%\alpha_tools\header_install.txt"
echo.
echo    Alpha Core DB Installed!
ping -n 2 127.0.0.1>nul
echo.
echo    Stopping MariaDB...
ping -n 2 127.0.0.1>nul
cd "%mainfolder%\alpha_tools"
start "" /min "%mainfolder%\alpha_tools\stop_mariadb.bat"
cd "%mainfolder%"

:config_rename
cls
more < "%mainfolder%\alpha_tools\header_install.txt"
rem backup original config
if not exist "%mainfolder%\alpha_core\backup" mkdir "%mainfolder%\alpha_core\backup"
if exist "%mainfolder%\alpha_core\backup\config.yml.dist" (
del "%mainfolder%\alpha_core\etc\config\config.yml"
xcopy /y "%mainfolder%\alpha_core\backup\config.yml.dist" "%mainfolder%\alpha_core\etc\config">nul
goto config_renaming
)
if not exist "%mainfolder%\alpha_core\backup\config.yml.dist" xcopy /y "%mainfolder%\alpha_core\etc\config\config.yml.dist" "%mainfolder%\alpha_core\backup">nul
if exist "%mainfolder%\alpha_core\etc\config\config.yml" goto set_server_localhost
:config_renaming
echo.
echo    Renaming Config...
ping -n 2 127.0.0.1>nul
echo.
echo    config.yml.dist --^> config.yml
ping -n 2 127.0.0.1>nul
if exist "%mainfolder%\alpha_core\etc\config\config.yml.dist" rename "%mainfolder%\alpha_core\etc\config\config.yml.dist" "config.yml">nul

:set_server_localhost
echo.
echo    Setting Config to 127.0.0.1...
ping -n 2 127.0.0.1>nul
"%mainfolder%\alpha_tools\fart.exe" "%mainfolder%\alpha_core\etc\config\config.yml" "host: 0.0.0.0" "host: 127.0.0.1 #worldserver">nul

:set_gm_acc_default
echo.
echo    Setting GM acc as default...
ping -n 2 127.0.0.1>nul
"%mainfolder%\alpha_tools\fart.exe" "%mainfolder%\alpha_core\etc\config\config.yml" "auto_create_gm_accounts: False" "auto_create_gm_accounts: True">nul

:backup_main_py
if not exist "%mainfolder%\alpha_core\backup" mkdir "%mainfolder%\alpha_core\backup">nul
if not exist "%mainfolder%\alpha_core\backup\main.py" xcopy /y "%mainfolder%\alpha_core\main.py" "%mainfolder%\alpha_core\backup">nul

:add_client_info
if not exist "%mainfolder%\alpha_client" mkdir "%mainfolder%\alpha_client"
cd "%mainfolder%\alpha_client"
echo. > readme.txt
echo    Put the contents of Mods.zip ^& Addons.zip >> readme.txt
echo    in the root of your 0.5.3 game folder >> readme.txt
echo. >> readme.txt
echo    Mods.zip removes debug stuff, adds 16:9 support and normal login screen, etc >> readme.txt
echo. >> readme.txt
echo    Edit the `Interface\FrameXML\FrameXML.toc` file to enable or disable AddOns >> readme.txt
echo    Place a `#` to disable an AddOn, remove the `#` to enable it >> readme.txt
echo. >> readme.txt
echo. >> readme.txt
echo    Start 0.5.3 with "-uptodate" parameter >> readme.txt
xcopy /y "%mainfolder%\alpha_tools\Mods.zip" "%mainfolder%\alpha_client">nul
xcopy /y "%mainfolder%\alpha_tools\Addons.zip" "%mainfolder%\alpha_client">nul

:end_install
cd "%mainfolder%"
cls
more < "%mainfolder%\alpha_tools\header_install.txt"
echo.
echo    Alpha Core Installation Complete!
ping -n 3 127.0.0.1>nul
echo.
start "" "notepad.exe" "%mainfolder%\README.md"
exit
