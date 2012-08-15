      SUBROUTINE CRATET
      IMPLICIT NONE
C----------
C  **CRATET--EC   DATE OF LAST REVISION:  05/09/12
C----------
C  THIS SUBROUTINE IS CALLED PRIOR TO PROJECTION.  IT HAS THE
C  FOLLOWING FUNCTIONS:
C
C    1)  CALL **RCON** TO LOAD SITE DEPENDENT MODEL COEFFICIENTS.
C    2)  REGRESSION TO ESTIMATE COEFFICIENTS OF LOCAL HEIGHT-
C        DIAMETER RELATIONSHIP.
C    3)  DUB IN MISSING HEIGHTS.
C    4)  CALL **DENSE** TO COMPUTE STAND DENSITY.
C    5)  SCALE CROWN RATIOS AND CALL **CROWN** TO DUB IN ANY MISSING
C        VALUES.
C    6)  DEFINE DG BASED ON CALIBRATION CONTROL PARAMETERS AND
C        CALL **DGDRIV** TO CALIBRATE DIAMETER GROWTH EQUATIONS.
C    7)  DELETE DEAD TREES FROM INPUT TREE LIST AND REALIGN IND1
C        AND ISCT.
C    8)  PRINT A TABLE DESCRIBING CONTROL PARAMETERS AND INPUT
C        VARIABLES.
C----------
C
COMMONS
C
C
      INCLUDE 'PRGPRM.F77'
C
C
      INCLUDE 'ARRAYS.F77'
C
C
      INCLUDE 'PLOT.F77'
C
C
      INCLUDE 'COEFFS.F77'
C
C
      INCLUDE 'CONTRL.F77'
C
C
      INCLUDE 'OUTCOM.F77'
C
C
      INCLUDE 'HTCAL.F77'
C
C
      INCLUDE 'VARCOM.F77'
C
C
COMMONS
C
C----------
C  INTERNAL VARIABLES.
C
C      KNT2 -- USED TO STORE COUNTS FOR PRINTING IN CONTROL
C              SUMMARY TABLE.
C     SPCNT -- USED TO ACCUMULATE NUMBER OF TREES PER ACRE BY
C              SPECIES AND TREE CLASS FOR CALCULATION OF
C              INITIAL SPECIES-TREE CLASS COMPOSITION VECTOR.
C----------
      LOGICAL DEBUG,MISSCR,TKILL
      CHARACTER*4 UNDER
      INTEGER I,I1,I2,I3,II,IICR,IM,IPTR,IS,ISPC
      INTEGER J,JCR,JJ
      INTEGER K1,K2,K3,K4,KNT2(MAXSP),KNT(MAXSP)
      INTEGER NH
      REAL AGMAX,AX,BKPT,BX,D,D1,D2,H,HS,HTMAX,HTMAX2
      REAL Q,SITAGE,SITHT,SPCNT(MAXSP,3),SUMX,XN,XX,YY
