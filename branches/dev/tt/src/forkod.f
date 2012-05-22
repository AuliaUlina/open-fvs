      SUBROUTINE FORKOD
      IMPLICIT NONE
C----------
C  **FORKOD--TT   DATE OF LAST REVISION:  02/04/10
C----------
C
C     TRANSLATES FOREST CODE INTO A SUBSCRIPT, IFOR, AND IF
C     KODFOR IS ZERO, THE ROUTINE RETURNS THE DEFAULT CODE.
C
COMMONS
C
C
      INCLUDE 'PRGPRM.F77'
C
C
      INCLUDE 'PLOT.F77'
C
C
      INCLUDE 'CONTRL.F77'
C
C
COMMONS
C
C----------
C  NATIONAL FORESTS:
C  403 = BRIDGER
C  405 = CARIBOU
C  415 = TARGHEE
C  416 = TETON
C----------
      INTEGER JFOR(4),KFOR(4),NUMFOR,I
      DATA JFOR/403,405,415,416/,NUMFOR/4/
      DATA KFOR/4*1/
C
      IF (KODFOR .EQ. 0) GOTO 30
      DO 10 I=1,NUMFOR
      IF (KODFOR .EQ. JFOR(I)) GOTO 20
   10 CONTINUE
      CALL ERRGRO (.TRUE.,3)
      WRITE(JOSTND,25) JFOR (IFOR)
   25 FORMAT(T13,'FOREST CODE USED IN THIS PROJECTION IS  ',I4)
      GOTO 30
   20 CONTINUE
      IFOR=I
      IGL=KFOR(I)
   30 CONTINUE
      KODFOR=JFOR(IFOR)
      RETURN
      END
