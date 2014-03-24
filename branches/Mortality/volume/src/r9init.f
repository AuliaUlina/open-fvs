!== last modified  6-12-2007
C***********************************************************************
C***********************************************************************
      SUBROUTINE R9_MHTS(IFORST,VOLEQ,DBH,HTTOT,SI,BA,HT1PRD,HT2PRD,
     >                   PROD,ERRFLAG)
C***********************************************************************
C CALCULATES THE MERCH HTS BASED ON TOTAL TREE HEIGHT BY FORST AND SPECIES
      CHARACTER*10 VOLEQ
      CHARACTER*2 PROD
      INTEGER SI,BA,VFLAG,ERRFLAG,IFORST
	REAL DBH,HTTOT,HT1PRD,HT2PRD,B(6),BFMIND,DBHMIN,BFTOPD,TOPD
      REAL SAWBOL,ESTSHT,FACTOR,PULBOL,ESTCHT,ESTTHT

      IF(BA.LE.0) BA = 90

      IF(IFORST.EQ.2 .OR. IFORST.EQ.3 .OR. IFORST.EQ.4 .OR. IFORST.EQ.6
     >   .OR. IFORST.EQ.7 .OR. IFORST.EQ.9 .OR. IFORST.EQ.10) THEN
C     LS
        IF(SI.LE.0)SI = 60
	  VFLAG = 1
	ELSEIF (IFORST.EQ.5 .OR. IFORST.EQ.8 .OR. IFORST.EQ.12) THEN
C     CS      
        IF(SI.LE.0)SI = 65
	  VFLAG = 2
	ELSE
C     NE
        IF(SI.LE.0)SI = 55
	  VFLAG = 3
      ENDIF
      CALL R9INIT(VOLEQ,B,VFLAG,ERRFLAG)

      IF(VOLEQ(8:10).LT."300")THEN
         IF(IFORST .EQ. 3) THEN
            DBHMIN = 4.0
            BFMIND = 9.0
	   ELSEIF(IFORST.EQ.5)THEN
            DBHMIN = 4.0
            BFMIND = 9.0
	   ELSE
            DBHMIN = 5.0
            BFMIND = 9.0
	   ENDIF
         BFTOPD = 7.6
         TOPD = 4.0
      ELSE
         IF(IFORST.EQ.4 .OR. IFORST.EQ.10 .OR. IFORST.EQ.13 .OR. 
     >                                     IFORST.EQ.21) THEN
            DBHMIN = 5.0
            BFMIND = 11.0
	   ELSEIF(IFORST.EQ.3)THEN
	      IF(VOLEQ(8:10).EQ."746".OR.VOLEQ(8:10).EQ."741".OR.
     >                               VOLEQ(8:10).EQ."743") THEN
               BFMIND = 11.0
            ELSE	   
               BFMIND = 9.0
	      ENDIF
            DBHMIN = 5.0
         ELSEIF(IFORST.EQ.5)THEN
	      BFMIND = 9.0
	      DBHMIN = 5.0
	   ELSEIF(IFORST.EQ.7)THEN
	      IF(VOLEQ(8:10).EQ."746".OR.VOLEQ(8:10).EQ."741".OR.
     >                               VOLEQ(8:10).EQ."743") THEN
               BFMIND = 9.0
            ELSE	   
               BFMIND = 11.0
	      ENDIF
            DBHMIN = 5.0
	   ELSEIF(IFORST.EQ.20)THEN
	      IF(VOLEQ(8:10).EQ."375") THEN
               BFMIND = 9.0
            ELSE	   
               BFMIND = 11.0
	      ENDIF
            DBHMIN = 8.0
	   ELSEIF(IFORST.EQ.22)THEN
	      IF(VOLEQ(8:10).EQ."375") THEN
               BFMIND = 8.0
            ELSE	   
               BFMIND = 11.0
	      ENDIF
            DBHMIN = 5.0
	   ELSE
            DBHMIN = 6.0
            BFMIND = 11.0
	   ENDIF
         BFTOPD = 9.6
         TOPD = 4.0
      ENDIF
      
C----------
C  COMPUTE ESTIMATED TOTAL TREE HEIGHT.
C----------
      IF(PROD.NE."01" .AND. PROD.NE."02") THEN
        IF(DBH .LT. BFMIND) THEN
	     PROD = "02"
      	ELSE
	      PROD = "01"
      	ENDIF
	ENDIF

      IF(DBH .LT. DBHMIN .OR. ERRFLAG.GT.0) THEN
         HT1PRD=0
         HT2PRD=0
         GO TO 100
      ELSE
         FACTOR = 0.0
         ESTTHT = 4.5+B(1)*(1.0-EXP(-1.0*B(2)*DBH))
     &         **B(3)*SI**B(4)*(1.00001-FACTOR)
     &         **B(5)*BA**B(6)
         
         IF(HTTOT .LE. 0) THEN
	      HTTOT = ESTTHT
	   ENDIF
C----------
C  COMPUTE THE NUMBER OF 8' BOLTS TO SPECIFIED PULPWOOD TOP DIAMETER.
C----------
         FACTOR = TOPD/DBH
         IF(FACTOR .GT. 1.0) FACTOR=1.0
         ESTCHT = 4.5+B(1)*(1.0-EXP(-1.0*B(2)*DBH))
     &         **B(3)*SI**B(4)*(1.00001-FACTOR)
     &         **B(5)*BA**B(6)
         PULBOL=ESTCHT*(HTTOT/ESTTHT)
         HT2PRD=INT(PULBOL/8.333333)
       ENDIF
C----------
C  COMPUTE THE NUMBER OF 8' BOLTS TO A SPECIFIED SAWTIMBER TOP
C  DIAMETER.
C----------
       IF(DBH .LT. BFMIND .OR. PROD.EQ."02") THEN
         HT1PRD=0
         GO TO 100
       ELSE
         FACTOR = BFTOPD/DBH
         IF(FACTOR .GT. 1.0) FACTOR=1.0
         ESTSHT = 4.5+B(1)*(1.0-EXP(-1.0*B(2)*DBH))
     &         **B(3)*SI**B(4)*(1.00001-FACTOR)
     &         **B(5)*BA**B(6)
         SAWBOL=ESTSHT*(HTTOT/ESTTHT)
         HT1PRD=INT(SAWBOL/8.333333)
	   IF(HT1PRD.LE.0 .AND. HT2PRD.GT.1) HT1PRD=1
      ENDIF

  100 CONTINUE
      RETURN
      END


