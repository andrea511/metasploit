@echo off
rem START or STOP Services
rem ----------------------------------
rem Check if argument is STOP or START

if not ""%1"" == ""START"" goto stop

CALL "C:\METASP~1\scripts\setenv.bat"

if exist "C:\METASP~1\postgresql\scripts\servicerun.bat" (start /MIN cmd.exe /c "C:\METASP~1\postgresql\scripts\servicerun.bat" START)
if exist "C:\METASP~1\apps\pro\engine\scripts\servicerun.bat" (start /MIN cmd.exe /c "C:\METASP~1\apps\pro\engine\scripts\servicerun.bat" START)
if exist "C:\METASP~1\apps\pro\ui\scripts\servicerun.bat" (start /MIN cmd.exe /c "C:\METASP~1\apps\pro\ui\scripts\servicerun.bat" START)
if exist "C:\METASP~1\apps\pro\ui\scripts\worker_servicerun.bat" (start /MIN cmd.exe /c "C:\METASP~1\apps\pro\ui\scripts\worker_servicerun.bat" START)
goto end

:stop

if exist "C:\METASP~1\apps\pro\ui\scripts\worker_servicerun.bat" (start /MIN cmd.exe /c "C:\METASP~1\apps\pro\ui\scripts\worker_servicerun.bat" STOP)
if exist "C:\METASP~1\apps\pro\ui\scripts\servicerun.bat" (start /MIN cmd.exe /c "C:\METASP~1\apps\pro\ui\scripts\servicerun.bat" STOP)
if exist "C:\METASP~1\apps\pro\engine\scripts\servicerun.bat" (start /MIN cmd.exe /c "C:\METASP~1\apps\pro\engine\scripts\servicerun.bat" STOP)
if exist "C:\METASP~1\postgresql\scripts\servicerun.bat" (start /MIN cmd.exe /c "C:\METASP~1\postgresql\scripts\servicerun.bat" STOP)

:end
