      SUBROUTINE DISPLY
      IMPLICIT NONE
C----------
C  **DISPLY--BS    DATE OF LAST REVISION:  07/02/10
C----------
C  **DISPLY** PRINTS STAND AND TREE STATISTICS AT THE BEGINNING
C  OF THE PROJECTION, AND AT THE END OF EACH CYCLE.  ESTIMATES
C  STAND AGE IF MISSING FROM THE STNDINFO KEYWORD
C----------
COMMONS
C
C
      INCLUDE 'PRGPRM.F77'
C
C
      INCLUDE 'ARRAYS.F77'
C
C
      INCLUDE 'CONTRL.F77'
C
C
      INCLUDE 'OUTCOM.F77'
C
C
      INCLUDE 'PLOT.F77'
C
C
      INCLUDE 'ECON.F77'
C
C
      INCLUDE 'SCREEN.F77'
C
C
      INCLUDE 'SUMTAB.F77'
C
C
      INCLUDE 'VARCOM.F77'
C
COMMONS
C
C----------
C  DIMENSIONS FOR INTERNAL VARIABLES (USED AS OUTPUT LABELS):
C----------
      INTEGER IRT,JYR,I,IOAGE,IKNT,IXF,IFIA,ISWT,J,JSDI,ISNOFT
      REAL DUM1,SUMAGE,AGEKNT,TEM,SDIBCTMP,SDIACTMP
      CHARACTER*7 VVER
      CHARACTER*9 AT1,AT2,AT3,AT4
      CHARACTER*10 STD(3)
C----------
C  DATA STATEMENTS:
C----------
      DATA AT1/'REMOVAL  '/,AT2/'VOLUME:  '/,AT3/
     & 'RESIDUAL '/,AT4/'ACCRETION'/
C----------
C  IDENTIFY VARIANT
C----------
      CALL VARVER (VVER)
C----------
C  IF ICL6 IS NEGATIVE,  PROJECTION IS COMPLETE AND WE NEED ONLY TO
C  PRINT THE FINAL LINE FOR  THE SAMPLE TREE OUTPUT  (DISPLAYING
C  STAND ATTRIBUTES FOLLOWING THINNING), AND THE FINAL LINE OF THE
C  SUMMARY OUTPUT.   BRANCH TO STATEMENT 34.
C----------
      IF (.NOT.LSTART.OR.ITABLE(2).EQ.1) GO TO 10
      IRT = 0
      WRITE (JOTREE) IRT,NPLT,MGMID
   10 CONTINUE
      IF(ICL6.LT.0) GO TO 34
C----------
C  ASSIGN JYR.
C----------
      JYR=IY(ICYC+1)
C----------
C   IF USER HAS SPECIFIED KEYWORDS THAT ALTER VOLUME EQUATION PARAMETERS
C   (IE VOLUMME BFVOLUME,ETC) THEN PRINT LABEL THAT INDICATES USER
C   SPECIFIED STANDARDS.  THESE LABLES ARE VARIANT SPECIFIC
C----------
C
      IF ((VVER(:2) .EQ. 'CS') .OR. (VVER(:2) .EQ. 'LS') .OR.
     1    (VVER(:2) .EQ. 'NE') .OR. (VVER(:2) .EQ. 'OZ') .OR.
     2    (VVER(:2) .EQ. 'SE') .OR. (VVER(:2) .EQ. 'SN')) THEN
C
         IF (LCVOLS) THEN
            STD(1)='USER MERCH'
            STD(2)='SAWLG'
         ELSE
            STD(1)='MERCH'
            STD(2)='SAWLG'
         ENDIF
C
         IF (LBVOLS) THEN
            STD(3)='USER SAWLG'
         ELSE
            STD(3)='SAWLG'
         ENDIF
C
      ELSE
C
         IF (LCVOLS) THEN
            STD(1)='USER TOTAL'
            STD(2)='USER MERCH'
         ELSE
            STD(1)='TOTAL'
            STD(2)='MERCH'
         ENDIF
