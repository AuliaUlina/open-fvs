      SUBROUTINE BWEWEA
      IMPLICIT NONE
C-----------
C **BWEWEA                   DATE OF LAST REVISION:  07/14/10
C-----------
C
C GET WEATHER PARAMETERS FOR THE CURRENT YEAR
C
C  K.A. SHEEHAN  USDA-FS, R6-NATURAL RESOURCES, PORTLAND, OR
C
C   CALLED FROM: BWELIT
C
C   SUBROUTINES AND FUNCTIONS CALLED:
C
C      BWENOR - CALC. AND SCALE A NORMALLY DISTRIB. DEVIATE
C      BWEMUL - SCALE A RANDOM NUMBER TO GET A MULTIPLIER
C
C   PARAMETERS:
C
C   BWEATH - ARRAY THAT STORES WEATHER PARAMETERS FOR 1 STATION
C            (X,1)=MEAN,(X,2)=S.D., (X,3)=MINIMUM, (X,4)=MAX. FOR X=
C            1=NO. OF DAYS FROM L2 EMERGENCE TO MID-L4
C            2=NO. OF DAYS FROM MID-L4 THROUGH PUPAE
C            3=NO. OF DAYS AS PUPAE
C            4=WARM DEGREE-DAYS AFTER ADULT FLIGHT IN FALL
C            5=NO. OF DAYS FROM L2 EMERGENCE TO BUD-FLUSHING
C            6=TREE DEGREE-DAYS ACCUMULATED AT MID-L4
C            7=MEAN PPT. FOR SMALL LARVAE
C            8=MEAN PPT. FOR LARGE LARVAE
C            9=MEAN PPT. FOR PUPAE
C            10=MEAN PPT. DURING L2 EMERGENCE
C   AMIN   - MINIMUM VALUE FOR WEATHER PARAMETER MULTIPLIERS (NOW = 0.8)
C   AMULT  - CURRENT VALUE FOR MULTIPLIERS
C   IEVENT(250,4) - BW SPECIAL EVENTS SUMMARY ARRAY
C   IWYR   - WEATHER YEAR COUNTER
C   LP4    - TABLE 4 OUTPUT FLAGS (TRUE=PRINT, FALSE=NO PRINT) [BWEBOX]
C   NEVENT - NUMBER OF BW SPECIAL EVENTS TO DATE
C   TREEDD - DEGREE-DAYS THAT HAVE ACCUMULATED FOR DF AT MID-L4
C   WCOLDW - EFFECT OF EXTREME WINTER WEATHER
C   WRAINA - EFFECT OF HEAVY PPT. ON ANT PREDATION (BY LIFE STAGE)
C   WRAINB - EFFECT OF HEAVY PPT. ON BIRD PREDATION (BY LIFE STAGE)
C   WRAIN1 - EFFECT OF HEAVY PPT. ON OTHER1 PREDATION (BY LIFE STAGE)
C   WRAIN2 - EFFECT OF HEAVY PPT. ON OTHER2 PREDATION (BY LIFE STAGE)
C   WRAIN3 - EFFECT OF HEAVY PPT. ON OTHER3 PREDATION (BY LIFE STAGE)
C   WRAIND - EFFECT OF HEAVY PPT. ON BW SURVIVAL DURING L2 EMERGENCE
C
C  SET WEATHER-RELATED PARAMETERS
C
C
C Revision History:
C   17-MAY-2005 Lance R. David (FHTET)
C      Added FVS parameter file PRGPRM.F77.
C   30-AUG-2006 Lance R. David (FHTET)
C      Changed array orientation of IEVENT from (4,250) to (250,4).
C    14-JUL-2010 Lance R. David (FMSC)
C       Added IMPLICIT NONE and declared variables as needed.
C
C----------
C
      INCLUDE 'PRGPRM.F77'
      INCLUDE 'BWECM2.F77'
      INCLUDE 'BWEBOX.F77'
      INCLUDE 'BWECOM.F77'

      INTEGER I, INDEX, IOS, N
      REAL AMIN, AMULT, BWENOR, PICK, RAIN(3)
C
C  SET THE ARRAY THAT STORES EVENT SUMMARIES (FOR TABLE 6) TO ZERO
C
      DO 10 I=1,3
      IOUT6A(I)='   '
   10 CONTINUE

