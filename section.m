classdef section < handle
    %SECTION Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
         % orientation vector
        dim
        shape
        
    end
    
    methods
        function obj = section(shape,dim)
            %SECTION Construct an instance of this class
            %   Detailed explanation goes here
            obj.dim=dim;
            obj.shape=shape;
            
            
        end
        
    end
end

