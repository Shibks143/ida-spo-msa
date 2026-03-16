classdef xBeamHinge < handle
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
        % zDirection column line number
        zDirectionColumnLine
        % xDirection bay number
        xBay
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
        function xBeamHingeObject = xBeamHinge(xBeamObject,...
                XBeamHingePropertiesLocation,buildingGeometry,...
                classesDirectory)
            
            % Attach xBeam number
            xBeamHingeObject.number = xBeamObject.number;  
            
            % Attach beam level
            xBeamHingeObject.story = xBeamObject.level;  
            
            % Attach column zDirection column line number
            xBeamHingeObject.zDirectionColumnLine = ...
                xBeamObject.zDirectionColumnLine;  
            
            % Attach xDirection bay number
            xBeamHingeObject.xBay = ...
                xBeamObject.bay; 
            
            % Attach start joint node number
            xBeamHingeObject.startJointNodeNumber = ...
                xBeamObject.startJointNodeNumber;  
            
            % Attach end joint node number
            xBeamHingeObject.endJointNodeNumber = ...
                xBeamObject.endJointNodeNumber;  
            
            % Attach start joint node OpenSees Tag
            xBeamHingeObject.startJointNodeOpenSeesTag = ...
                xBeamObject.startJointNodeOpenSeesTag ;
            
            % Attach end joint node OpenSees Tag
            xBeamHingeObject.endJointNodeOpenSeesTag = ...
                xBeamObject.endJointNodeOpenSeesTag ;            
            
            % Attach start hinge node OpenSees Tag
            xBeamHingeObject.startHingeNodeOpenSeesTag = ...
                xBeamObject.startHingeNodeOpenSeesTag;
            
            % Attach end hinge node OpenSees Tag
            xBeamHingeObject.endHingeNodeOpenSeesTag = ...
                xBeamObject.endHingeNodeOpenSeesTag;
            
            % Attach start hinge element OpenSees Tag
            xBeamHingeObject.startHingeOpenSeesTag = ...
                strcat(num2str(7),...
                xBeamObject.startJointNodeOpenSeesTag,...
                xBeamObject.startHingeNodeOpenSeesTag);
            
            % Attach end hinge element OpenSees Tag
            xBeamHingeObject.endHingeOpenSeesTag = ...
                strcat(num2str(7),...
                xBeamObject.endJointNodeOpenSeesTag,...
                xBeamObject.endHingeNodeOpenSeesTag);
            
            % Attach column length
            xBeamHingeObject.beamLength = xBeamObject.length;
            
            % Go to folder where structural properties are stored
            cd(XBeamHingePropertiesLocation)
            
            % Attach bending stiffness
            xBeamHingeObject.EIeff = xBeamObject.E*...
                xBeamObject.Igtr*xBeamObject.EIeffOverEIg;
            
            % Attach My
            beamHingeMy = load('My.txt');
            xBeamHingeObject.My  = beamHingeMy((xBeamObject.level - 1),...
                (xBeamObject.zDirectionColumnLine - 1)*...
                (buildingGeometry.numberOfXBays)...
                + xBeamObject.bay);
            
            % Attach McOverMy
            beamHingeMcOverMy = load('McOverMy.txt');
            xBeamHingeObject.McOverMy  = beamHingeMcOverMy((...
                xBeamObject.level - 1),...
                (xBeamObject.zDirectionColumnLine - 1)*...
                (buildingGeometry.numberOfXBays)...
                + xBeamObject.bay);
            
            % Attach thetaCap
            beamHingethetaCap = load('thetaCap.txt');
            xBeamHingeObject.thetaCap  = beamHingethetaCap((...
                xBeamObject.level - 1),...
                (xBeamObject.zDirectionColumnLine - 1)*...
                (buildingGeometry.numberOfXBays)...
                + xBeamObject.bay);
            
            % Attach thetaPC
            beamHingethetaPC = load('thetaPC.txt');
            xBeamHingeObject.thetaPC  = beamHingethetaPC((...
                xBeamObject.level - 1),...
                (xBeamObject.zDirectionColumnLine - 1)*...
                (buildingGeometry.numberOfXBays)...
                + xBeamObject.bay);
            
            % Attach lambda
            beamHingelambda = load('lambda.txt');
            xBeamHingeObject.lambda  = beamHingelambda((...
                xBeamObject.level - 1),...
                (xBeamObject.zDirectionColumnLine - 1)*...
                (buildingGeometry.numberOfXBays)...
                + xBeamObject.bay);
            
            cd(classesDirectory)
        end      
        
    end
    
end

