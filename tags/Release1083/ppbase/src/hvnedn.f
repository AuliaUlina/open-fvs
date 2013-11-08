      SUBROUTINE HVNEDN
      IMPLICIT NONE
C----------
C  **HVNEDN--   DATE OF LAST REVISION:  07/31/08
C----------
C
C     COMPUTE THE AMOUNT OF DENSITY NEIGHBORING STANDS "PROJECT"
C     ONTO THE CURRENT STAND.  CALLED WITHIN A DO OVER STAND
C     LOOP.
C
C     **** THIS ROUTINE IS A PROTOTYPE ***************************
C     **** THIS CODE ASSUMES THAT THERE ARE NO REPLICATIONS
C     **** OF STANDS OTHER THAN THOSE ASSOCIATED WITH THIS STAND'S
C     **** GROUP SELECTION SIMULATION.
C
C     PART OF THE PARALLEL PROCESSING EXTENSION OF PROGNOSIS SYSTEM.
C     N.L. CROOKSTON--FORESTRY SCIENCES LAB, MOSCOW, ID--NOV 1992
C
COMMONS
C
C
      INCLUDE 'PRGPRM.F77'
C
C
      INCLUDE 'PPEPRM.F77'
C
C
      INCLUDE 'PLOT.F77'
C
C
      INCLUDE 'PPHVCM.F77'
C
C
      INCLUDE 'PPEXCM.F77'
C
C
      INCLUDE 'PPCNTL.F77'
C
C
      INCLUDE 'HVDNCM.F77'
C
C
      INCLUDE 'PPDNCM.F77'
C
C
COMMONS
C
C     SET DIRNEI, THE DIRECTION THE NEIGHBOR IS FROM THE REFERENCE
C     STAND.  DIRNEI WOULD NORMALLY BE:
C     DIRNEI/ 0, 60, 120, 180, 240, 300/, HOWEVER, IN THE FORMULA THAT
C     USES DIRNEI, 180 DEGREES IS ADDED TO EACH ELEMENT, YIELDING:
C     DIRNEI/180, 240, 300, 360, 420, 480/, AND THEN THE COS IS TAKEN
C     YIELDING (AFTER CONVERSION TO RADIANS), WE HAVE THE FOLLOWING:
C
      REAL DIRNEI(6),XMN,XMX,B,P,R,S,XXBA,XXCCF,XXWH,EFF
      INTEGER NEI,NEIPTR
      DATA DIRNEI/ -1.0, -0.5, 0.5, 1.0, 0.5, -0.5/
C
C     IF THE DENSITY EFFECTS ARE NOT BEING INCLUDED IN THIS
C     SUMULATION, THEN SET LOCAL EFFECTS FLAG TO FALSE AND RETURN.
C
      LNEDNS=.FALSE.
      IF (.NOT.LNEDNG) RETURN
C
C     COMPUTE THE SLOPE/ASPECT INTERACTION TERM.
C
      XMN=0.4*SLOPE
      XMX=0.6+XMN
      XMN=0.6-XMN
      B=(XMX-XMN)*.5
      P=(XMN+B)+(B*COS(ASPECT))
      B=(P-0.2)*.5
C
C     COMPUTE THE HEXAGON SIZE TERM AND RADIUS, GIVEN THE
C     HXSIZE IS SET IN COMMON IN ACRES.
C
      R=SQRT(13865.58*HXSIZE)
      S=EXP(-(0.3*HXSIZE)**3)
C
C     ENTER A DO OVER NEIGHBORS LOOP.
C
      PDCCFN=0.0
      PDBAN =0.0
      DO 30 NEI=1,6
C
C     FIND THE INDEX TO THE NEIGHBORING HEXAGON.
C
      CALL HXINDX (NEIPTR,NEI,ISTND,NOSTND)
C
C     COMPUTE THE EFFECTIVNESS OF THE NEIGHBOR.
C
C     ***** THIS CODE ASSUMES THAT THERE ARE NO REPLICATIONS
C     ***** OF STANDS...AND THAT THERE IS ONLY ONE MSPOLICY...
C     ***** AND THAT ALL STANDS APPLY TO THE ONE POLICY.
C
C     LET WH BE THE "WALL HEIGHT".
C
C     IF THE NEIGHBORING HEXAGON DOES NOT EXIST (PERHAPS THE
C     REFERENCE HEXAGON (ISTND) IS IN THE FIRST ROW AND WE
C     ARE LOOKING FOR THE HEXAGON ON THE SOUTH, WHICH DOES NOT
C     EXIST), THEN USE THE AVERAGE BA, CCF, AND WH ("WALL HEIGHT")
C     FOR THE NEIGHBOR.
C
      IF (NEIPTR.EQ.0) THEN
         XXBA =AXXBA
         XXCCF=AXXCCF
         XXWH =AMAX1(0.0, AXXHT-HVDAHT(ISTND,  1))
      ELSE
         XXBA =HVDBA (NEIPTR, 1)
         XXCCF=HVDCCF(NEIPTR, 1)
         XXWH =AMAX1(0.0, HVDAHT(NEIPTR, 1)-
     >                    HVDAHT(ISTND,  1))
      ENDIF
C
C     COMPUTE THE EFFECTIVENESS OF THE NEIGHBOR'S DENSITY
C     0.166667 IS 1/6, WHERE 6 IS THE NUMBER OF "NEIGHBORS".
C
      EFF=((1-10**(-XXWH/R))*S)*
     >    ((0.2+B)+(B*DIRNEI(NEI)))
     >    *0.166667
C
C     COMPUTE PDCCFN AND PDBAN, THE AMOUNT OF ADDITIONAL CCF
C     AND BA THAT "PROJECTS" FROM THE NEIGHBORS ONTO THE STANDS.
C
      PDCCFN=PDCCFN+(EFF*XXCCF)
      PDBAN =PDBAN +(EFF*XXBA )
      LNEDNS=.TRUE.
      IF (LHVDEB) WRITE (JOPPRT,'('' IN HVNEDN, ISTND='',I4,
     >    ''; NEIPTR='',I4,''; XXBA='',F8.2,''; XXCCF='',F8.2,
     >    ''; XXWH='',F8.2,''; EFF='',F8.4)')
     >        ISTND,NEIPTR,XXBA,XXCCF,XXWH,EFF
   30 CONTINUE
      IF (LHVDEB) WRITE (JOPPRT,'('' IN HVNEDN, ISTND='',I4,
     >        ''; PDCCFN='',F8.2,''; PDBAN='',F8.2)')
     >        ISTND,PDCCFN,PDBAN
      RETURN
      END
