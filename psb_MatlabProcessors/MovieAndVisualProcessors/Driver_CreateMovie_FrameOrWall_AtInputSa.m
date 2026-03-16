%
% Procedure: Driver_CreateMovie_FrameOrWall_AtInputSa.m
% -------------------
% This driver creates a movie for either a frame of a wall model.
% 
% Variable definitions:
%       - not done
%
% Assumptions and Notices: 
%       NOTICE: The titles on the figures say that we are using
%       Sa(1.0sec.), so I will need to change this for future models).
%
% Author: Curt Haselton 
% Date Written: 12-14-05
%
% Sources of Code: none
%
% Functions and Procedures called: none
%
% Units: kips and inches
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Input needed information for movie
    bldgID = 1000;         % ****** IMPORTANT - As defined in "DefineBuildingInfo.m" (1 for DesA, 1000 for DesWA; see file for other numbers)
    movieID = 12;        % Just a tag to number the movie files (change this to aviod writing errors)
    saDefType = 3;      % Type of Sa definition we want to put on the titles (=1 for Sa,comp, =2 for Sa,geoMean, =3 for Sa,codeDef)
    eqNum = 9991;
    saLevel = 0.00;
    %eqNum = 11011;
    %saLevel = 0.11;
    analysisType = '(DesWA_ATC63_v.26)_(AllVar)_(Mean)_(nonlinearBeamColumn)';
    modelName = 'DesWA_ATC63_v.26';
    %analysisType = '(DesA_Buffalo_v.6)_(AllVar)_(Mean)_(clough)';
    %modelName = 'DesA_Buffalo_v.6';
    %analysisType = '(DesA_Buffalo_v.9noGFrm)_(AllVar)_(Mean)_(clough)';
    %modelName = 'DesA_Buffalo_v.9noGFrm';
    wallFrameID = 1;    % 1 for wall and 2 for frame
    analysisFlag = 1;       % 1 for PO with NLBmCol, 2 PO with lumped plasticity, and 3 for dynamic analysis (this dictates what processor is used)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Load needed information
    buildingInfo = DefineInfoForBuildings;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Process the data

    if(analysisFlag == 1)
        % PO analysis with nlBmCol elements
        ProcSingleRun_Generalized_NlBmCol_PO_ForVisuals(analysisType, saLevel, eqNum);
    elseif(analysisFlag == 2)
        % PO analysis with lumped plasticity elements
        ProcSingleRun_Generalized_LumpPla_PO_ForVisuals(analysisType, saLevel, eqNum);
    elseif(analysisFlag == 3)
        % Dynamic analysis
        ProcSingleRun_Collapse_GeneralFramesAndWalls_ForVisuals(bldgID, analysisType, modelName, saLevel, eqNum);
    else
       error('Invalid value for analysisFlag');
    end
        
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%    
% Make the movie
    if(wallFrameID == 1)
        CreateBuildingMovie_Wall(analysisType, buildingInfo, bldgID, eqNum, saLevel, movieID, saDefType);
    elseif(wallFrameID == 2)
        CreateBuildingMovie_Frame(analysisType, buildingInfo, bldgID, eqNum, saLevel, movieID, saDefType);
    else
       error('Invalid value for wallFrameID');
    end

    
    
    
    
    
    