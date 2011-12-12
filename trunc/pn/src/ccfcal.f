      SUBROUTINE CCFCAL(ISPC,D,H,JCR,P,LTHIN,CCFT,CRWDTH,MODE)
      IMPLICIT NONE
C----------
C  **CCFCAL--PN   DATE OF LAST REVISION:  12/15/09
C----------
C  THIS ROUTINE COMPUTES CROWN WIDTH AND CCF FOR INDIVIDUAL TREES.
C  CALLED FROM DENSE, PRTRLS, SSTAGE, AND CVCW.
C
C  ARGUMENT DEFINITIONS:
C    ISPC = NUMERIC SPECIES CODE
C       D = DIAMETER AT BREAST HEIGHT
C       H = TOTAL TREE HEIGHT
C     JCR = CROWN RATIO IN PERCENT (0-100)
C       P = TREES PER ACRE
C   LTHIN = .TRUE. IF THINNING HAS JUST OCCURRED
C         = .FALSE. OTHERWISE
C    CCFT = CCF REPRESENTED BY THIS TREE
C  CRWDTH = CROWN WIDTH OF THIS TREE
C    MODE = 1 IF ONLY NEED CCF RETURNED
C           2 IF ONLY NEED CRWDTH RETURNED
C
C  DEFINITIONS OF TERMS IN CCF EQUATION:
C      RD1 -- CONSTANT TERM SUBSCRIPTED BY SPECIES.
C      RD2 -- DIAMETER TERM SUBSCRIPTED BY SPECIES.
C      RD3 -- DIAMETER SQUARED TERM SUBSCRIPTED BY SPECIES.
C             NOTE: D=1.0 IS USED FOR D-SQUARED IF D LE 1.0 INCHES
C
C  VARIANT SPECIES ORDER:
C                1=SF,  2=WF,  3=GF,  4=AF,  5=RF,  6=SS,  7=NF,  8=YC,
C                9=IC, 10=ES, 11=LP, 12=JP, 13=SP, 14=WP, 15=PP, 16=DF,
C               17=RW, 18=RC, 19=WH, 20=MH, 21=BM, 22=RA, 23=WA, 24=PB,
C               25=GC, 26=AS, 27=CW, 28=WO, 29=J , 30=LL, 31=WB, 32=KP,
C               33=PY, 34=DG, 35=HT, 36=CH, 37=WI, 38=  , 39=OT
C
C  CCF EQUATIONS ORDER:
C     1 = SMITH TABLE 1:
C     2 = PAINE AND HANN TABLE 2: WHITE AND GRAND FIR
C     3 = PAINE AND HANN TABLE 2: NOBLE FIR
C     4 = PAINE AND HANN TABLE 2: RED FIR
C     5 = PAINE AND HANN TABLE 2: INCENSE-CEDAR
C     6 = SMITH TABLE 1; RITCHIE AND HANN TABLE 2:
C     7 = SMITH TABLE 1:
C     8 = SMITH TABLE 1; RITCHIE AND HANN TABLE 2:
C     9 = NORTHERN IDAHO VARIANT INT-133 TABLE 8: LODGEPOLE PINE
C    10 = SMITH TABLE 1:
C    11 = PAINE AND HANN TABLE 2: WESTERN WHITE PINE
C    12 = PAINE AND HANN TABLE 2: DOUGLAS-FIR
C    13 = SMITH TABLE 1; RITCHIE AND HANN TABLE 2:
C    14 = PAINE AND HANN TABLE 2: WESTERN HEMLOCK
C    15 = PAINE AND HANN TABLE 2: CHINKAPIN
C    16 = SMITH TABLE 1; RITCHIE AND HANN TABLE 2:
C    17 = PAINE AND HANN TABLE 2: OREGON WHITE OAK
C    18 = SMITH TABLE 1; RITCHIE AND HANN TABLE 2:
C    19 = PAINE AND HANN TABLE 2: PONDEROSA PINE
C
C  SOURCES OF COEFFICIENTS:
C      PAINE AND HANN, 1982. MAXIMUM CROWN WIDTH EQUATIONS FOR
C        SOUTHWESTERN OREGON TREE SPECIES. RES PAP 46, FOR RES LAB
C        SCH FOR, OSU, CORVALLIS. 20PP.
C      RITCHIE AND HANN, 1985. EQUATIONS FOR PREDICTING BASAL AREA
C        INCREMENT IN DOUGLAS-FIR AND GRAND FIR. RES PAP 51, FOR RES
C        LAB SCH FOR, OSU, CORVALLIS. 9PP. (TABLE 2 PG 8)
C      SMITH 1966. STUDIES OF CROWN DEVELOPMENT ARE IMPROVING CANADIAN
C        FOREST MANAGEMENT. PROCEEDINGS, SIXTH WORLD FORESTRY CONGRESS.
C        MADRID, SPAIN. VOL 2:2309-2315. (TABLES 1 & 2, PG 2310)
C----------
      LOGICAL LTHIN
      REAL RD1(19),RD2(19),RD3(19),CRWDTH,CCFT,P,H,D
      INTEGER INDCCF(39),ISPC,IC,MODE,JCR
