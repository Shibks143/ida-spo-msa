
clc; clear; close all;

% -----------------------------
% Data
% -----------------------------
% Sa1_IV  = [0.18 0.21 0.23 0.28 0.29 0.35 0.44 0.53];  % Delhi
% Sa1_VI  = [0.33 0.45 0.50 0.60 0.63 0.75 0.94 1.13];  % Guwahati
Sa1_VI = [0.1309 0.1736 0.2392 0.3495 0.3969 0.5299 0.6969 0.8909];
Tr = [175 275 475 975 1275 2475 4975 9975]; % Years
Lambda = (1./Tr);                           % 1/year
idx_DBE = 3;   % Tr = 475 Years
idx_MCE = 6;   % Tr = 2475 Years
lambda_DBE = Lambda(idx_DBE);
lambda_MCE = Lambda(idx_MCE);

% -----------------------------
% Plot
% -----------------------------
figure;
% loglog(Sa1_IV, Lambda, '-^', 'LineWidth', 2, 'MarkerSize', 4, 'Color','b');
loglog(Sa1_VI, Lambda, '-^', 'LineWidth', 2, 'MarkerSize', 4, 'Color','r');
hold on

loglog([1e-2 1], [lambda_DBE lambda_DBE], '--', 'LineWidth', 2, 'Color', 'k');   
loglog([1e-2 1], [lambda_MCE lambda_MCE], '--', 'LineWidth', 2, 'Color', 'k');   
text(0.07, lambda_DBE*1.1, 'DBE (T_r = 475y)', 'FontSize', 12, 'Color', 'k' );
text(0.07, lambda_MCE*1.1, 'MCE (T_r = 2475y)', 'FontSize', 12, 'Color', 'k');
hold off

% -----------------------------
% Apply custom formatting (handles ALL formatting below)
% -----------------------------
sks_figureFormat('paper');  % Sets Times, fonts, LaTeX interpreter, grid, etc.

% -----------------------------
% Labels ONLY (sks_figureFormat handles FontSize, bold, interpreter)
% -----------------------------
xlabel('Sa(1s, 5\%) (g)');
ylabel('Annual Rate of Exceedance, $\lambda$ (1/Year)');
legend('(Guwahati)','Location','northeast');
% title('Hazard Curves');

% -----------------------------
% Axis limits
% -----------------------------
xlim([1e-2 3]);
ylim([1e-5 1e0]);

% -----------------------------
% Export (sks_figureExport handles everything)
% -----------------------------
sks_figureExport('hazardCurve');



