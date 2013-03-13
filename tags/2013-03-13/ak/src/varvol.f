        SUBROUTINE VARVOL
        IMPLICIT NONE
C----------
C  **VARVOL--AK    DATE OF LAST REVISION:   09/29/11
C----------
C
C  THIS SUBROUTINE CALLS THE APPROPRIATE VOLUME CALCULATION ROUTINE
C  FROM THE NATIONAL CRUISE SYSTEM VOLUME LIBRARY FOR METHB OR METHC
C  EQUAL TO 6.  IT ALSO CONTAINS ANY OTHER SPECIAL VOLUME CALCULATION
C  METHOD SPECIFIC TO A VARIANT (METHB OR METHC = 8)
C
C  All FLEWELLING EQS. (TONGASS NF, EXCEPT SP.NO. 1) USE STANDARD LOG 
C  LENGTH OF 32 FT FOR BD FT CALCULATIONS AND 16 FT LOGS FOR CU FT
C  CALCULATIONS. ALL CHUGACH NF EQS. USE 16 FT LOGS.
C----------
C
COMMONS
C
C
      INCLUDE 'PRGPRM.F77'
C
C
      INCLUDE 'ARRAYS.F77'
C
C
      INCLUDE 'COEFFS.F77'
C
C
      INCLUDE 'CONTRL.F77'
C
C
      INCLUDE 'PLOT.F77'
C
C
      INCLUDE 'VOLSTD.F77'
C
C
COMMONS
C
C----------
      INTEGER IT,ITRNC,ISPC,INTFOR,IERR,IZERO
      INTEGER I01,I02,I03,I04,I05,I1,IREGN,IFIASP
      
      REAL VMAX,BARK,H,D,BBFV,VM,VN,DBT,TOPDIB
      REAL X01,X02,X03,X04,X05,X06,X07,X08,X09,X010,X011,X012
      REAL TOPS,HTL,TVOL1,TVOL4,VVN,BBF,VOLT,BEHRE,STUMP
      REAL DMRCH,HTMRCH,VOLM,S3,TDIBB,TDIBC,BRATIO
C
      REAL LOGLEN(20),TVOL(15),BOLHT(21)
      REAL NLOGMS,NLOGTW
      CHARACTER*10 VOLEQ
      CHARACTER CTYPE*1,FORST*2,HTTYPE,PROD*2
      INTEGER TLOGS,ERRFLAG
      LOGICAL TKILL,CTKFLG,BTKFLG,LCONE,DEBUG
      CHARACTER*10 EQNC,EQNB
C
C (AK VARIANT)  WS  RC  SF  MH  WH  YC  LP  SS  AF  RA  CW  OH  OS
C  VOLUME EQUATIONS AS OF 08/07
C      DATA CHUEQN/  'A00DVEW094','A01DEMW000','A01DEMW000',
C     & 'A01DEMW000','A01DEMW000','A01DEMW000','A01DEMW000',
C     & 'A01DEMW000','A01DEMW000','A01DEMW000','A01DEMW000',
C     & 'A16DEMW098','A16DEMW098'/
C
C      DATA TONEQN/  'A00DVEW094','A00F32W242','A00F32W263',
C     & 'A00F32W263','A00F32W263','A00F32W042','A00F32W263',
C     & 'A00F32W098','A00F32W263','A00F32W263','A00F32W263',
C     & 'A00F32W263','A00F32W263'/
C----------
C THESE WERE THE OLD VOLUME EQNS USED BEFORE 5/02 CHANGES.
C THE ONES LABELLED CHUEQN WERE THE DEFAULT FOR THE TONGASS,
C THE TONEQN EQUATIONS COULD BE USED BY SETTING FORM CLASS
C TO 32.  THE A16 EQUATIONS WERE REPLACED BY THE A01 EQNS
C AND THE A32 EQUATIONS WERE REPLACED BY THE A61 EQUATIONS.
C THE DEFAULT IS TO USE THE TONGASS EQUATIONS AS THE DEFAULT.
C THE OTHER EQUATIONS MAY BE USED BY SETTING FORM CLASS TO
C 16.
C     DATA CHUEQN/  'A16DEMW098','A16DEMW242','A16DEMW098',
C    & 'A16DEMW098','A16DEMW098','A16DEMW042','A16DEMW098',
C    & 'A16DEMW098','A16DEMW098','A16DEMW098','A16DEMW098',
C    & 'A16DEMW098','A16DEMW098'/
C
C     DATA TONEQN/   'A32DEMW098','A32DEMW242','A32DEMW098',
C    & 'A32DEMW098','A32DEMW098','A32DEMW042','A32DEMW098',
C    & 'A32DEMW098','A32DEMW098','A32DEMW098','A32DEMW098',
C    & 'A32DEMW098','A32DEMW098'/
C----------
C  NATIONAL CRUISE SYSTEM ROUTINES (METHOD = 6)
C----------
      ENTRY NATCRS (VN,VM,BBFV,ISPC,D,H,TKILL,BARK,ITRNC,VMAX,
     1              CTKFLG,BTKFLG,IT)
