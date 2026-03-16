%
% Procedure: ComputeMAFofCollapse_newerGeneralForSiteAndPeriod.m
% -------------------
% This procedure computes the MAF of collapse by integrating the hazard
% curve with the collapse CDF.  The collapse CDF can be either normal or
% lognormal.  This function can be altered to do other MAF
% calculations other than collapse.
%
% This is the same as the older file ("ComputeMAFofCollapse.m") except this
% has been generalized to work for many sites and many periods.  NOTE that
% the period and the collapse results (Sa at the same period) must be consistent.
% 
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
%       [hazardValue, hazardSlope] = HazardCurve_ReturnValueAndSlope(saLevel) - This 
%           is used to compute the hazard value (not used) and the slope of the 
%           hazard curve (used) each integration point.
%
%
% Variable definitions:
%       mean - mean collapse capacity for normal and meanLn for lognormal.
%                       Note that this does not matter when using distTypeForCDF = 'empr'.
%       sigma - stDev collapse capacity for normal and stDevLn for
%                       lognormal.  Note that this does not matter when using
%                       distTypeForCDF = 'empr'.
%       distTypeForCDF  - 'norm' for normal
%                       - 'lnrm' for lognormal
%                       - 'empr' for empirical CDF (need to pass this in as input)
%       minSa, maxSa, numIntSteps - this is the Sa range and numSteps for
%                       the numerical integration
%       empiricalCDF - this is the empirical CDF - this is a vector of
%                      collapse Sa levels to be used as the empirical CDF.
%                      This does not need to be sorted but can be sorted.
%                      If you do not use, distTypeForCDF = 'empr', then
%                      just put some junk value in for this variable
%                      because it is onlu used when distTypeForCDF =
%                      'empr'.
%
%       collapseCDF_Star_timesDSa - this is the average value over the step of the
%                       collapse capacity CDF, multiplied by the
%       
%       MAFofColDissag - this is a matrix showing the realtive
%                       contributions of different Sa levels to the MAF of collapse.  This
%                       is a 2xnumIntSteps matrix where the first row in the Sa level for
%                       the points and the third row in the "PDF" of contribution to the
%                       MAF of collapse.  The "PDF" values are simply the term in the
%                       numerical integration at the value of Sa multiplied by the saIncr
%                       and normalized by the MAFofCollapse (so that the area under the
%                       curve will be 1.0).  Note that the secods row is
%                       just there from computation and is the same as the
%                       3rd ros before it was normalized by MAFofCollapse.
% 
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [MAFofCollapse, MAFofColDissag] = ComputeMAFofCollapse_newerGeneralForSiteAndPeriod(mean, sigma, distTypeForCDF, minSa, maxSa, numIntSteps, empiricalCDF, siteNum, period)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Numerical integration - from ME 345 course notes
    % Follow HO # 9 - pg. 32 to do numerical integration
        MAFofCollapse = 0;
        MAFofColDissag = zeros(3, (numIntSteps + 1));
        stepNum = 1;
        % Step through Sa values and add terms to the sum
        saIncr = (maxSa - minSa) / numIntSteps;
        lastStepSa = minSa;
        for currentSa = (minSa + saIncr):saIncr:maxSa
            currentSa;
            
            % Compute the collapseCDF values for this step Sa and the last
            % step Sa.  Use normal or lognormal based on the input.
            if(distTypeForCDF == 'norm')
                %%disp('Using NORMAL CDF for MAF of collapse calculation')
                collapseCDF_current = normcdf(currentSa, mean, sigma);
                collapseCDF_lastStep = normcdf(lastStepSa, mean, sigma);
            elseif (distTypeForCDF == 'lnrm')
                %%disp('Using LOGNORMAL CDF for MAF of collapse calculation')
                collapseCDF_current = logncdf(currentSa, mean, sigma);  % Note that the input for these really need to be meanLn and sigmaLn!
                collapseCDF_lastStep = logncdf(lastStepSa, mean, sigma);  % Note that the input for these really need to be meanLn and sigmaLn!
            elseif (distTypeForCDF == 'empr')
                %%disp('Using EMPIRICAL CDF for MAF of collapse calculation')
                % For current Sa loop through and find how many SaCollapse
                %   values are less than the currentSa
                    sum = 0;
                    numCollapsePoints = length(empiricalCDF);
                    for i = 1:numCollapsePoints
                        currentCollapseSa = empiricalCDF(i);
                        if(currentCollapseSa < currentSa)
                            sum = sum + 1.0;
                        end
                    end
                        collapseCDF_current = sum / numCollapsePoints;
                % For last-step Sa loop through and find how many SaCollapse
                %   values are less than the lastStepSa
                    sum = 0;
                    numCollapsePoints = length(empiricalCDF);
                    for i = 1:numCollapsePoints
                        currentCollapseSa = empiricalCDF(i);
                        if(currentCollapseSa < lastStepSa)
                            sum = sum + 1.0;
                        end
                    end
                        collapseCDF_lastStep = sum / numCollapsePoints;
            else
               error('The input for distTypeForCDF must be NORM for normal dist or LNRM for lognormal!');
            end
            
            % Compute the average collapseCDF value over the step
            collapseCDF_Star_timesDSa = 0.5 * (collapseCDF_current + collapseCDF_lastStep) * (currentSa - lastStepSa);
            % Compute the centroid of the block for the step
                % If the sum of collapseCDF_current and
                % collapseCDF_lastStep is zero, we will get a
                % divide-by-zero error, so in this case, just use half way
                % between the last step and current step
                if((collapseCDF_current + collapseCDF_lastStep) < 0.000001)
                    saStar = currentSa - 0.50 * (currentSa - lastStepSa);
                else
                    saStar = currentSa - (((currentSa - lastStepSa) * (2.0 * collapseCDF_lastStep + collapseCDF_current)) / (3.0 * (collapseCDF_current + collapseCDF_lastStep)));
                end
            % Compute the increment of MAFofCollapse (i.e. the term in the sum for
            % this step)
                % Get the hazard slope at saStar...
                % OLD before making a hazard file general to site and period - [hazardValue_atSaStar, hazardSlope_atSaStar] = HazardCurve_ReturnValueAndSlope(saStar);
                % New hazard file that is allows for pultiple period values
                % and multiple sites.
                [hazardValue_atSaStar, hazardSlope_atSaStar] = HazardCurve_ReturnValueAndSlope_newerGeneralForSiteAndPeriod(saStar, siteNum, period);
                % Compute the term for the MAF of collapse
                MAFofCollapse_Incr = collapseCDF_Star_timesDSa * abs(hazardSlope_atSaStar);
            % Add the term to the sum
            MAFofCollapse = MAFofCollapse + MAFofCollapse_Incr;
            
            % Add term to the "PDF" fo collapse matrix
            MAFofColDissag(1, stepNum) = currentSa;
            MAFofColDissag(2, stepNum) = MAFofCollapse_Incr / saIncr;

            % Update history variable
            lastStepSa = currentSa;
            stepNum = stepNum + 1;
        end
        
        % Normalize the MAFofColDissag value by the MAFofCollapse to get
        % the third row.
            MAFofColDissag(3, :) = MAFofColDissag(2, :) / MAFofCollapse;

