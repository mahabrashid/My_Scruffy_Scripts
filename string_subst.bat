@echo off
setlocal enabledelayedexpansion
set string=This is my string to work with.
set "find=*my string "
call set delete=%%string:!find!=%%
echo %delete%
call set string=%%string:!delete!=%%
echo %string%