C-----------
C  SEE IF WE NEED TO DO SOME DEBUG.
C-----------
      CALL DBCHK (DEBUG,'VARVOL',6,ICYC)
      IF(DEBUG)WRITE(JOSTND,*)' ENTERING VARVOL-ICYC= ',ICYC
      IF(DEBUG)WRITE(JOSTND,*)' AFTER NATCRS ARGUMENTS= ',VN,VM,BBFV,
     &ISPC,D,H,TKILL,BARK,ITRNC,VMAX,CTKFLG,BTKFLG,IT
C     
C----------
C  SET PARAMETERS & CALL PROFILE TO COMPUTE R10 VOLUMES.
C----------
      INTFOR = KODFOR - (KODFOR/100)*100
      WRITE(FORST,'(I2)')INTFOR
      IF(INTFOR.LT.10)FORST(1:1)='0'
      HTTYPE='F'
      IERR=0
C
      DBT = D*(1-BRATIO(ISPC,D,H))
      DO 100 IZERO=1,15
      TVOL(IZERO)=0.
  100 CONTINUE
      TOPDIB=TOPD(ISPC)*BRATIO(ISPC,D,H)
C----------
C  CALL TO VOLUME INTERFACE - PROFILE
C  CONSTANT INTEGER ZERO ARGUMENTS - CUBIC FT
C----------
      I01=0
      I02=0
      I03=0
      I04=0
      I05=0
C----------
C  CONSTANT REAL ZERO ARGUMENTS
C----------
      X01=0.
      X02=0.
      X03=0.
      X04=0.
      X05=0.
      X06=0.
      X07=0.
      X08=0.
      X09=0.
      X010=0.
      X011=0.
      X012=0.
C----------
C  CONSTANT CHARACTER ARGUMENTS
C----------
      CTYPE=' '
      PROD='  '
C----------
C  CONSTANT INTEGER ARGUMENTS - CUBIC FT
C----------
      I1= 1
      IREGN= 10
C
C  DEMAR'S, BRUCE, OR CURTIS MODELS- TREES LESS THEN 9 INCHES DBH OR
C                                    40 FEET IN TOTAL HEIGHT WILL
C                                    USE SMALL TREE LOGIC (R10VOL)
c                                    INSTEAD OF PROFILE MODELS.
C  FLEWELLING - ALL TREES USE PROFILE
C
      IF((VEQNNC(ISPC)(4:4).EQ.'F').OR.((VEQNNC(ISPC)(4:6).EQ.'DEM')
     &   .AND.((D.GE.9.).AND.(H.GE.40.))).OR.
     &   ((VEQNNC(ISPC)(4:6).EQ.'CUR').AND.((D.GE.9.).AND.
     &   (H.GE.40.))))THEN
C
        IF(DEBUG)WRITE(JOSTND,*)' CALLING PROFILE CF ISPC,ARGS = ',
     &  ISPC,IREGN,FORST,VEQNNC(ISPC),TOPD(ISPC),STMP(ISPC),D,H,
     &  DBT,BARK
C
        CALL PROFILE (IREGN,FORST,VEQNNC(ISPC),TOPDIB,X01,STMP(ISPC),D,
     &  HTTYPE,H,I01,X02,X03,X04,X05,X06,X07,X08,X09,I02,DBT,BARK*100.,
     &  LOGDIA,BOLHT,LOGLEN,LOGVOL,TVOL,I03,X010,X011,I1,I1,I1,I04,
     &  I05,X012,CTYPE,I01,PROD,IERR)
C
        IF(DEBUG)WRITE(JOSTND,*)' AFTER PROFILE CF TVOL= ',TVOL
C
        IF(D.GE.BFMIND(ISPC))THEN
          IF(IT.GT.0)HT2TD(IT,1)=X02
        ELSE
          IF(IT.GT.0)HT2TD(IT,1)=0.
        ENDIF
        IF(D.GE.DBHMIN(ISPC))THEN
          IF(IT.GT.0)HT2TD(IT,2)=X02
        ELSE
          IF(IT.GT.0)HT2TD(IT,2)=0.
        ENDIF        
C
      ELSEIF(VEQNNC(ISPC)(4:6).EQ.'DVE')THEN
