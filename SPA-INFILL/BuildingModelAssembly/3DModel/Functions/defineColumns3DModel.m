% This function is used to generate the tcl file that defines the Columns
% for a 3D Model in OpenSees     
function defineColumns3DModel(buildingGeometry,columnObjects,...
    BuildingModelDirectory,AnalysisType)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                  Generating Tcl File with Columns Defined                %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    % Go to model data direction
    cd(BuildingModelDirectory)

    % Make folder used to store OpenSees models
    cd OpenSees3DModels
    cd(AnalysisType)
    
    % Opening and defining Tcl file
    fid = fopen('DefineColumns3DModel.tcl','wt');

    % Writing file description into tcl file
    fprintf(fid,'%s\n','# This file will be used to define columns');
    fprintf(fid,'%s\n','');
    fprintf(fid,'%s\n','');

    % Defining Columns
    fprintf(fid,'%s\n','# Define Columns');
    % Looping over all stories
    for i = 1:buildingGeometry.numberOfStories
        % Looping over the number of Z-direction column lines
        for j = 1:(buildingGeometry.numberOfZBays + 1)
            % Looping over the number of X-direction column lines
            for k = 1:(buildingGeometry.numberOfXBays + 1)
                % Defining Columns
                fprintf(fid,'%s\t','element');
                fprintf(fid,'%s\t','elasticBeamColumn');        
                fprintf(fid,'%s\t',columnObjects{i,k,j}.openSeesTag);
                fprintf(fid,'%s\t',...
                    columnObjects{i,k,j}.startHingeNodeOpenSeesTag);
                fprintf(fid,'%s\t',...
                    columnObjects{i,k,j}.endHingeNodeOpenSeesTag);
                fprintf(fid,'%10.3f\t',columnObjects{i,k,j}.area);
                fprintf(fid,'%10.3f\t',columnObjects{i,k,j}.E);
                fprintf(fid,'%10.3f\t',1.0);
                fprintf(fid,'%10.3f\t',columnObjects{i,k,j}.GJ);
                fprintf(fid,'%10.3f\t',columnObjects{i,k,j}.IgtrZZ*...
                    columnObjects{i,k,j}.EIeffOverEIg);
                fprintf(fid,'%10.3f\t',columnObjects{i,k,j}.IgtrXX*...
                    columnObjects{i,k,j}.EIeffOverEIg);
                fprintf(fid,'%s','$PDeltaTransf'); 
                fprintf(fid,'%s\n',';');
            end
        end
    end
    fprintf(fid,'%s\n','puts "Columns defined"');
    fprintf(fid,'%s\n','');

    % Closing and saving tcl file
    fclose(fid);
end

