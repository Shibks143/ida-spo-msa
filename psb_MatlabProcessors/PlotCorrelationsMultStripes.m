%
% Procedure: PlotCorrelationsMultStripes.m
% -------------------
% This procedure plots correlations for a range of Sa levels.  Right now it just plots some random plots, but later I can make it more coherant.  When this plots
%   over multiple Sa levels, it uses all of the Sa levels that were used in the ComputeCorrForMultStripes.m file.
% 
% Assumptions and Notices: 
%           - You must have executed the corrleation processor for each stripe before using this, and then executed the ComputeCorrForMultStripes.m to make the 
%               3D correaltion matrix.
%
% Author: Curt Haselton 
% Date Written: 11-9-04
%
% Sources of Code: none
%
% Functions and Procedures called: none
%
% Variable definitions (all variables are defined at each stripe level, so they will be different for different Sa values): 
%           - analysisType - this is just the name of the analysis (for Stanford book-keeping)
%
%
%
%
%
%
%
%
%
%
%
%
% Units: Whatever OpenSees is using - just be consistent!
%
% -------------------
% function[void] = PlotCorrelationsMultStripes()

%% Input the information for the stripe to be processed (be sure that this is not here when processing multiple stripe correlations).
    plotVersionName = ['DesID1_v.57nlBmCol'];
    analysisType = ['(DesID1_v.57)_(AllVar)_(Mean)_(nonlinearBeamColumn)'];
%     doIndividualPlots = 1;
    doIndividualPlots = 0;
    doCombinedPlots = 1;
%     doCombinedPlots = 0;

% Input other random stuff needed.
    markerType = 'bo-';
    markerTypeLIST = {'bo-', 'bx-', 'b+-', 'b*-', 'bs-', 'bd-', 'bv-', 'bh-'};


% Now do all of the work...
temp = sprintf('Correlation plotting Started for multiple stripes');
disp(temp);

% First get into the output folder, then into the model output folder
    cd ..;
    cd Output;
    % Convert the folder name to string b/c the cell data type won't work to open folders (just converting type)
    analysisTypeFolder = sprintf('%s', analysisType);
    cd(analysisTypeFolder);

% Open the file that has the 3D correlation matrix.
    fileName = sprintf('CORRELATIONS_All_Stripes.mat');
    load(fileName);
        
% Compute the number of EDPs and the number of Sa levels, for possible future use
    numSaLevels = length(saTOneForRunLIST);
    numEDPs = length(correlation3DMatrix);
    
    
    
%%%%%%%%%%%%%%%%%
% Do all plots
%%%%%%%%%%%%%%%%%

% Go into Figure folder
cd Figures;



%%%%%%%%%%%%%%%%%%%%%%%
% Do invdividual plots

if (doIndividualPlots == 1)
    % Plot EDP1 vs EDP2, for all Sa levels
        EDPOne = 1;
        figNum = 1000;

    
        for EDPTwo = 1:8
            
            % Do a plot
%             subPlotIndex1 = EDPTwo
%             subplot(
            figure(figNum)
            tempPlot(1,:) = correlation3DMatrix(EDPOne,EDPTwo,:);
            tempPlot2(1,:) = tempPlot(1,1,:)
            plot(tempPlot2, saTOneForRunLIST, markerType);
    
            % Do plot details
                    grid on
                    titleText = sprintf('Correlations between EDP %d and EDP %d, %s', EDPOne, EDPTwo, plotVersionName);
                    title(titleText);
                    yLabel = sprintf('Spectral Acceleration at First Mode Period (g)');
                    ylabel(yLabel);
                    xLabel = sprintf('Correlation Coefficient');
                    xlabel(xLabel);
                    box on

                    % Save the current figure
                    plotName = sprintf('%s.fig', titleText);
                    hgsave(plotName)

            figNum = figNum + 1;
    
        end
end
%%%%%%%%%%%%%%%%%%%%%%%


%%%%%%%%%%%%%%%%%%%%%%%
% Do multiple plots on one plot  

if (doCombinedPlots == 1)
    % Plot EDP1 vs EDPTwoLIST, for all Sa levels
        EDPOne = 9;
        EDPTwoLIST = 5:8;
        figure(figNum)
        hold on
        
        for EDPTwoIndex = 1:length(EDPTwoLIST)
            EDPTwo = EDPTwoLIST(EDPTwoIndex);
            
            % Do a plot
%             subPlotIndex1 = EDPTwo
%             subplot(

            tempPlot(1,:) = correlation3DMatrix(EDPOne,EDPTwo,:);
            tempPlot2(1,:) = tempPlot(1,1,:)
            plot(tempPlot2, saTOneForRunLIST, markerTypeLIST{EDPTwoIndex});

        end
        figNum = figNum + 1;
                    % Do plot details
                    grid on
                    titleText = sprintf('Correlations between EDP %d and EDPs 5-8, %s', EDPOne, plotVersionName);
                    title(titleText);
                    yLabel = sprintf('Spectral Acceleration at First Mode Period (g)');
                    ylabel(yLabel);
                    xLabel = sprintf('Correlation Coefficient');
                    xlabel(xLabel);
                    legend('EDP5 - PFA Floor 2', 'EDP6 - PFA Floor 3', 'EDP7 - PFA Floor 4', 'EDP8 - PFA Floor 5');
%                     legend('EDP1 - PTD Story 1', 'EDP2 - PTD Story 2', 'EDP3 - PTD Story 3', 'EDP4 - PTD Story 4');
                    box on

                    % Save the current figure
                    plotName = sprintf('%s.fig', titleText);
                    hgsave(plotName)
                    hold off
        
end
%%%%%%%%%%%%%%%%%%%%%%%
        
        
        
        
        
        
        
        
        
% Do some 3D plots of correlations over building height
    % Plot of EDP 1 vs. EDPs 1-4 for all Sa levels
%         EDPOne = 1;
%         EDPTwo = 1:4;
%         tempPlot = correlation3DMatrix(EDPOne,EDPTwo,:);
%         tempPlot2(1,:) = tempPlot(EDPOne,EDPTwo,:)
%         plot(tempPlot2, saTOneForRunLIST, markerType);

    
    
    
    
    
    
    
    
    
    
            
% Clear the data from the file that was opened
    clear EDPResponse3DMatrix saTOneForRunLIST analysisType correlation3DMatrix covariance3DMatrix

% Go back to the MatlabProcessors folder
cd ..;
cd ..;
cd ..;
cd MatlabProcessors;
    
    


temp = sprintf('Correlation plotting Finished for multiple stripes.');
disp(temp);












