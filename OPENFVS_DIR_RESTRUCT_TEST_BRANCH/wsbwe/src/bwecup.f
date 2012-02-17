      SUBROUTINE BWECUP
      IMPLICIT NONE
C----------
C  **BWECUP             DATE OF LAST REVISION:  07/14/10
C----------
C
C     PROCESSES ALL OF THE STANDS IN A RUN FROM YEAR IBWYR1 TO IBWYR2.
C
C     PART OF THE WESTERN SPRUCE BUDWORM MODEL/PROGNOSIS LINKAGE CODE.
c
c     major revision by K.Sheehan 7/96+ to strip out BW Pop.Dyn.stuff
C
C     DESCRIPTION :
C
C     BWECUP CONTROLS INTERACTION BETWEEN THE WEATHER MODEL, THE
C     ADULT DISPERSAL MODEL, THE BUDWORM LIFECYCLE MODEL, THE
C     FOLIAGE DAMAGE MODELS, AND PROGNOSIS.
C
C     CALLED FROM :
C
C       GRADD - PROGNOSIS SINGLE STAND TREE GROWTH MODEL.
C
C     SUBROUTINES CALLED :
C
C     BWESIT - BUILD BUDWORM PSUEDO-STAND FROM PROGNOSIS TREE LIST.
C     BWEDR  - DRIVE THE BUDWORM MODEL FOR ONE YEAR.
C     BWEPDM - COMPUTES PERIODIC DAMAGE TO PROGNOSIS TREES.
C     BWEPRB - COMPUTE FINAL ADJUSTMENT TO PROPORTION OF RETAINED
C              BIOMASS ARRAY.
C     BWEEST - TELLS ESTABLISHMENT MODEL ABOUT BW DEFOLIATION
C
C   SOME VARIABLE DEFINITIONS:
C
C   IBWYR2 = LAST YEAR IN BUDWORM SIMULATION
C   ICYC -- INDEX TO CURRENT CYCLE.  VALUE SET IN **MAIN**.
C   IFINT -- FIXED POINT REPRESENTATION OF CURRENT CYCLE LENGTH.
C   IY -- IY(1)=INVENTORY DATE, IY(2)=ENDPOINT OF FIRST CYCLE,
C         IY(3)=ENDPOINT OF SECOND CYCLE,...,IY(MAXCY1)=ENDPOINT
C         OF FORTIETH CYCLE.  KEYWORD CONTROLLED.
C
C Revision History:
C   11-JUN-01 Lance David (FHTET)
C      .Added debug handling. 
C   30-AUG-2006 Lance R. David (FHTET)
C      Changed array orientation of IEVENT from (4,250) to (250,4) for
C      efficiency purposes of the PPE processes in bwepppt and bweppgt.
C   14-JUL-2010 Lance R. David (FMSC)
C      Added IMPLICIT NONE and declared variables as needed.
C-----------------------------------------------------------------------------
C
COMMONS
C
      INCLUDE 'PRGPRM.F77'
      INCLUDE 'PLOT.F77'
      INCLUDE 'CONTRL.F77'
      INCLUDE 'BWESTD.F77'
      INCLUDE 'BWECOM.F77'
      INCLUDE 'BWECM2.F77'
      INCLUDE 'BWEBOX.F77'
C
COMMONS
C
      INTEGER IYEAR, NSPYR, LASTYR
      LOGICAL DEBUG
C
C.... Check for DEBUG
C
      CALL DBCHK(DEBUG,'BWECUP',6,ICYC)

      IF (DEBUG) WRITE (JOSTND,*) 'ENTER BWECUP: ICYC = ',ICYC

C     ************************ EXECUTION BEGINS ************************
C
C     PROCESS STAND OPTIONS, AND CREATE FOLIAGE PROFILE.
C
      IF (DEBUG) WRITE (JOSTND,*) 'IN BWECUP: CALL BWESIT'
      CALL BWESIT 
      IF (DEBUG) WRITE (JOSTND,*) 'IN BWECUP: RETURN FROM BWESIT'
C
C     IF PROGNOSIS TELLS US THAT BUDWORM OR MANUAL DEFOLIATION IS
C     NOT SCHEDULED FOR THIS CYCLE, RETURN TO TREGRO.  IF WE GOT HERE,
C     THERE SHOULD EITHER BE A CALL TO BUDWORM OR A CALL TO DEFOL,
C     BUT, BETTER SAFE THAN SORRY......
C
      IYEAR=0
      NSPYR=1
C
C     DO FOR ALL YEARS...
C
      LASTYR=IY(ICYC)+IFINT-1
      IF (DEBUG) WRITE (JOSTND,*) 'IN BWECUP: LASTYR = ',LASTYR

      DO 250 IYRCUR=IY(ICYC),LASTYR
      IYEAR=IYEAR+1
      IF (DEBUG) WRITE (JOSTND,*) 'IN BWECUP: IYEAR,IYRCUR= ',
     &                             IYEAR,IYRCUR
      LSPRAY=.FALSE.
C
C     IS AN INSECTICIDE APPLICATION SCHEDULED FOR THIS YEAR?
C
      IF (ISPYR(NSPYR).EQ.IYRCUR) THEN
         INSTSP=SPINST(NSPYR)
         SPEFF=SPEFFS(NSPYR)
         LSPRAY=.TRUE.
         NSPYR=NSPYR+1
         IF (DEBUG) WRITE (JOSTND,*) 'IN BWECUP: LSPRAY,NSPYR,SPEFF=',
     &                                LSPRAY,NSPYR,SPEFF
C
C IF SO, SEND A NOTE TO THE SPECIAL EVENTS TABLE
C
         IF (LP4) THEN
           NEVENT=NEVENT+1
           IF (NEVENT.GT.250) THEN
             WRITE (JOBWP4,8250)
 8250        FORMAT ('   AAAIIEEEE!  MORE THAN 250 ENTRIES!  ')
             LP4 = .FALSE.
           ELSE
             IEVENT(NEVENT,1)=IYRCUR
             IEVENT(NEVENT,2)=7
             IEVENT(NEVENT,3)=0
             IEVENT(NEVENT,4)=11
           ENDIF
         ENDIF
      ENDIF
C
      IF (DEBUG) WRITE (JOSTND,*) 'IN BWECUP: CALL BWEDR'
      CALL BWEDR
C
C     LET THE ESTAB MODEL KNOW IF THERE WAS DEFOLIATION THIS YEAR.
C
      IF (DEBUG) WRITE (JOSTND,*) 'IN BWECUP: CALL BWEEST'
      CALL BWEEST
C
C     END YEAR LOOP.
C
  250 CONTINUE
C
C     COMPUTE PERIODIC DAMAGE.
C
      IF (DEBUG) WRITE (JOSTND,*) 'IN BWECUP: CALL BWEPDM'
      CALL BWEPDM
C
C     COMPUTE FINAL ADJUSTMENT TO PRBIO ARRAY.
C
      IF (DEBUG) WRITE (JOSTND,*) 'IN BWECUP: CALL BWEPRB'
      CALL BWEPRB
C
C     SAVE LAST YEAR IN IYRLST, AND NUKE IBWYR2 SO NO OTHER STANDS
C     USE IT ACCIDENTALLY.
C
      IBWYR2=-1
C
      IF (DEBUG) WRITE (JOSTND,*) 'EXIT BWECUP: ICYC= ',ICYC

      RETURN
      END
