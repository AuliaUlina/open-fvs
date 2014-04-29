      SUBROUTINE GROHED (IUNIT)
      IMPLICIT NONE
C----------
C  **GROHED -- PN   DATE OF LAST REVISION:  10/13/11
C $Id: grohed.f 253 2012-10-09 22:20:37Z jdh $
C $Revision: 253 $
C $Date: 2012-10-09 15:20:37 -0700 (Tue, 09 Oct 2012) $
C $HeadURL: https://www.forestinformatics.com/svn/fvs/trunk/cacor/src/grohed.f $
C----------
C     WRITES HEADER FOR BASE MODEL PORTION OF PROGNOSIS SYSTEM
C
      CHARACTER DAT*10,TIM*8,VVER*7,DVVER*7,REV*10,SVN*4
      INTEGER IUNIT
      DATA DVVER/'CA     '/
      INCLUDE 'INCLUDESVN.F77'
C----------
C     CALL REVISE TO GET THE LATEST REVISION DATE FOR THIS VARIANT.
C----------
      CALL REVISE (DVVER,REV)
C
C     CALL THE DATE AND TIME ROUTINE FOR THE HEADING.
C
      CALL GRDTIM (DAT,TIM)
C
C     CALL PPE TO CLOSE OPTION TABLE IF IT IS OPEN.
C
      CALL PPCLOP (IUNIT)
C
      WRITE (IUNIT,40) SVN,REV,DAT,TIM

C----------
C  ORGANON: CHANGE THE PAGE TITLE TO INCLUDE 
C     THE ORGANON BETA RELEASE
C----------
C   40 FORMAT ('1',T10,'FOREST VEGETATION SIMULATOR',
C     >  5X,'VERSION ',A,' -- PACIFIC NW COAST PROGNOSIS',
C     >  T97,'RV:',A,T112,A,2X,A)

   40 FORMAT ('1',T10,'FOREST VEGETATION SIMULATOR',
     >  5X,'VERSION ',A,' -- ORGANON BETA RELEASE     ',
     >  T97,'RV:',A,T112,A,2X,A)

      RETURN
C
C
      ENTRY VARVER (VVER)
C
C     SUPPLY THE VARIANT AND VERSION NUMBER.
C
      VVER=DVVER
      RETURN
      END
