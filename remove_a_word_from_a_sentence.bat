@echo off
setlocal EnableDelayedExpansion

set word=I am planet earth
set del=planet
	
	call :method_1
	echo using method_1: "%method_1_word%"
	
	call :method_2
	echo sing method_2: "%method_2_word%"
	
goto :eof

Rem :just use the deleting word with a "=" suffix
:method_1
set method_1_word=!word:%del%=!
goto :eof

:method_2
Rem :first delete the everything from start until and including the deleting word, that leaves us with the end portion of the sentence, call it part2
set part2=!word:*%del%=!
echo %part2%

Rem :not delete part2 from the initial sentence, it will result in part1 but will also have the 'deleting word' included in it
set part1=!word:%part2%=!
echo %part1%

Rem :so now delete just the 'deleting word' from the part1 portion
set part1=!part1:%del%=!
echo %part1%

Rem :finally add part1 with part2 to find the sentence without the deleting word
set method_2_word=%part1%%part2%
goto :eof