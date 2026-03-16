%%========================================================================================================================
%%==============================PUSHOVER PLOTS ===========================================================================
% written on (11-12-2025)
% written by Shivakumar K S, IIT-Madras
% Run this code after running psb_MasterDriver_ProcPushoverAnalyses.m
%%========================================================================================================================

%% COMBINED PUSHOVER LOAD PATTERNS 
% cd ..
baseFolder = pwd;

cd Output/(ID2433_R5_5Story_v.02)_(AllVar)_(0.00)_(clough)/

fileList     = {'DATA_pushover_1.mat', 'DATA_pushover_2.mat', 'DATA_pushover_3.mat'};   % SPO_index = 1,2,3...
patternNames = {'Parabolic','Linear','Mode Shape'};
curveColors  = [0 0 0; 1 0 0; 0 0 1];
pattern      = load(fileList{1});
pattern      = pattern.runDifferentPushoverPatterns;  
[numR, numC] = size(pattern);
numStories   = numR;                
floors       = (2:numStories+1)';    


% Collect one column per SPO_index (one curve per pattern)
pushoverPattern = zeros(numStories, numel(fileList));   
for SPO_index = 1:numel(fileList)
    dataStruct = load(fileList{SPO_index});
    pushoverForceOnFloors = dataStruct.runDifferentPushoverPatterns;             

    % Read rows in reverse (6→2 becomes 2→6)
    if size(pushoverForceOnFloors,1) == numStories
        col = pushoverForceOnFloors(numStories:-1:1, SPO_index);     
    else
        col = pushoverForceOnFloors(SPO_index, numStories:-1:1).';   
    end

    pushoverPattern(:, SPO_index) = col;
end

% Plot combined patterns
figure; hold on; grid on;
for SPO_index = 1:numel(fileList)
    plot(pushoverPattern(:,SPO_index), floors, '-o', 'LineWidth', 3, 'MarkerSize', 6, 'Color', curveColors(SPO_index,:), 'DisplayName',patternNames{SPO_index});
end
xlabel('PushoverForce','FontSize',14,'FontWeight','bold');
ylabel('Floor Number','FontSize',14,'FontWeight','bold');
title('PushoverForce vs Floor Number','FontSize',16,'FontWeight','bold');
legend('Location','eastoutside','FontSize',12,'Box','off');
ylim([min(floors) max(floors)]);
yticks(floors);          % [2 3 4 5 6]
set(gca,'LineWidth',1.5,'FontSize',12); box on; hold off;

print(gcf,'PushoverPatterns_vs_FloorNumber_runDifferentPushoverPatterns.emf','-dmeta','-r300');


%% COMBINED PUSHOVER PLOT 

%cd Output/(ID2433_R5_5Story_v.02)_(AllVar)_(0.00)_(clough)/

fileList = { 'DATA_pushover_1.mat', 'DATA_pushover_2.mat','DATA_pushover_3.mat'};
% patternNames = { 'Parabolic', 'Linear','Mode Shape'};
Vcap = 1200;   % base shear cap

% Load, cut & store all curves
allCurves = cell(numel(fileList), 1);
allMuT    = zeros(numel(fileList), 1);

for i = 1:numel(fileList)
    dataStruct = load(fileList{i});
    xy = dataStruct.plotArrayAndBaseShearArray;
    xyCut = cutAtVcapDescending(xy, Vcap);
    allCurves{i} = xyCut;
    allMuT(i)    = dataStruct.mu_T;
end

figure('Position',[100 100 800 600]);  
hold on; grid on; box on;
% curveColors = [
%     0 0 0;   % Parabolic  → black
%     1 0 0;   % Linear     → red
%     0 0 1    % ModeShape  → blue
% ];

% --- Plot each curve
for i = 1:numel(fileList)
    xy = allCurves{i};
    plot(xy(:,1), xy(:,2), 'LineWidth', 3, 'Color', curveColors(i,:), 'DisplayName', patternNames{i});
    hold on;
