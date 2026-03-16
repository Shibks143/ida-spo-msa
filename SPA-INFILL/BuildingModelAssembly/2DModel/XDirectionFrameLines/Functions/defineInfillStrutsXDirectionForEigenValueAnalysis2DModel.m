% This function is used to generate the tcl file that defines the  
% infill struts for a 3D Model in OpenSees     
function defineInfillStrutsXDirectionForEigenValueAnalysis2DModel(...
    buildingGeometry,xDirectionInfillObjects,BuildingModelDirectory,...
    xDirectionInfillPropertiesLocation,FrameLineNumber,AnalysisType)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%             Generating Tcl File with Infill Struts Defined              %
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
    fid = fopen('DefineInfillStrutsForEigenValueAnalysis2DModel.tcl','wt');

    % Writing file description into tcl file
    fprintf(fid,'%s\n','# This file will be used to define infill struts');
    fprintf(fid,'%s\n','');
    fprintf(fid,'%s\n','');

    % Defining infill struts
    fprintf(fid,'%s\n','# Define infills');
    % Looping over all stories
    for i = 1:buildingGeometry.numberOfStories
        fprintf(fid,'%s\n',strcat('# Story',num2str(i)));
        % Loop over the number of X-Direction column lines
        for j = 1:buildingGeometry.numberOfXBays
            if xInfillLocation(i,(FrameLineNumber - 1)*...
                    buildingGeometry.numberOfXBays + j) == 1
                % Central east-west strut
                fprintf(fid,'%s\t','element');
                fprintf(fid,'%s\t','truss');
                fprintf(fid,'%s\t',...
                    xDirectionInfillObjects{i,j,FrameLineNumber}. ...
                    centralEastWestStrutOpenSeesTag);
                fprintf(fid,'%s\t',...
                    xDirectionInfillObjects{i,j,FrameLineNumber}. ...
                    centralEastWestStrutStartNodeOpenSeesTag);
                fprintf(fid,'%s\t',...
                    xDirectionInfillObjects{i,j,FrameLineNumber}. ...
                    centralEastWestStrutEndNodeOpenSeesTag);
                fprintf(fid,'%u\t',1.0);
                fprintf(fid,'%s',strcat('$CentralStrutXStory',...
                num2str(i),'Bay',num2str(j),'Line',num2str(...
                FrameLineNumber)));
                fprintf(fid,'%s\n',';');
            end
        end
        fprintf(fid,'%s\n','');
    end    
    fprintf(fid,'%s\n','puts "infill struts defined"');
    fprintf(fid,'%s\n','');

    % Closing and saving tcl file
    fclose(fid);
end

