      SUBROUTINE OPRDAT (JEXOPT,KODE)
      IMPLICIT NONE
C----------
C  **OPRDAT - BASE/M  DATE OF LAST REVISION:  07/23/08
C----------
C
C     READS A FILE OF "MORE ACTIVITIES" AND SCHEDULES THEM FOR
C     THE CURRENT STAND.
C
C     N.L. CROOKSTON--FORESTRY SCIENCES LAB, MOSCOW, ID--FEB 2004
C
C     JEXOPT = THE DATA SET REFERENCE NUMBER FOR READING THE FILE
C              (NOTE THAT THE FILE MUST ALREADY BE OPENED).
C     KODE   = IF POSITIVE, THE NUMBER OF ACTIVITIES ADDED
C              IF NEGATIVE, THE NUMBER OF FAILURES TO ADD ACTIVITIES
C
COMMONS
C
C
      INCLUDE 'PRGPRM.F77'
      INCLUDE 'CONTRL.F77'
      INCLUDE 'OPCOM.F77'
      INCLUDE 'PLOT.F77'
      INCLUDE 'METRIC.F77'
C
C
COMMONS
C
      INTEGER MXADDP,IPASS,NADD,I,NPRMS,IACTK,IDT,KODE,JEXOPT,
     >        NFAIL
      PARAMETER (MXADDP=N_METRIC_PRMS)
      REAL PRMS(MXADDP)
      REAL CPRMS(MXADDP)
C
      KODE = -999
      IF (JEXOPT.LE.0) RETURN

C     PICK UP READING WHERE EVER THE FILE POINTER IS AT THE TIME...
C     THIS APPROACH OFFERS SOME GREAT EFFICIENCIES WHEN CALLED BY THE PPE

      IPASS = 0
      NADD  = 0
      NFAIL = 0
   10 CONTINUE
      READ (JEXOPT,'(A)',END=30) WKSTR1
      IF (INDEX(WKSTR1,TRIM(NPLT)).EQ.1) THEN
   15   CONTINUE
        READ (JEXOPT,'(A)',END=30) WKSTR1
        IF (WKSTR1(1:3).NE.'End') THEN
          READ (WKSTR1,*) IACTK,IDT,NPRMS,(PRMS(I),I=1,
     >                    MIN(NPRMS,MXADDP))
          IF (IDT.GE.IY(ICYC)) THEN
            CALL MCNVRT(IACTK,1,CPRMS)
            DO I = 1,NPRMS
               PRMS(I) = PRMS(I) * CPRMS(I)
	      ENDDO
            CALL OPADD (IDT,IACTK,0,NPRMS,PRMS,KODE)
            IF (KODE .EQ. 0) THEN
              NADD  = NADD+1
            ELSE
              NFAIL = NFAIL+1
            ENDIF
          ENDIF
          GOTO 15
        ENDIF
        IF (NADD.GT.0) CALL OPINCR (IY,ICYC,NCYC)
        IF (NFAIL .EQ. 0) THEN
          KODE = NADD
        ELSE
          KODE = -NFAIL
        ENDIF
        RETURN
      ELSE
   20   CONTINUE
        READ (JEXOPT,'(A)',END=30) WKSTR1
        IF (WKSTR1(1:3).NE.'End') GOTO 20
        GOTO 10
      ENDIF
   30 CONTINUE

      REWIND JEXOPT

C     IF ONLY ON THE FIRST PASS THROUGH THE DATA, TRY AGAIN.

      IF (IPASS.EQ.1) RETURN
      IPASS=1
      GOTO 10
      END