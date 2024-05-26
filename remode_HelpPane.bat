@echo off
chcp 65001 > nul

if exist "C:\Windows\HelpPane.exe" (

tasklist /FI "IMAGENAME eq HelpPane.exe" 2>NUL | find /I /N "HelpPane.exe">NUL
if "%errorlevel%"=="0" (
    taskkill /F /IM HelpPane.exe
)

takeown /f C:\Windows\HelpPane.exe
icacls C:\Windows\HelpPane.exe /grant administrators:F
del /F /Q C:\Windows\HelpPane.exe

echo "C:\Windows\HelpPane.exeを削除しました"

)
