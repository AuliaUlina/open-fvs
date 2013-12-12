      SUBROUTINE SICHG(ISISP,SSITE,SIAGE)
      IMPLICIT NONE
C----------
C  **SICHG--BM   DATE OF LAST REVISION:  01/27/12
C
C THIS ROUTINE TAKES THE SITE FROM THE STDINFO CARD AND CALCULATES AN AGE
C THAT CURVE, GIVEN THE SITE, WHERE A NEW HT (OR PROXY AGE) MAY ME LOOKE
C UP.
C----------
COMMONS
C
      INCLUDE 'PRGPRM.F77'
C
COMMONS
C----------
      INTEGER DIFF,REFAGE
      CHARACTER*1 ISILOC,REFLOC
      DIMENSION REFAGE(MAXSP),REFLOC(MAXSP)
      REAL A(MAXSP),B(MAXSP),SIAGE(MAXSP)
      INTEGER ISISP,I
      REAL SSITE,AGE2BH
C----------
C  SPECIES ORDER:
C   1=WP,  2=WL,  3=DF,  4=GF,  5=MH,  6=WJ,  7=LP,  8=ES,
C   9=AF, 10=PP, 11=WB, 12=LM, 13=PY, 14=YC, 15=AS, 16=CW,
C  17=OS, 18=OH
C----------
C  SPECIES EXPANSION:
C  WJ USES SO JU (ORIGINALLY FROM UT VARIANT; REALLY PP FROM CR VARIANT)
C  WB USES SO WB (ORIGINALLY FROM TT VARIANT)
C  LM USES UT LM
C  PY USES SO PY (ORIGINALLY FROM WC VARIANT)
C  YC USES WC YC
C  AS USES SO AS (ORIGINALLY FROM UT VARIANT)
C  CW USES SO CW (ORIGINALLY FROM WC VARIANT)
C  OS USES BM PP BARK COEFFICIENT
C  OH USES SO OH (ORIGINALLY FROM WC VARIANT)
C
C----------
C  DATA STATEMENTS FOR A AND B CONTAIN COEFFICIENTS FOR A LINEAR
C  RELATION OF AGE TO BREAST HEIGHT AS A FUNCTION OF SITE INDEX.
C  THE LINEAR RELATION IS AN ESTIMATE FROM THE LOWER END POINT OF
C  A HEIGHT GROWTH CURVE TO THE ORIGIN (0 AGE; 0 TOT TREE HT.)
C  THESE COEFFICIENTS SHOULD BE COMPATIBLE WITH SIMILAR VALUES USED
C  IN ESSUBH AND REGSMT SUBROUTINES.
C----------
      DATA A/ 18.43316,  8.11668,   8.50000,  9.01840, 45.24969,
     &         34.0000, 10.65724,  33.72545, 13.88200,  8.00000,
     &         34.0000,  34.0000,  11.56252, 11.56252,  34.0000,
     &        11.56252,   8.0000,  11.56252/
      DATA B/ -0.13399, -0.05661,  -0.05000, -0.05700, -1.28885,
     &        -0.20000, -0.10667, -0.274509, -0.06588, -0.04286,
     &        -0.20000, -0.20000,  -0.05586, -0.05586, -0.20000,
     &        -0.05586, -0.04286,  -0.05586/
      DATA REFLOC/ 'T',      'B',       'B',      'B',      'B',
     &             'T',      'T',       'B',      'B',      'B',
     &             'T',      'T',       'B',      'B',      'B',
     &             'B',      'B',       'B'/
      DATA REFAGE/  50,       50,        50,       50,      100,
     &             100,       50,       100,      100,      100,
     &             100,      100,       100,      100,       80,
     &             100,      100,       100/
C
C ISILOC IS THE PLACE THE AGE FOR THE SITE SPECIES.
C
      ISILOC = REFLOC(ISISP)
      DO 100 I = 1,MAXSP
C
C  SET UP THE ARRAY TO TELL WHETHER YOU NEED TO SLIDE UP OR DOWN THE SIT
C  LINE TO ADJUST FOR TOTAL AGE OR BREAST HIGH AGE
C
      IF(ISILOC .EQ. 'T' .AND. REFLOC(I) .EQ. 'B')DIFF=-1
      IF(ISILOC .EQ. REFLOC(I))DIFF=0
      IF(ISILOC .EQ. 'B' .AND. REFLOC(I) .EQ. 'T')DIFF=1
      AGE2BH=0.0
      IF(DIFF .LT. 0 .OR. DIFF .GT. 0)THEN
        AGE2BH=A(I) + B(I)*SSITE
      IF(ISISP .NE. 5 .AND. I .EQ. 5)AGE2BH=A(I) + B(I)*(SSITE/3.281)
      IF(ISISP .EQ. 5 .AND. I .NE. 5)AGE2BH=A(I) + B(I)*(SSITE*3.281)
      END IF
      SIAGE(I) = REFAGE(I) + AGE2BH*DIFF
  100 CONTINUE
      RETURN
      END












