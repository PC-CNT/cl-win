::タイトル未定
::author PC-CNT

@echo off
@setlocal DisableDelayedExpansion


chcp 65001 > nul
set "__name=私的Win10環境構築ツール（仮）"
set "__version=1.02"


:: ====管理者権限の確認====
openfiles > nul 2>&1
if not %errorlevel% == 0 (
    powershell start-process \"%~f0\" -verb runas 
    exit /b
)


title %__name% v%__version%

:: ==============ここからメインメニュー===============
:__MAIN


mode con: cols=80 lines=32
:: https://maku77.github.io/windows/settings/change-window-size.html
powershell -command "&{$h=Get-Host;$w=$h.UI.RawUI;$s=$w.BufferSize;$s.height=6000;$w.BufferSize=$s;}"
@echo off
@setlocal DisableDelayedExpansion
cd /d %~dp0
color 07


cls
echo:      
echo:      
echo:      
echo:      ==================================================================
echo:      
echo:      [1] ソフトウェア関連
echo:      [2] レジストリ関連
echo:      [3] その他           
echo:      [4] 情報
echo:      [0] 終了                                
echo:      
echo:      ==================================================================
echo:      
echo:      
echo:      


:: choiceの仕様に苦戦した
:: 左から1,2,3,4……が%errorlevel%に格納される
:: 入力した文字は関係ないとのこと
choice /c:12340 /n > nul

if %errorlevel% == 5 (
    goto :__EXIT
)

if %errorlevel% == 4 (
    call :__INFO
    goto :__MAIN
)

if %errorlevel% == 3 (
    call :__OTHER
    goto :__MAIN
)

if %errorlevel% == 2 (
    call :__REG_MENU
    goto :__MAIN
)

if %errorlevel% == 1 (
    call :__SOFTWARE
    goto :__MAIN
)

goto :__MAIN

:: ==============ここまでメインメニュー==============



:: =============ここからソフトウェア関連===============
:__SOFTWARE
cls


:: curlはv1803以降にしか付属してないらしい
where curl > nul
if not %errorlevel% == 0 (
    set "CURL_EXIST=FALSE"
) else (
    set "CURL_EXIST=TRUE"
)

:: start https://code.visualstudio.com/sha/download?build=insider^&os=win32-x64-user

echo:      
echo:      
echo:      
echo:      ==================================================================
echo:      
echo:      [1] Visual Studio Code 
echo:      [2] Google Chrome 
echo:      
echo:      [0] 戻る 
echo:      
echo:      ==================================================================

choice /c:120 /n > nul

if %errorlevel% == 3 (
    goto :__MAIN
)

if %errorlevel% == 1 (
    goto :__VS_CODE
)

if %errorlevel% == 2 (
    goto :__CHROME
)


pause > nul

@REM goto :__MAIN
exit /b
:: =============ここまでソフトウェア関連===============


:: ==================ここからVisual Studio Code====================
:__VS_CODE
cls

echo:      
echo:      
echo:      
echo:      ==================================================================
echo:      
echo:      [1] Visual Studio Code
echo:      [2] Visual Studio Code Insiders
echo:      
echo:      [0] 戻る
echo:      
echo:      ==================================================================
echo:      

choice /c:120 /n > nul

if %errorlevel% == 3 (
    goto :__SOFTWARE
)

if %errorlevel% == 1 (
    set "__BUILD=stable"
)

if %errorlevel% == 2 (
    set "__BUILD=insider"
)


cls

echo:      
echo:      
echo:      
echo:      ==================================================================
echo:      
echo:      [1] User Installer   
echo:      [2] System Installer 
echo:      
echo:      [0] 戻る
echo:      
echo:      ==================================================================
echo:      

choice /c:120 /n > nul

if %errorlevel% == 3 (
    goto :__SOFTWARE
)



if %errorlevel% == 1 (
    set "INSTALL_TYPE=win32-x64-user"
)

