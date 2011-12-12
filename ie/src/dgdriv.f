      SUBROUTINE DGDRIV
      IMPLICIT NONE
C----------
C  **DGDRIV--NI23   DATE OF LAST REVISION: 04/14/2009
C----------
C  THIS SUBROUTINE SERVES TWO PURPOSES:
C
C    1)  IT IS CALLED PRIOR TO PROJECTION IN ORDER TO CALIBRATE
C        THE IMBEDDED GROWTH EQUATIONS SO THAT THEY MORE NEARLY
C        MATCH PAST GROWTH RATES MEASURED IN THE STAND.  THE
C        CALIBRATION SEGMENT BEGINS AT STATEMENT 100, AND IS
C        ACCESSED ONLY WHEN THE VALUE OF LSTART IS TRUE.
C
C    2)  SUBSEQUENTLY, IT IS CALLED EACH CYCLE TO CALCULATE
C        DIAMETER INCREMENT FOR THE NEXT PERIOD.
C
C  **DGF** IS ACCESSED TO LOAD LN(DDS) INTO THE ARRAY WK3.  DDS
C  REPRESENTS CHANGE IN SQUARED DIAMETER.
C----------
COMMONS
C
C
      INCLUDE 'PRGPRM.F77'
C
C
      INCLUDE 'CALCOM.F77'
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
      INCLUDE 'PLOT.F77'
C
C
      INCLUDE 'MULTCM.F77'
C
C
      INCLUDE 'ESTCOR.F77'
C
C
      INCLUDE 'WORKCM.F77'
C
C
COMMONS
C----------
C  DIMENSIONS AND DATA STATEMENTS FOR INTERNAL VARIABLES.
C
C    CORTEM -- ARRAY USED TO TEMPORARILY STORE CALCULATED CORRECTION
C              TERMS IN THE ORDER THAT SPECIES WERE ENCOUNTERED IN
C              THE INPUT TREE LIST.  THIS ARRAY IS PRINTED TO DISPLAY
C              CORRECTION TERMS BEING USED FOR A STAND.
C        FU -- ARRAYS WHICH ARE DIMENSIONED BY SPECIES AND CARRY
C        FM    RECORD TRIPLING GROWTH MULTIPLIERS.  WE ASSUME THAT
C        FL    LN(DDS) IS NORMALLY DISTRIBUTED.  THEN, EACH RECORD
C              IS PARTITIONED INTO TRIPLES.  THE FIRST TRIPLE
C              REPRESENTS 60% OF THE ORIGINAL RECORD, AND RECEIVES
C              A GROWTH RATE BASED ON A VALUE OF LN(DDS) WHICH HAS
C              BEEN DEFLATED BY 0.14228 STANDARD DEVIATIONS.  THE
C              SECOND TRIPLE REPRESENTS 25% OF THE ORIGINAL RECORD,
C              AND RECEIVES A GROWTH RATE BASED ON A VALUE OF
C              LN(DDS) WHICH HAS BEEN INFLATED BY 1.271 STANDARD
C              DEVIATIONS.  THE FINAL TRIPLE REPRESENTS 15% OF THE
C              ORIGINAL RECORD, AND RECEIVES A GROWTH RATE WHICH IS
C              BASED ON A VALUE OF LN(DDS) THAT HAS BEEN DEFLATED BY
C              1.549 STANDARD DEVIATIONS.
C     SIGMA -- ARRAY, DIMENSIONED BY SPECIES, THAT CONTAINS THE
C              POOLED STANDARD ERRORS ABOUT PREDICTED DIAMETER
C              GROWTH.  THESE STANDARD ERRORS ARE WEIGHTED AVERAGES
C              OF THE REGRESSION ESTIMATES FOR THE IMBEDDED MODELS
C              AND THE ESTIMATES FOR THE INPUT GROWTH SAMPLE TREES.
C----------
C  SPECIES EXPANSION -- EXPANDED PSIGSQ -- 
C  WB USE COEFFICIENTS FOR L
C  LM AND PY USE COEFFICIENTS FROM TT FOR LM
C  LL USE COEFFICIENTS FOR AF
C  AS, MM, PB USE COEFFIECIENTS FOR AS FROM UT
C  CO, OH USE COEFFIECIENTS FOR OH FROM CR
C  OS USE COEFFEICIENTS FOR MH
C  PI, JU USE COEFFICIENTS FROM UT
C----------
      EXTERNAL RANN
      LOGICAL DEBUG
      REAL PN,PX,P,BARK,EDDS,TERM,RESLOG,WC,BPOPX,BNX,BNY,CSNXY
      REAL CSNXX,SLOP,RATIO,SDPRED,DIST,REGCOR,RX,RN,SIGMR1,SVAR,CORI
      REAL PVAR,TEMP,Z,VTEMP,DDS,DSQ,GDIF,GLIM,FRMT,SCALE,CORNEW
      REAL DEV,DEVSQ,XNOB,FN,SPOPN,SPOPX,SNP,SNX,SNY,SNXY,SNXX,SNYY
      REAL DN,DX,BKPT
      INTEGER ITRIPU,ITRIPL,ISI,IREFI,KOUT,K,ISPEC,KK,I,ISPC,I1,I2,I3
      REAL PVMLT,CORR,SFINT,VARYP1,EVARP1,SIG1,VARYP2,EVARP2,SSIGMA
      REAL RHO,RHOCP,XDGROW,FRL,FRM,FRU,CORMLT,WKI,D,BRATIO,BACHLO
      REAL MISDGF
      REAL STDRAT(MAXSP),CORTEM(MAXSP)
      INTEGER NUMCAL(MAXSP),N
      REAL PSIGSQ(MAXSP)
      CHARACTER DAT*10,TIM*8,SPEC*2,VVER*7,REV*10
