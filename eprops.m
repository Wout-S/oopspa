classdef eprops %< handle
    %EPROPS Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        type
        flex
        orien
    end
    
    methods
        function obj = eprops(type,flex,orien)
            %EPROPS Construct an instance of this class
            %   Detailed explanation goes here
            obj.type = type;
            obj.flex= flex;
            obj.orien=orien;
        end
        
    end
end

