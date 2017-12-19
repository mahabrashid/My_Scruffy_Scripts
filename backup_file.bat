@echo off
::if below is not set, then the variables are expanded at parsing and not at execution, resulting in empty/old value still being stored in the variables. With EnableDelayedExpansion set, use !var! instead of %var% to expand variables at execution.
setlocal EnableDelayedExpansion

::check that appropriate parameters are given; if not, show usage information and terminate the script
IF [%1]==[] ( 
echo Error: Missing source file path
goto :usage
) ELSE (
    IF [%2]==[] ( 
    echo Error: Missing destination directory
	goto :usage
    ) ELSE (
    ::echo Params given: %1 %2
	set source_file=%1
	set dest_dir=%2
	echo Source file path: !source_file!
	echo Destination dir: !dest_dir!
	
	call :extract_src_file_name
	echo Source file name: !src_file_name!
	
	echo Changing directory to: !dest_dir!
	call :change_directory
	
	call :create_dest_file
	echo Destination file: !dest_file!
	
	echo The file is now being copied...
	copy !source_file! !dest_file!
	call :write_log
REM PAUSE
	)
  )
  
goto :eof

:extract_src_file_name
::take the file name from the full path and assign to a variable
for %%F in (%source_file%) do set src_file_name=%%~nxF
::echo %src_file_name%
goto :eof

:change_directory
for /F "tokens=1 delims=:" %%a in ("%dest_dir:"=%") do (
set dest_drive=%%a
REM echo Destination drive: !dest_drive!
!dest_drive!:
)
cd !dest_dir!
goto :eof

:create_dest_file
::run another batch script that appends a date-suffix to a file name. %src_file_name:"=% removes any leading and trailing quotes from the parameter file name before passing into the script.
::once the script is run, assign the file name with date-suffix to a variable.
for /f "tokens=*" %%a in ('"C:\Users\marashid\Documents\Personal_Stuff\scruffy_scripts\append_timestamp_to_file_name.bat" %src_file_name:"=%') do set dest_file=%%a
goto :eof

:write_log
::create a log directory if one doesn't already exist
if not exist !dest_dir!\logs (
mkdir !dest_dir!\logs
) 

::create one log file per day (not per backup) with a date-suffix if one doesn't already exist
for /f "tokens=*" %%a in ('"C:\Users\marashid\Documents\Personal_Stuff\scruffy_scripts\append_timestamp_to_file_name.bat" log') do ( set log_file=%%a )
::now take the time element from the log file name leaving only the date-suffix
set log_file=!log_file:~0,12!

echo Writing log into !log_file!...
::check if the log file already exists, if not create one, otherwise append into the existing log file
if not exist !dest_dir!\logs\!log_file! (
echo !source_file! is backed up in "%dest_dir:"=%\!dest_file!" > !dest_dir!\logs\!log_file!
) else (
echo !source_file! is backed up in "%dest_dir:"=%\!dest_file!" >> !dest_dir!\logs\!log_file!
)

goto :eof

::gives user information of what parameter is being expected
:usage
echo Usage: %0 [full path to the source file] [full path to the destination directory]
pause
exit /b
goto :eof