      SUBROUTINE CLMORTS
      IMPLICIT NONE
C----------
C  $Id$
C----------
C
C     CLIMATE EXTENSION - COMPUTES CLIMATE-CAUSED MORTALITY
C
COMMONS
C
      INCLUDE 'PRGPRM.F77'
      INCLUDE 'ARRAYS.F77'
      INCLUDE 'CONTRL.F77'
      INCLUDE 'PLOT.F77'
      INCLUDE 'CLIMATE.F77'
C
COMMONS
C
      INTEGER I,I2
      REAL THISYR,ALGSLP,X,XV,FYRMORT(MAXSP),CTHISYR(6),
     >     CBIRTH(6),DTV(6),DMORT,BIRTHYR,SPWTS(MAXSP)
      LOGICAL DEBUG,LDMORT

      CALL DBCHK (DEBUG,'CLMORTS',7,ICYC)
      IF (DEBUG) WRITE (JOSTND,1) LCLIMATE
    1 FORMAT (' IN CLMORTS, LCLIMATE=',L2)

      IF (.NOT.LCLIMATE) RETURN
      
      SPMORT1=0.
      FYRMORT=0.      
      THISYR=FLOAT(IY(ICYC))+(FINT/2)
      DO I=1,MAXSP 

        IF (INDXSPECIES(I).EQ.0) CYCLE         
        I2 = INDXSPECIES(I) 
        
C       X IS THE SPECIES VIABILITY SCORE.
        
        XV = ALGSLP (THISYR,FLOAT(YEARS),ATTRS(1,I2),NYEARS)  
        X = XV

C       CONVERT X TO A 10-YR SURVIVAL RATE.

        IF (X.LT. 0.2) THEN
          X=0.
        ELSE IF (X.GT. 0.5) THEN
          X=1.
        ELSE 
          X=-.66666667 + X*3.3333333
          IF (X.GT.1.0) X=1.0  ! ROUNDING ERROR?
        ENDIF

C       CONVERT TO A MORTALITY RATE AND APPLY MULTIPLIER.
C       SAVE THIS VERSION FOR REPORTING (10 YR).
        
        SPMORT1(I)=(1.-X)*CLMRTMLT1(I)
        
C       CONVERT TO A FINT-YR SURVIVAL RATE.

        IF (X.GT. 1E-5) THEN  ! VERY LOW SURVIVAL SET TO 0
          X=EXP(LOG(X)/10.)**FINT
          IF (X.LT.0) THEN
            X=0.
          ELSE IF (X.GT.1.0) THEN
            X=1.0
          ENDIF
        ELSE
          X=0.
        ENDIF
         
C       CONVERT TO A MORTALITY RATE AND APPLY MULTIPLIER.

        FYRMORT(I)=(1.-X)*CLMRTMLT1(I)

        IF (DEBUG) WRITE (JOSTND,10) IFIX(THISYR),I,JSP(I)(1:2),XV,X,
     >             CLMRTMLT1(I),CLMRTMLT2(I),SPMORT1(I),FYRMORT(I)
   10   FORMAT (' IN CLMORTS, THISYR=',I5,' I=',I3,1X,A3,' XVia=',
     >          2F10.4,' CLMRTMLT1&2=',2F10.4,' MORT=',2F10.4)
      ENDDO
      
C     COMPUTE MORTALITY BASED ON CLIMATE TRANSFER DISTANCE. FIRST
C     COMPUTE THE CLIMATE METRICS FOR "THIS" YEAR. THE SECOND
C     PART IS FOR THE BIRTH YEAR, AND IT MUST BE DONE WITHIN THE
C     TREE LOOP.

      LDMORT = IDEmtwm.GT.0 .AND. IDEmtcm.GT.0 .AND. 
     >         IDEdd5.GT.0 .AND. IDEsdi.GT.0 .AND. 
     >         IDEdd0.GT.0 .AND. IDEmapdd5.GT.0 .AND. 
     >         IXMTWM.GT.0 .AND. IXMTCM.GT.0 .AND. 
     >         IXDD5.GT.0 .AND. IXDD0.GT.0 .AND. 
     >         IXMAP.GT.0 .AND. IXGSP.GT.0 .AND. IXGSDD5.GT.0

      IF (DEBUG) WRITE (JOSTND,11) LDMORT,IDEmtwm,IDEmtcm,
     >         IDEdd5,IDEsdi,IDEdd0,IDEmapdd5,
     >         IXMTWM,IXMTCM,IXDD5,IXDD0,IXMAP,IXGSP,IXGSDD5
   11 FORMAT (' IN CLMORTS, LDMORT=',L2,13I3)

      IF (LDMORT) THEN
        CTHISYR(1) = ALGSLP(THISYR,FLOAT(YEARS),ATTRS(1,IXMTWM),
     >                      NYEARS)                    
        CTHISYR(2) = ALGSLP(THISYR,FLOAT(YEARS),ATTRS(1,IXMTCM),
     >                      NYEARS)                    
        CTHISYR(3) = ALGSLP(THISYR,FLOAT(YEARS),ATTRS(1,IXDD5),
     >                      NYEARS)                    
C       sdi=sqrt(gsdd5)/gsp
        CTHISYR(4) = SQRT(ALGSLP(THISYR,FLOAT(YEARS),
     >                           ATTRS(1,IXGSDD5),NYEARS))/
     >                    ALGSLP(THISYR,FLOAT(YEARS),
     >                           ATTRS(1,IXGSP),NYEARS)
        CTHISYR(5) = ALGSLP(THISYR,FLOAT(YEARS),ATTRS(1,IXDD0),
     >                      NYEARS)                    
