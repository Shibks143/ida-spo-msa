% This function is used to generate the tcl file that defines the pushover 
% load pattern for a 3D Model in OpenSees

function definePushoverLoading3DModel(buildingGeometry,...
    seismicParametersObject,jointNodes,BuildingModelDirectory,AnalysisType)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%             Generating Tcl File with Pushover Loading Defined           %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    % Go to model data direction
    cd(BuildingModelDirectory)

    % Make folder used to store OpenSees models
    cd OpenSees3DModels
    cd(AnalysisType)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                  X-Direction Pushover Loading Defined                   %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    % Opening and defining Tcl file
    fid = fopen('DefinePushoverXLoading3DModel.tcl','wt');

    % Writing file description into tcl file
    fprintf(fid,'%s\n','# Define pushover loading');
    fprintf(fid,'%s\n','');
    fprintf(fid,'%s\n','');

    % Define pushover loading
    fprintf(fid,'%s\n','pattern Plain 200 Linear {');
    fprintf(fid,'%s\n','');

    % Define lateral loads
    fprintf(fid,'%s\n','# Pushover pattern');
    for i = 1:buildingGeometry.numberOfStories
        fprintf(fid,'%s\n',strcat('# Level ', num2str(i + 1)));
        % Looping over number of Z-Direction column lines
        for j = 1:(buildingGeometry.numberOfZBays + 1)
            % Looping over X-Direction column lines
            for k = 1:(buildingGeometry.numberOfXBays + 1)
                fprintf(fid,'%s\t','load');
                fprintf(fid,'%s\t',jointNodes{i + 1,k,j}.openSeesTag);
                fprintf(fid,'%10.3f\t',seismicParametersObject.Cvx(i));
                fprintf(fid,'%s\t','0 0 0 0 0;');
                fprintf(fid,'%s\n','');
            end
        end
        fprintf(fid,'%s\n','');    
    end

    fprintf(fid,'%s\n','}');

    % Closing and saving tcl file
    fclose(fid);
    
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                  X-Direction Pushover Loading Defined                   %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    % Opening and defining Tcl file
    fid = fopen('DefinePushoverZLoading3DModel.tcl','wt');

    % Writing file description into tcl file
    fprintf(fid,'%s\n','# Define pushover loading');
    fprintf(fid,'%s\n','');
    fprintf(fid,'%s\n','');

    % Define pushover loading
    fprintf(fid,'%s\n','pattern Plain 200 Linear {');
    fprintf(fid,'%s\n','');

    % Define lateral loads
    fprintf(fid,'%s\n','# Pushover pattern');
    for i = 1:buildingGeometry.numberOfStories
        fprintf(fid,'%s\n',strcat('# Level ', num2str(i + 1)));
        % Looping over number of Z-Direction column lines
        for j = 1:(buildingGeometry.numberOfZBays + 1)
            % Looping over X-Direction column lines
            for k = 1:(buildingGeometry.numberOfXBays + 1)
                fprintf(fid,'%s\t','load');
                fprintf(fid,'%s\t',jointNodes{i + 1,k,j}.openSeesTag);
                fprintf(fid,'%s\t','0 0');
                fprintf(fid,'%10.3f\t',seismicParametersObject.Cvx(i));
                fprintf(fid,'%s\t','0 0 0;');
                fprintf(fid,'%s\n','');
            end
        end
        fprintf(fid,'%s\n','');    
    end

    fprintf(fid,'%s\n','}');

    % Closing and saving tcl file
    fclose(fid);

end

