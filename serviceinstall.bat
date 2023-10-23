@echo off
rem -- Check if argument is INSTALL or REMOVE

if not ""%1"" == ""INSTALL"" goto remove
if exist "C:\METASP~1\postgresql\scripts\serviceinstall.bat" (start /MIN cmd.exe /c "C:\METASP~1\postgresql\scripts\serviceinstall.bat" INSTALL)
if exist "C:\METASP~1\apps\pro\engine\scripts\serviceinstall.bat" (start /MIN cmd.exe /c "C:\METASP~1\apps\pro\engine\scripts\serviceinstall.bat" INSTALL)
if exist "C:\METASP~1\apps\pro\ui\scripts\serviceinstall.bat" (start /MIN cmd.exe /c "C:\METASP~1\apps\pro\ui\scripts\serviceinstall.bat" INSTALL)
if exist "C:\METASP~1\apps\pro\ui\scripts\worker_serviceinstall.bat" (start /MIN cmd.exe /c "C:\METASP~1\apps\pro\ui\scripts\worker_serviceinstall.bat" INSTALL)
goto end

:remove

if exist "C:\METASP~1\apps\pro\ui\scripts\worker_serviceinstall.bat" (start /MIN cmd.exe /c "C:\METASP~1\apps\pro\ui\scripts\worker_serviceinstall.bat")
if exist "C:\METASP~1\apps\pro\ui\scripts\serviceinstall.bat" (start /MIN cmd.exe /c "C:\METASP~1\apps\pro\ui\scripts\serviceinstall.bat")
if exist "C:\METASP~1\apps\pro\engine\scripts\serviceinstall.bat" (start /MIN cmd.exe /c "C:\METASP~1\apps\pro\engine\scripts\serviceinstall.bat")
if exist "C:\METASP~1\postgresql\scripts\serviceinstall.bat" (start /MIN cmd.exe /c "C:\METASP~1\postgresql\scripts\serviceinstall.bat")

:end
