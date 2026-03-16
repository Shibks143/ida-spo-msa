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
    xAxisLabelFontSize = 14;
    yAxisLabelFontSize = 14;
    axisNumberFontSize = 12;
    legendTextFontSize = 14;


% Alter the plot
    set(gca, 'FontSize', axisNumberFontSize);
    set(hx, 'FontSize', xAxisLabelFontSize);
    set(hy, 'FontSize', yAxisLabelFontSize);
    set(legh, 'FontSize', legendTextFontSize);




