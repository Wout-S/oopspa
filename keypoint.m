classdef keypoint < handle %& matlab.mixin.Copyable
    %NODE Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        n                   % node number
        p                   % position
        spanodes            % numbers[translational, rotational, warping]
        sn=node.empty    %subnodes
        raw
    end
    properties (Hidden)
        parent
    end
    properties (Dependent)
        pt
        r_eulzyx
        r_quat
        r_axang
        M_reac
        F_reac
        CMglob
        CMloc
        CMglob_p
        CMloc_p
        CMglob_new
        CMloc_new
    end
    
    methods (Access = ?spadata)
        function obj = keypoint(data,p,n)
            %NODE Construct an instance of this class
            %   create node based on position
            obj.p = p;
            obj.n=n;
            tnn=(n-1)*3+1;
            rnn=(n-1)*3+2;
            wnn=(n-1)*3+3;
            obj.spanodes=[tnn, rnn, wnn];
            n1=addnode(data,'trans');
            n1.p=p;
            n2=addnode(data,'rot');
            n3=addnode(data,'warp');
            obj.sn(1)=n1;
            obj.sn(2)=n2;
            obj.sn(3)=n3;
        end
    end
    methods
        function fix(obj)
            obj.sn(1).fix;
            obj.sn(2).fix;
        end
        function fix_t(obj,varargin)
            if nargin==1
                obj.sn(1).fix;
            else
              fix(obj.sn(1),varargin{1});
            end
        end
        function fix_r(obj,varargin)
            if nargin==1
                obj.sn(1).fix;
            else
              fix(obj.sn(2),varargin{1});
            end
        end
        
        function force_initial(obj,f)
            obj.sn(1).xf=f;
            
        end
        
        function force(obj,f)
            obj.sn(1).delxf=f;
        end
        
        function moment_initial(obj,m)
            obj.sn(2).xf=m;
        end
        
        function moment(obj,m)
            obj.sn(2).delxf=m;
        end
        
        
        function displ_x_initial(obj,d)
            obj.sn(1).c(1).inputx=d;
        end
        function displ_y_initial(obj,d)
            obj.sn(1).c(2).inputx=d;
        end
        function displ_z_initial(obj,d)
            obj.sn(1).c(3).inputx=d;
        end
        
        function displ_x(obj,d)
            obj.sn(1).c(1).delinpx=d;
        end
        function displ_y(obj,d)
            obj.sn(1).c(2).delinpx=d;
        end
        function displ_z(obj,d)
            obj.sn(1).c(3).delinpx=d;
        end
        
        function rot_initial(obj,r)
            if nnz(r) >1
                error('one rotation direction per node allowed')
            elseif nnz(r)==1
                rot=eul2quat(fliplr(r)); %zyx order
                [~,col,v]=find([0 rot(2:4)]);
                obj.sn(2).c(col).inputx=v;
            elseif nnz(r)==0
                obj.sn(2).inputx=[];
            end
        end
        
        function rot(obj,r)
            if nnz(r) >1
                error('one rotation direction per node allowed')
            elseif nnz(r)==1
                rot=eul2quat(fliplr(r)); %zyx order
                [~,col,v]=find([0 rot(2:4)]);
                obj.sn(2).c(col).delinpx=v;
            elseif nnz(r)==0
                obj.sn(2).delinpx=[];
            end
        end
        
        function mass(obj,m)
            obj.sn(1).xm=m;
        end
        
        function mominertia(obj,I)
            obj.sn(2).xm=I;
        end
        %% result methods
        function out=get.CMglob(obj)
            [out,~]=complt(obj.raw,obj);
        end
        function out=get.CMglob_new(obj)
            [out,~]=complt_new(obj.raw,obj);
        end
        function out=get.CMloc_new(obj)
            [~,out]=complt_new(obj.raw,obj);
        end
        function out=get.CMglob_p(obj)
            [out,~]=complt_new(obj.parent.perturbdata,obj);
        end
        function out=get.CMloc_p(obj)
            [~,out]=complt_new(obj.parent.perturbdata,obj);
        end
        function out=get.CMloc(obj)
            [~,out]=complt(obj.raw,obj);
        end
        function out=get.pt(obj)
            x       = obj.raw.x;
            lnp     = obj.raw.lnp; %lnp data
            out=x(:,lnp(obj.sn(1).n,1:3));
        end
        function out=get.r_eulzyx(obj)
            x       = obj.raw.x;
            lnp     = obj.raw.lnp; %lnp data
            out=quat2eulang(x(:,lnp(obj.sn(2).n,1:4)));
        end
        function out=get.r_axang(obj)
            x       = obj.raw.x;
            lnp     = obj.raw.lnp; %lnp data
            out=quat2axang(x(:,lnp(obj.sn(2).n,1:4)));
        end
        function out=get.r_quat(obj)
            x       = obj.raw.x;
            lnp     = obj.raw.lnp; %lnp data
            out=x(:,lnp(obj.sn(2).n,1:4));
        end
        function out=get.F_reac(obj)
            fxtot   = obj.raw.fxtot;
            lnp     = obj.raw.lnp; %lnp data
            out=fxtot(:,lnp(obj.sn(1).n,1:3));
        end
        function out=get.M_reac(obj)
            fxtot   = obj.raw.fxtot;
            lnp     = obj.raw.lnp; %lnp data
            out=fxtot(:,lnp(obj.sn(2).n,2:4))/2;
        end
    end
    methods(Access = protected)
        %         % Override copyElement method:
        %         function cpObj = copyElement(obj)
        %             % Make a shallow copy of all four properties
        %             cpObj = copyElement@matlab.mixin.Copyable(obj);
        %             % Make a deep copy of the raw object
        %             cpObj.raw = copy(obj.raw);
        %             %           cpObj.nodes(:).raw=cpObj.raw;
        %         end
    end
    
