      SUBROUTINE SITSET
      IMPLICIT NONE
C----------
C  **SITSET--NE/M   DATE OF LAST REVISION: 10/19/11
C----------
C THIS SUBROUTINE LOADS THE SITEAR ARRAY WITH A SITE INDEX FOR EACH
C SPECIES WHICH WAS NOT ASSIGNED A SITE INDEX BY KEYWORD.
C
C EQUATIONS AND COEFFICIENTS FOR THIS SUBROUTINE COME FROM 'SITE INDEX
C CONVERSION EQUATIONS FOR THE NORTHEAST' BY DON HILT.  FILE REPORT
C NUMBER 1: RESEARCH WORK UNIT FS-NE-4153.
C----------
C
COMMONS
C
C
      INCLUDE 'PRGPRM.F77'
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
      INCLUDE 'VOLSTD.F77'
C
C
      INCLUDE 'METRIC.F77'
C
C
COMMONS
C
      REAL SICOEF(28,28),BAMAXA(MAXSP)
      INTEGER IPOINT(MAXSP)
      INTEGER I,J,ISPC,JSITE,JSPC,JJ,K
      LOGICAL DEBUG
      CHARACTER FORST*2,DIST*2,PROD*2,VAR*2,VOLEQ*10
      INTEGER IFIASP,ERRFLAG,IREGN,KFORST
C----------
C  LOAD BA MAXIMUM VALUES --- R9 APPROVED BAMAX.
C----------
      DATA BAMAXA /
     & 240.,   200.,   190.,   260.,   240.,   180.,   240.,
     & 240.,   240.,   210.,   150.,   200.,   200.,   150.,
     & 200.,   240.,   240.,   150.,   150.,   210.,   150.,
     & 150.,   170.,   150.,   150.,   190.,   190.,   190.,
     & 150.,   200.,   170.,   150.,   150.,   150.,   170.,
     & 170.,   170.,   170.,   170.,   170.,   150.,   170.,
     & 150.,   150.,   150.,   180.,   140.,   180.,   130.,
     & 150.,   130.,   130.,   130.,   200.,   170.,   160.,
     & 160.,   130.,   160.,   160.,   160.,   160.,   130.,
     & 170.,   160.,   160.,   170.,   160.,   160.,   130.,
     & 150.,   150.,   150.,   150.,   150.,   150.,   150.,
     & 150.,   160.,   150.,   150.,   150.,   150.,   140.,
     & 140.,   150.,   150.,   150.,   160.,   150.,   150.,
     & 150.,   170.,   170.,   150.,   150.,   150.,   150.,
     & 150.,   150.,   150.,   170.,   170.,   150.,   170.,
     & 170.,   150.,   150.   /
