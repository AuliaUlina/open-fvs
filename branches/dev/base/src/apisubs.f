c $Id$

c     This is a collection of routines that provide an interface to 
c     the shared library version of FVS. Other routines that exist
c     inside FVS may also be called.

c     Created in late 2011 by Nick Crookston, RMRS-Moscow

      subroutine fvsDimSizes(ntrees,ncycles,nplots,maxtrees,maxspecies,
     -                       maxplots,maxcycles)
      implicit none
      include "PRGPRM.F77"
      include "CONTRL.F77"
      include "PLOT.F77"
      integer :: ntrees,ncycles,nplots,maxtrees,maxspecies,maxplots,
     -           maxcycles
      ntrees    = ITRN
      ncycles   = NCYC
      nplots    = IPTINV
      maxtrees  = MAXTRE
      maxspecies= MAXSP 
      maxplots  = MAXPLT
      maxcycles = MAXCYC
      return
      end

      subroutine fvsSummary(summary,icycle,ncycles,maxrow,maxcol,
     -                      rtnCode)
      implicit none

      include "PRGPRM.F77"
      include "CONTRL.F77"
      include "OUTCOM.F77"
      
      integer :: summary(20),icycle,ncycles,maxrow,maxcol,rtnCode
      
      maxrow = maxcy1
      maxcol = 20
      ncycles = ncyc
      if (icycle <= 0 .or. icycle > ncyc+1) then
        rtnCode = 1
      else
        summary = iosum(:maxcol,icycle)
        rtnCode = 0
      endif
      return
      end    
      
      subroutine fvsTreeAttr(name,nch,action,ntrees,attr,rtnCode)
      implicit none

c     set and/or gets the named tree attributes
c     name    = char string of the variable name,
c     nch     = the number of characters in "name" (case sensitive)
c     action  = char string that is one of "set" or "get" (case sensitive)
c     ntrees  = the number of trees, length of data
c     attr    = a vector of length data, always "double"
c     rtnCode = 0 is OK, 1= "name" not found,
c               2= ntrees is greater than maxtrees, not all data transfered
c               3= there were more/fewer than ntrees.
c
      include "PRGPRM.F77"
      include "ARRAYS.F77"
      include "CONTRL.F77"

      integer :: nch,rtnCode,ntrees
      real(kind=8)      :: attr(ntrees)
      character(len=10) :: name
      character(len=4)  :: action

      name=name(1:nch)
      action=action(1:3)

      rtnCode = 0
      if (ntrees > MAXTRE) then
        attr = 0
        rtnCode = 2
        return
      endif
      if (ntrees /= itrn) then
        attr = 0
        rtnCode = 3
        return
      endif

      select case(name)
      case ("tpa")
        if (action=="get") attr = prob(:itrn)
        if (action=="set") prob(:itrn) = real(attr,4)
      case ("dbh")
        if (action=="get") attr = dbh(:itrn)
        if (action=="set") dbh(:itrn) = real(attr,4)
      case ("dg")
        if (action=="get") attr = dg(:itrn)
        if (action=="set") dg(:itrn) = real(attr,4)
      case ("ht")
        if (action=="get") attr = ht(:itrn)
        if (action=="set") ht(:itrn) = real(attr,4)
      case ("htg")
        if (action=="get") attr = htg(:itrn)
        if (action=="set") htg(:itrn) = real(attr,4)
      case ("crwdth")
        if (action=="get") attr = crwdth(:itrn)
        if (action=="set") ht(:itrn) = real(attr,4)
      case ("cratio")
        if (action=="get") attr = icr(:itrn)
        if (action=="set") icr(:itrn) = int(attr,4)
      case ("species")
        if (action=="get") attr = isp(:itrn)
        if (action=="set") isp(:itrn) = int(attr,4)
      case ("age")
        if (action=="get") attr = abirth(:itrn)
        if (action=="set") abirth(:itrn) = real(attr,4)
      case ("plot")
        if (action=="get") attr = itre(:itrn)
        if (action=="set") itre(:itrn) = int(attr,4)
      case default
        rtnCode = 1
        attr = 0
      end select

      return
      end


      subroutine fvsEvmonAttr(name,nch,action,attr,rtnCode)
      implicit none

