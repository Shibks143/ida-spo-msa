%
% Procedure: HazardCurve_ReturnValueAndSlope.m
% -------------------
% This procedure returns the hazard curve value and slope for the LA Bulk
% mail site for Sa at T = 1.0 seconds.  It uses the PCHIP function to
% interpolate the hazard curve within the range of the hazard points that
% Christine provided.  For Sa levels higher than what she gave (Sa > 2.0g),
% the PCHIP extrapolation is WRONG so I am using the power fit.  Please see
% hand notes on 3-24-05 for all of this.

% Assumptions and Notices: 
%           - This must be run with the current directory started in the "MatlabProcessing" folder.
%
% Author: Curt Haselton 
% Last updated: 8-26-06
% Date written: 3-24-05
%
% Sources of Code: none
%
% Functions and Procedures called: none
%
% Variable definitions:
%
%
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [hazardValue, hazardSlope] = HazardCurve_ReturnValueAndSlope(saLevel)

%%%%%%%%%%%%%%%% Input %%%%%%%%%%%%%%%%%%%%%%%
% Define the ratio of Sa to use to perturb the value of Sa to find the
% slope of the hazard curve.  Note that I perturbe the Sa value to the
% higher Sa level side to find the slope.
ratioOfSaForPertubation = 0.00001;

% Define the hazard curve (this is from data from Christine in the LA bulk
% mail site GM folder)
    hazard_SaTOne = [0.0001, 0.01, 0.05, 0.1, 0.2, 0.3, 0.4,...
        0.5, 0.6, 0.7, 0.8, 0.9, 1, 1.5, 2];

    hazard_LambdaSaTOne = [4.03E+00, 1.59E+00, 3.73E-01, 1.46E-01,...
        3.96E-02, 1.45E-02, 6.16E-03, 2.90E-03, 1.47E-03, 7.87E-04,...
        4.41E-04, 2.56E-04, 1.53E-04, 1.46E-05, 2.13E-06];

% Define the hazard curve fit to be used for Sa > 2.0g, where PCHIp can't
% extrapolate correctly - from fit on pg. 2 of notes on 3-24-05.
    ko = 0.0001279437;
    k = -5.65937;
        
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%    
%%%%%%%%%%%% Calculations %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
% If the Sa level is in the range of the input hazard data, then use the
% PCHIP function.  If not, then use the power fit.
if(saLevel < max(hazard_SaTOne))
    
    % Use PCHIP to evaluate the hazard curve value at the desired Sa level
    hazardValue = pchip(hazard_SaTOne, hazard_LambdaSaTOne, saLevel);

    % Perturb the saLevel to find the slope of the hazard curve...
    saLevel_perturbed = saLevel * (1.0 + ratioOfSaForPertubation);
    hazardValue_perturbed = pchip(hazard_SaTOne, hazard_LambdaSaTOne, saLevel_perturbed);
    hazardSlope = (hazardValue_perturbed - hazardValue) / (saLevel_perturbed - saLevel);

else
    
    % Use the fitted power function to evaluate the hazard value and the
    % slope of the hazard curve (from notes on 3-24-05 - pg. 2-3)
    hazardValue = ko * (saLevel ^ k);
    hazardSlope = k * ko * (saLevel ^ (k - 1.0));

end


