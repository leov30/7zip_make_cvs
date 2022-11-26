@echo off
if exist "%programfiles%\7-Zip\7z.exe" set "_7zip=%programfiles%\7-Zip\7z.exe"&goto :next
if exist "%programfiles(x86)%\7-Zip\7z.exe" set "_7zip=%programfiles(x86)%\7-Zip\7z.exe"&goto :next
if exist "7z.exe" set "_7zip=7z.exe"&goto :next
title ERROR
echo THIS SCRIPT NEEDS 7ZIP&pause&exit
:next

title Processing files...
(echo File,Path,Size,CRC)>output.csv
for /f "tokens=1,2 delims=:=" %%g in ('^("%_7zip%" l -slt -an -ai!*.zip -ai!*.7z^)^|findstr /lb /c:"Listing archive:" /c:"Path =" /c:"Size =" /c:"CRC ="') do call :get_info "%%g" "%%h"

title FINISHED
echo ALL DONE!!
timeout 5&exit

:get_info
if "%~1"=="Listing archive" (
	set "_file=%~2"&set "_skip=1"
	exit /b
)
if "%_skip%"=="1" set "_skip=0"&exit /b
if "%~1"=="Path " set "_path=%~2"&exit /b
if "%~1"=="Size " set "_size=%~2"&exit /b
if "%~1"=="CRC " set "_crc=%~2"

(echo "%_file:~1%","%_path:~1%",%_size:~1%,%_crc:~1%)>>output.csv

exit /b
