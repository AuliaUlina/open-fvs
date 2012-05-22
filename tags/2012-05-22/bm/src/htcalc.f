      SUBROUTINE HTCALC (SINDX,ISPC,AG,HGUESS,JOSTND,DEBUG)
      IMPLICIT NONE
C----------
C  **HTCALC--BM   DATE OF LAST REVISION:  04/27/09
C----------
C THIS ROUTINE CALCULATES A POTENTIAL HT GIVEN AN SPECIES SITE AND AGE
C IT IS USED TO CAL POTHTG AND SITE
C----------
COMMONS
C
C
      INCLUDE 'PRGPRM.F77'
C
C
      INCLUDE 'VARCOM.F77'
C
C
COMMONS
C----------
      LOGICAL DEBUG
      INTEGER JOSTND,ISPC
      REAL HGUESS,AG,SINDX
      REAL B0,B1,B2,B3,B4,B5,B6,B7,B8,B9,B10,B11,B12,B13
      REAL X2,X3
C----------
C  SPECIES ORDER:
C   1=WP,  2=WL,  3=DF,  4=GF,  5=MH,  6=WJ,  7=LP,  8=ES,
C   9=AF, 10=PP, 11=WB, 12=LM, 13=PY, 14=YC, 15=AS, 16=CW,
C  17=OS, 18=OH
C----------
C  SPECIES EXPANSION:
C  WJ USES SO JU (ORIGINALLY FROM UT VARIANT; REALLY PP FROM CR VARIANT)
C  WB USES SO WB (ORIGINALLY FROM TT VARIANT)
C  LM USES UT LM
C  PY USES SO PY (ORIGINALLY FROM WC VARIANT)
C  YC USES WC YC
C  AS USES SO AS (ORIGINALLY FROM UT VARIANT)
C  CW USES SO CW (ORIGINALLY FROM WC VARIANT)
C  OS USES BM PP BARK COEFFICIENT
C  OH USES SO OH (ORIGINALLY FROM WC VARIANT)
C----------
      IF(DEBUG) WRITE(JOSTND,10)
   10 FORMAT(' ENTERING HTCALC')
      IF(DEBUG)WRITE(JOSTND,30)AG,SINDX
   30 FORMAT(' IN HTCALC 30F AG,SINDX =',2F13.8)
C
C LOAD THE BETA COEFFICIENTS
C
      B0=BB0(ISPC)
      B1=BB1(ISPC)
      B2=BB2(ISPC)
      B3=BB3(ISPC)
      B4=BB4(ISPC)
      B5=BB5(ISPC)
      B6=BB6(ISPC)
      B7=BB7(ISPC)
      B8=BB8(ISPC)
      B9=BB9(ISPC)
      B10=BB10(ISPC)
      B11=BB11(ISPC)
      B12=BB12(ISPC)
      B13=BB13(ISPC)
      IF(DEBUG)WRITE(JOSTND,90036)ISPC,BB0(ISPC)
90036 FORMAT(' ISPC ',I5,'B0 ',F10.4)
C----------
C GO TO A DIFFERENT POTENTIAL HEIGHT CURVE DEPENDING ON THE SPECIES
C----------
C
      SELECT CASE (ISPC)
C
C----------
C WESTERN WHITE PINE USE BRICKELL EQUATIONS
C----------
      CASE (1)
        HGUESS=SINDX/(B0*(1.0-B1*EXP(B2*AG))**B3)
C----------
C WESTERN LARCH USE COCHRAN PNW 424
C----------
      CASE (2)
        HGUESS=4.5 + B1*AG + B2*AG*AG + B3*AG**3  +
     &       B4*AG**4 + (SINDX -4.5)*(B5 + B6*AG
     &       + B7*AG*AG + B8*AG**3)-
     &       B9*(B10 + B11*AG + B12*AG*AG + B13*AG**3)
C----------
C DOUGLAS-FIR USE COCHRAN PNW 251. THIS EQUATION ALSO USED FOR MISC. SPP
C----------
      CASE (3)
        HGUESS=4.5 + EXP(B1 + B2*ALOG(AG) + B3*(ALOG(AG))**4)
     &       + B4*(B5 + B6*(1.0 - EXP(B7*AG))**B8)
     &       + (SINDX - 4.5)*(B5 + B6*(1.0 - EXP(B7*AG)**B8))
