!== last modified  4-9-2002
      SUBROUTINE NUMLOG(OPT,EVOD,LMERCH,MAXLEN,MINLEN,TRIM,
     >           NUMSEG)

C--  THIS SUBROUTINE WILL DETERMINE THE NUMBER OF MERCHANTABLE
C--  SEGMENTS IN A GIVEN MERCHANTABLE LENGTH OF TREE STEM,
C--  ACCORDING TO ONE OF THE DEFINED SEGMENTATION RULES IN
C--  THE VOLUME ESTIMATOR HANDBOOK FSH ???.

C--  THE LOGIC WAS DEVELOPED BY JIM BRICKELL, TCFPM R-1, AND
C--  IMPLEMENTED BY WO-TM.


      INTEGER EVOD, NUMSEG, OPT
      REAL LEFTOV, LMERCH, MAXLEN, MINLEN, TRIM

C--   DETERMINE IF THERE IS A MERCHANTABLE SEGMENT

      NUMSEG = INT(LMERCH/(MAXLEN+TRIM))
      LEFTOV = LMERCH-((MAXLEN+TRIM)*FLOAT(NUMSEG))

      IF (NUMSEG .GT. 0 .OR. LEFTOV .GE. MINLEN) THEN

C--       THERE IS MERCHANTABLE MATERIAL

          IF (OPT .LT. 20) THEN

C--           TOP SEGMENT CAN BE COMBINED - ODD LENGTHS OK
C--             CONSIDER ROUNDING OF TRIM TO NEAREST FOOT

              IF (LEFTOV .GE. (TRIM+0.5))  NUMSEG=NUMSEG+1

          ELSEIF (OPT .EQ. 21 .OR. OPT .EQ. 22) THEN

C--           TOP SEGMENT CAN BE COMBINED - CHECK ON ODD LENGTHS
C--             CONSIDER ROUNDING OF TRIM TO NEAREST FOOT
C--                      OR NEAREST EVEN FOOT

              IF (EVOD .EQ. 1 .AND. LEFTOV .GE. (TRIM+0.5)) THEN
                  NUMSEG=NUMSEG+1
              ENDIF
              IF (EVOD .EQ. 2 .AND. LEFTOV .GE. (TRIM+1.0)) THEN
                  NUMSEG=NUMSEG+1
              ENDIF

C--       TOP SEGMENT WILL BE ON ITS' OWN

          ELSEIF (OPT .EQ. 23) THEN
              IF (LEFTOV .GE. (TRIM+MINLEN)) NUMSEG=NUMSEG+1
          ELSEIF (OPT .EQ. 24) THEN
              IF (LEFTOV .GE. ((MAXLEN+TRIM)/4.0)) NUMSEG=NUMSEG+1
          ENDIF

C--   THERE IS NO MERCHANTABLE MATERIAL

      ELSE
          NUMSEG = 0
      ENDIF

      RETURN
      END

C--  VARIABLES OF INTEREST ARE:

C--  EVOD - INTEGER - EVEN OR ODD LENGTH SEGMENTS ALLOWED
C--         SEGMENTATION OPTIONS 11-14 ALLOW ODD LENGTHS
C--         BY DEFINITION
C--        1 = ODD SEGMENTS ALLOWED
C--        2 = ONLY EVEN SEGMENTS ALLOWED

C--  NUMSEG - INTEGER - THE COMPUTED NUMBER OF SEGMENTS

C--  OPT - INTEGER - SPECIFIED SEGMENTATION OPTION
C--        OPTION CODES ARE AS FOLLOWS:
C--        11 = 16 FT LOG SCALE (FSH 2409.11)
C--        12 = 20 FT LOG SCALE (FSH 2409.11)
C--        13 = 32 FT LOG SCALE
C--        14 = 40 FT LOG SCALE
C--        21 = NOMINAL LOG LENGTH (NLL), IF TOP LESS THAN HALF
C--             OF NLL IT IS COMBINED WITH NEXT LOWEST LOG AND
C--             SEGMENTED ACORDING TO RULES FOR NLL MAX LENGTH.
C--             IF SEGMENT IS HALF OR MORE OF NLL THEN SEGMENT
C--             STANDS ON ITS' OWN.
C--        22 = NOMINAL LOG LENGTH, TOP IS PLACED WITH NEXT LOWEST
C--             LOG AND SEGMENTED ACORDING TO RULES FOR NLL MAX
C--             LENGTH.
C--        23 = NOMINAL LOG LENGTH, TOP SEGMENT STANDS ON ITS' OWN.
C--        24 = NOMINAL LOG LENGTH, TOP SEGMENT LESS THAN 1/4 OF
C--             NLL THEN SEGMENT IS DROPED, IF SEGMENT IS 1/4 TO
C--             3/4 THEN SEGMENT IS = 1/2 OF NNL, IF SEGMENT IS
C--             GREATER THAN 3/4 OF NNL THEN SEGMENT IS = NNL.
C--  LEFTOV - REAL - LEFTOVER OR FRACTIONAL PORTION OF A SEGMENT
C--  LMERCH - REAL - GIVEN MERCHANTABLE LENGTH OF STEM
C--  MAXLEN - REAL - MAXIMUM SEGMENT LENGTH
C--  MINLEN - REAL - MINIMUM SEGMENT LENGTH
C--  TRIM - REAL - TRIM LENGTH FOR EACH SEGMENT
