classdef buildingblock < handle
    %BUILDBLOCK Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        elements
        endnodes
        kp
    end
    
    methods
        function obj = buildingblock(data,kp,type,bprops)
            %BUILDBLOCK Construct an instance of this class
            %   Detailed explanation goes here
            obj.endnodes=kp;
            epf=eprops('BEAM',1:6,bprops.orien); % flexible eprops
            epr=eprops('BEAM',[],bprops.orien);     % rigid eprops
            switch type
                case 'strip'
                    midpos=kp(1).p+kp(2).p/2;
                    kpmid=addkp(data,midpos);
                    e1=addelem(data,[kp(1),kpmid],epf,bprops.fsect,bprops.fmat);
                    e2=addelem(data,[kpmid,kp(2)],epf,bprops.fsect,bprops.fmat);
                    obj.elements=[e1 e2];
                case 'cfh'
                    lambda=bprops.dim(2); % cross point
                    alpha=bprops.dim(1);    % half cross angle
                    p=[kp(1).p; kp(2).p];
                    L=norm((p(1,:)-p(2,:)));
                    Ldir=(p(1,:)-p(2,:))/L;
                    L_ls=L/cos(alpha);
                    wdir=cross(epf.orien,Ldir);
                    w1=lambda*L_ls*sin(alpha);
                    w2=(1-lambda)*L_ls*sin(alpha);
                    np=[p(1,:)-w1*wdir;
                        p(1,:)+w1*wdir;
                        p(2,:)+w2*wdir;
                        p(2,:)-w2*wdir;];
                    kps=[kp data.addkp(np)];
                    rigid=[3 1; 1 4; 5 2; 2 6];
                    flex=[3 5
                        4 6];
                    eflex=data.addelem(kps(flex),epf,bprops.fsect,bprops.fmat);
                    erigid=data.addelem(kps(rigid),epr,bprops.rsect,bprops.rmat);
                case 'rotslav'
                    dim=bprops.dim;
                    p=[kp(1).p; kp(2).p; kp(3).p];
                    L=norm((p(1,:)-p(3,:)));
                    Ldir=(p(3,:)-p(1,:))/L;
                    tdir=cross(Ldir,epf.orien);
                    np=[dim(1)*tdir;
                        dim(1)*tdir+dim(2)*Ldir;
                        dim(4)*tdir+dim(2)*Ldir;
                        dim(3)*tdir+dim(2)*Ldir;
                        dim(3)*tdir+(L/2)*Ldir;
                        dim(4)*tdir+(L/2)*Ldir;
                        dim(1)*tdir+L*Ldir;]+p(1,:);
                    kps=[kp data.addkp(np)];
                    rconn=[4 5; 5 6; 6 7; 8 9; 8 2; 5 10];
                    fconn=[1 4; 6 9; 7 8; 10 3];
                    eflex=data.addelem(kps(fconn),epf,bprops.fsect,bprops.fmat);
                    erigid=data.addelem(kps(rconn),epr,bprops.rsect,bprops.rmat);
                case 'custom'
                    % custom building block based on a number of matrices
            end
            obj.kp=kps;
            obj.elements=[eflex,erigid];
        end
        
    end
end

