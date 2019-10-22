classdef node < handle
    %SPANODE Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        n
        p
        fixcoords
        inputx
        delinpx
        delxf
        xf
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
        
        function fix(obj,varargin)
            if nargin==1
                switch obj.type
                    case 'trans'
                        obj.fixcoords=[1 2 3];
                    case 'rot'
                        obj.fixcoords=[2 3 4];
                    case 'warp'
                        obj.fixcoords=1;
                end
            else
                switch obj.type
                    case 'trans'
                        obj.fixcoords=find([1 2 3].*varargin{1});
                    case 'rot'
                        obj.fixcoords=find([2 3 4].*varargin{1});
                    case 'warp'
                        obj.fixcoords=1;
                end
            end
        end
        
    end
    
end