C----------
C  SPECIES LIST FOR EAST CASCADES VARIANT.
C
C   1 = WESTERN WHITE PINE      (WP)    PINUS MONTICOLA
C   2 = WESTERN LARCH           (WL)    LARIX OCCIDENTALIS
C   3 = DOUGLAS-FIR             (DF)    PSEUDOTSUGA MENZIESII
C   4 = PACIFIC SILVER FIR      (SF)    ABIES AMABILIS
C   5 = WESTERN REDCEDAR        (RC)    THUJA PLICATA
C   6 = GRAND FIR               (GF)    ABIES GRANDIS
C   7 = LODGEPOLE PINE          (LP)    PINUS CONTORTA
C   8 = ENGELMANN SPRUCE        (ES)    PICEA ENGELMANNII
C   9 = SUBALPINE FIR           (AF)    ABIES LASIOCARPA
C  10 = PONDEROSA PINE          (PP)    PINUS PONDEROSA
C  11 = WESTERN HEMLOCK         (WH)    TSUGA HETEROPHYLLA
C  12 = MOUNTAIN HEMLOCK        (MH)    TSUGA MERTENSIANA
C  13 = PACIFIC YEW             (PY)    TAXUS BREVIFOLIA
C  14 = WHITEBARK PINE          (WB)    PINUS ALBICAULIS
C  15 = NOBLE FIR               (NF)    ABIES PROCERA
C  16 = WHITE FIR               (WF)    ABIES CONCOLOR
C  17 = SUBALPINE LARCH         (LL)    LARIX LYALLII
C  18 = ALASKA CEDAR            (YC)    CALLITROPSIS NOOTKATENSIS
C  19 = WESTERN JUNIPER         (WJ)    JUNIPERUS OCCIDENTALIS
C  20 = BIGLEAF MAPLE           (BM)    ACER MACROPHYLLUM
C  21 = VINE MAPLE              (VN)    ACER CIRCINATUM
C  22 = RED ALDER               (RA)    ALNUS RUBRA
C  23 = PAPER BIRCH             (PB)    BETULA PAPYRIFERA
C  24 = GIANT CHINQUAPIN        (GC)    CHRYSOLEPIS CHRYSOPHYLLA
C  25 = PACIFIC DOGWOOD         (DG)    CORNUS NUTTALLII
C  26 = QUAKING ASPEN           (AS)    POPULUS TREMULOIDES
C  27 = BLACK COTTONWOOD        (CW)    POPULUS BALSAMIFERA var. TRICHOCARPA
C  28 = OREGON WHITE OAK        (WO)    QUERCUS GARRYANA
C  29 = CHERRY AND PLUM SPECIES (PL)    PRUNUS sp.
C  30 = WILLOW SPECIES          (WI)    SALIX sp.
C  31 = OTHER SOFTWOODS         (OS)
C  32 = OTHER HARDWOODS         (OH)
C
C  SURROGATE EQUATION ASSIGNMENT:
C
C  FROM THE EC VARIANT:
C      USE 6(GF) FOR 16(WF)
C      USE OLD 11(OT) FOR NEW 12(MH) AND 31(OS)
C
C  FROM THE WC VARIANT:
C      USE 19(WH) FOR 11(WH)
C      USE 33(PY) FOR 13(PY)
C      USE 31(WB) FOR 14(WB)
C      USE  7(NF) FOR 15(NF)
C      USE 30(LL) FOR 17(LL)
C      USE  8(YC) FOR 18(YC)
C      USE 29(WJ) FOR 19(WJ)
C      USE 21(BM) FOR 20(BM) AND 21(VN)
C      USE 22(RA) FOR 22(RA)
C      USE 24(PB) FOR 23(PB)
C      USE 25(GC) FOR 24(GC)
C      USE 34(DG) FOR 25(DG)
C      USE 26(AS) FOR 26(AS) AND 32(OH)
C      USE 27(CW) FOR 27(CW)
C      USE 28(WO) FOR 28(WO)
C      USE 36(CH) FOR 29(PL)
C      USE 37(WI) FOR 30(WI)
C----------
C  INITIALIZE INTERNAL VARIABLES:
C----------
      DATA UNDER/'----'/
C-----------
C  SEE IF WE NEED TO DO SOME DEBUG.
C-----------
      CALL DBCHK (DEBUG,'CRATET',6,ICYC)
C-------
C  IF THERE ARE TREE RECORDS, BRANCH TO PREFORM CALIBRATION.
C-------
      AX=0.
      IF (ITRN.GT.0) GOTO 1
C----------
C   CALL MAICAL TO CALCULATE MAI
C----------
      CALL MAICAL
      CALL RCON
      ONTREM(7)=0.
      CALL DENSE
      CALL DGDRIV
      CALL REGENT(.FALSE.,1)
    1 CONTINUE
      DO 5 I=1,MAXSP
      SPCNT(I,1)=0.0
      SPCNT(I,2)=0.0
      SPCNT(I,3)=0.0
      IF (ISCT(I,1).EQ.0) GOTO 5
      J=IREF(I)
      IUSED(J)=NSP(I,1)
    5 CONTINUE
      IF((ITRN.LE.0).AND.(IREC2.GE.MAXTP1))GO TO 245
C----------
C  PRINT SPECIES LABELS AND NUMBER OF OBSERVATIONS IN CONTROL
C  TABLE.  THEN, RESET COUNTERS TO ZERO.
C----------
      WRITE(JOSTND,'(//'' CALIBRATION STATISTICS:''//)')
      WRITE(JOSTND,9000) (IUSED(I), I=1,NUMSP)
 9000 FORMAT ((T50,11(1X,A2,3X)/))
      IF(NUMSP .LE. 11) THEN
        WRITE(JOSTND,9001) (UNDER, I=1,NUMSP)
      ELSE
        WRITE(JOSTND,9001) (UNDER, I=1,11)
      ENDIF
 9001 FORMAT (T50,11(A4,2X))
      WRITE(JOSTND,9002) (KOUNT(I), I=1,NUMSP)
 9002 FORMAT(/,' NUMBER OF RECORDS PER SPECIES',
     &        ((T50,11(I4,2X)/)))
      DO 10 I=1,MAXSP
      KNT(I)=0
      KNT2(I)=0
   10 CONTINUE
