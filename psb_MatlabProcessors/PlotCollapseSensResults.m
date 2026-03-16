%
% Procedure: PlotCollapseSensResults.m
% -------------------
% This procedure plots the collapse results for multiple values of a variable.  Note that when you use the variable value of 1.0, then the procedure plots the mean 
%   analysis results in this place, so this is assuming that the mean of the variable is 1.0 (as it is with most of the factors that I am using).  This plots the 
%   results in Non-Ln and Ln space.
% 
% Assumptions and Notices: 
%           - This must be run with the current directory started in the "MatlabProcessing" folder.
%
% Author: Curt Haselton 
% Date Written: 2-7-05
%
% Sources of Code: none
%
% Functions and Procedures called: none
%
% Variable definitions (all variables are defined at each stripe level, so they will be different for different Sa values): 
%
% Units: Whatever OpenSees is using - just be consistent!
%
% -------------------

% Input what you want to plot
    variableName = 'postCapStiffRatF';      % Name of variable, string
    variableValueLIST = [0.13, 1.00, 1.25, 1.70, 1.87, 2.50, 4.00];     % List of variable values; MUST have two decimal places; when 1.00 is used, the mean analysis results will be plotted.
    eqNumberLIST = [941002, 941012, 941022, 941032, 941042, 941051, 941062, 941072, 941082, 941092];    % Bin 4A - only those that control collapse for DesID1_v.60_clough (noGFrm) - see notes on 1-31-05
    
% Plotting options
    markerTypePoint = 'bo';
    markerTypeLine = 'b-';
    plotMedianLine = 1;     % Plot the line == 1, no line == 0.  The line is plotted in the order in the variableValueLIST.
    plotIndivPoints = 1;    % Plot points for each EQ == 1, no points == 0

    
    
    
%%%%%%%%%%% Retreiving Data and Plotting %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%    
% Loop for all the variable values and EQs and retrieve the results, then store these results in a matrix.

% Loop for all variable values
for variableIndex = 1:length(variableValueLIST)
    variableVal = variableValueLIST(variableIndex);
    
    % If the variable value is 1.00, then change the settings to retireve the results of the mean analysis, otherwise set it up to get the results for the correct pertubation.
    % START AGAIN HERE
    
    
    
    
    
    
    for eqNum = 1:length(eqNumberLIST)
    
    
    
    
    
    
        
        
        
        
        
    end
end
    
    
    
    
    
    
    
    
    
    
    
    
    
































