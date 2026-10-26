# Ejercicio 4: subprograma con CALL y LINKAGE SECTION

## Qué hace
Parte del ejercicio 3 y saca la búsqueda de categoría a un subprograma (`BUSCACAT`). El programa principal (`TABCATEG`) lee el fichero, llama al subprograma con el código de categoría y, según lo que devuelva, escribe el registro en aceptados o rechazados y suma al contador de su categoría.

## Reparto de responsabilidades
- **`TABCATEG` (principal):** ficheros, FILE STATUS, contadores por categoría, resumen final.
- **`BUSCACAT` (subprograma):** tabla de categorías y búsqueda. No escribe mensajes: solo devuelve el resultado.

## Interfaz entre los dos programas
Cuatro parámetros, emparejados **por posición** (los nombres pueden ser distintos en cada programa):

| # | Principal | Subprograma | Formato | Sentido |
|---|---|---|---|---|
| 1 | `BUSCAR` | `BUSCAR` | `PIC X(2)` | Entrada: código de categoría |
| 2 | `WS-NOMBRE` | `WS-NOMBRE` | `PIC X(10)` | Salida: nombre de la categoría |
| 3 | `WS-ENCONTRADO` | `WS-ENCONTRADO` | `PIC X` | Salida: `S` o `N` |
| 4 | `WS-POS-DEV` | `LK-POS` | `PIC 9(4) COMP` | Salida: posición en la tabla (1 a 5) |

El subprograma devuelve la **posición** para que el principal pueda contar por categoría sin conocer la tabla.

## Cómo se ejecuta
El JCL (`BUSCACAT.jcl`) tiene estos pasos:
1. `DELETE`: borra los datasets de salida de ejecuciones anteriores.
2. `COMPSUB`: compila y enlaza `BUSCACAT`.
3. `COMPMAIN`: compila y enlaza `TABCATEG` con la opción `DYNAM`.
4. `RUN`: ejecuta el principal. La `STEPLIB` apunta a la librería donde están **los dos módulos**.

## Llamada dinámica
Con `DYNAM`, `CALL 'BUSCACAT'` es dinámico: los dos módulos están separados y el subprograma se carga al ejecutar. Sin esa opción, un `CALL` con literal sería estático, y el subprograma iría enlazado dentro del principal.

## Qué probé
| Prueba | Resultado |
|---|---|
| Búsqueda secuencial (`SEARCH`) | 2, 2, 1, 1, 1; 7 aceptados, 1 rechazado |
| Búsqueda binaria (`SEARCH ALL`) | Mismo resultado |
| `CALL 'BUSCAXXX'` (módulo inexistente) | Abend **S806** en ejecución |
| Lo mismo con `ON EXCEPTION` | Mensaje propio, RC 12, sin abend |
| Subprograma que modifica el parámetro `BUSCAR` | El cambio llega al principal (paso por referencia por defecto) |
| `BY CONTENT` frente a `BY REFERENCE` | [completa con lo que veas] |
| Categoría sin ningún registro | [completa con lo que veas] |

## Resultado esperado
```
CODIGO NO ENCONTRADO: ZZ
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
- **Parámetros por posición:** lo que tiene que coincidir entre `CALL ... USING` y `PROCEDURE DIVISION USING` es el orden y el tamaño, no el nombre. Si no coinciden, no hay error de compilación y los datos salen corruptos.
- **`GOBACK` frente a `STOP RUN`:** `GOBACK` devuelve el control al llamante; `STOP RUN` terminaría todo el programa, también el principal.
- **Estática frente a dinámica:** la estática enlaza el subprograma dentro del principal (si cambia, hay que reenlazar); la dinámica carga el módulo al ejecutar, y si no se encuentra falla en ejecución (S806).
- **Por referencia frente a por contenido:** por defecto, el subprograma trabaja sobre la memoria del principal y puede modificarla sin que haya error ni aviso.
- **Un índice se maneja con `SET`, no con `MOVE`:** `SET LK-POS TO IDX-CATEG` convierte el índice en un número normal.
- **Leer el listado del compilador:** los errores graves (`-S`) impiden generar el módulo (RC 12), y la tabla de mensajes del final indica la línea de cada uno.

## Decisión de diseño pendiente
[Escribe cómo resolviste los nombres en blanco de las categorías sin registros, y por qué: mostrar solo las que tienen datos, cargar los nombres al inicio o duplicar la tabla.]

## Entorno
z/OS, Enterprise COBOL, JCL, Zowe y Visual Studio Code.