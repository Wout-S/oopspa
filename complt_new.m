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