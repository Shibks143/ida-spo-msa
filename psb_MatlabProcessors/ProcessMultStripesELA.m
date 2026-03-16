%
% Procedure: ProcessMultipleStripesELE.m
% -------------------
% THIS IS THE SAME AS THE OTHER PROC, BUT IS FOR ELASTIC!  This procedure simply calls "ProcessStripeStatisticsELE.m" multiple times to process a lot of data.
% 
% Assumptions and Notices: 
%
% Author: Curt Haselton 
% Date Written: 6-1-04
%
% Units: Whatever OpenSees is using - just be consistent!
%
% -------------------
%function[void] = ProcessMultipleStripes(analysisTypeLIST)



    for analysisTypeNum = 1:length(analysisTypeLIST)

                analysisType = analysisTypeLIST{analysisTypeNum};

%               ProcessStripeStatistics(analysisType);
                ProcessStripeStatisticsELA;

                
    end


    
    
    
    
    
    
    