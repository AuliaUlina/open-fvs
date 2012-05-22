      SUBROUTINE COMCUP
      IMPLICIT NONE
C----------
C  **COMCUP--BS  DATE OF LAST REVISION:  01/14/11
C----------
C
C     INTERFACE ROUTINE TO COUPLE THE COMPRESSION ROUTINE TO
C     THE PROGNOSIS MODEL FOR STAND DEVELOPMENT.
C
C     ADDED THE CAPABILITY TO DELETE TREES THAT HAVE ZERO (AND/OR
C     NEAR-ZERO) PROBS...TOTAL REWRITE.  NL CROOKSTON, JUNE 1991.
C
C     N.L. CROOKSTON       INT-MOSCOW     DEC. 1981 & JUNE 1982
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
      INCLUDE 'CONTRL.F77'
C
C
      INCLUDE 'OUTCOM.F77'
C
C
COMMONS
C
      LOGICAL LDEBU,LCMPRS
      INTEGER NDEL,I,NTODO,NPRMS,IACT,IDT,ITARG,IS,IM,MYACT(1),ISPC
      REAL SPCNT(MAXSP,3),PRMS(3),PN1
      REAL SITAGE,SITHT,AGMAX,H,HTMAX,HTMAX2,D1,D2
C
      DATA MYACT/250/
C
C     CHECK FOR DEBUG REQUEST.
C
      CALL DBCHK (LDEBU,'COMCUP',6,ICYC)
C
C     CHECK THE TREELIST FOR ZERO PROBS.  SET UP IND2 IN THE SAME
C     PASS.
C
      LCMPRS= .FALSE.
      NDEL=0
      IF (ITRN.GT.0) THEN
         DO 10 I=1,ITRN
         IF (PROB(I).LE. 1E-5) THEN
            IND2(I)=-I
            NDEL=NDEL+1
         ELSE
            IND2(I)=I
         ENDIF
   10    CONTINUE
      ENDIF
C
C     IF ALL THE TREES HAVE ZERO PROBS, SET ITRN TO ZERO.
C
      IF (NDEL.EQ.ITRN) THEN
         ITRN=0
         IREC1=0
      ENDIF
      IF (LDEBU) WRITE (JOSTND,20) ITRN,NDEL
   20 FORMAT (/' IN COMCUP (TOP): ITRN,NDEL=',2I6)
C
C     IF THERE ARE SOME ZERO PROBS, AND ITRN IS GREATER THAN ZERO,
C     THEN DELETE THEM USING TREDEL.
C
      IF (NDEL.GT.0 .AND. ITRN.GT.0) CALL TREDEL (NDEL,IND2)
C
C     GET THE COMPRESSION REQUEST.
C
      CALL OPFIND (1,MYACT,NTODO)
C
C     IF NTODO IS GT ZERO, THEN:
C
      IF (NTODO .GT. 0) THEN
C
C        GET THE LAST COMPRESSION REQUEST AND DELETE ALL THE OTHERS.
C
         CALL OPGET (NTODO,3,IDT,IACT,NPRMS,PRMS)
         IF (NTODO.GT.1) THEN
            DO 40 I=1,(NTODO-1)
            CALL OPDEL1(I)
   40       CONTINUE
         ENDIF
C
C        SET THE PARAMETERS OF COMPRESSION.
C
         ITARG=IFIX(PRMS(1))
         PN1 = PRMS(2)/100.
C
C        DETERMINE IF COMPRESSION WILL TAKE PLACE AFTER ALL.
C
         LCMPRS = ITARG.LT.ITRN
C
C        WRITE DEBUG MSG, IF REQUESTED.
C
         IF (LDEBU) WRITE (JOSTND,50) ITARG,PN1,LCMPRS
   50    FORMAT (/' IN COMCUP: ITARG,PN1,LCMPRS: ',I5,F8.3,L3)
C
C        IF COMPRESSION IS TO TAKE PLACE; THEN: COMPRESS THE
C        TREE LIST.
C
         IF (LCMPRS) THEN
C
C           FOR THIS CALL TO COMPRS, WK2 MUST BE INITIALIZED
C           TO ZERO.
C
            DO 55 I=1,ITRN
            WK2(I)=0.0
   55       CONTINUE
C
C           COMPRESS THE TREE LIST.
C
            CALL COMPRS (ITARG,PN1)
C
C           SIGNAL THAT COMPRESSION HAS TAKEN PLACE.
C
            CALL OPDONE (NTODO,IY(ICYC))
C
C           SUPPRESS RECORD TRIPLING.
C
            NOTRIP=.TRUE.
C
         ELSE
C
C           SIGNAL OPDEL1.
C
            CALL OPDEL1 (NTODO)
         ENDIF
      ENDIF
C
C     IF COMPRESSION TOOK PLACE, OR IF TREES WITH PROBS OF ZERO,
C     WERE DELETED FROM THE TREELIST, THEN: DO THE FOLLOWING:
C     (NOTE: ALL THIS CAN BE DONE WITH ITRN=0).
C
      IF (LCMPRS.OR.NDEL.GT.0) THEN
C
C        REESTABLISH THE SPECIES-ORDER SORT.
C
         CALL SPESRT
C
C        INITIALIZE SPCNT.
C
         DO I=1,MAXSP
            SPCNT(I,1)=0.
            SPCNT(I,2)=0.
            SPCNT(I,3)=0.
         ENDDO
         IF (ITRN.GT.0) THEN
C
C           RE-COMPUTE THE SPECIES COMPOSITION
C
            DO 70 I=1,ITRN
            IS=ISP(I)
            IM=IMC(I)
            SPCNT(IS,IM)=SPCNT(IS,IM)+PROB(I)
   70       CONTINUE
C
C           REESTABLISH THE DIAMETER SORT.
C
            CALL RDPSRT (ITRN,DBH,IND,.TRUE.)
C
C           RE-COMPUTE THE DISTRIBUTION OF TREES PER ACRE AND
C           SPECIES-TREE CLASS COMPOSITON BY TREES PER ACRE.
C
            CALL PCTILE(ITRN,IND,PROB,WK3,ONTCUR(7))
C----------
C  ESTIMATE MISSING TOTAL TREE AGES
C----------
            DO I=1,ITRN
            IF(ABIRTH(I) .LE. 0.)THEN
              SITAGE = 0.0
              SITHT = 0.0
              AGMAX = 0.0
              HTMAX = 0.0
              HTMAX2 = 0.0
              ISPC = ISP(I)
              D1 = DBH(I)
              H = HT(I)
              D2 = 0.0
              CALL FINDAG(I,ISPC,D1,D2,H,SITAGE,SITHT,AGMAX,HTMAX,
     &                    HTMAX2,LDEBU)
              IF(SITAGE .GT. 0.)ABIRTH(I)=SITAGE
            ENDIF
            ENDDO
C
         ENDIF
C
C        (MAKE SURE IFST=1, TO GET A NEW SET OF POINTERS TO THE
C         DISTRIBUTIONS).
C
         IFST=1
         CALL DIST(ITRN,ONTCUR,WK3)
         CALL COMP(OSPCT,IOSPCT,SPCNT)
C
C        RE-COMPUTE THE STAND DENSITY STATISTICS AND SIGNAL THAT
C        DENSE HAS BEEN COMPUTED.
C
         CALL DENSE
      ENDIF
      IF (LDEBU) WRITE (JOSTND,80) ITRN,NDEL
   80 FORMAT (/' IN COMCUP (BOT): ITRN,NDEL=',2I6)
      RETURN
      END