C
         IF (LBVOLS) THEN
            STD(3)='USER MERCH'
         ELSE
            STD(3)='MERCH'
         ENDIF
      ENDIF
C----------
C  WRITE REMOVAL STATISTICS.  BYPASS IF LSTART IS TRUE OR NUMBER
C  OF TREES REMOVED WAS LESS THAN OR EQUAL TO ZERO.
C  SKIP PRINTING OF STAND COMPOSITION TABLE IF NOT WANTED.
C----------
      IF (ITABLE(1) .EQ. 1) GO TO 32
      IF(LSTART) GO TO 30
      IF(ONTREM(7).LE.0.0) GO TO 20
      WRITE(JOSTND,9003)
 9003 FORMAT(/)
      WRITE(JOSTND,9004) AT1,ONTREM,(OSPTT(I),IOSPTT(I),I=1,4)
 9004 FORMAT(7X,A9,3X,5F7.1,F8.1,F9.0,' TREES   ',
     >       3(F5.0,'% ',A3,','),F5.0,'% ',A3)
C
C
      WRITE(JOSTND,9005) AT2,STD(1),OCVREM,(OSPTV(I),IOSPTV(I),I=1,4),
     &                       STD(2),OMCREM,(OSPMR(I),IOSPMR(I),I=1,4),
     &                       STD(3),OBFREM,(OSPBR(I),IOSPBR(I),I=1,4)
C
 9005 FORMAT(7X,A9/9X,A10,5F7.1,F8.1,F9.0,' CUFT    ',
     >       3(F5.0,'% ',A3,','),F5.0,'% ',A3/
     &      9X,A10,5F7.1,F8.1,F9.0,' CUFT    ',
     >       3(F5.0,'% ',A3,','),F5.0,'% ',A3/
     &      9X,A10,5F7.1,F8.1,F9.0,' BDFT    ',
     >       3(F5.0,'% ',A3,','),F5.0,'% ',A3)
      WRITE(JOSTND,9003)
      WRITE(JOSTND,9004) AT3,ONTRES,(OSPRT(I),IOSPRT(I),I=1,4)
C----------
C  WRITE ACCRETION AND MORTALITY STATISTICS.  BYPASSED IF LSTART
C  IS TRUE. IF MORTALITY FUNCTIONS HAVE BEEN MODIFIED BY CERTAIN
C  KEYWORDS THEN CHANGE LABEL FROM 'MORTALITY' TO 'USER MORT'.
C----------
   20 CONTINUE
      WRITE(JOSTND,9003)
      WRITE(JOSTND,9006) AT4,OACC,(OSPAC(I),IOSPAC(I),I=1,4)
      IF (LMORT) THEN
         WRITE(JOSTND,9006) 'USER MORT',OMORT,(OSPMO(I),IOSPMO(I),I=1,4)
      ELSE
         WRITE(JOSTND,9006) 'MORTALITY',OMORT,(OSPMO(I),IOSPMO(I),I=1,4)
      ENDIF
 9006 FORMAT(7X,A9,3X,5F7.1,F8.1,F9.0,' CUFT/YR ',
     >       3(F5.0,'% ',A3,','),F5.0,'% ',A3)
C----------
C  WRITE CURRENT STAND STATISTICS.
C----------
   30 CONTINUE
      WRITE(JOSTND,9003)
      WRITE(JOSTND,9007) JYR,ONTCUR,(OSPCT(I),IOSPCT(I),I=1,4)
 9007 FORMAT(/,1X,I4,'  TREES',T20,5F7.1,F8.1,F9.0,' TREES   ',
     >       3(F5.0,'% ',A3,','),F5.0,'% ',A3)
      WRITE(JOSTND,9005) AT2,STD(1),OCVCUR,(OSPCV(I),IOSPCV(I),I=1,4),
     &                       STD(2),OMCCUR,(OSPMC(I),IOSPMC(I),I=1,4),
     &                       STD(3),OBFCUR,(OSPBV(I),IOSPBV(I),I=1,4)
  32  CONTINUE