C----------
C GRAND FIR USE COCHRAN PNW 252
C----------
      CASE (4)
        X2= B0 + B1*ALOG(AG) + B2*(ALOG(AG))**4
     &    + B3*(ALOG(AG))**9 + B4*(ALOG(AG))**11
     &    + B5*(ALOG(AG))**18
        X3= B6 + B7*ALOG(AG) + B8*(ALOG(AG))**2
     &    + B9*(ALOG(AG))**7 + B10*(ALOG(AG))**16
     &    + B11*(ALOG(AG))**24
        HGUESS=EXP(X2) + B12*EXP(X3) + (SINDX - 4.5)*EXP(X3)
     &       + 4.5
        IF(DEBUG)WRITE(JOSTND,9500)X2,X3,SINDX,AG,HGUESS
 9500   FORMAT(' X2,X3,SINDX,AG',5E12.4)
C----------
C MTN HEMLOCK USE INTERIM MEANS PUB
C----------
      CASE (5)
        IF(DEBUG)WRITE(JOSTND,9501)ISPC,AG,SINDX,B0,B1,B2,B4,B5
 9501   FORMAT(' HTCALC HEMLOC SP AG SI B S',I5,7E12.4)
        HGUESS = (B0 + B1*SINDX)*(1.0 - EXP(B2*SQRT(SINDX)*AG))
     &         **(B4 + B5/SINDX)
        HGUESS=(HGUESS + 1.37)*3.281
C----------
C WESTERN JUNIPER
C----------
      CASE(6)
        HGUESS = 0.
C----------
C LODGEPOLE PINE USE DAHMS PNW 8
C----------
      CASE(7)
        HGUESS = SINDX*(B0 + B1*AG + B2*AG*AG)
C----------
C ENGLEMANN SPRUCE USE ALEXANDER
C----------
      CASE(8)
        HGUESS = 4.5+((B0*SINDX**B1)*(1.0-EXP(-B2*AG))**(B3*SINDX**B4))
C----------
C SUBALPINE FIR USE JOHNSON'S EQUIV OF DEMARS
C----------
      CASE(9)
        HGUESS=SINDX*(B0 + B1*AG + B2*AG*AG)
C----------
C PONDEROSA PINE AND OTHER SOFTWOODS USE BARRETT
C----------
      CASE(10,17)
        IF(DEBUG)WRITE(JOSTND,20)B0,B1,AG,B2,B3,B4,B5,B6,B7,SINDX
   20   FORMAT(' HTCALC 20F B0-1,AG,B2-7,SINDX = ',/,1H ,10F13.8)
        HGUESS =( B0*(1.0 -EXP(B1*AG))**B2)
     &         - ((B3 + B4*(1.0-EXP(B5*AG))**B6)*B7)
     &         + ((B3 + B4*(1.0 - EXP(B5*AG))**B6)*(SINDX - 4.5))
     &         + 4.5
C----------
C   WHITEBARK PINE (11)
C   LIMBER PINE (12)
C   QUAKING ASPEN (15)
C----------
      CASE(11,12,15)
        HGUESS = 0.
C----------
C  MISC SPECIES FROM THE WC VARIANT - USE CURTIS, FOR. SCI. 20:307-316.  
C  CURTIS'S CURVES ARE PRESENTED IN METRIC (3.2808 ?). BECAUSE OF
C  EXCESSIVE HT GROWTH -- APPROX 30-40 FT/CYCLE, TAKE OUT METRIC MULT
C  DIXON 11-05-92
C    PACIFIC YEW (13)
C    ALASKA CEDAR (14)
C    BLACK COTTONWOOD (16)
C    OTHER HARDWOODS (18)
C----------
      CASE(13,14,16,18)
        HGUESS = (SINDX - 4.5) / ( B0 + B1/(SINDX - 4.5)
     &         + B2 * AG**(-1.4) +(B3/(SINDX - 4.5))*AG**(-1.4))
        HGUESS = HGUESS + 4.5
C
      END SELECT
C
      RETURN
      END
