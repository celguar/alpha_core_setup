@echo off
:beginning
mode con: cols=40 lines=30
SET NAME=Alpha Core Server
TITLE %NAME%
set mainfolder=%CD%
cls
more < "%mainfolder%\alpha_tools\header_start.txt"
echo.
rem CHECK EVERYTHING
tasklist /FI "IMAGENAME eq python.exe" 2>NUL | find /I /N "python.exe">NUL
if "%ERRORLEVEL%"=="0" (
echo    Alpha Core is already running!
ping -n 3 127.0.0.1>nul
goto ending
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
if not exist "%mainfolder%\alpha_downloads\get-pip.py" (
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

:check_mariadb_path
if not exist "%mainfolder%\alpha_mariadb\portable_install_path.txt" goto fix_mariadb_path
set /p mariadb_install_path=<"%mainfolder%\alpha_mariadb\portable_install_path.txt"
:compare_mariadb_path
if "%mariadb_install_path%"=="%mainfolder%" goto start_mariadb
:fix_mariadb_path
rem fix mariadb path
echo    MariaDB path changed!
ping -n 2 127.0.0.1>nul
echo.
echo    Fixing...
ping -n 2 127.0.0.1>nul
echo.
rem cd "%mainfolder%\mariadb\bin"
if not exist "%mainfolder%\alpha_mariadb\data" mkdir "%mainfolder%\alpha_mariadb\data"
"%mainfolder%\alpha_mariadb\bin\mysql_install_db.exe" --datadir="%mainfolder%\alpha_mariadb\data" --password=pwd
>"%mainfolder%\alpha_mariadb\portable_install_path.txt" echo %mainfolder%
echo.
echo    MariaDB Initialized!
ping -n 2 127.0.0.1>nul

:start_mariadb
cls
more < "%mainfolder%\alpha_tools\header_start.txt"
echo.
cd "%mainfolder%\alpha_tools"
echo    Starting MariaDB...
ping -n 2 127.0.0.1>nul
start "" "%mainfolder%\alpha_tools\start_mariadb.bat"

rem do it every time in case repack is moved
:fix_python_paths
set properpath=%mainfolder%
set "properpath=%properpath:\=/%"
rem restore original main.py
if exist "%mainfolder%\alpha_core\backup\main.py" (
if exist "%mainfolder%\alpha_core\main.py" del "%mainfolder%\alpha_core\main.py"
xcopy /y "%mainfolder%\alpha_core\backup\main.py" "%mainfolder%\alpha_core"
)
rem add core path to sys path
"%mainfolder%\alpha_tools\fart.exe" -C "%mainfolder%\alpha_core\main.py" "from time import sleep" "from time import sleep\r\n\r\nimport sys\r\nsys.path.insert(0, 'path_placeholder')"
"%mainfolder%\alpha_tools\fart.exe" "%mainfolder%\alpha_core\main.py" "path_placeholder" "%properpath%/alpha_core/"

:start_core
cd "%mainfolder%\alpha_core"
echo.
echo    Starting Alpha Core...
ping -n 2 127.0.0.1>nul
start "" "%mainfolder%\alpha_tools\start_alpha_core.bat"
cd "%mainfolder%"

:ending
exit

:error_install
echo.
echo    Run Setup Alpha Core.bat
echo    to complete installation
ping -n 5 127.0.0.1>nul
exit