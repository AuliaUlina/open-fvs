      SUBROUTINE ALINIT
      IMPLICIT NONE
C----------
C  **ALINIT  DATE OF LAST REVISION:  07/31/08
C----------
C
C     INITIALIZE THE ALL-STAND PROCESSING LOGIC.
C
C     PART OF THE PARALLEL PROCESSING EXTENSION OF PROGNOSIS SYSTEM.
C     N.L. CROOKSTON--FORESTRY SCIENCES LAB, MOSCOW, ID--JULY 1982
C
C     CALLED FROM: PPMAIN
C
C     CLOSE GLOBAL ACTIVITIES.
C
      CALL GPCLOS (0)
C
C     CHANGE DATE FIELDS THAT ARE CODED WITH MASTER CYCLES TO DATES
C
      CALL GPCSET
      RETURN
      END