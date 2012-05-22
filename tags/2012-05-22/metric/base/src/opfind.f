      SUBROUTINE OPFIND (NMYA,MYACTS,NTODO)
      IMPLICIT NONE
C----------
C  **OPFIND--BASE/M DATE OF LAST REVISION:  07/23/08
C----------
C
C     OPTION PROCESSING ROUTINE - NL CROOKSTON - JAN 1981 - MOSCOW
C
C     OPFIND FINDS THE NUMBER OF (NTODO) ACTIVITIES THAT THE CALLING
C     ROUTINE IS CAPABLE OF DOING IN THE LIST OF ACTIVITIES THAT ARE
C     TO BE DONE DURING THE CURRENT CYCLE.
C
C     NMYA  = THE NUMBER OF ACTIVITIES THE CALLING ROUTINE IS CAPABLE
C             OF ACCOMPLISHING (DIMENSION OF MYACTS).
C     MYACTS= THE LIST OF ACTIVITIES IN ASCENDING ORDER.
C     NTODO = THE NUMBER OF ACTIVITIES WHICH ARE TO BE DONE THIS
C             CYCLE.
C
COMMONS
C
C
      INCLUDE 'PRGPRM.F77'
      INCLUDE 'OPCOM.F77'
      INCLUDE 'METRIC.F77'
C
C
COMMONS
C
      REAL PRMS(*)
      INTEGER MYACTS(*)
      INTEGER NTODO,NMYA,NPRMS,IACTK,IDT,MXPM,ITODO1,IREFN,IRC,J1,J2,J
      INTEGER ITODO5,ILEN,I,NPRMS1,ITODO2,IDT4,ITODO3,ITODO4,ISQNUM
      INTEGER IYR2,IYR1,I2,II,I3,IDT3
      CHARACTER*(*) STR
      
      INTEGER IX
C
C     ARRAY OF CONVERSION FACTORS TO GIVE PRMS ARRAY IN THE 
C     USER'S CHOICE OF UNITS: VECTOR OF 1'S BY DEFAULT
C
      REAL XMLT(N_METRIC_PRMS)
C
C     FIND THE ACTIVITIES.  STORE A LIST OF POINTERS TO THE
C     ACTIVITIES IN THE ARRAY IPTODO.
C
      CALL OPMERG (NMYA,MYACTS,NTODO)
      KTODO=NTODO
      RETURN
C
C
      ENTRY OPGET (ITODO1,MXPM,IDT,IACTK,NPRMS,PRMS)
C
C     OPGET GETS THE "ITH" ACTIVITY OF THE NUMBER OF ACTIVITIES
C     TO DO (NTODO) WHICH ARE FOUND BY CALLING OPFIND.
C
C     ITODO1= WHICH OF THE NUMBER TO DO THE USER WANTS RETURNED.
C             FOR EXAMPLE: IF NTODO=6 AND THE ROUTINE CALLING OPGET
C             WANTS THE 5TH OF THE 6 ACTIVITIES, THEN I IS SET EQUAL
C             TO 5.
C     MXPM  = THE DIMENSION OF PRMS; THE MAXIMUM NUMBER OF PARMS
C             WHICH CAN BE RETURNED TO THE CALLING ROUTINE.
C     IDT   = THE DATE THE OPTION IS SCHEDULED TO OCCUR.
C     IACTK = RETURN THE ACTUAL ACTIVITY KODE; OR:
C             -1 IF I IS GREATER THAN THE NUMBER TO DO, OR
C             -ACTUAL ACTIVITY CODE IF THE ACTIVITIY WAS FLAGED AS
C             DELETED OR ACCOMPLISHED BETWEEN THIS CALL TO OPGET AND THE
C             LAST CALL TO OPFIND.  ACTIVITIES DELETED AT OTHER TIMES
C             WILL NOT BE "FOUND" BY OPFIND.
C     NPRMS = THE ACTUAL NUMBER OF PARAMETERS RETURNED; OR:
C             -NPRMS IF THE NUMBER OF PARAMETERS PRESENT FOR THE
C             OPTION IS GREATER THAN THE VALUE OF 'MXPM''.
C             IABS(NPRMS) IS EQUAL TO THE NUMBER OF PARMS PRESENT.
C     PRMS  = THE PARAMETERS ARRAY.
C

C     SET THE DEFAULT VALUE FOR THE IMPERIAL->METRIC CONVERSIONS

      DO I=1,N_METRIC_PRMS
        XMLT(I) = 1.
      ENDDO
