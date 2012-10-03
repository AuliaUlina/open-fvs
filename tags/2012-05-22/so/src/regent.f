      SUBROUTINE REGENT(LESTB,ITRNIN)
      IMPLICIT NONE
C----------
C  **REGENT--SO   DATE OF LAST REVISION:  01/13/12
C----------
C  THIS SUBROUTINE COMPUTES HEIGHT AND DIAMETER INCREMENTS FOR
C  SMALL TREES.  THE HEIGHT INCREMENT MODEL IS APPLIED TO TREES
C  THAT ARE LESS THAN 10 INCHES DBH (5 INCHES FOR LODGEPOLE PINE),
C  AND THE DBH INCREMENT MODEL IS APPLIED TO TREES THAT ARE LESS
C  THAN 3 INCHES DBH.  FOR TREES THAT ARE GREATER THAN 2 INCHES
C  DBH (1 INCH FOR LODGEPOLE PINE), HEIGHT INCREMENT PREDICTIONS
C  ARE AVERAGED WITH THE PREDICTIONS FROM THE LARGE TREE MODEL.
C  HEIGHT INCREMENT IS A FUNCTION OF SITE HEIGHT, CALCULATED
C  IN **SMHTGF**, AND MODIFIED BY VIGOR AND DENSITY FUNCTIONS
C  OF CCF, TOP HEIGHT AND CROWN RATIO.  DIAMETER IS ASSIGNED FROM
C  A HEIGHT-DIAMETER FUNCTION WITH ADJUSTMENTS FOR RELATIVE SIZE
C  AND STAND DENSITY.  INCREMENT IS COMPUTED BY SUBTRACTION.
C  THIS ROUTINE IS CALLED FROM **CRATET** DURING CALIBRATION AND
C  FROM **TREGRO** DURING CYCLING.  ENTRY **REGCON** IS CALLED FROM
C  **RCON** TO LOAD MODEL PARAMETERS THAT NEED ONLY BE RESOLVED ONCE.
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
      INCLUDE 'CALCOM.F77'
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
      INCLUDE 'HTCAL.F77'
C
C
      INCLUDE 'MULTCM.F77'
C
C
      INCLUDE 'ESTCOR.F77'
C
C
      INCLUDE 'PDEN.F77'
C
C
      INCLUDE 'VARCOM.F77'
C
C
COMMONS
C----------
C  DIMENSIONS FOR INTERNAL VARIABLES:
C
C   CORTEM -- A TEMPORARY ARRAY FOR PRINTING CORRECTION TERMS.
C   NUMCAL -- A TEMPORARY ARRAY FOR PRINTING NUMBER OF HEIGHT
C             INCREMENT OBSERVATIONS BY SPECIES.
C    RHCON -- CONSTANT FOR THE HEIGHT INCREMENT MODEL.  ZERO FOR ALL
C             SPECIES IN THIS VARIANT
C     XMAX -- UPPER END OF THE RANGE OF DIAMETERS OVER WHICH HEIGHT
C             INCREMENT PREDICTIONS FROM SMALL AND LARGE TREE MODELS
C             ARE AVERAGED.
C     XMIN -- LOWER END OF THE RANGE OF DIAMETERS OVER WHICH HEIGHT
C             INCREMENT PREDICTIONS FROM THE SMALL AND LARGE TREE
C             ARE AVERAGED.
C  SPECIES ORDER:
C  1=WP,  2=SP,  3=DF,  4=WF,  5=MH,  6=IC,  7=LP,  8=ES,  9=SH,  10=PP,
C 11=JU, 12=GF, 13=AF, 14=SF, 15=NF, 16=WB, 17=WL, 18=RC, 19=WH,  20=PY,
C 21=WA, 22=RA, 23=BM, 24=AS, 25=CW, 26=CH, 27=WO, 28=WI, 29=GC,  30=MC,
C 31=MB, 32=OS, 33=OH
C----------
      EXTERNAL RANN
      LOGICAL DEBUG,LESTB,LSKIPH
      CHARACTER SPEC*2
      INTEGER KK,ISPEC,KOUT,IREFI,N,IPCCF,MODE1,K,L,JCR
      INTEGER J,ISPC,I1,I2,I3,I,ITRNIN,NUMCAL(MAXSP)
      REAL RDCON(MAXSP),RDCR(MAXSP)
      REAL RDLHT(MAXSP),RDHT(MAXSP),RDDUM(MAXSP)
      REAL REGYR,CORTEM(MAXSP),DGMAX(MAXSP),DIAM(MAXSP)
      REAL XMAX(MAXSP),XMIN(MAXSP),SLO(MAXSP),SHI(MAXSP),AB(9)
      REAL D,CR,RAN,H,BARK,VIGOR,RELSDI,RSIMOD,HITE1,HTGR,TEMT
      REAL POTHTG,ZZRAN,XPPMLT,XWT,BKPT,HK,BX,AX,DK,DKK,PPCCF,DDUM
      REAL CRCODE,ALHT,TERM,P,EDH,H2,AG1,SCALE,SNY,SNX,SNP,CORNEW,HTNEW
      REAL DDS,DGSM,XDWT,DAT45,ALHK,TPCCF,HITE2,AG2,RELSI,BRATIO,BACHLO
      REAL DGMX,SCALE2,SI,XMN,XMX,CON,FNT,CCF,AVHT,PCTRED,XRHGRO
      REAL XRDGRO,SCALE3,X,HLESS4,DLESS3
      REAL SITHT,SITAGE,AGMAX,HTMAX,HTMAX2,D1,D2
C----------
C  DATA STATEMENTS.
C----------
C RJ 11/28/88 MAX DIAMETER GROWTHS
C----------
      DATA DGMAX /
     & 2.8, 2.8, 2.4, 3.6, 2.5, 2.5, 3.5, 3.6, 3.6, 2.8,
     & 2.0, 3.6, 3.6, 3.6, 5.0, 2.8, 2.8, 2.5, 5.0, 5.0,
     & 5.0, 5.0, 5.0, 2.5, 5.0, 5.0, 2.8, 5.0, 5.0, 5.0,
     & 5.0, 2.4, 5.0/
C
      DATA XMAX /
     & 3.0, 5.0, 4.0, 4.0, 2.0, 4.0, 4.0, 4.0, 4.0, 5.0,
     & 99., 4.0, 4.0, 4.0, 4.0, 3.0, 4.0, 10., 4.0, 4.0,
     & 4.0, 4.0, 4.0, 4.0, 4.0, 4.0, 4.0, 4.0, 4.0, 4.0,
     & 4.0, 4.0, 4.0/
