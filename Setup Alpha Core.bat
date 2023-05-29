@echo off
:beginning
mode con: cols=40 lines=30
SET NAME=Alpha Core Installer
TITLE %NAME%
set mainfolder=%CD%
cls
more < "%mainfolder%\alpha_tools\header_install.txt"
:core_download
if exist "%mainfolder%\alpha_core_master.zip" goto core_extract
echo.
echo    Downloading Alpha Core...
ping -n 3 127.0.0.1>nul
"%mainfolder%\alpha_tools\wget.exe" -q --show-progress "https://github.com/The-Alpha-Project/alpha-core/archive/refs/heads/master.zip" -O "%mainfolder%\alpha_core_master.zip"
rem curl -m -LJO https://github.com/The-Alpha-Project/alpha-core/archive/refs/heads/master.zip
:core_extract
if exist "%mainfolder%\alpha_core" goto python_download
cls
more < "%mainfolder%\alpha_tools\header_install.txt"
echo.
echo    Extracting Alpha Core...
ping -n 3 127.0.0.1>nul
rem tar -xf alpha-core-master.zip "%mainfolder%"
"%mainfolder%\alpha_tools\7za.exe" -y -spf e "%mainfolder%\alpha_core_master.zip" > nul
rename "%mainfolder%\alpha-core-master" "alpha_core"
:python_download
if exist "%mainfolder%\python_3.9.9_win64.zip" goto python_extract
cls
more < "%mainfolder%\alpha_tools\header_install.txt"
echo.
echo    Downloading Python 3.9...
ping -n 3 127.0.0.1>nul
"%mainfolder%\alpha_tools\wget.exe" -q --show-progress "https://www.python.org/ftp/python/3.9.9/python-3.9.9-embed-amd64.zip" -O "%mainfolder%\python_3.9.9_win64.zip"
:python_extract
if exist "%mainfolder%\alpha_python" goto mariadb_download
cls
more < "%mainfolder%\alpha_tools\header_install.txt"
echo.
echo    Extracting Python...
ping -n 3 127.0.0.1>nul
if not exist "%mainfolder%\alpha_python" mkdir "%mainfolder%\alpha_python"
"%mainfolder%\alpha_tools\7za.exe" -y -spf e -o"%mainfolder%\alpha_python" "%mainfolder%\python_3.9.9_win64.zip" > nul
:mariadb_download
if exist "%mainfolder%\mariadb_10.11.3_win64.zip" goto mariadb_extract
cls
more < "%mainfolder%\alpha_tools\header_install.txt"
echo.
echo    Downloading MariaDB 10.11.3...
ping -n 3 127.0.0.1>nul
"%mainfolder%\alpha_tools\wget.exe" -q --show-progress "https://mirrors.xtom.ee/mariadb/mariadb-10.11.3/winx64-packages/mariadb-10.11.3-winx64.zip" -O "%mainfolder%\mariadb_10.11.3_win64.zip"
:mariadb_extract
if exist "%mainfolder%\alpha_mariadb" goto end_download
cls
more < "%mainfolder%\alpha_tools\header_install.txt"
echo.
echo    Extracting MariaDB...
ping -n 3 127.0.0.1>nul
"%mainfolder%\alpha_tools\7za.exe" -y -spf e "%mainfolder%\mariadb_10.11.3_win64.zip" > nul
rename "%mainfolder%\mariadb-10.11.3-winx64" "alpha_mariadb"

:end_download
cls
more < "%mainfolder%\alpha_tools\header_install.txt"
echo.
echo    Extraction Complete!
ping -n 3 127.0.0.1>nul

:python_install
if exist "%mainfolder%\alpha_python\get-pip.py" goto pip_install
cls
more < "%mainfolder%\alpha_tools\header_install.txt"
echo.
echo    Preparing Python...
ping -n 3 127.0.0.1>nul
:pip_download
rem if exist "%mainfolder%\alpha_python\get-pip.py" goto pip_install
cls
more < "%mainfolder%\alpha_tools\header_install.txt"
echo.
echo    Preparing Python...
echo.
echo    Downloading Pip...
ping -n 3 127.0.0.1>nul
"%mainfolder%\alpha_tools\wget.exe" -q --show-progress "https://bootstrap.pypa.io/get-pip.py" -O "%mainfolder%\alpha_python\get-pip.py"
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
ping -n 3 127.0.0.1>nul
cd "%mainfolder%\alpha_python"
"%mainfolder%\alpha_python\python.exe" get-pip.py
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
ping -n 3 127.0.0.1>nul
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
ping -n 3 127.0.0.1>nul
cls
more < "%mainfolder%\alpha_tools\header_install.txt"
echo.
echo    Installing Python Requirements...
ping -n 3 127.0.0.1>nul
cd "%mainfolder%\alpha_core"
"%mainfolder%\alpha_python\python.exe" -m pip install -r requirements.txt
cd "%mainfolder%"
cls
more < "%mainfolder%\alpha_tools\header_install.txt"
echo.
echo    Python Requirements Installed!
ping -n 3 127.0.0.1>nul

