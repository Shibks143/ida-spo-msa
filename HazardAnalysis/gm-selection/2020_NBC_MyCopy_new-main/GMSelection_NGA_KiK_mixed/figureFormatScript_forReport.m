
% Set inputs
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
