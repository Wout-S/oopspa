        function [CMglob, CMloc]=complt(obj,node)
            nn=node.n;
            ntr=obj.nodes(nn).sn(1).n;
            nrot=obj.nodes(nn).sn(2).n;
            tdef     =obj.raw.tdef;
            CMglob=zeros(6,6,tdef);
            CMloc=zeros(6,6,tdef);
            lnp         =obj.raw.lnp;
%             nx          =getfrsbf([obj.filename '.sbd'],'nx');
%             nxp         =getfrsbf([obj.filename '.sbd'],'nxp');
%             nep         =getfrsbf([obj.filename '.sbd'],'nep');
%             DX_data     =getfrsbf([obj.filename '.sbd'],'dx');
            nx          =obj.raw.nx;
            nxp         =obj.raw.nxp;
            nep         =obj.raw.nep;
            DX_data     =obj.raw.dx;
            K0_data     = obj.raw.k0;
            G0_data     =obj.raw.g0;
            X_data      =obj.raw.x ;
            % locate the place of the coordinates of the points where the compliance
            % has to be determined
            locv=[lnp(ntr,1:3), lnp(nrot,1:4)];
            % test whether the selected coordinates are feasible
            % for i=1:7
            %   if locv(i) <= 0
            %     disp('ERROR: invalid node number');
            %     return;
            %   end;
            %   if locv(i) <= nxp(1) || ...
            %      (locv(i)>(nxp(1)+nxp(2)) && locv(i) <= (nxp(1)+nxp(2)+nxp(3)))
            %     disp('WARNING: constrained node');
            %   end;
            % end;
            % search for the right degrees of freedom
            locdof=[nxp(3)+(1:nxp(4)), nxp(3)+nxp(4)+nep(3)+(1:nep(4))];
            
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
                    X = X_data(tstp,:);
                else
                    DX = DX_data;
                    K0 = K0_data;
                    G0 = G0_data;
                    X = X_data;
                end
                DX = DX(locv,locdof);
                
                CMlambda=DX*((K0+G0)\(DX'));
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