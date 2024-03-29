      SUBROUTINE BALMOD(ISPC,D,GMOD)
      IMPLICIT NONE
C----------
C  **BALMOD--NE    DATE OF LAST REVISION:  07/11/08
C----------
C  THIS SUBROUTINE COMPUTES THE VALUE OF A GROWTH MODIFIER BASED
C  ON BAL. ORIGINALLY THIS WAS JUST PART OF THE LARGE TREE DIAMETER
C  GROWTH SEQUENCE. HOWEVER, THERE NEEDS TO BE A SIMILAR ACCOUNTING
C  OF STAND POSITION IN THE LARGE TREE AND SMALL TREE HEIGHT GROWTH
C  ESTIMATION SEQUENCE. THIS ROUTINE IS CALLED BY DGF, HTGF, AND
C  RGNTHW.
C----------
COMMONS
C
C
      INCLUDE 'PRGPRM.F77'
C
C
      INCLUDE 'TWIGCOM.F77'
C
C
COMMONS
C----------
      REAL B3(MAXSP)
      REAL GMOD,D,BAL
      INTEGER ISPC,ICLS
C
      DATA B3/
     % 0.012785, 0.018831, 0.013427,4*.011942, 0.017300, 0.015496,
     % 0.017300, 0.016835,4*.012329,2*.009149,8*.016835, 0.016191,
     % 3*.016240,3*.019046,2*.023978,5*.015963, 0.013029,5*.015004,
     % 3*.019904,5*.016877, 0.016537,5*.014235,4*.018560,3*.013762,
     % 2*.018024,2*.020843,27*.020653,11*.011620/
C
      GMOD=1.
      ICLS=IFIX(D + 1.0)
C
C  THIS NEXT LINE IS TO GET SOME COMPETITION FROM NEIGHBORING
C  TREES THAT ARE ABOUT THE SAME SIZE.
C
      ICLS=ICLS-2
C
      IF(ICLS .LT. 1)ICLS=1
      IF(ICLS .GT. 50)ICLS=50
      BAL=BAU(ICLS)
      IF(BAL .LE. 0.)GO TO 10
      GMOD=EXP(-(B3(ISPC)*BAL))
      IF(GMOD.LT.0.5)GMOD=0.5
   10 CONTINUE
      RETURN
      END
      