function totalMassFrame = sks_readFrameTotalMass(modelFolder)
% ===============================================
% (21-Nov-2026) Shivakumar K S, IIT Madras
% Reads the total seismic mass of the 2D frame from the line
%   "##### total mass is 1.14980377166157 (kN-s^2 /mm) #####"
% in <modelFolder>\psb_ModelCodePastedFromExcelVBA.tcl
% Output: totalMassFrame (kN-s^2/mm); W,2D = totalMassFrame x 9810 (kN)
% ===============================================

modelFile = fullfile(modelFolder, 'psb_ModelCodePastedFromExcelVBA.tcl');
if ~isfile(modelFile)
    error('Model file not found: %s', modelFile);
end

modelText = fileread(modelFile);
massToken = regexp(modelText, 'total mass is\s+([0-9.eE+-]+)', 'tokens', 'once');
if isempty(massToken)
    error('"total mass is" line not found in %s', modelFile);
end
totalMassFrame = str2double(massToken{1});

end