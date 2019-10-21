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
        
        m0_ltv
        k0b_ltv
        
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

                lnp         =getfrsbf([obj.p.filename '.sbd'],'lnp');
                obj.lnp=lnp;

        end
        function mode = get.mode(obj)

                mode         =getfrsbf([obj.p.filename '.sbd'],'mode');
                obj.mode=mode;

        end
        function ndof = get.ndof(obj)
                ndof         =getfrsbf([obj.p.filename '.sbd'],'ndof');
                obj.ndof=ndof;

        end
        function nddof = get.nddof(obj)
                nddof         =getfrsbf([obj.p.filename '.sbd'],'nddof');
                obj.nddof=nddof;

        end
        function nkdof = get.nkdof(obj)
                nkdof         =getfrsbf([obj.p.filename '.sbd'],'nkdof');
                obj.nkdof=nkdof;

        end
        function nkddof = get.nkddof(obj)
                nkddof         =getfrsbf([obj.p.filename '.sbd'],'nkddof');
                obj.nkddof=nkddof;

        end
        function nx = get.nx(obj)
                nx         =getfrsbf([obj.p.filename '.sbd'],'nx');
                obj.nx=nx;

        end
        function ne = get.ne(obj)
                ne         =getfrsbf([obj.p.filename '.sbd'],'ne');
                obj.ne=ne;

        end
        function nxp = get.nxp(obj)
                nxp         =getfrsbf([obj.p.filename '.sbd'],'nxp');
                obj.nxp=nxp;

        end
        function nep = get.nep(obj)
                nep         =getfrsbf([obj.p.filename '.sbd'],'nep');
                obj.nep=nep;

        end
        function le = get.le(obj)
                le         =getfrsbf([obj.p.filename '.sbd'],'le');
                obj.le=le;

        end
        function ln = get.ln(obj)
                ln         =getfrsbf([obj.p.filename '.sbd'],'ln');
                obj.ln=ln;

        end
        function it = get.it(obj)
                it         =getfrsbf([obj.p.filename '.sbd'],'it');
                obj.it=it;

        end
        function kdform = get.kdform(obj)
                kdform         =getfrsbf([obj.p.filename '.sbd'],'kdform');
                obj.kdform=kdform;

        end
        function rxyz = get.rxyz(obj)
                rxyz         =getfrsbf([obj.p.filename '.sbd'],'rxyz');
                obj.rxyz=rxyz;

        end
        function rxyzq = get.rxyzq(obj)
                rxyzq         =getfrsbf([obj.p.filename '.sbd'],'rxyzq');
                obj.rxyzq=rxyzq;

        end
        function dr0 = get.dr0(obj)
                dr0         =getfrsbf([obj.p.filename '.sbd'],'dr0');
                obj.dr0=dr0;

        end
        function estiff = get.estiff(obj)
                estiff         =getfrsbf([obj.p.filename '.sbd'],'estiff');
                obj.estiff=estiff;
         end
        function edamp = get.edamp(obj)
                edamp         =getfrsbf([obj.p.filename '.sbd'],'edamp');
                obj.edamp=edamp;
        end
        function em = get.em(obj)
                em         =getfrsbf([obj.p.filename '.sbd'],'em');
                obj.em=em;
        end
        function einit = get.einit(obj)
                einit         =getfrsbf([obj.p.filename '.sbd'],'einit');
                obj.einit=einit;
        end
        function esig = get.esig(obj)
                esig         =getfrsbf([obj.p.filename '.sbd'],'esig');
                obj.esig=esig;
          end
        function rl0 = get.rl0(obj)
                rl0         =getfrsbf([obj.p.filename '.sbd'],'rl0');
                obj.rl0=rl0;
        end
        function time = get.time(obj)
                time         =getfrsbf([obj.p.filename '.sbd'],'time');
                obj.time=time;
        end
        function x = get.x(obj)
                x         =getfrsbf([obj.p.filename '.sbd'],'x');
                obj.x=x;
        end
        function xd = get.xd(obj)
                xd         =getfrsbf([obj.p.filename '.sbd'],'xd');
                obj.xd=xd;
        end
        function xdd = get.xdd(obj)
                xdd         =getfrsbf([obj.p.filename '.sbd'],'xdd');
                obj.xdd=xdd;
        end
        function fx = get.fx(obj)
                fx         =getfrsbf([obj.p.filename '.sbd'],'fx');
                obj.fx=fx;
        end
        function fxgrav = get.fxgrav(obj)
                fxgrav         =getfrsbf([obj.p.filename '.sbd'],'fxgrav');
                obj.fxgrav=fxgrav;
        end
        function fxtot = get.fxtot(obj)
                fxtot         =getfrsbf([obj.p.filename '.sbd'],'fxt');
                obj.fxtot=fxtot;
        end
        function e = get.e(obj)
                e         =getfrsbf([obj.p.filename '.sbd'],'e');
                obj.e=e;
        end
        function ed = get.ed(obj)
                ed         =getfrsbf([obj.p.filename '.sbd'],'ed');
                obj.ed=ed;
        end
        function edd = get.edd(obj)
                edd         =getfrsbf([obj.p.filename '.sbd'],'edd');
                obj.edd=edd;
        end
        function sig = get.sig(obj)
                sig         =getfrsbf([obj.p.filename '.sbd'],'sig');
                obj.sig=sig;
        end
        function dec = get.dec(obj)
                dec         =getfrsbf([obj.p.filename '.sbd'],'dec');
                obj.dec=dec;
        end
        function dxc = get.dxc(obj)
                dxc         =getfrsbf([obj.p.filename '.sbd'],'dxc');
                obj.dxc=dxc;
        end
        function dx = get.dx(obj)
                dx         =getfrsbf([obj.p.filename '.sbd'],'dx');
                obj.dx=dx;
        end
        function de = get.de(obj)
                de         =getfrsbf([obj.p.filename '.sbd'],'de');
                obj.de=de;
        end
        function d2e = get.d2e(obj)
                d2e         =getfrsbf([obj.p.filename '.sbd'],'d2e');
                obj.d2e=d2e;

        end
        function d2x = get.d2x(obj)
                d2x         =getfrsbf([obj.p.filename '.sbd'],'d2x');
                obj.d2x=d2x;
        end
        function xcompl = get.xcompl(obj)
                xcompl         =getfrsbf([obj.p.filename '.sbd'],'xcompl');
                obj.xcompl=xcompl;
        end
        
        function tdef = get.tdef(obj)
                tdef         =getfrsbf([obj.p.filename '.sbd'],'tdef');
                obj.tdef=tdef;
        end
        function nk = get.nk(obj)
                nk         =getfrsbf([obj.p.filename '.sbd'],'nk');
                obj.nk=nk;
        end
        function m0 = get.m0(obj)
                m0         =getfrsbf([obj.p.filename '.sbm'],'m0');
                obj.m0=m0;
        end
        function b0 = get.b0(obj)
                b0         =getfrsbf([obj.p.filename '.sbm'],'b0');
                obj.b0=b0;
        end
        function c0 = get.c0(obj)
                c0         =getfrsbf([obj.p.filename '.sbm'],'c0');
                obj.c0=c0;
        end
        function d0 = get.d0(obj)
                d0         =getfrsbf([obj.p.filename '.sbm'],'d0');
                obj.d0=d0;
        end
        function k0 = get.k0(obj)
                k0         =getfrsbf([obj.p.filename '.sbm'],'k0');
                obj.k0=k0;
        end
        function n0 = get.n0(obj)
                n0         =getfrsbf([obj.p.filename '.sbm'],'n0');
                obj.n0=n0;
        end
        function g0 = get.g0(obj)
                g0         =getfrsbf([obj.p.filename '.sbm'],'g0');
                obj.g0=g0;
        end
        function ak0 = get.ak0(obj)
                ak0         =getfrsbf([obj.p.filename '.sbm'],'ak0');
                obj.ak0=ak0;
        end
        function bk0 = get.bk0(obj)
                bk0         =getfrsbf([obj.p.filename '.sbm'],'bk0');
                obj.bk0=bk0;
        end
        
        function m0_ltv = get.m0_ltv(obj)
                m0_ltv         =getfrsbf([obj.p.filename '.ltv'],'m0');
                obj.m0_ltv=m0_ltv;
        end
        function k0b_ltv = get.k0b_ltv(obj)
                k0b_ltv         =getfrsbf([obj.p.filename '.ltv'],'k0b');
                obj.k0b_ltv=k0b_ltv;
        end
    end
end

