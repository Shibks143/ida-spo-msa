%
% Procedure: PlotLogNormalCDF.m
% -------------------
% This procedure simply plots the lognormal CDF.
% 
% Assumptions and Notices: 
%           - This must be run with the current directory started in the "MatlabProcessing" folder.
%
% Author: Curt Haselton 
% Date Written: 3-24-05
%
% Sources of Code: none
%
% Functions and Procedures called: none
%
% Variable definitions: not done
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%5
function [] = PlotLogNormalCDF(meanLn, sigmaLn, minValue, maxValue, markerType)

% Make a list of points for which to plot the lognormal CDF
numPoints = 1000.0;
lineWidth = 4;
incrSize = (maxValue - minValue) / numPoints;
valueLIST = [minValue:incrSize:maxValue];

% Initialize
logNormalValueLIST = zeros(1, numPoints);

% Compute the lognormal CDF values for all of the points
for i = 1:length(valueLIST)
    currentValue = valueLIST(i);
    logNormalValueLIST(i) = logncdf(currentValue, meanLn, sigmaLn);
end

% Plot the results
plot(valueLIST, logNormalValueLIST, markerType, 'lineWidth', lineWidth);







