% This function is used to generate the tcl file that defines all 
% gravity loads for an XDirection 2D Model in OpenSees  
function defineMassesXDirection2DModel(buildingGeometry,buildingLoads,...
    jointNodes,xBeamObjects,columnObjects,leaningColumnNodeObjects,...
    FrameLineNumber,BuildingModelDirectory,AnalysisType)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                Generating Tcl File with Defined Nodal Masses            %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    % Go to model data direction
    cd(BuildingModelDirectory)

    % Go to folder used to store OpenSees models
    cd OpenSees2DModels
    cd XDirectionFrameLines
    FrameLineModelFolder = sprintf('Line_%d',FrameLineNumber);
    cd(FrameLineModelFolder)
    cd(AnalysisType)  

    % Opening and defining Tcl file
    fid = fopen('DefineMasses2DModel.tcl','wt');
    
    % Define gravitational constant in in/sec^2
    g = 32.2*12;
    
    % Typical beam depth (used to compute rotational masses)
    TypicalBeamDepth = sqrt(xBeamObjects{1,1,1}.area);

    % Typical column depth (used to compute rotational masses)
    TypicalColumnDepth = sqrt(columnObjects{1,1,1}.area);
    
    % Tributary width for node (in)
    NodeTributaryWidth = 2*TypicalBeamDepth + .5*TypicalColumnDepth;
    
    % Floor Area (in^2) (used to compute rotational masses)
    FloorArea = sum(buildingGeometry.XBayWidths)*...
        sum(buildingGeometry.ZBayWidths);
    for i = 1:buildingGeometry.numberOfStories
        UniformFloorWeights(i) = buildingLoads.floorWeights(i)/FloorArea;
    end
    
    % Compute number of corner frame nodes per floor
    numberOfCornerNodesPerFloor = (buildingGeometry.numberOfXBays + 2);

    % Compute number of beam hinge nodes per floor
    numberOfBeamHingeNodesPerFloor = 2*(buildingGeometry.numberOfXBays);

    % Compute number of column hinge nodes per floor
    numberOfColumnHingeNodesPerFloor = 2*(buildingGeometry.numberOfXBays...
        + 2);

    % Total number of nodes per typical floor
    numberOfNodesTypicalFloor = numberOfCornerNodesPerFloor + ...
        numberOfBeamHingeNodesPerFloor + numberOfColumnHingeNodesPerFloor;

    % Total number of nodes at roof level
    numberOfNodesRoof = numberOfCornerNodesPerFloor + ...
        numberOfBeamHingeNodesPerFloor + ...
        0.5*numberOfColumnHingeNodesPerFloor;   
    
    % Computing nodal masses
    for i = 1:buildingGeometry.numberOfStories
        if i == buildingGeometry.numberOfStories
            % Array storing mass at each node (1st column stores 
            % translationalmass and 2nd column stores rotational mass
            NodalMass(i,1) = buildingLoads.floorWeights(i)/...
                numberOfNodesRoof/g;
            NodalMass(i,2) = UniformFloorWeights(i)*(...
                NodeTributaryWidth^4)/g...
                /5; % 5 represents the number of nodes at interior joint at
                    % roof
        else
            NodalMass(i,1) = buildingLoads.floorWeights(i)/...
                numberOfNodesTypicalFloor/g;
            NodalMass(i,2) = UniformFloorWeights(i)*...
                (NodeTributaryWidth^4)/g...
                /7; % 7 represents the number of nodes at interior joint at
                    % typical floor level
        end
    end
    
    
    % Writing file description into tcl file
    fprintf(fid,'%s\n','# This file will be used to define all nodal masses');
    fprintf(fid,'%s\n','');
    fprintf(fid,'%s\n','');

    % Defining nodal masses for nodes at corner of frames
    fprintf(fid,'%s\n','# Define nodal masses for nodes at corner of frames');
    % Looping over number of floor levels
    for i = 1:buildingGeometry.numberOfStories
        fprintf(fid,'%s\n',strcat('# Level ', num2str(i + 1)));
        % Looping over number of X-Direction column lines
        for j = 1:(buildingGeometry.numberOfXBays + 1)
            fprintf(fid,'%s\t','mass');
            fprintf(fid,'%s\t',jointNodes{i + 1,j,FrameLineNumber}. ...
                openSeesTag);
            fprintf(fid,'%10.3f\t',NodalMass(i,1)*buildingLoads. ...
                xFrameLinesTributarySeismicMassRatios(FrameLineNumber));
            fprintf(fid,'%10.3f\t',NodalMass(i,1)*buildingLoads. ...
                xFrameLinesTributarySeismicMassRatios(FrameLineNumber));
            fprintf(fid,'%10.3f',NodalMass(i,2)*buildingLoads. ...
                xFrameLinesTributarySeismicMassRatios(FrameLineNumber));
            fprintf(fid,'%s\n',';');
        end
        
        % Leaning column node
        fprintf(fid,'%s\t','mass');
        if buildingGeometry.numberOfStories > 8
            fprintf(fid,'%s\t',strcat(num2str(...
                leaningColumnNodeObjects.jointNodes(i + 1)))); 
        else
            fprintf(fid,'%s\t',strcat(num2str(j + 1),num2str(i + 1)));
        end
        fprintf(fid,'%10.3f\t',buildingLoads. ...
                xFrameLinesTributarySeismicMassRatios(FrameLineNumber)*...
                NodalMass(i,1));
        fprintf(fid,'%10.3f\t',buildingLoads. ...
                xFrameLinesTributarySeismicMassRatios(FrameLineNumber)*...
                NodalMass(i,1));
        fprintf(fid,'%s','1e-12');      
        fprintf(fid,'%s\n',';');
        fprintf(fid,'%s\n','');
    end

    % Defining nodal masses for extra nodes used to define column hinge
    fprintf(fid,'%s\n','# Define nodal masses for extra nodes used to define column hinge');
    % Looping over number of floor levels
    for i = 1:buildingGeometry.numberOfStories
        % Column hinge nodes at bottom of story
        fprintf(fid,'%s\n',strcat('# Bottom of story ', num2str(i)));
        % Looping over number of X-Direction column lines
        for j = 1:buildingGeometry.numberOfXBays + 1
            fprintf(fid,'%s\t','mass');
            fprintf(fid,'%s\t',columnObjects{i,j,FrameLineNumber}. ...
                startHingeNodeOpenSeesTag);
                if i == 1
                    fprintf(fid,'%10.3f\t',buildingLoads. ...
                xFrameLinesTributarySeismicMassRatios(FrameLineNumber)*...
                NodalMass(i,1)/10);
                    fprintf(fid,'%10.3f\t',buildingLoads. ...
                xFrameLinesTributarySeismicMassRatios(FrameLineNumber)*...
                NodalMass(i,1)/10);
                    fprintf(fid,'%10.3f',buildingLoads. ...
                xFrameLinesTributarySeismicMassRatios(FrameLineNumber)*...
                NodalMass(i,2)/10);
                    fprintf(fid,'%s\n',';');
                else
                    fprintf(fid,'%10.3f\t',buildingLoads. ...
                xFrameLinesTributarySeismicMassRatios(FrameLineNumber)*...
                NodalMass(i,1));
                    fprintf(fid,'%10.3f\t',buildingLoads. ...
                xFrameLinesTributarySeismicMassRatios(FrameLineNumber)*...
                NodalMass(i,1));
                    fprintf(fid,'%10.3f',buildingLoads. ...
                xFrameLinesTributarySeismicMassRatios(FrameLineNumber)*...
                NodalMass(i,2));
                    fprintf(fid,'%s\n',';');
                end
        end
                
        if i ~= 1
            % Leaning column node
            fprintf(fid,'%s\t','mass');
            if buildingGeometry.numberOfStories > 8
                fprintf(fid,'%s\t',...
                    num2str(leaningColumnNodeObjects.startHingeNodes(i)));
            else
                fprintf(fid,'%s\t',strcat(num2str(j + 1),num2str(i),...
                num2str(4)));
            end
            fprintf(fid,'%10.3f\t',buildingLoads. ...
                xFrameLinesTributarySeismicMassRatios(FrameLineNumber)*...
                NodalMass(i,1));
            fprintf(fid,'%10.3f\t',buildingLoads. ...
                xFrameLinesTributarySeismicMassRatios(FrameLineNumber)*...
                NodalMass(i,1));
            fprintf(fid,'%s','1e-12');
            fprintf(fid,'%s\n',';');
        end
        fprintf(fid,'%s\n','');

        % Column hinge nodes at top of story
        fprintf(fid,'%s\n',strcat('# Top of story ', num2str(i)));
        % Looping over number of X-Direction column lines
        for j = 1:buildingGeometry.numberOfXBays + 1
            fprintf(fid,'%s\t','mass');
            fprintf(fid,'%s\t',...
                    columnObjects{i,j,FrameLineNumber}. ...
                    endHingeNodeOpenSeesTag);          
            fprintf(fid,'%10.3f\t',buildingLoads. ...
                xFrameLinesTributarySeismicMassRatios(FrameLineNumber)*...
                NodalMass(i,1));
            fprintf(fid,'%10.3f\t',buildingLoads. ...
                xFrameLinesTributarySeismicMassRatios(FrameLineNumber)*...
                NodalMass(i,1));
            fprintf(fid,'%10.3f',buildingLoads. ...
                xFrameLinesTributarySeismicMassRatios(FrameLineNumber)*...
                NodalMass(i,2));
            fprintf(fid,'%s\n',';');
        end
        
        % Leaning column node
        fprintf(fid,'%s\t','mass');
        if buildingGeometry.numberOfStories > 8
                fprintf(fid,'%s\t',...
            num2str(leaningColumnNodeObjects.endHingeNodes(i)));
        else
        fprintf(fid,'%s\t',strcat(num2str(j + 1),num2str(i + 1),...
                num2str(2)));
        end
        fprintf(fid,'%10.3f\t',buildingLoads. ...
                xFrameLinesTributarySeismicMassRatios(FrameLineNumber)*...
                NodalMass(i,1));
        fprintf(fid,'%10.3f\t',buildingLoads. ...
                xFrameLinesTributarySeismicMassRatios(FrameLineNumber)*...
                NodalMass(i,1));
        fprintf(fid,'%s','1e-12');
        fprintf(fid,'%s\n',';');
        fprintf(fid,'%s\n','');
    end

    % Defining masses at extra nodes used to define beam hinges
    fprintf(fid,'%s\n',strcat('# Define masses at extra nodes needed to define beam hinges'));
    % Looping over number of stories
    for i = 1:buildingGeometry.numberOfStories
        fprintf(fid,'%s\n',strcat('# Level ', num2str(i + 1)));
        % Loop over the number of Z-Direction lines
        for j = 1:buildingGeometry.numberOfXBays
            % Define mass at beam hinge node at start of beam
            fprintf(fid,'%s\t','mass');
            fprintf(fid,'%s\t',...
                    xBeamObjects{i,j,FrameLineNumber}. ...
                    startHingeNodeOpenSeesTag);
            fprintf(fid,'%10.3f\t',buildingLoads. ...
                xFrameLinesTributarySeismicMassRatios(FrameLineNumber)*...
                NodalMass(i,1));
            fprintf(fid,'%10.3f\t',buildingLoads. ...
                xFrameLinesTributarySeismicMassRatios(FrameLineNumber)*...
                NodalMass(i,1));
            fprintf(fid,'%10.3f',buildingLoads. ...
                xFrameLinesTributarySeismicMassRatios(FrameLineNumber)*...
                NodalMass(i,2));
            fprintf(fid,'%s\n',';');

            % Define mass at beam hinge node at end of beam
            fprintf(fid,'%s\t','mass');
            fprintf(fid,'%s\t',...
                    xBeamObjects{i,j,FrameLineNumber}. ...
                    endHingeNodeOpenSeesTag);
            fprintf(fid,'%10.3f\t',buildingLoads. ...
                xFrameLinesTributarySeismicMassRatios(FrameLineNumber)*...
                NodalMass(i,1));
            fprintf(fid,'%10.3f\t',buildingLoads. ...
                xFrameLinesTributarySeismicMassRatios(FrameLineNumber)*...
                NodalMass(i,1));
            fprintf(fid,'%10.3f',buildingLoads. ...
                xFrameLinesTributarySeismicMassRatios(FrameLineNumber)*...
                NodalMass(i,2));
            fprintf(fid,'%s\n',';');             
        end
        fprintf(fid,'%s\n','');
    end

    fprintf(fid,'%s\n','puts "nodal masses defined"');
    fprintf(fid,'%s\n','');

    % Closing and saving tcl file
    fclose(fid);
end

