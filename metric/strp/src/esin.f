      SUBROUTINE ESIN (PASKEY,ARRAY,LNOTBK,KARD,LKECHO)
      IMPLICIT NONE
C----------
C    ESIN--STRP/M  DATE OF LAST REVISION:   06/03/10
C----------
C
C     OPTION PROCESSOR FOR ESTABLISHMENT MODEL
C
COMMONS
      INCLUDE 'PRGPRM.F77'
      INCLUDE 'ESPARM.F77'
      INCLUDE 'ESCOMN.F77'
      INCLUDE 'ESHAP.F77'
      INCLUDE 'CONTRL.F77'
      INCLUDE 'PLOT.F77'
      INCLUDE 'ESWSBW.F77'
      INCLUDE 'METRIC.F77'
COMMONS

C     INTERNAL STORAGE
      INTEGER KEY,IMET,IYR1,ID,ISL,IAS,IHB,ITO,IPR,N,JRGRDR,I,ILEN,IS
      INTEGER IDT,IACTK,NP,NUMBER,IPRMPT,KODE,PNN,IPPR(MAXPLT),IKYSIZ
      INTEGER IULIM,IG,IGSP,IGRP,NSPCNT
      REAL ARRAY(7)
      PARAMETER (IKYSIZ=29)
      LOGICAL DEBUG,LNOTBK(7),LTALLY,LMODE,LKECHO
      EQUIVALENCE (PNN,IPPR)
      CHARACTER IBK,ISLBK
      CHARACTER*8 TABLE(IKYSIZ),KEYWRD,PASKEY
      CHARACTER*10 KARD(7)
      CHARACTER*150 RECORD
      
      DATA IBK/' '/
      DATA TABLE/
     &  'END','PLANT','NATURAL','BURNPREP','MECHPREP','OUTPUT',
     &  'SPECMULT','BUDWORM','EZCRUISE','PLOTINFO','TALLYONE',
     &  'TALLYTWO','STOCKADJ','HABGROUP','HTADJ','TALLY','RANNSEED',
     &  'PASSALL','RESETAGE','MINPLOTS','INGROW','NOINGROW',
     &  'NOAUTALY','AUTALLY','THRSHOLD','SPROUT','NOSPROUT',
     &  'ESTAB','ADDTREES'/
C
C     SEE IF WE NEED TO DO SOME DEBUG.
C
      CALL DBCHK (DEBUG,'ESIN',4,ICYC)
C
C     LOAD THE KEYWORD INTO 'KEYWRD' AND BRANCH TO THE FNDKEY ROUTINE.
C
      KEYWRD=PASKEY
      LTALLY=.FALSE.
      CALL OPMODE (LMODE)
      IF (LMODE) THEN
         IF (LNOTBK(1)) THEN
            CALL RCDSET (10,.TRUE.)
            WRITE(JOSTND,1)
    1       FORMAT(/' ********   WARNING:  DATE OF DISTURBANCE',
     >             ' IS IGNORED.')
         ENDIF
         IDSDAT=0
      ELSE
         IF (LNOTBK(1)) THEN
            IDSDAT=IFIX(ARRAY(1))
            IF(LKECHO)WRITE(JOSTND,5) IDSDAT
    5       FORMAT (T13,'DATE OF DISTURBANCE=',I5)
         ELSE
            IDSDAT=-1
         ENDIF
      ENDIF
C
C     PROCESS MORE KEYWORDS.
C
   10 CONTINUE
      CALL KEYRDR (IREAD,JOSTND,DEBUG,KEYWRD,LNOTBK,
     &             ARRAY,IRECNT,KODE,KARD,LFLAG,LKECHO)
C
C     RETURN KODES 0=NO ERROR,1=COLUMN 1 BLANK,2=EOF
C     LESS THAN ZERO...USE OF PARMS STATEMENT IS PRESENT.
C
      IF (KODE.LT.0) THEN
         IPRMPT=-KODE
      ELSE
         IPRMPT=0
      ENDIF
C
      IF (KODE.LE.0) GO TO 30
      IF (KODE.EQ.2) CALL ERRGRO (.FALSE.,2)
      CALL ERRGRO (.TRUE.,6)
      GOTO 10
   30 CONTINUE
      CALL FNDKEY (NUMBER,KEYWRD,TABLE,IKYSIZ,KODE,DEBUG,JOSTND)
