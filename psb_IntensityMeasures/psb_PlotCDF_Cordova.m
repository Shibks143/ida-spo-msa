function psb_PlotCDF_Cordova(analysisTypeFolder, eqListForCollapseIDAs_Cordova_Name, processAllComp, T1, dampRat, alpha, periodRat, doPlotSaveCDF)
baseFolder = pwd;

% analysisTypeFolder = '(CivilBldg_3story_ID9901_v.02_trying)_(AllVar)_(0.00)_(clough)';
% processAllComp = 1;
% T1 = 1.02;
% dampRat = 0.05;
% alpha = 0.5;
% periodRat = 2;
% doPlotSaveCDF = 1;

cd ..
cd Output
cd(analysisTypeFolder)

% load('DATA_collapse_CollapseSaAndStats_GMSetC_SaGeoMean.mat');
colFileName = sprintf('DATA_collapse_CollapseSaAndStats_%s_SaGeoMean.mat', eqListForCollapseIDAs_Cordova_Name);
load(colFileName, 'collapseLevelForAllControlComp', 'collapseLevelForAllComp', 'ControllingCompNumLIST', 'eqCompNumberLIST');

% load('DATA_collapse_CollapseSaAndStats_GMSetC_SaGeoMean.mat', 'collapseLevelForAllControlComp', 'collapseLevelForAllComp', 'ControllingCompNumLIST', 'eqCompNumberLIST');

if processAllComp == 1
    collapseLevelSaLIST = collapseLevelForAllComp;
    eqLIST = eqCompNumberLIST;
else
    collapseLevelSaLIST = collapseLevelForAllControlComp;
    eqLIST = ControllingCompNumLIST;
end 


[collapseLevelCordovaLIST, ~] = psb_ConvertToCordovaTwoParameterIM(collapseLevelSaLIST, eqLIST, T1, dampRat, alpha, periodRat);

    Tf = round(periodRat * T1 * 100) / 100;
    
    meanCollapseCordova = mean(collapseLevelCordovaLIST);
    medianCollapseCordova = median(collapseLevelCordovaLIST);
    meanLnCollapseCordova = mean(log(collapseLevelCordovaLIST));
    stDevCollapseCordova = std(collapseLevelCordovaLIST);
    stDevLnCollapseCordova = std(log(collapseLevelCordovaLIST));

% just for saving in mat file
    meanCollapseSaTOne = mean(collapseLevelSaLIST);
    medianCollapseSaTOne = (median(collapseLevelSaLIST));
    meanLnCollapseSaTOne = mean(log(collapseLevelSaLIST));
    stDevCollapseSaTOne = std(collapseLevelSaLIST);
    stDevLnCollapseSaTOne = std(log(collapseLevelSaLIST));
    
    
% %% Save the data file if asked by the function    
% if saveMatFile == 1
%     fileNameToSave = sprintf('DATA_CordovaIntensityMeasure.mat');
%     save DATA_CordovaIntensityMeasure.mat collapseLevelSaLIST T1 Tf eqLIST collapseLevelCordoveaLIST dampRat ...
%         meanCollapseCordova meanCollapseSaTOne meanLnCollapseCordova meanLnCollapseSaTOne medianCollapseCordova medianCollapseSaTOne ...
%         stDevCollapseSaTOne stDevCollapseCordova stDevLnCollapseCordova stDevLnCollapseSaTOne;
%     disp(['Saved the data file as ' fullfile(pwd, fileNameToSave)]);
% end

%% Plot the fragility with new Intensity Measures- S_a(T_1) * (S_a(T_f) / S_a(T_1)) ^ \alpha
                % Plot CDF and SaveMatFile = 1 for the optimum values
if doPlotSaveCDF == 1
    minValueForPlot = 0.0;
    maxValueForPlot = 2.0; % change it, if so be the need
    markerTypeSaTOneForLognormal = 'r-';
    markerTypeCordovaForLognormal = 'b-';
    markerTypeForIndivColResults = 'rs';
    markerFaceColorForIndivColResults = 'w';

    figure(101)
    
    % Sort the vector of collapse capacities so that it is monotonically increasing
    collapseLevelCordova_sorted = sort(collapseLevelCordovaLIST);
    numEQs = length(collapseLevelCordovaLIST);
    % Created the cumm. prob values for each Sa,col
    cummulativeProbOfCollapseEmpirical = [(1/numEQs):(1/numEQs):1.0];

% Plot the empirical CDF
    plot(collapseLevelCordova_sorted, cummulativeProbOfCollapseEmpirical, markerTypeForIndivColResults, 'MarkerFaceColor', markerFaceColorForIndivColResults);
    hold on; grid on;
    PlotLogNormalCDF(meanLnCollapseCordova, stDevLnCollapseCordova, minValueForPlot, maxValueForPlot, markerTypeCordovaForLognormal)
    
    str1 = '$S_a * R_{S_a}^\alpha [g] \rightarrow$'; 
    str2 = '${\rm I\!P} [collapse] \rightarrow$';
    str3 = 'Vulnerability Curve Conditional on Two-Parameter Intensity Measure';
%     strForLegend = sprintf('$\mu_{S_a R_{Sa}} = %4.3f, \sigma_{ln {S_a R_{Sa}}} = %4.2f', exp(meanLnCollapseCordova), stDevLnCollapseCordova);
    
    hx = xlabel(str1, 'Interpreter', 'latex'); hy = ylabel(str2, 'Interpreter', 'latex');
    htitle = title(str3); 

    limitsOfAxes = axis;
    XdimOfAxis = limitsOfAxes(2) - limitsOfAxes(1);
    YdimOfAxis = limitsOfAxes(4) - limitsOfAxes(3);
    pos = [limitsOfAxes(1) + 0.70 * XdimOfAxis limitsOfAxes(3) + 0.90 * YdimOfAxis];
    text(pos(1), pos(2), {['$$\mu_{S*} = ' num2str(round(exp(meanLnCollapseCordova)*1000)/1000) '$$' char(10) '$$\beta_{ln S*} = ' num2str(round(stDevLnCollapseCordova*1000)/1000) '$$']}, 'Interpreter', 'latex', 'FontSize', 20, 'FontWeight', 'bold', 'BackgroundColor', [0.875 0.875 0.875]);
    
    psb_FigureFormatScript;
    
%%%%%%%%%%%%%% save the plot
    grid on;
    
    
    if processAllComp == 1
        plotName = sprintf('CollapseCDF_CORDOVA_AllComp_%s.fig', analysisTypeFolder);
        exportName = sprintf('CollapseCDF_CORDOVA_AllComp_%s.eps', analysisTypeFolder);
    else
        plotName = sprintf('CollapseCDF_CORDOVA_ControlComp_%s.fig', analysisTypeFolder);
        exportName = sprintf('CollapseCDF_CORDOVA_ControlComp_%s.eps', analysisTypeFolder);
    end
    
    hgsave(plotName);
    print('-depsc', exportName);

    disp(['CDFs saved as ', fullfile(pwd, exportName)]);
    
    cd(baseFolder)
end





