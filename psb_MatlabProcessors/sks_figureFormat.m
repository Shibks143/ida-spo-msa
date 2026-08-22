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
        axisLineWidth      = 0.75;  % changed on 17-June-2026, just to check (old size =1.2)
        textFontSize       = 14;

    case 'powerpoint'
        xAxisLabelFontSize = 26;    % changed on 19-July-2026, just to check (old size =26)   
        yAxisLabelFontSize = 26;
        axisNumberFontSize = 24;    % changed on 19-July-2026, just to check (old size =20) 
        legendTextFontSize = 18;    % changed on 12-Mar-2026, just to check (old size =20)
        titleFontSize      = 24;    % changed on 12-Mar-2026, just to check (old size =20)
        axisLineWidth      = 0.75;  % changed on 17-June-2026, just to check (old size =1.0)
        textFontSize       = 24;    % added on 17-July-2026, for dimensional lines

    case 'report'
        xAxisLabelFontSize = 14;
        yAxisLabelFontSize = 14;
        axisNumberFontSize = 14;
        legendTextFontSize = 12;
        titleFontSize      = 12;
        axisLineWidth      = 0.75; % changed on 17-June-2026, just to check (old size =1.2)
        textFontSize       = 12;
    
    case 'paper'
        xAxisLabelFontSize = 16;
        yAxisLabelFontSize = 16;
        axisNumberFontSize = 14;
        legendTextFontSize = 12;
        titleFontSize      = 14;
        axisLineWidth      = 0.75; % changed on 17-June-2026, just to check (old size =1.2)
        textFontSize       = 14;


    otherwise
        error('Mode must be: default, powerpoint, report, paper')
end

% -------- Get Handles -----------------------------
fig = gcf;
ax  = gca;

% -------- Axes Base Formatting --------------------
set(ax,'FontName','Times New Roman','FontSize',axisNumberFontSize,'LineWidth',axisLineWidth,'TickDir','in','TickLength',[0.005 0.005],'Box','on');
grid(ax,'on')
ax.GridAlpha = 0.1;        % 0.2 can be used 
ax.GridLineWidth = 0.25;   % 0.5 by default but for thinner grid lines, it is 0.25


% This is only for loglog plots----------------------
% grid(ax,'minor')
% ax.MinorGridAlpha = 0.10;
% ax.XMinorTick = 'on';
% ax.YMinorTick = 'on';
% ax.XMinorGrid = 'on';
% ax.YMinorGrid = 'on';
% end of this is only for loglog plots, otherwise use below off condition--------------

ax.XMinorTick = 'off';
ax.YMinorTick = 'off';
ax.XMinorGrid = 'off';
ax.YMinorGrid = 'off';

% -------- X Label ---------------------------------
if isgraphics(ax.XLabel)
    set(ax.XLabel,'FontSize',xAxisLabelFontSize,'FontWeight','normal','Interpreter','latex');
end

% -------- Y Label ---------------------------------
if isgraphics(ax.YLabel)
    set(ax.YLabel,'FontSize',yAxisLabelFontSize,'FontWeight','normal','Interpreter','latex');
end

% -------- Z Label --------------------------------- c
if isgraphics(ax.ZLabel)
    set(ax.ZLabel,'FontSize',yAxisLabelFontSize,'FontWeight','normal','Interpreter','latex');
end

% -------- Title -----------------------------------
if isgraphics(ax.Title)
    set(ax.Title,'FontSize',titleFontSize,'Interpreter','latex');
end

% -------- Legend ----------------------------------
hleg = findobj(fig,'Type','Legend');
if ~isempty(hleg)
    set(hleg,'FontSize',legendTextFontSize,'Interpreter','latex','Box','on','LineWidth',0.5,'Location','northeast');
end

% -------- All text() objects ----------------------
hText = findall(fig,'Type','text');

for i = 1:length(hText)

    % Skip axis labels and title
    if isequal(hText(i),ax.Title) || ...
            isequal(hText(i),ax.XLabel) || ...
            isequal(hText(i),ax.YLabel) || ...
            isequal(hText(i),ax.ZLabel)
        continue
    end
    set(hText(i), ...
        'FontSize', textFontSize, ...
        'Interpreter', 'latex');
end

end

















