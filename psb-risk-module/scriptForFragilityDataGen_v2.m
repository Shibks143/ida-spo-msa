clear
tic
%% To save run time of risk modules, we need to execute this script ONCE with appropriate lists of building ID, imType, and damage state.
% This script takes approximately 8-10 minutes to execute for 9 buildings, 9 im types, and 4 damage states

baseFolder1 = pwd;

%% start of inputs
saveDir = 'DATA_files';
fragDataFileName = sprintf('DATA_fragility_ALL');

% imTypeLIST = {'PGA', 'Sa_0p1', 'Sa_0p2', 'Sa_0p5', 'Sa_0p9', 'Sa_1p0', 'Sa_1p2', 'Sa_2p0', 'Sa_5p0'};
timePLIST = [0, 0.04:0.01:5]; % skipping 0.01, 0.02, and 0.03 because several response spectra has Inf for these periods

dsLIST = {'DynInst','CP', 'LS', 'IO'};
BldgIdAndZoneLIST = {	
%     '2205v03',  'III';  '2207v09',	'III';	'2209v05',	'III';}: ... % 4, 7, 12-story zone-III
%     '2213v04',	'IV';   '2215v03',	'IV';   '2217v03',	'IV';}:  ... % 4, 7, 12-story zone-IV
%     '2221v06',	'V';    '2223v03',	'V';    '2225v03',	'V';}:   ... % 4, 7, 12-story zone-V
%     '2211v03_sca2', 'IV'; '2213v04_sca2', 'IV'; '2215v03_sca2', 'IV';}; ... % 2, 4, 7-story zone-IV (CS-compatible GM suite)
%     '2219v03_sca2', 'V';  '2221v06_sca2', 'V';  '2223v03_sca2', 'V'; }; ... % 2, 4, 7-story zone-V (CS-compatible GM suite)
%     '2211v03_sca2', 'IV'; '2213v04_sca2', 'IV';};
%     '2215v03_sca2', 'IV'; 
%     '2219v03_sca2', 'V'; };
%     '2221v06_sca2', 'V'; };
%     '2223v03_sca2', 'V'; };
      '2433v02', 'V'; };


eqNumberLIST_forProcessing_SetC = [120111, 120112, 120121, 120122,	120411, 120412,	120521, 120522,	120611, 120612,	120621, 120622,	120711, 120712,	120721, 120722,	120811, 120812,	120821, 120822,	120911, 120912,	120921, 120922,	121011, 121012,	121021, 121022,	121111, 121112,	121211, 121212,	121221, 121222,	121321, 121322,	121411, 121412,	121421, 121422,	121511, 121512,	121711, 121712];
% eqLIST_2211_Sca2 = [6000311	6000312	6001601	6001602	6001831	6001832	6002121	6002122	6002851	6002852	6003411	6003412	6003521	6003522	6004081	6004082	6004091	6004092	6004571	6004572	6004581	6004582	6004611	6004612	6006331	6006332	6006921	6006922	6007861	6007862	6009521	6009522	6009681	6009682	6009871	6009872	6011351	6011352	6014361	6014362	6023951	6023952	6026271	6026272];
% eqLIST_2213_Sca2 = [6002301	6002302	6002501	6002502	6003391	6003392	6005481	6005482	6007201	6007202	6007531	6007532	6008321	6008322	6008361	6008362	6008501	6008502	6008731	6008732	6009311	6009312	6009701	6009702	6009891	6009892	6010781	6010782	6011581	6011582	6012921	6012922	6013161	6013162	6013611	6013612	6015321	6015322	6026181	6026182	6026611	6026612	6032701	6032702];
% eqLIST_2215_Sca2 = [6001581	6001582	6003001	6003002	6005711	6005712	6007281	6007282	6007371	6007372	6007571	6007572	6008841	6008842	6009491	6009492	6009881	6009882	6011111	6011112	6011201	6011202	6011821	6011822	6011931	6011932	6013091	6013092	6013441	6013442	6014181	6014182	6014751	6014752	6015381	6015382	6016281	6016282	6024571	6024572	6025091	6025092	6027341	6027342];
% eqLIST_2219_Sca2 = [6000961	6000962	6004071	6004072	6006391	6006392	6007271	6007272	6007281	6007282	6007441	6007442	6007731	6007732	6008251	6008252	6008791	6008792	6009021	6009022	6009521	6009522	6009591	6009592	6009871	6009872	6010041	6010042	6010501	6010502	6010771	6010772	6010871	6010872	6012381	6012382	6015461	6015462	6017621	6017622	6027391	6027392	6034741	6034742];
% eqLIST_2221_Sca2 = [6000061	6000062	6000951	6000952	6000961	6000962	6001431	6001432	6001501	6001502	6002651	6002652	6003591	6003592	6004951	6004952	6005291	6005292	6005641	6005642	6007271	6007272	6007521	6007522	6007661	6007662	6008081	6008082	6010041	6010042	6010501	6010502	6011201	6011202	6011661	6011662	6012921	6012922	6014891	6014892	6014921	6014922	6027521	6027522];
% eqLIST_2223_Sca2 = [6000771	6000772	6001601	6001602	6001801	6001802	6004951	6004952	6005291	6005292	6007531	6007532	6008061	6008062	6010421	6010422	6010441	6010442	6010541	6010542	6010631	6010632	6010861	6010862	6010871	6010872	6011011	6011012	6012621	6012622	6014771	6014772	6015111	6015112	6015211	6015212	6017871	6017872	6017921	6017922	6032751	6032752	6033171	6033172];		

