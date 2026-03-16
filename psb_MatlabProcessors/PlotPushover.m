%
% Procedure: PlotPushover.m
% -------------------
% This plots the pushover curve - nodal displacement vs. base shear.  The base shear is computed in the "ProcessSingleRun" file and is the sum of the global shears in the
%   columns that are input as base columns in the "SetAnalysisOptions" file. THe node use is the poControlNode defined in the "SetAnalysisOptions" file.
% 
% COMMENT: This should work for you, but I am sorry that it is not clean
%   and commented; I did not have time to clean it up.  If you have any
%   questions, please let me know (Curt Haselton, haselton@stanford.edu)
%
% Assumptions and Notices: 
%           - none
%
% Author: Curt Haselton 
% Modified by: Prakash S Badal
% Date- 03-21-2016
% 
% Sources of Code: none
%
% Functions and Procedures called: none
%
% Units: Whatever OpenSees is using - kN, mm, radians
%
% -------------------
function [plotArrayAndBaseShearArray, mu_T] = PlotPushover(analysisType, eqNumber, saTOneForRun, plotRoofDriftRatio, ...
    maxNumPoints, markerType, lineWidth, determinePeriodBasedDuctility, SPO_index)

% on many occasions, I call this function with single expected output. Doing so will return only plotArrayAndBaseShearArraym, which is acceptable behavior. 
global figureh

% Define both of the following values to be consistent with the pushover
%   naming convention and to open the correct folders.
titleFontSize = 18;
textFontSize = 14;
axisLabelFontSize = 16;
markerTypeForVmax = 'r-.';
markerTypeForMeasure = 'k-.';
%  analysisType='(Archetype1Story_2061_modForSF)_(AllVar)_(Mean)_(clough)';

% Define node dof as 1 (lateral)
dofNum = 1;

% First change the directory to get into the correct folder for processing
cd ..;
cd Output;
cd(analysisType);

% Create Sa and EQ folder names for later use

saFolder = sprintf('Sa_%.2f', saTOneForRun);
eqFolder = sprintf('EQ_%.0f', eqNumber);

% Open the .mat file that holds all of the data that we need, go into folder to get it
cd(eqFolder);
cd(saFolder);

if SPO_index == -999
    fileName = ['DATA_allDataForThisSingleRun.mat'];
else
    fileName = sprintf('DATA_allDataForThisSingleRun_%i.mat', SPO_index);
end


load(fileName);


%load('DATA_reducedSensDataForThisSingleRun.mat');

% Do plot
    nodeDisplArray = nodeArray{poControlNodeNum}.displTH(:, dofNum);
    baseShearArray = -baseShear.TH;

% (12-01-16, PSB) added the following two commands to adjust for the
% pushover curve starting from a non-origin points. This causes the initial
% slope to look different from the actual value and gives a feeling that
% structure has yielded much earlier, in some cases even ealier than the
% factored design base shear value.
ix = find(nodeDisplArray >= 0, 1);
if ix == 1
    offsetOfBaseShear = 0;
else
    offsetOfBaseShear = interp1([nodeDisplArray(ix-1), nodeDisplArray(ix)], ...
                    [baseShearArray(ix-1), baseShearArray(ix)], 0, 'pchip');                
end
                
%     offsetOfBaseShear = interp1(nodeDisplArray, baseShearArray, 0); 
    baseShearArray = baseShearArray - offsetOfBaseShear; 
    
    % Adjust for there not being the same number of data points in each column and for the numDataPoint inputted possible being higher than the actual number.
    length1 = length(nodeDisplArray);
    length2 = length(baseShearArray);
    minLength = min(length1, length2);
  
    if(minLength < maxNumPoints)
        %Just use total number of entries for each data column
        numDataPointsUsed = minLength;
    else
        %Use the maxNumPoints provide by the caller
        numDataPointsUsed = maxNumPoints;
    end
    
    % Plot - note that the psuedoTimeVector is from the file that was opened 
    buildingHeight = max(floorHeightsLIST);
    if(plotRoofDriftRatio == 1)
        plotArray = nodeDisplArray / buildingHeight;
    else
        plotArray = nodeDisplArray;
    end
    %figureh = plot(plotArray(1:numDataPointsUsed), baseShearArray(1:numDataPointsUsed), markerType);
    
    %normBaseShear = baseShearArray(1:numDataPointsUsed) / 281.0;
    %figureh = plot(plotArray(1:numDataPointsUsed), normBaseShear, markerType, 'LineWidth', lineWidth);
    figureh = plot(plotArray(1:numDataPointsUsed), baseShearArray(1:numDataPointsUsed), markerType, 'LineWidth', lineWidth);
    
    plotArrayAndBaseShearArray = [plotArray, baseShearArray]
    
    hold on
    grid on
    
    % (11-20-15, PSB) writing the base shear and displacement or drift array to a file (optional)
