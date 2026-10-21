function [meanRepairTime, repairTimeAllData] = fun4meanRepTime_v1(meanSa, sigmaLn, IMvalList, numStories)
% repair time constitutes of time taken to repair the building. 
% this includes T_FUNC, T_OCC, and T_REP (functionality/occupancy restoration and replacement) 

%% sample inputs
% clear; close all; % clc
% buildingID = '1610v01';
% meanSa = [0.11, 0.22, 0.33, 0.38, 0.52];
% sigmaLn = [0.37, 0.43, 0.49, 0.48, 0.54];
% IMvalList = 0.01:0.01:1.0;
% numStories = 6;
% end of inputs

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

meanRepTime = zeros(6, 1); % array of mean repair time for each of six limit states; irrespective of IM values

%% method-1 (generate say, 10^6 independent random T1 and T2 realizations and find the expected value of q(t))
N1 = 1e4;
rng(1, 'twister'); % start random number generator with a given seed
repTime = zeros(6, N1); % martix of repair time for each of six limit states and N1 realizations
% generate uncorrelated T1 and T2 relizations
rho = 0; % 0 implies no correlation between T_NOcc_realizations and T_OccLoss_realizations

%% LS0
    % T_NOcc = 0; % trivially zero
    % T_OccLoss = 0; % trivially zero
    % repTime(:, 1) = T_NOcc + T_OccLoss; % unchanged
    meanRepTime(1) = 0; % repTime(1); 

%% LS1
%     mu_T_INSP = 30; sig_ln_T_INSP = 0.75;
% Symbolically, T_NOcc = T_INSP; T_OccLoss = 0; T_OccFull = T_LC - T_NOcc - T_OccLoss;
% generate uncorrelated T1 and T2 relizations
%     T_NOcc_realizations = mu_T_INSP * exp(randn(N1, 1) * sig_ln_T_INSP);
%     T_OccLoss_realizations = zeros(N1, 1);
%     repTime(2, :) = T_NOcc_realizations' + T_OccLoss_realizations'; % LS1
    repTime(2, :) = 0; % LS1
    meanRepTime(2) = mean(repTime(2, :)); 

%% LS2
%     mu_T_INSP = 30; sig_ln_T_INSP = 0.75;
    mu_T_FUNC = 90; sig_ln_T_FUNC = 0.40;
% Symbolically, T_NOcc = T_INSP; T_OccLoss = T_FUNC; T_OccFull = T_LC - T_NOcc - T_OccLoss;
% generate uncorrelated T1 and T2 relizations
%     T_NOcc_realizations = mu_T_INSP * exp(randn(N1, 1) * sig_ln_T_INSP);
%     T_OccLoss_realizations = mu_T_FUNC * exp(randn(N1, 1) * sig_ln_T_FUNC);
% update T2_realizations to have rho correlation with T1_realizations
%     T_OccLoss_realizations = rho * T_NOcc_realizations + sqrt(1 - rho^2) * T_OccLoss_realizations; 
%     repTime(3, :) = T_NOcc_realizations' + T_OccLoss_realizations'; % LS2
    repTime(3, :) = (mu_T_FUNC * exp(randn(N1, 1) * sig_ln_T_FUNC))'; % LS2
    meanRepTime(3) = mean(repTime(3, :)); 
    
%% LS3
%     mu_T_INSP = 30; sig_ln_T_INSP = 0.75;
%     mu_T_ASMT = 60; sig_ln_T_ASMT = 0.75;
%     mu_T_MOB = 150; sig_ln_T_MOB = 0.75;
    mu_T_OCC = 45; sig_ln_T_OCC = 0.40; % mu value Assumed. Actually, it should be considered by taking the sum of different repair times of all the elements (Table 7-3 of Burton Thesis)
    mu_T_FUNC = 120; sig_ln_T_FUNC = 0.40;
