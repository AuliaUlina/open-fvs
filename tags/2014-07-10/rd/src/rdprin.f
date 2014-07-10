      SUBROUTINE RDPRIN (IRRTR)
C----------
C  **RDPRIN                       LAST REVISION:  06/17/02
C----------
C
C  THIS SUBROUTINE CALCULATES THE NUMBER OF TREES PER ACRE THAT EACH
C  TREE RECORD REPRESENTS FOR THE ROOT DISEASE MODEL TREE CLASSES PROBI,
C  FPROB,PROBIU AND PROPI. THIS ROUTINE IS CALLED FROM NOTRE. THESE
C  INITIAL CALCULATIONS ARE MODIFIED IN RRINIT TO PUT THEM ON THE PROPER
C  ACERAGE BASIS. IPRFL=0 IF TREE IS OUTSIDE DISEASE PATCH,IPRFL=1-3
C  IF TREE IS INSIDE PATCH AND INFECTED WITH CORRESPONDING SEVERITY,
C  IPRFL=4 IF IT IS A DEAD INFECTED STUMP AND IPRFL=5 IF TREE IS INSIDE 
C  PATCH AND NOT INFECTED  
C  THIS ROUTINE IS SKIPPED IF THE DISEASE IS BEING INITIALIZED MANUALLY
C
C  CALLED BY :
C     NOTRE   [PROGNOSIS]
C
C  CALLS     :
C     NONE
C
C  PARAMETERS :
C     IRRTR  -
C
C REVISION HISTORY:
C   21-MAY-2002  Lance R. David (FHTET)
C     The previous date of change was March 1, 1995.
C     The TPA represented by dead tree records was unadjusted as
C     described at the point of change below and further described in
C     the FVS subroutine NOTRE. To facilitate the unadjustment, FVS
C     common PLOT.F77 was added.
C     This error was discovered by Don Robinson of ESSA.
C   17-JUN-2002  Lance R. David (FHTET)
C     Added debug.
C------------------
COMMONS
C
C
      INCLUDE 'PRGPRM.F77'
      INCLUDE 'RDPARM.F77'
      INCLUDE 'ARRAYS.F77'
      INCLUDE 'CONTRL.F77'
      INCLUDE 'PLOT.F77'
      INCLUDE 'RDCOM.F77'
      INCLUDE 'RDARRY.F77'
      INCLUDE 'RDADD.F77'

      LOGICAL DEBUG

C
C     SEE IF WE NEED TO DO SOME DEBUG.
C
      CALL DBCHK (DEBUG,'RDPRIN',6,ICYC)

C
C     IF ROOT DISEASE NOT BEING INITIALIZED BY INPUT TREELIST SKIP
C     TREES/ACRE ASSIGNMENTS. ALSO SKIP IF NUMBER OF TREES > IRRTRE
c     UNLESS THEY ARE DISEASED STUMPS
C
c      IF (.NOT. RRTINV .OR. IRRTR .GT. IRRTRE) GOTO 50
      IF (.NOT. RRTINV) GOTO 50
      IF (IRRTR .GT. IRRTRE .AND. IPRFL(IRRTR) .NE. 4) GOTO 50
C
C     PROCESS TREES TO MAKE INITIAL CALCULATION
C
      IF (IPRFL(IRRTR) .EQ. 0) THEN

C       TREE IS UNINFECTED
      
        FPROB(IRRTR) = PROB(IRRTR)
        
      ELSEIF (IPRFL(IRRTR) .GE. 1 .AND. IPRFL(IRRTR) .LE. 3) THEN
      
C       TREE IS INFECTED

        IDI = MAXRR
        IF (MAXRR .LT. 3) IDI = IDITYP(IRTSPC(ISP(IRRTR)))
        PROBI(IRRTR,1,1) = PROB(IRRTR)
C        PROPI(IRRTR,1) = RRINCS(IDI)
        
      ELSEIF (IPRFL(IRRTR) .EQ. 5) THEN

C       TREE IS UNINFECTED BUT INSIDE THE CENTER      
        PROBIU(IRRTR) = PROB(IRRTR)
        
      ELSEIF (IPRFL(IRRTR) .EQ. 4) THEN
      
C        TREE IS AN INFECTED STUMP
C
C        CALCULATE THE ROOT RADIUS OF THE STUMP.
         
         KSP = ISP(IRRTR)
         CALL RDROOT(KSP,DBH(IRRTR),ANS,PROOT(IRTSPC(KSP)),
     &               RSLOP(IRTSPC(KSP)),HHT)
         RTD = ANS

C        FIND THE SIZE CLASS FOR THE STUMP AND PLACE THE STUMP
C        INTO THE STUMP ARRAY.
C        THE PROB FOR THIS DEAD TREE RECORD NEEDS TO BE UNADJUSTED
C        AS EXPLAINED IN THE FVS SUBROUTINE NOTRE. SIMPLY STATED, THIS
C        RECORD WAS ADJUSTED BASED ON THE GROWTH MEASUREMENT PERIOD AND
C        MORTALITY OBSERVATION PERIOD SO THAT BACKDATED DENSITY IS 
C        IS ACCURATE FOR FVS CALIBRATION. FOR EXAMPLE, LIVE TREES MEASURED
C        WITH A GROWTH PERIOD OF 10 YEARS AND DEAD TREES MEASURED WITH A 
C        MORTALITY OBSERVATION PERIOD OF 5 YEARS LEAVES THE NUMBER OF DEAD
C        TREES UNDER-REPRESENTED FOR THE 10 YEAR PERIOD.

         ISTFLG = 0 
         PROBB = (PROB(IRRTR)/GROSPC/(FINT/FINTM))* SAREA
         CALL RDSSIZ(KSP,DBH(IRRTR),STCUT,ISL,ISPS,IRTSPC)
         CALL RDSTP (ISL,KSP,PROBB,DBH(IRRTR),RTD)

C        RESET AGE. ASSUME ALL LARGER STUMPS IN THE TREE LIST ARE 
C        15 YRS OLD (OR HOWEVER OLD USER DECIDES.)

         IDI = MAXRR
         IF (MAXRR .LT. 3) IDI = IDITYP(IRTSPC(KSP))
         JRAGED(IDI,ISPS(IRTSPC(KSP)),ISL,1) = -DEDAGE(ISL)
      
      ENDIF
      IF (DEBUG) WRITE(JOSTND,777) ICYC,IRRTR,PROBI(IRRTR,1,1),
     &           PROBIU(IRRTR),FPROB(IRRTR)
  777 FORMAT(' IN RDPRIN: ICYC,IRRTR,PROBI,PROBIU,FPROB',2(I4),3F8.2)

   50 CONTINUE
      RETURN
      END
