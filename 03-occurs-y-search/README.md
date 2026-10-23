# Ejercicio 3: tabla de categorías con SEARCH y SEARCH ALL

## Qué hace
Programa COBOL (`TABCATEG`) que lee un fichero secuencial de registros de 30 bytes y busca la categoría de cada uno (los dos primeros caracteres del `CODIGO`) en una tabla de 5 categorías.
- Si la categoría existe, el registro va al fichero de aceptados y se suma a su contador.
- Si no existe, va al fichero de rechazados y se muestra el código que falló.

Al final muestra los contadores por categoría y comprueba que su suma coincide con el número de aceptados.

## Estructura de datos
- Tabla de categorías cargada con `VALUE` mediante `REDEFINES`: código de 2 caracteres + nombre de 10, con `OCCURS 5 TIMES INDEXED BY`.
- Tabla paralela de contadores (`OCCURS 5 TIMES`), accedida con `SET WS-POS TO IDX-CATEG`.

## Dos formas de buscar
El programa incluye `SEARCH` (secuencial) y `SEARCH ALL` (binaria), intercambiables comentando un `PERFORM`. Con los mismos datos dan el mismo resultado.

## Lo que descubrí con SEARCH ALL
Con la tabla **desordenada** y `ASCENDING KEY` declarado, `SEARCH ALL` no encontró `HO` ni `EL`, aunque estaban en la tabla: salieron 5 aceptados y 3 rechazados en lugar de 7 y 1. No hubo error ni abend y el RC fue 0, así que el fallo es silencioso. Al ordenar la tabla (`AL, BE, EL, HO, LI`) salió el resultado correcto.

## Cuándo usar cada una
[Explica con tus palabras: qué exige SEARCH ALL, qué ventaja tiene con muchas entradas y qué usarías con 5 elementos.]

## Datos de prueba
8 registros con categorías en distinto orden, repetidas, y una categoría que no existe (`ZZ`).

## Resultado esperado
```
CODIGO NO ENCONTRADO ZZ
ALIMENTAC : 0000002
BEBIDAS   : 0000002
ELECTRONIC: 0000001
HOGAR     : 0000001
LIMPIEZA  : 0000001
TOTAL DE REGISTROS PROCESADOS: 0000008
TOTAL DE REGISTROS ACEPTADOS: 0000007
TOTAL DE REGISTROS RECHAZADOS: 0000001
```

## Qué aprendí
- Definir una tabla con `OCCURS`, `INDEXED BY` y `REDEFINES`.
- Diferencia entre búsqueda secuencial y binaria, y por qué la binaria exige una tabla ordenada.
- Usar una tabla paralela de contadores y cuadrarla con el total de aceptados.

## Entorno
z/OS, Enterprise COBOL, JCL, Zowe y Visual Studio Code.