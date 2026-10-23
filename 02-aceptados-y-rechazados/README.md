# Ejercicio 2: aceptados y rechazados con validación de COMP-3

## Qué hace
Programa COBOL (`ACEPRECH`) que lee un fichero secuencial de registros de 30 bytes y escribe cada uno en uno de dos ficheros de salida:
- `ACEPTADO`: registros cuyo importe es numérico válido.
- `RECHAZO`: registros cuyo importe no es válido.

Al final muestra el total de registros procesados, aceptados, rechazados y la suma de los importes aceptados.

## Estructura del registro (LRECL 30)
| Campo | Formato | Bytes |
|---|---|---|
| CODIGO | `PIC X(6)` | 6 |
| NOMBRE | `PIC X(14)` | 14 |
| IMPORTE | `PIC S9(7)V99 COMP-3` | 5 |
| FILLER | `PIC X(5)` | 5 |

## Cómo valida
Con `IF IMPORTE IS NUMERIC` sobre el campo empaquetado. Si el contenido no es un COMP-3 válido, el registro va a rechazados. Así se evita que una operación aritmética con un dato inválido termine en un abend S0C7.

## Cómo se ejecuta
El JCL (`ACEPRECH.jcl`) tiene cuatro pasos:
1. `DELETE`: borra los datasets de salida de ejecuciones anteriores (con `SET MAXCC=0`, para poder relanzar).
2. `COBRUN`: compila y enlaza con el procedimiento `IGYWCL`.
3. `RUN`: ejecuta el programa con las DD `ENTRADA`, `ACEPTA` y `RECHAZA`.

Las DD de salida se crean como `FB` con `LRECL=30`.

## Qué controla
- FILE STATUS de los tres ficheros tras cada `OPEN`, `READ` y `WRITE`, centralizado en el párrafo `9000-ERRORES`.
- El FILE STATUS `10` (fin de fichero) en la entrada se trata como correcto.
- Cualquier otro error muestra el código y termina con RC 12.
- Los contadores deben cumplir: aceptados + rechazados = procesados.

## Datos de prueba
Fichero de entrada con [N] registros inventados, de los cuales [N] tienen un importe empaquetado válido y [N] un importe inválido. Preparé el registro con COMP-3 inválido [explica cómo: por ejemplo, editando los bytes en hexadecimal con HEX ON en ISPF].

## Resultado esperado
Ver `salida-spool.txt`.

El RC del paso `RUN` es 0.

## Qué aprendí
- Estructurar un programa batch con párrafos (`INICIO`, `PROCESO`, `FIN`) y lectura anticipada.
- Validar un COMP-3 con `IS NUMERIC` antes de operar con él.
- Centralizar el control de errores en un único párrafo y tratar el FILE STATUS `10` como fin de fichero.
- Cuadrar contadores y mostrar importes con formato editado.
- Ajustar el `LRECL` de los ficheros de salida al tamaño real del registro.

## Entorno
z/OS, Enterprise COBOL, JCL, Zowe y Visual Studio Code.