C
      DATA XMIN /
     & 2.0, 1.0, 2.0, 2.0, 1.0, 2.0, 2.0, 2.0, 2.0, 1.0,
     & 90., 2.0, 2.0, 2.0, 2.0, 1.5, 2.0, 2.0, 2.0, 2.0,
     & 2.0, 2.0, 2.0, 2.0, 2.0, 2.0, 2.0, 2.0, 2.0, 2.0,
     & 2.0, 2.0, 2.0/
C
C  IF SHI AND SLO CHANGE, ALSO CHANGE THEM IN **SITSET**
C
      DATA SLO/
     & 13.,  27.,  21.,  5.,  5.,  5.,  5., 12., 10., 7.,
     &  5.,   9.,   6.,  4.,  7., 20., 60., 29.,  6., 5.,
     &  5.,  56., 108., 30., 10., 10., 21., 20.,  5., 5.,
     &  5.,   5.,   5./
C
      DATA SHI/
     & 137., 178., 148., 195., 133., 169., 140., 227., 134., 176.,
     &  40., 173., 127., 221., 210.,  65., 147., 152., 203.,  75.,
     & 100., 192., 142.,  66., 191., 104.,  85.,  93., 100.,  75.,
     &  75., 175., 125./
C
      DATA DIAM/
     & 0.4, 0.4, 0.3, 0.3, 0.2, 0.2, 0.4, 0.3, 0.2, 0.5,
     & 0.3, 0.3, 0.3, 0.3, 0.3, 0.4, 0.3, 0.2, 0.2, 0.2,
     & 0.2, 0.3, 0.2, 0.2, 0.2, 0.2, 0.2, 0.2, 0.2, 0.2,
     & 0.2, 0.3, 0.2/
C
      DATA AB/
     & 1.11436,-.011493,.43012E-4,-.72221E-7,.5607E-10,-.1641E-13,3*0./
C----------
C COEFS FOR THE DIA LOOKUP FUNCTION - WC VARIANT SPECIES
C----------
        DATA RDCON/
     & 0.0000, 0.0000, 0.0000, 0.0000, 0.0000,
     & 0.0000, 0.0000, 0.0000, 0.0000, 0.0000,
     & 0.0000, 0.0000, 0.0000, 0.0000,-2.0890,
     & 0.0000, 0.0000, 0.0000,-0.6740,-2.0890,
     & 3.1020, 3.1020, 3.1020, 0.0000, 3.1020,
     & 3.1020, 0.0000, 3.1020, 3.1020, 3.1020,
     & 3.1020, 0.0000, 3.1020/
C
      DATA RDCR/
     & 0.0000, 0.0000, 0.0000, 0.0000, 0.0000,
     & 0.0000, 0.0000, 0.0000, 0.0000, 0.0000,
     & 0.0000, 0.0000, 0.0000, 0.0000, 0.0000,
     & 0.0000, 0.0000, 0.0000, 0.0000, 0.0000,
     & 0.0000, 0.0000, 0.0000, 0.0000, 0.0000,
     & 0.0000, 0.0000, 0.0000, 0.0000, 0.0000,
     & 0.0000, 0.0000, 0.0000/
C
      DATA RDLHT/
     & 0.0000, 0.0000, 0.0000, 0.0000, 0.0000,
     & 0.0000, 0.0000, 0.0000, 0.0000, 0.0000,
     & 0.0000, 0.0000, 0.0000, 0.0000, 1.9800,
     & 0.0000, 0.0000, 0.0000, 1.5220, 1.9800,
     & 0.0000, 0.0000, 0.0000, 0.0000, 0.0000,
     & 0.0000, 0.0000, 0.0000, 0.0000, 0.0000,
     & 0.0000, 0.0000, 0.0000/
C
      DATA RDHT/
     & 0.0000, 0.0000, 0.0000, 0.0000, 0.0000,
     & 0.0000, 0.0000, 0.0000, 0.0000, 0.0000,
     & 0.0000, 0.0000, 0.0000, 0.0000, 0.0000,
     & 0.0000, 0.0000, 0.0000, 0.0000, 0.0000,
     & 0.0210, 0.0210, 0.0210, 0.0000, 0.0210,
     & 0.0210, 0.0000, 0.0210, 0.0210, 0.0210,
     & 0.0210, 0.0000, 0.0210/
C
      DATA RDDUM/
     & 0.0000, 0.0000, 0.0000, 0.0000, 0.0000,
     & 0.0000, 0.0000, 0.0000, 0.0000, 0.0000,
     & 0.0000, 0.0000, 0.0000, 0.0000, 0.0000,
     & 0.0000, 0.0000, 0.0000, 0.0000, 0.0000,
     & 0.0000, 0.0000, 0.0000, 0.0000, 0.0000,
     & 0.0000, 0.0000, 0.0000, 0.0000, 0.0000,
     & 0.0000, 0.0000, 0.0000/
C-----------
C  CHECK FOR DEBUG.
C-----------
      LSKIPH=.FALSE.
      CALL DBCHK (DEBUG,'REGENT',6,ICYC)
      IF(DEBUG) WRITE(JOSTND,9980)ICYC
 9980 FORMAT(' ENTERING SUBROUTINE REGENT  CYCLE =',I5)
C----------
C  IF THIS IS THE FIRST CALL TO REGENT, BRANCH TO STATEMENT 40 FOR
C  MODEL CALIBRATION.
C----------
      IF(LSTART) GOTO 40
      CALL MULTS (3,IY(ICYC),XRHMLT)
      CALL MULTS(6,IY(ICYC),XRDMLT)
      IF (ITRN.LE.0) GO TO 91
C----------
C  HEIGHT INCREMENT IS DERIVED FROM A HEIGHT-AGE CURVE AND IS NOMINALLY
C  BASED ON A 10-YEAR GROWTH PERIOD.  THE VARIABLE SCALE IS USED TO CONVERT
C  HEIGHT INCREMENT PREDICTIONS TO A FINT-YEAR PERIOD.  DIAMETER
C  INCREMENT IS PREDICTED FROM CHANGE IN HEIGHT, AND IS SCALED TO A 10-
C  YEAR PERIOD BY APPLICATION OF THE VARIABLE SCALE2.  DIAMETER INCREMENT
C  IS CONVERTED TO A FINT-YEAR BASIS IN **UPDATE**.
C----------
      FNT=FINT
      IF(LESTB) THEN
        IF(FINT.LE.5.0) THEN
          LSKIPH=.TRUE.
        ELSE
          FNT=FNT-5.0
        ENDIF
      ENDIF
