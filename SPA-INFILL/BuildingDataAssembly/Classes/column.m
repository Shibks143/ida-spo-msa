classdef column < handle
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
        % Column number
        number
        % Story location
        story
        % xDirection column line number
        xDirectionColumnLine
        % xDirection column line
        zDirectionColumnLine
        % Start joint node number
        startJointNodeNumber
        % End joint node number
        endJointNodeNumber
        % Start joint node openSees tag
        startJointNodeOpenSeesTag
        % End joint node openSees tag
        endJointNodeOpenSeesTag
        % Start hinge node openSees tag
        startHingeNodeOpenSeesTag
        % End hinge node openSees tag
        endHingeNodeOpenSeesTag
        % OpenSees element tag
        openSeesTag
        % Width
        width
        % Depth
        depth
        % Length
        length
        % Cross sectional area
        area
        % Modulus of elasticity
        E
        % Gross transformed moment of inertia about global Z Axis
        IgtrZZ
        % Gross transformed moment of inertia about global X Axs
        IgtrXX
        % Cracking stiffness factor EIeff/EIg
        EIeffOverEIg
        % Larger number used to represent product of rotational moment 
        % of inertia and shear modulus
        GJ
        % Expected (1.05D + 0.25L) concentrated column loads used for 2D 
        % OpenSees models. Only includes tributary loads from beams
        % orthogonal to frame line model i.e. loads from beams that are not
        % included in the model
        pointLoadsFor2DModels
    end    
    
    methods
        % Constructor function
        function columnObject = column(number,story,XColumnLineNumber,...
                ZColumnLineNumber,jointNodes,ColumnPropertiesLocation,...
                buildingGeometry,classesDirectory,...
                LoadParametersLocation)
            
            % Attach column number
            columnObject.number = number;  
            
            % Attach column story
            columnObject.story = story;  
            
            % Attach column xDirection column line number
            columnObject.xDirectionColumnLine = XColumnLineNumber;  
            
            % Attach column zDirection column line number
            columnObject.zDirectionColumnLine = ZColumnLineNumber; 
            
            % Attach start joint node number
            columnObject.startJointNodeNumber = (story - 1)*...
                length(jointNodes(1,1,:))*length(jointNodes(1,:,1)) + ...
                (ZColumnLineNumber - 1)*length(jointNodes(1,:,1)) + ...
                XColumnLineNumber;  
            
            % Attach end joint node number
            columnObject.endJointNodeNumber = story*...
                length(jointNodes(1,1,:))*length(jointNodes(1,:,1)) + ...
                (ZColumnLineNumber - 1)*length(jointNodes(1,:,1)) + ...
                XColumnLineNumber;  
            
            % Attach start joint node OpenSees Tag
            columnObject.startJointNodeOpenSeesTag = jointNodes{story,...
                XColumnLineNumber,ZColumnLineNumber}.openSeesTag;
            
            % Attach end joint node OpenSees Tag
            columnObject.endJointNodeOpenSeesTag = jointNodes{story + 1,...
                XColumnLineNumber,ZColumnLineNumber}.openSeesTag;
            
            
            % Attach start hinge node OpenSees Tag
            if buildingGeometry.numberOfStories > 8
                columnObject.startHingeNodeOpenSeesTag = ...
                    num2str((buildingGeometry.numberOfXBays + 1) * ...
                    (buildingGeometry.numberOfZBays + 1) * ...
                    (buildingGeometry.numberOfStories + 1) + 2*(number ...
                    - 1) + 1);
            else
                columnObject.startHingeNodeOpenSeesTag = strcat(...
                columnObject.startJointNodeOpenSeesTag,num2str(4));
            end
            
            % Attach end hinge node OpenSees Tag
            if buildingGeometry.numberOfStories > 8
                columnObject.endHingeNodeOpenSeesTag = ...
                    num2str((buildingGeometry.numberOfXBays + 1) * ...
                    (buildingGeometry.numberOfZBays + 1) * ...
                    (buildingGeometry.numberOfStories + 1) + 2*(number ...
                    - 1) + 2);
            else
                columnObject.endHingeNodeOpenSeesTag = strcat(...
                columnObject.endJointNodeOpenSeesTag,num2str(2));
            end
            
            
            % Attach OpenSees Tag for column element
            columnObject.openSeesTag = strcat(num2str(3),...
                columnObject.startHingeNodeOpenSeesTag,...
                columnObject.endHingeNodeOpenSeesTag);
            
            % Go to folder where structural properties are stored
            cd(ColumnPropertiesLocation)
            
            % Attach column length
            columnObject.length = buildingGeometry.storyHeights(story);
            
            % Attach concrete modulus
            columnObject.E = load('E.txt');
            
            % Attach GJ
            columnObject.GJ = load('GJ.txt');
            
            % Column cross section areaa
            columnAreas = load('A.txt');
            columnObject.area = columnAreas(story,(ZColumnLineNumber ...
                - 1)*(buildingGeometry.numberOfXBays + 1) + ...
                XColumnLineNumber);
            
            % Column gross transformed moment of inertia
            columnIgtrZZ = load('IgtrZZ.txt');
            columnObject.IgtrZZ  = columnIgtrZZ(story,(ZColumnLineNumber -...
                1)* (buildingGeometry.numberOfXBays + 1) + ...
                XColumnLineNumber);
            columnIgtrXX = load('IgtrXX.txt');
            columnObject.IgtrXX  = columnIgtrXX(story,(ZColumnLineNumber -...
                1)* (buildingGeometry.numberOfXBays + 1) + ...
                XColumnLineNumber);

            % Column cracked stiffness factor EIeff/EIg
            columnEIeffOverEIg = load('EIeffOverEIg.txt');
            columnObject.EIeffOverEIg  = columnEIeffOverEIg(story,...
                (ZColumnLineNumber - 1)* (buildingGeometry.numberOfXBays...
                + 1) + XColumnLineNumber);
            
            % Expected (1.05D + 0.25L) concentrated column loads used for 
            % 2D OpenSees models. Only includes tributary loads from beams
            % orthogonal to frame line model i.e. loads from beams that are 
            % not included in the model        
            cd(LoadParametersLocation)
            columnPointLoads = load('columnLoads.txt');
            columnObject.pointLoadsFor2DModels = columnPointLoads(story,...
                (ZColumnLineNumber - 1)*(buildingGeometry.numberOfXBays ...
                + 1) + XColumnLineNumber);
            
            cd(classesDirectory)
        end      
        
    end
    
end