C----------
C  WRITE OUTPUT FOR SAMPLE TREES.  FIRST, OUTPUT STAND CONDITIONS
C  FOR PREVIOUS CYCLE.  BYPASS IF LSTART IS TRUE. ALSO SKIP TREE
C  DATA IF TABLE IS NOT DESIRED.
C----------
      IF(LSTART) GO TO 39
   34 CONTINUE
      IOAGE=IAGE+IY(ICYC)-IY(1)
      IF (ITABLE(2) .EQ. 1) GO TO 41
C----------
C  GO TO STATEMENT 35 AND WRITE BOTH PRE AND POST THINNING STATISTICS
C  IF THINNING OCCURRED IN PREVIOUS CYCLE.
C----------
      IF(LZEIDE)THEN
        JSDI=SDIBC2 + 0.5
      ELSE
        JSDI=SDIBC + 0.5
      ENDIF
      IF(ONTREM(7).GT.0.0) GO TO 35
      IRT=1
      WRITE(JOTREE) IRT,IOAGE,ORMSQD,OLDTPA,OLDBA,OLDAVH,RELDM1,JSDI
      GO TO 36
   35 CONTINUE
      IRT=2
      WRITE(JOTREE) IRT,IOAGE,ORMSQD,OLDTPA,OLDBA,OLDAVH,RELDM1,JSDI
      IRT=3
      IF(LZEIDE)THEN
        JSDI=SDIAC2 + 0.5
      ELSE
        JSDI=SDIAC + 0.5
      ENDIF
      WRITE(JOTREE) IRT,ATAVD,ATTPA,ATBA,ATAVH,ATCCF,JSDI
   36 CONTINUE
C----------
C  IF ICL6.LT.0 BRANCH TO STMT. 90 TO LOAD LAST LINE OF SUMMARY OUTPUT
C----------
      IF(ICL6.LT.0) GO TO 90
C----------
C  WRITE YEAR  AND PERIOD LENGTH.
C----------
   39 CONTINUE
      IF(ITABLE(2).EQ.1)GO TO 41
C-------
C  IF SAMPLE TREES WERE RESELECTED THIS CYCLE (IFST=99), THEN SET
C  SIGN OF YEAR NEGETIVE.
C-------
      I=JYR
      IF (IFST.EQ.0) GOTO 40
      IFST=0
      IF (LSTART) GOTO 40
      I=-I
   40 CONTINUE
      IRT=4
      WRITE(JOTREE) IRT,I,IFINT
C----------
C  WRITE EXAMPLE TREE DATA.
C----------
      IRT=5
      WRITE(JOTREE) IRT,IONSP,DBHIO,HTIO,IOICR,DGIO,PCTIO,PRBIO
  41  CONTINUE
C----------
C  LOAD THE ARRAY CONTAINING SUMMARY DATA.
C----------
      IKNT=ICYC+1
C----------
C  CALCULATE FOREST TYPE (IFORTP), SIZE CLASS (ISZCL),
C  AND STOCKING CLASS (ISTCL)
C----------
      DUM1=0.
      IXF=2
      ISNOFT=IFORTP
      CALL FORTYP(IXF,DUM1)
C-------
C  IF THIS IS THE SN VARIANT, AND THE FOREST TYPE JUST CHANGED, THEN
C  WE MAY ALSO NEED TO UPDATE THE SDIDEF ARRAY AND SDIMAX AND BAMAX
C  SCALERS.
C-------
      IF(VVER(:2).EQ.'SN' .AND. IFORTP.NE.ISNOFT)THEN
        IF (.NOT. LFIXSD) THEN
