      SUBROUTINE PPDGF (XPPDDS,BALO,CCFO,DBH,BCCF,BBAL,BDBL)
      IMPLICIT NONE
C----------
C  **PPDGF--NI  DATE OF LAST REVISION:  09/18/08
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
C     CALLED FROM: DGF.
C
COMMONS
C
C
      INCLUDE 'PPDNCM.F77'
C
C
COMMON
C
C
      REAL XPPDDS,BALO,CCFO,DBH,BCCF,BBAL,BDBL,D
C
C
C     IF THE NEIGHBOR DENSITY EFFECTS ARE BEING INCLUDED, THEN
C     CALCULATE THEM, OTHERWISE, RETURN.
C
C     NOTE THAT PDBAN IS IN SQ FT/ACRE AND BALO IS IN 100THS OF
C     SQ FT/ACRE.  CCF IS IN IT'S NATURAL UNITS.
C     DON'T LET THE FUNCTION BE USED FOR DBH < 1.0 (IT'S TOO HARSH).
C
      IF (LNEDNS) THEN
         D=AMAX1(1.0,DBH)+1
         XPPDDS= BBAL*(AMAX1(0.0,(PDBAN*.01)-BALO))             +
     >           BDBL*(AMAX1(0.0,(PDBAN*.01)-BALO)/ALOG(D)) +
     >           BCCF*(AMAX1(0.0,PDCCFN-CCFO))
      ENDIF
      RETURN
      END
