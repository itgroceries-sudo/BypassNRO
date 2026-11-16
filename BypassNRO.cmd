@echo off
setlocal EnableDelayedExpansion
chcp 65001 >nul
title ITG FastOOBE ^& Post-Setup Tweaks

rem ------------------------------------------------------------------------------
rem [ ZONE 1: UAC GATEKEEPER ]
rem ------------------------------------------------------------------------------
reg query "HKLM\System\CurrentControlSet\Control\MiniNT" >nul 2>&1
if !errorlevel! neq 0 (
    fsutil dirty query %systemdrive% >nul 2>&1
    if !errorlevel! neq 0 (
        powershell -NoProfile -Command "Start-Process -FilePath '%~f0' -Verb RunAs"
        exit /b
    )
)

rem ------------------------------------------------------------------------------
rem [ ZONE 2: INITIALIZE COLORS ]
rem ------------------------------------------------------------------------------
for /F "tokens=1,2 delims=#" %%a in ('"prompt #$H#$E# & echo on & for %%b in (1) do rem"') do set "ESC=%%b"
set "0=!ESC![0m" & set "b=!ESC![1m" & set "_=!ESC![4m" & set "_0=!ESC![24m"
set "ck=!ESC![30m" & set "cr=!ESC![31m" & set "cg=!ESC![32m" & set "cy=!ESC![33m"
set "cc=!ESC![36m" & set "cw=!ESC![37m"
set "bgm=!ESC![45m" & set "bgr=!ESC![41m" & set "bgb=!ESC![44m" & set "bgw=!ESC![47m" & set "bgg=!ESC![42m"
set "sbgm=!ESC![105m"

rem ------------------------------------------------------------------------------
rem [ ZONE 3: HARDWARE SCANNER ]
rem ------------------------------------------------------------------------------
set "SYS_CPU="
for /f "tokens=2*" %%A in ('reg query "HKLM\HARDWARE\DESCRIPTION\System\CentralProcessor\0" /v ProcessorNameString 2^>nul ^| find /i "REG_SZ"') do set "SYS_CPU=%%B"
if defined SYS_CPU (
    set "SYS_CPU=!SYS_CPU:Intel(R) =!"
    set "SYS_CPU=!SYS_CPU:Core(TM) =!"
    set "SYS_CPU=!SYS_CPU: CPU=!"
    set "SYS_CPU=!SYS_CPU:(R)=!"
    set "SYS_CPU=!SYS_CPU:(TM)=!"
) else ( set "SYS_CPU=Unknown CPU" )

set "SYS_RAM="
for /f "tokens=2 delims==" %%A in ('powershell -NoProfile -Command "Write-Output ('TotalPhysicalMemory=' + (Get-CimInstance Win32_ComputerSystem).TotalPhysicalMemory)" 2^>nul') do for /f "delims=" %%B in ("%%A") do set "RAM_BYTES=%%B"
if defined RAM_BYTES (
    set "RAM_MB=!RAM_BYTES:~0,-6!"
    set /a "RAM_GB=(RAM_MB + 536) / 1073"
    set "SYS_RAM=!RAM_GB! GB"
) else ( set "SYS_RAM=Unknown" )

set "SYS_MB_MFG=" & set "SYS_MB_PROD="
for /f "tokens=2*" %%A in ('reg query "HKLM\HARDWARE\DESCRIPTION\System\BIOS" /v BaseBoardManufacturer 2^>nul ^| find /i "REG_SZ"') do set "SYS_MB_MFG=%%B"
for /f "tokens=2*" %%A in ('reg query "HKLM\HARDWARE\DESCRIPTION\System\BIOS" /v BaseBoardProduct 2^>nul ^| find /i "REG_SZ"') do set "SYS_MB_PROD=%%B"
if defined SYS_MB_MFG (
    set "SYS_MB_MFG=!SYS_MB_MFG:Micro-Star International Co., Ltd.=MSI!"
    set "SYS_MB_MFG=!SYS_MB_MFG:ASUSTeK COMPUTER INC.=ASUS!"
    set "SYS_MB_MFG=!SYS_MB_MFG:Gigabyte Technology Co., Ltd.=Gigabyte!"
    set "SYS_MB_MFG=!SYS_MB_MFG:Hewlett-Packard=HP!"
    set "SYS_MB_MFG=!SYS_MB_MFG:HP Inc.=HP!"
)
set "SYS_BOARD=!SYS_MB_MFG! !SYS_MB_PROD!"
if "!SYS_BOARD!"==" " set "SYS_BOARD=Unknown Board"

