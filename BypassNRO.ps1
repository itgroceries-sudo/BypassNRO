Write-Host " [INFO] Downloading ITG FastOOBE Menu..." -ForegroundColor Cyan

$TempCMD = "$env:TEMP\ITG_FastOOBE.cmd"

# แทนที่ด้วยลิงก์ RAW ของไฟล์ BypassNRO.cmd 
$CmdUrl = "https://raw.githubusercontent.com/itgroceries-sudo/BypassNRO/main/BypassNRO.cmd"

try {
    Invoke-WebRequest -Uri $CmdUrl -OutFile $TempCMD -UseBasicParsing
    
    # [CRITICAL FIX] แปลงบรรทัดใหม่จาก LF เป็น CRLF เพื่อป้องกัน Batch Crash
    $FixLF = (Get-Content $TempCMD -Raw) -replace "(?<!`r)`n", "`r`n"
    [System.IO.File]::WriteAllText($TempCMD, $FixLF, [System.Text.Encoding]::UTF8)
    
    Write-Host " [INFO] Launching Menu..." -ForegroundColor Green
    
    # สั่งรันในหน้าต่างเดิม และใช้ /k บังคับไม่ให้หน้าต่างปิดหนีถ้าเกิด Error
    & cmd.exe /k "`"$TempCMD`""
    
} catch {
    Write-Host " [ERROR] $($_.Exception.Message)" -ForegroundColor Red
    Start-Sleep -Seconds 10
} finally {
    Remove-Item -Path $TempCMD -Force -ErrorAction SilentlyContinue
}
