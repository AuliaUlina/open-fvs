      SUBROUTINE ESPLT2 (IPTKNT)
      IMPLICIT NONE
C----------
C  **ESPLT2-STRP DATE OF LAST REVISION:   09/17/08
C----------
C
C     CALLED BY INITRE TO TRANSLATE PLOT SPECIFIC VARIABLES FOR ESTAB
C
COMMONS
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
      INCLUDE 'ESHAP.F77'
C
C
      INCLUDE 'ESHAP2.F77'
C
C
COMMONS
C
      LOGICAL DEBUG
C
C     WARNING: ESB1 AND SUMPRB ARE BOTH MEMBERS OF /ESHAP2/ ... THEY
C              ARE BEING USED TO PASS DATA FROM ESPLT1 TO ESPLT2.
C
      INTEGER IEND(33),MYGRUP(33),NEW(MAXPLT),NON(MAXPLT),NSID(MAXPLT)
      INTEGER IPTKNT,NSTK,I,NM,N,J,ME,J1,ITEMP
      REAL XXSLP,XXASP
      EQUIVALENCE (NEW,PROB1),(NON,PNN),(NSID,ESB1),(NSTK,SUMPRB)
      DATA IEND/269,299,319,335,385,394,399,499,509,515,519,522,
     &  523,524,529,564,579,584,589,599,634,637,644,649,659,669,689,
     &  699,709,719,739,744,799/, MYGRUP/3,1,4,2,4,3,4,3,8,6,8,7,
     &  5,7,8,9,10,6,8,5,13,16,11,14,16,12,15,12,14,15,11,15,14/
C
      CALL DBCHK (DEBUG,'ESPLT2',6,ICYC)
C
C     MAP THE STAND HABITAT CODE TO THE ESTABLISHMENT CODES.
C
      IHTYPE=ICL5
      DO 3 I=1,33
      IF(IHTYPE.GT.IEND(I)) GO TO 3
      IHTYPE=MYGRUP(I)
      GO TO 4
    3 CONTINUE
      IHTYPE=16
    4 CONTINUE
      XXSLP=ISLOP*0.01
      XXASP=IASPEC*0.0174533
      IF (DEBUG) WRITE (JOSTND,5) IPINFO,IPTKNT,IPTINV,NPTIDS,
     >                            NONSTK,IHTYPE,XXSLP,XXASP
    5 FORMAT (/'IN ESPLT2: IPINFO=',I3,' IPTKNT=',I4,' IPTINV=',I4,
     >     ' NPTIDS=',I4,' NONSTK=',I4,' IHTYPE=',I3,' XXSLP=',F5.2,
     >     ' XXASP=',F5.2)    
C
C     INITIALIZE THE NON MATCH COUNT TO 0.
C
      NM=0
C
C     IF THERE WERE TREEDATA RECORDS (THE POINT COUNT IS GT 0);
C     THEN: BRANCH TO NORMAL PROCESSING.
C
      IF (IPTKNT.GT.0) GOTO 20
C
C     LOAD PLOT ID VECTOR WITH POINTERS.
C
      IF (NPTIDS.LE.0 .OR. IREC1.EQ.0) THEN
         NPTIDS=IPTINV-NONSTK
         IF (NPTIDS.LE.0) NPTIDS=1
      ENDIF
      DO 10 I=1,NPTIDS
      IPTIDS(I)=I
   10 CONTINUE
C
C     IF THERE ARE PLOTINFO RECORDS OR TREE RECORDS, THEN:
C     BRANCH TO DECODE.
C
      IF (IPINFO.NE.0) GOTO 110
C
C     ELSE:  BRANCH TO LOAD STAND VALUES.
C
      NM=1
      GOTO 150
   20 CONTINUE
C
C     IF PLOTINFO OPTION WAS USED (IPINFO=1), MATCH PLOT IDENTIFICATION
C     CODES WITH THOSE IN THE TREE FILE.  KEEP STOCKABLE PLOTS ONLY.
C
      IF (IPINFO.NE.1) GOTO 80