C***********************************************************************
C***********************************************************************
      SUBROUTINE R9INIT(VOLEQ,B,VFLAG,ERRFLAG)
C***********************************************************************

C CREATED  : 11-8-2002

C PURPOSE  : THIS SUBROUTINE SETS VALUES USED TO CALC THE MERCH HT OF A TREE

C*********************************
C       DECLARE VARIBLES         *
C*********************************
      CHARACTER*10 VOLEQ
      CHARACTER*3 SPEC_LIST(149),SPEC
      INTEGER VFLAG,I,ERRFLAG
	REAL B(6)
      REAL LS_B1(149),LS_B2(149),LS_B3(149),LS_B4(149),LS_B5(149)
      REAL CS_B1(149),CS_B2(149),CS_B3(149),CS_B4(149),CS_B5(149)
      REAL NE_B1(149),NE_B2(149),NE_B3(149),NE_B4(149),NE_B5(149)
      REAL LS_B6(149),CS_B6(149),NE_B6(149)

      DATA SPEC_LIST/'012','043','057','068','071','090','091','094',
     >   '095','097','100','105','110','123','125','126','128','129',
     >   '130','131','132','221','241','260','261','290','313','314',
     >   '315','316','317','318','319','330','331','332','341','356',
     >   '371','372','373','374','375','379','391','400','401','402',
     >   '403','404','405','407','408','409','410','421','450','452',
     >   '460','461','462','471','481','490','491','500','521','531',
     >   '540','541','543','544','545','546','552','571','591','601',
     >   '602','611','621','641','650','651','653','654','655','660',
     >   '690','691','693','694','701','711','712','731','741','742',
     >   '743','744','746','760','761','762','763','766','800','802',
     >   '804','806','809','812','813','816','817','822','823','824',
     >   '825','826','827','828','830','831','832','833','834','835',
     >   '836','837','901','920','922','923','931','935','951','952',
     >   '970','971','972','974','975','977','990','991','992','993',
     >   '994'/
