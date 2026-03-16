classdef xInfill < handle
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
        % xInfill number
        number
        % Story
        story
        % Bay number
        xBay
        % zDirection column line number
        zDirectionColumnLine
        % East-West strut start joint node number
        eastWestStrutStartJointNodeNumber
        % West-East strut start joint node number
        westEastStrutStartJointNodeNumber
        % East-West strut end joint node number
        eastWestStrutEndJointNodeNumber
        % West-East strut end joint node number
        westEastStrutEndJointNodeNumber
        % Central east-west strut start node openSees tag
        centralEastWestStrutStartNodeOpenSeesTag
        % Central west-east strut start node openSees tag
        centralWestEastStrutStartNodeOpenSeesTag
        % Central east-west strut end node openSees tag
        centralEastWestStrutEndNodeOpenSeesTag
        % Central west-east strut end node openSees tag
        centralWestEastStrutEndNodeOpenSeesTag
        % Offset east-west strut start node openSees tag
        offsetEastWestStrutStartNodeOpenSeesTag
        % Offset west-east strut start node openSees tag
        offsetWestEastStrutStartNodeOpenSeesTag
        % Offset east-west strut end node openSees tag
        offsetEastWestStrutEndNodeOpenSeesTag
        % Offset west-east strut end node openSees tag
        offsetWestEastStrutEndNodeOpenSeesTag
        % Central east-west strut OpenSees element tag
        centralEastWestStrutOpenSeesTag
        % Central west-east strut OpenSees element tag
        centralWestEastStrutOpenSeesTag
        % Offset east-west strut OpenSees element tag
        offsetEastWestStrutOpenSeesTag
        % Offset west-east strut OpenSees element tag
        offsetWestEastStrutOpenSeesTag
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
        function xInfillObject = xInfill(number,story,...
                xBayNumber,ZColumnLineNumber,jointNodes,...
                SpinInfillPropertiesLocation,buildingGeometry,...
                columnObjects,classesDirectory)
            
            % Attach xInfill number
            xInfillObject.number = number;  
            
            % Attach xInfill story
            xInfillObject.story = story;  
            
            % Attach infill xDirection bay number
            xInfillObject.xBay = xBayNumber;  
            
            % Attach inifll zDirection column line number
            xInfillObject.zDirectionColumnLine = ZColumnLineNumber; 
            
            % Attach east-west start joint node number
            xInfillObject.eastWestStrutStartJointNodeNumber = ...
                (story - 1)*length(jointNodes(1,1,:))*...
                length(jointNodes(1,:,1)) + ...
                (ZColumnLineNumber - 1)*length(jointNodes(1,:,1)) + ...
                xBayNumber + 1;  
            
            % Attach east-west end joint node number
            xInfillObject.eastWestStrutEndJointNodeNumber = ...
                (story)*length(jointNodes(1,1,:))*...
                length(jointNodes(1,:,1)) + ...
                (ZColumnLineNumber - 1)*length(jointNodes(1,:,1)) + ...
                xBayNumber;  
            
            % Attach west-east start joint node number
            xInfillObject.westEastStrutStartJointNodeNumber = ...
                (story - 1)*length(jointNodes(1,1,:))*...
                length(jointNodes(1,:,1)) + ...
                (ZColumnLineNumber - 1)*length(jointNodes(1,:,1)) + ...
                xBayNumber; 
            
            % Attach west-east end joint node number
            xInfillObject.westEastStrutEndJointNodeNumber = ...
                (story)*length(jointNodes(1,1,:))*...
                length(jointNodes(1,:,1)) + ...
                (ZColumnLineNumber - 1)*length(jointNodes(1,:,1)) + ...
                xBayNumber + 1; 
            
            % Attach central east-west strut start node openSees tag
            xInfillObject.centralEastWestStrutStartNodeOpenSeesTag ...
                = jointNodes{story,xBayNumber + 1,...
                ZColumnLineNumber}.openSeesTag; 
            
            % Attach central east-west strut end node openSees tag
            xInfillObject.centralEastWestStrutEndNodeOpenSeesTag ...
                = jointNodes{story + 1,xBayNumber,...
                ZColumnLineNumber}.openSeesTag; 
            
            % Attach central west-east strut start node openSees tag
            xInfillObject.centralWestEastStrutStartNodeOpenSeesTag ...
                = jointNodes{story,xBayNumber,...
                ZColumnLineNumber}.openSeesTag; 
            
            % Attach central west-east strut end node openSees tag
            xInfillObject.centralWestEastStrutEndNodeOpenSeesTag ...
                = jointNodes{story + 1,xBayNumber + 1,...
                ZColumnLineNumber}.openSeesTag; 
            
            % Attach offset east-west strut start node openSees tag
            if buildingGeometry.numberOfStories > 8
                xInfillObject.offsetEastWestStrutStartNodeOpenSeesTag ...
                    = (num2str(columnObjects{story,xBayNumber + 1,...
                    ZColumnLineNumber}.startHingeNodeOpenSeesTag));
            else
                xInfillObject.offsetEastWestStrutStartNodeOpenSeesTag ...
                = strcat(jointNodes{story,xBayNumber + 1,...
                ZColumnLineNumber}.openSeesTag,num2str(4)); 
            end
            
            % Attach offset east-west strut end node openSees tag
            if buildingGeometry.numberOfStories > 8
                xInfillObject.offsetEastWestStrutEndNodeOpenSeesTag ...
                    = (num2str(columnObjects{story,xBayNumber,...
                    ZColumnLineNumber}.endHingeNodeOpenSeesTag));
            else
                xInfillObject.offsetEastWestStrutEndNodeOpenSeesTag ...
                    = strcat(jointNodes{story + 1,xBayNumber,...
                    ZColumnLineNumber}.openSeesTag,num2str(2));  
            end
                        
            % Attach offset west-east strut start node openSees tag
            if buildingGeometry.numberOfStories > 8
                xInfillObject.offsetWestEastStrutStartNodeOpenSeesTag ...
                    = (num2str(columnObjects{story,xBayNumber,...
                    ZColumnLineNumber}.startHingeNodeOpenSeesTag));
            else
                xInfillObject.offsetWestEastStrutStartNodeOpenSeesTag ...
                = strcat(jointNodes{story,xBayNumber,...
                ZColumnLineNumber}.openSeesTag,num2str(4));  
            end     
            
            % Attach offset west-east strut end node openSees tag
            if buildingGeometry.numberOfStories > 8
                xInfillObject.offsetWestEastStrutEndNodeOpenSeesTag ...
                    = (num2str(columnObjects{story,xBayNumber + 1,...
                    ZColumnLineNumber}.endHingeNodeOpenSeesTag));
            else
                xInfillObject.offsetWestEastStrutEndNodeOpenSeesTag ...
                = strcat(jointNodes{story + 1,xBayNumber + 1,...
                ZColumnLineNumber}.openSeesTag,num2str(2));  
            end            
            
            % Attach east-west central strut openSees tag
            xInfillObject.centralEastWestStrutOpenSeesTag = ...
                strcat(num2str(5),...
                xInfillObject. ...
                centralEastWestStrutStartNodeOpenSeesTag,...
                xInfillObject.centralEastWestStrutEndNodeOpenSeesTag);
            
            % Attach west-east central strut openSees tag
            xInfillObject.centralWestEastStrutOpenSeesTag = ...
                strcat(num2str(5),...
                xInfillObject. ...
                centralWestEastStrutStartNodeOpenSeesTag,...
                xInfillObject.centralWestEastStrutEndNodeOpenSeesTag);
            
            % Attach east-west offset strut openSees tag
            xInfillObject.offsetEastWestStrutOpenSeesTag = ...
                strcat(num2str(5),...
                xInfillObject. ...
                offsetEastWestStrutStartNodeOpenSeesTag,...
                xInfillObject.offsetEastWestStrutEndNodeOpenSeesTag);
            
            % Attach west-east offset strut openSees tag
            xInfillObject.offsetWestEastStrutOpenSeesTag = ...
                strcat(num2str(5),...
                xInfillObject. ...
                offsetWestEastStrutStartNodeOpenSeesTag,...
                xInfillObject.offsetWestEastStrutEndNodeOpenSeesTag);
            
            % Go to folder where structural properties are stored
            cd(SpinInfillPropertiesLocation)
            
            % Attach infill strut stiffness
            InfillStrutK = load('Kstrut.txt');
            xInfillObject.Kstrut = InfillStrutK(story,...
                (ZColumnLineNumber - 1)*(buildingGeometry.numberOfXBays)...
                + xBayNumber);
            
            % Attach infill strut yield strength
            InfillStrutFy = load('FyStrut.txt');
            xInfillObject.FyStrut = InfillStrutFy(story,...
                (ZColumnLineNumber - 1)*(buildingGeometry.numberOfXBays)...
                + xBayNumber);
            
            % Attach infill strut length
            InfillStrutLength= load('length.txt');
            xInfillObject.length = InfillStrutLength(story,...
                (ZColumnLineNumber - 1)*(buildingGeometry.numberOfXBays)...
                + xBayNumber);
            
            % Attach strain hardening ratio
            xInfillObject.strainHardeningRatio = ...
                load('strainHardeningRatio.txt');
            
            % Attach strain softening ratio
            xInfillObject.strainSofteningRatio = ...
                load('strainSofteningRatio.txt');

            % Attach strain softening ratio
            xInfillObject.deltaCOverDeltaY = ...
                load('deltaCOverDeltaY.txt');
            
            cd(classesDirectory)
        end      
        
    end
    
end

