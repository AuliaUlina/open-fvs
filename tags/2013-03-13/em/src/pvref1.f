      SUBROUTINE PVREF1 (KARD2,LPVCOD,LPVREF)
C----------
C  **PVREF1--EM   DATE OF LAST REVISION: 02/04/11
C----------
C
C     MAPS PV/REFERENCE CODES INTO A FVS HABITAT/ECOCLASS CODE
C     CALLED FROM **HABTYP** WHEN CPVREF IS GREATER THAN ZERO
C
C     INPUT VARIABLES
C     KARD2          - FIELD 2 OF STDINFO KEYWORD
C     CPVREF         - FIELD 7 OF STDINFO KEYWORD
C                    - ALSO CARRIED IN PLOT.F77
C
C     RETURN VARIABLES
C     KARD2          - MAPPED FVS HABITAT/ECOCLASS CODE
C
C     INTERNAL VARIABLES
C     PVCODE,PVREF   - ARRAYS OF PV CODE/REFERENCE CODE COMBINATIONS
C                      FROM FSVEG DATA BASE
C     HABPVR         - FVS HABITAT/ECOCLASS CODE CORRESPONDING TO
C                      PV CODE/REFERENCE CODE COMBINATION
C----------
      IMPLICIT NONE
COMMONS
C
      INCLUDE 'PRGPRM.F77'
C
      INCLUDE 'PLOT.F77'
C
C  DECLARATIONS
C
      INTEGER      I,NCODES
      PARAMETER    (NCODES=610)
      CHARACTER*10 PVREF(NCODES),PVCODE(NCODES),KARD2
      CHARACTER*10 HABPVR(NCODES)
      LOGICAL      LPVCOD,LPVREF