C----------
C  IF CALLED FROM **ESTAB** INTERPOLATE MID-PERIOD CCF AND TOP HT
C  FROM VALUES AT START AND END OF PERIOD.
C----------
      CCF=RELDEN
      AVHT=AVH
      IF(LESTB.AND.FNT.GT.0.0) THEN
        CCF=(5.0/FINT)*RELDEN +((FINT-5.0)/FINT)*ATCCF
        AVHT=(5.0/FINT)*AVH +((FINT-5.0)/FINT)*ATAVH
      ENDIF
C---------
C COMPUTE DENSITY MODIFIER FROM CCF AND TOP HEIGHT.
C---------
      X=AVHT*(CCF/100.0)
      IF(X .GT. 300.0) X=300.0
      PCTRED=AB(1)
     & + X*(AB(2) + X*(AB(3) + X*(AB(4) + X*(AB(5)+ X*AB(6)))))
      IF(PCTRED .GT. 1.0) PCTRED = 1.0
      IF(PCTRED .LT. 0.01) PCTRED = 0.01
      IF(DEBUG) WRITE(JOSTND,9982) AVHT,CCF,X,PCTRED
 9982 FORMAT(' IN REGENT AVHT,CCF,X,PCTRED = ',4F10.4)
C----------
C  ENTER GROWTH PREDICTION LOOP.  PROCESS EACH SPECIES AS A GROUP;
C  LOAD CONSTANTS FOR NEXT SPECIES.
C----------
      DO 30 ISPC=1,MAXSP
      I1=ISCT(ISPC,1)
      IF(I1.EQ.0) GO TO 30
      I2=ISCT(ISPC,2)
      XRHGRO=XRHMLT(ISPC)
      XRDGRO=XRDMLT(ISPC)
      CON=RHCON(ISPC) * EXP(HCOR(ISPC))
      XMX=XMAX(ISPC)
      XMN=XMIN(ISPC)
      SI=SITEAR(ISPC)
      IF(SI .GT. SHI(ISPC)) SI=SHI(ISPC)
      IF(SI .LE. SLO(ISPC)) SI=SLO(ISPC) + 0.5
C
      IF(ISPC.EQ.9.OR.ISPC.EQ.27)THEN
        REGYR=5.
      ELSE
        REGYR=10.
      ENDIF
      SCALE=FNT/REGYR
      SCALE2=YR/FNT
C----------
C     PUT A CEILING ON DIAMETER GROWTH BASED ON OLIVER AND COCHRAN EMPR.
C     RJ 11/28/88
C----------
      DGMX = DGMAX(ISPC) * SCALE
      IF(ISPC.EQ.16)DGMX=FINT*0.2
C----------
C  PROCESS NEXT TREE RECORD.
C----------
      DO 25 I3=I1,I2
      I=IND1(I3)
      D=DBH(I)
      IF(D .GE. XMX)GO TO 25
      IPCCF=ITRE(I)
C----------
C  BYPASS INCREMENT CALCULATIONS IF CALLED FROM ESTAB AND THIS IS NOT A
C  NEWLY CREATED TREE.
C----------
      IF(LESTB) THEN
        IF(I.LT.ITRNIN) GO TO 25
C----------
C  ASSIGN CROWN RATIO FOR NEWLY ESTABLISHED TREES.
C----------
        CR = 0.89722 - 0.0000461*PCCF(IPCCF)
    1   CONTINUE
        RAN = BACHLO(0.0,1.0,RANN)
        IF(RAN .LT. -1.0 .OR. RAN .GT. 1.0) GO TO 1
        CR = CR + 0.07985 * RAN
        IF(CR .GT. .90) CR = .90
        IF(CR .LT. .20) CR = .20
        ICR(I)=(CR*100.0)+0.5
      ENDIF
      K=I
      L=0
C---------
C COMPUTE VIGOR MODIFIER FROM CROWN RATIO.
C---------
      JCR=ICR(I)/10.
      H=HT(I)
      BARK=BRATIO(ISPC,D,H)
      IF(LSKIPH) THEN
        HTG(K)=0.0
        GO TO 5
      ENDIF
      X=FLOAT(ICR(I))/100.
      VIGOR = (150.0 * (X**3.0)*EXP(-6.0*X))+0.3
      IF(VIGOR .GT. 1.0)VIGOR=1.0
C----------
C  VIGOR ADJUSTMENT TO DRASTIC FOR PINYON, JUNIPER, AND OAK
C  CUT IT BY TWO-THIRDS (FROM UT 6(AS) USED FOR SO 24(AS)
C----------
      IF(ISPC.EQ.11)VIGOR=1.-((1.-VIGOR)/3.)
C----------
C     RETURN HERE TO PROCESS NEXT TRIPLE.
C----------
    2 CONTINUE
C----------
C  BEGIN POTHTG SECTION
C----------
      SELECT CASE(ISPC)
      CASE(24)
        IF(LESTB)THEN
          SITAGE = ABIRTH(I)
        ELSE
          IF(DEBUG)WRITE(JOSTND,*)' IN REGENT, CALLING FINDAG I= ',I
C----------
C  CALL FINDAG TO CALCULATE EFFECTIVE AGE
C----------
          SITAGE = 0.0
          SITHT = 0.0
          AGMAX = 0.0
          HTMAX = 0.0
          HTMAX2 = 0.0
          H = HT(I)
          D2 = 0.0
          CALL FINDAG(I,ISPC,D,D2,H,SITAGE,SITHT,AGMAX,HTMAX,HTMAX2,
     &                DEBUG)
        ENDIF
        RELSI=(SI-SLO(ISPC))/(SHI(ISPC)-SLO(ISPC))
        RSIMOD = 0.5 * (1.0 + RELSI)
C----------
C COMPUTE HT GROWTH AND AGE FOR ASPEN. EQN FROM WAYNE SHEPPARD RMRS.
C----------
        HITE1 = 26.9825 * SITAGE**1.1752
        AG2 = SITAGE + 10.0
        HITE2 = 26.9825 * AG2**1.1752
        HTGR = (HITE2-HITE1)/(2.54*12.0) * RSIMOD * CON
        HTGR=HTGR*2.40
C----------
C GROWTH RATES APPEAR HIGH, REDUCE BY 25 PERCENT. DIXON 8-27-92
C----------
        HTGR = HTGR * .75
        GO TO 4
      CASE DEFAULT
C-----------
C CALL SMHTGF, THE SMALL TREE HEIGHT GROWTH ROUTINE. SMHTGF IS ALSO
C CALLED FROM ESSUBH TO GROW PLANTED AND NATURAL TREES FROM
C ESTABLISHMENT TO 5 YEARS INTO THE CYCLE
C-----------
        TEMT=10.
        MODE1=1
        CALL SMHTGF(MODE1,ICYC,ISPC,H,FLOAT(ICR(I)),
     &              TEMT,POTHTG,JOSTND,DEBUG)
        IF(DEBUG)WRITE(JOSTND,*)' SMHTGF-ICYC,ISPC,H,CR,TEMT,POTHTG= '
        IF(DEBUG)WRITE(JOSTND,*)ICYC,ISPC,H,FLOAT(ICR(I)),TEMT,POTHTG
C
      END SELECT
C----------
C  END POTHTG SECTION
C  BEGIN VIGOR ADJUSTMENT
C  SPECIES FROM CA (9, 27) DO NOT USE VIGOR KNOCK-DOWN METOD)
C----------
      IF(ISPC.EQ.9.OR.ISPC.EQ.27)THEN
        HTGR=POTHTG*CON
      ELSE
        HTGR=POTHTG*PCTRED*VIGOR*CON
      ENDIF
      IF(DEBUG) WRITE(JOSTND,9983) X,VIGOR,HTGR,CON
 9983 FORMAT(' IN REGENT X,VIGOR,HTGR,CON = ',4F10.4)
