      SUBROUTINE SPNBEX (CIDS,NCIDS,ISRT,IRC)
      IMPLICIT NONE
C----------
C  **SPNBEX--PPBASE   DATE OF LAST REVISION:  07/31/08
C----------
C     EXTRACTS, OR MAKES READY, THE NEIGHBORS DATA SO THAT
C     SUBROUTINES SPNBBD AND SPNBED CAN EFFECTIENTLY ACCESS IT.
C
C     CIDS  = A LIST OF IDS FOR WHICH NEIGHBORS DATA WILL BE EXTRACTED.
C             CALLS TO SPNBBD WILL BE MADE USING SUBSCRIPS OF CIDS.
C     NCIDS = THE LENGTH OF CIDS.
C     ISRT  = AN INDEX SORTED LIST ON CIDS (ISRT(1) POINTS TO THE
C             SMALLEST CIDS, ISRT(2) TO THE NEXT SMALLEST...ETC)
C     IRC   = RETURN CODE, 0=OK, 1=NO NEIGHBORS DATA, 2=SOME STANDS
C             DON'T HAVE NEIGHBORS, 3=NO IDS IN CIDS.
COMMONS
C
C
      INCLUDE 'PRGPRM.F77'
C
C
      INCLUDE 'PPEPRM.F77'
C
C
      INCLUDE 'PPSPNB.F77'
C
C
COMMONS
C
      CHARACTER*26 TID,CIDS(NCIDS)
      INTEGER ISRT(NCIDS),IRC,NCIDS,J,I,K,II,ID,IP
C
C     IF THERE ARE NO NEIGHBORS DATA, THEN SET RETURN CODE AND RETURN.
C
      IF (NNBS.LE.0) THEN
         IRC=1
         RETURN
      ENDIF
      IF (NCIDS.LE.0) THEN
         IRC=3
         RETURN
      ENDIF
C
C     SORT THE ALPHANUMERIC LARGEST ID LIST INTO ASCENDING
C     ORDER USING A POINTER SORT.
C
      CALL C26SRT (NNBS,CNBID2,NBORD,.TRUE.)
C
C     CREATE NBID2.
C
      J=1
      DO 20 I=1,NCIDS
      TID=CIDS(ISRT(I))
C
C     IF THE CURRENT STAND ID IS IDENTICAL TO THE PREVIOUS
C     ID, THEN SKIP IT.
C
      IF (I.GT.1) THEN
         IF (TID.EQ.CIDS(ISRT(I-1))) GOTO 20
      ENDIF
   10 CONTINUE
      IF (TID.GT.CNBID2(NBORD(J))) THEN
         NBID2(NBORD(J))=0
         J=J+1
         IF (J.GT.NNBS) GOTO 30
         GOTO 10
      ELSE
         IF (TID.EQ.CNBID2(NBORD(J))) THEN
            NBID2(NBORD(J))=ISRT(I)
            J=J+1
            IF (J.GT.NNBS) GOTO 30
            GOTO 10
         ENDIF
      ENDIF
   20 CONTINUE
   30 CONTINUE
C
C     SORT THE LIST OF ALPHANUMERIC SMALLEST IDS INTO ASCENDING ORDER
C
      CALL C26SRT (NNBS,CNBID1,NBORD,.FALSE.)
C
C     LOAD EDGE.
C
      DO 35 I=1,NCIDS
      EDGE(I)=0.0
   35 CONTINUE
      DO 40 I=1,NNBS
      J=NBID2(I)
      IF (J.GT.0) EDGE(J)=EDGE(J)+BORDER(I)
   40 CONTINUE
      J=1
      DO 50 I=1,NCIDS
      TID=CIDS(ISRT(I))
