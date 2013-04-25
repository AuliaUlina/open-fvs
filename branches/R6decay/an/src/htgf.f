      SUBROUTINE HTGF
      IMPLICIT NONE
C----------
C  **HTGF--AN   DATE OF LAST REVISION:  07/08/11
C----------
C   THIS SUBROUTINE COMPUTES THE PREDICTED PERIODIC HEIGHT
C   INCREMENT FOR EACH CYCLE AND LOADS IT INTO THE ARRAY HTG.
C   CALLED FROM **TREGRO** DURING REGULAR CYCLING.
C   ENTRY **HTCONS** IS CALLED FROM **RCON** TO LOAD SITE
C   DEPENDENT CONSTANTS THAT NEED ONLY BE RESOLVED ONCE.
C----------
COMMONS
C
C
      INCLUDE 'PRGPRM.F77'
C
C
      INCLUDE 'ARRAYS.F77'
C
C
      INCLUDE 'COEFFS.F77'
C
C
      INCLUDE 'CONTRL.F77'
C
C
      INCLUDE 'OUTCOM.F77'
C
C
      INCLUDE 'PLOT.F77'
C
C
      INCLUDE 'MULTCM.F77'
C
C
      INCLUDE 'HTCAL.F77'
C
C
      INCLUDE 'PDEN.F77'
C
C
      INCLUDE 'VARCOM.F77'
C
COMMONS
C------------
      LOGICAL DEBUG
      INTEGER I,ISPC,I1,I2,I3,ITFN
      REAL AGMAX,SITAGE,SITHT,FAHMX,FAHMX2,D2,BARK,BRATIO
      REAL SCALE,AGP10,HGUESS,XSITE,XHT,H,D,TEMPH,TEMPD,HTMAX
      REAL HTMAX2,POTHTG,XMOD,CRATIO,RELHT,DUMAG,BIGDX,CNEWHT
      REAL RNEWHT,TEMHTG
      REAL MISHGF
C-----------
C  SEE IF WE NEED TO DO SOME DEBUG.
C-----------
      CALL DBCHK (DEBUG,'HTGF',4,ICYC)
      IF(DEBUG) WRITE(JOSTND,3)ICYC
    3 FORMAT(' ENTERING SUBROUTINE HTGF  CYCLE =',I5)
C
      IF(DEBUG)WRITE(JOSTND,*) 'IN HTGF AT BEGINNING,HTCON=',
     *HTCON,'RMAI=',RMAI,'ELEV=',ELEV
C
      SCALE=FINT/YR
      AGP10=0.0
      HGUESS=0.0
C----------
C  GET THE HEIGHT GROWTH MULTIPLIERS.
C----------
      CALL MULTS (2,IY(ICYC),XHMULT)
C----------
C   BEGIN SPECIES LOOP:
C----------
      DO 40 ISPC=1,MAXSP
      I1 = ISCT(ISPC,1)
      IF (I1 .EQ. 0) GO TO 40
      I2 = ISCT(ISPC,2)
      XSITE = SITEAR(ISPC)
      XHT=XHMULT(ISPC)
C-----------
C   BEGIN TREE LOOP WITHIN SPECIES LOOP
C-----------
      DO 30 I3=I1,I2
      I=IND1(I3)
      H=HT(I)
      D=DBH(I)
      HTG(I)=0.
      IF(DG(I) .LE. 0.)DG(I)=0.0001
      IF (PROB(I).LE.0.) GO TO 161
C
      SITAGE = 0.0
      SITHT = 0.0
      AGMAX = 0.0
      FAHMX = 0.0
      FAHMX2 = 0.0
      D2 = 0.0
      CALL FINDAG(I,ISPC,D,D2,H,SITAGE,SITHT,AGMAX,FAHMX,FAHMX2,DEBUG)
C
      IF(ISPC.EQ.10 .OR. ISPC.EQ.11) THEN
