# Ejercicio 1: lectura de fichero secuencial con FILE STATUS

## Qué hace
Programa COBOL que lee un fichero secuencial de 80 posiciones y cuenta cuántos registros hay en total, cuántos están en blanco y cuántos tienen datos. Controla el FILE STATUS en la apertura, la lectura y el cierre.

## Cómo se ejecuta
1. Compilar y enlazar con el procedimiento `IGYWCL` (ver `LEEFICH.jcl`).
2. Ejecutar el paso `RUN` con la DD `ENTRADA` apuntando a un dataset de prueba (FB, LRECL 80).

## Qué controla
| FILE STATUS | Significado | Cuándo lo vi |
|---|---|---|
| 00 | Operación correcta | Ejecución normal |
| 10 | Fin de fichero | Al terminar de leer |
| 35 | Fichero no encontrado | DD con nombre distinto al esperado |
| 39 | Atributos que no coinciden | LRECL 80 contra `PIC X(100)` |

Si algo falla, el programa muestra el código y termina con RC 12.

## Resultado esperado
Ver `salida-spool.txt`.

## Qué aprendí
- Declarar `FILE STATUS` y comprobarlo después de cada operación.
- Provocar errores a propósito para ver cómo se comportan.
- Cuadrar contadores: leídos = vacíos + con datos.

## Entorno
z/OS, Enterprise COBOL, JCL, Zowe y Visual Studio Code.