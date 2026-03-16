% Procedure: FindAndReturnCollapseSaForEQ_inPrimaryFolder.m
% -------------------
%
% This is just a copied function from the MovieProcessing folder.
%
% Assumptions and Notices: 
%   - none
%
% Author: Curt Haselton 
% Date Written: 12-07-05; modified 7-26-06
%
% Sources of Code: Some information was taken from Paul Cordovas processing file called "ProcessData.m".
%
% Functions and Procedures called: none
%
% Variable definitions: 
%
% Units: Whatever OpenSees is using - just be consistent!
%
% -------------------
function[saAtCollapse, saLevelsForIDAPlotLIST] = FindAndReturnCollapseSaForEQ_inPrimaryFolder(analysisType, modelName, eqNumber)

% Go to the output folder
    startingFolder = [pwd]; % Save the path to the starting folder
    cd ..;
    cd Output;
    analysisTypeFolder = sprintf('%s', analysisType)
    cd(analysisTypeFolder);
    eqFolder = sprintf('EQ_%.0f', eqNumber);
    cd(eqFolder);

% Open the processed IDA file that contains the Sa levels for the IDA
% analysis.  The file that I am opening here is that one created when the
% collapse results were processed (NOT the file made when the IDAs were plotted).
    load('DATA_collapseIDAPlotDataForThisEQ.mat', 'saLevelsForIDAPlotLIST');
    
% Use the last entry in the "saLevelsForIDAPlotLIST" as the Sa at collapse.
%  Process only this Sa level.  However, due to processing, sometimes this
%  is over 50, so if it is then use the next lower Sa level.
    index = 0;
    while(1==1)
        saAtCollapse = saLevelsForIDAPlotLIST(length(saLevelsForIDAPlotLIST) - index);
        if(saAtCollapse < 50.0) 
            break;
        end
        index = index + 1;
    end
    saAtCollapse;
    
% Go to the starting folder
    cd(startingFolder);




