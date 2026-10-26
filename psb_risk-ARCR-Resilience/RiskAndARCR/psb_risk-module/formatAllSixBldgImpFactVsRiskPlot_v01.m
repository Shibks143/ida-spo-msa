
ylim([2e-6, 2e-3]);
% set(gca, 'XTick', [1, 3, 3.1, 5.1, 5.2, 7.2, 7.3, 9.3, 9.4, 11.4, 11.5, 13.5]);
% set(gca, 'XTickLabel', {1, 3, 1, 3, 1, 3, 1, 3, 1, 3});

% Define each row of labels. 
% row1 = {'1', 'ID-2211', '3', ' ', ' ', ' ', '1', 'ID-2215', '3', ' ', ' ', ' ', '1', 'ID-2221', '3', ' ', ' ', ' '};
% row2 = {' ', ' ', ' ', '1', 'ID-2213', '3', ' ', ' ', ' ', '1', 'ID-2219', '3', ' ', ' ', ' ', '1', 'ID-2223', '3'};
% row1 = {'[1', 'ID-2211', '3]', ' ', ' ', ' ', '[1', 'ID-2215', '3]', ' ', ' ', ' ', '[1', 'ID-2221', '3]', ' ', ' ', ' '};
% row2 = {' ', ' ', ' ', '[1', 'ID-2213', '3]', ' ', ' ', ' ', '[1', 'ID-2219', '3]', ' ', ' ', ' ', '[1', 'ID-2223', '3]'};

% row1 = {'[1', ' ', '3]', ' ', ' ', ' ', '[1', ' ', '3]', ' ', ' ', ' ', '[1', '', '3]', ' ', ' ', ' '};
% row2 = {' ', ' ', ' ', '[1', ' ', '3]', ' ', ' ', ' ', '[1', ' ', '3]', ' ', ' ', ' ', '[1', ' ', '3]'};

% row1 = {'1', ' ', '3', ' ', ' ', ' ', '1', ' ', '3', ' ', ' ', ' ', '1', '', '3', ' ', ' ', ' '};
% row2 = {' ', ' ', ' ', '1', ' ', '3', ' ', ' ', ' ', '1', ' ', '3', ' ', ' ', ' ', '1', ' ', '3'};

row1 = {'[1', '3] [1', ' ', '3] [1', ' ', '3] [1', ' ', '3] [1', ' ', '3] [1', ' ', '3]'};

 	  text(2, 1.5e-3, 'ID-2211', 'FontSize', 18, 'FontWeight', 'Bold', 'HorizontalAlignment', 'center', 'FontName', 'Times');
 text(4.0001, 1.5e-3, 'ID-2213', 'FontSize', 18, 'FontWeight', 'Bold', 'HorizontalAlignment', 'center', 'FontName', 'Times');
 text(6.0002, 1.5e-3, 'ID-2215', 'FontSize', 18, 'FontWeight', 'Bold', 'HorizontalAlignment', 'center', 'FontName', 'Times');
 text(8.0003, 1.5e-3, 'ID-2219', 'FontSize', 18, 'FontWeight', 'Bold', 'HorizontalAlignment', 'center', 'FontName', 'Times');
text(10.0004, 1.5e-3, 'ID-2221', 'FontSize', 18, 'FontWeight', 'Bold', 'HorizontalAlignment', 'center', 'FontName', 'Times');
text(12.0005, 1.5e-3, 'ID-2223', 'FontSize', 18, 'FontWeight', 'Bold', 'HorizontalAlignment', 'center', 'FontName', 'Times');

plot([1, 1], [1e-7, 1e-2], 'k-', 'LineWidth', 1.5);
plot([3.00005, 3.00005], [1e-7, 1e-2], 'k-', 'LineWidth', 1.5);
plot([5.00005, 5.00005], [1e-7, 1e-2], 'k-', 'LineWidth', 1.5);
plot([7.00005, 7.00005], [1e-7, 1e-2], 'k-', 'LineWidth', 1.5);
plot([9.00005, 9.00005], [1e-7, 1e-2], 'k-', 'LineWidth', 1.5);
plot([11.00005, 11.00005], [1e-7, 1e-2], 'k-', 'LineWidth', 1.5);
plot([13.00005, 13.00005], [1e-7, 1e-2], 'k-', 'LineWidth', 1.5);

h1 = plot(20, 20, 'k--', 'LineWidth', 2);
h2 = plot(20, 20, 'b-.', 'LineWidth', 2);
h3 = plot(20, 20, 'm:' , 'LineWidth', 2);
h4 = plot(20, 20, 'r-' , 'LineWidth', 2);

legend([h1, h2, h3, h4], {'IO', 'LS', 'CP', 'Collapse'}, 'Location', 'SouthEast');

% Combine the rows of labels into a cell array; convert non-strings to strings/character vectors.
% labelArray = [row1; row2]; %; compose('%.1f',row3)]; 
% labelArray = strjust(pad(labelArray),'right'); % 'left'(default)|'right'|'center % To use right or center justification, 
% tickLabels = strtrim(sprintf('%s\\newline%s\n', labelArray{:}));

% tickLabels = strsplit(tickLabels);  % Optional
% Assign ticks and labels
ax = gca(); 
ax.XTick = [1, 3, 3.0001, 5.0001, 5.0002, 7.0002, 7.0003, 9.0003, 9.0004, 11.0004, 11.0005, 13.0005]; 
ax.XLim = [1, 13.0005];
ax.XTickLabel = row1; % ax.XTickLabel = tickLabels; 
% ax.TickLabelInterpreter = 'tex';  % needed for some plots like boxplot.
