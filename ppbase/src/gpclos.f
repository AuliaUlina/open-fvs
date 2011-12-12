      SUBROUTINE GPCLOS (IACTK)
      IMPLICIT NONE
C----------
C  **GPCLOS  DATE OF LAST REVISION:  07/31/08
C----------
C
C     CLOSE A GLOBAL ACTIVITY.
C
C     PART OF THE PARALLEL PROCESSING EXTENSION TO PROGNOSIS.
C     P.W. THOMAS--FORESTRY SCIENCES LAB, MOSCOW, ID--MARCH 1986
C
C     PARAMETERS:
C
C       IACTK  - ACTIVITY NUMBER TO CLOSE.  IF ZERO, ALL ACTIVITIES
C                ARE CLOSED.
C
COMMONS
C
C
      INCLUDE 'PPGPCM.F77'
C
C
COMMONS
C
C
C
      INTEGER IACTK,I
C
C
      IF (MIMGL.LE.0) GOTO 999
      DO 40 I=1,MIMGL
      IF ((MIACT(1,MIMGL).EQ.IACTK).OR.(IACTK.EQ.0)) LMOPEN (I)=.FALSE.
   40 CONTINUE
  999 CONTINUE
      RETURN
      END