C
C     RETURN KODES 0=NO ERROR,1=KEYWORD NOT FOUND.
C
      IF (KODE.EQ.0) GO TO 90
      IF (KODE.EQ.1) THEN
         CALL ERRGRO (.TRUE.,1)
         GOTO 10
      ENDIF
C
C     SPECIAL END-OF-FILE TARGET (USED IF YOU READ PARAMETER CARDS).
C
   80 CONTINUE
      CALL ERRGRO (.FALSE.,2)
   90 CONTINUE
C
C     PROCESS OPTIONS
C
      GO TO( 1000,1200,1300,1400,1500,1600,1700,1800,1900,2000,
     &       2100,2200,2300,2400,2500,2600,2700,2800,2900,3000,
     &       3100,3200,3300,3400,3500,3600,3700,1000,3800),NUMBER
 1000 CONTINUE
C
C     OPTION NUMBER 1 -- END & ESTAB                            END & ESTAB 
C
C     IF A TALLY KEYWORD WAS PRESENT IN THE ESTAB PACKET
C     THEN DO NOT SCHEDULE ANY TALLYS.
C
      IF (LTALLY) GOTO 1080
C
C     SCHEDULE A TALLY AT THE DATE OF DISTURBANCE.  IF WE ARE
C     INSIDE AN IF-ENDIF ACTIVITY GROUP, THEN DO NOT SET THE
C     DATE OF DISTURBANCE ON THE KEYWORD.
C
      IF (LMODE) THEN
         NP=0
         IF (IDSDAT.EQ.0) IDSDAT=1
         CALL OPNEW(KODE,IDSDAT,427,NP,ARRAY)
         IF(LKECHO)WRITE(JOSTND,1020) KEYWRD,' ',IDSDAT,
     &                       ' YEARS AFTER THE EVENT IS OCCURS.'
 1020    FORMAT (/1X,A8,'   REGENERATION TALLY SEQUENCE SCHEDULED TO',
     &           ' START',A,I4,A)
      ELSE
         IF(IDSDAT.EQ.-1) GOTO 1080
         NP=1
         ARRAY(7)=FLOAT(IDSDAT)
         CALL OPNEW(KODE,MAX0(1,IDSDAT),427,NP,ARRAY(7))
         IF (KODE.GT.0) GOTO 1080
         IF(LKECHO)WRITE(JOSTND,1020) KEYWRD,' IN ',IDSDAT,' '
      ENDIF
      IF (NUMBER.EQ.1) THEN
         IF(LKECHO)WRITE(JOSTND,1021) 
 1021    FORMAT (T13,'END OF ESTABLISHMENT KEYWORDS')
C
C        MAKE SURE DATE OF DISTURBANCE IS -9999 THEREBY SIGNALING ESNUTR
C        THAT THE DATE OF DISTURBANCE HAS NEVER BEEN SET.
C
         IDSDAT=-9999
         RETURN
      ENDIF
 1080 CONTINUE
      IF (NUMBER.NE.1) THEN
         LTALLY=.FALSE.
         IF (LMODE) THEN
            IF (LNOTBK(1)) THEN
               CALL RCDSET (10,.TRUE.)
               WRITE(JOSTND,1)
            ENDIF
            IDSDAT=0
         ELSE
C     
C           IF THE NEWEST ESTAB KEYWORD CONTAINS A DATA OF DIST, THEN
C           USE IT. IF NOT, DON'T CHANGE THE STATUS OF THE DATE.
            
            IF (LNOTBK(1)) IDSDAT=IFIX(ARRAY(1))
            IF (IDSDAT.GT.-1) THEN
               IF(LKECHO)WRITE(JOSTND,1085) KEYWRD,IDSDAT
            ELSE
               IF(LKECHO)WRITE(JOSTND,1085) KEYWRD
 1085          FORMAT (/1X,A8,'   MORE ESTABLISHMENT KEYWORDS':
     >                 '; DATE OF DISTURBANCE=',I5)
            ENDIF
         ENDIF
         GOTO 10
      ELSE
         IF(LKECHO)WRITE(JOSTND,1090) KEYWRD
 1090    FORMAT (/1X,A8,'   END OF ESTABLISHMENT KEYWORDS')
         IDSDAT=-1
         RETURN
      ENDIF
 1200 CONTINUE
