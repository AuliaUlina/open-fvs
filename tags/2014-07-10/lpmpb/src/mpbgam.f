      DOUBLE PRECISION FUNCTION MPBGAM (XX)
      IMPLICIT NONE
C----------
C  **MPBGAM        DATE OF LAST REVISION:  06/14/13
C----------
C
C   THIS SUBROUTINE COMPUTES THE DOUBLE PRECISION GAMMA FUNCTION
C   OF A GIVE DOUBLE PRECISION ARGUMENT. THIS CODE WAS TAKEN FROM
C   IBM SYSTEM/360 SCIENTIFIC SUBROUTINE PACKAGE VERSION III, FIFTH
C   EDITION, AUG 1970. PP. 361-362.
C
C
C Revision History
C   05/27/88 Last noted revision date.
C   07/02/10 Lance R. David (FMSC)
C     Added IMPLICIT NONE.
C----------
C
      INTEGER IER
      DOUBLE PRECISION XX,ZZ,TERM,RZ2,DLGAM
C
C
      IER=0
C     WRITE(16,888) XX
 888  FORMAT('XX=',D16.8)
      ZZ=XX
      IF(XX-1.D10) 2,2,1
  1   IF(XX-1.D70) 8,9,9
C
C  SEE IF XX IS NEAR ZERO OR NEGATIVE
C
  2   IF(XX-1.D-9) 3,3,4
  3   IER=-1
      DLGAM=-1.D75
      GO TO 10
C
C  XX GREATER THAN ZERO AND LESS THAN OR EQUAL TO  1.D10
C
  4   TERM=1.D0
  5   IF(ZZ-18.D0) 6,6,7
  6   TERM=TERM*ZZ
      ZZ=ZZ+1.D0
      GO TO 5
  7   RZ2=1.D0/ZZ**2
      DLGAM=(ZZ-0.5D0)*DLOG(ZZ)-ZZ+0.9189385332046727-DLOG(TERM)+
     >     (1.D0/ZZ)*(0.8333333333333333D-1 -(RZ2*(0.2777777777777777D-2
     >     +(RZ2*(0.7936507936507936D-3 -(RZ2*(0.5952380952380952D-3
     >     )))))))
      GO TO 10
C
C  XX GREATER THAN 1.D10 AND LESS THAN 1.D70
C
   8  DLGAM=ZZ*(DLOG(ZZ)-1.D0)
      GO TO 10
C
C  XX GREATER THAN OR EQUAL TO 1.D70
C
   9  IER=1
      DLGAM=1.D75
  10  CONTINUE
C     WRITE(16,777) DLGAM
 777  FORMAT('DLGAM=',D16.8)
      MPBGAM=DEXP(DLGAM)
C     WRITE(16,333) MPBGAM
 333  FORMAT('MPBGAM=',D16.8)
      RETURN
      END
