function autosolve(obj)
            %load data
            sbd     = [obj.filename '.sbd'];
            nep     = getfrsbf(sbd,'nep');
            nxp     = getfrsbf(sbd,'nxp');
            %nddof   = getfrsbf(sbd,'nddof');
            le      = getfrsbf(sbd,'le');
            BigD    = getfrsbf(sbd,'bigd',1);
            Dcc     = BigD( 1:(nep(1)+nep(3)+nep(4)) , nxp(1)+(1:nxp(2)) );
            IDlist = 1:size(Dcc,1);
            [ U, s, V ] = svd(Dcc);
            s       = diag(s);
            %if empty s
            if isempty(s) %%% TO BE DONE: s can be empty. What does this mean? => no calculable nodes? no freedom?
                exactconstr = false;
                return
            end
            
            % calcualate number of over/under constraints
            nsing = length(find(s<sqrt(eps)*s(1))); %number of near zero singular values
            if length(U)>length(V)
                nover  = length(U)-length(V)+nsing;
                nunder = nsing;
            elseif length(U)<length(V)
                nover  = nsing;
                nunder = length(V)-length(U)+nsing;
            else
                nover  = nsing;
                nunder = nsing;
            end
            
            if nunder>0 %underconstrained
                warning('System is underconstrained. Check element connectivity, boundary conditions and releases.')
                exactconstr = false;
                return
            elseif nover>0 %overconstrained
                % attempt autosolve
                
                %create empty rlse matrix used internally for autosolver
                %                 rlse = zeros(size(E_list,1),6);
                %number of initial overconstraints
                n = nover;
                
                for dummy = 1:n %solve for n overconstraints, loop counter is not required (dummy)
                    %redo SVD analyses (has to be redone after each resolved overconstrain)
                    [ U, ~, ~ ] = svd(Dcc);
                    
                    %part of U matrix coresponding to all overconstraints
                    overconstraint = U(:,end-nover+1:end);
                    %select part of U matrix corresponding to first overconstraint
                    oc = overconstraint(:,1);
                    [oc_sort,order] = sort(oc.^2,1,'descend');
                    % select only part that explains 99% (or more) of singular vector's length
                    idx = find(cumsum(oc_sort)>sqrt(1-1e-6),1,'first');
                    idx = order(1:idx);
                    sel = (1:numel(oc))';
                    %overconstrained deformation modes
                    sel = sel(idx);
                    
                    loop = true; %loop until proper solution for overconstraints is obtained
                    j = 1;       %start with deformation mode with highest singular value
                    while loop
                        if j>length(sel) %unsolvable, all deformations modes have been attempted, probably rigid body release required
                            warn('Overconstraints could not be solved automatically; partial release information is provided in the output.')
                            fprintf('Number of overconstraints left: %u\n\n',nover);
                            disp( table((1:size(rlse,1))',rlse(:,1),rlse(:,2),rlse(:,3),rlse(:,4),rlse(:,5),rlse(:,6),'VariableNames',{'Element' 'def_1' 'def_2 ' 'def_3' 'def_4' 'def_5' 'def_6'}))
                            %                     results.rls = restruct_rlse(rlse);
                            %workspace output of //remaining// overconstraints in same style as
                            %//full// overconstraint workspace output
                            for v = 1:size(rlse,1)
                                rlsout(v,1:nnz(rlse(v,:))+1) = [v find(rlse(v,:)==1)];
                            end
                            overconstraints = rlsout;
                            exactconstr = false;
                            return
                        end
                        
                        %Select deformation to be test for release
                        def_id = sel(j);
                        def = IDlist(def_id);
                        %After each release, Dcc matrix is
                        %reduced in size, causing shifting
                        %of deformation modes.
                        %i.e., if deformation mode 2 is
                        %released, deformation 3 shifts to
                        %position 2, deformation 4 to 3,
                        %etc.
                        %The IDlist variable tracks and
                        %compensates for this shift
                        
                        %element number and deformation
                        [elnr,defmode] = find(le==def);     % find element nr and deformation number from deformation mode number
                        dyne=obj.elements(elnr).dyne;       % get dynamic dofs from element elnr
                        if ismembc(defmode,dyne)           % check if deformation mode is dynamic and can be released
                            obj.elements(elnr).rlse=sort([obj.elements(elnr).rlse defmode]); % add deformation mode to releases
                            dyne(dyne==defmode)=[];          % remove selected mode from dyne
                            obj.elements(elnr).dyne=dyne;   % save dyne
                            IDlist(def_id) = []; %update IDlist for deformation tracking
                            Dcc(def_id,:) = []; %reduce Dcc matrix to remove this overconstrained
                            nover = nover-1; %reduce number of overconstraints
                            loop = false; %terminate while loop and redo from line 235
                            j=j+1;
                        end
                        
                        j=j+1;
                    end
                end
                %release information is in matrix form (rlse), it has to be restructured
                %for ouput in structure
                %                 opt.rls = restruct_rlse(rlse);
                exactconstr = true;
                
            else
                %no underconstraints and no overconstraints
                exactconstr = true;
                
            end
        end