      SUBROUTINE SITSET
      IMPLICIT NONE
C----------
C  **SITSET-- LS  DATE OF LAST REVISION:  05/11/11
C----------
C THIS SUBROUTINE LOADS THE SITELG ARRAY WITH A SITE INDEX FOR EACH
C SPECIES WHICH WAS NOT ASSIGNED A SITE INDEX BY KEYWORD.
C----------
COMMONS
C
C
      INCLUDE 'ESPARM.F77'
C
C
      INCLUDE 'PRGPRM.F77'
C
C
      INCLUDE 'ESCOMN.F77'
C
C
      INCLUDE 'CONTRL.F77'
C
C
      INCLUDE 'PLOT.F77'
C
C
      INCLUDE 'VOLSTD.F77'
C
C
COMMONS
C
C
      LOGICAL DEBUG
      REAL SICOEF1(MAXSP,MAXSP),SICOEF2(MAXSP,MAXSP),BAMAXA(MAXSP)
      INTEGER J,I,JJ,K,METHB8,METHC8
      CHARACTER FORST*2,DIST*2,PROD*2,VAR*2,VOLEQ*10
      INTEGER IFIASP,ERRFLAG,ISPC,IREGN,KFORST
C----------
C  LOAD BA MAXIMUM VALUES --- R9 APPROVED BAMAX.
C----------
      DATA BAMAXA /
     & 150.,   150.,   240.,   240.,   240.,   190.,   240.,
     & 240.,   180.,   200.,   200.,   240.,   150.,   150.,
     & 150.,   150.,   130.,   150.,   150.,   200.,   150.,
     & 150.,   150.,   150.,   150.,   150.,   150.,   150.,
     & 150.,   160.,   160.,   160.,   160.,   160.,   160.,
     & 130.,   160.,   160.,   160.,   130.,   130.,   150.,
     & 150.,   150.,   150.,   160.,   150.,   150.,   150.,
     & 150.,   150.,   150.,   150.,   150.,   150.,   150.,
     & 170.,   150.,   140.,   150.,   150.,   150.,   150.,
     & 150.,   150.,   150.,   150.,   150. /
      DATA ((SICOEF1(I,J),I=1,MAXSP),J=1,MAXSP)/
     &  2*.000,2*-.083,35*.000,3*-4.661,-11.774,25*.000,
     &  2*.000,2*-.083,35*.000,3*-4.661,-11.774,25*.000,
     &  2*.081,2*.0,3.926,2*14.453,11*.0,2*13.601,19*.0,3*-20.194,26*.0,
     &  2*.081,2*.0,3.926,2*14.453,11*.0,2*13.601,19*.0,3*-20.194,26*.0,
     &  2*.0,2*-4.094,.0,2*10.9,11*.0,2*5.264,13*.0,3*4.678,3*.000,
     &      3*-9.004,26*.00,
     &  2*.0,2*-18.249,-13.974,5*.0,-19.486,28*.0,3*-7.893,26*.0,
     &  2*.0,2*-18.249,-13.974,5*.0,-19.486,28*.0,3*-7.893,26*.0,
     &  8*.0,-7.212,.0,-15.196,28*.0,3*-1.366,12.096,25*.0,
     &  7*.000,6.175,.000,2.846,58*.000,
     &  8*.000,-3.700,.000,-12.708,57*.000,
     &  5*.000,2*10.904,8.205,.000,6.434,58*.000,
     &  68*.000,
     &  68*.000,
     &  68*.000,
     &  18*.0,2*8.379,3*-.953,-15.228,.253,3*7.441,4.812,4*.0,
     &     3*-37.214,3*.000,3*-4.346,26*.000,
     &  18*.0,2*8.379,3*-.953,-15.228,.253,3*7.441,4.812,4*.0,
     &     3*-37.214,3*.000,3*-4.346,26*.000,
     &  68*.000,
     &  68*.000,
     &  2*.0,2*-17.873,-5.606,9*.0,2*-9.376,4*.0,3*6.729,-2.119,
     &      -2.628,3*3.4,11.937,4*.0,3*-11.597,3*.0,3*-18.897,-16.538,
     &      25*.0,
     &  2*.0,2*-17.873,-5.606,9*.0,2*-9.376,4*.0,3*6.729,-2.119,
     &      -2.628,3*3.4,11.937,4*.0,3*-11.597,3*.0,3*-18.897,-16.538,
     &      25*.0,
     &  14*.0,2*.946,2*.0,2*-7.973,3*.0,-6.136,-5.273,3*-1.384,
     &      3.405,4*.0,3*-9.013,3*.0,3*-.214,-5.084,25*.000,
     &  14*.0,2*.946,2*.0,2*-7.973,3*.0,-6.136,-5.273,3*-1.384,
     &      3.405,4*.0,3*-9.013,3*.0,3*-.214,-5.084,25*.000,
     &  14*.0,2*.946,2*.0,2*-7.973,3*.0,-6.136,-5.273,3*-1.384,
     &      3.405,4*.0,3*-9.013,3*.0,3*-.214,-5.084,25*.000,
     &  14*.0,2*11.436,2*.0,2*2.022,3*5.216,.0,-4.758,3*2.045,1.885,
     &      4*.0,3*-6.197,3*.0,3*-9.885,-10.258,25*.000,
     &  14*.0,2*-.256,2*.0,2*2.652,3*4.856,4.768,.0,3*4.931,9.642,
     &      4*.0,3*-15.079,3*.0,3*3.165,-1.913,25*.000,
     &  14*.0,2*-7.746,2*.0,2*-3.563,3*1.262,-2.119,-4.970,3*.0,
     &     1.006,4*.0,3*-11.199,3*.0,8.187,2*-2.435,-11.199,25*.0,
     &  14*.0,2*-7.746,2*.0,2*-3.563,3*1.262,-2.119,-4.970,3*.0,
     &     1.006,4*.0,3*-11.199,3*.0,8.187,2*-2.435,-11.199,25*.0,
     &  14*.0,2*-7.746,2*.0,2*-3.563,3*1.262,-2.119,-4.970,3*.0,
     &     1.006,4*.0,3*-11.199,3*.0,8.187,2*-2.435,-11.199,25*.0,
     &  14*.0,2*-5.428,2*.0,2*-15.895,3*-3.717,-2.162,-11.645,
     &      3*-1.143,5*.0,3*-34.762,3*.0,3*-23.105,-16.344,25*.000,
     &  33*.000,3*-1.235,32*.0,
     &  33*.000,3*-1.235,32*.0,
     &  33*.000,3*-1.235,32*.0,
     &  33*.000,3*-1.235,32*.0,
     &  4*.0,-5.576,9*.0,2*23.568,2*.0,2*10.41,3*7.934,6.247,12.35,
     &      3*10.199,22.442,4*1.321,6*.0,-8.189,2*-16.187,-16.401,
     &      25*.00,
     &  4*.0,-5.576,9*.0,2*23.568,2*.0,2*10.41,3*7.934,6.247,12.350,
     &      3*10.199,22.442,4*1.321,6*.0,-8.189,2*-16.187,-16.401,
     &      25*.0,
     &  4*.0,-5.576,9*.0,2*23.568,2*.0,2*10.41,3*7.934,6.247,12.350,
     &      3*10.199,22.442,4*1.321,6*.0,-8.189,2*-16.187,-16.401,
     &      25*.0,
     &  68*.0,
     &  68*.0,
     &  68*.0,
     &  2*4.385,2*16.194,8.276,2*7.893,1.605,6*.0,2*4.818,2*.0,
     &      2*16.179,3*.239,9.945,-3.615,3*-11.564,19.238,4*.0,3*7.992,
     &      4*.0,2*2.223,-19.532,25*.000,
     &  2*4.385,2*16.194,8.276,2*7.893,1.605,6*.0,2*4.818,2*.0,
     &      2*16.179,3*.239,9.945,-3.615,3*2.868,19.238,4*.0,3*13.856,
     &      3*.0,-2.271,2*.0,8.500,25*.000,
     &  2*4.385,2*16.194,8.276,2*7.893,1.605,6*.0,2*4.818,2*.0,
     &      2*16.179,3*.239,9.945,-3.615,3*2.868,19.238,4*.0,3*13.856,
     &      3*.0,-2.271,2*.0,8.500,25*.000,
     &  2*9.002,5*.0,-17.109,10*.0,2*13.612,3*4.769,9.696,1.911,
     &      3*10.199,13.342,4*.0,3*13.069,3*.0,13.926,2*-8.947,26*.0,
     &  68*.0,
     &  68*.0,
     &  68*.0,
     &  68*.0,
     &  68*.0,
     &  68*.0,
     &  68*.0,
     &  68*.0,
     &  68*.0,
     &  68*.0,
     &  68*.0,
     &  68*.0,
     &  68*.0,
     &  68*.0,
     &  68*.0,
     &  68*.0,
     &  68*.0,
     &  68*.0,
     &  68*.0,
     &  68*.0,
     &  68*.0,
     &  68*.0,
     &  68*.0,
     &  68*.0,
     &  68*.0/
      DATA ((SICOEF2(I,J),I=1,MAXSP),J=1,MAXSP)/
     &  2*.0,2*1.028,35*.0,3*1.063,1.308,25*.0,
     &  2*.0,2*1.028,35*.0,3*1.063,1.308,25*.0,
     &  2*.973,2*.0,.959,2*.792,11*.0,2*.761,19*.0,3*1.247,26*.00,
     &  2*.973,2*.0,.959,2*.792,11*.0,2*.761,19*.0,3*1.247,26*.00,
     &  2*0,2*1.043,.0,2*.78,11*.0,2*.939,13*.0,3*.839,3*.0,3*1.088,
     &     26*.000,
     &  2*.0,2*1.263,1.282,5*.0,1.787,28*.0,1.000,28*.000,
     &  2*.0,2*1.263,1.282,5*.0,1.787,28*.0,1.000,28*.000,
     &  8*.0,1.168,.0,1.852,28*.0,3*.851,.707,25*.00,
     &  7*.0,.856,.0,.769,58*.000,
     &  8*.0,1.300,.0,1.975,57*.0,
     &  5*.0,2*.560,.540,.000,.506,58*.000,
     &  68*.000,
     &  68*.000,
     &  68*.000,
     &  18*.0,2*.894,3*1.007,1.332,.99,3*.961,.887,4*.0,3*1.579,
     &      3*.0,3*.902,26*.000,
     &  18*.0,2*.894,3*1.007,1.332,.99,3*.961,.887,4*.0,3*1.579,
     &      3*.0,3*.902,26*.000,
     &  68*.0,
     &  68*.0,
     &  2*.0,2*1.314,1.065,9*.0,2*1.119,4*.0,3*.844,1.048,.991,
     &      3*.954,.751,4*.0,3*1.114,3*.0,3*1.168,1.215,25*.0,
     &  2*.0,2*1.314,1.065,9*.0,2*1.119,4*.0,3*.844,1.048,.991,
     &      3*.954,.751,4*.0,3*1.114,3*.0,3*1.168,1.215,25*.0,
     &  14*.0,2*.993,2*.0,2*1.185,3*.0,1.176,1.086,3*1.096,.916,
     &      4*.0,3*1.36,3*.0,3*.896,1.066,25*.000,
     &  14*.0,2*.993,2*.0,2*1.185,3*.0,1.176,1.086,3*1.096,.916,
     &      4*.0,3*1.36,3*.0,3*.896,1.066,25*.000,
     &  14*.0,2*.993,2*.0,2*1.185,3*.0,1.176,1.086,3*1.096,.916,
     &      4*.0,3*1.36,3*.0,3*.896,1.066,25*.000,
     &  14*.0,2*.751,2*.0,2*.954,3*.850,.0,.998,3*.965,.872,4*.0,3*.992,
     &      3*.0,3*.994,1.058,25*.000,
     &  14*.0,2*1.01,2*.0,2*1.009,3*.921,1.002,.0,3*.992,.828,4*.0,
     &      3*1.221,3*.0,3*.876,1.001,25*.000,
     &  14*.0,2*1.041,2*.0,2*1.048,3*.912,1.036,1.008,3*.0,.88,4*.0,
     &      3*1.098,3*.0,.708,2*.849,1.098,25*.000,
     &  14*.0,2*1.041,2*.0,2*1.048,3*.912,1.036,1.008,3*.0,.88,4*.0,
     &      3*1.098,3*.0,.708,2*.849,1.098,25*.000,
     &  14*.0,2*1.041,2*.0,2*1.048,3*.912,1.036,1.008,3*.0,.88,4*.0,
     &      3*1.098,3*.0,.708,2*.849,1.098,25*.000,
     &  14*.0,2*1.128,2*.0,2*1.332,3*1.092,1.147,1.208,3*1.136,5*.0,
     &      3*1.549,3*.0,3*1.201,1.225,25*.000,
     &  33*.000,3*.935,32*.000,
     &  33*.000,3*.935,32*.000,
     &  33*.000,3*.935,32*.000,
     &  33*.000,3*.935,32*.000,
     &  4*.0,1.192,9*.0,2*.633,2*.0,2*.898,3*.88,1.008,.819,3*.911,.646,
     &      4*1.070,.0,2*1.0,3*.0,1.025,2*1.168,1.255,25*.000,
     &  4*.0,1.192,9*.0,2*.633,2*.0,2*.898,3*.88,1.008,.819,3*.911,
     &      .646,4*1.070,1.000,5*.0,1.025,2*1.168,1.255,25*.000,
     &  4*.0,1.192,9*.0,2*.633,2*.0,2*.898,3*.88,1.008,.819,3*.911,
     &      .646,4*1.070,1.000,5*.0,1.025,2*1.168,1.255,25*.000,
     &  68*.000,
     &  68*.000,
     &  68*.000,
     &  2*.941,2*.802,.919,2*1.0,1.175,6*.0,2*1.109,2*.0,2*.856,3*1.116,
     &      1.006,1.142,3*1.412,.833,4*.0,3*.976,4*.0,2*.979,1.403,
     &      25*.0,
     &  2*.941,2*.802,.919,2*1.0,1.175,6*.0,2*1.109,2*.0,2*.856,
     &      3*1.116,1.006,1.142,3*1.178,.833,4*.0,3*.856,3*.0,1.021,
     &      2*.0,.950,25*.0,
     &  2*.941,2*.802,.919,2*1.0,1.175,6*.0,2*1.109,2*.0,2*.856,
     &      3*1.116,1.006,1.142,3*1.178,.833,4*.0,3*.856,3*.0,1.021,
     &      2*.0,.950,25*.0,
     &  2*.756,5*.0,1.414,10*.0,2*.823,3*.938,.945,.999,3*.911,.816,
     &      4*.0,3*.797,3*.0,.713,2*1.053,26*.000,
     &  68*.000,
     &  68*.000,
     &  68*.000,
     &  68*.000,
     &  68*.000,
     &  68*.000,
     &  68*.000,
     &  68*.000,
     &  68*.000,
     &  68*.000,
     &  68*.000,
     &  68*.000,
     &  68*.000,
     &  68*.000,
     &  68*.000,
     &  68*.000,
     &  68*.000,
     &  68*.000,
     &  68*.000,
     &  68*.000,
     &  68*.000,
     &  68*.000,
     &  68*.000,
     &  68*.000,
     &  68*.000/