C
C  DATA STATEMENTS
C
      DATA (HABPVR(I),I=   1,  60)/
     &'91        ','91        ','10        ','10        ',
     &'91        ','91        ','92        ','92        ',
     &'93        ','93        ','93        ','93        ',
     &'65        ','95        ','95        ','70        ',
     &'74        ','74        ','74        ','74        ',
     &'79        ','79        ','70        ','65        ',
     &'65        ','74        ','91        ','91        ',
     &'92        ','93        ','93        ','95        ',
     &'10        ','100       ','100       ','100       ',
     &'100       ','100       ','100       ','100       ',
     &'100       ','100       ','100       ','100       ',
     &'100       ','110       ','110       ','110       ',
     &'120       ','120       ','130       ','130       ',
     &'130       ','130       ','140       ','140       ',
     &'140       ','140       ','141       ','141       '/
      DATA (HABPVR(I),I=  61, 120)/
     &'141       ','141       ','141       ','141       ',
     &'161       ','161       ','161       ','161       ',
     &'161       ','161       ','161       ','161       ',
     &'161       ','170       ','170       ','170       ',
     &'170       ','171       ','171       ','171       ',
     &'172       ','172       ','172       ','180       ',
     &'180       ','180       ','181       ','181       ',
     &'181       ','182       ','182       ','182       ',
     &'182       ','182       ','182       ','182       ',
     &'182       ','200       ','200       ','200       ',
     &'200       ','200       ','210       ','210       ',
     &'210       ','210       ','220       ','220       ',
     &'220       ','220       ','230       ','230       ',
     &'230       ','200       ','200       ','200       ',
     &'200       ','250       ','250       ','250       '/
      DATA (HABPVR(I),I= 121, 180)/
     &'250       ','260       ','260       ','260       ',
     &'260       ','261       ','261       ','261       ',
     &'261       ','262       ','262       ','262       ',
     &'262       ','262       ','262       ','200       ',
     &'200       ','200       ','280       ','280       ',
     &'280       ','280       ','281       ','281       ',
     &'281       ','282       ','282       ','282       ',
     &'283       ','283       ','283       ','290       ',
     &'290       ','290       ','291       ','291       ',
     &'291       ','292       ','292       ','292       ',
     &'293       ','293       ','293       ','200       ',
     &'310       ','310       ','310       ','310       ',
     &'311       ','311       ','311       ','312       ',
     &'312       ','312       ','313       ','313       ',
     &'313       ','320       ','320       ','320       '/
      DATA (HABPVR(I),I= 181, 240)/
     &'320       ','321       ','321       ','321       ',
     &'322       ','322       ','322       ','322       ',
     &'323       ','323       ','323       ','323       ',
     &'323       ','323       ','323       ','323       ',
     &'330       ','330       ','330       ','330       ',
     &'340       ','340       ','340       ','340       ',
     &'350       ','350       ','350       ','360       ',
     &'360       ','360       ','360       ','360       ',
     &'360       ','370       ','370       ','370       ',
     &'371       ','371       ','371       ','200       ',
     &'200       ','400       ','400       ','400       ',
     &'410       ','410       ','410       ','410       ',
     &'410       ','410       ','410       ','410       ',
     &'410       ','410       ','410       ','410       ',
     &'430       ','430       ','430       ','440       '/
      DATA (HABPVR(I),I= 241, 300)/
     &'440       ','440       ','450       ','450       ',
     &'450       ','460       ','460       ','460       ',
     &'461       ','461       ','461       ','461       ',
     &'461       ','461       ','470       ','470       ',
     &'470       ','470       ','470       ','400       ',
     &'480       ','480       ','480       ','591       ',
     &'591       ','591       ','591       ','591       ',
     &'591       ','591       ','591       ','591       ',
     &'591       ','591       ','591       ','591       ',
     &'591       ','591       ','591       ','591       ',
     &'591       ','591       ','591       ','591       ',
     &'591       ','591       ','591       ','591       ',
     &'591       ','591       ','591       ','591       ',
     &'591       ','591       ','591       ','591       ',
     &'591       ','591       ','591       ','591       '/
      DATA (HABPVR(I),I= 301, 360)/
     &'591       ','591       ','591       ','591       ',
     &'591       ','591       ','591       ','591       ',
     &'591       ','591       ','591       ','591       ',
     &'591       ','591       ','591       ','591       ',
     &'591       ','591       ','591       ','591       ',
     &'591       ','591       ','591       ','591       ',
     &'591       ','591       ','591       ','591       ',
     &'591       ','591       ','591       ','591       ',
     &'591       ','591       ','591       ','591       ',
     &'591       ','591       ','591       ','591       ',
     &'591       ','591       ','591       ','610       ',
     &'610       ','610       ','610       ','610       ',
     &'610       ','610       ','610       ','620       ',
     &'620       ','620       ','620       ','620       ',
     &'620       ','620       ','620       ','620       '/
      DATA (HABPVR(I),I= 361, 420)/
     &'620       ','620       ','620       ','620       ',
     &'620       ','624       ','624       ','624       ',
     &'624       ','625       ','625       ','625       ',
     &'625       ','630       ','630       ','630       ',
     &'630       ','630       ','632       ','632       ',
     &'632       ','632       ','632       ','632       ',
     &'632       ','632       ','632       ','640       ',
     &'640       ','640       ','640       ','650       ',
     &'650       ','650       ','650       ','651       ',
     &'651       ','651       ','651       ','651       ',
     &'651       ','651       ','653       ','653       ',
     &'653       ','654       ','654       ','654       ',
     &'654       ','655       ','655       ','655       ',
     &'660       ','660       ','660       ','661       ',
     &'661       ','661       ','662       ','662       '/
      DATA (HABPVR(I),I= 421, 480)/
     &'662       ','663       ','663       ','663       ',
     &'670       ','670       ','670       ','670       ',
     &'670       ','670       ','670       ','670       ',
     &'670       ','670       ','670       ','670       ',
     &'670       ','674       ','674       ','674       ',
     &'674       ','674       ','674       ','674       ',
     &'674       ','674       ','674       ','674       ',
     &'674       ','674       ','674       ','674       ',
     &'674       ','674       ','674       ','674       ',
     &'674       ','674       ','674       ','674       ',
     &'674       ','674       ','674       ','674       ',
     &'674       ','674       ','690       ','690       ',
     &'690       ','690       ','691       ','691       ',
     &'691       ','691       ','692       ','692       ',
     &'692       ','692       ','692       ','692       '/
      DATA (HABPVR(I),I= 481, 540)/
     &'692       ','692       ','692       ','692       ',
     &'700       ','700       ','700       ','700       ',
     &'700       ','710       ','710       ','710       ',
     &'710       ','710       ','710       ','710       ',
     &'710       ','710       ','710       ','710       ',
     &'710       ','710       ','720       ','720       ',
     &'720       ','720       ','730       ','730       ',
     &'730       ','730       ','731       ','731       ',
     &'731       ','732       ','732       ','732       ',
     &'733       ','733       ','733       ','740       ',
     &'740       ','740       ','740       ','750       ',
     &'750       ','750       ','750       ','770       ',
     &'770       ','770       ','780       ','780       ',
     &'780       ','790       ','790       ','790       ',
     &'791       ','791       ','791       ','792       '/
      DATA (HABPVR(I),I= 541, 600)/
     &'792       ','792       ','792       ','792       ',
     &'792       ','810       ','810       ','810       ',
     &'820       ','820       ','820       ','830       ',
     &'830       ','830       ','830       ','830       ',
     &'830       ','830       ','832       ','832       ',
     &'832       ','832       ','832       ','832       ',
     &'832       ','832       ','832       ','832       ',
     &'832       ','832       ','832       ','850       ',
     &'850       ','850       ','850       ','860       ',
     &'860       ','860       ','860       ','870       ',
     &'870       ','870       ','870       ','870       ',
     &'870       ','900       ','900       ','900       ',
     &'900       ','910       ','910       ','910       ',
     &'920       ','920       ','920       ','920       ',
     &'920       ','920       ','920       ','930       '/
      DATA (HABPVR(I),I= 601, NCODES)/
     &'930       ','930       ','940       ','940       ',
     &'940       ','940       ','950       ','950       ',
     &'950       ','900       '/
      DATA (PVCODE(I),I=   1,  60)/
     &'000       ','000       ','010       ','010       ',
     &'040       ','040       ','050       ','050       ',
     &'051       ','051       ','052       ','052       ',
     &'065       ','070       ','070       ','070       ',
     &'071       ','072       ','073       ','074       ',
     &'078       ','079       ','080       ','081       ',
     &'084       ','087       ','090       ','091       ',
     &'092       ','093       ','094       ','095       ',
     &'10        ','100       ','100       ','100       ',
     &'100       ','101       ','102       ','103       ',
     &'104       ','105       ','106       ','107       ',
     &'108       ','110       ','110       ','110       ',
     &'120       ','120       ','130       ','130       ',
     &'130       ','130       ','140       ','140       ',
     &'140       ','140       ','141       ','141       '/
      DATA (PVCODE(I),I=  61, 120)/
     &'141       ','142       ','142       ','142       ',
     &'160       ','160       ','160       ','161       ',
     &'161       ','161       ','162       ','162       ',
     &'162       ','170       ','170       ','170       ',
     &'170       ','171       ','171       ','171       ',
     &'172       ','172       ','172       ','180       ',
     &'180       ','180       ','181       ','181       ',
     &'181       ','182       ','182       ','182       ',
     &'183       ','190       ','190       ','190       ',
     &'190       ','200       ','200       ','200       ',
     &'200       ','205       ','210       ','210       ',
     &'210       ','210       ','220       ','220       ',
     &'220       ','220       ','230       ','230       ',
     &'230       ','235       ','240       ','241       ',
     &'242       ','250       ','250       ','250       '/
      DATA (PVCODE(I),I= 121, 180)/
     &'250       ','260       ','260       ','260       ',
     &'260       ','261       ','261       ','261       ',
     &'261       ','262       ','262       ','262       ',
     &'263       ','263       ','263       ','270       ',
     &'271       ','272       ','280       ','280       ',
     &'280       ','280       ','281       ','281       ',
     &'281       ','282       ','282       ','282       ',
     &'283       ','283       ','283       ','290       ',
     &'290       ','290       ','291       ','291       ',
     &'291       ','292       ','292       ','292       ',
     &'293       ','293       ','293       ','300       ',
     &'310       ','310       ','310       ','310       ',
     &'311       ','311       ','311       ','312       ',
     &'312       ','312       ','313       ','313       ',
     &'313       ','320       ','320       ','320       '/
      DATA (PVCODE(I),I= 181, 240)/
     &'320       ','321       ','321       ','321       ',
     &'322       ','322       ','322       ','322       ',
     &'323       ','323       ','323       ','323       ',
     &'324       ','324       ','324       ','325       ',
     &'330       ','330       ','330       ','330       ',
     &'340       ','340       ','340       ','340       ',
     &'350       ','350       ','350       ','360       ',
     &'360       ','360       ','365       ','365       ',
     &'365       ','370       ','370       ','370       ',
     &'380       ','380       ','380       ','381       ',
     &'390       ','400       ','400       ','400       ',
     &'410       ','410       ','410       ','420       ',
     &'420       ','420       ','421       ','421       ',
     &'421       ','422       ','422       ','422       ',
     &'430       ','430       ','430       ','440       '/
      DATA (PVCODE(I),I= 241, 300)/
     &'440       ','440       ','450       ','450       ',
     &'450       ','460       ','460       ','460       ',
     &'461       ','461       ','461       ','462       ',
     &'462       ','462       ','470       ','470       ',
     &'470       ','471       ','472       ','475       ',
     &'480       ','480       ','480       ','500       ',
     &'500       ','500       ','500       ','505       ',
     &'505       ','505       ','506       ','506       ',
     &'506       ','507       ','507       ','507       ',
     &'508       ','508       ','508       ','510       ',
     &'510       ','510       ','510       ','511       ',
     &'511       ','511       ','512       ','512       ',
     &'512       ','515       ','515       ','515       ',
     &'516       ','516       ','516       ','517       ',
     &'517       ','517       ','518       ','518       '/
      DATA (PVCODE(I),I= 301, 360)/
     &'518       ','519       ','519       ','519       ',
     &'520       ','520       ','520       ','520       ',
     &'521       ','521       ','521       ','521       ',
     &'522       ','522       ','522       ','523       ',
     &'523       ','523       ','523       ','524       ',
     &'524       ','524       ','525       ','525       ',
     &'525       ','526       ','526       ','526       ',
     &'529       ','529       ','529       ','590       ',
     &'590       ','590       ','590       ','591       ',
     &'591       ','591       ','591       ','592       ',
     &'592       ','592       ','592       ','600       ',
     &'600       ','600       ','600       ','607       ',
     &'610       ','610       ','610       ','620       ',
     &'620       ','620       ','620       ','621       ',
     &'621       ','621       ','621       ','622       '/
      DATA (PVCODE(I),I= 361, 420)/
     &'622       ','622       ','623       ','623       ',
     &'623       ','624       ','624       ','624       ',
     &'624       ','625       ','625       ','625       ',
     &'625       ','630       ','630       ','630       ',
     &'631       ','632       ','635       ','635       ',
     &'635       ','636       ','636       ','636       ',
     &'637       ','637       ','637       ','640       ',
     &'640       ','640       ','640       ','650       ',
     &'650       ','650       ','650       ','651       ',
     &'651       ','651       ','651       ','652       ',
     &'652       ','652       ','653       ','653       ',
     &'653       ','654       ','654       ','654       ',
     &'654       ','655       ','655       ','655       ',
     &'660       ','660       ','660       ','661       ',
     &'661       ','661       ','662       ','662       '/
      DATA (PVCODE(I),I= 421, 480)/
     &'662       ','663       ','663       ','663       ',
     &'670       ','670       ','670       ','670       ',
     &'671       ','671       ','671       ','672       ',
     &'672       ','672       ','673       ','673       ',
     &'673       ','674       ','674       ','674       ',
     &'675       ','675       ','675       ','676       ',
     &'676       ','676       ','677       ','677       ',
     &'677       ','680       ','680       ','680       ',
     &'680       ','681       ','681       ','681       ',
     &'682       ','682       ','682       ','685       ',
     &'685       ','685       ','686       ','686       ',
     &'686       ','687       ','690       ','690       ',
     &'690       ','690       ','691       ','691       ',
     &'691       ','691       ','692       ','692       ',
     &'692       ','692       ','693       ','693       '/
      DATA (PVCODE(I),I= 481, 540)/
     &'693       ','694       ','694       ','694       ',
     &'700       ','700       ','700       ','701       ',
     &'706       ','710       ','710       ','710       ',
     &'710       ','711       ','711       ','711       ',
     &'712       ','712       ','712       ','713       ',
     &'713       ','713       ','720       ','720       ',
     &'720       ','720       ','730       ','730       ',
     &'730       ','730       ','731       ','731       ',
     &'731       ','732       ','732       ','732       ',
     &'733       ','733       ','733       ','740       ',
     &'740       ','740       ','745       ','750       ',
     &'750       ','750       ','750       ','770       ',
     &'770       ','770       ','780       ','780       ',
     &'780       ','790       ','790       ','790       ',
     &'791       ','791       ','791       ','792       '/
      DATA (PVCODE(I),I= 541, 600)/
     &'792       ','792       ','800       ','800       ',
     &'800       ','810       ','810       ','810       ',
     &'820       ','820       ','820       ','830       ',
     &'830       ','830       ','830       ','831       ',
     &'831       ','831       ','832       ','832       ',
     &'832       ','840       ','840       ','840       ',
     &'840       ','841       ','841       ','841       ',
     &'842       ','842       ','842       ','850       ',
     &'850       ','850       ','850       ','860       ',
     &'860       ','860       ','860       ','870       ',
     &'870       ','870       ','890       ','890       ',
     &'890       ','900       ','900       ','900       ',
     &'900       ','910       ','910       ','910       ',
     &'920       ','920       ','920       ','920       ',
     &'925       ','925       ','925       ','930       '/
      DATA (PVCODE(I),I= 601, NCODES)/
     &'930       ','930       ','940       ','940       ',
     &'940       ','940       ','950       ','950       ',
     &'950       ','960       '/
      DATA (PVREF(I),I=   1,  60)/
     &'101       ','111       ','101       ','199       ',
     &'101       ','111       ','101       ','111       ',
     &'101       ','111       ','101       ','111       ',
     &'199       ','101       ','111       ','199       ',
     &'199       ','199       ','199       ','199       ',
     &'199       ','199       ','199       ','199       ',
     &'199       ','199       ','199       ','199       ',
     &'199       ','199       ','199       ','199       ',
     &'110       ','101       ','110       ','111       ',
     &'199       ','102       ','102       ','102       ',
     &'102       ','102       ','102       ','102       ',
     &'102       ','101       ','111       ','199       ',
     &'111       ','199       ','101       ','110       ',
     &'111       ','199       ','101       ','110       ',
     &'111       ','199       ','101       ','111       '/
      DATA (PVREF(I),I=  61, 120)/
     &'199       ','101       ','111       ','199       ',
     &'101       ','111       ','199       ','101       ',
     &'111       ','199       ','101       ','111       ',
     &'199       ','101       ','110       ','111       ',
     &'199       ','101       ','111       ','199       ',
     &'101       ','111       ','199       ','101       ',
     &'111       ','199       ','101       ','111       ',
     &'199       ','101       ','111       ','199       ',
     &'102       ','102       ','110       ','111       ',
     &'199       ','101       ','110       ','111       ',
     &'199       ','102       ','101       ','110       ',
     &'111       ','199       ','101       ','110       ',
     &'111       ','199       ','101       ','111       ',
     &'199       ','102       ','102       ','102       ',
     &'102       ','101       ','110       ','111       '/
      DATA (PVREF(I),I= 121, 180)/
     &'199       ','101       ','110       ','111       ',
     &'199       ','101       ','110       ','111       ',
     &'199       ','101       ','111       ','199       ',
     &'110       ','111       ','199       ','102       ',
     &'102       ','102       ','101       ','110       ',
     &'111       ','199       ','101       ','111       ',
     &'199       ','101       ','111       ','199       ',
     &'101       ','111       ','199       ','101       ',
     &'111       ','199       ','101       ','111       ',
     &'199       ','101       ','111       ','199       ',
     &'101       ','111       ','199       ','102       ',
     &'101       ','110       ','111       ','199       ',
     &'101       ','111       ','199       ','101       ',
     &'111       ','199       ','101       ','111       ',
     &'199       ','101       ','110       ','111       '/
      DATA (PVREF(I),I= 181, 240)/
     &'199       ','101       ','111       ','199       ',
     &'101       ','110       ','111       ','199       ',
     &'101       ','110       ','111       ','199       ',
     &'101       ','111       ','199       ','199       ',
     &'101       ','110       ','111       ','199       ',
     &'101       ','110       ','111       ','199       ',
     &'101       ','111       ','199       ','101       ',
     &'111       ','199       ','101       ','111       ',
     &'199       ','101       ','111       ','199       ',
     &'101       ','111       ','199       ','102       ',
     &'102       ','101       ','111       ','199       ',
     &'101       ','111       ','199       ','101       ',
     &'111       ','199       ','101       ','111       ',
     &'199       ','101       ','111       ','199       ',
     &'101       ','111       ','199       ','101       '/
      DATA (PVREF(I),I= 241, 300)/
     &'111       ','199       ','101       ','111       ',
     &'199       ','101       ','111       ','199       ',
     &'101       ','111       ','199       ','101       ',
     &'111       ','199       ','101       ','111       ',
     &'199       ','102       ','102       ','102       ',
     &'101       ','111       ','199       ','101       ',
     &'110       ','111       ','199       ','110       ',
     &'111       ','199       ','110       ','111       ',
     &'199       ','110       ','111       ','199       ',
     &'110       ','111       ','199       ','101       ',
     &'110       ','111       ','199       ','110       ',
     &'111       ','199       ','110       ','111       ',
     &'199       ','110       ','111       ','199       ',
     &'110       ','111       ','199       ','110       ',
     &'111       ','199       ','110       ','111       '/
      DATA (PVREF(I),I= 301, 360)/
     &'199       ','110       ','111       ','199       ',
     &'101       ','110       ','111       ','199       ',
     &'101       ','110       ','111       ','199       ',
     &'101       ','111       ','199       ','101       ',
     &'110       ','111       ','199       ','110       ',
     &'111       ','199       ','110       ','111       ',
     &'199       ','110       ','111       ','199       ',
     &'110       ','111       ','199       ','101       ',
     &'110       ','111       ','199       ','101       ',
     &'110       ','111       ','199       ','101       ',
     &'110       ','111       ','199       ','101       ',
     &'110       ','111       ','199       ','102       ',
     &'101       ','111       ','199       ','101       ',
     &'110       ','111       ','199       ','101       ',
     &'110       ','111       ','199       ','101       '/
      DATA (PVREF(I),I= 361, 420)/
     &'111       ','199       ','101       ','111       ',
     &'199       ','101       ','110       ','111       ',
     &'199       ','101       ','110       ','111       ',
     &'199       ','101       ','111       ','199       ',
     &'102       ','102       ','110       ','111       ',
     &'199       ','110       ','111       ','199       ',
     &'110       ','111       ','199       ','101       ',
     &'110       ','111       ','199       ','101       ',
     &'110       ','111       ','199       ','101       ',
     &'110       ','111       ','199       ','110       ',
     &'111       ','199       ','101       ','111       ',
     &'199       ','101       ','110       ','111       ',
     &'199       ','110       ','111       ','199       ',
     &'101       ','111       ','199       ','101       ',
     &'111       ','199       ','101       ','111       '/
      DATA (PVREF(I),I= 421, 480)/
     &'199       ','101       ','111       ','199       ',
     &'101       ','110       ','111       ','199       ',
     &'110       ','111       ','199       ','110       ',
     &'111       ','199       ','110       ','111       ',
     &'199       ','110       ','111       ','199       ',
     &'110       ','111       ','199       ','110       ',
     &'111       ','199       ','110       ','111       ',
     &'199       ','101       ','110       ','111       ',
     &'199       ','110       ','111       ','199       ',
     &'110       ','111       ','199       ','110       ',
     &'111       ','199       ','110       ','111       ',
     &'199       ','110       ','101       ','110       ',
     &'111       ','199       ','101       ','110       ',
     &'111       ','199       ','101       ','110       ',
     &'111       ','199       ','110       ','111       '/
      DATA (PVREF(I),I= 481, 540)/
     &'199       ','110       ','111       ','199       ',
     &'101       ','111       ','199       ','110       ',
     &'102       ','101       ','110       ','111       ',
     &'199       ','110       ','111       ','199       ',
     &'110       ','111       ','199       ','110       ',
     &'111       ','199       ','101       ','110       ',
     &'111       ','199       ','101       ','110       ',
     &'111       ','199       ','101       ','111       ',
     &'199       ','101       ','111       ','199       ',
     &'101       ','111       ','199       ','101       ',
     &'111       ','199       ','102       ','101       ',
     &'110       ','111       ','199       ','101       ',
     &'111       ','199       ','101       ','111       ',
     &'199       ','101       ','111       ','199       ',
     &'101       ','111       ','199       ','101       '/
      DATA (PVREF(I),I= 541, 600)/
     &'111       ','199       ','101       ','111       ',
     &'199       ','101       ','111       ','199       ',
     &'101       ','111       ','199       ','101       ',
     &'110       ','111       ','199       ','101       ',
     &'111       ','199       ','101       ','111       ',
     &'199       ','101       ','110       ','111       ',
     &'199       ','101       ','111       ','199       ',
     &'101       ','111       ','199       ','101       ',
     &'110       ','111       ','199       ','101       ',
     &'110       ','111       ','199       ','101       ',
     &'111       ','199       ','101       ','111       ',
     &'199       ','101       ','110       ','111       ',
     &'199       ','101       ','111       ','199       ',
     &'101       ','110       ','111       ','199       ',
     &'110       ','111       ','199       ','101       '/
      DATA (PVREF(I),I= 601, NCODES)/
     &'111       ','199       ','101       ','110       ',
     &'111       ','199       ','101       ','111       ',
     &'199       ','102       '/
C----------
C  MAP PV/REFERENCE CODES INTO A FVS HABITAT/ECOCLASS CODE
C  REMOVE DECIMAL FROM KARD2 IF PRESENT
C----------
      DO I= 10, 1, -1
        IF (KARD2(I:I) .EQ. '.') THEN
          KARD2=KARD2
          KARD2(I:)=' '    
          GO TO 10
        END IF
      END DO
   10 CONTINUE
      KODTYP=0
      DO I=1,NCODES
      IF((ADJUSTL(PVCODE(I)).EQ.ADJUSTL(KARD2)).AND.(ADJUSTL(PVREF(I))
     &   .EQ.ADJUSTL(CPVREF)))THEN
        READ(HABPVR(I),'(I4)') KODTYP
        LPVCOD=.TRUE.
        LPVREF=.TRUE.
        EXIT
      ENDIF
      IF(ADJUSTL(PVCODE(I)).EQ.ADJUSTL(KARD2))LPVCOD=.TRUE.
      IF(ADJUSTL(PVREF(I)).EQ.ADJUSTL(CPVREF))LPVREF=.TRUE.
      ENDDO
C
      RETURN
      END