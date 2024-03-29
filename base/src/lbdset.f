      SUBROUTINE LBDSET (JOSTND,LKECHO)
      IMPLICIT NONE
C----------
C  $Id$
C----------
C
C     CREATE DEFAULT A LABEL SET FOR THE STAND AND WRITE IT TO THE
C     OPTIONS SELECTED BY DEFAULT TABLE.  ASSIGN THE STAND LABEL SET
C     TO ALL ACTIVITY GROUPS FOR WHICH NO ACTIVITY GROUP LABEL SET
C     HAS BEEN SPECIFIED.
C
C     PART OF THE LABEL PROCESSING COMPONENT OF THE PROGNOSIS SYSTEM
C     N.L. CROOKSTON -- INTERMOUNTAIN RESEARCH STATION -- JAN 1987
C
C     JOSTND= PRINT MESSAGE FILE.
C
COMMONS
C
C
      INCLUDE 'PRGPRM.F77'
C
C
      INCLUDE 'OPCOM.F77'
C
C
COMMONS
      LOGICAL LKECHO
      INTEGER JOSTND,NGRPS,I,KODE,LWRK,I1,I2,J
C
C     IF LABEL PROCESSING HAS NOT BEEN ACTIVIATED, BRANCH TO EXIT.
C
      IF (.NOT.LBSETS) GOTO 80
C
C     IF NO STAND LABEL SET KEYWORD HAS BEEN READ (LENSLS=-1) THEN
C     CREATE THE DEFAULT STAND LABEL SET BY TAKING THE UNION OVER
C     ALL OF THE ACTIVITY GROUP LABELS.
C
      NGRPS=IEVA-1
      IF (LENSLS.EQ.-1) THEN
         IF (NGRPS.GT.0) THEN
            DO 20 I=1,NGRPS
            CALL LBUNIN (LENSLS,SLSET,LENAGL(I),AGLSET(I),LWRK,WKSTR1,
     >                   KODE)
            IF (KODE.GT.0) THEN
               WRITE (JOSTND,10) AGLSET(I)(1:LENAGL(I))
   10          FORMAT (/'********   ERROR:  DEFAULT STAND LABEL ',
     >               'SET IS TOO LONG.  THE FOLLOWING ACTIVITY GROUP ',
     >               'IS NOT INCLUDED.'/'ACTIVITY LABEL:  ',A)
               CALL RCDSET (2,.TRUE.)
            ENDIF
            SLSET=WKSTR1
            LENSLS=LWRK
   20       CONTINUE
C
C           IF THE STAND LABEL SET IS NOW EMPTY, TURN OFF LABEL
C           PROCESSING.
C
            IF (SLSET.EQ.' ') THEN
               LBSETS=.FALSE.
               LENSLS=-1
               GOTO 80
            ENDIF
         ENDIF
C
C        WRITE THE DEFAULT STAND LABEL SET.
C
         IF(LKECHO)WRITE(JOSTND,30) 
 30      FORMAT (/'SPLABEL',T12,'STAND POLICY LABEL SET: ')
         I1=1
         I2=100
 40      CONTINUE
         IF (I2.GT.LENSLS) I2=LENSLS
         IF(LKECHO)WRITE(JOSTND,'(T12,A)') SLSET(I1:I2)
         IF (I2.LT.LENSLS) THEN
            I1=I2+1
            I2=I2+100
            GOTO 40
         ENDIF
      ENDIF
C
C     PASS THROUGH THE ACTIVITIES.  IF ANY ACTIVITY GROUP HAS NO
C     LABEL, GIVE IT THE STAND LABEL SET AS A DEFAULT.
C
      J=0
      DO 50 I=1,NGRPS
      IF (LENAGL(I).LE.0) THEN
         J=J+1
         LENAGL(I)=LENSLS
         AGLSET(I)=SLSET
      ENDIF
   50 CONTINUE
      IF (J.GT.0) WRITE (JOSTND,60) J
   60 FORMAT (/'********   WARNING: ',I2,' ACTIVITY GROUP(S) HAD ',
     >        'NO LABEL AND WERE ASSIGNED THE STAND POLICY ',
     >        'LABEL SET.')
   80 CONTINUE
      RETURN
      END
