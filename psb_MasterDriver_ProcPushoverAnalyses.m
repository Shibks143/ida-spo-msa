
clear; % DO NOT REMOVE THIS COMMAND. BECAUSE WE SAVE THE MATLAB SPACE AT THE END AND WHATEVER IS THERE IN THE MATSPACE BEFORE ANALYSIS IS RUN WILL BE SAVED. 
tic 

baseFolder = pwd;

% Automatically detect current root directory (works on both Windows and Linux HPC)
rootDir = fileparts(mfilename('fullpath'));

% Add code folders to MATLAB search path
addpath(genpath(fullfile(rootDir, 'psb_MatlabProcessors')));
addpath(genpath(fullfile(rootDir, 'psb_IntensityMeasures')));
addpath(genpath(fullfile(rootDir, 'OpenSeesProcessingFiles')));
addpath(genpath(fullfile(rootDir, 'Models')));

%% This one for running script at HPC (Paramshakti); added on 02-sep-2026
if isunix
    setenv('PATH', ['/home/apps/MLDL/DL-CondaPy3/envs/opensees/bin:' getenv('PATH')]);
end


%% Conventional code starts from here

% fileNameLIST = {'ID35053_R5_5Story_v.03'};       % ID35053_R5_5Story_v.03 | ID35083_R5_8Story_v.03 | ID35123_R5_12Story_v.03 | ID46053_R5_5Story_v.04 | ID46083_R5_8Story_v.04 | ID46123_R5_12Story_v.04 
fileNameLIST = {'ID35053_R5_5Story_v.03'; 'ID35083_R5_8Story_v.03'; 'ID35123_R5_12Story_v.03'; 'ID46053_R5_5Story_v.04'; 'ID46083_R5_8Story_v.04'; 'ID46123_R5_12Story_v.04'};       

shearHingeOrNot = 0;                            % if there is a shear Hinge then different opensees file is used; using 1 would always work 
                                                % but may not be the fastest in case of haselton-type models with flexural-only hinges

plotDefoShape = 1;                              % plot deformed shape

% (20-Nov-2026, sks) store the pushover curve of every building for the combined plot
numBuildings = size(fileNameLIST, 1);
pushoverCurveLIST = cell(numBuildings, 1);      % each cell: [roofDriftRatio, baseShear (kN)]
mu_T_LIST = nan(numBuildings, 1);               % period-based ductility of each building


for buildingIndex = 1:size(fileNameLIST, 1)
    fileName = fileNameLIST{buildingIndex, 1};

cd Models
cd(fileName)

fprintf('Running %i/%i... Building: %s  \n', buildingIndex, length(fileNameLIST), fileName);

%% Common code block %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

system('OpenSees psb_RunMeanAnalysis.tcl');
cd(baseFolder)

%% comment out above portion, if only plotting of the pushover curve is required to be done

%
% Procedure: MasterDriver_ProcessPushoverAnalyses.m
% -------------------
% This processes the pushover (monotonic and cyclic) analyses, then
% makes/saves all of the results.
%
% Assumptions and Notices: 
%   - none
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
baseFolder = pwd;

% Define building information - change this for the building being used

analysisType_forPO = sprintf('(%s)_(AllVar)_(0.00)_(clough)', fileName);

% Set the options for processing and plotting
    % Stuff to change
    eqNumber_PO = 9991;                     % 9991 for monotonic, 9992 for cyclic
    isProcessPOAnalysis = 1;                % no need to process, if once processed (& say, code is being re-run to generate new plots)
    
    isPlotPO = 1;                           % 1- Yes plot it. 0- No, do not plot it
    plotRoofDriftRatio = 1;                 % Plot roof drift ratio instead of roof displacement.
    determinePeriodBasedDuctility = 1;      % (10-28-15, PSB) FEMA-P695 sec 6.3 to find out period-based ductility
    
    isPlotStoryPO = 0;                      % This plots the story POs versus story shear and base shear both.  The 
                                            %   processors that this calls were fixed and updated by CBH on 6-16-08.
    storyNumLIST = [2];                     % Stories to plot story PO
    
    isPlotPOMaxDriftLevel = 1;              % Interstorydrift ratio vs Floor number 
                                            % Max drifts over PO
    
    maxNumPoints = 10000000;                % Large number does not limit the length of the plot       
    markerType_PO = 'b-';
    lineWidth_PO = 3;
    plotDefoShape = 0;                      % plot deformed shape
    
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
    % No need to change this stuff
    poModelType = 2;                        % Always use 2; 1 for nlBmCol/dispBmCol, 2 for lumpedPlasticity
    saTOneForRun_PO = 0.00;                 % Always use 0.00
    
    
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Call the procedure to do the processing and plotting
    cd psb_MatlabProcessors
    [plotArrayAndBaseShearArray, mu_T] = ProcessAndPlotPushoverAnalyses_proc(analysisType_forPO, isProcessPOAnalysis, poModelType, saTOneForRun_PO, ...
                                    eqNumber_PO, isPlotPO, plotRoofDriftRatio, maxNumPoints, markerType_PO, lineWidth_PO, isPlotStoryPO, ...
                                    storyNumLIST, isPlotPOMaxDriftLevel, determinePeriodBasedDuctility);
    cd ..

    % (20-Nov-2026, sks) keep this building's curve for the combined plot
    pushoverCurveLIST{buildingIndex, 1} = plotArrayAndBaseShearArray;
    mu_T_LIST(buildingIndex, 1) = mu_T;
