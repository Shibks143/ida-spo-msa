function sks_FragilityDataGen_PHR(PHRInputs)
tic
%% start of inputs
BldgIdLIST=          PHRInputs.BldgIdLIST;
timePLIST =          PHRInputs.timePLIST;
dsLIST =             PHRInputs.dsLIST;
GMsuiteName =        PHRInputs.GMsuiteName;
eqLIST =             PHRInputs.eqNumberLIST;
imTypeLIST =         PHRInputs.imTypeLIST; 
latLon =             PHRInputs.latLonLIST; 
zoneOfLoc =          PHRInputs.zoneOfLocLIST;    
baseFolder =         PHRInputs.baseFolder;


%% To save run time of risk modules, we need to execute this script ONCE with appropriate lists of building ID, imType, and damage state.
% This script takes approximately 8-10 minutes to execute for  buildings, im types, and damage states

thisFilePath = fileparts(mfilename('fullpath'));
saveDir = fullfile(thisFilePath, 'DATA_files');
fragDataFileName = sprintf('DATA_fragility_Dayala_%s', BldgIdLIST{1});

%%% end of inputs

count = 0;
totalNumRuns = size(BldgIdLIST, 2)*size(timePLIST, 2)*size(dsLIST, 2);
%% A. script begins
for i = 1:size(BldgIdLIST, 2) % for each building
    bldgIdShort = BldgIdLIST{1, i};
    switch bldgIdShort
        case '2433v02'
            bldgIdCurr = '2433v02';
            GMsuiteName = 'GMSetC';
            latLon = [26.17   91.77]; % Guwahati (Table 5.4 of NDMA, 2011 report)
            locName = 'Guwahati';
            zoneOfLoc = 'V';
            Ta = 0.71;

    end
% variable name for storing building ID, this cannot begin with a numeral
    bldgIdVar = ['ID' bldgIdCurr];

    [~, analysisTypeFolder, ~, ~] = returnModelFolderInfo(bldgIdCurr);
    cd(baseFolder)
    
%% B. (perform computations) parallelizing the program to reduce runtime; some remarks are in the order:
% 1. parallelizing on buildings is not optimal, since they are NINE BUILDINGS and my PC has FOUR CORES, resulting in a total 25% overhead.
%    Hence parallelizing on timePLIST, which has approximately 500 values
% 2. parfor wouldn't allow fragAllData, i.e., a structure to be assigned from within, in the name of sliced variable.
% 3. I am writing all five variables [mu_im_all, betaRTR_all, mu_im, betaRTR, imMin] to temporary variables namely, mu_im_allLIST, etc.;
% 4. Finally, I would assign data in these temporary variables back to structure named fragAllData
% 5. To be able to do 4, we need loops on j and k twice, only difference
% being the absence of (a) extractFragilityForDifferentIM_v2 and hence, (b) parfor, during the assignemnt.
%% SINCE THIS IS A ONE-TIME EXECUTION, I AM ABANDONING THE IDEA OF PARALLELIZATION. 

    for j = 1:size(timePLIST, 2)  % for intensity measure corresponding to each period
        T_new = timePLIST(1, j);
        fragAllData.(bldgIdVar).timeP(j, 1) = T_new;
        % the following piece basically assign imType one of 'PGA', Sa1p4, or Sa_1p35, depending on the digits after decimal 
%         if abs(T_new - 0) < 1e-6 % i.e., if it's PGA, assign 'PGA'
%             imType = 'PGA';
%         elseif abs(mod(T_new*100, 10)) <1e-6 % i.e., if the second digit after decimal is zero, e.g., 1.4
%             imType = sprintf('Sa_%ip%i', floor(T_new), int8(mod(T_new*10, 10))); % assign Sa_1p4
%         else                    % i.e., if the second digit after decimal is non-zero, e.g., 1.35
%             imType = sprintf('Sa_%ip%.2i', floor(T_new), int8(mod(T_new*100, 100))); % assign Sa_1p35
%         end

        
        for k = 1:size(dsLIST, 2) % for each damage state
            dsCurr = dsLIST{1, k};
            fragAllData.(bldgIdVar).ds{1, k} = dsCurr;
%             [mu_im_all, betaRTR_all, mu_im, betaRTR] = extractFragilityForDifferentIM(analysisTypeFolder, MIDR_ds, eqLIST, T_new);
%             [mu_im_all, betaRTR_all, mu_im, betaRTR, imMin] = extractFragilityForDifferentIM_v2(analysisTypeFolder, MIDR_ds, eqLIST, T_new);
            
              [mu_im_all, betaRTR_all, mu_im, betaRTR, imMin] = extractFragilityForDS_DayalaEtAl_v1(bldgIdCurr, GMsuiteName, eqLIST, dsCurr, T_new);

%% parfor doesn't allow writing to a structure here, hence I have the assigning out of parfor now, read detailed notes above.
            % fragility components using all components of earthquakes
%             muAllVar = sprintf('muAll_%s_%ip%ipcMIDR', imType, floor(MIDR_ds*100), int8(mod(MIDR_ds*1000, 10)));
%             betaAllRTRVar = sprintf('betaRTRAll_%s_%ip%ipcMIDR', imType, floor(MIDR_ds*100), int8(mod(MIDR_ds*1000, 10)));
            
            % fragility components using controlling components of earthquakes
%             muCtrl = sprintf('mu_%s_%ip%ipcMIDR', imType, floor(MIDR_ds*100), int8(mod(MIDR_ds*1000, 10)));
%             betaRTRCtrl = sprintf('betaRTR_%s_%ip%ipcMIDR', imType, floor(MIDR_ds*100), int8(mod(MIDR_ds*1000, 10)));
            
            % store the fragility data of all buildings with unique variables 
            fragAllData.(bldgIdVar).muAll(j, k) = mu_im_all;
            fragAllData.(bldgIdVar).betaRTRAll(j, k) = betaRTR_all;
            fragAllData.(bldgIdVar).muCtrl(j, k) = mu_im;
            fragAllData.(bldgIdVar).betaRTRCtrl(j, k) = betaRTR;
            
            % store minimum intensity measure from the analyses, this is particularly useful for intensity-bound risk assessment
%             imMinVar = sprintf('imMin_%s_%ip%ipcMIDR', imType, floor(MIDR_ds*100), int8(mod(MIDR_ds*1000, 10)));
            fragAllData.(bldgIdVar).imMin(j, k) = imMin;
            
%             fragAllData.(bldgIdVar).analysisFolder = analysisTypeFolder;
            fragAllData.(bldgIdVar).eqLIST = eqLIST;
            
            count = count + 1; fracDone = count/totalNumRuns; waitbar(fracDone);
            
%%
%              mu_im_allLIST(j, k) = mu_im_all;
%              betaRTR_allLIST(j, k) = betaRTR_all;
%              mu_imLIST(j, k) = mu_im;
%              betaRTRLIST(j, k) = betaRTR;
%              imMinLIST(j, k) = imMin;
        end
    end %% end of parfor, i.e., end of the extraction of fragility for a specific building

% saving results intermittently to avoid data loss, if any
% cd(saveDir); save([fragDataFileName 'bldg' num2str(i)], 'fragAllData'); cd ..;

end
save(fullfile(saveDir, fragDataFileName), 'fragAllData');
cd(baseFolder); % again back to the script directory

toc

