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
set "DST_GAME_MAPS=%DST_GAME%\maps"
set "DST_CONTENT_MAPS=%DST_CONTENT%\maps"
set "MAP_BACKUP_ROOT=%TEMP%\%ADDON_NAME%_map_backup_%RANDOM%_%RANDOM%"
set "MAP_BACKUP_GAME=%MAP_BACKUP_ROOT%\game_maps"
set "MAP_BACKUP_CONTENT=%MAP_BACKUP_ROOT%\content_maps"
set "ROBOCOPY_CACHE_EXCLUDES=/XF tools_thumbnail_cache.sqlite3 tools_thumbnail_cache.sqlite3-shm tools_thumbnail_cache.sqlite3-wal"

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
echo Se reemplazaran las carpetas del addon en Dota con esta version.
echo Los mapas .vmap/.vmap_c existentes en Dota se respaldaran y restauraran.
echo Esto evita borrar el mapa que estes creando en Hammer.
echo Cierra Dota 2 Tools y Hammer antes de continuar.
echo.
pause

if exist "%MAP_BACKUP_ROOT%" (
    rmdir /s /q "%MAP_BACKUP_ROOT%"
)
mkdir "%MAP_BACKUP_GAME%" 2>nul
mkdir "%MAP_BACKUP_CONTENT%" 2>nul

if exist "%DST_CONTENT_MAPS%" (
    echo Respaldando mapas fuente de Hammer...
    robocopy "%DST_CONTENT_MAPS%" "%MAP_BACKUP_CONTENT%" *.vmap* /E /R:2 /W:1 /NFL /NDL /NP
    if errorlevel 8 (
        echo ERROR: No se pudo respaldar el mapa fuente de Hammer.
        pause
        exit /b 1
    )
)

if exist "%DST_GAME_MAPS%" (
    echo Respaldando mapas compilados de Dota...
    robocopy "%DST_GAME_MAPS%" "%MAP_BACKUP_GAME%" *.vmap* /E /R:2 /W:1 /NFL /NDL /NP
    if errorlevel 8 (
        echo ERROR: No se pudo respaldar el mapa compilado.
        pause
        exit /b 1
    )
)

echo.
echo Creando carpetas destino...
mkdir "%DST_GAME%" 2>nul
mkdir "%DST_CONTENT%" 2>nul

echo.
echo Copiando GAME...
robocopy "%SRC_GAME%" "%DST_GAME%" /MIR /R:2 /W:1 /NFL /NDL /NP %ROBOCOPY_CACHE_EXCLUDES%

if errorlevel 8 (
    echo ERROR: Fallo la copia de GAME.
    pause
    exit /b 1
)

echo.
echo Copiando CONTENT...
robocopy "%SRC_CONTENT%" "%DST_CONTENT%" /MIR /R:2 /W:1 /NFL /NDL /NP %ROBOCOPY_CACHE_EXCLUDES%

if errorlevel 8 (
    echo ERROR: Fallo la copia de CONTENT.
    pause
    exit /b 1
)

if exist "%MAP_BACKUP_CONTENT%" (
    echo Restaurando mapas fuente de Hammer...
    mkdir "%DST_CONTENT_MAPS%" 2>nul
    robocopy "%MAP_BACKUP_CONTENT%" "%DST_CONTENT_MAPS%" /E /R:2 /W:1 /NFL /NDL /NP
    if errorlevel 8 (
        echo ERROR: No se pudo restaurar el mapa fuente de Hammer.
        pause
        exit /b 1
    )
)

if exist "%MAP_BACKUP_GAME%" (
    echo Restaurando mapas compilados de Dota...
    mkdir "%DST_GAME_MAPS%" 2>nul
    robocopy "%MAP_BACKUP_GAME%" "%DST_GAME_MAPS%" /E /R:2 /W:1 /NFL /NDL /NP
    if errorlevel 8 (
        echo ERROR: No se pudo restaurar el mapa compilado.
        pause
        exit /b 1
    )
)

if exist "%MAP_BACKUP_ROOT%" (
    rmdir /s /q "%MAP_BACKUP_ROOT%"
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
