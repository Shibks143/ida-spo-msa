% Procedure: ProcessSingleEQ_Collapse_makeMovieForSaNearCollapse.m
% -------------------
%
% This procedure finds the Sa at collapse (the Sa level that is the last
%   one plotted in the IDA, which I think should be the Sa level that does
%   cause collapse), processes this data and saves the TH's, then creates
%   and saves a movie file of the response.
%
% Assumptions and Notices: 
%   - none
%
% Author: Curt Haselton 
% Date Written: 12-03-05
%
% Sources of Code: Some information was taken from Paul Cordovas processing file called "ProcessData.m".
%
% Functions and Procedures called: none
%
% Variable definitions: 
%
%
% Units: Whatever OpenSees is using - just be consistent!
%
% -------------------
function[] = ProcessSingleEQ_Collapse_makeMovieForSingleSa_Frame(bldgID, analysisType, modelName, eqNumber, saLevel, movieID, isEQOrPO)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Save this folder path to be sure we get back here
    startingFolder = [pwd]; % Save the path to the starting folder

% Now process the analysis at the Sa level at collapse.
    if (isEQOrPO == 1)
        % Process for an EQ
        ProcSingleRun_Collapse_GeneralFramesAndWalls_ForVisuals(bldgID, analysisType, modelName, saLevel, eqNumber);    % For EQ collapse analysis
    else
        % Process for a PO
        ProcSingleRun_Generalized_LumpPla_PO_ForVisuals(analysisType, saTOneForRun, eqNumber);                          % For PO analysis
    end
    
% Now go into the moview folder and create the movie for this EQ and Sa
% level
    buildingInfo = DefineInfoForBuildings;
    CreateBuildingMovie_Frame(analysisType, buildingInfo, bldgID, eqNumber, saLevel, movieID);

% Go back to the Matlab processor folder
    cd(startingFolder);





