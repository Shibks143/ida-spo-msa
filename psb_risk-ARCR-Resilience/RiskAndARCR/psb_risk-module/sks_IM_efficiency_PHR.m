function sks_IM_efficiency_PHR(PHRInputs)

tic; 

%% Start of input
baseFolder =                PHRInputs.baseFolder;
BldgIdAndZoneLIST =         PHRInputs.BldgIdAndZoneLIST;
T1LIST =                    PHRInputs.T1LIST;
dsToPlotFragParam =         PHRInputs.dsToPlotFragParam;
dsLegForPlot =              PHRInputs.dsLegForPlot;
doPlotFragMedian =          PHRInputs.doPlotFragMedian;
doPlotFragDispers =         PHRInputs.doPlotFragDispers;
doPlotFragBound =           PHRInputs.doPlotFragBound;
doPlotT1LinesInFragDisp =   PHRInputs.doPlotT1LinesInFragDisp;
dsToPlotBound =             PHRInputs.dsToPlotBound;
saveMedianDispersionBound = PHRInputs.saveMedianDispersionBound;
formatMode =                PHRInputs.formatMode;


cd DATA_files
load('DATA_fragility_Dayala_2433v02');
cd ..
bldgIdLIST = {};
outFolder = fullfile(baseFolder, 'Output_Risk');

% for plotting fragility params with bound
UBPercentile = 0.84; LBPercentile = 1 - UBPercentile ;
UBEps = norminv(UBPercentile); LBEps = norminv(LBPercentile);

nDs = size(dsToPlotFragParam, 2)'; % number of damage states
% end of input

%% program begins
for i = 1:size(BldgIdAndZoneLIST, 1) % for each building
    bldgIdCurr = BldgIdAndZoneLIST{i, 1};
    bldgIdLIST = [bldgIdLIST; bldgIdCurr];
    % variable name for storing building ID, this cannot begin with a numeral
    bldgIdVar = ['ID' bldgIdCurr];
    
    muCtrlAllDs = fragAllData.(bldgIdVar).muCtrl;
    betaRTRCtrlAllDs = fragAllData.(bldgIdVar).betaRTRCtrl;
    timePLIST = fragAllData.(bldgIdVar).timeP;
    ds = fragAllData.(bldgIdVar).ds;
    
%% take a subset of the data depending on the damage state of interest
    for j = 1:nDs
       currDs = dsToPlotFragParam{1, j}; 
       dsMatchID = strcmp(ds, currDs);
       muCtrl(:, j) = muCtrlAllDs(:, dsMatchID);
       betaRTRCtrl(:, j) = betaRTRCtrlAllDs(:, dsMatchID);
    end

% for j = 1:size(dsToPlotFragParam, 2)
%         currDs = dsToPlotFragParam{1, j};
%         dsMatchID = strcmp(ds, currDs);
%         muCtrl(:, j) = muCtrlAllDs(:, dsMatchID);
%         betaRTRCtrl(:, j) = betaRTRCtrlAllDs(:, dsMatchID);
%     end
    
%% create a subset of betaRTR that we maybe interested in, for optimizing betaRTR 
    betaRTRCtrlSub = betaRTRCtrl(timePLIST <= 5.0, :);
    [M, I] = min(betaRTRCtrlSub);
    
    betaRTRCtrlMin(i, :) = M; % dispersion in the fragility for efficient intensity measure 
    for j = 1:nDs
    muCtrlEff(i, j) = muCtrl(I(j),j)'; % median fragility for efficient intensity measure 
    end
    timePEff(i, :) = timePLIST(I)'; % optimal period corresponding to efficient intensity measure
    
    lineStyleList = {'k-', 'r--', 'b-.', 'm:'};
