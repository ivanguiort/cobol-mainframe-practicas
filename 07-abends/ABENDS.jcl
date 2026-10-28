//ABENDS JOB 1,NOTIFY=&SYSUID
//*****************************************************
//DELETE   EXEC PGM=IDCAMS
//SYSPRINT DD SYSOUT=*
//SYSIN    DD *
  DELETE USUARIO.LLENO
  SET MAXCC=0
/*
//***************************************************/
//MICOMP  PROC  PROG=
//COMP    EXEC IGYWCL
//COBOL.SYSIN  DD DSN=&SYSUID..CBL(&PROG),DISP=SHR
//LKED.SYSLMOD DD DSN=&SYSUID..LOAD(&PROG),DISP=SHR
//        PEND
//***************************************************/
//COMPSUB  EXEC MICOMP,PROG=ABENDSUB
//***************************************************/
//COMPMAIN EXEC MICOMP,PROG=ABENDS,PARM.COMP='DYNAM'
//***************************************************/
//RUN     EXEC PGM=ABENDS
//STEPLIB DD DSN=&SYSUID..LOAD,DISP=SHR
//ENTRADA DD DSN=&SYSUID..ACEPTADO,DISP=SHR
//SYSIN   DD *
4
/*
//SYSOUT  DD SYSOUT=*
//LLENO   DD DSN=&SYSUID..LLENO,
//           DISP=(NEW,CATLG,DELETE),
//           SPACE=(TRK,(1,0)),
//           DCB=(RECFM=FB,LRECL=18,BLKSIZE=0)
//***************************************************/
