%
% Procedure: PlotMaxCurvOverHeightOfShearWall_ManySaOverIDA.m
% -------------------
%
%   This just calls PlotMaxCurvOverHeightOfShearWall_proc.m for many Sa
%   levels over the IDA and plots the curvature distribution.
%
% Assumptions and Notices: 
%       - NOTICE - must be using 5 intPts per element
%
% Author: Curt Haselton 
% Date Written: 11-15-05
%
% Sources of Code: Some information was taken from Paul Cordovas processing file called "ProcessData.m".
%
% Functions and Procedures called: none
%
% Variable definitions: 
%
% Units: Whatever OpenSees is using - just be consistent!
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Input needed information
    analysisType = '(DesWA_ATC63_v.19dispEle)_(AllVar)_(0.00)_(nonlinearBeamColumn)';
    modelNameForTitle = '(DesWA_ATC63_v.19dispEle)'
    eqNumberLIST = [11011, 11012];
    %eqNumberLIST = [11011, 11012, 11021, 11022, 11031, 11032, 11041, 11042, 11051, 11052, 11061, 11062, 11071, 11072, 11081, 11082, 11091, 11092, 11101, 11102, 11111, 11112, 11121, 11122, 11131, 11132];
    lineWidth = 1;
    markerType = 'b-';
    maxSaToPlot_errorCheck = 49.0;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Loop over all EQs
for eqIndex = 1:length(eqNumberLIST)
    eqNumber = eqNumberLIST(eqIndex);
    
    % For this EQ, go to the folder and open the file that tells which Sa
    % levels to use...
           
    % First change the directory to get into the correct folder for processing
    startFolder = [pwd];
    cd ..;
    cd Output;
    cd(analysisType);

    % Create and open the EQ folder
    eqFolder = sprintf('EQ_%.0f', eqNumber);
    cd(eqFolder);
    
    % Open the file and save the sa list
    load('DATA_collapse_ProcessedIDADataForThisEQ.mat');
    saTOneForRunLIST = saLevelsForIDAPlotPROCLIST;
    
    % Go back to the original folder
    cd(startFolder);

    % Loop over all Sa levels and plot (start at the second entry to miss
    % the leading zero)
    for saIndex = 2:length(saTOneForRunLIST)

        saTOneForRun = saTOneForRunLIST(saIndex);

        % Only plot if the Sa is less than a prescribed value (error check
        % for the processor)
        if(saTOneForRun < maxSaToPlot_errorCheck)
            % Call the procedure to plot the curvature dist...
            figure(eqIndex)
            hold on
            PlotMaxStoryShears_proc(analysisType, eqNumber, saTOneForRun, lineWidth, markerType);

        end
    end
    % Format 
    temp = sprintf('Maximum Wall Element Shears Over IDA (local coord., not shear from leaning col.), Model: %s, EQ: %d', modelNameForTitle, eqNumber);
    title(temp)
    hold off
end









































%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Define the information about the model and analysis run so we know what
% to plot
    %analysisType = '(DesWA_ATC63_v.12)_(AllVar)_(Mean)_(nonlinearBeamColumn)';
    %analysisType = '(DesWA_ATC63_v.12)_(rebarModelToUse)_(1.00)_(nonlinearBeamColumn)';
    %analysisType = '(DesWA_ATC63_v.12)_(rebarModelToUse)_(2.00)_(nonlinearBeamColumn)';
    %analysisType = '(DesWA_ATC63_v.20dispEle)_(AllVar)_(Mean)_(nonlinearBeamColumn)';

    %eqNumberLIST = [11011, 11012, 11021, 11022, 11031, 11032, 11041, 11042, 11051, 11052];  % 
    %eqNumberLIST = [11011, 11012, 11021, 11022, 11031, 11032];  % 
    %eqNumberLIST = [11031];  % 
    %eqNumberLIST = [9991];

    %saTOneForRunLIST = [2.00];
    %saTOneForRunLIST = [0.00];

% Define the plot options
    %lineWidth = 2;
    %markerType = 'bo-'; %'b-';