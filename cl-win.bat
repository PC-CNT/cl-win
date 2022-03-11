::タイトル未定
::author PC-CNT

@echo off
@setlocal DisableDelayedExpansion


chcp 65001 > nul
set "__name=私的Win10環境構築ツール（仮）"
set "__version=1.01"


:: ====管理者権限の確認====
openfiles > nul 2>&1
if not %errorlevel% == 0 (
    powershell start-process \"%~f0\" -verb runas 
    exit /b
)

title %__name% v%__version%
mode 80, 32
cd /d %~dp0

:: ==============ここからメインメニュー===============
:MAIN
cls
echo:
echo:
echo:
echo:       ==========================================================
echo:
echo:       [1] ソフトウェア関連
echo:       [2] レジストリ関連
echo:       [3] その他           
echo:       [4] 情報
echo:       [0] 終了                                
echo:
echo:       ==========================================================
echo:
echo:
echo:


:: choiceの仕様に苦戦した
:: 左から1,2,3,4……が%errorlevel%に格納される
:: 入力した文字は関係ないとのこと
choice /c:12340 /n > nul

if %errorlevel% == 5 (
    goto :EXIT
)

if %errorlevel% == 4 (
    goto :INFO
)

if %errorlevel% == 3 (
    goto :OTHER 
)

if %errorlevel% == 2 (
    goto :REG_MENU
)

if %errorlevel% == 1 (
    goto :SOFTWARE
)

:: ==============ここまでメインメニュー==============


:SOFTWARE

:: start https://code.visualstudio.com/sha/download?build=insider^&os=win32-x64-user

goto :MAIN

:REG_MENU
cls
echo:
echo:
echo:
echo:      ==========================================================
echo:
echo:      [1] レジストリを追加（一括） 
echo:      [2] レジストリを追加（選択） 
echo:      [0] メインメニューへ戻る 
echo:
echo:      ==========================================================
echo:
echo:
echo:

choice /c:120 /n > nul

if %errorlevel% == 3 (
    goto :MAIN
)

if %errorlevel% == 1 (
    goto :REG_ADD_ALL
)

if %errorlevel% == 2 (
    goto :REG_ADD_SELECT
)

goto :MAIN


:: ====================--ここからレジストリ追加--=============================
:REG_ADD_ALL
cls
echo:
echo:
echo:      以下のレジストリを追加します 本当に追加しますか？[Y,N]
echo:
echo:
echo:
echo:
@REM type all.reg


choice > nul

if %errorlevel% == 2 (
    goto :REG_MENU
)

if %errorlevel% == 1 (
    @REM reg add "HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v "HideFileExt" /t REG_DWORD /d "0" /f
    @REM chdir %temp%
    reg import all.reg
    cd /d %~dp0
    pause > nul
)

goto :REG_MENU
:: ====================--ここまでレジストリ追加--=============================


:INFO
cls
echo: info
pause > nul
goto :MAIN


:OTHER
cls
echo:
echo:
echo:
echo:       ==========================================================
echo:
echo:       [1] 環境変数の確認                      
echo:       [2] エクスプローラー再起動      
echo:       [0] メインメニューへ戻る                 
echo:
echo:       ==========================================================
echo:
echo:
echo:

choice /c:120 /n > nul

if %errorlevel% == 3 (
    goto :MAIN
)

if %errorlevel% == 1 (
    goto :CHECKENV
)

if %errorlevel% == 2 (
    taskkill /IM explorer.exe /F
    explorer
    goto :OTHER
)

goto :OTHER

:CHECKENV
cls
set
if defined %JAVA_HOME% (
    echo: Javaのパスが通ってるようです
)
pause > nul
goto :OTHER



:: =============終了処理=============
:EXIT
echo: 終了します……
timeout /t 2 /nobreak >nul
exit /b