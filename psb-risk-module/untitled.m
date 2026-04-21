clear; clc; close all

%% Data from your table
mu = [0.6136     0.39438     0.20047    0.097359];
beta = [0.33837    0.30527    0.23651    0.21594];



% mu = [0.781967948	0.520442051	0.285497976	0.143413675];
% beta = [0.627022032	0.605999393	0.618671609	0.632398279];


% mu   = [0.6136 0.59227 0.55428 0.54728];
% beta = [0.33837 0.30527 0.23651 0.21594];

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
xlim([0.05 1])

yticks(0:0.2:1)
% ytickformat('%f')

grid on
set(gca,'YGrid','on','XGrid','on')

% turn OFF minor grid
set(gca,'XMinorGrid','off','YMinorGrid','off')


%% Legend (bottom-right)
legend({ ...
    sprintf('DynInst ($\\mu$ = %.4f, $\\beta$ = %.5f)',mu(1),beta(1)), ...
    sprintf('CP ($\\mu$ = %.5f, $\\beta$ = %.5f)',mu(2),beta(2)), ...
    sprintf('LS ($\\mu$ = %.5f, $\\beta$ = %.5f)',mu(3),beta(3)), ...
    sprintf('IO ($\\mu$ = %.5f, $\\beta$ = %.5f)',mu(4),beta(4))}, ...
    'Interpreter','latex', ...
    'Location','southeast')
set(gca,'FontSize',16)