%     tempFolder = pwd;
%     cd 'C:\Users\Prakash\Desktop' % hard-coded as of now
%     filename = sprintf('%s_BaseShearArray.xlsx',analysisType);
%     firstRow = [{'Drift/Displacement'}, {'Base Shear'}];
%     xlswrite(filename, firstRow);
%     xlswrite(filename, plotArrayAndBaseShearArray);
%     % back to the original folder
%     cd(tempFolder)

    % Change the x-axes to be good
        % Find what maximum drift to use for the x-axis scale (just rounding)
        maxX = max(plotArray(1:numDataPointsUsed)) + 0.01;
        remainder = mod(maxX, 0.01);
        maxX = maxX - remainder;
        % Max shear - rounding to 100
        maxY = max(baseShearArray(1:numDataPointsUsed)) + 50.0;
        remainder = mod(maxY, 50.0);
        maxY = maxY - remainder;
        % Max the axes go from zero to the maximums
        axis([0 maxX 0 maxY])          
        
    %axes(haxes);
    %axes('FontSize', axisNumberFontSize)
    %titleText = sprintf('Pushover Curve for Analysis Model %s, for PO %d', analysisType, eqNumber);
    %title(titleText);
    %set(htitle, 'FontSize', titleFontSize);
    
    yLabel = sprintf('Base Shear (kN)');
    hy = ylabel(yLabel);
    set(hy, 'FontSize', axisLabelFontSize);
    if(plotRoofDriftRatio == 1)
        xLabel = sprintf('Roof Drift Ratio');
    else
        xLabel = sprintf('Roof Displacement (mm)');
    end
    hx = xlabel(xLabel);
    set(hx, 'FontSize', axisLabelFontSize);
    
    %legh = legend('Hello');
    %set(legh, 'FontSize', legendFontSize);
    
    % Save axis sizes and then format
    haxes = gca;
    axesInfo = get(haxes);
    % FigureFormatScript
    
    % Go back to the size the plot was before formatting
    xlim([axesInfo.XLim(1), axesInfo.XLim(2)]);
    ylim([axesInfo.YLim(1), axesInfo.YLim(2)]);    
    
mu_T = 0.0; % initialize period-based ductility (2-21-19)

  %% (10-2-15) finding mu_T as per FEMA-P695 - PSB
if(determinePeriodBasedDuctility == 1)
    if(plotRoofDriftRatio == 0)
        BS = baseShearArray(1:numDataPointsUsed);
        defoVec = nodeDisplArray(1:numDataPointsUsed);

        [V_max, index] = max(BS);
        BS_max = V_max * ones(length(defoVec),1);

        % plotting the pushover curve
        plot(defoVec, BS, markerType, 'LineWidth',2.0); 
        yLimForPlot = (round((V_max * 1.2) / 10) + 1) * 10;
        axis([0 max(defoVec)+5 0 yLimForPlot]); grid on; hold on;
          xLabel = 'Roof displacement (mm)';  
          yLabel = 'Base Shear (kN)'; 
          htitle =  title('Pushover Curve'); set(htitle, 'FontSize', titleFontSize);
          hy = ylabel(yLabel); set(hy, 'FontSize', axisLabelFontSize);
          hx = xlabel(xLabel); set(hx, 'FontSize', axisLabelFontSize);
    


        % drawing the line at base sear = V_max and at 80% of V_max
        plot(defoVec, BS_max, markerTypeForVmax, 'LineWidth',2.0); 
        plot(defoVec, 0.8*BS_max, markerTypeForVmax, 'LineWidth',2.0);
        str = sprintf('V_{max} = %.2f ',V_max);
        text(0 + 1, V_max + 15, str, 'FontSize', textFontSize, 'rotation', 0, 'FontWeight', 'bold');
        
        str0 = sprintf('0.8 V_{max} = %.2f ',0.8*V_max);
        text(defoVec(index)*0.90, 0.8 * V_max + 25, str0, 'FontSize', textFontSize, 'rotation', 0, 'FontWeight', 'bold');

        V_temp = 0.1*V_max;
