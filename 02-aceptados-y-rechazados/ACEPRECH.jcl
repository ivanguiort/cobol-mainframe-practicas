//ACEPRECH JOB 1,NOTIFY=&SYSUID
//*****************************************************
//DELETE   EXEC PGM=IDCAMS
//SYSPRINT DD SYSOUT=*
//SYSIN    DD *
  DELETE &SYSUID.ACEPTADO
  DELETE &SYSUID.RECHAZO
  SET MAXCC=0
/*
//COBRUN  EXEC IGYWCL
//COBOL.SYSIN  DD DSN=&SYSUID..CBL(ACEPRECH),DISP=SHR
//LKED.SYSLMOD DD DSN=&SYSUID..LOAD(ACEPRECH),DISP=SHR
//***************************************************/
//RUN     EXEC PGM=ACEPRECH
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
