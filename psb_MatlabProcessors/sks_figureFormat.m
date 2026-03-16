%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Master Figure Formatting Function
% Originally: CBH of Stanford University, haselton@stanford.edu
% 6-6-05
% Modernized by Shivakumar K S, IIT Madras (2026)
% Uses modern graphics (HG2)
%
% Usage:
%   sks_figureFormat('default')
%   sks_figureFormat('powerpoint')
%   sks_figureFormat('report')
%   sks_figureFormat('paper')
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function sks_figureFormat(formatMode)

% -------- Default Mode ----------------------------
if nargin == 0
    formatMode = 'powerpoint';
end
formatMode = lower(formatMode);

% -------- Set Font Sizes Based on Mode -----------
switch formatMode

    case 'default'
        % Word documents - any figure when I let it save the /emf file itself
        % and I later scale the figure in word to be 3" wide (half of page width)
        xAxisLabelFontSize = 22;
        yAxisLabelFontSize = 22;
        axisNumberFontSize = 20;
        legendTextFontSize = 14;
        titleFontSize      = 14;
        axisLineWidth      = 1.2;

    case 'powerpoint'
        xAxisLabelFontSize = 26;
        yAxisLabelFontSize = 26;
        axisNumberFontSize = 20;
        legendTextFontSize = 20;   % changed on 12-Mar-2026, just to check (old size =14)
        titleFontSize      = 20;   % changed on 12-Mar-2026, just to check (old size =14)
        axisLineWidth      = 1.5;

    case 'report'
        xAxisLabelFontSize = 14;
        yAxisLabelFontSize = 14;
        axisNumberFontSize = 14;
        legendTextFontSize = 12;
        titleFontSize      = 12;
        axisLineWidth      = 1.2;

    case 'paper'
        xAxisLabelFontSize = 16;
        yAxisLabelFontSize = 16;
        axisNumberFontSize = 14;
        legendTextFontSize = 12;
        titleFontSize      = 14;
        axisLineWidth      = 1.2;

    otherwise
        error('Mode must be: default, powerpoint, report, paper')
end

% -------- Get Handles -----------------------------
fig = gcf;
ax  = gca;

% -------- Axes Base Formatting --------------------
set(ax,'FontName','Times New Roman','FontSize',axisNumberFontSize,'LineWidth',axisLineWidth,'TickDir','in','TickLength',[0.005 0.005],'Box','on');
grid(ax,'off')

% -------- X Label ---------------------------------
if isgraphics(ax.XLabel)
    set(ax.XLabel,'FontSize',xAxisLabelFontSize,'FontWeight','bold','Interpreter','latex');
end

% -------- Y Label ---------------------------------
if isgraphics(ax.YLabel)
    set(ax.YLabel,'FontSize',yAxisLabelFontSize,'FontWeight','bold','Interpreter','latex');
end

% -------- Z Label --------------------------------- c 
if isgraphics(ax.ZLabel)
    set(ax.ZLabel,'FontSize',yAxisLabelFontSize,'FontWeight','bold','Interpreter','latex');
end

% -------- Title -----------------------------------
if isgraphics(ax.Title)
    set(ax.Title,'FontSize',titleFontSize,'Interpreter','latex');
end

% -------- Legend ----------------------------------
hleg = findobj(fig,'Type','Legend');
if ~isempty(hleg)
    set(hleg,'FontSize',legendTextFontSize,'Interpreter','latex','Box','off','Location','southeast');
end

end

















