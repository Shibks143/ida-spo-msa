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
%     % Word documents - single full width figure (OLDER)
%     xAxisLabelFontSize = 20;
%     yAxisLabelFontSize = 20;
%     axisNumberFontSize = 18;
%     legendTextFontSize = 14;
    
    % Word documents - any figure when I let it save the /emf file itself
    % and I later scale the figure in word to be 3" wide (half of page
    % width)
    xAxisLabelFontSize = 22;
    yAxisLabelFontSize = 22;
    axisNumberFontSize = 20;
    legendTextFontSize = 14;
    
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
        if(exist('legh', 'var'))
            if (ishandle(legh))
                set(legh, 'FontSize', legendTextFontSize);
            end
        end




