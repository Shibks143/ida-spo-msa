clear; tic; % close all; 
baseFolder = pwd;

%% (Inputs- 1/2) Building-specific inputs
DS_StoryDriftLIST = [0.005, 0.01, 0.02, 0.04, 0.00]; % LS1, LS2, LS3, LS4, LS5 (0.00 indicates sidesway collapse or dynamic instability)

buildingIDLIST = {'1310v1_FF'; '1610v1_FF'; '1910v1_FF'}; 

% buildingID = '1310v1_FF'; legOn = 1; close all; 
% buildingID = '1310v1_NF'; legOn = 0; try close(101); catch; end; try close (102); catch; end
% buildingID = '1610v1_FF'; legOn = 0; close all; 
% buildingID = '1610v1_NF'; legOn = 0; try close(101); catch; end; try close (102); catch; end
% buildingID = '1910v1_FF'; legOn = 0; close all; 
% buildingID = '1910v1_NF'; legOn = 0; try close(101); catch; end; try close (102); catch; end

%% (Inputs- 2/2) Scenario/GMM inputs
% Generate random spectral accelerations for a scenario earthquake
M = 7.3;
Rjb = 30; % Joyner-Boore distance in km
% T1forIM = 1.68; 
N1 = 1e4; % realizations of spectral acceleration.
% GMPM = 'BA08'; % Boore Atkinson (2008) NGA
GMPM = 'BSSA14'; % Boore et al (2014) NGA (NRCan gives 0.25 weight to each of ASK14, BSSA14, CB14, CY14 for SWCan)
saveFigures = 1; % when running for optimal beta, do not saveFigures
dirForFigures = sprintf('figures_SaRealization_histogram');% _%s_M%g_R%g', buildingID, M, Rjb);

% end of user input

for i = 1:size(buildingIDLIST, 1)
    buildingID = buildingIDLIST{i, 1};

%% Defined directory addresses, earthquake IDs
switch buildingID
    case '1310v1_FF'
        numStories = 3; 
        outpFolderLIST = {'E:\prak\ResilAnaOS_psb\Output\(ID1310_v.01_FF)_(AllVar)_(0.00)_(clough)';};
        eqLIST = [120111, 120112, 120121, 120122,	120411, 120412,	120521, 120522,	120611, 120612,	120621, 120622,	120711, 120712,	120721, 120722,	120811, 120812,	120821, 120822,	120911, 120912,	120921, 120922,	121011, 121012,	121021, 121022,	121111, 121112,	121211, 121212,	121221, 121222,	121321, 121322,	121411, 121412,	121421, 121422,	121511, 121512,	121711, 121712];
        GMsuiteName = 'GMSetC';
        T1forIM = 0.83; 
    case '1310v1_NF'
        numStories = 3; 
        outpFolderLIST = {'E:\prak\ResilAnaOS_psb\Output\(ID1310_v.01_NF)_(AllVar)_(0.00)_(clough)';};
        eqLIST = [8201811	8201812	8201821	8201822	8202921	8202922	8207231	8207232	8208021	8208022	8208211	8208212	8208281	8208282	8208791	8208792	8210631	8210632	8210861	8210862	8211651	8211652	8215031	8215032	8215291	8215292	8216051	8216052	8201261	8201262	8201601	8201602	8201651	8201652	8204951	8204952	8204961	8204962	8207411	8207412	8207531	8207532	8208251	8208252	8210041	8210042	8210481	8210482	8211761	8211762	8215041	8215042	8215171	8215172	8221141	8221142];
        GMsuiteName = 'GMSetG';
        T1forIM = 0.83; 
    case '1610v1_FF'
        numStories = 6; 
        outpFolderLIST = {'E:\prak\ResilAnaOS_psb\Output\(ID1610_v.01_FF)_(AllVar)_(0.00)_(clough)';};
        eqLIST = [120111, 120112, 120121, 120122,	120411, 120412,	120521, 120522,	120611, 120612,	120621, 120622,	120711, 120712,	120721, 120722,	120811, 120812,	120821, 120822,	120911, 120912,	120921, 120922,	121011, 121012,	121021, 121022,	121111, 121112,	121211, 121212,	121221, 121222,	121321, 121322,	121411, 121412,	121421, 121422,	121511, 121512,	121711, 121712];
        GMsuiteName = 'GMSetC';
        T1forIM = 1.68; 
    case '1610v1_NF'
        numStories = 6; 
        outpFolderLIST = {'E:\prak\ResilAnaOS_psb\Output\(ID1610_v.01_NF)_(AllVar)_(0.00)_(clough)';};
        eqLIST = [8201811	8201812	8201821	8201822	8202921	8202922	8207231	8207232	8208021	8208022	8208211	8208212	8208281	8208282	8208791	8208792	8210631	8210632	8210861	8210862	8211651	8211652	8215031	8215032	8215291	8215292	8216051	8216052	8201261	8201262	8201601	8201602	8201651	8201652	8204951	8204952	8204961	8204962	8207411	8207412	8207531	8207532	8208251	8208252	8210041	8210042	8210481	8210482	8211761	8211762	8215041	8215042	8215171	8215172	8221141	8221142];
        GMsuiteName = 'GMSetG';
        T1forIM = 1.68; 
    case '1910v1_FF'
        numStories = 9; 
        outpFolderLIST = {'E:\prak\ResilAnaOS_psb\Output\(ID1910_v.01_FF)_(AllVar)_(0.00)_(clough)';};
        eqLIST = [120111, 120112, 120121, 120122,	120411, 120412,	120521, 120522,	120611, 120612,	120621, 120622,	120711, 120712,	120721, 120722,	120811, 120812,	120821, 120822,	120911, 120912,	120921, 120922,	121011, 121012,	121021, 121022,	121111, 121112,	121211, 121212,	121221, 121222,	121321, 121322,	121411, 121412,	121421, 121422,	121511, 121512,	121711, 121712];
        GMsuiteName = 'GMSetC';
        T1forIM = 2.41; 
    case '1910v1_NF'
        numStories = 9; 
        outpFolderLIST = {'E:\prak\ResilAnaOS_psb\Output\(ID1910_v.01_NF)_(AllVar)_(0.00)_(clough)';};
        eqLIST = [8201811	8201812	8201821	8201822	8202921	8202922	8207231	8207232	8208021	8208022	8208211	8208212	8208281	8208282	8208791	8208792	8210631	8210632	8210861	8210862	8211651	8211652	8215031	8215032	8215291	8215292	8216051	8216052	8201261	8201262	8201601	8201602	8201651	8201652	8204951	8204952	8204961	8204962	8207411	8207412	8207531	8207532	8208251	8208252	8210041	8210042	8210481	8210482	8211761	8211762	8215041	8215042	8215171	8215172	8221141	8221142];
        GMsuiteName = 'GMSetG';
        T1forIM = 2.41; 
