function sks_FragilityDataGen_MIDR(MIDRInputs)

eqLIST =            MIDRInputs.eqNumberLIST;
GMsuiteName  =      MIDRInputs.GMsuiteName;
timePLIST =         MIDRInputs.timePLIST;
dsLIST =            MIDRInputs.dsLIST;
BldgIdAndZoneLIST = MIDRInputs.BldgIdAndZoneLIST;


%% To save run time of risk modules, we need to execute this script ONCE with appropriate lists of building ID, imType, and damage state.
% This script takes approximately 8-10 minutes to execute for buildings, im types, and 4 damage states

baseFolder1 = pwd;
saveDir = fullfile(baseFolder1,'DATA_files');

if ~exist(saveDir,'dir')
    mkdir(saveDir);
end
fragDataFileName = sprintf('DATA_fragility_ALL');

count = 0;
totalNumRuns = size(BldgIdAndZoneLIST, 1)*size(timePLIST, 2)*size(dsLIST, 2);
%% A. script begins
for i = 1:size(BldgIdAndZoneLIST, 1) % for each building
    bldgIdCurr = BldgIdAndZoneLIST{i, 1};
    % variable name for storing building ID, this cannot begin with a numeral
    bldgIdVar = ['ID' bldgIdCurr];

    [~, analysisTypeFolder, ~, ~] = returnModelFolderInfo(bldgIdCurr);
    cd(baseFolder1)

    %% %% B. (perform computations); SINCE THIS IS A ONE-TIME EXECUTION, I AM ABANDONING THE IDEA OF PARALLELIZATION.

    for j = 1:size(timePLIST, 2)  % for intensity measure corresponding to each period
        T_new = timePLIST(1, j);
        fragAllData.(bldgIdVar).timeP(j, 1) = T_new;
        % the following piece basically assign imType one of 'PGA', Sa1p4, or Sa_1p35, depending on the digits after decimal
        if abs(T_new - 0) < 1e-6 % i.e., if it's PGA, assign 'PGA'
            imType = 'PGA';
        elseif abs(mod(T_new*100, 10)) <1e-6 % i.e., if the second digit after decimal is zero, e.g., 1.4
            imType = sprintf('Sa_%ip%i', floor(T_new), int8(mod(T_new*10, 10))); % assign Sa_1p4
        else                    % i.e., if the second digit after decimal is non-zero, e.g., 1.35
            imType = sprintf('Sa_%ip%.2i', floor(T_new), int8(mod(T_new*100, 100))); % assign Sa_1p35
        end

        for k = 1:size(dsLIST, 2) % for each damage state
            ds = dsLIST{1, k};
            fragAllData.(bldgIdVar).ds{1, k} = ds;
            switch ds
                case 'DynInst';   MIDR_ds = 0.00; % proxy for dynamic instability
                case 'CP'     ;   MIDR_ds = 0.04;
                case 'LS'     ;   MIDR_ds = 0.02;
                case 'IO'     ;   MIDR_ds = 0.01;
            end

 
            [fragParamMu_ALL, fragParamBetaRTR_ALL, fragParamMu_CTRL, fragParamBetaRTR_CTRL, imMin] = extractFragilityForDifferentIM_v2(analysisTypeFolder, MIDR_ds, eqLIST, T_new, GMsuiteName);

            %% parfor doesn't allow writing to a structure here, hence I have the assigning out of parfor now, read detailed notes above.
            % fragility components using all components of earthquakes
            %             muAllVar = sprintf('muAll_%s_%ip%ipcMIDR', imType, floor(MIDR_ds*100), int8(mod(MIDR_ds*1000, 10)));
            %             betaAllRTRVar = sprintf('betaRTRAll_%s_%ip%ipcMIDR', imType, floor(MIDR_ds*100), int8(mod(MIDR_ds*1000, 10)));

            % fragility components using controlling components of earthquakes
            %             muCtrl = sprintf('mu_%s_%ip%ipcMIDR', imType, floor(MIDR_ds*100), int8(mod(MIDR_ds*1000, 10)));
            %             betaRTRCtrl = sprintf('betaRTR_%s_%ip%ipcMIDR', imType, floor(MIDR_ds*100), int8(mod(MIDR_ds*1000, 10)));

            % store the fragility data of all buildings with unique variables
            fragAllData.(bldgIdVar).muAll(j, k) = fragParamMu_ALL;
            fragAllData.(bldgIdVar).betaRTRAll(j, k) = fragParamBetaRTR_ALL;
            fragAllData.(bldgIdVar).muCtrl(j, k) = fragParamMu_CTRL;
            fragAllData.(bldgIdVar).betaRTRCtrl(j, k) = fragParamBetaRTR_CTRL;

            % store minimum intensity measure from the analyses, this is particularly useful for intensity-bound risk assessment
            %             imMinVar = sprintf('imMin_%s_%ip%ipcMIDR', imType, floor(MIDR_ds*100), int8(mod(MIDR_ds*1000, 10)));
            
            fragAllData.(bldgIdVar).imMin(j, k) = imMin;
            fragAllData.(bldgIdVar).analysisFolder = analysisTypeFolder;
            fragAllData.(bldgIdVar).eqLIST = eqLIST;
            count = count + 1; fracDone = count/totalNumRuns; waitbar(fracDone);

        end
    end %% end of parfor, i.e., end of the extraction of fragility for a specific building

    % saving results intermittently to avoid data loss, if any
    % save(fullfile(saveDir,[fragDataFileName 'bldg' num2str(i)]),'fragAllData');

end
save(fullfile(saveDir,fragDataFileName),'fragAllData'); % navigate to the directory where we need DATA files
cd(baseFolder1); % again back to the script directory