C----------
C  LOAD SITE INDEX CONVERSION COEFFICIENTS
C----------
      DATA ((SICOEF(I,J),I=1,28),J=1,28)/
     %  0.000,-3.200,-3.200,-3.200, 1.000, 1.000, 1.000, 1.000,
     %  5.632, 0.000, 1.000, 1.000, 1.000, 1.000, 1.000, 1.000,
     %  1.000, 1.000, 1.000, 1.000, 1.000, 1.000, 1.000, 1.000,
     %  1.000, 1.000,-3.200,5.632,
     %  1.000, 0.000, 0.000, 0.000, 1.000, 1.000, 1.000, 1.000,
     %  3.632, 1.000, 1.000, 1.000, 1.000, 1.000, 1.000, 1.000,
     %  1.000, 1.000, 1.000, 1.000, 1.000, 1.000, 1.000, 1.000,
     %  1.000, 1.000, 0.000, 3.632,
     %  1.000, 0.000, 0.000, 0.000, 1.000, 1.000, 1.000, 1.000,
     %  3.632, 1.000, 1.000, 1.000, 1.000, 1.000, 1.000, 1.000,
     %  1.000, 1.000, 1.000, 1.000, 1.000, 1.000, 1.000, 1.000,
     %  1.000, 1.000, 0.000, 3.632,
     %  1.000, 0.000, 0.000, 0.000, 1.000, 1.000, 1.000, 1.000,
     %  3.632, 1.000, 1.000, 1.000, 1.000, 1.000, 1.000, 1.000,
     %  1.000, 1.000, 1.000, 1.000, 1.000, 1.000, 1.000, 1.000,
     %  1.000, 1.000, 0.000, 3.632,
     %  7.592, 9.800, 9.800, 9.800, 0.000, 0.000, 0.000, 0.000,
     % 18.632, 7.592, 0.000, 3.176, 3.176, 3.176, 3.176, 3.176,
     %  3.176,-0.136,-1.240,-1.240,-1.240, 3.176, 0.986, 3.176,
     %  0.986, 0.986, 9.800,18.632,
     %  7.592, 9.800, 9.800, 9.800, 0.000, 0.000, 0.000, 0.000,
     % 18.632, 7.592, 0.000, 3.176, 3.176, 3.176, 3.176, 3.176,
     %  3.176,-0.136,-1.240,-1.240,-1.240, 3.176, 0.986, 3.176,
     %  0.986, 0.986, 9.800,18.632,
     %  7.592, 9.800, 9.800, 9.800, 0.000, 0.000, 0.000, 0.000,
     % 18.632, 7.592, 0.000, 3.176, 3.176, 3.176, 3.176, 3.176,
     %  3.176,-0.136,-1.240,-1.240,-1.240, 3.176, 0.986, 3.176,
     %  0.986, 0.986, 9.800,18.632,
     %  7.592, 9.800, 9.800, 9.800, 0.000, 0.000, 0.000, 0.000,
     % 18.632, 7.592, 0.000, 3.176, 3.176, 3.176, 3.176, 3.176,
     %  3.176,-0.136,-1.240,-1.240,-1.240, 3.176, 0.986, 3.176,
     %  0.986, 0.986, 9.800,18.632,
     %  1.000, 1.000, 1.000, 1.000, 1.000, 1.000, 1.000, 1.000,
     %  0.000, 1.000, 1.000, 1.000, 1.000, 1.000, 1.000, 1.000,
     %  1.000, 1.000, 1.000, 1.000, 1.000, 1.000, 1.000, 1.000,
     %  1.000, 1.000, 1.000, 0.000,
     %  0.000,-3.200,-3.200,-3.200, 1.000, 1.000, 1.000, 1.000,
     %  5.632, 0.000, 1.000, 1.000, 1.000, 1.000, 1.000, 1.000,
     %  1.000, 1.000, 1.000, 1.000, 1.000, 1.000, 1.000, 1.000,
     %  1.000, 1.000,-3.200, 5.632,
     %  7.592, 9.800, 9.800, 9.800, 0.000, 0.000, 0.000, 0.000,
     % 18.632, 7.592, 0.000, 3.176, 3.176, 3.176, 3.176, 3.176,
     %  3.176,-0.136,-1.240,-1.240,-1.240, 3.176, 0.986, 3.176,
     %  0.986, 0.986, 9.800,18.632,
     % -1.408, 0.800, 0.800, 0.800, 1.000, 1.000, 1.000, 1.000,
     %  9.632,-1.408, 1.000, 0.000, 0.000, 0.000, 0.000, 0.000,
     %  0.000, 1.000, 1.000, 1.000, 1.000, 0.000, 1.000, 0.000,
     %  1.000, 1.000, 0.800, 9.632,
     % -1.408, 0.800, 0.800, 0.800, 1.000, 1.000, 1.000, 1.000,
     %  9.632,-1.408, 1.000, 0.000, 0.000, 0.000, 0.000, 0.000,
     %  0.000, 1.000, 1.000, 1.000, 1.000, 0.000, 1.000, 0.000,
     %  1.000, 1.000, 0.800, 9.632,
     % -1.408, 0.800, 0.800, 0.800, 1.000, 1.000, 1.000, 1.000,
     %  9.632,-1.408, 1.000, 0.000, 0.000, 0.000, 0.000, 0.000,
     %  0.000, 1.000, 1.000, 1.000, 1.000, 0.000, 1.000, 0.000,
     %  1.000, 1.000, 0.800, 9.632,
     % -1.408, 0.800, 0.800, 0.800, 1.000, 1.000, 1.000, 1.000,
     %  9.632,-1.408, 1.000, 0.000, 0.000, 0.000, 0.000, 0.000,
     %  0.000, 1.000, 1.000, 1.000, 1.000, 0.000, 1.000, 0.000,
     %  1.000, 1.000, 0.800, 9.632,
     % -1.408, 0.800, 0.800, 0.800, 1.000, 1.000, 1.000, 1.000,
     %  9.632,-1.408, 1.000, 0.000, 0.000, 0.000, 0.000, 0.000,
     %  0.000, 1.000, 1.000, 1.000, 1.000, 0.000, 1.000, 0.000,
     %  1.000, 1.000, 0.800, 9.632,
     % -1.408, 0.800, 0.800, 0.800, 1.000, 1.000, 1.000, 1.000,
     %  9.632,-1.408, 1.000, 0.000, 0.000, 0.000, 0.000, 0.000,
     %  0.000, 1.000, 1.000, 1.000, 1.000, 0.000, 1.000, 0.000,
     %  1.000, 1.000, 0.800, 9.632,
     %  1.592, 3.800, 3.800, 3.800, 1.000, 1.000, 1.000, 1.000,
     % 12.632, 1.592, 1.000,-2.824,-2.824,-2.824,-2.824,-2.824,
     % -2.824, 0.000, 1.000, 1.000, 1.000,-2.824,-5.032,-2.824,
     % -5.032,-5.032, 3.800,12.632,
     %  2.592, 4.800, 4.800, 4.800, 1.000, 1.000, 1.000, 1.000,
     % 13.632, 2.592, 1.000,-1.824,-1.824,-1.824,-1.824,-1.824,
     % -1.824,-5.136, 0.000, 0.000, 0.000,-1.824,-4.032,-1.824,
     % -4.032,-4.032, 4.800,13.632,
     %  2.592, 4.800, 4.800, 4.800, 1.000, 1.000, 1.000, 1.000,
     % 13.632, 2.592, 1.000,-1.824,-1.824,-1.824,-1.824,-1.824,
     % -1.824,-5.136, 0.000, 0.000, 0.000,-1.824,-4.032,-1.824,
     % -4.032,-4.032, 4.800,13.632,
     %  2.592, 4.800, 4.800, 4.800, 1.000, 1.000, 1.000, 1.000,
     % 13.632, 2.592, 1.000,-1.824,-1.824,-1.824,-1.824,-1.824,
     % -1.824,-5.136, 0.000, 0.000, 0.000,-1.824,-4.032,-1.824,
     % -4.032,-4.032, 4.800,13.632,
     % -1.408, 0.800, 0.800, 0.800, 1.000, 1.000, 1.000, 1.000,
     %  9.632,-1.408, 1.000, 0.000, 0.000, 0.000, 0.000, 0.000,
     %  0.000, 1.000, 1.000, 1.000, 1.000, 0.000, 1.000, 0.000,
     %  1.000, 1.000, 0.800, 9.632,
     %  0.592, 2.800, 2.800, 2.800, 1.000, 1.000, 1.000, 1.000,
     % 11.632, 0.592, 1.000,-3.824,-3.824,-3.824,-3.824,-3.824,
     % -3.824, 1.000, 1.000, 1.000, 1.000,-3.824, 0.000,-3.824,
     %  0.000, 0.000, 2.800,11.632,
     % -1.408, 0.800, 0.800, 0.800, 1.000, 1.000, 1.000, 1.000,
     %  9.632,-1.408, 1.000, 0.000, 0.000, 0.000, 0.000, 0.000,
     %  0.000, 1.000, 1.000, 1.000, 1.000, 0.000, 1.000, 0.000,
     %  1.000, 1.000, 0.800, 9.632,
     %  0.592, 2.800, 2.800, 2.800, 1.000, 1.000, 1.000, 1.000,
     % 11.632, 0.592, 1.000,-3.824,-3.824,-3.824,-3.824,-3.824,
     % -3.824, 1.000, 1.000, 1.000, 1.000,-3.824, 0.000,-3.824,
     %  0.000, 0.000, 2.800,11.632,
     %  0.592, 2.800, 2.800, 2.800, 1.000, 1.000, 1.000, 1.000,
     % 11.632, 0.592, 1.000,-3.824,-3.824,-3.824,-3.824,-3.824,
     % -3.824, 1.000, 1.000, 1.000, 1.000,-3.824, 0.000,-3.824,
     %  0.000, 0.000, 2.800,11.632,
     %  1.000, 0.000, 0.000, 0.000, 1.000, 1.000, 1.000, 1.000,
     %  3.632, 1.000, 1.000, 1.000, 1.000, 1.000, 1.000, 1.000,
     %  1.000, 1.000, 1.000, 1.000, 1.000, 1.000, 1.000, 1.000,
     %  1.000, 1.000, 0.000, 3.632,
     %  1.000, 1.000, 1.000, 1.000, 1.000, 1.000, 1.000, 1.000,
     %  0.000, 1.000, 1.000, 1.000, 1.000, 1.000, 1.000, 1.000,
     %  1.000, 1.000, 1.000, 1.000, 1.000, 1.000, 1.000, 1.000,
     %  1.000, 1.000, 1.000, 0.000/
      DATA IPOINT/1,2,3,4*4,5,6,7,8,4*9,2*10,8*11,12,3*13,3*14,
     &            2*15,5*16,17,5*18,3*19,5*20,21,5*22,4*23,3*24,2*25,
     &            2*26,27*27,11*28/