C
      DATA PSIGSQ/
     &  0.0408,  0.0586,  0.1556,  0.0970,  0.0858,  0.1433,
     &  0.0636,  0.0970,  0.0970,  0.0636,  0.0858,  
     &  0.0586,  0.0586,  0.0970,  0.07,    0.07,    0.0586,
     &  0.1433,  0.07,    0.1433,  0.1433,  0.07,    0.0858/
C-----------
C  CHECK FOR DEBUG.
C-----------
      CALL DBCHK (DEBUG,'DGDRIV',6,ICYC)
C----------
C  BEGIN GROWTH CALCULATION SEGMENT.  BRANCH TO STATEMENT 100
C  FOR CALIBRATION.
C----------
      IF(LSTART) GO TO 100
C----------
C  CALL MULTS TO PROCESS THE MANAGED KEYWORD.
C----------
      WORK2(1)=FLOAT(MANAGD)
      CALL MULTS (7,IY(ICYC),WORK2)
      MANAGD=IFIX(WORK2(1))
C----------
C  RECALL THE VARIANCE MULTIPLIER FROM THE PRECEDING CYCLE (PVMLT).
C----------
      PVMLT=VMLT
C----------
C  CALCULATE THE VARIANCE AND COVARIANCE MULTIPLIERS FOR THE CURRENT
C  CYCLE.  COVARIANCE IS ZERO IN THE FIRST CYCLE.
C----------
      CALL AUTCOR(COVMLT,VMLT)
C----------
C  COMPUTE SERIAL CORRELATION FOR PREDICTION ERRORS.
C----------
      CORR=COVMLT/SQRT(VMLT*PVMLT)
C----------
C  LOAD WK1 WITH DBH INCREMENT FROM PREVIOUS CYCLE FOR USE IN
C  MORTS.
C----------
      DO 5 I=1,ITRN
      WK1(I)=DG(I)
    5 CONTINUE
C----------
C  CALL **DGF** TO LOAD WK2 WITH EXPECTED VALUES OF LN(DDS).
C----------
      CALL DGF(DBH)
C----------
C  LOOP THROUGH TREE LIST IN SPECIES ORDER TO COMPUTE DIAMETER
C  GROWTH FROM DDS.  ASSIGN SPECIES DEPENDENT VARIABLES.
C----------
      CALL MULTS (1,IY(ICYC),XDMULT)
      CALL CLGMULT(WK4)
C----------
C  OUTPUT MODEL COEFFICIENTS FOR DEBUG
C----------
      IF(DEBUG) WRITE(JOSTND,9002) SIGMA,XDMULT,COR
 9002 FORMAT(/11(F11.5))
      SFINT=IY(ICYC+1)-IY(1)
      DO 50 ISPC=1,MAXSP
C----------
C  COMPUTE SERIAL CORRELATION ADJUSTED FPR PERIOD LENGTH.
C----------
      VARYP1=VARDG(ISPC)*PVMLT
      EVARP1=(SQRT(1.0+4.0*VARYP1)+1.0)/2.0
      SIG1=SQRT(ALOG(EVARP1))
      VARYP2=VARDG(ISPC)*VMLT
      EVARP2=(SQRT(1.0+4.0*VARYP2)+1.0)/2.0
      SSIGMA=SQRT(ALOG(EVARP2))
      RHO=ALOG(1.0+CORR*SQRT((EVARP1-1.0)*(EVARP2-1.0)))/
     &         (SIG1*SSIGMA)
      RHOCP=SQRT(1.0-RHO*RHO)
      XDGROW=ALOG(XDMULT(ISPC))
C----------
C  IN THE FIRST CYCLE DEFINE THE GOAL FOR ATTENUATING CORRECTION
C  TERMS FOR THE SMALL TREE HEIGHT INCREMENT MODEL AND THE LARGE
C  TREE DBH INCREMENT MODEL.  CORRECTION TERMS FOR BOTH MODELS
C  WILL ATTENUATE TO 1/2 THE INITIAL VALUE OF THE CORRECTION TERM
C  FOR THE DBH INCREMENT MODEL, AND 1/2 OF THE ATTENUATION WILL
C  TAKE PLACE IN THE FIRST 25 YEARS.
C----------
      IF(ICYC.NE.1) GO TO 6
      WCI(ISPC)=0.5*COR(ISPC)
      DIFH(ISPC)=HCOR(ISPC)-WCI(ISPC)
    6 CONTINUE
      I1=ISCT(ISPC,1)
      IF(I1.EQ.0) GO TO 50
      I2=ISCT(ISPC,2)
      XDGROW=ALOG(XDMULT(ISPC))
