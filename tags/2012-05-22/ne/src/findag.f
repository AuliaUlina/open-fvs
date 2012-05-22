      SUBROUTINE FINDAG(I,ISPC,D1,D2,H,SITAGE,SITHT,AGMAX,HTMAX1,HTMAX2,
     &                  DEBUG)
      IMPLICIT NONE
C----------
C  **FINDAG--NE  DATE OF LAST REVISION:  01/14/11
C----------
C  THIS ROUTINE FINDS EFFECTIVE TREE AGE
C  CALLED FROM **COMCUP
C  CALLED FROM **CRATET
C----------
C  COMMONS
C
C
      INCLUDE 'PRGPRM.F77'
C
C
      INCLUDE 'CONTRL.F77'
C
C
      INCLUDE 'ARRAYS.F77'
C
C
      INCLUDE 'PLOT.F77'
C
C  COMMONS
C----------
C  DECLARATIONS
C----------
      LOGICAL DEBUG
      INTEGER I,ISPC,MODE0,IVAR
      REAL D1,D2,SITAGE,SITHT,AGMAX,HTMAX1,HTMAX2
      REAL HTG1,H,YRS,HTMAX,AGET
C
      HTG1=0.
C----------
C   CALL HTCALC TO CALCULATE AGE BASED ON INITIAL TREE HEIGHT
C----------
      MODE0= 0
      IVAR=3
      YRS=10.
      CALL HTCALC (MODE0,IVAR,ISPC,SITEAR(ISPC),YRS,H,AGET,HTMAX,
     &             HTG1,JOSTND,DEBUG)
C----------
C  IF H >= HTMAX THEN CALCULATE AGE BASED ON HTMAX - 1. FT.
C  THE FORMULA FOR AGE IS UNSTABLE FOR HEIGHTS >= HTMAX.
C----------
      IF (HTMAX-H.LE.1.) THEN
        H = HTMAX - 1.1
        CALL HTCALC (MODE0,IVAR,ISPC,SITEAR(ISPC),YRS,H,AGET,HTMAX,
     &               HTG1,JOSTND,DEBUG)
      ENDIF
C
      SITAGE = AGET
C
        IF(DEBUG)WRITE(JOSTND,91200)I,ISPC,AGET,H
91200   FORMAT(' FINDAG - I,ISPC,AGE,H ',2I5,2F10.2)
C
      IF(DEBUG)WRITE(JOSTND,50)
   50 FORMAT(' LEAVING SUBROUTINE FINDAG')
C
      RETURN
      END
C**END OF CODE SEGMENT