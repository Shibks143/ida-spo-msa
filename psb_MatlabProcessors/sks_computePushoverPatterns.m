function [pushoverPatternLIST, patternNameLIST, floorMassLIST, floorHeightLIST, modeShapeLIST] = sks_computePushoverPatterns(modelFolder, matlabInformationFolder)
% ===============================================
% (25-Nov-2026) Shivakumar K S, IIT Madras
% Computes the three lateral load patterns for pushover analysis of one building:
%   1. Parabolic  : Q_i proportional to W_i x h_i^2  (IS 1893 equivalent static distribution)
%   2. Linear     : Q_i proportional to W_i x h_i    (inverted triangle)
%   3. Mode Shape : Q_i proportional to W_i x phi_i1 (first lateral mode)
% Each pattern is normalised so that the floor forces add up to 1.0.
%
% Inputs:
%   modelFolder             - Models\<fileName>; floor masses are read from the "mass" lines
%                             in psb_ModelCodePastedFromExcelVBA.tcl (nodes 2FFxxx, X-direction mass)
%   matlabInformationFolder - Output\<analysisType>\MatlabInformation; written by OpenSees
%                             (psb_WriteNeededInformationToFilesForMatlab.tcl) in any earlier run:
%                               floorHeightLISTOUT.out  (mm, first entry = ground = 0)
%                               eigenVectorOUT.out      (row = level 0..N, column = mode)
%
% Outputs (rows ordered ROOF FIRST, as passed to OpenSees in PUSHOVER_LATERALFORCE_ON_FLOORS - psb_RunPushoverIfSpecified.tcl):
%   pushoverPatternLIST - [numFloors x 3] normalised floor forces, columns = patternNameLIST
%   patternNameLIST     - {'Parabolic', 'Linear', 'Mode Shape'}
%   floorMassLIST       - [numFloors x 1] floor mass (kN-s^2/mm)
%   floorHeightLIST     - [numFloors x 1] floor height above ground (mm)
%   modeShapeLIST       - [numFloors x 1] first lateral mode shape, roof = 1
% ===============================================

patternNameLIST = {'Parabolic', 'Linear', 'Mode Shape'};

% ---- Floor heights (mm), drop the ground level ----
floorHeightFile = fullfile(matlabInformationFolder, 'floorHeightLISTOUT.out');
if ~isfile(floorHeightFile)
    error('%s not found - run the pushover once (analyze = 1) to create MatlabInformation.', floorHeightFile);
end
floorHeightAllLevels = load(floorHeightFile);
floorHeightLIST = floorHeightAllLevels(2:end);          % floor 2 ... roof (bottom to top)
floorHeightLIST = floorHeightLIST(:);
numFloors = numel(floorHeightLIST);

% ---- Floor masses (kN-s^2/mm): sum X-direction mass of all nodes on each floor ----
modelFile = fullfile(modelFolder, 'psb_ModelCodePastedFromExcelVBA.tcl');
if ~isfile(modelFile)
    error('Model file not found: %s', modelFile);
end
massTokens = regexp(fileread(modelFile), '(?m)^\s*mass\s+(2\d{5})\s+([0-9.eE+-]+)', 'tokens');   % numeric masses only; small masses use [expr ...] and are skipped
nodeTagLIST  = cellfun(@(token) str2double(token{1}), massTokens);
nodeMassLIST = cellfun(@(token) str2double(token{2}), massTokens);
floorNumOfNode = floor(nodeTagLIST / 1000) - 200;                                                % 213011 -> floor 13
floorMassLIST = accumarray(floorNumOfNode(:) - 1, nodeMassLIST(:), [numFloors, 1]);               % floor 2 -> row 1
if any(floorMassLIST <= 0)
    error('Zero mass found on some floor in %s - check the mass lines.', modelFile);
end

% ---- First lateral mode shape ----
% Mode 1 written by OpenSees is a spurious mode (eigenvalue 0.02, zero floor displacement) in these models,
% so take the first mode whose floor displacements are not zero.
eigenVectorFile = fullfile(matlabInformationFolder, 'eigenVectorOUT.out');
if ~isfile(eigenVectorFile)
    error('%s not found - run the pushover once (analyze = 1) to create MatlabInformation.', eigenVectorFile);
end
eigenVectorAllLevels = load(eigenVectorFile);
eigenVectorFloors = eigenVectorAllLevels(2:numFloors+1, :);      % drop ground level (row 1)
firstLateralMode = find(max(abs(eigenVectorFloors), [], 1) > 1e-6, 1, 'first');
if isempty(firstLateralMode)
    error('No lateral mode found in %s', eigenVectorFile);
end
modeShapeLIST = eigenVectorFloors(:, firstLateralMode);
modeShapeLIST = modeShapeLIST / modeShapeLIST(end);             % roof = +1 (also fixes the sign)

% ---- Three patterns (bottom to top), each adds up to 1.0 ----
parabolicPattern = floorMassLIST .* floorHeightLIST.^2;
linearPattern    = floorMassLIST .* floorHeightLIST;
modeShapePattern = floorMassLIST .* modeShapeLIST;
pushoverPatternLIST = [parabolicPattern / sum(parabolicPattern), ...
                       linearPattern    / sum(linearPattern), ...
                       modeShapePattern / sum(modeShapePattern)];

% ---- Roof first (row order of PUSHOVER_LATERALFORCE_ON_FLOORS read by psb_RunPushoverIfSpecified.tcl) ----
pushoverPatternLIST = flipud(pushoverPatternLIST);
floorMassLIST       = flipud(floorMassLIST);
floorHeightLIST     = flipud(floorHeightLIST);
modeShapeLIST       = flipud(modeShapeLIST);

end
