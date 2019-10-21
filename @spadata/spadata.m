classdef spadata < handle %& matlab.mixin.Copyable
    %SPADATA Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        gravity
        loadsteps
        filename='default'
    end
    properties (SetAccess=private)
        nodes=node.empty
        keypoints=keypoint.empty
        elements=element.empty
        buildingblocks=buildingblock.empty
        smax                                % max stress results
        raw                               % unprocessed spacar results
        freq                                % eigenfrequency results
        perturbdata
        freq_p
    end
    methods
        function obj=spadata() % constructor
            obj.raw=rawdata(obj);
            %             obj.raw.filename=obj.filename;
        end
        
        function set.filename(obj,fn)
            obj.filename=fn;
            %             obj.raw.filename=obj.filename;
        end
        
        writedatfile(obj)
        autosolve(obj)
        [CMglob, CMloc]=complt(obj,node)
        
        function out = addnode(obj,type)
            %METHOD1 create node
                n=numel(obj.nodes); %get number of existing nodes
                out = node(n+1,type);
%                 out.type=type;
%                 out.raw=obj.raw;
%                 out.parent=obj;
                obj.nodes(n+1)=out;
        end
        
        function out = addelem(obj,nodes,eprops,sect,mat)
            for i=1:size(nodes,1)
                n=numel(obj.elements); % get number of existing elements
                out(i)=element(nodes(i,:),n+1,eprops,sect,mat);
                obj.elements(n+1)=out(i);
            end
        end
        function out= addkp(obj,p)
            
            for i=1:size(p,1) % for number of rows
                n=numel(obj.keypoints); %get number of existing nodes
                out(i) = keypoint(obj,p(i,:),n+1);
                out(i).raw=obj.raw;
                out(i).parent=obj;
                obj.keypoints(n+1)=out(i);
            end
        end
        function out = addbb(obj,nodes,bbtype,eprops,sect,mat)
            n=numel(obj.buildingblocks); % get number of existing elements
            out = buildingblock(obj,nodes,bbtype,eprops,sect,mat);
            obj.buildingblocks(n+1) = out;
        end
        
        function run(obj,mode)
            warning('off','all')
            [~]=spacar(mode,obj.filename);
            warning('on','all')
            %             disp('spacar run succeeded')
        end
        function runmode(obj,mode,as)
            
            if as % autosolve
                %reset dyne
                for i=1:numel(obj.elements)
                    obj.elements(i).dyne=obj.elements(i).flex;
                    obj.elements(i).rlse=[];
                end
                writedatfile(obj)
                %                 warning('off','all')
                run(obj,0)
                %                 warning('on','all')
                autosolve(obj)
                writedatfile(obj)
                run(obj,mode);
            else
                writedatfile(obj)
                run(obj,mode);
            end
        end
        function perturb(obj)
            mode=3;
            newfn=[obj.filename '_3'];
            copyfile([obj.filename '.dat'],[newfn '.dat'])
            [~]=spacar(mode,newfn);
            p.filename=newfn;
            obj.perturbdata=rawdata(p);
            
        end
        function sm=get.smax(obj)
            Sig_nums=[];
            propcrossect=[];
            for i=1:numel(obj.elements)
                if ~isempty(obj.elements(i).dyne) || ~isempty(obj.elements(i).rlse)
                    propcrossect(end+1).CrossSection=obj.elements(i).sect.shape;
                    propcrossect(end).Dimensions=obj.elements(i).sect.dim;
                    Sig_nums=[Sig_nums obj.elements(i).n];
                end
            end
            sm=zeros(1,obj.loadsteps);
            opt_stress.exterior = true; %only calculate exterior stresses (not possible for circ cross-section)
            for i=obj.raw.t_list
                [~,~,~,stressextrema] = stressbeam([obj.filename,'.sbd'],Sig_nums,i,opt_stress,propcrossect);
                
                sm(i)= stressextrema.max*1e6; %per loadstep
            end
        end
        
        function out=get.freq(obj)
            M0_data = obj.raw.m0;
            G0_data = obj.raw.g0;
            K0_data = obj.raw.k0;
            N0_data = obj.raw.n0;
            nddof   = obj.raw.nddof;
            nk = sqrt(size(K0_data,2));%number of elementen in K,M,G,N matrix if t_list > 1
            t_list=1:obj.loadsteps;
            for i=t_list
                if length(t_list) > 1
                    K0 = reshape(K0_data(i,:),nk,[]);
                    N0 = reshape(N0_data(i,:),nk,[]);
                    G0 = reshape(G0_data(i,:),nk,[]);
                    M0 = reshape(M0_data(i,:),nk,[]);
                else
                    K0 =K0_data;
                    N0 = N0_data;
                    G0 = G0_data;
                    M0 = M0_data;
                end
                if nddof>10
                    [V,D]   = eigs(K0+N0+G0,M0,10,'sm');
                else
                    [V,D]   = eig(K0+N0+G0,M0);
                end
                
                D       = diag(D);
                [~,o]   = sort(abs(D(:)));
                d       = D(o);
                f(:,i) = sqrt(d)*1/(2*pi); %per loadstep
            end
            out=f;
        end
        function out=get.freq_p(obj)
            mode=obj.perturbdata.mode;
            if mode==3
                nddof=obj.perturbdata.ndof;
                %                 M0_data = getfrsbf([obj.filename '.ltv'],'M0');
                %                 K_data = getfrsbf([obj.filename '.ltv'],'K0B');
                K_data=obj.perturbdata.k0b_ltv;
                M0_data=obj.perturbdata.m0_ltv;
            else
                M0_data = obj.raw.m0;
                G0_data = obj.raw.g0;
                K0_data = obj.raw.k0;
                N0_data = obj.raw.n0;
                K_data=N0_data+K0_data+G0_data;
                nddof   = obj.raw.nddof;
            end
            %             ndof = sqrt(size(K0_data,2));%number of elementen in K,M,G,N matrix if t_list > 1
            t_list=1:obj.loadsteps;
            for i=t_list
                if length(t_list) > 1
                    M0 = reshape(M0_data(i,:),nddof,[]);
                    K = reshape(K_data(i,:),nddof,[]);
                else
                    M0 = M0_data;
                    K=K_data;
                end
                if nddof>10
                    [V,D]   = eigs(K,M0,10,'sm');
                else
                    [V,D]   = eig(K,M0);
                end
                
                D       = diag(D);
                [~,o]   = sort(abs(D(:)));
                d       = D(o);
                f(:,i) = sqrt(d)*1/(2*pi); %per loadstep
            end
            out=f;
        end
        
    end
    methods(Access = protected)
        %         % Override copyElement method:
        %         function cpObj = copyElement(obj)
        %             % Make a shallow copy of all four properties
        %             cpObj = copyElement@matlab.mixin.Copyable(obj);
        %             % Make a deep copy of the raw object
        %             cpObj.raw = copy(obj.raw);
        %             cpObj.nodes = copy(obj.nodes);
        %             %           cpObj.nodes(:).raw=cpObj.raw;
        %         end
    end
end
