function NGAFileInfo = readNGAW2File(rawRecDir, filename, readVertComp)
% rawRecDir = 'ScaledRawCoding';
% filename = 'RSN166_IMPVALL.H_H-CC4045.AT2';
% filename = 'RSN166_IMPVALL.H_H-CC4-UP.AT2';

baseFolder = pwd; cd(rawRecDir);

%% do not read the vertical component unless explicitly requested
if nargin == 2
    readVertComp = 0;
end

% break file parts into name and extension
[~, fileNoExt, ext] = fileparts(filename);
k = strfind(fileNoExt, '_'); k = k(1); 
NGAFileInfo.EQID = fileNoExt(4:k-1); NGAFileInfo.filename = fileNoExt; NGAFileInfo.ext = ext;

NGAFileInfo.database = 'NGA_W2'; NGAFileInfo.surfaceRec = nan; % not applicable. Assigning nan to keep same 
% structure while readings different records from different databases

%% assign the component type. exit if a vertical component, unless explicitly requested
if contains(filename, 'UP.AT2') || contains(filename, 'DN.AT2') || contains(filename, 'V.AT2') || contains(filename, 'UD.AT2')
    NGAFileInfo.horComp = 0;
    if readVertComp == 0
        NGAFileInfo.readme{1, 1} = 'I did not read the vertical component because it was not requested.';
        NGAFileInfo.readme{2, 1} = 'Use variable readVertComp as 1 to format vertical components.';
        cd(baseFolder); return;
    end
elseif strcmpi(ext, '.AT2')
    NGAFileInfo.horComp = 1; % assign horizontal component and read the file
else
    error('Invalid filename %s, sent for processing as NGA-W2.', filename);
end

%% open the file (read headers)
fid = fopen(filename,'r'); A = cell(0);
for i = 1:4
    newline = fgetl(fid); A = [A; newline];
end
fclose(fid);

NumPoints = 0; dt = 0; % initialize

% line 4 has NPTS and dt
x = strsplit(A{4}); 

for i =1:size(x, 2)-1
    if contains(x{i}, 'NPTS')
        NumPoints = str2double(strrep(x{i+1}, ',',''));
    end
    if contains(x{i}, 'DT')
        dt = str2double(x{i+1});
    end
end

if NumPoints == 0 || dt == 0
    error('I expected strings NPTS and DT on line- 4 of %s.', filename);
end

%% read the time history data now
linesToSkip = 4; B = importdata(filename, ' ', linesToSkip);
timeHistory_rec = reshape(B.data', numel(B.data), 1); % reshaping into one column
timeHistory_rec(~any(~isnan(timeHistory_rec), 2),:)=[];
timeHistory_g = timeHistory_rec; % recordings in units of g

NGAFileInfo.TH = timeHistory_g;
NGAFileInfo.dt = dt;
NGAFileInfo.NumPoints= NumPoints;
NGAFileInfo.pga = max(abs(timeHistory_g));

cd(baseFolder)