C----------
C   CALL MBACAL TO IDENTIFY SITE SPECIES
C----------
      CALL MBACAL
C----------
C   CALL MAICAL TO CALCULATE MAI
C----------
      CALL MAICAL
C----------
C  CALL **RCON** TO INITIALIZE SITE DEPENDENT MODEL COEFFICIENTS.
C----------
      CALL RCON
C----------
C  CALL **RDPSRT** AND **DENSE** TO COMPUTE INITIAL STAND DENSITY
C  STATISTICS.  ONTREM(7) IS SET TO ZERO HERE TO ASSURE THAT RELDM1
C  WILL BE ASSIGNED IN **DENSE** IN THE FIRST CYCLE.
C----------
      DO 15 I=1,ITRN
      IND(I)=IND1(I)
   15 CONTINUE
      CALL RDPSRT(ITRN,DBH,IND,.FALSE.)
      ONTREM(7)=0.0
C----------
C  PREPARE INPUT DATA FOR DIAMETER GROWTH MODEL CALIBRATION.  IF
C  IDG IS 1, CONVERT THE PAST DIAMETER MEASUREMENT CARRIED IN DG TO
C  DIAMETER GROWTH.  IF IDG IS 3, CONVERT THE CURRENT DIAMETER
C  MEASUREMENT CARRIED IN DG TO DIAMETER GROWTH.  ACTUAL DIAMETER
C  INCREMENT MEASUREMENTS WILL BE CORRECTED FOR BARK GROWTH IN
C  THE CALIBRATION ROUTINE. (THIS CODE WAS MOVED HERE SO THAT THE
C  BACKDATING ALGORITHM IN **DENSE**, INVOKED DURING CALIBRATION,
C  IS CORRECT.)
C----------
      Q=1.0
      IF(IDG.EQ.3) Q=-1.0
      DO 230 II=1,ITRN
      I=IND1(II)
      IF(I.GE.IREC2) GO TO 230
      IF(DG(I).LE.0.0) GO TO 220
      IF(IDG.EQ.0.OR.IDG.EQ.2) GO TO 230
      DG(I)=Q*(DBH(I)-DG(I))
      GO TO 230
  220 CONTINUE
      DG(I)=-1.0
  230 CONTINUE
C---------
C  SET LBKDEN TRUE IF DIAMETERS ARE TO BE BACKDATED FOR DENSITY
C  CALCULATIONS.  AFTER THIS CALL TO DENSE, INSURE LBKDEN=FALSE.
C---------
      LBKDEN= IDG.LT.2
      CALL DENSE
      LBKDEN= .FALSE.
C----------
C  DELETE NON-PROJECTABLE RECORDS, AND REALIGN POINTERS TO THE
C  SPECIES ORDERED SORT.
C----------
      IF(IREC2.EQ.MAXTP1) GO TO 60
      DO 50 I=IREC2,MAXTRE
      ISPC=ISP(I)
      IPTR=IREF(ISPC)
      IF(IMC(I).EQ.7)KNT(IPTR)=KNT(IPTR)+1
      IF (DEBUG) WRITE(JOSTND,9003) I,IMC(I),ISPC
 9003 FORMAT(' IN CRATET: DEAD TREE RECORD:  I=',I4,',  IMC=',I2,
     &       ',  SPECIES=',I2,' (9003 CRATET)')
      IF(ITRN.GT.0)THEN
        I1=ISCT(ISPC,1)
        I2=ISCT(ISPC,2)
        DO 30 I3=I1,I2
        IF(IND1(I3).EQ.I) GO TO 40
   30   CONTINUE
   40   IND1(I3)=IND1(I2)
        ISCT(ISPC,2)=I2-1
        IF(ISCT(ISPC,2).GE.ISCT(ISPC,1)) GO TO 50
        ISCT(ISPC,1)=0
        ISCT(ISPC,2)=0
      ENDIF
   50 CONTINUE
C----------
C  WRITE CALIBRATION TABLE ENTRY FOR NON-PROJECTABLE RECORDS AND RESET
C  KNT ARRAY TO ZERO.
C----------
      WRITE(JOSTND,9004) (KNT(I),I=1,NUMSP)
 9004 FORMAT(/,' NUMBER OF RECORDS CODED AS RECENT MORTALITY',
     &        ((T50,11(I4,2X)/)))
