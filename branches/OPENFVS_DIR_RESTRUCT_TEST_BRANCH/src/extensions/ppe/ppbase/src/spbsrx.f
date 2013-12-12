      SUBROUTINE SPBSRX (N,A,IORD,F,IMID)
      IMPLICIT NONE
C----------
C  **SPBSRX--PPBASE   DATE OF LAST REVISION:  07/31/08
C----------
C
C     FINDS F IN A.  RETURNS IMID=0 IF F IS NOT IN A.  IF F IS IN
C     A IMID POINTS TO A LOCATION IN IORD.  IORD(IMID) POINTS TO
C     THEN LOCATION IN A WHERE F IS LOCATED.
C
C     N    = THE LENGTH OF A.
C     A    = A LIST OF CHARACTER*8 NUMBERS.
C     IORD = AN ARRAY OF KEYS SORTED IN ASCENDING ORDER OVER A.
C     F    = A CHARACTER*8 NUMBER WHICH YOU WISH TO FIND IN A.
C     IMID = SEE ABOVE.
C
      INTEGER IMID,N,I1,IN,ITOP,IBOT,IM,IB,IT
      CHARACTER*26 A(N),F
      INTEGER IORD(N)
      IMID=1
      I1=IORD(1)
C
C     IF THE VALUE WE SEARCH FOR IS LESS THAN THE SMALLEST VALUE IN THE
C     ARRAY, TERMINATE THE SEARCH.
C
      IF (F.LE.A(I1)) GOTO 40
      IMID=N
      IN=IORD(N)
C
C     IF THE VALUE WE SEARCH FOR IS GREATER THAN THE LARGEST VALUE IN
C     THE ARRAY, TERMINATE THE SEARCH.
C
      IF (F.GE.A(IN)) GOTO 40
C
C     INITIALIZE THE TOP AND BOTTOM OF THE SEARCH PARTITION TO THE TOP
C     BOTTOM OF THE ARRAY.
C
      ITOP=1
      IBOT=N
C
C     TEST THE MIDDLE VALUE OF THE PARTITION
C
   20 CONTINUE
      IMID=(IBOT+ITOP)/2
      IM=IORD(IMID)
C
C     IF THE MIDDLE VALUE IS GREATER THAN OR EQUAL TO THE SEARCH VALUE,
C     SET THE TOP OF THE PARTITION TO THE MIDDLE VALUE PLUS ONE.
C
      IF (F.GT.A(IM)) GOTO 30
C
C     IF THE MIDDLE VALUE IS LESS THAN WHAT WE SEARCH FOR, SET THE
C     BOTTOM OF THE PARTITION TO THE MIDDLE VALUE MINUS ONE.
C
      IBOT=IMID-1
      IB=IORD(IBOT)
C
C     IF THE VALUE OF THE BOTTOM OF THE PARTITION IS GREATER THAN OR
C     EQUAL TO THE SEARCH VALUE, TERMINATE.
C
      IF (F.GT.A(IB)) GOTO 40
C
C     RESEARCH THE PARTITION.
C
      GOTO 20
C
C     SET THE TOP OF THE PARTITION TO THE MIDDLE VALUE PLUS ONE.
C
   30 CONTINUE
      ITOP=IMID+1
      IT=IORD(ITOP)
C
C     IF THE VALUE OF THE TOP OF THE PARTITION IS LESS THAN OR EQUAL
C     TO THE SEARCH VALUE, TERMINATE.
C
      IF (F.LT.A(IT)) GOTO 40
C
C     RESEARCH THE PARTITION.
C
      GOTO 20
C
C     THIS IS THE EXIT POINT FOR THE ROUTINE.  IF WE GOT HERE, WE
C     EITHER FOUND THE SEARCH VALUE AS THE MIDDLE OF A PARTITION,
C     OR PARTITIONED TO THE POINT WHERE THE SEARCH VALUE COULD
C     NOT BE CONTAINED IN THE PARTITION.  AT THIS POINT, WE DONT KNOW
C     WHICH SO WE MAKE A FINAL CHECK, AND RETURN ZERO IF NOT FOUND.
C
   40 CONTINUE
      IF (F.NE.A(IORD(IMID))) IMID=0
      RETURN
      END