c     set and/or gets the named tree attributes
c     name    = char string of the variable name,
c     nch     = the number of characters in "name" (case sensitive)
c     action  = char string that is one of "set" or "get" (case sensitive)
c     attr    = a vector of length data, always "double"
c     rtnCode = 0 is OK, 1=action is "get" and variable
c               is known to be undefined. 2= "name" not found, 
c
      include "PRGPRM.F77"
      include "ARRAYS.F77"
      include "OPCOM.F77"

      integer :: nch,rtncode,iv,i
      double precision  :: attr
      character(len=9)  :: name
      character(len=4)  :: action
      character(len=8)  :: upname
     
      upname = ' '
      upname = name(1:nch)
      
      action=action(1:3)
      if (action=="get") attr = 0

      rtncode = 0
      select case(upname)
      case ("year")
        iv=101
      case ("age")
        iv=102
      case ("btpa")
        iv=103
      case ("btcuft")
        iv=104
      case ("bmcuft")
        iv=105
      case ("bbdft")
        iv=106
      case ("bba")
        iv=107
      case ("bccf")
        iv=108
      case ("btopht")
        iv=109
      case ("badbh")
        iv=110
      case ("yes")
        iv=111
      case ("no")
        iv=112
      case ("cycle")
        iv=113
      case ("numtrees")
        iv=114
      case ("bsdimax")
        iv=115
      case ("bsdi")
        iv=116
      case ("brden")
        iv=117
      case ("brden2")
        iv=118
      case ("habtype")
        iv=126
      case ("slope")
        iv=127
      case ("aspect")
        iv=128
      case ("elev")
        iv=129
      case ("sampwt")
        iv=130
      case ("invyear")
        iv=131
      case ("cendyear")
        iv=132
      case ("evphase")
        iv=133
      case ("smr")
        iv=134
      case ("site")
        iv=135
      case ("cut")
        iv=136
      case ("lat")
        iv=137
      case ("long")
        iv=138
      case ("state")
        iv=139
      case ("county")
        iv=140
      case ("fortyp")
        iv=141
      case ("sizcls")
        iv=142
      case ("stkcls")
        iv=143
      case ("propstk")
        iv=144
      case ("mai")
        iv=145
      case ("agecmp")
        iv=146
      case ("bdbhwtba")
        iv=147
      case ("silvahft")
        iv=148
      case ("fisherin")
        iv=149
      case ("bsdi2")
        iv=150
      case ("atpa")
        iv=201
      case ("atcuft")
        iv=202
      case ("amcuft")
        iv=203
      case ("abdft")
        iv=204
      case ("aba")
        iv=205
      case ("accf")
        iv=206
      case ("atopht")
        iv=207
      case ("aadbh")
        iv=208
      case ("rtpa")
        iv=209
      case ("rtcuft")
        iv=210
      case ("rmcuft")
        iv=211
      case ("rbdft")
        iv=212
      case ("asdimax")
        iv=213
      case ("asdi")
        iv=214
      case ("arden")
        iv=215
      case ("adbhwtba")
        iv=216
      case ("arden2")
        iv=217
      case ("asdi2")
        iv=218
      case ("acc")
        iv=301
      case ("mort")
        iv=302
      case ("pai")
        iv=303
      case ("dtpa")
        iv=305
      case ("dtpa%")
        iv=306
      case ("dba")
        iv=307
      case ("dba%")
        iv=308
      case ("dccf")
        iv=309
      case ("dccf%")
        iv=310
      case ("tm%stnd")
        iv=401
      case ("tm%df")
        iv=402
      case ("tm%gf")
        iv=403
      case ("mpbtpak")
        iv=404
      case ("bw%stnd")
        iv=405
      case ("mpbprob")
        iv=406
      case ("bsclass")
        iv=416
      case ("asclass")
        iv=417
      case ("bstrdbh")
        iv=418
      case ("astrdbh")
        iv=419
      case ("fire")
        iv=420
      case ("minsoil")
        iv=421
      case ("crownidx")
        iv=422
      case ("fireyear")
        iv=423
      case ("bcancov")
        iv=424
      case ("acancov")
        iv=425
      case ("crbaseht")
        iv=426
      case ("torchidx")
        iv=427
      case ("crbulkdn")
        iv=428
      case ("disccost")
        iv=430
      case ("discrevn")
        iv=431
      case ("forstval")
        iv=432
      case ("harvcost")
        iv=433
      case ("harvrevn")
        iv=434
      case ("irr")
        iv=435
      case ("pctcost")
        iv=436
      case ("pnv")
        iv=437
      case ("rprodval")
        iv=438
      case ("sev")
        iv=439
      case ("bmaxhs")
        iv=440
      case ("amaxhs")
        iv=441
      case ("bminhs")
        iv=442
      case ("aminhs")
        iv=443
      case ("bnumss")
        iv=444
      case ("anumss")
        iv=445
      case ("discrate")
        iv=446
      case ("undiscst")
        iv=447
      case ("undisrvn")
        iv=448
      case ("eccuft")
        iv=449
      case ("ecbdft")
        iv=450
      case default
        iv=0
      end select
      
      if (iv == 0) then
        do i=1,nch
          call upcase(upname(i:i))
        enddo
        do i=1,ITST5
          if (ctstv5(i).eq.upname) then
            if (action=="get") then
              if (LTSTV5(i)) then
                attr = tstv5(i)
              else
                rtncode = 1
              endif
            elseif (action=="set") then 
              tstv5(i) = real(attr,4)
              LTSTV5(i) = .TRUE.
            else
              rtncode = 1
            endif
            return
          endif
        enddo
        if (action=="set" .and. ITST5.lt.MXTST5) then
          ITST5=ITST5+1
          LTSTV5(ITST5) = .TRUE.
          tstv5(ITST5) = real(attr,4)
          ctstv5(ITST5) = upname
        else
          rtnCode=1
        endif
        return
      endif
      
      i = mod(iv,100)
      iv = iv/100

      select case (iv)
      case (1)
        if (action=="get") attr = tstv1(i)
        if (action=="set") tstv1(i) = real(attr,4)
      case (2)
        if (action=="get") attr = tstv2(i)
        if (action=="set") tstv2(i) = real(attr,4)
      case (3)
        if (action=="get") attr = tstv3(i)
        if (action=="set") tstv3(i) = real(attr,4)
      case (4)
        if (action=="get") then
          if (ltstv4(i)) then
            attr = tstv4(i)
          else
            rtncode = 1
          endif
        endif
        if (action=="set") then
          tstv4(i) = real(attr,4)
          ltstv4(i)=.true.
        endif
      end select
      return
      end
      
      subroutine fvsAddTrees(in_dbh,in_species,in_ht,in_cratio,
     -                       in_plot,in_tpa,ntrees,rtnCode)
      implicit none

