clear; close all; tic
baseFolder = pwd;

%% complete, fixed input data (% sticking with scaling limited to 2)
% bldgIDLIST1 = {'2211v03_sca2',	'2211v03_sca4',	'2213v04_sca2',	'2213v04_sca4',	'2215v03_sca2',	'2215v03_sca4',	...
%               '2219v03_sca2',	'2219v03_sca4',	'2221v06_sca2',	'2221v06_sca4',	'2223v03_sca2',	'2223v03_sca4'};
bldgIDLIST1 = {'2211v03',	'2213v04',	'2215v03', ...
               '2219v03',	'2221v06',	'2223v03'};

%% User inputs begins    
% select buildings to perform calculations (eqLIST, locations, zone, Ta) are automatically calculated based on this.
bldgIndexToRun = 1:6;
bldgIDLIST = bldgIDLIST1(1, bldgIndexToRun);

%% Select IM
imType = 'Sa_T1'; % essentially fixed now

% Select list of period T1 for Intensity measure, Sa(T1), corresponding to each building 
% T1LIST = zeros(size(bldgIDLIST));  % 0 for PGA
% T1LIST = 99*ones(size(bldgIDLIST));  % 99 for Sa(Ta)
% T1LIST = ones(size(bldgIDLIST));  % 1 for Sa(1.00)
T1LIST = [1.44	1.56	1.87	1.15	1.57	1.64]; % geoM_Topt2 (<= 2sec)

% T1LIST = [1.44	1.56	1.87]; % zone-IV buildings (1:3) for SaTogm
% T1LIST = [1.15	1.57	1.64]; % zone-V buildings (4:6) for SaTogm

if size(T1LIST, 2) ~= size(bldgIndexToRun, 2); error('Number of Ti values for Intensity measure, SaTi, (= %i) does not match the number of buildings (= %i).', size(T1LIST, 2), size(bldgIndexToRun, 2)); end

%% Damage states to consider and consequence model
% normalizedByThetaU = 1; % chi (= thetaM/thetaU) used as critical column parameter for DS2 and DS3
normalizedByThetaU = 0; % xi (= thetaM/thetaCap) used as critical column parameter for DS2 and DS3
DS2_threshold = 0.50; % GEM guidelines recommend 0.75, which results in very close DS2 and DS3 fragility parameters. I might use 0.50 or so.