C----------
C  RANDOM HT COMPONENT
C----------
    4 CONTINUE
      ZZRAN = 0.0
      IF(DGSD.GE.1.0) ZZRAN=BACHLO(0.0,1.0,RANN)
      IF((ZZRAN .GT. 0.5) .OR. (ZZRAN .LT. -2.0)) GO TO 4
      IF(DEBUG)WRITE(JOSTND,9984) HTGR,ZZRAN,XRHGRO,SCALE
 9984 FORMAT(1H ,'IN REGENT 9984 FORMAT',4(F10.4,2X))
      HTGR = (HTGR +ZZRAN*0.1)*XRHGRO * SCALE
C----------
C     GET A MULTIPLIER FOR THIS TREE FROM PPREGT TO ACCOUNT FOR
C     THE DENSITY EFFECTS OF NEIGHBORING TREES.
C----------
      XPPMLT=1.
      CALL PPREGT (XPPMLT,AVHT/100.,AB,CCF)
      HTGR = HTGR * XPPMLT
C-------------
C     COMPUTE WEIGHTS FOR THE LARGE AND SMALL TREE HEIGHT INCREMENT
C     ESTIMATES.  IF DBH IS LESS THAN OR EQUAL TO XMN, THE LARGE TREE
C     PREDICTION IS IGNORED (XWT=0.0).
C----------
      XWT=(D-XMN)/(XMX-XMN)
      IF(D.LE.XMN.OR.LESTB) XWT = 0.0
C----------
C     COMPUTE WEIGHTED HEIGHT INCREMENT FOR NEXT TRIPLE.
C----------
      IF(DEBUG)WRITE(JOSTND,9985)XWT,HTGR,HTG(K),I,K
 9985 FORMAT(' IN REGENT 9985 FORMAT',3(F10.4,2X),2I7)
      HTG(K)=HTGR*(1.0-XWT) + XWT*HTG(K)
      IF(HTG(K) .LT. .1) HTG(K) = .1
C----------
C CHECK FOR SIZE CAP COMPLIANCE.
C----------
      IF((H+HTG(K)).GT.SIZCAP(ISPC,4))THEN
        HTG(K)=SIZCAP(ISPC,4)-H
        IF(HTG(K) .LT. 0.1) HTG(K)=0.1
      ENDIF
C
    5 CONTINUE
C----------
C     ASSIGN DBH AND COMPUTE DBH INCREMENT FOR TREES WITH DBH LESS
C     THAN 3 INCHES (COMPUTE 10-YEAR DBH INCREMENT REGARDLESS OF
C     PROJECTION PERIOD LENGTH).
C----------
      BKPT = 3.
      IF(ISPC.EQ.11)BKPT=99.
      IF(D.GE.BKPT) GO TO 23
      HK=H + HTG(K)
      IF(HK .LE. 4.5) THEN
        DG(K)=0.0
        DBH(K)=D+0.001*HK
      ELSE
        SELECT CASE(ISPC)
C----------
C  LOGIC FROM SORNEC 11 (HTT1,HTT2 VARIABLES)
C  HEIGHT SET HEIGHT REGRESSION COEFFICIENTS
C----------
        CASE(1:8,10,12,13,32)
          IF(JCR .GT. 7)JCR = 7
          IF(JCR .LE. 0) JCR = 1
          BX=HTT2(ISPC,JCR)
          IF(IABFLG(ISPC).EQ.1) THEN
            AX=HTT1(ISPC,JCR)
          ELSE
            AX=AA(ISPC)
          ENDIF
        CASE DEFAULT
C----------
C  SPECIES FROM ALL OTHER VARIANTS
C---------
          BX=HT2(ISPC)
          IF(IABFLG(ISPC).EQ.1) THEN
            AX=HT1(ISPC)
          ELSE
            AX=AA(ISPC)
          ENDIF
        END SELECT
C----------
C  DIAMETER CALCUALTIONS
C----------
        SELECT CASE(ISPC)
        CASE(1:10,12:14,17,18,24,27,32)
C----------
C  SO11,UT(6),AND CA SPECIES
C----------
          IF(ISPC .EQ. 10) THEN
            DK=(HK-8.31485+.59200*7.)/3.03659
            DKK=(H-8.31485+.59200*7.)/3.03659
          ELSE
            DK=(BX/(ALOG(HK-4.5)-AX))-1.0
            IF(H .LE. 4.5) THEN
              DKK=D
            ELSE
              DKK=(BX/(ALOG(H-4.5)-AX))-1.0
          ENDIF
          IF(DEBUG)WRITE(JOSTND,9986) AX,BX,ISPC,JCR,HK,BARK,
     &                                XRDGRO,DK,DKK
 9986     FORMAT(1H0,'IN REGENT 9986 FORMAT AX,BX,ISPC,JCR,HK',
     &    ' BARK,XRDGRO,DK,DKK= '/T13, F10.3,2X,F10.3,2X,I5,2X,
     &    I7,5F10.3)
          ENDIF
