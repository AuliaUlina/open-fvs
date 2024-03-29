      SUBROUTINE DBCHK (LDEBG,SUBIN,NC,ICYC)
      IMPLICIT NONE
C----------
C  $Id$
C----------
C
C     CALLED TO FIND OUT IF 'SUBIN' IS BEING DEBUGED DURING CYCLE
C     'ICYC'.  LDEBG IS RETURNED TRUE IF YES, FALSE OTHERWISE.  NC
C     IS THE NUMBER OF CHARACTER IN STRING SUBIN.
C
COMMONS
C
C
      INCLUDE 'DBSTK.F77'
C
C
COMMONS
C
C
      CHARACTER*(*) SUBIN
      INTEGER ICYC,NC
      LOGICAL LDEBG
C
      LDEBG=.FALSE.
      IF (ITOP.GT.0) THEN
        CALL DBSCAN (LDEBG,ALLSUB,6,0)
        IF (.NOT.LDEBG) CALL DBSCAN (LDEBG,ALLSUB,6,ICYC)
        IF (.NOT.LDEBG) CALL DBSCAN (LDEBG,SUBIN,NC,ICYC)
      ENDIF
      RETURN
      END
