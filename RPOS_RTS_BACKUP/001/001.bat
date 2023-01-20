@echo off
title RPOS RTS TOOL
echo  ____ ____ ____ ____ ____ 
echo ^|^|D ^|^|^|U ^|^|^|M ^|^|^|A ^|^|^|C ^|^|
echo ^|^|__^|^|^|__^|^|^|__^|^|^|__^|^|^|__^|^|
echo ^|/__^\^|/__^\^|/__^\^|/__^\^|/__^\^|
echo.
timeout /t 3 >nul
:CheckForAdministratorPrivileges    
    net session >nul 2>&1
    if %errorLevel% == 0 (
	echo.
        echo [INFO] Administrative permissions confirmed. Continuing....
	timeout /t 2 >nul
	goto validate64bit
    ) else (
	echo.
        echo [ERROR] Current permissions inadequate. You must run this script as admin!
	pause
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
set lines=============================================================================================
set stars=********************************************************************************************

echo %lines%
echo RPOS RTS files backup
echo %lines%
del C:\Dumac\PathList.txt /q >>nul 2>&1

echo.
if exist "C:\Program Files (x86)\Radiant\Lighthouse\Data\SiteServerConfig.xml" (
echo [INFO] Backing up SiteServerConfig.xml.... && echo [INFO] Backing up SiteServerConfig.xml....>>%logfile%2>&1
xcopy "C:\Program Files (x86)\Radiant\Lighthouse\Data\SiteServerConfig.xml" "%backupfolder%" /q
) ELSE (
echo [WARN] We could not find SiteServerConfig.xml. Skipping. && echo [WARN] We could not find SiteServerConfig.xml. Skipping.>>%logfile%2>&1
)

echo.
if exist "C:\Program Files (x86)\Radiant\Lighthouse\Data\LHStationConfig.xml" (
echo [INFO] Backing up LHStationConfig.xml.... && echo [INFO] Backing up LHStationConfig.xml....>>%logfile%2>&1
xcopy "C:\Program Files (x86)\Radiant\Lighthouse\Data\LHStationConfig.xml" "%backupfolder%" /q
) ELSE (
echo [WARN] We could not find LHStationConfig.xml. Skipping. && echo [WARN] We could not find LHStationConfig.xml. Skipping.>>%logfile%2>&1
)

echo.
if exist "C:\Program Files (x86)\Radiant\Lighthouse\Data\SiteServerSiteID.xml" (
echo [INFO] Backing up SiteServerSiteID.xml.... && echo [INFO] Backing up SiteServerSiteID.xml....>>%logfile%2>&1
xcopy "C:\Program Files (x86)\Radiant\Lighthouse\Data\SiteServerSiteID.xml" "%backupfolder%" /q
) ELSE (
echo [WARN] We could not find SiteServerSiteID.xml. Skipping. && echo [WARN] We could not find SiteServerSiteID.xml. Skipping.>>%logfile%2>&1
)

echo.
if exist "C:\Program Files (x86)\Radiant\Lighthouse\Data\RelayGen\SystemFrames.dat" (
echo [INFO] Backing up SystemFrames.dat.... && echo [INFO] Backing up SystemFrames.dat....>>%logfile%2>&1
xcopy "C:\Program Files (x86)\Radiant\Lighthouse\Data\RelayGen\SystemFrames.dat" "%backupfolder%" /q
) ELSE (
echo [WARN] We could not find SystemFrames.dat. Skipping. && echo [WARN] We could not find SystemFrames.dat. Skipping.>>%logfile%2>&1
)

echo.
if exist "C:\Program Files (x86)\Radiant\Lighthouse\Data\RelayGen\message.dat" (
echo [INFO] Backing up message.dat.... && echo [INFO] Backing up message.dat....>>%logfile%2>&1
xcopy "C:\Program Files (x86)\Radiant\Lighthouse\Data\RelayGen\message.dat" "%backupfolder%" /q
) ELSE (
echo [WARN] We could not find message.dat. Skipping. && echo [WARN] We could not find message.dat. Skipping.>>%logfile%2>&1
echo [WARN] It is possible message.dat has been replaced by message.json. 
echo [WARN] We will attempt to backup message.json next.
)

echo.
if exist "C:\Program Files (x86)\Radiant\Lighthouse\Data\RelayGen\message.json" (
echo [INFO] Backing up message.json.... && echo [INFO] Backing up message.json....>>%logfile%2>&1
xcopy "C:\Program Files (x86)\Radiant\Lighthouse\Data\RelayGen\message.json" "%backupfolder%" /q
) ELSE (
echo [WARN] We could not find message.json. Skipping. && echo [WARN] We could not find message.json. Skipping.>>%logfile%2>&1
)

echo.
if exist "C:\Program Files (x86)\Radiant\Lighthouse\Data\RelayGen\pay_point.dat" (
echo [INFO] Backing up pay_point.dat.... && echo [INFO] Backing up pay_point.dat....>>%logfile%2>&1
xcopy "C:\Program Files (x86)\Radiant\Lighthouse\Data\RelayGen\pay_point.dat" "%backupfolder%" /q
) ELSE (
echo [WARN] We could not find pay_point.dat. Skipping. && echo [WARN] We could not find pay_point.dat. Skipping.>>%logfile%2>&1
)

echo.
if exist "C:\Program Files (x86)\Radiant\Lighthouse\Data\RelayGen\icarusdcs.xml" (
echo [INFO] Backing up icarusdcs.xml.... && echo [INFO] Backing up icarusdcs.xml....>>%logfile%2>&1
xcopy "C:\Program Files (x86)\Radiant\Lighthouse\Data\RelayGen\icarusdcs.xml" "%backupfolder%" /q
) ELSE (
echo [WARN] We could not find icarusdcs.xml. Skipping. && echo [WARN] We could not find icarusdcs.xml. Skipping.>>%logfile%2>&1
echo [WARN] Is this site OEMV? If not, the site may not have this file.
)

echo.
if exist "C:\Program Files (x86)\Radiant\Lighthouse\Data\RelayGen\jagdefault.cer" (
echo [INFO] Backing up jagdefault.cer.... && echo [INFO] Backing up jagdefault.cer....>>%logfile%2>&1
xcopy "C:\Program Files (x86)\Radiant\Lighthouse\Data\RelayGen\jagdefault.cer" "%backupfolder%" /q
) ELSE (
echo [WARN] We could not find jagdefault.cer. Skipping. && echo [WARN] We could not find jagdefault.cer. Skipping.>>%logfile%2>&1
)

echo.
if exist "C:\Program Files (x86)\Radiant\IntegrationManager\Configurations\NaxmlPbiMaintenance.cfg\Xslt\NAXMLCreditCodes.xml" (
echo [INFO] Backing up NAXMLCreditCodes.xml.... && echo [INFO] Backing up NAXMLCreditCodes.xml....>>%logfile%2>&1
xcopy "C:\Program Files (x86)\Radiant\IntegrationManager\Configurations\NaxmlPbiMaintenance.cfg\Xslt\NAXMLCreditCodes.xml" "%backupfolder%" /q
) ELSE (
echo [WARN] We could not find NAXMLCreditCodes.xml. Skipping. && echo [WARN] We could not find NAXMLCreditCodes.xml. Skipping.>>%logfile%2>&1
)

echo.
if exist "C:\Windows\System32\drivers\etc\hosts" (
echo [INFO] Backing up hosts.... && echo [INFO] Backing up hosts....>>%logfile%2>&1
xcopy "C:\Windows\System32\drivers\etc\hosts" "%backupfolder%" /q
) ELSE (
echo [WARN] We could not find hosts. Skipping. && echo [WARN] We could not find hosts. Skipping.>>%logfile%2>&1
)

echo.
if exist "C:\Program Files (x86)\Radiant\License.xml" (
echo [INFO] Backing up License.xml.... && echo [INFO] Backing up License.xml....>>%logfile%2>&1
xcopy "C:\Program Files (x86)\Radiant\License.xml" "%backupfolder%" /q
) ELSE (
echo [WARN] We could not find License.xml. Skipping. && echo [WARN] We could not find License.xml. Skipping.>>%logfile%2>&1
)

echo.
if exist "C:\Program Files (x86)\Radiant Systems\CMC\commandcenter.config" (
echo [INFO] Backing up commandcenter.config.... && echo [INFO] Backing up commandcenter.config....>>%logfile%2>&1
xcopy "C:\Program Files (x86)\Radiant Systems\CMC\commandcenter.config" "%backupfolder%" /q
) ELSE (
echo [WARN] We could not find commandcenter.config. Skipping. && echo [WARN] We could not find commandcenter.config. Skipping.>>%logfile%2>&1
)

echo.
if exist "C:\Program Files (x86)\Radiant\Lighthouse\Data\LHModuleManagementValues.xml" (
echo [INFO] Backing up LHModuleManagementValues.xml.... && echo [INFO] Backing up LHModuleManagementValues.xml....>>%logfile%2>&1
xcopy "C:\Program Files (x86)\Radiant\Lighthouse\Data\LHModuleManagementValues.xml" "%backupfolder%" /q
) ELSE (
echo [WARN] We could not find LHModuleManagementValues.xml. Skipping. && echo [WARN] We could not find LHModuleManagementValues.xml. Skipping.>>%logfile%2>&1
)

echo.
echo %lines%
echo RPOS Registry Parameters backup
echo %lines%

:RPOSInstallParemeters
echo.
reg query "HKEY_LOCAL_MACHINE\SOFTWARE\WOW6432Node\Radiant\InstallParameters\Radiant POS" > nul 2>&1
if %errorlevel% EQU 0 echo [INFO] Backing up RPOSInstallParemeters.reg.... && echo [INFO] Backing up RPOSInstallParemeters.reg....>>%logfile%2>&1
if %errorlevel% NEQ 0 echo [WARN] We could not find RPOSInstallParemeters.reg. Skipping. && echo [WARN] We could not find RPOSInstallParemeters.reg. Skipping.>>%logfile%2>&1 && goto EPSSetup
reg export "HKEY_LOCAL_MACHINE\SOFTWARE\WOW6432Node\Radiant\InstallParameters\Radiant POS" "%backupfolder%RPOSInstallParemeters.reg"

:EPSSetup
echo.
reg query "HKEY_LOCAL_MACHINE\SOFTWARE\WOW6432Node\RadiantSystems\Setup" > nul 2>&1
if %errorlevel% EQU 0 echo [INFO] Backing up EPSSetup.reg.... && echo [INFO] Backing up EPSSetup.reg....>>%logfile%2>&1
if %errorlevel% NEQ 0 echo [WARN] We could not find EPSSetup.reg. Skipping. && echo [WARN] We could not find EPSSetup.reg. Skipping.>>%logfile%2>&1 && goto radviewerconfig1
reg export "HKEY_LOCAL_MACHINE\SOFTWARE\WOW6432Node\RadiantSystems\Setup" "%backupfolder%EPSSetup.reg"

:radviewerconfig1
echo.
reg query "HKEY_LOCAL_MACHINE\SOFTWARE\WOW6432Node\RadiantSystems\RadViewer\NT Production" > nul 2>&1
if %errorlevel% EQU 0 echo [INFO] Backing up Radviewerconfig1.reg.... && echo [INFO] Backing up Radviewerconfig1.reg....>>%logfile%2>&1
if %errorlevel% NEQ 0 echo [WARN] We could not find Radviewerconfig1.reg. Skipping. && echo [WARN] We could not find Radviewerconfig1.reg. Skipping.>>%logfile%2>&1 %% goto radviewerconfig2
reg export "HKEY_LOCAL_MACHINE\SOFTWARE\WOW6432Node\RadiantSystems\RadViewer\NT Production" "%backupfolder%Radviewerconfig1.reg"

:radviewerconfig2
echo.
reg query "HKEY_LOCAL_MACHINE\SOFTWARE\WOW6432Node\RadiantSystems\RadViewer\NT Production" > nul 2>&1
if %errorlevel% EQU 0 echo [INFO] Backing up Radviewerconfig2.reg.... && echo [INFO] Backing up Radviewerconfig2.reg....>>%logfile%2>&1
if %errorlevel% NEQ 0 echo [WARN] We could not find Radviewerconfig2.reg. Skipping. && echo [WARN] We could not find Radviewerconfig2.reg. Skipping.>>%logfile%2>&1 && goto generatesiteinfotxt
reg export "HKEY_CURRENT_USER\SOFTWARE\RadiantSystems\RadViewer\NT Production" "%backupfolder%Radviewerconfig2.reg"

:generatesiteinfotxt
echo.
echo Sitecontroller Name: %computername% >>%siteinfolog%
echo. >>%siteinfolog%
cmd /c ipconfig /all  >>%siteinfolog%

:filehash
echo.
echo %lines%
echo [INFO] Generating MD5 hashes for RTS files......
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
echo %lines%
endlocal

:zipthefolder
timeout /t 2 >nul
echo.
echo %lines%
echo [INFO] Compressing backup files...
start "***Compressing backup files...***      ***Do not close this window.***" /wait powershell Compress-Archive "%backupfolder1%" "%ZIPFILE%"
echo [INFO] Completed compressing backup files. Continuing...

:cleanup
timeout /t 1 >nul
echo [INFO] Cleaning up...
if exist %zipfile% rmdir /s /q %backupfolder1%
del C:\Dumac\PathList.txt

echo.
echo %stars% && echo %stars%
echo                      PLEASE READ THE LOG FILE TO ENSURE ALL OF YOUR
echo                      RTS FILES BACKED UP SUCCESSFULLY!
echo.
echo                      SPECIFICALLY, LOOK FOR ANY [WARN] MESSAGES
echo                      IN THIS WINDOW.
echo.
echo                      The backup file is in the below location:
echo                      %ZIPFILE%
echo %stars% && echo %stars%
echo.
echo **THIS WINDOW WILL CLOSE AUTOMATICALLY IN 5 MINUTES IF YOU DO NOT EXIT**
timeout /t 300 >nul
