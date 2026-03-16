%
% Procedure: PlotIDAs.m
% -------------------
% This procedure computes opens the need files and plots IDA's with the EQ runs as dots, the mean responce line, and the +/- sigma lines for both RTR variability and
%           total variability (from the FOSM calculations).
%   
%           Right now this only processes drift ratios, PFA's and peak PHR's, but later will need to be updated to include more information.
% 
% Assumptions and Notices: 
%           - This assumes that the same EQ's were run at each stripe level and will need to be altered if this is not the case.
%           - This assumes that the ProcessStripeStatistics has been called and saved all of the DATA for each stripe.
%           - This must be run with the current directory started in the "MatlabProcessing" folder.
%           - The variable values must be numerical - i.e. not strings.
%
% Author: Curt Haselton 
% Date Written: 6-2-04
%
% Sources of Code: none
%
% Functions and Procedures called: none
%
% Variable definitions (all variables are defined at each stripe level, so they will be different for different Sa values): 
%
%
%           % ADD THESE
%
%
%
% Units: Whatever OpenSees is using - just be consistent!
%
% -------------------
% function[void] = PlotIDAs(put hings in here later - see below)

% All of the Accel. responces are in in/s^2, so divide by g = 386.4 in/(s^2) to get in units of g.
    g = 386.4;  % in/(s^2)
        

saTOneForStripeLIST = [0.10, 0.19, 0.26, 0.44, 0.55, 0.82, 1.20];   % No stripe 7
% saTOneForStripeLIST = [0.10, 0.19, 0.26, 0.33, 0.44, 0.55, 0.82];   % With stripe 7 of 0.33
% saTOneForStripeLIST = [0.10, 0.19, 0.26, 0.30, 0.44, 0.55, 0.82];   % No stripe 7 of 0.30


% saTOneForStripeLIST = [0.14, 0.50];
% saTOneForStripeLIST = [0.05, 0.14, 0.21, 0.25, 0.40, 0.50, 0.85];
% saTOneForStripeLIST = [0.10, 0.20, 0.30, 0.40, 0.68, 0.75, 0.90, 1.00, 1.15, 1.25, 1.35, 1.50];        % LATER, MAKE THIS AN INPUT PARAMETER

% Define the model version and the element used, so that we know which one to use - to know the folder names/etc.
% modelVersionPrefix = '(DesID1_v.47nlBmCol)_';       % LATER, MAKE THIS AN INPUT PARAMETER
% modelVersionPrefix = '(DesID1_v.47pinchDmg)_';       % LATER, MAKE THIS AN INPUT PARAMETER
modelVersionPrefix = '(DesID1_v.57LumpPla)_';       % LATER, MAKE THIS AN INPUT PARAMETER
% elementsUsedForModel = 'nonlinearBeamColumn';           % LATER, MAKE THIS AN INPUT PARAMETER
% elementsUsedForModel = 'pinchDmgHinge';           % LATER, MAKE THIS AN INPUT PARAMETER
% elementsUsedForModel = 'nonlinearBeamColumn';           % LATER, MAKE THIS AN INPUT PARAMETER
elementsUsedForModel = 'hystHinge';           % LATER, MAKE THIS AN INPUT PARAMETER


variableName = 'AllVar';
variableValue = 'Mean';



maxStoryNum = 4;
maxFloorNum = 5;

% Define the option of plotting all EQ's or just converged EQ's
    % Define if you want to plot only converged EQ's - this only affects the statistic lines for mean and +/- sigma
        plotALLOrJustConvEQs = 1; % ALL
%           plotALLOrJustConvEQs = 0;     % Just conv. EQs

    % Define if you want to plot the single record IDA lines
%         plotSingleEQIDAs = 1 - may not work now;           % ONLY USE IF ALL EQ RESULTS ARE PLOTTED (plotALLOrJustConvEQs = 1) - Plot IDA lines for each EQ - with 
                                %   distinction for which results are converged and non-converged.
          plotSingleEQIDAs = 0;         % Don't plot IDA lines for each EQ

    % Define if you want to plot the mean and mean +/- sigma lines
        plotMeanAndVarLines = 1;
%         plotMeanAndVarLines = 0;

% Input what max value you want on Y axis for the plot
maxYOnAxis = 1.0;

disp('IDA Processing Starting...');

% Initialize figure number
figureNum = 100;

% Go to the Output folder
cd ..;
cd Output;


%%%%%%%%%%%%%%%%
% MEAN VALUES - Loop over all stripes and open the AllVar = Mean DATA file to get the responces for all EQ runs.
for stripeIndex = 1:length(saTOneForStripeLIST)
    
    saTOneForStripe = saTOneForStripeLIST(stripeIndex);

    % Open the data file for each stripe for AllVar = Mean, to get information for later plotting...
        % Get to correct folder
        meanAnalysisFolder = sprintf('%s(%s)_(%s)_(%s)', modelVersionPrefix, variableName, variableValue, elementsUsedForModel);    % For the mean runs
%         meanAnalysisFolder = sprintf('%s(%s)_(%.2f)_(%s)', modelVersionPrefix, variableName, variableValue, elementsUsedForModel);    % For the sensitivity runs

        cd(meanAnalysisFolder);
        % Make file name and load file 
        fileName = sprintf('DATA_stripe_AllDataForAllEQRecords_Sa_%.2f.mat', saTOneForStripe);
        load(fileName);
        
        % Get the data out that I want for this stripe - note that these structures that are being copied have all the info in them (in fields) that we need.
        maxStoryDriftRatioAllStripes{stripeIndex} = maxStoryDriftRatio;
        residualStoryDriftRatioAllStripes{stripeIndex} = residualStoryDriftRatio;
        maxFloorAccelAllStripes{stripeIndex} = maxFloorAccel;
        maxPHRForAllEleAllStripes{stripeIndex} = maxPHRForAllEle;
        maxBmPHRInFullFrameAllStripes{stripeIndex} = maxBmPHRInFullFrame;
        maxColPHRInFullFrameAllStripes{stripeIndex} = maxColPHRInFullFrame;

