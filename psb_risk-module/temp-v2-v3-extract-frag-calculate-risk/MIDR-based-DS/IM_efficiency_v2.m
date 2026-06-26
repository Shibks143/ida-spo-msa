
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% Use script scriptForFragilityDataGen_v2 to generate the   %%%
%%% DATA_fragility_ALL.mat for all intensity measures, Sa(Tj) %%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

clear;
tic
baseFolder = pwd;
%% Start of input
dsToPlotFragParam = {'CP', 'LS', 'IO'};%, 'DynInst'};
dsToPlotBound = {'CP'}; %, 'LS', 'IO', 'DynInst'}; % one damage state at a time here. 
BldgIdAndZoneLIST = {
%     '2205v03',  'III';  '2207v09',	'III';	'2209v05',	'III'; ... % 4, 7, 12-story zone-III
    '2213v04',	'IV';   '2215v03',	'IV';   '2217v03',	'IV';%};  ... % 4, 7, 12-story zone-IV
    '2221v06',	'V';    '2223v03',	'V';    '2225v03',	'V'};      % 4, 7, 12-story zone-V
% BldgIdAndZoneLIST = {'2221v06',	'V';    '2223v03',	'V';    '2225v03',	'V'};      % 4, 7, 12-story zone-V
    
cd DATA_files
load('DATA_fragility_ALL')
cd ..
bldgIdLIST = [];

doPlotFragMedian = 0; % plot variation in median fragility parameter with the period of vibration
doPlotFragDispers = 1; % plot variation in dispersion fragility parameter with the period of vibration
doPlotFragBound = 0; % plot the bounds of fragility with the period of vibration
saveMedianDispersionBound = [0 1 0]; 

% for plotting fragility params with bound
UBPercentile = 0.84; LBPercentile = 1 - UBPercentile ;
UBEps = norminv(UBPercentile); LBEps = norminv(LBPercentile);

% end of input

%% program begins
for i = 1:size(BldgIdAndZoneLIST, 1) % for each building
    bldgIdCurr = BldgIdAndZoneLIST{i, 1};
    bldgIdLIST = [bldgIdLIST; bldgIdCurr];
    % variable name for storing building ID, this cannot begin with a numeral
    bldgIdVar = ['ID' bldgIdCurr '_sca2'];
    
    muCtrlAllDs = fragAllData.(bldgIdVar).muCtrl;
    betaRTRCtrlAllDs = fragAllData.(bldgIdVar).betaRTRCtrl;
    timePLIST = fragAllData.(bldgIdVar).timeP;
    ds = fragAllData.(bldgIdVar).ds;
    
%% take a subset of the data depending on the damage state of interest
    for j = 1:size(dsToPlotFragParam, 2)
        currDs = dsToPlotFragParam{1, j};
        dsMatchID = strcmp(ds, currDs);
        muCtrl(:, j) = muCtrlAllDs(:, dsMatchID);
        betaRTRCtrl(:, j) = betaRTRCtrlAllDs(:, dsMatchID);
    end
        
    
    
%% create a subset of betaRTR that we maybe interested in, for optimizing betaRTR 
    betaRTRCtrlSub = betaRTRCtrl(timePLIST <= 2.0, :);
    [M, I] = min(betaRTRCtrlSub);
    
    betaRTRCtrlMin(i, :) = M; % dispersion in the fragility for efficient intensity measure 
    muCtrlEff(i, :) = muCtrl(I)'; % median fragility for efficient intensity measure 
    timePEff(i, :) = timePLIST(I)'; % optimal period corresponding to efficient intensity measure
    
%     set(groot,'defaultAxesColorOrder', [0 0 0; 1 0 0; 0 0 1; 1 0 1]); % order of graphs changed to 'k', 'r', 'b'
    lineStyleList = {'k-', 'r--', 'b-.', 'm:'};
%% everything below is basically just for plotting
    if doPlotFragMedian == 1
        figure(i); 
        for k = 1:size(dsToPlotFragParam, 2)
            plot(timePLIST, muCtrl(:, k), lineStyleList{1, k}, 'LineWidth', 1.5); hold on; grid on;
        end
