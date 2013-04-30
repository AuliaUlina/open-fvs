      SUBROUTINE TWIGBF(ISPC,H,D,VMAX,BBFV)
      IMPLICIT NONE
C----------
C  **TWIGBF---NE  DATE OF LAST REVISION:  07/11/08
C----------
C
COMMONS
C
C
      INCLUDE 'PRGPRM.F77'
C
C
      INCLUDE 'PLOT.F77'
C
C
      INCLUDE 'CONTRL.F77'
C
C
      INCLUDE 'VOLSTD.F77'
C
C
COMMONS
C
C  ************** BOARD FOOT MERCHANTABILITY SPECIFICATIONS ********
C
C  BFVOL CALCULATES BOARD FOOT VOLUME OF ANY TREE LARGER THAN A MINIMUM
C  DBH SPECIFIED BY THE USER.  MINIMUM DBH CAN VARY BY SPECIES,
C  BUT CANNOT BE LESS THAN 2 INCHES.  DEFAULTS ARE 7 IN. FOR SOFTWOODS
C  AND 9 IN. FOR HARDWOODS.  MINIMUM MERCHANTABLE DBH IS
C  SET WITH THE BFVOLUME KEYWORD.
C
C  MERCHANTABLE TOP DIAMETER CAN BE SET WITH THE BFVOLUME KEYWORD
C  AT ANY VALUE BETWEEN 2 IN. AND ACTUAL DBH.  THIS DIAMETER IS
C  OUTSIDE BARK -- IF DIB IS DESIRED, ALLOWANCE FOR DOUBLE BARK
C  THICKNESS MUST BE MADE IN SPECIFICATION OF TOP DIAMETER.
C
C----------
C  SHB1   -- INTERCEPT COEFFICIENT IN THE MODEL PREDICTING SAWLOG
C            HEIGHT (ONE COEFFICIENT PER SPECIES).
C  SHB2   -- COEFFICIENT FOR SITE INDEX TERM IN THE MODEL PREDICTING
C            SAWLOG HEIGHT (ONE COEFFICIENT PER SPECIES).
C  SHB3   -- COEFFICIENT FOR (DBH-TDOB) TERM IN THE MODEL PREDICTING
C            SAWLOG HEIGHT (ONE COEFFICIENT PER SPECIES).
C  NEBF1  -- B1 COEFFICIENT IN THE NORTHEASTERN FOREST SURVEY
C            BOARD FOOT VOLUME EQUATION.
C  NEBF2  -- B2 COEFFICIENT IN THE NORTHEASTERN FOREST SURVEY BOARD-
C            FOOT VOLUME EQUATION.
C  NEBF3  -- B3 COEFFICIENT IN THE NORTHEASTERN FOREST SURVEY BOARD-
C            FOOT VOLUME EQUATION.
C  NEBF4  -- B4 COEFFICIENT IN THE NORTHEASTERN FOREST SURVEY BOARD-
C            FOOT VOLUME EQUATION.
C  NEBF5  -- B5 COEFFICIENT IN THE NORTHEASTERN FOREST SURVEY BOARD-
C            FOOT VOLUME EQUATION
C  NEBF6  -- B6 COEFFICIENT IN THE NORTHEASTERN FOREST SURVEY BOARD-
C            FOOT VOLUME EQUATION
C----------
      REAL NEBF1(MAXSP),NEBF2(MAXSP),NEBF3(MAXSP)
      REAL NEBF4(MAXSP),NEBF5(MAXSP),NEBF6(MAXSP)
      REAL SHB1(MAXSP),SHB2(MAXSP),SHB3(MAXSP)
      REAL BBFV,VMAX,D,H,SH,B1,B2,B3,B4,B5,B6
      INTEGER ISPC