C----------
C  WJ IS FROM UT SP 12
C----------
        CASE(11)
          DK=(HK-4.5)*10./(SITEAR(ISPC)-4.5)
          IF(DK .LT. 0.1) DK=0.1
          DKK=(H-4.5)*10./(SITEAR(ISPC)-4.5)
          IF(DKK .LT. 0.1) DKK=0.1
          IF(H .LT. 4.5) DKK=D
        CASE(16)
C----------
C  ASSIGN DIAMETER INCREMENT AND SCALE FOR BARK THICKNESS AND
C  PERIOD LENGTH.  SCALE ADJUSTMENT IS ON GROWTH IN DDS RATHER
C  THAN INCHES OF DG TO MAINTAIN CONSISTENCY WITH GRADD.
C----------
          PPCCF=1.
          TPCCF=PCCF(IPCCF)*PPCCF
          IF(TPCCF.GT.300.0) TPCCF=300.0
          IF(TPCCF.LT.25.0) TPCCF=25.0
C
C         USES WB EQ FROM EM/SMDGF(1,H,FLOAT(ICR(K)),TPCCF,DKK)
C
          HLESS4 = H - 4.5
          DLESS3 = 0.000231 * HLESS4*FLOAT(ICR(K))
     &     - 0.00005 * HLESS4 * TPCCF
     &     + 0.001711 * FLOAT(ICR(K))
     &     + 0.17023 * HLESS4
          DKK = DLESS3 + 0.3
C
          IF(DEBUG)WRITE(JOSTND,*)' I,ISPC,H,CR,TPCCF,DKK= ',
     &     I,ISPC,H,FLOAT(ICR(K)),TPCCF,DKK
C----------
C  PPCCF IS A PROPORTIONAL ADJUSTMENT FOR POINT CCF VALUES BASED ON
C  CHANGE IN STAND CCF FOR THE SUBCYCLE.
C----------
C         USES WB EQ FROM EM/CALL SMDGF(1,HK,FLOAT(ICR(K)),TPCCF,DK)
C
          HLESS4 = HK - 4.5
          DLESS3 = 0.000231 * HLESS4*FLOAT(ICR(K))
     &     - 0.00005 * HLESS4 * TPCCF
     &     + 0.001711 * FLOAT(ICR(K))
     &     + 0.17023 * HLESS4
          DK = DLESS3 + 0.3
C
          IF(DEBUG)WRITE(JOSTND,*)' SMDGF CALL PARMS- ,I,ISPC,HK,CR,
     &    PCCF(IPCCF),DKK= ',I,ISPC,HK,FLOAT(ICR(K)),PCCF(IPCCF),DK
C
        CASE(15,19:23,25,26,28:31,33)
C----------
C  SPECIES FROM WC VARIANT
C  SET DDUM = 1 IF THIS IS A MANAGED STAND
C----------
          DDUM = 0.0
          IF(MANAGD.EQ.1 .OR. LESTB) DDUM=1.0
C----------
C   BEGIN THE DIAMETER LOOKUP SECTION
C      DK = DIAMETER WITH HTG ADDED TO THE STARTING HEIGHT
C      DKK  = DIAMETER AT THE START OF THE PROJECTION
C   DAT45  = DIAMETER AT 4.5 FEET PREDICTED FROM EQUATION.
C----------
          CRCODE = FLOAT(ICR(K))/10.0
          ALHT = ALOG(H)
          ALHK = ALOG(HK)
          DAT45 = RDCON(ISPC) + RDCR(ISPC)*CRCODE
     &    + RDLHT(ISPC)*ALOG(4.5) + RDHT(ISPC)*4.5 + RDDUM(ISPC)*DDUM
C
          DKK = RDCON(ISPC) + RDCR(ISPC) * CRCODE
     &         + RDLHT(ISPC)*ALHT + RDHT(ISPC)*H  +RDDUM(ISPC)*DDUM
          IF(DKK .LT. 0.0) DKK=D
C
          DK = RDCON(ISPC) + RDCR(ISPC) * CRCODE
     &         + RDLHT(ISPC)*ALHK + RDHT(ISPC)*HK + RDDUM(ISPC)*DDUM
          IF(DK .LT. DKK) DK=DKK+.01
          IF(DEBUG)WRITE(JOSTND,*)' I,ISPC,DBH,H,HK,DK,DKK,CRCODE,DDUM=
     &    ',I,ISPC,DBH(I),H,HK,DK,DKK,CRCODE,DDUM
C
        END SELECT
        IF(ISPC.EQ.11.OR.ISPC.EQ.16.OR.ISPC.EQ.24)GOTO 300
C----------
C  USE INVENTORY EQUATIONS IF CALIBRATION OF THE HT-DBH FUNCTION IS TURNED
C  OFF, OR IF WYKOFF CALIBRATION DID NOT OCCUR.
C  NOTE: THIS SIMPLIFIES TO IF(IABFLB(ISPC).EQ.1) BUT IS SHOWN IN IT'S
C        ENTIRITY FOR CLARITY.
C----------
        IF(.NOT.LHTDRG(ISPC) .OR. 
     &     (LHTDRG(ISPC) .AND. IABFLG(ISPC).EQ.1))THEN
          CALL HTDBH (IFOR,ISPC,DK,HK,1)
          IF(H .LE. 4.5) THEN
            DKK=D
          ELSE
            CALL HTDBH (IFOR,ISPC,DKK,H,1)
          ENDIF
          IF(DEBUG)WRITE(JOSTND,*)' INV EQN DUBBING IFOR,ISPC,H,HK,DK,'
     &    ,'DKK= ',IFOR,ISPC,H,HK,DK,DKK
          IF(DEBUG)WRITE(JOSTND,*)'ISPC,LHTDRG,IABFLG= ',
     &    ISPC,LHTDRG(ISPC),IABFLG(ISPC)
        ENDIF
  300   CONTINUE
C----------
C  IF CALLED FROM **ESTAB** ASSIGN DIAMETER
C----------
        IF(LESTB) THEN
          SELECT CASE(ISPC)
C----------
C  WC VARIANT SPECIES
C  ADJUST REGRESSION TO PASS THROUGH BUD WIDTH AT 4.5 FEET.
C----------
          CASE(15,19:23,25,26,28:31,33)
