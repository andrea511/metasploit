@echo off
set BASE=%~dp0
CALL "%BASE%scripts\setenv.bat"
set BUNDLE_GEMFILE=%BASE%apps\pro\Gemfile-pro
ruby "%BASE%apps\pro\ui\script\resetpw" %*