C
C     INITIALIZE PLOTINFO COUNT.
C
      N=NPTIDS
      NPTIDS=0
C
C     DO FOR ALL TREEDATA PLOTS.
C
      DO 50 J=1,IPTKNT
      ME=IPVEC(J)
C
C     DO FOR ALL PLOTINFO PLOTS.
C
      DO 30 I=1,N
      IF (ME.EQ.IPTIDS(I)) GOTO 40
   30 CONTINUE
C
C     THERE IS NO MATCH (NO PLOTINFO RECORD MATCHES THE TREEDATA PLOT
C     ID); THEN:IF THE PLOT IS STOCKABLE, INCREMENT THE NON-MATCH
C     COUNTER AND SAVE THE POINT INDENTIFICATION.
C
      IF (NSTK.EQ.0) GOTO 38
      DO 35 J1=1,NSTK
      IF (ME.EQ.NSID(J1)) GOTO 50
   35 CONTINUE
   38 CONTINUE
      NM=NM+1
      NON(NM)=J
      GOTO 50
   40 CONTINUE
C
C     THERE IS A MATCH. IF THE PLOT IS NONSTOCKABLE, SKIP IT.
C
      IF (IPPREP(J).EQ.-1) GOTO 50
      NPTIDS=NPTIDS+1
      NEW(NPTIDS)=J
   50 CONTINUE
C
C     IF THERE WERE SOME MATCHES, THEN: BRANCH TO PROCESS MATCHED PLOTS.
C
      IF (NPTIDS.GT.0) GOTO 60
C
C     IF THERE WERE NO STOCKABLE PLOTS, BRANCH TO SET FLAG.
C
      IF (NM.LE.0) THEN
         IPINFO=4
         GOTO 140
      ENDIF
C
C     ELSE: SAVE THE NON-MATCH CODES AND BRANCH TO SET STAND SITE
C     VALUES FOR THE PLOTS.
C
      DO 55 J=1,NM
      IPTIDS(J)=NON(J)
   55 CONTINUE
      IPINFO=5
      NPTIDS=NM
      NM=1
      GOTO 150
   60 CONTINUE
C
C     COPY MATCHED PLOT IDS TO IPTIDS.
C
      DO 70 I=1,NPTIDS
      IPTIDS(I)=NEW(I)
   70 CONTINUE
C
C     BRANCH TO DECODE SITE VARIABLES.
C
      GOTO 110
   80 CONTINUE
C
C     PLOTINFO WAS NOT USED. PROCESS IPTIDS TO ELIMINATE NONSTOCKABLE
C     PLOTS.  SITE PREP CODE IS -1 FOR THESE PLOTS.
C
      N=NPTIDS
      NPTIDS=0
      DO I=1,N
         IF (IPPREP(I).GE.0) THEN
            NPTIDS=NPTIDS+1
            IPTIDS(NPTIDS)=I
         ENDIF
      ENDDO
C
C     IF THERE WERE MORE PLOTS SAID TO EXIST (IPTINV-NONSTK IS GT 
C     THE NUMBER OF PLOTS FOUND IN THE TREEDATA), THEN MAKE MORE 
C     PLOTS AND SET THE ATTRIBUTES TO THE STAND-LEVEL VALUES.
C
      IF (IPTINV-NONSTK-N.GT.0) THEN
         DO I=1,IPTINV-NONSTK-N
            NPTIDS=NPTIDS+1
            IPTIDS(NPTIDS)=NPTIDS
            PSLO(NPTIDS)=-1.
            PASP(NPTIDS)=-1.
            IPHAB(NPTIDS)=ICL5
            IPPREP(NPTIDS)=1
            IPHYS(NPTIDS)=3
         ENDDO
      ENDIF