C----------
C  IF TRIPLING, ASSIGN ERROR TO TRIPLES; ADJUST FOR SERIAL
C  CORRELATION.
C----------
      IF(.NOT.LTRIP) GO TO 10
      FRL=FL(ISPC)*SSIGMA*RHOCP
      FRM=FM(ISPC)*SSIGMA*RHOCP
      FRU=FU(ISPC)*SSIGMA*RHOCP
   10 CONTINUE
C----------
C  ATTENUATE THE CORRECTION TERM FOR THE NEXT CYCLE.
C----------
      IF (.NOT.LDGCAL(ISPC)) GO TO 15
      CORMLT=EXP(-0.02773*SFINT)
      COR(ISPC)=WCI(ISPC)+CORMLT*WCI(ISPC)
      HCOR(ISPC)=WCI(ISPC)+CORMLT*DIFH(ISPC)
      IF(DEBUG) WRITE(JOSTND,9011) ISPC,COR(ISPC),HCOR(ISPC),WCI(ISPC)
 9011 FORMAT(' FOR SPECIES ',I2,' NEW DGCOR = ',F7.4,' NEW HTCOR = '
     &  ,F7.4,' ATTENUATION GOAL = ',F7.4)
   15 CONTINUE
C----------
C  BEGIN TREE LOOP WITHIN SPECIES.
C----------
      DO 40 I3=I1,I2
      I=IND1(I3)
      WKI=0.0
      D=DBH(I)*BRATIO(ISPC,DBH(I),HT(I))
      DDS=EXP(WK2(I) + XDGROW) * WK4(I)
      DSQ=D*D
      WKI=(SQRT(DSQ+DDS)-D)
      IF(LTRIP) GO TO 30
C----------
C  CALL DGSCOR TO ASSIGN ERROR TO DIAMETER GROWTH PREDICTION.
C----------
      CALL DGSCOR (SSIGMA,FRM,RHO,RHOCP,I)
      DG(I)=(SQRT(DSQ+DDS*FRM)-D)
C----------
C  SPECIES EXPANSION -- THIS IS FROM CR DGDRIV
C  LIMIT + RANDOM DRAW TO ONE THIRD THE GROWTH ESTIMATE
C----------
      IF(ISPC.EQ. 19 .OR. ISPC.EQ. 22)THEN
        GDIF = DG(I)-WKI
        GLIM = WKI*0.33
        IF(GDIF .GT. GLIM)DG(I)=WKI+GLIM
      ENDIF
C----------
C  ACCOUNT FOR THE NEGATIVE EFFECTS OF DWARF MISTLETOE ON DIAMETER
C  GROWTH, IF ANY.
C----------
      DG(I) = DG(I) * MISDGF(I,ISPC)
C----------
C   CALL DGBND TO INSURE THAT DG DOES NOT EXCEED A MAXIMUM DG VALUE.
C----------
      CALL DGBND(ISPC,DBH(I),DG(I))
C----------
C  PRINT DEBUG INFO IF DESIRED THEN BRANCH TO END OF TREE LOOP.
C----------
      IF(.NOT.DEBUG) GO TO 40
      WRITE(JOSTND,9000) I,ISPC,D,HT(I),WKI,DG(I),FRM
 9000 FORMAT(' IN DGDRIV, I=',I4,', ISPC=',I3,', DBH=',F7.2,
     &       ', HT=',F7.2,', EXP.GR.=',F7.4,', PRED.GR.=',F7.4,
     &       ', FRM=',F7.4)
      GO TO 40
C----------
C  IF TRIPLING RECORDS, ASSIGN DIAMETER GROWTH TO ORIGINAL RECORD
C  AND TRIPLES.  DBH IS ALSO TRIPLED HERE.
C----------
   30 ITRIPU=ITRN+2*I-1
      ITRIPL=ITRIPU+1
      FRMT=FRM+CORR*OLDRN(I)
      DG(I)=SQRT(DSQ+DDS*EXP(FRMT))-D
C----------
C  SPECIES EXPANSION -- THIS IS FROM CR DGDRIV
C  LIMIT + RANDIOM DRAW TO ONE THIRD THE GROWTH ESTIMATE
C----------
      IF(ISPC.EQ.19 .OR. ISPC.EQ.22)THEN
        GDIF = DG(I)-WKI
        GLIM = WKI*0.33
        IF(GDIF .GT. GLIM)DG(I)=WKI+GLIM
      ENDIF
C----------
C  ACCOUNT FOR THE NEGATIVE EFFECTS OF DWARF MISTLETOE ON DIAMETER
C  GROWTH, IF ANY.
C----------
      DG(I) = DG(I) * MISDGF(I,ISPC)
      OLDRN(I)=FRMT
      FRMT=FRU+CORR*OLDRN(I)
      DG(ITRIPU)=(SQRT(DSQ+DDS*EXP(FRMT))-D)
C----------
C  SPECIES EXPANSION -- THIS IS FROM CR DGDRIV
C  LIMIT + RANDIOM DRAW TO ONE THIRD THE GROWTH ESTIMATE
C----------
      IF(ISPC.EQ.19 .OR. ISPC.EQ.22)THEN
        GDIF = DG(I)-WKI
        GLIM = WKI*0.33
        IF(GDIF .GT. GLIM)DG(ITRIPU)=WKI+GLIM
      ENDIF