C---------
C  RESET TREE RECORD COUNTERS AND SAVE THE NUMBER OF SPECIES.
C----------
      ITRN=IREC1
      IF((ITRN.LE.0).AND.(IREC2.GE.MAXTP1))GOTO 245
      IF(ITRN.LE.0)GOTO 60
      ISPC=NUMSP
C---------
C  MAKE SURE THAT ALL THE SPECIES ORDER SORTS AND THE IND2 ARRAY
C  ARE IN THE PROPER ORDER. FIRST, SAVE THE SPECIES REFERENCES.
C---------
      DO 51 I=1,MAXSP
      KNT(I)=IREF(I)
   51 CONTINUE
      CALL SPESRT
C---------
C  IF THE NUMBER OF SPECIES HAS CHANGED, WE MUST REWRITE THE
C  COLUMN HEADINGS.
C---------
      IF (ISPC.NE.NUMSP) THEN
         WRITE(JOSTND,52)
   52    FORMAT (/' ***** NOTE:  SPECIES HAVE BEEN DROPPED.')
         DO 55 I=1,MAXSP
         IF (ISCT(I,1).EQ.0) GOTO 55
         J=IREF(I)
         IUSED(J)=NSP(I,1)
   55    CONTINUE
         WRITE(JOSTND,9000) (IUSED(I), I=1, NUMSP)
         WRITE(JOSTND,9001) (UNDER, I=1, NUMSP)
      ELSE
C
C        RESET THE REFERENCES.
C
         DO 57 I=1,MAXSP
         IREF(I)=KNT(I)
   57    CONTINUE
      ENDIF
C----------
C  SORT REMAINING TREE RECORDS IN ORDER OF DESCENDING DIAMETER.
C  STORE POINTERS TO SORTED ORDER IN IND.
C----------
      CALL RDPSRT(ITRN,DBH,IND,.TRUE.)
   60 CONTINUE
      DO 65 I=1,MAXSP
      KNT(I)=0
   65 CONTINUE
C----------
C  ENTER LOOP TO ADJUST HEIGHT-DBH MODEL FOR LOCAL CONDITIONS.  IF
C  THERE ARE 3 OR MORE TREES WITH MEASURED HEIGHTS FOR A GIVEN
C  SPECIES, ADJUST THE INTERCEPT (ASYMPTOTE) IN THE MODEL SO THAT
C  THE MEAN RESIDUAL FOR THE MEASURED TREES IS ZERO.
C  IF LHTDRG IS FALSE FOR A GIVEN SPECIES THEN ALL DUBBING IS DONE WITH
C  DEFAULT VALUES.
C----------
      DO 150 ISPC=1,MAXSP
      AA(ISPC)=0.
      BB(ISPC)=0.
      I1=ISCT(ISPC,1)
      IF(I1.LE.0) GO TO 141
      I2=ISCT(ISPC,2)
      IPTR=IREF(ISPC)
C----------
C  INITIALIZE SUMS FOR THIS SPECIES.
C----------
      K1=0
      K2=0
      K3=0
      K4=0
      SUMX=0.0
C
      SELECT CASE (ISPC)
C
C  SPECIES USING WC EQUATIONS/LOGIC
C
      CASE(11,13:15,17:30,32)
        BKPT = 5.0
C
C  SPECIES USING EC EQUATIONS/LOGIC
C
      CASE DEFAULT
        BKPT = 3.0
C
      END SELECT
C----------
C  ENTER TREE LOOP WITHIN SPECIES.
C----------
      DO 80 I3=I1,I2
      I=IND1(I3)
      H=HT(I)
      NH=NORMHT(I)
      D=DBH(I)
      BX=HT2(ISPC)
C----------
C  BYPASS SUMS FOR TREES WITH MISSING HEIGHT OR TRUNCATED TOPS.
C
C  FOR SPECIES USING EQUATIONS/LOGIC FROM THE WC VARIANT:
C  SEPERATE EQUATIONS ARE USED FOR TREES 5" AND LARGER VS TREES
C  LESS THAN 5" DBH. CALIBRATION OF THE HT-DBH RELATIONSHIP IS
C  ONLY DONE ON THE EQUATION USED FOR TREES 5" AND LARGER.
C----------
      IF(H.LE.4.5 .OR. NH.LT.0 .OR. D.LT.BKPT) GO TO 70
      K1=K1+1
      XX = BX / (D + 1.)
      YY = ALOG(H - 4.5)
      SUMX= SUMX + YY - XX
      GO TO 80
