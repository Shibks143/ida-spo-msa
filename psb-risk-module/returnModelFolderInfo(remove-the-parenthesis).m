
% (01-13-17) PSB
% this function acts as a common file for location of model files
% Earlier each file has their own list of folder locations and
% any change in the location would require the change to be replicated in
% all the files.

function [modelFolder, analysisTypeFolder, designR, VBAfileNameWithLocation] = returnModelFolderInfo(buildingID)


switch buildingID

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%% Most updated Multi-objective Risk-targeted Seismic Design framework paper %%%%%%%%%%%
    
    case '2211v03_sca2'
        modelFolder = 'I:\PrakRuns_I\Models\ID2211_R5_2Story_v.03_CS_Del22_Sca2';
        analysisTypeFolder = 'I:\PrakRuns_I\Output\(ID2211_R5_2Story_v.03_CS_Del22_Sca2)_(AllVar)_(0.00)_(clough)';
        VBAfileNameWithLocation = 'I:\VBA_MODEL_FILES\2211v03_20190509General Excel Sheet-v21 (allInclusive).xlsm';
        designR = 5;
end