%% everything below is basically just for plotting
    if doPlotFragMedian == 1
        figure(100+i); hold on; grid on
        for k = 1:size(dsToPlotFragParam, 2)
            plot(timePLIST, muCtrl(:, k), lineStyleList{1, k}, 'LineWidth', 1.5); hold on; grid on;
        end
        legend(dsLegForPlot);
        xlabel('$T_j$ (s)');
        ylabel('$\mu_{ds,Sa(T_j)}$ (g)');
        sks_figureFormat(formatMode)
        if saveMedianDispersionBound(1) == 1
            cd(outFolder)
            exportName = sprintf('F7%s_IMefficiency_muSaTi_%i_%s_v1', 96+i, i, bldgIdCurr);
            sks_figureExport(exportName)
            cd(baseFolder)
        end
    end

    if doPlotFragDispers == 1
        figure(200+i); 
         idx = timePLIST <= 3.0;
        for k = 1:size(dsToPlotFragParam, 2)
            plot(timePLIST(idx), betaRTRCtrl(idx, k), lineStyleList{1, k}, 'LineWidth', 2); hold on; grid on;
        end
        legend(dsLegForPlot);   
        xlabel('$T_j $ (s)', 'Interpreter', 'latex'); 
        ylabel('$\beta_{RTR,ds,Sa(T_j)}$', 'Interpreter', 'latex');
        ylim([0.1 0.9]);
        if doPlotT1LinesInFragDisp == 1
            plot(T1LIST(i)*[1, 1], [0.1 0.899], 'r-', 'LineWidth', 1.25, 'HandleVisibility','off');
        end
        sks_figureFormat(formatMode)
        if saveMedianDispersionBound(2) == 1
            cd(outFolder)
            exportName = sprintf('F7%s_IMefficiency_betaRTRSaTi_%i_%s_v1', 96+i, i, bldgIdCurr);
            sks_figureExport(exportName)
            cd(baseFolder)            
        end
    end
    
    if doPlotFragBound == 1
        dsID = strcmpi(strtrim(ds), strtrim(dsToPlotBound{1}));
        muCtrlDs = muCtrlAllDs(:, dsID); % muCtrl corresponding to dsToPlot
        betaRTRCtrlDs = betaRTRCtrlAllDs(:, dsID); % betaRTRCtrl corresponding to dsToPlot
        IM_UB = muCtrlDs .* exp(betaRTRCtrlDs*UBEps); % intensity measure value with upper bound
        IM_LB = muCtrlDs .* exp(betaRTRCtrlDs*LBEps); % intensity measure value with lower bound
        figure(300+i); 
        clf;
        hold on; grid on;
        % --- Shade (±1σ) ---
        hShade = shade(timePLIST, IM_UB, timePLIST, IM_LB, 'FaceColor', [0.6 0.8 1], 'FaceAlpha', 0.3, 'EdgeColor', 'none');
        % --- Median ---
        hMed = plot(timePLIST, muCtrlDs, 'b-', 'LineWidth', 2);
        % --- Bounds (optional) ---
        plot(timePLIST, IM_UB, 'k--', 'LineWidth', 1.2);
        plot(timePLIST, IM_LB, 'k--', 'LineWidth', 1.2);
        % --- Correct legend mapping ---
        legend([hMed, hShade], {'Median', '$\pm 1\sigma$'}, 'Interpreter', 'latex');
        xlabel('Period, $T_j$ (s)', 'Interpreter', 'latex');
        ylabel('$\mu_{S_a(T_j)}$ (g)', 'Interpreter', 'latex');
        title(['Damage State = ', dsToPlotBound{1}]);
        sks_figureFormat(formatMode)
        if saveMedianDispersionBound(3) == 1
            cd(outFolder)
            exportName = sprintf('F7%s_IMefficiency_muSaTi%s_%i_%s_v1', 96+i, dsToPlotBound{1, 1}, i, bldgIdCurr);
            sks_figureExport(exportName)
            cd(baseFolder)            
        end
    end

end
Togm = prod(timePEff, 2).^(1/size(timePEff,2)); 
T = table(string(bldgIdLIST), timePEff, muCtrlEff, betaRTRCtrlMin, Togm);
disp(T); 
    
cd(baseFolder)
toc
 %% fragility is added on 12-Apr-2026 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

 sks_fragilityCurvesBasedOnMIDRDamageStates(muCtrlEff, betaRTRCtrlMin, dsLegForPlot)