C     SET TABLES FOR LS VARIANT
      DATA LS_B1/
     >     14.30400,16.93400,16.93400,16.93400,13.62000,31.95700,
     >     31.95700,31.95700,20.03800,16.93400,16.93400,16.93400,
     >     16.93400,16.93400,36.85100,16.93400,16.93400,16.28100,
     >     16.93400,16.93400,16.93400,16.93400, 8.20790, 5.31170,
     >      5.31170,16.93400, 6.43010, 5.34160, 6.43010, 6.86000,
     >      6.95720, 5.34160, 6.43010, 6.43010, 6.43010, 6.43010,
     >      6.43010, 6.43010, 7.18520, 7.27730, 7.27730, 7.27730,
     >      7.27730, 7.27730, 6.43010, 6.10340, 6.10340, 6.10340,
     >      6.10340, 6.10340, 6.10340, 6.10340, 6.10340, 6.10340,
     >      6.10340, 6.43010, 6.43010, 6.43010, 6.43010, 6.43010,
     >      6.43010, 6.43010, 6.43010, 6.43010, 6.43010, 6.43010,
     >      6.43010, 5.34160, 8.17820, 8.17820,11.29100,11.29100,
     >     11.29100,11.29100, 6.43010, 6.43010, 6.43010, 6.43010,
     >      6.43010, 6.43010, 6.43010, 6.43010, 6.43010, 6.43010,
     >      6.43010, 6.43010, 6.43010, 6.43010, 6.43010, 6.43010,
     >      6.43010, 6.43010, 6.43010, 6.43010, 6.43010, 6.43010,
     >      6.43010,13.62500, 5.53460,13.62500, 6.43010, 6.43010,
     >      6.43010, 6.86000, 6.43010, 6.43010, 9.20780, 9.20780,
     >      9.20780, 6.68440, 3.80110, 6.68440, 6.68440, 6.68440,
     >      6.68440, 9.20780, 9.20780, 6.68440, 9.20780, 9.20780,
     >      9.20780, 9.20780, 3.80110, 6.68440, 6.68440, 6.68440,
     >      6.68440, 9.20780, 9.20780, 3.80110, 6.43010, 6.43010,
     >      6.43010, 6.43010, 6.43010, 6.43010, 6.36280, 6.36280,
     >      8.45800, 8.45800, 8.45800, 8.45800, 8.45800, 8.45800,
     >      8.45800, 8.45800, 8.45800, 6.43010, 6.43010/
      DATA LS_B2/
     >     0.19894,0.12972,0.12972,0.12972,0.24255,0.18511,
     >     0.18511,0.18511,0.18981,0.12972,0.12972,0.12972,
     >     0.12972,0.12972,0.08298,0.12972,0.12972,0.08621,
     >     0.12972,0.12972,0.12972,0.12972,0.19672,0.10357,
     >     0.10357,0.12972,0.23545,0.23044,0.23545,0.27725,
     >     0.26564,0.23044,0.23545,0.23545,0.23545,0.23545,
     >     0.23545,0.23545,0.28384,0.22721,0.22721,0.22721,
     >     0.22721,0.22721,0.23545,0.17368,0.17368,0.17368,
     >     0.17368,0.17368,0.17368,0.17368,0.17368,0.17368,
     >     0.17368,0.23545,0.23545,0.23545,0.23545,0.23545,
     >     0.23545,0.23545,0.23545,0.23545,0.23545,0.23545,
     >     0.23545,0.23044,0.27316,0.27316,0.25250,0.25250,
     >     0.25250,0.25250,0.23545,0.23545,0.23545,0.23545,
     >     0.23545,0.23545,0.23545,0.23545,0.23545,0.23545,
     >     0.23545,0.23545,0.23545,0.23545,0.23545,0.23545,
     >     0.23545,0.23545,0.23545,0.23545,0.23545,0.23545,
     >     0.23545,0.28668,0.22637,0.28668,0.23545,0.23545,
     >     0.23545,0.27725,0.23545,0.23545,0.22208,0.22208,
     >     0.22208,0.19049,0.39213,0.19049,0.19049,0.19049,
     >     0.19049,0.22208,0.22208,0.19049,0.22208,0.22208,
     >     0.22208,0.22208,0.39213,0.19049,0.19049,0.19049,
     >     0.19049,0.22208,0.22208,0.39213,0.23545,0.23545,
     >     0.23545,0.23545,0.23545,0.23545,0.27859,0.27859,
     >     0.27527,0.27527,0.27527,0.27527,0.27527,0.27527,
     >     0.27527,0.27527,0.27527,0.23545,0.23545/
      DATA LS_B3/
     >     1.41950,1.00000,1.00000,1.00000,1.28850,1.70200,
     >     1.70200,1.70200,1.29090,1.00000,1.00000,1.00000,
     >     1.00000,1.00000,1.00000,1.00000,1.00000,1.00000,
     >     1.00000,1.00000,1.00000,1.00000,1.31120,1.00000,
     >     1.00000,1.00000,1.33800,1.15290,1.33800,1.42870,
     >     1.00000,1.15290,1.33800,1.33800,1.33800,1.33800,
     >     1.33800,1.33800,1.44170,1.00000,1.00000,1.00000,
     >     1.00000,1.00000,1.33800,1.00000,1.00000,1.00000,
     >     1.00000,1.00000,1.00000,1.00000,1.00000,1.00000,
     >     1.00000,1.33800,1.33800,1.33800,1.33800,1.33800,
     >     1.33800,1.33800,1.33800,1.33800,1.33800,1.33800,
     >     1.33800,1.15290,1.72500,1.72500,1.54660,1.54660,
     >     1.54660,1.54660,1.33800,1.33800,1.33800,1.33800,
     >     1.33800,1.33800,1.33800,1.33800,1.33800,1.33800,
     >     1.33800,1.33800,1.33800,1.33800,1.33800,1.33800,
     >     1.33800,1.33800,1.33800,1.33800,1.33800,1.33800,
     >     1.33800,1.61240,1.00000,1.61240,1.33800,1.33800,
     >     1.33800,1.42870,1.33800,1.33800,1.00000,1.00000,
     >     1.00000,1.00000,2.90530,1.00000,1.00000,1.00000,
     >     1.00000,1.00000,1.00000,1.00000,1.00000,1.00000,
     >     1.00000,1.00000,2.90530,1.00000,1.00000,1.00000,
     >     1.00000,1.00000,1.00000,2.90530,1.33800,1.33800,
     >     1.33800,1.33800,1.33800,1.33800,1.86770,1.86770,
     >     1.96020,1.96020,1.96020,1.96020,1.96020,1.96020,
     >     1.96020,1.96020,1.96020,1.33800,1.33800/
      DATA LS_B4/
     >     0.23349,0.20854,0.20854,0.20854,0.25831,0.00000,
     >     0.00000,0.00000,0.17836,0.20854,0.20854,0.20854,
     >     0.20854,0.20854,0.00001,0.20854,0.20854,0.16220,
     >     0.20854,0.20854,0.20854,0.20854,0.33978,0.68454,
     >     0.68454,0.20854,0.47370,0.54194,0.47370,0.40115,
     >     0.48660,0.54194,0.47370,0.47370,0.47370,0.47370,
     >     0.47370,0.47370,0.38884,0.41179,0.41179,0.41179,
     >     0.41179,0.41179,0.47370,0.44725,0.44725,0.44725,
     >     0.44725,0.44725,0.44725,0.44725,0.44725,0.44725,
     >     0.44725,0.47370,0.47370,0.47370,0.47370,0.47370,
     >     0.47370,0.47370,0.47370,0.47370,0.47370,0.47370,
     >     0.47370,0.54194,0.38694,0.38694,0.35711,0.35711,
     >     0.35711,0.35711,0.47370,0.47370,0.47370,0.47370,
     >     0.47370,0.47370,0.47370,0.47370,0.47370,0.47370,
     >     0.47370,0.47370,0.47370,0.47370,0.47370,0.47370,
     >     0.47370,0.47370,0.47370,0.47370,0.47370,0.47370,
     >     0.47370,0.30651,0.46918,0.30651,0.47370,0.47370,
     >     0.47370,0.40115,0.47370,0.47370,0.31723,0.31723,
     >     0.31723,0.43972,0.55634,0.43972,0.43972,0.43972,
     >     0.43972,0.31723,0.31723,0.43972,0.31723,0.31723,
     >     0.31723,0.31723,0.55634,0.43972,0.43972,0.43972,
     >     0.43972,0.31723,0.31723,0.55634,0.47370,0.47370,
     >     0.47370,0.47370,0.47370,0.47370,0.49589,0.49589,
     >     0.34894,0.34894,0.34894,0.34894,0.34894,0.34894,
     >     0.34894,0.34894,0.34894,0.47370,0.47370/
      DATA LS_B5/
     >     0.76878,0.77792,0.77792,0.77792,0.68128,0.68967,
     >     0.68967,0.68967,0.57343,0.77792,0.77792,0.77792,
     >     0.77792,0.77792,0.63884,0.77792,0.77792,0.86833,
     >     0.77792,0.77792,0.77792,0.77792,0.76173,0.71410,
     >     0.71410,0.77792,0.73385,0.83440,0.73385,0.85299,
     >     0.76954,0.83440,0.73385,0.73385,0.73385,0.73385,
     >     0.73385,0.73385,0.82157,0.76498,0.76498,0.76498,
     >     0.76498,0.76498,0.73385,1.02370,1.02370,1.02370,
     >     1.02370,1.02370,1.02370,1.02370,1.02370,1.02370,
     >     1.02370,0.73385,0.73385,0.73385,0.73385,0.73385,
     >     0.73385,0.73385,0.73385,0.73385,0.73385,0.73385,
     >     0.73385,0.83440,0.75822,0.75822,0.75060,0.75060,
     >     0.75060,0.75060,0.73385,0.73385,0.73385,0.73385,
     >     0.73385,0.73385,0.73385,0.73385,0.73385,0.73385,
     >     0.73385,0.73385,0.73385,0.73385,0.73385,0.73385,
     >     0.73385,0.73385,0.73385,0.73385,0.73385,0.73385,
     >     0.73385,1.02920,0.72456,1.02920,0.73385,0.73385,
     >     0.73385,0.85299,0.73385,0.73385,0.83560,0.83560,
     >     0.83560,0.82962,0.84317,0.82962,0.82962,0.82962,
     >     0.82962,0.83560,0.83560,0.82962,0.83560,0.83560,
     >     0.83560,0.83560,0.84317,0.82962,0.82962,0.82962,
     >     0.82962,0.83560,0.83560,0.84317,0.73385,0.73385,
     >     0.73385,0.73385,0.73385,0.73385,0.76169,0.76169,
     >     0.89213,0.89213,0.89213,0.89213,0.89213,0.89213,
     >     0.89213,0.89213,0.89213,0.73385,0.73385/
      DATA LS_B6/
     >     0.12399,0.12902,0.12902,0.12902,0.10771,0.16200,
     >     0.16200,0.16200,0.10159,0.12902,0.12902,0.12902,
     >     0.12902,0.12902,0.18231,0.12902,0.12902,0.23316,
     >     0.12902,0.12902,0.12902,0.12902,0.11666,0.00000,
     >     0.00000,0.12902,0.08228,0.06372,0.08228,0.12403,
     >     0.01618,0.06372,0.08228,0.08228,0.08228,0.08228,
     >     0.08228,0.08228,0.11411,0.11046,0.11046,0.11046,
     >     0.11046,0.11046,0.08228,0.14610,0.14610,0.14610,
     >     0.14610,0.14610,0.14610,0.14610,0.14610,0.14610,
     >     0.14610,0.08228,0.08228,0.08228,0.08228,0.08228,
     >     0.08228,0.08228,0.08228,0.08228,0.08228,0.08228,
     >     0.08228,0.06372,0.10847,0.10847,0.06859,0.06859,
     >     0.06859,0.06859,0.08228,0.08228,0.08228,0.08228,
     >     0.08228,0.08228,0.08228,0.08228,0.08228,0.08228,
     >     0.08228,0.08228,0.08228,0.08228,0.08228,0.08228,
     >     0.08228,0.08228,0.08228,0.08228,0.08228,0.08228,
     >     0.08228,0.07460,0.11782,0.07460,0.08228,0.08228,
     >     0.08228,0.12403,0.08228,0.08228,0.13465,0.13465,
     >     0.13465,0.10806,0.09593,0.10806,0.10806,0.10806,
     >     0.10806,0.13465,0.13465,0.10806,0.13465,0.13465,
     >     0.13465,0.13465,0.09593,0.10806,0.10806,0.10806,
     >     0.10806,0.13465,0.13465,0.09593,0.08228,0.08228,
     >     0.08228,0.08228,0.08228,0.08228,0.05841,0.05841,
     >     0.12594,0.12594,0.12594,0.12594,0.12594,0.12594,
     >     0.12594,0.12594,0.12594,0.08228,0.08228/

