classdef xBeam < handle
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
        % xBeam number
        number
        % Floor level
        level
        % Bay number
        bay
        % zDirection column line number
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
        % Gross transformed moment of inertia
        Igtr
        % Cracking stiffness factor EIeff/EIg
        EIeffOverEIg
        % Larger number used to represent product of rotational moment 
        % of inertia and shear modulus
        GJ   
        % Expected (1.05D + 0.25L) uniform beams loads used for 2D and 3D
        % OpenSees models. 
        uniformXBeamLoads
    end    
    
    methods
        % Constructor function
        function xBeamObject = xBeam(number,level,xBayNumber,...
                ZColumnLineNumber,jointNodes,BeamPropertiesLocation,...
                buildingGeometry,classesDirectory,LoadParametersLocation)
            
            % Attach xBeam number
            xBeamObject.number = number;  
            
            % Attach beam level
            xBeamObject.level = level;  
            
            % Attach beam xDirection bay number
            xBeamObject.bay = xBayNumber;  
            
            % Attach beam zDirection column line number
            xBeamObject.zDirectionColumnLine = ZColumnLineNumber; 
            
            % Attach start joint node number
            xBeamObject.startJointNodeNumber = (level - 1)*...
                length(jointNodes(1,1,:))*length(jointNodes(1,:,1)) + ...
                (ZColumnLineNumber - 1)*length(jointNodes(1,:,1)) + ...
                xBayNumber;  
            
            % Attach end joint node number
            xBeamObject.endJointNodeNumber = (level - 1)*...
                length(jointNodes(1,1,:))*length(jointNodes(1,:,1)) + ...
                (ZColumnLineNumber - 1)*length(jointNodes(1,:,1)) + ...
                xBayNumber + 1;    
            
            % Attach start joint node OpenSees Tag
            xBeamObject.startJointNodeOpenSeesTag = jointNodes{level,...
                xBayNumber,ZColumnLineNumber}.openSeesTag;
            
            % Attach end joint node OpenSees Tag
            xBeamObject.endJointNodeOpenSeesTag = jointNodes{level,...
                xBayNumber + 1,ZColumnLineNumber}.openSeesTag;
            
            % Attach start hinge node OpenSees Tag
            if buildingGeometry.numberOfStories > 8
                xBeamObject.startHingeNodeOpenSeesTag = num2str(...
                    (buildingGeometry.numberOfXBays + 1) * ...
                    (buildingGeometry.numberOfZBays + 1) * ...
                    (buildingGeometry.numberOfStories + 1) + 2*(...
                    (buildingGeometry.numberOfXBays + 1) * ...
                    (buildingGeometry.numberOfZBays + 1) * ...
                    (buildingGeometry.numberOfStories) )+ ... 
                     2*(number ...
                    - 1) + 1);
            else
                xBeamObject.startHingeNodeOpenSeesTag = strcat(...
                xBeamObject.startJointNodeOpenSeesTag,num2str(3));
            end
            
            % Attach end hinge node OpenSees Tag
            if buildingGeometry.numberOfStories > 8
                xBeamObject.endHingeNodeOpenSeesTag = num2str(...
                    (buildingGeometry.numberOfXBays + 1) * ...
                    (buildingGeometry.numberOfZBays + 1) * ...
                    (buildingGeometry.numberOfStories + 1) + 2*(...
                    (buildingGeometry.numberOfXBays + 1) * ...
                    (buildingGeometry.numberOfZBays + 1) * ...
                    (buildingGeometry.numberOfStories)) + ... 
                     2*(number ...
                    - 1) + 2);
            else
                xBeamObject.endHingeNodeOpenSeesTag = strcat(...
                xBeamObject.endJointNodeOpenSeesTag,num2str(1));
            end
            
            
            % Attach OpenSees Tag for beam element
            xBeamObject.openSeesTag = strcat(num2str(2),...
                xBeamObject.startHingeNodeOpenSeesTag,...
                xBeamObject.endHingeNodeOpenSeesTag);
            
            % Go to folder where structural properties are stored
            cd(BeamPropertiesLocation)
            
            % Attach beam length
            xBeamObject.length = buildingGeometry.XBayWidths(xBayNumber);
            
            % Attach concrete modulus
            xBeamObject.E = load('E.txt');
            
            % Attach GJ
            xBeamObject.GJ = load('GJ.txt');
            
            % xBeam cross section areaa
            beamAreas = load('A.txt');
            xBeamObject.area = beamAreas((level - 1),...
                (ZColumnLineNumber - 1)*(buildingGeometry.numberOfXBays)...
                + xBayNumber);
            
            % xBeam gross transformed moment of inertia
            beamIgtr = load('Igtr.txt');
            xBeamObject.Igtr = beamIgtr((level - 1),...
                (ZColumnLineNumber - 1)*(buildingGeometry.numberOfXBays)...
                + xBayNumber);

            % xBeam cracked stiffness factor EIeff/EIg
            beamEIeffOverEIg = load('EIeffOverEIg.txt');
            xBeamObject.EIeffOverEIg = beamEIeffOverEIg((level - 1),...
                (ZColumnLineNumber - 1)*(buildingGeometry.numberOfXBays)...
                + xBayNumber);
            
            % Expected (1.05D + 0.25L) uniform beams loads used for 2D and 
            % 3D OpenSees models. 
            cd(LoadParametersLocation)        
            beamLoads = load('xDirectionBeamLoads.txt');
            xBeamObject.uniformXBeamLoads = beamLoads((level - 1),...
                (ZColumnLineNumber - 1)*(buildingGeometry.numberOfXBays)...
                + xBayNumber);
            
            cd(classesDirectory)
        end      
        
    end
    
end