end

if numStories == 3; Sa_MCE = 0.435; elseif numStories == 6; Sa_MCE = 0.221;
elseif numStories == 9; Sa_MCE = 0.153; end

% Boore Atkinson (2008) NGA
Fault_Type    = 3; % 1 for unspecified fault; 2 for strike-slip fault; 3 for normal fault; 4 for reverse fault
% [Sa, sigma, period1] = BA_2008_nga (M, T, Rjb, Fault_Type, Vs30)
[Sa_T1_BA08, sigma_T1_BA08, ~] = BA_2008_nga(M, T1forIM, Rjb, Fault_Type, 450);

Fault_Type    = 2; % 0 for unspecified fault, 1 for strike-slip fault, 2 for normal fault, 3 for reverse fault
% [median, sigma, period1] = BSSA_2014_nga(M, T, Rjb, Fault_Type, region, z1, Vs30);
[Sa_T1_BSSA14 , sigma_T1_BSSA14, ~] = BSSA_2014_nga(M, T1forIM, Rjb, Fault_Type, 0, 999, 450);

% [Sa_T1_ASK14 , sigma_T1_ASK14 ] = ASK_2014_nga(M, Rjb, period) ;
% [Sa_T1_CB14  , sigma_T1_CB14  ] = CB_2014_nga(M, Rjb, period)  ;
% [Sa_T1_CY14  , sigma_T1_CY14  ] = CY_2014_nga(M, Rjb, period)  ;

% end of inputs

%% 1. generate 10,000 realizations of intensity measure (e.g., SaT1)
rng(3, 'twister')
epsList = randn(N1, 1);
% epsList = 0;

switch GMPM
    case 'BA08'
        Sa_realizations = Sa_T1_BA08 * exp(epsList * sigma_T1_BA08);
    case 'BSSA14'
        Sa_realizations = Sa_T1_BSSA14 * exp(epsList * sigma_T1_BSSA14);
    case 'ASK14'
        Sa_realizations = Sa_T1_ASK14 * exp(epsList * sigma_T1_ASK14);
    case 'CB14'
        Sa_realizations = Sa_T1_CB14 * exp(epsList * sigma_T1_CB14);
    case 'CY14'
        Sa_realizations = Sa_T1_CY14 * exp(epsList * sigma_T1_CY14);
end

% [counts, edges] = histcounts(Sa_realizations);
% bar((edges(1:end-1) + edges(2:end))/2, counts, 0.8); % Duty cycle of 40% for the bars gives a big space between the bars.
% grid on;

Sa_relz(:, i) = Sa_realizations/Sa_MCE;
end

% colorLIST = {'r', 'b', 'g'}; 
% h = histogram(Sa_realizations); h.FaceColor = colorLIST{i}; hold on;

edges = 0:0.1:1.5;
h1 = histcounts(Sa_relz(:, 1),edges);
h2 = histcounts(Sa_relz(:, 2),edges);
h3 = histcounts(Sa_relz(:, 3),edges);
figure 
b = bar(edges(1:end-1),[h1; h2; h3]', 'BarWidth', 1.0); grid on;
b(1).FaceColor = 'r'; b(2).FaceColor = 'b'; b(3).FaceColor = 'g';

yt = get(gca, 'YTick'); ytLabel = yt/N1;
set(gca, 'YTickLabel', ytLabel);

hx = xlabel(sprintf('$ Sa(T_1)/Sa_{MCE} $'), 'Interpreter', 'latex'); hy = ylabel('Fraction of Simulations');
hleg = legend('3-Story', '6-Story', '9-Story');
psb_FigureFormatScript_paper

if saveFigures == 1
    cd(baseFolder);  mkdir(dirForFigures); cd(dirForFigures);
%     strForIM = strrep(sprintf('Sa_%.2f', T1forIM), '.', 'p');
    exportName = sprintf('histogramCombined_Sa_M%ip%i_R%i_%s_%s', floor(M), int8(mod(M*10, 10)), Rjb, GMPM);
    hgsave(exportName); % .fig file for Matlab

    % Sometimes, .eps files will not have vector rendering. Change renderer to save figures properly.
    print('-depsc', '-vector', exportName); % .eps file for Linux (LaTeX)
    print('-dmeta', exportName); % .emf file for Windows (MSWORD)
end
cd(baseFolder);  toc;