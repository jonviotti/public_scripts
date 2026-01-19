@echo off
:: Ativa o suporte a cores ANSI no CMD
reg add "HKEY_CURRENT_USER\Console" /v VirtualTerminalLevel /t REG_DWORD /d 1 /f >nul 2>&1

:: DEFINIÇÃO DE CORES
set "GREEN=[32m"
set "RED=[31m"
set "RESET=[0m"

:: Feito do Brazil ^^
echo ===================================================================
echo.
echo                   Auto Connect Android Phone
echo.
echo        Requires Nmap installed "https://nmap.org/download.html"
echo.
echo           Requires static IP on your phone [for fast connecting]
echo.
echo ===================================================================
echo.

:: CONFIGURAÇÃO DE CAMINHOS LOCAIS (Substitua pelos seus caminhos reais)
set "PATH=%PATH%;C:\Android\Sdk\platform-tools"
set "PATH=%PATH%;C:\Program Files (x86)\Nmap"

:: CONFIGURAÇÃO DO DISPOSITIVO
:: Ajuste aqui o IP utilizado por seu telefone
set "ANDROID_DEVICE=192.168.X.XXX"
set "PORT_FILE=%TEMP%\adb_port.txt"

echo [1/2] Checking if already connected to %ANDROID_DEVICE%...

:: 1. Verifica se já está conectado
adb devices | findstr /C:"%ANDROID_DEVICE%" | findstr /C:"device" >nul
if %errorlevel% equ 0 (
    echo %GREEN%[OK] Phone is already connected.%RESET%
    goto SUCCESS
)

:: 2. Tenta a última porta conhecida (Cache)
if exist "%PORT_FILE%" (
    set /p LAST_PORT=<"%PORT_FILE%"
    echo [2/2] Trying cached port: %LAST_PORT%...
    adb connect %ANDROID_DEVICE%:%LAST_PORT% | findstr /C:"connected" >nul
    if %errorlevel% equ 0 goto SUCCESS
)

:: 3. Escaneia a porta caso tenha mudado
echo [!] Port changed.
echo Scanning %ANDROID_DEVICE% (Range: 30001-65535)...
set START_TIME=%time%

for /f "tokens=1 delims=/" %%A in ('nmap -T4 -sT %ANDROID_DEVICE% -p 30001-65535 --open ^| findstr "tcp open"') do (
    set "FOUND_PORT=%%A"
)

:: 4. Conexão Final
if defined FOUND_PORT (
    echo [NEW] Found Port: %FOUND_PORT%
    echo %FOUND_PORT%>"%PORT_FILE%"
    adb connect %ANDROID_DEVICE%:%FOUND_PORT%
    echo Scan Time: %START_TIME% to %time%
    goto SUCCESS
) else (
    echo.
    echo %RED%[ERROR] Could not find any open ADB ports on %ANDROID_DEVICE%.%RESET%
    echo 1. Is 'Wireless Debugging' actually ON?
    echo 2. Can you ping %ANDROID_DEVICE%?
    pause
    exit /b
)

:SUCCESS
echo.
echo %GREEN%========================================
echo READY for Android Studio!
echo ========================================%RESET%

timeout /t 10
