classdef zBeam < handle
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
        % zBeam number
        number
        % Floor level
        level
        % Bay number
        bay
        % xDirection column line number
        xDirectionColumnLine
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
        uniformZBeamLoads
    end    
    
    methods
        % Constructor function
        function zBeamObject = zBeam(number,level,xColumnLineNumber,...
                zBayNumber,jointNodes,BeamPropertiesLocation,...
                buildingGeometry,classesDirectory,LoadParametersLocation)
            
            % Attach zBeam number
            zBeamObject.number = number;  
            
            % Attach beam level
            zBeamObject.level = level;  
            
            % Attach beam xDirection bay number
            zBeamObject.bay = zBayNumber;  
            
            % Attach beam xDirection column line number
            zBeamObject.xDirectionColumnLine = xColumnLineNumber; 
            
            % Attach start joint node number
            zBeamObject.startJointNodeNumber = (level - 1)*...
                length(jointNodes(1,1,:))*length(jointNodes(1,:,1)) + ...
                (zBayNumber - 1)*length(jointNodes(1,:,1)) + ...
                xColumnLineNumber;  
            
            % Attach end joint node number
            zBeamObject.endJointNodeNumber = (level - 1)*...
                length(jointNodes(1,1,:))*length(jointNodes(1,:,1)) + ...
                (zBayNumber - 1)*length(jointNodes(1,:,1)) + ...
                xColumnLineNumber + buildingGeometry.numberOfXBays + 1;    
            
            % Attach start joint node OpenSees Tag
            zBeamObject.startJointNodeOpenSeesTag = jointNodes{level,...
                xColumnLineNumber,zBayNumber}.openSeesTag;
            
            % Attach end joint node OpenSees Tag
            zBeamObject.endJointNodeOpenSeesTag = jointNodes{level,...
                xColumnLineNumber,zBayNumber + 1}.openSeesTag;
            
            % Attach start hinge node OpenSees Tag
            if buildingGeometry.numberOfStories > 8
                zBeamObject.startHingeNodeOpenSeesTag = num2str(...
                    (buildingGeometry.numberOfXBays + 1) * ...
                    (buildingGeometry.numberOfZBays + 1) * ...
                    (buildingGeometry.numberOfStories + 1) + 2*(...
                    (buildingGeometry.numberOfXBays + 1) * ...
                    (buildingGeometry.numberOfZBays + 1) * ...
                    (buildingGeometry.numberOfStories) + ... 
                    (buildingGeometry.numberOfXBays) * ...
                    (buildingGeometry.numberOfZBays + 1) * ...
                    (buildingGeometry.numberOfStories)) + ...
                     2*(number ...
                    - 1) + 1);
            else
                zBeamObject.startHingeNodeOpenSeesTag = strcat(...
                zBeamObject.startJointNodeOpenSeesTag,num2str(6));
            end
            
            % Attach end hinge node OpenSees Tag
            if buildingGeometry.numberOfStories > 8
                zBeamObject.endHingeNodeOpenSeesTag = num2str(...
                    (buildingGeometry.numberOfXBays + 1) * ...
                    (buildingGeometry.numberOfZBays + 1) * ...
                    (buildingGeometry.numberOfStories + 1) + 2*(...
                    (buildingGeometry.numberOfXBays + 1) * ...
                    (buildingGeometry.numberOfZBays + 1) * ...
                    (buildingGeometry.numberOfStories) + ... 
                    (buildingGeometry.numberOfXBays) * ...
                    (buildingGeometry.numberOfZBays + 1) * ...
                    (buildingGeometry.numberOfStories)) + ...
                     2*(number ...
                    - 1) + 2);
            else
                zBeamObject.endHingeNodeOpenSeesTag = strcat(...
                zBeamObject.endJointNodeOpenSeesTag,num2str(5));
            end            
            
            % Attach OpenSees Tag for beam element
            zBeamObject.openSeesTag = strcat(num2str(2),...
                zBeamObject.startHingeNodeOpenSeesTag,...
                zBeamObject.endHingeNodeOpenSeesTag);
            
            % Go to folder where structural properties are stored
            cd(BeamPropertiesLocation)
            
            % Attach beam length
            zBeamObject.length = buildingGeometry.ZBayWidths(zBayNumber);
            
            % Attach concrete modulus
            zBeamObject.E = load('E.txt');
            
            % Attach GJ
            zBeamObject.GJ = load('GJ.txt');
            
            % zBeam cross section areaa
            beamAreas = load('A.txt');
            zBeamObject.area = beamAreas((level - 1),...
                (xColumnLineNumber - 1)*(buildingGeometry.numberOfZBays)...
                + zBayNumber);
            
            % zBeam gross transformed moment of inertia
            beamIgtr = load('Igtr.txt');
            zBeamObject.Igtr = beamIgtr((level - 1),...
                (xColumnLineNumber - 1)*(buildingGeometry.numberOfZBays)...
                + zBayNumber);
            
            % zBeam cracked stiffness factor EIeff/EIg
            beamEIeffOverEIg = load('EIeffOverEIg.txt');
            zBeamObject.EIeffOverEIg = beamEIeffOverEIg((level - 1),...
                (xColumnLineNumber - 1)*(buildingGeometry.numberOfZBays)...
                + zBayNumber);    
            
            % Expected (1.05D + 0.25L) uniform beams loads used for 2D and 
            % 3D OpenSees models. 
            cd(LoadParametersLocation)   
            beamLoads = load('zDirectionBeamLoads.txt');
            zBeamObject.uniformZBeamLoads = beamLoads((level - 1),...
                (xColumnLineNumber - 1)*(buildingGeometry.numberOfZBays)...
                + zBayNumber); 
            
            cd(classesDirectory)
        end      
        
    end
    
end

