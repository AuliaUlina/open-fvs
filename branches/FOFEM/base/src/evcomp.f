      SUBROUTINE EVCOMP (IRC,IREAD,JOSTND,RECORD,LDEBUG,IRECNT,LKECHO)
      IMPLICIT NONE
C----------
C  $Id$
C----------
C
C     CALLED FROM EVIF.  READS LOGICAL EXPRESSIONS AND CALLS
C     ALGCMP TO COMPILE THEM.
C
C     EVENT MONITOR ROUTINE - N.L. CROOKSTON  - APRIL 1987
C     FORESTRY SCIENCES LABORATORY - MOSCOW, ID 83843
C
C     IRC   = RETURN CODE: 0=OK,1=SOME ERROR.
C     IREAD = READER DATA SET REFERENCE NUMBER.
C     JOSTND= OUTPUT DATA SET REFERENCE NUMBER.
C     LDEBUG= DEBUG OUTPUT IS REQUESTED.
C     IRECNT= RECORD COUNTER.
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
C
      INTEGER IRECNT,JOSTND,IREAD,IRC,I,J,ISTLNB,I1,I2,II,IRTNCD
      LOGICAL LDEBUG,LKECHO
      CHARACTER*(*) RECORD
      INTEGER LENREC
      LENREC=LEN(RECORD)
C
C     READ THE LOGICAL EXPRESSION AND PLACE IT INTO THE CEXP ARRAY.
C
      I=1
      IF(LKECHO)WRITE(JOSTND,'(1X)')
    5 CONTINUE
      READ (IREAD,'(A)',END=50) RECORD
      IRECNT=IRECNT+1
      DO 10 J=1,LENREC
      CALL UPCASE(RECORD(J:J))
   10 CONTINUE
      IF(LKECHO)WRITE(JOSTND,'(T13,A)') RECORD(1:ISTLNB(RECORD))
      I1=I
      I2=I1+LENREC-1
      IF (I2.GT.MXEXPR) I2=MXEXPR
      II=0
      DO 15 J=I1,I2
      II=II+1
      CEXPRS(J)=RECORD(II:II)
   15 CONTINUE
C
C     IF II IS LESS THAN LENREC, AND CHARACTERS EXIST FROM II
C     TO LENREC, THEY WILL NOT BE SEEN BY THE PROGRAM.
C     ISSUE AN ERROR MESSAGE.
C
      IF (II.LT.LENREC) THEN
        IF (RECORD(II+1:LENREC).NE.' ') THEN
          WRITE (JOSTND,'(/T13,I2,'' CHARS IGNORED: '',A)')
     >         (LENREC-II),RECORD(II+1:LENREC)
          CALL RCDSET (2,.TRUE.)
        ENDIF
      ENDIF
C
C     CHECK FOR AMPERSANDS...IF THERE IS ONE, THEN BRANCH BACK AND
C     READ ANOTHER RECORD.
C
      DO 20 J=I1,I2
      IF (CEXPRS(J).NE.'&') GOTO 20
      I=J+1
      CEXPRS(J)=' '
      GOTO 5
   20 CONTINUE
C
C     FIND THE LAST NON-BLANK CHARACTER.
C
      I=0
      DO 30 J=1,I2
      I=I2-J+1
      IF (CEXPRS(I).NE.' ') GOTO 40
   30 CONTINUE
   40 CONTINUE
      IF (LDEBUG) WRITE (JOSTND,45) I,ICOD,IMPL
   45 FORMAT (' IN EVCOMP, LENGTH=',I4,'; ICOD=',I5,'; IMPL=',I5)
C
C     CALL ALGCMP TO COMPILE THE EXPRESSION.
C
      CALL ALGCMP (IRC,.TRUE.,CEXPRS,I,JOSTND,LDEBUG,1000,
     >   IPTODO,MXPTDO,IEVCOD,ICOD,MAXCOD,PARMS,IMPL,ITOPRM,MAXPRM)
C
C     SET ALL NON-ZERO RETURN CODES TO 1, ISSUE A GENERAL PURPOSE
C     ERROR MESSAGE, AND RETURN.
C
      IF (IRC.GT.0) THEN
         IRC=1
         CALL ERRGRO (.TRUE.,12)
      ENDIF
      RETURN
   50 CONTINUE
      CALL ERRGRO(.FALSE.,2)
      CALL fvsGetRtnCode(IRTNCD)
      IF (IRTNCD.NE.0) RETURN

      RETURN
      END
