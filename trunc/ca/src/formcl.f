      SUBROUTINE FORMCL(ISPC,IFOR,D,FC)
      IMPLICIT NONE
C----------
C  **FORMCL--CA     DATE OF LAST REVISION:  02/22/08
C----------
C
C THIS PROGRAM CALCULATES FORM FACTORS FOR CALCULATING CUBIC AND
C BOARD FOOT VOLUMES.
C
COMMONS
C
C
      INCLUDE 'PRGPRM.F77'
C
C
      INCLUDE 'CONTRL.F77'
C
C
COMMONS
C
C----------
      REAL ROGRFC(MAXSP,5),SISKFC(MAXSP,5),FC,D
      INTEGER IFOR,ISPC,IFCDBH
C----------
C  FOREST ORDER: (IFOR)
C  6=ROGUE RIVER(610)      7=SISKIYOU(611)
C
C
C  SPECIES ORDER:
C  1=PC  2=IC  3=RC  4=WF  5=RF  6=SH  7=DF  8=WH  9=MH 10=WB
C 11=KP 12=LP 13=CP 14=LM 15=JP 16=SP 17=WP 18=PP 19=MP 20=GP
C 21=JU 22=BR 23=GS 24=PY 25=OS 26=LO 27=CY 28=BL 29=EO 30=WO
C 31=BO 32=VO 33=IO 34=BM 35=BU 36=RA 37=MA 38=GC 39=DG 40=FL
C 41=WN 42=TO 43=SY 44=AS 45=CW 46=WI 47=CN 48=CL 49=OH
C----------
C  ROGUE RIVER FORM CLASS VALUES
C----------
      DATA ROGRFC/
     & 70., 69., 70., 78., 70., 77., 77., 74., 71., 75.,
     & 70., 70., 70., 70., 76., 77., 77., 76., 70., 70.,
     & 70., 76., 70., 72., 70., 70., 69., 70., 70., 66.,
     & 72., 70., 70., 72., 70., 72., 70., 70., 69., 72.,
     & 70., 72., 70., 72., 72., 72., 70., 70., 70., 
C
     & 70., 69., 70., 78., 70., 77., 77., 74., 71., 75.,
     & 70., 70., 70., 70., 72., 77., 77., 76., 70., 70.,
     & 70., 76., 70., 72., 70., 70., 69., 70., 70., 66.,
     & 72., 70., 70., 72., 70., 72., 70., 70., 69., 72.,
     & 70., 72., 70., 72., 72., 72., 70., 70., 70., 
C
     & 70., 67., 70., 77., 70., 75., 75., 72., 70., 73.,
     & 68., 68., 70., 70., 70., 75., 75., 74., 70., 70.,
     & 70., 74., 70., 72., 70., 70., 69., 70., 70., 66.,
     & 72., 70., 70., 72., 70., 72., 70., 70., 69., 72.,
     & 70., 72., 70., 72., 72., 72., 70., 70., 70.,
C
     & 70., 65., 70., 75., 70., 73., 74., 70., 68., 72.,
     & 66., 66., 70., 70., 68., 73., 73., 71., 70., 70.,
     & 70., 73., 70., 72., 70., 70., 69., 70., 70., 66.,
     & 72., 70., 70., 72., 70., 72., 70., 70., 69., 72.,
     & 70., 72., 70., 72., 72., 72., 70., 70., 70.,
C
     & 70., 63., 70., 71., 70., 71., 71., 69., 66., 71.,
     & 66., 66., 70., 70., 66., 70., 72., 69., 70., 70.,
     & 70., 72., 70., 72., 70., 70., 69., 70., 70., 66.,
     & 72., 70., 70., 72., 70., 72., 70., 70., 69., 72.,
     & 70., 72., 70., 72., 72., 72., 70., 70., 70./
C----------
C  SISKIYOU FORM CLASS VALUES
C----------
      DATA SISKFC/
     & 77., 66., 71., 80., 75., 82., 76., 84., 76., 74.,
     & 78., 78., 74., 74., 76., 78., 78., 76., 74., 74.,
     & 74., 76., 74., 65., 74., 70., 70., 70., 70., 70.,
     & 72., 70., 70., 72., 70., 74., 72., 70., 72., 72.,
     & 70., 74., 70., 70., 75., 75., 70., 70., 70., 
C
     & 77., 70., 71., 80., 75., 82., 76., 84., 76., 74.,
     & 78., 78., 74., 74., 72., 78., 78., 76., 74., 74.,
     & 74., 76., 74., 65., 74., 70., 70., 70., 70., 70.,
     & 72., 70., 70., 72., 70., 74., 72., 70., 72., 72.,
     & 70., 74., 70., 70., 75., 75., 70., 70., 70., 
C
     & 75., 70., 71., 78., 75., 80., 74., 82., 73., 74.,
     & 78., 78., 74., 74., 72., 78., 78., 76., 74., 74.,
     & 74., 76., 74., 65., 74., 70., 70., 70., 70., 70.,
     & 72., 70., 70., 72., 70., 74., 72., 70., 72., 72.,
     & 70., 74., 70., 70., 75., 75., 70., 70., 70.,
C
     & 71., 68., 69., 76., 74., 78., 74., 80., 72., 72.,
     & 76., 74., 72., 72., 68., 75., 74., 74., 72., 72.,
     & 72., 74., 72., 65., 72., 70., 70., 70., 70., 70.,
     & 72., 70., 70., 72., 70., 74., 72., 70., 72., 72.,
     & 70., 74., 70., 70., 72., 72., 70., 70., 70.,
C
     & 70., 66., 68., 75., 74., 76., 72., 78., 70., 72.,
     & 72., 74., 72., 72., 68., 74., 73., 72., 72., 72.,
     & 72., 72., 72., 65., 72., 70., 70., 70., 70., 70.,
     & 72., 70., 70., 72., 70., 74., 72., 70., 72., 72.,
     & 70., 74., 70., 70., 72., 72., 70., 70., 70./
C----------
C  FOR REGION 6 FORESTS, LOAD THE FORM CLASS USING TABLE VALUES.
C  IF A FORM CLASS HAS BEEN ENTERED VIA KEYWORD, USE IT INSTEAD.
C----------
      IF(FRMCLS(ISPC).LE.0.) THEN
        IFCDBH = (D - 1.0) / 10.0 + 1.0
        IF(IFCDBH .LT. 1) IFCDBH=1
        IF(D.GT.40.9) IFCDBH=5
        IF(IFOR.EQ.6) THEN
          FC = ROGRFC(ISPC,IFCDBH)
        ELSEIF(IFOR.EQ.7) THEN
          FC = SISKFC(ISPC,IFCDBH)
        ELSE
          FC = 80.
        ENDIF
      ELSE
        FC=FRMCLS(ISPC)
      ENDIF
C
      RETURN
      END
