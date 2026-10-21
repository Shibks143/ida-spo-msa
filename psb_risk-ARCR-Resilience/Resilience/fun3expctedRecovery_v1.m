function [timeArray, expectedHousingFunction, meanExpectedHousingFunction, meanHousingCapacityMatrix] = fun3expctedRecovery_v1(meanSa, sigmaLn, IMvalList, numStories)

% buildingID = '1610v01';
% switch buildingID
%     case '1610v01'
%         meanSa = [0.11, 0.22, 0.33, 0.38, 0.52];
%         sigmaLn = [0.37, 0.43, 0.49, 0.48, 0.54];
% end
% plotStyle = {'r-', 'b--', 'g-.', 'k:', 'm-', 'y--'};

% minValue = 0; maxValue = 0.8;

% [~, meanHousingCapacityMatrix_LS0] = fun2housingCapacity_v1(0, 0);
[~, meanHousingCapacityMatrix_LS0] = fun2housingCapacity_v1(0, numStories); % assigned to the matrix later on.
meanHousingCapacityMatrix = zeros(6, length(meanHousingCapacityMatrix_LS0)); % 6 recovery paths. Fig. 5 (Burton et al., 2015).

for LS = 1:5 % 
%     figure(101)
%     PlotLogNormalCDF_current(log(meanSa(LS)), sigmaLn(LS), minValue, maxValue, plotStyle{LS}); hold on; grid on;
% 
%     figure(102)
    [timeArray, meanHousingCapacity] = fun2housingCapacity_v1(LS, numStories); 
%     plot(timeArray, meanHousingCapacity, plotStyle{LS}, 'LineWidth', 1.5); hold on; grid on;

%     timeArrayMatrix(LS, :) = timeArray;
    meanHousingCapacityMatrix(LS + 1, :) = meanHousingCapacity;
end


% Find Differential probabilities of building being (not exceeding) in a limit state
% Multiply with the respective housing capacity curves.
% This gives Housing Recovery Function as a function of time, t.

% Fix an IM value, find E[q(t)|IM] as a function of time
% find similar curves for various values of IM, without having to run the
% fun2housingCapacity function again.
% IMval = 0.3;

PoE = zeros(1, 5); % 5 number of Limit states

for j = 1:length(IMvalList)
    IMval = IMvalList(j);
    
    i = 1:5; PoE(i) = logncdf(IMval, log(meanSa(i)), sigmaLn(i));
    
    % probability that the bldg is in he ith Limit state for a given IMval
    ProbLS(1) = 1 - PoE(1);
    ProbLS(2) = PoE(1) - PoE(2); ProbLS(3) = PoE(2) - PoE(3);
    ProbLS(4) = PoE(3) - PoE(4); ProbLS(5) = PoE(4) - PoE(5);
    ProbLS(6) = PoE(5);
    
    % PoE = [1, PoE, 0];
    % ProbLS = -diff(PoE);
    
    meanHousingCapacityMatrix(1, :) = meanHousingCapacityMatrix_LS0';
    % meanHousingCapacityMatrix now includes the LS0 i.e. full occupancy state as well.
    
    % expectedHousingFunction = ProbLS * meanHousingCapacityMatrix_LS0';
    
    % ProbLS is 1 by 6 in size
    % meanHousingCapacityMatrix_LS0 is 6 by 1e3 in size
    % expectedHousingFunction should be 1 by 1e3 in size
    expectedHousingFunction(j, :) = ProbLS * meanHousingCapacityMatrix;
end
    meanExpectedHousingFunction = mean(expectedHousingFunction, 1);

% figure(103)
% plot(timeArray, meanExpectedHousingFunction, 'k--', 'LineWidth', 1.5); hold on;