C
C     OPTION NUMBER 2 -- PLANT                                   PLANT
C
      ARRAY(3) = ARRAY(3) / HAtoACR
      ARRAY(6) = ARRAY(6) * MtoFT
      IACTK=430
 1205 CONTINUE
      IDT=1
      IF (LNOTBK(1)) IDT=IFIX(ARRAY(1))
C
C     IF THE PARMS FEATURE IS BEING USED PROCESS OPTION USING
C     OPNEWC, OTHERWISE, PROCESS "NORMALLY".
C
      IF (IPRMPT.GT.0) THEN
         CALL OPNEWC (KODE,JOSTND,IREAD,IDT,IACTK,KEYWRD,KARD,IPRMPT,
     >        IRECNT,ICYC)
         GOTO 10
      ENDIF
C
C     SPECIES CODE PROCESSING.
C
      CALL SPDECD (2,IS,NSP(1,1),JOSTND,IRECNT,KEYWRD,
     &             ARRAY,KARD)
      IF(IS.EQ.-999) GO TO 10
      IF(ARRAY(3).GT.0.0) GO TO 1215
      CALL KEYDMP (JOSTND,IRECNT,KEYWRD,ARRAY,KARD)
      CALL ERRGRO (.TRUE.,4)
      GO TO 10
 1215 CONTINUE
      IF(ARRAY(4).LT.0.001.OR.ARRAY(4).GT.100.0) ARRAY(4)=100.0
      CALL OPNEW(KODE,IDT,IACTK,6,ARRAY(2))
      IF (KODE.GT.0) GOTO 10
      ILEN=3
      IF(IS.LT.0)ILEN=ISPGRP(-IS,52)
      IF(LKECHO)WRITE(JOSTND,1220) KEYWRD,IDT,KARD(2)(1:ILEN),IS,
     >  ARRAY(3)/ACRtoHA,
     &  ARRAY(4),ARRAY(5),ARRAY(6)*FTtoM,
     &  ARRAY(7)
 1220 FORMAT(/1X,A8,'   DATE/CYCLE=',I5,'; SPECIES= ',A,' (CODE= ',I3,
     &  '); TREES/HA=',F6.0,'; % SURVIVAL=',F6.2,/,T13,
     &  'AGE=',F5.1,'; AVE. HEIGHT=',F5.1,'; SHADE CODE=',F5.1)
C*    IF(IACTK.EQ.431) IF(LKECHO)WRITE(JOSTND,1230)
C1230 FORMAT(12X,'NATURAL IMPLIES: STOCKADJ = 0.0, NOAUTALY, ',
C*   >           'AND NOINGROW.')
      GOTO 10
 1300 CONTINUE
C
C     OPTION NUMBER 3 -- NATURAL                               NATURAL
C
      ARRAY(3) = ARRAY(3) / HAtoACR
      ARRAY(6) = ARRAY(6) * MtoFT
      IACTK=431
      STOADJ=0.0
      LAUTAL=.FALSE.
      LINGRW=.FALSE.
      GOTO 1205
 1400 CONTINUE
C
C     OPTION NUMBER 4 -- BURNPREP                             BURNPREP
C
      CALL ESPRIN(491,IDSDAT,IRECNT,KEYWRD,ARRAY,LNOTBK,JOSTND,KARD)
      GOTO 10
 1500 CONTINUE
C
C     OPTION NUMBER 5 -- MECHPREP                             MECHPREP
C
      CALL ESPRIN(493,IDSDAT,IRECNT,KEYWRD,ARRAY,LNOTBK,JOSTND,KARD)
      GOTO 10
 1600 CONTINUE
C
C     OPTION NUMBER 6 -- OUTPUT                                 OUTPUT
C
      IF (LNOTBK(1)) THEN
         IPRINT=IFIX(ARRAY(1))
         IF(IPRINT.LT.0) IPRINT=0
      ENDIF
      IF(LKECHO)WRITE(JOSTND,1610) KEYWRD,IPRINT
 1610 FORMAT (/1X,A8,'   OUTPUT OPTION=',I2,' (0=NO OUTPUT,',
     &  ' 1=NORMAL OUTPUT).')
      IF (LNOTBK(2)) THEN
         JOREGT=IFIX(ARRAY(2))
         IF(LKECHO)WRITE(JOSTND,'(T13,''OUTPUT UNIT = '',I2)') JOREGT
      ENDIF
      GOTO 10
 1700 CONTINUE
