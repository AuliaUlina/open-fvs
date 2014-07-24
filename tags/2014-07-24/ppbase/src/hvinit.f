      SUBROUTINE HVINIT
      IMPLICIT NONE
C----------
C  **HVINIT DATE OF LAST REVISION:  07/31/08
C----------
C
C     CALLED FROM PPINIT.  INITIALIZE THE MULTISTAND POLICY VARIABLES
C
C     MULTISTAND POLICY ROUTINE - N.L. CROOKSTON  - JULY 1987
C     FORESTRY SCIENCES LABORATORY - MOSCOW, ID 83843
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
      INCLUDE 'PPHVCM.F77'
C
C
      INCLUDE 'HVDNCM.F77'
C
C
COMMONS
C
C
C
      INTEGER IHV
C
C
      LNEDNG=.FALSE.
      HXSIZE=1.0
      LHVDEB=.FALSE.
      LPRTCT=.TRUE.
      HVMXCC=40.
      LHVMXC=.FALSE.
      LHVUNT=.FALSE.
      LHIER =.FALSE.
      IXHRVP=0
      IHVEXT=0
      DO 10 IHV=1,MXHRVP
      HVPLAB(IHV)=' '
      LNHPLB(IHV,1)=0
      LNHPLB(IHV,2)=0
      IHVTAB(IHV,1)=0
      IHVTAB(IHV,2)=0
      IHVTAB(IHV,3)=0
      TRGSTS(8,IHV)=0.0
      JOHVDS(IHV)=0
   10 CONTINUE
      RETURN
      END
