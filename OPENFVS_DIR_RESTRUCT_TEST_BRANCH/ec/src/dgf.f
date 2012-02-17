      SUBROUTINE DGF(DIAM)
      IMPLICIT NONE
C----------
C  **DGF--EC    DATE OF LAST REVISION:  03/24/08
C----------
C  THIS SUBROUTINE COMPUTES THE VALUE OF DDS (CHANGE IN SQUARED
C  DIAMETER) FOR EACH TREE RECORD, AND LOADS IT INTO THE ARRAY
C  WK2.  DDS IS PREDICTED FROM HABITAT TYPE, LOCATION, SLOPE,
C  ASPECT, ELEVATION, DBH, CROWN RATIO, BASAL AREA IN LARGER TREES,
C  AND CCF.  THE SET OF TREE DIAMETERS TO BE USED IS PASSED AS THE
C  ARGUEMENT DIAM.  THE PROGRAM THUS HAS THE FLEXIBILITY TO
C  PROCESS DIFFERENT CALIBRATION OPTIONS.  THIS ROUTINE IS CALLED
C  BY **DGDRIV** DURING CALIBRATION AND WHILE CYCLING FOR GROWTH
C  PREDICTION.  ENTRY **DGCONS** IS CALLED BY **RCON** TO LOAD SITE
C  DEPENDENT COEFFICIENTS THAT NEED ONLY BE RESOLVED ONCE.
C----------
COMMONS
C
C
      INCLUDE 'PRGPRM.F77'
C
C
      INCLUDE 'CALCOM.F77'
C
C
      INCLUDE 'ARRAYS.F77'
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
      INCLUDE 'PLOT.F77'
C
C
      INCLUDE 'PDEN.F77'
C
C
COMMONS
C
C  DIMENSIONS FOR INTERNAL VARIABLES.
C
C     DIAM -- ARRAY LOADED WITH TREE DIAMETERS (PASSED AS AN
C             ARGUEMENT).
C     DGLD -- ARRAY CONTAINING COEFFICIENTS FOR THE LOG(DIAMETER)
C             TERM IN THE DDS MODEL (ONE COEFFICIENT FOR EACH
C             SPECIES).
C     DGCR -- ARRAY CONTAINING THE COEFFICIENTS FOR THE CROWN
C             RATIO TERM IN THE DDS MODEL (ONE COEFFICIENT FOR
C             EACH SPECIES).
C   DGCRSQ -- ARRAY CONTAINING THE COEFFICIENTS FOR THE CROWN
C             RATIO SQUARED TERM IN THE DDS MODEL (ONE
C             COEFFICIENT FOR EACH SPECIES).
C    DGBAL -- ARRAY CONTAINING COEFFICIENTS FOR THE BASAL AREA IN
C             LARGER TREES TERM IN THE DDS MODEL
C             (ONE COEFFICIENT FOR EACH SPECIES).
C   DGDBAL -- ARRAY CONTAINING COEFFICIENTS FOR THE INTERACTION
C             BETWEEN BASAL AREA IN LARGER TREES AND LN(DBH) (ONE
C             COEFFICIENT PER SPECIES).
C    DGCCF -- ARRAY CONTAINING THE COEFFICIENTS FOR THE CROWN
C             COMPETITION FACTOR TERM IN THE DDS MODEL (ONE
C             COEFFICIENT FOR EACH SPECIES, LOADED IN RCON).
C----------
C
C SPECIES ORDER
C     1     2     3     4     5     6     7     8     9    10 11
C    WP    WL    DF    SF    RC    GF    LP    ES    AF    PP OT
C
      REAL DIAM(MAXTRE),DGLD(11),DGDUM(11),DGCR(11),DGCRSQ(11),
     &   DGDBAL(11),DGHCCF(11),DGFOR(6,11),DGDS(4,11),DGEL(11),
     &   DGEL2(11),DGSASP(11),DGCASP(11),DGSLOP(11),DGSLSQ(11),
     &   DGCCFA(11),
     &   OBSERV(11),DGSITE(11),DGPCCF(11),SL0DUM(11)
      INTEGER MAPDSQ(7,11),MAPLOC(7,11)
      INTEGER ISPC,I1,I2,I3,I,IPCCF
      REAL CONSPP,D,CR,BAL,DUMMY,RELHT,DDS,X1,XPPDDS,SASP,XSITE
      DATA DGLD/
     & 1.32610,  0.609098, 0.855516,0.980383,0.58705,1.042583,
     & 0.554261, 0.823082, 0.816917, 0.665401, 0.580156/
      DATA DGCR/
     & 1.29730, 1.158355, 2.009866, 1.709846, 1.29360, 2.182084,
     & 1.423849, 1.263610, 1.119493, 1.671186, 1.212069/
      DATA DGCRSQ/
     & 0.00000, 0.00000, -0.44082, 0.00000, 0.00000, -0.843518,
     & 0.0    , 0.0    , 0.0    , 0.0    , 0.0/
      DATA DGSITE/
     & 0.86756, 0.351929, 1.119725, 0.323625, 0.00000, 0.782092,
     & 0.458662, 0.290959, 0.231960, 0.921987, 0.346907/
      DATA DGDBAL/
     &-0.00239,-0.004253,-0.003075,-0.000261,-0.02284,-0.001323,
     &-0.004803,-0.005163,-0.000702,-0.008065,-0.0/
      DATA DGDUM/
     & 0.00000, 0.00000, 0.00000, -0.799079,0.00000, 0.522079,
     & 0.0    , 0.00000, 0.00000, 0.00000, 0.00000/
      DATA DGHCCF/
     & 0.0    , 0.0    , 0.0    , 0.0 ,0.00000, 0.0,
     & 0.0    , 0.0    , 0.0    , 0.0    , 0.156459/
      DATA DGPCCF/
     &-0.00044,-0.000568,-0.000441,-0.000643,-0.00094,-0.001574,
     &-0.000627,-0.000883,-0.001102, 0.00112,-0.001221/
