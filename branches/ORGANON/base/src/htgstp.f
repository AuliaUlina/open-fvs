      SUBROUTINE HTGSTP
      IMPLICIT NONE
C----------
C  $Id$
C----------
C
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
C
      EXTERNAL RANN
      INTEGER MYACT(2)
      INTEGER NEW,IOD,ITRC1,ITRC2,I,K,IG,IULIM,IGRP,I1,I2,IS,IS1,IS2
      INTEGER ISPC,IDT,IACT,NP,ITODO,NTODO
      REAL STDPBR,AVEPRB,PRB,HT1,HT2,H,BRK,BRATIO,X,PKIL,BACHLO
      REAL TOPK,TOPH,D,AF,DTK,CN
      EQUIVALENCE (WK6(2),HT1),(WK6(3),HT2),(WK6(4),PRB),
     >            (WK6(5),AVEPRB),(WK6(6),STDPBR)
      DATA MYACT/110,111/
C
C     FIND OPTIONS
C
      CALL OPFIND(2,MYACT,NTODO)
      IF (NTODO .EQ. 0) RETURN
C
C     ENTER LOOP TO PROCESS ALL OPTIONS SPECIFIED.
C
      DO 200 ITODO=1,NTODO
      CALL OPGET(ITODO,6,IDT,IACT,NP,WK6)
      IF (IACT.LT.0) GOTO 200
      CALL OPDONE (ITODO,IY(ICYC))
C
C     LOAD PARAMETERS.  NOTE THAT SEVERAL PARAMETERS ARE EQUIVALENCED
C     TO WK6 THUS THEY ARE LOADED AUTOMATICALLY.
C
      ISPC=IFIX(WK6(1))
C
C     SET INDICIES TO SPECIES COUNTERS.
C
      IF (ISPC.LE.0) GOTO 10
      IS1=ISPC
      IS2=ISPC
      GOTO 20
   10 CONTINUE
      IS1=1
      IS2=MAXSP
   20 CONTINUE
C
C     ENTER SPECIES LOOP
C
      DO 110 IS=IS1,IS2
      I1=ISCT(IS,1)
C
C     IF THERE ARE NO TREES OF THIS SPECIES, THEN BRANCH.
C
      IF (I1.LE.0) GOTO 110
C
C     LOAD TREE INDEX.
C
      I2=ISCT(IS,2)
C----------
C  IF PROCESSING A SPECIES GROUP AND THIS SPECIES IS NOT IN THE GROUP,
C  THEN SKIP THIS SPECIES.
C----------
      IF(ISPC .LT. 0)THEN
        IGRP = -ISPC
        IULIM = ISPGRP(IGRP,1)+1
        DO 90 IG=2,IULIM
        IF(IS .EQ. ISPGRP(IGRP,IG))GO TO 91
   90   CONTINUE
        GO TO 110
   91   CONTINUE
      ENDIF
C
C     ENTER TREE LOOP
C
      DO 100 K=I1,I2
      I=IND1(K)
C
C     LOAD HEIGHT AND CHECK HEIGHT RANGE.  IF OUT-OF-RANGE, THEN SKIP
C     TREE RECORD.
C
      H=HT(I)
      BRK=BRATIO(IS,DBH(I),H)
      IF (H.LE.HT1 .OR. H.GT.HT2) GOTO 100
C
C     IF A RANDOM NUMBER IS GREATER THAN THE PROBABILITY OF DAMAGE,
C     THEN: THE TREE ESCAPES.
C
      IF (PRB.GT. 0.99999) GOTO 30
      CALL RANN(X)
      IF (X.GT.PRB) GOTO 100
C
C     ELSE: THE TREE WILL BE DAMAGED.
C
   30 CONTINUE
C
C     COMPUTE PROPORTION REDUCTION IN HEIGHT OR HIEGHT GROWTH.
C
      PKIL=BACHLO(AVEPRB,STDPBR,RANN)
      IF (PKIL.LE.0.0) GOTO 100
