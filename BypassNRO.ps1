Write-Host " [INFO] Downloading ITG FastOOBE Menu..." -ForegroundColor Cyan

$TempCMD = "$env:TEMP\ITG_FastOOBE.cmd"

# นำลิงก์ Raw ของไฟล์ BypassNRO.cmd บน GitHub ของคุณมาใส่ตรงนี้
$CmdUrl = "https://raw.githubusercontent.com/itgroceries-sudo/BypassNRO/main/BypassNRO.cmd"

try {
    # 1. ดาวน์โหลดไฟล์ .cmd มาไว้ในเครื่อง
    Invoke-WebRequest -Uri $CmdUrl -OutFile $TempCMD -UseBasicParsing
    
    Write-Host " [INFO] Launching Menu..." -ForegroundColor Green
    
    # 2. สั่งรันไฟล์แบบ Native Batch รอจนกว่าจะจบงาน
    Start-Process -FilePath "cmd.exe" -ArgumentList "/c `"$TempCMD`"" -Wait
} catch {
    Write-Host " [ERROR] Failed to download or run the script." -ForegroundColor Red
    Write-Host $_.Exception.Message
    Start-Sleep -Seconds 5
} finally {
    # 3. ลบไฟล์ทิ้งอย่างสะอาดหมดจด
    Remove-Item -Path $TempCMD -Force -ErrorAction SilentlyContinue
}
