      SUBROUTINE FORKOD
      IMPLICIT NONE
C----------
C  **FORKOD--KT DATE OF LAST REVISION:  04/03/08
C----------
C
C     TRANSLATES FOREST CODE INTO A SUBSCRIPT, IFOR, AND IF
C     KODFOR IS ZERO, THE ROUTINE RETURNS THE DEFAULT CODE.
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
      INCLUDE 'KOTCOM.F77'
C
C
COMMONS
C
C----------
C  NATIONAL FORESTS:
C  103 = BITTERROOT
C  104 = IDAHO PANHANDLE
C  105 = CLEARWATER
C  106 = COEUR D'ALENE  
C  621 = COLVILLE
C  110 = FLATHEAD
C  113 = KANIKSU
C  114 = KOOTENAI
C  116 = LOLO
C  117 = NEZPERCE
C  118 = ST. JOE
C  613 = KANIKSU ADMINISTERED BY COLVILLE (MAPPED TO KANIKSU 113)
C----------
      INTEGER JFOR(12),KFOR(12),NUMFOR,I,IFORDI,INTER,IFORE,IDIST,ICOMP
      DATA JFOR/103,104,105,106,621,110,113,114,116,117,118,613 /,
     >          NUMFOR /12/
      DATA KFOR/1,1,3,2,1,1,1,1,1,3,2,1 /
C
      IF (KODFOR .EQ. 0) GOTO 30
      DO 10 I=1,NUMFOR
      IFORDI=KODFOR/100000
      IF (IFORDI .EQ. JFOR(I)) GOTO 20
   10 CONTINUE
      CALL ERRGRO (.TRUE.,3)
      WRITE(JOSTND,200) JFOR(IFOR)
 200  FORMAT(T13,'FOREST CODE USED FOR THIS PROJECTION IS',I4)
      GOTO 30
   20 CONTINUE
      IF(I .EQ. 12)THEN
        WRITE(JOSTND,21)
   21   FORMAT(T13,'KANIKSU NF (613) BEING MAPPED TO ',
     &  'KANIKSU (113) FOR FURTHER PROCESSING.')
        I=7
      ENDIF
      IFOR=I
      IGL=KFOR(I)
   30 CONTINUE
C----------
C  SET DEFAULT KOTFOR TO 8 TO AVOID BLOWUPS IN REGENT & DGF
C  GED 8-29-96.
C----------
      KOTFOR=8
C----------
C  THIS NEXT SECTION TRANSLATES THE FOREST CODES INTO LOCATION
C  CODES FOR THE KOOTENAI VARIANT.
C----------
      INTER = KODFOR - 10000000
      IF(INTER .LT. 0) INTER =0
      IFORE = INTER/100000
      IDIST = INTER/1000
      ICOMP = INTER-IDIST*1000
        IF(IFORE .EQ. 10 .OR. IFORE .EQ. 0) KOTFOR=8
        IF(IFORE .EQ. 14) KOTFOR=7
        IF(IDIST .EQ. 1402) KOTFOR=2
        IF(IDIST .EQ. 1403) KOTFOR=3
        IF(IDIST .EQ.  406) KOTFOR=7
        IF(IDIST .EQ. 1404 .OR. IDIST .EQ. 407) KOTFOR=4
        IF(IDIST .EQ. 1401) THEN
           IF(ICOMP .GE. 16 .AND. ICOMP .LE. 27) THEN
             KOTFOR = 1
           ELSE
             KOTFOR = 2
           ENDIF
        ENDIF
        IF(IDIST .EQ. 1405) THEN
           IF((ICOMP .GE. 1 .AND. ICOMP .LE. 4) .OR. (ICOMP .GE. 8
     &         .AND. ICOMP .LE. 19) .OR. (ICOMP .EQ. 27)) THEN
             KOTFOR = 5
           ELSE
             KOTFOR = 10
           ENDIF
        ENDIF
        IF(IDIST .EQ. 1406) THEN
           IF(ICOMP .GE. 1 .AND. ICOMP .LE. 4) THEN
             KOTFOR = 6
           ELSE
             KOTFOR = 9
           ENDIF
         ENDIF
      KOTNUM=KODFOR
      KODFOR=JFOR(IFOR)
      RETURN
      END