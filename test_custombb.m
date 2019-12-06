clear
data=spadata;

w=0.01;
L=0.1;
steel=material(210e9,70e9,7800);
rmat=material(210e9,70e9,3000);
flex=section('rect',[w 0.2e-3]);
rigid=section('rect',[w 5e-3]);
beam=eprops('BEAM',[1:6],[0 1 0]);
beam2=eprops('BEAM',[1:6],[0 0 1]);
rbeam=eprops('BEAM',[],[ 0 1 0]);

%% define reinforced flexure bb
bb1=bbprops;
bb1.type='custom';
bb1.mat=[steel steel];
bb1.sect=[flex rigid];
bb1.eprops=[beam beam];
bb1.dim=[ 0.7];
bb1.p=@(dim,L) [L*(1-dim(1))/2 0 0; L-L*(1-dim(1))/2 0 0];
bb1.orien=[1 -1 0];
bb1.conn={[1 3; 4 2],[3 4]};

%% define nodes
p=[0 0 0;
   L L L];
kp=data.addkp(p);
fix(kp(1));
%% create bb
data.addbb(kp(1:2),bb1);

%% run
runmode(data,10,true,true)
spavisual(data.filename)