C----------
C  IDTYPE IS A HABITAT TYPE INDEX THAT IS COMPUTED IN **RCON**.
C  ASPECT IS STAND ASPECT.  OBSERV CONTAINS THE NUMBER OF
C  OBSERVATIONS BY HABITAT CLASS BY SPECIES FOR THE UNDERLYING
C  MODEL (THIS DATA IS ACTUALLY USED BY **DGDRIV** FOR
C  CALIBRATION).
C----------
      DATA  OBSERV/
     & 1185., 591. , 6249., 1210.,  100., 1950.,
     & 1478., 652. , 723., 4021., 1370./
C----------
C  DGCCFA CONTAINS COEFFICIENTS FOR THE CCF TERM BY SPECIES BY
C  HABITAT CLASS.
C----------
      DATA DGCCFA/
     & 0.00000, 0.00000, 0.00000, 0.00000, 0.00000, 0.00000,
     & 0.00000, 0.00000, 0.0    ,-0.003183, 0.00000/
C----------
C  DGFOR CONTAINS LOCATION CLASS CONSTANTS FOR EACH SPECIES.
C  MAPLOC IS AN ARRAY WHICH MAPS FOREST ONTO A LOCATION CLASS.
C----------
      DATA MAPLOC/
     & 1,1,1,1,1,1,1,
     & 1,1,1,1,1,1,1,
     & 1,2,1,2,1,1,1,
     & 1,2,1,1,1,1,1,
     & 1,1,1,1,1,1,1,
     & 1,1,1,2,1,1,1,
     & 1,1,2,1,1,1,1,
     & 1,1,1,2,2,1,1,
     & 1,1,1,2,1,1,1,
     & 1,1,1,1,1,1,1,
     & 1,2,3,3,1,1,1/
      DATA DGFOR/
     &-4.64535, 0.0     , 0.0    , 0.00000, 0.00000, 0.00000,
     &-0.605649, 0.0    , 0.0    , 0.0    , 0.00000, 0.00000,
     &-4.081038,-3.965956, .000000, 0.00000, 0.00000, 0.00000,
     &-0.441408, -0.538987, 4*0.0,
     & 1.49419, 0.00000, 0.00000, 0.00000, 0.00000, 0.00000,
     &-3.811100, -3.673109, 4*0.0,
     &-1.084679,-1.172470, 4*0.0,
     &-0.098284, 0.117987, 4*0.0,
     &-0.420205, -0.312955, 4*0.0,
     &-3.102028, 5*0.0,
     &-1.407548,-1.131934,-1.539078, 3*0.0/
