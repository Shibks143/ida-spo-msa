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
function[] = ProcessSingleEQ_Collapse_findSaAtColAndMakeMovie_Frame(bldgID, analysisType, modelName, eqNumber, movieID)

% Say that we are doing an EQ
    isEQOrPO = 1;   % EQ

% Call the function to find the Sa at collapse
    [saAtCollapse, saLevelsForIDAPlotLIST] = FindAndReturnCollapseSaForEQ(analysisType, modelName, eqNumber);
    
% Now call the function to process the data and make the movie
    ProcessSingleEQ_Collapse_makeMovieForSingleSa_Frame(bldgID, analysisType, modelName, eqNumber, saAtCollapse, movieID, isEQOrPO);

% Go back to the Matlab processor folder
    cd(startingFolder);





