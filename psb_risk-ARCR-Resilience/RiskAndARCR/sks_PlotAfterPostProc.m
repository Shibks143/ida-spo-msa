function sks_PlotAfterPostProc(PHRInputs)

tic
bldgIDLIST1 =        PHRInputs.BldgIdLIST;
eqNumberLIST1 =      PHRInputs.eqNumberLIST;
LimitStateValLIST =  PHRInputs.LimitStateValLIST;
baseFolder =         PHRInputs.baseFolder;
formatMode =         PHRInputs.formatMode; 

% bldgIndexToRun = 1:2:12;
% bldgIDLIST = bldgIDLIST1(1, bldgIndexToRun);
% eqNumberLIST = eqNumberLIST1(bldgIndexToRun, :);

bldgIDLIST = bldgIDLIST1(1,:);
eqNumberLIST = eqNumberLIST1(1, :);

% LimitStateValLIST = [0.75, 0.60, 0.50, 0.40]; % for DS2, limit over chi, the ratio of max rotation to ultimate rotation capacity


%% PLOT IDAs
for k = 1:size(LimitStateValLIST, 2)
    LimitStateVal = LimitStateValLIST(1, k);
    for i = 1:size(bldgIDLIST, 2)
        clc; fprintf('Processing chi- %i/%i, building- %i/%i...\n', k, size(LimitStateValLIST, 2), i, size(bldgIDLIST, 2));
        bldgID_curr = bldgIDLIST{1, i}; % current building ID


        [~, analysisTypeFolder, ~, ~] = returnModelFolderInfo(bldgID_curr);
        cd(analysisTypeFolder);

        eqNumberLIST_curr = eqNumberLIST(i, :); % EQ list for current building ID
        for j = 1:size(eqNumberLIST_curr, 2)
            eqNumber = eqNumberLIST_curr(1, j);
            eqFolder = sprintf('EQ_%d', eqNumber);
            % chi_LimitState = chi_LimitStateLIST(1, j);
            % extract EQ-specific IDA and plot it

            fullEqPath = fullfile(analysisTypeFolder, eqFolder);
            cd(fullEqPath);

            % cd(eqFolder);
            %             thisEqDataFileName = sprintf('DATA_criticalColDamRat_%ip%i_IDA_ForThisEQ.mat', floor(LimitStateVal), int8(LimitStateVal*100));
            thisEqDataFileName = 'DATA_criticalColDamRat_IDA_ForThisEQ.mat';

            % thisEqDataFileName = sprintf('DATA_criticalColDamRat_%s_IDA_ForThisEQ.mat', strrep(num2str(round(LimitStateVal, 2), '%.2f'), '.', 'p'));
            load(thisEqDataFileName, 'chiMax', 'saT1LIST', 'criticalColID', 'xiMax', 'criticalColID_xi');
            cd ..
            %% 1. using theta_U as normalizing parameter
            % 1.1 calculate ALL components
            % interpolate the obtained IDA for this TH, i.e., chiMax vs. saT1LIST at chi_DS2 = 0.75
            % A simple interpolation may not work, since IDAs are non-monotonous at times
            ix = find(chiMax  > LimitStateVal, 1);
            if isempty(ix)
                saT1_ds2_ALL(j) = saT1LIST(end);
            else
                saT1_ds2_ALL(j) = interp1([chiMax(ix-1), chiMax(ix)], ...
                    [saT1LIST(ix-1), saT1LIST(ix)], LimitStateVal, 'pchip');
            end

            % 1.2 plot ALL component IDAs
            figure(101);
            plot([0, chiMax], [0, saT1LIST], 'b-o', 'LineWidth', 1); hold on; grid on;

            % 1.3 for odd time history TH, store chiMax and saT1LIST, in case it is controlling
            if mod(j, 2) == 1
                chiMax_CompOne = chiMax;
                saT1LIST_CompOne = saT1LIST;
                % chiMax_CompTwo and saT1LIST_CompTwo need not be assigned since
                % chiMax and saT1LIST from current eqIndex are available in next conditional statement
            end

            % 1.4 determine the controlling component and plot it
            if mod(j, 2) == 0 % for every second TH, find controlling component
                gmIndex = j/2;
                saT1_ds2_CompOne = saT1_ds2_ALL(j - 1);
                saT1_ds2_CompTwo = saT1_ds2_ALL(j);
                saT1_ds2_CTRL(gmIndex) = min(saT1_ds2_CompOne, saT1_ds2_CompTwo);

                % plot CTRL component IDA
                figure(201);
                if saT1_ds2_CompOne < saT1_ds2_CompTwo
                    plot([0, chiMax_CompOne], [0, saT1LIST_CompOne], 'b-o', 'LineWidth', 1); hold on; grid on;
                else
                    plot([0, chiMax], [0, saT1LIST], 'b-o', 'LineWidth', 1); hold on; grid on;
                end
            end
            %% 2. using theta_cap as normalizing parameter
            % 2.1 calculate ALL components
            % interpolate the obtained IDA for this TH, i.e., xiMax vs. saT1LIST at xi_DS2 = 0.75
            % A simple interpolation may not work, since IDAs are non-monotonous at times
            ix_xi = find(xiMax > LimitStateVal, 1); %added on 20-Apr-2026

            if isempty(ix_xi)
                saT1_ds2_ALL_xi(j) = saT1LIST(end);

            elseif ix_xi == 1
                saT1_ds2_ALL_xi(j) = saT1LIST(1);

            else
                saT1_ds2_ALL_xi(j) = interp1( ...
                    [xiMax(ix_xi-1), xiMax(ix_xi)], ...
                    [saT1LIST(ix_xi-1), saT1LIST(ix_xi)], ...
                    LimitStateVal, 'pchip');
            end


            % ix_xi = find(xiMax  > LimitStateVal, 1);
            % if isempty(ix_xi)
            %     saT1_ds2_ALL_xi(eqIndex) = saT1LIST(end);
            % else
            %     saT1_ds2_ALL_xi(eqIndex) = interp1([xiMax(ix_xi-1), xiMax(ix)], ...
            %         [saT1LIST(ix_xi-1), saT1LIST(ix_xi)], LimitStateVal, 'pchip');
            % end

            % 2.2 plot ALL component IDAs
            figure(301);
            plot([0, xiMax], [0, saT1LIST], 'b-o', 'LineWidth', 1); hold on; grid on;

            % 2.3 for odd time history TH, store chiMax and saT1LIST, in case it is controlling
            if mod(j, 2) == 1
                xiMax_CompOne = xiMax;
                saT1LIST_CompOne_xi = saT1LIST;
                % chiMax_CompTwo and saT1LIST_CompTwo need not be assigned since
                % chiMax and saT1LIST from current eqIndex are available in next conditional statement
            end

            % 2.4 determine the controlling component and plot it
            if mod(j, 2) == 0 % for every second TH, find controlling component
                gmIndex = j/2;
                saT1_ds2_CompOne_xi = saT1_ds2_ALL_xi(j - 1);
                saT1_ds2_CompTwo_xi = saT1_ds2_ALL_xi(j);
                saT1_ds2_CTRL_xi(gmIndex) = min(saT1_ds2_CompOne_xi, saT1_ds2_CompTwo_xi);

                % plot CTRL component IDA
                figure(401);
                if saT1_ds2_CompOne_xi < saT1_ds2_CompTwo_xi
                    plot([0, xiMax_CompOne], [0, saT1LIST_CompOne_xi], 'b-o', 'LineWidth', 1); hold on; grid on;
                else
                    plot([0, xiMax], [0, saT1LIST], 'b-o', 'LineWidth', 1); hold on; grid on;
                end
            end

        end

        % 1.5 save ALL and CTRL component IDAs in analysis directory (chi, normalized by thetaU)
        figure(101);
        xlabel('$\chi = \theta_m / \theta_u$')
        ylabel('$S_a(T_a)$')
        xlim([0 1]);
        sks_figureFormat(formatMode)
        %         exportName = sprintf('criticalColDamage_chi_%ip%i_IDA_ALLComp', floor(LimitStateVal), int8(LimitStateVal*100));
        exportName = sprintf('criticalColDamage_chi_%s_IDA_ALLComp', strrep(num2str(round(LimitStateVal, 2), '%.2f'), '.', 'p'));
        sks_figureExport(exportName);

        figure(201);
        xlabel('$\chi= \theta_m/ \theta_u$'); 
        ylabel('$S_a(T_a)$');
        xlim([0 1]);
        sks_figureFormat(formatMode)
        %         exportName = sprintf('criticalColDamage_chi_%ip%i_IDA_CTRLComp', floor(LimitStateVal), int8(LimitStateVal*100));
        exportName = sprintf('criticalColDamage_chi_%s_IDA_CTRLComp', strrep(num2str(round(LimitStateVal, 2), '%.2f'), '.', 'p'));
        sks_figureExport(exportName);

        % 2.5 save ALL and CTRL component IDAs in analysis directory (chi, normalized by thetaCap)
        figure(301);
        xlabel('$\xi= \theta_m/ \theta_{cap}$'); 
        ylabel('$S_a(T_a)$');
        xlim([0 1]);
        sks_figureFormat(formatMode)
        %         exportName = sprintf('criticalColDamage_xi_%ip%i_IDA_ALLComp', floor(LimitStateVal), int8(LimitStateVal*100));
        exportName = sprintf('criticalColDamage_xi_%s_IDA_ALLComp', strrep(num2str(round(LimitStateVal, 2), '%.2f'), '.', 'p'));
        sks_figureExport(exportName);

        figure(401);
        xlabel('$\xi= \theta_m/ \theta_{cap}$'); 
        ylabel('$S_a(T_a)$');
        xlim([0 1]);
        sks_figureFormat(formatMode)
        %         exportName = sprintf('criticalColDamage_xi_%ip%i_IDA_CTRLComp', floor(LimitStateVal), int8(LimitStateVal*100));
        exportName = sprintf('criticalColDamage_xi_%s_IDA_CTRLComp', strrep(num2str(round(LimitStateVal, 2), '%.2f'), '.', 'p'));
        sks_figureExport(exportName);
        close all;
    end