C----------
C  SEE IF WE NEED TO DO SOME DEBUG.
C----------
      CALL DBCHK (DEBUG,'SITSET',6,ICYC)
C----------
C  DEFAULT MERCH LIMITS ARE SET IN LS/VOLS
C----------
C  IF SITE INDEX SPECIES IS NOT GIVEN, THEN ASSUME AN AVERAGE SITE
C  INDEX OF 56 FOR SUGAR MAPLE.
C----------
      IF (ISISP .LE. 0) ISISP=27
      IF (SITEAR(ISISP).LE.0.0) SITEAR(ISISP) = 56.
C
      IF (DEBUG) WRITE(JOSTND,9003)ISISP,SITEAR(ISISP)
 9003 FORMAT(' MAIN REF SPECIES ',I5,' SITE INDEX ',F10.1)
C
      DO 25 ISPC = 1,MAXSP
        JSITE=IPOINT(ISISP)
        JSPC=IPOINT(ISPC)
 	      IF(SITEAR(ISPC).GT.0.0001) GO TO 25
        IF(SICOEF(JSITE,JSPC).EQ.0) THEN
          SITEAR(ISPC) = SITEAR(ISISP)
        ELSEIF (SICOEF(JSITE,JSPC).EQ.1) THEN
          SITEAR(ISPC) =(SITEAR(ISISP)-SICOEF(JSPC,JSITE))/1.104
        ELSE
          SITEAR(ISPC) = SICOEF(JSITE,JSPC)+1.104*SITEAR(ISISP)
        ENDIF
        IF(DEBUG) WRITE(JOSTND,*)' SDIDEF= ',SDIDEF(ISPC),
     &  ' JSPC= ',JSPC,' JSITE= ',JSITE
   25 CONTINUE
