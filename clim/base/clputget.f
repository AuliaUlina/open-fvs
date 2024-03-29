      SUBROUTINE CLPUT (WK3,IPNT,ILIMIT)
      IMPLICIT NONE
C----------
C  $Id$
C----------
C
C     CLIMATE EXTENSION - STORES THE CLIMATE COMMON
C
COMMONS
C
      INCLUDE 'PRGPRM.F77'
      INCLUDE 'CLIMATE.F77'
C
COMMONS
C
      INTEGER MXI,MXR,I
      PARAMETER (MXI=22,MXR=5)
      INTEGER INTS(MXI)
      REAL     WK3(*),REALS(MXR)
      INTEGER IPNT,ILIMIT

      IF (.NOT. LCLIMATE) RETURN
      
      INTS( 1) = NATTRS
      INTS( 2) = NYEARS
      INTS( 3) = IXDD5
      INTS( 4) = IXMTCM
      INTS( 5) = IXMAT
      INTS( 6) = IXMAP
      INTS( 7) = IXMTWM
      INTS( 8) = IXGSP
      INTS( 9) = IXGSDD5
      INTS(10) = IXD100
      INTS(11) = IXMMIN
      INTS(12) = IXDD0
      INTS(13) = IXPSITE
      INTS(14) = NESPECIES
      INTS(15) = JCLREF
      INTS(16) = IDEmtwm
      INTS(17) = IDEmtcm
      INTS(18) = IDEdd5
      INTS(19) = IDEsdi
      INTS(20) = IDEdd0
      INTS(21) = IDEmapdd5
      INTS(22) = 0
      IF (LAESTB) INTS(22)=1
      CALL IFWRIT (WK3,IPNT,ILIMIT,INTS,MXI,2)
      CALL IFWRIT (WK3,IPNT,ILIMIT,INDXSPECIES,MAXSP,2)
      CALL IFWRIT (WK3,IPNT,ILIMIT,YEARS,NYEARS,2)

      REALS( 1) = AESNTREES
      REALS( 2) = AESTOCK
      REALS( 3) = CLMXDENMULT
      REALS( 4) = MXDENMLT
      REALS( 5) = CLHABINDX
      CALL BFWRIT (WK3,IPNT,ILIMIT,REALS,MXR,2)       
      CALL BFWRIT (WK3,IPNT,ILIMIT,CLGROWMULT,MAXSP,2)
      CALL BFWRIT (WK3,IPNT,ILIMIT,CLMRTMLT1,MAXSP,2)
      CALL BFWRIT (WK3,IPNT,ILIMIT,CLMRTMLT2,MAXSP,2)
      DO I=1,NATTRS
        CALL BFWRIT (WK3,IPNT,ILIMIT,ATTRS(1,I),NYEARS,2)
      ENDDO
      CALL BFWRIT (WK3,IPNT,ILIMIT,POTESTAB,MAXSP,2)
      CALL BFWRIT (WK3,IPNT,ILIMIT,SPMORT1,MAXSP,2)
      CALL BFWRIT (WK3,IPNT,ILIMIT,SPMORT2,MAXSP,2)
      CALL BFWRIT (WK3,IPNT,ILIMIT,SPGMULT,MAXSP,2)
      CALL BFWRIT (WK3,IPNT,ILIMIT,SPSITGM,MAXSP,2)
      CALL BFWRIT (WK3,IPNT,ILIMIT,SPVIAB,MAXSP,2)
      CALL BFWRIT (WK3,IPNT,ILIMIT,SPCALIB,MAXSP,2)
      
      RETURN
      END

      SUBROUTINE CLGET (WK3,IPNT,ILIMIT)
      IMPLICIT NONE
C
C     CLIMATE EXTENSION - GETS THE CLIMATE COMMON
C
COMMONS
C
      INCLUDE 'PRGPRM.F77'
      INCLUDE 'CLIMATE.F77'
C
COMMONS
C
      INTEGER MXI,MXR,I
      PARAMETER (MXI=22,MXR=5)
      INTEGER INTS(MXI)
      REAL     WK3(*),REALS(MXR)
      INTEGER IPNT,ILIMIT

      IF (.NOT. LCLIMATE) RETURN

      CALL IFREAD (WK3,IPNT,ILIMIT,INTS,MXI,2)
      NATTRS     = INTS( 1) 
      NYEARS     = INTS( 2) 
      IXDD5      = INTS( 3) 
      IXMTCM     = INTS( 4) 
      IXMAT      = INTS( 5) 
      IXMAP      = INTS( 6) 
      IXMTWM     = INTS( 7) 
      IXGSP      = INTS( 8) 
      IXGSDD5    = INTS( 9) 
      IXD100     = INTS(10) 
      IXMMIN     = INTS(11) 
      IXDD0      = INTS(12) 
      IXPSITE    = INTS(13) 
      NESPECIES  = INTS(14) 
      JCLREF     = INTS(15) 
      IDEmtwm    = INTS(16) 
      IDEmtcm    = INTS(17) 
      IDEdd5     = INTS(18) 
      IDEsdi     = INTS(19) 
      IDEdd0     = INTS(20) 
      IDEmapdd5  = INTS(21) 
      LAESTB = INTS(22).EQ.1
      CALL IFREAD (WK3,IPNT,ILIMIT,INDXSPECIES,MAXSP,2)
      CALL IFREAD (WK3,IPNT,ILIMIT,YEARS,NYEARS,2)
      
      CALL BFREAD (WK3,IPNT,ILIMIT,REALS,MXR,2)
      AESNTREES   = REALS( 1)
      AESTOCK     = REALS( 2)
      CLMXDENMULT = REALS( 3)
      MXDENMLT    = REALS( 4)
      CLHABINDX   = REALS( 5)
      CALL BFREAD (WK3,IPNT,ILIMIT,CLGROWMULT,MAXSP,2)
      CALL BFREAD (WK3,IPNT,ILIMIT,CLMRTMLT1,MAXSP,2)
      CALL BFREAD (WK3,IPNT,ILIMIT,CLMRTMLT2,MAXSP,2)
      DO I=1,NATTRS
        CALL BFREAD (WK3,IPNT,ILIMIT,ATTRS(1,I),NYEARS,2)
      ENDDO
      CALL BFREAD (WK3,IPNT,ILIMIT,POTESTAB,MAXSP,2)
      CALL BFREAD (WK3,IPNT,ILIMIT,SPMORT1,MAXSP,2)
      CALL BFREAD (WK3,IPNT,ILIMIT,SPMORT2,MAXSP,2)
      CALL BFREAD (WK3,IPNT,ILIMIT,SPGMULT,MAXSP,2)
      CALL BFREAD (WK3,IPNT,ILIMIT,SPSITGM,MAXSP,2)
      CALL BFREAD (WK3,IPNT,ILIMIT,SPVIAB,MAXSP,2)
      CALL BFREAD (WK3,IPNT,ILIMIT,SPCALIB,MAXSP,2)
      
      RETURN
      END
             
      
      SUBROUTINE CLACTV(L)
C
      INCLUDE 'PRGPRM.F77'
      INCLUDE 'CLIMATE.F77'
C
      LOGICAL L
      L = LCLIMATE
      RETURN
      ENTRY CLSETACTV(L)
      LCLIMATE = L
      RETURN
      END
