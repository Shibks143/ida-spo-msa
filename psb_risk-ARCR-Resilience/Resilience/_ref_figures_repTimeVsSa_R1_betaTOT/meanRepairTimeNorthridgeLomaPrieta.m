clear;

%% 3-story FF
numStories = 3; load('MeanRepairTime_1310v1_FF.mat');
saT1toSaMCE_Northridge_RSN_1085 = [2.34 2.44 2.25];
saT1toSaMCE_LomaPrieta_RSN_776  = [1.15 1.21 1.08];

if numStories == 3; Sa_MCE = 0.435; 
elseif numStories == 6; Sa_MCE = 0.221;
elseif numStories == 9; Sa_MCE = 0.153; 
end

Sa_realizations = Sa_realizations/Sa_MCE;
fprintf('3-story FF:\n');
fprintf('Northridge'); disp(interp1(Sa_realizations, meanRepairTime, saT1toSaMCE_Northridge_RSN_1085(1)));
fprintf('LomaPrieta'); disp(interp1(Sa_realizations, meanRepairTime, saT1toSaMCE_LomaPrieta_RSN_776(1)));

clear; 
% ratios are calculated in the sheet LomaPrietaNorthridgeResponseSpe of the resultsAndTables_v02_R1.xlsx

%% 6-story FF
numStories = 6; load('MeanRepairTime_1610v1_FF.mat');
saT1toSaMCE_Northridge_RSN_1085 = [2.34 2.44 2.25];
saT1toSaMCE_LomaPrieta_RSN_776  = [1.15 1.21 1.08];

if numStories == 3; Sa_MCE = 0.435; 
elseif numStories == 6; Sa_MCE = 0.221;
elseif numStories == 9; Sa_MCE = 0.153; 
end

Sa_realizations = Sa_realizations/Sa_MCE;
fprintf('6-story FF:\n');
fprintf('Northridge'); disp(interp1(Sa_realizations, meanRepairTime, saT1toSaMCE_Northridge_RSN_1085(2)));
fprintf('LomaPrieta'); disp(interp1(Sa_realizations, meanRepairTime, saT1toSaMCE_LomaPrieta_RSN_776(2)));

clear; 

%% 9-story FF
numStories = 9; load('MeanRepairTime_1910v1_FF.mat');
saT1toSaMCE_Northridge_RSN_1085 = [2.34 2.44 2.25]; % ratios are calculated in the sheet LomaPrietaNorthridgeResponseSpe of the resultsAndTables_v02_R1
saT1toSaMCE_LomaPrieta_RSN_776  = [1.15 1.21 1.08];

if numStories == 3; Sa_MCE = 0.435; 
elseif numStories == 6; Sa_MCE = 0.221;
elseif numStories == 9; Sa_MCE = 0.153; 
end

Sa_realizations = Sa_realizations/Sa_MCE;
fprintf('9-story FF:\n');
fprintf('Northridge'); disp(interp1(Sa_realizations, meanRepairTime, saT1toSaMCE_Northridge_RSN_1085(3)));
fprintf('LomaPrieta'); disp(interp1(Sa_realizations, meanRepairTime, saT1toSaMCE_LomaPrieta_RSN_776(3)));

clear; 