%         maxHingeRotAllStripes{stripeIndex} = maxHingeRot;
%         hingeNumWithMaxRotAllStripes{stripeIndex} = hingeNumWithMaxRot;    
%         numConvEQsInStripe{stripeIndex} = numConvEQs;
        isConvergedForFullEQAllStripes{stripeIndex} = isAnalysisConv;
        numEQsInStripe{stripeIndex} = numEQs;
%         maxToleranceUsedAllStripes{stripeIndex} = maxToleranceUsed;
        
        % Go back to the output folder
        cd ..;
end
%%%%%%%%%%%%%%%%%%



%%%%%%%%%%%%%%%%%%%%
% % Similarly loop over all stripes and open the FOSM results DATA file to get the data for the FOSM caclulations.

% NOT USING THIS HERE b/c I DIDN"T DO SENSITIVITIES!!!

% for stripeIndex = 1:length(saTOneForStripeLIST)
%     
%     saTOneForStripe = saTOneForStripeLIST(stripeIndex);
% 
%     % Open the data file for each stripe for AllVar = Mean, to get information for later plotting...
%         % Get to correct folder
%         FOSMResultsFolder = sprintf('FOSM_RESULTS_%s%s', modelVersionPrefix, elementsUsedForModel);
%         cd(FOSMResultsFolder);
%         % Make file name and load file
%         fileName = sprintf('RESULTS_FOSM_stripe_Sa_%.2f.mat', saTOneForStripe);
%         load(fileName);
%         
%         % Get the data out that I want for this stripe - note that these structures that are being copied have all the info in them (in fields) that we need.
%         maxStoryDriftRatioFOSMAllStripes{stripeIndex} = maxStoryDriftRatioFOSM;
%         maxFloorAccelFOSMAllStripes{stripeIndex} = maxFloorAccelFOSM;     
%         maxHingeRotFOSMAllStripes{stripeIndex} = maxHingeRotFOSM;
%         
%         % Go back to the output folder
%         cd ..;
% end
%%%%%%%%%%%%%%%%%%%%%%

    
%%%%%%%%%%%%%%%%%%%%%%
% Create IDA plots....

    % NOTE THAT THIS IS JUST RTR VARIABILITY, SO IT DOESN'T USE THE FOSM FOLDER THAT WE USE IF WE ARE DOING SENSITIVITIES!!!


    % Put all of these results (figure files) in the Figures folder in the ANALYSIS (not FOSM) results folder
%         folderName = sprintf('FOSM_RESULTS_%s%s', modelVersionPrefix, elementsUsedForModel);
%         cd(folderName);
        cd(meanAnalysisFolder);


    % First create a folder to save all of the figures in
    %   Check is the folder exists - if it doesn'r exist, then create the folder.  Note that "7" signifies that the folderName exists and it's a directory.
        figFolderName = 'Figures';
%         if(exist(figFolderName, 'dir') ~= 7)
%             disp('Creating a figures folder...')
%             mkdir Figures
%         end
    cd(figFolderName);
    
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% START STORY DRIFTS %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        % Make the diagrams for all the story drifts...
            for storyNum = 1:maxStoryNum
                figure(figureNum)
                hold on
                % Draw the IDA for each story drift responce
                
                    % Loop over all EQ's and stripes and plot the single EQ IDA lines...

                    
                    for stripeIndex = 1:length(saTOneForStripeLIST)
                        
                                
                        stripeIndex;
                            
                        
                            for eqIndex = 1:length(maxStoryDriftRatioAllStripes{stripeIndex}{storyNum}.allEQs)
                            
                                eqIndex;
                                
                                isCurrentEQFullyConv = isConvergedForFullEQAllStripes{stripeIndex}(eqIndex);
                            
                                % First initialize old plot vector to zero
                                plotVectorXPrevious = 0;
                                plotVectorYPrevious = 0;

                                if (isCurrentEQFullyConv == 1)
  
                                    % Plot a circle
                                    markerType = 'ko';
                                
                                    % Plot the point
                                    plotVectorX = maxStoryDriftRatioAllStripes{stripeIndex}{storyNum}.allEQs(eqIndex);     % These are the individual EQ responces for the AllVar=Mean run.
                                    plotVectorY = saTOneForStripeLIST(stripeIndex);  % Just Sa level for stripe
                                    plot(plotVectorX, plotVectorY, markerType);
                                    grid on
                                    hold on
                                
                                    if (plotSingleEQIDAs == 1)
                                        % Plot a line to connect the new point to the previous point
                                        markerType = 'k-';
                                        plot([plotVectorXPrevious, plotVectorX], [plotVectorYPrevious, plotVectorY], markerType);  
                                        hold on
                                
                                        % Save current values as old values for the next step
                                        plotVectorXPrevious = plotVectorX;
                                        plotVectorYPrevious = plotVectorY;
                                    end
                                
                                else if (isCurrentEQFullyConv == 0)

                                    % If it's NOT fully converged, plot an X
                                    markerType = 'rx';

                                    % Plot the point
                                    plotVectorX = maxStoryDriftRatioAllStripes{stripeIndex}{storyNum}.allEQs(eqIndex);     % These are the individual EQ responces for the AllVar=Mean run.
                                    plotVectorY = saTOneForStripeLIST(stripeIndex);  % Just Sa level for stripe
                                    plot(plotVectorX, plotVectorY, markerType);
                                    grid on
                                    hold on
                                
                                    if (plotSingleEQIDAs == 1)
                                        % Plot a line to connect the new point to the previous point
                                        markerType = 'r:';
                                        plot([plotVectorXPrevious, plotVectorX], [plotVectorYPrevious, plotVectorY], markerType);  
                                        hold on
                                
                                        % Save current values as old values for the next step
                                        plotVectorXPrevious = plotVectorX;
                                        plotVectorYPrevious = plotVectorY;
                                    end
                                  
                                else
                                    ERROR('ERROR');
                                end
                            
                            end;  
                            
                        end;    
   
                    end
                         
                    
               % Plot stats
                    
                if (plotMeanAndVarLines == 1)
                    % Now plot the mean IDA, the mean +/- one sigmaRTR IDA, and the mean +/- one sigmaTOTAL IDA
                        % Plot the mean IDA line (the mean responce of the AllVar=Mean run)
                            % Make vectors for the plot
                            saLevelForPlot = zeros(1,length(saTOneForStripeLIST) + 1);
                            saLevelForPlot(1,2:(length(saTOneForStripeLIST) + 1)) = saTOneForStripeLIST;     % Basically just taking the SaLevelLIST, expanding it 
                                                                                                            %   by 1, and adding 0.0 for the first cell
                    
                            meanResponceForPlot = zeros(1,length(saTOneForStripeLIST) + 1);
                            % Loop for all stripe and populate the vector
                            for stripeIndex = 1:length(saTOneForStripeLIST)
                                