C     SET TABLES FOR CS VARIANT
      DATA CS_B1/
     >     16.28100, 8.20790, 8.20790, 8.20790,16.28100,16.28100, 
     >     16.28100,16.28100,16.28100,16.28100,16.28100,16.28100, 
     >     16.93400,16.28100,16.28100,16.28100,16.28100,16.28100, 
     >     16.28100,16.93400,16.93400, 6.95720,16.28100,16.28100, 
     >     16.28100,16.28100, 6.86000, 5.34160,13.62000, 6.86000, 
     >      6.86000, 5.34160,13.62000, 6.43010, 6.43010, 6.43010, 
     >     13.62500,13.62000, 6.95720, 6.95720, 6.95720, 6.95720, 
     >      6.95720, 6.95720,13.62000, 6.10340, 6.10340, 6.10340, 
     >      6.10340, 6.10340, 6.10340, 6.10340, 6.10340, 6.10340, 
     >      6.10340, 6.10340, 6.43010, 6.43010, 8.45800, 8.45800, 
     >      8.45800,13.62000,13.62000,13.62000,13.62000,13.62000, 
     >      6.43010, 5.34160, 8.17820, 8.17820,11.29100, 8.17820, 
     >     11.29100,11.29100, 6.43010,13.62000, 6.68440,13.62500, 
     >     13.62500, 6.95720, 6.36280,13.62000,13.62000,13.62000, 
     >     13.62000,13.62000,13.62000,13.62000, 6.86000, 6.86000, 
     >      6.86000, 6.86000,13.62000,13.62000,13.62000, 6.95720, 
     >      6.43010,13.62500, 6.43010,13.62500, 6.43010, 7.27730, 
     >      7.27730, 7.27730, 7.27730, 7.27730, 9.20780, 9.20780, 
     >      9.20780, 3.80110, 6.68440, 6.68440, 9.20780, 6.68440, 
     >      9.20780, 9.20780, 9.20780, 3.80110, 9.20780, 9.20780, 
     >      9.20780, 9.20780, 9.20780, 9.20780, 3.80110, 6.68440, 
     >      9.20780, 3.80110, 3.80110, 3.80110, 6.43010, 6.95720, 
     >      6.95720, 6.43010, 6.43010,13.62000, 6.36280, 6.36280, 
     >      8.45800, 8.45800, 8.45800, 8.45800, 8.45800, 8.45800, 
     >      8.45800, 6.43010, 6.95720,13.62000,13.62000/
      DATA CS_B2/
     >     0.08621,0.19672,0.19672,0.19672,0.08621,0.08621,
     >     0.08621,0.08621,0.08621,0.08621,0.08621,0.08621,
     >     0.12972,0.08621,0.08621,0.08621,0.08621,0.08621,
     >     0.08621,0.12972,0.12972,0.26564,0.08621,0.08621,
     >     0.08621,0.08621,0.27725,0.23044,0.24255,0.27725,
     >     0.27725,0.23044,0.24255,0.23545,0.23545,0.23545,
     >     0.28668,0.24255,0.26564,0.26564,0.26564,0.26564,
     >     0.26564,0.26564,0.24255,0.17368,0.17368,0.17368,
     >     0.17368,0.17368,0.17368,0.17368,0.17368,0.17368,
     >     0.17368,0.17368,0.23545,0.23545,0.27527,0.27527,
     >     0.27527,0.24255,0.24255,0.24255,0.24255,0.24255,
     >     0.23545,0.23044,0.27316,0.27316,0.25250,0.27316,
     >     0.25250,0.25250,0.23545,0.24255,0.19049,0.28668,
     >     0.28668,0.26564,0.27859,0.24255,0.24255,0.24255,
     >     0.24255,0.24255,0.24255,0.24255,0.27725,0.27725,
     >     0.27725,0.27725,0.24255,0.24255,0.24255,0.26564,
     >     0.23545,0.28668,0.23545,0.28668,0.23545,0.22721,
     >     0.22721,0.22721,0.22721,0.22721,0.22208,0.22208,
     >     0.22208,0.39213,0.19049,0.19049,0.22208,0.19049,
     >     0.22208,0.22208,0.22208,0.39213,0.22208,0.22208,
     >     0.22208,0.22208,0.22208,0.22208,0.39213,0.19049,
     >     0.22208,0.39213,0.39213,0.39213,0.23545,0.26564,
     >     0.26564,0.23545,0.23545,0.24255,0.27859,0.27859,
     >     0.27527,0.27527,0.27527,0.27527,0.27527,0.27527,
     >     0.27527,0.23545,0.26564,0.24255,0.24255/
      DATA CS_B3/
     >     1.00000,1.31120,1.31120,1.31120,1.00000,1.00000,
     >     1.00000,1.00000,1.00000,1.00000,1.00000,1.00000,
     >     1.00000,1.00000,1.00000,1.00000,1.00000,1.00000,
     >     1.00000,1.00000,1.00000,1.00000,1.00000,1.00000,
     >     1.00000,1.00000,1.42870,1.15290,1.28850,1.42870,
     >     1.42870,1.15290,1.28850,1.33800,1.33800,1.33800,
     >     1.61240,1.28850,1.00000,1.00000,1.00000,1.00000,
     >     1.00000,1.00000,1.28850,1.00000,1.00000,1.00000,
     >     1.00000,1.00000,1.00000,1.00000,1.00000,1.00000,
     >     1.00000,1.00000,1.33800,1.33800,1.96020,1.96020,
     >     1.96020,1.28850,1.28850,1.28850,1.28850,1.28850,
     >     1.33800,1.15290,1.72500,1.72500,1.54660,1.72500,
     >     1.54660,1.54660,1.33800,1.28850,1.00000,1.61240,
     >     1.61240,1.00000,1.86770,1.28850,1.28850,1.28850,
     >     1.28850,1.28850,1.28850,1.28850,1.42870,1.42870,
     >     1.42870,1.42870,1.28850,1.28850,1.28850,1.00000,
     >     1.33800,1.61240,1.33800,1.61240,1.33800,1.00000,
     >     1.00000,1.00000,1.00000,1.00000,1.00000,1.00000,
     >     1.00000,2.90530,1.00000,1.00000,1.00000,1.00000,
     >     1.00000,1.00000,1.00000,2.90530,1.00000,1.00000,
     >     1.00000,1.00000,1.00000,1.00000,2.90530,1.00000,
     >     1.00000,2.90530,2.90530,2.90530,1.33800,1.00000,
     >     1.00000,1.33800,1.33800,1.28850,1.86770,1.86770,
     >     1.96020,1.96020,1.96020,1.96020,1.96020,1.96020,
     >     1.96020,1.33800,1.00000,1.28850,1.28850/
      DATA CS_B4/
     >     0.16220,0.33978,0.33978,0.33978,0.16220,0.16220,
     >     0.16220,0.16220,0.16220,0.16220,0.16220,0.16220,
     >     0.20854,0.16220,0.16220,0.16220,0.16220,0.16220,
     >     0.16220,0.20854,0.20854,0.48660,0.16220,0.16220,
     >     0.16220,0.16220,0.40115,0.54194,0.25831,0.40115,
     >     0.40115,0.54194,0.25831,0.47370,0.47370,0.47370,
     >     0.30651,0.25831,0.48660,0.48660,0.48660,0.48660,
     >     0.48660,0.48660,0.25831,0.44725,0.44725,0.44725,
     >     0.44725,0.44725,0.44725,0.44725,0.44725,0.44725,
     >     0.44725,0.44725,0.47370,0.47370,0.34894,0.34894,
     >     0.34894,0.25831,0.25831,0.25831,0.25831,0.25831,
     >     0.47370,0.54194,0.38694,0.38694,0.35711,0.38694,
     >     0.35711,0.35711,0.47370,0.25831,0.43972,0.30651,
     >     0.30651,0.48660,0.49589,0.25831,0.25831,0.25831,
     >     0.25831,0.25831,0.25831,0.25831,0.40115,0.40115,
     >     0.40115,0.40115,0.25831,0.25831,0.25831,0.48660,
     >     0.47370,0.30651,0.47370,0.30651,0.47370,0.41179,
     >     0.41179,0.41179,0.41179,0.41179,0.31723,0.31723,
     >     0.31723,0.55634,0.43972,0.43972,0.31723,0.43972,
     >     0.31723,0.31723,0.31723,0.55634,0.31723,0.31723,
     >     0.31723,0.31723,0.31723,0.31723,0.55634,0.43972,
     >     0.31723,0.55634,0.55634,0.55634,0.47370,0.48660,
     >     0.48660,0.47370,0.47370,0.25831,0.49589,0.49589,
     >     0.34894,0.34894,0.34894,0.34894,0.34894,0.34894,
     >     0.34894,0.47370,0.48660,0.25831,0.25831/
      DATA CS_B5/
     >     0.86833,0.76173,0.76173,0.76173,0.86833,0.86833,
     >     0.86833,0.86833,0.86833,0.86833,0.86833,0.86833,
     >     0.77792,0.86833,0.86833,0.86833,0.86833,0.86833,
     >     0.86833,0.77792,0.77792,0.76954,0.86833,0.86833,
     >     0.86833,0.86833,0.85299,0.83440,0.68128,0.85299,
     >     0.85299,0.83440,0.68128,0.73385,0.73385,0.73385,
     >     1.02920,0.68128,0.76954,0.76954,0.76954,0.76954,
     >     0.76954,0.76954,0.68128,1.02370,1.02370,1.02370,
     >     1.02370,1.02370,1.02370,1.02370,1.02370,1.02370,
     >     1.02370,1.02370,0.73385,0.73385,0.89213,0.89213,
     >     0.89213,0.68128,0.68128,0.68128,0.68128,0.68128,
     >     0.73385,0.83440,0.75822,0.75822,0.75060,0.75822,
     >     0.75060,0.75060,0.73385,0.68128,0.82962,1.02920,
     >     1.02920,0.76954,0.76169,0.68128,0.68128,0.68128,
     >     0.68128,0.68128,0.68128,0.68128,0.85299,0.85299,
     >     0.85299,0.85299,0.68128,0.68128,0.68128,0.76954,
     >     0.73385,1.02920,0.73385,1.02920,0.73385,0.76498,
     >     0.76498,0.76498,0.76498,0.76498,0.83560,0.83560,
     >     0.83560,0.84317,0.82962,0.82962,0.83560,0.82962,
     >     0.83560,0.83560,0.83560,0.84317,0.83560,0.83560,
     >     0.83560,0.83560,0.83560,0.83560,0.84317,0.82962,
     >     0.83560,0.84317,0.84317,0.84317,0.73385,0.76954,
     >     0.76954,0.73385,0.73385,0.68128,0.76169,0.76169,
     >     0.89213,0.89213,0.89213,0.89213,0.89213,0.89213,
     >     0.89213,0.73385,0.76954,0.68128,0.68128/
      DATA CS_B6/
     >     0.23316,0.11666,0.11666,0.11666,0.23316,0.23316,
     >     0.23316,0.23316,0.23316,0.23316,0.23316,0.23316,
     >     0.12902,0.23316,0.23316,0.23316,0.23316,0.23316,
     >     0.23316,0.12902,0.12902,0.01618,0.23316,0.23316,
     >     0.23316,0.23316,0.12403,0.06372,0.10771,0.12403,
     >     0.12403,0.06372,0.10771,0.08228,0.08228,0.08228,
     >     0.07460,0.10771,0.01618,0.01618,0.01618,0.01618,
     >     0.01618,0.01618,0.10771,0.14610,0.14610,0.14610,
     >     0.14610,0.14610,0.14610,0.14610,0.14610,0.14610,
     >     0.14610,0.14610,0.08228,0.08228,0.12594,0.12594,
     >     0.12594,0.10771,0.10771,0.10771,0.10771,0.10771,
     >     0.08228,0.06372,0.10847,0.10847,0.06859,0.10847,
     >     0.06859,0.06859,0.08228,0.10771,0.10806,0.07460,
     >     0.07460,0.01618,0.05841,0.10771,0.10771,0.10771,
     >     0.10771,0.10771,0.10771,0.10771,0.12403,0.12403,
     >     0.12403,0.12403,0.10771,0.10771,0.10771,0.01618,
     >     0.08228,0.07460,0.08228,0.07460,0.08228,0.11046,
     >     0.11046,0.11046,0.11046,0.11046,0.13465,0.13465,
     >     0.13465,0.09593,0.10806,0.10806,0.13465,0.10806,
     >     0.13465,0.13465,0.13465,0.09593,0.13465,0.13465,
     >     0.13465,0.13465,0.13465,0.13465,0.09593,0.10806,
     >     0.13465,0.09593,0.09593,0.09593,0.08228,0.01618,
     >     0.01618,0.08228,0.08228,0.10771,0.05841,0.05841,
     >     0.12594,0.12594,0.12594,0.12594,0.12594,0.12594,
     >     0.12594,0.08228,0.01618,0.10771,0.10771/

