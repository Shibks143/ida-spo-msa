%
% Procedure: ProcessMultipleStripes.m
% -------------------
% This procedure simply calls "ProcessStripeStatistics.m" multiple times to process a lot of data.
% 
% Assumptions and Notices: 
%
% Author: Curt Haselton 
% Date Written: 6-1-04
%
% Units: Whatever OpenSees is using - just be consistent!
%
% -------------------
% function[void] = ProcessMultipleStripes(analysisTypeLIST, eqNumberAllStripesLIST, saTOneForRunLIST)


% Call the initialation file (BE SURE TO MODIFY THIS TO DO WHAT YOU WANT TO
% DO!!!)
    InitProcessMultStripes

% Just loop through all of the 
    for analysisTypeNum = 1:length(analysisTypeLIST)

            analysisType = analysisTypeLIST{analysisTypeNum};

            for stripeNum = 1:length(saTOneForRunLIST)
                
                % Define values for this stripe.
                saTOneForStripe = saTOneForRunLIST(stripeNum);
                eqNumberLIST = eqNumberAllStripesLISTGeoMean{stripeNum};

                % Process this single stripe number
                ProcessStripeStatisticsGeoMean;
%                 ProcessStripeStatisticsGeoMean(analysisType,
%                 eqNumberLIST, saTOneForStripe, recordSetNameUsed)
            end
    end


    
    
    
    
    
    
    