%                                 if (plotALLOrJustConvEQs == 1)
                                    % Plot all EQ's
                                    meanResponceForPlot(1, stripeIndex + 1) = maxStoryDriftRatioAllStripes{stripeIndex}{storyNum}.MeanAllEQs; % This leaves 
                                                                                                                                 %   a 0 for the first responce value.
%                                 elseif (plotALLOrJustConvEQs == 0)
%                                     % Plot only converged EQ's
%                                     meanResponceForPlot(1, stripeIndex + 1) = maxStoryDriftRatioAllStripes{stripeIndex}{storyNum}.MeanConvEQs; % This leaves 
%                                                                                                                                  %   a 0 for the first responce value. 
%                                 else
%                                     disp('ERROR: Check input for "plotALLOrJustConvEQs"!!!')
%                                 end

                            end
                           
                    
                        % Do the plot - note that the strange way of doing this is for the spline interpolation
                        hold on
                        meanResponceForPlotX = meanResponceForPlot;
                        saLevelForPlotY = spline(meanResponceForPlot, saLevelForPlot, meanResponceForPlotX)
                        markerType = 'b';
                        plot(meanResponceForPlotX, saLevelForPlotY, markerType);
                        
                
%                     % Now plot the IDA lines for +/- 1.0 sigmaRTR
%                         % Note that the SA level for plot is the same as above, so we don't need to compute it.
%                         
%                         % Compute +/- one sigma RTR IDA lines
%                             meanMinusSigmaRTRResponceForPlot = zeros(1,length(saTOneForStripeLIST) + 1);
%                             meanPlusSigmaRTRResponceForPlot = zeros(1,length(saTOneForStripeLIST) + 1);
% 
%                             % Loop for all stripe and populate the vector - Thie leaves a 0 for the first responce value.
%                             for stripeIndex = 1:length(saTOneForStripeLIST)
%                                 
%                                 if (plotALLOrJustConvEQs == 1)
%                                     % Plot all EQ's
%                                     meanMinusSigmaRTRResponceForPlot(1, stripeIndex + 1) = meanResponceForPlot(1, stripeIndex + 1)...
%                                         - maxStoryDriftRatioAllStripes{stripeIndex}{storyNum}.StDevAllEQs;
%                                     meanPlusSigmaRTRResponceForPlot(1, stripeIndex + 1) = meanResponceForPlot(1, stripeIndex + 1)...
%                                         + maxStoryDriftRatioAllStripes{stripeIndex}{storyNum}.StDevAllEQs;
%                                 elseif (plotALLOrJustConvEQs == 0)
%                                     % Plot only converged EQ's
%                                     meanMinusSigmaRTRResponceForPlot(1, stripeIndex + 1) = meanResponceForPlot(1, stripeIndex + 1)...
%                                         - maxStoryDriftRatioAllStripes{stripeIndex}{storyNum}.StDevConvEQs;
%                                     meanPlusSigmaRTRResponceForPlot(1, stripeIndex + 1) = meanResponceForPlot(1, stripeIndex + 1)...
%                                         + maxStoryDriftRatioAllStripes{stripeIndex}{storyNum}.StDevConvEQs;
%                                 else
%                                     disp('ERROR: Check input for "plotALLOrJustConvEQs"!!!')
%                                 end  
%                                 
%                                 
%                             end                                                                                                     
%                            
%                         % Do the plots - note that the strange way of doing this is for the spline interpolation
%                         hold on
%                         meanMinusSigmaRTRResponceForPlotX = meanMinusSigmaRTRResponceForPlot;
%                         saLevelForPlotY = spline(meanMinusSigmaRTRResponceForPlot, saLevelForPlot, meanMinusSigmaRTRResponceForPlotX)
%                         markerType = 'b';
%                         plot(meanMinusSigmaRTRResponceForPlotX, saLevelForPlotY, markerType);
%                     
%                         meanPlusSigmaRTRResponceForPlotX = meanPlusSigmaRTRResponceForPlot;
%                         saLevelForPlotY = spline(meanPlusSigmaRTRResponceForPlot, saLevelForPlot, meanPlusSigmaRTRResponceForPlotX)
%                         markerType = 'b';
%                         plot(meanPlusSigmaRTRResponceForPlotX, saLevelForPlotY, markerType);                 
                    
                    end
                        
   
                   
                    % Do the final plot details...
                    ylim([0,maxYOnAxis])
                    % Do plot naming, etc...
