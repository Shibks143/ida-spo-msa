function sks_seismicRiskCal_MIDR(MIDRInputs)

tic; baseFolder = pwd;
%% 0. With chosen parameters, this script gives one risk values to be used for the paper. 
latLonLIST =           MIDRInputs.latLonLIST;
zoneOfLocLIST =        MIDRInputs.zoneOfLocLIST; 
imScaleFac =           MIDRInputs.imScaleFac; % Scale IS 1893 hazard such that it matches with site hazard at some Tr
dsLIST =               MIDRInputs.dsLIST; 
imTypeLIST =           MIDRInputs.imTypeLIST;
BldgIdAndZoneLIST =    MIDRInputs.BldgIdAndZoneLIST;
impFacLIST =           MIDRInputs.impFacLIST;
fitModelLIST =         MIDRInputs.fitModelLIST;
NLIST =                MIDRInputs.NLIST;
TaLIST =               MIDRInputs.Ta;
T1LIST =               MIDRInputs.T1LIST;
TogmLIST =             MIDRInputs.TogmLIST;
codeIdealizedHazData = MIDRInputs.codeIdealizedHazData;

% T1LIST = TaLIST; % (period for Intensity measure, Sa(T1) 
T1LIST = TogmLIST; % geoM_Topt2 (<= 2sec) for CS ground motion records 

%% X. im bound
%% X.0. factorOnImMin kicks in only if lowerBound = 99, i.e. when imMin is used. 
% Since, it's possible that (true imMin) < (imMin obtained from analysis). 
    factorOnImMin = 1.00; % 1.00; % optional variable that reduces the imMin value (DEFAULT value = 1)

% % %% X.1. (UNBOUNDED CASE) 
%     imOrAfeBoundLIST = 0; % no bound (=0); bound over IM (= 1); bound over AFE (= 2)
%     lowerBoundLIST = 0.01; 
%     upperBoundLIST = 5; % lower bound bound (over im or afe, as may be the case)

% X.2. (LOWER-BOUNDED CASE) 
    imOrAfeBoundLIST = 1; % no bound (=0); bound over IM (= 1); bound over AFE (= 2)
    lowerBoundLIST = 99; % 0.01; assign 99 to indicate that lowerBound is taken as the minimum im Value from fragility analysis
    upperBoundLIST = 5; % lower bound bound (over im or afe, as may be the case)

% afe bound
% imOrAfeBoundLIST = 2*ones(1, 6); % no bound (=0); bound over IM (= 1); bound over AFE (= 2)
% lowerBoundLIST = [1e-6, 1e-5, 1e-4, 1e-6, 1e-5, 1e-4]; % range of bound (over im or afe, as may be the case)
% upperBoundLIST = [2e-2, 2e-2, 2e-2, 1e-1, 1e-1, 1e-1]; % range of bound (over im or afe, as may be the case)

%% Importance Factor list
verbose = 1; % for debugging, set this to 2; this will just print more intermediate results 

%% Assign building list depending on the required results
counterMax = size(dsLIST, 2) * size(fitModelLIST, 2) * size(NLIST, 2) * size(imOrAfeBoundLIST, 2);

%% Well, too many loops, but we always carry out parametric comparisons by varying only a few variables at a time.
counter = 0; tableWithAllInfo = table;
fprintf('Loop-ID, ds, imType, fitModel, N, imOrAfeBound, boundRange\n');
for i = 1:size(dsLIST, 2) % over damage states
    ds = dsLIST{1, i};
    imType = imTypeLIST{1, 1};  
    for k = 1:size(fitModelLIST, 2) % over hazard fit model
        fitModel = fitModelLIST{1, k};
        for p = 1:size(NLIST, 2) % over descretization
            N = NLIST(1, p);
            for q = 1:size(imOrAfeBoundLIST, 2) % over bounds
                counter = counter + 1; 
                imOrAfeBound = imOrAfeBoundLIST(1, q);
                boundRange = [lowerBoundLIST(1, q), upperBoundLIST(1, q)];
                fprintf('%i/%i, %s, %s, %s, %i, %i, [%f, %f]\n', counter, counterMax, ds, imType, fitModel, N, imOrAfeBound, boundRange(1), boundRange(2));
                tableCurr = masterFunRiskAllStepsWithRiskVarVsImpFac_v7a(latLonLIST, zoneOfLocLIST, BldgIdAndZoneLIST, ds, imType, T1LIST, TaLIST, fitModel, N, imOrAfeBound, boundRange, impFacLIST, verbose, imScaleFac, codeIdealizedHazData, factorOnImMin);
                disp(tableCurr.Properties.VariableNames) 
        
   %%  This part is added by shivakumar KS ON 9/4/2025, needs to be verify and fix it 
                varNames = tableCurr.Properties.VariableNames;
                % find only existing RT_mu columns
                idx = startsWith(varNames,'RT_mu');
                RT_vars = varNames(idx);
                mu_dsVar = 'mu_ds';   

                for r = 1:length(RT_vars)
                    RT_muVar = RT_vars{r};
                    tableCurr.(RT_muVar) = tableCurr.(RT_muVar) ./ tableCurr.(mu_dsVar);
                    % rename column
                    colIndex = strcmp(tableCurr.Properties.VariableNames, RT_muVar);
                    tableCurr.Properties.VariableNames{colIndex} = sprintf('RTGM_ReqFac%i', r);

                end
                tableWithAllInfo = [tableWithAllInfo; tableCurr];
                
            end
        end
    end
end

disp(tableWithAllInfo)
toc
