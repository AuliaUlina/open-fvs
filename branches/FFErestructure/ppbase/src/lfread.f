      SUBROUTINE LFREAD(BUFFER,IPNT,ILIMIT,LVAR,ILEN,IBEGIN)
      IMPLICIT NONE
C----------
C  **LFREAD--PPBASE    DATE OF LAST REVISION:  07/31/08         
C----------
C
C     SEE BFREAD FOR A DESCRIPTION OF THIS ROUTINE
C
      LOGICAL LVAR(*),LSTOR
      REAL BUFFER(*),RSTOR
      INTEGER IBEGIN,ILEN,ILIMIT,IPNT,IWORD
      EQUIVALENCE (LSTOR,RSTOR)
      IF (IBEGIN.EQ.1) IPNT=ILIMIT
      IF (ILEN.LT.1) GOTO 1000
      DO 900 IWORD=1,ILEN
      IF (IPNT.LT.ILIMIT) GOTO 500
      CALL DSTASH (BUFFER,IPNT)
      IPNT=0
  500 CONTINUE
      IPNT=IPNT+1
      RSTOR=BUFFER(IPNT)
      LVAR(IWORD)=LSTOR
  900 CONTINUE
 1000 CONTINUE
      RETURN
      END
