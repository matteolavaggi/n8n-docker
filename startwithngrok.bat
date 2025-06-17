@echo off
cd /d %~dp0
setlocal enabledelayedexpansion

:: STEP 1: Check if ngrok is installed
where ngrok >nul 2>nul
if errorlevel 1 (
    echo.
    echo [ERROR] ngrok was not found. Please download it from: https://ngrok.com/download
    pause
    exit /b
)

:: STEP 2: Check for .env file and NGROK_AUTHTOKEN
set "TOKEN="
if exist ".env" (
    echo [INFO] Found .env file, checking for NGROK_AUTHTOKEN...
    for /f "tokens=2 delims==" %%A in ('findstr /i "NGROK_AUTHTOKEN" .env 2^>nul') do (
        set "TOKEN=%%A"
    )
    if not "!TOKEN!"=="" (
        echo [INFO] Using NGROK_AUTHTOKEN from .env file
        ngrok config add-authtoken !TOKEN!
    ) else (
        echo [WARNING] NGROK_AUTHTOKEN not found or empty in .env file
        goto ask_token
    )
) else (
    echo [INFO] No .env file found
    goto ask_token
)
goto continue_script

:ask_token
echo.
set /p TOKEN=Enter your ngrok authtoken (leave empty if already configured): 
if not "%TOKEN%"=="" (
    ngrok config add-authtoken %TOKEN%
)

:continue_script

:: STEP 3: Start ngrok tunnel on port 5678 (minimized)
echo.
echo [INFO] Starting ngrok tunnel on port 5678...
start "" /min cmd /c "ngrok http 5678 >nul"

:: STEP 4: Wait for ngrok to initialize and retry URL fetching
echo [INFO] Waiting for ngrok tunnel to become available...
set "URL="
set "RETRY_COUNT=0"

:retry_ngrok
timeout /t 3 >nul
set /a RETRY_COUNT+=1
echo [INFO] Attempt %RETRY_COUNT% to fetch ngrok URL...

:: Use PowerShell to properly parse JSON and extract the public_url
for /f "usebackq delims=" %%A in (`powershell -Command "try { $response = Invoke-RestMethod -Uri 'http://127.0.0.1:4040/api/tunnels' -ErrorAction Stop; $tunnel = $response.tunnels | Where-Object { $_.proto -eq 'https' } | Select-Object -First 1; if ($tunnel) { $tunnel.public_url } else { 'NOTFOUND' } } catch { 'ERROR' }"`) do (
    set "URL=%%A"
)

if "!URL!"=="ERROR" (
    echo [WARNING] Error connecting to ngrok API on attempt %RETRY_COUNT%
    if %RETRY_COUNT% LSS 5 goto retry_ngrok
    echo [ERROR] Failed to connect to ngrok API after 5 attempts. Falling back to localhost.
    set "URL=http://localhost:5678"
) else if "!URL!"=="NOTFOUND" (
    echo [WARNING] No HTTPS tunnel found on attempt %RETRY_COUNT%
    if %RETRY_COUNT% LSS 5 goto retry_ngrok
    echo [ERROR] No HTTPS tunnel found after 5 attempts. Falling back to localhost.
    set "URL=http://localhost:5678"
) else if "!URL!"=="" (
    echo [WARNING] Empty response from ngrok API on attempt %RETRY_COUNT%
    if %RETRY_COUNT% LSS 5 goto retry_ngrok
    echo [ERROR] Empty response from ngrok API after 5 attempts. Falling back to localhost.
    set "URL=http://localhost:5678"
) else (
    echo [SUCCESS] Retrieved ngrok URL: !URL!
)

:: STEP 5: Update docker-compose.yml with new WEBHOOK_URL
echo [INFO] Updating docker-compose.yml with WEBHOOK_URL: !URL!
powershell -Command "(Get-Content 'docker-compose.yml') -replace 'WEBHOOK_URL=.*', 'WEBHOOK_URL=!URL!' | Set-Content 'docker-compose.yml'"

:: STEP 6: Stop and remove old container (if it exists)
echo.
echo [INFO] Stopping and removing existing n8n container (if running)...
docker compose down

:: STEP 7: Start n8n with updated webhook URL
echo.
echo [INFO] Starting n8n with Docker Compose...
docker compose up -d

:: STEP 8: Final display
echo.
echo ===============================
echo        n8n is now running      
echo -------------------------------
echo    Public URL:  !URL!
echo    Local URL:   http://localhost:5678
echo    Webhook URL: !URL!
echo ===============================
pause
