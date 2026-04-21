function [thetaM_p, thetaM_n] = fun2_extractThetaMax(bldgID, eqNumber, saT1Val, eleID)
% both outputs return algebraic value

% This function extracts maximum rotation during an analysis
% output folder are taken from H:\DamageIndex\Automated\returnModelFolderInfo

% bldgID = '2211v03_sca2';
% eqNumber = 6000311;
% saT1Val = 1.01;
% eleID = 30201;

baseFolder = pwd;

% Convert column or beam ID to four numbers, jointIDs and springIDs corresponding to end-I and end-J
[endIJointID, endISpringID, endJJointID, endJSpringID] = fun2a_returnJointAndSpringID(eleID);

% cd H:\DamageIndex\Automated
% cd ..\..\..\DamageIndex\Automated\

[~, analysisTypeFolder, ~, ~] = returnModelFolderInfo(bldgID);
% lastwarn(''); % resetting last warning message;

eqFolder = sprintf('EQ_%d', eqNumber);
% if saT1Val > 10
%     fprintf('Check the folder name\n');
%     pause
% end 
SaFolder = sprintf('Sa_%3.2f', saT1Val);
cd(analysisTypeFolder)
cd(eqFolder)
cd(SaFolder)
cd Elements

if endISpringID == 0
    cd Hinges
    fileName_I = sprintf('HingeRotTH_%d.out', endIJointID);
    thetaTH_I = load(fileName_I); % has merely one column
else
    cd Joints
    fileName_I = sprintf('Joint_ForceAndDef_%d.out', endIJointID);
    fileI_data = load(fileName_I);
    thetaTH_I = fileI_data(:, endISpringID);
end

cd ..\Joints
fileName_J = sprintf('Joint_ForceAndDef_%d.out', endJJointID);
fileJ_data = load(fileName_J);
thetaTH_J = fileJ_data(:, endJSpringID);

% thetaM = max(abs([thetaTH_I; thetaTH_J]), [], 'all');
thetaM_p = max(0, max([thetaTH_I; thetaTH_J], [], 'all')); % maximum but not negative
thetaM_n = min(0, min([thetaTH_I; thetaTH_J], [], 'all')); % minimum but not positive
thetaM_n = abs(thetaM_n); % return algebraic value

cd(baseFolder)
