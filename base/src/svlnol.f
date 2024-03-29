      SUBROUTINE SVLNOL (XJ1,YJ1,XJ2,YJ2,
     >                   XK1,YK1,XK2,YK2,XS,YS,KODE)
      IMPLICIT NONE
C----------
C  $Id$
C----------
C
C     STAND VISUALIZATION GENERATION
C     N.L.CROOKSTON -- RMRS MOSCOW -- NOVEMBER 1998
C
C     RETURNS KODE = 0 IF THE LINES DON'T CROSS, 1 IF THEY DO.
C     IF THEY DO, THEN XS,YS ARE RETURNED AS A LOCATION IN COMMON
C     OTHERWISE XS,YS ARE BOTH UNDEFINED (SET TO ZERO).
C
      REAL XS,YS,YK2,XK2,YK1,XK1,YJ2,XJ2,YJ1,XJ1,BJ,AJ,BK,AK
      INTEGER KODE,KODEJ,KODEK
      
      XS = 0.
      YS = 0.
      KODE = 0
C
      CALL SVDFLN (XJ1,YJ1,XJ2,YJ2,AJ,BJ,KODEJ)
      CALL SVDFLN (XK1,YK1,XK2,YK2,AK,BK,KODEK)
C
C     IF EITHER LINE IS VERTICAL, THEN WE HAVE SOME SPECIAL
C     CASES...
C
      IF (KODEJ.EQ.1 .AND. KODEK.EQ.1) THEN
C
C        WE HAVE 2 VERTICAL LINES.  IF THE X'S ARE NOT EQUAL, THEN
C        THEY ARE PARALLEL AND DON'T CROSS.
C
         IF (ABS(XJ1-XK1) .GT. .000001) RETURN
C
C        THEY ARE THE SAME LINE...DO THE LINE SEGMENTS OVERLAP
C        ALONG THE Y AXIS.
C
         CALL SVLSOL (YJ1,YJ2,YK1,YK2,YS,KODE)
         XS = XJ1
         RETURN
C
C     LINE J IS VERTICAL AND K IS NOT.
C
      ELSEIF (KODEJ.EQ.1) THEN
C
         XS = XJ1
         YS = AK + (BK*XS)
C
C     LINE K IS VERTICAL AND J IS NOT.
C        
      ELSEIF (KODEK.EQ.1) THEN
C
         XS = XK1
         YS = AJ + (BJ*XS)
C
C     THE LINES HAVE THE SAME SLOPE.
C
      ELSEIF (ABS(BJ-BK).LT. .000001) THEN
C
C        IF THEY HAVE DIFFERENT INTERCEPTS, THEN THEY HAVE NO
C        POINTS IN COMMON...THEY DON'T CROSS.
C
         IF (ABS(AJ-AK).GT. .000001) RETURN
C
C        THEY ARE THE SAME LINE...(THEY HAVE THE SAME SLOPE AND 
C        INTERCEPT) CHECK OF OVERLAP ALONG THE X AXIS...         
C
         CALL SVLSOL (XJ1,XJ2,XK1,XK2,XS,KODE)
         IF (KODE.EQ.1) YS = AJ + (BJ*XS)
         RETURN
      ELSE
C
         XS = (AJ-AK)/(BK-BJ)
         YS = AJ+(BJ*XS)
C     
      ENDIF
C
C     IS XS,YS IS ON LINE J BETWEEN XJ1,YJ1 & XJ2,YJ2?
C
      CALL SVONLN (XS,YS,XJ1,YJ1,XJ2,YJ2,KODE)
      IF (KODE.EQ.1) THEN
C
C        IS XS,YS IS LINE K BETWEEN XK1,YK1 & XK2,YK2?
C
         CALL SVONLN (XS,YS,XK1,YK1,XK2,YK2,KODE)
         IF (KODE.EQ.1) RETURN
      ENDIF
      XS = 0.
      YS = 0.
      RETURN
      END