if %errorlevel% == 2 (
    set "INSTALL_TYPE=win32-x64"
)

set "_URL=https://code.visualstudio.com/sha/download?build=%__BUILD%&os=%INSTALL_TYPE%"

cls


echo:      
echo:      
echo:      
echo:      ==================================================================
echo:      
echo:      Visual Studio Code %__BUILD% （ %INSTALL_TYPE% ）  
echo:      をダウンロード、インストールします。よろしいですか？[y/n] 
echo:      "%_URL%"
echo:      
echo:      ==================================================================
echo:      


choice > nul

if %errorlevel% == 2 (
    goto :__SOFTWARE
)

if %errorlevel% == 1 (
    mkdir C:\temp
    if %CURL_EXIST% == TRUE (
        curl -L -o "C:\temp\vscodeinstaller.exe" "%_URL%"
    ) else (
        :: https://stackoverflow.com/questions/54917110
        powershell "Invoke-WebRequest '%_URL%' -OutFile C:\temp\vscodeinstaller.exe"
    )
    start C:\temp\vscodeinstaller.exe
)

pause

goto :__SOFTWARE
:: =================ここまでVisual Studio Code====================


:: =================ここからGoogle Chrome====================
:__CHROME
cls

echo:      
echo:      
echo:      
echo:      ==================================================================
echo:      
echo:      [1] Stable   
echo:      [2] Beta     
echo:      [3] Dev      
echo:      [4] Canary   
echo:      
echo:      [0] 戻る
echo:      
echo:      ==================================================================
echo:      

choice /c:12340 /n > nul

if %errorlevel% == 5 (
    goto :__SOFTWARE
)


@REM mkdir C:\temp
@REM curl -L -o "C:\temp\ChromeSetup.exe" https://dl.google.com/tag/s/ap=x64-stable-statsdef_1/update2/installers/ChromeSetup.exe

pause 

goto :__SOFTWARE
:: =================ここまでGoogle Chrome====================


:: ==================ここからレジストリ=====================
:__REG_MENU
cls
echo:      
echo:      
echo:      
echo:      ==================================================================
echo:      
echo:      [1] レジストリを追加（一括） 
echo:      [2] レジストリを追加（選択） 
echo:      [0] メインメニューへ戻る 
echo:      
echo:      ==================================================================
echo:      
echo:      
echo:      

choice /c:120 /n > nul

if %errorlevel% == 3 (
    goto :__MAIN
)

if %errorlevel% == 1 (
    goto :__REG_ADD_ALL
)

if %errorlevel% == 2 (
    echo:   工事中……    
    pause   
    @REM goto :REG_ADD_SELECT
)

@REM goto :__MAIN
exit /b

:: ==================ここまでレジストリ=====================



:: ====================--ここからレジストリ追加--=============================
:__REG_ADD_ALL
cls
echo:      
echo:      
echo:      以下のレジストリを追加します 本当に追加しますか？[Y,N]
echo:      
echo:      

@REM for /f "delims=" %%r in (all.reg) do (
@REM     echo %%r
@REM )

findstr /B ";" all.reg

echo:
echo:


choice > nul

if %errorlevel% == 2 (
    goto :__REG_MENU
)

if %errorlevel% == 1 (
    @REM reg add "HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v "HideFileExt" /t REG_DWORD /d "0" /f
    @REM chdir %temp%
    reg import all.reg
    cd /d %~dp0
    pause > nul
)

goto :__REG_MENU
:: ====================--ここまでレジストリ追加--=============================


:__INFO
cls
mode con: cols=120 lines=32
powershell -command "&{$h=Get-Host;$w=$h.UI.RawUI;$s=$w.BufferSize;$s.height=6000;$w.BufferSize=$s;}"
systeminfo
@REM driverquery /v /fo list
pause > nul
@REM goto :__MAIN
exit /b
:: exit と exit /b で挙動が変わる

