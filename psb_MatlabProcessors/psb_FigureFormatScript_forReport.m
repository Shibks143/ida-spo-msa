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
%     % Word dcouments - single full width figure (OLDER)
%     xAxisLabelFontSize = 20;
%     yAxisLabelFontSize = 20;
%     axisNumberFontSize = 18;
%     legendTextFontSize = 14;
    
    % Word dcouments - any figure when I let it save the /emf file itself
    % and I later scale the figure in word to be 3" wide (half of page
    % width)
%     xAxisLabelFontSize = 16;
%     yAxisLabelFontSize = 16;
%     axisNumberFontSize = 16;
%     legendTextFontSize = 12;
%     titleFontSize = 14;
    
    xAxisLabelFontSize = 14;
    yAxisLabelFontSize = 14;
    axisNumberFontSize = 14;
    legendTextFontSize = 12;
    titleFontSize = 12;

    
%     % PowerPoint
%     xAxisLabelFontSize = 26;
%     yAxisLabelFontSize = 26;
%     axisNumberFontSize = 20;
%     legendTextFontSize = 14;
%     titleFontSize = 14;

% Alter the plot
    set(gca, 'FontSize', axisNumberFontSize);
%     set(hx, 'FontSize', xAxisLabelFontSize);
%     set(hy, 'FontSize', yAxisLabelFontSize);

        if(exist('hx', 'var'))
            if (ishandle(hx))
                set(hx, 'FontSize', xAxisLabelFontSize);
            end
        end
        
        if(exist('hy', 'var'))
            if (ishandle(hy))
                set(hy, 'FontSize', yAxisLabelFontSize);
            end
        end

    % Only adjust the legend if it has been defined
        if(exist('legh', 'var'))
            if (ishandle(legh))
                set(legh, 'FontSize', legendTextFontSize);
            end
        end
        if(exist('hlegend', 'var'))
            if (ishandle(hlegend))
                set(hlegend, 'FontSize', legendTextFontSize);
            end
        end
        if(exist('htitle', 'var'))
            if(ishandle(htitle))
                set(htitle, 'FontSize', titleFontSize);
            end
        end