%         BSTemp = BS(1:find(BS == V_max));
%         dispTempVec = defoVec(1:find(BS == V_max));
        BSTemp = BS(1:find(BS >= V_max*0.95, 1));
        dispTempVec = defoVec(1:find(BS >= V_max*0.95, 1));
        
        disp_temp = interp1(BSTemp, dispTempVec, V_temp, 'linear');
        delta_y_eff = disp_temp * V_max / V_temp;
%         delta_y_eff = 151.453; % for 2207v03 this value is calculated using eq 6.8 of FEMA P695
        

        plot([0 delta_y_eff], [0 V_max], markerTypeForMeasure, 'LineWidth',1.5);
        plot([delta_y_eff delta_y_eff], [0 V_max], markerTypeForMeasure, 'LineWidth',1.5);
        str1 = sprintf('\\delta_{y, eff} = %.2f ',delta_y_eff);
        text(delta_y_eff + 0.4, V_max/12, str1, 'FontSize', textFontSize, 'rotation', 0, 'FontWeight', 'bold');
        
%         delta_u = interp1(BS(index:length(BS)),defoVec(index:length(BS)),0.8*V_max);
        % (1-9-19, PSB) changed range from (index + ix - 1, index + ix) to (index + ix - 2, index + ix - 1)
        ix = find(BS(index:end) <= 0.8*V_max, 1);
        delta_u = interp1([BS(index + ix - 2), BS(index + ix - 1)], ...
                    [defoVec(index + ix - 2), defoVec(index + ix - 1)], 0.8*V_max, 'pchip');
        plot([delta_u delta_u],[0 0.8*V_max], markerTypeForMeasure,'LineWidth',1.5);
        str2 = sprintf('\\delta_u = %.2f', delta_u);
        text(delta_u + 0.4, V_max/12, str2, 'FontSize', textFontSize, 'rotation', 0, 'FontWeight', 'bold');
    else
        BS = baseShearArray(1:numDataPointsUsed);
        
        % setting the value of deformation as drift. This is to avoid
        % changing all the defoVec parameters for the else part of the code 
        defoVec = nodeDisplArray(1:numDataPointsUsed)  / buildingHeight;

        [V_max, index] = max(BS);
        BS_max = V_max*ones(length(defoVec),1);

        % plotting the pushover curve
        plot(defoVec, BS, markerType, 'LineWidth',2.0); 
        yLimForPlot = (round((V_max * 1.2) / 10) + 1) * 10;
        axis([0 max(defoVec)*1.10 0 yLimForPlot]); grid on; hold on;
        
        xLabel = 'Roof Drift Ratio';  
        yLabel = 'Base Shear (kN)'; 
        htitle =  title('Pushover Curve'); set(htitle, 'FontSize', titleFontSize);
        hy = ylabel(yLabel); set(hy, 'FontSize', axisLabelFontSize);
        hx = xlabel(xLabel); set(hx, 'FontSize', axisLabelFontSize);
        
        % drawing the line at base sear = V_max and at 80% of V_max
        plot(defoVec, BS_max, markerTypeForVmax, 'LineWidth',2.0); 
        plot(defoVec, 0.8 * BS_max, markerTypeForVmax, 'LineWidth',2.0);
        
        str = sprintf('V_{max} = %.2f ',V_max);
        text(0.0001, V_max * 1.05, str, 'FontSize', textFontSize, 'rotation', 0, 'FontWeight', 'bold');
        
        str0 = sprintf('0.8*V_{max} = %.2f ',0.8*V_max);
        text(defoVec(index)*0.80, 0.8 * V_max + 25, str0, 'FontSize', textFontSize, 'rotation', 0, 'FontWeight', 'bold');

        V_temp = 0.1*V_max;
