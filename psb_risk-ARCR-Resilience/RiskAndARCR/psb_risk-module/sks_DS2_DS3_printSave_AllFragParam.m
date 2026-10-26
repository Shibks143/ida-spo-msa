function sks_DS2_DS3_printSave_AllFragParam(PHRInputs)

tic

%% User inputs begins           
bldgIDLIST1 =        PHRInputs.BldgIdLIST;
eqNumberLIST1 =      PHRInputs.eqNumberLIST;
LimitStateValLIST =  PHRInputs.LimitStateValLIST;
baseFolder =         PHRInputs.baseFolder;
formatMode =        PHRInputs.formatMode; 

bldgIDLIST = bldgIDLIST1(1,:);
eqNumberLIST = eqNumberLIST1(1, :);

T_all_chi = table(bldgIDLIST');
T_all_chi.Properties.VariableNames{1} = 'BldgID';
T_ctrl_chi = T_all_chi; 
T_all_xi = T_all_chi; 
T_ctrl_xi = T_all_chi; 

%% Extract fragility results
for i = 1:size(bldgIDLIST, 2)
    bldgID_curr = bldgIDLIST{1, i}; % current building ID

    [~, analysisTypeFolder, ~, ~] = returnModelFolderInfo(bldgID_curr);
    cd(analysisTypeFolder);

    for j = 1:size(LimitStateValLIST, 2)
        clc; fprintf('Processing building- %i/%i, chi- %i/%i...\n', i, size(bldgIDLIST, 2), j, size(LimitStateValLIST, 2));
        LimitStateVal = LimitStateValLIST(1, j);
        
%% 1. using theta_U as normalizing parameter    
        fileName = sprintf('DATA_criticalCol_chi_%s_SaAndStats.mat', strrep(num2str(round(LimitStateVal, 2), '%.2f'), '.', 'p'));      
        load(fileName, 'saT1_ds2_ALL', 'saT1_ds2_CTRL', 'LimitStateVal', 'eqLIST', ...
        'meanLnDS2SaAllComp', 'stDevLnDS2SaAllComp', 'minDS2LevelSaAll', 'maxDS2LevelSaAll',...
        'meanLnDS2SaCtrlComp', 'stDevLnDS2SaCtrlComp', 'minDS2LevelSaCtrl', 'maxDS2LevelSaCtrl');
        
        fragDataCurrAll = [meanLnDS2SaAllComp, stDevLnDS2SaAllComp];
        fragDataCurrCtrl = [meanLnDS2SaCtrlComp, stDevLnDS2SaCtrlComp];
        
        T_all_chi(i, j+1) = table(fragDataCurrAll);
        T_ctrl_chi(i, j+1) = table(fragDataCurrCtrl);
        
        if i == 1
            T_all_chi.Properties.VariableNames{j+1} = sprintf('fragParamsAll_chi_%s', strrep(num2str(round(LimitStateVal, 2), '%.2f'), '.', 'p'));
            T_ctrl_chi.Properties.VariableNames{j+1} = sprintf('fragParamsCtrl_chi_%ip%i', strrep(num2str(round(LimitStateVal, 2), '%.2f'), '.', 'p'));
        end
        
%% 2. using theta_cap as normalizing parameter
        fileName1 = sprintf('DATA_criticalCol_xi_%s_SaAndStats.mat', strrep(num2str(round(LimitStateVal, 2), '%.2f'), '.', 'p'));     
        load(fileName1, 'saT1_ds2_ALL_xi', 'saT1_ds2_CTRL_xi', 'LimitStateVal', 'eqLIST', ...
        'meanLnDS2SaAllComp_xi', 'stDevLnDS2SaAllComp_xi', 'minDS2LevelSaAll_xi', 'maxDS2LevelSaAll_xi',...
        'meanLnDS2SaCtrlComp_xi', 'stDevLnDS2SaCtrlComp_xi', 'minDS2LevelSaCtrl_xi', 'maxDS2LevelSaCtrl_xi');
        
        fragDataCurrAll_xi = [meanLnDS2SaAllComp_xi, stDevLnDS2SaAllComp_xi];
        fragDataCurrCtrl_xi = [meanLnDS2SaCtrlComp_xi, stDevLnDS2SaCtrlComp_xi];
        
        T_all_xi(i, j+1) = table(fragDataCurrAll_xi);
        T_ctrl_xi(i, j+1) = table(fragDataCurrCtrl_xi);
        
        if i == 1
            T_all_xi.Properties.VariableNames{j+1} = sprintf('fragParamsAll_xi_%s', strrep(num2str(round(LimitStateVal, 2), '%.2f'), '.', 'p'));
            T_ctrl_xi.Properties.VariableNames{j+1} = sprintf('fragParamsCtrl_xi_%s', strrep(num2str(round(LimitStateVal, 2), '%.2f'), '.', 'p'));
        end
        
    end
end

disp(T_all_chi);
disp(T_ctrl_chi);
disp(T_all_xi);
disp(T_ctrl_xi);

%% Histogram for failure mechanism

for i = 1:size(bldgIDLIST, 2)
    bldgID_curr = bldgIDLIST{1, i}; % current building ID

    [~, analysisTypeFolder, ~, ~] = returnModelFolderInfo(bldgID_curr);
    cd(analysisTypeFolder);

    for j = 1:size(LimitStateValLIST, 2)
        clc; fprintf('Processing building- %i/%i, chi- %i/%i...\n', i, size(bldgIDLIST, 2), j, size(LimitStateValLIST, 2));
        LimitStateVal = LimitStateValLIST(1, j);
        cd ..
    end
end

clearvars -except baseFolder bldgIDLIST eqNumberLIST LimitStateValLIST T_all_chi T_all_xi T_ctrl_chi T_ctrl_xi 

outFolder = fullfile(baseFolder, 'Output_Risk');
fileNameToSave = 'DS2_DS3_fragDataCS22_SaTa';
save(fullfile(outFolder, fileNameToSave), 'bldgIDLIST', 'eqNumberLIST', 'LimitStateValLIST', 'T_all_chi', 'T_all_xi', 'T_ctrl_chi', 'T_ctrl_xi');
fprintf('Data file saved in: %s\n', outFolder);

%% Fragility added on 21-Apr-2026 by Shivakumar K S
figure; hold on; grid on

Sa = linspace(0.01,1.5,400);

for j = 1:length(LimitStateValLIST)
    mu  = T_ctrl_chi{1,j+1}(1);
    beta= T_ctrl_chi{1,j+1}(2);
    plot(Sa, logncdf(Sa,log(mu),beta),'LineWidth',2)
end

for j = 1:length(LimitStateValLIST)
    mu  = T_ctrl_xi{1,j+1}(1);
    beta= T_ctrl_xi{1,j+1}(2);
    plot(Sa, logncdf(Sa,log(mu),beta),'--','LineWidth',2)
end

xlabel('Sa(Ta) (g)')
ylabel('Probability of exceedance')
title('Fragility curves (solid=chi, dashed=xi)')

%END OF FRAGILITY ADDITION on 21-Apr-2026 

%%
cd(baseFolder)        
toc;        
        
        
        
        
        
        
        
        
        
        
        