C-----------
C  SEE IF WE NEED TO DO SOME DEBUG.
C-----------
      CALL DBCHK (DEBUG,'SITSET',6,ICYC)
C----------
C  DEFAULT MERCH LIMITS ARE SET IN LS/VOLS
C----------
C  WRITE ERROR MESSAGE IF NO SITE SPECIES AND/OR SITE CODE HAS
C  BEEN ENTERED.
C----------
      IF(ISISP .LE. 0 .OR. SITEAR(ISISP) .LE. 0.0) THEN
        WRITE(JOSTND,1)
    1   FORMAT(/,3('***************'/),'WARNING: SITE SPECIES ',
     &    'AND/OR SITE CODE IS MISSING.  A DEFAULT IS BEING ASSIGNED.',
     &    ' THIS PROJECTION SHOULD NOT BE TAKEN SERIOUSLY.',/,
     &    3('***************'/),/)
      ENDIF
C----------
C  SET DEFAULT SITE SPECIES OF RED PINE NATURAL AND INDEX OF 60
C  IF MISSING.
C----------
      IF(ISISP .LE. 0) ISISP=3
      IF(SITEAR(ISISP) .LE. 0.0) SITEAR(ISISP)=60.
C----------
C  COMPUTE SPECIES SITE FROM STAND SITE FOR ALL SPECIES WHICH HAVE
C  COEFFICIENTS IN THE PARAMETER FILE.  WHEN COEFFICIENTS ARE NOT
C  AVAILABLE FOR A SPECIES, THAT SPECIES' SITE WILL BE ZERO.
C----------
      DO 5 I=1,MAXSP
       IF(SITEAR(I) .LE. .0001) SITEAR(I) = SICOEF1(ISISP,I)
     &         + SICOEF2(ISISP,I)*SITEAR(ISISP)
    5 CONTINUE