C     
C     IF ALL ARE NONSTOCKABLE, SET IPINFO=4 AND SET UP ONE PLOT USING
C     STAND SITE VALUES.
C
      IF (NPTIDS.LE.0) THEN
         IPINFO=4
         GOTO 140
      ENDIF
C
C     IF PLOT SITE DATA READ FROM TREE RECORDS, BRANCH TO DECODE VALUES.
C
      IF (IPINFO.EQ.2) GOTO 110
C
C     ELSE: BRANCH TO STAND VALUES.
C
      NM=1
      GOTO 150
  110 CONTINUE
C
C     DECODE THE PLOT SPECIFIC VARIABLES.
C
      DO 130 N=1,NPTIDS
      I=IPTIDS(N)
      IF (PSLO(I).LT.0.0) THEN
        PSLO(I)=XXSLP
      ELSE
        PSLO(I)=PSLO(I)*0.01
      ENDIF
      IF (IPHYS(I).LT.1 .OR. IPHYS(I).GT.5) IPHYS(I)=3
      IF (PASP(I).LT.0.0) THEN
        PASP(I)=XXASP
      ELSE
        PASP(I)=PASP(I)*0.0174533
      ENDIF
      IF (IPPREP(I).LT. 1 .OR. IPPREP(I).GT.4) IPPREP(I)=1
      IF(IPHAB(I).EQ.0)IPHAB(I)=ICL5
      ITEMP=IPHAB(I)
      DO 122 J=1,33
      IF(ITEMP.GT.IEND(J)) GO TO 122
      ITEMP=MYGRUP(J)
      GO TO 124
  122 CONTINUE
      ITEMP=16
  124 CONTINUE
      IPHAB(I)=ITEMP
  130 CONTINUE
C
C     IF THERE WERE SOME ADDITIONAL PLOTS FROM THE TREEDATA WHICH WERE
C     STOCKABLE BUT DID NOT HAVE PLOTINFO, ADD THEM TO THE LIST AND
C     BRANCH TO SET STAND SITE VALUES.
C
      IF (NM.EQ.0) GOTO 170
      DO 135 J=1,NM
      IPTIDS(NPTIDS+J)=NON(J)
  135 CONTINUE
      IPINFO=3
      NPTIDS=NPTIDS+NM
      NM=NPTIDS-NM+1
      GOTO 150
  140 CONTINUE
      IPTIDS(1)=1
      NPTIDS=1
      NM=1
  150 CONTINUE
C
C     SET STAND VALUES.
C
      DO 160 N=NM,NPTIDS
      I=IPTIDS(N)
      PSLO(I)=XXSLP
      PASP(I)=XXASP
      IPHAB(I)=IHTYPE
      IPPREP(I)=1
      IPHYS(I)=3
  160 CONTINUE
  170 CONTINUE
C
C     SIGNAL THAT SITE PREPS ARE READ FROM INPUT RECORDS.
C
      IF (IPINFO.GT.0 .AND. IPINFO.NE.5) LOAD=1
      IF (IPINFO.EQ.5) IPINFO=3
      IF (DEBUG) THEN
         WRITE (JOSTND,180) IPINFO,NPTIDS
  180    FORMAT (/'IN ESPLT2:  PLOT SITE DATA CODE=',I3,
     &     '; 0=NO DATA,1=PLOTINFO,2=TREEDATA,3=MISSMATCHED IDS,4=ALL',
     &     ' PLOTS NONSTOCKABLE.'/'PLOT SPECIFIC ATTRIBUTES FOR',I4,
     &     ' PLOTS',/,'    I IPTIDS IPPREP IPHYS IPHAB PASP   PSLO')
         DO 200 I=1,NPTIDS
         N=IPTIDS(I)
         WRITE (JOSTND,190) I,IPTIDS(I),IPPREP(N),IPHYS(N),IPHAB(N),
     &                      PASP(N),PSLO(N)
  190    FORMAT (I5,4I6,2F7.2)
  200    CONTINUE
      ENDIF
      RETURN
      END
