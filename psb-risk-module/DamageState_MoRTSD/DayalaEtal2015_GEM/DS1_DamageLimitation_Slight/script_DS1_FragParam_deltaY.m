clear; tic
%% DS1 Damage Limitation (Slight Damage) Operationability % page 35 of D'ayala et al (2015)
    % the limit state is attained at the yield displacement of the
    % idealized pushober curve and we use trilinear pushover curve idealization as per 
    % ASCE 41-13 section 7.4.3.2.4 which in turn refers to FEMA 440 section 4.3

buildingIDLIST = {'2211v03_sca2', '2213v04_sca2',	'2215v03_sca2',	...
                  '2219v03_sca2', '2221v06_sca2',	'2223v03_sca2'};

% PL_LIST = [0.04, 0.02];
PL_LIST = 0.02;

% deltaYieldBasis = 'deltaYieldBasedOnFEMAP695'; % delta Yield Effective as per FEMA P 695 Figure 6-5 
deltaYieldBasis = 'deltaYieldBasedOnASCE41'; % idealizing trilinear pushover curve as per ASCE 41-13 section 7.4.3.2.4 which in turn refers to FEMA 440 section 4.3

numBldgs = length(buildingIDLIST);

roofDR_PL = zeros(numBldgs, length(PL_LIST)); V_perfLimit = zeros(numBldgs, length(PL_LIST));
delta_y_eff = zeros(numBldgs, 1);
Vyield = zeros(numBldgs, 1); delta_u = zeros(numBldgs, 1);
deltaForVbmax = zeros(numBldgs, 1); 
mu = zeros(numBldgs, length(PL_LIST)); Vb_max = zeros(numBldgs, 1);
mu_T_LIST = zeros(numBldgs, 1); 

for j = 1:length(PL_LIST)
    for i = 1:numBldgs
        [V_perfLimit(i, j), roofDR_PL(i, j)] = fun1_IDRMaxForPushover_v03(buildingIDLIST{i}, PL_LIST(j));
%         [V_perfLimit(i, j), roofDR_PL(i, j)] = IDRMaxForPushover_v02(buildingIDLIST{i}, PL_LIST(j));
%         roofDR_PL(i, j) = IDRMaxForPushover_v01(buildingIDLIST{i}, PL_LIST(j));
%         delta_y_eff(i) = delta_y_eff_v01(buildingIDLIST{i});

    switch deltaYieldBasis
        case 'deltaYieldBasedOnFEMAP695'
%             [delta_y_eff(i), Vyield(i), BS] = delta_y_eff_v02_FEMAP695(buildingIDLIST{i});
%             [delta_y_eff(i), Vyield(i), delta_u(i), BS] = delta_y_eff_v03_FEMAP695(buildingIDLIST{i});
%             [delta_y_eff(i), Vyield(i), delta_u(i), deltaForVbmax(i), BS] = delta_y_eff_v04_FEMAP695(buildingIDLIST{i});
            fprintf('[%i/%i]\t', (j-1)*numBldgs + i, numBldgs*length(PL_LIST));
            [delta_y_eff(i), Vyield(i), delta_u(i), deltaForVbmax(i), BS] = fun2_delta_y_eff_v05_FEMAP695(buildingIDLIST{i});
        case 'deltaYieldBasedOnASCE41'
%             [delta_y_eff(i), Vyield(i), BS] = delta_y_eff_basedOnArea_ASCE41_v01(buildingIDLIST{i});
            fprintf('[%i/%i]\t', (j-1)*numBldgs + i, numBldgs*length(PL_LIST));
            [delta_y_eff(i), Vyield(i), BS, deltaForVbmax(i)] = fun3_delta_y_eff_basedOnArea_ASCE41_v02(buildingIDLIST{i});
    end
        [Vb_max(i), indexForMax] = max(BS);
        mu(i, j) = roofDR_PL(i, j) / delta_y_eff(i); % R_mu is calculated using R-mu-T relations like Nassar-Krawinkler 
%         fprintf('%s \t %.6f \t %.1f%% \t %.6f \t %.2f \n', buildingIDLIST{i}, delta_y_eff(i), PL_LIST(j)*100, roofDR_PL(i, j), R_mu(i, j));
    end
end

%% new section (for muT calculation); 
% recall that mu is the ratio of "RDR at defined performance level" (say, 2% MIDR, i.e., LS) to "yield RDR" 
% whereas the period-based ductility defined in FEMA P695 is the ratio of "RDR at 20% strength loss" to the "effective yield RDR" 

baseFolder = pwd;
for i = 1:numBldgs
        bldgID = buildingIDLIST{i};
        cd H:\DamageIndex\Automated
        [~, analysisTypeFolder, ~, ~] = returnModelFolderInfo(bldgID);
        cd(analysisTypeFolder)
        lastwarn(''); % resetting last warning message;
        load('DATA_pushover.mat', 'mu_T')
        msg = lastwarn;
        if isempty(msg)
            mu_T_LIST(i, 1) = mu_T;
        else 
            warning('mu_T is either not saved or could not be calculated for the pushover of the building ID- %s.', bldgID);
            mu_T_LIST(i, 1) = 0;
        end
end
cd(baseFolder);

% fprintf('***************************************************\n');
% fprintf('buildingID    V_yield      Vmax     deltay_eff   MIDR  delta_u  corr._roofDR  deltaForVbMax  V_MIDR       mu     mu_T\n');
% 
% for j = 1:length(PL_LIST)
%     for i = 1:numBldgs
%         fprintf('%s \t %6.1f \t %6.1f \t %.6f \t %.1f%% \t %.6f \t %.6f \t %.6f \t %6.1f \t %.2f \t %.2f \n', buildingIDLIST{i}, Vyield(i), Vb_max(i), delta_y_eff(i), PL_LIST(j)*100, delta_u(i), roofDR_PL(i, j), deltaForVbmax(i), V_perfLimit(i, j), mu(i, j), mu_T_LIST(i));  
%     end
%     fprintf('***************************************************\n');
% end

T = table(buildingIDLIST', Vyield, Vb_max, delta_y_eff, ones(numBldgs, 1).*PL_LIST, delta_u, roofDR_PL, deltaForVbmax, V_perfLimit, mu, mu_T_LIST);
T.Properties.VariableNames{1} = 'BldgID'; T.Properties.VariableNames{5} = 'MIDR';
T.Properties.VariableNames{9} = 'V_MIDR'; T.Properties.VariableNames{11} = 'mu_T';

disp(T) 

% To use as input for R-mu-T relations by Krawinkler Nassar (1993)
% alpha- Hardening slope normalized by elastic slope of the pushover curve
alpha = ((Vb_max - Vyield) ./ (deltaForVbmax - delta_y_eff)) ./ (Vyield ./ delta_y_eff);

disp(['alpha = ', num2str(alpha', '%.3f, ')])
toc