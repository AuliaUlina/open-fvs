      SUBROUTINE HTDBH (IFOR,ISPC,D,H,MODE)
      IMPLICIT NONE
C----------
C  **HTDBH--WS  DATE OF LAST REVISION:  05/09/11
C----------
C  THIS SUBROUTINE CONTAINS THE DEFAULT HEIGHT-DIAMETER RELATIONSHIPS
C  FROM THE INVENTORY DATA.  
C
C  FOR SOME SPECIES, IT IS CALLED FROM CRATET TO DUB MISSING
C  HEIGHTS, AND FROM REGENT TO ESTIMATE DIAMETERS (PROVIDED IN BOTH
C  CASES THAT LHTDRG IS SET TO .TRUE.).
C
C  DEFINITION OF VARIABLES:
C         D = DIAMETER AT BREAST HEIGHT
C         H = TOTAL TREE HEIGHT (STUMP TO TIP)
C      IFOR = FOREST CODE (NOT USED)
C      ISPC = FVS SPECIES SEQUENCE NUMBER
C      MODE = MODE OF OPERATING THIS SUBROUTINE
C             0 IF DIAMETER IS PROVIDED AND HEIGHT IS DESIRED
C             1 IF HEIGHT IS PROVIDED AND DIAMETER IS DESIRED
C----------
C
      INTEGER ISPC,IFOR,I,MODE
      REAL CURARN(43,3),SPLINE(43)
      REAL H,D,P2,P3,P4,Z,HATZ
C----------
C     SPECIES LIST FOR WESTERN SIERRAS VARIANT.
C
C     1 = SUGAR PINE (SP)                   PINUS LAMBERTIANA
C     2 = DOUGLAS-FIR (DF)                  PSEUDOTSUGA MENZIESII
C     3 = WHITE FIR (WF)                    ABIES CONCOLOR
C     4 = GIANT SEQUOIA (GS)                SEQUOIADENDRON GIGANTEAUM
C     5 = INCENSE CEDAR (IC)                LIBOCEDRUS DECURRENS
C     6 = JEFFREY PINE (JP)                 PINUS JEFFREYI
C     7 = CALIFORNIA RED FIR (RF)           ABIES MAGNIFICA
C     8 = PONDEROSA PINE (PP)               PINUS PONDEROSA
C     9 = LODGEPOLE PINE (LP)               PINUS CONTORTA
C    10 = WHITEBARK PINE (WB)               PINUS ALBICAULIS
C    11 = WESTERN WHITE PINE (WP)           PINUS MONTICOLA
C    12 = SINGLELEAF PINYON (PM)            PINUS MONOPHYLLA
C    13 = PACIFIC SILVER FIR (SF)           ABIES AMABILIS
C    14 = KNOBCONE PINE (KP)                PINUS ATTENUATA
C    15 = FOXTAIL PINE (FP)                 PINUS BALFOURIANA
C    16 = COULTER PINE (CP)                 PINUS COULTERI
C    17 = LIMBER PINE (LM)                  PINUS FLEXILIS
C    18 = MONTEREY PINE (MP)                PINUS RADIATA
C    19 = GRAY PINE (GP)                    PINUS SABINIANA
C         (OR CALIFORNIA FOOTHILL PINE)
C    20 = WASHOE PINE (WE)                  PINUS WASHOENSIS
C    21 = GREAT BASIN BRISTLECONE PINE (GB) PINUS LONGAEVA
C    22 = BIGCONE DOUGLAS-FIR (BD)          PSEUDOTSUGA MACROCARPA
C    23 = REDWOOD (RW)                      SEQUOIA SEMPERVIRENS
C    24 = MOUNTAIN HEMLOCK (MH)             TSUGA MERTENSIANA
C    25 = WESTERN JUNIPER (WJ)              JUNIPERUS OCIDENTALIS
C    26 = UTAH JUNIPER (UJ)                 JUNIPERUS OSTEOSPERMA
C    27 = CALIFORNIA JUNIPER (CJ)           JUNIPERUS CALIFORNICA
C    28 = CALIFORNIA LIVE OAK (LO)          QUERCUS AGRIFOLIA
C    29 = CANYON LIVE OAK (CY)              QUERCUS CHRYSOLEPSIS
C    30 = BLUE OAK (BL)                     QUERCUS DOUGLASII
C    31 = CALIFORNIA BLACK OAK (BO)         QUERQUS KELLOGGII
C    32 = VALLEY OAK (VO)                   QUERCUS LOBATA
C         (OR CALIFORNIA WHITE OAK)
C    33 = INTERIOR LIVE OAK (IO)            QUERCUS WISLIZENI
C    34 = TANOAK (TO)                       LITHOCARPUS DENSIFLORUS
C    35 = GIANT CHINKAPIN (GC)              CHRYSOLEPIS CHRYSOPHYLLA
C    36 = QUAKING ASPEN (AS)                POPULUS TREMULOIDES
C    37 = CALIFORNIA-LAUREL (CL)            UMBELLULARIA CALIFORNICA
C    38 = PACIFIC MADRONE (MA)              ARBUTUS MENZIESII
C    39 = PACIFIC DOGWOOD (DG)              CORNUS NUTTALLII
C    40 = BIGLEAF MAPLE (BM)                ACER MACROPHYLLUM
C    41 = CURLLEAF MOUNTAIN-MAHOGANY (MC)   CERCOCARPUS LEDIFOLIUS
C    42 = OTHER SOFTWOODS (OS)
C    43 = OTHER HARDWOODS (OH)
C
C  SURROGATE EQUATION ASSIGNMENT:
C
C    FROM EXISTING WS EQUATIONS --
C      USE 1(SP) FOR 11(WP) AND 24(MH) 
C      USE 2(DF) FOR 22(BD)
C      USE 3(WF) FOR 13(SF)
C      USE 4(GS) FOR 23(RW)
C      USE 8(PP) FOR 18(MP)
C      USE 34(TO) FOR 35(GC), 36(AS), 37(CL), 38(MA), AND 39(DG)
C      USE 31(BO) FOR 28(LO), 29(CY), 30(BL), 32(VO), 33(IO), 40(BM), AND
C                     43(OH)
C
C    FROM CA VARIANT --
C      USE CA11(KP) FOR 12(PM), 14(KP), 15(FP), 16(CP), 17(LM), 19(GP), 20(WE), 
C                       25(WJ), 26(WJ), AND 27(CJ)
C      USE CA12(LP) FOR 9(LP) AND 10(WB)
C
C    FROM SO VARIANT --
C      USE SO30(MC) FOR 41(MC)
C
C    FROM UT VARIANT --
C      USE UT17(GB) FOR 21(GB)
C----------
C SPECIES WITH CURTIS/ARNEY EQNS FIT FROM DATA FOR CA VARIANT ---
C       DF, IC, PM, KP, GP, LP, MA, BO, WO, PP, JP, RF/SF, SP, WF, WP
C COEFFICIENTS FOR OTHER SPECIES ARE FROM OTHER R6 VARIANTS
C----------
      DATA (CURARN(I,1),I=1,43)/
     &    0.0000,    0.0000,    0.0000,    0.0000,    0.0000,
     &    0.0000,    0.0000,    0.0000,   99.1568,   99.1568,
     &    0.0000,  101.5170,    0.0000,  101.5170,  101.5170,
     &  101.5170,  101.5170,    0.0000,  101.5170,  101.5170,
     &    0.0000,    0.0000,    0.0000,    0.0000,  101.5170,
     &  101.5170,  101.5170,    0.0000,    0.0000,    0.0000,
     &    0.0000,    0.0000,    0.0000,    0.0000,    0.0000,
     &    0.0000,    0.0000,    0.0000,    0.0000,    0.0000,
     & 1709.7229,    0.0000,    0.0000/