end


%% Histogram for failure mechanism
for i = 1:size(bldgIDLIST, 2)
    [~, analysisTypeFolder, ~, ~] = returnModelFolderInfo(bldgIDLIST{i});
    cd(analysisTypeFolder)
    for j = 1:size(eqNumberLIST, 2)
        eqNumber = eqNumberLIST(i, j);
        eqFolder = sprintf('EQ_%d', eqNumber);
        cd(eqFolder);
        %         load('DATA_collapseIDAPlotDataForThisEQ.mat', 'saLevelsForIDAPlotLIST');
        %         if saLevelsForIDAPlotLIST(end) == 100
        %             saMax(i, j) = saLevelsForIDAPlotLIST(end-1);
        %         else
        %             saMax(i, j) = saLevelsForIDAPlotLIST(end);
        %         end

        load('DATA_criticalColDamage_IDA_ForThisEQ.mat', 'criticalColID', 'chiMax');
        criticalColIDLIST(i, j) = criticalColID(end);
        %% histogram
        chiMaxLIST(i, j) = max(chiMax);
        cd ..
    end
end
%% Histogram — controlling column (failure mechanism) % added on 20-Apr-2026
figure
subplot(1,2,1)
histogram(criticalColIDLIST(:),'BinMethod','integers')
xlabel('Critical Column ID')
ylabel('Frequency')
title('Failure Mechanism')
grid on

subplot(1,2,2)
histogram(chiMaxLIST(:),10)
xlabel('\chi_{max}')
ylabel('Frequency')
title('Max Damage Distribution')
grid on
%  end of addition on 20-Apr-2026
%%
cd(baseFolder)
toc;










