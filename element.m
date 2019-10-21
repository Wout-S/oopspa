classdef element < handle
    %ELEMENT Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        nodes
        spanodes
        n
        EM
        ESTIFF
        etype
        sect=section.empty
        mat=material.empty
        flex
        dyne
        rlse
        color
        opacity
        orien
        esig
    end
    
    methods (Access = ?spadata)
        function obj = element(nodes,n,eprops,sect,mat)
            %ELEMENT Construct an instance of this class
            %   Detailed explanation goes here
            obj.nodes = nodes;
            obj.n = n;
            obj.etype=eprops.type;
            obj.orien=eprops.orien;
            switch eprops.type
                case 'BEAM'
                    obj.spanodes=[nodes(1).spanodes(1:2) nodes(2).spanodes(1:2)];
                case 'BEAMW'
                    obj.spanodes=[nodes(1).spanodes(1:3) nodes(2).spanodes(1:3)];
                case 'TRUSS'
                    obj.spanodes=[nodes(1).spanodes(1) nodes(2).spanodes(1)];
                case 'HINGE'
                    obj.spanodes=[nodes(1).spanodes(2) nodes(2).spanodes(2)];
            end
            if isa(sect,'section') && isa(mat,'material')
                obj.sect=sect;
                obj.mat=mat;
                v = mat.E/(2*mat.G) - 1;
                switch lower(sect.shape)
                    case 'rect'
                        w   = sect.dim(1);
                        t   = sect.dim(2);
                        A   = t*w;
                        Iy  = 1/12 * t^3*w;
                        Iz  = 1/12 * t*w^3;
                        Iw = (w^3*t^3)/144;
                        Cwv = (w^3*t^3)/144; %warping constant
                        It 	= calc_torsStiff(t,w);
                        k   = 10*(1+v)/(12+11*v);
                    case 'circ'
                        d   = sect.dim(1);
                        A   = (pi/4)*d^2;
                        Iy  = (pi/64)*d^4;
                        Iz  = Iy;
                        It  = (pi/32)*d^4;
                        Iw = 1;
                        Cwv = 1;
                        k   = 6*(1+v)/(7+6*v);
                end
                ESTIFF(1,1) = mat.E*A;
                ESTIFF(1,2) = mat.G*It;
                ESTIFF(1,3) = mat.E*Iy;
                ESTIFF(1,4) = mat.E*Iz;
                ESTIFF(1,5) = ESTIFF(1,3)/(mat.G*A*k);
                ESTIFF(1,6) = ESTIFF(1,4)/(mat.G*A*k);
                ESTIFF(1,7) = mat.E*Cwv;
                obj.ESTIFF=ESTIFF;
                EM(1,1) = mat.rho*A;
                EM(1,2) = mat.rho*(Iy+Iz);
                EM(1,3) = mat.rho*Iy;
                EM(1,4) = mat.rho*Iz;
                EM(1,5) = 0;
                EM(1,6) = mat.rho*Iw;
                obj.EM=EM;
            end
            obj.dyne=eprops.flex;
            obj.flex=eprops.flex;
            obj.color=[0.854900 0.858800 0.866700];
            obj.opacity=0.99;
        end
    end
    methods
        
    end
end

