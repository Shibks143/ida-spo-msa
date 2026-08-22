clear; tic; %close all; 

baseFolder = pwd;


%% User inputs begin here
latLon = [26.17 91.77];      % Guwahati
T1       = 0.71;             % conditioning period (s)
fitModel = '3param';
N        = 21;
imString = 'SA(0.71)';       % 'SA(2.0)' 'SA(1.0)'; 'PGA'; 
returnP = 2475; % 475 
returnPeriods = [475 975 2475 4975]; % years
deaggType = 'MagDistEps'; % 'MagDist';

%% Source / GMPE inputs for the deaggregation calculation
% Region: Kopili Fault Zone / Shillong Plateau area near Guwahati.
% b-value, Mmax based on published regional studies (see chat) - ADJUST as needed.
GRparams.b       = 0.85;   % Gutenberg-Richter b-value (regional studies: ~0.8-0.9)
GRparams.Mmin    = 4.0;    % minimum magnitude 
GRparams.Mmax    = 8.0;    % max magnitude 
GRparams.nu_Mmin = 1.0;    % annual rate of M>=Mmin events - PLACEHOLDER, refine if you have a real value

Vs30 = 760;         % m/s, rock site
mechanism = 'SS';   % strike-slip

%% NEW user inputs: your own (M, R, eps, weight) deaggregation tuples
% Replace these with your actual values. Every (mag, dist) combo must appear
% once per eps bin (see fun_deagg_fromTuples_v1 header for full format notes).
magEdges = 4.0:0.1:8.0;    % 0.1 magnitude bins
distEdges = 0:10:100;      % 10 km distance bins
epsEdges = -3:0.5:3;       % epsilon bins of width 0.5

[Mgrid, Rgrid, Egrid] = ndgrid(magEdges, distEdges, epsEdges);
mag  = Mgrid(:)';
dist = Rgrid(:)';
eps  = Egrid(:)';
weight = [ ];

if isempty(weight)
    weight = rand(size(mag)); 
end
 
doSaveDeagg = 0;
exportNameDeagg = regexprep(regexprep(sprintf('Guwahati_dis_%s%s', imString, num2str(returnP)), '(\(|\))', '_'), '\.', 'p');
dirFigDeagg = 'Output_Deagg_figs';
 
%% get hazard curve in the same (imVals, afeVals, poeVals50y) format the OpenQuake reader gives
[imVals, afeVals, poeVals50y] = sks_fun_returnHazCurFromRaghukanth_v1(latLon, T1, fitModel, N);
 
%% back-solve Sa at each target return period (same poeT convention as fun_deagg_v2)
fprintf('\nTarget Sa(%.2fs) at lat=%.2f, lon=%.2f:\n', T1, latLon(1), latLon(2));
for i = 1:length(returnPeriods)
    Tr = returnPeriods(i);
    switch Tr
        case 475;  poeT = 0.10;
        case 975;  poeT = 0.05;
        case 2475; poeT = 0.02;
        case 4975; poeT = 0.01;
        otherwise; poeT = 1 - exp(-50/Tr); 
    end
    [~, ind] = unique(afeVals); 
    saT1Tr = interp1(poeVals50y(ind), imVals(ind), poeT, 'pchip');
    fprintf('  Return period %5d yr (poeT=%.3f) -> Sa(%.2fs) = %.4f g\n', Tr, poeT, T1, saT1Tr);
 
    if Tr == returnP
        saT1Tr_target = saT1Tr; %  value matching chosen returnP for the deagg plot
    end
end
 
%% compute physically-based (M, R, eps, weight) tuples via GR recurrence + BA2008
[mag, dist, eps, weight] = sks_fun_computeDeaggWeights_v1(magEdges, distEdges, epsEdges, saT1Tr_target, T1, Vs30, mechanism, GRparams);

%% NEW: build the deagg plot from your own tuples
textStr = ['$ T_r = $ ', num2str(returnP), ' years', newline, ...
    '$ ', upper(imString(1)), lower(imString(2:end)), ' = $ ', num2str(saT1Tr_target, '%.3f'), ' g'];
 
sks_fun_deagg_fromTuples_v1(mag, dist, eps, weight, textStr, doSaveDeagg, exportNameDeagg, dirFigDeagg);
 
toc;