C----------
C  HT-DBH COEFFICIENTS
C----------
      HT1(1)=  4.5084
      HT1(2)=  4.5084
      HT1(3)=  4.5084
      HT1(4)=  4.5084
      HT1(5)=  4.5084
      HT1(6)=  4.5084
      HT1(7)=  4.5084
      HT1(8)=  4.5084
      HT1(9)=  4.6090
      HT1(10)= 4.6897
      HT1(11)= 4.4718
      HT1(12)= 4.5084
      HT1(13)= 4.5084
      HT1(14)= 4.4718
      HT1(15)= 4.4718
      HT1(16)= 4.5084
      HT1(17)= 4.5084
      HT1(18)= 4.3898
      HT1(19)= 4.5084
      HT1(20)= 4.6271
      HT1(21)= 4.3898
      HT1(22)= 4.3898
      HT1(23)= 4.5457
      HT1(24)= 4.5457
      HT1(25)= 4.0374
      HT1(26)= 4.3379
      HT1(27)= 4.4834
      HT1(28)= 4.4834
      HT1(29)= 4.5991
      HT1(30)= 4.4388
      HT1(31)= 4.4522
      HT1(32)= 4.4388
      HT1(33)= 4.4388
      HT1(34)= 4.4388
      HT1(35)= 4.5128
      HT1(36)= 4.5128
      HT1(37)= 4.5128
      HT1(38)= 4.5128
      HT1(39)= 4.5128
      HT1(40)= 4.4772
      HT1(41)= 4.4819
      HT1(42)= 4.5959
      HT1(43)= 4.6155
      HT1(44)= 4.6155
      HT1(45)= 4.4819
      HT1(46)= 4.6892
      HT1(47)= 4.5920
      HT1(48)= 4.6067
      HT1(49)= 4.5128
      HT1(50)= 4.5959
      HT1(51)= 4.9396
      HT1(52)= 4.5959
      HT1(53)= 4.5959
      HT1(54)= 4.3286
      HT1(55)= 4.5463
      HT1(56)= 4.5225
      HT1(57)= 4.3420
      HT1(58)= 4.2496
      HT1(59)= 4.5225
      HT1(60)= 4.5225
      HT1(61)= 4.4618
      HT1(62)= 4.5577
      HT1(63)= 4.5225
      HT1(64)= 4.4618
      HT1(65)= 4.7342
      HT1(66)= 4.6135
      HT1(67)= 4.5202
      HT1(68)= 4.5142
      HT1(69)= 4.4747
      HT1(70)= 4.7342
      HT1(71)= 4.0322
      HT1(72)= 4.5820
      HT1(73)= 4.5820
      HT1(74)= 4.4388
      HT1(75)= 4.4207
      HT1(76)= 4.4207
      HT1(77)= 4.4207
      HT1(78)= 4.5018
      HT1(79)= 4.5018
      HT1(80)= 4.0322
      HT1(81)= 4.4004
      HT1(82)= 4.3609
      HT1(83)= 3.9678
      HT1(84)= 4.4330
      HT1(85)= 4.3802
      HT1(86)= 4.1352
      HT1(87)= 4.4207
      HT1(88)= 4.6355
      HT1(89)= 4.9396
      HT1(90)= 4.4299
      HT1(91)= 4.4911
      HT1(92)= 4.3383
      HT1(93)= 4.5820
      HT1(94)= 4.5820
      HT1(95)= 4.3744
      HT1(96)= 4.6008
      HT1(97)= 4.6238
      HT1(98)= 4.4207
      HT1(99)= 4.5018
      HT1(100)=4.4207
      HT1(101)=4.4207
      HT1(102)=4.4207
      HT1(103)=4.0322
      HT1(104)=3.7301
      HT1(105)=4.4207
      HT1(106)=4.0322
      HT1(107)=3.9678
      HT1(108)=4.4207