C----------
C  DWARF MISTLETOE EFFECTS.
C----------
      DG(ITRIPU) = DG(ITRIPU) * MISDGF(I,ISPC)
      DBH(ITRIPU)=DBH(I)
      OLDRN(ITRIPU)=FRMT
      FRMT=FRL+CORR*OLDRN(I)
      DG(ITRIPL)=(SQRT(DSQ+DDS*EXP(FRMT))-D)
C----------
C  SPECIES EXPANSION -- THIS IS FROM CR DGDRIV
C  LIMIT + RANDIOM DRAW TO ONE THIRD THE GROWTH ESTIMATE
C----------
      IF(ISPC.EQ. 19 .OR. ISPC.EQ.22)THEN
        GDIF = DG(I)-WKI
        GLIM = WKI*0.33
        IF(GDIF .GT. GLIM)DG(ITRIPL)=WKI+GLIM
      ENDIF
C----------
C  DWARF MISTLETOE EFFECTS.
C----------
      DG(ITRIPL) = DG(ITRIPL) * MISDGF(I,ISPC)
      DBH(ITRIPL)=DBH(I)
      OLDRN(ITRIPL)=FRMT
C----------
C  CALL DGBND TO INSURE THAT DG DOES NOT EXCEED A MAXIMUM DG VALUE.
C----------
      CALL DGBND(ISPC,DBH(I),DG(I))
      CALL DGBND(ISPC,DBH(I),DG(ITRIPU))
      CALL DGBND(ISPC,DBH(I),DG(ITRIPL))
C----------
C  PRINT DEBUG INFO IF DESIRED.
C----------
      IF(.NOT.DEBUG) GO TO 40
      WRITE(JOSTND,9001) ISPC,D,HT(I),WKI,I,DG(I),FRM,
     &      ITRIPU,DG(ITRIPU),FRU,ITRIPL,DG(ITRIPL),FRL
 9001 FORMAT(' IN DGDRIV, ISPC=',I3,', DBH=',F7.2,
     &       ', HT=',F7.2,', EXP.GR.=',F7.4,', DG(',I4,')=',F7.4,
     &       ', FRM=',F7.4/T13,'DG(',I4,')U=',F7.4,', FRU=',
     &       F7.4,', DG(',I4,')L=',F7.4,', FRL=',F7.4)
C----------
C  END OF TREE LOOP.
C----------
   40 CONTINUE
C----------
C  END OF SPECIES LOOP.
C----------
   50 CONTINUE
      RETURN
C----------
C  THIS PROGRAM SEGMENT IS FOR CALIBRATION.  IT IS EXECUTED ONLY
C  WHEN LSTART IS TRUE.
C----------
  100 CONTINUE
C----------
C  IF CALBSTAT KEYWORD WAS PRESENT, WRITE HEADER RECORD.
C----------
      IF(JOCALB .GT. 0) THEN
        CALL VARVER(VVER)
        CALL REVISE (VVER,REV)
        CALL GRDTIM(DAT,TIM)
        IF(ISISP .LE. 0)THEN
          ISI=0
        ELSE
          ISI=SITEAR(ISISP)
        ENDIF
        WRITE(JOCALB,1000)VVER,DAT,TIM,NPLT,MGMID,KODTYP,
     &  ISISP,ISI,IAGE,REV
 1000   FORMAT(' CALBSTAT ',A7,1X,A10,1X,A8,1X,A26,1X,A4,
     &  1X,I3,1X,I2,1X,I3,1X,I3,1X,A)
      ENDIF
C----------
C  COMPUTE VARIANCE MULTIPLIER FOR YR PERIOD AND INITIALIZE VMLT.
C----------
      CALL AUTCOR(COVYR,VMLTYR)
      VMLT=VMLTYR
C----------
C  INITIALIZE SFINT TO RESTART ATTENUATION FOR THE NEXT PROJECTION.
C----------
      SFINT=0.0
      IF (ITRN.LE.0) GOTO 115
C----------
C
C     *******   CALIBRATION SECTION   *******
C
C----------
C  DEFINE SCALING FACTOR WHICH CONVERTS TERM TO A FINT-YEAR
C  PERIOD BASIS.
C----------
      SCALE=YR/FINT
C----------
C  IF INCREMENT IS INPUT AS DIFFERENCE BETWEEN TWO DBH MEASUREMENTS
C  (IDG=1 OR 3), CONVERT TO INSIDE BARK ESTIMATE.
C----------
      IF(IDG.EQ.0.OR.IDG.EQ.2) GO TO 110
      DO 105 I=1,ITRN
      ISPC=ISP(I)
      DG(I)=DG(I)*BRATIO(ISPC,DBH(I),HT(I))
  105 CONTINUE
  110 CONTINUE
C----------
C  WK3 WAS LOADED IN **DENSE** WITH DBH AS OF THE START OF THE
C  CALIBRATION PERIOD.  **DGF** IS CALLED TO LOAD WK2 WITH PREDICTED
C  LN(DDS).
C----------
      CALL DGF(WK3)
C----------
C  BEGIN PROCESSING TREE LIST IN SPECIES ORDER.
C----------
  115 CONTINUE
      DO 150 I=1,MAXSP
      STDRAT(I)=1.0
      CORTEM(I)=1.0
      WCI(I)=0.0
      NUMCAL(I)=0
  150 CONTINUE
      DO 200 ISPC=1,MAXSP
      CORNEW=1.0
      SIGMA(ISPC)=SIGMAR(ISPC)
      I1=ISCT(ISPC,1)
