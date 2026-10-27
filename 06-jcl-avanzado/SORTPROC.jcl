//SORTPROC JOB 1,NOTIFY=&SYSUID
//*****************************************************
//DELETE   EXEC PGM=IDCAMS
//SYSPRINT DD SYSOUT=*
//SYSIN    DD *
  DELETE USUARIO.ACEPTADO
  DELETE USUARIO.ORDENADO
  DELETE USUARIO.RECHAZO
  SET MAXCC=0
/*
//***************************************************/
//ORDENAR PROC ENTRADA=,SALIDA=
//SORTPASO EXEC PGM=SORT
//SYSOUT  DD SYSOUT=*
//SORTIN  DD DSN=&SYSUID..&ENTRADA,DISP=SHR
//SORTOUT DD DSN=&SYSUID..&SALIDA,
//           DISP=(NEW,CATLG,DELETE),
//           SPACE=(TRK,(1,1)),
//           DCB=(RECFM=FB,LRECL=30,BLKSIZE=0)
//SYSIN   DD DUMMY
//        PEND
//***************************************************/
//MICOMP  PROC  PROG=
//COMP    EXEC IGYWCL
//COBOL.SYSLIB DD DSN=&SYSUID..COPY,DISP=SHR
//COBOL.SYSIN  DD DSN=&SYSUID..CBL(&PROG),DISP=SHR
//LKED.SYSLMOD DD DSN=&SYSUID..LOAD(&PROG),DISP=SHR
//        PEND
//***************************************************/
//COMPSUB  EXEC MICOMP,PROG=BUSCACAT
//***************************************************/
//COMPMAIN EXEC MICOMP,PROG=TABCOPY,PARM.COMP='DYNAM'
//***************************************************/
//RUN     EXEC PGM=TABCOPY
//STEPLIB   DD DSN=&SYSUID..LOAD,DISP=SHR
//ENTRADA   DD DSN=&SYSUID..REGI,DISP=SHR
//ACEPTA    DD DSN=&SYSUID..ACEPTADO,
//             DISP=(NEW,CATLG,DELETE),
//             SPACE=(TRK,(1,1)),
//             DCB=(RECFM=FB,LRECL=30,BLKSIZE=0)
//RECHAZA     DD DSN=&SYSUID..RECHAZO,
//             DISP=(NEW,CATLG,DELETE),
//             SPACE=(TRK,(1,1)),
//             DCB=(RECFM=FB,LRECL=30,BLKSIZE=0)
//SYSOUT    DD SYSOUT=*
//***************************************************/
//ORDEN   EXEC ORDENAR,ENTRADA=ACEPTADO,SALIDA=ORDENADO,COND=(0,NE,RUN)
//SORTPASO.SYSIN DD *
    INCLUDE COND=(1,2,CH,EQ,C'AL',OR,1,2,CH,EQ,C'BE')
    SORT FIELDS=(1,6,CH,A)
/*
//

