      SUBROUTINE IFREAD(BUFFER,IPNT,ILIMIT,IVAR,ILEN,IBEGIN)
      IMPLICIT NONE
C----------
C  **IFREAD--PPBASE   DATE OF LAST REVISION:  07/31/08         
C----------
C
C     THIS ROUTINE IS LIKE BFREAD, SEE BFREAD FOR A DESCRIPTION.
C
      REAL BUFFER(*)
      INTEGER IVAR(*)
      INTEGER IBEGIN,ILEN,ILIMIT,IPNT,IWORD
      REAL RSTOR
      INTEGER*4 ISTOR
      EQUIVALENCE (RSTOR,ISTOR)
      IF (IBEGIN.EQ.1) IPNT=ILIMIT
      IF (ILEN.LT.1) GOTO 1000
      DO 900 IWORD=1,ILEN
      IF (IPNT.LT.ILIMIT) GOTO 500
      CALL DSTASH (BUFFER,IPNT)
      IPNT=0
  500 CONTINUE
      IPNT=IPNT+1
      RSTOR=BUFFER(IPNT)
      IVAR(IWORD)=ISTOR
  900 CONTINUE
 1000 CONTINUE
      RETURN
      END