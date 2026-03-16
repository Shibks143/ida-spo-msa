function [cordovaIntensityMeasureValue] = psb_retrieveCordovaIM(SaValToConvert, eqNum, dampRat, T1, alpha, periodRat)

% SaValToConvert = 1.615;
% eqNum = 120411;
% dampRat = 0.05;
% T1 = 1.02;
% alpha = 0.6;
% periodRat = 2.50;


Tf = round(periodRat * T1 * 100) / 100; % rounding to 2nd decimal place

baseFolder = pwd;
cd C:\OpenSeesProcessingFiles\EQ_Spectra_Saved

    respSpecFile = sprintf('SaEQSpectrum_EQ_%i.mat', eqNum);
    load(respSpecFile, 'dampRatioLIST', 'periodVector', 'SaAbs');

    dampRatIndex = find(dampRatioLIST == dampRat);
    period1Index = find(abs(periodVector - T1) < 0.001);
    period2Index = find(abs(periodVector - Tf) < 0.001);
    
    scalingOfT1ForCollapse = SaValToConvert / SaAbs(period1Index, dampRatIndex);
    
    SaUnscaledForPeriod2 = SaAbs(period2Index, dampRatIndex);
    SaScaledForPeriod2 = scalingOfT1ForCollapse * SaUnscaledForPeriod2;
    
    cordovaIntensityMeasureValue = SaValToConvert * power(SaScaledForPeriod2 / SaValToConvert, alpha);
    
    cd (baseFolder)
