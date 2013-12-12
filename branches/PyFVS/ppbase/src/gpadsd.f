      SUBROUTINE GPADSD (ISTND)
      IMPLICIT NONE
C----------
C  **GPADSD  DATE OF LAST REVISION:  07/31/08
C----------
C
C     ADD THE CURRENT STAND TO ANY OPEN GLOBAL ACTIVITIES.
C
C     PART OF THE PARALLEL PROCESSING EXTENSION TO PROGNOSIS.
C     P.W. THOMAS--FORESTRY SCIENCES LAB, MOSCOW, ID--MARCH 1986
C
C     SUBROUTINES CALLED:
C
C       LLADD  - ADD AN INTEGER TO A LINKED LIST.
C
C     PARAMETERS:
C
C       ISTND  - PROGNOSIS STAND NUMBER OF THE CURRENT STAND.
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
      INTEGER ISTND,I
C
C
      IF (MIMGL.LE.0) GOTO 999
      DO 40 I=1,MIMGL
      IF (LMOPEN(I)) CALL LLADD (ISTND,MIACT(4,I),MIACT(5,I))
   40 CONTINUE
  999 CONTINUE
      RETURN
      END