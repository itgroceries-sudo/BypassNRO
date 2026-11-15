<# : hybrid batch + powershell script
@echo off
chcp 65001 >nul
mode con:cols=98 lines=28
title ITG FastOOBE ^& Post-Setup Tweaks by IT Groceries Co.,ltd.

powershell -noprofile -c "$param='%*';$ScriptPath='%~f0';iex((Get-Content -LiteralPath '%~f0' -Encoding UTF8 -Raw))"
exit /b
#>

# =========================================================
#  ITG FastOOBE & Post-Setup Tweaks (Hybrid Edition)
# =========================================================

$TempCMD = "$env:TEMP\ITG_FastOOBE.cmd"

$BatchCode = @'
:: [BOM Catcher]
@echo off
setlocal EnableDelayedExpansion
chcp 65001 >nul

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
for /F "tokens=1,2 delims=#" %%a in ('"prompt #$H#$E# & echo on & for %%b in (1) do rem"') do set "nhcolor=%%b"
set "0=!nhcolor![0m" & set "b=!nhcolor![1m" & set "_=!nhcolor![4m" & set "_0=!nhcolor![24m"
set "ck=!nhcolor![30m" & set "cr=!nhcolor![31m" & set "cg=!nhcolor![32m" & set "cy=!nhcolor![33m"
set "cb=!nhcolor![34m" & set "cm=!nhcolor![35m" & set "cc=!nhcolor![36m" & set "cw=!nhcolor![37m"
set "bgk=!nhcolor![40m" & set "bgr=!nhcolor![41m" & set "bgg=!nhcolor![42m" & set "bgy=!nhcolor![43m"
set "bgb=!nhcolor![44m" & set "bgm=!nhcolor![45m" & set "bgc=!nhcolor![46m" & set "bgw=!nhcolor![47m"
set "sbgm=!nhcolor![105m"

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
for /f "tokens=2 delims==" %%A in ('wmic ComputerSystem get TotalPhysicalMemory /Value 2^>nul ^|^| powershell -NoProfile -Command "Write-Output ('TotalPhysicalMemory=' + (Get-CimInstance Win32_ComputerSystem).TotalPhysicalMemory)" 2^>nul') do for /f "delims=" %%B in ("%%A") do set "RAM_BYTES=%%B"
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
for /f "tokens=2 delims==" %%A in ('wmic path win32_VideoController get name /Value 2^>nul ^|^| powershell -NoProfile -Command "Write-Output ('name=' + (Get-CimInstance Win32_VideoController)[0].Name)" 2^>nul') do for /f "delims=" %%B in ("%%A") do set "SYS_VGA=%%B"
if defined SYS_VGA ( set "SYS_VGA=!SYS_VGA:(R)=!" & set "SYS_VGA=!SYS_VGA: Corporation=!" )
if "!SYS_VGA!"=="" set "SYS_VGA=Unknown VGA"