C----------
C  DATA STATEMENTS AND INITIALIZATIONS.
C----------
      DATA SHB1/
     &  10.366,37.572,32.532,4*17.995, 5.199,39.900, 5.199,10.278,
     &  4*24.385,2*33.152,8*5.199,14.197,3*25.696,3*22.540,2*20.458,
     &  5*39.321,15.530,5*13.321,3*50.572,5*10.736,11.837,5*11.050,
     &  4*22.206,3*10.405,2*25.095,2*16.636,27*35.152,11*0.000/
      DATA SHB2/
     &  0.322,.0,.056,4*.203,0.530,0.031,0.530,0.334,4*.024,2*.057,
     &  8*.530,.190,3*.064,3*.050,2*.061,5*.000,.167,5*.238,3*.0,
     &  5*.290,.219,5*.283,4*.132,3*.308,2*.086,2*.201,27*.0,11*.0/
      DATA SHB3/
     &  .467,.431,.327,4*.352,.321,.234,.321,.436,4*.376,2*.216,
     &  8*.321,.473,3*.418,3*.673,2*.882,5*.360,.405,5*.468,3*.276,
     &  5*.546,.337,5*.387,4*.370,3*.379,2*.403,2*.328,27*.369,11*.0/
      DATA NEBF1/
     &  -12.29,-6.78,-13.03,4*-13.03,-12.25,-12.25,-12.25,-6.78,4*-8.89,
     &  2*-8.36,8*-6.78,2.84,3*3.73,3*8.23,2*8.23,5*-1.24,-0.84,5*9.20,
     &  3*2.84,5*9.20,1.58,5*4.46,4*1.01,3*4.46,4*1.01,27*0.03,11*.0/
      DATA NEBF2/
     &  -.08212,-.00841,-.05197,4*-.05197,-0.02418,-0.02418,
     &  -.02418,-.00841,4*-.07324,2*-0.01433,8*-.00841,-.00557,
     &  3*-.00182,3*-.00039,2*-.00039,5*-.00385,-.01207,5*.00052,
     &  3*-.00557,5*.00052,-.00151,5*-.00061,4*-.00192,3*-.00061,
     &  2*-.00192,2*-.00192,27*-.00196,11*0.00000/
      DATA NEBF3/
     &   2.5641,2.7001,2.5248,4*2.5248,2.6865,2.6865,2.6865,2.7001,
     &   4*2.4556,2*2.7878,8*2.7001,3.1808,3*3.3766,5*3.0,5*3.1648,
     &   3.0043,5*3.0,3*3.1808,5*3.0,3.3878,5*3.5972,4*3.3188,3*3.5972,
     &   4*3.3188,27*3.3236,11*0.0000/
      DATA NEBF4/
     &   .1416,.0645,.1200,4*.1200,0.0961,0.0961,0.0961,0.0645,
     &   4*.1216,2*.0771,8*.0645,.0296,3*.0262,3*.0206,2*.0206,5*.0312,
     &   .0419,5*.0193,3*.0296,5*.0193,.0287,5*.0182,4*.0246,3*.0182,
     &   2*.0246,2*.0246,27*.0263,11*.0000/
      DATA NEBF5/
     &   2.2657,2.1938,5*2.1999,2.2281,2.2281,2.2281,2.1938,
     &   4*2.2382,2*2.2593,8*2.1938,2.4606,3*2.4291,5*2.2116,5*2.3888,
     &   2.3951,5*2.2165,3*2.4606,5*2.2165,2.3875,5*2.4804,4*2.4268,
     &   3*2.4804,4*2.4268,27*2.4162,11*0.0/
      DATA NEBF6/
     &   .3744,.4713,.4227,4*.4227,.4222,.4222,.4222,.4713,
     &   4*.3249,2*.4202,8*.4713,.5771,3*.6139,3*.8019,2*.8019,5*.6067,
     &   .5912,5*.8043,3*.5771,5*.8043,.6356,5*.5922,4*.6000,3*.5922,
     &   4*.6000,27*0.6012,11*0.0000/
C
C-----------------------------------------------------------------
C  NORTHEASTERN FOREST SURVEY VOLUME EQUATIONS:
C  --SCOTT, CHARLES, T. 1979. NORTHEASTERN FOREST SURVEY BOARD-FOOT
C    VOLUME EQUATIONS. USDA FOR. SERV RES. NOTE NE-271.
C
C  BFVOL=B1+BS(DBH)^B3+(B4(DBH)^B5)*H^B6
C
C  WHERE H = HEIGHT (IN FEET) TO TOP DIAMETER OUTSIDE BARK (TDOB)
C   TDOB FOR BFVOL = 9 INCHES (HARDWOODS) AND 7 INCHES (SOFTWOODS).
C
C  MERCHANTABLE HEIGHT EQUATIONS:
C  --YAUSSY, D.A. AND M.E. DALE. 1990. SAWLOG AND BOLE LENGTH
C    GENERALIZED MERCHANTABLE HEIGHT EQUATIONS FOR THE NORTHEASTERN
C    UNITED STATES.  USDA FOR. SERV. RES. PAP. NE-??? (IN PRESS).
C
C  HEIGHT=C1*SI^C2*(1-EXP(C3*(DBH-TD)))
C
C------------------------------------------------------------------
        SH=SHB1(ISPC)*SITEAR(ISPC)**SHB2(ISPC)*(1.0-EXP(-1.0*SHB3(ISPC)*
     &       (D-BFTOPD(ISPC))))
        B1=NEBF1(ISPC)
        B2=NEBF2(ISPC)
        B3=NEBF3(ISPC)
        B4=NEBF4(ISPC)
        B5=NEBF5(ISPC)
        B6=NEBF6(ISPC)
C----------
C  COMPUTE MERCH BOARD FOOT VOLUME (BBFV)
C----------
        BBFV=B1+B2*D**B3+B4*D**B5*SH**B6
        VMAX=BBFV
        RETURN
        END