C----------
C  ADJUST REGRESSION TO PASS THROUGH BUD WIDTH AT 4.5 FEET.
C----------
            IF(DAT45.GT.0.0 .AND. HK.GE.4.5 .AND. LHTDRG(ISPC) .AND.
     &         IABFLG(ISPC).EQ.0) THEN
             DBH(K)=DK - DAT45 + DIAM(ISPC)
            ELSE
              DBH(K)=DK
            ENDIF
          CASE DEFAULT
            DBH(K)=DK
          END SELECT
C
          IF(DBH(K).LT.DIAM(ISPC).OR.HK.LT.4.5) DBH(K)=DIAM(ISPC)
          DBH(K)=DBH(K)+0.001*HK
          DG(K)=DBH(K)
        ELSE
C----------
C  COMPUTE DIAMETER INCREMENT BY SUBTRACTION, APPLY USER
C  SUPPLIED MULTIPLIERS, AND CHECK TO SEE IF COMPUTED VALUE
C  IS WITHIN BOUNDS.
C----------
C IF THE TREE JUST REACHED 4.5 FEET, SET DKK TO PRESENT DBH.
C RJ 12/6/91
          IF(H .LT. 4.5 )DKK = D
          BARK=BRATIO(ISPC,D,H)
C
          IF(DEBUG)WRITE(JOSTND,*)' BARK,XRDGRO= ',BARK,XRDGRO
C
          SELECT CASE (ISPC)
          CASE(15,19:23,25,26,28:31,33)
C----------
C FROM WC
C PROBLEM WITH HARDWOOD EQN, REDUCES TO .021*HG. SET TO RULE
C OF THUMB VALUE .1*HG FOR NOW. DIXON 11-04-92
C DON'T USE R.O.T. IF USING INVENTORY EQNS.  DIXON 03-31-98
C----------
            IF(DK.LT.0.0 .OR. DKK.LT.0.0)THEN
              DG(K)=HTG(K)*0.2*BARK*XRDGRO
              DK=D+DG(K)
            ELSE
              DG(K)=(DK-DKK)*BARK*XRDGRO
            ENDIF
            IF(DEBUG)WRITE(JOSTND,*)' K,DK,DKK,DG,BARK,XRDGRO= ',
     &       K,DK,DKK,DG(K),BARK,XRDGRO
            IF(LHTDRG(ISPC) .AND. IABFLG(ISPC).EQ.0) 
     &         DG(K)=0.1*HTG(K)*XRDGRO
            IF(DG(K) .LT. 0.0) DG(K)=0.1
            IF (DG(K) .GT. DGMX) DG(K)=DGMX
            DDS=DG(K)*(2.0*BARK*D+DG(K))*SCALE2
            DG(K)=SQRT((D*BARK)**2.0+DDS)-BARK*D
            IF(DEBUG)WRITE(JOSTND,*)' HARDWOOD EQU DG(K),DGMX,LHTDRG= '
            IF(DEBUG)WRITE(JOSTND,*)DG(K),DGMX,LHTDRG(ISPC)
c
          CASE(9,27)
C----------
C  IN ICASCA, THE INCREMENT FOR TREES BETWEEN
C  1.5 AND 3 INCHES DBH IS A WEIGHTED AVERAGE OF PREDICTIONS FROM
C  THE LARGE AND SMALL TREE MODELS.
C  SCALE ADJUSTMENT IS ON GROWTH IN DDS TERMS RATHER THAN INCHES
C  OF DG TO MAINTAIN CONSISTENCY WITH GRADD.
C         
C         NOTE: LARGE TREE DG IS ON A 10-YR BASIS; SMALL TREE DG IS ON A 
C         FINT-YR BASIS. CONVERT SMALL TREE DG TO A 10-YR BASIS BEFORE
C         WEIGHTING. DG GETS CONVERTED BACK TO A FINT-YR BASIS IN **GRADD**.
C----------
            XDWT=(D-1.5)/1.5
            IF(D.LE.1.5) XDWT=0.0
            IF(D.GE.3.0) XDWT=1.0
            DGSM=(DK-DKK)*BARK*XRDGRO
            IF(DGSM .LT. 0.0) DGSM=0.0
            DDS=DGSM*(2.0*BARK*D+DGSM)*SCALE2
            DGSM=SQRT((D*BARK)**2.0+DDS)-BARK*D
            IF(DGSM.LT.0.0) DGSM=0.0
            DG(K)=DGSM*(1.0-XDWT)+DG(K)*XDWT
            IF(DEBUG)WRITE(JOSTND,*)' XDWT,D,DDS,DG(K),DK,DKK,DGSM= '
            IF(DEBUG)WRITE(JOSTND,*)XDWT,D,DDS,DG(K),DK,DKK,DGSM
            IF((DBH(K)+DG(K)).LT.DIAM(ISPC))THEN
              DG(K)=DIAM(ISPC)-DBH(K)
            ENDIF
            IF(DEBUG)WRITE(JOSTND,*)' K,D,DBH,DG,DK,DKK,DGSM,XDWT='
            IF(DEBUG)WRITE(JOSTND,*)K,D,DBH(K),DG(K),DK,DKK,DGSM,XDWT
            GO TO 23
c
          CASE DEFAULT
            IF(DK.LT.0.0 .OR. DKK.LT.0.0)THEN
              DG(K)=HTG(K)*0.2*BARK*XRDGRO
              DK=D+DG(K)
            ELSE
              DG(K)=(DK-DKK)*BARK*XRDGRO
            ENDIF
            IF(DEBUG)WRITE(JOSTND,*)' K,DK,DKK,DG= ',K,DK,DKK,DG(K)
          END SELECT
C----------
C  SCALE DIAMETER INCREMENT TO 10-YR ESTIMATE.
C----------
C RJ   12/6/91
C TO BE CONSISTENT WITH GRADD, THE SCALE ADJUSTMENT IS
C ON GROWTH IN DDS TERMS RATHER THAN INCHES OF DG
C
          IF(DG(K) .LT. 0.0) DG(K)=0.0
          IF (DG(K) .GT. DGMX) DG(K)=DGMX
          IF(ISPC.EQ.16.AND.(DBH(K)+DG(K)).LT.DIAM(ISPC))THEN
            DG(K)=DIAM(ISPC)-DBH(K)
          ENDIF
C
          DDS=(DG(K)*(2.0*BARK*D+DG(K))) * SCALE2
          DG(K)=SQRT((D*BARK)**2.0+DDS)-BARK*D
        ENDIF
        IF((DBH(K)+DG(K)).LT.DIAM(ISPC))THEN
          DG(K)=DIAM(ISPC)-DBH(K)
        ENDIF
      ENDIF
