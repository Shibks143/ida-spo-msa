%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% This file sets the defaults for the figures
% 6-6-05
% CBH of Stanford University, haselton@stanford.edu
%
% This assumes that the figure is open and you have 
%   defined the following handles when you created
%   your figure:
%       hx = handle for x-axis (i.e. hx = xlabel('text...'))
%       hy = handle for y-axis (i.e. hy = ylabel('text...'))
%       legh = handle for legend (i.e. legh = legend('text...'))
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Set inputs
    % Word dcouments - single full width figure 
    xAxisLabelFontSize = 10;
    yAxisLabelFontSize = 10;
    axisNumberFontSize = 10;
    legendTextFontSize = 10;
    
%     % PowerPoint
%     xAxisLabelFontSize = 26;
%     yAxisLabelFontSize = 26;
%     axisNumberFontSize = 20;
%     legendTextFontSize = 14;

% Alter the plot
    set(gca, 'FontSize', axisNumberFontSize);
    set(hx, 'FontSize', xAxisLabelFontSize);
    set(hy, 'FontSize', yAxisLabelFontSize);
    % Only adjust the legend if it has been defined
        if(exist('legh'))
            if (ishandle(legh))
                set(legh, 'FontSize', legendTextFontSize);
            end
        end