C
C     IF THE CURRENT ID IS EQUAL TO THE LAST ID, SET THE EDGE
C     FOR THE CURRENT ID EQUAL TO THE EDGE OF THE LAST.
C
      IF (I.GT.1) THEN
         IF (TID.EQ.CIDS(ISRT(I-1))) THEN
            EDGE(ISRT(I))=EDGE(ISRT(I-1))
            GOTO 50
         ENDIF
      ENDIF
   45 CONTINUE
      K=NBORD(J)
      IF (TID.GT.CNBID1(K)) THEN
         J=J+1
         IF (J.GT.NNBS) GOTO 60
         GOTO 45
      ELSE
         IF (TID.EQ.CNBID1(K)) THEN
            EDGE(ISRT(I))=EDGE(ISRT(I))+BORDER(K)
            J=J+1
            IF (J.GT.NNBS) GOTO 60
            GOTO 45
         ENDIF
      ENDIF
   50 CONTINUE
   60 CONTINUE
C
C     LOAD KEYLST.
C
      K=0
      DO 110 II=1,NCIDS
      ID=ISRT(II)
C
C     IF THE CURRENT ID IS EQUAL TO THE LAST ONE, SET THE SECOND
C     COLUMN OF KEYLST SO THAT ITS ABSOLUTE VALUE POINTS TO THE
C     FIRST OCCURANCE OF THIS ID.
C
      IF (K.GT.0) THEN
         IF (CIDS(ID).EQ.CIDS(ISRT(II-K))) THEN
            KEYLST(ID,1)=MXNBS
            KEYLST(ID,2)=-ISRT(II-K)
            K=K+1
            GOTO 110
         ENDIF
      ELSE
         K=1
      ENDIF
C
C     FIND THE ID IN CNBID1
C
      CALL SPBSRX (NNBS,CNBID1,NBORD,CIDS(ID),IP)
C
C     IF THE ID IS IN NBORD (AND THERE IS NO REAL REASON TO EXPECT
C     THAT IT MUST BE), THEN:
C
      IF (IP.GT.0) THEN
C
C        SEARCH FOR THE FIRST OCCURRENCE OF THE ID IN CNBID1.
C
         I=IP
         DO 70 J=I,1,-1
         IF (CNBID1(NBORD(J)).NE.CIDS(ID)) GOTO 80
         IP=J
   70    CONTINUE
   80    CONTINUE
         KEYLST(ID,1)=IP
C
C        COUNT UP THE NUMBER OF ENTRIES.
C
         I=0
         DO 90 J=IP,NNBS
         IF (CNBID1(NBORD(J)).NE.CIDS(ID)) GOTO 100
         I=I+1
   90    CONTINUE
  100    CONTINUE
         KEYLST(ID,2)=KEYLST(ID,1)+I-1
      ELSE
C
C        LOAD CORRESPONDING ENTRIES OF KEYLST.
C
         KEYLST(ID,1)=MXNBS
         KEYLST(ID,2)=0
      ENDIF
  110 CONTINUE
C
C     REMOVE ENTRIES WHERE 2 OR MORE LINE SEGMENTS ARE USED TO
C     BORDER THE SAME 2 IDS.
C
      IF (NCIDS.EQ.1) GOTO 160
      DO 150 ID=1,NCIDS-1
      K=KEYLST(ID,1)
      IF (K.GE.MXNBS .OR. K.EQ.KEYLST(ID,2)) GOTO 150
      DO 140 J=K,KEYLST(ID,2)-1
      IP=NBID2(NBORD(J))
      IF (IP.EQ.0) GOTO 140
      DO 130 I=J+1,KEYLST(ID,2)
      IF (IP.NE.NBID2(NBORD(I))) GOTO 130
      NBID2 (NBORD(I))=0
      BORDER(NBORD(J))=BORDER(NBORD(J))+BORDER(NBORD(I))
      BORDER(NBORD(I))=0.0
  130 CONTINUE
  140 CONTINUE
  150 CONTINUE
  160 CONTINUE
C
      NIDS=NCIDS
      IRC=0
      RETURN
      END