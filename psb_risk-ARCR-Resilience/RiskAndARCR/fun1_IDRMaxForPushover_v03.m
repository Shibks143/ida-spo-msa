function [V_perfLimit, roofDR_PL] = fun1_IDRMaxForPushover_v03(BuildingID, perfLimit)

% roofDR_PL is the roof drift corresponding to perfLimit.
% V_perfLimit is the shear corresponding to that perfLimit.

baseFolder = pwd;

% BuildingID = '2227v01';
% roof drift ratio corresponding to the performance limit of 4% or 2% of Max IDR
% perfLimit = 0.02; 

[~, analysisTypeFolder, designR, ~] = returnModelFolderInfo(BuildingID);

cd(baseFolder)
cd(analysisTypeFolder)
cd(fullfile('EQ_9991', 'Sa_0.00', 'RunInformation'));

floorHeightLIST = load('floorHeightLISTOUT.out');
numFloors = length(floorHeightLIST) - 1;
individualFloorHt = zeros(1, numFloors);

for floorIndex = 2:numFloors+1
    individualFloorHt(floorIndex - 1) = floorHeightLIST(floorIndex) - floorHeightLIST(floorIndex - 1);
end
    
cd(fullfile('..', 'Nodes', 'DisplTH'));
% store displacements of each floor in a matrix
for floorIndex = 2:numFloors+1
    currentNodeNum = 300 + floorIndex;
    fileName = sprintf('THNodeDispl_%i.out', currentNodeNum);
    tempDispData = load(fileName);
    dispMatrix(:, floorIndex) = tempDispData(:, 2);    
    
%     IDR_matrix(:, floorIndex) = (dispMatrix(:, floorIndex) -  dispMatrix(:, floorIndex - 1))/ individualFloorHt(floorIndex - 1);
end

% Interstory drift ratio of each floor
for floorIndex = 2:numFloors+1
    IDR_matrix(:, floorIndex) = (dispMatrix(:, floorIndex) -  dispMatrix(:, floorIndex - 1))/ individualFloorHt(floorIndex - 1);
end

% max IDR
maxIDR = max(IDR_matrix, [], 2);

% roof drift ratio
roofDR = dispMatrix(:, numFloors + 1)/ sum(individualFloorHt);

% roof drift ratio corresponding to the performance limit of 4% or 2% of Max IDR
% PL = 0.02; 
% roofDR_PL = interp1(maxIDR, roofDR, perfLimit);

% interp1 gives up every now and then, citing to even the small modulation in the pushover drift values
% hence using the robust interpolation
ix = find(maxIDR >= perfLimit, 1);
roofDR_PL = interp1([maxIDR(ix-1), maxIDR(ix)], ...
                    [roofDR(ix-1), roofDR(ix)], perfLimit, 'pchip');

% disp(roofDR_PL)


cd(analysisTypeFolder)
load DATA_pushover.mat  plotArrayAndBaseShearArray

BS = plotArrayAndBaseShearArray(:, 2);
defoVec = plotArrayAndBaseShearArray(:, 1);


    ix = find(defoVec >= roofDR_PL, 1);
    V_perfLimit = interp1([defoVec(ix-1), defoVec(ix)], [BS(ix-1), BS(ix)], roofDR_PL, 'pchip');

cd(baseFolder)

