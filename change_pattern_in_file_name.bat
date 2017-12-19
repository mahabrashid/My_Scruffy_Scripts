@echo off
::if below is not set, then the variables are expanded at parsing and not at execution, resulting in empty/old value still being stored in the variables. With EnableDelayedExpansion set, use !var! instead of %var% to expand variables at execution.
setlocal EnableDelayedExpansion

:: echo current directory:%~dp0%

::check that appropriate parameter is given; if not, show usage information and terminate the script
IF [%1]==[] (
echo Error: Missing Directory input
src_dir=%1
goto :usage
)ELSE (
		set resident_dir=%~dp1%
    IF [%2]==[] (
    echo Error: Missing existing file pattern
		goto :usage
		)ELSE (
			IF [%3]==[] (
			echo Error: Missing replacing file patterns
			goto :usage
			)ELSE (
			 set existing_patt=%2
			 set replacing_patt=%3
			 Rem echo !existing_patt!
			 Rem echo !replacing_patt!
			 call :using_for
			 )
		 )
 )
goto :eof

:using_for
echo resident directory: "!resident_dir!"
for /f "tokens=*" %%G in ('dir /b *%existing_patt%*') do (
set file=%%G
set new_file=!file:%existing_patt%=%replacing_patt%!
echo creating backup...
call :create_backup "!file!"
ren "!file!" "!new_file!"
echo "!file!" has now changed to "!new_file!"
)
goto :eof

::not yet implemented
:using_forfiles
forfiles ^/m *.* /c "cmd /c echo @fname"
goto :eof

:create_backup
set "orig_file=%~1"
set "bac_file=%orig_file%.bak"
copy "%orig_file%" "%bac_file%"
goto :eof

::gives user information of what parameter is being expected
:usage
echo Usage: %0 [existing pattern in file names] [replacing pattern in file names]
pause
exit /b
goto :eof
