      SUBROUTINE SUMOUT(IOSUM,I17,IPT,ITYPE,JOPRT,JOSTND,JOSUM,
     >                  LEN,MGMID,NPLT,SAMWT,ITITLE)
      IMPLICIT NONE
C----------
C  **SUMOUT--LS   DATE OF LAST REVISION:  07/11/08
C----------
C
C     WRITES SUMMARY OUTPUT.
C
C     IOSUM = THE SUMMARY OUTPUT ARRAY FROM THE FVS MODEL.
C              1: YEAR
C              2: AGE
C              3: TREES/ACRE
C     *        4: MERCH CU FT (PULP AND SAWLOG)
C     *        5: MERCH CU FT (SAWLOG)
C     *        6: MERCH BD FT (SAWLOG)
C              7: REMOVED TREES/ACRE
C     *        8: REMOVED MERCH CU FT (PULP AND SAWLOG)
C     *        9: REMOVED MERCH CU FT (SAWLOG)
C     *       10: REMOVED MERCH BD FT (SAWLOG)
C             11: BASAL AREA/ACRE
C             12: CCF
C             13: AVERAGE DOMINANT HEIGHT
C             14: PERIOD LENGTH (YEARS)
C             15: ACCRETION (ANNUAL IN CU FT/ACRE)
C             16: MORTALITY  (ANNUAL IN CU FT/ACRE)
C             17: SAMPLE WEIGHT
C
C NOTE: * Indicates R9 specific.  !!!!!!!!!
C
C     IPT   = POINTER ARRAY USED TO ACCESS IOSUM IN CRONOLOGICAL
C             ORDER. IF IPT(1)=0, IOSUM IS ASSUMED TO BE IN
C             CRONOLOGICAL ORDER.
C     ITYPE = SUMMARY TABLE TYPE
C     JOSTND= DATA SET REFERENCE NUMBER FOR 'PRINTED' COPY (WITH
C             HEADINGS AND CARRAGE CONTROL BYTE).  IF JOSTND=0, NO
C             DATA WILL BE WRITTEN.
C     JOPRT = PRINTER OUTPUT FOR MESSAGES.
C     JOSUM = DATA SET REFERENCE NUMBER FOR 'NON-PRINTED' COPY (WITH
C             OUT HEADINGS, NO CARRAGE CONTROL BYTE). IF JOSUM=0,
C             NO DATA WILL BE WRITTEN.
C     LEN   = NUMBER OF ROWS (ENTRIES) IN IOSUM.
C     MGMID = MANAGEMENT IDENTIFICATION FIELD. ASSUMED ALPHANUMERIC.
C     NPLT  = PLOT IDENTIFICATION FIELD. ASSUMED ALPHANUMERIC.
C
COMMONS
C
C
      INCLUDE 'PRGPRM.F77'
C
C
      INCLUDE 'SUMTAB.F77'
C
COMMONS
C
      CHARACTER CISN*11,NPLT*26,TIM*8,DAT*10,MGMID*4,VVER*7,REV*10
      CHARACTER ITITLE*72
      INTEGER IPT(LEN)
      INTEGER*4 IOSUM(I17,LEN)
      INTEGER JOSUM,JOSTND,JOPRT,ITYPE,I17,ISTLNB,I12,J,I,K,LEN
      REAL SAMWT,OLDAGE,AGE,YMAI,REM
      LOGICAL LNOR,LPRT,LDSK
C
C     **************************************************************
C
C     STEP1: SET SWITCHES.
C
      LPRT= JOSTND .GT. 0
      LDSK= JOSUM .GT. 0
      IF (.NOT. (LPRT.OR.LDSK)) RETURN
      LNOR= IPT(1) .NE. 0
C
      CALL PPISN (CISN)
      CALL VARVER (VVER)
      CALL REVISE (VVER,REV)
      CALL GRDTIM (DAT,TIM)
      IF(LDSK) WRITE (JOSUM,2) LEN,NPLT,MGMID,SAMWT,VVER,DAT,TIM,
     &                         REV,CISN
    2 FORMAT ('-999',I5,1X,A26,1X,A4,E15.7,5(1X,A))
