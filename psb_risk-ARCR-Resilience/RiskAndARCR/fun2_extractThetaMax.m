function [thetaM_p, thetaM_n] = fun2_extractThetaMax(bldgID, eqNumber, saT1Val, eleID)
% both outputs return algebraic value
% This function extracts maximum rotation during an analysis

baseFolder = pwd;

% Convert column or beam ID to four numbers, jointIDs and springIDs corresponding to end-I and end-J
[endIJointID, endISpringID, endJJointID, endJSpringID] = fun2a_returnJointAndSpringID(eleID);
[~, analysisTypeFolder, ~, ~] = returnModelFolderInfo(bldgID);


eqFolder = sprintf('EQ_%d', eqNumber);
% if saT1Val > 10
%     fprintf('Check the folder name\n');
%     pause
% end 
SaFolder = sprintf('Sa_%3.2f', saT1Val);
cd(fullfile(analysisTypeFolder, 'IDA', eqFolder, SaFolder, 'Elements'));


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

cd(fullfile('..', 'Joints'));
fileName_J = sprintf('Joint_ForceAndDef_%d.out', endJJointID);
fileJ_data = load(fileName_J);
thetaTH_J = fileJ_data(:, endJSpringID);

% thetaM = max(abs([thetaTH_I; thetaTH_J]), [], 'all');
thetaM_p = max(0, max([thetaTH_I; thetaTH_J], [], 'all')); % maximum but not negative
thetaM_n = min(0, min([thetaTH_I; thetaTH_J], [], 'all')); % minimum but not positive
thetaM_n = abs(thetaM_n); % return algebraic value

cd(baseFolder)
