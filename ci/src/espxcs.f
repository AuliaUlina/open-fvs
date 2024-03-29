      SUBROUTINE ESPXCS
      IMPLICIT NONE
C----------
C  **ESPXCS--CI   DATE OF LAST REVISION:   06/20/11
C
C  PREDICTS THE PROBABILITY OF EXCESS SPECIES
C----------
C
COMMONS
C
C
      INCLUDE 'PRGPRM.F77'
C
C
      INCLUDE 'ESPARM.F77'
C
C
      INCLUDE 'ESCOMN.F77'
C
C
      INCLUDE 'ESCOM2.F77'
C
C
      INCLUDE 'PLOT.F77'
C
C
      INCLUDE 'PDEN.F77'
C
C
      INCLUDE 'ESHAP.F77'
C
C
      INCLUDE 'ESHAP2.F77'
C
C
COMMONS
C----------
      REAL PN
C----------
C     SPECIES LIST FOR CENTRAL IDAHO VARIANT.
C
C     1 = WESTERN WHITE PINE (WP)          PINUS MONTICOLA
C     2 = WESTERN LARCH (WL)               LARIX OCCIDENTALIS
C     3 = DOUGLAS-FIR (DF)                 PSEUDOTSUGA MENZIESII
C     4 = GRAND FIR (GF)                   ABIES GRANDIS
C     5 = WESTERN HEMLOCK (WH)             TSUGA HETEROPHYLLA
C     6 = WESTERN REDCEDAR (RC)            THUJA PLICATA
C     7 = LODGEPOLE PINE (LP)              PINUS CONTORTA
C     8 = ENGLEMANN SPRUCE (ES)            PICEA ENGELMANNII
C     9 = SUBALPINE FIR (AF)               ABIES LASIOCARPA
C    10 = PONDEROSA PINE (PP)              PINUS PONDEROSA
C    11 = WHITEBARK PINE (WB)              PINUS ALBICAULIS
C    12 = PACIFIC YEW (PY)                 TAXUS BREVIFOLIA
C    13 = QUAKING ASPEN (AS)               POPULUS TREMULOIDES
C    14 = WESTERN JUNIPER (WJ)             JUNIPERUS OCCIDENTALIS
C    15 = CURLLEAF MOUNTAIN-MAHOGANY (MC)  CERCOCARPUS LEDIFOLIUS
C    16 = LIMBER PINE (LM)                 PINUS FLEXILIS
C    17 = BLACK COTTONWOOD (CW)            POPULUS BALSAMIFERA VAR. TRICHOCARPA
C    18 = OTHER SOFTWOODS (OS)
C    19 = OTHER HARDWOODS (OH)
C----------
C  P(EXCESS WESTERN WHITE PINE)  3/24/87
C----------
      PN= -2.6601112 -0.2103586*XCOS -2.1766529*XSIN -2.6159747*SLO
     &    -.0170345*BAA +0.3166977*BAALN +FHAB(IHAB,1)
      IF(OVER(1,NNID).GT.9.95) PN=PN +1.0546575
      IF(IFO.EQ.7.OR.IFO.EQ.10.OR.IFO.EQ.16) PN=PN -1.8648362
      IF(IFO.EQ.5) PN=PN -0.5629999
      PXCS(1)=(1./(1.+EXP(-PN)))*XESMLT(1)*OCURHT(IHAB,1)*OCURNF(IFO,1)
C----------
C  P(EXCESS LARCH). 3/22/87
C----------
      PN= -15.2532959 +1.5877491*XCOS +0.4421725*XSIN -1.5027288*SLO
     &    +.4384918*ELEV -.0051305*ELEVSQ +FPRE(IPREP,2) +FHAB(IHAB,2)
      IF(IFO.EQ.9.OR.IFO.EQ.10.OR.IFO.EQ.14.OR.IFO.EQ.16) PN=PN
     &    +2.3989265
      IF(OVER(2,NNID).GT.9.95) PN=PN +1.2872436
      PXCS(2)=(1./(1.+EXP(-PN)))*XESMLT(2)*OCURHT(IHAB,2)*OCURNF(IFO,2)
C----------
C  P(EXCESS DOUGLAS-FIR).
C----------
      PN= -2.0080204 -.1351578*XCOS -.3944477*XSIN +.8531865*SLO
     &    -.0383463*ELEV +.0652054*TIME +FHAB(IHAB,3) +FPRE(IPREP,3)
      IF(IFO.EQ.3.OR.IFO.EQ.9.OR.IFO.EQ.12.OR.IFO.EQ.16) PN=PN
     &    +1.3155589
      IF(OVER(3,NNID).GT.9.95) PN=PN +.7341939
      PXCS(3)=(1./(1.+EXP(-PN)))*XESMLT(3)*OCURHT(IHAB,3)*OCURNF(IFO,3)