C----------
C  CHECK FOR TREE SIZE CAP COMPLIANCE
C----------
      CALL DGBND(ISPC,DBH(K),DG(K))
C
   23 CONTINUE
C----------
C  RETURN TO PROCESS NEXT TRIPLE IF TRIPLING.  OTHERWISE,
C  PRINT DEBUG AND RETURN TO PROCESS NEXT TREE.
C----------
      IF(LESTB .OR. .NOT.LTRIP .OR. L.GE.2) GO TO 22
      L=L+1
      K=ITRN+2*I-2+L
      GO TO 2
C----------
C  END OF GROWTH PREDICTION LOOP
C----------
   22 CONTINUE
      IF(DEBUG)THEN
      HTNEW=HT(I)+HTG(I)
      WRITE(JOSTND,9987) I,ISPC,HT(I),HTG(I),HTNEW,DBH(I),DG(I)
 9987 FORMAT(' IN REGENT, I=',I4,',  ISPC=',I3,'  CUR HT=',F7.2,
     &       ',  HT INC=',F7.4,',  NEW HT=',F7.2,',  CUR DBH=',F10.5,
     &       ',  DBH INC=',F7.4)
      ENDIF
   25 CONTINUE
   30 CONTINUE
      GO TO 91
C----------
C  SMALL TREE HEIGHT CALIBRATION SECTION.
C----------
   40 CONTINUE
      DO 45 ISPC=1,MAXSP
      HCOR(ISPC)=0.0
      CORTEM(ISPC)=1.0
      NUMCAL(ISPC)=0
   45 CONTINUE
      IF (ITRN.LE.0) GO TO 91
      IF(IFINTH .EQ. 0)  GOTO 95
C---------
C COMPUTE DENSITY MODIFIER FROM CCF AND TOP HEIGHT.
C---------
      X=AVH*(RELDEN/100.0)
      IF(X .GT. 300.0) X=300.0
      PCTRED=AB(1)
     & + X*(AB(2) + X*(AB(3) + X*(AB(4) + X*(AB(5)+ X*AB(6)))))
      IF(PCTRED .GT. 1.0) PCTRED = 1.0
      IF(PCTRED .LT. 0.01) PCTRED = 0.01
      IF(DEBUG)WRITE(JOSTND,9988)AVH,RELDEN,X,PCTRED
 9988 FORMAT(' IN REGENT AVH,RELDEN,X,PCTRED = ',4F10.4)
C----------
C  BEGIN PROCESSING TREE LIST IN SPECIES ORDER.  DO NOT CALCULATE
C  CORRECTION TERMS IF THERE ARE NO TREES FOR THIS SPECIES.
C----------
      DO 100 ISPC=1,MAXSP
      CORNEW=1.0
      I1=ISCT(ISPC,1)
      IF(I1.EQ.0 .OR. .NOT. LHTCAL(ISPC)) GO TO 100
      N=0
      SNP=0.0
      SNX=0.0
      SNY=0.0
      I2=ISCT(ISPC,2)
      IREFI=IREF(ISPC)
      SI=SITEAR(ISPC)
      IF(SI .GT. SHI(ISPC)) SI=SHI(ISPC)
      IF(SI .LE. SLO(ISPC)) SI=SLO(ISPC) + 0.5
      IF(ISPC.EQ.9.OR.ISPC.EQ.27)THEN
        REGYR=5.
      ELSE
        REGYR=10.
      ENDIF
      SCALE3 = REGYR / FINTH
C----------
C  BEGIN TREE LOOP WITHIN SPECIES.  IF MEASURED HEIGHT INCREMENT IS
C  LESS THAN OR EQUAL TO ZERO, OR DBH IS LESS THAN 5.0, THE RECORD
C  WILL BE EXCLUDED FROM THE CALIBRATION.
C----------
      DO 60 I3=I1,I2
      I=IND1(I3)
      JCR=ICR(I)/10.
      H=HT(I)
      IPCCF=ITRE(I)
C----------
C  DIA GT 3 INCHES INCLUDED IN OVERALL MEAN
C----------
      IF(IHTG.LT.2) H=H-HTG(I)
      IF(DBH(I).GE.5.0.OR.H.LT.0.01) GO TO 60
C----------
C  COMPUTE VIGOR MODIFIER FROM CROWN RATIO.
C----------
      X=FLOAT(ICR(I))/100.
      VIGOR = (150.0 * (X**3.0)*EXP(-6.0*X))+0.3
      IF(VIGOR .GT. 1.0)VIGOR=1.0
C----------
C  VIGOR ADJUSTMENT TO DRASTIC FOR PINYON, JUNIPER, AND OAK
C  CUT IT BY TWO-THIRDS (FROM UT 6(AS) USED FOR SO 11(AS)
C----------
      IF(ISPC.EQ.11)VIGOR=1.-((1.-VIGOR)/3.)
C----------
C  BEGIN POTHTG SECTION
C----------
      SELECT CASE(ISPC)
      CASE(24)
        RELSI=(SI-SLO(ISPC))/(SHI(ISPC)-SLO(ISPC))
        RSIMOD = 0.5 * (1.0 + RELSI)
C----------
C COMPUTE HT GROWTH AND AGE FOR ASPEN. EQN FROM WAYNE SHEPPARD RMRS.
C----------
        AG1 = (H*12.0*2.54/26.9825)**0.8509
        AG2 = AG1 + 10.0
        H2  = (26.9825*AG2**1.1752)/(2.54*12.0)
        EDH = (H2-H) * RSIMOD * RHCON(ISPC)
        EDH=EDH*2.4
C----------
C GROWTH RATES APPEAR HIGH, REDUCE BY 25 PERCENT. DIXON 8-27-92.
C----------
        EDH=EDH*.75
        IF(EDH .LT. 0.0) EDH=0.0
        GO TO 9989
      CASE DEFAULT
C-----------
C CALL SMHTGF, THE SMALL TREE HEIGHT GROWTH ROUTINE. SMHTGF IS ALSO
C CALLED FROM ESSUBH TO GROW PLANTED AND NATURAL TREES FROM
C ESTABLISHMENT TO 5 YEARS INTO THE CYCLE
C-----------
        TEMT=10.
        MODE1=1
        CALL SMHTGF(MODE1,ICYC,ISPC,H,FLOAT(ICR(I)),
     &              TEMT,POTHTG,JOSTND,DEBUG)
C
      END SELECT
C----------
C  END POTHTG SECTION
C  BEGIN VIGOR ADJUSTMENT
C  SPECIES FROM CA (9, 27) DO NOT USE VIGOR KNOCK-DOWN METOD)
C----------
      IF(ISPC.EQ.9.OR.ISPC.EQ.27)THEN
        EDH=POTHTG*CON
      ELSE
        EDH=POTHTG*PCTRED*VIGOR*RHCON(ISPC)
      ENDIF