C----------
C  FOR SPECIES WHICH DID NOT HAVE SITES FIGURED ABOVE, ATTEMPT A
C  CONVERSION THRU ASPEN.  IF COEFFICIENTS ARE NOT AVAILABLE, SITES
C  WILL BE LEFT AS ZERO.
C----------
      IF(SITEAR(41) .GT. .0001) THEN
        DO 10 I=1,MAXSP
         IF(SITEAR(I) .LE. .0001) SITEAR(I) = SICOEF1(41,I)
     &      + SICOEF2(41,I)*SITEAR(41)
   10   CONTINUE
      ENDIF
C----------
C  NOW SET ALL UNSET SPECIES SITES TO THE STAND SITE INDEX
C----------
      DO 15 I=1,MAXSP
        IF(SITEAR(I) .LT. .0001) SITEAR(I) = SITEAR(ISISP)
        IF(SDIDEF(I) .LE. 0.) THEN
          IF(BAMAX .GT. 0.)THEN
            SDIDEF(I)=BAMAX/(0.5454154*(PMSDIU/100.))
          ELSE
            SDIDEF(I)=BAMAXA(I)/(0.5454154*(PMSDIU/100.))
          ENDIF
        ENDIF
   15 CONTINUE
C----------
C  LOAD VOLUME DEFAULT MERCH. SPECS.
C----------
      DO ISPC=1,MAXSP
      IF(DBHMIN(ISPC).LE.0.)THEN               !SET **DBHMIN** DEFAULT
        IF(ISPC.LE.14)THEN                     !SOFTWOODS
          DBHMIN(ISPC)=5.
        ELSE                                   !HARDWOODS
          SELECT CASE(IFOR)
          CASE(2)
            DBHMIN(ISPC)=5.
            IF(ISPC.GE.40.AND.ISPC.LE.42)DBHMIN(ISPC)=6.
          CASE(6)
            DBHMIN(ISPC)=6.
          CASE DEFAULT
            DBHMIN(ISPC)=5.
          END SELECT
        ENDIF
      ENDIF
      IF(TOPD(ISPC).LE.0.)TOPD(ISPC)=4.        !SET **TOPD** DEFAULT
      IF(BFMIND(ISPC).LE.0.)THEN                 !SET **BFMIND** DEFAULT
        IF(ISPC.LE.14)THEN                     !SOFTWOODS
          BFMIND(ISPC)=9.
        ELSE                                   !HARDWOODS
          SELECT CASE(IFOR)
          CASE(2)
            BFMIND(ISPC)=9.
            IF(ISPC.GE.40.AND.ISPC.LE.42)BFMIND(ISPC)=11.
          CASE(5)
            BFMIND(ISPC)=11.
            IF(ISPC.GE.40.AND.ISPC.LE.42)BFMIND(ISPC)=9.
          CASE DEFAULT
            BFMIND(ISPC)=11.
          END SELECT
        ENDIF
      ENDIF
      IF(BFTOPD(ISPC).LE.0.)THEN                 !SET **BFTOPD** DEFAULT
        IF(ISPC.LE.14)THEN                     !SOFTWOODS
          BFTOPD(ISPC)=7.6
        ELSE                                   !HARDWOODS
          SELECT CASE(IFOR)
          CASE(2)
            BFTOPD(ISPC)=7.6
            IF(ISPC.GE.40.AND.ISPC.LE.42)BFTOPD(ISPC)=9.6
          CASE(5)
            BFTOPD(ISPC)=7.6
            IF(ISPC.GE.40.AND.ISPC.LE.42)BFTOPD(ISPC)=7.6
          CASE DEFAULT
            BFTOPD(ISPC)=9.6
          END SELECT
        ENDIF
      ENDIF
      ENDDO
