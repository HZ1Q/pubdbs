@echo on

rem Set the directory where the ZIP files are located
set zipfolder=%~dp0
setlocal enabledelayedexpansion
rem Get a list of all ZIP files in the directory that start with "RTSBACKUP-"
set cnt=0
for /f "delims=" %%i in ('dir /b /a-d "%zipfolder%\RTSBACKUP-*.zip"') do (
    set /A cnt+=1
    set "file=%%~i"
    set "file=!file:~11!"
    echo !cnt! - !file!
)

rem Prompt the user to select a file to extract
set /p "fileNum=Enter the number of the file you want to extract: "

rem Extract the selected file
set cnt=0
for /f "delims=" %%i in ('dir /b /a-d "%zipfolder%\RTSBACKUP-*.zip"') do (
    set /A cnt+=1
    if !cnt!==%fileNum% (
        set "file=%%~i"
        set "file=!file:~11!"
	start /min "***Compressing backup files...***      ***Do not close this window.***" /wait powershell Expand-Archive "%zipfolder%%FILENUM%" "%ZIPFILE%%FILENUM:~0,-1%"
        echo The file RTSBACKUP-!file!.zip has been extracted successfully!
        goto :break
    )
)
:break

pause
