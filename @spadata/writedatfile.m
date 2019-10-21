function writedatfile(obj)
if ispc
    username = getenv('username');
elseif ismac
    username = getenv('USER');
end
% d=datetime;
% dat=datestr(d);
dat=' ';
pr_I = sprintf('#Dat-file generated with oopspa \n#Date: %s\n#User: %s',dat,username);
pr_I = sprintf('%s \n%s',pr_I,'OUTLEVEL 0 1');
% print nodal data
pr_N = sprintf('#NODES\t Nn\t\t\tX\t\t\tY\t\t\tZ');
pr_FIX = sprintf('# NODAL FIXES ');
pr_INPUT=sprintf('#INPUT displacement directions');
pr_INPUTVAL=sprintf('#INPUT initial displacement magnitudes');
pr_DELINPUTVAL=sprintf('#INPUT displacement magnitudes');
pr_XF=sprintf('#INPUT initial force/moment magnitudes');
pr_DELXF=sprintf('#INPUT force/moment magnitudes');
pr_XM=sprintf('#XM nodal mass/inertia');
id_add=false;
id_ini=false;
for i=1:numel(obj.nodes)
    
    p=obj.nodes(i).p;
    if ~isempty(p)
        pr_N = sprintf('%s\nX\t\t%3u\t\t\t%6f\t%6f\t%6f\t\t#node %u',pr_N,obj.nodes(i).n,p(1),p(2),p(3),obj.nodes(i).n);
    end
    nn=obj.nodes(i).n; %spacar node number
    type=obj.nodes(i).type; % spacar node type
    % print nodal fixes
    if ~isempty(obj.nodes(i).fix)
        fixes= sprintf('%3u \t',obj.nodes(i).fix);
        pr_FIX=sprintf('%s\n FIX \t %3u %s',pr_FIX, nn,fixes);
    end
    % print input displacements
    dval_init=obj.nodes(i).inputx; % get initial displacement values
    dval=obj.nodes(i).delinpx;% get displacement values
    inputdirval=[find(dval_init),find(dval)];
    if ~isempty(inputdirval)
        inputdirs=sprintf('%3u \t',unique(inputdirval)); % print unique values
        pr_INPUT=sprintf('%s \n INPUTX %3u %s',pr_INPUT,nn,inputdirs);
    end
    if ~isempty(dval_init)
        id_ini=true;
        for k=find(dval_init)
            pr_INPUTVAL=sprintf('%s \n INPUTX %3u \t %3u \t %6f \t #%s', pr_INPUTVAL,nn,k, obj.nodes(i).inputx(k),type);
        end
    end
    if ~isempty(dval)
        id_add=true;
        for k=find(dval)
            pr_DELINPUTVAL=sprintf('%s \n DELINPX %3u \t %3u \t %6f \t #%s', pr_DELINPUTVAL,nn,k, obj.nodes(i).delinpx(k),type);
        end
    end
    % print input forces and moments
    
    if ~isempty(obj.nodes(i).xf)
        fm_init=sprintf('%6f \t',obj.nodes(i).xf); % get initial force/moment values
        id_ini=true;
        pr_XF=sprintf('%s \n XF %3u \t %s \t #%s', pr_XF,nn, fm_init,type);
    end
    if ~isempty(obj.nodes(i).delxf)
        fm=sprintf('%6f \t',obj.nodes(i).delxf);% get force/moment values
        id_add=true;
        pr_DELXF=sprintf('%s \n DELXF %3u \t  %s \t #%s', pr_DELXF,nn, fm,type);
    end
    % print nodal masses
    if ~isempty(obj.nodes(i).xm)
        xm=sprintf('%6f \t',obj.nodes(i).xm);
        pr_XM=sprintf('%s \n XM %3u \t %s \t #%s',pr_XM,nn,xm,type);
    end
    