%                     legendName = sprintf('Single Responces', 'Mean Responce', '+/- One StDev RTR', '+/- One StDev FOSM');
%                     legend(legendName);
                    grid on
                    titleText = sprintf('Incremental Dynamic Analysis for Peak Story Drift Ratio of Story %d, %s', storyNum, meanAnalysisFolder);
                    title(titleText);
                    yLabel = sprintf('Spectral Acceleration at First Mode Period (g)');
                    ylabel(yLabel);
                    xLabel = sprintf('Structural EDP - Peak Story Drift Ratio of Story %d (drift ratio)', storyNum);
                    xlabel(xLabel);
                    box on

                    % Save the current figure
                    plotName = sprintf('%s.fig', titleText);
                    hgsave(plotName)

                    hold off
                    figureNum = figureNum + 1;
    
            end
            
        end
                
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% END STORY DRIFTS %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

        
        
      
        
        
            
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% START OF PEAK FLOOR ACCELERATIONS %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        % Make the diagrams for all the PFA's...
        

        
            for floorNum = 2:maxFloorNum
                figure(figureNum)
                hold on
                    
                    
              % Loop over all EQ's and stripes and plot the single EQ IDA lines...

                for stripeIndex = 1:length(saTOneForStripeLIST)
                       
                                
                        stripeIndex;
              
              
                        for eqIndex = 1:length(maxStoryDriftRatioAllStripes{stripeIndex}{storyNum}.allEQs)
                            
                            eqIndex;
                            
                             isCurrentEQFullyConv = isConvergedForFullEQAllStripes{stripeIndex}(eqIndex);
                            
                            % First initialize old plot vector to zero
                                plotVectorXPrevious = 0;
                                plotVectorYPrevious = 0;

                            
                                if (isCurrentEQFullyConv == 1)
  
                                    % If it's fully converged, plot a circle
                                    markerType = 'ko';
                                
                                    % Plot the point
                                    plotVectorX = maxFloorAccelAllStripes{stripeIndex}{floorNum}.allEQsUnfiltered(eqIndex) / g;     % Changed to unfiltered on 10-6-04!  % These are the individual EQ responces for the AllVar=Mean run.
                                    plotVectorY = saTOneForStripeLIST(stripeIndex);  % Just Sa level for stripe
                                    plot(plotVectorX, plotVectorY, markerType);
                                    grid on
                                    hold on
                                
                                    if (plotSingleEQIDAs == 1)
                                        % Plot a line to connect the new point to the previous point
                                        markerType = 'k-';
                                        plot([plotVectorXPrevious, plotVectorX], [plotVectorYPrevious, plotVectorY], markerType);  
                                        hold on
                                
                                        % Save current values as old values for the next step
                                        plotVectorXPrevious = plotVectorX;
                                        plotVectorYPrevious = plotVectorY;
                                    end
                                
                                else if (isCurrentEQFullyConv == 0)

                                    % If it's NOT fully converged, plot an X
                                    markerType = 'rx';

                                    % Plot the point
                                    plotVectorX = maxFloorAccelAllStripes{stripeIndex}{floorNum}.allEQsUnfiltered(eqIndex) / g;   % Changed to unfiltered on 10-6-04!    % These are the individual EQ responces for the AllVar=Mean run.
                                    plotVectorY = saTOneForStripeLIST(stripeIndex);  % Just Sa level for stripe
                                    plot(plotVectorX, plotVectorY, markerType);
                                    grid on
                                    hold on
                                
                                    if (plotSingleEQIDAs == 1)
                                        % Plot a line to connect the new point to the previous point
                                        markerType = 'r:';
                                        plot([plotVectorXPrevious, plotVectorX], [plotVectorYPrevious, plotVectorY], markerType);  
                                        hold on
                                
                                        % Save current values as old values for the next step
                                        plotVectorXPrevious = plotVectorX;
                                        plotVectorYPrevious = plotVectorY;
                                    end
                                  
                                else
                                    ERROR('ERROR');
                                end
                            
                            end;  
                            
                        end;    
   
                    end
                    
                    
                % Plot stats
                    
                if (plotMeanAndVarLines == 1)
                    % Now plot the mean IDA, the mean +/- one sigmaRTR IDA, and the mean +/- one sigmaTOTAL IDA
                        % Plot the mean IDA line (the mean responce of the AllVar=Mean run)
                            % Make vectors for the plot
                            saLevelForPlot = zeros(1,length(saTOneForStripeLIST) + 1);
                            saLevelForPlot(1,2:(length(saTOneForStripeLIST) + 1)) = saTOneForStripeLIST;     % Basically just taking the SaLevelLIST, expanding it 
                                                                                                            %   by 1, and adding 0.0 for the first cell
                    
                            meanResponceForPlot = zeros(1,length(saTOneForStripeLIST) + 1);
                            % Loop for all stripe and populate the vector
                            for stripeIndex = 1:length(saTOneForStripeLIST)
                                                                                                                                                                                             
%                                 if (plotALLOrJustConvEQs == 1)
                                    % Plot all EQ's - PLOT THE FILTERED RESPONSE!
                                    meanResponceForPlot(1, stripeIndex + 1) = maxFloorAccelAllStripes{stripeIndex}{floorNum}.MeanAllEQsUnfiltered / g; % Changed to unfiltered on 10-6-04!  
                                                                                                                                % This leaves 
                                                                                                                                 %   a 0 for the first responce value.
%                                 elseif (plotALLOrJustConvEQs == 0)
%                                     % Plot only converged EQ's
%                                     meanResponceForPlot(1, stripeIndex + 1) = maxFloorAccelAllStripes{stripeIndex}{floorNum}.MeanConvEQs / g; % This leaves 
%                                                                                                                                  %   a 0 for the first responce value.
%                                 else
%                                     disp('ERROR: Check input for "plotALLOrJustConvEQs"!!!')
%                                 end                                                                                         
                                                                                                                                 
                                                                                                                                 
                                                                                                                                 
                                                                                                                                 
                            end
                    
                        % Do the plot - note that the strange way of doing this is for the spline interpolation
                        hold on
                        meanResponceForPlotX = meanResponceForPlot;
                        saLevelForPlotY = spline(meanResponceForPlot, saLevelForPlot, meanResponceForPlotX); 
                        markerType = 'b';
                        plot(meanResponceForPlotX, saLevelForPlotY, markerType);
                        hold on
   
                
