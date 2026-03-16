%
% Procedure: Driver_RetrieveSa2in50ForSitesAndPeriods.m
% -------------------
% This procedure loops over a list of site indices and periods and returns
% the Sa value for a given hazard level.  This is commonly used to get the
% 2% in 50 year hazard, but you can use it for any hazard.
%
% Author: Curt Haselton 
% Date written: 8-30-06
%
% Sources of Code: none
%
% Functions and Procedures called: none
%
% Variable definitions:
%       siteNum = 1 - Benchmark site (haazard data from Goulet and Stewart for Benchmark study)
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clear
clc

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Input information

    % Define the hazard level that you want the Sa values for
    targetHazardLevel = 0.0004; % 2% in 50 year motion

    % Define paralalel lists of siteNumber and period
        % Period list
            % For Brian's buildings as of 8-30-06 (need to add 1-story buildings, 1 2-story, and 4 more weak story designs).
            %periodLIST = [0.63	0.56	0.63	0.86	2.14	2.00	1.92	2.09	1.12	0.94	1.16	2.01	1.80	1.11	2.36	1.71	1.80	1.57	1.71	2.13	2.63];
            % For Jason's sensitivity designs
            %periodLIST = [0.85	0.97	2.64	1.59	2.27	0.74	2.40	2.20	1.99	0.91	1.97	1.99	1.99	1.99	1.97	1.97	0.87	1.83	0.77	0.85	0.86	0.85	0.74	0.87	0.79	1.97	0.54	1.15	1.50	2.84	1.90	1.84	2.00	2.01	2.01];
            % For new ASCE7-05 high seismic designs
            periodLIST = [2.40 2.18 2.24 3.77 3.45];
        % Site - use Benchmark site for all (site 1)
        siteNumLIST = ones(length(periodLIST)); % Use site number 1 for all periods
        
    % Input numerical options
        startSaLevel = 0.11;        % Algorithm starts here 
        startStepSize = 0.1;        % Algorithm starts with this step size
        refinedStepSize = 0.01;     % Algorithm uses this as second step size to find result
        
      
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Do calculations and return a list of Sa values
    % Loop for all periods/sites
    for index = 1:length(periodLIST)
        currentPeriod = periodLIST(index)
        currentSiteNum = siteNumLIST(index);        
        
        currentSaLevel = startSaLevel;
        % Loop and increase Sa level until we get past the hazard of interest
        flag = 0;
        while(flag == 0)
            % Compute the hazard value
            [currentHazardValue, hazardSlope] = HazardCurve_ReturnValueAndSlope_newerGeneralForSiteAndPeriod(currentSaLevel, currentSiteNum, currentPeriod);

            % If the hazard value is smaller than the target, then stop
            % this loop
            if(currentHazardValue < targetHazardLevel)
                break
            end

            % Incement Sa value
            currentSaLevel = currentSaLevel + startStepSize;
        end
        
        % Loop again with a smaller step size.  Start at the last Sa level
        % just before we crossed the traget hazard level
        currentSaLevel = currentSaLevel - startStepSize;
        
        while(flag == 0)
            % Compute the hazard value
            [currentHazardValue, hazardSlope] = HazardCurve_ReturnValueAndSlope_newerGeneralForSiteAndPeriod(currentSaLevel, currentSiteNum, currentPeriod);

            % If the hazard value is smaller than the target, then stop
            % this loop
            if(currentHazardValue < targetHazardLevel)
                break
            end

            % Incement Sa value
            currentSaLevel = currentSaLevel + refinedStepSize;
        end
        
        % Save the Sa value in a list of results
        currentSaAtTargetHazard = currentSaLevel - (refinedStepSize / 2.0)
        results_SaAtTargetHazard(index) = currentSaAtTargetHazard;

    end

    results_SaAtTargetHazard