C----------
C  DO NOT CALCULATE CORRECTION TERMS NOR CALIBRATE BAI MODEL
C  VARIANCE IF IFINT=0 OR THERE ARE NO TREES FOR THIS SPECIES.
C----------
      IF(I1.EQ.0.OR.IFINT.EQ.0) GO TO 195
      I2=ISCT(ISPC,2)
      IREFI= IREF(ISPC)
      DEV=0.0
      DEVSQ=0.0
      N=0
      XNOB=ATTEN(ISPC)
      FN=0.0
      SPOPN=0.0
      SPOPX=0.0
      SNP=0.0
      SNX=0.0
      SNY=0.0
      SNXY=0.0
      SNXX=0.0
      SNYY=0.0
C----------
C  FIRST LOOP TO FIND MINIMUM AND MAXIMUM DBH FOR GSTS OF THIS SPECIES
C  AND ASSOCIATED PREDICTED DDS.
C----------
      DN=999.0
      DX=0.0
C----------
C  SPECIES EXPANSION - BREAKPOINT DIAMETER IS 1.0 IF CO OR OH
C  CHANGED 3.0 TO BKPT AS WELL
C----------
      BKPT = 3.0
      IF(ISPC.EQ.19.OR.ISPC.EQ.22)BKPT=1.0
C
      DO 155 I3=I1,I2
      I=IND1(I3)
      IF(WK3(I).LT.BKPT .OR.DG(I).LE.0.0) GO TO 155
      IF(WK3(I).LT.DN) THEN
        DN=WK3(I)
        PN=EXP(WK2(I))
      ENDIF
      IF(WK3(I).GT.DX) THEN
        DX=WK3(I)
        PX=EXP(WK2(I))
      ENDIF
  155 CONTINUE
C----------
C  BEGIN TREE LOOP WITHIN SPECIES.  IF MEASURED DIAMETER GROWTH
C  IS LESS THAN ZERO, OR DBH IS LESS THAN 3.0 INCHES, THE RECORD
C  WILL NOT BE INCLUDED IN THE CALIBRATION.
C----------
      DO 160 I3=I1,I2
      I=IND1(I3)
C----------
C  INITIALIZE OLDRN.
C----------
      OLDRN(I)=0.0
      P=PROB(I)
      BARK=BRATIO(ISPC,DBH(I),HT(I))
C----------
C  EXCLUDE TREES THAT ARE OUTSIDE OF THE GST DBH RANGE FROM THE
C  POPULATION TOTALS.
C----------
      IF(WK3(I).LT.DN .OR. WK3(I).GT.DX) GO TO 160
      EDDS=EXP(WK2(I))
      SPOPN=SPOPN+P
      SPOPX=SPOPX+EDDS*P
      IF(DG(I).LE.0.0) GO TO 160
      TERM=DG(I)*(2.0*BARK*WK3(I)+DG(I))*SCALE
C----------
C  SKIP CALCULATION OF STANDARD DEVIATION IF TERM=0.0
C----------
      IF(TERM.EQ.0.0) GO TO 159
      FN=FN+1.0
      RESLOG=ALOG(TERM)-WK2(I)
C----------
C  INITIALIZE OLDRN WITH LN-SCALE RESIDUAL DDS.
C----------
      IF(DGSD.GE.1.0) OLDRN(I)=RESLOG
      DEV=DEV+RESLOG
      DEVSQ=DEVSQ+RESLOG*RESLOG
  159 CONTINUE
      IF(.NOT.LDGCAL(ISPC)) GO TO 160
C----------
C  COLLECT SUMS TO REGRESS LN(RESIDUAL) ON PREDICTED DDS; WEIGHT
C  OBSERVATIONS BY PROB.
C----------
      SNP=SNP+P
      SNX=SNX+P*EDDS
      SNY=SNY+P*RESLOG
      SNXX=SNXX+P*EDDS*EDDS
      SNXY=SNXY+P*RESLOG*EDDS
      SNYY=SNYY+P*RESLOG*RESLOG
      N=N+1
C----------
C  PRINT DEBUG INFO IF DESIRED.
C----------
      IF(.NOT.DEBUG) GO TO 160
      WRITE(JOSTND,9003) I,ISPC,DG(I),TERM,DEV,DEVSQ,RESLOG
 9003 FORMAT(' IN DGDRIV,  I=',I4,',  ISPC=',I3,',  OBS. DG=',
     &       F7.4,',  TERM=',F10.4,',  CUM. DEV.=',E15.6/
     &       11X,'CUM. DEV. SQ=',E15.6,',  DEV=',E15.6)
C----------
C  END OF TREE WITHIN SPECIES LOOP.
C----------
  160 CONTINUE
      IF(DEBUG) WRITE(JOSTND,9010) ISPC,SPOPN,SPOPX,FN,SNP,
     &                             SNX,SNY,SNXX,SNXY,SNYY
 9010 FORMAT(/' SUMS FOR SPECIES ',I2,':  SPOPN=',F10.2,';  SPOPX=',
     &  F10.2,';  FN=',F6.1,';  SNP=',F10.2,';  SNX=',F10.2,';'/22X,
     &  'SNY=',F10.2,';  SNXX=',F10.2,';  SNXY=',F10.2,';  SNYY=',
     &  F10.2)
