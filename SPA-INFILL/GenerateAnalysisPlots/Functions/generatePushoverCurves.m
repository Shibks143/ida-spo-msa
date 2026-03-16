% This function is used to generate pushover plots
function generatePushoverCurves(AnalysisPlotsDirectory,...
    pushoverResults,Model,FrameLineNumber)
    
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                         Plot Pushover Curves                            %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    % Create blank figures
    figure1 = figure('Units','pixels','Position', [100 100 500 375]);
    axes1 = axes('Parent',figure1,'FontSize',14);
    ylim(axes1,[0 1]);
    xlim(axes1,[0 max(pushoverResults.roofDrift)]);
    hold on;
    
    % Create initial plot of data
    LinePlot = line(pushoverResults.roofDrift,-pushoverResults.baseShear);
    set(LinePlot,'Color',[0 0 1],'LineStyle','-','LineWidth',3);   
    
    % Add axes labels
    xlabel({'Roof Drift Ratio'},'FontSize',14);
    ylabel({'Normalized Base Shear V/W'},'FontSize',14);
    set(gca,'FontName','Helvetica','FontSize',14);
    
    % Creaet folder used to store pushover curves
    if strcmp(Model,'XDirection3DModel') == 1
        cd(AnalysisPlotsDirectory)
        mkdir OpenSees3DModels 
        cd OpenSees3DModels
        % Print plot to file
        saveas(figure1, 'XDirectionPushoverPlot.fig');
    elseif strcmp(Model,'ZDirection3DModel') == 1
        cd(AnalysisPlotsDirectory)
        mkdir OpenSees3DModels 
        cd OpenSees3DModels
        % Print plot to file
        saveas(figure1, 'ZDirectionPushoverPlot.fig');
    elseif strcmp(Model,'XDirection2DModel') == 1
        cd(AnalysisPlotsDirectory)
        mkdir OpenSees2DModels
        cd OpenSees2DModels
        mkdir 'XDirectionFrameLines'
        cd XDirectionFrameLines
        FrameLineModelFolder = sprintf('Line_%d',FrameLineNumber);
        mkdir(FrameLineModelFolder)
        cd(FrameLineModelFolder)
        % Print plot to file
        saveas(figure1, 'PushoverPlot.fig');
    else
        cd(AnalysisPlotsDirectory)
        mkdir OpenSees2DModels
        cd OpenSees2DModels
        mkdir 'ZDirectionFrameLines'
        cd ZDirectionFrameLines
        FrameLineModelFolder = sprintf('Line_%d',FrameLineNumber);
        mkdir(FrameLineModelFolder)
        cd(FrameLineModelFolder)
        % Print plot to file
        saveas(figure1, 'PushoverPlot.fig');
    end
    close all
end