C                  
      HT2(1)=  -6.0116
      HT2(2)=  -6.0116
      HT2(3)=  -6.0116
      HT2(4)=  -6.0116
      HT2(5)=  -6.0116
      HT2(6)=  -6.0116
      HT2(7)=  -6.0116
      HT2(8)=  -6.0116
      HT2(9)=  -6.1896
      HT2(10)= -6.8801
      HT2(11)= -5.0078
      HT2(12)= -6.0116   
      HT2(13)= -6.0116
      HT2(14)= -5.0078
      HT2(15)= -5.0078
      HT2(16)= -6.0116
      HT2(17)= -6.0116
      HT2(18)= -5.7183    
      HT2(19)= -6.0116
      HT2(20)= -6.4095
      HT2(21)= -5.7183
      HT2(22)= -5.7183
      HT2(23)= -6.8000
      HT2(24)= -6.8000
      HT2(25)= -4.2964
      HT2(26)= -3.8214
      HT2(27)= -4.5431
      HT2(28)= -4.5431
      HT2(29)= -6.6706
      HT2(30)= -4.0872
      HT2(31)= -4.5758
      HT2(32)= -4.0872
      HT2(33)= -4.0872
      HT2(34)= -4.0872
      HT2(35)= -4.9918
      HT2(36)= -4.9918
      HT2(37)= -4.9918
      HT2(38)= -4.9918
      HT2(39)= -4.9918
      HT2(40)= -4.7206
      HT2(41)= -4.5314
      HT2(42)= -6.4497
      HT2(43)= -6.2945
      HT2(44)= -6.2945
      HT2(45)= -4.5314
      HT2(46)= -4.9605
      HT2(47)= -5.1719
      HT2(48)= -5.2030
      HT2(49)= -4.9918
      HT2(50)= -6.4497
      HT2(51)= -8.1838
      HT2(52)= -6.4497
      HT2(53)= -6.4497
      HT2(54)= -4.0922
      HT2(55)= -5.2287
      HT2(56)= -4.9401
      HT2(57)= -5.1193
      HT2(58)= -4.8061
      HT2(59)= -4.9401
      HT2(60)= -4.9401
      HT2(61)= -4.8786
      HT2(62)= -4.9595
      HT2(63)= -4.9401
      HT2(64)= -4.8786
      HT2(65)= -6.2674
      HT2(66)= -5.7613
      HT2(67)= -4.8896
      HT2(68)= -5.2205
      HT2(69)= -4.8698
      HT2(70)= -6.2674
      HT2(71)= -3.0833
      HT2(72)= -5.0903
      HT2(73)= -5.0903
      HT2(74)= -4.0872
      HT2(75)= -5.1435
      HT2(76)= -5.1435
      HT2(77)= -5.1435
      HT2(78)= -5.6123
      HT2(79)= -5.6123
      HT2(80)= -3.0833
      HT2(81)= -4.7519
      HT2(82)= -4.1423
      HT2(83)= -3.2510
      HT2(84)= -4.5383
      HT2(85)= -4.7903
      HT2(86)= -3.7450
      HT2(87)= -5.1435
      HT2(88)= -5.2776
      HT2(89)= -8.1838
      HT2(90)= -4.9920
      HT2(91)= -5.7928
      HT2(92)= -4.5018
      HT2(93)= -5.0903
      HT2(94)= -5.0903
      HT2(95)= -4.5257
      HT2(96)= -7.2732
      HT2(97)= -7.4847
      HT2(98)= -5.1435
      HT2(99)= -5.6123
      HT2(100)=-5.1435
      HT2(101)=-5.1435
      HT2(102)=-5.1435
      HT2(103)=-3.0833
      HT2(104)=-2.7758
      HT2(105)=-5.1435
      HT2(106)=-3.0833
      HT2(107)=-3.2510
      HT2(108)=-5.1435
