
function [timeArray, meanHousingCapacity] = fun2housingCapacity_v1(LS, numStories)

% Most of the references in this program are to Burton et al. (2015) J. Struct. Eng. paper or to Chapter 7 of Burton's thesis.

% doPrint = 1;
% LS = 0;

T_E = 0; % time of earthquake (day)
T_LC = 1500; % Control time (days) 
% T_LC = 700; % Control time (days) % changing this to 700 did not affect results beyond 4th decimal place.
OccupancyTot = 1; % keep it to 1, if interested only in knowing the loss of occupancy in fraction

% numStories = 7; % Used in LS_4 to determine the mean repair time
% Building replacement time based on p9 of Burton's 2016-ASCE paper
if numStories == 4
    mu_T_REP = 210; sig_ln_T_REP = 0.40; 
elseif numStories == 6
    mu_T_REP = 300; sig_ln_T_REP = 0.40; 
elseif numStories == 10
    mu_T_REP = 435; sig_ln_T_REP = 0.40; 
elseif numStories == 5 % interpolated
    mu_T_REP = 255; sig_ln_T_REP = 0.40; 
elseif numStories > 6 && numStories < 10  % interpolated for 7, 8, 9
    mu_T_REP = 300 + 135/4*(numStories - 6); sig_ln_T_REP = 0.40; 
elseif numStories < 4  % capped to 210 days (assumption) (consider USRC, 2015 default values, if nothing else comes up)
    mu_T_REP = 210; sig_ln_T_REP = 0.40; 
else
    error('Repair time database avialable for number of story between 4 and 10.');
end
            
% some input parameters that control the precision of the calculations
N = 100; % number of subdivisions in time

% Table 1
% T_NOcc0 = 0;
% T_NOcc1 = T_INSP;
% T_NOcc2 = T_INSP;
% T_NOcc3 = T_INSP + T_ASMT + T_MOB + T_OCC;
% T_NOcc4 = T_ASMT + T_MOB + T_REP; % Add T_INSP to this based on personal comm with Burton on Sep 17, 2017
% T_NOcc5 = T_MOB + T_REP;
% 
% T_OccLoss0 = 0;
% T_OccLoss1 = 0;
% T_OccLoss2 = T_FUNC;
% T_OccLoss3 = T_FUNC;
% T_OccLoss4 = 0;
% T_OccLoss5 = 0;
% 
% T_OccFull0 = T_LC - T_NOcc0 - T_OccLoss0;
% T_OccFull1 = T_LC - T_NOcc1 - T_OccLoss1;
% T_OccFull2 = T_LC - T_NOcc2 - T_OccLoss2;
% T_OccFull3 = T_LC - T_NOcc3 - T_OccLoss3;
% T_OccFull4 = T_LC - T_NOcc4 - T_OccLoss4;
% T_OccFull5 = T_LC - T_NOcc5 - T_OccLoss5;

% Fraction of capacities for different functional states
capacity_NOcc = 0.00; % No Occupancy functional state
capacity_OccLoss = 0.4; % Loss of Occupancy functional state
capacity_OccFull = 1.00; % Full Occupancy functional state

% Convert the fractions to number of occupants, if required.
capacity_NOcc = capacity_NOcc * OccupancyTot;
capacity_OccLoss = capacity_OccLoss * OccupancyTot;
capacity_OccFull = capacity_OccFull * OccupancyTot;

% Eqn (3)
% [q(t)|LS_i] housing capacity function conditional on the immediate postearthquake limit state LS_i

%% method-1 (generate say, 10^6 independent random T1 and T2 realizations and find the expected value of q(t))
N1 = 1e4;
rng(1, 'twister'); % start random number generator with a given seed

% generate uncorrelated T1 and T2 relizations
    rho = 0.; % 0 implies no correlation between T_NOcc_realizations and T_OccLoss_realizations
    % a correlation between T_NOcc and T_OccLoss does not make a whole lot of difference. 
    % Possibly, a correlation betwixt different lead times might. 

% let T_E i.e. the time of earthquake be t = 0
% let T_RE i.e. the time at full recovery be t = T_LC
    timeArray = linspace(T_E, T_LC, N+1);

switch LS
    case 0
        T_NOcc = 0;
        T_OccLoss = 0;
        T_OccFull = T_LC - T_NOcc - T_OccLoss;
        meanHousingCapacity = capacity_OccFull * ones(N+1, 1);

    case 1
        mu_T_INSP = 30; sig_ln_T_INSP = 0.75;

%         Symbolically, T_NOcc = T_INSP; T_OccLoss = 0; T_OccFull = T_LC - T_NOcc - T_OccLoss;
    % generate uncorrelated T1 and T2 relizations
        T_NOcc_realizations = mu_T_INSP * exp(randn(N1, 1) * sig_ln_T_INSP);
        T_OccLoss_realizations = zeros(N1, 1);
    % update T2_realizations to have rho correlation with T1_realizations
%         T_OccLoss_realizations = rho * T_NOcc_realizations + sqrt(1 - rho^2) * T_OccLoss_realizations; 

    case 2
        mu_T_INSP = 30; sig_ln_T_INSP = 0.75;
        mu_T_FUNC = 90; sig_ln_T_FUNC = 0.40;

