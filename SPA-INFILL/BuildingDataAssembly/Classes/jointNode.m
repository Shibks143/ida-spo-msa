classdef jointNode < handle
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
        % Beam-column joint node number
        number
        % Node X coordinate in inches
        xCoordinate
        % Node Z coordinate in inches
        yCoordinate
        % Node Z coordinate in inches
        zCoordinate
        % OpenSees node tag
        openSeesTag
        % Floor level location
        level
        % X Column line number
        XColumnLineNumber
        % Z Column line number
        ZColumnLineNumber
        % 3 x 1 vector of x, y and z direction point loads in kips
        pointLoads  
        % 6 x 1 vector of x, y and z direction translational masses as well
        % as rotational masses about the x, y and z axes
        nodalMasses
    end    
    
    methods
        % Constructor function
        function jointNodeObject = jointNode(number,level,...
                XColumnLineNumber,ZColumnLineNumber,XBayWidths,...
                ZBayWidths,storyHeights)
            
            % Attach node number
            jointNodeObject.number = number;
            
            % Attach node level
            jointNodeObject.level = level;
            
            % Attach X-ColumnLine Number
            jointNodeObject.XColumnLineNumber = ...
                XColumnLineNumber;
            
            % Attach Z-ColumnLine Number
            jointNodeObject.ZColumnLineNumber = ...
                ZColumnLineNumber;
            
            % Initialize nodal coordinates
            jointNodeObject.xCoordinate = 0;
            jointNodeObject.yCoordinate = 0;
            jointNodeObject.zCoordinate = 0;
            
            % Compute nodal coordinates
            if XColumnLineNumber > 1
                jointNodeObject.xCoordinate = ...
                    sum(XBayWidths(1:XColumnLineNumber - 1));
            end
            
            if ZColumnLineNumber > 1
                jointNodeObject.zCoordinate = ...
                    sum(ZBayWidths(1:ZColumnLineNumber - 1));
            end
            jointNodeObject.yCoordinate = ...
                sum(storyHeights(1:(level - 1))); 
            
            % OpenSees model node tag
            if length(storyHeights) > 8
                jointNodeObject.openSeesTag = num2str(number);
            else
                jointNodeObject.openSeesTag = strcat(...
                    num2str(XColumnLineNumber),num2str(level),...
                    num2str(ZColumnLineNumber));
            end
            
        end        
    end
    
end

