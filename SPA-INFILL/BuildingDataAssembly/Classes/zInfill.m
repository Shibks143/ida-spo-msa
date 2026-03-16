classdef zInfill < handle
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
        % zInfill number
        number
        % Story
        story
        % Bay number
        zBay
        % zDirection column line number
        xDirectionColumnLine
        % East-West strut start joint node number
        southNorthStrutStartJointNodeNumber
        % West-East strut start joint node number
        northSouthStrutStartJointNodeNumber
        % East-West strut end joint node number
        southNorthStrutEndJointNodeNumber
        % West-East strut end joint node number
        northSouthStrutEndJointNodeNumber
        % Central east-west strut start node openSees tag
        centralSouthNorthStrutStartNodeOpenSeesTag
        % Central west-east strut start node openSees tag
        centralNorthSouthStrutStartNodeOpenSeesTag
        % Central east-west strut end node openSees tag
        centralSouthNorthStrutEndNodeOpenSeesTag
        % Central west-east strut end node openSees tag
        centralNorthSouthStrutEndNodeOpenSeesTag
        % Offset east-west strut start node openSees tag
        offsetSouthNorthStrutStartNodeOpenSeesTag
        % Offset west-east strut start node openSees tag
        offsetNorthSouthStrutStartNodeOpenSeesTag
        % Offset east-west strut end node openSees tag
        offsetSouthNorthStrutEndNodeOpenSeesTag
        % Offset west-east strut end node openSees tag
        offsetNorthSouthStrutEndNodeOpenSeesTag
        % Central east-west strut OpenSees element tag
        centralSouthNorthStrutOpenSeesTag
        % Central west-east strut OpenSees element tag
        centralNorthSouthStrutOpenSeesTag
        % Offset east-west strut OpenSees element tag
        offsetSouthNorthStrutOpenSeesTag
        % Offset west-east strut OpenSees element tag
        offsetNorthSouthStrutOpenSeesTag
        % Infill strut stiffness
        Kstrut
        % Infill strut yield strength
        FyStrut
        % Infill strut strain hardening ratio
        strainHardeningRatio
        % Infill strut strain softening ratio
        strainSofteningRatio
        % Infill strut length
        length
        % Infill strut deltaC/deltaY
        deltaCOverDeltaY
    end    
    
    methods
        % Constructor function
        function zInfillObject = zInfill(number,story,...
                XColumnLineNumber,zBayNumber,jointNodes,...
                SpinInfillPropertiesLocation,buildingGeometry,...
                columnObjects,classesDirectory)
            
            % Attach zInfill number
            zInfillObject.number = number;  
            
            % Attach zInfill story
            zInfillObject.story = story;  
            
            % Attach infill zDirection bay number
            zInfillObject.zBay = zBayNumber;  
            
            % Attach infill xDirection column line number
            zInfillObject.xDirectionColumnLine = XColumnLineNumber; 
            
            % Attach south-north start joint node number
            zInfillObject.southNorthStrutStartJointNodeNumber = ...
                (story - 1)*length(jointNodes(1,1,:))*...
                length(jointNodes(1,:,1)) + ...
                (zBayNumber - 1)*length(jointNodes(1,:,1)) + ...
                XColumnLineNumber;  
            
            % Attach south-north end joint node number
            zInfillObject.southNorthStrutEndJointNodeNumber = ...
                (story)*length(jointNodes(1,1,:))*...
                length(jointNodes(1,:,1)) + ...
                (zBayNumber)*length(jointNodes(1,:,1)) + ...
                XColumnLineNumber;  
            
            % Attach north-south start joint node number
            zInfillObject.northSouthStrutStartJointNodeNumber = ...
                (story - 1)*length(jointNodes(1,1,:))*...
                length(jointNodes(1,:,1)) + ...
                (zBayNumber)*length(jointNodes(1,:,1)) + ...
                XColumnLineNumber;  
            
            % Attach north-south end joint node number
            zInfillObject.northSouthStrutEndJointNodeNumber = ...
                (story)*length(jointNodes(1,1,:))*...
                length(jointNodes(1,:,1)) + ...
                (zBayNumber - 1)*length(jointNodes(1,:,1)) + ...
                XColumnLineNumber;  
            
            % Attach central south-north strut start node openSees tag
            zInfillObject. ...
                centralSouthNorthStrutStartNodeOpenSeesTag ...
                = jointNodes{story,XColumnLineNumber,...
                zBayNumber}.openSeesTag; 
            
            % Attach central south-north strut end node openSees tag
            zInfillObject.centralSouthNorthStrutEndNodeOpenSeesTag ...
                = jointNodes{story + 1,XColumnLineNumber,...
                zBayNumber + 1}.openSeesTag; 
            
            % Attach central north-south strut start node openSees tag
            zInfillObject. ...
                centralNorthSouthStrutStartNodeOpenSeesTag ...
                = jointNodes{story,XColumnLineNumber,...
                zBayNumber + 1}.openSeesTag; 
            
            % Attach central north-south strut end node openSees tag
            zInfillObject.centralNorthSouthStrutEndNodeOpenSeesTag ...
                = jointNodes{story + 1,XColumnLineNumber,...
                zBayNumber}.openSeesTag; 
            
            % Attach offset south-north strut start node openSees tag
            if buildingGeometry.numberOfStories > 8
                zInfillObject.offsetSouthNorthStrutStartNodeOpenSeesTag ...
                    = (num2str(columnObjects{story,XColumnLineNumber,...
                    zBayNumber}.startHingeNodeOpenSeesTag));                
            else
                zInfillObject. ...
                offsetSouthNorthStrutStartNodeOpenSeesTag ...
                = strcat(jointNodes{story,XColumnLineNumber,...
                zBayNumber}.openSeesTag,num2str(4)); 
            end
            
            % Attach offset south-north strut end node openSees tag
            if buildingGeometry.numberOfStories > 8
                zInfillObject.offsetSouthNorthStrutEndNodeOpenSeesTag ...
                    = (num2str(columnObjects{story,XColumnLineNumber,...
                    zBayNumber + 1}.endHingeNodeOpenSeesTag));                
            else
                zInfillObject.offsetSouthNorthStrutEndNodeOpenSeesTag ...
                = strcat(jointNodes{story + 1,XColumnLineNumber,...
                zBayNumber + 1}.openSeesTag,num2str(2)); 
            end            
            
            % Attach offset north-south strut start node openSees tag
            if buildingGeometry.numberOfStories > 8
                zInfillObject.offsetNorthSouthStrutStartNodeOpenSeesTag ...
                    = (num2str(columnObjects{story,XColumnLineNumber,...
                    zBayNumber + 1}.startHingeNodeOpenSeesTag));                
            else
                zInfillObject. ...
                offsetNorthSouthStrutStartNodeOpenSeesTag ...
                = strcat(jointNodes{story,XColumnLineNumber,...
                zBayNumber + 1}.openSeesTag,num2str(4)); 
            end            
            
            % Attach offset north-south strut end node openSees tag
            if buildingGeometry.numberOfStories > 8
                zInfillObject.offsetNorthSouthStrutEndNodeOpenSeesTag ...
                    = (num2str(columnObjects{story,XColumnLineNumber,...
                    zBayNumber}.endHingeNodeOpenSeesTag));                
            else
                zInfillObject.offsetNorthSouthStrutEndNodeOpenSeesTag ...
                = strcat(jointNodes{story + 1,XColumnLineNumber,...
                zBayNumber}.openSeesTag,num2str(2));  
            end              
            
            % Attach south-north central strut openSees tag
            zInfillObject.centralSouthNorthStrutOpenSeesTag = ...
                strcat(num2str(5),...
                zInfillObject. ...
                centralSouthNorthStrutStartNodeOpenSeesTag,...
                zInfillObject. ...
                centralSouthNorthStrutEndNodeOpenSeesTag);
            
            % Attach north-south central strut openSees tag
            zInfillObject.centralNorthSouthStrutOpenSeesTag = ...
                strcat(num2str(5),...
                zInfillObject. ...
                centralNorthSouthStrutStartNodeOpenSeesTag,...
                zInfillObject. ...
                centralNorthSouthStrutEndNodeOpenSeesTag);
            
            % Attach south-north offset strut openSees tag
            zInfillObject.offsetSouthNorthStrutOpenSeesTag = ...
                strcat(num2str(5),...
                zInfillObject. ...
                offsetSouthNorthStrutStartNodeOpenSeesTag,...
                zInfillObject. ...
                offsetSouthNorthStrutEndNodeOpenSeesTag);
            
            % Attach north-south offset strut openSees tag
            zInfillObject.offsetNorthSouthStrutOpenSeesTag = ...
                strcat(num2str(5),...
                zInfillObject. ...
                offsetNorthSouthStrutStartNodeOpenSeesTag,...
                zInfillObject. ...
                offsetNorthSouthStrutEndNodeOpenSeesTag);
            
            % Go to folder where structural properties are stored
            cd(SpinInfillPropertiesLocation)
            
            % Attach infill strut stiffness
            InfillStrutK = load('Kstrut.txt');
            zInfillObject.Kstrut = InfillStrutK(story,...
                (zBayNumber - 1)*(buildingGeometry.numberOfXBays + 1)...
                + XColumnLineNumber);
            
            % Attach infill strut yield strength
            InfillStrutFy = load('FyStrut.txt');
            zInfillObject.FyStrut = InfillStrutFy(story,...
                (zBayNumber - 1)*(buildingGeometry.numberOfXBays + 1)...
                + XColumnLineNumber);
            
            % Attach infill strut length
            InfillStrutLength= load('length.txt');
            zInfillObject.length = InfillStrutLength(story,...
                (zBayNumber - 1)*(buildingGeometry.numberOfXBays + 1)...
                + XColumnLineNumber);
            
            % Attach strain hardening ratio
            zInfillObject.strainHardeningRatio = ...
                load('strainHardeningRatio.txt');
            
            % Attach strain softening ratio
            zInfillObject.strainSofteningRatio = ...
                load('strainSofteningRatio.txt');

            % Attach strain softening ratio
            zInfillObject.deltaCOverDeltaY = ...
                load('deltaCOverDeltaY.txt');
            
            cd(classesDirectory)
        end      
        
    end
    
end