C----------
C  FOR ALLEGHENY SUBSTITUTE HT-DBH COEFFICIENTS FIT FROM TECH NOTE 6 
C  BY A.F.HOUGH
C----------
      IF(IFOR.EQ.3)THEN
C RED MAPLE
        HT1(26) = 4.6839
        HT2(26) = -4.9622
C SUGAR MAPLE
        HT1(27) = 4.6354
        HT2(27) = -4.7168
C YELLOW BIRCH
        HT1(30) = 4.4635
        HT2(30) = -3.6456
C SWEET BIRCH USE YELLOW BIRCH
        HT1(31) = 4.4635
        HT2(31) = -3.6456
C PAPER BIRCH USE YELLOW BIRCH
        HT1(33) = 4.4635
        HT2(33) = -3.6456
C AMERICAN BEECH
        HT1(40) = 4.5497
        HT2(40) = -4.6727
C ASH SP. USE WHITE ASH
        HT1(41) = 4.6804
        HT2(41) = -4.5561
C WHITE ASH
        HT1(42) = 4.6804
        HT2(42) = -4.5561
C GREEN ASH USE WHITE ASH
        HT1(44) = 4.6804
        HT2(44) = -4.5561
C BLACK CHERRY
        HT1(54) = 4.7614
        HT2(54) = -5.3776
C WHITE OAK
        HT1(55) = 4.9100
        HT2(55) = -7.2941
C SCARLET OAK
        HT1(60) = 4.9100
        HT2(60) = -7.2941
C CHESTNUT OAK
        HT1(64) = 4.9100
        HT2(64) = -7.2941
C N. RED OAK
        HT1(67) = 4.9100
        HT2(67) = -7.2941
C BLACK OAK
        HT1(69) = 4.9100
        HT2(69) = -7.2941
C OTHER HARDWOODS USE HOPHORNBEAM
        HT1(71) = 4.4393
        HT2(71) = -4.0711
C AMERICAN BASSWOOD
        HT1(93) = 4.6855
        HT2(93) = -4.8690
C SERVICEBERRY USE HOPHORNBEAM
        HT1(102) = 4.4393
        HT2(102) = -4.0711
C HOPHORNBEAM
        HT1(106) = 4.4393
        HT2(106) = -4.0711
C PIN CHERRY  USE BLACK CHERRY
        HT1(108) = 4.7614
        HT2(108) = -5.3776
      ENDIF
C----------
C  SET SDIDEF ARRAY, IF NOT SET BY KEYWORD.
C----------
      DO 30 I=1,MAXSP
      IF(SDIDEF(I) .LE. 0.) THEN
        IF(BAMAX .GT. 0.)THEN
          SDIDEF(I)=BAMAX/(0.5454154*(PMSDIU/100.))
        ELSE
          SDIDEF(I)=BAMAXA(I)/(0.5454154*(PMSDIU/100.))
        ENDIF
      ENDIF
   30 CONTINUE
