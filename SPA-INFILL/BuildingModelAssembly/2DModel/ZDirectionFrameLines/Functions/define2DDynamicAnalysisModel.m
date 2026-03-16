% This function is used to generate the tcl file that sources all 
% tcl files needed to run a 3D Model in OpenSees  
function define2DDynamicAnalysisModel(FrameLineNumber,...
    BuildingModelDirectory,AnalysisType)

    % Go to model data direction
    cd(BuildingModelDirectory)

    % Go to folder used to store OpenSees models
    cd OpenSees2DModels
    cd ZDirectionFrameLines
    FrameLineModelFolder = sprintf('Line_%d',FrameLineNumber);
    cd(FrameLineModelFolder)
    cd(AnalysisType)

    % Opening and defining Tcl file
    fid = fopen(strcat('Model','.tcl'),'wt');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%         Defining Model Builder and Sourcing Appropriate Procedures      %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    % Clear memory
    fprintf(fid,'%s\n','wipe all;');
    fprintf(fid,'%s\n','');

    % Defining model builder
    fprintf(fid,'%s\n','model BasicBuilder -ndm 2 -ndf 3;');
    fprintf(fid,'%s\n','');

    % Source appropriate procedures
    fprintf(fid,'%s\n','source DefineUnitsAndConstants.tcl');
    fprintf(fid,'%s\n','source DefineVariables.tcl');
    fprintf(fid,'%s\n','source DefineFunctionsAndProcedures.tcl');
    fprintf(fid,'%s\n','source Define_GM_Record_Info.tcl');
    fprintf(fid,'%s\n','');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%      Defining Nodes, Rigid Floor Diaphragm Constraints and Fixities     %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    % Defining nodes
    fprintf(fid,'%s\n','# Defining nodes');
    fprintf(fid,'%s\n','source DefineNodes2DModel.tcl');
    fprintf(fid,'%s\n','');
    
    % Defining node fixities
    fprintf(fid,'%s\n','# Defining node fixities');
    fprintf(fid,'%s\n','source DefineFixities2DModel.tcl');
    fprintf(fid,'%s\n','');


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                       Defining All Material Models                      %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    % Beam hinge material models
    fprintf(fid,'%s\n','# Defining beam hinge material models');
    fprintf(fid,'%s\n','source DefineBeamHingeMaterials2DModel.tcl');
    fprintf(fid,'%s\n','');

    % Column hinge material models
    fprintf(fid,'%s\n','# Defining column hinge material models');
    fprintf(fid,'%s\n','source DefineColumnHingeMaterials2DModel.tcl');
    fprintf(fid,'%s\n','');

    % Infill strut material
    fprintf(fid,'%s\n','source DefineInfillStrutMaterials2DModel.tcl');
    fprintf(fid,'%s\n','');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                  Defining Beam-Column Framing Elements                  %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    % Define beam elements
    fprintf(fid,'%s\n','# Defining beam elements');
    fprintf(fid,'%s\n','source DefineBeams2DModel.tcl');
    fprintf(fid,'%s\n','');

    % Define column elements
    fprintf(fid,'%s\n','# Defining column elements');
    fprintf(fid,'%s\n','source DefineColumns2DModel.tcl');
    fprintf(fid,'%s\n','');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                  Defining Beam-Column Plastic Hinges                    %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    % Define beam hinges
    fprintf(fid,'%s\n','# Defining beam hinges');
    fprintf(fid,'%s\n','source DefineBeamHinges2DModel.tcl');
    fprintf(fid,'%s\n','');

    % Define column hinges
    fprintf(fid,'%s\n','# Defining column hinges');
    fprintf(fid,'%s\n','source DefineColumnHinges2DModel.tcl');
    fprintf(fid,'%s\n','');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                           Define Gravity Loads                          %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    % Define gravity loads
    fprintf(fid,'%s\n','# Define gravity loads');
    fprintf(fid,'%s\n','source DefineGravityLoads2DModel.tcl');
    fprintf(fid,'%s\n','');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                    Defining Infill Strut Elements                       %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    % Define infill strut elements
    fprintf(fid,'%s\n','# Defining infill strut elements');
    fprintf(fid,'%s\n','source DefineInfillStruts2DModel.tcl');
    fprintf(fid,'%s\n','');
    
    
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                            Defining Recorders                           %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    % Define recorders
    fprintf(fid,'%s\n','# Defining recorders');
    fprintf(fid,'%s\n','source DefineAllRecorders2DModel.tcl');
    fprintf(fid,'%s\n','');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                         Perform Gravity Analysis                        %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    % Perform Gravity Analysis 
    fprintf(fid,'%s\n','# Perform gravity analysis');
    fprintf(fid,'%s\n','source PerformGravityAnalysis.tcl');
    fprintf(fid,'%s\n','');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                           Defining Masses                               %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    % Define masses
    fprintf(fid,'%s\n','# Defining masses');
    fprintf(fid,'%s\n','source DefineMasses2DModel.tcl');
    fprintf(fid,'%s\n','');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                            Defining Damping                             %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    % Define damping
    fprintf(fid,'%s\n','# Defining damping');
    fprintf(fid,'%s\n','source DefineDamping2DModel.tcl');
    fprintf(fid,'%s\n','');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                    Define Ground Motion Scale Factor                    %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    % Run Time History
    fprintf(fid,'%s\n','# Define ground motion scale factor');
    fprintf(fid,'%s\n',...
        strcat('set scalefactor [expr $g*$scale/100*$MCE_SF];'));
    fprintf(fid,'%s\n','');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                            Run Time History                             %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    % Run Time History
    fprintf(fid,'%s\n','# Run Time History');
    fprintf(fid,'%s\n','source DefineTimeHistory.tcl');
    fprintf(fid,'%s\n','');

    fprintf(fid,'%s\n','puts "Analysis Completed"');

    % Closing and saving tcl file
    fclose(fid);

end