C
C     OPTION NUMBER 7 -- SPECMULT                             SPECMULT
C
      IDT=1
      IF(LNOTBK(1)) IDT=IFIX(ARRAY(1))

      IF (IPRMPT.GT.0) THEN
         CALL OPNEWC (KODE,JOSTND,IREAD,IDT,95,KEYWRD,KARD,IPRMPT,
     >        IRECNT,ICYC)
         GOTO 10
      ENDIF
C
      IF(.NOT.LNOTBK(3)) THEN
         CALL KEYDMP (JOSTND,IRECNT,KEYWRD,ARRAY,KARD)
         CALL ERRGRO (.TRUE.,4)
         GOTO 10
      ENDIF

      IF(ARRAY(3).LT.0.0) ARRAY(3)=0.0
C
C     SPECIES CODE PROCESSING.
C
      CALL SPDECD (2,IS,NSP(1,1),JOSTND,IRECNT,KEYWRD,
     &             ARRAY,KARD)
      IF(IS.EQ.-999) GO TO 10
      CALL OPNEW(KODE,IDT,95,2,ARRAY(2))
      IF(KODE.GT.0) GOTO 10
      ILEN=3
      IF(IS.LT.0)ILEN=ISPGRP(-IS,52)
      IF(LKECHO)WRITE(JOSTND,1730) KEYWRD,IDT,KARD(2)(1:ILEN),IS,
     >  ARRAY(3)
 1730 FORMAT (/1X,A8,'   DATE/CYCLE=',I5,'; SPECIES= ',A,' (CODE= ',
     &  I3,'); MULTIPLIER=',F10.4,/,T13,'SPECMULT KEYWORD IS',
     &  ' DISABLED IN THIS VARIANT.')
      GOTO 10
 1800 CONTINUE
C
C     OPTION NUMBER 8 -- BUDWORM                               BUDWORM
C
      IF (NBWHST.GE.20) THEN
         WRITE(JOSTND,1810) NBWHST
 1810    FORMAT (/T13,'EXCEEDED MAX. #BUDWORM RECS=',I3)
         CALL ERRGRO (.TRUE.,1)
         GOTO 10
      ELSE
         IF (ARRAY(2).EQ.0.0) ARRAY(2)=ARRAY(1)
         IF (ARRAY(1).EQ.0.0 .OR. ARRAY(1).GT.ARRAY(2)) THEN
            CALL ERRGRO (.TRUE.,4)
            GOTO 10
         ELSE
            NBWHST=NBWHST+1
            IBWHST(1,NBWHST)=IFIX(ARRAY(1))
            IBWHST(2,NBWHST)=IFIX(ARRAY(2))
            IF(LKECHO)WRITE(JOSTND,1820) KEYWRD,IBWHST(1,NBWHST),
     >        IBWHST(2,NBWHST)
 1820       FORMAT (/1X,A8,'   BUDWORM ACTIVE FROM ',I4,' TO ',I4)
         ENDIF
      ENDIF
      GO TO 10
 1900 CONTINUE
C
C     OPTION NUMBER 9 -- EZCRUISE                             EZCRUISE
C
      INADV=1
      IF(LKECHO)WRITE(JOSTND,1930) KEYWRD
 1930 FORMAT (/1X,A8,'   MODEL PREDICTS REGENERATION AT TIME OF ',
     &  'DISTURBANCE OR INVENTORY.')
      GOTO 10
 2000 CONTINUE
C
C     OPTION NUMBER 10 -- PLOTINFO                            PLOTINFO
C
      JRGRDR=IREAD
      I=IFIX(ARRAY(1))
      IF(I.GE.1) JRGRDR = I
C
C     SET THE NUMBER OF PLOTS DEFINED EQUAL TO ZERO.
C
      N=0
C
C     SIGNAL THAT PLOT INFO WAS READ USING PLOTINFO OPTION.
C
      IPINFO=1
 2010 CONTINUE
      READ(JRGRDR,2020,END=80) ID,ISL,ISLBK,IAS,IHB,ITO,IPR
 2020 FORMAT(I10,I2,T11,A2,2I3,2I1)
      IRECNT=IRECNT+1
      IF(ID.LT.0) GOTO 2040
      N=N+1
      IF(N.GT.MAXPLT) GOTO 2030