C----------
C  LOAD VOLUME DEFAULT MERCH. SPECS.
C----------
      DO ISPC=1,MAXSP
      IF(DBHMIN(ISPC).LE.0.)THEN                   !SET **TOPD** DEFAULT
        IF(ISPC.LE.25)THEN                     !SOFTWOODS
          DBHMIN(ISPC)=5.
        ELSE                                   !HARDWOODS
          SELECT CASE(IFOR)
          CASE(1,3)
            DBHMIN(ISPC)=6.
          CASE(4)
            DBHMIN(ISPC)=8.
          CASE(2,5)
            DBHMIN(ISPC)=5.
          END SELECT
        ENDIF
      ENDIF
      IF(TOPD(ISPC).LE.0.) THEN        !SET **TOPD** DEFAULT
        IF(ISPC.LE.25)THEN                     !SOFTWOODS
          TOPD(ISPC)=4.
        ELSE
          SELECT CASE(IFOR)
          CASE(3)
            TOPD(ISPC)=5.
          CASE DEFAULT
            TOPD(ISPC)=4.
          END SELECT
        ENDIF
      ENDIF
      IF(BFMIND(ISPC).LE.0.)THEN                 !SET **BFMIND** DEFAULT
        IF(ISPC.LE.25)THEN                     !SOFTWOODS
          BFMIND(ISPC)=9.
        ELSE                                   !HARDWOODS
          BFMIND(ISPC)=11.
        ENDIF
      ENDIF
      IF(BFTOPD(ISPC).LE.0.)THEN                 !SET **BFTOPD** DEFAULT
        IF(ISPC.LE.25)THEN                     !SOFTWOODS
          BFTOPD(ISPC)=7.6
        ELSE                                   !HARDWOODS
          BFTOPD(ISPC)=9.6
        ENDIF
      ENDIF
      ENDDO
C----------
C  LOAD VOLUME EQUATION ARRAYS FOR ALL SPECIES
C----------
      KFORST = KODFOR-900
      IREGN=9
      WRITE(FORST,'(I2)')KFORST
      IF(KFORST.LT.10)FORST(1:1)='0'
      DIST='  '
      PROD='  '
      VAR='NE'
C
      DO ISPC=1,MAXSP
      READ(FIAJSP(ISPC),'(I4)')IFIASP
      IF(((METHC(ISPC).EQ.6).OR.(METHC(ISPC).EQ.9).OR.
     &    (METHC(ISPC).EQ.5)).AND.(VEQNNC(ISPC).EQ.'          '))THEN
        IF(METHC(ISPC).EQ.5)THEN
          VOLEQ(1:7)='900DVEE'
        ELSE
          VOLEQ(1:7)='900CLKE'
        ENDIF        
        PROD='02'
        CALL VOLEQDEF(VAR,IREGN,FORST,DIST,IFIASP,PROD,VOLEQ,ERRFLAG)
        VEQNNC(ISPC)=VOLEQ
C      WRITE(16,*)' PROD,IFIASP,ISPC,VEQNNC(ISPC)= ',PROD,IFIASP,ISPC,
C     &VEQNNC(ISPC)
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
      ENDIF
      ENDDO
C
      DO 92 I=1,15
      J=(I-1)*10 + 1
      JJ=J+9
      IF(JJ.GT.MAXSP)JJ=MAXSP
      WRITE(JOSTND,90)(NSP(K,1)(1:2),K=J,JJ)
   90 FORMAT(/' SPECIES ',5X,10(A2,6X))
      WRITE(JOSTND,91)(SDIDEF(K)/ACRtoHA,K=J,JJ )
   91 FORMAT(' SDI MAX ',   10F8.0)
      IF(JJ .EQ. MAXSP)GO TO 93
   92 CONTINUE
   93 CONTINUE
C----------
C  IF FIA CODES WERE IN INPUT DATA, WRITE TRANSLATION TABLE
C---------
      IF(LFIA) THEN
        CALL FIAHEAD(JOSTND)
        WRITE(JOSTND,211) (NSP(I,1)(1:2),FIAJSP(I),I=1,MAXSP)
 211    FORMAT ((T13,8(A3,'=',A6,:,'; '),A,'=',A6))
      ENDIF
C----------
C  WRITE VOLUME EQUATION NUMBER TABLE
C----------
      CALL VOLEQHEAD(JOSTND)
      WRITE(JOSTND,230)(NSP(J,1)(1:2),VEQNNC(J),VEQNNB(J),J=1,MAXSP)
 230  FORMAT(4(3X,A2,4X,A10,1X,A10))
C
      RETURN
      END