C
C----------
C  CHECK TO SEE IF TREE HT/DBH RATIO IS ABOVE THE MAXIMUM RATIO AT
C  THE BEGINNING OF THE CYCLE. THIS COULD HAPPEN FOR TREES COMING
C  OUT OF THE ESTAB MODEL.  IF IT IS, THEN CHECK TO SEE IF THE
C  HT/NEWDBH RATIO IS ABOVE THE MAXIMUM.  IF THIS IS ALSO TRUE, LIMIT
C  HTG TO 0.1 FOOT OR HALF THE DG, WHICH EVER IS GREATER.
C  IF IT ISN'T, THEN LET HTG BE COMPUTED THE NORMAL
C  WAY AND THEN CHECK IT AGAIN AT THAT POINT.
C----------
            BARK=BRATIO(ISPC,DBH(I),HT(I))
            TEMPH=H + HTG(I)
            TEMPD=D+DG(I)/BARK
            HTMAX = 3.9033821*D + 59.3370816
            IF(H .GT.HTMAX) THEN
              HTMAX2 = TEMPD*3.9033821 + 59.3370816
              IF(H .GE. HTMAX2) THEN
                HTG(I)=0.5 * DG(I)
                IF(HTG(I).LT.0.1)HTG(I)=0.1
              ENDIF
              GO TO 161
            ENDIF
C----------
C  NORMAL HEIGHT INCREMENT CALCULATON BASED ON INCOMMING TREE AGE
C  FIRST CHECK FOR MAX, ASMYPTOTIC HEIGHT
C----------
        IF (SITAGE .GE. AGMAX) THEN
          POTHTG= 0.1
          GO TO 1320
        ELSE
          AGP10= SITAGE + 10.
        ENDIF
C----------
C  CALL HTCALC FOR NORMAL CYCLING, SP 10 AND 11
C----------
        IF(DEBUG)WRITE(JOSTND,*)' ISPC,I,HT,AGP10= ',ISPC,I,HT(I),AGP10
C
        CALL HTCALC(I,ISPC,XSITE,AGP10,HGUESS,POTHTG)
        POTHTG= HGUESS-SITHT
C----------
C  HEIGHT GROWTH MUST BE POSITIVE
C----------
        IF(POTHTG .LT. 0.1)POTHTG= 0.1
C----------
C ASSIGN A POTENTIAL HTG FOR THE ASYMPTOTIC AGE
C----------
 1320   CONTINUE
        XMOD=1.0
        CRATIO=ICR(I)/100.
        RELHT=H/AVH
        IF(RELHT .GT. 1.)RELHT=1.
        IF(PCCF(ITRE(I)) .LT. 100.)RELHT=1.
        XMOD = 1.117148 * (1.0-EXP(-4.26558 * CRATIO))
     &          *(EXP(2.54119 * (RELHT**0.250537 -1.)))
        HTG(I) = POTHTG * XMOD
C
        IF(DEBUG)    WRITE(JOSTND,901)ICR(I),PCT(I),BA,DG(I),HT(I),
     &   POTHTG,AVH,HTG(I),DBH(I),RMAI,HGUESS,AGP10,XMOD
  901   FORMAT(' HTGF',I5,13F9.2)
C-----------
C  CHECK HT/DBH RATIO. LIMIT HTG IF NECESSARY.  HTG GETS
C  MULTIPLIED BY SCALE TO CHANGE FROM A YR  PERIOD TO FINT AND
C  MULTIPLIED BY XHT TO APPLY USER SUPPLIED GROWTH MULTIPLIERS.
C----------
        TEMPH=H + HTG(I)
        HTMAX2 = 59.3370816 + 3.9033821*TEMPD
        IF(TEMPH .GT. HTMAX2) HTG(I)=HTMAX2-H
        IF(HTG(I) .LT. 0.1) HTG(I)=0.1
        GO TO 161
      ENDIF
C----------
C  ALL SPECIES OTHER THAN RED ALDER AND COTTONWOOD. AGE NOT USED
C----------
      IF((HT(I) - 4.5) .LE. 0.)GO TO 161
      IF(DEBUG)WRITE(JOSTND,9050)I,ISP(I),DBH(I),HT(I),ICR(I),
     &AVH,XSITE,SCALE,XHT,DG(I)
 9050 FORMAT('IN HTGF 9050 I,ISP,DBH,HT,ICR,AVH,XSITE,SCALE,XHT,DG=',
     &2I5,2F10.2,I5,5F8.3)
C----------
C  ESTIMATE HEIGHT GROWTH IN HTCALC
C----------
      CALL HTCALC(I,ISPC,XSITE,DUMAG,HGUESS,POTHTG)
      HTG(I)= POTHTG
C----------
C BIG DIAMETER MODIFIER (RALPH JOHNSON 4-5-88)
C----------
      IF(DBH(I) .GT. 90.) GO TO 115
      IF(DBH(I) .LT. 40.1) GO TO 115
      BIGDX = 3.01-0.06*DBH(I)+0.00033*DBH(I)*DBH(I)
      HTG(I)=HTG(I)*BIGDX
  115 CONTINUE