c     rtnCode = 0 when all is OK
c               1 when there isn't room for the ntrees
c                 or when ntrees is zero
      
      include "PRGPRM.F77"
      include "ARRAYS.F77"
      include "CONTRL.F77"
      include "OUTCOM.F77"
      include "PLOT.F77"
      include "VARCOM.F77"
      include "ESTREE.F77"
      include "STDSTK.F77"

      real(kind=8) :: in_dbh(ntrees),in_species(ntrees),
     -    in_ht(ntrees),in_cratio(ntrees),in_plot(ntrees),
     -    in_tpa(ntrees)
      real :: cw,crdum
      integer :: ntrees,rtnCode,i
      
      rtnCode = 0
      if (ntrees == 0 .or. ntrees+itrn > MAXTRE) then
        rtnCode = 1
        return
      endif

      do i=1,ntrees
        itrn=itrn+1
        dbh(itrn) = real (in_dbh    (i),4)
        isp(itrn) = int  (in_species(i),4)
        ht (itrn) = real (in_ht     (i),4)
        icr(itrn) = int  (in_cratio (i),4)
        itre(itrn)= int  (in_plot   (i),4)
        prob(itrn)= real (in_tpa    (i),4)
        imc(itrn)=2
        cfv(itrn)=0.0
        itrunc(itrn)=0
        normht(itrn)=0
        crdum = icr(itrn)
        call cwcalc(isp(itrn),prob(itrn),dbh(itrn),ht(itrn),crdum,
     &              icr(itrn),cw,0,jostnd)
        crwdth(itrn)=cw
c       
        dg(itrn)=0.0
        htg(itrn)=0.0
        pct(itrn)=0.0
        oldpct(itrn)=0.0
        wk1(itrn)=0.0
        wk2(itrn)=0.
        wk4(itrn)=0.
        bfv(itrn)=0.0
        iestat(itrn)=0
        ptbalt(itrn)=0.
        idtree(itrn)=10000000+icyc*10000+itrn
        call misputz(itrn,0)
