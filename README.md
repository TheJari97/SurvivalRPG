# SurvivalRPG / SirvivalRPG v0.4

Custom game cooperativo de Dota 2 para hasta 5 jugadores.

## Nombre interno

```text
sirvival_rpg
```

Este nombre interno no debe cambiarse porque lo usan las rutas, el addon y el comando de prueba.

## Nombre publico recomendado

```text
SurvivalRPG
```

Si decides conservar `SirvivalRPG` como marca, cambia el titulo publico en `game/dota_addons/sirvival_rpg/addoninfo.txt` y en los textos de localizacion.

## Orden recomendado

1. Lee `docs/19_GUIA_PASO_A_PASO_COMPLETA.md`.
2. Ejecuta `tools/copiar_a_dota.bat`.
3. Abre Dota 2 Tools.
4. Selecciona el addon `sirvival_rpg`.
5. Crea el mapa real `sirvival_rpg.vmap` en Hammer.
6. Coloca las entidades indicadas en `content/dota_addons/sirvival_rpg/maps/ENTIDADES_REQUERIDAS.csv`.
7. Compila el mapa.
8. Prueba con:

```text
dota_launch_custom_game sirvival_rpg sirvival_rpg
```

## Documentos principales

```text
docs/01_INSTALACION_LOCAL.md
docs/02_CREAR_MAPA_EN_HAMMER.md
docs/19_GUIA_PASO_A_PASO_COMPLETA.md
docs/20_VALIDACION_V04.md
docs/21_DUDAS_SUGERENCIAS_PARA_RESPONDER.md
```

## Nota sobre ZIP

Este proyecto queda como carpeta de trabajo directa. No se genera ZIP dentro del proyecto.