rem ------------------------------------------------------------------------------
rem [ ZONE 4: UI & USER INPUT ]
rem ------------------------------------------------------------------------------
:MAIN_MENU
cls
mode con:cols=98 lines=28
title ITG FastOOBE ^& Post-Setup Tweaks by IT Groceries Co.,ltd.

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
echo( !b!!cw!===============================================================================================!0!
echo(      !cr![H] !cg!^^!^^! !cw!for ^^!HomePath^^!         !cr![T]!cw!askmgr !cg!^^!^^! !cw!Task Manager         !cw!e!cr![X]!cw!it !cg!^^!^^! !cw!for Exit!0!
echo( !b!!cw!-----------------------------------------------------------------------------------------------!0!
echo/
echo(      !bgr!!cw! [A] Local Account Mode (OOBE)       !0!     !bgw!!ck! [M] Device Manager                    !0!
echo(      !bgb!!cw! [O] Online Account Mode (OOBE)      !0!     !bgw!!ck! [K] Disk Management                   !0!
echo(      !bgw!!ck! [D] Desktop Tweaks (Current User)   !0!     !bgw!!ck! [U] User Accounts (netplwiz)          !0!
echo(      !b!!cr! [E] Exit Program                      !0!     !bgw!!ck! [R] Registry Editor                   !0!
echo/
echo( !b!!cw!-----------------------------------------------------------------------------------------------!0!
echo( !b!!cr!===============================================================================================!0!
echo/

set "opt="
set /p "opt=!b!!cg!   Select option [!cw!A, O, D, E, M, K, U, R!cg!] : !cw!!b!!0!!nhcolor![K"

if /i "!opt!"=="H" explorer.exe "%USERPROFILE%" & goto MAIN_MENU
if /i "!opt!"=="T" start "" taskmgr & goto MAIN_MENU
if /i "!opt!"=="X" exit /b
if /i "!opt!"=="E" exit /b

rem --- [ SYSTEM TOOLS FOR OOBE ] ---
if /i "!opt!"=="M" start "" devmgmt.msc & goto MAIN_MENU
if /i "!opt!"=="K" start "" diskmgmt.msc & goto MAIN_MENU
if /i "!opt!"=="U" start "" netplwiz & goto MAIN_MENU
if /i "!opt!"=="R" start "" regedit & goto MAIN_MENU

rem --- [ SETUP MODES - FLATTENED LOGIC ] ---
if /i "!opt!"=="D" goto MODE_DESKTOP
if /i "!opt!"=="O" goto MODE_ONLINE
if /i "!opt!"=="A" goto MODE_LOCAL
goto MAIN_MENU

:MODE_DESKTOP
set "SETUP_MODE=DESKTOP"
echo/
echo(  !b!!cm![INFO] Desktop Mode selected. Tweaks will apply to CURRENT USER.!0!
goto RUN_SETUP

:MODE_ONLINE
set "SETUP_MODE=ONLINE"
echo/
echo(  !b!!cg![INFO] Proceeding with Online Mode. (No Local User will be created)!0!
goto RUN_SETUP

:MODE_LOCAL
set "SETUP_MODE=LOCAL"
echo/
set "NEW_USER="
<nul set /p="!b!!cg!   Enter Local Account Name : !cw!!b!"
set /p "NEW_USER="
if "!NEW_USER!"=="" set "NEW_USER=User"
goto RUN_SETUP


:RUN_SETUP
rem ------------------------------------------------------------------------------
rem [ ZONE 5: SYSTEM WIDE REGISTRY & LOCALE ]
rem ------------------------------------------------------------------------------
echo/
echo [PROCESS] Configuring System Region, TimeZone ^& Network Sharing...

reg add "HKLM\SYSTEM\CurrentControlSet\Services\LanmanWorkstation\Parameters" /v "AllowInsecureGuestAuth" /t REG_DWORD /d 1 /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Services\LanmanWorkstation\Parameters" /v "RequireSecuritySignature" /t REG_DWORD /d 0 /f >nul 2>&1

schtasks /delete /tn "\Microsoft\Windows\Servicing\OOBEFodSetup" /f >nul 2>&1

powershell -NoProfile -Command "Set-WinSystemLocale th-TH; Set-WinHomeLocation -GeoId 227" >nul 2>&1
tzutil /s "SE Asia Standard Time" >nul 2>&1

reg add "HKLM\SYSTEM\CurrentControlSet\Control\BitLocker" /v "PreventDeviceEncryption" /t REG_DWORD /d 1 /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Network\NewNetworkWindowOff" /v "" /f >nul 2>&1
label C: OS Windows (x64) >nul 2>&1

reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\OOBE" /v BypassNRO /t reg_dword /d 1 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\OOBE" /v DisablePrivacyExperience /t REG_DWORD /d 1 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System" /v EnableFirstLogonAnimation /t reg_dword /d 0 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon" /v EnableFirstLogonAnimation /t reg_dword /d 0 /f >nul 2>&1

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

set "RUNONCE_FILE=C:\Windows\ITG_LangFix.cmd"
(
    echo @echo off
    echo powershell -NoProfile -Command "Set-Culture th-TH" ^>nul 2^>^&1
    echo powershell -NoProfile -Command "Set-WinUserLanguageList -LanguageList en-US,th-TH -Force" ^>nul 2^>^&1
    echo reg add "HKCU\Keyboard Layout\Toggle" /v Hotkey /t REG_SZ /d 4 /f ^>nul 2^>^&1
    echo reg add "HKCU\Keyboard Layout\Toggle" /v "Language Hotkey" /t REG_SZ /d 4 /f ^>nul 2^>^&1
    echo reg add "HKCU\Keyboard Layout\Toggle" /v "Layout Hotkey" /t REG_SZ /d 3 /f ^>nul 2^>^&1
    echo reg delete "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\RunOnce" /v "ITG_Init" /f ^>nul 2^>^&1
    echo del "%%~f0"
) > "!RUNONCE_FILE!"

reg add "!REG_ROOT!\SOFTWARE\Microsoft\Windows\CurrentVersion\RunOnce" /v "ITG_Init" /t REG_SZ /d "!RUNONCE_FILE!" /f >nul 2>&1

if not "!SETUP_MODE!"=="DESKTOP" reg unload "HKU\DefUser" >nul 2>&1

rem ------------------------------------------------------------------------------
rem [ ZONE 7: USER CREATION & AUTO-LOGIN ] 
rem ------------------------------------------------------------------------------
if not "!SETUP_MODE!"=="LOCAL" goto SKIP_LOCAL

echo [PROCESS] Creating Account ^& Enforcing Auto-Login...
    
rem Create User with explicit empty password
net user "!NEW_USER!" "" /add >nul 2>&1
net localgroup Administrators "!NEW_USER!" /add >nul 2>&1
    
rem Set password to never expire
powershell -NoProfile -Command "Set-LocalUser -Name '!NEW_USER!' -PasswordNeverExpires $true" >nul 2>&1
wmic useraccount where "name='!NEW_USER!'" set PasswordExpires=FALSE >nul 2>&1
net accounts /maxpwage:unlimited >nul 2>&1

rem Set DefaultPassword to empty to prevent duplicate Ghost Profile
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon" /v AutoAdminLogon /t REG_SZ /d "1" /f >nul 2>&1
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon" /v DefaultUserName /t REG_SZ /d "!NEW_USER!" /f >nul 2>&1
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon" /v DefaultPassword /t REG_SZ /d "" /f >nul 2>&1

goto CLEANUP_DEFAULTUSER

:SKIP_LOCAL
echo [PROCESS] Skipping Local User Creation (Online Mode)...

:CLEANUP_DEFAULTUSER
rem Cleanup defaultuser0
net user defaultuser0 /delete >nul 2>&1
if exist "C:\Users\defaultuser0" rmdir /s /q "C:\Users\defaultuser0" >nul 2>&1
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon\SpecialAccounts\UserList" /v defaultuser0 /t REG_DWORD /d 0 /f >nul 2>&1

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

echo !b!!cy![FINISHING] Triggering OOBE Engine... Please wait for 30s timer.!0!
echo/
start /b C:\Windows\System32\oobe\msoobe.exe

echo [INFO] Background processes initiated.
echo [INFO] Preparing to schedule restart in 30 seconds...
ping 127.0.0.1 -n 5 >nul

shutdown /r /t 30 /f /c "ITG FastOOBE: Finalizing setup. System will boot to Desktop automatically."

echo/
echo !b!!scg![DONE] Process initiated.!0! !cw!You can close this window or wait for reboot.!0!
echo/
pause
exit /b
'@

$Utf8WithBom = New-Object System.Text.UTF8Encoding($True)
[System.IO.File]::WriteAllText($TempCMD, $BatchCode, $Utf8WithBom)

# เปลี่ยน Parameter เป็น /k แทน /c เพื่อให้หน้าต่างไม่ปิดเองตอนเจอบั๊ก
Start-Process -FilePath "cmd.exe" -ArgumentList "/k `"$TempCMD`"" -Wait

Remove-Item -Path $TempCMD -Force -ErrorAction SilentlyContinue
