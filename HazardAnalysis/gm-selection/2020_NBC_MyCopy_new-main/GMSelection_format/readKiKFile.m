function KiKFileInfo = readKiKFile(rawRecDir, filename, readBHComp, readVertComp)
% rawRecDir = 'ScaledRawCoding';
% filename = 'AOMH171103111446.EW2';
% filename = 'AOMH171103111446.UD2';

baseFolder = pwd; cd(rawRecDir);

%% do not read the borehole recordings or vertical component unless explicitly requested
switch nargin 
    case 2
        readBHComp = 0; readVertComp = 0;
    case 3
        readVertComp = 0;
end

% break file parts into name and extension
[~, fileNoExt, ext] = fileparts(filename);
KiKFileInfo.EQID = fileNoExt; KiKFileInfo.filename = fileNoExt; KiKFileInfo.ext = ext;
KiKFileInfo.database = 'KiK_NET';

%% assign the recording station type (surface or BH).
if strcmpi(ext, '.NS2') || strcmpi(ext, '.EW2') || strcmpi(ext, '.UD2') 
    KiKFileInfo.surfaceRec = 1; % surface recording
elseif strcmpi(ext, '.NS1') || strcmpi(ext, '.EW1') ||strcmpi(ext, '.UD1') 
    KiKFileInfo.surfaceRec = 0; % borehole recording
    if readBHComp == 0
        KiKFileInfo.readmeBH{1, 1} = 'I did not read the borehole recordindgs because it was not requested.';
        KiKFileInfo.readmeBH{2, 1} = 'Use variable readBHComp as 1 to format borehole recodings.';
    end
else
    error('Invalid filename %s, sent for processing as KiK-net.', filename);
end
    
%% assign the component type. 
if strcmpi(ext, '.NS1') || strcmpi(ext, '.NS2') || strcmpi(ext, '.EW1') || strcmpi(ext, '.EW2')
    KiKFileInfo.horComp = 1; % %dir is 1 or 2. Horizontal component
else
    KiKFileInfo.horComp = 0; % %dir is 0. vertical component
    if readVertComp == 0
        KiKFileInfo.readmeVert{1, 1} = 'I did not read the vertical component because it was not requested.';
        KiKFileInfo.readmeVert{2, 1} = 'Use variable readVertComp as 1 to format vertical components.';
    end
end
%% exit if it is a BH recording, unless specifically requested, OR
% if it is a vertical component, unless specifically requested
if (KiKFileInfo.surfaceRec == 0 && readBHComp == 0) || (KiKFileInfo.horComp == 0 && readVertComp == 0)
    cd(baseFolder); return;
end

%% open the file (read headers)
fid = fopen(filename,'r'); A = cell(0);
for i = 1:16
    newline = fgetl(fid); A = [A; newline];
end
fclose(fid);

% line 11 has frequency
x = strsplit(A{11}); y = x{end};
if contains(y, 'Hz')
    freq = str2double(y(1:end-2)); dt = 1/freq;
else
    error('I expected sampling frequency in Hz on line- 11 of %s.', filename);
end

% line 12 has duration in s
% x = strsplit(A{12}); y = x{end}; duration = str2double(y);

% line 14 has scaling factor 
x = strsplit(A{14}); 
if ~strcmp(x{1}, 'Scale')
    error('I expected scaling factor on line- 14 of %s.', filename);
end
y = x{end}; y = strrep(y, '(gal)', ''); y = strsplit(y, '/');
scalingFac_gal = str2double(y{1})/ str2double(y{2});

% line 15 has pga 
x = strsplit(A{15}); y = x{end};
pga_gal = str2double(y);

%% read the time history data 
linesToSkip = 17; B = importdata(filename, ' ', linesToSkip);
timeHistory_rec = reshape(B.data', numel(B.data), 1); % reshaping into one column
timeHistory_rec(~any(~isnan(timeHistory_rec), 2),:)=[];
timeHistory_gal = timeHistory_rec * scalingFac_gal; maxTH_gal = max(abs(timeHistory_gal)); 
timeHistory_g = timeHistory_gal/981;

% compare pga for inernal consistency check of the record and data-reading
% if abs((pga_gal - maxTH_gal)/pga_gal) > 0.10
%     warning(['Reported pga is %i%% (> 10%%) away from max of recording. ' ...
%         'Check %s.'], int32(abs((pga_gal - maxTH_gal)/pga_gal)*100), filename);
% end

KiKFileInfo.TH = timeHistory_g;
KiKFileInfo.dt = dt;
KiKFileInfo.NumPoints= size(timeHistory_g, 1);
KiKFileInfo.pga = maxTH_gal/981;

cd(baseFolder)