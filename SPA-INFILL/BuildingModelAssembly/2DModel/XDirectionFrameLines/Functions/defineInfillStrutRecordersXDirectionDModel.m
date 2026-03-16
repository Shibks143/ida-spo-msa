% This function is used to generate the tcl file that defines recorders for
% beam hinges
function defineInfillStrutRecordersXDirectionDModel(...
    buildingGeometry,xDirectionInfillObjects,...
    xDirectionInfillPropertiesLocation,FrameLineNumber,...
    BuildingModelDirectory,AnalysisType)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%       Generating Tcl File with X-Direction Infill Strut Recorders       %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    % Load text file with X-Direction infill strut locations
    cd(xDirectionInfillPropertiesLocation)
    xInfillLocation = load('xInfillLocation.txt'); 
    
    % Go to model data direction
    cd(BuildingModelDirectory)

    % Go to folder used to store OpenSees models
    cd OpenSees2DModels
    cd XDirectionFrameLines
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
    else
        fprintf(fid,'%s\n',strcat('$baseDir/$dataDir/EQ_$eqNumber/',...
            'Scale_$scale/InfillStrutForces'));
        fprintf(fid,'%s\n','');
    end

    % Defining recorders for X-Direction infill struts
    fprintf(fid,'%s\n','# Central X-Direction infill strut force recorders');
    % Looping over all stories
    for i = 1:buildingGeometry.numberOfStories 
        fprintf(fid,'%s\t','recorder Element -file'); 
        fprintf(fid,'%s\t',strcat('CentralXStrutForceStory',...
            num2str(i),'.out'));
        fprintf(fid,'%s\t','-time -ele');     
        % Looping over the number of Z-direction column lines
        for j = 1:buildingGeometry.numberOfXBays
            if xInfillLocation(i,(FrameLineNumber - 1)*...
                        buildingGeometry.numberOfXBays + j) == 1
                fprintf(fid,'%s\t',xDirectionInfillObjects{i,j,...
                    FrameLineNumber}. ...
                        centralEastWestStrutOpenSeesTag);
                fprintf(fid,'%s\t',xDirectionInfillObjects{i,j,...
                    FrameLineNumber}. ...
                        centralWestEastStrutOpenSeesTag);                    
            end
        end
        fprintf(fid,'%s\n','localForce');    
    end
    fprintf(fid,'%s\n','');
    
    fprintf(fid,'%s\n','# Offset X-Direction infill strut force recorders');
    % Looping over all stories
    for i = 1:buildingGeometry.numberOfStories 
        fprintf(fid,'%s\t','recorder Element -file'); 
        fprintf(fid,'%s\t',strcat('OffsetXStrutForceStory',...
            num2str(i),'.out'));
        fprintf(fid,'%s\t','-time -ele');     
        % Looping over the number of Z-direction column lines
        for j = 1:buildingGeometry.numberOfXBays
            if xInfillLocation(i,(FrameLineNumber - 1)*...
                        buildingGeometry.numberOfXBays + j) == 1
                fprintf(fid,'%s\t',xDirectionInfillObjects{i,j,...
                    FrameLineNumber}.offsetEastWestStrutOpenSeesTag);
                    fprintf(fid,'%s\t',xDirectionInfillObjects{i,j,...
                        FrameLineNumber}.offsetWestEastStrutOpenSeesTag);                    
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

    % Defining recorders for X-Direction infill struts
    fprintf(fid,'%s\n','# Central X-Direction infill strut deformation recorders');
    % Looping over all stories
    for i = 1:buildingGeometry.numberOfStories 
        fprintf(fid,'%s\t','recorder Element -file'); 
        fprintf(fid,'%s\t',strcat('CentralXStrutDeformationsStory',...
            num2str(i),'.out'));
        fprintf(fid,'%s\t','-time -ele');     
        % Looping over the number of Z-direction column lines
        for j = 1:buildingGeometry.numberOfXBays
            if xInfillLocation(i,(FrameLineNumber - 1)*...
                        buildingGeometry.numberOfXBays + j) == 1
                fprintf(fid,'%s\t',xDirectionInfillObjects{i,j,...
                    FrameLineNumber}.centralEastWestStrutOpenSeesTag);
                fprintf(fid,'%s\t',xDirectionInfillObjects{i,j,...
                    FrameLineNumber}.centralWestEastStrutOpenSeesTag);                    
            end
        end
        fprintf(fid,'%s\n','deformation');    
    end
    fprintf(fid,'%s\n','');
    
    fprintf(fid,'%s\n','# Offset X-Direction infill strut deformation recorders');
    % Looping over all stories
    for i = 1:buildingGeometry.numberOfStories 
        fprintf(fid,'%s\t','recorder Element -file'); 
        fprintf(fid,'%s\t',strcat('OffsetXStrutDeformationsStory',...
            num2str(i),'.out'));
        fprintf(fid,'%s\t','-time -ele');     
        % Looping over the number of Z-direction column lines
        for j = 1:buildingGeometry.numberOfXBays
            if xInfillLocation(i,(FrameLineNumber - 1)*...
                        buildingGeometry.numberOfXBays + j) == 1
                fprintf(fid,'%s\t',xDirectionInfillObjects{i,j,...
                    FrameLineNumber}.offsetEastWestStrutOpenSeesTag);
                fprintf(fid,'%s\t',xDirectionInfillObjects{i,j,...
                    FrameLineNumber}.offsetWestEastStrutOpenSeesTag);                    
            end
        end
        fprintf(fid,'%s\n','deformation');    
    end
    fprintf(fid,'%s\n','');

    % Closing and saving tcl file
    fclose(fid);
end

