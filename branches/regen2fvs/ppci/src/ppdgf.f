      SUBROUTINE PPDGF (XPPDDS,BALO,CCFO,BAO,DBH,BCCF,BSBA,BDBL)
      IMPLICIT NONE
C----------
C  **PPDGF--CI  DATE OF LAST REVISION:  09/18/08
C----------
C
C     IF ARGUMENT LIST CHANGES, ALSO CHANGE EXPPNB ROUTINE
C
C     COMPUTE THE DDS MODIFIER THAT ACCOUNTS FOR THE DENSITY
C     OF NEIGHBORING STANDS.
C
C     PART OF THE PARALLEL PROCESSING EXTENSION OF PROGNOSIS SYSTEM.
C     N.L. CROOKSTON--FORESTRY SCIENCES LAB, MOSCOW, ID--NOV 1992
C
C     MODIFIED FOR CENTRAL IDAHO BY  GARY DIXON -- FT COLLINS, CO
C                                    FOREST MANAGEMENT SERVICE CENTER
C     CALLED FROM: DGF.
C
COMMONS
C
C
      INCLUDE 'PPDNCM.F77'
C
C
COMMON
C----------
C     IF THE NEIGHBOR DENSITY EFFECTS ARE BEING INCLUDED, THEN
C     CALCULATE THEM, OTHERWISE, RETURN.
C
C     NOTE:  PDBAN IS IN SQ FT/ACRE
C            CCF IS IN IT'S NATURAL UNITS.
C     DON'T LET THE FUNCTION BE USED FOR DBH < 1.0 (IT'S TOO HARSH).
C
C  FIRST TERM IS TOTAL STAND BA
C  SECOND TERM IS BAL
C    NOTE: ASSUME ADDITIONAL STAND BA WILL BE IN BIGGER TREES
C  THIRD TERM IS CCF
C
C
      REAL BDBL,BSBA,BCCF,DBH,BAO,CCFO,BALO,XPPDDS,D
C
C
C----------
      IF (LNEDNS) THEN
         D=AMAX1(1.0,DBH)+1
         XPPDDS= BSBA*(AMAX1(0.0,PDBAN-BAO))            +
     >           BDBL*(AMAX1(0.0,PDBAN-BALO)/ALOG(D))   +
     >           BCCF*(AMAX1(0.0,PDCCFN-CCFO))
      ENDIF
      RETURN
      END