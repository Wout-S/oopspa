classdef buildingblock < handle
    %BUILDBLOCK Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        elements
        endnodes
    end
    
    methods
        function obj = buildingblock(data,nodes,type,eprops,sect,mat)
            %BUILDBLOCK Construct an instance of this class
            %   Detailed explanation goes here
            switch type
                case 'strip'
                    midpos=nodes(1).p+nodes(2).p/2;
                    pmid=addnode(data,midpos)
                    e1=addelem(data,[nodes(1),pmid],eprops,sect,mat);
                    e2=addelem(data,[pmid,nodes(2)],eprops,sect,mat);
                    obj.elements=[e1 e2];
                    obj.endnodes=nodes;
            end
            
        end
        
    end
end

