@echo off
::if below is not set, then the variables are expanded at parsing and not at execution, resulting in empty/old value still being stored in the variables. With EnableDelayedExpansion set, use !var! instead of %var% to expand variables at execution.
setlocal EnableDelayedExpansion

echo Hello. I am a simple script who lives in "%~dp0%".
::echo %~dp1%

set zero=%0
set first=%1
set last=%2
echo hello %zero% %first% %last% > C:\Users\marashid\Documents\Personal_Stuff\scruffy_scripts\hello.txt

:: in a code block will result in 'The system cannot find the drive specified' error, so replace it with Rem instead especially within a code block to comment out lines or to make notes.

pause