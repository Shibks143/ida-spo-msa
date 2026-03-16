%
% Procedure: Prak_RecoverInterruptedAnalysis.m
% -------------------
% this function recovers the analysis already run but interrupted.
% 
% Assumptions and Notices: 
%           - This assumes that this file is executed in the Sensitivity_Analysis folder
%
% Author: Prakash Singh
% Date Written: 11-15-15
%
% Sources of Code: none
%
% Functions and Procedures called: none
%
% NOTICE: This file does not change the definition of eqNumberLIST for the
% processing commands following the runAnalysis command in the master file.
% Processing and plotting commands redefin their eqNumberLIST separately
% and thus remain unchanged.
% -------------------

function [eqNumberLIST, timeTakenInMinsForEachAnalysis] = psb_RecoverInterruptedAnalysis(eqNumberLISTOld, analysisType)

currentFolder = pwd;
% textToDisplay3 = sprintf('Current folder is %s', currentFolder);
% disp(textToDisplay3);

% Go into the output folder for this EQ run
        cd ..;
        cd ..;
        cd Output;
        cd(analysisType)

tempFilename = ['temp_CollapseRunForThisModel.mat'];
if exist(tempFilename, 'file')
    
    txtToDisplay1 = sprintf('Recovering from %s', tempFilename);
    disp(txtToDisplay1);
    
    load(tempFilename)
    
    totalNumOfEqRecords = length(eqNumberLISTOld);

    eqNumberLIST = eqNumberLISTOld(lastCompleteEqNumberIndex+1:totalNumOfEqRecords);
    
	fprintf('\n ############################################################# \n');
    fprintf(' ###########  Recovered %d/%d total records  ################# ', lastCompleteEqNumberIndex, totalNumOfEqRecords);
    fprintf('\n ############################################################# \n');
    
else
    eqNumberLIST = eqNumberLISTOld;
    timeTakenInMinsForEachAnalysis = [];
end

cd(currentFolder)