%                     % Now plot the IDA lines for +/- 1.0 sigmaRTR
%                         % Note that the SA level for plot is the same as above, so we don't need to compute it.
%                         
%                         % Compute +/- one sigma RTR IDA lines
%                             meanMinusSigmaRTRResponceForPlot = zeros(1,length(saTOneForStripeLIST) + 1);
%                             meanPlusSigmaRTRResponceForPlot = zeros(1,length(saTOneForStripeLIST) + 1);
% 
%                             % Loop for all stripe and populate the vector - Thie leaves a 0 for the first responce value.
%                             for stripeIndex = 1:length(saTOneForStripeLIST)
% 
%                                 if (plotALLOrJustConvEQs == 1)
%                                     % Plot all EQ's
%                                     meanMinusSigmaRTRResponceForPlot(1, stripeIndex + 1) = meanResponceForPlot(1, stripeIndex + 1)...
%                                         - (maxFloorAccelAllStripes{stripeIndex}{floorNum}.StDevAllEQs / g);
%                                     meanPlusSigmaRTRResponceForPlot(1, stripeIndex + 1) = meanResponceForPlot(1, stripeIndex + 1)...
%                                         + (maxFloorAccelAllStripes{stripeIndex}{floorNum}.StDevAllEQs / g);
%                                 elseif (plotALLOrJustConvEQs == 0)
%                                     meanMinusSigmaRTRResponceForPlot(1, stripeIndex + 1) = meanResponceForPlot(1, stripeIndex + 1)...
%                                         - (maxFloorAccelAllStripes{stripeIndex}{floorNum}.StDevConvEQs / g);
%                                     meanPlusSigmaRTRResponceForPlot(1, stripeIndex + 1) = meanResponceForPlot(1, stripeIndex + 1)...
%                                         + (maxFloorAccelAllStripes{stripeIndex}{floorNum}.StDevConvEQs / g);
%                                 else
%                                     disp('ERROR: Check input for "plotALLOrJustConvEQs"!!!')
%                                 end     
%                                 
%                             end                                                                                                     
%                            
%                         % Do the plots - note that the strange way of doing this is for the spline interpolation
%                         hold on
%                         meanMinusSigmaRTRResponceForPlotX = meanMinusSigmaRTRResponceForPlot;
%                         saLevelForPlotY = spline(meanMinusSigmaRTRResponceForPlot, saLevelForPlot, meanMinusSigmaRTRResponceForPlotX);
%                         markerType = '-';
%                         plot(meanMinusSigmaRTRResponceForPlotX, saLevelForPlotY, markerType);
%                         hold on
%                     
%                         meanPlusSigmaRTRResponceForPlotX = meanPlusSigmaRTRResponceForPlot;
%                         saLevelForPlotY = spline(meanPlusSigmaRTRResponceForPlot, saLevelForPlot, meanPlusSigmaRTRResponceForPlotX);
%                         markerType = '-';
%                         plot(meanPlusSigmaRTRResponceForPlotX, saLevelForPlotY, markerType);  
%                         hold on
                        
                    end
                    
                   
                    % Do the final plot details...
                    ylim([0,maxYOnAxis])
                    % Do plot naming, etc...
%                     legendName = sprintf('Single Responces', 'Mean Responce', '+/- One StDev RTR', '+/- One StDev FOSM');
%                     legend(legendName);
                    grid on
                    titleText = sprintf('Incremental Dynamic Analysis for Peak Floor Acceleration of Floor %d, %s', floorNum, meanAnalysisFolder);
                    title(titleText);
                    yLabel = sprintf('Spectral Acceleration at First Mode Period (g)');
                    ylabel(yLabel);
                    xLabel = sprintf('Structural EDP - Peak Floor Acceleration of Floor %d (g)', floorNum);
                    xlabel(xLabel);
                    box on

                    % Save the current figure
                    plotName = sprintf('%s.fig', titleText);
                    hgsave(plotName)

                    hold off
                    figureNum = figureNum + 1;
    
            end

            
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% END OF PEAK FLOOR ACCELERATIONS %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


  %         %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% START OF COLUMN PEAK HINGE ROTATIONS %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


        % Make the diagrams for the peak PHR in the building (of all hinges)...
       
                figure(figureNum)
                hold on

              % Loop over all EQ's and stripes and plot the single EQ IDA lines...

                for stripeIndex = 1:length(saTOneForStripeLIST)
                    
                                
                    stripeIndex;
              
                        for eqIndex = 1:length(maxStoryDriftRatioAllStripes{stripeIndex}{storyNum}.allEQs)
                            
                            eqIndex;
                            
                            isCurrentEQFullyConv = isConvergedForFullEQAllStripes{stripeIndex}(eqIndex);
                            
                            % First initialize old plot vector to zero
                                plotVectorXPrevious = 0;
                                plotVectorYPrevious = 0;

                            
                                if (isCurrentEQFullyConv == 1)
  
                                    % If it's fully converged, plot a circle
                                    markerType = 'ko';
                                
                                    % Plot the point
                                    plotVectorX = maxColPHRInFullFrameAllStripes{stripeIndex}.maxHingeRot.allEQs(eqIndex);     % These are the individual EQ responces for the AllVar=Mean run.
                                    plotVectorY = saTOneForStripeLIST(stripeIndex);  % Just Sa level for stripe
                                    plot(plotVectorX, plotVectorY, markerType);
                                    grid on
                                    hold on
                                
                                    if (plotSingleEQIDAs == 1)
                                        % Plot a line to connect the new point to the previous point
                                        markerType = 'k-';
                                        plot([plotVectorXPrevious, plotVectorX], [plotVectorYPrevious, plotVectorY], markerType);  
                                        hold on
                                
                                        % Save current values as old values for the next step
                                        plotVectorXPrevious = plotVectorX;
                                        plotVectorYPrevious = plotVectorY;
                                    end
                                
                                else if (isCurrentEQFullyConv == 0)

                                    % If it's NOT fully converged, plot an X
                                    markerType = 'rx';

                                    % Plot the point
                                    plotVectorX = maxColPHRInFullFrameAllStripes{stripeIndex}.maxHingeRot.allEQs(eqIndex);     % These are the individual EQ responces for the AllVar=Mean run.
                                    plotVectorY = saTOneForStripeLIST(stripeIndex);  % Just Sa level for stripe
                                    plot(plotVectorX, plotVectorY, markerType);
                                    grid on
                                    hold on
                                
                                    if (plotSingleEQIDAs == 1)
                                        % Plot a line to connect the new point to the previous point
                                        markerType = 'r:';
                                        plot([plotVectorXPrevious, plotVectorX], [plotVectorYPrevious, plotVectorY], markerType);  
                                        hold on
                                
                                        % Save current values as old values for the next step
                                        plotVectorXPrevious = plotVectorX;
                                        plotVectorYPrevious = plotVectorY;
                                    end
                                  
                                else
                                    ERROR('ERROR');
                                end
