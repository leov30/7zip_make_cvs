@echo off
if exist "%programfiles%\7-Zip\7z.exe" set "_7zip=%programfiles%\7-Zip\7z.exe"&goto :next
if exist "%programfiles(x86)%\7-Zip\7z.exe" set "_7zip=%programfiles(x86)%\7-Zip\7z.exe"&goto :next
if exist "7z.exe" set "_7zip=7z.exe"&goto :next
title ERROR
echo THIS SCRIPT NEEDS 7zip to be installed&pause&exit

:next
set /a "_total_lines=0"&set /a "_count_lines=0"
for %%g in (*.zip *.7z) do set /a _total_lines+=1

if %_total_lines% equ 0 (
	title ERROR
	echo THERE ARE NO ZIP./7Z. FILES&pause&exit 
)

title Processing files...
set /a _count=0&(echo File,Path,Size,CRC)>output.csv

for %%g in (*.zip *.7z) do (
	echo %%g
	for /f "tokens=2 skip=1 delims==" %%h in ('""%_7zip%" l -slt -spd -- "%%g"|findstr /lb /c:"Path =" /c:"Size =" /c:"CRC =""') do (
		call :get_info "%%h" "%%g"
	)
	call :progress

)
title FINISHED
pause&exit

:progress
set /a "_count_lines+=1"
set /a "_percent=(%_count_lines%*100)/%_total_lines%"
title Processing Files: %_count_lines% / %_total_lines% ^( %_percent% %% ^)
exit /b

:get_info
set /a _count+=1

if %_count% equ 1 set "_file=%~1"&exit /b
if %_count% equ 2 set "_size=%~1"&exit /b
set /a _count=0&set "_crc=%~1"

(echo "%~2","%_file:~1%",%_size:~1%,%_crc:~1%) >>output.csv

set "_file="&set "_size="&set "_crc="
exit /b