C----------
C  COMPUTE CALIBRATION TERMS.
C----------
      WC=0.0
C----------
C  DO NOT CALCULATE CORRECTION TERMS NOR CALIBRATE BAI MODEL
C  VARIANCE IF THERE ARE FEWER THAN FNMIN (DEFAULT=5.)
C  OBSERVATIONS FOR A SPECIES.
C----------
      IF(FN.LT.FNMIN) GO TO 190
C----------
C  IF NOCALIB WAS SPECIFIED, CALCULATION OF CORRECTION TERMS
C  IS BYPASSED.  MODEL VARIANCE IS, HOWEVER, ESTIMATED (STMT 180).
C----------
      IF(.NOT.LDGCAL(ISPC)) GO TO 180
C----------
C  CALCULATE MEAN RESIDUAL FOR GROWTH SAMPLE AND MEAN PREDICTED DDS
C  FOR THE POPULATION AND SAMPLE.
C----------
      BPOPX=SPOPX/SPOPN
      BNX=SNX/SNP
      BNY=SNY/SNP
C----------
C  CALCULATE CORRECTED SUMS OF SQUARES FOR RESIDUAL REGRESSION.
C----------
      CSNXY=SNXY-BNX*BNY*SNP
      CSNXX=SNXX-BNX*BNX*SNP
      IF(CSNXX .LT. 0.)THEN
        WRITE(JOSTND,161)JSP(ISPC)
  161   FORMAT(1H0,' POOR SELECTION OF GROWTH SAMPLE TREES DETECTED ',
     &  'FOR SPECIES ',A3,'. LARGE TREE DG CALIBRATION ABORTED FOR ',
     &  'THIS SPECIES.')
        GO TO 190
      ENDIF
C----------
C  CALCULATE RATIO AND REGRESSION ESTIMATORS.
C----------
      SLOP=CSNXY/CSNXX
      RATIO=BNY
C----------
C  CALCULATE DISTANCE BETWEEN MEAN PREDICTED VALUES FOR POPULATION AND
C  GROWTH SAMPLE WEIGHTED BY THE STANDARD DEVIATION OF THE GROWTH SAMPLE
C  PREDICTIONS (ADJUSTED SO THAT SUM OF PROB IS EQUAL TO NUMBER OF
C  GROWTH SAMPLE TREES).
C----------
      SDPRED=SQRT(CSNXX/(SNP*(1.0-1.0/FN)))
      DIST=ABS(BPOPX-BNX)/SDPRED
      IF (DEBUG) WRITE(JOSTND,876) SLOP,RATIO,DIST
 876  FORMAT(' SLOP RATIO DIST=',3(2X,F10.2))
C----------
C  REGRESSION ESTIMATE OF CORRECTION FACTOR IS OBTAINED BY SOLVING
C  THE RESIDUAL REGRESSION AT THE MEAN PREDICTED DDS FOR THE POPULATION.
C----------
      REGCOR=BNY+(BPOPX-BNX)*SLOP
C----------
C  ACTUAL CORRECTION FACTOR IS A WEIGHTED AVERAGE OF THE REGRESSION AND
C  RATIO ESTIMATORS WHERE THE WEIGHT IS DEPENDENT ON DIST.  FOR DIST
C  LESS THAN OR EQUAL TO 1, USE THE REGRESSION ESTIMATOR; FOR DIST
C  GREATER THAN 3, USE THE RATIO ESTIMATOR; FOR 1 < DIST < 3, USE
C  DIST/2*(RATIO ESTIMATE) +(1-DIST/2)*(REGRESSION ESTIMATE).
C----------
      IF(DIST.GT.3.0) CORNEW=RATIO
      IF(DIST.LE.1.0) CORNEW=REGCOR
      IF(DIST.GT.1.0 .AND. DIST.LE.3.0)
     &       CORNEW=RATIO*(DIST/2.0)+REGCOR*(1.0-DIST/2.0)
      COR(ISPC)=CORNEW
C----------
C  LOAD INITIAL ERRORS FOR THE SERIAL CORRELATION CORRECTION (OLDRN)
C  FOR NON-GSTS FROM THE PREDICTED LN(DDS) VALUES OBTAINED BY SOLVING
C  THE CALIBRATION REGRESSION FOR THE PREDICTED DDS VALUE. TREES THAT
C  HAVE GREATER DBH THAN THE LARGEST TREE IN THE GROWTH SAMPLE ARE
C  ASSIGNED THE PREDICTED RESIDUAL FOR THE LARGEST TREE IN THE GROWTH
C  SAMPLE;  TREES WITH DBH LESS THAN THE SMALLEST TREE IN THE GROWTH
C  SAMPLE ARE ASSIGNED THE PREDICTED RESIDUAL FOR THE SMALLEST TREE IN
C  THE GROWTH SAMPLE. ASSIGNMENT IS BYPASSED IF RANDOM EFFECTS ARE
C  SUPPRESSED (DGSD < 1)
C---------- 
      IF(DGSD.GE.1.0) THEN
        RX=BNY+(PX-BNX)*SLOP
        RN=BNY+(PN-BNX)*SLOP
        DO 170 I3=I1,I2
         I=IND1(I3)
         IF(OLDRN(I).NE.0.0) GO TO 170
         EDDS=EXP(WK2(I))
         OLDRN(I)=BNY+(EDDS-BNX)*SLOP
         IF(WK3(I).LT.DN) OLDRN(I)=RN
         IF(WK3(I).GT.DX) OLDRN(I)=RX
  170   CONTINUE
      ENDIF
