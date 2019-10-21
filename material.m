classdef material < handle
    %MATERIAL Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        E
        G
        rho
    end
    
    methods
        function obj = material(E,G,rho)
            %MATERIAL Construct an instance of this class
            %   Detailed explanation goes here
            validateattributes(E,{'numeric'},{'scalar'},'','E')
            validateattributes(G,{'numeric'},{'scalar'},'','G')
            validateattributes(rho,{'numeric'},{'scalar'},'','rho')
                obj.E=E;
                obj.G=G;
                obj.rho=rho;
        end
        
    end
end