c     WRITE (16,*) 'IN BWEWEA: BWEATH=',BWEATH                    ! TEMP DEBUG
C
C  IF IWOPT=1, GENERATE WEATHER VALUES FROM THE MEANS AND STANDARD
C    DEVIATIONS FROM THE WEATHER STATION SELECTED BY THE USER
C
C  GET THE WEATHER RANDOM NO. SEED (WSEED).  CHECK TO SEE IF >1 YR
C    HAS PASSED SINCE THIS SUBR. WAS CALLED -- IF SO, MAKE DUMMY
C    CALLS TO THE RN GENERATOR SO THAT THE SAME SEED WILL BE USED IN
C    A GIVEN YEAR (TO COMPARE ACROSS YEARS). EACH YEAR WHEN BUDLITE
C    IS CALLED, THERE ARE 20 CALLS TO THE WEATHER SEED (10 CALLS TO
C    BWERAN, 2 USES OF THE SEED PER CALL).
C IF IWSRC=3, USER HAS SUPPLIED ACTUAL DATA (1 LINE PER YEAR). READ
C CURRENT YEAR & STORE IN BWEATH(X,1); IWOPT IS SET TO 2 TEMPORARILY.
C
C
C     WRITE (16,*) 'IN BWEWEA: IWOPT, IWSRC=',IWOPT,IWSRC         ! TEMP DEBUG
C     RESTORE SEED VALUE FOR WEATHER RANDOM NUMBER SERIES USED IN FUNCTION BWENOR
      CALL BWERPT(WSEED)
C     WRITE (16,*) 'IN BWEWEA: WSEED: ', WSEED                    ! TEMP DEBUG

      IF (IWOPT.EQ.1.OR.IWSRC.EQ.3) THEN
 
         AMIN=0.8
         IF (IYRCUR.GT.IWYR+1.AND.IWYR.LT.3000) THEN
   20        IWYR=IWYR+1
C            WRITE (16,*) 'IN BWEWEA: IYRCUR, IWYR=',IYRCUR,IWYR   ! TEMP DEBUG
             IF (IWSRC.NE.3) THEN
                TREEDD=BWENOR(BWEATH(6,1),BWEATH(6,2))
                PICK=BWENOR(BWEATH(4,1),BWEATH(4,2))
                PICK=BWENOR(BWEATH(10,1),BWEATH(10,2))
                DFLUSH=BWENOR(BWEATH(5,1),BWEATH(5,2))
                DAYS(1)=BWENOR(BWEATH(1,1),BWEATH(1,2))
                DAYS(2)=BWENOR(BWEATH(2,1),BWEATH(2,2))
                DAYS(3)=BWENOR(BWEATH(3,1),BWEATH(3,2))
                PICK=BWENOR(BWEATH(7,1),BWEATH(7,2))
                PICK=BWENOR(BWEATH(8,1),BWEATH(8,2))
                PICK=BWENOR(BWEATH(9,1),BWEATH(9,2))
             ELSE
C               WRITE (16,*) 'IN BWEWEA: DUMMY READ JOWE'         ! TEMP DEBUG
                READ (JOWE,30,IOSTAT=IOS)
   30           FORMAT (1X)
                IF (IOS.EQ.-1) REWIND (JOWE)
C               WRITE (16,*) 'IN BWEWEA: REWIND JOWE'             ! TEMP DEBUG
             ENDIF
             IF (IDEFPR.NE.0) WRITE (JOBWP3,40) IWYR,(IDEF(IBUDYR,N),
     *          N=1,NUMCOL)
   40        FORMAT (I4,4X,5(I4,6X))
             IBUDYR=IBUDYR+1
C            WRITE (16,*) 'IN BWEWEA: IBUDYR=',IBUDYR              ! TEMP DEBUG
             IF (IWYR.LT.IYRCUR-1) GOTO 20
         ENDIF
         IWYR=IWYR+1    
C
C IF IWSRC=3, READ IN DATA FROM FILE SUPPLIED BY USER, THEN SKIP REST
C   OF THIS SECTION
C
         IF (IWSRC.EQ.3) THEN
   44       READ (JOWE,45,IOSTAT=IOS) DAYS(1),DAYS(2),DAYS(3),WHOTF,
     *        DFLUSH,TREEDD,RAIN(1),RAIN(2),RAIN(3),WRAIND
   45       FORMAT(5X,10F7.1)
            IF (IOS.EQ.-1) THEN 
               REWIND (JOWE)
               GOTO 44
            ENDIF
            AMIN=0.8
            AMULT=1.0
            IF (WHOTF.GT.WHOTM) CALL BWEMUL(WHOTM,WHOTSD,WHOTF,AMIN,
     *         AMULT)
            WHOTF=AMULT
            AMULT=1.0
            IF (WRAIND.GT.RAINDM) CALL BWEMUL(RAINDM,RAINDS,WRAIND,AMIN,
     *         AMULT)
            WRAIND=AMULT
            DO 46 I=1,3
               AMULT=1.0
               IF (RAIN(I).GT.RAINM(I)) CALL BWEMUL(RAINM(I),RAINS(I),
     *             RAIN(I),AMIN,AMULT)
               WRAINA(I)=AMULT
               WRAINB(I)=AMULT
               WRAIN1(I)=AMULT
               WRAIN2(I)=AMULT
               WRAIN3(I)=AMULT
   46       CONTINUE
            WCOLDW=1.0
         ENDIF
         IF (IWSRC.EQ.3) GO TO 300                             ! RETURN
 
         TREEDD=BWENOR(BWEATH(6,1),BWEATH(6,2))
         PICK=BWENOR(BWEATH(4,1),BWEATH(4,2))

