% This function is used to generate the tcl file that defines recorders 
% infill struts
function defineInfillStrutRecorders3DModel(buildingGeometry,...
    xDirectionInfillObjects,zDirectionInfillObjects,...
    xDirectionInfillPropertiesLocation,...
    ZDirectionInfillPropertiesLocation,BuildingModelDirectory,...
    AnalysisType)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%         Generating Tcl File with Defined Infill Strut Recorders         %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    % Load text file with XNonSpine infill strut locations
    cd(xDirectionInfillPropertiesLocation)
    xInfillLocation = load('xInfillLocation.txt');    
    
    % Load text file with ZNonSpine infill strut locations
    cd(ZDirectionInfillPropertiesLocation)
    zInfillLocation = load('zInfillLocation.txt');
    
    % Go to model data direction
    cd(BuildingModelDirectory)

    % Make folder used to store OpenSees models
    cd OpenSees3DModels
    cd(AnalysisType)

    % Opening and defining Tcl file
    fid = fopen('DefineInfillStrutRecorders3DModel.tcl','wt');

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
    fprintf(fid,'%s\n','');

    % Defining recorders for X-Direction infill struts
    fprintf(fid,'%s\n','# Central X-Direction infill strut force recorders');
    % Looping over all stories
    for i = 1:buildingGeometry.numberOfStories 
        fprintf(fid,'%s\t','recorder Element -file'); 
        fprintf(fid,'%s\t',strcat('CentralXStrutForceStory',...
            num2str(i),'.out'));
        fprintf(fid,'%s\t','-time -ele');     
        % Looping over the number of Z-direction column lines
        for j = 1:(buildingGeometry.numberOfZBays + 1)
            % Looping over the number of X-direction bays
            for k = 1:buildingGeometry.numberOfXBays
                if xInfillLocation(i,(j - 1)*...
                        buildingGeometry.numberOfXBays + k) == 1
                    fprintf(fid,'%s\t',xDirectionInfillObjects{i,k,j}. ...
                        centralEastWestStrutOpenSeesTag);
                    fprintf(fid,'%s\t',xDirectionInfillObjects{i,k,j}. ...
                        centralWestEastStrutOpenSeesTag);                    
                end
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
        for j = 1:(buildingGeometry.numberOfZBays + 1)
            % Looping over the number of X-direction bays
            for k = 1:buildingGeometry.numberOfXBays
                if xInfillLocation(i,(j - 1)*...
                        buildingGeometry.numberOfXBays + k) == 1
                    fprintf(fid,'%s\t',xDirectionInfillObjects{i,k,j}. ...
                        offsetEastWestStrutOpenSeesTag);
                    fprintf(fid,'%s\t',xDirectionInfillObjects{i,k,j}. ...
                        offsetWestEastStrutOpenSeesTag);                    
                end
            end
        end
        fprintf(fid,'%s\n','localForce');    
    end
    fprintf(fid,'%s\n','');

    % Defining recorders for Z-Direction infill struts
    fprintf(fid,'%s\n','# Central Z-Direction infill strut force recorders');
    % Looping over all stories
    for i = 1:buildingGeometry.numberOfStories 
        fprintf(fid,'%s\t','recorder Element -file'); 
        fprintf(fid,'%s\t',strcat('CentralZStrutForceStory',...
            num2str(i),'.out'));
        fprintf(fid,'%s\t','-time -ele');     
        % Looping over the number of Z-direction bays
        for j = 1:(buildingGeometry.numberOfZBays)
            % Looping over the number of X-direction column lines
            for k = 1:buildingGeometry.numberOfXBays + 1
                if zInfillLocation(i,(j - 1)*...
                        (buildingGeometry.numberOfXBays + 1) + k) == 1
                    fprintf(fid,'%s\t',zDirectionInfillObjects{i,k,j}. ...
                        centralSouthNorthStrutOpenSeesTag);
                    fprintf(fid,'%s\t',zDirectionInfillObjects{i,k,j}. ...
                        centralNorthSouthStrutOpenSeesTag);                    
                end
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
        % Looping over the number of Z-direction bays
        for j = 1:(buildingGeometry.numberOfZBays)
            % Looping over the number of X-direction column lines
            for k = 1:buildingGeometry.numberOfXBays + 1
                if zInfillLocation(i,(j - 1)*...
                        (buildingGeometry.numberOfXBays + 1) + k) == 1
                    fprintf(fid,'%s\t',zDirectionInfillObjects{i,k,j}. ...
                        offsetSouthNorthStrutOpenSeesTag);
                    fprintf(fid,'%s\t',zDirectionInfillObjects{i,k,j}. ...
                        offsetNorthSouthStrutOpenSeesTag);                   
                end
            end
        end
        fprintf(fid,'%s\n','localForce');    
    end
    fprintf(fid,'%s\n','');

    % Define deformation recorders
    % Changing directory to output location
    fprintf(fid,'%s\t','cd');
    if strcmp(AnalysisType,'PushoverAnalysis') == 1
        fprintf(fid,'%s\n',strcat('$baseDir/$dataDir/',...
            'InfillStrutDeformations'));
        fprintf(fid,'%s\n','');
    else
        fprintf(fid,'%s\n',strcat('$baseDir/$dataDir/EQ_$eqNumber/',...
            'Scale_$scale/InfillStrutDeformations'));
        fprintf(fid,'%s\n','');
    end
    fprintf(fid,'%s\n','');

    % Defining recorders for X-Direction infill struts
    fprintf(fid,'%s\n','# Central X-Direction infill strut deformation recorders');
    % Looping over all stories
    for i = 1:buildingGeometry.numberOfStories 
        fprintf(fid,'%s\t','recorder Element -file'); 
        fprintf(fid,'%s\t',strcat(...
            'CentralXStrutDeformationsStory',...
            num2str(i),'.out'));
        fprintf(fid,'%s\t','-time -ele');     
        % Looping over the number of Z-direction column lines
        for j = 1:(buildingGeometry.numberOfZBays + 1)
            % Looping over the number of X-direction bays
            for k = 1:buildingGeometry.numberOfXBays
                if xInfillLocation(i,(j - 1)*...
                        buildingGeometry.numberOfXBays + k) == 1
                    fprintf(fid,'%s\t',xDirectionInfillObjects{i,k,j}. ...
                        centralEastWestStrutOpenSeesTag);
                    fprintf(fid,'%s\t',xDirectionInfillObjects{i,k,j}. ...
                        centralWestEastStrutOpenSeesTag);                    
                end
            end
        end
        fprintf(fid,'%s\n','deformation');    
    end
    fprintf(fid,'%s\n','');
    
    fprintf(fid,'%s\n','# Offset X-Direction infill strut deformation recorders');
    % Looping over all stories
    for i = 1:buildingGeometry.numberOfStories 
        fprintf(fid,'%s\t','recorder Element -file'); 
        fprintf(fid,'%s\t',strcat(...
            'OffsetXStrutDeformationsStory',...
            num2str(i),'.out'));
        fprintf(fid,'%s\t','-time -ele');     
        % Looping over the number of Z-direction column lines
        for j = 1:(buildingGeometry.numberOfZBays + 1)
            % Looping over the number of X-direction bays
            for k = 1:buildingGeometry.numberOfXBays
                if xInfillLocation(i,(j - 1)*...
                        buildingGeometry.numberOfXBays + k) == 1
                    fprintf(fid,'%s\t',xDirectionInfillObjects{i,k,j}. ...
                        offsetEastWestStrutOpenSeesTag);
                    fprintf(fid,'%s\t',xDirectionInfillObjects{i,k,j}. ...
                        offsetWestEastStrutOpenSeesTag);                    
                end
            end
        end
        fprintf(fid,'%s\n','deformation');    
    end
    fprintf(fid,'%s\n','');

    % Defining recorders for Z-Direction infill struts
    fprintf(fid,'%s\n','# Central Z-Direction infill strut deformation recorders');
    % Looping over all stories
    for i = 1:buildingGeometry.numberOfStories 
        fprintf(fid,'%s\t','recorder Element -file'); 
        fprintf(fid,'%s\t',strcat(...
            'CentralZStrutDeformationsStory',...
            num2str(i),'.out'));
        fprintf(fid,'%s\t','-time -ele');     
        % Looping over the number of Z-direction bays
        for j = 1:(buildingGeometry.numberOfZBays)
            % Looping over the number of X-direction column lines
            for k = 1:buildingGeometry.numberOfXBays + 1
                if zInfillLocation(i,(j - 1)*...
                        (buildingGeometry.numberOfXBays + 1) + k) == 1
                    fprintf(fid,'%s\t',zDirectionInfillObjects{i,k,j}. ...
                        centralSouthNorthStrutOpenSeesTag);
                    fprintf(fid,'%s\t',zDirectionInfillObjects{i,k,j}. ...
                        centralNorthSouthStrutOpenSeesTag);                    
                end
            end
        end
        fprintf(fid,'%s\n','deformation');    
    end
    fprintf(fid,'%s\n','');
    
    fprintf(fid,'%s\n','# Offset Z-Direction infill strut deformation recorders');
    % Looping over all stories
    for i = 1:buildingGeometry.numberOfStories 
        fprintf(fid,'%s\t','recorder Element -file'); 
        fprintf(fid,'%s\t',strcat(...
            'OffsetZStrutDeformationsStory',...
            num2str(i),'.out'));
        fprintf(fid,'%s\t','-time -ele');     
        % Looping over the number of Z-direction bays
        for j = 1:(buildingGeometry.numberOfZBays)
            % Looping over the number of X-direction column lines
            for k = 1:buildingGeometry.numberOfXBays + 1
                if zInfillLocation(i,(j - 1)*...
                        (buildingGeometry.numberOfXBays + 1) + k) == 1
                    fprintf(fid,'%s\t',zDirectionInfillObjects{i,k,j}. ...
                        offsetSouthNorthStrutOpenSeesTag);
                    fprintf(fid,'%s\t',zDirectionInfillObjects{i,k,j}. ...
                        offsetNorthSouthStrutOpenSeesTag);                   
                end
            end
        end
        fprintf(fid,'%s\n','deformation');    
    end
    fprintf(fid,'%s\n','');

    % Closing and saving tcl file
    fclose(fid);
end