%         Symbolically, T_NOcc = T_INSP; T_OccLoss = T_FUNC; T_OccFull = T_LC - T_NOcc - T_OccLoss;
    % generate uncorrelated T1 and T2 relizations
        T_NOcc_realizations = mu_T_INSP * exp(randn(N1, 1) * sig_ln_T_INSP);
        T_OccLoss_realizations = mu_T_FUNC * exp(randn(N1, 1) * sig_ln_T_FUNC);
    % update T2_realizations to have rho correlation with T1_realizations
        T_OccLoss_realizations = rho * T_NOcc_realizations + sqrt(1 - rho^2) * T_OccLoss_realizations; 

    case 3
        mu_T_INSP = 30; sig_ln_T_INSP = 0.75;
        mu_T_ASMT = 60; sig_ln_T_ASMT = 0.75;
        mu_T_MOB = 150; sig_ln_T_MOB = 0.75;
        mu_T_OCC = 45; sig_ln_T_OCC = 0.40; % mu value Assumed. Actually, it should be considered by taking the sum of different repair times of all the elements (Table 7-3 of Burton Thesis)
        mu_T_FUNC = 120; sig_ln_T_FUNC = 0.40;

%         Symbolically, T_NOcc = T_INSP + T_ASMT + T_MOB + T_OCC; T_OccLoss = T_FUNC; T_OccFull = T_LC - T_NOcc - T_OccLoss;
    % generate uncorrelated T1 and T2 relizations
        T_NOcc_realizations = mu_T_INSP * exp(randn(N1, 1) * sig_ln_T_INSP) + mu_T_ASMT * exp(randn(N1, 1) * sig_ln_T_ASMT) + mu_T_MOB * exp(randn(N1, 1) * sig_ln_T_MOB) + mu_T_OCC * exp(randn(N1, 1) * sig_ln_T_OCC);
        T_OccLoss_realizations = mu_T_FUNC * exp(randn(N1, 1) * sig_ln_T_FUNC);
    % update T2_realizations to have rho correlation with T1_realizations
        T_OccLoss_realizations = rho * T_NOcc_realizations + sqrt(1 - rho^2) * T_OccLoss_realizations; 

    case 4
        mu_T_ASMT = 60; sig_ln_T_ASMT = 0.75;
%         mu_T_MOB = 365; sig_ln_T_MOB = 0.75;
        mu_T_MOB = 240; sig_ln_T_MOB = 0.75;

%         Symbolically, T_NOcc = T_ASMT + T_MOB + T_REP; T_OccLoss = 0; T_OccFull = T_LC - T_NOcc - T_OccLoss;
    % generate uncorrelated T1 and T2 relizations
        T_NOcc_realizations = mu_T_ASMT * exp(randn(N1, 1) * sig_ln_T_ASMT) + mu_T_MOB * exp(randn(N1, 1) * sig_ln_T_MOB) + mu_T_REP * exp(randn(N1, 1) * sig_ln_T_REP);
        T_OccLoss_realizations = zeros(N1, 1);
    % update T2_realizations to have rho correlation with T1_realizations
%         T_OccLoss_realizations = rho * T_NOcc_realizations + sqrt(1 - rho^2) * T_OccLoss_realizations; 
        
    case 5
%         mu_T_MOB = 365; sig_ln_T_MOB = 0.75;
        mu_T_MOB = 240; sig_ln_T_MOB = 0.75;

%         Symbolically, T_NOcc = T_MOB + T_REP; T_OccLoss = 0; T_OccFull = T_LC - T_NOcc - T_OccLoss;
    % generate uncorrelated T1 and T2 relizations
        T_NOcc_realizations = mu_T_MOB * exp(randn(N1, 1) * sig_ln_T_MOB) + mu_T_REP * exp(randn(N1, 1) * sig_ln_T_REP);
        T_OccLoss_realizations = zeros(N1, 1);
    % update T2_realizations to have rho correlation with T1_realizations
%         T_OccLoss_realizations = rho * T_NOcc_realizations + sqrt(1 - rho^2) * T_OccLoss_realizations; 
        
end
    

if LS ~= 0 % for 0 case, meanHousingCapacity was directly estimated in the switch case above

    T1 = T_NOcc_realizations;
    T2 = T_NOcc_realizations + T_OccLoss_realizations; % recall from eqn (3) that OccLoss occurs when (T_Nocc < t < T_NOcc + T_OccLoss)

    %     hist(T_NOcc_realizations, [0:mu_T_NOcc/4:mu_T_NOcc*exp(2*sig_ln_T_NOcc)])

    for timeIndex = 1:N+1
        currTime = timeArray(timeIndex);
        for relizationIndex = 1:N1
            T1curr = T1(relizationIndex); T2curr = T2(relizationIndex); % current T1 and T2, for this realization
            housingCapacity(timeIndex, relizationIndex) = capacity_NOcc * (currTime < T1curr) + capacity_OccLoss * ((currTime >= T1curr) * (currTime < T2curr)) + capacity_OccFull * ((currTime >= T2curr) * (currTime <= T_LC));
        end
    end
    meanHousingCapacity = mean(housingCapacity, 2);
end

% if doPlot == 1
% %     figure
% %     lineColors = repmat({'r','b','g','k','y','m',[.5 .6 .7]}, [1 4]); % Cell array of 28 colors.
% %     lineStyles = repmat({'-','--', '-.', ':', '-','--', '-.', ':', '-','--', '-.', ':'}, [1 4]);
% %     markers = repmat({''}, [1 28]);
% % 
% %     j = LS + 1; % since LS starts from 0.
% %     plotStyle = [lineColors{j} lineStyles{j} markers{j}];
%     plot(timeArray, meanHousingCapacity, plotStyle, 'LineWidth', 1.5); hold on;
% end

% toc