C
C     IF TREEDATA HAS ALREADY BEEN READ, CHECK THE PLOTID TO SEE IF
C     THIS IS A STOCKABLE PLOT.  IPPREP IS -1 FOR NONSTOCKABLE PLOTS
C
      IF (NPTIDS.LE.0) GOTO 2028
      DO 2022 I=1,NPTIDS
      IF (IPVEC(I).EQ.ID) GOTO 2025
 2022 CONTINUE
      GOTO 2026
 2025 CONTINUE
      IF (IPPREP(I).EQ.-1) IPR=-1
 2026 CONTINUE
      IPPR(N)=IPR
      GOTO 2029
 2028 CONTINUE
      IPPREP(N)=IPR
 2029 CONTINUE
      IPTIDS(N)=ID
      PSLO(N)=FLOAT(ISL)
      IF(ISLBK.EQ.IBK) PSLO(N)=-1.
      PASP(N)=FLOAT(IAS)
      IPHAB(N)=IHB
      IPHYS(N)=ITO
      GOTO 2010
 2030 CONTINUE
C
C     BRANCH HERE IF OVER 'MAXPLT' PLOTS WERE READ, ERRGRO ISSUES
C     MSG AND ABORTS THE RUN.
C
      LSTKNT=N
      CALL ERRGRO (.FALSE.,13)
 2040 CONTINUE
C
C     WRITE KEYWORD AND NUMBER OF PLOTS READ.
C
      IF(LKECHO)WRITE(JOSTND,2050) KEYWRD,N
 2050 FORMAT(/1X,A8,3X,I3,' INDIVIDUAL PLOT RECORDS WERE READ.')
C
C     IF TREEDATA ARE ALREADY READ, THEN THE SITE PREP VECTOR NEEDS
C     TO BE MOVED TO PERMANENT STORAGE.
C
      IF (NPTIDS.LE.0) GOTO 2060
      DO 2055 I=1,N
      IPPREP(I)=IPPR(I)
 2055 CONTINUE
      GOTO 10
 2060 CONTINUE
C
C     NOW SET THE NUMBER OF PLOTS DEFINED.
C
      NPTIDS=N
      GOTO 10
 2100 CONTINUE
C
C     OPTION NUMBER 11 -- TALLYONE                            TALLYONE
C
      I=428
 2105 CONTINUE
C
C     IF THE DATE FIELD IS BLANK, SIGNAL AN ERROR.
C
      IF(.NOT.LNOTBK(1)) GOTO 2150
      IDT=IFIX(ARRAY(1))
      IF (LMODE) THEN
         NP=0
      ELSE
         IF(.NOT.LNOTBK(2)) ARRAY(2)=FLOAT(IDSDAT)
         IF(ARRAY(2).LT.0.) GOTO 2150
         NP=1
      ENDIF
      CALL OPNEW(KODE,IDT,I,NP,ARRAY(2))
      IF (KODE.GT.0) GOTO 10
      IF (LMODE) THEN
         IF(LKECHO)WRITE(JOSTND,2140) KEYWRD,IDT
      ELSE
         IF(LKECHO)WRITE(JOSTND,2140) KEYWRD,IDT,ARRAY(2)
      ENDIF
 2140 FORMAT(/1X,A8,'   DATE/CYCLE=',I5,:,
     &              '; DATE OF DISTURBANCE=',F5.0)
      LTALLY=.TRUE.
      GOTO 10
 2150 CONTINUE
      CALL KEYDMP (JOSTND,IRECNT,KEYWRD,ARRAY,KARD)
      CALL ERRGRO (.TRUE.,4)
      GOTO 10
 2200 CONTINUE
C
C     OPTION NUMBER 12 -- TALLYTWO                            TALLYTWO
C
      I=429
      GOTO 2105
 2300 CONTINUE
C
C     OPTION NUMBER 13 -- STOCKADJ                            STOCKADJ
C
      IF(LKECHO)WRITE(JOSTND,2320) KEYWRD
 2320 FORMAT (/1X,A8,'   PREDICTION OF NATURAL REGENERATION DISABLED.')
      GOTO 10
 2400 CONTINUE
C
C     OPTION NUMBER 14 -- HABGROUP                            HABGROUP
C
      IF(LKECHO)WRITE(JOSTND,2410) KEYWRD
 2410 FORMAT(/1X,A8,'   HABITAT TYPE GROUPS WILL BE PRINTED')
      CALL ESMSGS (JOREGT)
      GOTO 10
 2500 CONTINUE
