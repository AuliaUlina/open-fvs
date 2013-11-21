      SUBROUTINE GHEADS(NPLT,MGMID,JOSTND,JOTREE,ITITLE)
      IMPLICIT NONE
C----------
C  $Id$
C----------
C
C     PRINTS HEADINGS. IF I/O UNIT(S) IS/ARE ZERO THE PRINTING
C     OF THE CORRESPONDING HEADING IS SKIPPED.
C
      INTEGER JOSTND,JOTREE,ISTLNB
      CHARACTER*26 NPLT
      CHARACTER*72 ITITLE
      CHARACTER*4 MGMID
C
      IF(JOSTND.EQ.0) GO TO 10
C
C     WRITE HEADING FOR STAND COMPOSITION OUTPUT.
C
      CALL GROHED(JOSTND)
      WRITE (JOSTND,5) NPLT,MGMID,ITITLE(1:MAX(1,ISTLNB(ITITLE)))
    5 FORMAT(/'STAND ID: ',A26,4X,'MGMT ID: ',A4,4X,A/)
      CALL PPLABS (JOSTND)
      WRITE (JOSTND,50)
   50 FORMAT(/T41,
     >'STAND COMPOSITION (BASED ON STOCKABLE AREA)'/
     >122('-')/T29,'PERCENTILE POINTS IN THE'/
     >T22,'DISTRIBUTION OF STAND ATTRIBUTES BY DBH      TOTAL/ACRE'/
     >T9,'STAND',7X,41('-'),6X,'OF STAND',9X,
     >'DISTRIBUTION OF STAND ATTRIBUTES BY'/'YEAR  ATTRIBUTES',
     >6X,'10     30     50     70     90    100',7X,'ATTRIBUTES',7X,
     >'SPECIES AND 3 USER-DEFINED SUBCLASSES'/,4('-'),2X,11('-'),3X,
     >6(6('-'),1X),2X,14('-'),2X,42('-')/T34,'(DBH IN INCHES)')
C
   10 CONTINUE
      IF(JOTREE .EQ. 0) RETURN
C
C     WRITE LABELS FOR EXAMPLE TREE OUTPUT.
C
      CALL GROHED(JOTREE)
      WRITE (JOTREE,5) NPLT,MGMID,ITITLE(1:ISTLNB(ITITLE))
      CALL PPLABS (JOTREE)
      WRITE (JOTREE,80)
   80 FORMAT(
     >/126('-')
     >/T22,'ATTRIBUTES OF SELECTED SAMPLE TREES',16X,
     >' ADDITIONAL STAND ATTRIBUTES (BASED ON STOCKABLE AREA)'/
     >6X,65('-'),2X,53('-')/6X,'INITIAL',
     >27X,'LIVE   PAST DBH  BASAL   TREES',10X,'QUADRATIC   TREES',
     >4X,'BASAL  TOP HEIGHT  CROWN'/6X,'TREES/A',12X,'DBH    HEIGHT',
     >2X,'CROWN   GROWTH   AREA     PER    STAND   MEAN DBH    PER',
     >5X,'AREA     LARGEST   COMP'/'YEAR   %TILE  SPECIES (INCHES)',
     >'  (FEET)  RATIO  (INCHES)  %TILE    ACRE   AGE     (INCHES)',4X,
     >'ACRE   (SQFT/A) 40/A (FT)  FACTOR'/'----',2X,2(7('-'),1X),
     >2(8('-'),1X),6('-'),1X,9('-'),1X,7('-'),1X,6('-'),2X,5('-'),2X,
     >9('-'),3X,6('-'),1X,2(9('-'),1X),7('-'))
C
      RETURN
C
C  CALLED FROM **SITSET** ROUTINES TO WRITE TABLE HEADERS FR THE
C  1) FIAHEAD   - THE SPECIES FIA NUMBER / ALPHA CODE TRANSLATION TABLE
C  2) VOLEQHEAD - VOLUME EQUATION NUMBERS
C
      ENTRY FIAHEAD(JOSTND)
      WRITE(JOSTND,210)
 210  FORMAT(/T12,'ALPHA SPECIES - FIA CODE CROSS REFERENCE:')
      RETURN
C
      ENTRY VOLEQHEAD(JOSTND)
      WRITE(JOSTND,220)
  220 FORMAT(/T35,'NATIONAL VOLUME ESTIMATOR LIBRARY EQUATION NUMBERS',
     &/,4('SPECIES CUBIC FOOT BOARD FOOT ')/
C     & 4('          EQ. NO.    EQ. NO.  ')/
     &  4('------- ---------- ---------- '))
C
      RETURN
      END
