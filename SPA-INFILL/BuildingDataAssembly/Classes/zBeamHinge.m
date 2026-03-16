classdef zBeamHinge < handle
    % Hidden properties will not be displayed when you access the property
    % list using get(object) or object.property
    properties (Hidden) 
    end       
    
    % These properties are the same for all instances of of the class
    properties (Constant) 
    end
     
    % For SetAcess = protected you can only access the properties from the 
    % class or subclass. 
    % For SetAccess = public you can access the properties from anywhere
    % For SetAccess = private you can access the properties from class
    % members only (not subclasses)
    properties (SetAccess = protected)
        % Beam number
        number
        % Beam level location
        story
        % Beam length
        beamLength
        % xDirection column line number
        xDirectionColumnLine
        % xDirection bay number
        zBay
        % Beam start joint node number
        startJointNodeNumber
        % Beam end joint node number
        endJointNodeNumber
        % Beam start joint node openSees tag
        startJointNodeOpenSeesTag
        % End joint node openSees tag
        endJointNodeOpenSeesTag
        % Start hinge node openSees tag
        startHingeNodeOpenSeesTag
        % End hinge node openSees tag
        endHingeNodeOpenSeesTag
        % Start hinge element openSees tag
        startHingeOpenSeesTag
        % End hinge element openSees tag
        endHingeOpenSeesTag
        % Bending stiffness
        EIeff
        % Yield moment for
        My
        % Ratio of yield to capping moment
        McOverMy
        % Capping rotation
        thetaCap
        % Post-capping rotation
        thetaPC
        % Deterioration parameter
        lambda
    end    
    
    methods
        % Constructor function
        function zBeamHingeObject = zBeamHinge(zBeamObject,...
                ZBeamHingePropertiesLocation,buildingGeometry,...
                classesDirectory)
            
            % Attach zBeam number
            zBeamHingeObject.number = zBeamObject.number;  
            
            % Attach beam level
            zBeamHingeObject.story = zBeamObject.level;  
            
            % Attach column zDirection column line number
            zBeamHingeObject.xDirectionColumnLine = ...
                zBeamObject.xDirectionColumnLine;  
            
            % Attach xDirection bay number
            zBeamHingeObject.zBay = ...
                zBeamObject.bay; 
            
            % Attach start joint node number
            zBeamHingeObject.startJointNodeNumber = ...
                zBeamObject.startJointNodeNumber;  
            
            % Attach end joint node number
            zBeamHingeObject.endJointNodeNumber = ...
                zBeamObject.endJointNodeNumber;  
            
            % Attach start joint node OpenSees Tag
            zBeamHingeObject.startJointNodeOpenSeesTag = ...
                zBeamObject.startJointNodeOpenSeesTag ;
            
            % Attach end joint node OpenSees Tag
            zBeamHingeObject.endJointNodeOpenSeesTag = ...
                zBeamObject.endJointNodeOpenSeesTag ;            
            
            % Attach start hinge node OpenSees Tag
            zBeamHingeObject.startHingeNodeOpenSeesTag = ...
                zBeamObject.startHingeNodeOpenSeesTag;
            
            % Attach end hinge node OpenSees Tag
            zBeamHingeObject.endHingeNodeOpenSeesTag = ...
                zBeamObject.endHingeNodeOpenSeesTag;
            
            % Attach start hinge element OpenSees Tag
            zBeamHingeObject.startHingeOpenSeesTag = ...
                strcat(num2str(7),...
                zBeamObject.startJointNodeOpenSeesTag,...
                zBeamObject.startHingeNodeOpenSeesTag);
            
            % Attach end hinge element OpenSees Tag
            zBeamHingeObject.endHingeOpenSeesTag = ...
                strcat(num2str(7),...
                zBeamObject.endJointNodeOpenSeesTag,...
                zBeamObject.endHingeNodeOpenSeesTag);
            
            % Attach column length
            zBeamHingeObject.beamLength = zBeamObject.length;
            
            % Go to folder where structural properties are stored
            cd(ZBeamHingePropertiesLocation)
            
            % Attach bending stiffness
            zBeamHingeObject.EIeff = zBeamObject.E*...
                zBeamObject.Igtr*zBeamObject.EIeffOverEIg;
            
            % Attach My
            beamHingeMy = load('My.txt');
            zBeamHingeObject.My  = beamHingeMy((zBeamObject.level - 1),...
                (zBeamObject.xDirectionColumnLine - 1)*...
                (buildingGeometry.numberOfZBays)...
                + zBeamObject.bay);
            
            % Attach McOverMy
            beamHingeMcOverMy = load('McOverMy.txt');
            zBeamHingeObject.McOverMy  = beamHingeMcOverMy((...
                zBeamObject.level - 1),...
                (zBeamObject.xDirectionColumnLine - 1)*...
                (buildingGeometry.numberOfZBays)...
                + zBeamObject.bay);
            
            % Attach thetaCap
            beamHingethetaCap = load('thetaCap.txt');
            zBeamHingeObject.thetaCap  = beamHingethetaCap((...
                zBeamObject.level - 1),...
                (zBeamObject.xDirectionColumnLine - 1)*...
                (buildingGeometry.numberOfZBays)...
                + zBeamObject.bay);
            
            % Attach thetaPC
            beamHingethetaPC = load('thetaPC.txt');
            zBeamHingeObject.thetaPC  = beamHingethetaPC((...
                zBeamObject.level - 1),...
                (zBeamObject.xDirectionColumnLine - 1)*...
                (buildingGeometry.numberOfZBays)...
                + zBeamObject.bay);
            
            % Attach lambda
            beamHingelambda = load('lambda.txt');
            zBeamHingeObject.lambda  = beamHingelambda((...
                zBeamObject.level - 1),...
                (zBeamObject.xDirectionColumnLine - 1)*...
                (buildingGeometry.numberOfZBays)...
                + zBeamObject.bay);
            
            cd(classesDirectory)
        end      
        
    end
    
end