%     (6-1-16, PSB) store pushover results to plot together
    cd Output
    cd(analysisType_forPO)
    save('DATA_pushover.mat');
    cd ..
    cd ..
    close;
    close;
end

%% (20-Nov-2026, sks) print period-based ductility of every building: buildingID | mu_T
buildingIDLIST = cell(numBuildings, 1);
for buildingIndex = 1:numBuildings
    buildingIDLIST{buildingIndex, 1} = extractBefore(fileNameLIST{buildingIndex, 1}, '_');   % 'ID35053_R5_5Story_v.03' -> 'ID35053'
end
mu_T_TABLE = table(buildingIDLIST, mu_T_LIST, 'VariableNames', {'buildingID', 'mu_T'});
disp(mu_T_TABLE);

%% (20-Nov-2026, sks) combined pushover plot, only when fileNameLIST has more than one building
if numBuildings > 1
    figure('Name', 'Combined pushover');
    mainAxes = gca;
    hold(mainAxes, 'on'); grid(mainAxes, 'on'); box(mainAxes, 'on');

    designs2016LIST     = {'ID35053_R5_5Story_v.03'; 'ID35083_R5_8Story_v.03'; 'ID35123_R5_12Story_v.03'};
    designsProposedLIST = {'ID46053_R5_5Story_v.04'; 'ID46083_R5_8Story_v.04'; 'ID46123_R5_12Story_v.04'};
    storyLabelLIST      = {'5-Story'; '8-Story'; '12-Story'};

    lineColorLIST = [0.00 0.00 1.00;    % blue    -> 2016, 5-story
                     1.00 0.00 1.00;    % magenta -> 2016, 8-story
                     0.00 0.00 0.00;    % black   -> 2016, 12-story
                     1.00 0.00 0.00;    % red     -> Proposed, 5-story
                     0.90 0.60 0.00;    % orange  -> Proposed, 8-story
                     0.00 0.60 0.00];   % green   -> Proposed, 12-story
    numDesignsPerStandard = numel(designs2016LIST);   % 3 -> Proposed colours start at row 4

    lineStyle2016     = '-';            % 2016 Standard
    lineStyleProposed = '-';            % Proposed Standard ('--' for dashed)

    roofDriftLimit = 0.09;              % x-axis upper limit (roof drift ratio)
    baseShearLimit = 5000;              % y-axis upper limit (kN)
    legendFontSize = 12;                % font size for both legends (text and title)

    legendHandles2016   = gobjects(0);  legendText2016     = {};
    legendColorProposed = {};           legendTextProposed = {};   % rebuilt on overlay axes later

    for buildingIndex = 1:numBuildings
        if isempty(pushoverCurveLIST{buildingIndex})
            continue;   % skip a building whose pushover did not finish
        end
        roofDeformation = pushoverCurveLIST{buildingIndex}(:, 1);   % drift ratio (or mm if plotRoofDriftRatio = 0)
        baseShear       = pushoverCurveLIST{buildingIndex}(:, 2);   % kN
        buildingName    = fileNameLIST{buildingIndex};
        buildingID      = extractBefore(buildingName, '_');         % 'ID35053_R5_5Story_v.03' -> 'ID35053'

        [is2016, storyIndex2016]         = ismember(buildingName, designs2016LIST);
        [isProposed, storyIndexProposed] = ismember(buildingName, designsProposedLIST);

        if is2016
            lineHandle = plot(mainAxes, roofDeformation, baseShear, lineStyle2016, ...
                'Color', lineColorLIST(storyIndex2016, :), 'LineWidth', lineWidth_PO);
            legendHandles2016(end+1) = lineHandle;
            legendText2016{end+1}    = sprintf('%s (%s)', storyLabelLIST{storyIndex2016}, buildingID);
        elseif isProposed
            proposedColorIndex = storyIndexProposed + numDesignsPerStandard;
            plot(mainAxes, roofDeformation, baseShear, lineStyleProposed, ...
                'Color', lineColorLIST(proposedColorIndex, :), 'LineWidth', lineWidth_PO);
            legendColorProposed{end+1} = lineColorLIST(proposedColorIndex, :);
            legendTextProposed{end+1}  = sprintf('%s (%s)', storyLabelLIST{storyIndexProposed}, buildingID);
        else
            warning('Building %s is not in either design list - plotted grey, not in legend.', buildingName);
            plot(mainAxes, roofDeformation, baseShear, ':', 'Color', [0.5 0.5 0.5], 'LineWidth', lineWidth_PO);
        end
    end

    if plotRoofDriftRatio == 1
        xlabel(mainAxes, 'Roof Drift Ratio');
        xlim(mainAxes, [0, roofDriftLimit]);
    else
        xlabel(mainAxes, 'Roof Displacement (mm)');
        xlim(mainAxes, [0, inf]);   % mm: auto upper limit
    end
    ylabel(mainAxes, 'Base Shear (kN)');
    ylim(mainAxes, [0, baseShearLimit]);
    title(mainAxes, 'Pushover curves - all buildings');
    hold(mainAxes, 'off');

    sks_figureFormat('powerpoint');   % format first; legends below are created after, so our font size wins

    % ---- Legend 1: 2016 Standard (main axes, southeast) ----
    legend2016 = legend(mainAxes, legendHandles2016, legendText2016, ...
        'Location', 'southeast', 'Interpreter', 'none', 'FontSize', legendFontSize);
    legend2016.Title.String   = 'Designs as per 2016 Standard';
    legend2016.Title.FontSize = legendFontSize;

    % ---- Legend 2: Proposed Standard (transparent overlay axes, northeast) ----
    % Overlay stays 'Visible','on' so exportgraphics keeps its legend; it is see-through with no axis lines.
    overlayAxes = axes('Position', mainAxes.Position, 'Color', 'none', ...
        'XColor', 'none', 'YColor', 'none', 'XTick', [], 'YTick', [], 'HitTest', 'off');
    hold(overlayAxes, 'on');
    legendHandlesProposed = gobjects(numel(legendTextProposed), 1);
    for proposedIndex = 1:numel(legendTextProposed)
        legendHandlesProposed(proposedIndex) = plot(overlayAxes, NaN, NaN, lineStyleProposed, ...
            'Color', legendColorProposed{proposedIndex}, 'LineWidth', lineWidth_PO);
    end
    legendProposed = legend(overlayAxes, legendHandlesProposed, legendTextProposed, ...
        'Location', 'northeast', 'Interpreter', 'none', 'FontSize', legendFontSize);
    legendProposed.Title.String   = 'Designs as per Proposed Standard';
    legendProposed.Title.FontSize = legendFontSize;
    legendProposed.FontName       = legend2016.FontName;   % match the 2016 legend's font

    set(gcf, 'CurrentAxes', mainAxes);   % make main axes current WITHOUT bringing it to the front (axes() would hide the overlay legend)

    combinedExportName = fullfile(baseFolder, 'Output', 'Pushover_Combined_AllBuildings');
    sks_figureExport(combinedExportName);
    disp(['Saved: ', combinedExportName]);
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Call the procedure to plot the deformed shape
if plotDefoShape == 1
    fprintf('Plotting deformed shape...\n');
        % Go to visual processors folder
        cd(fullfile('psb_MatlabProcessors', 'MovieAndVisualProcessors'))
       
    for buildingIndex = 1:size(fileNameLIST, 1)
        fileName = fileNameLIST{buildingIndex, 1};
        underscoreLocs = strfind(fileName, '_');
        bldgID_LIST(1, buildingIndex) = str2double(fileName(3:underscoreLocs(1)-1));
        analysisDirLIST{buildingIndex, 1} = sprintf('(%s)_(AllVar)_(0.00)_(clough)', fileName);
    end
        driftPlotOption = 2;    % Plot the drifts at the last time step of the analysis (to show the collapse mechanism better), 1- undeformed building
        maxOnDemandCapacityRatioToPlot = 3.0;   % Limit the demand/capacity ratio to 3, so the plots won't be too crazy at collapse.
        pushoverStepNameIdentifier = 'lastStep'; 

        psb_pushoverDeformedShape(bldgID_LIST, analysisDirLIST, driftPlotOption, maxOnDemandCapacityRatioToPlot, pushoverStepNameIdentifier);
        
        cd ..
        cd ..
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
   toc