%                             
                            end;  
                            
                        end;    
   
                    end


                % Plot stats
                    
                if (plotMeanAndVarLines == 1)

                    % Now plot the mean IDA, the mean +/- one sigmaRTR IDA, and the mean +/- one sigmaTOTAL IDA
                        % Plot the mean IDA line (the mean responce of the AllVar=Mean run)
                            % Make vectors for the plot
                            saLevelForPlot = zeros(1,length(saTOneForStripeLIST) + 1);
                            saLevelForPlot(1,2:(length(saTOneForStripeLIST) + 1)) = saTOneForStripeLIST;     % Basically just taking the SaLevelLIST, expanding it 
                                                                                                            %   by 1, and adding 0.0 for the first cell
                    
                            meanResponceForPlot = zeros(1,length(saTOneForStripeLIST) + 1);
                            % Loop for all stripe and populate the vector
                            for stripeIndex = 1:length(saTOneForStripeLIST)
                                meanResponceForPlot(1, stripeIndex + 1) = maxColPHRInFullFrameAllStripes{stripeIndex}.maxHingeRot.MeanAllEQs; 
                            end                                                                                               
                           
                    
                        % Do the plot - note that the strange way of doing this is for the spline interpolation
                        hold on
                        meanResponceForPlotX = meanResponceForPlot;
                        saLevelForPlotY = spline(meanResponceForPlot, saLevelForPlot, meanResponceForPlotX);
                        markerType = 'b';
                        plot(meanResponceForPlotX, saLevelForPlotY, markerType);
   
                
%                     % Now plot the IDA lines for +/- 1.0 sigmaRTR
%                         % Note that the SA level for plot is the same as above, so we don't need to compute it.
%                         
%                         % Compute +/- one sigma RTR IDA lines
%                             meanMinusSigmaRTRResponceForPlot = zeros(1,length(saTOneForStripeLIST) + 1);
%                             meanPlusSigmaRTRResponceForPlot = zeros(1,length(saTOneForStripeLIST) + 1);
% 
%                             % Loop for all stripe and populate the vector - Thie leaves a 0 for the first responce value, but a bit different that above, due to the floor/story numbering difference.
%                             
%                             for stripeIndex = 1:length(saTOneForStripeLIST)
%                                 stDev = std(maxPHRInFullFrameAllStripes{stripeIndex}.maxHingeRot.allEQs);
%                                 meanMinusSigmaRTRResponceForPlot(1, stripeIndex + 1) = meanResponceForPlot(1, stripeIndex + 1)...
%                                     - stDev;
%                                 meanPlusSigmaRTRResponceForPlot(1, stripeIndex + 1) = meanResponceForPlot(1, stripeIndex + 1)...
%                                     + stDev;
%                             end                                                                                                     
%                            
%                         % Do the plots - note that the strange way of doing this is for the spline interpolation
%                         hold on
%                         meanMinusSigmaRTRResponceForPlotX = meanMinusSigmaRTRResponceForPlot;
%                         saLevelForPlotY = spline(meanMinusSigmaRTRResponceForPlot, saLevelForPlot, meanMinusSigmaRTRResponceForPlotX);
%                         markerType = '-';
%                         plot(meanMinusSigmaRTRResponceForPlotX, saLevelForPlotY, markerType);
%                     
%                         meanPlusSigmaRTRResponceForPlotX = meanPlusSigmaRTRResponceForPlot;
%                         saLevelForPlotY = spline(meanPlusSigmaRTRResponceForPlot, saLevelForPlot, meanPlusSigmaRTRResponceForPlotX);
%                         markerType = '-';
%                         plot(meanPlusSigmaRTRResponceForPlotX, saLevelForPlotY, markerType);                 
                    
                    end 
                    
                    % Do the final plot details...
                    ylim([0,maxYOnAxis])
                    % Do plot naming, etc...
%                     legendName = sprintf('Single Responces', 'Mean Responce', '+/- One StDev RTR', '+/- One StDev FOSM');
%                     legend(legendName);
                    grid on
                    titleText = sprintf('Incremental Dynamic Analysis for Maximum Column Plastic Rotation, %s', meanAnalysisFolder);
                    title(titleText);
                    yLabel = sprintf('Spectral Acceleration at First Mode Period (g)');
                    ylabel(yLabel);
                    xLabel = sprintf('Structural EDP - Maximum Column Plastic Rotation (radians)');
                    xlabel(xLabel);
                    box on

                    % Save the current figure
                    plotName = sprintf('%s.fig', titleText);
                    hgsave(plotName)

                    hold off
                    figureNum = figureNum + 1;

%         %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% END OF Column PEAK HINGE ROTATIONS %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        
        
        
        
