       IDENTIFICATION DIVISION.
       PROGRAM-ID. LEEFICH.
       ENVIRONMENT DIVISION.
       INPUT-OUTPUT SECTION.
       FILE-CONTROL.
           SELECT ENTRADA ASSIGN TO ENTRADA
               ORGANIZATION IS SEQUENTIAL
               FILE STATUS IS WS-FS-ENT.
       DATA DIVISION.
       FILE SECTION.
       FD  ENTRADA.
       01  REG-ENT          PIC X(80).
       WORKING-STORAGE SECTION.
       01  WS-FS-ENT        PIC XX.
       01  WS-LEIDOS        PIC 9(5) COMP VALUE 0.
       01  WS-VACIO         PIC 9(5) COMP VALUE 0.
       01  WS-CON-DATOS     PIC 9(5) COMP VALUE 0.
       PROCEDURE DIVISION.
           OPEN INPUT ENTRADA
           IF WS-FS-ENT NOT = '00'
              DISPLAY 'ERROR AL ABRIR, FILE STATUS: ' WS-FS-ENT
              MOVE 12 TO RETURN-CODE
              STOP RUN
           END-IF
           PERFORM UNTIL WS-FS-ENT NOT = '00'
              READ ENTRADA
                 AT END CONTINUE
                 NOT AT END
                 ADD 1 TO WS-LEIDOS
                 IF REG-ENT= SPACE
                    ADD 1 TO WS-VACIO
                 ELSE
                    ADD 1 TO WS-CON-DATOS
                 END-IF
              END-READ
           END-PERFORM
           IF WS-FS-ENT NOT = '10'
              DISPLAY 'ERROR AL LEER, FILE STATUS: ' WS-FS-ENT
              MOVE 12 TO RETURN-CODE
           END-IF
           CLOSE ENTRADA
            IF WS-FS-ENT NOT = '00'
              DISPLAY 'ERROR AL CERRAR, FILE STATUS: ' WS-FS-ENT
              MOVE 12 TO RETURN-CODE
              STOP RUN
           END-IF
           DISPLAY 'REGISTROS LEIDOS: ' WS-LEIDOS
           DISPLAY 'REGISTROS VACIOS: ' WS-VACIO
           DISPLAY 'REGISTROS CON DATOS: ' WS-CON-DATOS
           STOP RUN.
