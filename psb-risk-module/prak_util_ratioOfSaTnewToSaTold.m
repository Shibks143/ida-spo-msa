function saRatNewToOld = prak_util_ratioOfSaTnewToSaTold(eqNumber, T_old, T_new, dampRat)
%% (6-28-19, PSB) T_new = 0.00 will throw the ratio for PGA. Added this piece below on 6-28-19

baseFolder = pwd;
switch nargin 
    case 3
        dampRat = 0.05;
end

% We expect, T_old and T_new to be rounded to two decimal places, if not then let's do it now.

T_old = round(T_old *100)/100;
T_new = round(T_new *100)/100;


%% (6-28-19, PSB) Modifying to include ratio to PGA when T_new is entered as 0.00
if abs(T_new) < 0.001 % essentially, zero
    cd C:\Users\sks\OpenSeesProcessingFiles\EQ_Spectra_Saved
    % cd C:\OpenSeesProcessingFiles\EQ_Spectra_Saved
    respSpecFile = sprintf('SaEQSpectrum_EQ_%i.mat', eqNumber);
    load(respSpecFile, 'dampRatioLIST', 'periodVector', 'SaAbs');
    
% find the old SaValue
    dampRatIndex = find(abs(dampRatioLIST - dampRat) < 1e-5);
    timePIndexOld = find(abs(periodVector - T_old) < 1e-4);
    SaT_old = SaAbs(timePIndexOld, dampRatIndex);    
    
% % find the PGA value (essentially, SaT_new)
cd C:\Users\sks\OpenSeesProcessingFiles\EQs    
% cd C:\OpenSeesProcessingFiles\EQs
    timeHistoryFile = sprintf('SortedEQFile_(%i).txt', eqNumber);
    accnArray = load(timeHistoryFile);
    SaT_new = max(abs(min(accnArray)), abs(max(accnArray)));
    saRatNewToOld = SaT_new/SaT_old;

else
    cd C:\Users\sks\OpenSeesProcessingFiles\EQ_Spectra_Saved
    % cd C:\OpenSeesProcessingFiles\EQ_Spectra_Saved
    respSpecFile = sprintf('SaEQSpectrum_EQ_%i.mat', eqNumber);
    load(respSpecFile, 'dampRatioLIST', 'periodVector', 'SaAbs');
    
% find the old SaValue
    dampRatIndex = find(abs(dampRatioLIST - dampRat) < 1e-5);
    timePIndexOld = find(abs(periodVector - T_old) < 1e-4);
    SaT_old = SaAbs(timePIndexOld, dampRatIndex);
    
% find the new SaValue
    timePIndexNew = find(abs(periodVector - T_new) < 1e-4);
    SaT_new = SaAbs(timePIndexNew, dampRatIndex);
   
    saRatNewToOld = SaT_new/SaT_old;
end

cd(baseFolder)