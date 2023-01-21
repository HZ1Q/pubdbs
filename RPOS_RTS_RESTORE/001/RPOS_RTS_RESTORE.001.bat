@echo off
title RTS BACKUP RESTORE
setlocal enabledelayedexpansion


rem Find all zip files matching the pattern "RTSBackup-.zip" in the current directory
set file_list=0
for /f "delims=" %%a in ('dir /b %~dp0RTSBackup-*.zip') do (
set /a file_list+=1
set file_!file_list!=%%a
)

rem Display the list of zip files and ask the user to choose one
set choice=0
if %file_list% GTR 0 (
echo.
echo 	Available zip files in %~dp0 :
echo.
for /l %%i in (1,1,%file_list%) do echo 	%%i - !file_%%i!
echo.
set /p choice= 	Enter the number of the zip file to extract:
)

rem Extract the chosen zip file to a folder with the same name as the zip file
if %choice% GTR 0 (
set filename=!file_%choice%!
set foldername=!filename:.zip=!
rem mkdir "!foldername!" >nul 2>&1
start /min /wait powershell Expand-Archive -Path '%~dp0!filename!' -DestinationPath '%~dp0%foldername%'
)

rem Check each file in the extracted folder against the restorex.conf file
set conf_file=%~dp0restorex.conf
if exist %conf_file% (
	for /f "tokens=1,2 delims=," %%a in (%conf_file%) do (
	set _a=%%a
	set _b=%%b
		if exist %~dp0%foldername%\%%a (
		cls
		echo.
		echo Do you want to restore %%a to %%b? ^(y/n^)
		echo We will back up the original file in %%b if it exists.
		set /p "restore=Answer:"
			timeout /t 1 >nul
			if /i "!restore!"=="y" (
			rem timeout /t 2 >nul
			set date_str=%date:~4,2%%date:~7,2%%date:~10,4%
			if exist "%%b\%%a" mkdir "%%b\Z_PRE_RTS_BACKUPS" >nul 2>&1
			if exist "%%b\%%a" copy "%%b\%%a" "%%b\Z_PRE_RTS_BACKUPS\ORIGINAL_!date_str!_%%a"
			copy %~dp0%foldername%\%%a "%%b"			
			)

		)

	)

)

endlocal
pause
