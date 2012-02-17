      SUBROUTINE FMPPGET (WK3, IPNT, ILIMIT)
      IMPLICIT NONE
C----------
C  **FMPPGET      DATE OF LAST REVISION: 06/29/10
C----------
C  Purpose:
C     Get (read) the Fire Model data for a given stand from DA file.
C
C     This is part of the Parallel Processing Extension.
C----------------------------------------------------------------------
C
C  Call list definitions:
C     ILIMIT: (I)  Size of buffer WK3.
C     IPNT:   (IO) Pointer to curent element in print buffer WK3.
C     WK3:    (IO) Work array used as a buffer.
C
C  Local variable definitions:
C     INTS:   Array of length MXI to hold integer values.
C     LOGICS: Array of length MXL to hold logical values.
C     REALS:  Array of length XMR to hold real values.
C

C.... Parameter statements.

      INTEGER MXL,MXR,MXI
      PARAMETER (MXL=14,MXR=54,MXI=91)

C.... Parameter include files.

      INCLUDE 'PRGPRM.F77'
      INCLUDE 'CONTRL.F77'
      INCLUDE 'SVDATA.F77'

      INCLUDE 'FMPARM.F77'
      INCLUDE 'FMCOM.F77'
      INCLUDE 'FMFCOM.F77'
      INCLUDE 'FMSVCM.F77'

      LOGICAL LOGICS(MXL)
      INTEGER INTS(MXI), I, ILIMIT, IPNT, NSNAGZ
      REAL    REALS(MXR), WK3(*)

      CALL IFREAD (WK3, IPNT, ILIMIT, INTS, MXI, 2)
      IFMTYP   = INTS(  1)
      ACTCBH   = INTS(  2)
      ATEMP    = INTS(  3)
      BURNYR   = INTS(  4)
      COVTYP   = INTS(  5)
      FIRTYPE  = INTS(  6)
      FMKOD    = INTS(  7)
      FTREAT   = INTS(  8)
      HARTYP   = INTS(  9)
      HARVYR   = INTS( 10)
      IBRPAS   = INTS( 11)
      IDBRN    = INTS( 12)
      IDFLAL   = INTS( 13)
      IDFUL    = INTS( 14)
      IDMRT    = INTS( 15)
      IDPFLM   = INTS( 16)
      IDRYB    = INTS( 17)
      IDRYE    = INTS( 18)
      IFAPAS   = INTS( 19)
      IFLALB   = INTS( 20)
      IFLALE   = INTS( 21)
      IFLPAS   = INTS( 22)
      IFMBRB   = INTS( 23)
      IFMBRE   = INTS( 24)
      IFMFLB   = INTS( 25)
      IFMFLE   = INTS( 26)
      IFMMRB   = INTS( 27)
      IFMMRE   = INTS( 28)
      IFMYR1   = INTS( 29)
      IFMYR2   = INTS( 30)
      IFSTEP   = INTS( 31)
      IFTYR    = INTS( 32)
      IMRPAS   = INTS( 33)
      IPFLMB   = INTS( 34)
      IPFLME   = INTS( 35)
      IPFPAS   = INTS( 36)
      IPFSTP   = INTS( 37)
      ISALVC   = INTS( 38)
      ISALVS   = INTS( 39)
      ISNAGB   = INTS( 40)
      ISNAGE   = INTS( 41)
      ISNGSM   = INTS( 42)
      ISNSTP   = INTS( 43)
      JCOUT    = INTS( 44)
      JSNOUT   = INTS( 45)
      ND       = INTS( 46)
      NFMODS   = INTS( 47)
      NFMSVPX  = INTS( 48)
      NL       = INTS( 49)
      NSNAG    = INTS( 50)
      OLDCOVTYP= INTS( 51)
      OLDICT   = INTS( 52)
      OLDICT2  = INTS( 53)
      PBURNYR  = INTS( 54)
      FM89YR   = INTS( 55)
      ICBHMT   = INTS( 56)
      ICANSP   = INTS( 57)
      BURNSEAS = INTS( 58)
      IDSHEAT  = INTS( 59)
      ISHEATB  = INTS( 60)
      ISHEATE  = INTS( 61)
      SOILTP   = INTS( 62) 
      ICFPB    = INTS( 63)
      ICFPE    = INTS( 64) 
      ICFPST   = INTS( 65)
      NSNAGSALV= INTS( 66)

