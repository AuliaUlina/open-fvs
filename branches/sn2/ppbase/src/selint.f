      SUBROUTINE SELINT
      IMPLICIT NONE
C----------
C  **SELINT  DATE OF LAST REVISION:  07/31/08
C----------
C
C     INITIALIZE "SELECT" PROCESSING OPTIONS.
C
C     PART OF THE PARALLEL PROCESSING EXTENSION OF PROGNOSIS SYSTEM.
C     N.L. CROOKSTON--FORESTRY SCIENCES LAB, MOSCOW, ID--SEPT 1987
C
C     CALLED FROM PPINIT
C
COMMONS
C
C
      INCLUDE 'PRGPRM.F77'
C
C
      INCLUDE 'PPEPRM.F77'
C
C
      INCLUDE 'PPCNTL.F77'
C
C
COMMONS
C
      LNSHPL=0
      LNSSPL=0
      MGM1=NSET
      MGM2=NSET
      SID1=NOTSET
      SID2=NOTSET
      CSISN='-1'
      CLISN='-1'
      RETURN
      END