% Symbolically, T_NOcc = T_INSP + T_ASMT + T_MOB + T_OCC; T_OccLoss = T_FUNC; T_OccFull = T_LC - T_NOcc - T_OccLoss;
% generate uncorrelated T1 and T2 relizations
%     T_NOcc_realizations = mu_T_INSP * exp(randn(N1, 1) * sig_ln_T_INSP) + mu_T_ASMT * exp(randn(N1, 1) * sig_ln_T_ASMT) + mu_T_MOB * exp(randn(N1, 1) * sig_ln_T_MOB) + mu_T_OCC * exp(randn(N1, 1) * sig_ln_T_OCC);
%     T_OccLoss_realizations = mu_T_FUNC * exp(randn(N1, 1) * sig_ln_T_FUNC);
% update T2_realizations to have rho correlation with T1_realizations
%     T_OccLoss_realizations = rho * T_NOcc_realizations + sqrt(1 - rho^2) * T_OccLoss_realizations; 
%     repTime(4, :) = T_NOcc_realizations' + T_OccLoss_realizations'; % LS3
    repTime(4, :) = (mu_T_OCC * exp(randn(N1, 1) * sig_ln_T_OCC))' + (mu_T_FUNC * exp(randn(N1, 1) * sig_ln_T_FUNC))'; % LS3
    meanRepTime(4) = mean(repTime(4, :)); 

%% LS4
%     mu_T_INSP = 30; sig_ln_T_INSP = 0.75; % Adding T_INSP to LS4 based on personal comm with Burton on Sep 17, 2017
%     mu_T_ASMT = 60; sig_ln_T_ASMT = 0.75;
%     mu_T_MOB = 365; sig_ln_T_MOB = 0.75;
%     mu_T_MOB = 240; sig_ln_T_MOB = 0.75;
%     Symbolically, T_NOcc = T_INSP + T_ASMT + T_MOB + T_REP; T_OccLoss = 0; T_OccFull = T_LC - T_NOcc - T_OccLoss;
% generate uncorrelated T1 and T2 relizations
%     T_NOcc_realizations = mu_T_INSP * exp(randn(N1, 1) * sig_ln_T_INSP) + mu_T_ASMT * exp(randn(N1, 1) * sig_ln_T_ASMT) + mu_T_MOB * exp(randn(N1, 1) * sig_ln_T_MOB) + mu_T_REP * exp(randn(N1, 1) * sig_ln_T_REP);
%     T_OccLoss_realizations = zeros(N1, 1);
% update T2_realizations to have rho correlation with T1_realizations
%     T_OccLoss_realizations = rho * T_NOcc_realizations + sqrt(1 - rho^2) * T_OccLoss_realizations; 
%     repTime(5, :) = T_NOcc_realizations' + T_OccLoss_realizations'; % LS4
    repTime(5, :) = (mu_T_REP * exp(randn(N1, 1) * sig_ln_T_REP))';
    meanRepTime(5) = mean(repTime(5, :)); 

%% LS5
%         mu_T_MOB = 365; sig_ln_T_MOB = 0.75;
%     mu_T_MOB = 240; sig_ln_T_MOB = 0.75;
%   Symbolically, T_NOcc = T_MOB + T_REP; T_OccLoss = 0; T_OccFull = T_LC - T_NOcc - T_OccLoss;
% generate uncorrelated T1 and T2 relizations
%     T_NOcc_realizations = mu_T_MOB * exp(randn(N1, 1) * sig_ln_T_MOB) + mu_T_REP * exp(randn(N1, 1) * sig_ln_T_REP);
%     T_OccLoss_realizations = zeros(N1, 1);
% update T2_realizations to have rho correlation with T1_realizations
%     T_OccLoss_realizations = rho * T_NOcc_realizations + sqrt(1 - rho^2) * T_OccLoss_realizations; 
%     repTime(6, :) = T_NOcc_realizations' + T_OccLoss_realizations'; % LS5
    repTime(6, :) = (mu_T_REP * exp(randn(N1, 1) * sig_ln_T_REP))';
    meanRepTime(6) = mean(repTime(6, :)); 

%% For each im value, calculate the differential probability
% Find Differential probabilities of building being (not exceeding) in a limit state.
PoE = zeros(1, 5); % 5 number of Limit states
for j = 1:length(IMvalList)
    IMval = IMvalList(j);
    
    i = 1:5; PoE(i) = logncdf(IMval, log(meanSa(i)), sigmaLn(i));
    
    % probability that the bldg is in he ith Limit state for a given IMval
    ProbLS(1) = 1 - PoE(1);
    ProbLS(2) = PoE(1) - PoE(2); ProbLS(3) = PoE(2) - PoE(3);
    ProbLS(4) = PoE(3) - PoE(4); ProbLS(5) = PoE(4) - PoE(5);
    ProbLS(6) = PoE(5);
    meanRepairTime(j) = ProbLS * meanRepTime;
    repairTimeAllData(:, j) = ProbLS * repTime;
end
x = 1;