C     SET TABLES FOR NE VARIANT
      DATA NE_B1/
     >     14.30400, 8.20790, 8.20790, 8.20790,13.62000,31.95700,
     >     31.95700,31.95700,31.95700,31.95700,36.85100,36.85100,
     >     36.85100,36.85100,36.85100,36.85100,36.85100,16.28100,
     >     36.85100,16.28100,16.93400,36.85100, 8.20790, 5.31170,
     >      5.31170,36.85100,13.62500, 5.34160,13.62500, 6.86000,
     >      5.34160, 5.34160,13.62500, 6.68440, 6.68440, 6.68440,
     >     13.62500,13.62500, 7.18520, 7.18520, 7.18520, 6.68440,
     >      7.27730, 7.27730,13.62500, 6.10340, 6.10340, 6.10340,
     >      6.10340, 6.10340, 6.10340, 6.10340, 6.10340, 6.10340,
     >      6.10340, 6.10340, 6.10340, 6.10340, 6.68440, 6.68440,
     >      6.68440,13.62500,13.62500,13.62500,13.62500,13.62500,
     >      6.68440, 9.20780, 8.17820, 8.17820, 8.17820, 8.17820,
     >      8.17820, 8.17820,13.62500,13.62500, 6.68440, 6.68440,
     >      6.68440, 8.17820, 8.17820, 6.68440, 6.68440, 8.17820,
     >      6.68440, 6.68440, 6.68440, 6.68440, 6.68440, 6.68440,
     >      6.68440, 6.68440,13.62500, 6.68440, 6.68440, 6.68440,
     >      6.43010, 6.43010, 6.43010, 6.43010, 6.43010,13.62500,
     >     13.62500, 8.17820, 8.17820, 8.17820, 9.20780, 9.20780,
     >      3.80110, 3.80110, 6.68440, 6.68440, 6.68440, 6.68440,
     >      3.80110, 9.20780, 9.20780, 6.68440, 3.80110, 9.20780,
     >      3.80110, 3.80110, 3.80110, 6.68440, 3.80110, 6.68440,
     >      6.68440, 9.20780, 6.68440, 6.68440, 6.68440, 6.68440,
     >      6.68440, 6.68440, 6.68440,13.62500, 6.68440, 6.68440,
     >      6.68440, 6.68440, 6.68440, 6.68440, 6.68440, 6.68440,
     >      6.68440,13.62500,13.62500,13.62500,13.62500/
      DATA NE_B2/
     >     0.19894,0.19672,0.19672,0.19672,0.24255,0.18511,
     >     0.18511,0.18511,0.18511,0.18511,0.08298,0.08298,
     >     0.08298,0.08298,0.08298,0.08298,0.08298,0.08621,
     >     0.08298,0.08621,0.12972,0.08298,0.19672,0.10357,
     >     0.10357,0.08298,0.28668,0.23044,0.28668,0.27725,
     >     0.23044,0.23044,0.28668,0.19049,0.19049,0.19049,
     >     0.28668,0.28668,0.28384,0.28384,0.28384,0.19049,
     >     0.22721,0.22721,0.28668,0.17368,0.17368,0.17368,
     >     0.17368,0.17368,0.17368,0.17368,0.17368,0.17368,
     >     0.17368,0.17368,0.17368,0.17368,0.19049,0.19049,
     >     0.19049,0.28668,0.28668,0.28668,0.28668,0.28668,
     >     0.19049,0.22208,0.27316,0.27316,0.27316,0.27316,
     >     0.27316,0.27316,0.28668,0.28668,0.19049,0.19049,
     >     0.19049,0.27316,0.27316,0.19049,0.19049,0.27316,
     >     0.19049,0.19049,0.19049,0.19049,0.19049,0.19049,
     >     0.19049,0.19049,0.28668,0.19049,0.19049,0.19049,
     >     0.23545,0.23545,0.23545,0.23545,0.23545,0.28668,
     >     0.28668,0.27316,0.27316,0.27316,0.22208,0.22208,
     >     0.39213,0.39213,0.19049,0.19049,0.19049,0.19049,
     >     0.39213,0.22208,0.22208,0.19049,0.39213,0.22208,
     >     0.39213,0.39213,0.39213,0.19049,0.39213,0.19049,
     >     0.19049,0.22208,0.19049,0.19049,0.19049,0.19049,
     >     0.19049,0.19049,0.19049,0.28668,0.19049,0.19049,
     >     0.19049,0.19049,0.19049,0.19049,0.19049,0.19049,
     >     0.19049,0.28668,0.28668,0.28668,0.28668/
      DATA NE_B3/
     >     1.41950,1.31120,1.31120,1.31120,1.28850,1.70200,
     >     1.70200,1.70200,1.70200,1.70200,1.00000,1.00000,
     >     1.00000,1.00000,1.00000,1.00000,1.00000,1.00000,
     >     1.00000,1.00000,1.00000,1.00000,1.31120,1.00000,
     >     1.00000,1.00000,1.61240,1.15290,1.61240,1.42870,
     >     1.15290,1.15290,1.61240,1.00000,1.00000,1.00000,
     >     1.61240,1.61240,1.44170,1.44170,1.44170,1.00000,
     >     1.00000,1.00000,1.61240,1.00000,1.00000,1.00000,
     >     1.00000,1.00000,1.00000,1.00000,1.00000,1.00000,
     >     1.00000,1.00000,1.00000,1.00000,1.00000,1.00000,
     >     1.00000,1.61240,1.61240,1.61240,1.61240,1.61240,
     >     1.00000,1.00000,1.72500,1.72500,1.72500,1.72500,
     >     1.72500,1.72500,1.61240,1.61240,1.00000,1.00000,
     >     1.00000,1.72500,1.72500,1.00000,1.00000,1.72500,
     >     1.00000,1.00000,1.00000,1.00000,1.00000,1.00000,
     >     1.00000,1.00000,1.61240,1.00000,1.00000,1.00000,
     >     1.33800,1.33800,1.33800,1.33800,1.33800,1.61240,
     >     1.61240,1.72500,1.72500,1.72500,1.00000,1.00000,
     >     2.90530,2.90530,1.00000,1.00000,1.00000,1.00000,
     >     2.90530,1.00000,1.00000,1.00000,2.90530,1.00000,
     >     2.90530,2.90530,2.90530,1.00000,2.90530,1.00000,
     >     1.00000,1.00000,1.00000,1.00000,1.00000,1.00000,
     >     1.00000,1.00000,1.00000,1.61240,1.00000,1.00000,
     >     1.00000,1.00000,1.00000,1.00000,1.00000,1.00000,
     >     1.00000,1.61240,1.61240,1.61240,1.61240/
      DATA NE_B4/
     >     0.23349,0.33978,0.33978,0.33978,0.25831,0.00000,
     >     0.00000,0.00000,0.00000,0.00000,0.00001,0.00001,
     >     0.00001,0.00001,0.00001,0.00001,0.00001,0.16220,
     >     0.00001,0.16220,0.20854,0.00001,0.33978,0.68454,
     >     0.68454,0.00001,0.30651,0.54194,0.30651,0.40115,
     >     0.54194,0.54194,0.30651,0.43972,0.43972,0.43972,
     >     0.30651,0.30651,0.38884,0.38884,0.38884,0.43972,
     >     0.41179,0.41179,0.30651,0.44725,0.44725,0.44725,
     >     0.44725,0.44725,0.44725,0.44725,0.44725,0.44725,
     >     0.44725,0.44725,0.44725,0.44725,0.43972,0.43972,
     >     0.43972,0.30651,0.30651,0.30651,0.30651,0.30651,
     >     0.43972,0.31723,0.38694,0.38694,0.38694,0.38694,
     >     0.38694,0.38694,0.30651,0.30651,0.43972,0.43972,
     >     0.43972,0.38694,0.38694,0.43972,0.43972,0.38694,
     >     0.43972,0.43972,0.43972,0.43972,0.43972,0.43972,
     >     0.43972,0.43972,0.30651,0.43972,0.43972,0.43972,
     >     0.47370,0.47370,0.47370,0.47370,0.47370,0.30651,
     >     0.30651,0.38694,0.38694,0.38694,0.31723,0.31723,
     >     0.55634,0.55634,0.43972,0.43972,0.43972,0.43972,
     >     0.55634,0.31723,0.31723,0.43972,0.55634,0.31723,
     >     0.55634,0.55634,0.55634,0.43972,0.55634,0.43972,
     >     0.43972,0.31723,0.43972,0.43972,0.43972,0.43972,
     >     0.43972,0.43972,0.43972,0.30651,0.43972,0.43972,
     >     0.43972,0.43972,0.43972,0.43972,0.43972,0.43972,
     >     0.43972,0.30651,0.30651,0.30651,0.30651/
      DATA NE_B5/
     >     0.76878,0.76173,0.76173,0.76173,0.68128,0.68967,
     >     0.68967,0.68967,0.68967,0.68967,0.63884,0.63884,
     >     0.63884,0.63884,0.63884,0.63884,0.63884,0.86833,
     >     0.63884,0.86833,0.77792,0.63884,0.76173,0.71410,
     >     0.71410,0.63884,1.02920,0.83440,1.02920,0.85299,
     >     0.83440,0.83440,1.02920,0.82962,0.82962,0.82962,
     >     1.02920,1.02920,0.82157,0.82157,0.82157,0.82962,
     >     0.76498,0.76498,1.02920,1.02370,1.02370,1.02370,
     >     1.02370,1.02370,1.02370,1.02370,1.02370,1.02370,
     >     1.02370,1.02370,1.02370,1.02370,0.82962,0.82962,
     >     0.82962,1.02920,1.02920,1.02920,1.02920,1.02920,
     >     0.82962,0.83560,0.75822,0.75822,0.75822,0.75822,
     >     0.75822,0.75822,1.02920,1.02920,0.82962,0.82962,
     >     0.82962,0.75822,0.75822,0.82962,0.82962,0.75822,
     >     0.82962,0.82962,0.82962,0.82962,0.82962,0.82962,
     >     0.82962,0.82962,1.02920,0.82962,0.82962,0.82962,
     >     0.73385,0.73385,0.73385,0.73385,0.73385,1.02920,
     >     1.02920,0.75822,0.75822,0.75822,0.83560,0.83560,
     >     0.84317,0.84317,0.82962,0.82962,0.82962,0.82962,
     >     0.84317,0.83560,0.83560,0.82962,0.84317,0.83560,
     >     0.84317,0.84317,0.84317,0.82962,0.84317,0.82962,
     >     0.82962,0.83560,0.82962,0.82962,0.82962,0.82962,
     >     0.82962,0.82962,0.82962,1.02920,0.82962,0.82962,
     >     0.82962,0.82962,0.82962,0.82962,0.82962,0.82962,
     >     0.82962,1.02920,1.02920,1.02920,1.02920/
      DATA NE_B6/
     >     0.12399,0.11666,0.11666,0.11666,0.10771,0.16200,
     >     0.16200,0.16200,0.16200,0.16200,0.18231,0.18231,
     >     0.18231,0.18231,0.18231,0.18231,0.18231,0.23316,
     >     0.18231,0.23316,0.12902,0.18231,0.11666,0.00000,
     >     0.00000,0.18231,0.07460,0.06372,0.07460,0.12403,
     >     0.06372,0.06372,0.07460,0.10806,0.10806,0.10806,
     >     0.07460,0.07460,0.11411,0.11411,0.11411,0.10806,
     >     0.11046,0.11046,0.07460,0.14610,0.14610,0.14610,
     >     0.14610,0.14610,0.14610,0.14610,0.14610,0.14610,
     >     0.14610,0.14610,0.14610,0.14610,0.10806,0.10806,
     >     0.10806,0.07460,0.07460,0.07460,0.07460,0.07460,
     >     0.10806,0.13465,0.10847,0.10847,0.10847,0.10847,
     >     0.10847,0.10847,0.07460,0.07460,0.10806,0.10806,
     >     0.10806,0.10847,0.10847,0.10806,0.10806,0.10847,
     >     0.10806,0.10806,0.10806,0.10806,0.10806,0.10806,
     >     0.10806,0.10806,0.07460,0.10806,0.10806,0.10806,
     >     0.08228,0.08228,0.08228,0.08228,0.08228,0.07460,
     >     0.07460,0.10847,0.10847,0.10847,0.13465,0.13465,
     >     0.09593,0.09593,0.10806,0.10806,0.10806,0.10806,
     >     0.09593,0.13465,0.13465,0.10806,0.09593,0.13465,
     >     0.09593,0.09593,0.09593,0.10806,0.09593,0.10806,
     >     0.10806,0.13465,0.10806,0.10806,0.10806,0.10806,
     >     0.10806,0.10806,0.10806,0.07460,0.10806,0.10806,
     >     0.10806,0.10806,0.10806,0.10806,0.10806,0.10806,
     >     0.10806,0.07460,0.07460,0.07460,0.07460/
C----------------------------------------------------------------------
C     MAIN LOGIC
      
      SPEC = VOLEQ(8:10)
      DO 100, I=1,149
         IF(SPEC.EQ.SPEC_LIST(I))THEN
            IF(VFLAG .EQ. 1) THEN
               B(1) = LS_B1(I)
               B(2) = LS_B2(I)
               B(3) = LS_B3(I)
               B(4) = LS_B4(I)
               B(5) = LS_B5(I)
               B(6) = LS_B6(I)
            ELSEIF(VFLAG .EQ. 2) THEN
               B(1) = CS_B1(I)
               B(2) = CS_B2(I)
               B(3) = CS_B3(I)
               B(4) = CS_B4(I)
               B(5) = CS_B5(I)
               B(6) = CS_B6(I)
            ELSE
               B(1) = NE_B1(I)
               B(2) = NE_B2(I)
               B(3) = NE_B3(I)
               B(4) = NE_B4(I)
               B(5) = NE_B5(I)
               B(6) = NE_B6(I)
            ENDIF
            RETURN
         ENDIF
  100 CONTINUE            

      ERRFLAG = 1

      RETURN
      END
