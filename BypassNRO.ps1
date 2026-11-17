Write-Host " [INFO] Downloading ITG FastOOBE Menu..." -ForegroundColor Cyan

[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12

# [CRITICAL FIX] ใส่ Parameter สุ่มรหัสด้านหลัง (?t=...) เพื่อทะลวง Cache ของ GitHub ให้ได้ไฟล์สดใหม่ 100% เสมอ!
$CmdUrl = "https://raw.githubusercontent.com/itgroceries-sudo/BypassNRO/main/BypassNRO.cmd?t=$([guid]::NewGuid())"

$TempDir = "$env:PUBLIC\ITG_Scripts"
if (!(Test-Path $TempDir)) { New-Item -ItemType Directory -Force -Path $TempDir | Out-Null }
$TempCMD = "$TempDir\ITG_FastOOBE.cmd"

try {
    $ScriptContent = Invoke-RestMethod -Uri $CmdUrl -UseBasicParsing
    
    # แปลงบรรทัดใหม่จาก LF เป็น CRLF
    $ScriptContent = $ScriptContent -replace "(?<!`r)`n", "`r`n"
    
    $Utf8NoBom = New-Object System.Text.UTF8Encoding($False)
    [System.IO.File]::WriteAllText($TempCMD, $ScriptContent, $Utf8NoBom)
    
    Write-Host " [INFO] Launching Menu..." -ForegroundColor Green
    
    & cmd.exe /c "`"$TempCMD`""
    
} catch {
    Write-Host " [ERROR] $($_.Exception.Message)" -ForegroundColor Red
    Start-Sleep -Seconds 10
} finally {
    Remove-Item -Path $TempCMD -Force -ErrorAction SilentlyContinue
    Remove-Item -Path $TempDir -Force -ErrorAction SilentlyContinue
}