C----------
C  COUNT NUMBER OF MISSING HEIGHTS AND BROKEN OR DEAD TOPS.  LOAD THE
C  ARRAY IND2 WITH SUBSCRIPTS TO THE RECORDS WITH MISSING HEIGHTS.
C----------
   70 CONTINUE
      IF(NH.LT.0) K3=K3+1
      IF(H.GT.0.0 .AND. NH.EQ.0) GO TO 80
      K2=K2+1
      IND2(K2)=I
C----------
C  END OF SUMMATION LOOP FOR THIS SPECIES.
C----------
C*** ONE LINE FIX FOR GROWTH METHOD 1 PROBLEM. DIXON 11-16-90
      IF(HT(I) .LE. 0.1) HTG(I)=0.0
   80 CONTINUE
C----------
C  IF THERE ARE LESS THAN THREE OBSERVATIONS OR LHTDRG IS FALSE
C  THEN DUB HEIGHTS USING DEFAULT COEFFICIENTS FOR THIS SPECIES.
C----------
      KNT(IPTR)=K3
      IF(K1.LT.3 .OR. .NOT.LHTDRG(ISPC)) GO TO 100
      XN=FLOAT(K1)
      AA(ISPC) = SUMX/XN
C----------
C  IF THE INTERCEPT IS NEGATIVE, USE DEFAULT VALUES.
C----------
      IF(AA(ISPC).GE.0.0) THEN
        IABFLG(ISPC)=0
      ENDIF
C----------
C  DUB IN MISSING HEIGHTS.
C  A VALUE LESS THAN ZERO STORED IN 'HT' => THAT TREE WAS TOP KILLED.
C  CONSEQUENTLY, A VALUE OF 80% OF THE PREDICTED HEIGHT IS STORED AS
C  THE TRUNCATED HEIGHT.
C----------
  100 CONTINUE
      AX=HT1(ISPC)
      BX=HT2(ISPC)
      IF(IABFLG(ISPC) .EQ. 0) AX=AA(ISPC)
      IF(K2.EQ.0) GO TO 140
      DO 130 JJ=1,K2
      II=IND2(JJ)
      JCR=((ICR(II)-1)/10)+1
      D=DBH(II)
      TKILL = NORMHT(II) .LT. 0.
C
      IF(D .LE. 0.1)THEN
        H=1.01
        GO TO 115
      ENDIF
C
      SELECT CASE (ISPC)
C
C  SPECIES USING EC EQUATIONS/LOGIC
C
      CASE(1:10,12,16,31)
        H=EXP(AX+BX/(D+1.0))+4.5
C
C  SPECIES USING WC EQUATIONS/LOGIC
C
      CASE(11,13:15,17:30,32)
        IF(D .LT. 5.0) THEN
          IICR=ICR(II)
          IF(IICR.LE.0)IICR=40
          H = HTT1(ISPC,1) + HTT1(ISPC,2)*D
     &      + HTT1(ISPC,3)*FLOAT(IICR) + HTT1(ISPC,4)*D*D
     &      + HTT1(ISPC,5)
          SELECT CASE (ISPC)
          CASE(11,13:15,17:18)
            H = EXP(H)
          END SELECT
        ELSE
          H=EXP(AX+BX/(D+1.0))+4.5
        ENDIF
C
      END SELECT
      IF (DEBUG) WRITE(JOSTND,88) AX,BX,D,H
  88  FORMAT(' CRATET DUBBED HEIGHT: AX,BX,D,H=',4F8.2)
C
C SMALL PP USE A DIFFERENT LOGIC. RJ 7-26-88
C
      IF(ISPC.EQ.10 .AND. D.LT.3.0) THEN
      IF(ICR(II).LE.0)THEN
        JCR=4
      ELSE
        JCR=((ICR(II)-1)/10)+1
        IF(JCR.GT.7)JCR=7
        IF(JCR.LE.0)JCR=4
      ENDIF
        H = 8.31485 + 3.03659*D - 0.59200*JCR
      ENDIF
C----------
C  USE INVENTORY EQUATIONS IF CALIBRATION OF THE HT-DBH FUNCTION IS TURNED
C  OFF, OR IF WYKOFF CALIBRATION DID NOT OCCUR.
C  NOTE: THIS SIMPLIFIES TO IF(IABFLB(ISPC).EQ.1) BUT IS SHOWN IN IT'S
C        ENTIRITY FOR CLARITY.
C----------
      IF(.NOT.LHTDRG(ISPC) .OR. 
     &   (LHTDRG(ISPC) .AND. IABFLG(ISPC).EQ.1))THEN
        CALL HTDBH(IFOR,ISPC,D,H,0)
        IF(DEBUG)WRITE(JOSTND,*)' INVENTORY EQN DUBBING IFOR,ISPC,D,H= '
     &  ,IFOR,ISPC,D,H
      ENDIF