C------- Carbon reporting INTEGER variables --------
      ICHABT   = INTS( 67)
      ICHPAS   = INTS( 68)
      ICHRVB   = INTS( 69)
      ICHRVE   = INTS( 70)
      ICHRVI   = INTS( 71)
      ICMETRC  = INTS( 72)
      ICMETH   = INTS( 73)
      ICRPAS   = INTS( 74)
      ICRPTB   = INTS( 75)
      ICRPTE   = INTS( 76)
      ICRPTI   = INTS( 77)
      IDCHRV   = INTS( 78)
      IDCRPT   = INTS( 79)
C------- new FFE INTEGER variables --------    
      IFLOGIC  = INTS( 80)
      IFMSET   = INTS( 81)      
C------- new FFE INTEGER variables for down wood reports --------      
      IDWPAS   = INTS( 82)
      IDWRPB   = INTS( 83)
      IDWRPE   = INTS( 84)
      IDWRPI   = INTS( 85)
      IDCPAS   = INTS( 86)
      IDWCVB   = INTS( 87)
      IDWCVE   = INTS( 88)
      IDWCVI   = INTS( 89)
      IDDWRP   = INTS( 90)
      IDDWCV   = INTS( 91)  

      NSNAGZ = MAX(NSNAG,1)
      CALL IFREAD (WK3, IPNT, ILIMIT, DKRCLS, MAXSP       , 2)
      CALL IFREAD (WK3, IPNT, ILIMIT, FLAG, 3             , 2)
      CALL IFREAD (WK3, IPNT, ILIMIT, FMDUSR, 4           , 2)
      CALL IFREAD (WK3, IPNT, ILIMIT, FMOD, MXFMOD        , 2)
      CALL IFREAD (WK3, IPNT, ILIMIT, GROW,  ITRN         , 2)
      CALL IFREAD (WK3, IPNT, ILIMIT, IOBJTPTMP, NSVOBJ   , 2)
      CALL IFREAD (WK3, IPNT, ILIMIT, IS2FTMP,   NSVOBJ   , 2)
      CALL IFREAD (WK3, IPNT, ILIMIT, JFROUT, 3           , 2)
      CALL IFREAD (WK3, IPNT, ILIMIT, JLOUT,  3           , 2)
      CALL IFREAD (WK3, IPNT, ILIMIT, MPS,    8           , 2)
      CALL IFREAD (WK3, IPNT, ILIMIT, PLSIZ,  2           , 2)
      CALL IFREAD (WK3, IPNT, ILIMIT, POTSEAS, 2          , 2)
      CALL IFREAD (WK3, IPNT, ILIMIT, POTTYP, 2           , 2)
      CALL IFREAD (WK3, IPNT, ILIMIT, SPS,    NSNAGZ      , 2)
      CALL IFREAD (WK3, IPNT, ILIMIT, SPSSALV, NSNAGZ     , 2)
      CALL IFREAD (WK3, IPNT, ILIMIT, SURFVL, MXDFMD*2*4  , 2)
      CALL IFREAD (WK3, IPNT, ILIMIT, YRDEAD, NSNAGZ      , 2)
      CALL IFREAD (WK3, IPNT, ILIMIT, FMICR, MAXTRE       , 2)
      CALL IFREAD (WK3, IPNT, ILIMIT, IFUELMON, MXDFMD    , 2)
      
      CALL LFREAD (WK3, IPNT, ILIMIT, LOGICS,   MXL, 2)
      LANHED = LOGICS ( 1)
      LATFUEL= LOGICS ( 2)
      LDHEAD = LOGICS ( 3)
      LDYNFM = LOGICS ( 4)
      LFLBRN = LOGICS ( 5)
      LFMON  = LOGICS ( 6)
      LFMON2 = LOGICS ( 7)
      LHEAD  = LOGICS ( 8)
      LREMT  = LOGICS ( 9)
      LSHEAD = LOGICS (10)
      LUSRFM = LOGICS (11)
      LATSHRB= LOGICS (12)
      LVWEST = LOGICS (13)
      LPRV89 = LOGICS (14)

      CALL LFREAD (WK3, IPNT, ILIMIT, HARD, NSNAGZ,     2)
      CALL LFREAD (WK3, IPNT, ILIMIT, HARDSALV, NSNAGZ, 2)
      CALL LFREAD (WK3, IPNT, ILIMIT, LFROUT, 3,        2)
      CALL LFREAD (WK3, IPNT, ILIMIT, LSW, MAXSP,       2)
      
      CALL BFREAD (WK3, IPNT, ILIMIT, REALS, MXR, 2)
      BURNCR = REALS (  1)
      CBD    = REALS (  2)
      CRBURN = REALS (  3)
      CWDCUT = REALS (  4)
      DEPTH  = REALS (  5)
      DPMOD  = REALS (  6)
      EXPOSR = REALS (  7)
      FLAMEHT= REALS (  8)
      FLPART = REALS (  9)
      FMSLOP = REALS ( 10)
      FWIND  = REALS ( 11)
      HTR1   = REALS ( 12)
      HTR2   = REALS ( 13)
      HTXSFT = REALS ( 14)
      LARGE  = REALS ( 15)
      LIMBRK = REALS ( 16)
      MINSOL = REALS ( 17)
      NZERO  = REALS ( 18)
      OLARGE = REALS ( 19)
      OSMALL = REALS ( 20)
      PBRNCR = REALS ( 21)
      PBSCOR = REALS ( 22)
      PBSIZE = REALS ( 23)
      PBSMAL = REALS ( 24)
      PBSOFT = REALS ( 25)
      PBTIME = REALS ( 26)
      PERCOV = REALS ( 27)
      PRSNAG = REALS ( 28)
      RFINAL = REALS ( 29)
      SCCF   = REALS ( 30)
      SCH    = REALS ( 31)
      SLCHNG = REALS ( 32)
      SLCRIT = REALS ( 33)
      SMALL  = REALS ( 34)
      TCLOAD = REALS ( 35)
      TONRMC = REALS ( 36)
      TONRMH = REALS ( 37)
      TONRMS = REALS ( 38)
      TOTACR = REALS ( 39)
      CCCHNG = REALS ( 40)
      CCCRIT = REALS ( 41)
      PRV8   = REALS ( 42)
      PRV9   = REALS ( 43)
      CANMHT = REALS ( 44)
      CBHCUT = REALS ( 45)
