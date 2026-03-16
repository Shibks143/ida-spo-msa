classdef columnHinge < handle
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
        % Column story location
        story
        % Column length
        columnLength
        % xDirection column line number
        xDirectionColumnLine
        % xDirection column line
        zDirectionColumnLine
        % Column start joint node number
        startJointNodeNumber
        % Column end joint node number
        endJointNodeNumber
        % Column start joint node openSees tag
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
        % Bending stiffness about global Z-axis
        EIeffZZ
        % Bending stiffness about global Z-axis
        EIeffXX
        % Yield moment for benging about global Z-axis
        MyZZ
        % Yield moment for benging about global X-axis
        MyXX
        % Ratio of yield to capping moment
        McOverMy
        % Capping rotation
        thetaCap
        % Post-capping rotation
        thetaPC
        % Deterioration parameter
        lambda
        % Shear strength
        VnX        
        % Shear strength
        VnZ
        % Shear stiffness in global x-direction
        kShearXX
        % Shear stiffness in global x-direction
        kShearZZ
        % Post-capping displacement for deteriorating shear spring
        deltaPCShear
        % Tag used to choose whether or not column shear failure is
        % considered
        considerColumnShearFailure
    end    
    
    methods
        % Constructor function
        function columnHingeObject = columnHinge(columnObject,...
                ColumnHingePropertiesLocation,buildingGeometry,...
                classesDirectory)
            
            % Attach column number
            columnHingeObject.number = columnObject.number;  
            
            % Attach column story
            columnHingeObject.story = columnObject.story;  
            
            % Attach column xDirection column line number
            columnHingeObject.xDirectionColumnLine = ...
                columnObject.xDirectionColumnLine;  
            
            % Attach column zDirection column line number
            columnHingeObject.zDirectionColumnLine = ...
                columnObject.zDirectionColumnLine; 
            
            % Attach start joint node number
            columnHingeObject.startJointNodeNumber = ...
                columnObject.startJointNodeNumber;  
            
            % Attach end joint node number
            columnHingeObject.endJointNodeNumber = ...
                columnObject.endJointNodeNumber;  
            
            % Attach start joint node OpenSees Tag
            columnHingeObject.startJointNodeOpenSeesTag = ...
                columnObject.startJointNodeOpenSeesTag ;
            
            % Attach end joint node OpenSees Tag
            columnHingeObject.endJointNodeOpenSeesTag = ...
                columnObject.endJointNodeOpenSeesTag ;            
            
            % Attach start hinge node OpenSees Tag
            columnHingeObject.startHingeNodeOpenSeesTag = ...
                columnObject.startHingeNodeOpenSeesTag;
            
            % Attach end hinge node OpenSees Tag
            columnHingeObject.endHingeNodeOpenSeesTag = ...
                columnObject.endHingeNodeOpenSeesTag;
            
            % Attach start hinge element OpenSees Tag
            columnHingeObject.startHingeOpenSeesTag = ...
                strcat(num2str(6),...
                columnHingeObject.startJointNodeOpenSeesTag,...
                columnHingeObject.startHingeNodeOpenSeesTag);
            
            % Attach end hinge element OpenSees Tag
            columnHingeObject.endHingeOpenSeesTag = ...
                strcat(num2str(6),...
                columnHingeObject.endJointNodeOpenSeesTag,...
                columnHingeObject.endHingeNodeOpenSeesTag);
            
            % Attach column length
            columnHingeObject.columnLength = columnObject.length;
            
            % Go to folder where structural properties are stored
            cd(ColumnHingePropertiesLocation)
            
            % Attach bending stiffness about global Z-axis
            columnHingeObject.EIeffZZ = columnObject.E*...
                columnObject.IgtrZZ*columnObject.EIeffOverEIg;
            
            % Attach bending stiffness about global X-axis
            columnHingeObject.EIeffXX = columnObject.E*...
                columnObject.IgtrXX*columnObject.EIeffOverEIg;
            
            % Attach My
            columnHingeMyZZ = load('MyZZ.txt');
            columnHingeMyXX = load('MyXX.txt');
            columnHingeObject.MyZZ  = columnHingeMyZZ(...
                columnObject.story,(...
                columnObject.zDirectionColumnLine -...
                1)* (buildingGeometry.numberOfXBays + 1) + ...
                columnObject.xDirectionColumnLine);
            columnHingeObject.MyXX  = columnHingeMyXX(...
                columnObject.story,(...
                columnObject.zDirectionColumnLine -...
                1)* (buildingGeometry.numberOfXBays + 1) + ...
                columnObject.xDirectionColumnLine);
            
            % Attach McOverMy
            columnHingeMcOverMy = load('McOverMy.txt');
            columnHingeObject.McOverMy  = columnHingeMcOverMy(...
                columnObject.story,(columnObject.zDirectionColumnLine -...
                1)* (buildingGeometry.numberOfXBays + 1) + ...
                columnObject.xDirectionColumnLine);
            
            % Attach thetaCap
            columnHingethetaCap = load('thetaCap.txt');
            columnHingeObject.thetaCap  = columnHingethetaCap(...
                columnObject.story,(columnObject.zDirectionColumnLine -...
                1)* (buildingGeometry.numberOfXBays + 1) + ...
                columnObject.xDirectionColumnLine);
            
            % Attach thetaPC
            columnHingethetaPC = load('thetaPC.txt');
            columnHingeObject.thetaPC  = columnHingethetaPC(...
                columnObject.story,(columnObject.zDirectionColumnLine -...
                1)* (buildingGeometry.numberOfXBays + 1) + ...
                columnObject.xDirectionColumnLine);
            
            % Attach lambda
            columnHingelambda = load('lambda.txt');
            columnHingeObject.lambda  = columnHingelambda(...
                columnObject.story,(columnObject.zDirectionColumnLine -...
                1)* (buildingGeometry.numberOfXBays + 1) + ...
                columnObject.xDirectionColumnLine);
            
            % Attach Vn
            columnHingeVnX = load('VnX.txt');
            columnHingeObject.VnX  = columnHingeVnX(...
                columnObject.story,(columnObject.zDirectionColumnLine -...
                1)* (buildingGeometry.numberOfXBays + 1) + ...
                columnObject.xDirectionColumnLine);
            columnHingeVnZ = load('VnZ.txt');
            columnHingeObject.VnZ  = columnHingeVnZ(...
                columnObject.story,(columnObject.zDirectionColumnLine -...
                1)* (buildingGeometry.numberOfXBays + 1) + ...
                columnObject.xDirectionColumnLine);
            
            % Attach kShear
            columnHingekShearXX = load('kShearXX.txt');
            columnHingeObject.kShearXX  = columnHingekShearXX(...
                columnObject.story,(columnObject.zDirectionColumnLine -...
                1)* (buildingGeometry.numberOfXBays + 1) + ...
                columnObject.xDirectionColumnLine);
            columnHingekShearZZ = load('kShearZZ.txt');
            columnHingeObject.kShearZZ  = columnHingekShearZZ(...
                columnObject.story,(columnObject.zDirectionColumnLine -...
                1)* (buildingGeometry.numberOfXBays + 1) + ...
                columnObject.xDirectionColumnLine);
            
            % Attach kShear
            columnHingedeltaPCShear = load('deltaPCShear.txt');
            columnHingeObject.deltaPCShear  = columnHingedeltaPCShear(...
                columnObject.story,(columnObject.zDirectionColumnLine -...
                1)* (buildingGeometry.numberOfXBays + 1) + ...
                columnObject.xDirectionColumnLine);
            
            % Attach tag used to determine whether or not column shear
            % failure is considered
            columnHingeObject.considerColumnShearFailure{1,1,1} = ...
                load('considerColumnShearFailure.txt');
            
            cd(classesDirectory)
        end      
        
    end
    
end