C
      DATA (CURARN(I,2),I=1,43)/
     &    0.0000,    0.0000,    0.0000,    0.0000,    0.0000,
     &    0.0000,    0.0000,    0.0000,   12.1300,   12.1300,
     &    0.0000,    4.7066,    0.0000,    4.7066,    4.7066,
     &    4.7066,    4.7066,    0.0000,    4.7066,    4.7066,
     &    0.0000,    0.0000,    0.0000,    0.0000,    4.7066,
     &    4.7066,    4.7066,    0.0000,    0.0000,    0.0000,
     &    0.0000,    0.0000,    0.0000,    0.0000,    0.0000,
     &    0.0000,    0.0000,    0.0000,    0.0000,    0.0000,
     &    5.8887,    0.0000,    0.0000/
C
      DATA (CURARN(I,3),I=1,43)/
     &    0.0000,    0.0000,    0.0000,    0.0000,    0.0000,
     &    0.0000,    0.0000,    0.0000,   -1.3272,   -1.3272,
     &    0.0000,   -0.9540,    0.0000,   -0.9540,   -0.9540,
     &   -0.9540,   -0.9540,    0.0000,   -0.9540,   -0.9540,
     &    0.0000,    0.0000,    0.0000,    0.0000,   -0.9540,
     &   -0.9540,   -0.9540,    0.0000,    0.0000,    0.0000,
     &    0.0000,    0.0000,    0.0000,    0.0000,    0.0000,
     &    0.0000,    0.0000,    0.0000,    0.0000,    0.0000,
     &   -0.2286,    0.0000,    0.0000/
C
      DATA SPLINE /
     & 0., 0., 0., 0., 0., 0., 0., 0., 5., 5.,
     & 0., 2., 0., 2., 2., 2., 2., 0., 2., 2.,
     & 0., 0., 0., 0., 2., 2., 2., 0., 0., 0.,
     & 0., 0., 0., 0., 0., 0., 0., 0., 0., 0.,
     & 3., 0., 0./
C----------
C  SET EQUATION PARAMETERS ACCORDING TO SPECIES.
C----------
      P2 = CURARN(ISPC,1)
      P3 = CURARN(ISPC,2)
      P4 = CURARN(ISPC,3)
      Z = SPLINE(ISPC)
      IF(MODE .EQ. 0) H=0.
      IF(MODE .EQ. 1) D=0.
C----------
C  PROCESS ACCORDING TO MODE
C----------
      IF(MODE .EQ. 0) THEN
        IF(D .GE. Z) THEN
          H = 4.5 + P2 * EXP(-1.*P3*D**P4)
        ELSE
          H = ((4.5+P2*EXP(-1.*P3*(Z**P4))-4.51)*(D-0.3)/(Z-0.3))+4.51
        ENDIF
      ELSE
        HATZ = 4.5 + P2 * EXP(-1.*P3*Z**P4)
        IF(H .GE. HATZ) THEN
          D = EXP( ALOG((ALOG(H-4.5)-ALOG(P2))/(-1.*P3)) * 1./P4)
        ELSE
          D=(((H-4.51)*(Z-0.3))/(4.5+P2*EXP(-1.*P3*(Z**P4))-4.51))+0.3
        ENDIF
      ENDIF
C
      RETURN
      END
