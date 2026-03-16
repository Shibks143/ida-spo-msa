%
% Procedure:  Driver_CreateFileOfStripeResponseResults.m
% -------------------
% This procedure runs for a single model and loops for sets of EQs and creates files of
% stripe analysis results.  Before this is run, the individual stripe must be processed with the stripe processor (the
% one that make the stripe statistic files).
%
%   THIS WAS MODIFIED from the similar IDACollapse processor, so some
%   variables may have changed from the below values.
%
% DATA:
%   EDPs included in the file:
%       - IDRmax or all stories
%       - IDRresidual or all stories   
%       - PGA
%       - PFA (absolute acceleration) of all floors
%
%   Format of complete results matrix (allIDAResultsMatrix):
%       - Columns - Each column is for a different earthquake/Sa-level pair
%       - Rows (in order); number of rows = (6 + 2*numStories + 2*numFloors):
%           - SaLevel of analysis (scaled Sa)
%           - eqNum
%           - NOT USED YET - scale factor for record
%           - NOT USED - floor displacements of all floors (floor 2 to roof)
%           - IDRmax for all stories (1:numStories)
%           - IDRresidual for all stories (1:numStories)
%           - PGA
%           - PFA (absolute acceleration) of all floors (1:numFloors)
%           - NOT YET USED - isCollapsed - an indicator to show if this record resulted in
%           collapse (0 or 1)
%           - isNonConverged - an indicator to show if this analysis is 
%               nonconverged; not than any record that causes collapse has 
%               nonConverged = 1  This is just included to be sure that I am 
%               processing the data correctly and removing these results.
%               (0 or 1)
%
%       - Rows: one row for a single EDP type (note that one row includes
%       results for many EQ/Sa pairs)
%
%   NOT USED NOW - Format of simplified collapse capacity matrix (collapseSaLevelsMatrix):
%       - One column for EQnumber, and one column for collapse Sa level (in
%       g)
%
% Assumptions and Notices: none
%
% Author: Curt Haselton
% Affiliation: Stanford University PhD candidate, member of ATC-63 NLD working group 
% Date Written: 5-11-04; modified for stripes on 6-23/26-06
%
% Units: 
%   - floor displacements in inches
%   - IDR in drift ratio
%   - PGA and PFA in g
%   - Sa in g
%
% -------------------
clear

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Input the model and earthquakes to create the file for, the
% filenames to use and information about the structural model (this part
% could be automated better)

    % Input g - this is used to convert the PFA from the model units
    % (inches and kips) to g units
    g = 386.4;

    % Input the model to use (including the variable value for sensitivity)
    %analysisType = '(DesA_Buffalo_v.9noGFrm)_(AllVar)_(0.00)_(clough)';
    %analysisType = '(DesWA_ATC63_v.26)_(AllVar)_(0.00)_(nonlinearBeamColumn)';
    analysisType = '(DesID1_v.65)_(AllVar)_(Mean)_(nonlinearBeamColumn)';

    % Define the prefix used on the stripe files
        stripeFilePrefix = 'DATA_stripe_Bin5A_Sa_';
        
    % Make a name of the results file
        nameOfFileWithFullResults = sprintf('StripeAnalysisResults_%s_Bin5AForAllStripes.mat', analysisType);
        
    % Input the stripe levels to output data for - this uses the stripe levels and outputs the EQs already processed for that stripe.
        % PEER Benchmark stripes 
        saLevelsForStripesLIST = [0.26, 0.19, 0.10, 0.82, 0.55, 0.44, 0.30, 1.20];        
        
    % Structural model information - IS THIS USED???
        %numStories = 4;         
        %minFloorNum = 2;
        %maxFloorNum = numStories + 1;  % (In the .mat results files, the first above ground floor in numbered floor 2)
        
    % Sometimes an ealier processor leaves a large Sa value in the
    %   file above the collapse point, so put a threshold for which to
    %   filter out these useless values
    %    maxSaToConsiderAnError = 15.0;
        
    % File names
        %nameOfFileWithFullResults = sprintf('IDA_Collapse_ForBuffalo_AllResults_%s.mat', analysisType);
        %nameOfFileWithOnlyCollapseCapResults = sprintf('IDA_Collapse_ForBaker_OnlyColSa_%s.mat', analysisType);
    
            
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Loop through all of the stripe levels, open the results files, then save
% the data for that stripe.

    % Go into the folder for the model
        cd ..;
        cd Output;
        % Convert the folder name to string b/c the cell data type won't work to open folders (just converting type)
        analysisTypeFolder = sprintf('%s', analysisType)
        cd(analysisTypeFolder);

    % Loop through all the stripes and save the data for each.
    currentStartColumnNumInResultsMatrix = 1;
    for stripeIndex = 1:length(saLevelsForStripesLIST)
        saLevelForCurrentStripe = saLevelsForStripesLIST(stripeIndex);
        
        % Create the file name and open the results file for this stripe
        stripeFileName = sprintf('%s%.2f.mat', stripeFilePrefix, saLevelForCurrentStripe)
        load(stripeFileName, 'maxStoryDriftRatio', 'residualStoryDriftRatioAbsVal', 'eqNumberLISTToSave', 'peakGroundAccel', 'maxFloorAccel', 'isAnalysisConv');   
        numEQsInThisStripe = length(eqNumberLISTToSave);
        
        % Compute come information from the opened file
        numStories = length(maxStoryDriftRatio);         
        minFloorNum = 2;    % (In the .mat results files, the first above ground floor in numbered floor 2)
        maxFloorNum = numStories + 1;  
        
        % Save the results into the results matrix
            currentRowNumInMatrix = 1;
            startColNum = currentStartColumnNumInResultsMatrix;
            endColNum = currentStartColumnNumInResultsMatrix + numEQsInThisStripe - 1;
            
            % Save the Sa level
            allIDAResultsMatrix(currentRowNumInMatrix, startColNum:endColNum) = saLevelForCurrentStripe * ones(1, numEQsInThisStripe);
            currentRowNumInMatrix = currentRowNumInMatrix + 1;
        
            % Save the EQ Numbers
            allIDAResultsMatrix(currentRowNumInMatrix, startColNum:endColNum) = eqNumberLISTToSave';        
            currentRowNumInMatrix = currentRowNumInMatrix + 1;
                
            % Save the max(IDR) values
            for storyNum = 1:numStories
                allIDAResultsMatrix(currentRowNumInMatrix, startColNum:endColNum) = maxStoryDriftRatio{storyNum}.allEQs';
                currentRowNumInMatrix = currentRowNumInMatrix + 1;
            end
                
            % Save the resdidual(IDR) values
            for storyNum = 1:numStories
                allIDAResultsMatrix(currentRowNumInMatrix, startColNum:endColNum) = residualStoryDriftRatioAbsVal{storyNum}.allEQs';
                currentRowNumInMatrix = currentRowNumInMatrix + 1;
            end
                
            % Save the PGA (this is already in G units
                allIDAResultsMatrix(currentRowNumInMatrix, startColNum:endColNum) = peakGroundAccel;
                currentRowNumInMatrix = currentRowNumInMatrix + 1;
            
            % Save the PFA - these are in Opensees units (inches, seconds,
            % kips), so convert these to g units
                for floorNum = minFloorNum:maxFloorNum
                    allIDAResultsMatrix(currentRowNumInMatrix, startColNum:endColNum) = maxFloorAccel{floorNum}.allEQsUnfiltered / g;
                    currentRowNumInMatrix = currentRowNumInMatrix + 1;
                end  
                
            % Save if the analysis is converged or not
                allIDAResultsMatrix(currentRowNumInMatrix, startColNum:endColNum) = ~isAnalysisConv;

        % Increment the column number to start the stripe at (note that
        % this adds the number of EQs in this stripe)
        currentStartColumnNumInResultsMatrix = currentStartColumnNumInResultsMatrix + numEQsInThisStripe;
        
        % Clear things for this stripe
        clear maxStoryDriftRatio residualStoryDriftRatioAbsVal eqNumberLISTToSave peakGroundAccel maxFloorAccel isAnalysisConv
        
    end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Save the results into a file

    % Go into results folder
    cd ..;
    cd ..;
    cd Results_StripeResponseDataFiles;

    % Save the files
    note = 'This file was made by Driver_CreateFileOfStripeResponseResults.m';
    save(nameOfFileWithFullResults, 'allIDAResultsMatrix', 'note');        
    disp('File saved!');
    
    % Go back to the MatlabProcessor folder
    cd ..;
    cd MatlabProcessors;



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%




