C
C     SET THE ACTIVITY CODE
C
      IF (ITODO1 .LE. KTODO) GOTO 10
      IACTK=-1
      RETURN
   10 CONTINUE
      IREFN=IPTODO(ITODO1)
      ISEQDN=ISEQDN+1
	ISEQ(IREFN)=ISEQDN
	NPRMS=0
	IACTK=-1

C     IF THE PARAMETER POINTER IS LESS THAN ZERO, THE PARMS ARE AN
C     EXPRESSION.  CALL OPEVAL TO EVALUATE THE EXPRESSION AND LOAD
C     THE PARAMETER ARRAYS. CALL MCNVRT TO CONVERT EXPRESSIONS WITH
C     METRIC UNITS INTO IMPERIAL EQUIVALENTS.

      IF (IACT(IREFN,2).LT.0) THEN
        CALL OPEVAL (IREFN,IRC)
        IF (IRC.NE.0) RETURN
        CALL MCNVRT (IACT(IREFN,1),1,XMLT)
      ENDIF 
      IACTK=-1
            
      IF (IACT(IREFN,4).EQ.0) IACTK=1
      IACTK=IACT(IREFN,1)*IACTK
      IDT=IDATE(IREFN)
C
C     SET NUMBER OF PARAMETERS
C
      NPRMS=0
      J1=IACT(IREFN,2)
      IF (J1.EQ.0) RETURN
      J2=IACT(IREFN,3)
      NPRMS=J2-J1+1
      IF (NPRMS .LE. MXPM) GOTO 20
      J2=J2-(NPRMS-MXPM)
      NPRMS=-NPRMS
   20 CONTINUE
C
C     MOVE THE PARAMETERS.
C
      DO 30 J=J1,J2
        IX = J-J1+1
        IF (IX .GT. 0 .AND. IX .LE. N_METRIC_PRMS)
     >    PARMS(J)=PARMS(J)*XMLT(IX)
        PRMS(IX)=PARMS(J)
   30 CONTINUE
      RETURN
C
C
      ENTRY OPGETC (ITODO5,STR)
C
C     OPGETC GETS CHARACTER STRING ASSOCIATED WITH THE "ITODO5" ACTIVITY
C
C     ITODO5= WHICH OF THE NUMBER TO DO THE USER WANTS RETURNED.
C     STR   = THE CHARACTER STRING, BLANK IF NONE...OR BLANK IF
C             THE COMMAND IS TOO LONG FOR STR.
C
      STR=' '
      ILEN=LEN(STR)
      IF (ITODO5 .GT. KTODO) RETURN
      IREFN=IPTODO(ITODO5)
      IF (IACT(IREFN,5).EQ.0) RETURN
      J=1
      DO I=IACT(IREFN,5),MXCACT
         IF(J.GT.ILEN) THEN
            STR=' '
            RETURN
         ENDIF
         IF(CACT(I).EQ.CHAR(0)) RETURN
         STR(J:J)=CACT(I)
         J=J+1
      ENDDO
      RETURN
C
C
      ENTRY OPCHPR (ITODO2,NPRMS1,PRMS)
C
C     OPCHPR IS USED TO CHANGE THE VALUE OF A STORED PARAMETER OF
C     FOR AN ACTIVITY.  YOU CAN NOT CHANGE THE PARAMETER VALUES OF
C     ACTIVITIES WHICH HAVE COMPUTABLE PARAMETERS THAT HAVE NOT BEEN
C     COMPUTED.
C
C     ITODO2 = THE "ITH" ACTIVITY OF THE "NTODO".
C     NPRMS1  = THE NUMBER OF PARAMETERS IN PRMS.
C     PRMS   = THE NEW PARAMETERS. 
C
      IF (ITODO2.LE.KTODO) THEN
         IREFN=IPTODO(ITODO2)
C
C        IF THERE IS ENOUGH ROOM IN PARMS, AND IF THE ACTIVITY GROUP
C        DOES NOT HAVE UNCOMPUTED, COMPUTABLE PARAMETERS, THEN
C        STORE THE NEW PARAMETERS. DON'T WRITE OVER THE OLD PARAMETERS.
C
         IF (IMPL+NPRMS1-1.LE.ITOPRM .AND. IACT(IREFN,2).GE.0) THEN
            IACT(IREFN,2)=IMPL
            DO 35 J=1,NPRMS1
            PARMS(IMPL)=PRMS(J)
            IMPL=IMPL+1
   35       CONTINUE
            IACT(IREFN,3)=IMPL-1
         ENDIF
      ENDIF
      RETURN
C
C
      ENTRY OPDONE (ITODO3,IDT4)