C----------
C  P(EXCESS GRAND FIR).
C----------
      PN= -6.1448393 +FHAB(IHAB,4) +1.4774529*XCOS +.2616096*XSIN
     &    -.4769181*SLO +FPRE(IPREP,4) -.0048863*BAA +.2789069*ELEV
     &    -.0036567*ELEVSQ +.0582383*REGT +.0502622*BWAF
     &    +.1356740*BAALN
      IF(OVER(4,NNID).GT.9.95) PN=PN+.4348936
      IF(IFO.EQ.14.OR.IFO.EQ.16) PN=PN -0.5188152
      IF(IFO.EQ.19.OR.IFO.EQ.20) PN=PN -0.7681130
      PXCS(4)=(1./(1.+EXP(-PN)))*XESMLT(4)*OCURHT(IHAB,4)*OCURNF(IFO,4)
C----------
C  P(EXCESS WESTERN HEMLOCK) 3/20/87
C----------
      PN = -9.3195372 +4.3167849*XCOS -.9011113*XSIN -.1339375*SLO
     &  +.3964820*ELEV -.0055853*ELEVSQ +.0896454*TIME +FPRE(IPREP,7)
      IF(OVER(5,NNID).GT.9.95) PN=PN +1.0252551
      PXCS(5)=(1./(1.+EXP(-PN)))*XESMLT(5)*OCURHT(IHAB,5)*OCURNF(IFO,5)
C----------
C  P(EXCESS WESTERN REDCEDAR). 3/26/87
C----------
      PN= -1.2917893 +1.9611115*XCOS -.0809641*XSIN  -.6731737*SLO
     &    + .0717763*TIME +FPRE(IPREP,6) +FHAB(IHAB,6)
      IF(OVER(6,NNID).GT.9.95) PN=PN +1.3999580
      PXCS(6)=(1./(1.+EXP(-PN)))*XESMLT(6)*OCURHT(IHAB,6)*OCURNF(IFO,6)
C----------
C  P(EXCESS LODGEPOLE PINE).
C----------
      PN= -2.6488557 +FHAB(IHAB,7) +0.9309435*XCOS -0.2925614*XSIN
     &    -2.4103925*SLO -.3734260*BAALN +.0142129*ELEV +FPRE(IPREP,7)
      IF(OVER(7,NNID).GT.9.95) PN=PN +2.5861046
      IF(IPHY.EQ.1) PN=PN +1.1320554
      PXCS(7)=(1./(1.+EXP(-PN)))*XESMLT(7)*OCURHT(IHAB,7)*OCURNF(IFO,7)
C----------
C  P(EXCESS ENGELMANN SPRUCE). 04/08/87
C----------
      PN= -26.3272057 +0.7454571*ELEV -0.0064948*ELEVSQ -1.9590315*SLO
     &    +0.0703796*TIME +FHAB(IHAB,8) +FPRE(IPREP,8)
      IF(OVER(8,NNID).GT.9.95) PN=PN +1.2224044
      PXCS(8)=(1./(1.+EXP(-PN)))*XESMLT(8)*OCURHT(IHAB,8)*OCURNF(IFO,8)
C----------
C  P(EXCESS SUBALPINE FIR).
C----------
      PN= -7.4072008 +FHAB(IHAB,9) +1.0363630*XCOS +0.2825538*XSIN
     &    -1.5201763*SLO +0.0569783*ELEV -0.1950940*BWB4
     &    +FPRE(IPREP,9)
      IF(IFO.EQ.3.OR.IFO.EQ.9.OR.IFO.EQ.10.OR.IFO.EQ.11.OR.IFO.EQ.12.
     &    OR.IFO.EQ.14.OR.IFO.EQ.16) PN=PN +1.2027771
      IF(OVER(9,NNID).GT.9.95) PN=PN +1.5097677
      PXCS(9)=(1./(1.+EXP(-PN)))*XESMLT(9)*OCURHT(IHAB,9)*OCURNF(IFO,9)
C----------
C  P(EXCESS PONDEROSA PINE) 3/26/87
C----------
      PN= -18.8911858 +.6606922*ELEV -.0068996*ELEVSQ +FHAB(IHAB,10)
      IF(OVER(10,NNID).GT.9.95) PN=PN +.9117771
      PXCS(10)=(1.0/(1.0+EXP(-PN)))*XESMLT(10)*OCURHT(IHAB,10)
     &    *OCURNF(IFO,10)
C----------
C  P(EXCESS WHITEBARK PINE)
C----------
      PXCS(11)=0.0
C----------
C  P(EXCESS PACIFIC YEW)
C----------
      PXCS(12)=0.0
C----------
C  P(EXCESS QUAKING ASPEN)
C----------
      PXCS(13)=0.0
C----------
C  P(EXCESS WESTERN JUNIPER)
C----------
      PXCS(14)=0.0
C----------
C  P(EXCESS CURLLEAF MOUNTAIN-MAHOGANY)
C----------
      PXCS(15)=0.0
C----------
C  P(EXCESS LIMBER PINE)
C----------
      PXCS(16)=0.0
C----------
C  P(EXCESS BLACK COTTONWOOD)
C----------
      PXCS(17)=0.0
C----------
C  P(EXCESS OTHER SOFTWOODS)
C----------
      PXCS(18)=0.0
C----------
C  P(EXCESS OTHER HARDWOODS)
C----------
      PXCS(19)=0.0
C
      RETURN
      END
