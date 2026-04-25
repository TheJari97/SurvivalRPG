# SurvivalRPG v0.5.2-pre

Custom game cooperativo de Dota 2 para hasta 5 jugadores.

## Nombre interno

```text
sirvival_rpg
```

Este nombre interno no debe cambiarse porque lo usan las rutas, el addon y el comando de prueba.

## Nombre publico

```text
SurvivalRPG
```

`SirvivalRPG` se mantiene solo como compatibilidad interna de codigo viejo.

## Orden recomendado

1. Ejecuta `tools/copiar_a_dota.bat`.
2. Abre Dota 2 Tools.
3. Selecciona el addon `sirvival_rpg`.
4. Crea el mapa real `sirvival_rpg.vmap` en Hammer.
5. Coloca las entidades indicadas en `content/dota_addons/sirvival_rpg/maps/ENTIDADES_REQUERIDAS.csv`.
6. Compila el mapa.
7. Prueba con:

```text
dota_launch_custom_game sirvival_rpg sirvival_rpg
```

## Estado actual

```text
Zona 0 segura
Zonas 1 a 10 configuradas
15 heroes base
75 habilidades base
Mascotas visibles
Boss roulette base
Guardado temporal preparado para backend HTTP futuro
Zona 0 limpia: enemigos se retiran, recuperan vida y retoman aggro fuera del refugio
```

La documentacion larga de trabajo vive localmente en `docs/` y esta ignorada por Git para no subirla al repositorio publico.

## Nota sobre ZIP

Este proyecto queda como carpeta de trabajo directa. No se genera ZIP dentro del proyecto.
