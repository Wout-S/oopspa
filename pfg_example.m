clear
clc
 
% addpath('spacar') %point this to the spacar folder

%% NODE POSITIONS
nodes = [-50e-3 0.0 0       %node 1
         -50e-3 100e-3 0    %node 2
         0 100e-3 0         %node 3
         50e-3 100e-3 0     %node 4
         50e-3 0 0];        %node 5
 
%node 3 is only added so that the system properties can be evaluated right there

%% ELEMENT CONNECTIVITY
elements = [1 2             %element 1: 1st leafspring
            2 3             %element 2: 1st half of rigid body
            3 4             %element 3: 2nd half of rigid body
            4 5];           %element 4: 2nd leafspring
 
 
%% NODE PROPERTIES
nprops(1).fix = true;       %fix begin 1st leafspring
nprops(5).fix = true;       %fix end 2nd leafspring
 
nprops(3).force = [0 -10 0];%load of 10N on node 3 y-direction
nprops(3).mass = 1;         %1kg mass at node 3
nprops(3).displ_initial_x = -20e-3; %initial displacement, node 3 -20mm moved in x 
nprops(3).displ_x = 40e-3;  %additional displacement, node 3 40mm moved in x 
 
 
%% ELEMENT PROPERTIES
eprops(1).elems = [1 4];    %both leafsprings
eprops(1).emod = 210e9;     %steel
eprops(1).smod = 70e9;      %steel
eprops(1).dens = 7800;      %steel
eprops(1).dim = [30e-3 0.5e-3];
eprops(1).cshape = 'rect';
eprops(1).flex = [2 3 4];   %only bending and torsion flexible
eprops(1).orien = [0 0 1];
eprops(1).nbeams = 2;       %2 beams per element
eprops(1).color = [0.8549    0.8588    0.8667];
 
eprops(2).elems = [2 3];    %rigid body
eprops(2).dens = 2700;      %aluminium
eprops(2).dim = [30e-3 10e-3];
eprops(2).cshape = 'rect';
eprops(2).orien = [0 0 1];
eprops(2).color = [0.1686    0.3922    0.6627];
 
 
%% OPTIONAL
opt.gravity = [0 0 -9.81];  %gravity in z-direction
opt.loadsteps = 50;         %additional load steps (default 10) to get 
                            %higher resolution plots
 

%% DO SIMULATION
out = spacarlight(nodes,elements,nprops,eprops,opt);
 

%% POST PROCESS RESULTS
%plot stiffness values over the range of motion
Ky(:) = 1./out.node(3).CMglob(2,2,:); %y stiffness evaluated at node 3
Kz(:) = 1./out.node(3).CMglob(3,3,:); %z stiffness evaluated at node 3
x = out.node(3).p(1,:).*1000;         %position of the end-effector in mm (.*1000)
 
fig1 = figure;
hold on
plot(x,Ky)
plot(x,Kz)
grid minor
xlabel('x-position [mm]')
ylabel('y-stiffness [N/m]')
fig1.Children.YScale = 'log';        %plot with log yscale
fig1.Children.YLim = [1e4 1e10];