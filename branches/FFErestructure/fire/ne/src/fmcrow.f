      SUBROUTINE FMCROW
      IMPLICIT NONE
C----------
C  **FMCROW  FIRE-NE DATE OF LAST REVISION:  01/10/12
C----------
C     CALLED FROM: FMSDIT, FMPRUN
C     CALLS:
C                 
C  PURPOSE:
C     THIS SUBROUTINE CALCULATES CROWNW(TREE,SIZE), THE WEIGHT OF
C     VARIOUS SIZES OF CROWN MATERIAL THAT IS ASSOCIATED WITH EACH TREE
C     RECORD IN THE CURRENT STAND.  
C----------
C  LOCAL VARIABLE DEFINITIONS:
C     D:        DBH
C     H:        HEIGHT
C     IC:       LENGTH OF LIVE CROWN
C     SP:       SPECIES
C----------
COMMONS
C
C
      INCLUDE 'PRGPRM.F77'
C
C      
      INCLUDE 'FMPARM.F77'
C
C
      INCLUDE 'FMCOM.F77'
C
C      
      INCLUDE 'CONTRL.F77'
C
C      
      INCLUDE 'ARRAYS.F77'
C
C
COMMONS
C----------
C  VARIABLE DECLARATIONS
C----------
      LOGICAL DEBUG
      INTEGER I,J,IC,ISPMAP(MAXSP),SPI
      REAL    D,H,SG,XV(0:5)
C----------
C  INDEX TO THE CROWN EQUATIONS USED.  THE SPECIES NUMBERS ARE THOSE
C  LISTED IN FMCROWE.F.  MAPPING IS DONE WHERE NECESSARY.  NOTE: MANY
C  SPECIES ARE MAPPED TO COMMERCIAL HARDWOODS SO THAT THE "MIXED HARDWOOD"
C  EQUATIONS IN JENKINS ET. AL. ARE USED.
C----------
      DATA ISPMAP / 8,10, 6, 9, 7, 9, 9, 3, 5, 3,
     >              3,11,11,14,14,12,12, 3, 3, 3,
     >              3, 3, 3, 3, 3,19,26,27,18,24,
     >             24,24,43,24,39,38,39,39,39,28,
     >             29,29,15,16,16,44,44,44,41,42,
     >             17,40,17,20,30,32,33,30,30,34,
     >             34,34,36,30,30,30,34,34,35,34,
     >             44,44,44,24,55,44,44,45,46,44,
     >             44,44,58,59,59,44,44,60,34,48,
     >             65,67,25,25,21,21,22,49,50,51,
     >             44,44,53,56,57,47,63,61/
C
C----------
C  CHECK FOR DEBUG
C----------
      CALL DBCHK (DEBUG,'FMCROW',6,ICYC)
      IF (DEBUG) WRITE(JOSTND,7) ICYC,ITRN
    7 FORMAT(' ENTERING FMCROW CYCLE = ',I2,' ITRN=',I5)
C
      IF (ITRN.EQ.0) RETURN
C
      DO 999 I = 1,ITRN
C----------
C  INCREMENT GROW TO KEEP TRACK OF WHETHER THIS CROWN IS FREE
C  TO GROW AFTER BEING BURNED IN A FIRE.  SKIP THE REST OF THE LOOP
C  IF GROW IS STILL LESS THAN 1 AFTER THE INCREMENT.
C----------
        IF (GROW(I) .LT. 1) GROW(I) = GROW(I) + 1
        IF (GROW(I) .LT. 1) GOTO 999
C----------        
C  ARGUMENTS TO PASS
C----------
	      SPI = ISPMAP(ISP(I))
        D   = DBH(I)
        H   = HT(I)
        IC  = ICR(I)
	      SG  = V2T(ISP(I))
        IF (DEBUG) WRITE(JOSTND,8) ISP(I),SPI
    8   FORMAT(' FMCROW ISP(I) = ',I2,' SPI=',I5)
C----------
C  INITIALIZE ALL THE CANOPY COMPONENTS TO ZERO, AND SKIP THE REST
C  OF THIS LOOP IF THE TREE HAS NO DIAMETER, HEIGHT, OR LIVE CROWN.
C----------
        DO J = 0,5
	        XV(J) = 0.0
        ENDDO
C
        CALL FMCROWE(SPI,ISP(I),D,H,IC,SG,XV)
C----------
C  COPY TEMPORARY VALUES TO FFE ARRAY
C----------
        DO J = 0,5
          CROWNW(I,J) = XV(J)
        ENDDO
C
      IF (DEBUG) WRITE(JOSTND,9) D,CROWNW(I,0),CROWNW(I,1), 
     >  CROWNW(I,2),CROWNW(I,3),CROWNW(I,4),CROWNW(I,5)
    9 FORMAT(' FMCROW DBH = ',F5.1,' CROWNW=',6F10.4)
      IF (DEBUG) WRITE(JOSTND,10) (CROWNW(I,0)+ CROWNW(I,1) +  
     >  CROWNW(I,2) + CROWNW(I,3) + CROWNW(I,4) + CROWNW(I,5))
   10 FORMAT(' FMCROW SUM OF CROWNW=',F10.4)

C
  999 CONTINUE
C
      RETURN
      END