C----------
C  CALIBRATE THE BAI MODEL VARIANCE.
C  USE A POOLED ESTIMATE OF THE VARIANCE CALCULATED FROM THE SAMPLE
C  AND FROM THE BASE MODELS.
C----------
  180 SIGMR1=SIGMAR(ISPC)**2
      SVAR=DEVSQ-(DEV*DEV)/FN
      SIGMA(ISPC)=SQRT((SVAR+XNOB*SIGMR1)/(FN+XNOB))
      SVAR=SVAR/(FN-1.0)
      STDRAT(IREFI)=SQRT(SVAR/SIGMR1)
C----------
C  IF NOCALIB WAS SPECIFIED DO NOT SCALE THE CORRECTION TERMS.
C----------
      IF(.NOT.LDGCAL(ISPC)) GO TO 194
      CORI=COR(ISPC)
C----------
C  USE THE BASE MODEL VARIANCE AND ASSOCIATED DEGREES OF FREEDOM
C  TO DISCRIBE THE PRIOR DISTRIBUTION OF BASAL AREA INCREMENTS.
C
C  USE THIS PRIOR DISTRIBUTION WITH AN EMPIRICAL BAYES ESTIMATION TO
C  ADJUST THE CORRECTION TERMS.  THIS IS DONE FOR EACH SPECIES.
C----------
      SVAR=SVAR/FN
      PVAR=PSIGSQ(ISPC)
      TEMP=CORI*CORI/PVAR
C----------
C THE CONSTRAINT HERE WAS 176.0 FROM THE ORIGINAL NI CODE. THIS CAUSES
C AN UNDERFLOW ERROR IF IMPOSED. CHANGED TO 72.0 8/31/04 BY GARY DIXON.
C THE VALUE OF E(-36) IS 2.3(-16) WHICH IS AROUND THE LIMIT THAT A 
C NUMBER CAN BE DISTINGUISHED FROM 0.0 IN SINGLE PRECISION.
C----------
      IF(TEMP.GT.72.0) TEMP=72.0
      WC=1.0/(1.0+EXP(-0.5*TEMP)*SQRT(SVAR/PVAR))
      COR(ISPC)= WC * CORI
      IF (DEBUG) WRITE (JOSTND,9009) ISPC,COR(ISPC)
 9009 FORMAT (' IN DGDRIV, ISPC=',I3,' COR=',E15.7)
      GO TO 193
  190 CONTINUE
C----------
C  FEWER THAN 5 GSTS; ASSIGN OLDRN WITH RANDOM NUMBER GENERATOR.
C  BYPASS ASSIGNMENT IF DGSD < 1.
C----------
      IF(DGSD.LT.1) GO TO 193
      DO 192 I3=I1,I2
      I=IND1(I3)
  191 CONTINUE
      Z=BACHLO(0.0,SIGMA(ISPC),RANN)
      IF(Z.GT.DGSD*SIGMA(ISPC)) GO TO 191
      OLDRN(I)=Z
  192 CONTINUE
  193 CONTINUE
C----------
C  PREPARE AND PRINT THE CALIBRATION OUTPUT.
C----------
      WCI(IREFI)= WC
      CORTEM(IREFI)= EXP(COR(ISPC))
C----------
C  TRAP CALIBRATION VALUES OUTSIDE 2.5 STANDARD DEVIATIONS FROM THE 
C  MEAN. IF C IS THE CALIBRATION TERM, WITH A DEFAULT OF 1.0, THEN
C  LN(C) HAS A MEAN OF 0.  -2.5 < LN(C) < 2.5 IMPLIES 
C  0.0821 < C < 12.1825
C----------
      IF(CORTEM(IREFI).LT.0.0821 .OR. CORTEM(IREFI).GT.12.1825) THEN
        CALL ERRGRO(.TRUE.,27)
        WRITE(JOSTND,9194)ISPC,JSP(ISPC),CORTEM(IREFI)
 9194   FORMAT(T28,' LARGE TREE DG: SPECIES = ',I2,' (',A3,
     &  ') CALCULATED CALIBRATION VALUE = ',F8.2)
        CORTEM(IREFI)=1.0
        COR(ISPC)=0.0
      ENDIF
  194 CONTINUE
      NUMCAL(IREFI)= N
  195 CONTINUE
C----------
C  COMPUTE VARIANCE OF ANNUAL DG AND STORE.
C----------
      VTEMP=EXP(SIGMA(ISPC)**2)
      VARDG(ISPC)=(VTEMP-1.0)*VTEMP/VMLT
C----------
C  LOAD RECORD TRIPLING GROWTH MULTIPLIERS.
C----------
      FU(ISPC)=  1.271 
      FM(ISPC)=  -.14228 
      FL(ISPC)=  -1.549 
C----------
C  END OF CALIBRATION LOOP
C----------
  200 CONTINUE