end
function q = eul2quat(eul)
%conversion from Euler angles (radians) to quaternions
%rotation sequence is ZYX (following eul2quat from Robotics System Toolbox)

% Pre-allocate output
q = zeros(size(eul,1), 4, 'like', eul);

% Compute sines and cosines of half angles
c = cos(eul/2);
s = sin(eul/2);

% Construct quaternion
q = [c(:,1).*c(:,2).*c(:,3)+s(:,1).*s(:,2).*s(:,3), ...
    c(:,1).*c(:,2).*s(:,3)-s(:,1).*s(:,2).*c(:,3), ...
    c(:,1).*s(:,2).*c(:,3)+s(:,1).*c(:,2).*s(:,3), ...
    s(:,1).*c(:,2).*c(:,3)-c(:,1).*s(:,2).*s(:,3)];
end
function out = quat2axang(q)

%conversion from quaternions (Euler parameters) to axis-angle representation
%based on http://www.euclideanspace.com/maths/geometry/rotations/conversions/quaternionToAngle/
%first output is angle (radians), followed by axis

if q(1)>1, err('Quaternions should be normalized.'); end

angle = 2*acos(q(1)); %returns in radians
s = sqrt(1-q(1)^2);
if s < 0.001
    %if s is close to zero, then axis is not important (just pick something normalised)
    x = 1;
    y = 0;
    z = 0;
else
    x = q(2)/s;
    y = q(3)/s;
    z = q(4)/s;
end

out = [angle; x; y; z];

end

function eul = quat2eulang(q)

%conversion from quaternions to Euler angles (radians)
%rotation sequence is ZYX (following quat2eul from Robotics System Toolbox)

%q = normc(q(:)); %normalize !requires specific toolboxes for matlab version 2017
%versions
q = q./norm(q);

%extra check
test = -2*(q(2)*q(4)-q(1)*q(3));
if test>1, test = 1; end

eul(1,1) = atan2(2*(q(2)*q(3)+q(1)*q(4)),q(1)^2+q(2)^2-q(3)^2-q(4)^2);
eul(2,1) = asin(test);
eul(3,1) = atan2(2*(q(3)*q(4)+q(1)*q(2)),q(1)^2-q(2)^2-q(3)^2+q(4)^2);

if ~isreal(eul), eul = real(eul); end

end

function [CMglob, CMloc]=complt(raw,node)
nn=node.n;
ntr=node.sn(1).n;
nrot=node.sn(2).n;
tdef     =raw.tdef;
CMglob=zeros(6,6,tdef);
CMloc=zeros(6,6,tdef);
lnp         =raw.lnp;
nx          =raw.nx;
nxp         =raw.nxp;
nep         =raw.nep;
DX_data     =raw.dx;
K0_data     = raw.k0;
G0_data     =raw.g0;
N0_data     =raw.n0;
X_data      =raw.x ;
% locate the place of the coordinates of the points where the compliance
% has to be determined
locv=[lnp(ntr,1:3), lnp(nrot,1:4)];
% test whether the selected coordinates are feasible
% search for the right degrees of freedom
locdof=[nxp(3)+(1:nxp(4)), nxp(3)+nxp(4)+nep(3)+(1:nep(4))];
% locdof=[1:nxp(3)+nxp(4)+nep(3)+nep(4)] % from spavisual
%input coordinates    % dynamic coordinates   %dynamic deformations
% locdof=[nxp(2)+(1:nxp(3)),    nxp(3)+(1:nxp(4)),      nxp(3)+nxp(4)+nep(3)+(1:nep(4))]
if tdef > 1
    nddof = sqrt(length(K0_data(1,:)));
end