C
      IF(H .LT. 4.5) H=4.5
  115 CONTINUE
      IF(TKILL) GO TO 120
      HT(II)=H
      K4=K4+1
      GO TO 125
  120 CONTINUE
      NORMHT(II)=H*100.0+0.5
      IF(ITRUNC(II).EQ.0) THEN
         IF(HT(II).GT.0.0) THEN
            ITRUNC(II)=80.0*HT(II)+0.5
         ELSE
            ITRUNC(II)=80.0*H+0.5
            HT(II)=H
         ENDIF
      ELSE
         IF(HT(II).GT.0.0) THEN
            IF(HT(II).LT.(ITRUNC(II)*0.01)) HT(II)=ITRUNC(II)*0.01
         ELSE
            HT(II)=ITRUNC(II)*0.01
         ENDIF
      ENDIF
      IF(NORMHT(II)*0.01.LT.HT(II)) NORMHT(II)=HT(II)*100.0
  125 CONTINUE
  130 CONTINUE
      KNT2(IPTR)=K4
C----------
C  END OF SPECIES LOOP.  PRINT HEIGHT-DIAMETER COEFFICIENTS ON
C  DEBUG UNIT IF DESIRED.
C----------
  140 CONTINUE
      IF(DEBUG)THEN
      WRITE(JOSTND,9005) ISPC,AX,BX,IABFLG(ISPC)
 9005 FORMAT(' HEIGHT-DIAMETER COEFFICIENTS FOR SPECIES ',I2,
     &      ':  INTERCEPT=',F10.6,'  SLOPE=',F10.6,'  IABFLG(ISPC)=',I4,
     & ' (9005 CRATET)')
      ENDIF
C----------
C  LOOP THROUGH DEAD TREES AND DUB MISSING HEIGHTS FOR THIS SPECIES.
C----------
  141 CONTINUE
      IF(IREC2 .GT. MAXTRE) GO TO 150
      DO 145 II=IREC2,MAXTRE
      IF(ISP(II).NE.ISPC) GO TO 145
      AX=HT1(ISPC)
      BX=HT2(ISPC)
      IF(IABFLG(ISPC) .EQ. 0) AX=AA(ISPC)
      JCR=((ICR(II)-1)/10)+1
      D=DBH(II)
      TKILL = NORMHT(II) .LT. 0.
      IF(HT(II).GT.0. .AND. TKILL) GO TO 142
      IF(HT(II).GT.0.) GO TO 146
C
      IF(D .LE. 0.1)THEN
        H=1.01
        GO TO 144
      ENDIF
C
      SELECT CASE (ISPC)
C
C  SPECIES USING EC EQUATIONS/LOGIC
C
      CASE(1:10,12,16,31)
        H=EXP(AX+BX/(D+1.0))+4.5
C
C  SPECIES USING WC EQUATIONS/LOGIC
C
      CASE(11,13:15,17:30,32)
        IF(D .LT. 5.0) THEN
          IICR=ICR(II)
          IF(IICR.LE.0)IICR=40
          H = HTT1(ISPC,1) + HTT1(ISPC,2)*D
     &      + HTT1(ISPC,3)*FLOAT(IICR) + HTT1(ISPC,4)*D*D
     &      + HTT1(ISPC,5)
          SELECT CASE (ISPC)
          CASE(11,13:15,17:18)
            H = EXP(H)
          END SELECT
        ELSE
          H=EXP(AX+BX/(D+1.0))+4.5
        ENDIF
C
      END SELECT
C
C SMALL PP USE A DIFFERENT LOGIC. RJ 7-26-88
C
      IF(ISPC.EQ.10 .AND. D.LT.3.0) THEN
      IF(ICR(II).LE.0)THEN
        JCR=4
      ELSE
        JCR=((ICR(II)-1)/10)+1
        IF(JCR.GT.7)JCR=7
        IF(JCR.LE.0)JCR=4
      ENDIF
      H = 8.31485 + 3.03659*D - 0.59200*JCR
      ENDIF