C----------
C  IF USER SPECIFIED SDIMAX OR BAMAX, THEN MODIFY SDIDEF
C----------
          TEM=PMSDIU
          IF(TEM .GT. 1.0) TEM=TEM/100.
          DO 4 I=1,MAXSP
          IF(MAXSDI(I) .GE. 1) GO TO 4
          IF (LBAMAX)THEN
            SDIDEF(I)=BAMAX/(0.5454154*TEM)
          ELSE
            SDIDEF(I)=DUM1
          ENDIF
    4     CONTINUE
        ENDIF
      CALL SDICAL(SDIMAX)
      BAMAX = SDIMAX*PMSDIU*0.5454154
      ENDIF
C----------
C  ESTIMATE STAND AGE FROM SIZE CLASS AND ABIRTH
C  IF IT WAS MISSING FROM THE INPUT DATA, SET IT FROM THIS ESTIMATE..
C----------
      IF(LSTART)THEN
        SUMAGE=0.
        AGEKNT=0.
C*        WRITE(JOSTND,*)' IAGE,ISZCL,ITRN= ',IAGE,ISZCL,ITRN
        IF(ISZCL.EQ.0 .OR. ISZCL.GT.3)THEN
          ICAGE=0
          GO TO 42
        ELSEIF(ISZCL .EQ. 3) THEN
          DO I=1,ITRN
          IF(DBH(I).LT.5.)THEN
            SUMAGE=SUMAGE+ABIRTH(I)*PROB(I)
            AGEKNT=AGEKNT+PROB(I)
C*            WRITE(JOSTND,*)' I,D,AGE,PROB,SUMAGE,AGEKNT= ',
C*     &      I,DBH(I),ABIRTH(I),PROB(I),SUMAGE,AGEKNT
          ENDIF
          ENDDO
        ELSEIF(ISZCL .EQ. 2) THEN
          DO I=1,ITRN
          IF(FIAJSP(ISP(I))(1:1).EQ.'-')THEN
            IFIA=998
          ELSE
            READ(FIAJSP(ISP(I)),'(I4)') IFIA
          ENDIF
          IF((IFIA.LT.300. .AND. DBH(I).GE.5. .AND. DBH(I).LT.9.) .OR.
     &       (IFIA.GE.300. .AND. DBH(I).GE.5. .AND. DBH(I).LT.11.))THEN
            SUMAGE=SUMAGE+ABIRTH(I)*PROB(I)
            AGEKNT=AGEKNT+PROB(I)
C*            WRITE(JOSTND,*)' I,IFIA,D,AGE,PROB,SUMAGE,AGEKNT= ',
C*     &      I,IFIA,DBH(I),ABIRTH(I),PROB(I),SUMAGE,AGEKNT
          ENDIF
          ENDDO
        ELSE
          DO I=1,ITRN
          IF(FIAJSP(ISP(I))(1:1).EQ.'-')THEN
            IFIA=998
          ELSE
            READ(FIAJSP(ISP(I)),'(I4)') IFIA
          ENDIF
          IF((IFIA.LT.300. .AND. DBH(I).GE.9.) .OR.
     &       (IFIA.GE.300. .AND. DBH(I).GE.11.))THEN
            SUMAGE=SUMAGE+ABIRTH(I)*PROB(I)
            AGEKNT=AGEKNT+PROB(I)
C*            WRITE(JOSTND,*)' I,IFIA,D,AGE,PROB,SUMAGE,AGEKNT= ',
C*     &      I,IFIA,DBH(I),ABIRTH(I),PROB(I),SUMAGE,AGEKNT
          ENDIF
          ENDDO
        ENDIF
        IF(AGEKNT.GT.0.)THEN
C*        WRITE(JOSTND,*)' AGEKNT= ',AGEKNT
          ICAGE=IFIX(SUMAGE/AGEKNT)
        ELSE
          ICAGE=0
        ENDIF