C
C     OPTION NUMBER 15 -- HTADJ                                  HTADJ
C
      IDT=1
      IF(LNOTBK(1)) IDT=IFIX(ARRAY(1))

      IF (IPRMPT.GT.0) THEN
         CALL OPNEWC (KODE,JOSTND,IREAD,IDT,442,KEYWRD,KARD,IPRMPT,
     >        IRECNT,ICYC)
         GOTO 10
      ENDIF
C
      IF(.NOT.LNOTBK(3)) THEN
         CALL KEYDMP (JOSTND,IRECNT,KEYWRD,ARRAY,KARD)
         CALL ERRGRO (.TRUE.,4)
         GOTO 10
      ENDIF
      ARRAY(3) = ARRAY(3) * MtoFT
C
C     SPECIES CODE PROCESSING.
C
      CALL SPDECD (2,IS,NSP(1,1),JOSTND,IRECNT,KEYWRD,
     &             ARRAY,KARD)
      IF(IS.EQ.-999) GO TO 10
      CALL OPNEW(KODE,IDT,442,2,ARRAY(2))
      IF(KODE.GT.0) GOTO 10
      ILEN=3
      IF(IS.LT.0)ILEN=ISPGRP(-IS,52)
      IF(LKECHO)WRITE(JOSTND,2530) KEYWRD,IDT,KARD(2)(1:ILEN),IS,
     >  ARRAY(3)*FTtoM
 2530 FORMAT(/1X,A8,'   DATE/CYCLE=',I5,'; SPECIES= ',A,' (CODE= ',
     &  I3,'); ADJUSTMENT VALUE=',F10.4)
      GOTO 10
 2600 CONTINUE
C
C     OPTION NUMBER 16 -- TALLY                                 TALLY
C
      I=427
      GOTO 2105
 2700 CONTINUE
C
C     OPTION NUMBER 17 -- RANNSEED                            RANNSEED
C
      IF (LNOTBK(1).AND.ARRAY(1).EQ.0.0) CALL GETSED (ARRAY(1))
      CALL ESRNSD (LNOTBK(1),ARRAY(1))
      IF(LKECHO)WRITE(JOSTND,2710) KEYWRD,ARRAY(1)
 2710 FORMAT(/1X,A8,'   RANDOM SEED=',F14.1)
      GOTO 10
 2800 CONTINUE
C
C     OPTION NUMBER 18 -- PASSALL                              PASSALL
C
C     IF IBLK EQUALS 1, THEN EXCESS TREES ARE TO BE PASSED
C
      IBLK=1
      CONFID=ARRAY(1)
      IF(CONFID.LT.1.0) CONFID=1.0
      IF(LKECHO)WRITE(JOSTND,2810) KEYWRD,CONFID
 2810 FORMAT(/1X,A8,'   MAXIMUM NUMBER OF EXCESS TREES',
     &  ' PASSED PER PLOT PER SPECIES=',F10.2)
      GOTO 10
 2900 CONTINUE
C
C     OPTION NUMBER 19 -- RESETAGE                            RESETAGE
C
      IDT=1
      IF(LNOTBK(1)) IDT=IFIX(ARRAY(1))
      IF (IPRMPT.GT.0) THEN
         CALL OPNEWC (KODE,JOSTND,IREAD,IDT,443,KEYWRD,KARD,IPRMPT,
     >        IRECNT,ICYC)
      ELSE
         CALL OPNEW (KODE,IDT,443,1,ARRAY(2))
         IF((KODE.EQ.0).AND.LKECHO)WRITE(JOSTND,2910) KEYWRD,IDT,
     >     ARRAY(2)
 2910    FORMAT(/1X,A8,'   DATE/CYCLE=',I5,'; NEW AGE=',F6.0)
      ENDIF
      GOTO 10
 3000 CONTINUE
C
C     OPTION NUMBER 20 -- MINPLOTS                            MINPLOTS
C
C     MINPLOTS SETS THE MINIMUM NUMBER OF PLOTS TO PROJECT.
C     DEFAULT=50 (SET IN ESINIT).  MINIMUM IS 20 PLOTS.
C
      MINREP=IFIX(ARRAY(1))
      IF(MINREP.LT.20) MINREP=20
      IF(LKECHO)WRITE(JOSTND,3010) KEYWRD,MINREP
 3010 FORMAT(/1X,A8,'   MINIMUM NUMBER OF PLOTS TO PROJECT=',I5)
      GOTO 10
 3100 CONTINUE
