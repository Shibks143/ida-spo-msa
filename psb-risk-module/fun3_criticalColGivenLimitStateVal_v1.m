function [criticalColID_chi_LIST, criticalColID_xi_LIST, criticalFloorNum_chiBased, criticalFloorNum_xiBased] = fun3_criticalColGivenLimitStateVal_v1(bldgID, eqLIST, LimitStateVal)
% limit over chi (thetaM / thetaU), or xi (thetaM / thetaCap) 

%% sample inputs
% bldgID = '2211v03_sca2';
% eqLIST = [6000311	6000312	6001601	6001602	6001831	6001832	6002121	6002122	6002851	6002852	6003411	6003412	6003521	6003522	6004081	6004082	6004091	6004092	6004571	6004572	6004581	6004582	6004611	6004612	6006331	6006332	6006921	6006922	6007861	6007862	6009521	6009522	6009681	6009682	6009871	6009872	6011351	6011352	6014361	6014362	6023951	6023952	6026271	6026272];
% LimitStateVal = 0.75;
%%%%%%% END OF USER INPUT

%% Calculations start
baseFolder = pwd;
numEqs = size(eqLIST, 2);
    
%% 0. Based on building ID, read colIDLIST from MatlabInfo directory of output folder
%     cd H:\DamageIndex\Automated
    % cd ..\..\..\DamageIndex\Automated\
    
    [~, analysisTypeFolder, ~, ~] = returnModelFolderInfo(bldgID);
    
%% if colID list is required, uncomment the following
    cd(analysisTypeFolder); 
    cd MatlabInformation
    colIDLIST = load('columnNumsAtEachStoryLISTOUT.out');
    numFloors = size(colIDLIST, 1); 
%     colIDLIST = colIDLIST(:, 1:end-1); % remove leaning frame columns
%     colIDLIST = reshape(colIDLIST, 1, numel(colIDLIST)); % reshape the matrix to an array 
%     numCols = size(colIDLIST, 2); 
    cd(baseFolder);
    
%% 1. extract critical column ID for particular EQ and scaling 
for eqIndex = 1:numEqs
    eqNumber = eqLIST(eqIndex);
    eqFolder = sprintf('EQ_%d', eqNumber);
    cd(analysisTypeFolder); cd(eqFolder);
    
    thisEqDataFileName = sprintf('DATA_criticalColDamRat_IDA_ForThisEQ.mat');
    load(thisEqDataFileName, 'saT1LIST', 'chiMax', 'criticalColID', 'xiMax', 'criticalColID_xi'); % saT1LIST remains largly unused. So far!
    
    ix = find(chiMax  > LimitStateVal, 1);
    if isempty(ix) % even the last SaVal corresponds to a chiMax < LimitStateVal 
        criticalColID_chi_LIST(eqIndex) = criticalColID(end);
    elseif ix == 1 % the very first SaVal corresponds to a chiMax > LimitStateVal
        criticalColID_chi_LIST(eqIndex) = criticalColID(1);
    else
        if LimitStateVal > (chiMax(ix) + chiMax(ix-1))/2
            criticalColID_chi_LIST(eqIndex) = criticalColID(ix);
        else
            criticalColID_chi_LIST(eqIndex) = criticalColID(ix-1);
        end
    end
    
    ix = find(xiMax  > LimitStateVal, 1);
    if isempty(ix) % even the last SaVal corresponds to a xiMax < LimitStateVal 
        criticalColID_xi_LIST(eqIndex) = criticalColID_xi(end);
    elseif ix == 1 % the very first SaVal corresponds to a xiMax > LimitStateVal
        criticalColID_xi_LIST(eqIndex) = criticalColID_xi(1);
    else
        if LimitStateVal > (xiMax(ix) + xiMax(ix-1))/2
            criticalColID_xi_LIST(eqIndex) = criticalColID_xi(ix);
        else
            criticalColID_xi_LIST(eqIndex) = criticalColID_xi(ix-1);
        end
    end
    criticalColFloor_chi_LIST(eqIndex) = floor((criticalColID_chi_LIST(eqIndex) - 3e4)/100); % recall that colIDs follow 3ffgg; where ff is floor number, and gg is grid
    criticalColFloor_xi_LIST(eqIndex) = floor((criticalColID_xi_LIST(eqIndex) - 3e4)/100); 
end

for k = 1:numFloors
        x = criticalColFloor_chi_LIST; % assigning to an array for easy referencing in the next line(s)
        criticalFloorNum_chiBased(1, k) = sum(x == k);

        y = criticalColFloor_xi_LIST; % assigning to an array for easy referencing in the next line(s)
        criticalFloorNum_xiBased(1, k) = sum(y == k);
end

cd(baseFolder)