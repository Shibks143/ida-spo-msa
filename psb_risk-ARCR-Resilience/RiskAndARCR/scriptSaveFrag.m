clear; 
DS_StoryDriftLIST = [0.005, 0.01, 0.021]; % DS1, DS2, DS3, DS4 (0.00 indicates sidesway collapse or dynamic instability)
buildingIDLIST = {'1310v1_FF'; '1310v1_NF'; '1610v1_FF'; '1610v1_NF'; '1910v1_FF'; '1910v1_NF'}; % legStr = {'3-Story (FF)', '3-Story (NF)', '6-Story (FF)', '6-Story (NF)', '9-Story (FF)', '9-Story (NF)'}; plotStyle = {'k-', 'k--', 'b-', 'b--', 'r-', 'r--'}; figNameSuff = 'allSix';
outpFolderLIST = {'C:\Users\aprak\Desktop\UBCO_AnalysisResults\Results_Spectra_small\(ID1310_v.01_FF)_(AllVar)_(0.00)_(clough)';
                  'C:\Users\aprak\Desktop\UBCO_AnalysisResults\Results_Spectra_small\(ID1310_v.01_NF)_(AllVar)_(0.00)_(clough)';
                  'C:\Users\aprak\Desktop\UBCO_AnalysisResults\Results_Spectra_small\(ID1610_v.01_FF)_(AllVar)_(0.00)_(clough)';
                  'C:\Users\aprak\Desktop\UBCO_AnalysisResults\Results_Spectra_small\(ID1610_v.01_NF)_(AllVar)_(0.00)_(clough)';
                  'C:\Users\aprak\Desktop\UBCO_AnalysisResults\Results_Spectra_small\(ID1910_v.01_FF)_(AllVar)_(0.00)_(clough)';
                  'C:\Users\aprak\Desktop\UBCO_AnalysisResults\Results_Spectra_small\(ID1910_v.01_NF)_(AllVar)_(0.00)_(clough)';};
eqLIST_FF = [120111, 120112, 120121, 120122,	120411, 120412,	120521, 120522,	120611, 120612,	120621, 120622,	120711, 120712,	120721, 120722,	120811, 120812,	120821, 120822,	120911, 120912,	120921, 120922,	121011, 121012,	121021, 121022,	121111, 121112,	121211, 121212,	121221, 121222,	121321, 121322,	121411, 121412,	121421, 121422,	121511, 121512,	121711, 121712];
eqLIST_NF = [8201811	8201812	8201821	8201822	8202921	8202922	8207231	8207232	8208021	8208022	8208211	8208212	8208281	8208282	8208791	8208792	8210631	8210632	8210861	8210862	8211651	8211652	8215031	8215032	8215291	8215292	8216051	8216052	8201261	8201262	8201601	8201602	8201651	8201652	8204951	8204952	8204961	8204962	8207411	8207412	8207531	8207532	8208251	8208252	8210041	8210042	8210481	8210482	8211761	8211762	8215041	8215042	8215171	8215172	8221141	8221142];

for i = 1:size(buildingIDLIST, 1)
    buildingID = buildingIDLIST{i, 1};
    bldgNum = int32(str2double(buildingID(1:4))); % number
    outpFolder = outpFolderLIST(i);
    if contains(buildingID, '_FF')
        eqLIST = eqLIST_FF; GMsuiteName = 'GMSetC';
    elseif contains(buildingID, '_NF')
        eqLIST = eqLIST_NF; GMsuiteName = 'GMSetG';
    else
        error('eqLIST unassigned');
    end

    switch bldgNum
        case 1310;  T1forIM = 0.83; SaT1 = 0.435;       
        case 1610;  T1forIM = 1.68; SaT1 = 0.221;       
        case 1910;  T1forIM = 2.41; SaT1 = 0.153;       
    end
    fileNameToSaveFragData = sprintf('fragRes_NonStr_%s_%s', buildingID, GMsuiteName);
    [~, ~, ~, meanSa, sigmaLn, imMin] = extractFragilityForMIDR_v1(bldgNum, outpFolder, DS_StoryDriftLIST, eqLIST, GMsuiteName, T1forIM, fileNameToSaveFragData);
    meanSaBySaT1LIST(i, :) = meanSa./SaT1;
    sigmaLIST(i, :) = sigmaLn;
end
    disp(meanSaBySaT1LIST); fprintf('-----------------------\n');
    disp(sigmaLIST);  fprintf('-----------------------\n');