C----------
C  LIMIT INITIAL VALUES OF OLDRN() TO + OR - DGSD*SIGMA, TO AVOID
C  AN INFINITE LOOP IN ** DGSCOR ** .   GED 12/18/96.
C----------
      DO 202 I=1,ITRN
      ISPC=ISP(I)
      IF(OLDRN(I) .GT.  DGSD*SIGMA(ISPC)) OLDRN(I)= DGSD*SIGMA(ISPC)
      IF(OLDRN(I) .LT. -DGSD*SIGMA(ISPC)) OLDRN(I)=-DGSD*SIGMA(ISPC)
  202 CONTINUE
      IF(IFINT.EQ.0) GO TO 210
      IF (ITRN.EQ.0) RETURN
C
      WRITE(JOSTND,9004)(NUMCAL(I),I=1,NUMSP)
 9004 FORMAT (/,' NUMBER OF RECORDS AVAILABLE FOR SCALING'/
     &       ' THE DIAMETER INCREMENT MODEL',((T49,11(I5,1X)/)))
C
      WRITE (JOSTND,9008) (STDRAT(I),I=1,NUMSP)
 9008 FORMAT(/' RATIO OF STANDARD ERRORS'/
     &       ' (INPUT DBH GROWTH DATA : MODEL)',((T49,11(F5.2,1X)/)))
C
      WRITE (JOSTND,9005) (WCI(I), I=1, NUMSP)
 9005 FORMAT (/,' WEIGHT GIVEN TO THE INPUT GROWTH DATA WHEN'/
     >        ' DBH GROWTH MODEL SCALE FACTORS WERE COMPUTED',
     >        ((T49,11(F5.2,1X)/)))
C
      WRITE(JOSTND,9006) (CORTEM(I), I= 1, NUMSP)
 9006 FORMAT (/' INITIAL SCALE FACTORS FOR THE'/
     >       ' DBH INCREMENT MODEL',((T49,11(F5.2,1X)/)))
C----------
C OUTPUT CALIBRATION TERMS IF CALBSTAT KEYWORD WAS PRESENT.
C----------
      IF(JOCALB .GT. 0) THEN
        KOUT=0
        DO 207 K=1,MAXSP
        IF(CORTEM(K).NE.1.0 .OR. NUMCAL(K).GE.FNMIN) THEN
          SPEC=NSP(MAXSP,1)(1:2)
          ISPEC=MAXSP
          DO 203 KK=1,MAXSP
          IF(K .NE. IREF(KK)) GO TO 203
          ISPEC=KK
          SPEC=NSP(KK,1)(1:2)
          GO TO 2031
  203     CONTINUE
 2031     WRITE(JOCALB,204)ISPEC,SPEC,NUMCAL(K),CORTEM(K),STDRAT(K),
     &    WCI(K)
  204     FORMAT(' CAL: LD',1X,I2,1X,A2,1X,I4,3(1X,F6.3))
          KOUT=KOUT+1
        ENDIF
  207   CONTINUE
        IF(KOUT .EQ. 0) WRITE(JOCALB,209)
  209   FORMAT(' NO LD VALUES COMPUTED')
      ENDIF
      GO TO 215
  210 CONTINUE
      WRITE(JOSTND,9007)
 9007 FORMAT(/,' NO CORRECTION TERMS ARE CALCULATED WHEN GROWTH',
     &        ' MEASUREMENT PERIOD IS ZERO.')
C----------
C  DUB IN DBH INCREMENT FOR TREES ON WHICH IT WAS NOT MEASURED.
C----------
  215 CONTINUE
      CALL DGF(WK3)
C
C     SET ICL6 AND SCALE
C
      ICL6=IFINT
      SCALE=1./SCALE
C----------
C  CHECK FOR A VALID ESTIMATE OF DIAMETER INCREMENT.  COMPUTE A NEW 
C  INCREMENT IF INPUT VALUE IS MISSING; IF INPUT INCREMENT EXCEEDS 
C  CURRENT DIAMETER, REPLACE AND PRINT WARNING MESSAGE.
C----------
      DO 220 I = 1,ITRN
      ISPC=ISP(I)
      BARK=BRATIO(ISPC,DBH(I),HT(I))
      D=WK3(I)*BARK
      IF(DG(I).GT.0.0.AND.HT(I).GT.4.5) THEN
        IF(IDG.LT.2 .AND. DG(I).GT.DBH(I)*BARK) THEN
          WRITE(JOSTND,9012) I,DG(I),DBH(I)*BARK
 9012     FORMAT(/' NOTE: FOR TREE ',I4,' DG (',F5.2,
     &            ') IS GREATER THAN IB DBH (',F5.2,')'/
     &            '       DG RESET TO INSIDE BARK DBH.')
          DG(I)=DBH(I)*BARK
        ENDIF
        WORK1(I)=DG(I)
      ELSE
        IF(HT(I).LE.4.5) THEN
          DG(I)=0.0
        ELSE 
          DG(I)=SQRT(D*D+EXP((WK2(I)+OLDRN(I)))*SCALE)-D
          IF(DG(I) .GT. D) DG(I)=D
C----------
C   CALL DGBND TO SET BOUNDS ON VALUE OF DG.
C----------
          CALL DGBND (ISPC,DBH(I),DG(I))
        ENDIF
        WORK1(I)=0.
      ENDIF
  220 CONTINUE
      RETURN
      END
