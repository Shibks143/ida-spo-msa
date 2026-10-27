function sks_DS1_FragParam(PHRInputs)


tic
%% DS1 Damage Limitation (Slight Damage) Operationability % page 35 of D'ayala et al (2015)
    % the limit state is attained at the yield displacement of the
    % idealized pushover curve and we use trilinear pushover curve idealization as per 
    % ASCE 41-13 section 7.4.3.2.4 which in turn refers to FEMA 440 section 4.3
baseFolder = pwd;

eqNumberLIST1 = PHRInputs.eqNumberLIST;
bldgIDLIST1 = PHRInputs.BldgIdLIST;
deltaYieldBasis = PHRInputs.deltaYieldBasis;
    
% bldgIndexToRun = 9:2:12; % carrying out parameterized study over the limit of chi (= thetaM/thetaU) of most critical column
% bldgIDLIST = bldgIDLIST1(1, bldgIndexToRun);      % for multiple buildings 
bldgIDLIST = bldgIDLIST1;                           % for single building 
% eqNumberLIST = eqNumberLIST1(bldgIndexToRun, :);  % for multiple buildings 
eqNumberLIST = eqNumberLIST1;                       % for single building 

% % End of user input
% %%%%%%%%%%%%%%%%%%%%%%

%% calculations begin
numBldgs = size(bldgIDLIST, 2);
delta_y_eff = zeros(numBldgs, 1); Vyield = zeros(numBldgs, 1); 
delta_u = zeros(numBldgs, 1); deltaForVbmax = zeros(numBldgs, 1); 

T = table(bldgIDLIST');
T.Properties.VariableNames{1} = 'BldgID';

% 1. find delta_y_eff which would give us Roof drift ratio for DS1 
for i = 1:numBldgs
    fprintf('Processing building- %i/%i...\n', i, numBldgs);
    bldgID_curr = bldgIDLIST{1, i}; % current building ID
    eqNumberLIST_curr = eqNumberLIST(i, :); % EQ list for current building ID

    switch deltaYieldBasis
        case 'deltaYieldBasedOnFEMAP695'
            [delta_y_eff, Vyield, delta_u, deltaForVbmax, BS] = fun2_delta_y_eff_v05_FEMAP695(bldgID_curr);
        case 'deltaYieldBasedOnASCE41'
            [delta_y_eff, Vyield, BS, deltaForVbmax] = fun3_delta_y_eff_basedOnArea_ASCE41_v02(bldgID_curr);
    end
% 2. process and save ALL component IDA
    fun0a_processAndSaveIDA_DS1_AllComp_v1(bldgID_curr, eqNumberLIST_curr)
    
% 3. extract fragility parameters
    LimitStateVal = delta_y_eff;
    [fragilityInfo] = fun0b_extractFragParam_DS1_v1(bldgID_curr, eqNumberLIST_curr, LimitStateVal);

% store values as a table
    fragDataCurrAll = [fragilityInfo.meanLnDS1SaAllComp, fragilityInfo.stDevLnDS1SaAllComp];
    fragDataCurrCtrl = [fragilityInfo.meanLnDS1SaCtrlComp, fragilityInfo.stDevLnDS1SaCtrlComp];

    T(i, 2:4) = table(delta_y_eff, fragDataCurrAll, fragDataCurrCtrl);
    if i == 1
        T.Properties.VariableNames{2} = sprintf('RDR_DS1');
        T.Properties.VariableNames{3} = sprintf('Frag_DS1_ALL');
        T.Properties.VariableNames{4} = sprintf('Frag_DS1_CTRL');
    end
end

%% since, there are a few clc commands in fun0, display T in the end
disp(T);
clearvars -except bldgIDLIST eqNumberLIST deltaYieldBasis T baseFolder

cd('Output_Risk')
fileNameToSave = 'DS1_fragDataCS22_SaTa';
save(fileNameToSave, 'bldgIDLIST', 'eqNumberLIST', 'deltaYieldBasis', 'T');
fprintf('Data file saved in: %s\n', pwd);
cd(baseFolder)
toc