%         BSTemp = BS(1:find(BS == V_max));
%         dispTempVec = defoVec(1:find(BS == V_max));
        BSTemp = BS(1:find(BS >= V_max*0.95, 1));
        dispTempVec = defoVec(1:find(BS >= V_max*0.95, 1));
        
        disp_temp = interp1(BSTemp, dispTempVec, V_temp, 'linear');
        
        delta_y_eff = disp_temp * V_max / V_temp;
        plot([0 delta_y_eff],[0 V_max], markerTypeForMeasure,'LineWidth',1.5);
        plot([delta_y_eff delta_y_eff],[0 V_max], markerTypeForMeasure,'LineWidth',1.5);
        str1 = sprintf('\\delta_{y, eff} = %.4f ',delta_y_eff);
        text(delta_y_eff+0.0001, V_max/12, str1, 'FontSize', textFontSize, 'rotation', 0, 'FontWeight', 'bold');

        try 
%         delta_u = interp1(BS(index:length(BS)),defoVec(index:length(BS)),0.8*V_max);
%         ix = find(BS(index:end) >= 0.8*V_max, 1);
        % (1-9-19, PSB) changed range from (index + ix - 1, index + ix) to (index + ix - 2, index + ix - 1)
        ix = find(BS(index:end) <= 0.8*V_max, 1);
        delta_u = interp1([BS(index + ix - 2), BS(index + ix - 1)], ...
                    [defoVec(index + ix - 2), defoVec(index + ix - 1)], 0.8*V_max, 'pchip'); 
        
        plot([delta_u delta_u],[0 0.8*V_max],  markerTypeForMeasure, 'LineWidth',1.5);
        str2 = sprintf('\\delta_u = %.4f', delta_u);
        text(delta_u-0.005,V_max/12, str2, 'FontSize', textFontSize, 'rotation', 0, 'FontWeight', 'bold');
%         text(delta_u+0.0001,V_max/30,str2, 'FontSize', textFontSize, 'rotation', 0, 'FontWeight', 'bold');
        % setting the value of displacement back to the original
        catch 
            fprintf('!!!!!!!!!!!!!!!!!!!!!!!!!!!!\n');
            fprintf('delta_u could not be located\n');
            fprintf('!!!!!!!!!!!!!!!!!!!!!!!!!!!!\n');
        end
        
        defoVec = defoVec * buildingHeight;
    end
        try 
            mu_T = delta_u/delta_y_eff;
            fprintf('Ductility ratio, mu_T is %.3f\n', mu_T);
        catch 
        end
end




        %%%%%%%%%%% end of added code %%%%%%%%%%%
    
    %% Save the plot
        % Go back to the output folder
        cd ..;
        cd ..;
%         xlim([ 0 1100]);
	
            psb_FigureFormatScript_forReport

        % Save the plot
        modifiedAnaType = strrep(analysisType, '.', '_'); % having a dot in the name itself makes matlab 
                               % treat the remianing as extension and commands below don't work 
                               % unless you type the extensions explicitly.
        exportName = sprintf('Pushover_Num_%d_%s', eqNumber, modifiedAnaType);
        hgsave(exportName); % .fig file for Matlab
        print('-dmeta', exportName); % .emf file for Windows (MSWORD)
        print('-depsc', exportName); % .eps file for Linux (LaTeX)

%         print('-dpng', exportName); % .png file for small sized files

        display(fullfile(pwd, 'exportName'))
        
        

    hold off

% Get back to the MatlabProcessors folder where we started
cd ..;
cd ..;
cd psb_MatlabProcessors;
