      SUBROUTINE ESXCSH (HTMAX,HTMIN,TIME,II,DRAW,HHT)
      IMPLICIT NONE
C----------
C   **ESXCSH DATE OF LAST REVISION:   07/25/08
C----------
COMMONS
C
C
      INCLUDE 'PRGPRM.F77'
C
C
COMMONS
C
C     SUBROUTINE TO ASSIGN HEIGHTS TO EXCESS TREES
C
      REAL BB(3,MAXSP),CC(3,MAXSP),SHIFT(MAXSP)
      INTEGER II,ITIME
      REAL HHT,DRAW,TIME,HTMIN,HTMAX,CLASS,XUPPR,XX
      DATA SHIFT/4.0,4.0,4*2.0,4.0,2.0,2.0,4.0,2.0/
C
C     COEFFICIENTS FOR ARRAYS BB AND CC PREDICT TREE HEIGHT 'CLASS'
C     RATHER THAN ACTUAL HEIGHT; E.G.
C     CLASS  DF,GF,C,H,S,AF  WP,WL,LP,PP
C        1         .6            1.0
C        2         .8            1.2
C        3        1.0            1.4    ETC.
C     PLOT AGE(YRS): 3 THRU 7  8 THRU 12  13 THRU 20
C
      DATA BB/      2.121455,  5.060402,   5.979549,
     2              6.643726, 11.422982,  19.618871,
     3              3.816083,  8.161474,  10.987699,
     4              3.089571,  5.830185,  10.105748,
     5              3.347712,  6.806825,  13.553455,
     6              3.169513,  4.506403,   8.940539,
     7              7.360424, 10.928846,  25.214411,
     8              1.466152,  5.159270,   9.272780,
     9              2.921356,  4.581383,  10.333282,
     O              2.779221,  9.033310,  14.131212,
     A              3.347712,  6.806825,  13.553455/
      DATA CC/       .745850,   .782170,    .842171,
     2               .902909,  1.166155,   1.306380,
     3               .996732,   .845413,    .948037,
     4               .800681,   .832278,    .954081,
     5               .567768,   .894628,   1.214044,
     6               .640554,   .813543,    .943493,
     7              1.148084,  1.232333,   1.117025,
     8               .722527,   .739031,   1.125510,
     9               .885137,   .871559,   1.043759,
     O               .899325,  1.074932,    .930698,
     A               .567768,   .894628,   1.214044/
C
      ITIME=1
      IF(TIME.GT.7.5.AND.TIME.LT.12.5) ITIME=2
      IF(TIME.GT.12.5) ITIME=3
      CLASS=(HTMAX/0.2) -SHIFT(II)
      XUPPR=1.0-EXP(-(((CLASS-HTMIN)/BB(ITIME,II))**CC(ITIME,II)))
      XX=XUPPR*DRAW
      HHT=((-(ALOG(1.00-XX)))**(1.0/CC(ITIME,II)))*BB(ITIME,II)+HTMIN
      HHT=0.2*(HHT+SHIFT(II))
      RETURN
      END
