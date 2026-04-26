@echo off
setlocal

title Sincronizar mapa SurvivalRPG desde Dota 2

set "DOTA_ROOT=D:\SteamLibrary\steamapps\common\dota 2 beta"
set "ADDON_NAME=sirvival_rpg"
set "SRC_ROOT=%~dp0.."

set "SRC_MAPS=%DOTA_ROOT%\content\dota_addons\%ADDON_NAME%\maps"
set "DST_MAPS=%SRC_ROOT%\content\dota_addons\%ADDON_NAME%\maps"

echo ==================================================
echo Sincronizar mapa SurvivalRPG desde Dota 2
echo ==================================================
echo.
echo Origen:
echo %SRC_MAPS%
echo.
echo Destino:
echo %DST_MAPS%
echo.

if not exist "%SRC_MAPS%" (
    echo ERROR: No existe la carpeta de mapas en Dota.
    pause
    exit /b 1
)

if not exist "%DST_MAPS%" (
    mkdir "%DST_MAPS%" 2>nul
)

robocopy "%SRC_MAPS%" "%DST_MAPS%" *.vmap* /E /R:2 /W:1 /NFL /NDL /NP

if errorlevel 8 (
    echo ERROR: Fallo la sincronizacion del mapa.
    pause
    exit /b 1
)

echo.
echo Sincronizacion completada.
echo.
pause
exit /b 0
