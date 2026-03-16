%
% Procedure: ProcessResponseStatisticsForScaledRecordSets_proc.m 
% -------------------
% Same as "ProcessStripeStatisticsForCollapseRuns_proc.m" except for a scaled
% record set (with each EQ having a scale factor; not necessarily scaled
% all to the same Sa level).
% 
% Assumptions and Notices: 
%   - none
%
% Author: Curt Haselton 
% Date Written: 7-25-07
%
% Sources of Code: none
%
% Functions and Procedures called: none
%
% Variable definitions (all variables are defined at each stripe level, so they will be different for different Sa values): 
%
%       eqIndex - this is a value that is 1:numEQ's, so to get the actual EQ num, we need to look this up in the eqNumberToRunLIST
%
%       eqNumberLIST(eqIndex) - a list of the eqNumbers at the stripes - these are the numbers that are used in OpenSees (i.e. the .tcl input EQ numbers)
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
%       recordSetResultsTableForAllEQs - This is a table containing all of the
%       stripes results; this is in the format needed for the simplified
%       loss toolbox created by Eduardo Miranda.
%           - Contents in order of columns; each row is one EQ:
%               - eqNumber
%               - scale factor
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
%               - isSingular
%
%       recordSetResultsTableSummaryStats - These are just the summary
%       statistic for the stripe analyses.  Note that for a tall building
%       (like a 20 story building) these results will not fit on on Excel
%       page).
%           - Contents in order of columns; this structure will just have
%           one row
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
%               -
%               jointShearDistortionAbsMax_exteriorJoints.MeanLnAllEQs,StDevLnAllEQs
%               - isCollapsed_mean;
%
% Units: Whatever OpenSees is using - just be consistent!
%
% -------------------
function[void] = ProcessResponseStatisticsForScaledRecordSets_proc(analysisType, bldgLetter, recordSetInfo, scenarioNumberForRuns, currentMethodNum, eqRecordFormat_Num)

disp('Starting processing for records sets...');

% Loop over record sets and do processing
    for recordSetIndex = 1:recordSetInfo.numberOfGMSets
        currentEqNumberLIST = recordSetInfo.recordSets_recordCompNumbers{recordSetIndex};
        currentEqScaleFactorLIST = recordSetInfo.recordSets_fileNamesAndScaleFactors{recordSetIndex}(:,2);
            
        % Create the outputFileName
        if(scenarioNumberForRuns == 1)
            % M7
            outputFileName = sprintf('StrResponseDATA_GMSM_Method%d_M7_Building%s_Set%d', currentMethodNum, bldgLetter, recordSetIndex);
            outputFileName_allSets = sprintf('StrResponseDATA_GMSM_Method%d_M7_Building%s_SetALL', currentMethodNum, bldgLetter);
        elseif(scenarioNumberForRuns == 2)
            % M7.5
            outputFileName = sprintf('StrResponseDATA_GMSM_Method%d_M75_Building%s_Set%d', currentMethodNum, bldgLetter, recordSetIndex);
            outputFileName_allSets = sprintf('StrResponseDATA_GMSM_Method%d_M75_Building%s_SetALL', currentMethodNum, bldgLetter);
        else
            error('ERROR: Invalid scenario number');
        end
        
        % Call a subfile to load all of the EQ response data and to
        % make/save summary files for this single record set.  This also
        % saves the response data so I can output it for all of the record
        % sets combined.
        [recordSetResultsTableForAllEQs_AllSets{recordSetIndex}, recordFilenames_LIST_AllSets{recordSetIndex}, recordSetResultsTableForAllEQs_header_AllSets{recordSetIndex}] = ProcessResponseStatisticsForScaledRecordSets_proc_single(analysisType, outputFileName, currentEqNumberLIST, currentEqScaleFactorLIST, eqRecordFormat_Num);   % Processes for a single record set
        
    end

    % Go to the output folder to save more data files
    startFolder = [pwd];
    cd ..;
    cd Output
    cd(analysisType);
    
    % Output a single file with the header.
        outputFileNameForSummaryTable_Header = sprintf('%s_SummaryTableHeader.txt', outputFileName_allSets);
        % Loop and make a string of the header (with one space between each
        % entry), then write the string to a file.
        myFileStream = fopen(outputFileNameForSummaryTable_Header, 'w');
        % Just do loop over the first GM set since all header files are the
        % same.
        for setIndex = 1:1
            recordSetResultsTableForAllEQs_header_CurrentSet = recordSetResultsTableForAllEQs_header_AllSets{setIndex};
            % Loop over GMs in this set
            for eqIndex = 1:length(recordSetResultsTableForAllEQs_header_CurrentSet)
                currentHeaderEntry = recordSetResultsTableForAllEQs_header_CurrentSet{eqIndex};
                fprintf(myFileStream, '%s\n', currentHeaderEntry);
            end
        end
        fclose(myFileStream);
    
    % Output a file with the EQ filenames for all of the group motion sets
    % combined (the order of these filenames follows the order of the
    % resutls data in the .wk1 file that is written next).
        outputFileNameForSummaryTable_RecordFileNames = sprintf('%s_RecordFileNames.txt', outputFileName_allSets);
        myFileStream = fopen(outputFileNameForSummaryTable_RecordFileNames, 'w');
        % Loop over GM sets
        for setIndex = 1:length(recordFilenames_LIST_AllSets)
            recordFilenames_LIST_CurrentSet = recordFilenames_LIST_AllSets{setIndex};
            % Loop over GMs in this set
            for eqIndex = 1:length(recordFilenames_LIST_CurrentSet)
                currentRecordFilename = recordFilenames_LIST_CurrentSet{eqIndex};
            
                % Place the EQ filename in the file
                fprintf(myFileStream, '%s\n', currentRecordFilename);
            end
        end
        fclose(myFileStream);

    % Now write a EDP data file that has data for all GM sets combined
    % (with same order as the EQ filenames above).
        % Loop over the GM sets and add the tables together to make a full
        % table
        currentStartRow = 1;
        for setIndex = 1:length(recordSetResultsTableForAllEQs_AllSets)
            recordSetResultsTableForAllEQs_currentRecSet = recordSetResultsTableForAllEQs_AllSets{setIndex};
    
            % Get size of data table and location to place data
            sizeOfTable = size(recordSetResultsTableForAllEQs_currentRecSet);
            sizeOfTable_rows = sizeOfTable(1);
            sizeOfTable_cols = sizeOfTable(2);
            startCol = 2;
            endCol = 2 + sizeOfTable_cols - 1;
            startRow = currentStartRow;
            endRow = startRow + sizeOfTable_rows - 1;
            
            % Add data to table
                % Add the first column for record set number
                recordSetResultsTable_AllSets(startRow:endRow, 1) = setIndex;
                % Add data to table
                recordSetResultsTable_AllSets(startRow:endRow, startCol:endCol) = recordSetResultsTableForAllEQs_currentRecSet;
    
            % Adjust current row for next loop
            currentStartRow = currentStartRow + sizeOfTable_rows;
        end
        
        % Write the table to a file
        outputFileNameForSummaryTable = sprintf('%s_SummaryTable', outputFileName_allSets);
        wk1write(outputFileNameForSummaryTable, recordSetResultsTable_AllSets);
            
        
cd(startFolder);
disp('Processing for ALL record sets completed!');





