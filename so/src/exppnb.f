      SUBROUTINE EXPPNB
      IMPLICIT NONE
C----------
C  **EXPPNB-SO  DATE OF LAST REVISION:  04/24/08
C----------
C
C     VARIANT DEPENDENT EXTERNAL REFERENCES FOR THE
C     PARALLEL PROCESSING EXTENSION.
C
      REAL BAB(9),BCF2,BLCF,BCCF,BDBL,BBAL,BREL,DBH,PCCFO,CCFO
      REAL BALO,XPPDDS,BX,XPPMLT
C
C
C     CALLED TO COMPUTE THE DDS MODIFIER THAT ACCOUNTS FOR THE DENSITY
C     OF NEIGHBORING STANDS (CALLED FROM DGF).
C
      ENTRY PPDGF (XPPDDS,BALO,CCFO,PCCFO,DBH,BREL,BBAL,BDBL,BCCF,
     &             BLCF,BCF2)
      RETURN
C
C     CALLED TO COMPUTE THE REGENT MULTIPLIER THAT ACCOUNTS FOR
C     THE DENSITY OF NEIGHBORING STANDS (CALLED FROM REGENT).
C
      ENTRY PPREGT (XPPMLT,BX,BAB,CCFO)
      RETURN
      END