C----------
C  DGDS CONTAINS COEFFICIENTS FOR THE DIAMETER SQUARED TERMS
C  IN THE DIAMETER INCREMENT MODELS    ARRAYED BY FOREST BY
C  SPECIES.  MAPDSQ IS AN ARRAY WHICH MAPS FOREST ONTO A DBH**2
C  COEFFICIENT.
C----------
      DATA MAPDSQ/
     & 1,1,1,1,1,1,1,
     & 1,1,1,1,1,1,1,
     & 1,1,1,1,1,1,1,
     & 1,1,1,1,1,1,1,
     & 1,1,1,1,1,1,1,
     & 1,1,1,1,1,1,1,
     & 1,1,1,1,1,1,1,
     & 1,1,1,1,1,1,1,
     & 1,1,1,1,1,1,1,
     & 1,1,1,1,1,1,1,
     & 1,1,1,1,1,1,1/
      DATA DGDS/
     &  0.0     , 0.000000, 0.0     ,      0.0,
     & -0.0001683, 3*0.0,
     & -0.000261, 3*0.0,
     & -0.0002189, 3*0.0,
     &  0.000000, 0.000   ,      0.0,      0.0,
     & -0.0003694, 3*0.0,
     &  4*0.0,
     & -0.0002039, 3*0.0,
     &  4*0.0,
     & -0.0002468, 0.0     , 0.000000,      0.0,
     & -0.0000192, 0.000   ,      0.0,      0.0/
C----------
C  DGEL CONTAINS THE COEFFICIENTS FOR THE ELEVATION TERM IN THE
C  DIAMETER GROWTH EQUATION.  DGEL2 CONTAINS THE COEFFICIENTS FOR
C  THE ELEVATION SQUARED TERM IN THE DIAMETER GROWTH EQUATION.
C  DGSASP CONTAINS THE COEFFICIENTS FOR THE SIN(ASPECT)*SLOPE
C  TERM IN THE DIAMETER GROWTH EQUATION.  DGCASP CONTAINS THE
C  COEFFICIENTS FOR THE COS(ASPECT)*SLOPE TERM IN THE DIAMETER
C  GROWTH EQUATION.  DGSLOP CONTAINS THE COEFFICIENTS FOR THE
C  SLOPE TERM IN THE DIAMETER GROWTH EQUATION.  DGSLSQ CONTAINS
C  COEFFICIENTS FOR THE (SLOPE)**2 TERM IN THE DIAMETER GROWTH
C  MODELS.  ALL OF THESE ARRAYS ARE SUBSCRIPTED BY SPECIES.
C----------
      DATA DGCASP/
     & 0.38002,-0.156235,-0.092151,-0.059062,-0.06625,-0.239156,
     &-0.064328,-0.055587,-0.049761,-0.181022,-0.097288/
      DATA DGSASP/
     &-0.17911, 0.258712, 0.029947,-0.128126, 0.05534,-0.185520,
     &-0.142328, 0.216231, 0.002810,-0.149848, 0.037062/
      DATA DGSLOP/
     &-0.81780,-0.635704,-0.309511, 0.240178, 0.11931, 1.466089,
     &-0.097297,-0.000577, 1.160345,-0.252705, 0.089774/
      DATA DGSLSQ/
     & 0.84368, 0.0    , 0.00000, 0.131356, 0.0    ,-1.817050,
     & 0.094464,0.0    ,-1.740114, 0.0    , 0.0/
      DATA DGEL/
     & 0.00000, 0.004379,-0.021091,-0.015087,-0.00175, 0.023020,
     &-0.001124,-0.014944,-0.009430,-0.005345, 0.012082/
      DATA DGEL2/
     & 0.00000, 0.0    , 0.000225, 0.0    ,-0.000067,-0.000364,
     & 0.0    , 0.00000, 0.00000, 0.00000, 0.00000/