end
% print element data
pr_E=sprintf('#ELEMENTS');
pr_ESTIFF=sprintf('#stiffness properties');
pr_EM=sprintf('# mass properties');
pr_ESIG=' ';
pr_DEF=sprintf('#DEF');
pr_VIS=sprintf('VISUALIZATION \nINITIAL \nCOLOR		0.00	0.00	0.00');
for i=1:numel(obj.elements)
    % print element definition
    prnodes=sprintf('%3u \t',obj.elements(i).spanodes);
    prorien=sprintf('%6f \t',obj.elements(i).orien);
    pr_E = sprintf('%s\n%s\t %3u \t %s %s #element %u',pr_E, obj.elements(i).etype,obj.elements(i).n,prnodes,prorien,obj.elements(i).n);
    % print estiff lines
    if ~isempty(obj.elements(i).ESTIFF)
        prestiff=sprintf('%20.15f \t',obj.elements(i).ESTIFF);
        pr_ESTIFF = sprintf('%s\n ESTIFF \t %3u \t %s',pr_ESTIFF,obj.elements(i).n,prestiff);
    end
    % print em lines
    if ~isempty(obj.elements(i).EM)
        prem=sprintf('%20.15f \t',obj.elements(i).EM);
        pr_EM = sprintf('%s\n EM \t %3u \t %s',pr_EM,obj.elements(i).n,prem);
    end
    % print dof lines
    if ~isempty(obj.elements(i).dyne)
        prdyne=sprintf('%3u \t',obj.elements(i).dyne);
        pr_DEF=sprintf('%s \n DYNE %3u \t %s',pr_DEF,obj.elements(i).n,prdyne);
    end
    if ~isempty(obj.elements(i).rlse)
        prrlse=sprintf('%3u \t',obj.elements(i).rlse);
        pr_DEF=sprintf('%s \n RLSE %3u \t %s',pr_DEF,obj.elements(i).n,prrlse);
    end
    if ~isempty(obj.elements(i).esig)
        pr_ESIG=sprintf('%s \n ESIG \t %3u \t %6f',pr_ESIG,obj.elements(i).n,obj.elements(i).esig);
    end
    %     end
    % visualization
    if ~isempty(obj.elements(i).sect)
        pr_VIS=sprintf('%s \n BEAMPROPS \t %3u',pr_VIS,obj.elements(i).n);
        pr_VIS=sprintf('%s \n CROSSTYPE \t %s',pr_VIS,upper(obj.elements(i).sect.shape));
        dim=sprintf('%6f \t',obj.elements(i).sect.dim);
        pr_VIS=sprintf('%s \n CROSSDIM \t %s',pr_VIS,dim);
        pr_VIS=sprintf('%s \n GRAPHICS \t %3u',pr_VIS,obj.elements(i).n);
        color=sprintf('%6f \t',obj.elements(i).color);
        pr_VIS=sprintf('%s \n FACECOLOR \t %s',pr_VIS,color);
        pr_VIS=sprintf('%s \n OPACITY \t %.2f',pr_VIS,obj.elements(i).opacity);
    end
    
end
% print additional data
% print gravity
pr_ADD=sprintf('#Additional options');
if ~isempty(obj.gravity)
    grav=sprintf('%6f \t',obj.gravity);
    pr_ADD=sprintf('%s \n GRAVITY \t %s',pr_ADD, grav);
end
% print load steps
if ~isempty(obj.loadsteps)
    steps = obj.loadsteps-1;
else
    steps = 9;
end
if      (id_ini && id_add);      pr_ADD = sprintf('%s\n\nITERSTEP\t10\t%3u\t0.0000005\t1\t3\t%3u',pr_ADD,steps,steps);    %if initial and aditional loading/displacement
elseif  (id_ini && ~id_add);     pr_ADD = sprintf('%s\n\nITERSTEP\t10\t1\t0.0000005\t1\t1\t%3u',pr_ADD,steps);    %if initial loading/displacement
elseif  (~id_ini && id_add);     pr_ADD = sprintf('%s\n\nITERSTEP\t10\t%3u\t0.0000005\t1\t3\t0',pr_ADD,steps);     %if initial loading/displacement
else                       ;     pr_ADD = sprintf('%s\n\nITERSTEP\t10\t1\t0.0000005\t1\t1\t0',pr_ADD);    %no loading/displacement
end

fileID = fopen([obj.filename '.dat'],'w');
formatSpec='%s\n\n\n\n';
fprintf(fileID,formatSpec,pr_I); % print init
fprintf(fileID,formatSpec,pr_N); % print nodes
fprintf(fileID,formatSpec,pr_E); % print elements
fprintf(fileID,formatSpec,pr_DEF); % print deformation dofs
fprintf(fileID,formatSpec,pr_FIX); % print nodal fixes
fprintf(fileID,formatSpec,pr_INPUT);% print input displacement directions



fprintf(fileID,'\n END \n HALT \n \n');
fprintf(fileID,formatSpec,pr_ESTIFF);   % print stiffness data
fprintf(fileID,formatSpec,pr_EM);       % print mass data
fprintf(fileID,formatSpec,pr_ESIG);
fprintf(fileID,formatSpec,pr_XF);       % print force/moment magnitude
fprintf(fileID,formatSpec,pr_DELXF);
fprintf(fileID,formatSpec,pr_INPUTVAL); % print input displacement/rotation magintude
fprintf(fileID,formatSpec,pr_DELINPUTVAL);
fprintf(fileID,formatSpec,pr_XM);       % print nodal mass/inertia
fprintf(fileID,formatSpec,pr_ADD);% print additional properties like iterstep/gravity
fprintf(fileID,' \n END \n END \n \n');

fprintf(fileID,formatSpec,pr_VIS);%print visualization data

fclose(fileID); %datfile finished!
end