C
C     STEP2: WRITE HEADING; SKIP A FEW LINES, DO NOT START A NEW PAGE.
C
      IF (LPRT) THEN
      WRITE (JOSTND,5) NPLT,MGMID,ITITLE(1:ISTLNB(ITITLE))
    5 FORMAT(/'STAND ID: ',A26,4X,'MGMT ID: ',A4,4X,A/)
      WRITE (JOSTND,10)
   10 FORMAT(//32X,'SUMMARY STATISTICS (PER ACRE OR STAND BASED ON TOTAL
     & STAND AREA)',/,
     &  127(1H-),/15X,'START OF SIMULATION PERIOD',21X,'REMOVALS',13X,
     &  'AFTER TREATMENT',4X,'GROWTH THIS PERIOD',/9X,45(1H-),1X,
     &  23(1H-),1X,21(1H-),2X,18(1H-),3X,'MAI',/9X,'NO OF',14X,'TOP',
     &  6X,'MERCH SAWLG SAWLG NO OF MERCH SAWLG SAWLG',14X,'TOP  RES  ',
     &  'PERIOD ACCRE MORT   MERCH',/'YEAR AGE TREES  BA  SDI CCF ',
     &  'HT  QMD  CU FT CU FT BD FT TREES CU FT CU FT BD FT  BA  SDI ',
     &  'CCF HT   QMD  YEARS   PER  YEAR   CU FT',/'---- --- ----- ',
     &  '--- ---- --- --- ---- ',7('----- '),'--- ---- --- --- ----  ',
     &  '------ ---- -----   -----')
      ENDIF
C
C
C     STEP3: LOOP THRU ALL ROWS IN IOSUM...WRITE OUTPUT.
C
C  THIS STEP TAKES JUST THE FIRST 12 ITEMS IN THE IOSUM ARRAY
C
      I12=I17-5
      TOTREM=0.0
      MAIFLG=0
      NEWSTD = 0
      OLDAGE = 0.0
      DO 50 J=1,LEN
      I=J
      IF (LNOR) I=IPT(J)
C
      AGE = IOSUM(2,I)
      IF(AGE .LT. OLDAGE) TOTREM = 0.0
      OLDAGE = AGE
      IF(AGE.EQ.0.0 .OR. (MAIFLG.EQ.1 .AND. NEWSTD.NE.1)) THEN
          YMAI = 0.0
          MAIFLG = 1
          GO TO 11
      ENDIF
C----------
C  MAI for R-9 is based upon total sawlog AND pulpwood CF volume.
C----------
      REM=IOSUM(4,I)
      YMAI=(TOTREM + REM )/AGE
      TOTREM=TOTREM+IOSUM(8,I)
   11 CONTINUE
      IF(LPRT)
     &    WRITE(JOSTND,20) (IOSUM(K,I),K=1,3),IOLDBA(I),ISDI(I),
     &      IBTCCF(I),IBTAVH(I),QSDBT(I),(IOSUM(K,I),K=4,11),
     &      ISDIAT(I),IOSUM(12,I),IOSUM(13,I),QDBHAT(I),
     &      (IOSUM(K,I),K=14,16),YMAI
   20     FORMAT(2I4,I6,I4,I5,2I4,F5.1,7I6,I4,I5,2I4,F5.1,2X,
     &           I6,I5,I6,2X,F6.1)
C
      IF(LDSK)
     &    WRITE(JOSUM,9014) (IOSUM(K,I),K=1,3),IOLDBA(I),ISDI(I),
     &      IBTCCF(I),IBTAVH(I),QSDBT(I),(IOSUM(K,I),K=4,11),
     &      ISDIAT(I),IOSUM(12,I),IOSUM(13,I),QDBHAT(I),
     &      (IOSUM(K,I),K=14,16),YMAI
 9014     FORMAT(2I4,I6,I4,I5,2I4,F5.1,7I6,I4,I5,2I4,F5.1,2X,I6,
     &           I5,I6,2X,F6.1)
C
      IF(IOSUM(11,I).EQ.0 .AND. IOSUM(12,I).EQ.0 .AND.
     *   ISDIAT(I).EQ.0 .AND. IOSUM(7,I).NE.0) THEN
        NEWSTD = 1
        TOTREM = 0.0
      ENDIF
      IF(AGE .EQ. 0.0 .AND. IOSUM(3,I) .EQ. 0.0) NEWSTD=1
   50 CONTINUE
C
      IF (.NOT.LDSK) RETURN
      WRITE (JOPRT,60) LEN,JOSUM
   60 FORMAT(/'NOTE:',I3,' LINES OF SUMMARY DATA HAVE BEEN WRITTEN',
     >       ' TO THE FILE REFERENCED BY LOGICAL UNIT',I3)
      RETURN
      END