C----------
C  LOAD VOLUME EQUATION ARRAYS FOR ALL SPECIES IF USING CLARK
C  OR GEVORKIANTZ. METHB8 AND METHC8 INDEX THE NUMBER OF SPECIS
C  USING TWIGS VOLUME EQS. (F7 =8 IN VOLUME AND BFVOLUME KEYWORDS
C  IF ALL TWIGS EQUATIONS, THEN DON'T PRINT THE NVEL TABLE
C----------
      KFORST = KODFOR-900
      IREGN=9
      WRITE(FORST,'(I2)')KFORST
      IF(KFORST.LT.10)FORST(1:1)='0'
      DIST='  '
      PROD='  '
      VAR='LS'
C
      METHB8=0
      METHC8=0
      DO ISPC=1,MAXSP
      READ(FIAJSP(ISPC),'(I4)')IFIASP
      IF(((METHC(ISPC).EQ.6).OR.(METHC(ISPC).EQ.9).OR.
     &    (METHC(ISPC).EQ.5)).AND.(VEQNNC(ISPC).EQ.'          '))THEN
        IF(METHC(ISPC).EQ.5)THEN
          VOLEQ(1:7)='900DVEE'
        ELSE
          VOLEQ(1:7)='900CLKE'
        ENDIF        
        CALL VOLEQDEF(VAR,IREGN,FORST,DIST,IFIASP,PROD,VOLEQ,ERRFLAG)
        VEQNNC(ISPC)=VOLEQ
C      WRITE(16,*)'PROD,IFIASP,ISPC,VEQNNC(ISPC)= ',PROD,IFIASP,ISPC,
C     &VEQNNC(ISPC)
      ELSEIF(METHC(ISPC).EQ.8)THEN
          METHC8=METHC8+1
      ENDIF
      IF(((METHB(ISPC).EQ.6).OR.(METHB(ISPC).EQ.9).OR.
     &    (METHB(ISPC).EQ.5)).AND.(VEQNNB(ISPC).EQ.'          '))THEN
        IF(METHB(ISPC).EQ.5)THEN
          VOLEQ(1:7)='900DVEE'
        ELSE
          VOLEQ(1:7)='900CLKE'
        ENDIF
        PROD='01'
        CALL VOLEQDEF(VAR,IREGN,FORST,DIST,IFIASP,PROD,VOLEQ,ERRFLAG)
        VEQNNB(ISPC)=VOLEQ
      ELSEIF(METHC(ISPC).EQ.8)THEN
          METHB8=METHB8+1
      ENDIF
      ENDDO
   50 CONTINUE
      DO 92 I=1,15
      J=(I-1)*10 + 1
      JJ=J+9
      IF(JJ.GT.MAXSP)JJ=MAXSP
      WRITE(JOSTND,90)(NSP(K,1)(1:2),K=J,JJ)
   90 FORMAT(/'SPECIES ',5X,10(A2,6X))
      WRITE(JOSTND,91)(SDIDEF(K),K=J,JJ )
   91 FORMAT('SDI MAX ',   10F8.0)
      IF(JJ .EQ. MAXSP)GO TO 93
   92 CONTINUE
   93 CONTINUE
C----------
C  IF FIA CODES WERE IN INPUT DATA, WRITE TRANSLATION TABLE
C---------
      IF(LFIA) THEN
        CALL FIAHEAD(JOSTND)
        WRITE(JOSTND,211) (NSP(I,1)(1:2),FIAJSP(I),I=1,MAXSP)
 211    FORMAT ((T12,8(A3,'=',A6,:,'; '),A,'=',A6))
      ENDIF
C----------
C  WRITE VOLUME EQUATION NUMBER TABLE
C----------
      IF((METHC8.NE.MAXSP).AND.(METHB8.NE.MAXSP))
     &CALL VOLEQHEAD(JOSTND)
      IF((METHC8.NE.MAXSP).AND.(METHB8.NE.MAXSP))
     &WRITE(JOSTND,230)(NSP(J,1)(1:2),VEQNNC(J),VEQNNB(J),J=1,MAXSP)
 230  FORMAT(4(2X,A2,4X,A10,1X,A10,1X))
      RETURN
      END