C
 9989 CONTINUE
      IF(DEBUG)WRITE(JOSTND,9990) X,VIGOR,FINT,EDH
 9990 FORMAT(' IN REGENT X,VIGOR,FINT,EDH = ',4F10.4)
      P=PROB(I)
      IF(HTG(I).LT.0.001) GO TO 60
      TERM=HTG(I) * SCALE3
      SNP=SNP+P
      SNX=SNX+EDH*P
      SNY=SNY+TERM*P
      N=N+1
C----------
C  PRINT DEBUG INFO IF DESIRED.
C----------
      IF(DEBUG)WRITE(JOSTND,9991) NPLT,I,ISPC,H,DBH(I),ICR(I),
     & PCT(I),ATCCF,RHCON(ISPC),EDH,TERM
 9991 FORMAT(' NPLT=',A26,',  I=',I5,',  ISPC=',I3,',  H=',F6.1,
     & ',  DBH=',F5.1,',  ICR',I5,',  PCT=',F6.1,',  RELDEN=',
     & F6.1 / 13X,'RHCON=',F10.3,',  EDH=',F10.3,', TERM=',F10.3)
C----------
C  END OF TREE LOOP WITHIN SPECIES.
C----------
   60 CONTINUE
      IF(DEBUG) WRITE(JOSTND,9992) ISPC,SNP,SNX,SNY
 9992 FORMAT(/' SUMS FOR SPECIES ',I2,':  SNP=',F10.2,
     & ';  SNX=',F10.2,';  SNY=',F10.2)
C----------
C  COMPUTE CALIBRATION TERMS.  CALIBRATION TERMS ARE NOT COMPUTED
C  IF THERE WERE FEWER THAN NCALHT (DEFAULT=5) HEIGHT INCREMENT
C  OBSERVATIONS FOR A SPECIES.
C----------
      IF(N.LT.NCALHT) GO TO 80
C----------
C  CALCULATE MEANS FOR THE POPULATION AND FOR THE SAMPLE ON THE
C  NATURAL SCALE.
C----------
      SNX=SNX/SNP
      SNY=SNY/SNP
C----------
C  CALCULATE RATIO ESTIMATOR.
C----------
      CORNEW = SNY/SNX
      IF(CORNEW.LE.0.0) CORNEW=1.0E-4
      HCOR(ISPC)=ALOG(CORNEW)
C----------
C  TRAP CALIBRATION VALUES OUTSIDE 2.5 STANDARD DEVIATIONS FROM THE 
C  MEAN. IF C IS THE CALIBRATION TERM, WITH A DEFAULT OF 1.0, THEN
C  LN(C) HAS A MEAN OF 0.  -2.5 < LN(C) < 2.5 IMPLIES 
C  0.0821 < C < 12.1825
C----------
      IF(CORNEW.LT.0.0821 .OR. CORNEW.GT.12.1825) THEN
        CALL ERRGRO(.TRUE.,27)
        WRITE(JOSTND,9194)ISPC,JSP(ISPC),CORNEW
 9194   FORMAT(T28,' SMALL TREE HTG: SPECIES = ',I2,' (',A3,
     &  ') CALCULATED CALIBRATION VALUE = ',F8.2)
        CORNEW=1.0
        HCOR(ISPC)=0.0
      ENDIF
   80 CONTINUE
      CORTEM(IREFI) = CORNEW
      NUMCAL(IREFI) = N
  100 CONTINUE
C----------
C  END OF CALIBRATION LOOP.  PRINT CALIBRATION STATISTICS AND RETURN
C----------
      WRITE(JOSTND,9993) (NUMCAL(I),I=1,NUMSP)
 9993 FORMAT(/' NUMBER OF RECORDS AVAILABLE FOR SCALING'/
     >       ' THE SMALL TREE HEIGHT INCREMENT MODEL',
     >        ((T49,11(I4,2X)/)))
   95 CONTINUE
      WRITE(JOSTND,9994) (CORTEM(I),I=1,NUMSP)
 9994 FORMAT(/' INITIAL SCALE FACTORS FOR THE SMALL TREE'/
     >      ' HEIGHT INCREMENT MODEL',
     >       ((T49,11(F5.2,1X)/)))
C----------
C OUTPUT CALIBRATION TERMS IF CALBSTAT KEYWORD WAS PRESENT.
C----------
      IF(JOCALB .GT. 0) THEN
        KOUT=0
        DO 207 K=1,MAXSP
        IF(CORTEM(K).NE.1.0 .OR. NUMCAL(K).GE.NCALHT) THEN
          SPEC=NSP(MAXSP,1)(1:2)
          ISPEC=MAXSP
          DO 203 KK=1,MAXSP
          IF(K .NE. IREF(KK)) GO TO 203
          ISPEC=KK
          SPEC=NSP(KK,1)(1:2)
          GO TO 2031
  203     CONTINUE
 2031     WRITE(JOCALB,204)ISPEC,SPEC,NUMCAL(K),CORTEM(K)
  204     FORMAT(' CAL: SH',1X,I2,1X,A2,1X,I4,1X,F6.3)
          KOUT = KOUT + 1
        ENDIF
  207   CONTINUE
        IF(KOUT .EQ. 0)WRITE(JOCALB,209)
  209   FORMAT(' NO SH VALUES COMPUTED')
       WRITE(JOCALB,210)
  210   FORMAT(' CALBSTAT END')
      ENDIF
   91 IF(DEBUG)WRITE(JOSTND,9995)ICYC
 9995 FORMAT(' LEAVING SUBROUTINE REGENT  CYCLE =',I5)
      RETURN
      ENTRY REGCON
C----------
C  ENTRY POINT FOR LOADING OF REGENERATION GROWTH MODEL
C  CONSTANTS  THAT REQUIRE ONE-TIME RESOLUTION.
C---------
      DO 90 ISPC=1,MAXSP
      RHCON(ISPC) = 1.0
      IF(LRCOR2.AND.RCOR2(ISPC).GT.0.0)
     &RHCON(ISPC)=RCOR2(ISPC)
   90 CONTINUE
      DO I=1,MAXTRE
      ZRAND(I)=-999.0
      ENDDO
      RETURN
      END