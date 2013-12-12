      SUBROUTINE DBSEXECSQL (SQLCMD,ConnHndl,LSCHED,IRC)
      IMPLICIT NONE
C
C $Id$
C
C
C     AUTH: D. GAMMEL -- RMRS -- MAY 2003
C     PURPOSE: EXECUTES USER DEFINED QUERIES UPON OPENED
C              DATABASE CONNECTIONS
C     INPUT: SQLCMD   - SQL COMMAND QUERY TO BE EXECUTED
C            ConnHndl - THE CONNECTION HANDLE TO THE DBMS
C            LSCHED   - SPECIFIES WHETHER THIS IS COMING FROM THE EVENT
C                       MONITOR
COMMONS
C
C
      INCLUDE  'PRGPRM.F77'
C
C
      INCLUDE  'CONTRL.F77'
C
C
      INCLUDE  'OPCOM.F77'
C
C
      INCLUDE  'PLOT.F77'
C
C
      INCLUDE  'DBSCOM.F77'
C
COMMONS

      CHARACTER*(*) SQLCMD
      CHARACTER*20   ColName
      INTEGER(SQLSMALLINT_KIND) ColumnCount,NameLen,ColNumber
      INTEGER(SQLINTEGER_KIND)::LI(MXTST5)
      INTEGER(SQLHDBC_KIND):: ConnHndl
      INTEGER(SQLHSTMT_KIND):: StmtHndl
      INTEGER(SQLRETURN_KIND):: rsSQLRet
      INTEGER KODE,I,INDX(MXTST5),IBound,IOPKD
      REAL SQLDATA(MXTST5)
      LOGICAL      LSCHED
      INTEGER IRC

      IRC = 1

C     MAKE SURE WE HAVE AN OPEN CONNECTION
      IF(ConnHndl.EQ.-1) RETURN

C     PARSE OUT AND REPLACE WITH USER DEFINED AND EVENT MONITOR VAR VALS
      CALL DBSPRSSQL(SQLCMD,LSCHED,KODE)
      IF(KODE.EQ.0) THEN
C       THERE WAS A PROBLEM IN PARSING THE SQL STATEMENT
        WRITE (JOSTND,110) TRIM(SQLCMD)
  110 FORMAT (/'********   ERROR: SQLOUT/SQLIN PARSING FAILED. '
     &            'SQL STMT: ',A)
        CALL RCDSET(2,.TRUE.)
        RETURN
      ENDIF

C     ALLOCATE A STATEMENT HANDLE

      iRet = fvsSQLAllocHandle(SQL_HANDLE_STMT,ConnHndl,
     -                       StmtHndl)
      IF (iRet.NE.SQL_SUCCESS .AND.
     -  iRet.NE. SQL_SUCCESS_WITH_INFO) THEN
        CALL  DBSDIAGS(SQL_HANDLE_DBC,ConnHndl,
     -         'DBSEXEC:DSN Connection')
      ELSE
C       EXECUTE QUERY
        iRet = fvsSQLExecDirect(StmtHndl,trim(SQLCMD),
     -            int(len_trim(SQLCMD),SQLINTEGER_KIND))
        IF (iRet.NE.SQL_SUCCESS .AND.
     -    iRet.NE. SQL_SUCCESS_WITH_INFO) THEN
          CALL DBSDIAGS(SQL_HANDLE_STMT,StmtHndl,
     -        'DBSEXEC:Executing SQL KeyWrd: '//trim(SQLCMD))
          WRITE (JOSTND,120) trim(SQLCMD)
  120     FORMAT ('SQL STMT: ',A)
          GOTO 500
        ENDIF
C
C       IF THIS IS A SELECT QUERY THEN MAKE NEEDED UPDATES TO VARIABLES
C
        iRet = fvsSQLNumResultCols(StmtHndl,ColumnCount)

        IF(ColumnCount.GT.0) THEN
C
C         DETERMINE THE KEWORD AND EDIT THE APPROPRIATE VARIABLE
C
         IBound = 0
          DO ColNumber = 1,ColumnCount
C           GET COLUMN NAME
            iRet = fvsSQLColAttribute(StmtHndl, ColNumber,
     -                        SQL_DESC_NAME, ColName,
     -                        NameLen)
C
C          UPPER CASE THE COLUMN NAME FOR EASIER COMPARISONS
C
            DO I = 1, LEN_TRIM(ColName)
              CALL UPCASE(ColName(I:I))
            END DO
            CALL ALGKEY(ColName,LEN_TRIM(ColName),IOPKD,IRET)
            IF(IRET.EQ.0 .AND. IOPKD.GT.500 .AND. IOPKD.LT.700) THEN
              IBound = IBound + 1
              LI(IBound)=SQL_NULL_DATA
C             FOUND THE EVMON VARIABLE INDEX
              INDX(IBound) = IOPKD - 500
C             THE VALUE IS DEFINED SO BIND VALUE TO SQL DATA ARRAY
              iRet = fvsSQLBindCol (StmtHndl,ColNumber,SQL_F_FLOAT,
     -             SQLDATA(IBound),loc(LI(IBound)),rsSQLRet)
            ENDIF
          END DO
C         FETCH THE FIRST ROW OF DATA FROM THE QUERY
          iRet = fvsSQLFetch (StmtHndl, rsSQLRet)
          IF (rsSQLRet.EQ.SQL_SUCCESS .OR.
     -        rsSQLRet.EQ.SQL_SUCCESS_WITH_INFO) THEN
             DO I = 1, IBound
C              IF THE FETCH RETURNED NULL THEN SET EVMON VAR TO UNDEFINED
               IF(LI(I).EQ.SQL_NULL_DATA) THEN
                 TSTV5(INDX(I)) = 0
                 LTSTV5(INDX(I)) = .FALSE.
               ELSE
                 TSTV5(INDX(I)) = SQLDATA(I)
                 LTSTV5(INDX(I)) = .TRUE.
               ENDIF
               IRC=0
             END DO
          ENDIF
        ELSE
          IRC=0
        ENDIF
      ENDIF
      !make sure transactions are committed
      iRet = fvsSQLEndTran(SQL_HANDLE_DBC, ConnHndl, SQL_COMMIT)

 500  CONTINUE
C     FREE HANDLE BEFORE LEAVING
      iRet = fvsSQLFreeHandle(SQL_HANDLE_STMT, StmtHndl)
      RETURN
      END