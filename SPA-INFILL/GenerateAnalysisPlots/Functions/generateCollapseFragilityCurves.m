% This function is used to generate collapse fragility plots
function generateCollapseFragilityCurves(GCFCFunctionsDirectory,...
    collapseResults,Model,FrameLineNumber)
    
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%       Plot Baseline Logonormal and Empirical Collapse Fragility         %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    % Create blank figures
    figure1 = figure('Units','pixels','Position', [100 100 500 375]);
    axes1 = axes('Parent',figure1,'FontSize',14);
    ylim(axes1,[0 1]);
    xlim(axes1,[0 2*ceil(max(collapseResults.empiricalCollapseSas))]);
    hold on;
    
    % Create initial plot of data
    LinePlot = line(collapseResults.lognormalSas,collapseResults. ...
        lognormalCollapseProbabilities);
    set(LinePlot,'Color',[0 0 1],'LineStyle','-','LineWidth',3);
    plot(collapseResults.sortedEmpiricalCollapseSas,collapseResults. ...
        empiricalCollapseProbabilities,...
        'Marker','square','LineStyle','none');    
    
    % Add Legend
    hLegend = legend('Logonormal','Empirical','location','Best');
    legend boxoff  
    set(hLegend,'color','none');
    
    % Add axes labels
    xlabel({'Sa_T_1 (g)'},'FontSize',14);
    ylabel({'Probability of Collapse'},'FontSize',14);
    set(gca,'FontName','Helvetica','FontSize',14);
    
    % Creaet folder used to store collapse fragility curves
    if strcmp(Model,'3DModel') == 1
        cd(GCFCFunctionsDirectory)
        mkdir OpenSees3DModels 
        cd OpenSees3DModels
    elseif strcmp(Model,'XDirection2DModel') == 1
        cd(GCFCFunctionsDirectory)
        mkdir OpenSees2DModels
        cd OpenSees2DModels
        mkdir 'XDirectionFrameLines'
        cd XDirectionFrameLines
        FrameLineModelFolder = sprintf('Line_%d',FrameLineNumber);
        mkdir(FrameLineModelFolder)
        cd(FrameLineModelFolder)
    else
        cd(GCFCFunctionsDirectory)
        mkdir OpenSees2DModels
        cd OpenSees2DModels
        mkdir 'ZDirectionFrameLines'
        cd ZDirectionFrameLines
        FrameLineModelFolder = sprintf('Line_%d',FrameLineNumber);
        mkdir(FrameLineModelFolder)
        cd(FrameLineModelFolder)
    end    
     % Print plot to file
    saveas(figure1, 'CollapseFragilityPlot.fig');
%     close all
end

