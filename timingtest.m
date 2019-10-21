clear
filename='testfile';
spacar(-10,'testfile')


        nddof   = getfrsbf([filename '.sbd'],'nddof'); %number of dynamic DOFs
        t_list  =  1:getfrsbf([filename,'.sbd'],'tdef'); %list of timesteps
        lnp     = getfrsbf([filename,'.sbd'],'lnp'); %lnp data
        ln      = getfrsbf([filename,'.sbd'],'ln'); %lnp data
                x       = getfrsbf([filename '.sbd'] ,'x');
        fxtot   = getfrsbf([filename '.sbd'] ,'fxt');
        M0_data = getfrsbf([filename '.sbm'] ,'m0');
        G0_data = getfrsbf([filename '.sbm'] ,'g0');
        K0_data = getfrsbf([filename '.sbm'] ,'k0');
        N0_data = getfrsbf([filename '.sbm'] ,'n0');