C----------
C  USE INVENTORY EQUATIONS IF CALIBRATION OF THE HT-DBH FUNCTION IS TURNED
C  OFF, OR IF WYKOFF CALIBRATION DID NOT OCCUR.
C  NOTE: THIS SIMPLIFIES TO IF(IABFLB(ISPC).EQ.1) BUT IS SHOWN IN IT'S
C        ENTIRITY FOR CLARITY.
C----------
      IF(.NOT.LHTDRG(ISPC) .OR. 
     &   (LHTDRG(ISPC) .AND. IABFLG(ISPC).EQ.1))THEN
        CALL HTDBH(IFOR,ISPC,D,H,0)
        IF(DEBUG)WRITE(JOSTND,*)' INVENTORY EQN DUBBING IFOR,ISPC,D,H= '
     &  ,IFOR,ISPC,D,H
      ENDIF
C
      IF(H .LT. 4.5) H=4.5
  144 CONTINUE
      IF(TKILL) GO TO 142
      HT(II)=H
      GO TO 146
  142 CONTINUE
      IF(HT(II) .GT. 0.) THEN
        NORMHT(II)=HT(II)*100.0+0.5
      ELSE
        NORMHT(II)=H*100.0+0.5
      ENDIF
      IF(ITRUNC(II).EQ.0) THEN
         IF(HT(II).GT.0.0) THEN
            ITRUNC(II)=80.0*HT(II)+0.5
         ELSE
            ITRUNC(II)=80.0*H+0.5
            HT(II)=H
         ENDIF
      ELSE
         IF(HT(II).GT.0.0) THEN
            IF(HT(II).LT.(ITRUNC(II)*0.01)) HT(II)=ITRUNC(II)*0.01
         ELSE
            HT(II)=ITRUNC(II)*0.01
         ENDIF
      ENDIF
      IF(NORMHT(II)*0.01.LT.HT(II)) NORMHT(II)=HT(II)*100.0
C----------
C   CALL FIRE SNAG MODEL TO ADD THE DEAD TREES TO THE
C   SNAG LIST; DEFLATE PROB(II), WHICH WAS TEMPORARILY
C   ADJUSTED TO ALLOW BACKDATING FOR CALIBRATION PURPOSES,
C   IN **NOTRE**
C----------
  146 CONTINUE
      IF (TKILL) THEN
        HS = ITRUNC(II) * 0.01
      ELSE
        HS = HT(II)
      ENDIF
      CALL FMSSEE (II,ISPC,D,HS,
     >  (PROB(II)/(FINT/FINTM)),3,.FALSE.,JOSTND)
C
  145 CONTINUE
C----------
  150 CONTINUE
C----------
C  END OF HEIGHT DUBBING SEGMENT.  PRINT CONTROL TABLE ENTRIES FOR
C  USEABLE HEIGHTS AND MISSING HEIGHTS, AND REINITIALIZE COUNTERS.
C----------
      WRITE(JOSTND,9006) (KNT2(I),I=1,NUMSP)
 9006 FORMAT(/,' NUMBER OF RECORDS WITH MISSING HEIGHTS',
     &       T50,11(I4,2X))
      WRITE(JOSTND,9007) (KNT(I),I=1,NUMSP)
 9007 FORMAT(/,' NUMBER OF RECORDS WITH BROKEN OR DEAD TOPS',
     &       T50,11(I4,2X))
      DO 160 I=1,MAXSP
      KNT(I)=0
      KNT2(I)=0
  160 CONTINUE
C----------
C  CHECK FOR MISSING CROWNS ON LIVE TREES.
C  SAVE PCT IN OLDPCT TO RETAIN AN OLD PCTILE VALUE.
C----------
      MISSCR = .FALSE.
      DO 190 I=1,ITRN
      OLDPCT(I)= PCT(I)
      IF(ICR(I).LE.0)THEN
        MISSCR = .TRUE.
        ISPC=ISP(I)
        IPTR=IREF(ISPC)
        KNT2(IPTR)=KNT2(IPTR)+1
      ENDIF
      IF(ITRE(I).LE.0) ITRE(I) = 9999
  190 CONTINUE
C----------
C  CHECK FOR MISSING CROWNS ON CYCLE 0 DEAD TREES.
C----------
      IF(IREC2 .GT. MAXTRE) GO TO 192
      DO 191 I=IREC2,MAXTRE
      IF(ICR(I).LE.0)MISSCR=.TRUE.
  191 CONTINUE
  192 CONTINUE
C----------
C  CALL **CROWN** IF ANY CROWN RATIOS ARE MISSING.
C----------
      IF(MISSCR)CALL CROWN