C----------
C CHECK HT/DBH RATIO, IF TOO HIGH, REDUCE HTG
C----------
      CNEWHT = HT(I) + HTG(I)
      RNEWHT = 27.572 * ((DBH(I)+DG(I))**0.544)
      IF(CNEWHT .GT. RNEWHT) HTG(I) = RNEWHT - HT(I)
      IF(HTG(I) .LE. 0.1) HTG(I) = 0.1
C----------
C IF SMALL DG THEN MINIMAL HTG
C----------
      IF(DG(I) .LE. 0.04) HTG(I) = 0.1
      IF(DEBUG) WRITE(JOSTND,120)
     & CNEWHT,RNEWHT,HT(I),HTG(I),DBH(I),DG(I)
  120 FORMAT(' HTGF 120F CNEWHT,RNEWHT,HT,HTG,DBH,DG =',6F10.4)
C
  161 CONTINUE
C-----------
C   HEIGHT GROWTH EQUATION, EVALUATED FOR EACH TREE EACH CYCLE
C   MULTIPLIED BY SCALE TO CHANGE FROM A YR. PERIOD TO FINT AND
C   MULTIPLIED BY XHT TO APPLY USER SUPPLIED GROWTH MULTIPLIERS.
C----------
      HTG(I)=SCALE*XHT*HTG(I)*EXP(HTCON(ISPC))
C----------
C    APPLY DWARF MISTLETOE HEIGHT GROWTH IMPACT HERE,
C    INSTEAD OF AT EACH FUNCTION IF SPECIAL CASES EXIST.
C----------
      HTG(I)=HTG(I)*MISHGF(I,ISPC)
      TEMHTG=HTG(I)
C----------
C CHECK FOR SIZE CAP COMPLIANCE.
C----------
      IF((HT(I)+HTG(I)).GT.SIZCAP(ISPC,4))THEN
        HTG(I)=SIZCAP(ISPC,4)-HT(I)
        IF(HTG(I) .LT. 0.1) HTG(I)=0.1
      ENDIF
C
      IF(.NOT.LTRIP) GO TO 30
      ITFN=ITRN+2*I-1
      HTG(ITFN)=TEMHTG
C----------
C CHECK FOR SIZE CAP COMPLIANCE.
C----------
      IF((HT(ITFN)+HTG(ITFN)).GT.SIZCAP(ISPC,4))THEN
        HTG(ITFN)=SIZCAP(ISPC,4)-HT(ITFN)
        IF(HTG(ITFN) .LT. 0.1) HTG(ITFN)=0.1
      ENDIF
C
      HTG(ITFN+1)=TEMHTG
C----------
C CHECK FOR SIZE CAP COMPLIANCE.
C----------
      IF((HT(ITFN+1)+HTG(ITFN+1)).GT.SIZCAP(ISPC,4))THEN
        HTG(ITFN+1)=SIZCAP(ISPC,4)-HT(ITFN+1)
        IF(HTG(ITFN+1) .LT. 0.1) HTG(ITFN+1)=0.1
      ENDIF
C
      IF(DEBUG) WRITE(JOSTND,9001) HTG(ITFN),HTG(ITFN+1)
 9001 FORMAT( ' UPPER HTG =',F8.4,' LOWER HTG =',F8.4)
C----------
C   END OF TREE LOOP
C----------
   30 CONTINUE
C----------
C   END OF SPECIES LOOP
C----------
   40 CONTINUE
      IF(DEBUG)WRITE(JOSTND,9002)ICYC
 9002 FORMAT(' LEAVING SUBROUTINE HTGF  CYCLE =',I5)
C
      RETURN
C
      ENTRY HTCONS
C----------
C  ENTRY POINT FOR LOADING HEIGHT INCREMENT MODEL COEFFICIENTS THAT
C  ARE SITE DEPENDENT AND REQUIRE ONE-TIME RESOLUTION.
C----------
C  LOAD OVERALL INTERCEPT FOR EACH SPECIES.
C----------
      DO 50 ISPC=1,MAXSP
      HTCON(ISPC)=0.0
      IF(LHCOR2 .AND. HCOR2(ISPC).GT.0.0) HTCON(ISPC)=
     &    HTCON(ISPC)+ALOG(HCOR2(ISPC))
   50 CONTINUE
C
      RETURN
      END