%
% Procedure: FindSingularAnalyses.m
% -------------------
% This procedure computes loops and opens the output files from the
% collapse IDA runs and find the analyses that were singular (just so I can
% find a singular run and send it to Frank).
% 
% Assumptions and Notices: 
%           - This must be run with the current directory started in the "MatlabProcessing" folder.
%
% Author: Curt Haselton 
% Date Written: 12-13-05
%
% Sources of Code: none
%
% Functions and Procedures called: none
%
% Variable definitions (all variables are defined at each stripe level, so they will be different for different Sa values): 
%
% Units: Whatever OpenSees is using - just be consistent!
%
% -------------------

% Define the model information
    analysisTypeLIST = {'(DesA_Buffalo_v.9noGFrm)_(AllVar)_(0.00)_(clough)'};
        
    %%% ATC-63 Set A (record 23 and 30 excluded) - Both PEER and PEER-NGA formats
    eqNumberLIST = [1101, 1102, 1103, 1104, 1105, 1106, 1107, 1108, 1109, 1110, 1111, 1112, 1113, 1114, 1115, 1116, 1117, 1118, 1119, 1120, 1121, 1122, 1124, 1125, 1126, 1127, 1128, 1129, 1131, 1132];


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Loop and open files to check for singularity

for analysisTypeIndex = 1:length(analysisTypeLIST)
    analysisType = analysisTypeLIST{analysisTypeIndex}

% Initialize a vector - twice as long as the eqNumerLIST b/c I do two comp. per EQ
collapseLevelForAllComp = zeros(1,(2.0*length(eqNumberLIST)));   
collapseLevelForControllingComp = zeros(1,(length(eqNumberLIST)));   
eqCompNumberLIST = zeros(1,(2.0*length(eqNumberLIST))); 
eqCompInd = 1;

for eqInd = 1:(length(eqNumberLIST))
    eqNumber = eqNumberLIST(eqInd);

    for eqCompIndex = 1:2
        eqCompNumber = eqNumber * 10.0 + eqCompIndex;
    
        % Go to the correct folder
        cd ..;
        cd Output;
        analysisTypeFolder = sprintf('%s', analysisType);
        cd(analysisTypeFolder);
        eqFolder = sprintf('EQ_%.0f', eqCompNumber);
        cd(eqFolder)

        % Open the file that has the collapse data
        load('DATA_CollapseResultsForThisSingleEQ.mat', 'isSingularForEachRun');
        
        % Check if it is singular for any of the EQs and report back
        isSingular = max(isSingularForEachRun);
        
        if(isSingular)
            temp = sprintf('EQ %d: SINGULAR for at least one Sa level!!!!!!', eqCompNumber);
            disp(temp);
        else
            temp = sprintf('EQ %d: No singularities', eqCompNumber);
            disp(temp);
        end
        
        
        
        % Go back to the Matlab folder
        cd ..;
        cd ..;
        cd ..;
        cd MatlabProcessors;

    end  
end

end
