      BLOCK DATA KEYWDS
      IMPLICIT NONE
C----------
C  $Id$
C----------
C
C     SEE **MAIN** FOR DICTIONARY OF VARIABLE NAMES.
C
C     DATA STATEMENT FOR TABLE OF KEYWORDS
C
COMMONS
C
C
      INCLUDE 'KEYCOM.F77'
C
      INTEGER I
C
COMMONS
C
      DATA (TABLE(I),I=1,20) /
     >     'PROCESS','TIMEINT','FIXCW','TREEDATA','TREEFMT','MPB',
     >     'DFTM','WSBW','CWEQN','DESIGN','NUMCYCLE','TFIXAREA',
     >     'GROWTH','STDINFO','STDIDENT','INVYEAR','TREELIST',
     >     'REWIND','NOSUM','DEBUG'/
      DATA (TABLE(I),I=21,40) /
     >     'ECHOSUM','ADDFILE','THINAUTO','THINBTA','THINATA',
     >     'THINBBA','THINABA','THINPRSC','THINDBH','SALVAGE',
     >     'SPLABEL','AGPLABEL','COMPUTE','FERTILIZ','THINHT',
     >     'STATS','TOPKILL','HTGSTOP','MCFDLN','BFFDLN'/
      DATA (TABLE(I),I=41,60) /
     >     'MCDEFECT','BFDEFECT','VOLUME','BFVOLUME','REGDMULT',
     >     'COVER','ESTAB','MINHARV','SPECPREF','SPCODES','NODEBUG',
     >     'CUTEFF','NOTRIPLE','READCORD','REUSCORD','NOCALIB',
     >     'DGSTDEV','BAIMULT','MORTMULT','NOHTDREG'/
      DATA (TABLE(I),I=61,80) /
     >     'RANNSEED','HTGMULT','CHEAPO','NUMTRIP','ENDFILE','BAMAX',
     >     'READCORH','REUSCORH','MGMTID','REGHMULT','TCONDMLT',
     >     'NOAUTOES','READCORR','REUSCORR','BRUST','IF','SCREEN',
     >     'COMPRESS','THEN','ALSOTRY'/
      DATA (TABLE(I),I=81,100) /
     >     'ENDIF', 'NOTREES', 'CALBSTAT','OPEN','CLOSE','NOSCREEN',
     >     'RRIN','FIXMORT','SDIMAX','DELOTAB','SERLCORR','CUTLIST',
     >     'RESETAGE','SITECODE','MISTOE','CRNMULT','CFVOLEQU',
     >     'BFVOLEQU','ANIN','DFB'/
      DATA (TABLE(I),I=101,120) /
     >     'RDIN','MANAGED','YARDLOSS','FMIN','STRCLASS','MODTYPE',
     >     'FVSSTAND','PRUNE','SVS','FIXDG','FIXHTG','THINSDI',
     >     'LOCATE','BGCIN','THINCC','ECON','DATABASE',
     >     'SYSTEM','DEFECT','CRUZFILE'/
      DATA (TABLE(I),I=121,135) /
     >     'STANDCN','THINMIST','TREESZCP','THINRDEN','SPGROUP ',
     >     'BMIN','DATASCRN','SETPTHIN','THINPT','VOLEQNUM',
     >     'POINTREF','ECHO','NOECHO','CYCLEAT','ATRTLIST'/
      DATA (TABLE(I),I=136,150) /
     >     'THINRDSL','MORTMSB','SETSITE','CLIMATE','SDICALC',
     >     'THINQFA','ORGANON','        ','        ','        ',
     >     '        ','         ','        ','        ','        '/
      END
