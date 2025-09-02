@echo off
echo Iniciando Convert YTM...
echo.

REM Iniciar Backend
echo [1/2] Iniciando Backend...
cd /d "c:\convert YTM\backend-simple"
start "Backend" cmd /k npm start

REM Esperar un momento
timeout /t 3 /nobreak >nul

REM Iniciar Frontend
echo [2/2] Iniciando Frontend...
cd /d "c:\convert YTM\frontend"
start "Frontend" cmd /k npm run dev

echo.
echo Convert YTM iniciado correctamente!
echo.
echo Backend: http://localhost:3001
echo Frontend: http://localhost:3000
echo.
pause