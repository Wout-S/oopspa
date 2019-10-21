% EXAMPLE SCRIPT FOR RUNNING SPACAR LIGHT
% This example simulates a simple cross flexure rotating due to an applied moment

clear
clc
addpath('C:\Users\schilderwp\Google Drive\spacar\spalight_beamw')
addpath('C:\Users\schilderwp\Google Drive\spacar')

%% NODE POSITIONS
%           x y z
nodes = [   0 0 0;      %node 1  
            0 0.1 0;    %node 2  
            0.1 0.1 0;  %node 3
            0.1 0 0];   %node 4

        
%% ELEMENT CONNECTIVITY
%               p   q
elements = [    1   3;  %element 1
                2   3;  %element 2
                2   4]; %element 3

            
%% NODE PROPERTIES  
%node 1
nprops(1).fix               = true;         %Fix node 1

%node 3
% nprops(3).force           = [0 1 0];      %Force [N] in y-direction on node 3
% nprops(3).force_initial   = [0 0.2 0];    %Initial force [N] in y-direction on node 3
% nprops(3).moment_initial    = [0 0 -0.025]; %Initial moment [Nm] around z-axis on node 3 
% nprops(3).moment            = [0 0 0.05];   %Moment [Nm] around z-axis on node 3
nprops(3).rot_z=0.5
nprops(3).mass              = 0.1;            %Mass [kg] of node 3

%node 4
nprops(4).fix               = true;         %Fix node 4


%% ELEMENT PROPERTIES
%Property set 1
eprops(1).elems    = [1 3];            %Add this set of properties to elements 1 and 3
eprops(1).emod     = 210e9;            %E-modulus [Pa]
eprops(1).smod     = 70e9;             %G-modulus [Pa]
eprops(1).dens     = 7800;             %Density [kg/m^3]
eprops(1).cshape   = 'rect';           %Rectangular cross-section
eprops(1).dim      = [50e-3 0.2e-3];   %Width: 50 mm, thickness: 0.2 mm
eprops(1).orien    = [0 0 1];          %Orientation of the cross-section as a vector pointing along "width-direction"
eprops(1).nbeams   = 1;                %4 beam elements for simulating these elements
eprops(1).flex     = 1:6;        	   %Model out-of-plane bending (modes 3 and 4) as flexible
eprops(1).color    = [0.8549    0.8588    0.8667];

%Property set 2
eprops(2).elems    = 2;                %Add this set of properties to element 2
eprops(2).dens     = 3000;             %Density [kg/m^3]
eprops(2).cshape   = 'rect';           %Rectangular cross-section
eprops(2).dim      = [50e-3 10e-3];    %Width: 50 mm, thickness: 10 mm
eprops(2).orien    = [0 0 1];          %Orientation of the cross-section as a vector pointing along "width-direction"
eprops(2).nbeams   = 1;                %1 beam element for simulating this element
eprops(2).color    = [0.1686    0.3922    0.6627];
% eprops(2).hide     = true;           %Hide element (in visualization only)


%% OPTIONAL ARGUMENTS
opt.filename    = 'crosshinge';     %Filename
% opt.calcbuck    = true;           %Enable calculation of load multipliers
opt.gravity     = [0 0 -9.81];      %Gravitational acceleration [m/s^2]
opt.showinputonly=true

%% CALL SPACAR_LIGHT
out = spacarlight(nodes, elements, nprops, eprops, opt);

%out.step(i)                            Results at loadstep i
%out.step(i).freq                       List with eigenfrequencies [Hz], sorted from lowest to highest
%out.step(i).buck*                      List with load multipliers, sorted from lowest to highest
%out.step(i).stressmax                  Maximum stress [Pa]
%out.step(i).node(j)                    Results at loadstep i, node number j
%out.step(i).node(j).p                  Position [m]
%out.step(i).node(j).r_axang			Rotation in axis-angle representation
%out.step(i).node(j).r_eulzyx           Euler rotations in order z, y, x
%out.step(i).node(j).r_quat             Rotations in quaternions
%out.step(i).node(j).Freac              Reaction forces on the node
%out.step(i).node(j).Mreac              Reaction moments on the node
c10=out.step(10).node(3).CMglob          %   6x6 compliance matrix of the node in the global frame
%out.step(i).node(j).CMloc              6x6 compliance matrix of the node in the local frame
%
%   *load multipliers only calculated if opt.calcbuck = true.

%% run mode 3
nprops(3).rot_z=[]
opt2=opt
opt2.mode=3
% out2 = spacarlight(nodes, elements, nprops, eprops, opt2);
c3=out.step(10).node(3).CMglob  
c3a=out2.step(10).node(3).CMglob          %   6x6 compliance matrix of the node in the global frame