C------- Carbon reporting REAL variables --------
      CRDCAY = REALS ( 46)
      BIOLIVE= REALS ( 47)
      BIOSNAG= REALS ( 48)
      BIODDW = REALS ( 49)
      BIOFLR = REALS ( 50)
      BIOSHRB= REALS ( 51)
      BIOROOT= REALS ( 52)
C-------new FFE REAL variables --------
      ULHV   = REALS ( 53)
      FOLMC  = REALS ( 54)
      
      CALL BFREAD (WK3, IPNT, ILIMIT, ALLDWN,       MAXSP  , 2)
      CALL BFREAD (WK3, IPNT, ILIMIT, CANCLS,        4     , 2)
      CALL BFREAD (WK3, IPNT, ILIMIT, CATCHUP,      NFLPTS , 2)
      CALL BFREAD (WK3, IPNT, ILIMIT, CORFAC,        4     , 2)
      DO I=0,5
         CALL BFREAD (WK3, IPNT, ILIMIT, CROWNW(1,I), ITRN , 2)
         CALL BFREAD (WK3, IPNT, ILIMIT, OLDCRW(1,I), ITRN , 2)
      ENDDO
      CALL BFREAD (WK3, IPNT, ILIMIT, CURKIL, ITRN         , 2)
      CALL BFREAD (WK3, IPNT, ILIMIT, CWD, 3*MXFLCL*2*5    , 2)
      CALL BFREAD (WK3, IPNT, ILIMIT, CWD2B,   4*6*TFMAX   , 2)
      CALL BFREAD (WK3, IPNT, ILIMIT, CWD2B2,  4*6*TFMAX   , 2)
      CALL BFREAD (WK3, IPNT, ILIMIT, CWDNEW,    2*MXFLCL  , 2)
      CALL BFREAD (WK3, IPNT, ILIMIT, DBHS,    NSNAGZ      , 2)
      CALL BFREAD (WK3, IPNT, ILIMIT, DBHSSALV, NSNAGZ     , 2)
      CALL BFREAD (WK3, IPNT, ILIMIT, DECAYX,  MAXSP       , 2)
      CALL BFREAD (WK3, IPNT, ILIMIT, DEND ,   NSNAGZ      , 2)
      CALL BFREAD (WK3, IPNT, ILIMIT, DENIH,   NSNAGZ      , 2)
      CALL BFREAD (WK3, IPNT, ILIMIT, DENIS,   NSNAGZ      , 2)
      CALL BFREAD (WK3, IPNT, ILIMIT, DKR,   MXFLCL*4      , 2)
      CALL BFREAD (WK3, IPNT, ILIMIT, DKRDEF, 4            , 2)
      CALL BFREAD (WK3, IPNT, ILIMIT, DSPDBH, MAXSP*19     , 2)
      CALL BFREAD (WK3, IPNT, ILIMIT, FALLX, MAXSP         , 2)
      CALL BFREAD (WK3, IPNT, ILIMIT, FIRACR, 2            , 2)
      CALL BFREAD (WK3, IPNT, ILIMIT, FLIVE, 2             , 2)
      CALL BFREAD (WK3, IPNT, ILIMIT, FMACRE, 14           , 2)
      CALL BFREAD (WK3, IPNT, ILIMIT, FMDEP, MXDFMD        , 2)
      CALL BFREAD (WK3, IPNT, ILIMIT, FMLOAD, MXDFMD*2*7   , 2)
      CALL BFREAD (WK3, IPNT, ILIMIT, FMTBA, MAXSP         , 2)
      CALL BFREAD (WK3, IPNT, ILIMIT, FMY1,  NFLPTS        , 2)
      CALL BFREAD (WK3, IPNT, ILIMIT, FMY2,  NFLPTS        , 2)
      CALL BFREAD (WK3, IPNT, ILIMIT, FUAREA, 5*4          , 2)
      CALL BFREAD (WK3, IPNT, ILIMIT, FWG, 2*7             , 2)
      CALL BFREAD (WK3, IPNT, ILIMIT, FWT, MXFMOD          , 2)
      CALL BFREAD (WK3, IPNT, ILIMIT, FWTUSR, 4            , 2)
      CALL BFREAD (WK3, IPNT, ILIMIT, HTDEAD, NSNAGZ       , 2)
      CALL BFREAD (WK3, IPNT, ILIMIT, HTDEADSALV, NSNAGZ   , 2)
      CALL BFREAD (WK3, IPNT, ILIMIT, HTIH,   NSNAGZ       , 2)
      CALL BFREAD (WK3, IPNT, ILIMIT, HTIHSALV, NSNAGZ     , 2)
      CALL BFREAD (WK3, IPNT, ILIMIT, HTIS,   NSNAGZ       , 2)
      CALL BFREAD (WK3, IPNT, ILIMIT, HTISSALV, NSNAGZ     , 2)
      CALL BFREAD (WK3, IPNT, ILIMIT, HTX,  MAXSP*4        , 2)
      CALL BFREAD (WK3, IPNT, ILIMIT, LEAFLF, MAXSP        , 2)
      CALL BFREAD (WK3, IPNT, ILIMIT, LOWDBH, 7            , 2)
      CALL BFREAD (WK3, IPNT, ILIMIT, MAXHT, MAXSP*19      , 2)
      CALL BFREAD (WK3, IPNT, ILIMIT, MEXT, 3              , 2)
      CALL BFREAD (WK3, IPNT, ILIMIT, MINHT, MAXSP*19      , 2)
      CALL BFREAD (WK3, IPNT, ILIMIT, MOIS, 2*5            , 2)
      CALL BFREAD (WK3, IPNT, ILIMIT, MOISEX, MXDFMD       , 2)
      CALL BFREAD (WK3, IPNT, ILIMIT, OFFSET, NFLPTS       , 2)
      CALL BFREAD (WK3, IPNT, ILIMIT, OLDCRL, ITRN         , 2)
      CALL BFREAD (WK3, IPNT, ILIMIT, OLDHT,  ITRN         , 2)
      CALL BFREAD (WK3, IPNT, ILIMIT, PBFRIH, NSNAGZ       , 2)
      CALL BFREAD (WK3, IPNT, ILIMIT, PBFRIS, NSNAGZ       , 2)
      CALL BFREAD (WK3, IPNT, ILIMIT, PFLACR, 4*3          , 2)
      CALL BFREAD (WK3, IPNT, ILIMIT, PFLAM, 4             , 2)
      CALL BFREAD (WK3, IPNT, ILIMIT, POTEMP, 2            , 2)
      CALL BFREAD (WK3, IPNT, ILIMIT, POTFSR, 4            , 2)
      CALL BFREAD (WK3, IPNT, ILIMIT, POTKIL, 4            , 2)
      CALL BFREAD (WK3, IPNT, ILIMIT, POTPAB, 2            , 2)
      CALL BFREAD (WK3, IPNT, ILIMIT, POTRINT, 2           , 2)
      CALL BFREAD (WK3, IPNT, ILIMIT, POTVOL, 2            , 2)
      CALL BFREAD (WK3, IPNT, ILIMIT, PRDUFF, MXFLCL       , 2)
      CALL BFREAD (WK3, IPNT, ILIMIT, PRESVL, 2*8          , 2)
      CALL BFREAD (WK3, IPNT, ILIMIT, PREWND, 2            , 2)
      CALL BFREAD (WK3, IPNT, ILIMIT, PRPILE, MXFLCL       , 2)
      CALL BFREAD (WK3, IPNT, ILIMIT, PSOFT, MAXSP         , 2)
      CALL BFREAD (WK3, IPNT, ILIMIT, SALVSPA, NSNAGZ*2    , 2)
      CALL BFREAD (WK3, IPNT, ILIMIT, SCBE, 3              , 2)
      CALL BFREAD (WK3, IPNT, ILIMIT, SFRATE, 3            , 2)
      CALL BFREAD (WK3, IPNT, ILIMIT, SIRXI,  3            , 2)
      CALL BFREAD (WK3, IPNT, ILIMIT, SMOKE,  2            , 2)
      CALL BFREAD (WK3, IPNT, ILIMIT, SNGNEW, NSNAGZ       , 2)
      CALL BFREAD (WK3, IPNT, ILIMIT, SNPRCL, 6            , 2)
      CALL BFREAD (WK3, IPNT, ILIMIT, SPHIS, 3             , 2)
      CALL BFREAD (WK3, IPNT, ILIMIT, SRHOBQ, 3            , 2)
      CALL BFREAD (WK3, IPNT, ILIMIT, SSIGMA, 3            , 2)
      CALL BFREAD (WK3, IPNT, ILIMIT, SXIR, 3              , 2)
      CALL BFREAD (WK3, IPNT, ILIMIT, TCWD,  6             , 2)
      CALL BFREAD (WK3, IPNT, ILIMIT, TCWD2, 6             , 2)
      CALL BFREAD (WK3, IPNT, ILIMIT, TFALL,   MAXSP*6     , 2)
      CALL BFREAD (WK3, IPNT, ILIMIT, TODUFF,  MXFLCL*4    , 2)
      CALL BFREAD (WK3, IPNT, ILIMIT, V2T,     MAXSP       , 2)
      CALL BFREAD (WK3, IPNT, ILIMIT, BURNED,  3*MXFLCL    , 2)
      CALL BFREAD (WK3, IPNT, ILIMIT, BURNLV,  2           , 2)
      CALL BFREAD (WK3, IPNT, ILIMIT, FIRKIL,  MAXTRE      , 2)
      CALL BFREAD (WK3, IPNT, ILIMIT, FMPROB,  MAXTRE      , 2)
      CALL BFREAD (WK3, IPNT, ILIMIT, OLDICTWT, 2          , 2)
C------- Carbon reporting REAL variables --------
      CALL BFREAD (WK3, IPNT, ILIMIT, CDBRK,   2           , 2)
      CALL BFREAD (WK3, IPNT, ILIMIT, BIOCON,  2           , 2)
      CALL BFREAD (WK3, IPNT, ILIMIT, BIOREM,  2           , 2)
      CALL BFREAD (WK3, IPNT, ILIMIT, FATE,    2*2*MAXCYC  , 2)
      CALL BFREAD (WK3, IPNT, ILIMIT, CARBVAL, 17          , 2)
C------- new FFE REAL variables --------
      CALL BFREAD (WK3, IPNT, ILIMIT, USAV,     3          , 2)
      CALL BFREAD (WK3, IPNT, ILIMIT, UBD,      2          , 2)
      CALL BFREAD (WK3, IPNT, ILIMIT, CWDVOL,  3*10*2*5    , 2)
      CALL BFREAD (WK3, IPNT, ILIMIT, CWDCOV,  3*10*2*5    , 2)
                  
      RETURN
      END
