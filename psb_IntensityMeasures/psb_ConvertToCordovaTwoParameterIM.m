function [collapseLevelCordovaLIST, stDevLnCollapseCordova] = psb_ConvertToCordovaTwoParameterIM(collapseLevelSaLIST, eqLIST, T1, dampRat, alpha, ratioOfTimePeriods)
baseFolder = pwd;

%     T2 = round(ratioOfTimePeriods * T1 * 100) / 100; % rounding to 2nd decimal place
    cd C:\OpenSeesProcessingFiles\EQ_Spectra_Saved

    totNumOfEQs = length(eqLIST);
    collapseLevelCordovaLIST = zeros(1, totNumOfEQs);
    
for eqIndex = 1:totNumOfEQs
    eqNumber = eqLIST(eqIndex);
    SaScaledForPeriod1 = collapseLevelSaLIST(eqIndex);
    collapseLevelCordovaLIST(eqIndex) = psb_retrieveCordovaIM(SaScaledForPeriod1, eqNumber, dampRat, T1, alpha, ratioOfTimePeriods);
end

%     meanCollapseSaTOne = mean(collapseLevelSaLIST);
%     medianCollapseSaTOne = (median(collapseLevelSaLIST));
%     meanLnCollapseSaTOne = mean(log(collapseLevelSaLIST));
%     stDevCollapseSaTOne = std(collapseLevelSaLIST);
%     stDevLnCollapseSaTOne = std(log(collapseLevelSaLIST));
%     
%     meanCollapseCordova = mean(collapseLevelCordovaLIST);
%     medianCollapseCordova = (median(collapseLevelCordovaLIST));
%     meanLnCollapseCordova = mean(log(collapseLevelCordovaLIST));
%     stDevCollapseCordova = std(collapseLevelCordovaLIST);
    stDevLnCollapseCordova = std(log(collapseLevelCordovaLIST));

cd(baseFolder)