%         hleg = legend('CP', 'LS', 'IO', 'DynInst');
        hleg = legend(dsToPlotFragParam);
        hx = xlabel('Period, Ti (s)'); hy = ylabel('\mu_{ds,SaTi} (g)');
        psb_FigureFormatScript_forReport
        if saveMedianDispersionBound(1) == 1
            cd IM_efficiency_figures
            exportName = sprintf('F6%s_IMefficiency_muSaTi_%i_%s_v1', 96+i, i, bldgIdCurr);
            hgsave(exportName); % .fig file for Matlab
            print('-depsc', exportName); % .eps file for Linux (LaTeX)
            print('-dmeta', exportName); % .emf file for Windows (MSWORD)
            print('-dpng', exportName); % .png file for small sized files
            print('-djpeg', exportName); % .jpeg file for small sized files
            print('-djpeg', [exportName '_r300'], '-r300');
            cd ..
        end
    end
    if doPlotFragDispers == 1
        figure(100+i); 
        for k = 1:size(dsToPlotFragParam, 2)
            plot(timePLIST, betaRTRCtrl(:, k), lineStyleList{1, k}, 'LineWidth', 1.5); hold on; grid on;
        end
%         hleg = legend('CP', 'LS', 'IO', 'DynInst');
        hleg = legend(dsToPlotFragParam);    
   
        ylim([0.2 0.9]);
%         hx = xlabel('Period, $T_j (s)$'); hy = ylabel('$\beta_{RTR,ds,SaT_j}$');
        hx = xlabel('$T_j $ (s)', 'Interpreter', 'latex'); 
        hy = ylabel('$\beta_{RTR,ds,Sa(T_j)}$', 'Interpreter', 'latex');
        
        psb_FigureFormatScript_forReport
        if saveMedianDispersionBound(2) == 1
            cd IM_efficiency_figures
            exportName = sprintf('F6%s_IMefficiency_betaRTRSaTi_%i_%s_v1', 96+i, i, bldgIdCurr);
            hgsave(exportName); % .fig file for Matlab
            print('-depsc', exportName); % .eps file for Linux (LaTeX)
            print('-dmeta', exportName); % .emf file for Windows (MSWORD)
%             print('-dpng', exportName); % .png file for small sized files
%             print('-djpeg', exportName); % .jpeg file for small sized files
            print('-djpeg', [exportName '_r300'], '-r300');
            cd ..            
        end


        % COV for log-normal distribution is defined as sqrt(exp(\sig_ln^2-1)) 
        % which is monotonically increasing with \sig_ln. In other words, 
        % comparison of \sig_ln direcly is as good as comparing COV. 
%         figure(200+i); plot(timePLIST, betaRTRCtrl./muCtrl); hold on;
%         hleg = legend('CP', 'LS', 'IO', 'DynInst');
%         hx = xlabel('Period, T1 (s)'); hy = ylabel('COV_{SaT1}');
%         psb_FigureFormatScript_forReport
    end
    
    if doPlotFragBound == 1
        dsID = strcmp(ds, dsToPlotBound);
        muCtrlDs = muCtrlAllDs(:, dsID); % muCtrl corresponding to dsToPlot
        betaRTRCtrlDs = betaRTRCtrlAllDs(:, dsID); % betaRTRCtrl corresponding to dsToPlot

        IM_UB = muCtrlDs .* exp(betaRTRCtrlDs*UBEps); % intensity measure value with upper bound
        IM_LB = muCtrlDs .* exp(betaRTRCtrlDs*LBEps); % intensity measure value with lower bound
        figure(300+i); 
        shade(timePLIST, IM_UB, timePLIST, IM_LB,'FillType', [1 2;2 1]); hold on; grid on;
        h(1) = plot(timePLIST, muCtrlDs, 'k-'); 
        h(2) = plot(timePLIST, IM_UB, 'k--');
        h(3) = plot(timePLIST, IM_LB, 'k--');
        hleg = legend([h(1), h(2)], 'Median', '\pm 1 \sigma');
        hx = xlabel('Period, Ti (s)'); hy = ylabel('\mu_{SaTi} (g)');
        title(['Damage State = ', dsToPlotBound{1}]);
        psb_FigureFormatScript_forReport
        if saveMedianDispersionBound(3) == 1
            cd IM_efficiency_figures
            exportName = sprintf('F6%s_IMefficiency_muSaTi%s_%i_%s_v1', 96+i, dsToPlotBound{1, 1}, i, bldgIdCurr);
            hgsave(exportName); % .fig file for Matlab
            print('-depsc', exportName); % .eps file for Linux (LaTeX)
            print('-dmeta', exportName); % .emf file for Windows (MSWORD)
            print('-dpng', exportName); % .png file for small sized files
            print('-djpeg', exportName); % .jpeg file for small sized files
            print('-djpeg', [exportName '_r300'], '-r300');
            cd ..            
        end
    end

    
end
    T = table(bldgIdLIST, muCtrlEff, betaRTRCtrlMin, timePEff);
    disp(T)
    cd(baseFolder)
    toc
