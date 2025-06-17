@echo off
cd /d %~dp0
setlocal enabledelayedexpansion

echo.
echo ===============================
echo     Stopping n8n and ngrok    
echo ===============================

:: STEP 1: Stop and remove n8n container
echo.
echo [INFO] Stopping and removing n8n container...
docker compose down

:: STEP 2: Stop ngrok process
echo.
echo [INFO] Stopping ngrok tunnel...
taskkill /f /im ngrok.exe >nul 2>nul
if errorlevel 1 (
    echo [WARNING] No ngrok process found running
) else (
    echo [SUCCESS] ngrok process stopped
)

:: STEP 3: Optional - Kill any remaining ngrok processes (just in case)
echo.
echo [INFO] Checking for any remaining ngrok processes...
for /f "tokens=2" %%A in ('tasklist /fi "imagename eq ngrok.exe" ^| findstr ngrok.exe') do (
    echo [INFO] Found remaining ngrok process with PID %%A, killing it...
    taskkill /f /pid %%A >nul 2>nul
)

:: STEP 4: Reset docker-compose.yml webhook URL to localhost (optional)
echo.
set /p RESET=Reset WEBHOOK_URL to localhost in docker-compose.yml? (y/N): 
if /i "!RESET!"=="y" (
    echo [INFO] Resetting WEBHOOK_URL to localhost...
    powershell -Command "(Get-Content 'docker-compose.yml') -replace 'WEBHOOK_URL=.*', 'WEBHOOK_URL=http://localhost:5678' | Set-Content 'docker-compose.yml'"
    echo [SUCCESS] WEBHOOK_URL reset to localhost
) else (
    echo [INFO] WEBHOOK_URL left unchanged
)

echo.
echo ===============================
echo   n8n and ngrok stopped      
echo ===============================
echo.
pause 