C
C     OPTION NUMBER 21 -- INGROW                                INGROW
C
      GOTO 10
 3200 CONTINUE
C
C     OPTION NUMBER 22 -- NOINGROW                            NOINGROW
C
      LINGRW=.FALSE.
      GOTO 10
 3300 CONTINUE
C
C     OPTION NUMBER 23 -- NOAUTALY                            NOAUTALY
C
      LAUTAL=.FALSE.
      GOTO 10
 3400 CONTINUE
C
C     OPTION NUMBER 24 -- AUTALLY                              AUTALLY
C
      GOTO 10
 3500 CONTINUE
C
C     OPTION NUMBER 25 -- THRSHOLD                            THRSHOLD
C
      IF(LKECHO)WRITE(JOSTND,3510) KEYWRD
 3510 FORMAT(/1X,A8,'   THRESHOLD VALUES FOR AUTOMATIC TALLIES ',
     &  'DISABLED.')
      GOTO 10
 3600 CONTINUE
C
C     OPTION NUMBER 26 -- SPROUT                               SPROUT
C
      LSPRUT=.TRUE.
      IACTK=450
      IDT=1
      IF(LNOTBK(1)) IDT=IFIX(ARRAY(1))
      ARRAY(5) = ARRAY(5)*CMtoIN
      ARRAY(6) = ARRAY(6)*CMtoIN      
C
C     IF THE PARMS FEATURE IS BEING USED PROCESS OPTION USING
C     OPNEWC, OTHERWISE, PROCESS "NORMALLY".
C
      IF (IPRMPT.GT.0) THEN
         CALL OPNEWC (KODE,JOSTND,IREAD,IDT,IACTK,KEYWRD,KARD,IPRMPT,
     >        IRECNT,ICYC)
         GOTO 10
      ENDIF
C
      IF(LNOTBK(7)) THEN
         CALL KEYDMP (JOSTND,IRECNT,KEYWRD,ARRAY,KARD)
         CALL ERRGRO (.TRUE.,4)
         GOTO 10
      ENDIF
C----------
C     SPECIES CODE PROCESSING.
C----------
      CALL SPDECD (2,IS,NSP(1,1),JOSTND,IRECNT,KEYWRD,
     &             ARRAY,KARD)
      IF(DEBUG)WRITE(JOSTND,*)' IS,NSP(1,1),MAXSP,JOSTND,IRECNT,KEYWRD',
     &'ARRAY,KARD= ',IS,NSP(1,1),MAXSP,JOSTND,IRECNT,KEYWRD,ARRAY,KARD
C
      IF(IS.EQ.-999) THEN
        LSPRUT=.FALSE.
        GO TO 10
      ENDIF
C----------
C  CHECK TO MAKE SURE THAT INPUT SPECIES WILL SPROUT
C----------
      IF(IS.LT.0)THEN
        NSPCNT=0
        IGRP=-IS
        IULIM = ISPGRP(IGRP,1)+1
        DO IG=2,IULIM
        IGSP = ISPGRP(IGRP,IG)
        DO I=1,NSPSPE
        IF(IGSP.EQ.ISPSPE(I))NSPCNT=NSPCNT+1
        ENDDO
        ENDDO
        IF(NSPCNT.EQ.ISPGRP(IGRP,1))GOTO 3604
      ELSEIF(IS.EQ.0)THEN
        GOTO 3604
      ELSE
        DO I=1,NSPSPE
        IF(IS.EQ.ISPSPE(I))GOTO 3604
        ENDDO
      ENDIF
C----------
C  NO VALID SPROUTING SPECIES CODE WAS FOUND.  SIGNAL AN ERROR.
C----------
      CALL KEYDMP (JOSTND,IRECNT,KEYWRD,ARRAY,KARD)
      CALL ERRGRO (.TRUE.,4)
      LSPRUT=.FALSE.
      GOTO 10
 3604 CONTINUE
      IF(DEBUG) WRITE(JOSTND,*)' IS= ',IS
      IF(.NOT.LNOTBK(3))ARRAY(3)=1.
      IF(.NOT.LNOTBK(4))ARRAY(4)=1.
      IF(.NOT.LNOTBK(5))ARRAY(5)=0.
      IF(.NOT.LNOTBK(6))ARRAY(6)=999.*CMtoIN