C
C     OPDONE IS USED TO SET THE DATE AN OPTION IS ACTUALLY
C     ACCOMPLISHED; THEREFORE MAINTAINING AN ACCURATE HISTORY OF
C     ACTIVITIES.  IT CAN ALSO BE USED TO SET THE STATUS OF THE
C     ACTIVITY TO ANY VALUE PASSED AS 'IDT4', EXCEPT 0.
C
C     ITODO3= THE "ITH" ACTIVITY OF THE "NTODO".
C     IDT4  = THE YEAR THE ACTIVITY IS ACTUALLY IMPLEMENTED.
C
      IF (ITODO3 .GT. KTODO) RETURN
      IREFN=IPTODO(ITODO3)
      ISEQDN=ISEQDN+1
      ISEQ(IREFN)=ISEQDN
      IACT(IREFN,4)=IDT4
      IF (IDT4.EQ.0) IACT(IREFN,4)=1
      RETURN
C
C
      ENTRY OPDEL1 (ITODO4)
C
C     OPDEL1 IS USED TO DELETE THE ITH ACTIVITY OF THE NTODO.
C
      IF (ITODO4 .GT. KTODO) RETURN
      IREFN=IPTODO(ITODO4)
      IACT(IREFN,4)=-1
      RETURN
C
C
      ENTRY OPDEL2 (IYR1,IYR2,IACTK,ISQNUM)
C
C     OPDEL2 IS USED TO DELETE ALL OF THE OCCURACES OF ACTIVITY
C     IACTK FROM THE ACTIVITY SCHEDULE IF IT MEETS THE FOLLOWING
C     SEARCH RESTRICTIONS:
C
C             A.  NOT YET ACCOMPLISHED
C             B.  IS SCHEDULED TO OCCUR ON OR AFTER IYR1 AND
C                 ON OR BEFORE IYR2,
C             C.  MEETS 'ISQNUM' RESTRICTIONS:
C                 ISQNUM=0, DELETE ALL OCCURANCES
C                 ISQNUM>0, DELETE OCCURANCE ISQNUM
C                 ISQNUM<0, DELETE ALL EXCEPT IABS(ISQNUM) TIMES
C                           THE ACTIVITY IS SCHEDULED.
C
C     J1=COUNTER, STORES THE NUMBER OF OCCURANCES FOUND.
C
      J1=0
      I2=IMGL-1
      DO 50 II=1,I2
      I3=IOPSRT(II)
      IDT3=IDATE(I3)
      IF (.NOT.(IDT3.GE.IYR1.AND.IDT3.LE.IYR2.AND.IACT(I3,4).EQ.0
     >    .AND.IACT(I3,1).EQ.IACTK)) GOTO 50
      IF (ISQNUM.EQ.0) GOTO 40
      J1=J1+1
      IF (J1.NE.ISQNUM) GOTO 50
   40 CONTINUE
      IACT(I3,4)= -1
      IF (ISQNUM .GT. 0) RETURN
   50 CONTINUE
      IF (ISQNUM .GE. 0) RETURN
      IF (-ISQNUM .GE. J1) RETURN
C
C     NOTE: ISQNUM < 0, AND THERE ARE MORE OCCURANCES THAN -ISQNUM;
C     THEREFORE, WE MUST DELETE ALL EXCEPT -ISQNUM TIMES THE ACTIVITY
C     OCCURES BETWEEN IYR1 AND IYR2.
C
C     J2 IS USED TO COUNT THE NUMBER OF DELETIONS, AND
C     J1 IS HOLDS THE NUMBER OF DELETIONS WHICH MUST BE ACCOMPLISHED.
C
      J2=0
      J1=J1+ISQNUM
      DO 60 II=1,I2
      I3=IOPSRT(II)
      IDT3=IDATE(I3)
      IF (.NOT.(IDT3.GE.IYR1.AND.IDT3.LE.IYR2.AND.IACT(I3,4).EQ.0
     >    .AND.IACT(I3,1).EQ.IACTK)) GOTO 60
      IACT (I3,4)= -1
      J2=J2+1
      IF (J2 .GE. J1) RETURN
   60 CONTINUE
      RETURN
C
C
      ENTRY OPDEL3 (IACTK)
C
C     OPDEL3 IS USED TO DELETE AN ACTIVITY IF IT OCCURS AS ONE
C     OF THE ACTIVITIES TO BE SCHEDULED WHEN ANY EVENT OCCURS.
C
      I2=IEPT+1
      IF (I2.GT.MAXACT) RETURN
      DO 80 I=I2,MAXACT
      IF (IACT(I,1).EQ.IACTK) IACT(I,4)= -1
   80 CONTINUE
      RETURN
      END
