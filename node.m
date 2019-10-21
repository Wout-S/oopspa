classdef node < handle
    %SPANODE Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        fix
        inputx
        delinpx
        delxf
        xf
        n
        type
        xm
    end
    
    methods
        function obj = node(n,type)
            %SPANODE Construct an instance of this class
            %   Detailed explanation goes here
            obj.n=n;
            obj.type=type;
        end
        
    end

end

