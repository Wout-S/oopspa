classdef bbprops
    %BBPROPS Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        type            % builing block layout type
        mat             % materials 1xn array
        sect            % sections 1xn array
        eprops          % element properties 1xn array
        dim             % dimenstions
        orien           % global y-direction (width direction)
        
        % custom building block properties:
        p               % internal node position function @(dim,L)
        conn            % 1xn connection matrix cell array
    end
    
    methods
%         function obj = bbprops(inputArg1,inputArg2)
%             %BBPROPS Construct an instance of this class
%             %   Detailed explanation goes here
%             obj.Property1 = inputArg1 + inputArg2;
%         end
%         
%         function outputArg = method1(obj,inputArg)
%             %METHOD1 Summary of this method goes here
%             %   Detailed explanation goes here
%             outputArg = obj.Property1 + inputArg;
%         end
    end
end

