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
            %             epf=eprops('BEAM',1:6,bprops.orien); % flexible eprops
            %             if bprops.rigid
            %                 epr=eprops('BEAM',[],bprops.orien);     % rigid eprops
            %             else
            %                 epr=epf;
            %             end
            switch type
                case 'strip'
                    midpos=kp(1).p+kp(2).p/2;
                    kpmid=addkp(data,midpos);
                    kps=[kp, kpmid];
                    conn{1}=[1 3; 3 2];
                case 'cfh'
                    lambda=bprops.dim(2); % cross point
                    alpha=bprops.dim(1);    % half cross angle
                    p=[kp(1).p; kp(2).p];
                    L=norm((p(1,:)-p(2,:)));
                    Ldir=(p(1,:)-p(2,:))/L;
                    L_ls=L/cos(alpha);
                    wdir=cross(bprops.orien,Ldir);
                    w1=lambda*L_ls*sin(alpha);
                    w2=(1-lambda)*L_ls*sin(alpha);
                    np=[p(1,:)-w1*wdir;
                        p(1,:)+w1*wdir;
                        p(2,:)+w2*wdir;
                        p(2,:)-w2*wdir;];
                    kps=[kp data.addkp(np)];
                    conn{1}=[3 5; 4 6];             %flex
                    conn{2}=[3 1; 1 4; 5 2; 2 6];   %rigid

                case 'rotslav'
                    dim=bprops.dim;
                    p=[kp(1).p; kp(2).p; kp(3).p];
                    L=norm((p(1,:)-p(3,:)));
                    Ldir=(p(3,:)-p(1,:))/L;
                    tdir=cross(Ldir,bprops.orien);
                    np=[dim(1)*tdir;
                        dim(1)*tdir+dim(2)*Ldir;
                        dim(4)*tdir+dim(2)*Ldir;
                        dim(3)*tdir+dim(2)*Ldir;
                        dim(3)*tdir+(L/2)*Ldir;
                        dim(4)*tdir+(L/2)*Ldir;
                        dim(1)*tdir+L*Ldir;]+p(1,:);
                    kps=[kp data.addkp(np)];
                    conn{1}=[1 4; 6 9; 7 8; 10 3];
                    conn{2}=[4 5; 5 6; 6 7; 8 9; 8 2; 5 10];
                case 'rotslav_r'
                    dim=bprops.dim;
                    p=[kp(1).p; kp(2).p; kp(3).p];
                    L=norm((p(1,:)-p(3,:)));
                    Ldir=(p(3,:)-p(1,:))/L;
                    tdir=cross(Ldir,bprops.orien);
                    np=[dim(1)*tdir;
                        dim(1)*tdir+dim(2)*Ldir;
                        dim(4)*tdir+dim(2)*Ldir;
                        dim(3)*tdir+dim(2)*Ldir;
                        dim(3)*tdir+(L/2)*Ldir;
                        dim(4)*tdir+(L/2)*Ldir;
                        dim(1)*tdir+L*Ldir;]+p(1,:);
                    kps=[kp data.addkp(np)];
                    bbconn{1}=[1 4; 6 9; 7 8; 10 3];
                    conn{2}=[4 5; 5 6; 6 7; 8 9; 8 2; 5 10];
                    bprops2=bprops;
                    bprops2.dim=bprops.dim(5);
                    bb=data.addbb(kps(bbconn{1}),'reinf',bprops2);
                case 'reinf'
                    r=bprops.dim(1);
                    p=[kp(1).p; kp(2).p];
                    L=norm((p(2,:)-p(1,:)));
                    Ldir=(p(2,:)-p(1,:))/L;
                    np=[(L-r*L)/2*Ldir;
                        ((L-r*L)/2+r*L)*Ldir]+p(1,:);
                    kps=[kp data.addkp(np)];
                    conn{1}=[1 3; 4 2];
                    conn{2}=[3 4];
                case 'tapered'
                    nel=6;
                    dim=bprops.dim;
                    p=[kp(1).p; kp(2).p];
                    L=norm((p(2,:)-p(1,:)));
                    Ldir=(p(2,:)-p(1,:))/L;
                    dl=linspace(L/nel,L-L/nel,nel-1);
                    dl1=L/nel;
                    larray=0:dl1:L;
                    x=larray(1:end-1)+dl1/2;
                    w1=bprops.sect(1).dim(1);
                    w2=bprops.sect(2).dim(1);
                    t1=bprops.sect(1).dim(2);
                    t2=bprops.sect(2).dim(2);
                    W=(w2-w1)/L.*x+w1;
                    t=(t2-t1)/L.*x+t1;
                    
                    dir2=Ldir;
                    np= [dir2*dl(1);
                    dir2*dl(2);
                    dir2*dl(3);
                    dir2*dl(4);
                    dir2*dl(5)]+p(1,:);
                    kps=[kp(1) data.addkp(np) kp(2)];
                    for i=1:nel
                        conn{i}=[i i+1];
                        bprops.eprops(i)=bprops.eprops(1);
                        bprops.mat(i)=bprops.mat(1);
                        bprops.sect(i)=section('rect',[W(i),t(i)]);
                    end
                    
                case 'custom'
                    % custom building block based on a number of matrices,
                    % np, conn{i}
            end
            for i=1:numel(bprops.sect)
                if ~isempty(conn{i})
                    ei=data.addelem(kps(conn{i}),bprops.eprops(i),bprops.sect(i),bprops.mat(i));
                    obj.elements=[obj.elements ei];
                end
            end
            obj.kp=kps;
            %             obj.elements=[eflex,erigid];
        end
        
    end
end