C
C     IF SIMULATING HTGSTOP.
C
      IF (IACT.EQ.110) THEN
C
C        SET THE HEIGHT GROWTH AND BIRTH YEAR.
C
         IF (PKIL.GE.1.0) PKIL=1.0
         HTG(I)=HTG(I)*PKIL
         ABIRTH(I)=0.0
         GOTO 100
      ENDIF
      IF (PKIL.GT.0.8) PKIL=.8
C
C     COMPUTE ABSOLUTE NUMBER OF FEET TOP-KILLED.
C
      TOPK=H*PKIL
      TOPH=H-TOPK
      ITRC2=IFIX(TOPH*100.+.5)
C
C     IF THE TREE IS NOT ALREADY TOPKILLED, THEN: BRANCH TO TOPKILL.
C
      ITRC1=ITRUNC(I)
      IF (ITRC1.LE.0) GOTO 40
C
C     IF THE NEW POINT IS BELOW THE POINT OF TRUNCATION, THEN:
C     REDUCE THE POINT OF TRUNCATION.
C
      IF (ITRC1.GT.ITRC2) ITRUNC(I)=ITRC2
      HT(I)=TOPH
      GOTO 100
   40 CONTINUE
C
C     ELSE: THE TREE HAS NOT BEEN TOP KILLED.  IF THE HEIGHT IS LESS
C     THAN 25 OR THE DBH IS LESS THAN 6, THEN:  THE TREE WILL BE
C     TEMPORARILY KILLED.
C
      D=DBH(I)*BRK
      IF (H.LT. 25 .OR. D.LT.6.0) GOTO 60
C
C     ELSE:
C     IF THE DIAMETER AT THE POINT OF TOPKILL IS LESS THAN A CRITICAL
C     VALUE, THEN TEMPORARILY TOPKILL THE TREE.
C     COMPUTE THE DIAMETER AT POINT OF TOPKILL USING THE BEHRE HYPER-
C     BOLOID (MONSERUD 1981 FOREST SCI. 27:253/265.)
C
      AF=CFV(I)/(.00545415*D*D*H)
      AF=.44244-(.99167/AF)-(1.43237*ALOG(AF))+(1.68581*SQRT(AF))
     >   -(.13611*AF*AF)
      DTK=TOPK/H
      DTK=(DTK/((AF*DTK)+(1-AF)))*D
      IF (DTK.LT. 4.0) GOTO 60
C
C     PERMANENTLY TOPKILL THE TREE.
C
      ITRUNC(I)=ITRC2
      NORMHT(I)=IFIX(H*100.+.5)
C
C     SET THE MANAGEMENT CODE FOR PERMANENTLY TOPKILLED TREES
C     EQUAL TO 3
C
      IMC(I)=3
   60 CONTINUE
      HT(I)=TOPH
C
C     IF THE CROWN RATIO HAS NOT BEEN ADJUSTED BY THE BUG MODELS
C     (THE CROWN RATIO IS NEG IF CROWN HAS BEEN ADJUSTED BY BUG MODELS),
C     THEN: REDUCE THE CROWN RATIO TO ACCOUNT FOR THE DAMAGE.
C
      IOD=ICR(I)
      IF (IOD.LT.0) GOTO 100
      CN=(IOD/100.*H)-H+TOPH
      NEW=IFIX(CN/TOPH*100.+.5)
C
C     TOPKILL WILL NOT REDUCE THE CROWN RATIO TO LESS THAN 5 PERCENT.
C
      IF (NEW.LT.5) NEW=5
      ICR(I)=-NEW
C
C     MAKE SURE THAT THE MANAGEMENT CODE FOR TOP DAMAGED TREES
C     IS GREATER THAN 1 (WHICH IS A LOWER SCORE THUS NORMALLY
C     INDICATING HIGHER PRIORITY FOR CUTTING).
C
      IF (IMC(I).EQ.1) IMC(I)=2
  100 CONTINUE
  110 CONTINUE
  200 CONTINUE
      RETURN
      END