C
      DATA INDCCF/
     &  1,  2,  2,  3,  4,  8,  3,  5,  5,  7,
     & 10, 19, 19, 11, 19, 12, 12, 13, 14, 14,
     & 15, 16, 16, 17, 15, 17, 18, 17,  6, 19,
     &  9,  9,  6, 15, 17, 15, 15, 10, 10    /
      DATA RD1/
     & 1.01420E-1, 6.90403E-2, 2.45276E-2, 1.72000E-2, 1.94415E-2,
     & 3.18054E-2, 2.88484E-2, 7.61779E-2,    0.01925, 2.20871E-2,
     & 1.85728E-2, 3.87616E-2, 2.88484E-2, 3.75770E-2, 1.60051E-2,
     & 1.15394E-1, 1.70887E-2, 4.50757E-4, 2.19000E-2 /
      DATA RD2/
     & 4.32725E-2, 2.24682E-2, 1.14741E-2, 0.87600E-2, 1.42461E-2,
     & 2.15065E-2, 1.73091E-2, 4.21908E-2,    0.01676, 2.52424E-2,
     & 1.46210E-2, 2.68821E-2, 2.37999E-2, 2.32893E-2, 1.66659E-2,
     & 4.41381E-2, 2.13617E-2, 2.92090E-3, 1.68000E-2 /
      DATA RD3/
     & 4.61575E-3, 1.82799E-3, 1.34190E-3, 1.12000E-3, 2.60979E-3,
     & 3.63562E-3, 2.59636E-3, 5.84180E-3,    0.00365, 7.21210E-3,
     & 2.87750E-3, 4.66086E-3, 4.90874E-3, 3.60853E-3, 4.33848E-3,
     & 4.22070E-3, 6.67579E-3, 4.73186E-3, 3.25000E-3 /
C----------
C  INITIALIZE RETURN VARIABLES.
C----------
      CCFT = 0.
      CRWDTH = 0.
C----------
C  COMPUTE CCF
C----------
      IF(MODE.EQ.1) THEN
        IC = INDCCF(ISPC)
        IF (D .GE. 1.0) THEN
          CCFT = RD1(IC) + RD2(IC)*D + RD3(IC)*D**2.0
        ELSE
          CCFT = D * (RD1(IC)+RD2(IC)+RD3(IC))
        ENDIF
        IF(CCFT .LT. 0.001) CCFT=0.001
        CCFT = CCFT * P
      ENDIF
C----------
C  COMPUTE CROWN WIDTH
C----------
      IF(MODE.EQ.2) THEN
        CALL R6CRWD (ISPC,D,H,CRWDTH)
        IF(CRWDTH .GT. 99.9) CRWDTH=99.9
      ENDIF
C
      RETURN
      END
