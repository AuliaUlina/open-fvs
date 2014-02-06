      SUBROUTINE PPPDEN
      IMPLICIT NONE
C----------
C  **PPPDEN--BS DATE OF LAST REVISION:  07/31/08
C----------
C
C     MODIFIY THE POINT DENSITY STATISTICS FOR THE ESTAB
C     MODEL.  THIS IS FOR MODELING EFFECTS OF NEIGHBORING
C     DENSITY ON ESTAB.
C
C     PART OF THE PARALLEL PROCESSING EXTENSION OF PROGNOSIS SYSTEM.
C     N.L. CROOKSTON--FORESTRY SCIENCES LAB, MOSCOW, ID--NOV 1992
C
C     CALLED FROM: GRADD.
C
COMMONS
C
C
      INCLUDE 'PRGPRM.F77'
C
C
      INCLUDE 'PLOT.F77'
C
C
      INCLUDE 'PDEN.F77'
C
C
      INCLUDE 'PPDNCM.F77'
C
C
COMMONS
C
C
      INTEGER IP
C
C     IF THE DENSITY EFFECTS ARE NOT BEING INCLUDED IN THIS
C     SUMULATION, THEN RETURN.
C
      IF (.NOT.LNEDNS) RETURN
C
C     ADD THE NEIGHBOR DENSITY TO THE POINT DENSITY.
C     DO THE SAME FOR CCF.
C
      DO 10 IP=1,IPTINV
      BAAA(IP)=BAAA(IP)+PDBAN
      PCCF(IP)=PCCF(IP)+PDCCFN
   10 CONTINUE
      RETURN
      END