%         %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% START OF BEAM PEAK HINGE ROTATIONS %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


        % Make the diagrams for the peak PHR in the building (of all hinges)...
       
                figure(figureNum)
                hold on

              % Loop over all EQ's and stripes and plot the single EQ IDA lines...

                for stripeIndex = 1:length(saTOneForStripeLIST)
                    
                                
                    stripeIndex;
              
                        for eqIndex = 1:length(maxStoryDriftRatioAllStripes{stripeIndex}{storyNum}.allEQs)
                            
                            eqIndex;
                            
                            isCurrentEQFullyConv = isConvergedForFullEQAllStripes{stripeIndex}(eqIndex);
                            
                            % First initialize old plot vector to zero
                                plotVectorXPrevious = 0;
                                plotVectorYPrevious = 0;

                            
                                if (isCurrentEQFullyConv == 1)
  
                                    % If it's fully converged, plot a circle
                                    markerType = 'ko';
                                
                                    % Plot the point
                                    plotVectorX = maxBmPHRInFullFrameAllStripes{stripeIndex}.maxHingeRot.allEQs(eqIndex);     % These are the individual EQ responces for the AllVar=Mean run.
                                    plotVectorY = saTOneForStripeLIST(stripeIndex);  % Just Sa level for stripe
                                    plot(plotVectorX, plotVectorY, markerType);
                                    grid on
                                    hold on
                                
                                    if (plotSingleEQIDAs == 1)
                                        % Plot a line to connect the new point to the previous point
                                        markerType = 'k-';
                                        plot([plotVectorXPrevious, plotVectorX], [plotVectorYPrevious, plotVectorY], markerType);  
                                        hold on
                                
                                        % Save current values as old values for the next step
                                        plotVectorXPrevious = plotVectorX;
                                        plotVectorYPrevious = plotVectorY;
                                    end
                                
                                else if (isCurrentEQFullyConv == 0)

                                    % If it's NOT fully converged, plot an X
                                    markerType = 'rx';

                                    % Plot the point
                                    plotVectorX = maxBmPHRInFullFrameAllStripes{stripeIndex}.maxHingeRot.allEQs(eqIndex);     % These are the individual EQ responces for the AllVar=Mean run.
                                    plotVectorY = saTOneForStripeLIST(stripeIndex);  % Just Sa level for stripe
                                    plot(plotVectorX, plotVectorY, markerType);
                                    grid on
                                    hold on
                                
                                    if (plotSingleEQIDAs == 1)
                                        % Plot a line to connect the new point to the previous point
                                        markerType = 'r:';
                                        plot([plotVectorXPrevious, plotVectorX], [plotVectorYPrevious, plotVectorY], markerType);  
                                        hold on
                                
                                        % Save current values as old values for the next step
                                        plotVectorXPrevious = plotVectorX;
                                        plotVectorYPrevious = plotVectorY;
                                    end
                                  
                                else
                                    ERROR('ERROR');
                                end
%                             
                            end;  
                            
                        end;    
   
                    end


                % Plot stats
                    
                if (plotMeanAndVarLines == 1)

                    % Now plot the mean IDA, the mean +/- one sigmaRTR IDA, and the mean +/- one sigmaTOTAL IDA
                        % Plot the mean IDA line (the mean responce of the AllVar=Mean run)
                            % Make vectors for the plot
                            saLevelForPlot = zeros(1,length(saTOneForStripeLIST) + 1);
                            saLevelForPlot(1,2:(length(saTOneForStripeLIST) + 1)) = saTOneForStripeLIST;     % Basically just taking the SaLevelLIST, expanding it 
                                                                                                            %   by 1, and adding 0.0 for the first cell
                    
                            meanResponceForPlot = zeros(1,length(saTOneForStripeLIST) + 1);
                            % Loop for all stripe and populate the vector
                            for stripeIndex = 1:length(saTOneForStripeLIST)
                                meanResponceForPlot(1, stripeIndex + 1) = maxBmPHRInFullFrameAllStripes{stripeIndex}.maxHingeRot.MeanAllEQs; 
                            end                                                                                               
                           
                    
                        % Do the plot - note that the strange way of doing this is for the spline interpolation
                        hold on
                        meanResponceForPlotX = meanResponceForPlot;
                        saLevelForPlotY = spline(meanResponceForPlot, saLevelForPlot, meanResponceForPlotX);
                        markerType = 'b';
                        plot(meanResponceForPlotX, saLevelForPlotY, markerType);
   
                
%                     % Now plot the IDA lines for +/- 1.0 sigmaRTR
%                         % Note that the SA level for plot is the same as above, so we don't need to compute it.
%                         
%                         % Compute +/- one sigma RTR IDA lines
%                             meanMinusSigmaRTRResponceForPlot = zeros(1,length(saTOneForStripeLIST) + 1);
%                             meanPlusSigmaRTRResponceForPlot = zeros(1,length(saTOneForStripeLIST) + 1);
% 
%                             % Loop for all stripe and populate the vector - Thie leaves a 0 for the first responce value, but a bit different that above, due to the floor/story numbering difference.
%                             
%                             for stripeIndex = 1:length(saTOneForStripeLIST)
%                                 stDev = std(maxPHRInFullFrameAllStripes{stripeIndex}.maxHingeRot.allEQs);
%                                 meanMinusSigmaRTRResponceForPlot(1, stripeIndex + 1) = meanResponceForPlot(1, stripeIndex + 1)...
%                                     - stDev;
%                                 meanPlusSigmaRTRResponceForPlot(1, stripeIndex + 1) = meanResponceForPlot(1, stripeIndex + 1)...
%                                     + stDev;
%                             end                                                                                                     
%                            
%                         % Do the plots - note that the strange way of doing this is for the spline interpolation
%                         hold on
%                         meanMinusSigmaRTRResponceForPlotX = meanMinusSigmaRTRResponceForPlot;
%                         saLevelForPlotY = spline(meanMinusSigmaRTRResponceForPlot, saLevelForPlot, meanMinusSigmaRTRResponceForPlotX);
%                         markerType = '-';
%                         plot(meanMinusSigmaRTRResponceForPlotX, saLevelForPlotY, markerType);
%                     
%                         meanPlusSigmaRTRResponceForPlotX = meanPlusSigmaRTRResponceForPlot;
%                         saLevelForPlotY = spline(meanPlusSigmaRTRResponceForPlot, saLevelForPlot, meanPlusSigmaRTRResponceForPlotX);
%                         markerType = '-';
%                         plot(meanPlusSigmaRTRResponceForPlotX, saLevelForPlotY, markerType);                 
                    
                    end 
                    
                    % Do the final plot details...
                    ylim([0,maxYOnAxis])
                    % Do plot naming, etc...
%                     legendName = sprintf('Single Responces', 'Mean Responce', '+/- One StDev RTR', '+/- One StDev FOSM');
%                     legend(legendName);
                    grid on
                    titleText = sprintf('Incremental Dynamic Analysis for Maximum Beam Plastic Rotation, %s', meanAnalysisFolder);
                    title(titleText);
                    yLabel = sprintf('Spectral Acceleration at First Mode Period (g)');
                    ylabel(yLabel);
                    xLabel = sprintf('Structural EDP - Peak Beam Plastic Rotation (radians)');
                    xlabel(xLabel);
                    box on

                    % Save the current figure
                    plotName = sprintf('%s.fig', titleText);
                    hgsave(plotName)

                    hold off
                    figureNum = figureNum + 1;

