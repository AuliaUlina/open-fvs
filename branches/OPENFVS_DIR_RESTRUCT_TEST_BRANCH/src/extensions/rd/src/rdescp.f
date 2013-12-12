      SUBROUTINE RDESCP (LMAXTR,MXRR)
C----------
C  **RDESCP      LAST REVISION:  04/28/93
C----------
C
C  THIS ROOT DISEASE MODEL SUBROUTINE INSURES THAT THERE IS ROOM
C  IN THE TREELIST FOR ESTAB TREES.
C
C  CALLED BY :
C     ESTAB   [PROGNOSIS]
C
C  PARAMETERS :
C     LMAXTR - MAXIMUM NUMBER OF PROGNOSIS MODEL TREE RECORDS
C              (NAME CHANGED TO AVOID CONFLICT WITH MAXTRE IN
C               PRGPRM FILE.)
C     MXRR   - MAXIMUM NUMBER OF RROT TREE RECORDS
C
C
COMMONS
C
C
      INCLUDE  'PRGPRM.F77'
      INCLUDE  'RDPARM.F77'
      INCLUDE  'RDCOM.F77'
C
C
COMMONS
C

      TPAREA = 0.0
      DO 100 IDI=1,ITOTRR
         TPAREA = TPAREA + PAREA(IDI)
  100 CONTINUE       

      IF (IROOT .EQ. 0 .OR. TPAREA .EQ. 0.0) THEN
         MXRR = LMAXTR
      ELSE
         MXRR = 500
      ENDIF

      RETURN
      END   