C        TEMP DEBUG
C        WRITE (16,*) 'IN BWEWEA: PICK, BWEATH(4,1)=',PICK,BWEATH(4,1)

         IF (PICK.GT.BWEATH(4,1)) THEN
            CALL BWEMUL(BWEATH(4,1),BWEATH(4,2),PICK,
     *                   AMIN,AMULT)
         ELSE
            AMULT=1.0
         ENDIF
         WHOTF=AMULT
         IF (LP4 .AND. AMULT-AMIN .LE. 0.02) THEN
            NEVENT=NEVENT+1
            IF (NEVENT.GT.250) THEN
              WRITE (JOBWP4,8250) 
              LP4 = .FALSE.
            ELSE
              IEVENT(NEVENT,1)=IYRCUR
              IEVENT(NEVENT,2)=7
              IEVENT(NEVENT,3)=0
              IEVENT(NEVENT,4)=8
            ENDIF
         ENDIF
         IF (AMULT-AMIN.LE.0.02) IOUT6A(3)=' 95'

         PICK=BWENOR(BWEATH(10,1),BWEATH(10,2))
         IF (PICK.GT.BWEATH(10,1)) THEN
            CALL BWEMUL(BWEATH(10,1),BWEATH(10,2),PICK,
     *                   AMIN,AMULT)
         ELSE
            AMULT=1.0
         ENDIF
         WRAIND=AMULT
         IF (LP4 .AND. AMULT-AMIN .LE. 0.02) THEN
            NEVENT=NEVENT+1
            IF (NEVENT.GT.250) THEN
              WRITE (JOBWP4,8250) 
              LP4 = .FALSE.
            ELSE
              IEVENT(NEVENT,1)=IYRCUR
              IEVENT(NEVENT,2)=7
              IEVENT(NEVENT,3)=0
              IEVENT(NEVENT,4)=4
            ENDIF
         ENDIF
         IF (AMULT-AMIN.LE.0.02) IOUT6A(3)=' 95'

         DFLUSH=BWENOR(BWEATH(5,1),BWEATH(5,2))
         DAYS(1)=BWENOR(BWEATH(1,1),BWEATH(1,2))
         DAYS(2)=BWENOR(BWEATH(2,1),BWEATH(2,2))
         DAYS(3)=BWENOR(BWEATH(3,1),BWEATH(3,2))
         DO 50 I=1,3
         INDEX=I+6
         PICK=BWENOR(BWEATH(INDEX,1),BWEATH(INDEX,2))
         IF (PICK.GT.BWEATH(INDEX,1)) THEN
            CALL BWEMUL(BWEATH(INDEX,1),BWEATH(INDEX,2),PICK,
     *                   AMIN,AMULT)
         ELSE
            AMULT=1.0
         ENDIF
         WRAINA(I)=AMULT
         WRAINB(I)=AMULT
         WRAIN1(I)=AMULT
         WRAIN2(I)=AMULT
         WRAIN3(I)=AMULT
         IF (LP4 .AND. AMULT-AMIN .LE. 0.02) THEN
            NEVENT=NEVENT+1
            IF (NEVENT.GT.250) THEN
              WRITE (JOBWP4,8250) 
 8250         FORMAT ('   AAAIIEEEEEE!!  MORE THAN 250 ENTRIES!!!')
              LP4 = .FALSE.
            ELSE
              IEVENT(NEVENT,1)=IYRCUR
              IEVENT(NEVENT,2)=7
              IEVENT(NEVENT,3)=0
              IEVENT(NEVENT,4)=I+4
            ENDIF
         ENDIF
   50    CONTINUE
C
C STILL NEED TO FIGURE OUT HOW TO CALC. EXTREME WINTER WEATHER MULTIPLIER
C   SET TO 1.0 (NO EFFECT) FOR NOW.
C

         WCOLDW=1.0
C
C IF WOPT NE 1, SET WEATHER PARAMETERS TO AVERAGE VALUES (NO STOCH.)
C
      ELSE
         TREEDD=BWEATH(6,1)
         DFLUSH=BWEATH(5,1)
         DAYS(1)=BWEATH(1,1)
         DAYS(2)=BWEATH(2,1)
         DAYS(3)=BWEATH(3,1)
         AMULT=1.0
         DO 250 I=1,3
         WRAINA(I)=AMULT
         WRAINB(I)=AMULT
         WRAIN1(I)=AMULT
         WRAIN2(I)=AMULT
         WRAIN3(I)=AMULT
  250    CONTINUE
         WRAIND=AMULT
         WCOLDW=AMULT
         WHOTF=AMULT
      ENDIF

  300 CONTINUE

