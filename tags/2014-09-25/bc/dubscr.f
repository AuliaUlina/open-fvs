      SUBROUTINE DUBSCR(LVER,ISPC,XC,D,H,BAX,BAL,CR)
      IMPLICIT NONE
C----------
C  $Id$
C----------
C  THIS SUBROUTINE CALCULATES CROWN RATIOS FOR TREES INSERTED BY
C  THE REGENERATION ESTABLISHMENT MODEL.  IT ALSO DUBS CROWN RATIOS
C  FOR TREES IN THE INVENTORY THAT ARE MISSING CROWN RATIO
C  MEASUREMENTS AND ARE LESS THAN 3.0 INCHES DBH.  FINALLY, IT IS
C  USED TO REPLACE CROWN RATIO ESTIMATES FOR ALL TREES THAT
C  CROSS THE THRESHOLD BETWEEN THE SMALL AND LARGE TREE MODELS.
C----------
COMMONS
C
C
      INCLUDE 'PRGPRM.F77'
      INCLUDE 'CONTRL.F77'
      INCLUDE 'PLOT.F77'
      INCLUDE 'BCPLOT.F77'

COMMONS
      LOGICAL  LVER
      INTEGER  ISPC
	REAL     XC,D,H,BAX,BAL,CR

C     V2
      EXTERNAL RANN
      REAL     SD,FCR,BACHLO
      REAL     BCR0(MAXSP),BCR1(MAXSP),BCR2(MAXSP),BCR3(MAXSP),
     &         CRSDX(MAXSP)

      DATA BCR0/
     &  -0.44316,-0.83965,-0.89122,-0.62646,-0.49548, 0.11847,
     &  -0.32466,-0.92007,-0.89014,-0.17561, 0.11847, 0.11847,
     &   0.11847,-0.89122, 0.11847/
      DATA BCR1/
     &  -0.48446,-0.16106,-0.18082,-0.06141, 0.00012,-0.39305,
     &  -0.20108,-0.22454,-0.18026,-0.33847,-0.39305,-0.39305,
     &  -0.39305,-0.18082,-0.39305/
      DATA BCR2/
     &   0.05825, 0.04161, 0.05186, 0.02360, 0.00362, 0.02783,
     &   0.04219, 0.03248, 0.02233, 0.05699, 0.02783, 0.02783,
     &   0.02783, 0.05186, 0.02783/
      DATA BCR3/
     &   0.00513, 0.00602, 0.00454, 0.00505, 0.00456, 0.00626,
     &   0.00436, 0.00620, 0.00614, 0.00692, 0.00626, 0.00626,
     &   0.00626, 0.00454, 0.00626/
      DATA CRSDX/
     &  0.9476,  0.7396,  0.8706,  0.9203,  0.9450,  0.8012,
     &  0.7707,  0.9721,  0.8871,  0.8866,  0.8012,  0.8012,
     &  0.8012,  0.8706,  0.8012/

      IF (LVER) THEN
        CR=BCR0(ISPC) + BCR1(ISPC)*D + BCR2(ISPC)*H + BCR3(ISPC)*BAX
        SD=CRSDX(ISPC)
   10   CONTINUE
        FCR=0.0
        IF (DGSD.GE.1.0) FCR=BACHLO(0.0,SD,RANN)
        IF(ABS(FCR).GT.SD) GO TO 10
        CR=1.0/(1.0 + EXP(CR+FCR))
      ELSE
        CALL CRNMD (ISPC,XC,D,H,BAL,CR,0.0)
      ENDIF
      IF(CR .LT. 0.05) CR = 0.05
      IF(CR .GT. 0.95) CR = 0.95
      
      RETURN
      END
