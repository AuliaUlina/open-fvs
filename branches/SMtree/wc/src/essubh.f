      SUBROUTINE ESSUBH (I,HHT,EMSQR,DILATE,DELAY,ELEVDUM,IHTSER,GENTIM,
     &                   TRAGE)
      IMPLICIT NONE
C----------
C  **ESSUBH--WC  DATE OF LAST REVISION:  01/31/12
C----------
C     CALLED FROM **ESTAB
C     CALLS **SMHGDG
COMMONS
C
C
      INCLUDE 'PRGPRM.F77'
C
C
      INCLUDE 'CONTRL.F77'
C
C
      INCLUDE 'ESPARM.F77'
C
C
      INCLUDE 'ESCOMN.F77'
C
C
      INCLUDE 'PLOT.F77'
C
COMMONS
C
      LOGICAL DEBUG
      INTEGER I,IHTSER,N,ITIME,ID,ISUM5
      REAL    AGE,EMSQR,DILATE,DELAY,ELEVDUM,GENTIM,H,HHT,TRAGE
      REAL    DGS,HG,DD
C----------
C     ASSIGNS HEIGHTS TO SUBSEQUENT AND PLANTED TREE RECORDS
C     CREATED BY THE ESTABLISHMENT MODEL.
C     COMING INTO ESSUBH, TRAGE IS THE AGE OF THE TREE AS SPECIFIED ON 
C     THE PLANT OR NATURAL KEYWORD.  LEAVING ESSUBH, TRAGE IS THE NUMBER 
C     BETWEEN PLANTING (OR NATURAL REGENERATION) AND THE END OF THE 
C     CYCLE.  AGE IS TREE AGE UP TO THE TIME REGENT WILL BEGIN GROWING 
C     THE TREE.
C----------
      CALL DBCHK (DEBUG,'ESSUBH',6,ICYC)
      IF(DEBUG) 
     &WRITE(JOSTND,*)'ENTERING ESSUBH - ICYC,TRAGE= ',ICYC,TRAGE
      IF(DEBUG)WRITE(JOSTND,*)' I,HHT,EMSQR,DILATE,DELAY,ELEV,IHTSER,',
     &'GENTIM,TRAGE= ',I,HHT,EMSQR,DILATE,DELAY,ELEV,IHTSER,GENTIM,TRAGE
C
      N=DELAY+0.5
      IF(N.LT.-3) N=-3
      DELAY=FLOAT(N)
      ITIME=TIME+0.5
      IF(N.GT.ITIME) DELAY=TIME
      AGE=TIME-DELAY-GENTIM+TRAGE
      IF(AGE.LT.1.0) AGE=1.0
      TRAGE=TIME-DELAY
C----------
C  CALL SMHGDG TO CALCULATE SEEDLING HEIGHT 5 YEARS AFTER PLANTING
C  OR END OF CYCLE, WHICHEVER COMES FIRST
C  ASSUME INITIAL CONDITIONS (MODE=0) AT TIME OF PLANTING
C----------
  100 CONTINUE
C
C  CALL SMHGDG TO GET 5 YEAR GROWTH
C  ASSUME INITIAL SEEDLING HEIGHT = 1.0 FT
C
      HHT=1.0
      DD=.1
      CALL SMHGDG(ID,I,HHT,DD,HG,DGS,ICYC,JOSTND,DEBUG,0)
      HHT=HHT+HG
C
C  SCALE FOR DELAY (NUMBER OF YEARS BETWEEN START OF CYCLE AND PLANTING)
C  (0 TO FINT-1) IF DELAY IS MORE THAN 5 YEARS THEN GROWTH IS SCALED
C  IN REGENT
C
      IF(FINT.LT.5)HHT=HHT*FINT/5.
C
      IF(DEBUG) THEN
      WRITE(JOSTND,*)' LEAVING ESSUBH -ICYC,I,AGE,TRAGE,',
     &'TIME,DELAY,HHT= ',ICYC,I,AGE,TRAGE,TIME,DELAY,HHT
      ENDIF
C
      RETURN
      END