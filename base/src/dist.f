      SUBROUTINE DIST(N,ATTR,PCTWK)
      IMPLICIT NONE
C----------
C  $Id$
C----------
C  THIS SUBROUTINE COMPUTES THE DIAMETERS CORRESPONDING TO THE
C  90, 70, 50, 30, AND 10 PERCENTILE POINTS IN THE DISTRIBUTION
C  OF A STAND ATTRIBUTE.  THESE DIAMETERS ARE LOADED INTO THE
C  FIRST 5 POSITIONS OF THE ARRAY ATTR.  THE SIXTH POSITION IN
C  ATTR IS LOADED WITH THE DIAMETER OF THE LARGEST TREE REPRESENTED
C  IN THE ATTRIBUTE.  IF THE VALUE OF IFST IS 1, INS IS LOADED
C  WITH SUBSCRIPTS TO TREE RECORDS TO BE PRINTED.  N IS THE CURRENT
C  LENGTH OF THE TREE RECORD LIST (ITRN).
C----------
COMMONS
C
C
      INCLUDE 'PRGPRM.F77'
C
C
      INCLUDE 'ARRAYS.F77'
C
C
      INCLUDE 'CONTRL.F77'
C
C
COMMONS
C----------
C  DIMENSIONS FOR INTERNAL VARIABLES.
C----------
      REAL ATTR(7),PCTWK(*)
      INTEGER N,N1,ITOP,I,J,IBOT,IPTR,MIDPTR,INDTOP
      REAL PCTAGE
C----------
C  IF THE TREE LIST IS NOT EMPTY, THEN:
C  BEGIN BINARY SEARCH FOR PERCENTILE POINTS.
C----------
      IF (ITRN.EQ.0) GOTO 60
      N1=N+1
      ITOP=1
      PCTAGE=90.0
      DO 50 I=1,5
      J=6-I
      IF(ITOP.EQ.N) GO TO 40
      IBOT=N1
   10 IPTR=(IBOT+ITOP)/2
      MIDPTR=IND(IPTR)
      IF(PCTWK(MIDPTR).LT.PCTAGE) GO TO 20
      ITOP=IPTR
      GO TO 30
   20 IBOT=IPTR
   30 IF(ITOP+1.LT.IBOT) GO TO 10
C----------
C  PERCENTILE POINT HAS BEEN LOCATED.
C----------
   40 CONTINUE
      INDTOP=IND(ITOP)
      ATTR(J)=DBH(INDTOP)
      IF(IFST.EQ.1) INS(J)=INDTOP
      PCTAGE=PCTAGE-20.0
   50 CONTINUE
C----------
C  ALL PERCENTILE POINTS HAVE BEEN LOCATED.  LOAD ATTR(6) AND
C  INS(6) (IF NECESSARY), AND RESET IFST.
C----------
      J=IND(1)
      ATTR(6)= DBH(J)
      IF (IFST.NE.1) RETURN
      INS(6)=J
      IFST=99
C
C     RESET TRM SO THE TREES/ACRE LISTED FOR EXAMPLE TREES ARE CORRECT.
C
      TRM=1.0
      RETURN
C-------
C  ZERO OUT THE DISTRIBUTION STATISTICS IF THE TREE LIST IS EMPTY
C-------
   60 CONTINUE
      DO 70 I=1,6
      ATTR(I)=0.
      INS(I)=0
   70 CONTINUE
      RETURN
      END
