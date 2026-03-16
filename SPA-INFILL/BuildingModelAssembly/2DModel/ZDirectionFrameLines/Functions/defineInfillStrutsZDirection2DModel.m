% This function is used to generate the tcl file that defines the 
% infill struts for a 3D Model in OpenSees     
function defineInfillStrutsZDirection2DModel(buildingGeometry,...
    zDirectionInfillObjects,BuildingModelDirectory,...
    ZDirectionInfillPropertiesLocation,FrameLineNumber,AnalysisType)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%             Generating Tcl File with Infill Struts Defined              %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    % Load text file with X infill strut locations
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
    fid = fopen('DefineInfillStruts2DModel.tcl','wt');

    % Writing file description into tcl file
    fprintf(fid,'%s\n','# This file will be used to define infill struts');
    fprintf(fid,'%s\n','');
    fprintf(fid,'%s\n','');

    % Defining infill struts
    fprintf(fid,'%s\n','# Define infills');
    % Looping over all stories
    for i = 1:buildingGeometry.numberOfStories
        fprintf(fid,'%s\n',strcat('# Story',num2str(i)));
        % Loop over the number of Z-Direction column lines
        for j = 1:buildingGeometry.numberOfZBays
            if zInfillLocation(i,(j - 1)*...
                    (buildingGeometry.numberOfXBays + 1) + ...
                    FrameLineNumber) == 1
                % Central south-north strut
                if strcmp(AnalysisType,'EigenValueAnalysis') ~= 1 
                    fprintf(fid,'%s\t','element');
                    fprintf(fid,'%s\t','truss');
                    fprintf(fid,'%s\t',...
                        zDirectionInfillObjects{i,FrameLineNumber,j}. ...
                        centralSouthNorthStrutOpenSeesTag);
                    fprintf(fid,'%s\t',...
                        zDirectionInfillObjects{i,FrameLineNumber,j}. ...
                        centralSouthNorthStrutStartNodeOpenSeesTag);
                    fprintf(fid,'%s\t',...
                        zDirectionInfillObjects{i,FrameLineNumber,j}. ...
                        centralSouthNorthStrutEndNodeOpenSeesTag);
                    fprintf(fid,'%u\t',1.0);
                    fprintf(fid,'%s',strcat('$CentralStrutZStory',...
                    num2str(i),'Bay',num2str(j),'Line',num2str(...
                    FrameLineNumber)));
                    fprintf(fid,'%s\n',';');

                    % Offset south-north strut
                    fprintf(fid,'%s\t','element');
                    fprintf(fid,'%s\t','truss');
                    fprintf(fid,'%s\t',...
                        zDirectionInfillObjects{i,FrameLineNumber,j}. ...
                        offsetSouthNorthStrutOpenSeesTag);
                    fprintf(fid,'%s\t',...
                        zDirectionInfillObjects{i,FrameLineNumber,j}. ...
                        offsetSouthNorthStrutStartNodeOpenSeesTag);
                    fprintf(fid,'%s\t',...
                        zDirectionInfillObjects{i,FrameLineNumber,j}. ...
                        offsetSouthNorthStrutEndNodeOpenSeesTag);
                    fprintf(fid,'%u\t',1.0);
                    fprintf(fid,'%s',strcat('$OffsetStrutZStory',...
                    num2str(i),'Bay',num2str(j),'Line',num2str(...
                    FrameLineNumber)));
                    fprintf(fid,'%s\n',';');
                end

                % Central north-south strut
                fprintf(fid,'%s\t','element');
                fprintf(fid,'%s\t','truss');
                fprintf(fid,'%s\t',...
                    zDirectionInfillObjects{i,FrameLineNumber,j}. ...
                    centralNorthSouthStrutOpenSeesTag);
                fprintf(fid,'%s\t',...
                    zDirectionInfillObjects{i,FrameLineNumber,j}. ...
                    centralNorthSouthStrutStartNodeOpenSeesTag);
                fprintf(fid,'%s\t',...
                    zDirectionInfillObjects{i,FrameLineNumber,j}. ...
                    centralNorthSouthStrutEndNodeOpenSeesTag);
                fprintf(fid,'%u\t',1.0);
                fprintf(fid,'%s',strcat('$CentralStrutZStory',...
                num2str(i),'Bay',num2str(j),'Line',num2str(...
                FrameLineNumber)));
                fprintf(fid,'%s\n',';');

                % Offset north-south strut
                fprintf(fid,'%s\t','element');
                fprintf(fid,'%s\t','truss');
                fprintf(fid,'%s\t',...
                    zDirectionInfillObjects{i,FrameLineNumber,j}. ...
                    offsetNorthSouthStrutOpenSeesTag);
                fprintf(fid,'%s\t',...
                    zDirectionInfillObjects{i,FrameLineNumber,j}. ...
                    offsetNorthSouthStrutStartNodeOpenSeesTag);
                fprintf(fid,'%s\t',...
                    zDirectionInfillObjects{i,FrameLineNumber,j}. ...
                    offsetNorthSouthStrutEndNodeOpenSeesTag);
                fprintf(fid,'%u\t',1.0);
                fprintf(fid,'%s',strcat('$OffsetStrutZStory',...
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

