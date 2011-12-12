      SUBROUTINE OPSORT(N,A,A2,INDEX,LSEQ)
      IMPLICIT NONE
C----------
C  **OPSORT DATE OF LAST REVISION:  07/23/08
C----------
C----------
C  OPSORT IS A INTEGER ASCENDING IDENTIFICATION SORT OVER TWO FIELDS.
C
C       SCOWEN, R.A. 1965. ALGORITHM 271; QUICKERSORT. COMM ACM.
C                    8(11) 669-670.
C
      LOGICAL LSEQ
      INTEGER A(*),T,A2(*),T2
      INTEGER INDEX(*)
      INTEGER IPUSH(33)
      INTEGER N,I,ITOP,IL,IU,INDIL,INDIU,IP,INDIP,KL,KU,INDKL,INDKU
      INTEGER JL,JU
C----------
C  IF LSEQ IS FALSE, ASSUME THAT A IS PARTIALLY
C  SORTED.  OTHERWISE, LOAD INDEX WITH VALUES FROM 1 TO N.
C----------
      IF(.NOT.LSEQ) GO TO 20
      DO 10 I=1,N
   10 INDEX(I)=I
   20 CONTINUE
C----------
C  RETURN IF FEWER THAN TWO ELEMENTS IN ARRAY A.
C----------
      IF(N.LT.2) RETURN
C----------
C  SORT:
C----------
      ITOP=0
      IL=1
      IU=N
   30 CONTINUE
      IF(IU.LE.IL) GO TO 40
      INDIL=INDEX(IL)
      INDIU=INDEX(IU)
      IF(IU.GT.IL+1) GO TO 50
      IF(A(INDIL).LT.A(INDIU)) GO TO 40
      IF ((A(INDIL).EQ.A(INDIU)).AND.(A2(INDIL).LE.A2(INDIU))) GOTO 40
      INDEX(IL)=INDIU
      INDEX(IU)=INDIL
   40 CONTINUE
      IF(ITOP.EQ.0) RETURN
      IL=IPUSH(ITOP-1)
      IU=IPUSH(ITOP)
      ITOP=ITOP-2
      GO TO 30
   50 CONTINUE
      IP=(IL+IU)/2
      INDIP=INDEX(IP)
      T=A(INDIP)
      T2=A2(INDIP)
      INDEX(IP)=INDIL
      KL=IL
      KU=IU
   60 CONTINUE
      KL=KL+1
      IF(KL.GT.KU) GO TO 90
      INDKL=INDEX(KL)
      IF(A(INDKL).LT.T) GO TO 60
      IF ((A(INDKL).EQ.T).AND.(A2(INDKL).LE.T2)) GOTO 60
   70 CONTINUE
      INDKU=INDEX(KU)
      IF(KU.LT.KL) GO TO 100
      IF(A(INDKU).LT.T) GO TO 80
      IF ((A(INDKU).EQ.T).AND.(A2(INDKU).LT.T2)) GOTO 80
      KU=KU-1
      GO TO 70
   80 CONTINUE
      INDEX(KL)=INDKU
      INDEX(KU)=INDKL
      KU=KU-1
      GO TO 60
   90 CONTINUE
      INDKU=INDEX(KU)
  100 CONTINUE
      INDEX(IL)=INDKU
      INDEX(KU)=INDIP
      IF(KU.LE.IP) GO TO 110
      JL=IL
      JU=KU-1
      IL=KU+1
      GO TO 120
  110 CONTINUE
      JL=KU+1
      JU=IU
      IU=KU-1
  120 CONTINUE
      ITOP=ITOP+2
      IPUSH(ITOP-1)=JL
      IPUSH(ITOP)=JU
      GO TO 30
      END
