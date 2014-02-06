      SUBROUTINE COMP(CMP,ICMP,ATTR)
      IMPLICIT NONE
C----------
C  **COMP   DATE OF LAST REVISION:  07/23/08
C----------
C  THIS SUBROUTINE COMPUTES THE PERCENTAGE OF A GIVEN STAND
C  ATTRIBUTE IN EACH SPECIES-TREE CLASS.  IT THEN LOADS CMP
C  WITH THE FOUR LARGEST CLASSES AND LOADS ICMP WITH
C  CORRESPONDING SPECIES-TREE CLASS LABELS.
C----------
C
COMMONS
C
C
      INCLUDE 'PRGPRM.F77'
C
C
      INCLUDE 'CONTRL.F77'
C
C
      INCLUDE 'PLOT.F77'
C
C
COMMONS
C
      INTEGER MXSP3
      PARAMETER (MXSP3=MAXSP*3)
      INTEGER J,I1,I2,I,ISPC,JMC,K
      REAL WORK1(MXSP3),WORK2(MXSP3),ATTR(MAXSP,3),CMP(4),TTT
C
C----------
C  TYPE DECLARATIONS FOR INTERNAL VARIABLES.
C----------
      CHARACTER*3 ICMP(4),NS
      INTEGER IDS(MXSP3)
C----------
C  DATA STATEMENTS AND INITIALIZATIONS.
C----------
      DATA NS/'---'/
      IF (ITRN.LE.0) GOTO 30
      J=0
      DO 10 I1=1,MAXSP
      DO 10 I2=1,3
      J=J+1
      WORK1(J)=ATTR(I1,I2)
   10 CONTINUE
C----------
C  SORT THE ATTRIBUTE ARRAY IN DESCENDING ORDER.
C----------
      CALL RDPSRT(MXSP3,WORK1,IDS,.TRUE.)
C----------
C  COMPUTE THE PERCENTAGE OF THE ATTRIBUTE IN EACH SPECIES-TREE
C  CLASS.
C----------
      CALL PCTILE(MXSP3,IDS,WORK1,WORK2,TTT)
C----------
C  FIND INDEX FOR SPECIES-TREE CLASS AND LOAD CMP AND ICMP.
C  ISPC REFERENCES SPECIES, AND JMC REFERENCES TREE CLASS.
C----------
      DO 20 I=1,4
      J=IDS(I)
      ISPC=(J+2)/3
      JMC=MOD(J,3)
      IF(JMC.EQ.0) JMC=3
      K=IDS(I+1)
      CMP(I)=WORK2(J)-WORK2(K)
      ICMP(I)=NSP(ISPC,JMC)
      IF(CMP(I).LE.0.0) ICMP(I)=NS
   20 CONTINUE
      RETURN
   30 CONTINUE
C-------
C  BRANCH HERE IF THERE ARE NO TREE RECORDS
C-------
      DO 40 I=1,4
      CMP(I)=0.
      ICMP(I)=NS
   40 CONTINUE
      RETURN
      END