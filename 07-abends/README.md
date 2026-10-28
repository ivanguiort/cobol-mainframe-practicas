# Ejercicio 7: provocar abends y aprender a leerlos

## Qué hace
Un programa COBOL (`ABENDS`) que lee una opción de `SYSIN` y provoca un fallo distinto según su valor. Sirve para lanzar el mismo job una vez por cada abend, cambiando solo una línea, y estudiar el spool de cada uno.

| Opción | Fallo que provoca |
|---|---|
| `1` | Operación aritmética sobre un campo empaquetado (COMP-3) con datos no válidos |
| `2` | Llamada a un subprograma sin pasarle los parámetros que espera |
| `3` | Escritura en un dataset de un track sin espacio secundario hasta llenarlo |
| `4` | Apertura de un fichero cuyo registro (18 bytes) no coincide con el del dataset (30 bytes) |

## Cómo se ejecuta
El JCL (`ABENDS.jcl`) borra el dataset de la ejecución anterior, compila y enlaza con un `PROC` propio (`MICOMP`) y ejecuta. La opción se pasa así:
```
//SYSIN   DD *
4
/*
```
El dataset de la opción 3 se crea con `SPACE=(TRK,(1,0))`, sin espacio secundario.

## Resultados

### Opción 4: atributos de fichero que no coinciden
| Caso | Resultado |
|---|---|
| Sin `FILE STATUS` | El job termina con `ABEND=S000 U4038 REASON=00000001`. En el `SYSOUT`: `IGZ0201W` (longitud de registro 18 en el programa frente a 30 en el dataset) e `IGZ0035S` (OPEN fallido, status 39, sin `FILE STATUS` ni declarativa) |
| Con `FILE STATUS` pero sin comprobarlo | El programa sigue con el fichero sin abrir y **termina con RC 0** |
| Con `FILE STATUS` comprobado y `MOVE 12 TO RETURN-CODE` | RC 12 y mensaje propio: `ERROR AL ABRIR ENTRADA, FILE STATUS: 39` |

### Opciones 1, 2 y 3
| Abend | Cómo lo provoqué | Qué vi en `JESMSGLG` | Qué vi en `SYSOUT` | Causa | Cómo se evita |
|---|---|---|---|---|---|
| Opción 1 (dato inválido) | `ADD 1 TO WS-NUM` con `WS-NUM` ocupando la misma memoria que `ABCDE` | [completa] | [completa] | [completa] | Comprobar `IF WS-NUM IS NUMERIC` antes de operar |
| Opción 2 (acceso a memoria) | `CALL 'ABENDSUB'` sin `USING` | [completa] | [completa] | [completa] | Pasar siempre los parámetros que declara el subprograma |
| Opción 3 (sin espacio) | 800.000 `WRITE` en un dataset de 1 track sin secundario | [completa: mensaje `IEC...` y código SD37 o SB37] | [completa] | [completa] | Dimensionar bien el espacio y controlar el `FILE STATUS` en los `WRITE` |

## Qué aprendí
- **Un abend del runtime se diagnostica por el mensaje del `SYSOUT`, no por el código del job.** El `U4038` del `IEF450I` no explica nada; el `IGZ0035S` sí.
- **Abend frente a RC distinto de cero:** un abend es una terminación anormal provocada por el sistema o por el runtime; un RC es un fin controlado donde el programa informa de cómo acabó. Y un RC 0 **no garantiza** que todo fuese bien: con `FILE STATUS` sin comprobar, el programa terminó con RC 0 teniendo un fichero sin abrir.
- **Por qué aborta sin `FILE STATUS`:** si el programa no declara `FILE STATUS` ni una declarativa de error, nadie se hace responsable del fallo, y el runtime termina el programa. Con `FILE STATUS`, el runtime deja el código en la variable y es el programa quien decide qué hacer.
- **Un mensaje `IGZ...S` (severo)** viene del runtime de COBOL y suele nombrar el fichero, el programa y el desplazamiento del fallo.
- **Si el programa controla el error, tiene que avisar de él:** `MOVE 12 TO RETURN-CODE` es lo que lee el planificador para decidir si encadena el paso siguiente.

## Entorno
z/OS, Enterprise COBOL, JCL, Zowe y Visual Studio Code.