@echo off
::if below is not set, then the variables are expanded at parsing and not at execution, resulting in empty/old value still being stored in the variables. With EnableDelayedExpansion set, use !var! instead of %var% to expand variables at execution.
setlocal EnableDelayedExpansion

::check that appropriate parameter is given; if not, show usage information and terminate the script
IF [%1]==[] ( 
echo Error: Missing input file
goto :usage
)

::There's an env variable, %date%, which shows date in dd/mm/yyyy formate. So we move 6 characters forward and take the next 4 characters for yyyy on %date% variable, and do similar thing for mm and dd.
set yyyy=%date:~6,4%
set mm=%date:~3,2%
set dd=%date:~0,2%
set date_suffix=_%dd%%mm%%yyyy%
::echo date_suffix: %date_suffix%

::Now let's do same for time
set time_suffix=%time:~0,2%%time:~3,2%%time:~6,2%%time:~9,2%
::echo %time_suffix%

::echo Timestamp suffix to append at the end of file name: %date_suffix%%time_suffix%

set file=%1
::echo param passed: %file%
call :check_for_extension

::echo finally the file is: !file!
echo !file!
goto :eof

:check_for_extension
::%file:.=% replaces dots with nothing in the %file% string, so after replacing all dots if %file% fails the equality condition it means it has dots
IF NOT "!file!"=="!file:.=!" (
REM echo !file! contains extension
goto :split_extension
) ELSE (
REM echo !file! has no extension
set file=!file!!date_suffix!!time_suffix!
)
goto :eof

:split_extension
::split the %file% at delim dot and take token 1 and 2, i.e. either sides of the dot, the first token will be file name while the second is the extension
for /F "tokens=1,* delims=." %%a in ("!file!") do (
set file_name=%%a
set ext=%%b
set file=!file_name!!date_suffix!!time_suffix!.!ext!
REM echo file name: !file_name!
REM echo extension: !ext!
)
goto :eof

::gives user information of what parameter is being expected
:usage
echo Usage: %0 [file (with or without extention) to append date suffix]
pause
exit /b
goto :eof