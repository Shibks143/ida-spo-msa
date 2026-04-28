
function [fragParamMu_ALL, fragParamBetaRTR_ALL, fragParamMu_CTRL, fragParamBetaRTR_CTRL, imMin] = extractFragilityForDifferentIM_v2(outpFolder, storyDrift, eqLIST, T_new, GMsuiteName)
%% inputs
% T_new = 0.00; % time period for spectral acceleration)
          % 0.00 corresponds to PGA,
          % 99 corresponds to unchanged time period, which is Ta as per IS 1893 in the case of SMRF archetypical buildings
% for truncated fragility the fragility function is zero for im < imMin

%% 2a. extract the old period and values of spectral acceleration corr. to story drift ratio as chosen above

matFileToLoad = sprintf('DATA_collapse_CollapseSaAndStats_%s_SaGeoMean.mat', GMsuiteName);
[T_old, saT_oldAllComp] = prak_util_extractFragDataPoints_v02(outpFolder, eqLIST, storyDrift, matFileToLoad);

%% 2b. depending on the intensity measure type, find ratio of scaling from old IM value to new value for each earthquake (NOT NEEDED in case of PGA)
% (6-28-19, PSB) extract fragility with PGA as Intensity Measure
for eqIndex = 1:length(eqLIST)
    eqNumber = eqLIST(eqIndex);
    if T_new == 99 % proxy for Ta
        ratioOfSaTnewToSaTold1 = 1;
    else
        ratioOfSaTnewToSaTold1 = prak_util_ratioOfSaTnewToSaTold(eqNumber, T_old, T_new); % for PGA (modified the function for considering PGA)
    end
    saT_newAllComp(eqIndex) = ratioOfSaTnewToSaTold1* saT_oldAllComp(eqIndex);
    IM_newAllComp(eqIndex) = saT_newAllComp(eqIndex); % (6-21-19, PSB) added this to extract the fragility for PGA
end

%% 2c. combine the new intensity measure values for different ground motions to find the fragility function parameters
IM_newCtrlComp = zeros(1, length(eqLIST)/2);

for gmIndex = 1:length(eqLIST)/2
    saT_newCompOne = IM_newAllComp(gmIndex * 2 - 1);
    saT_newCompTwo = IM_newAllComp(gmIndex * 2);
    IM_newCtrlComp(gmIndex) = min(saT_newCompOne, saT_newCompTwo);
end

% Do collapse statistics - for all components
meanCollapseSaTOneAllComp = mean(IM_newAllComp);
medianCollapseSaTOneAllComp = (median(IM_newAllComp));
meanLnCollapseSaTOneAllComp = mean(log(IM_newAllComp));
stDevCollapseSaTOneAllComp = std(IM_newAllComp);
stDevLnCollapseSaTOneAllComp = std(log(IM_newAllComp));
imMin = min(IM_newAllComp); % same as imMinAll or imMinCtrl
%     imMinAll = min(IM_newAllComp);

% Do collapse statistics - for controlling components
meanCollapseSaTOneControlComp = mean(IM_newCtrlComp);
medianCollapseSaTOneControlComp = (median(IM_newCtrlComp));
meanLnCollapseSaTOneControlComp = mean(log(IM_newCtrlComp));
stDevCollapseSaTOneControlComp = std(IM_newCtrlComp);
stDevLnCollapseSaTOneControlComp = std(log(IM_newCtrlComp));
%     imMinCtrl = min(IM_newCtrlComp);

%     fragParamMu = exp(meanLnCollapseSaTOneControlComp)';
%     fragParamBetaRTR = stDevLnCollapseSaTOneControlComp';

fragParamMu_ALL = exp(meanLnCollapseSaTOneAllComp);
fragParamBetaRTR_ALL = stDevLnCollapseSaTOneAllComp;
fragParamMu_CTRL = exp(meanLnCollapseSaTOneControlComp);
fragParamBetaRTR_CTRL = stDevLnCollapseSaTOneControlComp;

