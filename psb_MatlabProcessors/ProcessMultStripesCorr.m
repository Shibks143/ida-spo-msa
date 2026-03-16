%
% Procedure: ProcessMultStripesCorr.m
% -------------------
% This procedure simply calls "ComputeCorrForSingleStripe.m" multiple times to process the correlation information.
% 
% Assumptions and Notices: 
%
% Author: Curt Haselton 
% Date Written: 11-8-04
%
% Units: Whatever OpenSees is using - just be consistent!
%
% -------------------
%function[void] = ProcessMultStripesCorr()

% Initialze and make the lists of stripes to process
    analysisTypeLIST = {'(DesID1_v.57)_(AllVar)_(Mean)_(nonlinearBeamColumn)'};
    saTOneForRunLIST = [0.26, 0.19, 0.10, 0.82, 0.55, 0.44, 0.30, 1.20];


% Process the correlations for the list of stripes
    for analysisTypeNum = 1:length(analysisTypeLIST)

            for stripeNum = 1:length(saTOneForRunLIST)
                
                % Define the analysis type
                analysisType = analysisTypeLIST{analysisTypeNum};
                
                % Define values for this stripe.
                saTOneForStripe = saTOneForRunLIST(stripeNum);

                % Call the procedure
                ComputeCorrForSingleStripe;

            end
    end


    
    
    
    
    
    
    