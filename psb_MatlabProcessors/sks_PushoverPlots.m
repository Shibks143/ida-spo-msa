
function sks_PushoverPlots(analysisType_forPO, runDifferentPushoverPatterns, patternNames)  % function file

%%========================================================================================================================
%%==============================PUSHOVER PLOTS ===========================================================================
% written on (11-12-2025)
% written by Shivakumar K S, IIT-Madras
% Run this code after running psb_MasterDriver_ProcPushoverAnalyses.m
%%========================================================================================================================

% % % sample inputs
% fileName = 'ID2433_R5_5Story_v.02'; 
% analysisType_forPO = sprintf('(%s)_(AllVar)_(0.00)_(clough)', fileName);
% runDifferentPushoverPatterns = [
%                                   0.4401491  0.3248811  0.3024556
%                                   0.2886080  0.2630745  0.2696329
%                                   0.1689272  0.2012678  0.2124970
%                                   0.0811068  0.1394612  0.1456358
%                                   0.0212089  0.0713154  0.0697788
%                                 ]; 
% patternNames = {'Parabolic','Linear','Mode Shape'};


%% COMBINED PUSHOVER LOAD PATTERNS 
baseFolder = pwd;

cd Output
cd (analysisType_forPO)

curveColors  = [0 0 0; 1 0 0; 0 0 1];
[numR, numPO_cases] = size(runDifferentPushoverPatterns);
numStories   = numR;                
floors       = (2:numStories+1)';    

% Collect one column per SPO_index (one curve per pattern)
pushoverPattern = zeros(numStories, numPO_cases);   
for SPO_index = 1:numPO_cases
    datafileName = sprintf('DATA_pushover_%d.mat', SPO_index);
    dataStruct = load(datafileName);
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
for SPO_index = 1:numPO_cases
    plot(pushoverPattern(:,SPO_index), floors, '-o', 'LineWidth', 3, 'MarkerSize', 6, 'Color', curveColors(SPO_index,:), 'DisplayName',patternNames{SPO_index});
end
xlabel('PushoverForce','FontSize',14,'FontWeight','bold');
ylabel('Floor Level','FontSize',14,'FontWeight','bold');
title('PushoverForce vs Floor Number','FontSize',16,'FontWeight','bold');
legh = legend('Location','southeast','FontSize',12,'Box','off');
ylim([min(floors) max(floors)]);
yticks(floors);         
set(gca,'LineWidth',1.5,'FontSize',12); box on; hold off;
print(gcf,'PushoverPatterns_vs_FloorNumber_runDifferentPushoverPatterns.emf','-dmeta','-r300');


%% COMBINED PUSHOVER PLOT 

Vcap = 1200;   % base shear cap

% Load, cut & store all curves
allCurves = cell(numPO_cases, 1);
allMuT    = zeros(numPO_cases, 1);

for ii = 1:numPO_cases
    datafileName = sprintf('DATA_pushover_%d.mat', ii);
    dataStruct = load(datafileName);
    xy = dataStruct.plotArrayAndBaseShearArray;
    xyCut = cutAtVcapDescending(xy, Vcap);
    allCurves{ii} = xyCut;
    allMuT(ii)    = dataStruct.mu_T;
end

figure('Position',[100 100 800 600]);  
hold on; grid on; box on;


% --- Plot each curve
for ii = 1:numPO_cases
    xy = allCurves{ii};
    plot(xy(:,1), xy(:,2), 'LineWidth', 3, 'Color', curveColors(ii,:), 'DisplayName', patternNames{ii});
    hold on;
end
hold off;

hx = xlabel('Roof Drift Ratio','FontSize',14,'FontWeight','bold');
hy = ylabel('Base Shear (kN)','FontSize',14,'FontWeight','bold');
htitle = title('Pushover Curves','FontSize',16,'FontWeight','bold');

% Axis limits
allX = cell2mat(cellfun(@(c) c(:,1), allCurves, 'UniformOutput', false));
allY = cell2mat(cellfun(@(c) c(:,2), allCurves, 'UniformOutput', false));
xlim([0 max(allX)*1.05]);
ylim([0 max(allY)*1.05]);

legend('Location','southeast','FontSize',12,'Box','off');
set(gca,'LineWidth',1.5,'FontSize',12);
hold off;

% Save figure
print(gcf, 'PushoverCurves_DifferentLoadPatterns.emf', '-dmeta', '-r300');

fprintf('\nDuctility μ_T:\n');
for ii = 1:numPO_cases
    fprintf('%s : %.2f\n', patternNames{ii}, allMuT(ii));
end

% ================= LOCAL FUNCTION (must be at end of file) =================
function xyout = cutAtVcapDescending(xy, Vcap)

    % Find the peak base shear
    [~, iiPeak] = max(xy(:,2));

    % Locate first point after peak where base shear drops below Vcap
    iiCutRel = find(xy(iiPeak+1:end, 2) < Vcap, 1, 'first');

    if isempty(iiCutRel)
        xyout = xy;
    else
        iiCut = iiPeak + iiCutRel - 1;
        xyout = xy(1:iiCut, :);
    end