:mariadb_install
if exist "%mainfolder%\alpha_mariadb\data" goto database_install
cls
more < "%mainfolder%\alpha_tools\header_install.txt"
echo.
echo    Preparing MariaDB...
ping -n 3 127.0.0.1>nul
echo.
rem cd "%mainfolder%\mariadb\bin"
if not exist "%mainfolder%\alpha_mariadb\data" mkdir "%mainfolder%\alpha_mariadb\data"
"%mainfolder%\alpha_mariadb\bin\mysql_install_db.exe" --datadir="%mainfolder%\alpha_mariadb\data" --password=pwd
cls
more < "%mainfolder%\alpha_tools\header_install.txt"
echo.
echo    MariaDB Initialized!
ping -n 3 127.0.0.1>nul

:database_install
cls
more < "%mainfolder%\alpha_tools\header_install.txt"
echo.
echo    Installing Alpha Core DB...
ping -n 3 127.0.0.1>nul
echo.
cd "%mainfolder%\alpha_tools"
echo    Starting MariaDB...
ping -n 3 127.0.0.1>nul
start "" /min "%mainfolder%\alpha_tools\start_mariadb.bat"
cd "%mainfolder%"
:install_world
if exist "%mainfolder%\alpha_mariadb\data\alpha_world" goto install_realm
echo.
echo    Installing World DB
ping -n 3 127.0.0.1>nul
echo     - Create World DB...
ping -n 2 127.0.0.1>nul
"%mainfolder%\alpha_mariadb\bin\mariadb.exe" --user=root --password=pwd --port=3306 -e "drop database if exists alpha_world";
"%mainfolder%\alpha_mariadb\bin\mariadb.exe" --user=root --password=pwd --port=3306 -e "create database alpha_world";
echo     - Populate World DB...
ping -n 2 127.0.0.1>nul
"%mainfolder%\alpha_mariadb\bin\mariadb.exe" --user=root --password=pwd --port=3306 alpha_world -e "source alpha_core\etc\databases\world\world.sql"
echo     - Update World DB...
ping -n 2 127.0.0.1>nul
"%mainfolder%\alpha_mariadb\bin\mariadb.exe" --user=root --password=pwd --port=3306 alpha_world -e "source alpha_core\etc\databases\world\updates\updates.sql"
:install_realm
if exist "%mainfolder%\alpha_mariadb\data\alpha_realm" goto install_dbc
echo.
echo    Installing Realm DB
ping -n 3 127.0.0.1>nul
echo     - Create Realm DB...
ping -n 2 127.0.0.1>nul
"%mainfolder%\alpha_mariadb\bin\mariadb.exe" --user=root --password=pwd --port=3306 -e "drop database if exists alpha_realm";
"%mainfolder%\alpha_mariadb\bin\mariadb.exe" --user=root --password=pwd --port=3306 -e "create database alpha_realm";
echo     - Populate Realm DB...
ping -n 2 127.0.0.1>nul
"%mainfolder%\alpha_mariadb\bin\mariadb.exe" --user=root --password=pwd --port=3306 alpha_realm -e "source alpha_core\etc\databases\realm\realm.sql"
echo     - Update Realm DB...
ping -n 2 127.0.0.1>nul
"%mainfolder%\alpha_mariadb\bin\mariadb.exe" --user=root --password=pwd --port=3306 alpha_realm -e "source alpha_core\etc\databases\realm\updates\updates.sql"
:install_dbc
if exist "%mainfolder%\alpha_mariadb\data\alpha_dbc" goto set_server_localhost
echo.
echo    Installing Dbc DB
ping -n 3 127.0.0.1>nul
echo     - Create Dbc DB...
ping -n 2 127.0.0.1>nul
"%mainfolder%\alpha_mariadb\bin\mariadb.exe" --user=root --password=pwd --port=3306 -e "drop database if exists alpha_dbc";
"%mainfolder%\alpha_mariadb\bin\mariadb.exe" --user=root --password=pwd --port=3306 -e "create database alpha_dbc";
echo     - Populate Dbc DB...
ping -n 2 127.0.0.1>nul
"%mainfolder%\alpha_mariadb\bin\mariadb.exe" --user=root --password=pwd --port=3306 alpha_dbc -e "source alpha_core\etc\databases\dbc\dbc.sql"
echo     - Update Dbc DB...
ping -n 2 127.0.0.1>nul
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
echo    Alpha Core DB Installed!
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

:add_client_info
mkdir "%mainfolder%\alpha_client"
cd "%mainfolder%\alpha_client"
echo. > readme.txt
echo    You can get client here: >> readme.txt
echo. >> readme.txt
echo    https://wowdl.net/client/World-of-Warcraft-0.5.3.3368-enUS >> readme.txt
echo. >> readme.txt
echo. >> readme.txt
echo    After extracting client >> readme.txt
echo    put the contents of Mods.zip ^& Addons.zip >> readme.txt
echo    in the root of your 0.5.3 game folder >> readme.txt
echo. >> readme.txt
echo    Edit the `Interface\FrameXML\FrameXML.toc` file to enable or disable AddOns. >> readme.txt
echo    Place a `#` to disable an AddOn, remove the `#` to enable it. >> readme.txt
echo. >> readme.txt
echo. >> readme.txt
echo    Start 0.5.3 ONLY by using "Start WoW.bat" >> readme.txt
echo    that comes with the client >> readme.txt
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
echo    "alpha_client" folder has tips
echo    for WoW Alpha client
ping -n 5 127.0.0.1>nul
echo.
echo    You can add maps to Alpha Core
echo    by running Update Maps.bat
ping -n 5 127.0.0.1>nul
exit
