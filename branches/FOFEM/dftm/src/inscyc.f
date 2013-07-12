      SUBROUTINE INSCYC (IFROM,IBOUND,ISPOT,LCHFNT,LMORE,IOUT,DEBU) 
      IMPLICIT NONE
C---------- 
C  **INSCYC DATE OF LAST REVISION:  06/30/10   
C---------- 
C   
C     THIS ROUTINE INSERTS A CYCLE IN THE SPECIFED SPOT 
C     AFTER FIRST INSURING THAT ONE DOES NOT EXIST IN THE SPOT  
C     REQUESTED AND THAT THERE IS ROOM FOR THE THE CYCLE WITHIN THE 
C     THE TOTAL LENGTH OF PROJECTION YEARS REQUESTED BY THE 
C     USER. THE ROUTINE INSURES THAT IFINT AND FINT ARE PROPERLY
C     SET WHEN A CYCLE IS INSERTED. 
C   
C     NICK CROOKSTON;    PROGRAMMER.   INT -- MOSCOW  MAY 1978  
C     REVISED BY CROOKSTON TO WORK WITH THE WAY OPTIONS ARE 
C     HANDLED IN VERSION 4.0 --- MAY 1981 (3 YRS LATER) 
C     REVISED BY CROOKSTON TO WORK WITH PPE (FEB 1983). 
C     REVISED BY CROOKSTON TO UPGRADE TREELIST PROCESSING (APR 1984).   
C   
C   
C     LCHFNT= TRUE IF YOU WANT IFINT & FINT TO BE RESET.
C     LMORE = TRUE IF YOU HAVE MORE CYCLES TO INSERT BESIDES THIS   
C             PARTICLAR CYCLE.  THIS IS MENT TO BE A CPU TIME SAVER.
C             IF YOU DO NOT UNDERSTAND WHAT ITS VALUE SHOULD BE,
C             ALWAYS SET IT FALSE.  
C     IFROM = THE CYCLE NUMBER THAT IBOUND IS TO BE ADDED.  
C     IBOUND= THE NUMBER OF YEARS HENCE THAT YOU WISH TO INSURE 
C             THAT A CYCLE WILL EXEC.   
C     ISPOT = THE SUBSCRIPT OF THE INSERTED CYCLE   
C     IOUT  = PRINT UNIT NUMBER FOR DEBUG MSG.  
C     DEBU  = TRUE IF DEBUGING  
C     IYLAST= NUMBER OF CYCLES PLUS 1 (NCYC+1)  
C   
      LOGICAL  DEBU,LCHFNT,LMORE,LOK
C   
C   
COMMONS 
C   
C   
      INCLUDE 'PRGPRM.F77'
C   
C   
      INCLUDE 'CONTRL.F77'
C   
C   
      INCLUDE 'PLOT.F77'
C   
C   
COMMONS 

      INTEGER IOUT,ISPOT,IBOUND,IFROM,IYLAST,I,IYPB,I1,I2   

C     **********     EXECUTION BEGINS     **********
C   
      IYLAST = NCYC + 1 
      IF ( DEBU  ) THEN 
         WRITE (IOUT,5) (IY(I),I=1,IYLAST)  
    5    FORMAT (/,' INSCYC:IY= ',20I6,/,6X,21I6)   
      ENDIF 
C   
C     STEP1 CHECK TO SEE IF THE PROPER CYCLING EXISTS.  
C   
      ISPOT = 0 
      DO 10 I= IFROM, IYLAST
      ISPOT = I 
      IF ( IY(I) .GT. IY(IFROM) + IBOUND ) GO TO 20 
      IF ( IY(I) .EQ. IY(IFROM) + IBOUND ) GO TO 200
   10 CONTINUE  
C   
C     THE LAST YEAR OF THE LAST CYCLE IS LESS THAN THE CYCLE
C     YEAR THAT IS REQUESTED.  CHECK WITH PPE TO INSURE IT IS OK TO 
C     CHANGE THE CYCLE.  IF IT IS OK, THEN SET THE LAST YEAR OF THE 
C     LAST CYCLE EQUAL TO THE YEAR THAT IS REQUESTED.   
C
      IYPB=IY(IFROM)+IBOUND
      CALL PPECYC (IYPB,LOK)
      IF (LOK) GOTO 15  
      ISPOT=0   
      RETURN
   15 CONTINUE  
      I1 = NCYC 
      GO TO 100 
   20 CONTINUE  
      IF ( ISPOT .GT. 40 ) CALL ERRGRO (.FALSE.,19) 
C   
C     CHECK WITH PARALLEL PROCESSING EXTENSION...   
C
      CALL PPECYC (IYPB,LOK)
      IF (LOK) GOTO 25  
      ISPOT=0   
      RETURN
   25 CONTINUE  
C   
C     STEP2 RESET NCYC  
C   
      NCYC = NCYC + 1   
      IYLAST = NCYC + 1 
C   
C     STEP3 MOVE VALUES; MAKE ROOM FOR THE TO-BE-INSERTED CYCLE.
C   
      I = 0 
   30 CONTINUE  
      I1 = NCYC - I 
      I2 = I1 - 1   
      IY  (IYLAST-I) = IY  (IYLAST-I-1) 
      I = I + 1 
C   
      IF ( I2 .GE. ISPOT ) GO TO 30 
      IY  (IYLAST-I) = IY  (IYLAST-I-1) 
C   
C     STEP4 READY TO INSERT.
C   
      IY ( ISPOT ) = IY ( IFROM ) + IBOUND  
      I1 = ISPOT - 1
      I2 = ISPOT + 1
      IF (LMORE) GOTO 230   
      CALL OPCYCL (NCYC,IY) 
      CALL OPCSET (ICYC)
      GO TO 230 
  100 CONTINUE  
      IY(I1+1) = IY(IFROM) + IBOUND 
      GO TO 230 
C   
  200 CONTINUE  
      ISPOT = 0 
C   
  230 CONTINUE  
C   
C     STEP5 RESET IFINT AND FINT
C   
      IF ( .NOT. LCHFNT ) GO TO 235 
      IFINT = IY(ICYC+1) - IY(ICYC) 
      FINT = IFINT  
  235 CONTINUE  
C   
      IF ( .NOT. DEBU  ) RETURN 
      WRITE (IOUT,240)  IFROM,IBOUND,ISPOT,LCHFNT,ICYC,NCYC,IFINT,LMORE 
  240 FORMAT (' INSCYC: BEFORE RETURN:',/,' IFROM    IBOUND     ISPOT', 
     >        '     LCHFNT     ICYC     NCYC      IFINT     LMORE',/,   
     >        I5,2I10,L10,3I10,L10) 
      WRITE (IOUT,5) (IY(I),I=1,IYLAST) 
      RETURN
      END   