C*        WRITE(JOSTND,*)' SUMAGE,AGEKNT,ICAGE= ',SUMAGE,AGEKNT,ICAGE
C----------
C  REMOVE THE COMMENT CHARACTERS (C**) IN THE FOLLOWING STATEMENT
C  TO ENABLE REPORTING THE INITIAL STAND AGE, AGECMP, (IF 0 IN STDINFO
C  KEYWORD) IN THE SUMMARY STATISTICS TABLE.  DO **NOT** USE FOR THE
C  FOLLOWING VARIANTS, AK, CI, CS, IE, KT, LS, NE, NI, SE, TT, UT, WS,
C  WHICH DO NOT CONSISTENTLY USE SITE CURVES FOR HEIGHT GROWTH.
C----------
C**        IF(IAGE .EQ. 0)IAGE=ICAGE
      ENDIF
   42 CONTINUE
C
      IOSUM(01,IKNT)=IY(IKNT)
      IOSUM(03,IKNT)=ONTCUR(7)/GROSPC+0.5
      IOSUM(04,IKNT)=OCVCUR(7)/GROSPC+0.5
      IOSUM(05,IKNT)=OMCCUR(7)/GROSPC+0.5
      IOSUM(06,IKNT)=OBFCUR(7)/GROSPC+0.5
C
      IOSUM(18,IKNT)=IFORTP
      IOSUM(19,IKNT)=ISZCL
      IOSUM(20,IKNT)=ISTCL
C----------
C  IF LSTART IS TRUE,  DONT LOAD REMOVAL AND GROWTH STATISTICS.
C----------
      IF(LSTART) GO TO 100
C----------
C  ENTER HERE TO LOAD FINAL LINE OF SUMMARY OUTPUT.
C----------
   90 CONTINUE
      IKNT=ICYC
      IOSUM(02,IKNT)=IOAGE
      IF (ONTREM(7).LE.0.0) GOTO 91
      IOSUM(03,IKNT)=OLDTPA/GROSPC+.5
      IOSUM(11,IKNT)=ATBA/GROSPC+0.5
      IOSUM(12,IKNT)=ATCCF/GROSPC+0.5
      IOSUM(13,IKNT)=ATAVH+0.5
      QDBHAT(IKNT)=ATAVD
      SDIACTMP=SDIAC
      IF(LZEIDE)SDIACTMP=SDIAC2
      ISDIAT(IKNT)=SDIACTMP/GROSPC + 0.5
      GOTO 92
   91 CONTINUE
      IOSUM(11,IKNT)=OLDBA/GROSPC+0.5
      IOSUM(12,IKNT)=RELDM1/GROSPC+0.5
      IOSUM(13,IKNT)=OLDAVH+0.5
      QDBHAT(IKNT)=ORMSQD
      SDIBCTMP=SDIBC
      IF(LZEIDE)SDIBCTMP=SDIBC2
      ISDIAT(IKNT)=SDIBCTMP/GROSPC + 0.5
   92 CONTINUE
      SDIBCTMP=SDIBC
      IF(LZEIDE)SDIBCTMP=SDIBC2
      ISDI(IKNT)=SDIBCTMP/GROSPC + 0.5
      IOSUM(07,IKNT)=ONTREM(7)/GROSPC+0.5
      IOSUM(08,IKNT)=OCVREM(7)/GROSPC+0.5
      IOSUM(09,IKNT)=OMCREM(7)/GROSPC+0.5
      IOSUM(10,IKNT)=OBFREM(7)/GROSPC+0.5
      IOSUM(14,IKNT)=IFINT
      IOSUM(15,IKNT)=OACC(7)/GROSPC+0.5
      IOSUM(16,IKNT)=OMORT(7)/GROSPC+0.5
      QSDBT(IKNT)=ORMSQD
      IOLDBA(IKNT)=OLDBA/GROSPC + 0.5
      IBTCCF(IKNT)=RELDM1/GROSPC+0.5
      IBTAVH(IKNT)=OLDAVH+0.5
      IF (SAMWT .GE. .99999) ISWT = IFIX(SAMWT+.0001)
      IF (SAMWT .LT. .99999) ISWT = IFIX(SAMWT*100000.+.5)
      IOSUM(17,IKNT)=ISWT
  100 CONTINUE
      IF (ICL6 .GT. 0) GO TO 150
