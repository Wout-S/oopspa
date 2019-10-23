clear
clc
addpath('C:\Users\schilderwp\Google Drive\spacar')
data=spadata;
p=[0 0 0;
   1 1 0;
   3 0 0];

kp=data.addkp(p);

fix_t(kp(1));
fix_r(kp(1),[ 1 1 0])
fix_t(kp(3),[0 1 1])
mass(kp(1),0.1)
mass(kp(2),0.1)
mass(kp(3),0.1)

steel=material(210e9,70e9,7600);                                            % create material
flex=section('rect',[30e-3 1.5e-3]);                                        % create crossection
beam=eprops('BEAM',[1:6],[0 0 1]);                                          % create element type
rbeam=eprops('BEAM',[],[0 0 1]);
hinge=eprops('HINGE',[1],[0 0 1]);
                                              % fix nodes at kp 3 in 2 directions

e1=data.addelem([kp(1).sn(2),data.addrnode],hinge,[],[]);
e2=data.addelem([kp(1).sn(1),e1.nodes(2),kp(2).sn(1),kp(2).sn(2)],beam,flex,steel);
e3=data.addelem([kp(2).sn(2),data.addrnode],hinge,[],[]);
e4=data.addelem([kp(2).sn(1),e3.nodes(2),kp(3).sn(1),kp(3).sn(2)],rbeam,flex,steel);
% e1.esig=1;
e1.nodes(1).c(4).delinpx=[1 0.5];
% e1.dyne=[]
% e1.rlse=1


data.filename='slidercrank'
% writedatfile(data)
data.runmode(1,true,false)
spadraw(data.filename)