% start loop over the time steps
for tstp=1:tdef
    % get data from files
    %DX      =getfrsbf([filename '.sbd'],'dx',tstp);
    %X       =getfrsbf([filename '.sbd'],'x',tstp);
    % reduce DX to the rows needed
    if tdef > 1
        DX = reshape(DX_data(tstp,:),nx,[]);
        %K0      =getfrsbf([filename '.sbm'],'k0',tstp);
        %G0      =getfrsbf([filename '.sbm'],'g0',tstp);
        K0 = reshape(K0_data(tstp,:),nddof,[]);
        G0 = reshape(G0_data(tstp,:),nddof,[]);
        N0 = reshape(N0_data(tstp,:),nddof,[]);
        X = X_data(tstp,:);
    else
        DX = DX_data;
        K0 = K0_data;
        G0 = G0_data;
        N0 = N0_data;
        X = X_data;
    end
    DX = DX(locv,locdof);
    
    CMlambda=DX*((K0+G0+N0)\(DX'));
    % Reduce CMlambda to the correct matrices by the lambda matrices
    lambda0=X(locv(4));
    lambda1=X(locv(5));
    lambda2=X(locv(6));
    lambda3=X(locv(7));
    lambdabt=[ -lambda1  lambda0 -lambda3  lambda2
        -lambda2  lambda3  lambda0 -lambda1
        -lambda3 -lambda2  lambda1  lambda0 ];
    lambdat= [ -lambda1  lambda0  lambda3 -lambda2
        -lambda2 -lambda3  lambda0  lambda1
        -lambda3  lambda2 -lambda1  lambda0 ];
    Tglob= [ eye(3)     zeros(3,4)
        zeros(3,3) 2*lambdabt];
    Tloc = [ lambdat*(lambdabt') zeros(3,4)
        zeros(3,3) 2*lambdat];
    CMglob(:,:,tstp)=Tglob*CMlambda*(Tglob');
    CMloc(:,:,tstp)=Tloc*CMlambda*(Tloc');
end
end
function [CMglob, CMloc]=complt_new(raw,node)
mode=raw.mode;
nn=node.n;
ntr=node.sn(1).n;
nrot=node.sn(2).n;
tdef     =raw.tdef;
CMglob=zeros(6,6,tdef);
CMloc=zeros(6,6,tdef);
lnp         =raw.lnp;
nx          =raw.nx;
nxp         =raw.nxp;
nep         =raw.nep;
if mode==3
    DX_data     =raw.dx;
    K_data = getfrsbf([raw.p.filename '.ltv'],'K0B');
    locv=[lnp(ntr,1:3), lnp(nrot,1:4)];
    locdof=[1:nxp(3)+nxp(4)+nep(3)+nep(4)];
    nddof=raw.ndof;
        X_data      =raw.x ;
else
    DX_data     =raw.dx;
    K0_data     = raw.k0;
    G0_data     =raw.g0;
    N0_data     =raw.n0;
    K_data      =G0_data+K0_data+N0_data;
    X_data      =raw.x ;
    locv=[lnp(ntr,1:3), lnp(nrot,1:4)];
    locdof=[nxp(3)+(1:nxp(4)), nxp(3)+nxp(4)+nep(3)+(1:nep(4))];
    nddof=raw.nddof;
end

% start loop over the time steps
for tstp=1:tdef
    % get data from files
    % reduce DX to the rows needed
    if tdef > 1
        DX = reshape(DX_data(tstp,:),nx,[]);
        K  = reshape(K_data(tstp,:),nddof,[]);
        X = X_data(tstp,:);
    else
        DX = DX_data;
        K  = K_data;
        X = X_data;
    end
    DX = DX(locv,locdof);
    
    CMlambda=DX*((K)\(DX'));
    % Reduce CMlambda to the correct matrices by the lambda matrices
    lambda0=X(locv(4));
    lambda1=X(locv(5));
    lambda2=X(locv(6));
    lambda3=X(locv(7));
    lambdabt=[ -lambda1  lambda0 -lambda3  lambda2
        -lambda2  lambda3  lambda0 -lambda1
        -lambda3 -lambda2  lambda1  lambda0 ];
    lambdat= [ -lambda1  lambda0  lambda3 -lambda2
        -lambda2 -lambda3  lambda0  lambda1
        -lambda3  lambda2 -lambda1  lambda0 ];
    Tglob= [ eye(3)     zeros(3,4)
        zeros(3,3) 2*lambdabt];
    Tloc = [ lambdat*(lambdabt') zeros(3,4)
        zeros(3,3) 2*lambdat];
    CMglob(:,:,tstp)=Tglob*CMlambda*(Tglob');
    CMloc(:,:,tstp)=Tloc*CMlambda*(Tloc');
end
end