%         %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% END OF Beam PEAK HINGE ROTATIONS %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%






















% %         %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% CONVERGENCE PLOTS %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 
%         % Story number for plot
%         storyNum = 1;
% 
%         % Loop over all stripe levels - PLOTS ARE ONLY DONE USING CONVERGED RESULTS!!!
%         for stripeIndex = 1:length(saTOneForStripeLIST)
%     
%             saTOneForStripe = saTOneForStripeLIST(stripeIndex);
% 
%             % Do plots for convergence vs. drift - for each Sa level
%                 figure(figureNum)
%                 hold on
% 
%                 % Plot the point
%                 minToleranceForModel = 1e-6;    % This is the minimu tolerance used (if no tolerance loosening is done)
%                 plotVectorX = log10(maxToleranceUsedAllStripes{stripeIndex}.allConvEQs/minToleranceForModel);     % This is the ratio of the max tolerance to the min and in log domain
%                 plotVectorY = maxStoryDriftRatioAllStripes{stripeIndex}{storyNum}.allConvEQs;  % Drift of STORY 1
%                 markerType = 'o';
%                 plot(plotVectorX, plotVectorY, markerType);
%                 grid on
%                 hold on
% 
%             % Do the final plot details...
%                 % Find plot boundaries
%                 maxYOnAxis = max(maxStoryDriftRatioAllStripes{stripeIndex}{storyNum}.allConvEQs);
%                 maxXOnAxis = max(log10(maxToleranceUsedAllStripes{stripeIndex}.allConvEQs/minToleranceForModel));
%                 
%                 % Set axis limits
%                 ylim([0,1.1*maxYOnAxis])
%                 xlim([0,1.1*maxXOnAxis])
%                     
%                 % Do plot naming, etc...
% %                 legendName = sprintf('Single Responces', 'Mean Responce', '+/- One StDev RTR', '+/- One StDev FOSM');
% %                 legend(legendName);
%                 titleText = sprintf('Convergence Diagram for Sa: %.2f, Analysis: %s', saTOneForStripe, meanAnalysisFolder);
%                 title(titleText);
%                 yLabel = sprintf('Drift Ratio for Story 1 (ratio)');
%                 ylabel(yLabel);
%                 xLabel = sprintf('Convergence Index (log10(maxConvTolUsed/minConvTol)), where minConvTol is 1e-6');
%                 xlabel(xLabel);
%                 box on
% 
%                 % Save the current figure
%                 saveName = sprintf('Convergence plot for drift of story 1, Sa of %.2f', saTOneForStripe);
%                 plotName = sprintf('%s.fig', saveName);
%                 hgsave(plotName)
% 
%                 hold off
%                 figureNum = figureNum + 1;
%             end
% 
% 
%         % Do convergence plot using the convergence index vs. Sa for this IDA
%         
%             % Do plots for convergence vs. drift - for each Sa level
%                 figure(figureNum)
%                 hold on
%                 grid on
% 
%                 
%             % Loop over all stripe levels - PLOTS ARE ONLY DONE USING CONVERGED RESULTS!!!
%                 % Initialize the max convIndex )for plotting purposes)
%                 maxConvIndexAllStripes = 0;
%             
%                 for stripeIndex = 1:length(saTOneForStripeLIST)
%                     % Plot the points
%                     minToleranceForModel = 1e-6;    % This is the minimu tolerance used (if no tolerance loosening is done)
%                     plotVectorX = log10(maxToleranceUsedAllStripes{stripeIndex}.allConvEQs/minToleranceForModel);     % This is the ratio of the max tolerance to the min and in log domain
%                     plotVectorY = ones(length(plotVectorX)) * saTOneForStripeLIST(stripeIndex);  % Just vector of correct length unifrom Sa level
%                     markerType = 'o';
%                     plot(plotVectorX, plotVectorY, markerType);
%                     hold on
%                     
%                     % Update maxConvIndexAllStripes
%                     if(max(log10(maxToleranceUsedAllStripes{stripeIndex}.allConvEQs/minToleranceForModel)) > maxConvIndexAllStripes)
%                         maxConvIndexAllStripes = max(log10(maxToleranceUsedAllStripes{stripeIndex}.allConvEQs/minToleranceForModel))
%                     end
%                     
%                 end
% 
%             % Do the final plot details...
%                 % Find plot boundaries
%                 maxYOnAxis = max(saTOneForStripeLIST);
%                 maxXOnAxis = maxConvIndexAllStripes;  
%                 
%                 % Set axis limits
%                 ylim([0,(maxYOnAxis+0.5)])
%                 xlim([0,1.1*maxXOnAxis])
%                     
%                 % Do plot naming, etc...
% %                 legendName = sprintf('Single Responces', 'Mean Responce', '+/- One StDev RTR', '+/- One StDev FOSM');
% %                 legend(legendName);
%                 titleText = sprintf('Convergence Diagram for Range of Sa Levels, Analysis: %s', meanAnalysisFolder);
%                 title(titleText);
%                 yLabel = sprintf('Spectral Acceleration at First Mode Period (g)');
%                 ylabel(yLabel);
%                 xLabel = sprintf('Convergence Index (log10(maxConvTolUsed/minConvTol)), where minConvTol is 1e-6');
%                 xlabel(xLabel);
%                 box on
% 
%                 % Save the current figure
%                 saveName = sprintf('Convergence plot for ConvIndex vs. Sa');
%                 plotName = sprintf('%s.fig', saveName);
%                 hgsave(plotName)
% 
%                 hold off
%                 figureNum = figureNum + 1;
%         
%         
%             
%             
%             
%             
% %         %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% END OF CONVERGENCE PLOTS %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%



% Get back to MatlabProcessors folder
cd ..;
cd ..;
cd ..;
cd MatlabProcessors;





disp('IDA Processing Finished.');







