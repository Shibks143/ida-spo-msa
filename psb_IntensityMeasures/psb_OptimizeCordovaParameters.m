function [optimumRat, optimumAlphaForOptimumRat] = psb_OptimizeCordovaParameters(analysisTypeFolder, eqListForCollapseIDAs_Name, T1, dampRat, processAllComp, doPlotSaveCAlpha)

baseFolder = pwd;

% analysisTypeFolder = '(CivilBldg_3story_ID9901_v.02_trying)_(AllVar)_(0.00)_(clough)';
% T1 = 1.02;
% dampRat = 0.05;

% processAllComp = 1; % 1- all component; 0- control component
% saveMatFile = 1; % 1- Aye! save it; 0- Nay! don't save it
% doPlotSaveCDF = 1; % 1- plotCDF and save it
% doPlotSaveCAlpha = 1; % 1- plot optimum C-alpha and optimum sigma graphs

ratMin = 1.2;
ratMax = 3.0;
ratIncr = 0.05;

cd ..
cd Output
cd(analysisTypeFolder)

% load('DATA_collapse_CollapseSaAndStats_GMSetC_SaGeoMean.mat');
colFileName = sprintf('DATA_collapse_CollapseSaAndStats_%s_SaGeoMean.mat', eqListForCollapseIDAs_Name);
load(colFileName);        

if processAllComp == 0
    collapseLevelSaLIST = collapseLevelForAllControlComp;
    eqLIST = ControllingCompNumLIST;
else
    collapseLevelSaLIST = collapseLevelForAllComp;
    eqLIST = eqCompNumberLIST;
end 

ratioOfTimePeriods = ratMin:ratIncr:ratMax;
optimumAlpha = zeros(length(ratioOfTimePeriods), 1); % initiate
optimumSigma = zeros(length(ratioOfTimePeriods), 1);

parfor ratIndex = 1:length(ratioOfTimePeriods)
    currenRat = ratioOfTimePeriods(ratIndex);
     [~, optimumSigma(ratIndex)] = psb_ConvertToCordovaTwoParameterIM(collapseLevelSaLIST, eqLIST, T1, dampRat, 0.1, currenRat); % initiate optimum sigma value
        for alpha = 0.15:0.05:3.0
            [~, currentSigma] = psb_ConvertToCordovaTwoParameterIM(collapseLevelSaLIST, eqLIST, T1, dampRat, alpha, currenRat);
            if currentSigma < optimumSigma(ratIndex)
                optimumSigma(ratIndex) = currentSigma;
                optimumAlpha(ratIndex) = alpha;
            end
        end
end

[optimumValueOfSig, alphaIndex] = min(optimumSigma);
optimumAlphaForOptimumRat = optimumAlpha(alphaIndex);
optimumRat = ratioOfTimePeriods(alphaIndex);

disp(['Optimum Time Period Ratio = ', num2str(round(optimumRat * 1000)/1000)]);
disp(['Optimum Alpha For Optimum Time Period Ratio = ', num2str(round(optimumAlphaForOptimumRat * 1000)/1000)]);
disp(['Optimum sigma = ', num2str(round(optimumValueOfSig * 1000)/1000)]);



%% Plot C alpha and optimum sigma files if asked by the user
if doPlotSaveCAlpha == 1
    figure(1)
    plot(ratioOfTimePeriods, optimumAlpha, 'r-o', 'LineWidth', 2.5); grid on;
        str1 = '$C = T_f / T_1 \rightarrow$'; 
        str2 = '$\alpha \rightarrow$';
        str3 = 'Optimum C-\alpha pairs';
    %     strForLegend = sprintf('$\mu_{S_a(T_1)} = %4.3f, \sigma_{ln S_a(T_1)} = %4.2f', exp(meanLnCollapseSaTOneAllComp), stDevLnCollapseSaTOneAllComp);

        hx = xlabel(str1, 'Interpreter', 'latex'); hy = ylabel(str2, 'Interpreter', 'latex');
        htitle = title(str3); 
        h_legend = legend(['building ID' num2str(9901)]);

        psb_FigureFormatScript;

    if processAllComp == 1
        exportName = sprintf('OptimumCAlphaPairs_AllComp_%s.eps', analysisTypeFolder);
        plotName = sprintf('OptimumCAlphaPairs_AllComp_%s.fig', analysisTypeFolder);
    else
        exportName = sprintf('OptimumCAlphaPairs_ControlComp_%s.eps', analysisTypeFolder);
        plotName = sprintf('OptimumCAlphaPairs_ControlComp_%s.fig', analysisTypeFolder);
    end
    
        hgsave(plotName);
        print('-depsc', exportName);
        disp(['Files saved as ', fullfile(pwd, exportName)]);

        clearvars hx hy htitle h_legend

    figure(2)
    plot(ratioOfTimePeriods, optimumSigma, 'r-o', 'LineWidth', 2.5); grid on;
        str1 = '$C = T_f / T_1 \rightarrow$'; 
        str2 = '$\sigma_{ln IM_{new}}\rightarrow$';
        str3 = 'Optimum \sigma for C-\alpha pairs';
    %     strForLegend = sprintf('$\mu_{S_a(T_1)} = %4.3f, \sigma_{ln S_a(T_1)} = %4.2f', exp(meanLnCollapseSaTOneAllComp), stDevLnCollapseSaTOneAllComp);

        hx = xlabel(str1, 'Interpreter', 'latex'); hy = ylabel(str2, 'Interpreter', 'latex');
        htitle = title(str3); 
        h_legend = legend(['building ID' num2str(9901)]);

        psb_FigureFormatScript;

    if processAllComp == 1
        plotName = sprintf('OptimumSigma_AllComp_%s.fig', analysisTypeFolder);
        exportName = sprintf('OptimumSigma_AllComp_%s.eps', analysisTypeFolder);
    else
        plotName = sprintf('OptimumSigma_ControlComp_%s.fig', analysisTypeFolder);
        exportName = sprintf('OptimumSigma_ControlComp_%s.eps', analysisTypeFolder);
    end
    
        hgsave(plotName);
        print('-depsc', exportName);
        disp(['Files saved as ', fullfile(pwd, exportName)]);

        clearvars hx hy htitle h_legend
end






cd(baseFolder)

toc