C
C DUMMY FOR SLOPE EQ 0
C
       DATA SL0DUM/
     & 0.0,-0.290174, 0.00000,-0.174404, 0.0     ,-0.360203,
     & 0.0, 0.0    , -0.278601, 0.0    ,-0.099908/
C
      LOGICAL DEBUG
C-----------
C  CHECK FOR DEBUG.
C-----------
      CALL DBCHK (DEBUG,'DGF',3,ICYC)
      IF(DEBUG) WRITE(JOSTND,3)ICYC
    3 FORMAT(' ENTERING SUBROUTINE DGF  CYCLE =',I5)
C----------
C  DEBUG OUTPUT: MODEL COEFFICIENTS.
C----------
      IF(DEBUG) WRITE(JOSTND,*) 'IN DGF,HTCON=',HTCON,
     *'ELEV=',ELEV,'RELDEN=',RELDEN
      IF(DEBUG)
     & WRITE(JOSTND,9000) DGCON,DGDSQ
 9000 FORMAT(/11(1X,F10.5))
C----------
C  BEGIN SPECIES LOOP.  ASSIGN VARIABLES WHICH ARE SPECIES
C  DEPENDENT
C----------
      DO 20 ISPC=1,11
      I1=ISCT(ISPC,1)
      IF(I1.EQ.0) GO TO 20
      I2=ISCT(ISPC,2)
      CONSPP= DGCON(ISPC) + COR(ISPC)
      IF(ISPC .EQ. 11) CONSPP = CONSPP - 0.000021*RMAI*RELDEN
C----------
C  BEGIN TREE LOOP WITHIN SPECIES ISPC.
C----------
      DO 10 I3=I1,I2
      I=IND1(I3)
      D=DIAM(I)
      IF (D.LE.0.0) GOTO 10
      CR=ICR(I)*0.01
      BAL = (1.0 - (PCT(I)/100.)) * BA
      IPCCF=ITRE(I)
      DUMMY = 0.0
      RELHT=HT(I)/AVH
      IF(RELHT .GT. 1.5)RELHT=1.5
      IF(ISPC .EQ. 4 .OR. ISPC .EQ. 6) DUMMY = 1.0
      DDS = CONSPP + DGLD(ISPC)*ALOG(D)
     & + DGDUM(ISPC)*DUMMY + CR*(DGCR(ISPC) + CR*DGCRSQ(ISPC))
     & + DGDSQ(ISPC)*D*D  + DGDBAL(ISPC)*BAL/(ALOG(D+1.0))
     & + DGPCCF(ISPC)*PCCF(IPCCF)
     & + DGHCCF(ISPC)*RELHT*PCCF(IPCCF)/100.0
     & + DGCCFA(ISPC) *PCCF(IPCCF)*PCCF(IPCCF)/1000.0
      IF(ISPC.EQ.1)DDS=DDS+0.49649*RELHT
C
      IF(DEBUG) WRITE(JOSTND,8000)
     &I,ISPC,CONSPP,D,BA,CR,BAL,PCCF(IPCCF),RELDEN,HT(I),AVH
 8000 FORMAT(1H0,'IN DGF 8000F',2I5,9F11.4)
