# Prácticas de COBOL y JCL en z/OS

Ejercicios que estoy haciendo para consolidar mi base de COBOL, JCL y DB2 sobre z/OS. Cada carpeta contiene el programa, su JCL, un README y la salida del spool de las pruebas.

> Todos los datos son de prueba, inventados para los ejercicios.

## Ejercicios

| # | Ejercicio | Qué practico | Estado |
|---|---|---|---|
| 01 | [Lectura de fichero con FILE STATUS](01-lectura-fichero-file-status/) | Ficheros secuenciales, control de FILE STATUS (00, 10, 35, 39), contadores | Hecho |
| 02 | [Aceptados y rechazados con validación de COMP-3](02-aceptados-y-rechazados/) | Párrafos, lectura anticipada, `IS NUMERIC`, ficheros de salida, control de errores centralizado | Hecho |
| 03 | [Tabla de categorías con SEARCH y SEARCH ALL](03-tabla-categorias/) | `OCCURS`, `INDEXED BY`, `REDEFINES`, búsqueda secuencial y binaria, tabla de contadores | Hecho |
| 04 | [Subprograma con CALL y LINKAGE SECTION](04-subprograma-call/) | Parámetros, `GOBACK`, llamada dinámica, `ON EXCEPTION` | Hecho |
| 05 | [Copybooks con COPY](05-copybooks/) | `COPY`, `SYSLIB`, parámetros agrupados, recompilación tras cambiar un copybook | Hecho |
| 06 | [JCL avanzado: PROC, SORT y ejecución condicional](06-jcl-avanzado/) | `PROC` con parámetros, `SORT`, `IF/THEN/ELSE`, `COND`, lectura de errores de JCL | Hecho |
| 07 | [Abends: provocarlos y leerlos](07-abends/) | `FILE STATUS` frente a abend, mensajes `IGZ`, RC frente a abend | Hecho |

## Plan de estudio

Sigo un roadmap de mainframe con foco en desarrollo COBOL, DB2 y CICS:

1. COBOL y JCL sólidos
2. DB2 y CICS
3. VSAM y entorno de empresa
4. Modernización y herramientas modernas (Zowe, Git)

## Entorno

z/OS, Enterprise COBOL, JCL, Zowe y Visual Studio Code.

## Contacto

Iván Guirado Ortiz · [LinkedIn](https://www.linkedin.com/in/ivanguiradortiz)