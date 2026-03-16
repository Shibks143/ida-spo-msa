% Load saved figures
% c=hgload('MyFirstFigure.fig');
% k=hgload('MySecondFigure.fig');

g(1) = hgload('Pushover_Num_9991_(ID3040_R0_4Story_v_02)_(AllVar)_(0_00)_(clough).fig');
g(2) = hgload('Pushover_Num_9991_(ID3042_R0_4Story_v_02)_(AllVar)_(0_00)_(clough).fig');
g(3) = hgload('Pushover_Num_9991_(ID3044_R0_4Story_v_02)_(AllVar)_(0_00)_(clough).fig');
g(4) = hgload('Pushover_Num_9991_(ID3045_R0_4Story_v_02)_(AllVar)_(0_00)_(clough).fig');
titleLIST = {'3040', '3042', '3044', '3045'};

xlabelText = get(gca,'xlabel'); ylabelText = get(gca,'ylabel');

% Prepare subplots
figure
for i = 1:4
    h(i)=subplot(2,2,i);
    xlabel(xlabelText.String);
    ylabel(ylabelText.String);
    title(['Bldg. ID- ', titleLIST{i}]);
end

% Paste figures on the subplots
for i = 1:4
    copyobj(allchild(get(g(i),'CurrentAxes')),h(i));
end

% xlim(h(1),[0 0.03]); ylim(h(1),[0 500]);
% xlim(h(2),[0 0.025]); ylim(h(2),[0 500]);
% xlim(h(3),[0 0.05]); ylim(h(3),[0 600]);
% xlim(h(4),[0 0.05]); ylim(h(4),[0 500]);

for i = 1:4
    xlim(h(i),[0 0.05]); ylim(h(i),[0 600]);
    close(g(i));
end

   exportName = sprintf('Pushover_3040_3042_3044_3045_v2');
   hgsave(exportName); % .fig file for Matlab
   
%    print('-depsc', exportName); % .eps file for Linux (LaTeX)
%    print('-dmeta', exportName); % .emf file for Windows (MSWORD)
%    print('-dpng', exportName); % .png file for small sized files
%    print('-djpeg', exportName); % .jpeg file for small sized files
%    print('-djpeg', [exportName '_r300'], '-r300');
%    print('-dpng','-r300',[exportName '-r300'])
   
% Add legends
% l(1)=legend(h(1),'LegendForFirstFigure');
% l(2)=legend(h(2),'LegendForSecondFigure');
% l(3)=legend(h(3),'LegendForSecondFigure');
% l(4)=legend(h(4),'LegendForSecondFigure');