C----------
C  PRINT CONTROL TABLE ENTRY FOR MISSING CROWN RATIOS; RESET COUNTERS.
C----------
      WRITE(JOSTND,9008) (KNT2(I),I=1,NUMSP)
 9008 FORMAT(/,' NUMBER OF RECORDS WITH MISSING CROWN RATIOS',
     &       T50,11(I4,2X))
      DO 200 I=1,MAXSP
      KNT2(I)=0
  200 CONTINUE
C----------
C  CALL AVHT40 TO CALCULATE AVERAGE HEIGHT.  THIS CALL IS NEEDED
C  BECAUSE DGF USES AVH IN CALCULATION OF DDS.
C----------
      CALL AVHT40
C----------
C  CALL DGDRIV TO CALIBRATE DIAMETER GROWTH EQUATIONS.
C----------
      IF(DEBUG)WRITE(JOSTND,*)' CALL DGDRIV FROM CRATET SECOND TIME'
      CALL DGDRIV
C----------
C  PREPARE INPUT DATA FOR HEIGHT GROWTH MODEL CALIBRATION; IT'S DONE
C  THE SAME AS THE DIAMETER GROWTH MODEL SEEN ABOVE.
C----------
      IF(IHTG.EQ.0 .OR. IHTG.EQ.2) GOTO 236
      Q = 1.
      IF(IHTG.EQ.3) Q = -1.
      DO 233 I=1,ITRN
      IF(HTG(I).LE.0.) GOTO 233
      HTG(I) = Q * (HT(I)-HTG(I))
      IF(HT(I) .LE. 0.0) HTG(I)=0.0
  233 CONTINUE
  236 CONTINUE
C----------
C  ESTIMATE MISSING TOTAL TREE AGE
C----------
      IF(DEBUG)WRITE(JOSTND,*)' IN CRATET, CALLING FINDAG'
      DO I=1,ITRN
      IF(ABIRTH(I) .LE. 0.)THEN
        SITAGE = 0.0
        SITHT = 0.0
        AGMAX = 0.0
        HTMAX = 0.0
        HTMAX2 = 0.0
        ISPC = ISP(I)
        D1 = DBH(I)
        H = HT(I)
        D2 = 0.0
        CALL FINDAG(I,ISPC,D1,D2,H,SITAGE,SITHT,AGMAX,HTMAX,HTMAX2,
     &              DEBUG)
        IF(SITAGE .GT. 0.)ABIRTH(I)=SITAGE
      ENDIF
      ENDDO
C----------
C  CALL REGENT TO CALIBRATE THE SMALL TREE HEIGHT INCREMENT MODEL.
C----------
      CALL REGENT(.FALSE.,1)
C----------
C  LOAD SPCNT WITH NUMBER OF TREES PER ACRE BY SPECIES AND TREE
C  CLASS.
C----------
      DO 240 I=1,ITRN
      IS=ISP(I)
      IM=IMC(I)
      SPCNT(IS,IM)=SPCNT(IS,IM)+PROB(I)
  240 CONTINUE
C----------
C  COMPUTE DISTRIBUTION OF TREES PER ACRE AND SPECIES-TREE CLASS
C  COMPOSITION BY TREES PER ACRE.
C----------
  245 CONTINUE
      CALL PCTILE(ITRN,IND,PROB,WK3,ONTCUR(7))
      CALL DIST(ITRN,ONTCUR,WK3)
      CALL COMP(OSPCT,IOSPCT,SPCNT)
      IF (ITRN.LE.0) GO TO 500
C----------
C  CALL **DENSE** TO CALCULATE STAND DENSITY STATISTICS FOR
C  INITIAL INVENTORY.
C----------
      IF(DEBUG) WRITE(JOSTND,9013) ICYC
 9013 FORMAT(' CALLING DENSE, CYCLE=',I2)
      CALL DENSE
C----------
C  COUNT AND PRINT NUMBER OF RECORDS WITH MISTLETOE.
C----------
      CALL MISCNT(KNT)
      WRITE(JOSTND,248) (KNT(I),I=1,NUMSP)
  248 FORMAT(/,' NUMBER OF RECORDS WITH MISTLETOE',T50,11(I4,2X))
C----------
C  CALL **SDICHK** TO SEE IF INITIAL STAND SDI IS ABOVE THE SPECIFIED
C  MAXIMUM SDI.  RESET MAXIMUM SDI IF THIS IS THE CASE.
C----------
      CALL SDICHK
C
  500 CONTINUE
      IF(DEBUG)WRITE(JOSTND,510)ICYC
  510 FORMAT(' LEAVING SUBROUTINE CRATET  CYCLE =',I5)
C
      RETURN
      END
