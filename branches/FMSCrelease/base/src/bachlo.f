      FUNCTION  BACHLO( XBAR, STDEV, RANGEN )
      IMPLICIT NONE
C----------
C  $Id$
C----------
C  THIS FUNCTION RETURNS A RANDOM NUMBER DRAWN FROM THE
C  NORMAL DISTRIBUTION DESCRIBED BY (XBAR,STDEV).  THIS FUNCTION
C  UTILIZES THE COMPOSITE REJECTION TECHNIQUE DEVELOPED BY
C  BATCHELOR AND DESCRIBED IN:
C
C      TOCHER, K.D.  1963. THE ART OF SIMULATION. D. VAN NOSTRAND
C                    COMPANY, INC. PRINCETON, NJ. 184 P. (PP 24/27).
C
C  DEFINITION OF VARIABLES.
C
C    BACHLO -- GENERATED NORMAL RANDOM VARIABLE.
C    RANGEN -- SUBROUTINE THAT GENERATES UNIFORM RANDOM NUMBERS; 
C              ACTUAL NAME IS PASSED FROM CALLING ROUTINE.
C      XBAR -- MEAN OF THE NORMAL DISTRIBUTION FROM WHICH BACHLO
C              IS DRAWN.
C     STDEV -- STANDARD DEVIATION OF THE NORMAL DISTRIBUTION FROM
C              WHICH BACHLO IS DRAWN.
C
C  DEFINITION OF INTERNAL VARIABLES.
C
C         X -- COMPUTED ORDINAL OF THE STANDARDIZED NORMAL
C              DISTRIBUTION FUNCTION.
C         U -- UNIFORM RANDOM NUMBER DRAWN TO REPRESENT THE INTEGRAL
C              OF THE STANDARDIZED NORMAL PDF EVALUATED FROM -X TO
C              X.  IF U IS LESS THAN 2/3, X IS APPROXIMATED FROM A
C              UNIFORM DISTRIBUTION.  OTHERWISE, X IS APPROXIMATED
C              FROM A NEGATIVE EXPONENTIAL DISTRIBUTION.
C         Z -- VALUE COMPUTED ASSUMING X IS EXPONENTIALLY
C              DISTRIBUTED.
C         Y -- EXPONENTIALLY DISTRIBUTED RANDOM VARIATE.  IF Y IS
C              LESS THAN OR EQUAL TO Z, X IS REJECTED AND REDRAWN.
C        R1 -- UNIFORM RANDOM NUMBER DRAWN TO GENERATE Y.
C        R2 -- UNIFORM RANDOM NUMBER DRAWN TO ASSIGN A SIGN TO X.
C----------
C
      REAL STDEV,XBAR,BACHLO,U,R1,R2,Z,X,Y
C
   10 CONTINUE
C----------
C  IF THE STD DEV IS ZERO, RETURN THE MEAN.
C----------
      IF (STDEV.LE.0.) THEN
         BACHLO = XBAR
         RETURN
      ENDIF
C----------
C  DRAW THREE UNIFORM RANDOM NUMBERS;  U, R1, AND R2.
C----------
      CALL RANGEN(U)
      CALL RANGEN(R1)
      CALL RANGEN(R2)
C----------
C  DETERMINE METHOD OF APPROXIMATION.
C----------
      IF(U.LE.(2./3.)) GO TO 20
C----------
C  CALCULATE X AND Z ASSUMING A NEGATIVE EXPONENTIAL DISTRIBUTION.
C----------
      Z=3.0*U-2.0
      IF (Z.LT. 0.001) GOTO 10
      X=1.0-0.5*ALOG(Z)
      Z=0.5*(X-2.0)**2
      GO TO 30
C----------
C  CALCULATE X AND Z ASSUMING A UNIFORM DISTRIBUTION.
C----------
   20 X=1.5*U
      Z=0.5*X*X
C----------
C  DRAW REJECTION PARAMETER FROM AN EXPONENTIAL DISTRIBUTION AND
C  DETERMINE IF REJECTION IS NECESSARY.
C----------
   30 Y=-ALOG(R1)
      IF(Y.LE.Z) GO TO 10
C----------
C      SELECT THE SIGN OF X
C----------
      IF (R2 .GE. 0.5) X = -X
C----------
C  SCALE STANDARDIZED NORMAL RANDOM VARIATE FOR INPUT MEAN AND
C  STANDARD DEVIATION AND RETURN IT AS BACHLO.
C----------
      BACHLO= X * STDEV + XBAR
      RETURN
      END
