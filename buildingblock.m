classdef buildingblock < handle
    %BUILDBLOCK Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        elements
        endnodes
        kp
    end
    
    methods
        function obj = buildingblock(data,kp,bprops)
            %BUILDBLOCK Construct an instance of this class
            %   Detailed explanation goes here
            obj.endnodes=kp;
            for i=1:numel(kp)
                p(i,:)=kp(i).p;         % get positions of keypoints
            end
            L=norm((p(2,:)-p(1,:)));    % building block length
            xdir=(p(2,:)-p(1,:))/L;     % Length direction
            ydir=bprops.orien/norm(bprops.orien);          % entered width direction
            zdir=cross(xdir,ydir);      % computed thickness direction
            %             epf=eprops('BEAM',1:6,bprops.orien); % flexible eprops
            %             if bprops.rigid
            %                 epr=eprops('BEAM',[],bprops.orien);     % rigid eprops
            %             else
            %                 epr=epf;
            %             end
            switch bprops.type
                case 'strip'
                    midpos=kp(1).p+kp(2).p/2;
                    kpmid=addkp(data,midpos);
                    kps=[kp, kpmid];
                    conn{1}=[1 3; 3 2];
                case 'cfh'
                    lambda=bprops.dim(2); % cross point
                    alpha=bprops.dim(1);    % half cross angle
                    %                     p=[kp(1).p; kp(2).p];
                    L=norm((p(1,:)-p(2,:)));
                    %                     xdir=(p(1,:)-p(2,:))/L;
                    L_ls=L/cos(alpha);
                    %                     ydir=cross(bprops.orien,xdir);
                    w1=lambda*L_ls*sin(alpha);
                    w2=(1-lambda)*L_ls*sin(alpha);
                    np=[p(1,:)-w1*zdir;
                        p(1,:)+w1*zdir;
                        p(2,:)+w2*zdir;
                        p(2,:)-w2*zdir;];
                    kps=[kp data.addkp(np)];
                    conn{1}=[3 5; 4 6];             %flex
                    conn{2}=[3 1; 1 4; 5 2; 2 6];   %rigid
                    
                case 'rotslav'
                    dim=bprops.dim;
                    %                     p=[kp(1).p; kp(2).p; kp(3).p];
                    %                     L=norm((p(1,:)-p(3,:)));
                    %                     xdir=(p(3,:)-p(1,:))/L;
                    %                     zdir=cross(xdir,bprops.orien);
                    np=[dim(1)*zdir;
                        dim(1)*zdir+dim(2)*xdir;
                        dim(4)*zdir+dim(2)*xdir;
                        dim(3)*zdir+dim(2)*xdir;
                        dim(3)*zdir+(L/2)*xdir;
                        dim(4)*zdir+(L/2)*xdir;
                        dim(1)*zdir+L*xdir;]+p(1,:);
                    kps=[kp data.addkp(np)];
                    conn{1}=[1 4; 6 9; 7 8; 10 2];              %flex
                    conn{2}=[4 5; 5 6; 6 7; 8 9; 8 3; 5 10];    %rigid
                case 'rotslav_r'
                    dim=bprops.dim;
                    %                     p=[kp(1).p; kp(2).p; kp(3).p];
                    %                     L=norm((p(1,:)-p(3,:)));
                    %                     xdir=(p(3,:)-p(1,:))/L;
                    %                     zdir=cross(xdir,bprops.orien);
                    np=[dim(1)*zdir;
                        dim(1)*zdir+dim(2)*xdir;
                        dim(4)*zdir+dim(2)*xdir;
                        dim(3)*zdir+dim(2)*xdir;
                        dim(3)*zdir+(L/2)*xdir;
                        dim(4)*zdir+(L/2)*xdir;
                        dim(1)*zdir+L*xdir;]+p(1,:);
                    kps=[kp data.addkp(np)];
                    bbconn{1}=[1 4; 6 9; 7 8; 10 2];
                    conn{2}=[4 5; 5 6; 6 7; 8 9; 8 3; 5 10];
                    bprops2=bprops;
                    bprops2.dim=bprops.dim(5);
                    bprops2.type='reinf';
                    bb=data.addbb(kps(bbconn{1}),'reinf',bprops2);
                case 'reinf'
                    r=bprops.dim(1);
                    %                     p=[kp(1).p; kp(2).p];
                    %                     L=norm((p(2,:)-p(1,:)));
                    %                     xdir=(p(2,:)-p(1,:))/L;
                    np=[(L-r*L)/2*xdir;
                        ((L-r*L)/2+r*L)*xdir]+p(1,:);
                    kps=[kp data.addkp(np)];
                    conn{1}=[1 3; 4 2];
                    conn{2}=[3 4];
                case 'tapered'
                    nel=6;
                    %                     p=[kp(1).p; kp(2).p];
                    %                     L=norm((p(2,:)-p(1,:)));
                    %                     xdir=(p(2,:)-p(1,:))/L;
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
                    
                    dir2=xdir;
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
%                     for i=1:numel(kp)
%                         p(i,:)=kp(i).p;         % get positions of keypoints
%                     end
                    %                     L=norm((p(2,:)-p(1,:)));    % building block length
                    %                     xdir=(p(2,:)-p(1,:))/L;     % Length direction
                    %                     ydir=bprops.orien/norm(bprops.orien);          % entered width direction
                    %                     zdir=cross(xdir,ydir);      % computed thickness direction
                    np1_fun=bprops.p;           % function handle dependent on dimensions and computed length
                    np1=np1_fun(bprops.dim,L);  % uncorrected positions, [0,0,0] is at kp(1).p
                    for i=1:size(np1,1)
                        np(i,:)=np1(i,1)*xdir+np1(i,2)*ydir+np1(i,3)*zdir+p(1,:); % rotate and transpose nodes
                    end
                    kps=[kp data.addkp(np)];    % create keypoints
                    for i=1:numel(bprops.eprops)  % change local y axis to global y axis
                        o_old=bprops.eprops(i).orien;
                        o_new=o_old(1)*xdir+o_old(2)*ydir+o_old(3)*zdir; % correct orientation vectors of elements
                        bprops.eprops(i).orien=o_new;
                    end
                    for i=1:numel(bprops.conn)
                        conn{i}=bprops.conn{i}; % setup connection matrices
                    end
            end
            if dot(xdir,bprops.orien)
                warning('bbprops.orien is not perpendicular to local x-axis of builing block')
            end
            for i=1:numel(conn)
                if ~isempty(conn{i})
                    ei=data.addelem(kps(conn{i}),bprops.eprops(i),bprops.sect(i),bprops.mat(i));
                    obj.elements=[obj.elements ei];
                end
            end
            obj.kp=kps;
        end
        
    end
end

