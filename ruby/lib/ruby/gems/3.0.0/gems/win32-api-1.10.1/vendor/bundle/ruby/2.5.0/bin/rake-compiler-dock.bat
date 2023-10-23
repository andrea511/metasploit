@ECHO OFF
IF NOT "%~f0" == "~f0" GOTO :WinNT
@"c:\Ruby25-x64\bin\ruby.exe" "C:/Users/cosmo/Documents/GitHub/win32-api/vendor/bundle/ruby/2.5.0/bin/rake-compiler-dock" %1 %2 %3 %4 %5 %6 %7 %8 %9
GOTO :EOF
:WinNT
@"c:\Ruby25-x64\bin\ruby.exe" "%~dpn0" %*
