clear all
addpath('C:\Users\schilderwp\Google Drive\spacar')
data=spadata

steel=material(210e9,70e9,7800);
mat2=material(210e9,70e9,3000);
flex=section('rect',[50e-3 0.2e-3]);
rigid=section('rect',[50e-3 10e-3]);
beam=eprops('BEAM',[1:6],[0 0 1]);
rbeam=eprops('BEAM',[],[0 0 1]);

p = [   0 0 0;      %node 1
    0 0.1 0;    %node 2
    0.1 0.1 0;  %node 3
    0.1 0 0];   %node 4
% n1=data.addnode(p(1,:));

n=data.addnode(p);

% e1=data.addelem([n1, n2],'BEAMW',sec1,steel)
flexelems=data.addelem([n(1), n(2);n(3) n(4)],beam,flex,steel);
e2=data.addelem([n(2), n(3)],rbeam,rigid,mat2);
% e3=data.addelem([n(2), n(4)],beam,flex,steel);

fix(n(1));
fix(n(4));

% moment_initial(n(3),[0 0 -0.025]);
% moment(n(3),[0 0 0.05]);
mass(n(3),0.1);


% bb=data.addbb([n2 n4],'strip',ep1,sec1,steel)
% n5=findobj(data.nodes,'p',[1.5 0 0]) % get the handle for automatically created node\

data.loadsteps=10;
data.gravity=[0 0 -9.81];
data.filename='testfile';

%%
% run in mode 10
displ(n(3),[0.01 0 0])
data.runmode(10,true)
c3=n(3).CMglob(:,:,10)
f1=data.freq;

data.filename='testfile_3';

t=10

data.runmode(3,false)
c3_1=n(3).CMglob(:,:,t)
c3_1a=n(3).CMglob_new(:,:,t)
f_1=data.freq
% spavisual(data.filename)

% delete inputx, 
displ(n(3),[])
data.runmode(3,true)
c3_2=n(3).CMglob(:,:,t)
c3_2a=n(3).CMglob_new(:,:,t)
f_2=data.freq

dif1=c3_1./c3_1a
dif2=c3_2./c3_2a
dif3=c3_1a./c3_2a







