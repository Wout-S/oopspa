classdef buildingblock < handle
    %BUILDBLOCK Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        elements
        endnodes
        keypoints
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
                    h=norm((p(1,:)-p(2,:)));
                    hdir=(p(1,:)-p(2,:))/h;
                    L=h/cos(alpha);
                    wdir=cross(hdir,epf.orien);
                    w1=lambda*L*sin(alpha);
                    w2=(1-lambda)*L*sin(alpha);
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
                    obj.keypoints=kps;
                    obj.elements=[eflex,erigid];
            end
        end
        
    end
end

