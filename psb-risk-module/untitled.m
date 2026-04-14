clear; clc; close all

%% Data from your table
mu   = [0.6136 0.59227 0.55428 0.54728];
beta = [0.33837 0.30527 0.23651 0.21594];

dsLabels = {'DynInst','CP','LS','IO'};
Togm = 1.717;
bldgID = '2433v02';

%% Sa range (log axis)
Sa = logspace(-2,1,500);

%% Fragility computation
frag = zeros(length(Sa), length(mu));

for i = 1:length(mu)
    frag(:,i) = normcdf( log(Sa./mu(i)) ./ beta(i) );
end

%% Plot
figure; hold on; grid on; box on

plot(Sa, frag(:,1),'k-','LineWidth',2)
plot(Sa, frag(:,2),'r--','LineWidth',2)
plot(Sa, frag(:,3),'b-.','LineWidth',2)
plot(Sa, frag(:,4),'m:','LineWidth',2)

set(gca,'XScale','log')

%% Labels
xlabel('$S_a(T_{ogm})$ (g)','Interpreter','latex','FontSize',18)
ylabel('$P[DS \ge ds_k]$','Interpreter','latex','FontSize',18)
title('Fragility Curves','FontSize',24,'FontWeight','bold')

ylim([0 1])
xlim([0.1 1])

%% Legend (bottom-right)
legend({ ...
    sprintf('DynInst ($\\mu$ = %.4f, $\\beta$ = %.5f)',mu(1),beta(1)), ...
    sprintf('CP ($\\mu$ = %.5f, $\\beta$ = %.5f)',mu(2),beta(2)), ...
    sprintf('LS ($\\mu$ = %.5f, $\\beta$ = %.5f)',mu(3),beta(3)), ...
    sprintf('IO ($\\mu$ = %.5f, $\\beta$ = %.5f)',mu(4),beta(4))}, ...
    'Interpreter','latex', ...
    'Location','southeast')

%% Information box (top-left)
txt = { ...
    ['\bfBuilding ID: ' bldgID], ...
    ' ', ...
    ['\mu = [' sprintf('%.4f, ',mu(1:3)) sprintf('%.5f',mu(4)) ']'], ...
    ['\beta = [' sprintf('%.5f, ',beta(1:3)) sprintf('%.5f',beta(4)) ']'], ...
    ' ', ...
    ['$T_{ogm}$ = ' num2str(Togm,'%.3f') ' s']};

annotation('textbox',[0.15 0.60 0.28 0.25], ...
    'String',txt, ...
    'Interpreter','latex', ...
    'FitBoxToText','on', ...
    'BackgroundColor',[0.9 0.9 0.9], ...
    'EdgeColor','k', ...
    'FontSize',14)

set(gca,'FontSize',16)