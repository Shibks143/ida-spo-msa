%
% Procedure: ProcessStripeStatisticsForCollapseRuns_proc.m
% -------------------
% This procedure computes the stripe statistics for a list of Sa levels.
%   This is set up to work with the results of collapse analyses.  I am trying to make this extendable for various ways of defining Sa, so
%   we may not have results for the specific Sa value we are looking at; therefore, this interpolates
%   the EDPs between the two adjacent Sa values.
% 
% Assumptions and Notices: 
%   - This assumes that the results were proceessed and the collapse IDAs
%   were plotted (this opens those files).
%
% Author: Curt Haselton 
% Date Written: 6-29-06
%
% Sources of Code: none
%
% Functions and Procedures called: none
%
% Variable definitions (all variables are defined at each stripe level, so they will be different for different Sa values): 
%
%       eqIndex - this is a value that is 1:numEQ's, so to get the actual EQ num, we need to look this up in the eqNumberToRunLIST
%
%       eqNumberLIST_forStripes(eqIndex) - a list of the eqNumbers at the stripes - these are the numbers that are used in OpenSees (i.e. the .tcl input EQ numbers)
%
%       IDR_max{storyNum} - Absolute value of maximum story drift ratio for all EQ's (story num starts at 1 for ground level) - fields are: 
%               - .allEQs(eqIndex) - this is the value for all EQ's of the stripe (with NAN for non-converged or collapsed runs)
%               - .allEQs_withoutNAN(eqIndex) - same as above, but NANs removed
%               - .MinAllEQs
%               - .MaxAllEQs
%               - .MeanAllEQs
%               - .StDevAllEQs
%               - .MedianAllEQs
%               - .MeanLnAllEQs
%               - .StDevLnAllEQs
%
%       IDR_maxAllStories - maximum of all stories
%               - .allEQs(eqIndex) - this is the value for all EQ's of the stripe (with NAN for non-converged or collapsed runs)
%               - .allEQs_withoutNAN(eqIndex) - same as above, but NANs removed
%               - .MinAllEQs
%               - .MaxAllEQs
%               - .MeanAllEQs
%               - .StDevAllEQs
%               - .MedianAllEQs
%               - .MeanLnAllEQs
%               - .StDevLnAllEQs
%       IDR_max_Avg - average of the peak story drift ratios (like peak
%       roof drift ratio; would be exactly peak roof drift ratio if peak
%       story drifts occur all at the same time)
%               - .allEQs(eqIndex) - this is the value for all EQ's of the stripe (with NAN for non-converged or collapsed runs)
%               - .allEQs_withoutNAN(eqIndex) - same as above, but NANs removed
%               - .MinAllEQs
%               - .MaxAllEQs
%               - .MeanAllEQs
%               - .StDevAllEQs
%               - .MedianAllEQs
%               - .MeanLnAllEQs
%               - .StDevLnAllEQs
%
%       IDR_residual{storyNum} - This is the absolute value of the
%       residual.
%               - .allEQs(eqIndex) - this is the value for all EQ's of the stripe (with NAN for non-converged or collapsed runs)
%               - .allEQs_withoutNAN(eqIndex) - same as above, but NANs removed
%               - .MinAllEQs
%               - .MaxAllEQs
%               - .MeanAllEQs
%               - .StDevAllEQs
%               - .MedianAllEQs
%               - .MeanLnAllEQs
%               - .StDevLnAllEQs
%
%       PGAToSave - peak ground acceleration [g]
%               - .allEQs(eqIndex) - this is the value for all EQ's of the stripe (with NAN for non-converged or collapsed runs)
%               - .allEQs_withoutNAN(eqIndex) - same as above, but NANs removed
%               - .MinAllEQs
%               - .MaxAllEQs
%               - .MeanAllEQs
%               - .StDevAllEQs
%               - .MedianAllEQs
%               - .MeanLnAllEQs
%               - .StDevLnAllEQs
%
%       PFA{floorNum} - [g] maximum floor accel. (these are all unfiltered) for all EQ's (floor num starts at 1 for ground level) - fields are: 
%               - .allEQs(eqIndex) - this is the value for all EQ's of the stripe (with NAN for non-converged or collapsed runs)
%               - .allEQs_withoutNAN(eqIndex) - same as above, but NANs removed
%               - .MinAllEQs
%               - .MaxAllEQs
%               - .MeanAllEQs
%               - .StDevAllEQs
%               - .MedianAllEQs
%               - .MeanLnAllEQs
%               - .StDevLnAllEQs
%
%       NOT USED HERE - maxPHRForAllEle{eleNum}
%
%       isNonConverged_allEQs(eqNumber) - flag for if analysis is NOT converged
%           (note that if it is collapsed then it did not converge to the end
%           of the EQ)
%
%       isCollapsed_allEQs(eqNumber) - flag for if analysis is NOT converged
%           (note that if it is collapsed then it did not converge to the end
%           of the EQ)
%
%       stripeResultsTableForAllEQs - This is a table containing all of the
%       stripes results; this is in the format needed for the simplified
%       loss toolbox created by Eduardo Miranda.
%           - Contents in order of columns; each row is one EQ:
%               - Sa level for stripe
%               - eqNumber
%               - RDR_max (maximum roof drift ratio)
%               - IDR_max for each story of building
%               - RDR_absResidual (residual roof drift ratio)
%               - IDR_residual for each story of building
%               - PGAToSave
%               - PFA for each floor of building excluding ground floor
%               - beamAbsMaxPHR_allBeams for each floor of building
%               (excluding ground floor of course) (this is the maximum of the next two entries)
%               - beamAbsMaxPHR_interiorBeams for each floor of building (excluding ground floor of course)
%               - beamAbsMaxPHR_exteriorBeams for each floor of building (excluding ground floor of course)
%               - columnAbsMaxPHR_allColumns for each story of building (this is the maximum of the next two entries)
%               - columnAbsMaxPHR_interiorColumns for each story of building
%               - columnAbsMaxPHR_exteriorColumns for each story of building
%               - jointShearDistortionAbsMax_allJoints for each floor of
%               building (excluding ground floor of course)  (this is the maximum of the next two entries)
%               - jointShearDistortionAbsMax_interiorJoints for each floor of building (excluding ground floor of course)
%               - jointShearDistortionAbsMax_exteriorJoints for each floor of building (excluding ground floor of course)
%               - isNonConverged
%               - isCollapsed
%
%       stripeResultsTableSummaryStats - These are just the summary
%       statistic for the stripe analyses.  Note that for a tall building
%       (like a 20 story building) these results will not fit on on Excel
%       page).
%           - Contents in order of columns; each row is one EQ:
%               - saLevelForCurrentStripe   
%               - RDR_max.MeanLnAllEQs,StDevLnAllEQs (maximum roof drift ratio)
%               - IDR_max{for all stories}.MeanLnAllEQs,StDevLnAllEQs 
%               - RDR_absResidual.MeanLnAllEQs,StDevLnAllEQs (residual roof drift ratio)
%               - IDR_residual{for all stories}.MeanLnAllEQs,StDevLnAllEQs
%               - PGAToSave.MeanLnAllEQs,StDevLnAllEQs
%               - PFA{for all floors from 1 to roof}.MeanLnAllEQs,StDevLnAllEQs
%               - beamAbsMaxPHR_allBeams.MeanLnAllEQs,StDevLnAllEQs
%               - beamAbsMaxPHR_interiorBeams.MeanLnAllEQs,StDevLnAllEQs
%               - beamAbsMaxPHR_exteriorBeams.MeanLnAllEQs,StDevLnAllEQs
%               - columnAbsMaxPHR_allColumns.MeanLnAllEQs,StDevLnAllEQs
%               - columnAbsMaxPHR_interiorColumns.MeanLnAllEQs,StDevLnAllEQs
%               - columnAbsMaxPHR_exteriorColumns.MeanLnAllEQs,StDevLnAllEQs
%               - jointShearDistortionAbsMax_allJoints.MeanLnAllEQs,StDevLnAllEQs
%               - jointShearDistortionAbsMax_interiorJoints.MeanLnAllEQs,StDevLnAllEQs
%               - jointShearDistortionAbsMax_exteriorJoints.MeanLnAllEQs,StDevLnAllEQs
%               - isCollapsed_mean;
%
% Units: Whatever OpenSees is using - just be consistent!
%
% -------------------
function[void] = ProcessStripeStatisticsForCollapseRuns_proc(analysisType, eqNumberLIST_forStripes, eqListForCollapseIDAs_Name, saLevelsForStripes, isConvertToSaKircher, isConvertToSaComponent, dampRat)

disp('Starting stripe processing...');

% Input units of g to convert the PFA from in/s^2 (as used in Opensees) to
% g units
% g = 386.4; %in/s^2
% dampRat = 0.05; % Used for converting to Sa,Kircher when this is done.

% Go to the output folder
startFolder = [pwd];
% cd ..;
% cd ..;
cd E:\OpenSees_PracticeExamples\ida-spo-temp\Output
% cd Output
cd(analysisType);

