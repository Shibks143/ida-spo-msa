%
% Procedure: ProcessMultipleRuns.m
% -------------------
% This procedure simply calls "ProcessSingleRun.m" multiple times to process a lot of data.
% 
% Assumptions and Notices: none
%
% Author: Curt Haselton 
% Date Written: 5-11-04
% Updated: 12-10-04
%
% Examples of input:
%       analysisTypeLIST = {'(DesID1_v.UCLA6)_(AllVar)_(Mean)_(nonlinearBeamColumn)', '(DesID1_v.UCLA6)_(AllVar)_(Mean)_(hystHinge)'}; 
%       modelNameLIST = {'DesID1_v.UCLA6', 'DesID1_v.UCLA6'};
%       Note: This processes EQ 100-154 at Sa = 0.26g and then processes EQ 200-1256 at Sa = 0.19g.
%       eqNumberAllStripesLIST = { [100, 101, 102, 103, 104, 150, 151, 152, 153, 154],
%                                  [200, 201, 202, 203, 204, 250, 252, 1250, 1253, 1256]};
%       saTOneForRunLIST = [0.26, 0.19];
%       elementUsed = 1 for nonlinearMeanColumn, or 2 for hystHinge
%
%
% Units: Whatever OpenSees is using - just be consistent!
%
% -------------------
% function[void] = ProcessMultipleRuns(analysisTypeLIST, modelNameLIST, eqNumberAllStripesLIST, saTOneForRunLIST, elementUsed)

    for analysisAndModelNum = 1:length(analysisTypeLIST)

        analysisType = analysisTypeLIST{analysisAndModelNum};
        modelName = modelNameLIST{analysisAndModelNum};
        
        for saTOneForRunNum = 1:length(saTOneForRunLIST)
        
            % Stripe number
            eqStripeNum = saTOneForRunNum;
            eqNumberLIST = eqNumberAllStripesLIST{eqStripeNum};
            
                % Loop for all EQ''s in the stripe
                for eqNumberNum = 1:length(eqNumberLIST)

                    saTOneForRun = saTOneForRunLIST(saTOneForRunNum);
                    eqNumber = eqNumberLIST(eqNumberNum);

                    temp = sprintf('Processing EQ %d at %.2f', eqNumber, saTOneForRun);
                    disp(temp);
                
                
                    % Decide what processor to use, depending on the element used for the analysis
                    if (elementUsed == 1)
                        disp('Using nlBmCol Processor!')
%                         ProcSingleRunNlBmColFull(analysisType, modelName, saTOneForRun, eqNumber);
                        ProcSingleRunNlBmColSens_temp;

                    elseif (elementUsed == 2)
                        disp('Using Lumped Plasticity Processor!')
                        ProcSingleRunLumpPlaFull_temp(analysisType, modelName, saTOneForRun, eqNumber);

                    else
                        error('ERROR: Invalid element!')
                    end
                
                end
        end 
    end
    
    
    
  