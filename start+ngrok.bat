@echo off
cd /d %~dp0

:: STEP 1: Check if ngrok exists
where ngrok >nul 2>nul
if errorlevel 1 (
    echo.
    echo [ERRORE] ngrok non trovato. Scaricalo da: https://ngrok.com/download
    pause
    exit /b
)

:: STEP 2: Ask for authtoken
echo.
set /p TOKEN=Inserisci il tuo ngrok authtoken (lascia vuoto se già configurato): 
if not "%TOKEN%"=="" (
    ngrok config add-authtoken %TOKEN%
)

:: STEP 3: Launch ngrok on port 5678 and capture the public URL
echo.
echo [INFO] Avvio tunnel ngrok sulla porta 5678...
start "" /min cmd /c "ngrok http 5678 > nul"

:: Aspetta che ngrok sia partito
timeout /t 4 >nul

:: STEP 4: Interroga l'API di ngrok per ottenere il dominio
for /f "tokens=*" %%A in ('curl -s http://127.0.0.1:4040/api/tunnels ^| findstr "public_url"') do (
    set "LINE=%%A"
    goto parse
)

:parse
for /f "tokens=2 delims=:" %%B in ("%LINE%") do (
    set "NGROK_URL=%%B"
)
set NGROK_URL=%NGROK_URL:~2,-2%

echo [INFO] URL pubblico ngrok: %NGROK_URL%

:: STEP 5: Sostituisci o inserisci la variabile WEBHOOK_URL nel docker-compose.yml
echo [INFO] Aggiornamento del file docker-compose.yml...

powershell -Command "(Get-Content 'docker-compose.yml') -replace 'WEBHOOK_URL=.*', 'WEBHOOK_URL=%NGROK_URL%' | Set-Content 'docker-compose.yml'"

:: STEP 6: Avvia n8n
echo.
echo [INFO] Avvio n8n tramite Docker Compose...
docker compose up -d

echo.
echo [FINE] n8n è disponibile su: %NGROK_URL%
pause
