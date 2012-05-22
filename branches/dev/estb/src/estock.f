      SUBROUTINE ESTOCK (ELEV,IFO,XBAA,XBAALN,PN)
      IMPLICIT NONE
C----------
C  **ESTOCK--ESTB   DATE OF LAST REVISION:   07/25/08
C----------
C
C     CALCULATES PROBABILITY OF STOCKING FOR REGENERATION MODEL.
C     COEFFICIENTS FOR PLANTING ARE NOT INCLUDED IN EQUATIONS.
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
COMMONS
C
      REAL SHAB(16),SPRE(3,4),FORDF(20),FORGF(20),SSER(5)
      REAL PN,XBAALN,XBAA,ELEV,SQSLO,SQSQ
      INTEGER IFO,IEQ
C
      DATA SHAB/1.14975,0.070196,-.115832,0.0,.539949,-.060377,
     &    0.0, -.178929,  0.0, 0.356001, .278596,.181755,0.0,
     &    -0.764070, 0.403826, -0.837748/,
     &  SSER/0.0, 0.5976365, 1.3547862, 1.5073566, 1.1695859/
C
C     COEFFICIENTS FOR SITE PREP BY HABITAT TYPE SERIES
C     SITE PREP--> NONE     MECH     BURN
C
      DATA SPRE/  0.0,  -0.180267,  -0.485674,
     &            0.0,  -0.161450,  -0.189325,
     &            0.0,  -0.185464,  -0.346349,
     &            0.0,   0.068146,  -0.342800/
      DATA FORDF/2*0.0,1.077081, 5*0.0, 4*.730596, 3*0.0,1.077081,
     &    2*0.0,.286133,.805539/,  FORGF/4*0.0, -.482030,11*0.0,
     &    -.415825, 0.0,2*-1.087558/
      IEQ=1
      IF(IHAB.GT.4.AND.IHAB.LT.9) IEQ=2
      IF(IHAB.EQ.9.OR.IHAB.EQ.10) IEQ=3
      IF(IHAB.GT.10) IEQ=4
      IF(IPREP.GT.3) GO TO 100
      SQSLO=SQRT(SLO)
      SQSQ=SQSLO*SQRT(TIME)
      GO TO (20,40,60,80),IEQ
   20 CONTINUE
C
C     P(STOCKING) DOUGLAS-FIR SERIES
C
      PN= -0.829879 +SHAB(IHAB) +.074061*XCOSAS*SQSQ
     &  -.067207*XSINAS*SQSQ -.021187*SQSQ
     &  +SPRE(IPREP,1) -.027058*ELEV +.213680*SQREGT
     &  +.129135*SQBWAF +FORDF(IFO)
      GO TO 200
   40 CONTINUE
C
C     P(STOCKING) GRAND FIR SERIES.
C
      PN= -2.444807 +.392834*XCOSAS*SQSQ +SHAB(IHAB)
     &  +.117465*XSINAS*SQSQ -.316824*SQSQ
     &  +SPRE(IPREP,2) +FORGF(IFO) +.013726*XBAA
     &  -.0000822*XBAA*XBAA +.076197*ELEV -.000839*ELEVSQ
     &  +.555074*SQRT(TIME) -.013542*XCOSAS*SLO*XBAA
     &  -.013486*XSINAS*SLO*XBAA
      GO TO 200
   60 CONTINUE
C
C     P(STOCKING) CEDAR AND HEMLOCK SERIES.      4/28/89
C
      PN= -6.216694 +SHAB(IHAB) +.587967*XCOSAS*SQSQ
     &  +.007416*XSINAS*SQSQ +.152539*SQSQ
     &  +SPRE(IPREP,3) +.007953*XBAA -.0000373*XBAA*XBAA
     &  +.288594*ELEV -.003952*ELEVSQ +.514807*SQREGT
     &  +.449858*SQBWAF -.017901*XCOSAS*SLO*XBAA
     &  -.006001*XSINAS*SLO*XBAA
      GO TO 200
   80 CONTINUE
C
C     P(STOCKING) SUBALPINE FIR SERIES.
C
      PN= -0.430349 +SHAB(IHAB) +.246248*XCOSAS*SQSQ
     &  -.019381*XSINAS*SQSQ -.099968*SQSQ
     &  +SPRE(IPREP,4) +.136777*XBAALN +.239137*SQREGT
     &  -.111587*BWB4 +.224696*SQBWAF
      GO TO 200
  100 CONTINUE
C
C     P(STOCKING) ALL ROADS.  12/02/86
C
      IF(IHAB.GT.9) IEQ=IEQ+1
      PN= -2.1072788 +SSER(IEQ) +0.0111295*XBAA +0.4206679*SQREGT
     &  -0.3558347*BWB4 +0.1871430*SQBWAF
  200 CONTINUE
      RETURN
      END
