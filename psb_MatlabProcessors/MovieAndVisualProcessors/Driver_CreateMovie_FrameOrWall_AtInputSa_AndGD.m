%
% Procedure: Driver_CreateMovie_FrameOrWall_AtInputSa_AndGD.m
% -------------------
% This driver creates a movie for either a frame of a wall model; with
% ground displacement
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
    bldgID = 1009; %1000;      % As defined in "DefineBuildingInfo.m"
    movieID = 1;        % Just a tag to number the movie files (change this to aviod writing errors)
    saDefType = 2;      % Type of Sa definition we want to put on the titles (=1 for Sa,comp, =2 for Sa,geoMean, =3 for Sa,codeDef)
    %eqNum = 9991;
    %saLevel = 0.00;
    eqNum = 120411; %11281; %11051
    saLevel = 2.19; %1.02; %1.99; %1.72;
    %analysisType = '(DesWA_ATC63_v.26)_(AllVar)_(0.00)_(nonlinearBeamColumn)';
    %modelName = 'DesWA_ATC63_v.26';
    %analysisType = '(DesA_Buffalo_v.9noGFrm)_(AllVar)_(0.00)_(clough)';
    %modelName = 'DesA_Buffalo_v.9noGFrm';
    %analysisType = '(DesA_Buffalo_v.9noGFrm_grndDisp_Corot)_(AllVar)_(0.00)_(clough)';
    %modelName = 'DesA_Buffalo_v.9noGFrm_grndDisp_Corot';
    %analysisType = '(Arch_8story_ID1012_v58)_(AllVar)_(0.00)_(clough)';
    %modelName = 'Arch_8story_ID1012_v58';
    analysisType = '(Arch_4story_ID1009_v10)_(AllVar)_(0.00)_(clough)';
    modelName = 'Arch_4story_ID1009_v10';
    wallFrameID = 2;    % 1 for wall and 2 for frame

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Load needed information
    buildingInfo = DefineInfoForBuildings;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Process the data
    ProcSingleRun_Collapse_GeneralFramesAndWalls_ForVisualsGD(analysisType, modelName, saLevel, eqNum);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%    
% Make the movie
    if(wallFrameID == 1)
        CreateBuildingMovie_Wall_AndGD(analysisType, buildingInfo, bldgID, eqNum, saLevel, movieID, saDefType);
    elseif(wallFrameID == 2)
        CreateBuildingMovie_Frame_AndGD(analysisType, buildingInfo, bldgID, eqNum, saLevel, movieID, saDefType);
    else
       error('Invalid value for wallFrameID');
    end

    
    
    
    
    
    