C----------
C  OLD R10 SECTION
C  CALL R10VOL OR R10D2H, TO COMPUTE CUBIC VOLUME.
C----------
        TOPS = 0.
        HTL=0.
        NLOGMS=0.
        NLOGTW=0.
        TLOGS=0
        CALL R10D2H(VEQNNC(ISPC),D,H,TVOL,1,1,1,IERR)
      ELSE
        CALL R10VOL(VEQNNC(ISPC),TOPDIB,TOPS,H,HTL,D,'F',TVOL,
     &  NLOGMS,NLOGTW,TLOGS,LOGLEN,LOGDIA,LOGVOL,1,1,0,IERR)
C
        IF(DEBUG)WRITE(16,*)' ISPC,BFTOPD,TOPD,VEQNNB(ISPC),',
     & 'VEQNNC(ISPC)= ',ISPC,BFTOPD(ISPC),TOPD(ISPC),VEQNNB(ISPC),
     &  VEQNNC(ISPC)
      ENDIF  ! END OF CF SECTION
C----------
C  IF TOP DIAMETER IS DIFFERENT FOR BF CALCULATIONS, OR THE BF VOLUME EQ.
C  IS DIFFERENT THAN THE CF VOLUME EQUATION NO. THEN STORE APPROPRIATE
C  VOLUMES AND CALL PROFILE AGAIN.
C----------
      IF((BFTOPD(ISPC).NE.TOPD(ISPC)).OR.
     &   (BFSTMP(ISPC).NE.STMP(ISPC)).OR.
     &   (VEQNNB(ISPC).NE.VEQNNC(ISPC))) THEN
        TVOL1=TVOL(1)
        TVOL4=TVOL(4)
        DO 110 IZERO=1,15
        TVOL(IZERO)=0.
  110   CONTINUE
        TOPDIB=BFTOPD(ISPC)*BARK
C----------
C  CALL TO VOLUME INTERFACE - PROFILE
C  CONSTANT INTEGER ZERO ARGUMENTS
C----------
        I01=0
        I02=0
        I03=0
        I04=0
        I05=0
C----------
C  CONSTANT REAL ZERO ARGUMENTS - CUBIC FT
C----------
        X01=0.
        X02=0.
        X03=0.
        X04=0.
        X05=0.
        X06=0.
        X07=0.
        X08=0.
        X09=0.
        X010=0.
        X011=0.
        X012=0.
C----------
C  CONSTANT CHARACTER ARGUMENTS- CUBIC FT
C----------
        CTYPE=' '
        PROD='  '
C----------
C  CONSTANT INTEGER ARGUMENTS
C----------
        IF((VEQNNB(ISPC)(4:4).EQ.'F').OR.((VEQNNB(ISPC)(4:6).EQ.'DEM')
     &     .AND.((D.GE.9.).AND.(H.GE.40.))).OR.
     &     ((VEQNNB(ISPC)(4:6).EQ.'CUR').AND.((D.GE.9.).OR.
     &     (H.GE.40.))))THEN
          I1= 1
          IREGN= 10
C
          IF(DEBUG)WRITE(JOSTND,*)' CALLING PROFILE BF ISPC,ARGS = ',
     &    ISPC,FORST,VEQNNB(ISPC),BFTOPD(ISPC),BFSTMP(ISPC),D,H,
     &    DBT,BARK
C
          CALL PROFILE (IREGN,FORST,VEQNNB(ISPC),TOPDIB,X01,
     &    BFSTMP(ISPC),D,HTTYPE,H,I01,X02,X03,X04,X05,X06,X07,
     &    X08,X09,I02,DBT,BARK*100.,LOGDIA,BOLHT,LOGLEN,LOGVOL,
     &    TVOL,I03,X010,X011,I1,I1,I1,I04,I05,X012,CTYPE,I01,PROD,
     &    IERR)
C        
          IF(DEBUG)WRITE(JOSTND,*)' AFTER PROFILE BF TVOL= ',TVOL
C 
          IF(D.GE.BFMIND(ISPC))THEN
            IF(IT.GT.0)HT2TD(IT,1)=X02
          ELSE
            IF(IT.GT.0)HT2TD(IT,1)=0.
          ENDIF
C
          TVOL(1)=TVOL1
          TVOL(4)=TVOL4
C
        ELSEIF(VEQNNB(ISPC)(4:6).EQ.'DVE')THEN
