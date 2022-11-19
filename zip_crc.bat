
@echo off
if not exist "%programfiles%\7-Zip\7z.exe" (
		echo THIS SCRIPT NEEDS 7zip to be installed&pause&exit
)
title Processing files...
set _7zip="%programfiles%\7-Zip\7z.exe"

set /a _count=0
(echo File,Path,CRC) >output.csv

for %%g in (*.zip *.7z) do (
	echo %%g
	%_7zip% l -slt "%%g" >7zip.txt
	for /f "tokens=2 skip=1 delims==" %%h in ('findstr /b /c:"Path =" /c:"CRC =" 7zip.txt') do call :get_info "%%h" "%%g"

)
del 7zip.txt
title FINISHED
pause&exit

:get_info
set /a _count+=1

if %_count% equ 1 set "_file=%~1"&exit /b
set /a _count=0

set "_crc=%~1"
(echo "%~2","%_file:~1%",%_crc:~1%) >>output.csv
exit /b
