% This function is used to generate the tcl file that sources all 
% tcl files needed to run a 3D Model in OpenSees  
function define3DEigenValueAnalysisModel(BuildingModelDirectory,AnalysisType)

    % Go to model data direction
    cd(BuildingModelDirectory)

    % Make folder used to store OpenSees models
    cd OpenSees3DModels
    cd(AnalysisType)

    % Opening and defining Tcl file
    fid = fopen(strcat('Model','.tcl'),'wt');
    
    % Clear the memory
    fprintf(fid,'%s\n','# Clear the memory');
    fprintf(fid,'%s\n','wipe all');
    fprintf(fid,'%s\n','');
    
    % Defining model builder
    fprintf(fid,'%s\n','# Define model builder');
    fprintf(fid,'%s\n','model BasicBuilder -ndm 3 -ndf 6');
    fprintf(fid,'%s\n',''); 
    
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%               Define Miscellaneous Functions and Procedures             %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 

    % Define variables
    fprintf(fid,'%s\n','# Defining variables');
    fprintf(fid,'%s\n','source DefineVariables.tcl');
    fprintf(fid,'%s\n','');
    
    % Define units and constants
    fprintf(fid,'%s\n','# Defining units and constants');
    fprintf(fid,'%s\n','source DefineUnitsAndConstants.tcl');
    fprintf(fid,'%s\n','');
    
    % Define functions and procedures
    fprintf(fid,'%s\n','# Defining functions and procedures');
    fprintf(fid,'%s\n','source DefineFunctionsAndProcedures.tcl');
    fprintf(fid,'%s\n','');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%      Defining Nodes, Rigid Floor Diaphragm Constraints and Fixities     %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    % Defining nodes
    fprintf(fid,'%s\n','# Defining nodes');
    fprintf(fid,'%s\n','source DefineNodes3DModel.tcl');
    fprintf(fid,'%s\n','');

    % Defining rigid floor diaphragm constraints
    fprintf(fid,'%s\n','# Defining rigid floor diaphragm constraints');
    fprintf(fid,'%s\n','source DefineRigidFloorDiaphragm3DModel.tcl');
    fprintf(fid,'%s\n','');

    % Defining node fixities
    fprintf(fid,'%s\n','# Defining node fixities');
    fprintf(fid,'%s\n','source DefineFixities3DModel.tcl');
    fprintf(fid,'%s\n','');


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                       Defining All Material Models                      %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Beam hinge material models
fprintf(fid,'%s\n','# Defining beam hinge material models');
fprintf(fid,'%s\n','source DefineBeamHingeMaterials3DModel.tcl');
fprintf(fid,'%s\n','');

% Column hinge material models
fprintf(fid,'%s\n','# Defining column hinge material models');
fprintf(fid,'%s\n','source DefineColumnHingeMaterials3DModel.tcl');
fprintf(fid,'%s\n','');

% Infill strut material
fprintf(fid,'%s\n','source DefineInfillStrutMaterialsForEigenValueAnalysis3DModel.tcl');
fprintf(fid,'%s\n','');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                  Defining Beam-Column Framing Elements                  %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Define beam elements
fprintf(fid,'%s\n','# Defining beam elements');
fprintf(fid,'%s\n','source DefineBeams3DModel.tcl');
fprintf(fid,'%s\n','');

% Define column elements
fprintf(fid,'%s\n','# Defining column elements');
fprintf(fid,'%s\n','source DefineColumns3DModel.tcl');
fprintf(fid,'%s\n','');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                  Defining Beam-Column Plastic Hinges                    %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Define beam hinges
fprintf(fid,'%s\n','# Defining beam hinges');
fprintf(fid,'%s\n','source DefineBeamHinges3DModel.tcl');
fprintf(fid,'%s\n','');

% Define column hinges
fprintf(fid,'%s\n','# Defining column hinges');
fprintf(fid,'%s\n','source DefineColumnHinges3DModel.tcl');
fprintf(fid,'%s\n','');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                  Display Model with Node Numbers                        %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Display  model with node numbers
% fprintf(fid,'%s\n','# Display  model with node numbers');
% fprintf(fid,'%s\n','DisplayModel3D NodeNumbers');
% fprintf(fid,'%s\n','');


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                           Defining Masses                               %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Define masses
fprintf(fid,'%s\n','# Defining masses');
fprintf(fid,'%s\n','source DefineMasses3DModel.tcl');
fprintf(fid,'%s\n','');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                           Define Gravity Loads                          %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Define gravity loads
fprintf(fid,'%s\n','# Define gravity loads');
fprintf(fid,'%s\n','source DefineGravityLoads3DModel.tcl');
fprintf(fid,'%s\n','');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                    Defining Infill Strut Elements                       %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Define infill strut elements
fprintf(fid,'%s\n','# Defining infill strut elements');
fprintf(fid,'%s\n','source DefineInfillStrutsForEigenValueAnalysis3DModel.tcl');
fprintf(fid,'%s\n','');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                       Perform Eigen Value Analysis                      %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Perform Eigen Value Analysis 
fprintf(fid,'%s\n','# Perform eigen value analysis');
fprintf(fid,'%s\n','source EigenValueAnalysis.tcl');
fprintf(fid,'%s\n','');

% Closing and saving tcl file
fclose(fid);

end



