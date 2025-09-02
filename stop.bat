@echo off
echo Deteniendo Convert YTM...
echo.

REM Detener procesos de Node.js en los puertos 3001 y 5173
echo Deteniendo Backend (puerto 3001)...
for /f "tokens=5" %%a in ('netstat -ano ^| findstr :3001') do (
    taskkill /PID %%a /F >nul 2>&1
)

echo Deteniendo Frontend (puerto 3000)...
for /f "tokens=5" %%a in ('netstat -ano ^| findstr :3000') do (
    taskkill /PID %%a /F >nul 2>&1
)

echo.
echo ✅ Convert YTM detenido correctamente!
echo.
pause