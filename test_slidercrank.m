clear
clc
data=spadata;
p=[0 0 0;
   1 1 0;
   3 0 0];

n=data.addnode(p);

fix(n(1));
fix_t(n(3),[0 1 1])
mass(n(3),0.1)

steel=material(210e9,70e9,7600);
flex=section('rect',[30e-3 1.5e-3]);
beam=eprops('BEAM',[1:6],[0 0 1]);
rbeam=eprops('BEAM',[],[0 0 1]);
hinge=eprops('HINGE',[1],[0 0 1]);


e1=data.addelem([n(1),data.addnode([])],hinge,[],[]);
e2=data.addelem([e1.nodes(2),n(2)],beam,flex,steel);
e3=data.addelem([n(2),data.addnode([])],hinge,[],[]);
e4=data.addelem([e3.nodes(2),n(3)],rbeam,flex,steel);
e1.esig=1;

data.filename='slidercrank'
writedatfile(data)
data.runmode(1,true)