% eqLIST = eqNumberLIST_forProcessing_SetC; % now assigned below as a function of the buildings ID

%%% end of inputs
count = 0;
totalNumRuns = size(BldgIdAndZoneLIST, 1)*size(timePLIST, 2)*size(dsLIST, 2);
%% A. script begins
for i = 1:size(BldgIdAndZoneLIST, 1) % for each building
    bldgIdCurr = BldgIdAndZoneLIST{i, 1};
    % variable name for storing building ID, this cannot begin with a numeral
    bldgIdVar = ['ID' bldgIdCurr];

    % cd H:\DamageIndex\Automated
    
    [~, analysisTypeFolder, ~, ~] = returnModelFolderInfo(bldgIdCurr);
    cd(baseFolder1)

%% B. (perform computations) parallelizing the program to reduce run-time; some remarks are in the order:
% 1. parallelizing on buildings is not optimal, since they are NINE BUILDINGS and my PC has FOUR CORES, resulting in a total 25% overhead.
%    Hence parallelizing on timePLIST, which has approximately 500 values
% 2. parfor wouldn't allow fragAllData, i.e., a structure to be assigned from within, in the name of sliced variable.
% 3. I am writing all five variables [mu_im_all, betaRTR_all, mu_im, betaRTR, imMin] to temporary variables namely, mu_im_allLIST, etc.;
% 4. Finally, I would assign data in these temporary variables back to structure named fragAllData
% 5. To be able to do 4, we need loops on j and k twice, only difference
% being the absence of (a) extractFragilityForDifferentIM_v2 and hence, (b) parfor, during the assignment.
%% SINCE THIS IS A ONE-TIME EXECUTION, I AM ABANDONING THE IDEA OF PARALLELIZATION. 

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
            
%             [mu_im_all, betaRTR_all, mu_im, betaRTR] = extractFragilityForDifferentIM(analysisTypeFolder, MIDR_ds, eqLIST, T_new);
    switch bldgIdCurr
        % case '2211v03_sca2'
        %     eqLIST = eqLIST_2211_Sca2; GMsuiteName = 'GMSetDel22_2211_Sca2';
        % case '2213v04_sca2'
        %     eqLIST = eqLIST_2213_Sca2; GMsuiteName = 'GMSetDel22_2213_Sca2';
        % case '2215v03_sca2'
        %     eqLIST = eqLIST_2215_Sca2; GMsuiteName = 'GMSetDel22_2215_Sca2';
        % case '2219v03_sca2'
        %     eqLIST = eqLIST_2219_Sca2; GMsuiteName = 'GMSetGuw22_2219_Sca2';
        % case '2221v06_sca2'
        %     eqLIST = eqLIST_2221_Sca2; GMsuiteName = 'GMSetGuw22_2221_Sca2';
        % case '2223v03_sca2'
        %     eqLIST = eqLIST_2223_Sca2; GMsuiteName = 'GMSetGuw22_2223_Sca2';
        otherwise
            eqLIST = eqNumberLIST_forProcessing_SetC; GMsuiteName = 'GMSetC';
    end
    
            [mu_im_all, betaRTR_all, mu_im, betaRTR, imMin] = extractFragilityForDifferentIM_v2(analysisTypeFolder, MIDR_ds, eqLIST, T_new, GMsuiteName);

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
            
            fragAllData.(bldgIdVar).analysisFolder = analysisTypeFolder;
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
cd(saveDir); save([fragDataFileName 'bldg' num2str(i)], 'fragAllData'); cd ..;
% cd(saveDir); save([fragDataFileName 'bldg_2221' num2str(i)], 'fragAllData'); cd ..;
% cd(saveDir); save([fragDataFileName 'bldg_2223' num2str(i)], 'fragAllData'); cd ..;

end
cd(saveDir); % navigate to the directory where we need DATA files
save(fragDataFileName, 'fragAllData');
cd(baseFolder1); % again back to the script directory

toc

