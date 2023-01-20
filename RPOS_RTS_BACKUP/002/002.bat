@echo off
title RPOS RTS BACKUP TOOL
mode con:cols=150
set stars=************************************************************************************************************************************************
set backupname=RTSBackup-%Computername%-%date:~4,2%%date:~7,2%%date:~10,4%-%time:~0,2%%time:~3,2%%time:~6,2%
set backupname=%backupname: =0%
set backupfolder=C:\DUMAC\Backup\%backupname%\
set backupfolder1=C:\DUMAC\Backup\%backupname%
set zipfile=%backupfolder1%.zip
set logfile="%backupfolder%Z_ReturnToService.log"
set siteinfolog="%backupfolder%Z_SiteInfo.txt"
set md5log="%backupfolder%Z_MD5.txt"
if not exist "C:\DUMAC" mkdir "C:\DUMAC"
if not exist "C:\DUMAC\Backup" mkdir "C:\DUMAC\Backup"
if not exist "%backupfolder1%" mkdir "%backupfolder1%"

echo  ____ ____ ____ ____ ____ 
echo ^|^|D ^|^|^|U ^|^|^|M ^|^|^|A ^|^|^|C ^|^|
echo ^|^|__^|^|^|__^|^|^|__^|^|^|__^|^|^|__^|^|
echo ^|/__^\^|/__^\^|/__^\^|/__^\^|/__^\^|
echo.
timeout /t 2 >nul
echo * * *  %date%   %time%   %computername%  * * *>>%logfile%2>&1
whoami>>%logfile%2>&1
echo %stars%
echo #####  PREREQUISITES CHECK  #####
echo %stars%
echo %STARS%>>%logfile%2>&1
echo #####  PREREQUISITES CHECK  #####>>%logfile%2>&1
echo %STARS%>>%logfile%2>&1

:CheckForAdministratorPrivileges    
    net session >nul 2>&1
    if %errorLevel% == 0 (
        echo [INFO] Administrative permissions confirmed. Continuing....
        echo [INFO] Administrative permissions confirmed. Continuing....>>%logfile%2>&1
	timeout /t 2 >nul
	goto validate64bit
    ) else (
        echo [ERROR] Current permissions inadequate. You must run this script as admin!
		echo [ERROR] Press any key to exit the script...
        echo [ERROR] Current permissions inadequate. You must run this script as admin!>>%logfile%2>&1
		echo [ERROR] Exiting script...>>%logfile%2>&1
		pause >nul
		exit
    )

:validate64bit
if "%PROCESSOR_ARCHITECTURE%"=="AMD64" goto 64BIT
echo [INFO] 32-bit OS
echo [WARN] This script was written for x64 operating systems!
echo [WARN] Press any key to exit...
pause >nul
exit
:64BIT
echo [INFO] 64-bit OS confirmed. Continuing....

:StartScript
echo %stars%
echo #####  RPOS RTS files backup  #####
echo %stars%
echo %STARS%>>%logfile%2>&1
echo #####  RPOS RTS files backup  #####>>%logfile%2>&1
echo %STARS%>>%logfile%2>&1
del C:\Dumac\PathList.txt /q >>nul 2>&1

for /f "delims=" %%i in (%~dp0filestobackup.conf) do (
  if exist "%%i" (
	echo [INFO] Backing up %%i.... && echo [INFO] Backing up %%i....>>%logfile%2>&1
	xcopy "%%i" "%backupfolder%" /q >nul
	) ELSE (
	echo [WARN] We could not find %%i. Skipping. && echo [WARN] We could not find %%i. Skipping.>>%logfile%2>&1
	)
)

echo %stars%
echo #####  RPOS Registry Parameters backup  #####
echo %stars%

echo %stars%>>%logfile%2>&1
echo #####  RPOS Registry Parameters backup  #####>>%logfile%2>&1
echo %stars%>>%logfile%2>&1

setlocal enabledelayedexpansion
for /f "tokens=1,2 delims=," %%a in (%~dp0regexports.conf) do (
		set "regpath=%%a"
		set "regname=%%b"
		reg query "%regpath%" > nul 2>&1
		if %errorlevel% EQU 0 echo [INFO] Backing up "!REGPATH!" to "!REGNAME!".... && echo [INFO] Backing up "!REGPATH!" to "!REGNAME!"....>>%logfile%2>&1
		if %errorlevel% NEQ 0 echo [WARN] We could not find !REGPATH!. Skipping. && echo [WARN] We could not find !REGPATH!. Skipping.>>%logfile%2>&1
		reg export "!REGPATH!" "%backupfolder%!REGNAME!" >nul
)

:generatesiteinfotxt
echo Computer Name: %computername% >>%siteinfolog%
echo. >>%siteinfolog%
cmd /c ipconfig /all  >>%siteinfolog%

:filehash
echo %stars%
echo [INFO] Generating MD5 hashes for RTS files...
@echo off
setlocal EnableDelayedExpansion
echo %backupfolder1%>>C:\Dumac\pathlist.txt
echo RTS Files MD5 Hashes>>%md5log%
echo. >>%md5log%
for /f "tokens=*" %%i in (C:\Dumac\PathList.txt) do (
  for /f "tokens=*" %%j in ('dir /b /s "%%i"') do (
    certutil -hashfile "%%j" MD5 | find /i /v "certutil" >>%md5log% && echo.>>%md5log%
    )
  )
echo [INFO] Completed generating MD5 hashes for RTS files
echo %stars%
endlocal

:zipthefolder
set failedtozip=""
timeout /t 2 >nul
echo.
echo %stars%
echo [INFO] Compressing backup files...
echo.
echo [INFO] * * *         BE PATIENT!            * * *
echo [INFO] * * * THIS MAY TAKE SEVERAL MINUTES! * * *
echo.
start /min "***Compressing backup files...***      ***Do not close this window.***" /wait powershell Compress-Archive "%backupfolder1%" "%ZIPFILE%"
if %errorlevel% EQU 0 echo [INFO] Completed compressing backup files. Continuing.... && echo [INFO] [INFO] Completed compressing backup files. Continuing....>>%logfile%2>&1
if %errorlevel% NEQ 0 echo [ERROR] Failed to zip files! YOu will need to manually zip them. && echo [ERROR] Failed to zip files! You will need to manually zip them.>>%logfile%2>&1 && set failedtozip=1

if "%FAILEDTOZIP%"=="1" echo [WARN] Skipping cleanup process since we could not zip the directory... && echo [WARN] Skipping cleanup process since we could not zip the directory...>>%logfile%2>&1 && goto :endmessage

:cleanup
timeout /t 1 >nul
echo [INFO] Cleaning up...
if exist %zipfile% rmdir /s /q %backupfolder1%
del C:\Dumac\PathList.txt

:endmessage
if "%FAILEDTOZIP%"=="1" set zipfile=%backupfolder1%
echo %stars% && echo %stars%
echo                           PLEASE READ THE LOG FILE TO ENSURE ALL OF YOUR
echo                           RTS FILES BACKED UP SUCCESSFULLY!
echo.
echo                           SPECIFICALLY, LOOK FOR ANY [WARN] or [ERROR] 
echo                           MESSAGES IN THIS WINDOW.
echo.
echo                           The backup file is in the below location:
echo                           %ZIPFILE%
echo %stars% && echo %stars%
echo.
echo **THIS WINDOW WILL CLOSE AUTOMATICALLY IN 5 MINUTES IF YOU DO NOT EXIT**
timeout /t 300 >nul