C---------
C     CALL PPDGF TO GET A MODIFICATION VALUE FOR DDS THAT ACCOUNTS
C     FOR THE DENSITY OF NEIGHBORING STANDS.
C
      X1=0.
      XPPDDS=0.
      CALL PPDGF (XPPDDS,X1,X1,X1,X1,X1,X1)
C
      DDS=DDS+XPPDDS
C---------
      IF(DDS.LT.-9.21) DDS=-9.21
      WK2(I)=DDS
C----------
C  END OF TREE LOOP.  PRINT DEBUG INFO IF DESIRED.
C----------
      IF(DEBUG)THEN
      WRITE(JOSTND,9001) I,ISPC,DDS
 9001 FORMAT(' IN DGF, I=',I4,',  ISPC=',I3,',  LN(DDS)=',F7.4)
      ENDIF
   10 CONTINUE
C----------
C  END OF SPECIES LOOP.
C----------
   20 CONTINUE
      IF(DEBUG) WRITE(JOSTND,100)ICYC
  100 FORMAT(' LEAVING SUBROUTINE DGF  CYCLE =',I5)
      RETURN
      ENTRY DGCONS
C----------
C  ENTRY POINT FOR LOADING COEFFICIENTS OF THE DIAMETER INCREMENT
C  MODEL THAT ARE SITE SPECIFIC AND NEED ONLY BE RESOLVED ONCE.
C----------
C  CHECK FOR DEBUG.
C----------
      CALL DBCHK (DEBUG,'DGF',3,ICYC)
C----------
C  ENTER LOOP TO LOAD SPECIES DEPENDENT VECTORS.
C----------
      DO 30 ISPC=1,11
      ISPFOR=MAPLOC(IFOR,ISPC)
      ISPDSQ=MAPDSQ(IFOR,ISPC)
      SASP =
     &                 +(DGSASP(ISPC) * SIN(ASPECT)
     &                 + DGCASP(ISPC) * COS(ASPECT)
     &                 + DGSLOP(ISPC)) * SLOPE
     &                 + DGSLSQ(ISPC) * SLOPE * SLOPE
      IF(SLOPE .EQ. 0.0)SASP=SL0DUM(ISPC)
      XSITE=SITEAR(ISPC)
      IF(ISPC .EQ. 11) XSITE=XSITE*3.281
      DGCON(ISPC) =
     &                   DGFOR(ISPFOR,ISPC)
     &                 + DGEL(ISPC) * ELEV
     &                 + DGEL2(ISPC) * ELEV * ELEV
     &                 +DGSITE(ISPC)*ALOG(XSITE)
     &                 + SASP
C
C DUMMY FOR NOBLE FIR
C
      IF(ISPC .EQ. 9) DGCON(ISPC)=DGCON(ISPC) + 0.3835
      DGDSQ(ISPC)=DGDS(ISPDSQ,ISPC)
      ATTEN(ISPC)=OBSERV(ISPC)
      SMCON(ISPC)=0.
      IF(DEBUG)WRITE(JOSTND,9030)DGFOR(ISPFOR,ISPC),
     &DGEL(ISPC),ELEV,DGEL2(ISPC),DGSASP(ISPC),ASPECT,
     &DGCASP(ISPC),DGSLOP(ISPC),SLOPE,DGSITE(ISPC),
     &SITEAR(ISPC),DGCON(ISPC),SASP
 9030 FORMAT(' IN DGF 9030',13F9.5)
C----------
C  IF READCORD OR REUSCORD WAS SPECIFIED (LDCOR2 IS TRUE) ADD
C  LN(COR2) TO THE BAI MODEL CONSTANT TERM (DGCON).  COR2 IS
C  INITIALIZED TO 1.0 IN BLKDATA.
C----------
      IF (LDCOR2.AND.COR2(ISPC).GT.0.0) DGCON(ISPC)=DGCON(ISPC)
     &  + ALOG(COR2(ISPC))
   30 CONTINUE
      RETURN
      END
