Write-Host " [INFO] Downloading ITG FastOOBE Menu..." -ForegroundColor Cyan

# บังคับใช้ TLS 1.2 ป้องกันปัญหาการเชื่อมต่อ GitHub ใน OOBE 
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12

$CmdUrl = "https://raw.githubusercontent.com/itgroceries-sudo/BypassNRO/main/BypassNRO.cmd"
$TempCMD = "$env:TEMP\ITG_FastOOBE.cmd"

try {
    # 1. โหลดไฟล์โค้ดจาก Raw Link
    $ScriptContent = Invoke-RestMethod -Uri $CmdUrl -UseBasicParsing
    
    # 2. แปลงการขึ้นบรรทัดใหม่จาก LF เป็น CRLF เพื่อให้ CMD อ่านบล็อกคำสั่งได้สมบูรณ์
    $ScriptContent = $ScriptContent -replace "(?<!`r)`n", "`r`n"
    
    # 3. บันทึกไฟล์เป็น UTF-8 (No BOM) ป้องกันบั๊กถูกกลืนตัวอักษร 2 ตัวแรก
    $Utf8NoBom = New-Object System.Text.UTF8Encoding($False)
    [System.IO.File]::WriteAllText($TempCMD, $ScriptContent, $Utf8NoBom)
    
    Write-Host " [INFO] Launching Menu..." -ForegroundColor Green
    
    # 4. รันโค้ด CMD (ตัดบล็อกลบไฟล์อัตโนมัติทิ้ง เพื่อให้ UAC สามารถดึงไฟล์ไปรันต่อในหน้าต่างใหม่ได้)
    & cmd.exe /c "`"$TempCMD`""
    
} catch {
    Write-Host " [ERROR] $($_.Exception.Message)" -ForegroundColor Red
    Start-Sleep -Seconds 10
}
