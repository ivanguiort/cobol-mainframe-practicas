//LEERFIC  JOB 1,NOTIFY=&SYSUID
//*****************************************************
//COBRUN  EXEC IGYWCL
//COBOL.SYSIN  DD DSN=&SYSUID..CBL(LEEFICH),DISP=SHR
//LKED.SYSLMOD DD DSN=&SYSUID..LOAD(LEEFICH),DISP=SHR
//***************************************************/
//RUN     EXEC PGM=LEEFICH,COND=((4,LT,COBRUN.COBOL),
//        (4,LT,COBRUN.LKED))
//STEPLIB   DD DSN=&SYSUID..LOAD,DISP=SHR
//ENTRADA    DD DSN=&SYSUID..REGI,
//             DISP=SHR
//SYSOUT    DD SYSOUT=*
//***************************************************/