end
cd ..;
cd ..;

% %% COMBINED INTERSTORY DRIFT RATIO (IDR) PLOT
% cd Output
% 
% cd (analysisType_forPO)
% cd EQ_9991
% cd Sa_0.00
% 
% 
% figure; hold on; grid on;
% 
% for ii = 1:numPO_cases
%     dataFileName = sprintf('DATA_allDataForThisSingleRun_%d.mat', ii);
%     dataStruct = load(dataFileName);
%     storyDriftRatio = dataStruct.storyDriftRatioToSave;
% 
%     % build continuous driftVector & storyVector
%     driftVectorAll = [];
%     storyVectorAll = [];
% 
%     for storyNum = 1:numStories
%         currentStoryDrift = storyDriftRatio{storyNum}.Max;
%         driftVector = [currentStoryDrift, currentStoryDrift];
%         storyVector = [storyNum, storyNum+1];
%         driftVectorAll = [driftVectorAll, driftVector];
%         storyVectorAll = [storyVectorAll, storyVector];
% 
%         % horizontal connection at the top of this story
%         if storyNum < numStories
%             nextDrift = storyDriftRatio{storyNum+1}.Max;
%             driftVectorAll = [driftVectorAll, nextDrift];
%             storyVectorAll = [storyVectorAll, storyNum+1];
%         end
%     end
%     plot(driftVectorAll, storyVectorAll, 'LineWidth', 3, 'Color', curveColors(ii,:), 'DisplayName', patternNames{ii});
% end
% 
% hx = xlabel('Interstory Drift Ratio');
% hy = ylabel('Story Number');
% htitle = title('PushoverMaxDriftRatio');
% legend('Location','southeast','FontSize',12,'Box','off');
% ylim([1 numStories+1]);
% yticks(1:numStories+1);
% box on; hold off;
% 
% % Save figure at outputs
% cd ..;
% cd ..;
% print(gcf, 'PushoverMaxDriftRatio_DifferentLoadPatterns.emf', '-dmeta', '-r300')
% 
% cd(baseFolder)
% end


%% ===================== COMBINED INTERSTORY DRIFT RATIO (IDR) =====================


clc; close all;

baseFolder   = pwd;
driftData    = fullfile(baseFolder, 'Output', analysisType_forPO, 'EQ_9991', 'Sa_0.00');

% -----------------------------------------------------------
% USER-DEFINED DRIFT CAP
% -----------------------------------------------------------
driftCapLimit = 0.15;   % Cap drift (15% in this example)

figure; hold on; grid on;

% -----------------------------------------------------------
% LOOP OVER ALL PATTERNS
% -----------------------------------------------------------
for ii = 1:numPO_cases
    % Load drift data
    driftFile = fullfile(driftData, sprintf('DATA_allDataForThisSingleRun_%d.mat', ii));
    driftStruct = load(driftFile);
    storyDriftRatio = driftStruct.storyDriftRatioToSave;
    lastStep = length(storyDriftRatio{1}.Max);

    % Build drift profile
    driftVectorAll = [];
    storyVectorAll = [];

    for storyNum = 1:numStories
        driftRatio = storyDriftRatio{storyNum}.Max(lastStep);
        drift = min(driftRatio, driftCapLimit);  % Apply drift cap

        % Vertical segment
        driftVectorAll = [driftVectorAll, drift, drift];
        storyVectorAll = [storyVectorAll, storyNum, storyNum+1];

        % Horizontal connector
        if storyNum < numStories
            driftNextRaw = storyDriftRatio{storyNum+1}.Max(lastStep);
            driftNext = min(driftNextRaw, driftCapLimit);

            driftVectorAll = [driftVectorAll, driftNext];
            storyVectorAll = [storyVectorAll, storyNum+1];
        end
    end

    % Plot
    plot(driftVectorAll, storyVectorAll, 'LineWidth', 3, 'Color', curveColors(ii,:), 'DisplayName', patternNames{ii});
end

% -----------------------------------------------------------
% Finish plot
% -----------------------------------------------------------
hx = xlabel('Interstory Drift Ratio','FontSize',14,'FontWeight','bold');
hy = ylabel('Story Level','FontSize',14,'FontWeight','bold');
title('Interstory Drift Profiles','FontSize',16,'FontWeight','bold');

xlim([0 driftCapLimit + 0.1]);
ylim([1 numStories+1]);
yticks(1:numStories+1);

set(gca,'LineWidth',1.5,'FontSize',12); box off; 
legend('Location','southeast','FontSize',11,'Box','off');
cd('Output\(ID2433_R5_5Story_v.02)_(AllVar)_(0.00)_(clough)')
print(gcf,'PushoverMaxDriftRatio_vs_FloorNumber_runDifferentPushoverPatterns.emf','-dmeta','-r300'); hold off;


cd(baseFolder);

end




