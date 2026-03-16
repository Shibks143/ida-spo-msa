%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% This function opens the precalculated spectra file and retrieves the Sa
%   for the two components of an EQ at the period and damping of interest. It
%   then computes the Sa_geoMean and returns it for the pair of motions.
% Note that this assumes that the component numbers have an additional 1 or
%   2 appended to the end of the record #.
%
% Note that the period value and damping value must be found in the file that is opened (i.e.
% this does not interpolate between points):
%   damping ratios: [0.0200, 0.0500, 0.1000, 0.1500, 0.2000, 0.2500, 0.3000]
%   periods = [0.01:0.01:5.00]
%
% This function was checked and works.  See Benchmark notes dated 9-28-05
% for verification.
%
% Curt Haselton
% 9-26-28-05
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function[Sa_abs_psuedo_geoMean] = psb_RetrieveSaGeoMeanValueForAnEQ(eqNum, T, dampRat)

% eqNum=12011; T=0.86; dampRat=0.05; % trial values

% Simply call the function to find the Sa of each component and then
% compute the Sa,geoMean and return it.
    % Component 1:
        eqNum_comp1 = eqNum * 10 + 1;
        saComp_comp1 = psb_RetrieveSaCompValueForAnEQ(eqNum_comp1, T, dampRat);
    % Component 2:
        eqNum_comp2 = eqNum * 10 + 2;
        saComp_comp2 = psb_RetrieveSaCompValueForAnEQ(eqNum_comp2, T, dampRat);
    % Compute GeoMean
        Sa_abs_psuedo_geoMean = (saComp_comp1 * saComp_comp2) ^ 0.5;