C
      CALL OPNEW(KODE,IDT,IACTK,5,ARRAY(2))
      IF(KODE.GT.0) GOTO 10
      ILEN=3
      IF(IS.LT.0)ILEN=ISPGRP(-IS,52)
      IF(LKECHO)WRITE(JOSTND,3606) KEYWRD,IDT,KARD(2)(1:ILEN),IS,
     >ARRAY(3),ARRAY(4),ARRAY(5)*INtoCM,ARRAY(6)*INtoCM
 3606 FORMAT(/1X,A8,'   DATE/CYCLE=',I5,'; SPROUTING WILL BE SIMULATED.'
     &,'ADJUSTMENTS FOR SPECIES= ',A,' (CODE= ',I3,') ARE;',/T13,
     &'SPROUT NUMBER MULTIPLIER VALUE= ',F10.4,';  HEIGHT MULTIPLIER',
     &' VALUE= ',F10.4,';',/T13,'LOWER DBH LIMIT= ',F10.2,';  UPPER',
     &' DBH LIMIT= ',F10.2)
      GOTO 10
 3700 CONTINUE
C
C     OPTION NUMBER 27 -- NOSPROUT                           NOSPROUT
C
      LSPRUT=.FALSE.
      IF(LKECHO)WRITE(JOSTND,3710) KEYWRD
 3710 FORMAT (/1X,A8,'   SPROUTING WILL NOT BE SIMULATED.')
      GOTO 10
 3800 CONTINUE
C
C     OPTION NUMBER 28 -- ADDTREES                           ADDTREES
C
      IACTK=432
      IDT  = 1
      IYR1 = 0
      IMET = 0
      IF(LNOTBK(1)) IDT  = IFIX(ARRAY(1))
      IF(LNOTBK(2)) IYR1 = IFIX(ARRAY(2))
      IF(LNOTBK(3)) IMET = IFIX(ARRAY(3))
      ARRAY(2) = FLOAT(IYR1)
      ARRAY(3) = FLOAT(IMET)

C     METHOD=1; READ EXTERNAL PROGRAM THAT WILL GENERATE PLANT COMMANDS

      IF (IMET .EQ. 1) THEN
        READ(IREAD,'(A)',END=80) RECORD
        IRECNT=IRECNT+1
        IF (RECORD.EQ.' ') THEN
          CALL KEYDMP (JOSTND,IRECNT,KEYWRD,ARRAY,KARD)
          CALL ERRGRO (.TRUE.,4)
          GOTO 10
        ENDIF
        IF (IPRMPT.GT.0) THEN
          IF (IPRMPT.NE.2) THEN
            CALL KEYDMP (JOSTND,IRECNT,KEYWRD,ARRAY,KARD)
            CALL ERRGRO (.TRUE.,25)
          ELSE
            CALL OPNEWC (KODE,JOSTND,IREAD,IDT,IACTK,KEYWRD,KARD,
     >        IPRMPT,IRECNT,ICYC)
          ENDIF
        ELSE
          CALL OPNEW (KODE,IDT,IACTK,2,ARRAY(2))
        ENDIF
        IF (KODE.EQ.0) CALL OPCACT (KODE,RECORD)
        IF(LKECHO)WRITE(JOSTND,3830) KEYWRD,IDT,INT(ARRAY(2)),
     >    INT(ARRAY(3))
 3830   FORMAT(/1X,A8,'   DATE/CYCLE=',I5,' SCHEDULE PLANTING=', I5,
     >    ' YRS LATER; METHOD=',I2)
      ENDIF
      GOTO 10
C*********************************************************************
C
C     SPECIAL ENTRY TO TURN OFF AUTOMATIC TALLIES AND INGROWTH.
C
      ENTRY ESNOAU (PASKEY,LKECHO)
C*********************************************************************
      LAUTAL=.FALSE.
      LINGRW=.FALSE.
      LSPRUT=.FALSE.
      STOADJ=0.0
      IF(LKECHO)WRITE(JOSTND,3110) PASKEY,'TALLIES AND INGROWTH',' NOT '
 3110 FORMAT (/1X,A8,3X,A,' WILL',A,'BE ADDED AUTOMATICALLY.')
      IF(LKECHO)WRITE(JOSTND,9010)
 9010 FORMAT (T13,'NO SPROUTING WILL BE SIMULATED.')
      RETURN
C
C     SPECIAL ENTRY TO RETRIEVE KEYWORDS.
C
      ENTRY ESKEY (KEY,PASKEY)
      PASKEY=TABLE(KEY)
      RETURN
      END