C       mapdd5 = map*dd5/1000   
        CTHISYR(6) = ALGSLP(THISYR,FLOAT(YEARS),ATTRS(1,IXMAP),
     >                      NYEARS)*CTHISYR(3)/1000    
        IF (DEBUG) WRITE (JOSTND,12) CTHISYR
   12   FORMAT (' IN CLMORTS, CTHISYR=',6F13.5)
      ENDIF
      SPMORT2=0.
      SPWTS  =0.
      DO I=1,ITRN
        DMORT = 0.
        IF (LDMORT) THEN
          BIRTHYR   = THISYR-ABIRTH(I)
          CBIRTH(1) = ALGSLP(BIRTHYR,FLOAT(YEARS),ATTRS(1,IXMTWM),
     >                        NYEARS)                    
          CBIRTH(2) = ALGSLP(BIRTHYR,FLOAT(YEARS),ATTRS(1,IXMTCM),
     >                        NYEARS)                    
          CBIRTH(3) = ALGSLP(BIRTHYR,FLOAT(YEARS),ATTRS(1,IXDD5),
     >                        NYEARS)                    
C         sdi=sqrt(gsdd5)/gsp
          CBIRTH(4) = SQRT(ALGSLP(BIRTHYR,FLOAT(YEARS),
     >                            ATTRS(1,IXGSDD5),NYEARS))/
     >                     ALGSLP(BIRTHYR,FLOAT(YEARS),
     >                            ATTRS(1,IXGSP),NYEARS)
          CBIRTH(5) = ALGSLP(BIRTHYR,FLOAT(YEARS),ATTRS(1,IXDD0),
     >                       NYEARS)                    
C         mapdd5 = map*dd5/1000  
          CBIRTH(6) = ALGSLP(BIRTHYR,FLOAT(YEARS),ATTRS(1,IXMAP),
     >                       NYEARS)*CBIRTH(3)/1000 
          DTV = CTHISYR - CBIRTH
          DTV(1) = DTV(1) / ATTRS(1,IDEmtwm)  
          DTV(2) = DTV(2) / ATTRS(1,IDEmtcm)  
          DTV(3) = DTV(3) / ATTRS(1,IDEdd5)   
          DTV(4) = DTV(4) / ATTRS(1,IDEsdi)   
          DTV(5) = DTV(5) / ATTRS(1,IDEdd0)   
          DTV(6) = DTV(6) / ATTRS(1,IDEmapdd5)
          DMORT = (SUM(DTV)/6.)-1.1 ! COMPUTE THE AVERAGE, THEN TRANSLATE
          IF (DMORT .LT. 0) DMORT = 0
          DMORT = .9*(1-EXP(-(DMORT)**2.5))
          X = (DBH(I)*DBH(I)*PROB(I))
          SPMORT2(ISP(I)) = SPMORT2(ISP(I))+(DMORT*CLMRTMLT2(ISP(I))*X)
          SPWTS(ISP(I))   = SPWTS(ISP(I))+X
          DMORT = 1.-DMORT !CONVERT TO A SURVIVAL RATE
          IF (DMORT.GT. 1E-5) THEN  ! VERY LOW SURVIVAL WILL BE 0
            DMORT=EXP(LOG(DMORT)/10.)**FINT
            IF (DMORT.LT.0.) THEN
              DMORT=0.
            ELSE IF (DMORT.GT.1.0) THEN
              DMORT=1.0
            ENDIF
          ELSE
            DMORT=0.
          ENDIF
          ! CONVERT BACK TO A MORTALITY RATE AND APPLY SPECIES MULT.           
          DMORT = (1.-DMORT)*CLMRTMLT2(ISP(I))
        ENDIF
        
        ! X IS THE FVS PERIODIC MORTALITY RATE (FINT-YEARS)...              
        IF (PROB(I)-WK2(I) .LE. 1E-10) THEN
          X=1.
        ELSE IF (PROB(I).LT. 1E-10) THEN
          X=1.
        ELSE
          X = WK2(I)/PROB(I)
        ENDIF
        IF (DEBUG) WRITE (JOSTND,15) I,JSP(ISP(I))(1:2),BIRTHYR,X,
     >             FYRMORT(ISP(I)),DMORT,CBIRTH,ATTRS(1,IDEmtwm),
     >             ATTRS(1,IDEmtcm),ATTRS(1,IDEdd5),ATTRS(1,IDEsdi),
     >             ATTRS(1,IDEdd0),ATTRS(1,IDEmapdd5),CTHISYR,DTV
   15   FORMAT (' IN CLMORTS, I=',I4,' SP=',A3,' BIRTHYR=',F6.0,
     >        ' FVSmort=',F10.4,' FYRMORT=',F10.4,' DMORT=',F10.4/
     >        ' IN CLMORTS, CBIRTH =',6F13.5/
     >        ' IN CLMORTS, deV    =',6F13.5/
     >        ' IN CLMORTS, CTHISYR=',6F13.5/
     >        ' IN CLMORTS, DTV    =',6F13.5)
        ! USE THE MAX OF THE TWO RATES.
        IF (FYRMORT(ISP(I)).GT.DMORT) DMORT=FYRMORT(ISP(I))
        IF (DMORT.GT.X) WK2(I)=PROB(I)*DMORT
      ENDDO
      
C     COMPUTE THE WEIGHTED AVERAGE MORTALITY RATE FOR CAUSE 2 
           
      DO I=1,MAXSP
        IF (SPWTS(I).GT. 0.0001) THEN
          SPMORT2(I) = SPMORT2(I)/SPWTS(I)
        ELSE
          SPMORT2(I) = 0.
        ENDIF
      ENDDO
      
      RETURN
      END
