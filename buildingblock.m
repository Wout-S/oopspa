classdef buildingblock < handle
    %BUILDBLOCK Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        elements
        endnodes
    end
    
    methods
        function obj = buildingblock(data,keypoints,type,eprops,sect,mat)
            %BUILDBLOCK Construct an instance of this class
            %   Detailed explanation goes here
            switch type
                case 'strip'
                    midpos=keypoints(1).p+keypoints(2).p/2;
                    kpmid=addkp(data,midpos);
                    e1=addelem(data,[keypoints(1),kpmid],eprops,sect,mat);
                    e2=addelem(data,[kpmid,keypoints(2)],eprops,sect,mat);
                    obj.elements=[e1 e2];
                    obj.endnodes=keypoints;
            end
            
        end
        
    end
end

