% This simply loops over Sa levels and calls the hazard curve function to
% get the full hazard curve (for plotting, etc.)
% Curt Haselton
% 12-19-05
clear

saIndex = 1;
for saLevel = 0.001:0.01:2.0

    [hazardValue, hazardSlope] = HazardCurve_ReturnValueAndSlope(saLevel);
    saLevelLIST(saIndex) = saLevel;
    hazardValueLIST(saIndex) = hazardValue;

    saIndex = saIndex + 1;
end


disp('Done')








