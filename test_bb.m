clear
addpath('C:\Users\schilderwp\Google Drive\spacar')
data=spadata


steel=material(210e9,70e9,7800);
rmat=material(210e9,70e9,3000);
flex=section('rect',[50e-3 0.2e-3]);
rigid=section('rect',[50e-3 10e-3]);
beam=eprops('BEAM',[1:6],[0 0 1]);
rbeam=eprops('BEAM',[],[1 0 0]);

p=[0 0 0;
   0 0.1 0;
   0 0.1 0.05;
   0 0 0.05
   0 0 0.1
   0 0.1 0.1]
   
kp=data.addkp(p)
bb1p=bbprops
bb1p.type='cfh'
bb1p.mat=[steel rmat];
bb1p.sect=[flex rigid];
bb1p.eprops=[beam beam];
bb1p.orien=[0 0 1];
alpha=0.5;
lambda=0.5;
bb1p.dim=[alpha, lambda]
bb1=data.addbb(kp(1:2),bb1p)
e1=data.addelem(kp(2:3),rbeam,rigid,rmat)
bb1=data.addbb(kp(3:4),bb1p)
% e1=data.addelem(kp(4:5),rbeam,rigid,rmat)
% bb1=data.addbb(kp(5:6),'cfh',bb1p)

fix(kp(1))

rot(kp(4),[0 0 1])

runmode(data,10,true,true)
spavisual(data.filename)