c       
        abirth(itrn)=5
        defect(itrn)=0
        ispecl(itrn)=0
        oldrn(itrn)=0.
        ptocfv(itrn)=0.
        pmrcfv(itrn)=0.
        pmrbfv(itrn)=0.
        ncfdef(itrn)=0
        nbfdef(itrn)=0
        pdbh(itrn)=0.
        pht(itrn)=0.
        zrand(itrn)=-999.
      enddo

c     set the value of irec1 to point to the last location in the
c     treelist. call spesrt to reestablish the species order sort.

      irec1=itrn
      call spesrt

c     reestablish the diameter sort (include the new trees).

      call rdpsrt (itrn,dbh,ind,.true.)

c     set ifst=1 so that the sample tree records will be repicked
c     next time dist is called.

      ifst=1
      return
      end
      
      subroutine fvsSpeciesCode(fvs_code,fia_code,plant_code,
     -                          indx,nchfvs,nchfia,nchplant,rtnCode)
      implicit none

c     rtnCode = 0 when all is OK
c               1 when index is out of bounds
c     indx    = species index
     
      include "PRGPRM.F77"
      include "PLOT.F77"

      integer :: indx,nchfvs,nchfia,nchplant,rtnCode
      character(len=4) :: fvs_code
      character(len=4) :: fia_code
      character(len=6) :: plant_code
      
      if (indx == 0 .or. indx > MAXSP) then
        nchfvs  = 0
        nchfia  = 0
        nchplant= 0
        rtnCode = 1
      else
        fvs_code   = JSP   (indx)
        fia_code   = FIAJSP(indx)
        plant_code = PLNJSP(indx)
        nchfvs  = len_trim(JSP   (indx))
        nchfia  = len_trim(FIAJSP(indx))
        nchplant= len_trim(PLNJSP(indx))
        rtnCode = 0
      endif
      return
      end
      
      
      subroutine fvsCutTrees(pToCut,ntrees,rtnCode)

      include "PRGPRM.F77"
      include "ARRAYS.F77"
      include "CONTRL.F77"
      
      integer :: ntrees,rtnCode
      double precision :: pToCut(ntrees)
      pToCut = 0.
      if (ntrees <= 0 .or. ntrees > maxtre) then
        rtnCode = 1
        return
      endif
      
      print *,"Not yet implemented"
      rntCode = 1
      return
      end
      
      subroutine fvsStandID(sID,sCN,mID,ncsID,ncCN,ncmID)

      include "PRGPRM.F77"
      include "PLOT.F77"
      
      integer :: ncsID,ncCN,ncmID
      character(len=26) sID
      character(len=4)  mID
      character(len=40) sCN
      
      sID = NPLT
      mID = MGMID
      sCN = DBCN
      ncsID = len_trim(NPLT)
      ncCN  = len_trim(DBCN)
      ncmID = len_trim(MGMID)
      return
      end


      subroutine fvsCloseFile(filename,nch)
      implicit none

C     this routine closes "filename" if it is opened, it is not called
C     from within FVS. nch is the length of filename.

      integer nch,i
      character(len=nch) filename
      logical ls
      if (nch <= 0) return
      inquire(file=filename(:nch),opened=ls)
      if (ls) then
        inquire(file=filename(:nch),number=i)
        if (i > 0) close(unit=i)
      endif
      return
      end
      
      
      subroutine fvsAddActivity(idt,iactk,inprms,nprms,rtnCode)
      implicit none

C     add an activity to the schedule.

      include "PRGPRM.F77"
      include "CONTRL.F77"
      
      integer :: i,idt,iactk,nprms,rtnCode,kode
      integer, parameter :: mxtopass=20
      real(kind=8) inprms(*)
      real(kind=4) prms(mxtopass)

      if (nprms > 0) then 
        do i=1,min(nprms,mxtopass)
          prms(i) = real(inprms(i),kind=4)
        enddo
      endif
      call opadd(idt,iactk,0,nprms,prms,kode)
      if (kode /= 0) then
        rtnCode = 1
      else
        call opincr (IY,ICYC,NCYC)
        rtnCode = 0
      endif
      return 
      end
