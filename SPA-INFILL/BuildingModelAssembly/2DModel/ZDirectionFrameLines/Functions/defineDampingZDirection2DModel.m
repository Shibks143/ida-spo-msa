% This function is used to generate the tcl file that defines Rayleigh
% Damping         

function defineDampingZDirection2DModel(buildingGeometry,...
    dynamicPropertiesObject,BuildingModelDirectory,zBeamObjects,...
    columnObjects,jointNodes,FrameLineNumber,AnalysisType)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                 Generating Tcl File with Damping Defined                %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    % Go to model data direction
    cd(BuildingModelDirectory)

    % Go to folder used to store OpenSees models
    cd OpenSees2DModels
    cd ZDirectionFrameLines
    FrameLineModelFolder = sprintf('Line_%d',FrameLineNumber);
    cd(FrameLineModelFolder)
    cd(AnalysisType)    

    % Opening and defining Tcl file
    fid = fopen('DefineDamping2DModel.tcl','wt');

    % Writing file description into tcl file
    fprintf(fid,'%s\n','# This file will be used to define damping');
    fprintf(fid,'%s\n','');
    fprintf(fid,'%s\n','');

    % Defining damping properties
    fprintf(fid,'%s\n','# Defining damping parameters');
    fprintf(fid,'%s\n','set omegaI [expr (2.0 * $pi) / $periodForRayleighDamping_1]');
    fprintf(fid,'%s\n','set omegaJ [expr (2.0 * $pi) / ($periodForRayleighDamping_2)]');
    fprintf(fid,'%s\n','set alpha1Coeff [expr (2.0 * $omegaI * $omegaJ) / ($omegaI + $omegaJ)]');
    fprintf(fid,'%s\n','set alpha2Coeff [expr (2.0) / ($omegaI + $omegaJ)]');
    fprintf(fid,'%s\n',strcat('set alpha1  [expr $alpha1Coeff*',...
        num2str(dynamicPropertiesObject.dampingRatio),']'));
    fprintf(fid,'%s\n',strcat('set alpha2  [expr $alpha2Coeff*',...
        num2str(dynamicPropertiesObject.dampingRatio),']'));
    fprintf(fid,'%s\n','set alpha2ToUse [expr 1.1 * $alpha2];   # 1.1 factor is becuase we apply to only LE elements');

    % Assigning damping to beams
    fprintf(fid,'%s\n','# Assign damping to beam elements');
    fprintf(fid,'%s\t','region 1 -eleRange');
    fprintf(fid,'%s\t',zBeamObjects{1,FrameLineNumber,1}.openSeesTag);
    fprintf(fid,'%s\t',zBeamObjects{buildingGeometry.numberOfStories,...
        FrameLineNumber,buildingGeometry.numberOfZBays}.openSeesTag);
    fprintf(fid,'%s\n','-rayleigh $alpha1 0 $alpha2ToUse 0;');

    % Assigning damping to columns
    fprintf(fid,'%s\n','# Assign damping to column elements');
    fprintf(fid,'%s\t','region 2 -eleRange');
    fprintf(fid,'%s\t',columnObjects{1,FrameLineNumber,1}.openSeesTag);
    fprintf(fid,'%s\t',columnObjects{buildingGeometry.numberOfStories,...
        FrameLineNumber,buildingGeometry.numberOfZBays + 1}.openSeesTag);
    fprintf(fid,'%s\n','-rayleigh $alpha1 0 $alpha2ToUse 0;');

    % Assigning damping to nodes
    fprintf(fid,'%s\n','# Assign damping to nodes');
    fprintf(fid,'%s\t','region 3 -nodeRange');
    fprintf(fid,'%s\t',jointNodes{1,FrameLineNumber,1}.openSeesTag);
    fprintf(fid,'%s\t',jointNodes{buildingGeometry.numberOfStories + 1,...
        FrameLineNumber,buildingGeometry.numberOfZBays + 1}.openSeesTag);
    fprintf(fid,'%s\n','-rayleigh $alpha1 0 $alpha2ToUse 0;');

    % Closing and saving tcl file
    fclose(fid);

end

