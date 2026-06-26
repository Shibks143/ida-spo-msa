function fun0a_processAndSaveIDA_DS1_AllComp_v1(bldgID, eqLIST)
%% DS1 Damage Limitation (Slight Damage) Operationability % page 35 of D'ayala et al (2015)
    % the limit state is attained at the yield displacement of the
    % idealized pushober curve and we use trilinear pushover curve idealization as per 
    % ASCE 41-13 section 7.4.3.2.4 which in turn refers to FEMA 440 section 4.3
    
%% sample inputs
% clear; tic
% bldgID = '2211v03_sca2'; % bldgIDLIST{2}
% eqLIST = [6000311	6000312	6001601	6001602	6001831	6001832	6002121	6002122	6002851	6002852	6003411	6003412	6003521	6003522	6004081	6004082	6004091	6004092	6004571	6004572	6004581	6004582	6004611	6004612	6006331	6006332	6006921	6006922	6007861	6007862	6009521	6009522	6009681	6009682	6009871	6009872	6011351	6011352	6014361	6014362	6023951	6023952	6026271	6026272];
%%%%%%% END OF USER INPUT
formatMode = 'powerpoint';
%% Calculations start
baseFolder = pwd;
numEqs = size(eqLIST, 2);
    
%% 0. Read floorHtLIST, building height, and number of floors from MatlabInfo directory of output folder
%     clc; fprintf('Processing building- %i/%i ...\n', i, numBldgs);
%     cd H:\DamageIndex\Automated
    % cd ..\..\..\DamageIndex\Automated\
    [~, analysisTypeFolder, ~, ~] = returnModelFolderInfo(bldgID);
    cd(analysisTypeFolder); cd MatlabInformation
    floorHtLIST = load('floorHeightLISTOUT.out');
    bldgHt = floorHtLIST(end); 
    numLevels = size(floorHtLIST, 1); % = numFloors + 1
    cd ..; % back to analysis output Folder

%% 1. extract maximum roof displacement from output file from each scaled levels of the applied time history
for eqIndex = 1:numEqs
    %         clc; fprintf('Processing building- %i/%i, EQ- %i/%i ...\n', i, numBldgs, eqIndex, numEqs);
    eqNumber = eqLIST(eqIndex);
    eqFolder = sprintf('EQ_%d', eqNumber);
    cd(eqFolder);
    
    % this list contains 100 in saLevels for non-conv cases,
    load('DATA_collapseIDAPlotDataForThisEQ.mat', 'saLevelsForIDAPlotLIST');
    saT1LIST = saLevelsForIDAPlotLIST(2:end); % 2 to remove zero.
    saT1LIST(saT1LIST == 100) = [];
    saT1LIST = sort(saT1LIST, 'ascend');
    
    numSaLevels = size(saT1LIST, 2);
    
    nodeID_bot = 2e5 + numLevels * 1000 + 1 * 10 + 1; % node at bottom of the joint
    nodeID_top = 2e5 + numLevels * 1000 + 1 * 10 + 3; % node at top of the joint
    
    fileName_dispNodeBot = sprintf('THNodeDispl_%d.out', nodeID_bot);
    fileName_dispNodeTop = sprintf('THNodeDispl_%d.out', nodeID_top);
    
    roofDriftM = []; % initialize
    
    for scalingIndex = 1:numSaLevels
        saT1Val = saT1LIST(scalingIndex);
        SaFolder = sprintf('Sa_%3.2f', saT1Val);
        cd(SaFolder); cd Nodes; cd DisplTH
        
        nodeTH_bot = load(fileName_dispNodeBot); % file has (t, ux, uy, rz)
        nodeTH_top = load(fileName_dispNodeTop);
        
        nodeAverageDispTH = (nodeTH_bot(:, 2) + nodeTH_top(:, 2))/2;
        roofDispM = max(abs(nodeAverageDispTH));
        roofDriftM(scalingIndex) = roofDispM/bldgHt;
        
        cd ..; cd ..; cd ..; % back to earthquake-specific folder
    end
    
    % save EQ-specific processed results (IDA, i.e., roof drift ratio versus Sa(Ta))
    thisEqDataFileName = sprintf('DATA_roofDriftRat_IDA_ForThisEQ.mat');
    save(thisEqDataFileName, 'roofDriftM', 'saT1LIST');
    
    % 1 plot ALL component IDAs
    figure(151); % just in case, 101 is open by some other program
    plot([0, roofDriftM], [0, saT1LIST], 'b-o', 'LineWidth', 1); hold on; grid on;
    
    cd ..; % back to analysis output Folder
end

% 2 save ALL component Roof drift ratio IDAs in analysis directory
    figure(151); % figure(100+figUniqueSeedForParfor); 
    xlabel('RDR\,max','Interpreter','latex');
    ylabel('Sa(Ta) (g)','Interpreter','latex');
    
    % hx = xlabel('RDR_{max}'); hy = ylabel('Sa(Ta) (g)');
    % xlim([0 1]);
    sks_figureFormat(formatMode)

% psb_FigureFormatScript_paper; set(gca,'fontname','times');
    exportName = sprintf('roofDriftRatio_IDA_ALLComp');
    savefig(exportName); print('-depsc', exportName); print('-dmeta', exportName);
    sks_figureExport(exportName)

    cd(baseFolder);
% close figures to avoid plotting on the same figure in case the function is repeatedly called 

close all;

% toc