C----------
C  SET R10VOL PARAMETERS FOR BOARD FOOT VOLUME
C----------
          TOPS = 0.
          HTL=0.
          NLOGMS=0.
          NLOGTW=0.
          TLOGS=0
          IERR=0
          CALL R10D2H(VEQNNB(ISPC),D,H,TVOL,0,0,1,IERR)
          TVOL(1)=TVOL1
          TVOL(4)=TVOL4
        ELSE
          CALL R10VOL(VEQNNB(ISPC),TOPDIB,TOPS,H,HTL,D,'F',TVOL,
     &    NLOGMS,NLOGTW,TLOGS,LOGLEN,LOGDIA,LOGVOL,1,1,0,IERR)
          TVOL(1)=TVOL1
          TVOL(4)=TVOL4
        ENDIF
      ENDIF
C----------
C  SET RETURN VALUES.
C----------
      VN=TVOL(1)
      IF(VN.LT.0.)VN=0.
      VMAX=VN
      IF(D .LT. DBHMIN(ISPC))THEN
        VM = 0.
      ELSE
        VM=TVOL(4)
        IF(VM.LT.0.)VM=0.
      ENDIF
      IF(D.LT.BFMIND(ISPC))THEN
        BBFV=0.
      ELSE
        IF(METHB(ISPC).EQ.9) THEN
          BBFV=TVOL(10)
        ELSE
          BBFV=TVOL(2)
        ENDIF
        IF(BBFV.LT.0.)BBFV=0.
      ENDIF
        CTKFLG = .TRUE.
        BTKFLG = .TRUE.
C
      RETURN
C
C
C----------
C  ENTER ANY OTHER CUBIC HERE
C----------
      ENTRY OCFVOL (VN,VM,ISPC,D,H,TKILL,BARK,ITRNC,VMAX,LCONE,
     1              CTKFLG,IT)
      VVN=0.0
      BBF=0.0
      IF (H .LE. 4.5) GO TO 50
      IF(D .LE. 3.5 .OR. H .LT. 18.0) GO TO 10
      IF(D .GE. 9.0 .AND. H .GT. 40.0)GO TO 30
      CALL OLDSEC(ISPC,VVN,D,H)
      GO TO 50
   10 CALL OLDFST (ISPC,VVN,D,H)
      GO TO 50
   30 CALL OLDGRO(ISPC,VVN,D,H,BBF)
   50 CONTINUE
      VN=VVN
      VMAX=VVN
C----------
C  COMPUTE MERCHANTABLE CUBIC VOLUME USING TOP DIAMETER, MINIMUM
C  DBH, AND STUMP HEIGHT SPECIFIED BY THE USER.
C----------
      IF(VN .EQ. 0.) THEN
        VM = 0.
        CTKFLG = .FALSE.
        GO TO 60
      ENDIF
      CALL BEHPRM (VMAX,D,H,BARK,LCONE)
      VOLT=BEHRE(0.0,1.0)
      STUMP = 1. - (STMP(ISPC)/H)
      IF(D.LT.DBHMIN(ISPC).OR.D.LT.TOPD(ISPC)) THEN
        VM=0.0
      ELSE
        DMRCH=TOPD(ISPC)/D
        HTMRCH=((BHAT*DMRCH)/(1.0-(AHAT*DMRCH)))
        IF(.NOT.LCONE) THEN
          VOLM=BEHRE(HTMRCH,STUMP)
          VM=VMAX*VOLM/VOLT
        ELSE
C----------
C       PROCESS CONES.
C----------
          S3=STUMP**3
          VOLM=S3-HTMRCH**3
          VM=VMAX*VOLM
        ENDIF
      ENDIF
      CTKFLG = .TRUE.
   60 CONTINUE
      RETURN
C
C
C----------
C  ENTER ANY OTHER BOARD HERE.
C----------
      ENTRY OBFVOL (BBFV,ISPC,D,H,TKILL,BARK,ITRNC,VMAX,LCONE,
     1              BTKFLG,IT)
      VVN=0.0
      BBF=0.0
      IF(D .GE. 9.0 .AND. H .GT. 40.0) THEN
        CALL OLDGRO(ISPC,VVN,D,H,BBF)
      ENDIF
      BBFV=BBF
      BTKFLG = .TRUE.
      RETURN
C
C
C----------
C  ENTRY POINT FOR SENDING VOLUME EQN NUMBER TO THE FVS-TO-NATCRZ ROUTINE
C----------
      ENTRY GETEQN(ISPC,D,H,EQNC,EQNB,TDIBC,TDIBB)
      EQNC=VEQNNC(ISPC)
      EQNB=VEQNNB(ISPC)
      TDIBC=TOPD(ISPC)*BRATIO(ISPC,D,H)
      TDIBB=BFTOPD(ISPC)*BRATIO(ISPC,D,H)
      RETURN
C
      END