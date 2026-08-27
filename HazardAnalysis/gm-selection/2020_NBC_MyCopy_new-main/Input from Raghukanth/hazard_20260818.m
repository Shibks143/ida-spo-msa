
clear; tic
basefolder =pwd;
fileName = 'hazard_20260818.mat';

%% Start of Inputs %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

lithologyType = 'Alluvium'; % Select site lithology; ref: Raghukanth et al (2024)_Draft Earthquake Zone Map of India

%%% End of Inputs %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

lithGroup = {'metamorphicRocks'; 'sedimentaryRocks'; 'lateriteLayers'; 'Alluvium'};
ampFactor = [1.25; 1.50; 1.75; 1.85];
idx = strcmp(lithGroup, lithologyType);
AF  = ampFactor(idx); % Obtain corresponding amplification factor

periodLIST = {'c_0pt01s','c_0pt015s','c_0pt02s','c_0pt03s','c_0pt04s','c_0pt05s','c_0pt06s','c_0pt075s', ...
    'c_0pt09s','c_0pt1s','c_0pt15s','c_0pt2s','c_0pt3s','c_0pt4s','c_0pt5s','c_0pt6s', ...
    'c_0pt7s','c_0pt75s','c_0pt8s','c_0pt9s','c_1s','c_1pt2s','c_1pt5s','c_2s', ...
    'c_2pt5s','c_3s','c_5s'};

%% ===================== GUWAHATI =====================
locName = 'Guwahati';
T = readtable('_fromSTGR_Guwahati_HazardData_2026-08-18.xlsx', 'Sheet', 'HazardCurves', 'VariableNamingRule', 'preserve');

int_g = T.Sa_g';
cDataCell = cell(1,length(periodLIST));
for i = 1:length(periodLIST)
    cDataCell{i} = T{:,i+1}';
end

buildAndStoreHazTable(fileName, locName, int_g, periodLIST, cDataCell, AF);

%% ===================== DELHI =====================
locName = 'Delhi';
T = readtable('_fromSTGR_Delhi_HazardData_2026-08-18.xlsx', 'Sheet', 'HazardCurves', 'VariableNamingRule', 'preserve');

% IM levels
int_g = T.Sa_g';

cDataCell = cell(1,length(periodLIST));
for i = 1:length(periodLIST)
    cDataCell{i} = T{:,i+1}';
end

buildAndStoreHazTable(fileName, locName, int_g, periodLIST, cDataCell, AF);

%% ===================== helper function =====================
function buildAndStoreHazTable(fileName, locName, int_g, periodNames, cDataCell, AF)

% apply amplification factor only to intensity measure
int_g = int_g * AF;
% assemble columns
cols = [{int_g(:)}, cellfun(@(v) v(:), cDataCell, 'UniformOutput', false)];

varNames = [{'int_g'}, periodNames];
hazardCurveTableTemp = table(cols{:}, 'VariableNames', varNames);


% store under a location-specific variable name
varName = sprintf('hazardCurveTable_%s', locName);
S.(varName) = hazardCurveTableTemp; 

if isfile(fileName)
    save(fileName, '-struct', 'S', '-append'); % add without wiping other locations already in the file
else
    save(fileName, '-struct', 'S'); % first location — create the file
end
fprintf('Saved %s into %s\n', varName, fileName);
end


toc
