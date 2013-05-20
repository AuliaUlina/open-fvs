      SUBROUTINE EXPPNB
      IMPLICIT NONE
C----------
C  **EXPPNB-CI  DATE OF LAST REVISION:  06/20/11
C----------
C
C     VARIANT DEPENDENT EXTERNAL REFERENCES FOR THE
C     PARALLEL PROCESSING EXTENSION
C
C----------
      REAL XPPDDS,BALO,CCFO,BAO,DBH,BCCF,BSBA,BDBL
      REAL XPPMLT,BRHT,BBAL
C----------
C     CALLED TO COMPUTE THE DDS MODIFIER THAT ACCOUNTS FOR THE DENSITY
C     OF NEIGHBORING STANDS (CALLED FROM DGF).
C----------
      ENTRY PPDGF (XPPDDS,BALO,CCFO,BAO,DBH,BCCF,BSBA,BDBL)
      RETURN
C----------
C     CALLED TO COMPUTE THE REGENT MULTIPLIER THAT ACCOUNTS FOR
C     THE DENSITY OF NEIGHBORING STANDS (CALLED FROM REGENT).
C----------
      ENTRY PPREGT (XPPMLT,BAO,BALO,BRHT,BSBA,BBAL)
      RETURN
C
      END
