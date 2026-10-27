# Ejercicio 5: copybooks con COPY

## Qué hace
Parte del ejercicio 4 y saca las definiciones compartidas a dos copybooks en una librería (`COPY`):
- `REGCOPY`: el registro de entrada de 30 bytes (`CODIGO`, `NOMBRE`, `IMPORTE` y `FILLER`).
- `PARMCAT`: los parámetros de la llamada al subprograma, agrupados en un único registro (`BUSCAR`, `WS-NOMBRE`, `WS-ENCONTRADO`, `WS-POS-DEV`).

Los dos programas (`TABCOPY` y `BUSCACAT`) incluyen `PARMCAT` con `COPY`, y la llamada pasa un único parámetro: `CALL 'BUSCACAT' USING PARMCAT`.

## Estructura
- `REGCOPY.cpy` y `PARMCAT.cpy`: copybooks (PDS/E con RECFM=FB y LRECL=80, escritos desde la columna 8).
- `TABCOPY.cbl`: programa principal.
- `BUSCACAT.cbl`: subprograma.
- `BUSCAREG.jcl`: compila los dos módulos y ejecuta.

## Cómo se ejecuta
En el JCL, los dos pasos de compilación llevan la DD que indica al compilador dónde están los copybooks:
```
//COBOL.SYSLIB DD DSN=USUARIO.COPY,DISP=SHR
```
El principal se compila con `DYNAM` y la `STEPLIB` del paso `RUN` apunta a la librería de carga con los dos módulos.

## Qué probé
| Prueba | Resultado |
|---|---|
| Ejecución normal con los copybooks | Mismo resultado que el ejercicio 4: 2, 2, 1, 1, 1; 7 aceptados, 1 rechazado |
| `BUSCAR` cambiado de `X(2)` a `X(3)` en el copybook, recompilando **solo el principal** | Sin error de compilación y sin abend. Los 8 registros acabaron en rechazados y el `DISPLAY` mostraba códigos de 3 caracteres (`ALA`, `BEB`, `LIL`...) |
| Lo mismo, recompilando **los dos programas** | Resultado idéntico al normal (2, 2, 1, 1, 1; 7 aceptados y 1 rechazado). Los dos usan el mismo layout y el código de 2 caracteres se rellena con un espacio hasta los 3. |

## Qué pasó con el cambio de tamaño
El principal usaba el layout nuevo y el subprograma, sin recompilar, el antiguo, pero ambos compartían la misma zona de memoria. Cada uno la interpretaba con campos de tamaños distintos y los resultados se cruzaban: el subprograma escribía sus datos un byte desplazado, el principal leía el indicador de "encontrado" en una posición equivocada y concluía que no había coincidencias. Lo peor es que **no hubo ningún aviso**: el programa terminó con normalidad y dio resultados erróneos.

## Qué aprendí
- Si cambia un copybook, hay que **recompilar todos los programas que lo usan**. Con `COPY` se cambia en un solo sitio, sin él habría que tocar la definición en cada programa, con riesgo de olvidar alguno.
- Agrupar los parámetros en un `01` y pasar un único parámetro evita que el orden, el número o el tamaño de los campos se descuadren entre el `CALL` y el `USING`.
- Los copybooks llevan solo definiciones (sin `FD`, ni cabeceras de división o sección), y desde la columna 8 como el resto del fuente.
- La librería de copybooks se indica al compilador con la DD `SYSLIB` del paso de compilación.
- Los subrayados rojos del editor ("unable to find copybook") dependen de la configuración de la extensión, no del compilador. Lo que cuenta es el listado de compilación.

## Resultado esperado
Ver `salida-spool.txt`

## Entorno
z/OS, Enterprise COBOL, JCL, Zowe y Visual Studio Code.