C----------
C  PRINT THE EXAMPLE TREE RECORD AND STAND ATTRIBUTE TABLE.
C  IF NOT DESIRED THEN SKIP.
C----------
      IF (ITABLE(2) .EQ. 1) GO TO 125
C----------
C  WRITE AN END OF FILE MARK ON SUMMARY TREE SCRATCH FILE.
C----------
      ENDFILE JOTREE
      CALL PRTEXM (JOTREE,JOSTND,ITITLE)
  125 CONTINUE
C----------
C  PRINT THE SUMMARY OUTPUT
C----------
      DO 130 I=7,10
      IOSUM(I,IKNT)=0
  130 CONTINUE
      DO 140 I=14,16
      IOSUM(I,IKNT)=0
  140 CONTINUE
C----------
C  LOAD FINAL MAI VALUE
C----------
      IF(MAIFLG .EQ. 0)THEN
        IF(IOSUM(2,IKNT).GT.0.)THEN
          IF ((VVER(:2) .EQ. 'CS') .OR. (VVER(:2) .EQ. 'LS') .OR.
     1      (VVER(:2) .EQ. 'NE') .OR. (VVER(:2) .EQ. 'OZ') .OR.
     2      (VVER(:2) .EQ. 'SE') .OR. (VVER(:2) .EQ. 'SN')) THEN
            BCYMAI(IKNT)=(IOSUM(4,IKNT)+TOTREM)/IOSUM(2,IKNT)
          ELSE
            BCYMAI(IKNT)=(IOSUM(5,IKNT)+TOTREM)/IOSUM(2,IKNT)
          ENDIF
        ELSE
          BCYMAI(IKNT)=0.
        ENDIF
      ELSE
        BCYMAI(IKNT)=0.
      ENDIF
C----------
C     CALL **ECEND** TO OUTPUT LAST LINES OF ECONOMIC OUTPUT
C----------
      IF (LECON) CALL ECEND
      I=0
      IF (LSUMRY) I=JOSUM
C---------
C     SKIP PRINTING OF SUMMARY OUTPUT IF NOT DESIRED.
C---------
      J=JOSTND
      IF (ITABLE(3).EQ.1) J=0
      CALL GROHED (JOSTND)
      CALL LBSPLW (JOSTND)
      CALL SUMOUT (IOSUM,20,0,JOSTND,J,I,IKNT,MGMID,NPLT,SAMWT,
     &ITITLE,IPTINV)
      CALL OPLIST (.FALSE.,NPLT,MGMID,ITITLE)
C----------
C     CALL ECLBL TO OUTPUT ECONOMIC LABEL INFORMATION.
C----------
      IF (LECON) CALL ECLBL
  150 CONTINUE
      IF ((LSTART).AND.(LSCRN)) CALL SUMHED
      IF ((.NOT.LSTART).AND.(LSCRN))
     >    WRITE (JOSCRN,170) IOSUM(1,IKNT),IOSUM(3,IKNT),IOLDBA(IKNT),
     >    ISDI(IKNT),IBTAVH(IKNT),QSDBT(IKNT),IOSUM(4,IKNT),
     >    IOSUM(7,IKNT),IOSUM(8,IKNT),IOSUM(10,IKNT),IOSUM(11,IKNT),
     >    ISDIAT(IKNT),IOSUM(13,IKNT),QDBHAT(IKNT),
     >    IOSUM(15,IKNT),IOSUM(16,IKNT)
  170 FORMAT (1X,I4,I6,3I4,F5.1,4I6,3I4,F5.1,I4,I4)
      RETURN
      END
