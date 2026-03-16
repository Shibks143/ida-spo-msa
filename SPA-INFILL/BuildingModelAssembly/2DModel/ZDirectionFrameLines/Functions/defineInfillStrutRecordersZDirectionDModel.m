% This function is used to generate the tcl file that defines recorders for
% beam hinges
function defineInfillStrutRecordersZDirectionDModel(...
    buildingGeometry,zDirectionInfillObjects,...
    ZDirectionInfillPropertiesLocation,FrameLineNumber,...
    BuildingModelDirectory,AnalysisType)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%         Generating Tcl File with Defined Beam Hinge Recorders           %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    % Load text file with XNonSpine infill strut locations
    cd(ZDirectionInfillPropertiesLocation)
    zInfillLocation = load('zInfillLocation.txt'); 
    
    % Go to model data direction
    cd(BuildingModelDirectory)

    % Go to folder used to store OpenSees models
    cd OpenSees2DModels
    cd ZDirectionFrameLines
    FrameLineModelFolder = sprintf('Line_%d',FrameLineNumber);
    cd(FrameLineModelFolder)
    cd(AnalysisType)   

    % Opening and defining Tcl file
    fid = fopen('DefineInfillStrutRecorders2DModel.tcl','wt');

    % Writing file description into tcl file
    fprintf(fid,'%s\n','# Define infill strut force-deformation recorders');
    fprintf(fid,'%s\n','');
    fprintf(fid,'%s\n','');

    % Define force recorders
    % Changing directory to output location
    fprintf(fid,'%s\t','cd');
    if strcmp(AnalysisType,'PushoverAnalysis') == 1
        fprintf(fid,'%s\n',strcat('$baseDir/$dataDir/InfillStrutForces'));
        fprintf(fid,'%s\n','');
    elseif strcmp(AnalysisType,'DynamicAnalysis') == 1
        fprintf(fid,'%s\n',strcat('$baseDir/$dataDir/EQ_$eqNumber/',...
            'Scale_$scale/InfillStrutForces'));
        fprintf(fid,'%s\n','');
    end

    % Defining recorders for Z-Direction infill struts
    fprintf(fid,'%s\n','# Central Z-Direction infill strut force recorders');
    % Looping over all stories
    for i = 1:buildingGeometry.numberOfStories 
        fprintf(fid,'%s\t','recorder Element -file'); 
        fprintf(fid,'%s\t',strcat('CentralZStrutForceStory',...
            num2str(i),'.out'));
        fprintf(fid,'%s\t','-time -ele');     
        % Looping over the number of Z-direction column lines
        for j = 1:buildingGeometry.numberOfZBays
            if zInfillLocation(i,(j - 1)*...
                    (buildingGeometry.numberOfXBays + 1) + ...
                    FrameLineNumber) == 1
                fprintf(fid,'%s\t',zDirectionInfillObjects{i,...
                    FrameLineNumber,j}. ...
                        centralSouthNorthStrutOpenSeesTag);
                fprintf(fid,'%s\t',zDirectionInfillObjects{i,...
                    FrameLineNumber,j}.centralNorthSouthStrutOpenSeesTag);                    
            end
        end
        fprintf(fid,'%s\n','localForce');    
    end
    fprintf(fid,'%s\n','');
    
    fprintf(fid,'%s\n','# Offset Z-Direction infill strut force recorders');
    % Looping over all stories
    for i = 1:buildingGeometry.numberOfStories 
        fprintf(fid,'%s\t','recorder Element -file'); 
        fprintf(fid,'%s\t',strcat('OffsetZStrutForceStory',...
            num2str(i),'.out'));
        fprintf(fid,'%s\t','-time -ele');     
        % Looping over the number of Z-direction column lines
        for j = 1:buildingGeometry.numberOfZBays
            if zInfillLocation(i,(j - 1)*...
                    (buildingGeometry.numberOfXBays + 1) + ...
                    FrameLineNumber) == 1
                fprintf(fid,'%s\t',zDirectionInfillObjects{i,...
                    FrameLineNumber,j}.offsetSouthNorthStrutOpenSeesTag);
                    fprintf(fid,'%s\t',zDirectionInfillObjects{i,...
                        FrameLineNumber,j}. ...
                        offsetNorthSouthStrutOpenSeesTag);                    
            end
        end
        fprintf(fid,'%s\n','localForce');    
    end
    fprintf(fid,'%s\n','');

    % Define deformation recorders
    % Changing directory to output location
    fprintf(fid,'%s\t','cd');
    if strcmp(AnalysisType,'PushoverAnalysis') == 1
        fprintf(fid,'%s\n',strcat('$baseDir/$dataDir/InfillStrutDeformations'));
        fprintf(fid,'%s\n','');
    else
        fprintf(fid,'%s\n',strcat('$baseDir/$dataDir/EQ_$eqNumber/',...
            'Scale_$scale/InfillStrutDeformations'));
        fprintf(fid,'%s\n','');
    end

    % Defining recorders for Z-Direction infill struts
    fprintf(fid,'%s\n','# Central Z-Direction infill strut deformation recorders');
    % Looping over all stories
    for i = 1:buildingGeometry.numberOfStories 
        fprintf(fid,'%s\t','recorder Element -file'); 
        fprintf(fid,'%s\t',strcat('CentralZStrutDeformationsStory',...
            num2str(i),'.out'));
        fprintf(fid,'%s\t','-time -ele');     
        % Looping over the number of Z-direction column lines
        for j = 1:buildingGeometry.numberOfZBays
            if zInfillLocation(i,(j - 1)*...
                    (buildingGeometry.numberOfXBays + 1) + ...
                    FrameLineNumber) == 1
                fprintf(fid,'%s\t',zDirectionInfillObjects{i,...
                    FrameLineNumber,j}. ...
                        centralSouthNorthStrutOpenSeesTag);
                fprintf(fid,'%s\t',zDirectionInfillObjects{i,FrameLineNumber...
                    ,j}.centralNorthSouthStrutOpenSeesTag);                    
            end
        end
        fprintf(fid,'%s\n','deformation');    
    end
    fprintf(fid,'%s\n','');
    
    fprintf(fid,'%s\n','# Offset Z-Direction infill strut deformation recorders');
    % Looping over all stories
    for i = 1:buildingGeometry.numberOfStories 
        fprintf(fid,'%s\t','recorder Element -file'); 
        fprintf(fid,'%s\t',strcat('OffsetZStrutDeformationsStory',...
            num2str(i),'.out'));
        fprintf(fid,'%s\t','-time -ele');     
        % Looping over the number of Z-direction bays
        for j = 1:buildingGeometry.numberOfZBays
            if zInfillLocation(i,(j - 1)*...
                    (buildingGeometry.numberOfXBays + 1) + ...
                    FrameLineNumber) == 1
                fprintf(fid,'%s\t',zDirectionInfillObjects{i,...
                    FrameLineNumber,j}.offsetSouthNorthStrutOpenSeesTag);
                    fprintf(fid,'%s\t',zDirectionInfillObjects{i,...
                        FrameLineNumber,j}. ...
                        offsetNorthSouthStrutOpenSeesTag);                    
            end
        end
        fprintf(fid,'%s\n','deformation');    
    end
    fprintf(fid,'%s\n','');

    % Closing and saving tcl file
    fclose(fid);
end

