% Base directory and file names
folderPath = 'E:\OpenSees_PracticeExamples\ida-spo-msa\HazardAnalysis\gm-selection\2020_NBC_MyCopy_new-main\GMSelection_format\UnscaledAccRecord4673_EQ_Spectra_psb';

% List of base earthquake IDs
eqNumberList = [7001, 7002, 7003, 7004, 7005, 7006, 7007, 7008, 7009, 7010, 7011, 7012, 7013, 7014, 7015, 7016, 7017, 7018, 7019, 7020, 7021, 7022, 7023, 7024, 7025, 7026, 7027, 7028, 7029, 7030];

% Pre-allocate matrix for geometric mean spectra (5% damping)
all_SageoM = [];

figure('Color', 'w');
hold on;

for i = 1:length(eqNumberList)
    eqID = eqNumberList(i);
    
    % Construct file names dynamically
    Comp1 = fullfile(folderPath, sprintf('SaEQSpectrum_EQ_%d1.mat', eqID));
    Comp2 = fullfile(folderPath, sprintf('SaEQSpectrum_EQ_%d2.mat', eqID));
    
    % Load component data
    eqComp1 = load(Comp1);
    eqComp2 = load(Comp2);
    
    % Extract period vector
    periodvector = eqComp1.periodVector(:);
    
    % -------------------------------------------------------------
    % Extract Sa for 5% Damping Ratio (zeta = 0.05)
    % -------------------------------------------------------------
    if isfield(eqComp1, 'dampRatio') || isfield(eqComp1, 'damping')
        % Dynamically find the column index for 0.05 (or 5%) damping
        dampVec = eqComp1.dampRatio; % change field name if stored differently
        dampIdx = find(abs(dampVec - 0.05) < 1e-4 | abs(dampVec - 5) < 1e-4, 1);
        
        Sa_comp1 = eqComp1.SaAbs(:, dampIdx);
        Sa_comp2 = eqComp2.SaAbs(:, dampIdx);
    elseif size(eqComp1.SaAbs, 2) > 1
        % If Sa is a matrix where column 1 (or specific column) corresponds to 5% damping
        dampIdx = 1; % Adjust index to match 5% damping column in your files
        Sa_comp1 = eqComp1.SaAbs(:, dampIdx);
        Sa_comp2 = eqComp2.SaAbs(:, dampIdx);
    else
        % If Sa is already a 1D vector pre-computed for 5% damping
        Sa_comp1 = eqComp1.SaAbs(:);
        Sa_comp2 = eqComp2.SaAbs(:);
    end
    
    % Compute Geometric Mean: SageoM = SQRT(Sa1 * Sa2)
    SageoM = sqrt(Sa_comp1 .* Sa_comp2);
    
    % Store for suite-average calculation
    all_SageoM(:, i) = SageoM;
    
    % Plot individual spectra at 5% damping
    if i == 1
        plot(periodvector, SageoM, 'Color', [0.75 0.75 0.75], 'LineWidth', 0.8, 'DisplayName', 'Individual Records (\zeta = 5%)');
    else
        plot(periodvector, SageoM, 'Color', [0.75 0.75 0.75], 'LineWidth', 0.8, 'HandleVisibility', 'off');
    end
end

% Compute and plot ensemble median/mean spectrum
mean_SageoM = mean(all_SageoM, 2);
plot(periodvector, mean_SageoM, 'r-', 'LineWidth', 2.5, 'DisplayName', 'Mean S_{a,geoM} (\zeta = 5%)');

% Plot formatting
xlabel('Period $T$ (s)', 'Interpreter', 'latex', 'FontSize', 14);
ylabel('$S_{a,\mathrm{geoM}}$ (g)', 'Interpreter', 'latex', 'FontSize', 14);
title('Geometric Mean Response Spectra Suite (\zeta = 5%)', 'FontSize', 14);
grid on;
set(gca, 'XScale', 'log', 'YScale', 'log');
xlim([0.04 10])
% set(gca, 'XScale', 'log');
legend('Location', 'northeast');