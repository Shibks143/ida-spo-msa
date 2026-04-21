
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% Use script: scriptForFragilityDataGen_v2 to generate the   %%%
%%% DATA_fragility_ALL.mat for all intensity measures, Sa(Tj) %%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

clear;
tic
baseFolder = pwd;
%% Start of input
dsToPlotFragParam = {'DynInst','CP', 'LS', 'IO'};%, 'DynInst'};
dsToPlotBound = {'DynInst','CP','LS','IO'};
% dsToPlotBound = {'CP'}; %, 'LS', 'IO', 'DynInst'}; % one damage state at a time here. 
BldgIdAndZoneLIST = { '2433v02', 'V'; };


% %     '2205v03',  'III';  '2207v09',	'III';	'2209v05',	'III'; ... % 4, 7, 12-story zone-III
%     '2213v04',	'IV';   '2215v03',	'IV';   '2217v03',	'IV';%};  ... % 4, 7, 12-story zone-IV
%     '2221v06',	'V';    '2223v03',	'V';    '2225v03',	'V'};      % 4, 7, 12-story zone-V
% % BldgIdAndZoneLIST = {'2221v06',	'V';    '2223v03',	'V';    '2225v03',	'V'};      % 4, 7, 12-story zone-V
    
cd DATA_files
load('DATA_fragility_ALL')
cd ..
bldgIdLIST = {};

doPlotFragMedian = 1; % plot variation in median fragility parameter with the period of vibration
doPlotFragDispers = 1; % plot variation in dispersion fragility parameter with the period of vibration
doPlotFragBound = 1; % plot the bounds of fragility with the period of vibration
doPlotT1LinesInFragDisp = 1;
T1LIST = [1.84]';

saveMedianDispersionBound = [1 1 1]; 
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
    % timePLIST =[1.72];
    ds = fragAllData.(bldgIdVar).ds;
    
%% take a subset of the data depending on the damage state of interest
    for j = 1:nDs
        currDs = dsToPlotFragParam{1, j};
        dsMatchID = strcmp(ds, currDs);
        muCtrl(:, j) = muCtrlAllDs(:, dsMatchID);
        betaRTRCtrl(:, j) = betaRTRCtrlAllDs(:, dsMatchID);
    end
        
    
%% create a subset of betaRTR that we maybe interested in, for optimizing betaRTR 
    betaRTRCtrlSub = betaRTRCtrl(timePLIST <= 3.0, :);
    [M, I] = min(betaRTRCtrlSub);
    
    betaRTRCtrlMin(i, :) = M; % dispersion in the fragility for efficient intensity measure 
    for j = 1:nDs
        muCtrlEff(i, j) = muCtrl(I(j), j)'; % median fragility for efficient intensity measure 
    end
    timePEff(i, :) = timePLIST(I)'; % optimal period corresponding to efficient intensity measure
    
%     set(groot,'defaultAxesColorOrder', [0 0 0; 1 0 0; 0 0 1; 1 0 1]); % order of graphs changed to 'k', 'r', 'b'
    lineStyleList = {'k-', 'r--', 'b-.', 'm:'};
%% everything below is basically just for plotting
    
if doPlotFragMedian == 1
    figure(i); hold on; grid on

    for k = 1:size(dsToPlotFragParam, 2)
        plot(timePLIST, muCtrl(:, k), lineStyleList{k}, 'LineWidth', 1.5);
    end

    legend(dsToPlotFragParam);
    xlabel('$T_j$ (s)');
    ylabel('$\mu_{ds,Sa(T_j)}$ (g)');
    sks_figureFormat('powerpoint')

    if saveMedianDispersionBound(1) == 1
        exportName = sprintf('IM_efficiency_figures/F6%s_IMefficiency_muSaTi_%i_%s_v1', 96+i, i, bldgIdCurr);
        sks_figureExport(exportName)
    end
end


if doPlotFragDispers == 1
    figure(100+i); hold on; grid on
    
    idx = timePLIST <= 3.0;
    for k = 1:size(dsToPlotFragParam, 2)
        plot(timePLIST(idx), betaRTRCtrl(idx, k), lineStyleList{k}, 'LineWidth', 1.5);
    end
    % ---- Set axis limits first (important) ----
    ylim([0.1 0.9]);

    if doPlotT1LinesInFragDisp == 1
        yl = ylim;
        plot(T1LIST(i)*[1, 1], yl,'r-', 'LineWidth', 2, 'HandleVisibility','off');
        % plot(T1LIST(i)*[1, 1], yl, 'LineWidth', 1.5, 'Color', 'k','HandleVisibility','off');
    end
    % ============================

    legend(dsToPlotFragParam);
    xlabel('$T_j$ (s)');
    ylabel('$\beta_{RTR,ds,Sa(T_j)}$');
    sks_figureFormat('powerpoint')

    if saveMedianDispersionBound(2) == 1
        exportName = sprintf('IM_efficiency_figures/F6%s_IMefficiency_betaRTRSaTi_%i_%s_v1',96+i, i, bldgIdCurr);
        sks_figureExport(exportName)
    end