set "SYS_VGA="
for /f "tokens=2 delims==" %%A in ('powershell -NoProfile -Command "Write-Output ('name=' + (Get-CimInstance Win32_VideoController)[0].Name)" 2^>nul') do for /f "delims=" %%B in ("%%A") do set "SYS_VGA=%%B"
if defined SYS_VGA ( set "SYS_VGA=!SYS_VGA:(R)=!" & set "SYS_VGA=!SYS_VGA: Corporation=!" )
if "!SYS_VGA!"=="" set "SYS_VGA=Unknown VGA"

rem ------------------------------------------------------------------------------
rem [ ZONE 4: UI & SMART USER INPUT (LODE MENU) ]
rem ------------------------------------------------------------------------------
:MAIN_MENU
cls
mode con:cols=98 lines=28

set "BANNER_TEXT=   !b!!bgg!!cw!Facebook:!_!FB.COM/KHOMSO(R)N!_0! !bgb!FANPAGE:!_!FB.COM/Adm1n1straTOE(TM)!_0! !bgr!Youtube:!_!YT.COM/@ITGRO(C)ERIES!_0!!sbgm!   !0!"
echo( !sbgm!                                                                                               !0!
echo( !sbgm!!BANNER_TEXT!
echo( !sbgm!                                                                                               !0!
echo( !b!!cr!===============================================================================================!0!

set "RAW_LINE=CPU:!SYS_CPU!  RAM:!SYS_RAM!  M/B:!SYS_BOARD!  VGA:!SYS_VGA!"
set "PAD_LINE=!RAW_LINE!                                                                                        "
set "PAD_LINE=!PAD_LINE:~0,87!"
for %%C in ("!cc!") do for %%Y in ("!cy!") do (
    set "PAD_LINE=!PAD_LINE:CPU:=%%~CCPU:%%~Y!"
    set "PAD_LINE=!PAD_LINE:RAM:=%%~CRAM:%%~Y!"
    set "PAD_LINE=!PAD_LINE:M/B:=%%~CM/B:%%~Y!"
    set "PAD_LINE=!PAD_LINE:VGA:=%%~CVGA:%%~Y!"
)
echo( !b!!bgm!    !PAD_LINE!    !0!
echo( !b!!cr!===============================================================================================!0!
echo/
echo( !b!!cg!----------------------------------- [v3.1 - LODE ^& LangMenu] ----------------------------------!0!
echo/
echo( !b!!cr!===============================================================================================!0!
echo(      !cr![H] !cg!^^!^^! !cw!for ^^!HomePath^^!         !cr![T]!cw!askmgr !cg!^^!^^! !cw!Task Manager         !cw!e!cr![X]!cw!it !cg!^^!^^! !cw!for Exit!0!
echo( !b!!cw!-----------------------------------------------------------------------------------------------!0!
echo/
echo(      !bgr!!cw! [L] Local Account Mode (OOBE)       !0!     !bgw!!ck! [M] Device Manager                    !0!
echo(      !bgb!!cw! [O] Online Account Mode (OOBE)      !0!     !bgw!!ck! [K] Disk Management                   !0!
echo(      !bgw!!ck! [D] Desktop Tweaks (Current User)   !0!     !bgw!!ck! [U] User Accounts (netplwiz)          !0!
echo(      !b!!cr! [E] Exit Program                      !0!   !bgw!!ck! [R] Registry Editor                   !0!
echo/
echo( !b!!cw!-----------------------------------------------------------------------------------------------!0!
echo( !b!!cr!===============================================================================================!0!
echo/

set "opt="
set /p "opt=!b!!cg!   Select option [!cw!L, O, D, E, M, K, U, R!cg!] : !0!"

if /i "!opt!"=="H" explorer.exe "%USERPROFILE%" & goto MAIN_MENU
if /i "!opt!"=="T" start "" taskmgr & goto MAIN_MENU
if /i "!opt!"=="X" exit /b
if /i "!opt!"=="E" exit /b

if /i "!opt!"=="M" start "" devmgmt.msc & goto MAIN_MENU
if /i "!opt!"=="K" start "" diskmgmt.msc & goto MAIN_MENU
if /i "!opt!"=="U" start "" netplwiz & goto MAIN_MENU
if /i "!opt!"=="R" start "" regedit & goto MAIN_MENU

if /i "!opt!"=="L" goto MODE_LOCAL
if /i "!opt!"=="O" goto MODE_ONLINE
if /i "!opt!"=="D" goto MODE_DESKTOP
goto MAIN_MENU

:MODE_ONLINE
set "SETUP_MODE=ONLINE"
goto SUMMARY_SCREEN

:MODE_DESKTOP
set "SETUP_MODE=DESKTOP"
goto SUMMARY_SCREEN

:MODE_LOCAL
set "SETUP_MODE=LOCAL"
echo/
set "NEW_USER="
rem รองรับการสลับโหมดทันที หากพิมพ์ O, D, E หรือ B (Back)
set /p "NEW_USER=!b!!cg!   Enter Local Account Name [Default: User, !cw!B!cg! for Back] : !0!"
if /i "!NEW_USER!"=="B" goto MAIN_MENU
if /i "!NEW_USER!"=="O" goto MODE_ONLINE
if /i "!NEW_USER!"=="D" goto MODE_DESKTOP
if /i "!NEW_USER!"=="E" exit /b
if /i "!NEW_USER!"=="L" goto MODE_LOCAL
if "!NEW_USER!"=="" set "NEW_USER=User"

:LANG_MENU
cls
echo/
echo(  !b!!cw!-------------------------------------------------------------------------!0!
echo(  !b!!cy!   Select System Region ^& Language (Local Mode only)!0!
echo(  !b!!cw!-------------------------------------------------------------------------!0!
echo(    !cw![ 1 ] Thai (Auto) - Default      [ 6 ] Korean!0!
echo(    !cw![ 2 ] English (US)               [ 7 ] Russian!0!
echo(    !cw![ 3 ] Chinese (PRC)              [ 8 ] German!0!
echo(    !cw![ 4 ] Chinese (Taiwan)           [ 9 ] French!0!
echo(    !cw![ 5 ] Japanese                   [ 10] Arabic!0!
echo/
echo(    !cw![ B ] Back to Main Menu!0!
echo/
set "LANG_OPT="
set /p "LANG_OPT=!b!!cg!   Choose [!cw!1-10, B!cg!] (Press Enter for 1) : !0!"

if /i "!LANG_OPT!"=="B" goto MAIN_MENU
if "!LANG_OPT!"=="" set "LANG_OPT=1"

rem ใช้โค้ดบรรทัดเดียวป้องกัน Error วงเล็บตีกันใน Batch
if "!LANG_OPT!"=="1" set "LANG_NAME=Thai (Auto)" & set "SYS_LOCALE=th-TH" & set "GEO_ID=227" & set "LANG_LIST=en-US,th-TH" & set "SYS_TZ=SE Asia Standard Time" & goto SUMMARY_SCREEN
if "!LANG_OPT!"=="2" set "LANG_NAME=English (US)" & set "SYS_LOCALE=en-US" & set "GEO_ID=244" & set "LANG_LIST=en-US" & set "SYS_TZ=Pacific Standard Time" & goto SUMMARY_SCREEN
if "!LANG_OPT!"=="3" set "LANG_NAME=Chinese (PRC)" & set "SYS_LOCALE=zh-CN" & set "GEO_ID=45" & set "LANG_LIST=zh-CN,en-US" & set "SYS_TZ=China Standard Time" & goto SUMMARY_SCREEN
if "!LANG_OPT!"=="4" set "LANG_NAME=Chinese (Taiwan)" & set "SYS_LOCALE=zh-TW" & set "GEO_ID=237" & set "LANG_LIST=zh-TW,en-US" & set "SYS_TZ=Taipei Standard Time" & goto SUMMARY_SCREEN
if "!LANG_OPT!"=="5" set "LANG_NAME=Japanese" & set "SYS_LOCALE=ja-JP" & set "GEO_ID=122" & set "LANG_LIST=ja-JP,en-US" & set "SYS_TZ=Tokyo Standard Time" & goto SUMMARY_SCREEN
if "!LANG_OPT!"=="6" set "LANG_NAME=Korean" & set "SYS_LOCALE=ko-KR" & set "GEO_ID=134" & set "LANG_LIST=ko-KR,en-US" & set "SYS_TZ=Korea Standard Time" & goto SUMMARY_SCREEN
if "!LANG_OPT!"=="7" set "LANG_NAME=Russian" & set "SYS_LOCALE=ru-RU" & set "GEO_ID=203" & set "LANG_LIST=ru-RU,en-US" & set "SYS_TZ=Russian Standard Time" & goto SUMMARY_SCREEN
if "!LANG_OPT!"=="8" set "LANG_NAME=German" & set "SYS_LOCALE=de-DE" & set "GEO_ID=94" & set "LANG_LIST=de-DE,en-US" & set "SYS_TZ=W. Europe Standard Time" & goto SUMMARY_SCREEN
if "!LANG_OPT!"=="9" set "LANG_NAME=French" & set "SYS_LOCALE=fr-FR" & set "GEO_ID=84" & set "LANG_LIST=fr-FR,en-US" & set "SYS_TZ=Romance Standard Time" & goto SUMMARY_SCREEN
if "!LANG_OPT!"=="10" set "LANG_NAME=Arabic" & set "SYS_LOCALE=ar-SA" & set "GEO_ID=205" & set "LANG_LIST=ar-SA,en-US" & set "SYS_TZ=Arab Standard Time" & goto SUMMARY_SCREEN
goto LANG_MENU

:SUMMARY_SCREEN
cls
echo/
echo(  !b!!cw!-------------------------------------------------------------------------!0!
echo(  !b!!cy!   [ SUMMARY ] Please Review Your Settings!0!
echo(  !b!!cw!-------------------------------------------------------------------------!0!

rem ใช้ goto โดดข้ามแทนการใช้ if() ครอบ เพื่อหลีกเลี่ยงวงเล็บในข้อความ echo ตีกับระบบ
if "!SETUP_MODE!"=="LOCAL" goto SUM_LOCAL
if "!SETUP_MODE!"=="ONLINE" goto SUM_ONLINE
if "!SETUP_MODE!"=="DESKTOP" goto SUM_DESKTOP

:SUM_LOCAL
echo(    !cw!Mode       : !cg!Local Account Mode (OOBE)!0!
echo(    !cw!Username   : !cg!!NEW_USER!!0!
echo(    !cw!Language   : !cg!!LANG_NAME!!0!
goto SUM_CONFIRM

:SUM_ONLINE
echo(    !cw!Mode       : !bgb!Online Account Mode (OOBE)!0!
echo(    !cw!Action     : Inject UI Tweaks ONLY. (No User Created, No Restart)!0!
goto SUM_CONFIRM

:SUM_DESKTOP
echo(    !cw!Mode       : !bgw!!ck!Desktop Tweaks (Current User)!0!
echo(    !cw!Action     : Apply Tweaks to Current Desktop Profile.!0!
goto SUM_CONFIRM

:SUM_CONFIRM
echo(  !b!!cw!-------------------------------------------------------------------------!0!
echo/
set "CONFIRM="
set /p "CONFIRM=!b!!cg!   Press [!cw!Y!cg!] to Start Setup or [!cw!B!cg!] to Back : !0!"
if /i "!CONFIRM!"=="B" goto MAIN_MENU
if /i "!CONFIRM!"=="Y" goto RUN_SETUP
goto SUMMARY_SCREEN

:RUN_SETUP
rem ------------------------------------------------------------------------------
rem [ ZONE 5: SYSTEM WIDE REGISTRY & LOCALE ]
rem ------------------------------------------------------------------------------
echo/
echo [PROCESS] Configuring System Registry ^& Network Sharing...

reg add "HKLM\SYSTEM\CurrentControlSet\Services\LanmanWorkstation\Parameters" /v "AllowInsecureGuestAuth" /t REG_DWORD /d 1 /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Services\LanmanWorkstation\Parameters" /v "RequireSecuritySignature" /t REG_DWORD /d 0 /f >nul 2>&1
schtasks /delete /tn "\Microsoft\Windows\Servicing\OOBEFodSetup" /f >nul 2>&1

reg add "HKLM\SYSTEM\CurrentControlSet\Control\BitLocker" /v "PreventDeviceEncryption" /t REG_DWORD /d 1 /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Network\NewNetworkWindowOff" /v "" /f >nul 2>&1
label C: OS Windows (x64) >nul 2>&1

reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\OOBE" /v BypassNRO /t reg_dword /d 1 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\OOBE" /v DisablePrivacyExperience /t REG_DWORD /d 1 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System" /v EnableFirstLogonAnimation /t reg_dword /d 0 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon" /v EnableFirstLogonAnimation /t reg_dword /d 0 /f >nul 2>&1

rem ตั้งค่า Locale เฉพาะโหมด Local เท่านั้น เพื่อไม่กวนภาษาเดิมในโหมด Online/Desktop
if "!SETUP_MODE!"=="LOCAL" (
    echo [PROCESS] Applying Region [!SYS_LOCALE!] ^& TimeZone [!SYS_TZ!]...
    "%SystemRoot%\System32\WindowsPowerShell\v1.0\powershell.exe" -NoProfile -Command "Set-WinSystemLocale !SYS_LOCALE!; Set-WinHomeLocation -GeoId !GEO_ID!" >nul 2>&1
    tzutil /s "!SYS_TZ!" >nul 2>&1
)

rem ------------------------------------------------------------------------------
rem [ ZONE 6: DYNAMIC USER INJECTION ]
rem ------------------------------------------------------------------------------
if "!SETUP_MODE!"=="DESKTOP" (
    set "REG_ROOT=HKCU"
    echo [PROCESS] Applying Desktop Icons ^& UI Tweaks to CURRENT USER...
)
if not "!SETUP_MODE!"=="DESKTOP" (
    set "REG_ROOT=HKU\DefUser"
    echo [PROCESS] Injecting Desktop Icons ^& UI Tweaks to DEFAULT USER...
    reg load "HKU\DefUser" "C:\Users\Default\NTUSER.DAT" >nul 2>&1
)

FOR %%L IN ({5399E694-6CE5-4D6C-8FCE-1D8870FDCBA0} {F02C1A0D-BE21-4350-88B0-7367FC96EF3C} {20D04FE0-3AEA-1069-A2D8-08002B30309D} {59031a47-3f72-44a7-89c5-5595fe6b30ee}) DO (
    reg add "!REG_ROOT!\Software\Microsoft\Windows\CurrentVersion\Explorer\HideDesktopIcons\NewStartPanel" /v %%L /t REG_DWORD /d 0 /f >nul 2>&1
    reg add "!REG_ROOT!\Software\Microsoft\Windows\CurrentVersion\Explorer\HideDesktopIcons\ClassicStartMenu" /v %%L /t REG_DWORD /d 0 /f >nul 2>&1
)

reg add "!REG_ROOT!\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v LaunchTo /t reg_dword /d 1 /f >nul 2>&1
reg add "!REG_ROOT!\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v ShowSecondsInSystemClock /t REG_DWORD /d 1 /f >nul 2>&1
reg add "!REG_ROOT!\Control Panel\International" /v sShortDate /t reg_sz /d "ddd/d/MMM" /f >nul 2>&1
reg add "!REG_ROOT!\Software\Policies\Microsoft\Windows\WindowsCopilot" /v TurnOffWindowsCopilot /t reg_dword /d 1 /f >nul 2>&1
reg add "!REG_ROOT!\Software\Microsoft\Windows\CurrentVersion\Run" /v OneDriveSetup /d "" /f >nul 2>&1
reg add "!REG_ROOT!\Software\Microsoft\Edge" /v HideFirstRunExperience /t REG_DWORD /d 1 /f >nul 2>&1
reg add "!REG_ROOT!\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" /v SubscribedContent-310093Enabled /t reg_dword /d 0 /f >nul 2>&1
reg add "!REG_ROOT!\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" /v SubscribedContent-338389Enabled /t reg_dword /d 0 /f >nul 2>&1

rem บังคับรันสคริปต์สลับภาษาในโหมด Local เท่านั้น (กันบั๊กภาษาเพี้ยนในโหมดอื่น)
if "!SETUP_MODE!"=="LOCAL" (
    if not exist "%SystemRoot%\Setup\Scripts" mkdir "%SystemRoot%\Setup\Scripts" >nul 2>&1
    set "RUNONCE_FILE=%SystemRoot%\Setup\Scripts\ITG_LangFix.cmd"
    (
        echo @echo off
        echo "%SystemRoot%\System32\WindowsPowerShell\v1.0\powershell.exe" -NoProfile -Command "Set-Culture !SYS_LOCALE!" ^^^>nul 2^^^>^^^&1
        echo "%SystemRoot%\System32\WindowsPowerShell\v1.0\powershell.exe" -NoProfile -Command "Set-WinUserLanguageList -LanguageList !LANG_LIST! -Force" ^^^>nul 2^^^>^^^&1
        
        rem ตั้งค่าปุ่มตัวหนอน (Grave Accent) เฉพาะคีย์บอร์ดไทย
        if "!SYS_LOCALE!"=="th-TH" (
            echo reg add "HKCU\Keyboard Layout\Toggle" /v Hotkey /t REG_SZ /d 4 /f ^^^>nul 2^^^>^^^&1
            echo reg add "HKCU\Keyboard Layout\Toggle" /v "Language Hotkey" /t REG_SZ /d 4 /f ^^^>nul 2^^^>^^^&1
            echo reg add "HKCU\Keyboard Layout\Toggle" /v "Layout Hotkey" /t REG_SZ /d 3 /f ^^^>nul 2^^^>^^^&1
        )
        echo reg delete "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\RunOnce" /v "ITG_Init" /f ^^^>nul 2^^^>^^^&1
        echo del "%%%%~f0"
    ) > "!RUNONCE_FILE!"
    reg add "!REG_ROOT!\SOFTWARE\Microsoft\Windows\CurrentVersion\RunOnce" /v "ITG_Init" /t REG_SZ /d "!RUNONCE_FILE!" /f >nul 2>&1
)

if not "!SETUP_MODE!"=="DESKTOP" reg unload "HKU\DefUser" >nul 2>&1

rem ------------------------------------------------------------------------------
rem [ ZONE 7: USER CREATION & AUTO-LOGIN ]
rem ------------------------------------------------------------------------------
if "!SETUP_MODE!"=="ONLINE" goto SKIP_LOCAL
if "!SETUP_MODE!"=="DESKTOP" goto SKIP_LOCAL

echo [PROCESS] Creating Account ^& Enforcing Auto-Login...

net user "!NEW_USER!" "" /add >nul 2>&1
net localgroup Administrators "!NEW_USER!" /add >nul 2>&1

if exist "%SystemRoot%\System32\WindowsPowerShell\v1.0\powershell.exe" (
    "%SystemRoot%\System32\WindowsPowerShell\v1.0\powershell.exe" -NoProfile -Command "Set-LocalUser -Name '!NEW_USER!' -PasswordNeverExpires $true" >nul 2>&1
) else (
    powershell -NoProfile -Command "Set-LocalUser -Name '!NEW_USER!' -PasswordNeverExpires $true" >nul 2>&1
)
net accounts /maxpwage:unlimited >nul 2>&1

rem ลบโปรไฟล์ผีเฉพาะใน Local Mode
net user defaultuser0 /delete >nul 2>&1
if exist "C:\Users\defaultuser0" rmdir /s /q "C:\Users\defaultuser0" >nul 2>&1
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon\SpecialAccounts\UserList" /v defaultuser0 /t REG_DWORD /d 0 /f >nul 2>&1

reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon" /v AutoAdminLogon /t REG_SZ /d "1" /f >nul 2>&1
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon" /v DefaultUserName /t REG_SZ /d "!NEW_USER!" /f >nul 2>&1
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon" /v DefaultPassword /t REG_SZ /d "" /f >nul 2>&1

goto FINISH_ZONE7

:SKIP_LOCAL
echo [PROCESS] Skipping Local User Creation...

:FINISH_ZONE7
rem ------------------------------------------------------------------------------
rem [ ZONE 8: THE MAGIC EXECUTION ]
rem ------------------------------------------------------------------------------
echo/

if "!SETUP_MODE!"=="DESKTOP" (
    echo !b!!cm![DONE] Desktop tweaks successfully applied to Current User!!0!
    echo !cw!Please sign out or restart your computer to apply all changes.!0!
    echo/
    pause
    exit /b
)

if "!SETUP_MODE!"=="ONLINE" (
    echo !b!!cg![DONE] Online tweaks successfully injected to Default User!!0!
    echo !cw!Press any key to completely close this window and continue Windows Setup.!0!
    echo/
    pause >nul
    taskkill /f /im powershell.exe >nul 2>&1
    taskkill /f /im cmd.exe >nul 2>&1
    exit
)

echo !b!!cy![FINISHING] Finalizing Setup... Please wait.!0!
echo/

reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Setup\State" /v "ImageState" /t REG_SZ /d "IMAGE_STATE_COMPLETE" /f >nul 2>&1
reg add "HKLM\SYSTEM\Setup" /v "OOBEInProgress" /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKLM\SYSTEM\Setup" /v "SetupType" /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKLM\SYSTEM\Setup" /v "SystemSetupInProgress" /t REG_DWORD /d 0 /f >nul 2>&1

pushd "%SystemRoot%\System32\oobe"
if exist "msoobe.exe" start "" /b msoobe.exe >nul 2>&1
popd

echo !b!!cg![DONE] Rebooting to Desktop in 10 seconds...!0!
"%SystemRoot%\System32\shutdown.exe" /r /t 10 /f /c "ITG FastOOBE: Finalizing setup. System will boot to Desktop automatically."

if !errorlevel! neq 0 (
    if exist "%SystemRoot%\System32\WindowsPowerShell\v1.0\powershell.exe" (
        "%SystemRoot%\System32\WindowsPowerShell\v1.0\powershell.exe" -NoProfile -Command "Restart-Computer -Force" >nul 2>&1
    ) else (
        powershell -NoProfile -Command "Restart-Computer -Force" >nul 2>&1
    )
)

pause
exit /b