% Go into MatlabInformation just to find the number of floors/stories (so I
% know how many EDPs we will have for drift/PFA.
cd MatlabInformation
% If there is an error at this stage, then run the pushover analysis and
% paste the two files 


% floorHeightsList = load('floorHeightLISTOUT.out');
%periodUsedForScalingGroundMotionsFromMatlab =
%load('periodUsedForScalingGroundMotionsFromMatlabOUT.out'); % Removed on
    %7-26-06 b/c I did not save this correctly in the MatlabInfor folder; the
    %correct value is in the folders for each Eq-Sa run.  This is now
    %opened from the EQ-Sa files when the EDP data is loaded (so it is
    %opened many time, but I had to do this b/c this is how the Opensees
    %model was set up and I already started a lot of analysis).
% numFloors = length(floorHeightsList);
% numStories = numFloors - 1;
cd ..;

% Loop through all Sa levels for stripes
currentStartRowInStripeEDPResultsFullTable = 1;
currentStartRowInStripeEDPResultsSummaryTable = 1;
for stripeIndex = 1:length(saLevelsForStripes)
    saLevelForCurrentStripe = saLevelsForStripes(stripeIndex);
    temp = sprintf('Stripe processing for Sa = %.2fg...', saLevelForCurrentStripe);
    disp(temp);
    
    % Loop over the EQ list and get results for each EQ
    for eqIndex = 1:length(eqNumberLIST_forStripes)
        currentEqNum = eqNumberLIST_forStripes(eqIndex);

        % Go into the EQ folder
        eqFolderName = sprintf('EQ_%d', currentEqNum);
        cd(eqFolderName);
        
        % Open collapse results file for this EQ 
        load('DATA_CollapseResultsForThisSingleEQ.mat');
      
        % load('DATA_collapse_ProcessedIDADataForThisEQ.mat');
        
        % Just to get the period used for GM scaling, open the file from the first non-zero Sa value that was run for
        % this EQ
        % firstNonZeroSaValue = saLevelsForIDAPlotPROCLIST(2);
        % saFolderName = sprintf('Sa_%.2f', firstNonZeroSaValue);
        % cd(saFolderName);
        % load('DATA_reducedSensDataForThisSingleRun.mat', 'periodUsedForScalingGroundMotionsFromMatlab');
        % cd ..;

        % All of the data files that we are opening here is based on Sa,geoMean(T1).  
        %   If we want to use Sa,geoMean(T1), then we do not need to alter the Sa values 
        %   that we look up in the EDP files.  If we want to use Sa,Kircher(1s),
        %   we just need to fake the program out by looking up a
        %   Sa,geoMean(T1) value that is altered. (7-20-06)
        % Similarly, if we want to use Sa,component instead of Sa,geoMean
        % we also want to fake the program out (added on 11-2-07).
        if(isConvertToSaKircher == 0 & isConvertToSaComponent == 0)
            % The input stripe Sa value is Sa,geoMean(T1) and we are looking up files
            % based on Sa,geoMean(T1), so no alteration is needed.
            saLevelForToLookUp = saLevelForCurrentStripe;
        elseif(isConvertToSaKircher == 1 & isConvertToSaComponent == 0)
            % The input stripe Sa value is Sa,ATC63(1s) and we are looking up files
            % based on Sa,geoMean(T1), so we need to convert from the stripe Sa
            % (Sa,ATC(1s)) to the Sa used in the EDP files being used
            % (Sa,gemMean(T1))
            DefineSaKircherOverSaGeoMeanValues; % Load file
            currentEqRecNum = floor(currentEqNum/10);
            saGeoMeanAtOneSec = RetrieveSaGeoMeanValueForAnEQ(currentEqRecNum, 1.0, dampRat);
            saGeoMeanAtTOne = RetrieveSaGeoMeanValueForAnEQ(currentEqRecNum, periodUsedForScalingGroundMotionsFromMatlab, dampRat);
            saLevelForToLookUp = saLevelForCurrentStripe * (saGeoMeanAtTOne/saGeoMeanAtOneSec) * (1/saKircherAtOneSecOverSaGeoMeanAtOneSec{currentEqNum});
        elseif(isConvertToSaKircher == 0 & isConvertToSaComponent == 1)
            % The input stripe Sa value is Sa,component(T1) and we are looking up files
            % based on Sa,geoMean(T1), so we need to convert from the stripe Sa
            % (Sa,component(T1)) to the Sa used in the EDP files being used
            % (Sa,geoMean(T1)). (added on 11-2-07)
            currentEqRecNum = floor(currentEqNum/10);
            saGeoMeanAtTOne = RetrieveSaGeoMeanValueForAnEQ(currentEqRecNum, periodUsedForScalingGroundMotionsFromMatlab, dampRat);
            saComponentAtTOne = RetrieveSaCompValueForAnEQ(currentEqNum, periodUsedForScalingGroundMotionsFromMatlab, dampRat);
            saLevelForToLookUp = saLevelForCurrentStripe * (saComponentAtTOne / saGeoMeanAtTOne);
        else
            error('Error: Invalid definition for type of Sa used');
        end
        
        % If the stripe Sa value is above Sa,collapse, then call it
        % collapsed and exit this loop
        % if(saLevelForToLookUp > collapseSaLevel)
        %     % This EQ has already collapse building, so flag this and add
        %     % NANs for the EDPs
        %     isCollapsed_allEQs(eqIndex) = 1;
        %     isNonConverged_allEQs(eqIndex) = 1;
        %     % Loop and add NANs for the EDPs - call proc
        %     PlaceNANsForAllEDPs
        % else
        %     % It did not collapse, so continue with the processing
        %     isCollapsed_allEQs(eqIndex) = 0;
        % 
        %     % Find the Sa value just above and below the Sa for this
        %     % stripe.  Note that the last value in the collapse IDA Sa level vecor is 100.0 (from eartlier processing).  
        %     % Loop until the Sa in the collapse IDA vector exceeds the Sa for this stripe; then save
        %     % the values of the Sa above and below the Sa for this stripe.
        %     for i = 1:length(saLevelsForIDAPlotPROCLIST)
        %         currentSaInCollapseIDAVector = saLevelsForIDAPlotPROCLIST(i);
        %         if(currentSaInCollapseIDAVector > saLevelForToLookUp)
        %             break;
        %         end
        %     end
    %         saLevel_belowStripe = saLevelsForIDAPlotPROCLIST(i-1);
    %         saLevel_aboveStripe = saLevelsForIDAPlotPROCLIST(i);
    % 
    %         % Error check - if the saLevel above the stripe is 100.0, then
    %         % something weird happended, so call it non-converged and place
    %         % nans for the EDPs.
    %         if(saLevel_aboveStripe > 99.0)
    %             isNonConverged_allEQs(eqIndex) = 1;
    %             % Loop and add NANs for the EDPs - call proc
    %             PlaceNANsForAllEDPs                
    %         else
    %             % It is not collapsed and so far it looks converged, so
    %             % continue...
    % 
    %             % Open the response files for the Sa levels above and below
    %             % the stripe Sa.  If the Sa value below the stripe is 0.00
    %             % (i.e. the stripe is below the first Sa value run), then
    %             % place zero into all of the EDPs for the SaBelowTheStripe
    %             LoadEDPsForSaBelowStripe
    %             LoadEDPsForSaAboveStripe
    % 
    %             % If either of the Sa levels above or below this stripe Sa
    %             % is non-conv, then call the analysis non-conv and place
    %             % NANs in the EDPs.
    %             if((isNonConverged_belowStripe == 1) | (isNonConverged_aboveStripe == 1))
    %                 isNonConverged_allEQs(eqIndex) = 1;
    %                 % Loop and add NANs for the EDPs - call proc
    %                 PlaceNANsForAllEDPs    
    %             else
    %                 % The analyses are convereged at the Sa levels just
    %                 % below/above the Sa of this stripe, so we call it
    %                 % converged and move onto do the linear interpolation
    %                 % for getting the EDPs for this stripe.
    %                 isNonConverged_allEQs(eqIndex) = 0;
    % 
    %                 % Do linear interpolation between the two Sa levels
    %                 % above and below this stripe to get the EDP results.
    %                 ratioForInterp = (saLevelForToLookUp - saLevel_belowStripe) / (saLevel_aboveStripe - saLevel_belowStripe);
    %                 IDR_residual_maxAllStories.allEQs(eqIndex) = 0.0;
    % %                 for storyNum = 1:numStories
    % %                     IDR_max{storyNum}.allEQs(eqIndex) = IDR_max_belowStripe{storyNum} + ratioForInterp * (IDR_max_aboveStripe{storyNum} - IDR_max_belowStripe{storyNum});
    % %                     IDR_residual{storyNum}.allEQs(eqIndex) = IDR_residual_belowStripe{storyNum} + ratioForInterp * (IDR_residual_aboveStripe{storyNum} - IDR_residual_belowStripe{storyNum});
    % %                     % Update maximums
    % %                     if(IDR_residual{storyNum}.allEQs(eqIndex) > IDR_residual_maxAllStories.allEQs(eqIndex))
    % %                         IDR_residual_maxAllStories.allEQs(eqIndex) = IDR_residual{storyNum}.allEQs(eqIndex);
    %                     end                    
    %                 end
    %                 RDR_max.allEQs(eqIndex) = RDR_max_belowStripe + ratioForInterp * (RDR_max_aboveStripe - RDR_max_belowStripe);
    %                 RDR_absResidual.allEQs(eqIndex) = RDR_absResidual_belowStripe + ratioForInterp * (RDR_absResidual_aboveStripe - RDR_absResidual_belowStripe);
    %                 IDR_maxAllStories.allEQs(eqIndex) = IDR_maxAllStories_belowStripe + ratioForInterp * (IDR_maxAllStories_aboveStripe - IDR_maxAllStories_belowStripe);
    %                 PGAToSave.allEQs(eqIndex) = PGA_belowStripe + ratioForInterp * (PGA_aboveStripe - PGA_belowStripe); % g-units
    %                 for floorNum = 2:numFloors
    %                     PFA{floorNum}.allEQs(eqIndex) = PFA_belowStripe{floorNum} + ratioForInterp * (PFA_aboveStripe{floorNum} - PFA_belowStripe{floorNum});
    %                 end    
    %                 beamAbsMaxPHR_maxAllFloors.allEQs(eqIndex) = beamAbsMaxPHR_maxAllFloors_belowStripe + ratioForInterp * (beamAbsMaxPHR_maxAllFloors_aboveStripe - beamAbsMaxPHR_maxAllFloors_belowStripe);
    %                 for floorNum = 2:numFloors
    %                     beamAbsMaxPHR_allBeams{floorNum}.allEQs(eqIndex) = beamAbsMaxPHR_allBeams_belowStripe{floorNum} + ratioForInterp * (beamAbsMaxPHR_allBeams_aboveStripe{floorNum} - beamAbsMaxPHR_allBeams_belowStripe{floorNum});
    %                     beamAbsMaxPHR_interiorBeams{floorNum}.allEQs(eqIndex) = beamAbsMaxPHR_interiorBeams_belowStripe{floorNum} + ratioForInterp * (beamAbsMaxPHR_interiorBeams_aboveStripe{floorNum} - beamAbsMaxPHR_interiorBeams_belowStripe{floorNum});
    %                     beamAbsMaxPHR_exteriorBeams{floorNum}.allEQs(eqIndex) = beamAbsMaxPHR_exteriorBeams_belowStripe{floorNum} + ratioForInterp * (beamAbsMaxPHR_exteriorBeams_aboveStripe{floorNum} - beamAbsMaxPHR_exteriorBeams_belowStripe{floorNum});
    %                 end
    %                 columnAbsMaxPHR_maxAllStories.allEQs(eqIndex) = columnAbsMaxPHR_maxAllStories_belowStripe + ratioForInterp * (columnAbsMaxPHR_maxAllStories_aboveStripe - columnAbsMaxPHR_maxAllStories_belowStripe);
    %                 for storyNum = 1:numStories
    %                     columnAbsMaxPHR_allColumns{storyNum}.allEQs(eqIndex) = columnAbsMaxPHR_allColumns_belowStripe{storyNum} + ratioForInterp * (columnAbsMaxPHR_allColumns_aboveStripe{storyNum} - columnAbsMaxPHR_allColumns_belowStripe{storyNum});
    %                     columnAbsMaxPHR_interiorColumns{storyNum}.allEQs(eqIndex) = columnAbsMaxPHR_interiorColumns_belowStripe{storyNum} + ratioForInterp * (columnAbsMaxPHR_interiorColumns_aboveStripe{storyNum} - columnAbsMaxPHR_interiorColumns_belowStripe{storyNum});
    %                     columnAbsMaxPHR_exteriorColumns{storyNum}.allEQs(eqIndex) = columnAbsMaxPHR_exteriorColumns_belowStripe{storyNum} + ratioForInterp * (columnAbsMaxPHR_exteriorColumns_aboveStripe{storyNum} - columnAbsMaxPHR_exteriorColumns_belowStripe{storyNum});
    %                 end
    %                 jointShearDistortionAbsMax_maxAllFloors.allEQs(eqIndex) = jointShearDistortionAbsMax_maxAllFloors_belowStripe + ratioForInterp * (jointShearDistortionAbsMax_maxAllFloors_aboveStripe - jointShearDistortionAbsMax_maxAllFloors_belowStripe);
    %                 for floorNum = 2:numFloors
    %                     jointShearDistortionAbsMax_allJoints{floorNum}.allEQs(eqIndex) = jointShearDistortionAbsMax_allJoints_belowStripe{floorNum} + ratioForInterp * (jointShearDistortionAbsMax_allJoints_aboveStripe{floorNum} - jointShearDistortionAbsMax_allJoints_belowStripe{floorNum});
    %                     jointShearDistortionAbsMax_interiorJoints{floorNum}.allEQs(eqIndex) = jointShearDistortionAbsMax_interiorJoints_belowStripe{floorNum} + ratioForInterp * (jointShearDistortionAbsMax_interiorJoints_aboveStripe{floorNum} - jointShearDistortionAbsMax_interiorJoints_belowStripe{floorNum});
    %                     jointShearDistortionAbsMax_exteriorJoints{floorNum}.allEQs(eqIndex) = jointShearDistortionAbsMax_exteriorJoints_belowStripe{floorNum} + ratioForInterp * (jointShearDistortionAbsMax_exteriorJoints_aboveStripe{floorNum} - jointShearDistortionAbsMax_exteriorJoints_belowStripe{floorNum});
    %                 end
    % 
    %             end;    % end of IF statement for checking convergence of Sa runs just above and just below stripe Sa
    %         end;    % end of IF statement for "non-converged" check based on the Sa being too close to the dummy 100.0 value
    %     end;    % end of IF statement for collapse check
    %     cd ..;
    % end;    % end of EQ loop
    
    % % Do summary statistics and save file for this stripe (be sure to
    % % mention the Sa definition used for the stripe).
    %     for storyNum = 1:numStories
    %         % IDR_max and residual
    %         IDR_max{storyNum}.allEQs_withoutNAN = IDR_max{storyNum}.allEQs(find(~isnan(IDR_max{storyNum}.allEQs)));
    %         if(length(IDR_max{storyNum}.allEQs_withoutNAN) > 0)                
    %             IDR_max{storyNum}.MeanAllEQs       = mean(IDR_max{storyNum}.allEQs_withoutNAN);
    %             IDR_max{storyNum}.MinAllEQs        = min(IDR_max{storyNum}.allEQs_withoutNAN);
    %             IDR_max{storyNum}.MaxAllEQs        = max(IDR_max{storyNum}.allEQs_withoutNAN);
    %             IDR_max{storyNum}.StDevAllEQs      = std(IDR_max{storyNum}.allEQs_withoutNAN);
    %             IDR_max{storyNum}.MedianAllEQs     = median(IDR_max{storyNum}.allEQs_withoutNAN);
    %             IDR_max{storyNum}.MeanLnAllEQs     = mean(log(IDR_max{storyNum}.allEQs_withoutNAN));
    %             IDR_max{storyNum}.StDevLnAllEQs    = std(log(IDR_max{storyNum}.allEQs_withoutNAN));
    %             % IDR_residual
    %             IDR_residual{storyNum}.allEQs_withoutNAN = IDR_residual{storyNum}.allEQs(find(~isnan(IDR_residual{storyNum}.allEQs)));
    %             IDR_residual{storyNum}.MeanAllEQs       = mean(IDR_residual{storyNum}.allEQs_withoutNAN);
    %             IDR_residual{storyNum}.MinAllEQs        = min(IDR_residual{storyNum}.allEQs_withoutNAN);
    %             IDR_residual{storyNum}.MaxAllEQs        = max(IDR_residual{storyNum}.allEQs_withoutNAN);
    %             IDR_residual{storyNum}.StDevAllEQs      = std(IDR_residual{storyNum}.allEQs_withoutNAN);
    %             IDR_residual{storyNum}.MedianAllEQs     = median(IDR_residual{storyNum}.allEQs_withoutNAN);
    %             IDR_residual{storyNum}.MeanLnAllEQs     = mean(log(IDR_residual{storyNum}.allEQs_withoutNAN));
    %             IDR_residual{storyNum}.StDevLnAllEQs    = std(log(IDR_residual{storyNum}.allEQs_withoutNAN));
        %     else
        %         IDR_max{storyNum}.MeanAllEQs       = nan;
        %         IDR_max{storyNum}.MinAllEQs        = nan;
        %         IDR_max{storyNum}.MaxAllEQs        = nan;
        %         IDR_max{storyNum}.StDevAllEQs      = nan;
        %         IDR_max{storyNum}.MedianAllEQs     = nan;
        %         IDR_max{storyNum}.MeanLnAllEQs     = nan;
        %         IDR_max{storyNum}.StDevLnAllEQs    = nan;
        %         % IDR_residual
        %         IDR_residual{storyNum}.allEQs_withoutNAN = IDR_residual{storyNum}.allEQs(find(~isnan(IDR_residual{storyNum}.allEQs)));
        %         IDR_residual{storyNum}.MeanAllEQs       = nan;
        %         IDR_residual{storyNum}.MinAllEQs        = nan;
        %         IDR_residual{storyNum}.MaxAllEQs        = nan;
        %         IDR_residual{storyNum}.StDevAllEQs      = nan;
        %         IDR_residual{storyNum}.MedianAllEQs     = nan;
        %         IDR_residual{storyNum}.MeanLnAllEQs     = nan;
        %         IDR_residual{storyNum}.StDevLnAllEQs    = nan;
        %     end
        % end

        % for floorNum = 2:numFloors
        %     % PFA
        %     PFA{floorNum}.allEQs_withoutNAN = PFA{floorNum}.allEQs(find(~isnan(PFA{floorNum}.allEQs)));
        %     if(length(PFA{floorNum}.allEQs_withoutNAN) > 0)
        %         PFA{floorNum}.MeanAllEQs       = mean(PFA{floorNum}.allEQs_withoutNAN);
        %         PFA{floorNum}.MinAllEQs        = min(PFA{floorNum}.allEQs_withoutNAN);
        %         PFA{floorNum}.MaxAllEQs        = max(PFA{floorNum}.allEQs_withoutNAN);
        %         PFA{floorNum}.StDevAllEQs      = std(PFA{floorNum}.allEQs_withoutNAN);
        %         PFA{floorNum}.MedianAllEQs     = median(PFA{floorNum}.allEQs_withoutNAN);
        %         PFA{floorNum}.MeanLnAllEQs     = mean(log(PFA{floorNum}.allEQs_withoutNAN));
        %         PFA{floorNum}.StDevLnAllEQs    = std(log(PFA{floorNum}.allEQs_withoutNAN));
        %     else
        %         PFA{floorNum}.MeanAllEQs       = nan;
        %         PFA{floorNum}.MinAllEQs        = nan;
        %         PFA{floorNum}.MaxAllEQs        = nan;
        %         PFA{floorNum}.StDevAllEQs      = nan;
        %         PFA{floorNum}.MedianAllEQs     = nan;
        %         PFA{floorNum}.MeanLnAllEQs     = nan;
        %         PFA{floorNum}.StDevLnAllEQs    = nan;
        %     end
        % end    
    
        % % IDR_maxAllStories
        % IDR_maxAllStories.allEQs_withoutNAN = IDR_maxAllStories.allEQs(find(~isnan(IDR_maxAllStories.allEQs)));
        % if(length(IDR_maxAllStories.allEQs_withoutNAN) > 0)
        %     IDR_maxAllStories.MeanAllEQs       = mean(IDR_maxAllStories.allEQs_withoutNAN);
        %     IDR_maxAllStories.MinAllEQs        = min(IDR_maxAllStories.allEQs_withoutNAN);
        %     IDR_maxAllStories.MaxAllEQs        = max(IDR_maxAllStories.allEQs_withoutNAN);
        %     IDR_maxAllStories.StDevAllEQs      = std(IDR_maxAllStories.allEQs_withoutNAN);
        %     IDR_maxAllStories.MedianAllEQs     = median(IDR_maxAllStories.allEQs_withoutNAN);
        %     IDR_maxAllStories.MeanLnAllEQs     = mean(log(IDR_maxAllStories.allEQs_withoutNAN));
        %     IDR_maxAllStories.StDevLnAllEQs    = std(log(IDR_maxAllStories.allEQs_withoutNAN));
        % else
        %     IDR_maxAllStories.MeanAllEQs       = nan;
        %     IDR_maxAllStories.MinAllEQs        = nan;
        %     IDR_maxAllStories.MaxAllEQs        = nan;
        %     IDR_maxAllStories.StDevAllEQs      = nan;
        %     IDR_maxAllStories.MedianAllEQs     = nan;
        %     IDR_maxAllStories.MeanLnAllEQs     = nan;
        %     IDR_maxAllStories.StDevLnAllEQs    = nan;
        % end

        % % IDR_residual_maxAllStories
        % IDR_residual_maxAllStories.allEQs_withoutNAN = IDR_residual_maxAllStories.allEQs(find(~isnan(IDR_residual_maxAllStories.allEQs)));
        % if(length(IDR_residual_maxAllStories.allEQs_withoutNAN) > 0)
        %     IDR_residual_maxAllStories.MeanAllEQs       = mean(IDR_residual_maxAllStories.allEQs_withoutNAN);
        %     IDR_residual_maxAllStories.MinAllEQs        = min(IDR_residual_maxAllStories.allEQs_withoutNAN);
        %     IDR_residual_maxAllStories.MaxAllEQs        = max(IDR_residual_maxAllStories.allEQs_withoutNAN);
        %     IDR_residual_maxAllStories.StDevAllEQs      = std(IDR_residual_maxAllStories.allEQs_withoutNAN);
        %     IDR_residual_maxAllStories.MedianAllEQs     = median(IDR_residual_maxAllStories.allEQs_withoutNAN);
        %     IDR_residual_maxAllStories.MeanLnAllEQs     = mean(log(IDR_residual_maxAllStories.allEQs_withoutNAN));
        %     IDR_residual_maxAllStories.StDevLnAllEQs    = std(log(IDR_residual_maxAllStories.allEQs_withoutNAN));
        % else
        %     IDR_residual_maxAllStories.MeanAllEQs       = nan;
        %     IDR_residual_maxAllStories.MinAllEQs        = nan;
        %     IDR_residual_maxAllStories.MaxAllEQs        = nan;
        %     IDR_residual_maxAllStories.StDevAllEQs      = nan;
        %     IDR_residual_maxAllStories.MedianAllEQs     = nan;
        %     IDR_residual_maxAllStories.MeanLnAllEQs     = nan;
        %     IDR_residual_maxAllStories.StDevLnAllEQs    = nan;
        % end        
        
        % % RDR_max
        % RDR_max.allEQs_withoutNAN = RDR_max.allEQs(find(~isnan(RDR_max.allEQs)));
        % if(length(RDR_max.allEQs_withoutNAN) > 0)
        %     RDR_max.MeanAllEQs       = mean(RDR_max.allEQs_withoutNAN);
        %     RDR_max.MinAllEQs        = min(RDR_max.allEQs_withoutNAN);
        %     RDR_max.MaxAllEQs        = max(RDR_max.allEQs_withoutNAN);
        %     RDR_max.StDevAllEQs      = std(RDR_max.allEQs_withoutNAN);
        %     RDR_max.MedianAllEQs     = median(RDR_max.allEQs_withoutNAN);
        %     RDR_max.MeanLnAllEQs     = mean(log(RDR_max.allEQs_withoutNAN));
        %     RDR_max.StDevLnAllEQs    = std(log(RDR_max.allEQs_withoutNAN));
        % else
        %     RDR_max.MeanAllEQs       = nan;
        %     RDR_max.MinAllEQs        = nan;
        %     RDR_max.MaxAllEQs        = nan;
        %     RDR_max.StDevAllEQs      = nan;
        %     RDR_max.MedianAllEQs     = nan;
        %     RDR_max.MeanLnAllEQs     = nan;
        %     RDR_max.StDevLnAllEQs    = nan;
        % end        
        
        % % RDR_absResidual
        % RDR_absResidual.allEQs_withoutNAN = RDR_absResidual.allEQs(find(~isnan(RDR_absResidual.allEQs)));
        % if(length(RDR_absResidual.allEQs_withoutNAN) > 0)
        %     RDR_absResidual.MeanAllEQs       = mean(RDR_absResidual.allEQs_withoutNAN);
        %     RDR_absResidual.MinAllEQs        = min(RDR_absResidual.allEQs_withoutNAN);
        %     RDR_absResidual.MaxAllEQs        = max(RDR_absResidual.allEQs_withoutNAN);
        %     RDR_absResidual.StDevAllEQs      = std(RDR_absResidual.allEQs_withoutNAN);
        %     RDR_absResidual.MedianAllEQs     = median(RDR_absResidual.allEQs_withoutNAN);
        %     RDR_absResidual.MeanLnAllEQs     = mean(log(RDR_absResidual.allEQs_withoutNAN));
        %     RDR_absResidual.StDevLnAllEQs    = std(log(RDR_absResidual.allEQs_withoutNAN));
        % else
        %     RDR_absResidual.MeanAllEQs       = nan;
        %     RDR_absResidual.MinAllEQs        = nan;
        %     RDR_absResidual.MaxAllEQs        = nan;
        %     RDR_absResidual.StDevAllEQs      = nan;
        %     RDR_absResidual.MedianAllEQs     = nan;
        %     RDR_absResidual.MeanLnAllEQs     = nan;
        %     RDR_absResidual.StDevLnAllEQs    = nan;
        % end          
        
        % % PGAToSave
        % PGAToSave.allEQs_withoutNAN = PGAToSave.allEQs(find(~isnan(PGAToSave.allEQs)));
        % if(length(PGAToSave.allEQs_withoutNAN) > 0)
        %     PGAToSave.MeanAllEQs       = mean(PGAToSave.allEQs_withoutNAN);
        %     PGAToSave.MinAllEQs        = min(PGAToSave.allEQs_withoutNAN);
        %     PGAToSave.MaxAllEQs        = max(PGAToSave.allEQs_withoutNAN);
        %     PGAToSave.StDevAllEQs      = std(PGAToSave.allEQs_withoutNAN);
        %     PGAToSave.MedianAllEQs     = median(PGAToSave.allEQs_withoutNAN);
        %     PGAToSave.MeanLnAllEQs     = mean(log(PGAToSave.allEQs_withoutNAN));
        %     PGAToSave.StDevLnAllEQs    = std(log(PGAToSave.allEQs_withoutNAN));
        % else
        %     PGAToSave.MeanAllEQs       = nan;
        %     PGAToSave.MinAllEQs        = nan;
        %     PGAToSave.MaxAllEQs        = nan;
        %     PGAToSave.StDevAllEQs      = nan;
        %     PGAToSave.MedianAllEQs     = nan;
        %     PGAToSave.MeanLnAllEQs     = nan;
        %     PGAToSave.StDevLnAllEQs    = nan;
        % end

        % % beamAbsMaxPHR_maxAllFloors
        % beamAbsMaxPHR_maxAllFloors.allEQs_withoutNAN = beamAbsMaxPHR_maxAllFloors.allEQs(find(~isnan(beamAbsMaxPHR_maxAllFloors.allEQs)));
        % if(length(beamAbsMaxPHR_maxAllFloors.allEQs_withoutNAN) > 0)
        %     beamAbsMaxPHR_maxAllFloors.MeanAllEQs       = mean(beamAbsMaxPHR_maxAllFloors.allEQs_withoutNAN);
        %     beamAbsMaxPHR_maxAllFloors.MinAllEQs        = min(beamAbsMaxPHR_maxAllFloors.allEQs_withoutNAN);
        %     beamAbsMaxPHR_maxAllFloors.MaxAllEQs        = max(beamAbsMaxPHR_maxAllFloors.allEQs_withoutNAN);
        %     beamAbsMaxPHR_maxAllFloors.StDevAllEQs      = std(beamAbsMaxPHR_maxAllFloors.allEQs_withoutNAN);
        %     beamAbsMaxPHR_maxAllFloors.MedianAllEQs     = median(beamAbsMaxPHR_maxAllFloors.allEQs_withoutNAN);
        %     beamAbsMaxPHR_maxAllFloors.MeanLnAllEQs     = mean(log(beamAbsMaxPHR_maxAllFloors.allEQs_withoutNAN));
        %     beamAbsMaxPHR_maxAllFloors.StDevLnAllEQs    = std(log(beamAbsMaxPHR_maxAllFloors.allEQs_withoutNAN));
        % else
        %     beamAbsMaxPHR_maxAllFloors.MeanAllEQs       = nan;
        %     beamAbsMaxPHR_maxAllFloors.MinAllEQs        = nan;
        %     beamAbsMaxPHR_maxAllFloors.MaxAllEQs        = nan;
        %     beamAbsMaxPHR_maxAllFloors.StDevAllEQs      = nan;
        %     beamAbsMaxPHR_maxAllFloors.MedianAllEQs     = nan;
        %     beamAbsMaxPHR_maxAllFloors.MeanLnAllEQs     = nan;
        %     beamAbsMaxPHR_maxAllFloors.StDevLnAllEQs    = nan;
        % end
        % 
        % for floorNum = 2:numFloors
        %     % beamAbsMaxPHR_allBeams
        %     beamAbsMaxPHR_allBeams{floorNum}.allEQs_withoutNAN = beamAbsMaxPHR_allBeams{floorNum}.allEQs(find(~isnan(beamAbsMaxPHR_allBeams{floorNum}.allEQs)));
        %     if(length(beamAbsMaxPHR_allBeams{floorNum}.allEQs_withoutNAN) > 0)
        %         beamAbsMaxPHR_allBeams{floorNum}.MeanAllEQs       = mean(beamAbsMaxPHR_allBeams{floorNum}.allEQs_withoutNAN);
        %         beamAbsMaxPHR_allBeams{floorNum}.MinAllEQs        = min(beamAbsMaxPHR_allBeams{floorNum}.allEQs_withoutNAN);
        %         beamAbsMaxPHR_allBeams{floorNum}.MaxAllEQs        = max(beamAbsMaxPHR_allBeams{floorNum}.allEQs_withoutNAN);
        %         beamAbsMaxPHR_allBeams{floorNum}.StDevAllEQs      = std(beamAbsMaxPHR_allBeams{floorNum}.allEQs_withoutNAN);
        %         beamAbsMaxPHR_allBeams{floorNum}.MedianAllEQs     = median(beamAbsMaxPHR_allBeams{floorNum}.allEQs_withoutNAN);
        %         beamAbsMaxPHR_allBeams{floorNum}.MeanLnAllEQs     = mean(log(beamAbsMaxPHR_allBeams{floorNum}.allEQs_withoutNAN));
        %         beamAbsMaxPHR_allBeams{floorNum}.StDevLnAllEQs    = std(log(beamAbsMaxPHR_allBeams{floorNum}.allEQs_withoutNAN));
        %     else
        %         beamAbsMaxPHR_allBeams{floorNum}.MeanAllEQs       = nan;
        %         beamAbsMaxPHR_allBeams{floorNum}.MinAllEQs        = nan;
        %         beamAbsMaxPHR_allBeams{floorNum}.MaxAllEQs        = nan;
        %         beamAbsMaxPHR_allBeams{floorNum}.StDevAllEQs      = nan;
        %         beamAbsMaxPHR_allBeams{floorNum}.MedianAllEQs     = nan;
        %         beamAbsMaxPHR_allBeams{floorNum}.MeanLnAllEQs     = nan;
        %         beamAbsMaxPHR_allBeams{floorNum}.StDevLnAllEQs    = nan;
        %     end
        % end    
        
       % for floorNum = 2:numFloors
       %      % beamAbsMaxPHR_interiorBeams
       %      beamAbsMaxPHR_interiorBeams{floorNum}.allEQs_withoutNAN = beamAbsMaxPHR_interiorBeams{floorNum}.allEQs(find(~isnan(beamAbsMaxPHR_interiorBeams{floorNum}.allEQs)));
       %      if(length(beamAbsMaxPHR_interiorBeams{floorNum}.allEQs_withoutNAN) > 0)
       %          beamAbsMaxPHR_interiorBeams{floorNum}.MeanAllEQs       = mean(beamAbsMaxPHR_interiorBeams{floorNum}.allEQs_withoutNAN);
       %          beamAbsMaxPHR_interiorBeams{floorNum}.MinAllEQs        = min(beamAbsMaxPHR_interiorBeams{floorNum}.allEQs_withoutNAN);
       %          beamAbsMaxPHR_interiorBeams{floorNum}.MaxAllEQs        = max(beamAbsMaxPHR_interiorBeams{floorNum}.allEQs_withoutNAN);
       %          beamAbsMaxPHR_interiorBeams{floorNum}.StDevAllEQs      = std(beamAbsMaxPHR_interiorBeams{floorNum}.allEQs_withoutNAN);
       %          beamAbsMaxPHR_interiorBeams{floorNum}.MedianAllEQs     = median(beamAbsMaxPHR_interiorBeams{floorNum}.allEQs_withoutNAN);
       %          beamAbsMaxPHR_interiorBeams{floorNum}.MeanLnAllEQs     = mean(log(beamAbsMaxPHR_interiorBeams{floorNum}.allEQs_withoutNAN));
       %          beamAbsMaxPHR_interiorBeams{floorNum}.StDevLnAllEQs    = std(log(beamAbsMaxPHR_interiorBeams{floorNum}.allEQs_withoutNAN));
       %      else
       %          beamAbsMaxPHR_interiorBeams{floorNum}.MeanAllEQs       = nan;
       %          beamAbsMaxPHR_interiorBeams{floorNum}.MinAllEQs        = nan;
       %          beamAbsMaxPHR_interiorBeams{floorNum}.MaxAllEQs        = nan;
       %          beamAbsMaxPHR_interiorBeams{floorNum}.StDevAllEQs      = nan;
       %          beamAbsMaxPHR_interiorBeams{floorNum}.MedianAllEQs     = nan;
       %          beamAbsMaxPHR_interiorBeams{floorNum}.MeanLnAllEQs     = nan;
       %          beamAbsMaxPHR_interiorBeams{floorNum}.StDevLnAllEQs    = nan;
       %      end
       % end   
        
        % for floorNum = 2:numFloors
        %     % beamAbsMaxPHR_exteriorBeams
        %     beamAbsMaxPHR_exteriorBeams{floorNum}.allEQs_withoutNAN = beamAbsMaxPHR_exteriorBeams{floorNum}.allEQs(find(~isnan(beamAbsMaxPHR_exteriorBeams{floorNum}.allEQs)));
        %     if(length(beamAbsMaxPHR_interiorBeams{floorNum}.allEQs_withoutNAN) > 0)
        %         beamAbsMaxPHR_exteriorBeams{floorNum}.MeanAllEQs       = mean(beamAbsMaxPHR_exteriorBeams{floorNum}.allEQs_withoutNAN);
        %         beamAbsMaxPHR_exteriorBeams{floorNum}.MinAllEQs        = min(beamAbsMaxPHR_exteriorBeams{floorNum}.allEQs_withoutNAN);
        %         beamAbsMaxPHR_exteriorBeams{floorNum}.MaxAllEQs        = max(beamAbsMaxPHR_exteriorBeams{floorNum}.allEQs_withoutNAN);
        %         beamAbsMaxPHR_exteriorBeams{floorNum}.StDevAllEQs      = std(beamAbsMaxPHR_exteriorBeams{floorNum}.allEQs_withoutNAN);
        %         beamAbsMaxPHR_exteriorBeams{floorNum}.MedianAllEQs     = median(beamAbsMaxPHR_exteriorBeams{floorNum}.allEQs_withoutNAN);
        %         beamAbsMaxPHR_exteriorBeams{floorNum}.MeanLnAllEQs     = mean(log(beamAbsMaxPHR_exteriorBeams{floorNum}.allEQs_withoutNAN));
        %         beamAbsMaxPHR_exteriorBeams{floorNum}.StDevLnAllEQs    = std(log(beamAbsMaxPHR_exteriorBeams{floorNum}.allEQs_withoutNAN));
        %     else
        %         beamAbsMaxPHR_exteriorBeams{floorNum}.MeanAllEQs       = nan;
        %         beamAbsMaxPHR_exteriorBeams{floorNum}.MinAllEQs        = nan;
        %         beamAbsMaxPHR_exteriorBeams{floorNum}.MaxAllEQs        = nan;
        %         beamAbsMaxPHR_exteriorBeams{floorNum}.StDevAllEQs      = nan;
        %         beamAbsMaxPHR_exteriorBeams{floorNum}.MedianAllEQs     = nan;
        %         beamAbsMaxPHR_exteriorBeams{floorNum}.MeanLnAllEQs     = nan;
        %         beamAbsMaxPHR_exteriorBeams{floorNum}.StDevLnAllEQs    = nan;
        %     end
        % end    
       
        % % columnAbsMaxPHR_maxAllStories
        % columnAbsMaxPHR_maxAllStories.allEQs_withoutNAN = columnAbsMaxPHR_maxAllStories.allEQs(find(~isnan(columnAbsMaxPHR_maxAllStories.allEQs)));
        % if(length(columnAbsMaxPHR_maxAllStories.allEQs_withoutNAN) > 0)
        %     columnAbsMaxPHR_maxAllStories.MeanAllEQs       = mean(columnAbsMaxPHR_maxAllStories.allEQs_withoutNAN);
        %     columnAbsMaxPHR_maxAllStories.MinAllEQs        = min(columnAbsMaxPHR_maxAllStories.allEQs_withoutNAN);
        %     columnAbsMaxPHR_maxAllStories.MaxAllEQs        = max(columnAbsMaxPHR_maxAllStories.allEQs_withoutNAN);
        %     columnAbsMaxPHR_maxAllStories.StDevAllEQs      = std(columnAbsMaxPHR_maxAllStories.allEQs_withoutNAN);
        %     columnAbsMaxPHR_maxAllStories.MedianAllEQs     = median(columnAbsMaxPHR_maxAllStories.allEQs_withoutNAN);
        %     columnAbsMaxPHR_maxAllStories.MeanLnAllEQs     = mean(log(columnAbsMaxPHR_maxAllStories.allEQs_withoutNAN));
        %     columnAbsMaxPHR_maxAllStories.StDevLnAllEQs    = std(log(columnAbsMaxPHR_maxAllStories.allEQs_withoutNAN));
        % else
        %     columnAbsMaxPHR_maxAllStories.MeanAllEQs       = nan;
        %     columnAbsMaxPHR_maxAllStories.MinAllEQs        = nan;
        %     columnAbsMaxPHR_maxAllStories.MaxAllEQs        = nan;
        %     columnAbsMaxPHR_maxAllStories.StDevAllEQs      = nan;
        %     columnAbsMaxPHR_maxAllStories.MedianAllEQs     = nan;
        %     columnAbsMaxPHR_maxAllStories.MeanLnAllEQs     = nan;
        %     columnAbsMaxPHR_maxAllStories.StDevLnAllEQs    = nan;
        % end
        
        % for storyNum = 1:numStories
        %     % columnAbsMaxPHR_allColumns
        %     columnAbsMaxPHR_allColumns{storyNum}.allEQs_withoutNAN = columnAbsMaxPHR_allColumns{storyNum}.allEQs(find(~isnan(columnAbsMaxPHR_allColumns{storyNum}.allEQs)));
        %     if(length(columnAbsMaxPHR_allColumns{storyNum}.allEQs_withoutNAN) > 0)                
        %         columnAbsMaxPHR_allColumns{storyNum}.MeanAllEQs       = mean(columnAbsMaxPHR_allColumns{storyNum}.allEQs_withoutNAN);
        %         columnAbsMaxPHR_allColumns{storyNum}.MinAllEQs        = min(columnAbsMaxPHR_allColumns{storyNum}.allEQs_withoutNAN);
        %         columnAbsMaxPHR_allColumns{storyNum}.MaxAllEQs        = max(columnAbsMaxPHR_allColumns{storyNum}.allEQs_withoutNAN);
        %         columnAbsMaxPHR_allColumns{storyNum}.StDevAllEQs      = std(columnAbsMaxPHR_allColumns{storyNum}.allEQs_withoutNAN);
        %         columnAbsMaxPHR_allColumns{storyNum}.MedianAllEQs     = median(columnAbsMaxPHR_allColumns{storyNum}.allEQs_withoutNAN);
        %         columnAbsMaxPHR_allColumns{storyNum}.MeanLnAllEQs     = mean(log(columnAbsMaxPHR_allColumns{storyNum}.allEQs_withoutNAN));
        %         columnAbsMaxPHR_allColumns{storyNum}.StDevLnAllEQs    = std(log(columnAbsMaxPHR_allColumns{storyNum}.allEQs_withoutNAN));
        %     else
        %         columnAbsMaxPHR_allColumns{storyNum}.MeanAllEQs       = nan;
        %         columnAbsMaxPHR_allColumns{storyNum}.MinAllEQs        = nan;
        %         columnAbsMaxPHR_allColumns{storyNum}.MaxAllEQs        = nan;
        %         columnAbsMaxPHR_allColumns{storyNum}.StDevAllEQs      = nan;
        %         columnAbsMaxPHR_allColumns{storyNum}.MedianAllEQs     = nan;
        %         columnAbsMaxPHR_allColumns{storyNum}.MeanLnAllEQs     = nan;
        %         columnAbsMaxPHR_allColumns{storyNum}.StDevLnAllEQs    = nan;
        %     end
        % end        
        
        % for storyNum = 1:numStories
        %     % columnAbsMaxPHR_interiorColumns
        %     columnAbsMaxPHR_interiorColumns{storyNum}.allEQs_withoutNAN = columnAbsMaxPHR_interiorColumns{storyNum}.allEQs(find(~isnan(columnAbsMaxPHR_interiorColumns{storyNum}.allEQs)));
        %     if(length(columnAbsMaxPHR_interiorColumns{storyNum}.allEQs_withoutNAN) > 0)                
        %         columnAbsMaxPHR_interiorColumns{storyNum}.MeanAllEQs       = mean(columnAbsMaxPHR_interiorColumns{storyNum}.allEQs_withoutNAN);
        %         columnAbsMaxPHR_interiorColumns{storyNum}.MinAllEQs        = min(columnAbsMaxPHR_interiorColumns{storyNum}.allEQs_withoutNAN);
        %         columnAbsMaxPHR_interiorColumns{storyNum}.MaxAllEQs        = max(columnAbsMaxPHR_interiorColumns{storyNum}.allEQs_withoutNAN);
        %         columnAbsMaxPHR_interiorColumns{storyNum}.StDevAllEQs      = std(columnAbsMaxPHR_interiorColumns{storyNum}.allEQs_withoutNAN);
        %         columnAbsMaxPHR_interiorColumns{storyNum}.MedianAllEQs     = median(columnAbsMaxPHR_interiorColumns{storyNum}.allEQs_withoutNAN);
        %         columnAbsMaxPHR_interiorColumns{storyNum}.MeanLnAllEQs     = mean(log(columnAbsMaxPHR_interiorColumns{storyNum}.allEQs_withoutNAN));
        %         columnAbsMaxPHR_interiorColumns{storyNum}.StDevLnAllEQs    = std(log(columnAbsMaxPHR_interiorColumns{storyNum}.allEQs_withoutNAN));
        %     else
        %         columnAbsMaxPHR_interiorColumns{storyNum}.MeanAllEQs       = nan;
        %         columnAbsMaxPHR_interiorColumns{storyNum}.MinAllEQs        = nan;
        %         columnAbsMaxPHR_interiorColumns{storyNum}.MaxAllEQs        = nan;
        %         columnAbsMaxPHR_interiorColumns{storyNum}.StDevAllEQs      = nan;
        %         columnAbsMaxPHR_interiorColumns{storyNum}.MedianAllEQs     = nan;
        %         columnAbsMaxPHR_interiorColumns{storyNum}.MeanLnAllEQs     = nan;
        %         columnAbsMaxPHR_interiorColumns{storyNum}.StDevLnAllEQs    = nan;
        %     end
        % end   
        
        % for storyNum = 1:numStories
        %     % columnAbsMaxPHR_exteriorColumns
        %     columnAbsMaxPHR_exteriorColumns{storyNum}.allEQs_withoutNAN = columnAbsMaxPHR_exteriorColumns{storyNum}.allEQs(find(~isnan(columnAbsMaxPHR_exteriorColumns{storyNum}.allEQs)));
        %     if(length(columnAbsMaxPHR_exteriorColumns{storyNum}.allEQs_withoutNAN) > 0)                
        %         columnAbsMaxPHR_exteriorColumns{storyNum}.MeanAllEQs       = mean(columnAbsMaxPHR_exteriorColumns{storyNum}.allEQs_withoutNAN);
        %         columnAbsMaxPHR_exteriorColumns{storyNum}.MinAllEQs        = min(columnAbsMaxPHR_exteriorColumns{storyNum}.allEQs_withoutNAN);
        %         columnAbsMaxPHR_exteriorColumns{storyNum}.MaxAllEQs        = max(columnAbsMaxPHR_exteriorColumns{storyNum}.allEQs_withoutNAN);
        %         columnAbsMaxPHR_exteriorColumns{storyNum}.StDevAllEQs      = std(columnAbsMaxPHR_exteriorColumns{storyNum}.allEQs_withoutNAN);
        %         columnAbsMaxPHR_exteriorColumns{storyNum}.MedianAllEQs     = median(columnAbsMaxPHR_exteriorColumns{storyNum}.allEQs_withoutNAN);
        %         columnAbsMaxPHR_exteriorColumns{storyNum}.MeanLnAllEQs     = mean(log(columnAbsMaxPHR_exteriorColumns{storyNum}.allEQs_withoutNAN));
        %         columnAbsMaxPHR_exteriorColumns{storyNum}.StDevLnAllEQs    = std(log(columnAbsMaxPHR_exteriorColumns{storyNum}.allEQs_withoutNAN));
        %     else
        %         columnAbsMaxPHR_exteriorColumns{storyNum}.MeanAllEQs       = nan;
        %         columnAbsMaxPHR_exteriorColumns{storyNum}.MinAllEQs        = nan;
        %         columnAbsMaxPHR_exteriorColumns{storyNum}.MaxAllEQs        = nan;
        %         columnAbsMaxPHR_exteriorColumns{storyNum}.StDevAllEQs      = nan;
        %         columnAbsMaxPHR_exteriorColumns{storyNum}.MedianAllEQs     = nan;
        %         columnAbsMaxPHR_exteriorColumns{storyNum}.MeanLnAllEQs     = nan;
        %         columnAbsMaxPHR_exteriorColumns{storyNum}.StDevLnAllEQs    = nan;
        %     end
        % end
        
        % % jointShearDistortionAbsMax_maxAllFloors
        % jointShearDistortionAbsMax_maxAllFloors.allEQs_withoutNAN = jointShearDistortionAbsMax_maxAllFloors.allEQs(find(~isnan(jointShearDistortionAbsMax_maxAllFloors.allEQs)));
        % if(length(jointShearDistortionAbsMax_maxAllFloors.allEQs_withoutNAN) > 0)
        %     jointShearDistortionAbsMax_maxAllFloors.MeanAllEQs       = mean(jointShearDistortionAbsMax_maxAllFloors.allEQs_withoutNAN);
        %     jointShearDistortionAbsMax_maxAllFloors.MinAllEQs        = min(jointShearDistortionAbsMax_maxAllFloors.allEQs_withoutNAN);
        %     jointShearDistortionAbsMax_maxAllFloors.MaxAllEQs        = max(jointShearDistortionAbsMax_maxAllFloors.allEQs_withoutNAN);
        %     jointShearDistortionAbsMax_maxAllFloors.StDevAllEQs      = std(jointShearDistortionAbsMax_maxAllFloors.allEQs_withoutNAN);
        %     jointShearDistortionAbsMax_maxAllFloors.MedianAllEQs     = median(jointShearDistortionAbsMax_maxAllFloors.allEQs_withoutNAN);
        %     jointShearDistortionAbsMax_maxAllFloors.MeanLnAllEQs     = mean(log(jointShearDistortionAbsMax_maxAllFloors.allEQs_withoutNAN));
        %     jointShearDistortionAbsMax_maxAllFloors.StDevLnAllEQs    = std(log(jointShearDistortionAbsMax_maxAllFloors.allEQs_withoutNAN));
        % else
        %     jointShearDistortionAbsMax_maxAllFloors.MeanAllEQs       = nan;
        %     jointShearDistortionAbsMax_maxAllFloors.MinAllEQs        = nan;
        %     jointShearDistortionAbsMax_maxAllFloors.MaxAllEQs        = nan;
        %     jointShearDistortionAbsMax_maxAllFloors.StDevAllEQs      = nan;
        %     jointShearDistortionAbsMax_maxAllFloors.MedianAllEQs     = nan;
        %     jointShearDistortionAbsMax_maxAllFloors.MeanLnAllEQs     = nan;
        %     jointShearDistortionAbsMax_maxAllFloors.StDevLnAllEQs    = nan;
        % end
        
        % for floorNum = 2:numFloors
        %     % jointShearDistortionAbsMax_allJoints
        %     jointShearDistortionAbsMax_allJoints{floorNum}.allEQs_withoutNAN = jointShearDistortionAbsMax_allJoints{floorNum}.allEQs(find(~isnan(jointShearDistortionAbsMax_allJoints{floorNum}.allEQs)));
        %     if(length(jointShearDistortionAbsMax_allJoints{floorNum}.allEQs_withoutNAN) > 0)
        %         jointShearDistortionAbsMax_allJoints{floorNum}.MeanAllEQs       = mean(jointShearDistortionAbsMax_allJoints{floorNum}.allEQs_withoutNAN);
        %         jointShearDistortionAbsMax_allJoints{floorNum}.MinAllEQs        = min(jointShearDistortionAbsMax_allJoints{floorNum}.allEQs_withoutNAN);
        %         jointShearDistortionAbsMax_allJoints{floorNum}.MaxAllEQs        = max(jointShearDistortionAbsMax_allJoints{floorNum}.allEQs_withoutNAN);
        %         jointShearDistortionAbsMax_allJoints{floorNum}.StDevAllEQs      = std(jointShearDistortionAbsMax_allJoints{floorNum}.allEQs_withoutNAN);
        %         jointShearDistortionAbsMax_allJoints{floorNum}.MedianAllEQs     = median(jointShearDistortionAbsMax_allJoints{floorNum}.allEQs_withoutNAN);
        %         jointShearDistortionAbsMax_allJoints{floorNum}.MeanLnAllEQs     = mean(log(jointShearDistortionAbsMax_allJoints{floorNum}.allEQs_withoutNAN));
        %         jointShearDistortionAbsMax_allJoints{floorNum}.StDevLnAllEQs    = std(log(jointShearDistortionAbsMax_allJoints{floorNum}.allEQs_withoutNAN));
        %     else
        %         jointShearDistortionAbsMax_allJoints{floorNum}.MeanAllEQs       = nan;
        %         jointShearDistortionAbsMax_allJoints{floorNum}.MinAllEQs        = nan;
        %         jointShearDistortionAbsMax_allJoints{floorNum}.MaxAllEQs        = nan;
        %         jointShearDistortionAbsMax_allJoints{floorNum}.StDevAllEQs      = nan;
        %         jointShearDistortionAbsMax_allJoints{floorNum}.MedianAllEQs     = nan;
        %         jointShearDistortionAbsMax_allJoints{floorNum}.MeanLnAllEQs     = nan;
        %         jointShearDistortionAbsMax_allJoints{floorNum}.StDevLnAllEQs    = nan;
        %     end
        % end    
        
        % for floorNum = 2:numFloors
        %     % jointShearDistortionAbsMax_interiorJoints
        %     jointShearDistortionAbsMax_interiorJoints{floorNum}.allEQs_withoutNAN = jointShearDistortionAbsMax_interiorJoints{floorNum}.allEQs(find(~isnan(jointShearDistortionAbsMax_interiorJoints{floorNum}.allEQs)));
        %     if(length(jointShearDistortionAbsMax_interiorJoints{floorNum}.allEQs_withoutNAN) > 0)
        %         jointShearDistortionAbsMax_interiorJoints{floorNum}.MeanAllEQs       = mean(jointShearDistortionAbsMax_interiorJoints{floorNum}.allEQs_withoutNAN);
        %         jointShearDistortionAbsMax_interiorJoints{floorNum}.MinAllEQs        = min(jointShearDistortionAbsMax_interiorJoints{floorNum}.allEQs_withoutNAN);
        %         jointShearDistortionAbsMax_interiorJoints{floorNum}.MaxAllEQs        = max(jointShearDistortionAbsMax_interiorJoints{floorNum}.allEQs_withoutNAN);
        %         jointShearDistortionAbsMax_interiorJoints{floorNum}.StDevAllEQs      = std(jointShearDistortionAbsMax_interiorJoints{floorNum}.allEQs_withoutNAN);
        %         jointShearDistortionAbsMax_interiorJoints{floorNum}.MedianAllEQs     = median(jointShearDistortionAbsMax_interiorJoints{floorNum}.allEQs_withoutNAN);
        %         jointShearDistortionAbsMax_interiorJoints{floorNum}.MeanLnAllEQs     = mean(log(jointShearDistortionAbsMax_interiorJoints{floorNum}.allEQs_withoutNAN));
        %         jointShearDistortionAbsMax_interiorJoints{floorNum}.StDevLnAllEQs    = std(log(jointShearDistortionAbsMax_interiorJoints{floorNum}.allEQs_withoutNAN));
        %     else
        %         jointShearDistortionAbsMax_interiorJoints{floorNum}.MeanAllEQs       = nan;
        %         jointShearDistortionAbsMax_interiorJoints{floorNum}.MinAllEQs        = nan;
        %         jointShearDistortionAbsMax_interiorJoints{floorNum}.MaxAllEQs        = nan;
        %         jointShearDistortionAbsMax_interiorJoints{floorNum}.StDevAllEQs      = nan;
        %         jointShearDistortionAbsMax_interiorJoints{floorNum}.MedianAllEQs     = nan;
        %         jointShearDistortionAbsMax_interiorJoints{floorNum}.MeanLnAllEQs     = nan;
        %         jointShearDistortionAbsMax_interiorJoints{floorNum}.StDevLnAllEQs    = nan;
        %     end
        % end    
        
        % for floorNum = 2:numFloors
        %     % jointShearDistortionAbsMax_exteriorJoints
        %     jointShearDistortionAbsMax_exteriorJoints{floorNum}.allEQs_withoutNAN = jointShearDistortionAbsMax_exteriorJoints{floorNum}.allEQs(find(~isnan(jointShearDistortionAbsMax_exteriorJoints{floorNum}.allEQs)));
        %     if(length(jointShearDistortionAbsMax_exteriorJoints{floorNum}.allEQs_withoutNAN) > 0)
        %         jointShearDistortionAbsMax_exteriorJoints{floorNum}.MeanAllEQs       = mean(jointShearDistortionAbsMax_exteriorJoints{floorNum}.allEQs_withoutNAN);
        %         jointShearDistortionAbsMax_exteriorJoints{floorNum}.MinAllEQs        = min(jointShearDistortionAbsMax_exteriorJoints{floorNum}.allEQs_withoutNAN);
        %         jointShearDistortionAbsMax_exteriorJoints{floorNum}.MaxAllEQs        = max(jointShearDistortionAbsMax_exteriorJoints{floorNum}.allEQs_withoutNAN);
        %         jointShearDistortionAbsMax_exteriorJoints{floorNum}.StDevAllEQs      = std(jointShearDistortionAbsMax_exteriorJoints{floorNum}.allEQs_withoutNAN);
        %         jointShearDistortionAbsMax_exteriorJoints{floorNum}.MedianAllEQs     = median(jointShearDistortionAbsMax_exteriorJoints{floorNum}.allEQs_withoutNAN);
        %         jointShearDistortionAbsMax_exteriorJoints{floorNum}.MeanLnAllEQs     = mean(log(jointShearDistortionAbsMax_exteriorJoints{floorNum}.allEQs_withoutNAN));
        %         jointShearDistortionAbsMax_exteriorJoints{floorNum}.StDevLnAllEQs    = std(log(jointShearDistortionAbsMax_exteriorJoints{floorNum}.allEQs_withoutNAN));
        %     else
        %         jointShearDistortionAbsMax_exteriorJoints{floorNum}.MeanAllEQs       = nan;
        %         jointShearDistortionAbsMax_exteriorJoints{floorNum}.MinAllEQs        = nan;
        %         jointShearDistortionAbsMax_exteriorJoints{floorNum}.MaxAllEQs        = nan;
        %         jointShearDistortionAbsMax_exteriorJoints{floorNum}.StDevAllEQs      = nan;
        %         jointShearDistortionAbsMax_exteriorJoints{floorNum}.MedianAllEQs     = nan;
        %         jointShearDistortionAbsMax_exteriorJoints{floorNum}.MeanLnAllEQs     = nan;
        %         jointShearDistortionAbsMax_exteriorJoints{floorNum}.StDevLnAllEQs    = nan;
        %     end
        % end      
        
        % IsCollapsed - mean so we see how many collapsed.
        % isCollapsed_mean = mean(isCollapsed_allEQs);
        
    % Make a table of stripe results in the format of what Profesor
    % Miranda's loss analyses need.  Loop over all the EQs and EDPs...
    % for eqIndex = 1:length(eqNumberLIST_forStripes)
    %     eqNumber = eqNumberLIST_forStripes(eqIndex);
    %     % Place the Sa level and the EQ number in results matrix
    %     stripeResultsTableForAllEQs(eqIndex, 1) = saLevelForCurrentStripe;
    %     stripeResultsTableForAllEQs(eqIndex, 2) = eqNumber;
    %     % Place the EDPs into the matrix
    %     EDPIndex = 3;   % Row of results matrix
    %         % RDR_max 
    %         stripeResultsTableForAllEQs(eqIndex, EDPIndex) = RDR_max.allEQs(eqIndex);
    %         EDPIndex = EDPIndex + 1;        
    %         % IDR_max
    %         for storyNum = 1:numStories
    %             stripeResultsTableForAllEQs(eqIndex, EDPIndex) = IDR_max{storyNum}.allEQs(eqIndex);
    %             EDPIndex = EDPIndex + 1;
    %         end     
    %         % RDR_absResidual 
    %         stripeResultsTableForAllEQs(eqIndex, EDPIndex) = RDR_absResidual.allEQs(eqIndex);
    %         EDPIndex = EDPIndex + 1;  
    %         % IDR_residual
    %         for storyNum = 1:numStories
    %             stripeResultsTableForAllEQs(eqIndex, EDPIndex) = IDR_residual{storyNum}.allEQs(eqIndex);
    %             EDPIndex = EDPIndex + 1;
    %         end   
    %         % PGAToSave [g]
    %         stripeResultsTableForAllEQs(eqIndex, EDPIndex) = PGAToSave.allEQs(eqIndex);
    %         EDPIndex = EDPIndex + 1;
    %         % PFA [g]
    %         for floorNum = 2:numFloors
    %             stripeResultsTableForAllEQs(eqIndex, EDPIndex) = PFA{floorNum}.allEQs(eqIndex);
    %             EDPIndex = EDPIndex + 1;
    %         end  
    %         % beamAbsMaxPHR_allBeams [rad]
    %         for floorNum = 2:numFloors
    %             stripeResultsTableForAllEQs(eqIndex, EDPIndex) = beamAbsMaxPHR_allBeams{floorNum}.allEQs(eqIndex);
    %             EDPIndex = EDPIndex + 1;
    %         end  
    %         % beamAbsMaxPHR_interiorBeams [rad]
    %         for floorNum = 2:numFloors
    %             stripeResultsTableForAllEQs(eqIndex, EDPIndex) = beamAbsMaxPHR_interiorBeams{floorNum}.allEQs(eqIndex);
    %             EDPIndex = EDPIndex + 1;
    %         end  
    %         % beamAbsMaxPHR_exteriorBeams [rad]
    %         for floorNum = 2:numFloors
    %             stripeResultsTableForAllEQs(eqIndex, EDPIndex) = beamAbsMaxPHR_exteriorBeams{floorNum}.allEQs(eqIndex);
    %             EDPIndex = EDPIndex + 1;
    %         end  
    %         % columnAbsMaxPHR_allColumns [rad]
    %         for storyNum = 1:numStories
    %             stripeResultsTableForAllEQs(eqIndex, EDPIndex) = columnAbsMaxPHR_allColumns{storyNum}.allEQs(eqIndex);
    %             EDPIndex = EDPIndex + 1;
    %         end   
    %         % columnAbsMaxPHR_interiorColumns [rad]
    %         for storyNum = 1:numStories
    %             stripeResultsTableForAllEQs(eqIndex, EDPIndex) = columnAbsMaxPHR_interiorColumns{storyNum}.allEQs(eqIndex);
    %             EDPIndex = EDPIndex + 1;
    %         end          
    %         % columnAbsMaxPHR_exteriorColumns [rad]
    %         for storyNum = 1:numStories
    %             stripeResultsTableForAllEQs(eqIndex, EDPIndex) = columnAbsMaxPHR_exteriorColumns{storyNum}.allEQs(eqIndex);
    %             EDPIndex = EDPIndex + 1;
    %         end   
    %         % jointShearDistortionAbsMax_allJoints [units?]
    %         for floorNum = 2:numFloors
    %             stripeResultsTableForAllEQs(eqIndex, EDPIndex) = jointShearDistortionAbsMax_allJoints{floorNum}.allEQs(eqIndex);
    %             EDPIndex = EDPIndex + 1;
    %         end     
    %         % jointShearDistortionAbsMax_interiorJoints [units?]
    %         for floorNum = 2:numFloors
    %             stripeResultsTableForAllEQs(eqIndex, EDPIndex) = jointShearDistortionAbsMax_interiorJoints{floorNum}.allEQs(eqIndex);
    %             EDPIndex = EDPIndex + 1;
    %         end   
    %         % jointShearDistortionAbsMax_exteriorJoints [units?]
    %         for floorNum = 2:numFloors
    %             stripeResultsTableForAllEQs(eqIndex, EDPIndex) = jointShearDistortionAbsMax_exteriorJoints{floorNum}.allEQs(eqIndex);
    %             EDPIndex = EDPIndex + 1;
    %         end               
    %         % IsNonConverged
    %         stripeResultsTableForAllEQs(eqIndex, EDPIndex) = isNonConverged_allEQs(eqIndex);
    %         EDPIndex = EDPIndex + 1;
    %         % IsCollapsed
    %         stripeResultsTableForAllEQs(eqIndex, EDPIndex) = isCollapsed_allEQs(eqIndex);
    %         EDPIndex = EDPIndex + 1;
    % 
    % end; % end of loop to make table of all EDP results
    % 
    
    % Make a table of results for what Kircher wants
        % EDPIndex = 1;
        % stripeResultsTableSummaryStats(EDPIndex,1) = saLevelForCurrentStripe;
        % EDPIndex = EDPIndex + 1;
        % % RDR_max
        %     stripeResultsTableSummaryStats(1,EDPIndex) = RDR_max.MeanLnAllEQs;
        %     EDPIndex = EDPIndex + 1;            
        %     stripeResultsTableSummaryStats(1,EDPIndex) = RDR_max.StDevLnAllEQs;
        %     EDPIndex = EDPIndex + 1;         
        % % IDR_max
        %     for storyNum = 1:numStories
        %         stripeResultsTableSummaryStats(1,EDPIndex) = IDR_max{storyNum}.MeanLnAllEQs;
        %         EDPIndex = EDPIndex + 1;            
        %         stripeResultsTableSummaryStats(1,EDPIndex) = IDR_max{storyNum}.StDevLnAllEQs;
        %         EDPIndex = EDPIndex + 1;            
        %     end       
        % % RDR_absResidual
        %     stripeResultsTableSummaryStats(1,EDPIndex) = RDR_absResidual.MeanLnAllEQs;
        %     EDPIndex = EDPIndex + 1;            
        %     stripeResultsTableSummaryStats(1,EDPIndex) = RDR_absResidual.StDevLnAllEQs;
        %     EDPIndex = EDPIndex + 1;   
        % % IDR_residual
        %     for storyNum = 1:numStories
        %         stripeResultsTableSummaryStats(1,EDPIndex) = IDR_residual{storyNum}.MeanLnAllEQs;
        %         EDPIndex = EDPIndex + 1;            
        %         stripeResultsTableSummaryStats(1,EDPIndex) = IDR_residual{storyNum}.StDevLnAllEQs;
        %         EDPIndex = EDPIndex + 1;            
        %     end          
        % % PGAToSave [g]  
        %     stripeResultsTableSummaryStats(1,EDPIndex) = PGAToSave.MeanLnAllEQs;
        %     EDPIndex = EDPIndex + 1;    
        %     stripeResultsTableSummaryStats(1,EDPIndex) = PGAToSave.StDevLnAllEQs;
        %     EDPIndex = EDPIndex + 1;    
        % % PFA [g]
        %     for floorNum = 2:numFloors 
        %         stripeResultsTableSummaryStats(1,EDPIndex) = PFA{floorNum}.MeanLnAllEQs;
        %         EDPIndex = EDPIndex + 1;    
        %         stripeResultsTableSummaryStats(1,EDPIndex) = PFA{floorNum}.StDevLnAllEQs;
        %         EDPIndex = EDPIndex + 1;    
        %     end     
        % % beamAbsMaxPHR_allBeams [rad]
        %     for floorNum = 2:numFloors  
        %         stripeResultsTableSummaryStats(1,EDPIndex) = beamAbsMaxPHR_allBeams{floorNum}.MeanLnAllEQs;
        %         EDPIndex = EDPIndex + 1;    
        %         stripeResultsTableSummaryStats(1,EDPIndex) = beamAbsMaxPHR_allBeams{floorNum}.StDevLnAllEQs;
        %         EDPIndex = EDPIndex + 1;    
        %     end          
        % % beamAbsMaxPHR_interiorBeams [rad]
        %     for floorNum = 2:numFloors  
        %         stripeResultsTableSummaryStats(1,EDPIndex) = beamAbsMaxPHR_interiorBeams{floorNum}.MeanLnAllEQs;
        %         EDPIndex = EDPIndex + 1;    
        %         stripeResultsTableSummaryStats(1,EDPIndex) = beamAbsMaxPHR_interiorBeams{floorNum}.StDevLnAllEQs;
        %         EDPIndex = EDPIndex + 1;    
        %     end    
        % % beamAbsMaxPHR_exteriorBeams [rad]
        %     for floorNum = 2:numFloors  
        %         stripeResultsTableSummaryStats(1,EDPIndex) = beamAbsMaxPHR_exteriorBeams{floorNum}.MeanLnAllEQs;
        %         EDPIndex = EDPIndex + 1;    
        %         stripeResultsTableSummaryStats(1,EDPIndex) = beamAbsMaxPHR_exteriorBeams{floorNum}.StDevLnAllEQs;
        %         EDPIndex = EDPIndex + 1;    
        %     end 
        % % columnAbsMaxPHR_allColumns [rad]
        %     for storyNum = 1:numStories
        %         stripeResultsTableSummaryStats(1,EDPIndex) = columnAbsMaxPHR_allColumns{storyNum}.MeanLnAllEQs;
        %         EDPIndex = EDPIndex + 1;            
        %         stripeResultsTableSummaryStats(1,EDPIndex) = columnAbsMaxPHR_allColumns{storyNum}.StDevLnAllEQs;
        %         EDPIndex = EDPIndex + 1;            
        %     end    
        % % columnAbsMaxPHR_interiorColumns [rad]
        %     for storyNum = 1:numStories
        %         stripeResultsTableSummaryStats(1,EDPIndex) = columnAbsMaxPHR_interiorColumns{storyNum}.MeanLnAllEQs;
        %         EDPIndex = EDPIndex + 1;            
        %         stripeResultsTableSummaryStats(1,EDPIndex) = columnAbsMaxPHR_interiorColumns{storyNum}.StDevLnAllEQs;
        %         EDPIndex = EDPIndex + 1;            
        %     end       
        % % columnAbsMaxPHR_exteriorColumns [rad]
        %     for storyNum = 1:numStories
        %         stripeResultsTableSummaryStats(1,EDPIndex) = columnAbsMaxPHR_exteriorColumns{storyNum}.MeanLnAllEQs;
        %         EDPIndex = EDPIndex + 1;            
        %         stripeResultsTableSummaryStats(1,EDPIndex) = columnAbsMaxPHR_exteriorColumns{storyNum}.StDevLnAllEQs;
        %         EDPIndex = EDPIndex + 1;            
        %     end    
        % % jointShearDistortionAbsMax_allJoints [units?]
        %     for floorNum = 2:numFloors 
        %         stripeResultsTableSummaryStats(1,EDPIndex) = jointShearDistortionAbsMax_allJoints{floorNum}.MeanLnAllEQs;
        %         EDPIndex = EDPIndex + 1;    
        %         stripeResultsTableSummaryStats(1,EDPIndex) = jointShearDistortionAbsMax_allJoints{floorNum}.StDevLnAllEQs;
        %         EDPIndex = EDPIndex + 1;    
        %     end               
        % % jointShearDistortionAbsMax_interiorJoints [units?]
        %     for floorNum = 2:numFloors 
        %         stripeResultsTableSummaryStats(1,EDPIndex) = jointShearDistortionAbsMax_interiorJoints{floorNum}.MeanLnAllEQs;
        %         EDPIndex = EDPIndex + 1;    
        %         stripeResultsTableSummaryStats(1,EDPIndex) = jointShearDistortionAbsMax_interiorJoints{floorNum}.StDevLnAllEQs;
        %         EDPIndex = EDPIndex + 1;    
        %     end       
        % % jointShearDistortionAbsMax_exteriorJoints [units?]
        %     for floorNum = 2:numFloors 
        %         stripeResultsTableSummaryStats(1,EDPIndex) = jointShearDistortionAbsMax_exteriorJoints{floorNum}.MeanLnAllEQs;
        %         EDPIndex = EDPIndex + 1;    
        %         stripeResultsTableSummaryStats(1,EDPIndex) = jointShearDistortionAbsMax_exteriorJoints{floorNum}.StDevLnAllEQs;
        %         EDPIndex = EDPIndex + 1;    
        %     end   
        % 
        % % IsCollapsed - mean
        %     stripeResultsTableSummaryStats(1,EDPIndex) = isCollapsed_mean;
        %     EDPIndex = EDPIndex + 1;    
    
        end 

    % Save file for this stripe - say that the Sa is Sa_geoMean 
    if(isConvertToSaKircher == 0)
        fileNameForThisStripe = sprintf('DATA_stripe_SaGeoMean_%s_Sa_%.2f.mat', eqListForCollapseIDAs_Name, saLevelForCurrentStripe);
    else
        fileNameForThisStripe = sprintf('DATA_stripe_SaATC63_%s_Sa_%.2f.mat', eqListForCollapseIDAs_Name, saLevelForCurrentStripe);
    end
         
        save(fileNameForThisStripe, 'analysisType', 'eqNumberLIST_forStripes', 'eqListForCollapseIDAs_Name', 'periodUsedForScalingGroundMotionsFromMatlab', 'numFloors', 'numStories',...
            'saLevelForCurrentStripe', 'isCollapsed_allEQs', 'isCollapsed_mean', 'isNonConverged_allEQs', 'saLevel_belowStripe',...
            'saLevel_aboveStripe', 'ratioForInterp', 'IDR_max', 'IDR_residual', 'IDR_maxAllStories', 'PGAToSave', 'PFA',...
            'stripeResultsTableForAllEQs', 'stripeResultsTableSummaryStats',...
            'RDR_max', 'RDR_absResidual', 'IDR_residual_maxAllStories',...
            'beamAbsMaxPHR_allBeams', 'beamAbsMaxPHR_interiorBeams', 'beamAbsMaxPHR_exteriorBeams', 'beamAbsMaxPHR_maxAllFloors',...
            'columnAbsMaxPHR_allColumns', 'columnAbsMaxPHR_interiorColumns', 'columnAbsMaxPHR_exteriorColumns', 'columnAbsMaxPHR_maxAllStories',... 
            'jointShearDistortionAbsMax_allJoints', 'jointShearDistortionAbsMax_interiorJoints', 'jointShearDistortionAbsMax_exteriorJoints',...
            'jointShearDistortionAbsMax_maxAllFloors');

    end 
    % Save the results for this stripe variables of results for all stripes
    % (these are saved into a file after this loop).  Save only the information for the output tables; leave all the detailed informatio in the individual stripe files.
        % Save the larger EDP table
            % Compute the size of the mattrix to place
            sizeOfMatrixToPlace = size(stripeResultsTableForAllEQs);
            currentNumCols = sizeOfMatrixToPlace(2);
            currentNumRows = sizeOfMatrixToPlace(1);
            currentEndRowInStripeEDPResultsFullTable = currentStartRowInStripeEDPResultsFullTable + currentNumRows - 1;
            % Place the matrix
            stripeResultsTableForAllEQs_allStripes(currentStartRowInStripeEDPResultsFullTable:currentEndRowInStripeEDPResultsFullTable, 1:currentNumCols) = stripeResultsTableForAllEQs;
            % Update the current start column for the next loop
            currentStartRowInStripeEDPResultsFullTable = currentEndRowInStripeEDPResultsFullTable + 1;
        
        % Save the summary EDP table
            % Compute the size of the mattrix to place - this is always a
            % vector
            sizeOfMatrixToPlace = size(stripeResultsTableSummaryStats);
            currentNumCols = sizeOfMatrixToPlace(2);
            % Place the matrix
            stripeResultsTableSummaryStats_allStripes(currentStartRowInStripeEDPResultsSummaryTable, :) = stripeResultsTableSummaryStats;
            % Update the current start column for the next loop
            currentStartRowInStripeEDPResultsSummaryTable = currentStartRowInStripeEDPResultsSummaryTable + 1;        
            
      end    % end of Sa loop

% Save the file for all the stripes
    if(isConvertToSaKircher == 0 & isConvertToSaComponent == 0)
        fileNameForThisStripe = sprintf('DATA_stripe_SaGeoMean_%s_Sa_SummaryForAllStripes.mat', eqListForCollapseIDAs_Name);
    elseif(isConvertToSaKircher == 1 & isConvertToSaComponent == 0)
        fileNameForThisStripe = sprintf('DATA_stripe_SaATC63_%s_Sa_SummaryForAllStripes.mat', eqListForCollapseIDAs_Name);
    elseif(isConvertToSaKircher == 0 & isConvertToSaComponent == 1)
        fileNameForThisStripe = sprintf('DATA_stripe_SaComp_%s_Sa_SummaryForAllStripes.mat', eqListForCollapseIDAs_Name);
    else
        error('ERROR: Invalid type for Sa');    
    end
     
    % save(fileNameForThisStripe, 'analysisType', 'eqNumberLIST_forStripes', 'eqListForCollapseIDAs_Name', 'periodUsedForScalingGroundMotionsFromMatlab', 'numFloors', 'numStories',...
    % 'saLevelsForStripes', 'stripeResultsTableForAllEQs_allStripes', 'stripeResultsTableSummaryStats_allStripes');

    save(fileNameForThisStripe, 'analysisType', 'eqNumberLIST_forStripes', 'eqListForCollapseIDAs_Name', 'periodUsedForScalingGroundMotionsFromMatlab',...
        'saLevelsForStripes', 'stripeResultsTableForAllEQs_allStripes', 'stripeResultsTableSummaryStats_allStripes');

% Go back to starting folder
cd(startFolder);

disp('Stripe processing completed!');





