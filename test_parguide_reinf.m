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


n=data.addkp(p);
%% 
bb1p=bbprops;
bb1p.mat=[steel, mat2];
bb1p.sect=[flex rigid];
bb1p.eprops=[beam rbeam];
bb1p.type='reinf';
bb1p.dim=0.7;
bb1p.orien=[0 0 1];
% e1=data.addelem([n1, n2],'BEAMW',sec1,steel)
flexelems=data.addbb([n(1), n(2);n(3) n(4)],bb1p);
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
displ_x(n(3),0.01)
data.runmode(10,true,true)
c3=n(3).CMglob(:,:,10)
f1=data.freq;


spavisual(data.filename)






