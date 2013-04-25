      SUBROUTINE DFBPRB (PROTBK)
      IMPLICIT NONE
C----------
C  **DFBPRB  DATE OF LAST REVISION:  06/30/10
C----------
C
C  THIS ROUTINE IS USED TO CALCULATE THE PROBABILITY OF A STAND
C  OUTBREAK.
C
C  CALLED BY :
C     DFBGO  [DFB]
C
C  CALLS :
C     NONE
C
C  PARAMETERS :
C     PROTBK - THE PROBABILITY OF A DFB STAND OUTBREAK (OUTPUT).
C
C  COMMON BLOCK VARIABLES USED :
C     A45DBH - (DFBCOM)  INPUT
C     BA9    - (DFBCOM)  INPUT
C     BADF9  - (DFBCOM)  INPUT
C     DEBUIN - (DFBCOM)  INPUT
C     JODFB  - (DFBCOM)  INPUT
C     JOSTND - (CONTRL)  INPUT
C     PBADF4 - (DFBCOM)  INPUT
C
COMMONS
C
C
      INCLUDE 'PRGPRM.F77'
C
C
      INCLUDE 'CONTRL.F77'
C
C
      INCLUDE 'DFBCOM.F77'
C
C
COMMONS
C

      REAL PROTBK

C
C     CALCULATE THE PROBABILITY OF A STAND OUTBREAK OCCURING.
C
C     PROBABILITY IS EQUAL TO ZERO IF ANY OF THE MINIMUM CONDITIONS
C     ARE NOT PASSED.
C
      PROTBK = 0.0
      IF (A45DBH .LT. 9.0) GOTO 10
      IF (PBADF4 .LT. 0.25) GOTO 10

      PROTBK = BADF9 / BA9
      IF (PROTBK .GT. 0.9) PROTBK = 0.9

   10 CONTINUE
C
C     PRINT VARIABLES IF DEBUG IS USED.
C
      IF (DEBUIN) THEN
         WRITE (JOSTND,*) ' IN DFBPRB   *******************'
         WRITE (JOSTND,*) ' A45DBH = ', A45DBH
         WRITE (JOSTND,*) ' PBADF4 = ', PBADF4
         WRITE (JOSTND,*) ' BADF9  = ', BADF9
         WRITE (JOSTND,*) ' BA9    = ', BA9
         WRITE (JOSTND,*) ' PROTBK = ', PROTBK
         WRITE (JOSTND,*) ' LEAVING DFBPRB   **************'
      ENDIF

      RETURN
      END