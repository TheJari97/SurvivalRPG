@echo off
setlocal enabledelayedexpansion

title Instalar SurvivalRPG / SirvivalRPG en Dota 2

set "DOTA_ROOT=D:\SteamLibrary\steamapps\common\dota 2 beta"
set "ADDON_NAME=sirvival_rpg"
set "SRC_ROOT=%~dp0.."

set "SRC_GAME=%SRC_ROOT%\game\dota_addons\%ADDON_NAME%"
set "SRC_CONTENT=%SRC_ROOT%\content\dota_addons\%ADDON_NAME%"

set "DST_GAME=%DOTA_ROOT%\game\dota_addons\%ADDON_NAME%"
set "DST_CONTENT=%DOTA_ROOT%\content\dota_addons\%ADDON_NAME%"

echo ==================================================
echo Instalador local de SurvivalRPG / SirvivalRPG
echo ==================================================
echo.
echo Ruta Dota configurada:
echo %DOTA_ROOT%
echo.

if not exist "%DOTA_ROOT%" (
    echo ERROR: No existe la ruta de Dota configurada.
    echo Edita DOTA_ROOT dentro de este archivo BAT.
    pause
    exit /b 1
)

if not exist "%SRC_GAME%" (
    echo ERROR: No existe la carpeta fuente GAME:
    echo %SRC_GAME%
    pause
    exit /b 1
)

if not exist "%SRC_CONTENT%" (
    echo ERROR: No existe la carpeta fuente CONTENT:
    echo %SRC_CONTENT%
    pause
    exit /b 1
)

echo ADVERTENCIA:
echo Se borraran las carpetas actuales del addon en Dota y se reemplazaran por esta version.
echo Cierra Dota 2 Tools y Hammer antes de continuar.
echo.
pause

if exist "%DST_GAME%" (
    echo Borrando carpeta GAME anterior...
    rmdir /s /q "%DST_GAME%"
)

if exist "%DST_CONTENT%" (
    echo Borrando carpeta CONTENT anterior...
    rmdir /s /q "%DST_CONTENT%"
)

echo.
echo Creando carpetas destino...
mkdir "%DST_GAME%" 2>nul
mkdir "%DST_CONTENT%" 2>nul

echo.
echo Copiando GAME...
robocopy "%SRC_GAME%" "%DST_GAME%" /MIR /R:2 /W:1 /NFL /NDL /NP

if errorlevel 8 (
    echo ERROR: Fallo la copia de GAME.
    pause
    exit /b 1
)

echo.
echo Copiando CONTENT...
robocopy "%SRC_CONTENT%" "%DST_CONTENT%" /MIR /R:2 /W:1 /NFL /NDL /NP

if errorlevel 8 (
    echo ERROR: Fallo la copia de CONTENT.
    pause
    exit /b 1
)

echo.
echo ==================================================
echo Instalacion completada correctamente.
echo ==================================================
echo.
echo GAME instalado en:
echo %DST_GAME%
echo.
echo CONTENT instalado en:
echo %DST_CONTENT%
echo.
echo Siguiente paso:
echo Abre Dota 2 Tools y carga el addon sirvival_rpg.
echo.
pause
exit /b 0
