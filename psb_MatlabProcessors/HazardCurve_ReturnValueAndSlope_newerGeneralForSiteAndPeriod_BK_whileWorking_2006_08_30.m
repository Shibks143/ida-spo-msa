%
% Procedure: HazardCurve_ReturnValueAndSlope_newerGeneralForSiteAndPeriod.m
% -------------------
% This procedure returns the hazard curve value and slope for the LA Bulk
% mail site for Sa at T = 1.0 seconds.  It uses the PCHIP function to
% interpolate the hazard curve within the range of the hazard points that
% Christine provided.  For Sa levels higher than what she gave (Sa > 2.0g),
% the PCHIP extrapolation is WRONG so I am using the power fit.  Please see
% hand notes on 3-24-05 for all of this.
%
% This is now generalized for many sites and many periods.
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
%
% Variable definitions:
%       siteNum = 1 - Benchmark site (haazard data from Goulet and Stewart for Benchmark study)
%
%
%
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [hazardValue, hazardSlope] = HazardCurve_ReturnValueAndSlope_newerGeneralForSiteAndPeriod(saLevel, siteNum, period)

%%%%%%%%%%%%%%%% Input %%%%%%%%%%%%%%%%%%%%%%%
% Define the ratio of Sa to use to perturb the value of Sa to find the
% slope of the hazard curve.  Note that I perturbe the Sa value to the
% higher Sa level side to find the slope.
ratioOfSaForPertubation = 0.00001;

    %%%%%%%%%%%%%%%% SITE HAZARD INPUT %%%%%%%%%%%%%%%%%%%%%%%
    if(siteNum == 1)
        
        % SITE 1 is the Benchmark site (Goulet abd Stewart) used
        % in the Benchmark study (2007 PEER report and 2006 EESD paper)

        % Define the hazard curve (this is from data from Christine in the LA bulk
        % mail site GM folder; FILE: "HazardCurvesForJudith_CBHaltered_2006_08_26_forArchetypeWork.xls")
        hazard_SaTOne = [0.0001, 0.01, 0.05, 0.1, 0.2, 0.3, 0.4, 0.5, 0.6, 0.7, 0.8, 0.9, 1, 1.5, 2];           % Sa values for the hazard points; this is associated with the rows of the hazard table
        hazard_Periods = [0.0, 0.1,	0.13, 0.17, 0.2, 0.23, 0.27, 0.3, 0.4, 0.5, 0.75, 1.0, 1.25, 1.5, 2.0];     % Periods for the hazard points; this is associated with the columns of the hazard table
        hazard_Lambda_allSaTOneAllPeriods = [   4.03300E+00	4.03300E+00	4.03300E+00	4.03300E+00	4.03300E+00	4.03300E+00	4.03300E+00	4.03300E+00	4.03300E+00	4.03300E+00	4.03300E+00	4.03300E+00	4.03300E+00	4.03300E+00	4.03300E+00
                                                1.90460E+00	2.47970E+00	2.57300E+00	2.65330E+00	2.69920E+00	2.70790E+00	2.71370E+00	2.71750E+00	2.50400E+00	2.36740E+00	1.92920E+00	1.58920E+00	1.34143E+00	1.16323E+00	8.95480E-01
                                                4.12480E-01	7.76200E-01	8.57360E-01	9.26900E-01	9.58870E-01	9.58880E-01	9.50980E-01	9.44420E-01	8.04880E-01	7.12800E-01	5.04590E-01	3.73330E-01	2.91490E-01	2.37780E-01	1.59100E-01
                                                1.30310E-01	3.35090E-01	3.85710E-01	4.32130E-01	4.53620E-01	4.54160E-01	4.49810E-01	4.46020E-01	3.68450E-01	3.17990E-01	2.10780E-01	1.46020E-01	1.07200E-01	8.28420E-02	4.84610E-02
                                                2.58170E-02	1.03464E-01	1.26463E-01	1.49687E-01	1.61070E-01	1.61760E-01	1.60350E-01	1.58960E-01	1.25468E-01	1.05030E-01	6.32520E-02	3.95920E-02	2.63070E-02	1.86660E-02	8.88870E-03
                                                7.32480E-03	4.27040E-02	5.44270E-02	6.69230E-02	7.32910E-02	7.36650E-02	7.29770E-02	7.23290E-02	5.47850E-02	4.49760E-02	2.50660E-02	1.44600E-02	8.86620E-03	5.89020E-03	2.39178E-03
                                                2.41900E-03	2.04670E-02	2.70470E-02	3.42990E-02	3.80800E-02	3.82210E-02	3.77730E-02	3.73830E-02	2.72570E-02	2.20180E-02	1.14623E-02	6.16390E-03	3.52970E-03	2.22107E-03	7.91720E-04
                                                8.80410E-04	1.06963E-02	1.46497E-02	1.91350E-02	2.15040E-02	2.15420E-02	2.12280E-02	2.09660E-02	1.47664E-02	1.17447E-02	5.74310E-03	2.90180E-03	1.56744E-03	9.43050E-04	2.96704E-04
                                                3.41970E-04	5.91420E-03	8.39220E-03	1.12923E-02	1.28486E-02	1.28467E-02	1.26259E-02	1.24475E-02	8.49660E-03	6.65360E-03	3.07030E-03	1.46917E-03	7.53860E-04	4.34518E-04	1.19957E-04
                                                1.38386E-04	3.40280E-03	5.00150E-03	6.93460E-03	7.99070E-03	7.98230E-03	7.82370E-03	7.69960E-03	5.11580E-03	3.94080E-03	1.72620E-03	7.86600E-04	3.84330E-04	2.12479E-04	5.03571E-05
                                                5.73300E-05	2.02068E-03	3.07260E-03	4.38710E-03	5.12090E-03	5.11350E-03	5.00210E-03	4.91500E-03	3.19290E-03	2.41640E-03	1.01063E-03	4.40660E-04	2.05280E-04	1.08384E-04	2.15864E-05
                                                2.39449E-05	1.23151E-03	1.93320E-03	2.84300E-03	3.36090E-03	3.35470E-03	3.27610E-03	3.21520E-03	2.05071E-03	1.52513E-03	6.12060E-04	2.55755E-04	1.13343E-04	5.68594E-05	9.09497E-06
                                                1.08002E-05	7.65540E-04	1.24123E-03	1.87780E-03	2.24960E-03	2.24620E-03	2.19060E-03	2.14690E-03	1.34965E-03	9.87250E-04	3.80940E-04	1.52872E-04	6.44282E-05	3.03239E-05	3.65314E-06
                                                7.63576E-07	7.93350E-05	1.59231E-04	2.85160E-04	3.67370E-04	3.70810E-04	3.63340E-04	3.56500E-04	2.14773E-04	1.46458E-04	4.71460E-05	1.46232E-05	4.36047E-06	1.46992E-06	1.01780E-07
                                                1.53900E-07	8.37570E-06	2.11629E-05	4.87570E-05	6.97500E-05	7.24340E-05	7.25500E-05	7.20540E-05	4.27061E-05	2.72566E-05	7.41953E-06	2.13260E-06	6.52531E-07	2.21290E-07	1.17500E-08];

        % Define the hazard curve fit to be used for Sa > 2.0g, where PCHIp can't
        % extrapolate correctly.  This is from a fit to the last 5 hazard
        % points (0.8g - 2.0g).  This list contains a value for each
        % period.
            ko_allPeriods = [0.000012036	0.00065842	0.0010965	0.0016963	0.0020501	0.0020546	0.0020107	0.00197467	0.00124702	0.0009096	0.0003475	0.0001369	0.00005645	0.00002624	3.5079E-06];
            k_allPeriods = [-6.46203	-5.950375	-5.396103	-4.887977	-4.67137	-4.63057	-4.606618	-4.596197	-4.69598	-4.88043	-5.34751	-5.83544	-6.36415	-6.91005	-8.34768];

    else
        error('ERROR: Invalid siteNum!') 
    end
    
    
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%   
%%%%%%%%%%%% Site Hazard Calculations (interpolation/extrapolation, etc.) %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
% Linearly interpolate ko and k for period; for T > 2.0 seconds, just use ko and k for T = 2 seconds.
    numPeriods = length(ko_allPeriods);
    
    if(period > max(hazard_Periods))
       % We are outside the period range of the hazard analysis (0-2 seconds probably), so just use the ko and k values at 2 seconds.  This 
       %    is only used for approximation when Sa>2g and T is outside
       %    hazard analysis range (usually > 2 sec), so this approxmation
       %    is not very important.
       ko = ko_allPeriods(numPeriods);
       k = k_allPeriods(numPeriods);
    else
        % If we get here, we are for a period within the range of the
        % hazard analysis.  So, just do linear interpolation.
            % Loop to find the values above and below the period of
            % interest.
            pastPeriodInLoop = -1;
            for periodIndex = 1:numPeriods
                currentPeriodInLoop = hazard_Periods(periodIndex);
                if(currentPeriodInLoop > period)
                   break; 
                end
                pastPeriodInLoop = currentPeriodInLoop;
            end
        
        
            
            
            
        
        
    end
        
        
        
        
        
        
        
            % I NEED TO START AGAIN HERE.  I NEED TO EXTRAPOLATE FOR
            % PERIODS LAERGER THAN 2 SECONDS.  I THEN NEED TO INTERPOLATE
            % THE VALUES TO GET VALUES FOR EACH PERIOD.  AFTER I
            % INTERPOLATE TO GET VALUES FOR EACH PERIOD, THEN THE REST OF
            % THE FILE SHOULD WORK AS LONG AS THE VARIABLES ARE NAMED
            % THE SAME AS BEFORE.  NOTE: PUT THE INTERPOLATION OUTSIDE OF
            % THE AREA FOR A SPECIFIC SITE.




%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%   
%%%%%%%%%%%% General Hazard Curve Calculations %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
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