:: =============================--↓↓↓その他↓↓↓--=============================
:__OTHER
cls
echo:       
echo:       
echo:       
echo:       ==================================================================
echo:       
echo:       [1] 環境変数の確認                      
echo:       [2] エクスプローラー再起動      
echo:       [3] PC再起動            
echo:       [4] 
echo:       [0] メインメニューへ戻る                 
echo:       
echo:       ==================================================================
echo:       
echo:       
echo:       

choice /c:12340 /n > nul

if %errorlevel% == 5 (
    goto :__MAIN
)

if %errorlevel% == 1 (
    goto :__CHECKENV
)

if %errorlevel% == 2 (
    taskkill /IM explorer.exe /F
    explorer
    goto :__OTHER
)

if %errorlevel% == 3 (
    echo:       再起動しますか？[y,n]
    choice > nul
    if %errorlevel% == 2 (
        goto :__OTHER
    )
    if %errorlevel% == 1 (
        shutdown /r /t 0
    )
)

if %errorlevel% == 4 (
    call :__OPTIMIZE
    goto :__OTHER
)

goto :__OTHER

exit /b
:: =============================--↑↑↑その他↑↑↑--=============================


:__CHECKENV
cls
set
echo:
echo:
echo:
if defined %JAVA_HOME% (
    echo: Javaのパスが通ってるようです
)
pause > nul
goto :__OTHER



:__OPTIMIZE
cls
echo:       
echo:       
echo:       
echo:       ==================================================================
echo:       
echo:       [1] データ送信を停止                      
echo:       [2] 一時ファイルを削除  
echo:       [0] 「その他」トップへ戻る                 
echo:       
echo:       ==================================================================
echo:       
echo:       
echo:       


choice /c:12340 /n > nul

if %errorlevel% == 5 (
    goto :__OTHER
)

if %errorlevel% == 1 (
    call :__A____MS
    goto :__OPTIMIZE
)

if %errorlevel% == 2 (
    call :__DEL_TEMP
    goto :__OPTIMIZE
)

exit /b

:: =============================--↓↓↓スパイウェア停止↓↓↓--=============================
:__A____MS
cls
echo:      
echo:      
echo:      
echo:      以下の作業を行います。よろしいですか？[y,n]
echo:      
echo:      ・Diagnostics Tracking Service（データ送信）の停止
echo:      ・dmwappushsvc（データ送信）の停止
echo:      
echo:      
choice > nul
if %errorlevel% == 2 (
    goto :__OPTIMIZE
)
if %errorlevel% == 1 (
    sc stop Diagtrack
    sc delete Diagtrack
    sc stop dmwappushservice
    pause
)

exit /b
:: =============================--↑↑↑スパイウェア停止↑↑↑--=============================


:: =============
:__DEL_TEMP
cls
echo:      
echo:      
echo:      
echo:      以下の作業を行います。よろしいですか？[y,n]
echo:      
echo:      ・pipのキャッシュを削除
echo:      ・C:\\Windows\servicing\LCU\以下を削除
echo:      ・Dism.exeでのクリーンアップ
echo:      ・.gradleのキャッシュを削除
echo:      
echo:      
choice > nul
if %errorlevel% == 2 (
    goto :__OPTIMIZE
)
if %errorlevel% == 1 (
    where pip > nul
    if %errorlevel% == 0 (
        :: pip cache purge
        :: ↑これ最近のpipじゃないと使えないらしい
        rmdir /s /q %LOCALAPPDATA%\pip\Cache
    )

    rmdir /s /q C:\\Windows\servicing\LCU\

    Dism.exe /online /Cleanup-Image /StartComponentCleanup /ResetBase

    rmdir /s /q %USERPROFILE%\.gradle\caches

)




pause > nul

exit /b
:: =============





:: =============終了処理=============
:__EXIT
echo: 終了します……
timeout /t 2 /nobreak >nul
exit