C     RETRIEVE SEED VALUE FOR WEATHER RANDOM NUMBER SERIES.
      CALL BWERGT(WSEED)

C     WRITE (16,*) 'EXIT BWEWEA: NEVENT=',NEVENT                   ! TEMP DEBUG

      RETURN
      END

C----------------------------------------------------------------------

      FUNCTION BWENOR(AVE,SD)
C-----------
C **BWENOR      LAST REVISED: 2/25/97
C-----------
C
C  THIS FUNCTION FIRST CALCULATES A NORMALLY DISTRIBUTED DEVIATE WITH
C  ZERO MEAN AND UNIT VARIANCE, USING BWERAN AS THE SOURCE FOR A UNIFORM
C  DEVIATE.  SOURCE: PRESS, WILLIAM H.; TEUKOLSKY, SAUL A.; VETTERLING, 
C  WILLIAM T.; FLANNERY, BRIAN P.  1992.  NUMERICAL RECIPES IN FORTRAN, 
C  2ND EDITION.  CAMBRIDGE UNIVERSITY PRESS, PORT CHESTER, NEW YORK. 963 P.
C
C  NEXT, THE DEVIATE IS SCALED TO THE AVERAGE (AVE) AND STANDARD DEVIATION
C  (SD), WITH THE RESULTING VALUE STORED IN BWENOR.
C
C  K.A. SHEEHAN  USDA-FS, R6-NATURAL RESOURCES, PORTLAND, OR
C
C   CALLED FROM: BWEWEA
C
C   SUBROUTINES AND FUNCTIONS CALLED:
C
C      BWERAN
C
C   PARAMETERS:
C
C
      DATA ISET/0/
C
C  FIRST, GET THE NORMALLY DISTRIBUTED DEVIATE
C
C     WRITE (16,*) 'BWEWEA (BWENOR): ISET=',ISET                 ! TEMP DEBUG

      IF (ISET.EQ.0) THEN

    1   CALL BWERAN(X)
C       WRITE (16,*) 'BWEWEA (BWENOR): RANDOM #1: ', X           ! TEMP DEBUG
        V1=2.*X-1.
        CALL BWERAN(X)
C       WRITE (16,*) 'BWEWEA (BWENOR): RANDOM #2: ', X           ! TEMP DEBUG
        V2=2.*X-1.
        RSQ=V1**2+V2**2
        IF (RSQ.GE.1..OR.RSQ.EQ.0.) GOTO 1
        FAC=SQRT(-2.*LOG(RSQ)/RSQ)
        GSET=V1*FAC
        GASDEV=V2*FAC
        ISET=1
      ELSE
        GASDEV=GSET
        ISET=0
      ENDIF
C
C NEXT, SCALE THE DEVIATE
C
      BWENOR=AVE+(GASDEV*SD)

C     TEMP DEBUG
C     WRITE (16,*) 'IN BWEWEA BWENOR: BWENOR, AVE, GASDEV, SD, ISET=',
C    &                                BWENOR, AVE, GASDEV, SD, ISET
      RETURN
      END

C----------------------------------------------------------------------

      SUBROUTINE BWEMUL(AVE,SD,PICK,AMIN,AMULT)
C-----------
C **BWEMUL      LAST REVISED: 2/25/97
C-----------
C
C  THIS SUBROUTINE IS USED TO SCALE A NORMALY-DISTR. RANDOM
C  NUMBER (PICK) FOR A MULTIPLIER THAT IS SET TO A MAXIMUM OF
C  1.0 AND A MINIMUM OF AMIN.  
C
C  K.A. SHEEHAN  USDA-FS, R6-NATURAL RESOURCES, PORTLAND, OR
C
C   CALLED FROM: BWEWEA
C
C   SUBROUTINES AND FUNCTIONS CALLED: NONE
C
      DIFF=ABS(AVE-PICK)
      TOP=SD*2.0
      IF (DIFF.GT.TOP) DIFF=TOP
      IF (TOP.GT.0.0) THEN
        PROP=DIFF/TOP
      ELSE
        PROP=0.0
      ENDIF
      AMULT=1.0-((1.0-AMIN)*PROP)
      IF (AMULT.LT.0.0.OR.AMULT.GT.1.0) THEN
        WRITE (*,100) AVE,SD,PICK,AMIN,AMULT
  100   FORMAT (' WARNING (BWEMUL): BAD AMULT VALUE!',5F9.2)
        AMULT=1.0
      ENDIF

C     WRITE (16,*) 'BWEWEA (BWEMUL): ',AVE,SD,PICK,AMIN,AMULT     ! TEMP DEBUG

      RETURN
      END