end

if doPlotFragBound == 1
    for d = 1:length(dsToPlotBound)
        currDs = dsToPlotBound{d};
        dsID = strcmp(ds, currDs);
        muCtrlDs = muCtrlAllDs(:, dsID);
        betaRTRCtrlDs = betaRTRCtrlAllDs(:, dsID);

        IM_UB = muCtrlDs .* exp(betaRTRCtrlDs*UBEps);
        IM_LB = muCtrlDs .* exp(betaRTRCtrlDs*LBEps);
        figure(300+i+d); hold on; grid on

        % ---- shaded region (light blue) ----
        hshade = shade(timePLIST, IM_UB, timePLIST, IM_LB);
        set(hshade,'FaceColor',[0.75 0.85 1], 'FaceAlpha',0.5,'EdgeColor','none');
        h1 = plot(timePLIST, muCtrlDs, 'Color',[0 0.2 0.8], 'LineWidth',2);
        h2 = plot(timePLIST, IM_UB, '--','Color',[0.85 0 0], 'LineWidth',1.5);
        h3 = plot(timePLIST, IM_LB, '--', 'Color',[0.85 0 0], 'LineWidth',1.5);
        legend([h1 h2], {'Median','$\pm 1\sigma$'});
        % plot(timePLIST, IM_LB, '--', 'Color',[0.85 0 0], 'LineWidth',1.5);
        % legend([h1 h2],'Median','\pm 1 \sigma');

        xlabel('$T_j$ (s)');
        ylabel('$\mu_{Sa(T_j)}$ (g)');
        title(['Damage State = ', currDs]);
        sks_figureFormat('powerpoint')

        if saveMedianDispersionBound(3) == 1
            exportName = sprintf( ...
                'IM_efficiency_figures/F6%s_IMefficiency_muSaTj%s_%i_%s_v1', 96+i, currDs, i, bldgIdCurr);

            sks_figureExport(exportName)
        end
    end
end 
    
end
Togm = prod(timePEff, 2).^(1/size(timePEff,2));
T = table(bldgIdLIST, timePEff, muCtrlEff, betaRTRCtrlMin,Togm);
disp(T)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% Togm-based IM evaluation (added post-processing) %%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

muCtrlEff_Togm = zeros(length(bldgIdLIST), nDs);
betaRTRCtrl_Togm = zeros(length(bldgIdLIST), nDs);

for i = 1:length(bldgIdLIST)

    bldgIdCurr = BldgIdAndZoneLIST{i, 1};
    bldgIdVar = ['ID' bldgIdCurr];

    muCtrlAllDs = fragAllData.(bldgIdVar).muCtrl;
    betaRTRCtrlAllDs = fragAllData.(bldgIdVar).betaRTRCtrl;
    timePLIST = fragAllData.(bldgIdVar).timeP;
    ds = fragAllData.(bldgIdVar).ds;

    T_query = Togm(i);   % use previously computed Togm

    for j = 1:nDs

        currDs = dsToPlotFragParam{1, j};
        dsMatchID = strcmp(ds, currDs);

        muCurve = muCtrlAllDs(:, dsMatchID);
        betaCurve = betaRTRCtrlAllDs(:, dsMatchID);

        % interpolation at Togm
        muCtrlEff_Togm(i, j) = interp1(timePLIST, muCurve, T_query, 'linear');
        betaRTRCtrl_Togm(i, j) = interp1(timePLIST, betaCurve, T_query, 'linear');

    end
end

T_Togm = table(bldgIdLIST, Togm, muCtrlEff_Togm, betaRTRCtrl_Togm);
disp('================ Togm-based IM Results ================')
disp(T_Togm)

% T = table(bldgIdLIST, muCtrlEff, betaRTRCtrlMin, timePEff);
    cd(baseFolder)
    toc
%% fragility is added on 12-Apr-2026 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

sks_fragilityCurvesBasedOnMIDRDamageStates(muCtrlEff, betaRTRCtrlMin, dsToPlotFragParam)