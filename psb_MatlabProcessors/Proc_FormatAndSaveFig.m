% Procedure: Proc_FormatAndSaveFig.m
% ---------------------------------------------------------------------
%   This is a procedure to format and save the figure as .fig and .emf.
%
% Author: Curt Haselton 
% Date Written: 9-1-06
% ---------------------------------------------------------------------

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Do labels and format the plot
    grid on 
    box on
    hy = ylabel(yLabel);
    hx = xlabel(xLabel);
    
    % Format the plot
    set(gca, 'FontSize', axisNumberFontSize);
    set(hx, 'FontSize', xAxisLabelFontSize);
    set(hy, 'FontSize', yAxisLabelFontSize);
    % Only adjust the legend if it has been defined
        if(exist('legh'))
            if (ishandle(legh))
                set(legh, 'FontSize', legendTextFontSize);
            end
        end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Save the figure
    % Save the plot as a .fig file
    plotName = sprintf('%s.fig', fileName);
    hgsave(plotName);
    % Export the plot as a .emf file (Matlab book page 455)
    exportName = sprintf('%s.emf', fileName);
    print('-dmeta', exportName);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%   

hold off
