% DS1 Damage Limitation, Operationability (Slight Damage)   % DS2 Significant Damage (Moderate Damage)
% DS3 Near COllapse (Extensive Damage)                      % DS4 Collapse
% dsLIST = {'DS1' 'DS2' 'DS3' 'DS4'}; % (p35 of D'ayala et al., 2015) 
consqModel = [2, 10, 40.4, 100]; % DS1, DS2, DS3, and DS4; repair cost ratio (% of building repair cost) (COM4 from HAZUS 2003)

%% We have now essentially fixed the hazard fitting parameter as well as the im bound parameters 
fitModel = '3param'; % {'2param', '3param'}; % Basically, k0*a^(-k) OR k0*exp[-k2*ln^2(a) - k1*ln(a)]
N = 21; % [11, 21, 51]; % number of points between consecutive imValLIST values

%% im bound
imOrAfeBound = 1; % 1*ones(1, 4); % no bound (=0); bound over IM (= 1); bound over AFE (= 2)

% PGA
% lowerBoundLIST = [0.01, 99, 99*ones(1, 2)]; % 99, to indicate that lowerBound is taken as the minimum im Value from fragility analysis
% upperBoundLIST = [5, 5, 1.37, 1.58]; % 1.37 = PGA_Max in Zone-IV; 1.58 = PGA_Max in Zone-V

% SaTa
% lowerBoundLIST = [0.01, 99, 99*ones(1, 6)]; % 99, to indicate that lowerBound is taken as the minimum im Value from fragility analysis
% upperBoundLIST = [5, 5, 2.70, 1.91, 1.31, 3.23, 2.41, 1.70]; % SaTa_Max for Ta = {0.37, 0.61, 0.91} in zone- {IV, V}.

% SaTogm- (unb, lb, and lub) unbounded, lower-bounded, lower-and-upper bounded
% lowerBoundLIST = [0.01, 99, 99*ones(1, 6)]; % 99, to indicate that lowerBound is taken as the minimum im Value from fragility analysis
% upperBoundLIST = [5, 5, 0.77, 0.71, 0.62, 1.16, 1.23, 1.21]; % SaTogm_Max for Togm = {1.44, 1.56, 1.87} in zone-IV; Togm = {1.15, 1.57, 1.64} in zone-V;

% (unb and lb cases)
% lowerBoundLIST = [0.01, 99]; % 99, to indicate that lowerBound is taken as the minimum im Value from fragility analysis
% upperBoundLIST = [5, 5]; 

% (lub for zone-IV)
% lowerBoundLIST = 99*ones(1, 3); % 99, to indicate that lowerBound is taken as the minimum im Value from fragility analysis
% upperBoundLIST = [0.77, 0.71, 0.62]; % SaTogm_Max for Togm = {1.44, 1.56, 1.87} in zone-IV;

% (lub for zone-V)
% lowerBoundLIST = 99*ones(1, 3); % 99, to indicate that lowerBound is taken as the minimum im Value from fragility analysis
% upperBoundLIST = [1.16, 1.23, 1.21]; % SaTogm_Max for Togm = {1.15, 1.57, 1.64} in zone-V;

lowerBoundLIST = 99; % 99, to indicate that lowerBound is taken as the minimum im Value from fragility analysis
upperBoundLIST = 5;

%% Annualized Repair Cost Ratio targets (RCR is normalized by the total building replacement cost)
% EAL_in_pc_tarLIST = [1.5; ... % 1.5% class-B as per Cosenza et al (2018) New Italian code
%                      1.0; ... % 1.0% class-A as per Cosenza et al (2018) New Italian code
%                      0.5];    % 0.5% class-A+ as per Cosenza et al (2018) New Italian code

EAL_in_pc_tarLIST = [1.5; ... % 1.5% class-B as per Cosenza et al (2018) New Italian code
                     0.75; ... % 1.0% class-A as per Cosenza et al (2018) New Italian code
                     0.30];    % 0.5% class-A+ as per Cosenza et al (2018) New Italian code
impFacLIST = [1.2; ... % business continuity structures (IS 1893-1, 2016)
              1.5; ... % critical and lifeline structures  (IS 1893-1, 2016)
              2.0];    % highly critical structures (dam etc.)
verbose = 1; % for debugging, set this to 2; this will just print more intermediate results 
imScaleFac = 1; % this is an optional variable; used for paramteric study to see the impact of hazard variation on risk
%% 0 for actual hazard; 1, for code-idealized hazard using two-parameter model based on DBE and MCE values
% codeIdealizedHazData = 0; % 0 or NO input, would invoke the use of actual hazard curve for risk calculation 
codeIdealizedHazData = 0; % 1, the program uses code-idealized hazard using two-parameter model based on DBE and MCE values

factorOnImMin = 1; % optional variable that reduces the imMin value
saveFigures = 0; % when running for optimal beta, do not saveFigures
dirForFigures = 'figures_revB';

pLIST = [0.20, 0.10, 0.02, 0.01, 0.005]; % (in fraction) i.e., 0.10 for 10% poe in 50 years.
% end of the input for this paper.

% counterMax = size(dsLIST, 2) * size(imOrAfeBoundLIST, 2);

%% the following calls masterFunLambdaARCR_v2 for each building
tableWithAllInfo = table; tableBrief = table;
fprintf('Loop-ID, ds, imType, imOrAfeBound, boundRange\n'); counter = 0; totalCounter = size(bldgIDLIST, 2)*size(lowerBoundLIST, 2);
if size(lowerBoundLIST, 2) == size(upperBoundLIST, 2)
    for j = 1:size(lowerBoundLIST, 2)
        lowerBound = lowerBoundLIST(1, j); upperBound = upperBoundLIST(1, j);
        boundRange = [lowerBound, upperBound];
        for i = 1:size(bldgIDLIST, 2)
            bldgId = bldgIDLIST{1, i};
            T1forIM = T1LIST(1, i);
            counter = counter + 1;
            %   fprintf('%i/%i, %s, %s, %i, [%f, %f]\n', i, size(bldgIDLIST, 2), bldgId, imType, imOrAfeBound, boundRange(1), boundRange(2));
            fprintf('%i/%i, %s, %s, %i, [%f, %f]\n', counter, totalCounter, bldgId, imType, imOrAfeBound, boundRange(1), boundRange(2));
            %   tableCurr = masterFunLambdaARCR_v1(latLonLIST, zoneOfLocLIST, BldgIdAndZoneLIST, ds, imType, T1LIST, TaLIST, fitModel, N, imOrAfeBound, boundRange, lambda_tarLIST, impFacLIST, verbose, imScaleFac, codeIdealizedHazData);
            tableCurr = masterFunLambdaARCR_v2(bldgId, T1forIM, normalizedByThetaU, DS2_threshold, consqModel, fitModel, N, imOrAfeBound, boundRange, verbose, imScaleFac, codeIdealizedHazData, factorOnImMin, saveFigures, dirForFigures);
            % Here we convert it to the "required factor for targeted risk"
            tableWithAllInfo = [tableWithAllInfo; tableCurr];
        end
    close all;
    end
end
disp(tableWithAllInfo)
boundRangeTiled = kron([lowerBoundLIST', upperBoundLIST'], ones(size(bldgIDLIST'))); % boundRangeTiled = repmat(boundRange, size(bldgIDLIST'));
tableBrief = [tableBrief; table(tableWithAllInfo.BuildingID, tableWithAllInfo.IM, boundRangeTiled, tableWithAllInfo.H_475, tableWithAllInfo.H_2475, tableWithAllInfo.lambda_RCR_in_pc, tableWithAllInfo.lambda_DS4, tableWithAllInfo.lambda_DS1)];
tableBrief.Properties.VariableNames = {'BldgID', 'IM', 'im_bound', 'H475', 'H2475', 'EAL_in_pc', 'lambda_coll', 'lambda_IO'};
disp(tableBrief)

toc

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