end
hold off;

xlabel('Roof Drift Ratio','FontSize',14,'FontWeight','bold');
ylabel('Base Shear (kN)','FontSize',14,'FontWeight','bold');
title('Pushover Curves','FontSize',16,'FontWeight','bold');

% Axis limits
allX = cell2mat(cellfun(@(c) c(:,1), allCurves, 'UniformOutput', false));
allY = cell2mat(cellfun(@(c) c(:,2), allCurves, 'UniformOutput', false));
xlim([0 max(allX)*1.05]);
ylim([0 max(allY)*1.05]);

legend('Location','northeast','FontSize',12,'Box','off');
set(gca,'LineWidth',1.5,'FontSize',12);
hold off;

% Save figure
print(gcf, 'PushoverCurves_DifferentLoadPatterns.emf', '-dmeta', '-r300');

fprintf('\nDuctility μ_T:\n');
for i = 1:numel(fileList)
    fprintf('%s : %.2f\n', patternNames{i}, allMuT(i));
end

% ================= LOCAL FUNCTION (must be at end of file) =================
function xyout = cutAtVcapDescending(xy, Vcap)

    % Find the peak base shear
    [~, iPeak] = max(xy(:,2));

    % Locate first point after peak where base shear drops below Vcap
    iCutRel = find(xy(iPeak+1:end, 2) < Vcap, 1, 'first');

    if isempty(iCutRel)
        xyout = xy;
    else
        iCut = iPeak + iCutRel - 1;
        xyout = xy(1:iCut, :);
    end
end
cd ..;
cd ..;

%% COMBINED INTERSTORY DRIFT RATIO (IDR) PLOT

cd Output/(ID2433_R5_5Story_v.02)_(AllVar)_(0.00)_(clough)/EQ_9991/Sa_0.00

fileList    = {'DATA_allDataForThisSingleRun_1.mat', 'DATA_allDataForThisSingleRun_2.mat','DATA_allDataForThisSingleRun_3.mat'};
patternNames = { 'Parabolic', 'Linear', 'Mode Shape' };
curveColors  = [
    0 0 0;   % Parabolic  → black
    1 0 0;   % Linear     → red
    0 0 1    % ModeShape  → blue
];

figure; hold on; grid on;

for i = 1:numel(fileList)
    dataStruct = load(fileList{i});
    storyDriftRatioToSave = dataStruct.storyDriftRatioToSave;
    numStories = numel(storyDriftRatioToSave);

    % build continuous driftVector & storyVector
    driftVectorAll = [];
    storyVectorAll = [];

    for storyNum = 1:numStories
        currentStoryDrift = storyDriftRatioToSave{storyNum}.Max;
        driftVector = [currentStoryDrift, currentStoryDrift];
        storyVector = [storyNum, storyNum+1];
        driftVectorAll = [driftVectorAll, driftVector];
        storyVectorAll = [storyVectorAll, storyVector];

        % horizontal connection at the top of this story
        if storyNum < numStories
            nextDrift = storyDriftRatioToSave{storyNum+1}.Max;
            driftVectorAll = [driftVectorAll, nextDrift];
            storyVectorAll = [storyVectorAll, storyNum+1];
        end
    end
    plot(driftVectorAll, storyVectorAll, 'LineWidth', 3, 'Color', curveColors(i,:), 'DisplayName', patternNames{i});
end

hx = xlabel('Interstory Drift Ratio');
hy = ylabel('Story Number');
htitle = title('PushoverMaxDriftRatio');
ylim([1 numStories+1]);
yticks(1:numStories+1);
box on; hold off;

% Save figure at outputs
cd ..;
cd ..;
print(gcf, 'PushoverMaxDriftRatio_DifferentLoadPatterns.emf', '-dmeta', '-r300')

cd(baseFolder)
%%