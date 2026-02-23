@echo off
setlocal enabledelayedexpansion

:: Requer Administrador
net session >nul 2>&1
if %errorlevel% neq 0 (
    echo Solicitando privilegios de administrador...
    powershell -Command "Start-Process -FilePath '%~f0' -Verb RunAs"
    exit /b
)

:: Pede o caminho com um padrão
set "DEFAULT_PATH=C:\Program Files (x86)\Steam\steamapps\common\Counter-Strike Global Offensive\game\csgo\cfg"
set /p "CS2_CFG_PATH=Digite o caminho da pasta cfg do CS2 [Enter para padrao]: "

:: Aplica o padrão se nada foi digitado
if "%CS2_CFG_PATH%"=="" set "CS2_CFG_PATH=%DEFAULT_PATH%"
set "CS2_CFG_PATH=%CS2_CFG_PATH:"=%"

:: Verifica se a pasta existe
if not exist "%CS2_CFG_PATH%\" (
    echo [ERRO] Pasta nao encontrada: "%CS2_CFG_PATH%"
    pause
    exit /b
)

:: Cria os Hardlinks
echo.
for %%F in ("%~dp0*.cfg") do (
    del /f /q "%CS2_CFG_PATH%\%%~nxF" 2>nul
    mklink /H "%CS2_CFG_PATH%\%%~nxF" "%%F"
)

echo.
echo [SUCESSO] CFGs vinculadas em: "%CS2_CFG_PATH%"
pause
