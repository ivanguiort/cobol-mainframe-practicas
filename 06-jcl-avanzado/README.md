# Ejercicio 6: JCL avanzado (PROC, SORT y ejecución condicional)

## Qué hace
Un único job (`BUSCAREG.jcl`) que compila, ejecuta y ordena, y que usa procedimientos propios y ejecución condicional:
1. `DELETE` (IDCAMS): borra los datasets de salida de ejecuciones anteriores, con `SET MAXCC=0` para poder relanzar.
2. `COMPSUB` y `COMPMAIN`: compilan y enlazan los dos programas mediante un `PROC` en línea (`MICOMP`) con el parámetro simbólico `&PROG`.
3. `RUN`: ejecuta el programa principal.
4. `ORDEN`: llama a un segundo `PROC` (`ORDENAR`) que ejecuta `SORT` sobre los aceptados, ordenando por código y quedándose solo con las categorías `AL` y `BE`. Solo se ejecuta si `RUN` terminó con RC 0.

## Los dos procedimientos
| PROC | Parámetros | Qué hace |
|---|---|---|
| `MICOMP` | `PROG` | Compila y enlaza el miembro `&PROG` con `IGYWCL` y la `SYSLIB` de copybooks |
| `ORDENAR` | `ENTRADA`, `SALIDA` | Ordena `&ENTRADA` por `CODIGO` y deja `&SALIDA`; los datos del `SORT` se pasan en cada llamada sobreescribiendo la `SYSIN` |

## Qué probé
| Prueba | Resultado |
|---|---|
| Ejecución normal | `RUN` RC 0, `ORDENADO` generado con solo `AL` y `BE`, ordenado por código |
| `IF/THEN/ELSE` con un paso de aviso en el `ELSE` | Funciona: si `RUN` falla, se salta el `SORT` y se ejecuta el aviso |
| `IF` mal escrito (`// IF(RUN.RC=0)`, sin espacio) | `IEFC605I` y una cadena de `MISPLACED` en los pasos siguientes |
| Líneas en blanco tras el `// ENDIF` | `IEFC019I MISPLACED DD` por un `//SYSIN DD * GENERATED STATEMENT`: el sistema tomó las líneas como datos |
| `COND=(0,NE,RUN)` en lugar de `IF` | Mismo comportamiento: el paso se salta si `RUN` no termina con 0 |
| Camino de error (sin la DD `ENTRADA`) |`RUN` RC 12, `ORDENADO` no generado |

## Qué aprendí
- **`IF/THEN/ELSE` frente a `COND`:** `IF` permite decidir también qué hacer si no se cumple la condición, agrupar varios pasos bajo una misma condición y se lee mejor. `COND` se escribe al revés ("salta el paso si..."). Los pasos dentro de un `IF` cuya condición no se cumple no se ejecutan.
- **Sintaxis del `IF`:** `//` seguido de un espacio y la palabra clave (`IF`, `ELSE`, `ENDIF`); el espacio también cuenta en `IF (condición) THEN`.
- **Leer los errores de JCL:** arreglar siempre el primero (`IEFC...`), porque los siguientes suelen ser consecuencia. Un `GENERATED STATEMENT` indica que sobran datos o líneas.
- **`PROC` con parámetros simbólicos:** se define antes del primer `EXEC` que lo usa, se llama con `EXEC nombre,PARAM=valor`, y `&PARAM` se sustituye al expandirlo. Se puede ver el resultado en el `JESJCL`.
- **Sobreescribir un `DD` de un `PROC`:** `//paso.ddname DD ...` en la llamada.
- **`SORT`:** `SORT FIELDS` e `INCLUDE COND` (cada comparación con su operador y unidas con `OR`).

## Resultado esperado
Ver `salida-spool.txt`

## Entorno
z/OS, JCL, DFSORT, Enterprise COBOL, Zowe y Visual Studio Code.