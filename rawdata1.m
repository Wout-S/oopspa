classdef rawdata < handle %& matlab.mixin.Copyable
    %RAW Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        mode
        ndof
        nddof
        nkdof
        nkddof
        nx
        ne
        nxp
        nep
        lnp
        le
        ln
        it
        kdform
        rxyz
        rxyzq
        dr0
        estiff
        edamp
        em
        einit
        esig
        rl0
        time
        x
        xd
        xdd
        fx
        fxgrav
        fxtot
        e
        ed
        edd
        sig
        dec
        dxc
        de
        dx
        d2e
        d2x
        xcompl
        tdef
        nk
        
        m0
        b0
        c0
        d0
        k0
        n0
        g0
        ak0
        bk0
        
        filename
        p
    end
    
    methods (Access = ?spadata)
        function obj = rawdata(parent)
            %RAW Construct an instance of this class
            %   Detailed explanation goes here
            obj.p=parent;
        end
    end
    methods
        function lnp = get.lnp(obj)
            if isempty(obj.lnp)
                lnp         =getfrsbf([obj.p.filename '.sbd'],'lnp');
                obj.lnp=lnp;
            else
                lnp=obj.lnp;
            end
        end
        function mode = get.mode(obj)
            if isempty(obj.mode)
                mode         =getfrsbf([obj.p.filename '.sbd'],'mode');
                obj.mode=mode;
            else
                mode=obj.mode;
            end
        end
        function ndof = get.ndof(obj)
            if isempty(obj.ndof)
                ndof         =getfrsbf([obj.p.filename '.sbd'],'ndof');
                obj.ndof=ndof;
            else
                ndof=obj.ndof;
            end
        end
        function nddof = get.nddof(obj)
            if isempty(obj.nddof)
                nddof         =getfrsbf([obj.p.filename '.sbd'],'nddof');
                obj.nddof=nddof;
            else
                nddof=obj.nddof;
            end
        end
        function nkdof = get.nkdof(obj)
            if isempty(obj.nkdof)
                nkdof         =getfrsbf([obj.p.filename '.sbd'],'nkdof');
                obj.nkdof=nkdof;
            else
                nkdof=obj.nkdof;
            end
        end
        function nkddof = get.nkddof(obj)
            if isempty(obj.nkddof)
                nkddof         =getfrsbf([obj.p.filename '.sbd'],'nkddof');
                obj.nkddof=nkddof;
            else
                nkddof=obj.nkddof;
            end
        end
        function nx = get.nx(obj)
            if isempty(obj.nx)
                nx         =getfrsbf([obj.p.filename '.sbd'],'nx');
                obj.nx=nx;
            else
                nx=obj.nx;
            end
        end
        function ne = get.ne(obj)
            if isempty(obj.ne)
                ne         =getfrsbf([obj.p.filename '.sbd'],'ne');
                obj.ne=ne;
            else
                ne=obj.ne;
            end
        end
        function nxp = get.nxp(obj)
            if isempty(obj.nxp)
                nxp         =getfrsbf([obj.p.filename '.sbd'],'nxp');
                obj.nxp=nxp;
            else
                nxp=obj.nxp;
            end
        end
        function nep = get.nep(obj)
            if isempty(obj.nep)
                nep         =getfrsbf([obj.p.filename '.sbd'],'nep');
                obj.nep=nep;
            else
                nep=obj.nep;
            end
        end
        function le = get.le(obj)
            if isempty(obj.le)
                le         =getfrsbf([obj.p.filename '.sbd'],'le');
                obj.le=le;
            else
                le=obj.le;
            end
        end
        function ln = get.ln(obj)
            if isempty(obj.ln)
                ln         =getfrsbf([obj.p.filename '.sbd'],'ln');
                obj.ln=ln;
            else
                ln=obj.ln;
            end
        end
        function it = get.it(obj)
            if isempty(obj.it)
                it         =getfrsbf([obj.p.filename '.sbd'],'it');
                obj.it=it;
            else
                it=obj.it;
            end
        end
        function kdform = get.kdform(obj)
            if isempty(obj.kdform)
                kdform         =getfrsbf([obj.p.filename '.sbd'],'kdform');
                obj.kdform=kdform;
            else
                kdform=obj.kdform;
            end
        end
        function rxyz = get.rxyz(obj)
            if isempty(obj.rxyz)
                rxyz         =getfrsbf([obj.p.filename '.sbd'],'rxyz');
                obj.rxyz=rxyz;
            else
                rxyz=obj.rxyz;
            end
        end
        function rxyzq = get.rxyzq(obj)
            if isempty(obj.rxyzq)
                rxyzq         =getfrsbf([obj.p.filename '.sbd'],'rxyzq');
                obj.rxyzq=rxyzq;
            else
                rxyzq=obj.rxyzq;
            end
        end
        function dr0 = get.dr0(obj)
            if isempty(obj.dr0)
                dr0         =getfrsbf([obj.p.filename '.sbd'],'dr0');
                obj.dr0=dr0;
            else
                dr0=obj.dr0;
            end
        end
        function estiff = get.estiff(obj)
            if isempty(obj.estiff)
                estiff         =getfrsbf([obj.p.filename '.sbd'],'estiff');
                obj.estiff=estiff;
            else
                estiff=obj.estiff;
            end
        end
        function edamp = get.edamp(obj)
            if isempty(obj.edamp)
                edamp         =getfrsbf([obj.p.filename '.sbd'],'edamp');
                obj.edamp=edamp;
            else
                edamp=obj.edamp;
            end
        end
        function em = get.em(obj)
            if isempty(obj.em)
                em         =getfrsbf([obj.p.filename '.sbd'],'em');
                obj.em=em;
            else
                em=obj.em;
            end
        end
        function einit = get.einit(obj)
            if isempty(obj.einit)
                einit         =getfrsbf([obj.p.filename '.sbd'],'einit');
                obj.einit=einit;
            else
                einit=obj.einit;
            end
        end
        function esig = get.esig(obj)
            if isempty(obj.esig)
                esig         =getfrsbf([obj.p.filename '.sbd'],'esig');
                obj.esig=esig;
            else
                esig=obj.esig;
            end
        end
        function rl0 = get.rl0(obj)
            if isempty(obj.rl0)
                rl0         =getfrsbf([obj.p.filename '.sbd'],'rl0');
                obj.rl0=rl0;
            else
                rl0=obj.rl0;
            end
        end
        function time = get.time(obj)
            if isempty(obj.time)
                time         =getfrsbf([obj.p.filename '.sbd'],'time');
                obj.time=time;
            else
                time=obj.time;
            end
        end
        function x = get.x(obj)
            if isempty(obj.x)
                x         =getfrsbf([obj.p.filename '.sbd'],'x');
                obj.x=x;
            else
                x=obj.x;
            end
        end
        function xd = get.xd(obj)
            if isempty(obj.xd)
                xd         =getfrsbf([obj.p.filename '.sbd'],'xd');
                obj.xd=xd;
            else
                xd=obj.xd;
            end
        end
        function xdd = get.xdd(obj)
            if isempty(obj.xdd)
                xdd         =getfrsbf([obj.p.filename '.sbd'],'xdd');
                obj.xdd=xdd;
            else
                xdd=obj.xdd;
            end
        end
        function fx = get.fx(obj)
            if isempty(obj.fx)
                fx         =getfrsbf([obj.p.filename '.sbd'],'fx');
                obj.fx=fx;
            else
                fx=obj.fx;
            end
        end
        function fxgrav = get.fxgrav(obj)
            if isempty(obj.fxgrav)
                fxgrav         =getfrsbf([obj.p.filename '.sbd'],'fxgrav');
                obj.fxgrav=fxgrav;
            else
                fxgrav=obj.fxgrav;
            end
        end
        function fxtot = get.fxtot(obj)
            if isempty(obj.fxtot)
                fxtot         =getfrsbf([obj.p.filename '.sbd'],'fxt');
                obj.fxtot=fxtot;
            else
                fxtot=obj.fxtot;
            end
        end
        function e = get.e(obj)
            if isempty(obj.e)
                e         =getfrsbf([obj.p.filename '.sbd'],'e');
                obj.e=e;
            else
                e=obj.e;
            end
        end
        function ed = get.ed(obj)
            if isempty(obj.ed)
                ed         =getfrsbf([obj.p.filename '.sbd'],'ed');
                obj.ed=ed;
            else
                ed=obj.ed;
            end
        end
        function edd = get.edd(obj)
            if isempty(obj.edd)
                edd         =getfrsbf([obj.p.filename '.sbd'],'edd');
                obj.edd=edd;
            else
                edd=obj.edd;
            end
        end
        function sig = get.sig(obj)
            if isempty(obj.sig)
                sig         =getfrsbf([obj.p.filename '.sbd'],'sig');
                obj.sig=sig;
            else
                sig=obj.sig;
            end
        end
        function dec = get.dec(obj)
            if isempty(obj.dec)
                dec         =getfrsbf([obj.p.filename '.sbd'],'dec');
                obj.dec=dec;
            else
                dec=obj.dec;
            end
        end
        function dxc = get.dxc(obj)
            if isempty(obj.dxc)
                dxc         =getfrsbf([obj.p.filename '.sbd'],'dxc');
                obj.dxc=dxc;
            else
                dxc=obj.dxc;
            end
        end
        function dx = get.dx(obj)
            if isempty(obj.dx)
                dx         =getfrsbf([obj.p.filename '.sbd'],'dx');
                obj.dx=dx;
            else
                dx=obj.dx;
            end
        end
        function de = get.de(obj)
            if isempty(obj.de)
                de         =getfrsbf([obj.p.filename '.sbd'],'de');
                obj.de=de;
            else
                de=obj.de;
            end
        end
        function d2e = get.d2e(obj)
            if isempty(obj.d2e)
                d2e         =getfrsbf([obj.p.filename '.sbd'],'d2e');
                obj.d2e=d2e;
            else
                d2e=obj.d2e;
            end
        end
        function d2x = get.d2x(obj)
            if isempty(obj.d2x)
                d2x         =getfrsbf([obj.p.filename '.sbd'],'d2x');
                obj.d2x=d2x;
            else
                d2x=obj.d2x;
            end
        end
        function xcompl = get.xcompl(obj)
            if isempty(obj.xcompl)
                xcompl         =getfrsbf([obj.p.filename '.sbd'],'xcompl');
                obj.xcompl=xcompl;
            else
                xcompl=obj.xcompl;
            end
        end
        
        function tdef = get.tdef(obj)
            if isempty(obj.tdef)
                tdef         =getfrsbf([obj.p.filename '.sbd'],'tdef');
                obj.tdef=tdef;
            else
                tdef=obj.tdef;
            end
        end
        function nk = get.nk(obj)
            if isempty(obj.nk)
                nk         =getfrsbf([obj.p.filename '.sbd'],'nk');
                obj.nk=nk;
            else
                nk=obj.nk;
            end
        end
        function m0 = get.m0(obj)
            if isempty(obj.m0)
                m0         =getfrsbf([obj.p.filename '.sbm'],'m0');
                obj.m0=m0;
            else
                m0=obj.m0;
            end
        end
        function b0 = get.b0(obj)
            if isempty(obj.b0)
                b0         =getfrsbf([obj.p.filename '.sbm'],'b0');
                obj.b0=b0;
            else
                b0=obj.b0;
            end
        end
        function c0 = get.c0(obj)
            if isempty(obj.c0)
                c0         =getfrsbf([obj.p.filename '.sbm'],'c0');
                obj.c0=c0;
            else
                c0=obj.c0;
            end
        end
        function d0 = get.d0(obj)
            if isempty(obj.d0)
                d0         =getfrsbf([obj.p.filename '.sbm'],'d0');
                obj.d0=d0;
            else
                d0=obj.d0;
            end
        end
        function k0 = get.k0(obj)
            if isempty(obj.k0)
                k0         =getfrsbf([obj.p.filename '.sbm'],'k0');
                obj.k0=k0;
            else
                k0=obj.k0;
            end
        end
        function n0 = get.n0(obj)
            if isempty(obj.n0)
                n0         =getfrsbf([obj.p.filename '.sbm'],'n0');
                obj.n0=n0;
            else
                n0=obj.n0;
            end
        end
        function g0 = get.g0(obj)
            if isempty(obj.g0)
                g0         =getfrsbf([obj.p.filename '.sbm'],'g0');
                obj.g0=g0;
            else
                g0=obj.g0;
            end
        end
        function ak0 = get.ak0(obj)
            if isempty(obj.ak0)
                ak0         =getfrsbf([obj.p.filename '.sbm'],'ak0');
                obj.ak0=ak0;
            else
                ak0=obj.ak0;
            end
        end
        function bk0 = get.bk0(obj)
            if isempty(obj.bk0)
                bk0         =getfrsbf([obj.p.filename '.sbm'],'bk0');
                obj.bk0=bk0;
            else
                bk0=obj.bk0;
            end
        end
    end
end

