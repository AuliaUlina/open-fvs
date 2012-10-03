      SUBROUTINE RDTRES (IRNTRE,IRTP1)
C----------
C  **RDTRES      LAST REVISION:  11/20/89
C----------
C
C  ROUTINE THAT RETURNS THE NUMBER OF TREE RECORDS THAT WILL
C  BE PERMITTED FOR THE ROOT DISEASE MODEL.  THIS VALUE FOR
C  NUMBER OF TREES IS THE NUMBER THAT IS CONTAINED IN THE ROUTINE
C  ANPARM AS A PARAMETER VALUE.  THIS ROUTINE IS CALLED FROM INTREE
C  TO ESTABLISH THE MAXIMUM NUMBER OF TREE RECORDS TO BE READ.
C
C  CALLED BY :
C     INTREE  [PROGNOSIS]
C
C  CALLS     :
C     NONE
C
C  PARAMETERS :
C     IRNTRE -
C     IRTP1  -
C
COMMONS
C
C
      INCLUDE 'RDPARM.F77'
C
C
COMMONS
C
      IRNTRE = IRRTRE
      IRTP1  = IRRTP1

      RETURN
      END