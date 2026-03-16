%
% Procedure: PlotIDAs_proc.m
% -------------------
% This plots IDA analyses; this only plots non-collapse data.  This is the same as the PlotIDAs.m file, but is a procedure and has been
%   updated for the new archetype file formats.  This only plots the mean
%   and sigma lines is there are enough converged points in the stripe (as
%   defined by an input variable).
% 
% Assumptions and Notices: 
%       - none
%
% Author: Curt Haselton 
% Date Written: 6-2-04; adapted 6-30-06
%
% Sources of Code: none
%
% Functions and Procedures called: none
%
% Variable definitions (all variables are defined at each stripe level, so they will be different for different Sa values): 
%   - not included here
%
% Units: Whatever OpenSees is using - just be consistent!
%
% -------------------
function[void] = PlotIDAs_proc(analysisType, saLevelsForStripes, eqListForCollapseIDAs_Name, saTypeForIDAPlotting, isConvertToSaKircher)

% Marker Types
    %%convPointMarkerType = 'k+';
    convPointMarkerType = 'b.';
    nonConvPointMarkerType = 'bx';
    singleIDAMarkerType = 'b-';     % Single record IDA line
    %%meanIDAMarkerType = 'k--';
    meanIDAMarkerType = 'b-';
    %%varIDAMarkerType = 'k--';
    varIDAMarkerType = 'b--';

% Decide if you want to add titles
isAddTitle = 0;
titleText = ''; % Clear this from previous runs
    
% Define plotting options
    % Define if you want to plot the single record IDA lines
    %plotSingleEQIDAs = 1 - may not work now;  
    plotSingleEQIDAs = 0;         % Don't plot IDA lines for each EQ
          
    % Define if you want to plot the single EQ response points
    plotSingleEQPoints = 1;
    %plotSingleEQPoints = 0;
        
    % Define if you want to plot the mean and mean +/- sigma lines
    minNumOfConvPointsToPlotMeanAndSigmaLines = 8;
    plotMeanLine = 1;       
    %plotMeanLine = 0;
    plotVarLines = 1;       
    %plotVarLines = 0;

% Define Line Widths
    meanLineWidth = 5; %5
    varLineWidth = 4;

disp('IDA Processing Starting...');

% Initialize figure number
figureNum = 200;
maxSaPlottedSoFar = 0.0;

% Go to the Output folder for this model
cd ..;
cd Output;
cd(analysisType)

%%%%%%%%%%%%%%%%
% Loop over all stripes and save the responses.
for stripeIndex = 1:length(saLevelsForStripes)
    
    saTOneForStripe = saLevelsForStripes(stripeIndex);

    % Make filename based on EQ set used and the Sa type used.
    fileName = sprintf('DATA_stripe_%s_%s_Sa_%.2f.mat', saTypeForIDAPlotting, eqListForCollapseIDAs_Name, saTOneForStripe);
    
    % Load the desired data for this stripe
    load(fileName, 'IDR_max', 'IDR_maxAllStories', 'RDR_max', 'RDR_absResidual', 'IDR_residual', 'PGAToSave', 'PFA', 'numFloors',...
        'numStories', 'periodUsedForScalingGroundMotionsFromMatlab', 'beamAbsMaxPHR_maxAllFloors', 'columnAbsMaxPHR_maxAllStories',...
        'jointShearDistortionAbsMax_maxAllFloors');
    IDR_max_AllStripes{stripeIndex} = IDR_max;
    IDR_maxAllStories_AllStripes{stripeIndex} = IDR_maxAllStories;
    RDR_max_AllStripes{stripeIndex} = RDR_max;
    RDR_absResidual_AllStripes{stripeIndex} = RDR_absResidual;
    IDR_residual_AllStripes{stripeIndex} = IDR_residual;
    PGAToSave_AllStripes{stripeIndex} = PGAToSave;
    PFA_AllStripes{stripeIndex} = PFA; 
    beamAbsMaxPHR_maxAllFloors_AllStripes{stripeIndex} = beamAbsMaxPHR_maxAllFloors;
    columnAbsMaxPHR_maxAllStories_AllStripes{stripeIndex} = columnAbsMaxPHR_maxAllStories;
    jointShearDistortionAbsMax_maxAllFloors_AllStripes{stripeIndex} = jointShearDistortionAbsMax_maxAllFloors;
   
end
%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%
% Create IDA plots....
    
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% START STORY DRIFTS %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        % Make the diagrams for all the story drifts...
            for storyNum = 1:numStories
                figure(figureNum)
                hold on
                % Draw the IDA for each story drift responce
                    % Loop over all EQ's and stripes and plot the single EQ IDA lines...
                    for stripeIndex = 1:length(saLevelsForStripes)
                            for eqIndex = 1:length(IDR_max_AllStripes{stripeIndex}{storyNum}.allEQs)
                                % First initialize old plot vector to zero
                                plotVectorXPrevious = 0;
                                plotVectorYPrevious = 0;

                                    % Plot a circle
                                    markerType = convPointMarkerType;
                                
                                    % Plot the point
                                        plotVectorX = IDR_max_AllStripes{stripeIndex}{storyNum}.allEQs(eqIndex);     % These are the individual EQ responces for the AllVar=Mean run.
                                        plotVectorY = saLevelsForStripes(stripeIndex);  % Just Sa level for stripe
                                        if (plotSingleEQPoints == 1)
                                            plot(plotVectorX, plotVectorY, markerType);
                                        end
                                        grid on
                                        hold on
                                
                                    if (plotSingleEQIDAs == 1)
                                        % Plot a line to connect the new point to the previous point
                                        markerType = singleIDAMarkerType;
                                            plot([plotVectorXPrevious, plotVectorX], [plotVectorYPrevious, plotVectorY], markerType);  
                                        hold on
                                
                                        % Save current values as old values for the next step
                                        plotVectorXPrevious = plotVectorX;
                                        plotVectorYPrevious = plotVectorY;
                                    end
                            end;  
                    end
                         
               % Plot stats
                if (plotMeanLine == 1)
                    % Now plot the mean IDA, the mean +/- one sigmaRTR IDA, and the mean +/- one sigmaTOTAL IDA
                        % Plot the mean IDA line (the mean responce of the AllVar=Mean run)
                            % Make vectors for the plot
                            saLevelForPlot = zeros(1,length(saLevelsForStripes) + 1);
                            saLevelForPlot(1,2:(length(saLevelsForStripes) + 1)) = saLevelsForStripes;     % Basically just taking the SaLevelLIST, expanding it 
                                                                                                            %   by 1, and adding 0.0 for the first cell
                            meanResponceForPlot = zeros(1,length(saLevelsForStripes) + 1);
                            % Loop for all stripe and populate the vector
                            for stripeIndex = 1:length(saLevelsForStripes)
                                % Put a NAN, do not plot the mean line for
                                % this SA level, if there is less than two
                                % converged results
                                if((length(IDR_max_AllStripes{stripeIndex}{storyNum}.allEQs_withoutNAN)) < minNumOfConvPointsToPlotMeanAndSigmaLines)
                                    % Place a NAN value to stop the plot
                                    % for this Sa level
                                    meanResponceForPlot(1, stripeIndex + 1) = nan;
                                else
                                    % Compute the mean to plot
                                    meanResponceForPlot(1, stripeIndex + 1) = exp(IDR_max_AllStripes{stripeIndex}{storyNum}.MeanLnAllEQs);
                                end
                            end
                           
                        % Do the plot - note that the strange way of doing this is for the spline interpolation
                        hold on
                        meanResponceForPlotX = meanResponceForPlot;
                        saLevelForPlot;
                        saLevelForPlotY = spline(meanResponceForPlot, saLevelForPlot, meanResponceForPlotX);
                        markerType = meanIDAMarkerType;
                        plot(meanResponceForPlotX, saLevelForPlotY, markerType, 'LineWidth', meanLineWidth);

                end
                
                    % Plot variance lines in needed
                    if (plotVarLines == 1)
                    
                    % Now plot the IDA lines for +/- 1.0 sigmaRTR
                        % Note that the SA level for plot is the same as above, so we don't need to compute it.
                        
                        % Compute +/- one sigma RTR IDA lines
                            meanMinusSigmaRTRResponceForPlot = zeros(1,length(saLevelsForStripes) + 1);
                            meanPlusSigmaRTRResponceForPlot = zeros(1,length(saLevelsForStripes) + 1);

                            % Loop for all stripe and populate the vector - Thie leaves a 0 for the first responce value.
                            for stripeIndex = 1:length(saLevelsForStripes)
                                % Put a NAN, do not plot the mean line for
                                % this SA level, if there is less than two
                                % converged results
                                if((length(IDR_max_AllStripes{stripeIndex}{storyNum}.allEQs_withoutNAN)) < minNumOfConvPointsToPlotMeanAndSigmaLines)
                                    % Place a NAN value to stop the plot
                                    % for this Sa level
                                    meanMinusSigmaRTRResponceForPlot(1, stripeIndex + 1) = nan;
                                    meanPlusSigmaRTRResponceForPlot(1, stripeIndex + 1) = nan;
                                else
                                    % Compute the values to plot
                                        % Mean minum sigma
                                        meanMinusSigmaRTRResponceForPlot(1, stripeIndex + 1) = exp(IDR_max_AllStripes{stripeIndex}{storyNum}.MeanLnAllEQs - ...
                                            IDR_max_AllStripes{stripeIndex}{storyNum}.StDevLnAllEQs);
                                    % Mean minum sigma
                                        meanPlusSigmaRTRResponceForPlot(1, stripeIndex + 1) = exp(IDR_max_AllStripes{stripeIndex}{storyNum}.MeanLnAllEQs + ...
                                            IDR_max_AllStripes{stripeIndex}{storyNum}.StDevLnAllEQs);          
                                end
                            end                                                                                                     
                           
                        % Do the plots - note that the strange way of doing this is for the spline interpolation
                        hold on
                        meanMinusSigmaRTRResponceForPlotX = meanMinusSigmaRTRResponceForPlot;
                        saLevelForPlotY = spline(meanMinusSigmaRTRResponceForPlot, saLevelForPlot, meanMinusSigmaRTRResponceForPlotX);
                        markerType = 'b';
                        plot(meanMinusSigmaRTRResponceForPlotX, saLevelForPlotY, varIDAMarkerType, 'LineWidth', varLineWidth);
                    
                        meanPlusSigmaRTRResponceForPlotX = meanPlusSigmaRTRResponceForPlot;
                        saLevelForPlotY = spline(meanPlusSigmaRTRResponceForPlot, saLevelForPlot, meanPlusSigmaRTRResponceForPlotX);
                        markerType = 'b';
                        plot(meanPlusSigmaRTRResponceForPlotX, saLevelForPlotY, varIDAMarkerType, 'LineWidth', varLineWidth);    
                    
                    end
   
                    % Do the final plot details...
                    maxYOnAxis = floor(2.0*(max(saLevelsForStripes) + 0.5)) / 2.0;
                    ylim([0,maxYOnAxis])
                    % Do plot naming, etc...
%                     legendName = sprintf('Single Responces', 'Mean Responce', '+/- One StDev RTR', '+/- One StDev FOSM');
%                     legend(legendName);
                    grid on
                    if(isAddTitle)
                        titleText = sprintf('Incremental Dynamic Analysis for Peak Story Drift Ratio of Story %d, %s', storyNum, meanAnalysisFolder);
                    end
                    title(titleText);
                    if(isConvertToSaKircher == 0)
                        yLabel = sprintf('Sa_{g.m.}(T=%.2f) [g]', periodUsedForScalingGroundMotionsFromMatlab);
                    else
                        DefineSaKircherOverSaGeoMeanValues
                        yLabel = axisLabelForSaKircher;
                    end
                    hy = ylabel(yLabel);
                    xLabel = sprintf('Peak Drift: Story %d', storyNum);
                    hx = xlabel(xLabel);
                    box on
                    FigureFormatScript

                    % Save the current figure
                    plotName = sprintf('IDA_%s_%s_PeakTransientDrift_Story_%d.fig', saTypeForIDAPlotting, eqListForCollapseIDAs_Name, storyNum);
                    hgsave(plotName)
                    exportName = sprintf('IDA_%s_%s_PeakTransientDrift_Story_%d.emf', saTypeForIDAPlotting, eqListForCollapseIDAs_Name, storyNum);
                    print('-dmeta', exportName);

                    hold off
                    close
                    figureNum = figureNum + 1;
                
            end
                    
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% END STORY DRIFTS %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% ROOF DRIFT %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        % Make the diagrams for all the story drifts...
                figure(figureNum)
                hold on
                % Draw the IDA for each story drift responce
                    % Loop over all EQ's and stripes and plot the single EQ IDA lines...
                    for stripeIndex = 1:length(saLevelsForStripes)
                            for eqIndex = 1:length(RDR_max_AllStripes{stripeIndex}.allEQs)
                                % First initialize old plot vector to zero
                                plotVectorXPrevious = 0;
                                plotVectorYPrevious = 0;

                                    % Plot a circle
                                    markerType = convPointMarkerType;
                                
                                    % Plot the point
                                        plotVectorX = RDR_max_AllStripes{stripeIndex}.allEQs(eqIndex);     % These are the individual EQ responces for the AllVar=Mean run.
                                        plotVectorY = saLevelsForStripes(stripeIndex);  % Just Sa level for stripe
                                        if (plotSingleEQPoints == 1)
                                            plot(plotVectorX, plotVectorY, markerType);
                                        end
                                        grid on
                                        hold on
                                
                                    if (plotSingleEQIDAs == 1)
                                        % Plot a line to connect the new point to the previous point
                                        markerType = singleIDAMarkerType;
                                            plot([plotVectorXPrevious, plotVectorX], [plotVectorYPrevious, plotVectorY], markerType);  
                                        hold on
                                
                                        % Save current values as old values for the next step
                                        plotVectorXPrevious = plotVectorX;
                                        plotVectorYPrevious = plotVectorY;
                                    end
                            end;  
                    end
                         
               % Plot stats
                if (plotMeanLine == 1)
                    % Now plot the mean IDA, the mean +/- one sigmaRTR IDA, and the mean +/- one sigmaTOTAL IDA
                        % Plot the mean IDA line (the mean responce of the AllVar=Mean run)
                            % Make vectors for the plot
                            saLevelForPlot = zeros(1,length(saLevelsForStripes) + 1);
                            saLevelForPlot(1,2:(length(saLevelsForStripes) + 1)) = saLevelsForStripes;     % Basically just taking the SaLevelLIST, expanding it 
                                                                                                            %   by 1, and adding 0.0 for the first cell
                            meanResponceForPlot = zeros(1,length(saLevelsForStripes) + 1);
                            % Loop for all stripe and populate the vector
                            for stripeIndex = 1:length(saLevelsForStripes)
                                % Put a NAN, do not plot the mean line for
                                % this SA level, if there is less than two
                                % converged results
                                if((length(RDR_max_AllStripes{stripeIndex}.allEQs_withoutNAN)) < minNumOfConvPointsToPlotMeanAndSigmaLines)
                                    % Place a NAN value to stop the plot
                                    % for this Sa level
                                    meanResponceForPlot(1, stripeIndex + 1) = nan;
                                else
                                    % Compute the mean to plot
                                    meanResponceForPlot(1, stripeIndex + 1) = exp(RDR_max_AllStripes{stripeIndex}.MeanLnAllEQs);
                                end
                            end
                           
                        % Do the plot - note that the strange way of doing this is for the spline interpolation
                        hold on
                        meanResponceForPlotX = meanResponceForPlot;
                        saLevelForPlot;
                        saLevelForPlotY = spline(meanResponceForPlot, saLevelForPlot, meanResponceForPlotX);
                        markerType = meanIDAMarkerType;
                        plot(meanResponceForPlotX, saLevelForPlotY, markerType, 'LineWidth', meanLineWidth);

                end
                
                    % Plot variance lines in needed
                    if (plotVarLines == 1)
                    
                    % Now plot the IDA lines for +/- 1.0 sigmaRTR
                        % Note that the SA level for plot is the same as above, so we don't need to compute it.
                        
                        % Compute +/- one sigma RTR IDA lines
                            meanMinusSigmaRTRResponceForPlot = zeros(1,length(saLevelsForStripes) + 1);
                            meanPlusSigmaRTRResponceForPlot = zeros(1,length(saLevelsForStripes) + 1);

                            % Loop for all stripe and populate the vector - Thie leaves a 0 for the first responce value.
                            for stripeIndex = 1:length(saLevelsForStripes)
                                % Put a NAN, do not plot the mean line for
                                % this SA level, if there is less than two
                                % converged results
                                if((length(RDR_max_AllStripes{stripeIndex}.allEQs_withoutNAN)) < minNumOfConvPointsToPlotMeanAndSigmaLines)
                                    % Place a NAN value to stop the plot
                                    % for this Sa level
                                    meanMinusSigmaRTRResponceForPlot(1, stripeIndex + 1) = nan;
                                    meanPlusSigmaRTRResponceForPlot(1, stripeIndex + 1) = nan;
                                else
                                    % Compute the values to plot
                                        % Mean minum sigma
                                        meanMinusSigmaRTRResponceForPlot(1, stripeIndex + 1) = exp(RDR_max_AllStripes{stripeIndex}.MeanLnAllEQs - ...
                                            RDR_max_AllStripes{stripeIndex}.StDevLnAllEQs);
                                    % Mean minum sigma
                                        meanPlusSigmaRTRResponceForPlot(1, stripeIndex + 1) = exp(RDR_max_AllStripes{stripeIndex}.MeanLnAllEQs + ...
                                            RDR_max_AllStripes{stripeIndex}.StDevLnAllEQs);          
                                end
                            end                                                                                                     
                           
                        % Do the plots - note that the strange way of doing this is for the spline interpolation
                        hold on
                        meanMinusSigmaRTRResponceForPlotX = meanMinusSigmaRTRResponceForPlot;
                        saLevelForPlotY = spline(meanMinusSigmaRTRResponceForPlot, saLevelForPlot, meanMinusSigmaRTRResponceForPlotX);
                        markerType = 'b';
                        plot(meanMinusSigmaRTRResponceForPlotX, saLevelForPlotY, varIDAMarkerType, 'LineWidth', varLineWidth);
                    
                        meanPlusSigmaRTRResponceForPlotX = meanPlusSigmaRTRResponceForPlot;
                        saLevelForPlotY = spline(meanPlusSigmaRTRResponceForPlot, saLevelForPlot, meanPlusSigmaRTRResponceForPlotX);
                        markerType = 'b';
                        plot(meanPlusSigmaRTRResponceForPlotX, saLevelForPlotY, varIDAMarkerType, 'LineWidth', varLineWidth);    
                    
                    end
   
                    % Do the final plot details...
                    maxYOnAxis = floor(2.0*(max(saLevelsForStripes) + 0.5)) / 2.0;
                    ylim([0,maxYOnAxis])
                    % Do plot naming, etc...
%                     legendName = sprintf('Single Responces', 'Mean Responce', '+/- One StDev RTR', '+/- One StDev FOSM');
%                     legend(legendName);
                    grid on
                    if(isAddTitle)
                        titleText = sprintf('Incremental Dynamic Analysis for Roof Drift Ratio, %s', meanAnalysisFolder);
                    end
                    title(titleText);
                    if(isConvertToSaKircher == 0)
                        yLabel = sprintf('Sa_{g.m.}(T=%.2f) [g]', periodUsedForScalingGroundMotionsFromMatlab);
                    else
                        DefineSaKircherOverSaGeoMeanValues
                        yLabel = axisLabelForSaKircher;
                    end
                    hy = ylabel(yLabel);
                    xLabel = sprintf('Roof Drift Ratio');
                    hx = xlabel(xLabel);
                    box on
                    FigureFormatScript

                    % Save the current figure
                    plotName = sprintf('IDA_%s_%s_RoofDrift_AbsMax.fig', saTypeForIDAPlotting, eqListForCollapseIDAs_Name);
                    hgsave(plotName)
                    exportName = sprintf('IDA_%s_%s_RoofDrift_AbsMax.emf', saTypeForIDAPlotting, eqListForCollapseIDAs_Name);
                    print('-dmeta', exportName);

                    hold off
                    close
                    figureNum = figureNum + 1;
                
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% END ROOF DRIFT %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

        
        
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% START RESIDUAL ROOF DRIFT %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        % Make the diagrams for all the story drifts...
                figure(figureNum)
                hold on
                % Draw the IDA for each story drift responce
                    % Loop over all EQ's and stripes and plot the single EQ IDA lines...
                    for stripeIndex = 1:length(saLevelsForStripes)
                            for eqIndex = 1:length(RDR_absResidual_AllStripes{stripeIndex}.allEQs)
                                % First initialize old plot vector to zero
                                plotVectorXPrevious = 0;
                                plotVectorYPrevious = 0;

                                    % Plot a circle
                                    markerType = convPointMarkerType;
                                
                                    % Plot the point
                                        plotVectorX = RDR_absResidual_AllStripes{stripeIndex}.allEQs(eqIndex);     % These are the individual EQ responces for the AllVar=Mean run.
                                        plotVectorY = saLevelsForStripes(stripeIndex);  % Just Sa level for stripe
                                        if (plotSingleEQPoints == 1)
                                            plot(plotVectorX, plotVectorY, markerType);
                                        end
                                        grid on
                                        hold on
                                
                                    if (plotSingleEQIDAs == 1)
                                        % Plot a line to connect the new point to the previous point
                                        markerType = singleIDAMarkerType;
                                            plot([plotVectorXPrevious, plotVectorX], [plotVectorYPrevious, plotVectorY], markerType);  
                                        hold on
                                
                                        % Save current values as old values for the next step
                                        plotVectorXPrevious = plotVectorX;
                                        plotVectorYPrevious = plotVectorY;
                                    end
                            end;  
                    end
                         
               % Plot stats
                if (plotMeanLine == 1)
                    % Now plot the mean IDA, the mean +/- one sigmaRTR IDA, and the mean +/- one sigmaTOTAL IDA
                        % Plot the mean IDA line (the mean responce of the AllVar=Mean run)
                            % Make vectors for the plot
                            saLevelForPlot = zeros(1,length(saLevelsForStripes) + 1);
                            saLevelForPlot(1,2:(length(saLevelsForStripes) + 1)) = saLevelsForStripes;     % Basically just taking the SaLevelLIST, expanding it 
                                                                                                            %   by 1, and adding 0.0 for the first cell
                            meanResponceForPlot = zeros(1,length(saLevelsForStripes) + 1);
                            % Loop for all stripe and populate the vector
                            for stripeIndex = 1:length(saLevelsForStripes)
                                % Put a NAN, do not plot the mean line for
                                % this SA level, if there is less than two
                                % converged results
                                if((length(RDR_absResidual_AllStripes{stripeIndex}.allEQs_withoutNAN)) < minNumOfConvPointsToPlotMeanAndSigmaLines)
                                    % Place a NAN value to stop the plot
                                    % for this Sa level
                                    meanResponceForPlot(1, stripeIndex + 1) = nan;
                                else
                                    % Compute the mean to plot
                                    meanResponceForPlot(1, stripeIndex + 1) = exp(RDR_absResidual_AllStripes{stripeIndex}.MeanLnAllEQs);
                                end
                            end
                           
                        % Do the plot - note that the strange way of doing this is for the spline interpolation
                        hold on
                        meanResponceForPlotX = meanResponceForPlot;
                        saLevelForPlot;
                        saLevelForPlotY = spline(meanResponceForPlot, saLevelForPlot, meanResponceForPlotX);
                        markerType = meanIDAMarkerType;
                        plot(meanResponceForPlotX, saLevelForPlotY, markerType, 'LineWidth', meanLineWidth);

                end
                
                    % Plot variance lines in needed
                    if (plotVarLines == 1)
                    
                    % Now plot the IDA lines for +/- 1.0 sigmaRTR
                        % Note that the SA level for plot is the same as above, so we don't need to compute it.
                        
                        % Compute +/- one sigma RTR IDA lines
                            meanMinusSigmaRTRResponceForPlot = zeros(1,length(saLevelsForStripes) + 1);
                            meanPlusSigmaRTRResponceForPlot = zeros(1,length(saLevelsForStripes) + 1);

                            % Loop for all stripe and populate the vector - Thie leaves a 0 for the first responce value.
                            for stripeIndex = 1:length(saLevelsForStripes)
                                % Put a NAN, do not plot the mean line for
                                % this SA level, if there is less than two
                                % converged results
                                if((length(RDR_absResidual_AllStripes{stripeIndex}.allEQs_withoutNAN)) < minNumOfConvPointsToPlotMeanAndSigmaLines)
                                    % Place a NAN value to stop the plot
                                    % for this Sa level
                                    meanMinusSigmaRTRResponceForPlot(1, stripeIndex + 1) = nan;
                                    meanPlusSigmaRTRResponceForPlot(1, stripeIndex + 1) = nan;
                                else
                                    % Compute the values to plot
                                        % Mean minum sigma
                                        meanMinusSigmaRTRResponceForPlot(1, stripeIndex + 1) = exp(RDR_absResidual_AllStripes{stripeIndex}.MeanLnAllEQs - ...
                                            RDR_absResidual_AllStripes{stripeIndex}.StDevLnAllEQs);
                                    % Mean minum sigma
                                        meanPlusSigmaRTRResponceForPlot(1, stripeIndex + 1) = exp(RDR_absResidual_AllStripes{stripeIndex}.MeanLnAllEQs + ...
                                            RDR_absResidual_AllStripes{stripeIndex}.StDevLnAllEQs);          
                                end
                            end                                                                                                     
                           
                        % Do the plots - note that the strange way of doing this is for the spline interpolation
                        hold on
                        meanMinusSigmaRTRResponceForPlotX = meanMinusSigmaRTRResponceForPlot;
                        saLevelForPlotY = spline(meanMinusSigmaRTRResponceForPlot, saLevelForPlot, meanMinusSigmaRTRResponceForPlotX);
                        markerType = 'b';
                        plot(meanMinusSigmaRTRResponceForPlotX, saLevelForPlotY, varIDAMarkerType, 'LineWidth', varLineWidth);
                    
                        meanPlusSigmaRTRResponceForPlotX = meanPlusSigmaRTRResponceForPlot;
                        saLevelForPlotY = spline(meanPlusSigmaRTRResponceForPlot, saLevelForPlot, meanPlusSigmaRTRResponceForPlotX);
                        markerType = 'b';
                        plot(meanPlusSigmaRTRResponceForPlotX, saLevelForPlotY, varIDAMarkerType, 'LineWidth', varLineWidth);    
                    
                    end
   
                    % Do the final plot details...
                    maxYOnAxis = floor(2.0*(max(saLevelsForStripes) + 0.5)) / 2.0;
                    ylim([0,maxYOnAxis])
                    % Do plot naming, etc...
%                     legendName = sprintf('Single Responces', 'Mean Responce', '+/- One StDev RTR', '+/- One StDev FOSM');
%                     legend(legendName);
                    grid on
                    if(isAddTitle)
                        titleText = sprintf('Incremental Dynamic Analysis for Residual Roof Drift Ratio, %s', meanAnalysisFolder);
                    end
                    title(titleText);
                    if(isConvertToSaKircher == 0)
                        yLabel = sprintf('Sa_{g.m.}(T=%.2f) [g]', periodUsedForScalingGroundMotionsFromMatlab);
                    else
                        DefineSaKircherOverSaGeoMeanValues
                        yLabel = axisLabelForSaKircher;
                    end
                    hy = ylabel(yLabel);
                    xLabel = sprintf('Residual Roof Drift Ratio');
                    hx = xlabel(xLabel);
                    box on
                    FigureFormatScript

                    % Save the current figure
                    plotName = sprintf('IDA_%s_%s_RoofDrift_AbsResidual.fig', saTypeForIDAPlotting, eqListForCollapseIDAs_Name);
                    hgsave(plotName)
                    exportName = sprintf('IDA_%s_%s_RoofDrift_AbsResidual.emf', saTypeForIDAPlotting, eqListForCollapseIDAs_Name);
                    print('-dmeta', exportName);

                    hold off
                    close
                    figureNum = figureNum + 1;
                
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% END RESIDUAL ROOF DRIFT %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

        
        
        
        
        
        
        
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% START RESDUAL STORY DRIFTS %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        % Make the diagrams for all the story drifts...
            for storyNum = 1:numStories
                figure(figureNum)
                hold on
                % Draw the IDA for each story drift responce
                    % Loop over all EQ's and stripes and plot the single EQ IDA lines...
                    for stripeIndex = 1:length(saLevelsForStripes)
                            for eqIndex = 1:length(IDR_residual_AllStripes{stripeIndex}{storyNum}.allEQs)
                                % First initialize old plot vector to zero
                                plotVectorXPrevious = 0;
                                plotVectorYPrevious = 0;

                                    % Plot a circle
                                    markerType = convPointMarkerType;
                                
                                    % Plot the point
                                        plotVectorX = IDR_residual_AllStripes{stripeIndex}{storyNum}.allEQs(eqIndex);     % These are the individual EQ responces for the AllVar=Mean run.
                                        plotVectorY = saLevelsForStripes(stripeIndex);  % Just Sa level for stripe
                                        if (plotSingleEQPoints == 1)
                                            plot(plotVectorX, plotVectorY, markerType);
                                        end
                                        grid on
                                        hold on
                                    
                                
                                    if (plotSingleEQIDAs == 1)
                                        % Plot a line to connect the new point to the previous point
                                        markerType = singleIDAMarkerType;
                                            plot([plotVectorXPrevious, plotVectorX], [plotVectorYPrevious, plotVectorY], markerType);  
                                        hold on
                                
                                        % Save current values as old values for the next step
                                        plotVectorXPrevious = plotVectorX;
                                        plotVectorYPrevious = plotVectorY;
                                    end
                            end;  
                    end
                         
               % Plot stats
                if (plotMeanLine == 1)
                    % Now plot the mean IDA, the mean +/- one sigmaRTR IDA, and the mean +/- one sigmaTOTAL IDA
                        % Plot the mean IDA line (the mean responce of the AllVar=Mean run)
                            % Make vectors for the plot
                            saLevelForPlot = zeros(1,length(saLevelsForStripes) + 1);
                            saLevelForPlot(1,2:(length(saLevelsForStripes) + 1)) = saLevelsForStripes;     % Basically just taking the SaLevelLIST, expanding it 
                                                                                                            %   by 1, and adding 0.0 for the first cell
                            meanResponceForPlot = zeros(1,length(saLevelsForStripes) + 1);
                            % Loop for all stripe and populate the vector
                            for stripeIndex = 1:length(saLevelsForStripes)
                                % Put a NAN, do not plot the mean line for
                                % this SA level, if there is less than two
                                % converged results
                                if((length(IDR_residual_AllStripes{stripeIndex}{storyNum}.allEQs_withoutNAN)) < minNumOfConvPointsToPlotMeanAndSigmaLines)
                                    % Place a NAN value to stop the plot
                                    % for this Sa level
                                    meanResponceForPlot(1, stripeIndex + 1) = nan;
                                else
                                    % Compute the mean to plot
                                    meanResponceForPlot(1, stripeIndex + 1) = exp(IDR_residual_AllStripes{stripeIndex}{storyNum}.MeanLnAllEQs);
                                end
                            end
                           
                        % Do the plot - note that the strange way of doing this is for the spline interpolation
                        hold on
                        meanResponceForPlotX = meanResponceForPlot;
                        saLevelForPlot;
                        saLevelForPlotY = spline(meanResponceForPlot, saLevelForPlot, meanResponceForPlotX);
                        markerType = meanIDAMarkerType;
                        plot(meanResponceForPlotX, saLevelForPlotY, markerType, 'LineWidth', meanLineWidth);

                end
                
                    % Plot variance lines in needed
                    if (plotVarLines == 1)
                    
                    % Now plot the IDA lines for +/- 1.0 sigmaRTR
                        % Note that the SA level for plot is the same as above, so we don't need to compute it.
                        
                        % Compute +/- one sigma RTR IDA lines
                            meanMinusSigmaRTRResponceForPlot = zeros(1,length(saLevelsForStripes) + 1);
                            meanPlusSigmaRTRResponceForPlot = zeros(1,length(saLevelsForStripes) + 1);

                            % Loop for all stripe and populate the vector - Thie leaves a 0 for the first responce value.
                            for stripeIndex = 1:length(saLevelsForStripes)
                                % Put a NAN, do not plot the mean line for
                                % this SA level, if there is less than two
                                % converged results
                                if((length(IDR_residual_AllStripes{stripeIndex}{storyNum}.allEQs_withoutNAN)) < minNumOfConvPointsToPlotMeanAndSigmaLines)
                                    % Place a NAN value to stop the plot
                                    % for this Sa level
                                    meanMinusSigmaRTRResponceForPlot(1, stripeIndex + 1) = nan;
                                    meanPlusSigmaRTRResponceForPlot(1, stripeIndex + 1) = nan;
                                else
                                    % Compute the values to plot
                                        % Mean minum sigma
                                        meanMinusSigmaRTRResponceForPlot(1, stripeIndex + 1) = exp(IDR_residual_AllStripes{stripeIndex}{storyNum}.MeanLnAllEQs - ...
                                            IDR_residual_AllStripes{stripeIndex}{storyNum}.StDevLnAllEQs);
                                    % Mean minum sigma
                                        meanPlusSigmaRTRResponceForPlot(1, stripeIndex + 1) = exp(IDR_residual_AllStripes{stripeIndex}{storyNum}.MeanLnAllEQs + ...
                                            IDR_residual_AllStripes{stripeIndex}{storyNum}.StDevLnAllEQs);          
                                end
                            end                                                                                                     
                           
                        % Do the plots - note that the strange way of doing this is for the spline interpolation
                        hold on
                        meanMinusSigmaRTRResponceForPlotX = meanMinusSigmaRTRResponceForPlot;
                        saLevelForPlotY = spline(meanMinusSigmaRTRResponceForPlot, saLevelForPlot, meanMinusSigmaRTRResponceForPlotX);
                        markerType = 'b';
                        plot(meanMinusSigmaRTRResponceForPlotX, saLevelForPlotY, varIDAMarkerType, 'LineWidth', varLineWidth);
                    
                        meanPlusSigmaRTRResponceForPlotX = meanPlusSigmaRTRResponceForPlot;
                        saLevelForPlotY = spline(meanPlusSigmaRTRResponceForPlot, saLevelForPlot, meanPlusSigmaRTRResponceForPlotX);
                        markerType = 'b';
                        plot(meanPlusSigmaRTRResponceForPlotX, saLevelForPlotY, varIDAMarkerType, 'LineWidth', varLineWidth);    
                    
                    end
   
                    % Do the final plot details...
                    maxYOnAxis = floor(2.0*(max(saLevelsForStripes) + 0.5)) / 2.0;
                    ylim([0,maxYOnAxis])
                    % Do plot naming, etc...
%                     legendName = sprintf('Single Responces', 'Mean Responce', '+/- One StDev RTR', '+/- One StDev FOSM');
%                     legend(legendName);
                    grid on
                    if(isAddTitle)
                        titleText = sprintf('');
                    end
                    title(titleText);
                    if(isConvertToSaKircher == 0)
                        yLabel = sprintf('Sa_{g.m.}(T=%.2f) [g]', periodUsedForScalingGroundMotionsFromMatlab);
                    else
                        DefineSaKircherOverSaGeoMeanValues
                        yLabel = axisLabelForSaKircher;
                    end
                    hy = ylabel(yLabel);
                    xLabel = sprintf('Residual Drift: Story %d', storyNum);
                    hx = xlabel(xLabel);
                    box on
                    FigureFormatScript

                    % Save the current figure
                    plotName = sprintf('IDA_%s_%s_ResidualDrift_Story_%d.fig', saTypeForIDAPlotting, eqListForCollapseIDAs_Name, storyNum);
                    hgsave(plotName)
                    exportName = sprintf('IDA_%s_%s_ResidualDrift_Story_%d.emf', saTypeForIDAPlotting, eqListForCollapseIDAs_Name, storyNum);
                    print('-dmeta', exportName);

                    hold off
                    close
                    figureNum = figureNum + 1;
                
            end
                    
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% END RESIDUAL DRIFTS
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        
        
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% START PFA/PGA %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        % Make the diagrams for all the story drifts...
            for floorNum = 1:numFloors
                figure(figureNum)
                hold on
                % Draw the IDA for each story drift responce
                    % Loop over all EQ's and stripes and plot the single EQ IDA lines...
                    for stripeIndex = 1:length(saLevelsForStripes)
                            % Just loop based on length of floor 2 PFA
                            % vector (arbitrary decision to aviod the error
                            % of looking for floor 1 PFA, which is realy
                            % PGA and is not in this PFA variable structure).
                            for eqIndex = 1:length(PFA_AllStripes{stripeIndex}{2}.allEQs)
                                % First initialize old plot vector to zero
                                plotVectorXPrevious = 0;
                                plotVectorYPrevious = 0;

                                    % Plot a circle
                                    markerType = convPointMarkerType;
                                
                                    % Plot the point
                                        if(floorNum == 1)
                                            % Use PGA
                                            plotVectorX = PGAToSave_AllStripes{stripeIndex}.allEQs(eqIndex);     
                                        else
                                            % Use PFA
                                            plotVectorX = PFA_AllStripes{stripeIndex}{floorNum}.allEQs(eqIndex);     
                                        end
                                        plotVectorY = saLevelsForStripes(stripeIndex);  % Just Sa level for stripe
                                        if (plotSingleEQPoints == 1)
                                            plot(plotVectorX, plotVectorY, markerType);
                                        end
                                        grid on
                                        hold on
                                    
                                
                                    if (plotSingleEQIDAs == 1)
                                        % Plot a line to connect the new point to the previous point
                                        markerType = singleIDAMarkerType;
                                            plot([plotVectorXPrevious, plotVectorX], [plotVectorYPrevious, plotVectorY], markerType);  
                                        hold on
                                
                                        % Save current values as old values for the next step
                                        plotVectorXPrevious = plotVectorX;
                                        plotVectorYPrevious = plotVectorY;
                                    end
                            end;  
                    end
                         
               % Plot stats
                if (plotMeanLine == 1)
                    % Now plot the mean IDA, the mean +/- one sigmaRTR IDA, and the mean +/- one sigmaTOTAL IDA
                        % Plot the mean IDA line (the mean responce of the AllVar=Mean run)
                            % Make vectors for the plot
                            saLevelForPlot = zeros(1,length(saLevelsForStripes) + 1);
                            saLevelForPlot(1,2:(length(saLevelsForStripes) + 1)) = saLevelsForStripes;     % Basically just taking the SaLevelLIST, expanding it 
                                                                                                            %   by 1, and adding 0.0 for the first cell
                            meanResponceForPlot = zeros(1,length(saLevelsForStripes) + 1);
                            % Loop for all stripe and populate the vector
                            for stripeIndex = 1:length(saLevelsForStripes)
                                % Put a NAN, do not plot the mean line for
                                % this SA level, if there is less than two
                                % converged results.  Just use floor 2 to
                                % check this (arbitrary decision).
                                if((length(PFA_AllStripes{stripeIndex}{2}.allEQs_withoutNAN)) < minNumOfConvPointsToPlotMeanAndSigmaLines)
                                    % Place a NAN value to stop the plot
                                    % for this Sa level
                                    meanResponceForPlot(1, stripeIndex + 1) = nan;
                                else
                                    % Compute the mean to plot
                                    if(floorNum == 1)
                                        meanResponceForPlot(1, stripeIndex + 1) = exp(PGAToSave_AllStripes{stripeIndex}.MeanLnAllEQs);
                                    else
                                        meanResponceForPlot(1, stripeIndex + 1) = exp(PFA_AllStripes{stripeIndex}{floorNum}.MeanLnAllEQs);
                                    end
                                end
                            end
                           
                        % Do the plot - note that the strange way of doing this is for the spline interpolation
                        hold on
                        meanResponceForPlotX = meanResponceForPlot;
                        saLevelForPlot;
                        saLevelForPlotY = spline(meanResponceForPlot, saLevelForPlot, meanResponceForPlotX);
                        markerType = meanIDAMarkerType;
                        plot(meanResponceForPlotX, saLevelForPlotY, markerType, 'LineWidth', meanLineWidth);

                end
                
                    % Plot variance lines in needed
                    if (plotVarLines == 1)
                    
                    % Now plot the IDA lines for +/- 1.0 sigmaRTR
                        % Note that the SA level for plot is the same as above, so we don't need to compute it.
                        
                        % Compute +/- one sigma RTR IDA lines
                            meanMinusSigmaRTRResponceForPlot = zeros(1,length(saLevelsForStripes) + 1);
                            meanPlusSigmaRTRResponceForPlot = zeros(1,length(saLevelsForStripes) + 1);

                            % Loop for all stripe and populate the vector - Thie leaves a 0 for the first responce value.
                            for stripeIndex = 1:length(saLevelsForStripes)
                                % Put a NAN, do not plot the mean line for
                                % this SA level, if there is less than two
                                % converged results.  Just use floor 2 to
                                % check this (arbitrary decision).
                                if((length(PFA_AllStripes{stripeIndex}{2}.allEQs_withoutNAN)) < minNumOfConvPointsToPlotMeanAndSigmaLines)
                                    % Place a NAN value to stop the plot
                                    % for this Sa level
                                    meanMinusSigmaRTRResponceForPlot(1, stripeIndex + 1) = nan;
                                    meanPlusSigmaRTRResponceForPlot(1, stripeIndex + 1) = nan;
                                else
                                    if(floorNum == 1)
                                        % Compute the values to plot - PGA
                                            % Mean minum sigma
                                            meanMinusSigmaRTRResponceForPlot(1, stripeIndex + 1) = exp(PGAToSave_AllStripes{stripeIndex}.MeanLnAllEQs - ...
                                                PGAToSave_AllStripes{stripeIndex}.StDevLnAllEQs);
                                        % Mean minum sigma
                                            meanPlusSigmaRTRResponceForPlot(1, stripeIndex + 1) = exp(PGAToSave_AllStripes{stripeIndex}.MeanLnAllEQs + ...
                                                PGAToSave_AllStripes{stripeIndex}.StDevLnAllEQs);  
                                    else
                                        % Compute the values to plot - PFA
                                            % Mean minum sigma
                                            meanMinusSigmaRTRResponceForPlot(1, stripeIndex + 1) = exp(PFA_AllStripes{stripeIndex}{floorNum}.MeanLnAllEQs - ...
                                                PFA_AllStripes{stripeIndex}{floorNum}.StDevLnAllEQs);
                                        % Mean minum sigma
                                            meanPlusSigmaRTRResponceForPlot(1, stripeIndex + 1) = exp(PFA_AllStripes{stripeIndex}{floorNum}.MeanLnAllEQs + ...
                                                PFA_AllStripes{stripeIndex}{floorNum}.StDevLnAllEQs);  
                                    end
                                end
                            end                                                                                                     
                           
                        % Do the plots - note that the strange way of doing this is for the spline interpolation
                        hold on
                        meanMinusSigmaRTRResponceForPlotX = meanMinusSigmaRTRResponceForPlot;
                        saLevelForPlotY = spline(meanMinusSigmaRTRResponceForPlot, saLevelForPlot, meanMinusSigmaRTRResponceForPlotX);
                        markerType = 'b';
                        plot(meanMinusSigmaRTRResponceForPlotX, saLevelForPlotY, varIDAMarkerType, 'LineWidth', varLineWidth);
                    
                        meanPlusSigmaRTRResponceForPlotX = meanPlusSigmaRTRResponceForPlot;
                        saLevelForPlotY = spline(meanPlusSigmaRTRResponceForPlot, saLevelForPlot, meanPlusSigmaRTRResponceForPlotX);
                        markerType = 'b';
                        plot(meanPlusSigmaRTRResponceForPlotX, saLevelForPlotY, varIDAMarkerType, 'LineWidth', varLineWidth);    
                    
                    end
   
                    % Do the final plot details...
                    maxYOnAxis = floor(2.0*(max(saLevelsForStripes) + 0.5)) / 2.0;
                    ylim([0,maxYOnAxis])
                    % Do plot naming, etc...
%                     legendName = sprintf('Single Responces', 'Mean Responce', '+/- One StDev RTR', '+/- One StDev FOSM');
%                     legend(legendName);
                    grid on
                    if(isAddTitle)
                        titleText = sprintf('');
                    end
                    title(titleText);
                    if(isConvertToSaKircher == 0)
                        yLabel = sprintf('Sa_{g.m.}(T=%.2f) [g]', periodUsedForScalingGroundMotionsFromMatlab);
                    else
                        DefineSaKircherOverSaGeoMeanValues
                        yLabel = axisLabelForSaKircher;
                    end
                    hy = ylabel(yLabel);
                    xLabel = sprintf('Peak Acceleration [g]: Floor %d', floorNum);
                    hx = xlabel(xLabel);
                    box on
                    FigureFormatScript

                    % Save the current figure
                    plotName = sprintf('IDA_%s_%s_PeakFloorAccel_Floor_%d.fig', saTypeForIDAPlotting, eqListForCollapseIDAs_Name, floorNum);
                    hgsave(plotName)
                    exportName = sprintf('IDA_%s_%s_PeakFloorAccel_Floor_%d.emf', saTypeForIDAPlotting, eqListForCollapseIDAs_Name, floorNum);
                    print('-dmeta', exportName);

                    hold off
                    close
                    figureNum = figureNum + 1;
                
            end
                    
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% END PFA/PGA
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% START PEAK BEAM PLASTIC ROTATION IN FULL FRAME  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        % Make the diagrams for all the story drifts...
                figure(figureNum)
                hold on
                % Draw the IDA for each story drift responce
                    % Loop over all EQ's and stripes and plot the single EQ IDA lines...
                    for stripeIndex = 1:length(saLevelsForStripes)
                            for eqIndex = 1:length(beamAbsMaxPHR_maxAllFloors_AllStripes{stripeIndex}.allEQs)
                                % First initialize old plot vector to zero
                                plotVectorXPrevious = 0;
                                plotVectorYPrevious = 0;

                                    % Plot a circle
                                    markerType = convPointMarkerType;
                                
                                    % Plot the point
                                        plotVectorX = beamAbsMaxPHR_maxAllFloors_AllStripes{stripeIndex}.allEQs(eqIndex);     % These are the individual EQ responces for the AllVar=Mean run.
                                        plotVectorY = saLevelsForStripes(stripeIndex);  % Just Sa level for stripe
                                        if (plotSingleEQPoints == 1)
                                            plot(plotVectorX, plotVectorY, markerType);
                                        end
                                        grid on
                                        hold on
                                
                                    if (plotSingleEQIDAs == 1)
                                        % Plot a line to connect the new point to the previous point
                                        markerType = singleIDAMarkerType;
                                            plot([plotVectorXPrevious, plotVectorX], [plotVectorYPrevious, plotVectorY], markerType);  
                                        hold on
                                
                                        % Save current values as old values for the next step
                                        plotVectorXPrevious = plotVectorX;
                                        plotVectorYPrevious = plotVectorY;
                                    end
                            end;  
                    end
                         
               % Plot stats
                if (plotMeanLine == 1)
                    % Now plot the mean IDA, the mean +/- one sigmaRTR IDA, and the mean +/- one sigmaTOTAL IDA
                        % Plot the mean IDA line (the mean responce of the AllVar=Mean run)
                            % Make vectors for the plot
                            saLevelForPlot = zeros(1,length(saLevelsForStripes) + 1);
                            saLevelForPlot(1,2:(length(saLevelsForStripes) + 1)) = saLevelsForStripes;     % Basically just taking the SaLevelLIST, expanding it 
                                                                                                            %   by 1, and adding 0.0 for the first cell
                            meanResponceForPlot = zeros(1,length(saLevelsForStripes) + 1);
                            % Loop for all stripe and populate the vector
                            for stripeIndex = 1:length(saLevelsForStripes)
                                % Put a NAN, do not plot the mean line for
                                % this SA level, if there is less than two
                                % converged results
                                if((length(beamAbsMaxPHR_maxAllFloors_AllStripes{stripeIndex}.allEQs_withoutNAN)) < minNumOfConvPointsToPlotMeanAndSigmaLines)
                                    % Place a NAN value to stop the plot
                                    % for this Sa level
                                    meanResponceForPlot(1, stripeIndex + 1) = nan;
                                else
                                    % Compute the mean to plot
                                    meanResponceForPlot(1, stripeIndex + 1) = exp(beamAbsMaxPHR_maxAllFloors_AllStripes{stripeIndex}.MeanLnAllEQs);
                                end
                            end
                           
                        % Do the plot - note that the strange way of doing this is for the spline interpolation
                        hold on
                        meanResponceForPlotX = meanResponceForPlot;
                        saLevelForPlot;
                        saLevelForPlotY = spline(meanResponceForPlot, saLevelForPlot, meanResponceForPlotX);
                        markerType = meanIDAMarkerType;
                        plot(meanResponceForPlotX, saLevelForPlotY, markerType, 'LineWidth', meanLineWidth);

                end
                
                    % Plot variance lines in needed
                    if (plotVarLines == 1)
                    
                    % Now plot the IDA lines for +/- 1.0 sigmaRTR
                        % Note that the SA level for plot is the same as above, so we don't need to compute it.
                        
                        % Compute +/- one sigma RTR IDA lines
                            meanMinusSigmaRTRResponceForPlot = zeros(1,length(saLevelsForStripes) + 1);
                            meanPlusSigmaRTRResponceForPlot = zeros(1,length(saLevelsForStripes) + 1);

                            % Loop for all stripe and populate the vector - Thie leaves a 0 for the first responce value.
                            for stripeIndex = 1:length(saLevelsForStripes)
                                % Put a NAN, do not plot the mean line for
                                % this SA level, if there is less than two
                                % converged results
                                if((length(beamAbsMaxPHR_maxAllFloors_AllStripes{stripeIndex}.allEQs_withoutNAN)) < minNumOfConvPointsToPlotMeanAndSigmaLines)
                                    % Place a NAN value to stop the plot
                                    % for this Sa level
                                    meanMinusSigmaRTRResponceForPlot(1, stripeIndex + 1) = nan;
                                    meanPlusSigmaRTRResponceForPlot(1, stripeIndex + 1) = nan;
                                else
                                    % Compute the values to plot
                                        % Mean minum sigma
                                        meanMinusSigmaRTRResponceForPlot(1, stripeIndex + 1) = exp(beamAbsMaxPHR_maxAllFloors_AllStripes{stripeIndex}.MeanLnAllEQs - ...
                                            beamAbsMaxPHR_maxAllFloors_AllStripes{stripeIndex}.StDevLnAllEQs);
                                    % Mean minum sigma
                                        meanPlusSigmaRTRResponceForPlot(1, stripeIndex + 1) = exp(beamAbsMaxPHR_maxAllFloors_AllStripes{stripeIndex}.MeanLnAllEQs + ...
                                            beamAbsMaxPHR_maxAllFloors_AllStripes{stripeIndex}.StDevLnAllEQs);          
                                end
                            end                                                                                                     
                           
                        % Do the plots - note that the strange way of doing this is for the spline interpolation
                        hold on
                        meanMinusSigmaRTRResponceForPlotX = meanMinusSigmaRTRResponceForPlot;
                        saLevelForPlotY = spline(meanMinusSigmaRTRResponceForPlot, saLevelForPlot, meanMinusSigmaRTRResponceForPlotX);
                        markerType = 'b';
                        plot(meanMinusSigmaRTRResponceForPlotX, saLevelForPlotY, varIDAMarkerType, 'LineWidth', varLineWidth);
                    
                        meanPlusSigmaRTRResponceForPlotX = meanPlusSigmaRTRResponceForPlot;
                        saLevelForPlotY = spline(meanPlusSigmaRTRResponceForPlot, saLevelForPlot, meanPlusSigmaRTRResponceForPlotX);
                        markerType = 'b';
                        plot(meanPlusSigmaRTRResponceForPlotX, saLevelForPlotY, varIDAMarkerType, 'LineWidth', varLineWidth);    
                    
                    end
   
                    % Do the final plot details...
                    maxYOnAxis = floor(2.0*(max(saLevelsForStripes) + 0.5)) / 2.0;
                    ylim([0,maxYOnAxis])
                    % Do plot naming, etc...
%                     legendName = sprintf('Single Responces', 'Mean Responce', '+/- One StDev RTR', '+/- One StDev FOSM');
%                     legend(legendName);
                    grid on
                    if(isAddTitle)
                        titleText = sprintf('Incremental Dynamic Analysis for Peak Beam Plastic Rotation in Full Frame, %s', meanAnalysisFolder);
                    end
                    title(titleText);
                    if(isConvertToSaKircher == 0)
                        yLabel = sprintf('Sa_{g.m.}(T=%.2f) [g]', periodUsedForScalingGroundMotionsFromMatlab);
                    else
                        DefineSaKircherOverSaGeoMeanValues
                        yLabel = axisLabelForSaKircher;
                    end
                    hy = ylabel(yLabel);
                    xLabel = sprintf('Peak Beam PHR in Building [rad]');
                    hx = xlabel(xLabel);
                    box on
                    FigureFormatScript

                    % Save the current figure
                    plotName = sprintf('IDA_%s_%s_BeamPHR_MaxFullBldg.fig', saTypeForIDAPlotting, eqListForCollapseIDAs_Name);
                    hgsave(plotName)
                    exportName = sprintf('IDA_%s_%s_BeamPHR_MaxFullBldg.emf', saTypeForIDAPlotting, eqListForCollapseIDAs_Name);
                    print('-dmeta', exportName);

                    hold off
                    close
                    figureNum = figureNum + 1;
                
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% END PEAK BEAM PLASTIC ROTATION IN FULL FRAME %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% START PEAK COLUMN PLASTIC ROTATION IN FULL FRAME  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        % Make the diagrams for all the story drifts...
                figure(figureNum)
                hold on
                % Draw the IDA for each story drift responce
                    % Loop over all EQ's and stripes and plot the single EQ IDA lines...
                    for stripeIndex = 1:length(saLevelsForStripes)
                            for eqIndex = 1:length(columnAbsMaxPHR_maxAllStories_AllStripes{stripeIndex}.allEQs)
                                % First initialize old plot vector to zero
                                plotVectorXPrevious = 0;
                                plotVectorYPrevious = 0;

                                    % Plot a circle
                                    markerType = convPointMarkerType;
                                
                                    % Plot the point
                                        plotVectorX = columnAbsMaxPHR_maxAllStories_AllStripes{stripeIndex}.allEQs(eqIndex);     % These are the individual EQ responces for the AllVar=Mean run.
                                        plotVectorY = saLevelsForStripes(stripeIndex);  % Just Sa level for stripe
                                        if (plotSingleEQPoints == 1)
                                            plot(plotVectorX, plotVectorY, markerType);
                                        end
                                        grid on
                                        hold on
                                
                                    if (plotSingleEQIDAs == 1)
                                        % Plot a line to connect the new point to the previous point
                                        markerType = singleIDAMarkerType;
                                            plot([plotVectorXPrevious, plotVectorX], [plotVectorYPrevious, plotVectorY], markerType);  
                                        hold on
                                
                                        % Save current values as old values for the next step
                                        plotVectorXPrevious = plotVectorX;
                                        plotVectorYPrevious = plotVectorY;
                                    end
                            end;  
                    end
                         
               % Plot stats
                if (plotMeanLine == 1)
                    % Now plot the mean IDA, the mean +/- one sigmaRTR IDA, and the mean +/- one sigmaTOTAL IDA
                        % Plot the mean IDA line (the mean responce of the AllVar=Mean run)
                            % Make vectors for the plot
                            saLevelForPlot = zeros(1,length(saLevelsForStripes) + 1);
                            saLevelForPlot(1,2:(length(saLevelsForStripes) + 1)) = saLevelsForStripes;     % Basically just taking the SaLevelLIST, expanding it 
                                                                                                            %   by 1, and adding 0.0 for the first cell
                            meanResponceForPlot = zeros(1,length(saLevelsForStripes) + 1);
                            % Loop for all stripe and populate the vector
                            for stripeIndex = 1:length(saLevelsForStripes)
                                % Put a NAN, do not plot the mean line for
                                % this SA level, if there is less than two
                                % converged results
                                if((length(columnAbsMaxPHR_maxAllStories_AllStripes{stripeIndex}.allEQs_withoutNAN)) < minNumOfConvPointsToPlotMeanAndSigmaLines)
                                    % Place a NAN value to stop the plot
                                    % for this Sa level
                                    meanResponceForPlot(1, stripeIndex + 1) = nan;
                                else
                                    % Compute the mean to plot
                                    meanResponceForPlot(1, stripeIndex + 1) = exp(columnAbsMaxPHR_maxAllStories_AllStripes{stripeIndex}.MeanLnAllEQs);
                                end
                            end
                           
                        % Do the plot - note that the strange way of doing this is for the spline interpolation
                        hold on
                        meanResponceForPlotX = meanResponceForPlot;
                        saLevelForPlot;
                        saLevelForPlotY = spline(meanResponceForPlot, saLevelForPlot, meanResponceForPlotX);
                        markerType = meanIDAMarkerType;
                        plot(meanResponceForPlotX, saLevelForPlotY, markerType, 'LineWidth', meanLineWidth);

                end
                
                    % Plot variance lines in needed
                    if (plotVarLines == 1)
                    
                    % Now plot the IDA lines for +/- 1.0 sigmaRTR
                        % Note that the SA level for plot is the same as above, so we don't need to compute it.
                        
                        % Compute +/- one sigma RTR IDA lines
                            meanMinusSigmaRTRResponceForPlot = zeros(1,length(saLevelsForStripes) + 1);
                            meanPlusSigmaRTRResponceForPlot = zeros(1,length(saLevelsForStripes) + 1);

                            % Loop for all stripe and populate the vector - Thie leaves a 0 for the first responce value.
                            for stripeIndex = 1:length(saLevelsForStripes)
                                % Put a NAN, do not plot the mean line for
                                % this SA level, if there is less than two
                                % converged results
                                if((length(columnAbsMaxPHR_maxAllStories_AllStripes{stripeIndex}.allEQs_withoutNAN)) < minNumOfConvPointsToPlotMeanAndSigmaLines)
                                    % Place a NAN value to stop the plot
                                    % for this Sa level
                                    meanMinusSigmaRTRResponceForPlot(1, stripeIndex + 1) = nan;
                                    meanPlusSigmaRTRResponceForPlot(1, stripeIndex + 1) = nan;
                                else
                                    % Compute the values to plot
                                        % Mean minum sigma
                                        meanMinusSigmaRTRResponceForPlot(1, stripeIndex + 1) = exp(columnAbsMaxPHR_maxAllStories_AllStripes{stripeIndex}.MeanLnAllEQs - ...
                                            columnAbsMaxPHR_maxAllStories_AllStripes{stripeIndex}.StDevLnAllEQs);
                                    % Mean minum sigma
                                        meanPlusSigmaRTRResponceForPlot(1, stripeIndex + 1) = exp(columnAbsMaxPHR_maxAllStories_AllStripes{stripeIndex}.MeanLnAllEQs + ...
                                            columnAbsMaxPHR_maxAllStories_AllStripes{stripeIndex}.StDevLnAllEQs);          
                                end
                            end                                                                                                     
                           
                        % Do the plots - note that the strange way of doing this is for the spline interpolation
                        hold on
                        meanMinusSigmaRTRResponceForPlotX = meanMinusSigmaRTRResponceForPlot;
                        saLevelForPlotY = spline(meanMinusSigmaRTRResponceForPlot, saLevelForPlot, meanMinusSigmaRTRResponceForPlotX);
                        markerType = 'b';
                        plot(meanMinusSigmaRTRResponceForPlotX, saLevelForPlotY, varIDAMarkerType, 'LineWidth', varLineWidth);
                    
                        meanPlusSigmaRTRResponceForPlotX = meanPlusSigmaRTRResponceForPlot;
                        saLevelForPlotY = spline(meanPlusSigmaRTRResponceForPlot, saLevelForPlot, meanPlusSigmaRTRResponceForPlotX);
                        markerType = 'b';
                        plot(meanPlusSigmaRTRResponceForPlotX, saLevelForPlotY, varIDAMarkerType, 'LineWidth', varLineWidth);    
                    
                    end
   
                    % Do the final plot details...
                    maxYOnAxis = floor(2.0*(max(saLevelsForStripes) + 0.5)) / 2.0;
                    ylim([0,maxYOnAxis])
                    % Do plot naming, etc...
%                     legendName = sprintf('Single Responces', 'Mean Responce', '+/- One StDev RTR', '+/- One StDev FOSM');
%                     legend(legendName);
                    grid on
                    if(isAddTitle)
                        titleText = sprintf('Incremental Dynamic Analysis for Peak Columns Plastic Rotation in Full Frame, %s', meanAnalysisFolder);
                    end
                    title(titleText);
                    if(isConvertToSaKircher == 0)
                        yLabel = sprintf('Sa_{g.m.}(T=%.2f) [g]', periodUsedForScalingGroundMotionsFromMatlab);
                    else
                        DefineSaKircherOverSaGeoMeanValues
                        yLabel = axisLabelForSaKircher;
                    end
                    hy = ylabel(yLabel);
                    xLabel = sprintf('Peak Column PHR in Building [rad]');
                    hx = xlabel(xLabel);
                    box on
                    FigureFormatScript

                    % Save the current figure
                    plotName = sprintf('IDA_%s_%s_ColumnPHR_MaxFullBldg.fig', saTypeForIDAPlotting, eqListForCollapseIDAs_Name);
                    hgsave(plotName)
                    exportName = sprintf('IDA_%s_%s_ColumnPHR_MaxFullBldg.emf', saTypeForIDAPlotting, eqListForCollapseIDAs_Name);
                    print('-dmeta', exportName);

                    hold off
                    close
                    figureNum = figureNum + 1;
                
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% END PEAK COLUMN PLASTIC ROTATION IN FULL FRAME %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% START PEAK JOINT PANEL SHEAR DISTORTION IN FULL FRAME  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        
        
        % NOTICE: I put that the units are RADIANS (shear strain), but I
        % need to double check that this is what is coing out of
        % Altoontash's recorder! (7-25-06 CBH)
        
        % Make the diagrams for all the story drifts...
                figure(figureNum)
                hold on
                % Draw the IDA for each story drift responce
                    % Loop over all EQ's and stripes and plot the single EQ IDA lines...
                    for stripeIndex = 1:length(saLevelsForStripes)
                            for eqIndex = 1:length(jointShearDistortionAbsMax_maxAllFloors_AllStripes{stripeIndex}.allEQs)
                                % First initialize old plot vector to zero
                                plotVectorXPrevious = 0;
                                plotVectorYPrevious = 0;

                                    % Plot a circle
                                    markerType = convPointMarkerType;
                                
                                    % Plot the point
                                        plotVectorX = jointShearDistortionAbsMax_maxAllFloors_AllStripes{stripeIndex}.allEQs(eqIndex);     % These are the individual EQ responces for the AllVar=Mean run.
                                        plotVectorY = saLevelsForStripes(stripeIndex);  % Just Sa level for stripe
                                        if (plotSingleEQPoints == 1)
                                            plot(plotVectorX, plotVectorY, markerType);
                                        end
                                        grid on
                                        hold on
                                
                                    if (plotSingleEQIDAs == 1)
                                        % Plot a line to connect the new point to the previous point
                                        markerType = singleIDAMarkerType;
                                            plot([plotVectorXPrevious, plotVectorX], [plotVectorYPrevious, plotVectorY], markerType);  
                                        hold on
                                
                                        % Save current values as old values for the next step
                                        plotVectorXPrevious = plotVectorX;
                                        plotVectorYPrevious = plotVectorY;
                                    end
                            end;  
                    end
                         
               % Plot stats
                if (plotMeanLine == 1)
                    % Now plot the mean IDA, the mean +/- one sigmaRTR IDA, and the mean +/- one sigmaTOTAL IDA
                        % Plot the mean IDA line (the mean responce of the AllVar=Mean run)
                            % Make vectors for the plot
                            saLevelForPlot = zeros(1,length(saLevelsForStripes) + 1);
                            saLevelForPlot(1,2:(length(saLevelsForStripes) + 1)) = saLevelsForStripes;     % Basically just taking the SaLevelLIST, expanding it 
                                                                                                            %   by 1, and adding 0.0 for the first cell
                            meanResponceForPlot = zeros(1,length(saLevelsForStripes) + 1);
                            % Loop for all stripe and populate the vector
                            for stripeIndex = 1:length(saLevelsForStripes)
                                % Put a NAN, do not plot the mean line for
                                % this SA level, if there is less than two
                                % converged results
                                if((length(jointShearDistortionAbsMax_maxAllFloors_AllStripes{stripeIndex}.allEQs_withoutNAN)) < minNumOfConvPointsToPlotMeanAndSigmaLines)
                                    % Place a NAN value to stop the plot
                                    % for this Sa level
                                    meanResponceForPlot(1, stripeIndex + 1) = nan;
                                else
                                    % Compute the mean to plot
                                    meanResponceForPlot(1, stripeIndex + 1) = exp(jointShearDistortionAbsMax_maxAllFloors_AllStripes{stripeIndex}.MeanLnAllEQs);
                                end
                            end
                           
                        % Do the plot - note that the strange way of doing this is for the spline interpolation
                        hold on
                        meanResponceForPlotX = meanResponceForPlot;
                        saLevelForPlot;
                        saLevelForPlotY = spline(meanResponceForPlot, saLevelForPlot, meanResponceForPlotX);
                        markerType = meanIDAMarkerType;
                        plot(meanResponceForPlotX, saLevelForPlotY, markerType, 'LineWidth', meanLineWidth);

                end
                
                    % Plot variance lines in needed
                    if (plotVarLines == 1)
                    
                    % Now plot the IDA lines for +/- 1.0 sigmaRTR
                        % Note that the SA level for plot is the same as above, so we don't need to compute it.
                        
                        % Compute +/- one sigma RTR IDA lines
                            meanMinusSigmaRTRResponceForPlot = zeros(1,length(saLevelsForStripes) + 1);
                            meanPlusSigmaRTRResponceForPlot = zeros(1,length(saLevelsForStripes) + 1);

                            % Loop for all stripe and populate the vector - Thie leaves a 0 for the first responce value.
                            for stripeIndex = 1:length(saLevelsForStripes)
                                % Put a NAN, do not plot the mean line for
                                % this SA level, if there is less than two
                                % converged results
                                if((length(jointShearDistortionAbsMax_maxAllFloors_AllStripes{stripeIndex}.allEQs_withoutNAN)) < minNumOfConvPointsToPlotMeanAndSigmaLines)
                                    % Place a NAN value to stop the plot
                                    % for this Sa level
                                    meanMinusSigmaRTRResponceForPlot(1, stripeIndex + 1) = nan;
                                    meanPlusSigmaRTRResponceForPlot(1, stripeIndex + 1) = nan;
                                else
                                    % Compute the values to plot
                                        % Mean minum sigma
                                        meanMinusSigmaRTRResponceForPlot(1, stripeIndex + 1) = exp(jointShearDistortionAbsMax_maxAllFloors_AllStripes{stripeIndex}.MeanLnAllEQs - ...
                                            jointShearDistortionAbsMax_maxAllFloors_AllStripes{stripeIndex}.StDevLnAllEQs);
                                    % Mean minum sigma
                                        meanPlusSigmaRTRResponceForPlot(1, stripeIndex + 1) = exp(jointShearDistortionAbsMax_maxAllFloors_AllStripes{stripeIndex}.MeanLnAllEQs + ...
                                            jointShearDistortionAbsMax_maxAllFloors_AllStripes{stripeIndex}.StDevLnAllEQs);          
                                end
                            end                                                                                                     
                           
                        % Do the plots - note that the strange way of doing this is for the spline interpolation
                        hold on
                        meanMinusSigmaRTRResponceForPlotX = meanMinusSigmaRTRResponceForPlot;
                        saLevelForPlotY = spline(meanMinusSigmaRTRResponceForPlot, saLevelForPlot, meanMinusSigmaRTRResponceForPlotX);
                        markerType = 'b';
                        plot(meanMinusSigmaRTRResponceForPlotX, saLevelForPlotY, varIDAMarkerType, 'LineWidth', varLineWidth);
                    
                        meanPlusSigmaRTRResponceForPlotX = meanPlusSigmaRTRResponceForPlot;
                        saLevelForPlotY = spline(meanPlusSigmaRTRResponceForPlot, saLevelForPlot, meanPlusSigmaRTRResponceForPlotX);
                        markerType = 'b';
                        plot(meanPlusSigmaRTRResponceForPlotX, saLevelForPlotY, varIDAMarkerType, 'LineWidth', varLineWidth);    
                    
                    end
   
                    % Do the final plot details...
                    maxYOnAxis = floor(2.0*(max(saLevelsForStripes) + 0.5)) / 2.0;
                    ylim([0,maxYOnAxis])
                    % Do plot naming, etc...
%                     legendName = sprintf('Single Responces', 'Mean Responce', '+/- One StDev RTR', '+/- One StDev FOSM');
%                     legend(legendName);
                    grid on
                    if(isAddTitle)
                        titleText = sprintf('Incremental Dynamic Analysis for Peak Joint Shear Panel Distortion in Full Frame, %s', meanAnalysisFolder);
                    end
                    title(titleText);
                    if(isConvertToSaKircher == 0)
                        yLabel = sprintf('Sa_{g.m.}(T=%.2f) [g]', periodUsedForScalingGroundMotionsFromMatlab);
                    else
                        DefineSaKircherOverSaGeoMeanValues
                        yLabel = axisLabelForSaKircher;
                    end
                    hy = ylabel(yLabel);
                    xLabel = sprintf('Peak Joint Shear Dist. in Bldg. [rad]');
                    hx = xlabel(xLabel);
                    box on
                    FigureFormatScript

                    % Save the current figure
                    plotName = sprintf('IDA_%s_%s_JointShearDistortion_MaxFullBldg.fig', saTypeForIDAPlotting, eqListForCollapseIDAs_Name);
                    hgsave(plotName)
                    exportName = sprintf('IDA_%s_%s_JointShearDistortion_MaxFullBldg.emf', saTypeForIDAPlotting, eqListForCollapseIDAs_Name);
                    print('-dmeta', exportName);

                    hold off
                    close
                    figureNum = figureNum + 1;
                
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% END PEAK JOINT PANEL SHEAR DISTORTION IN FULL FRAME %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

        
        
        
        
        
        
        

% Get back to starting folder
cd ..;

disp('IDA Processing Finished.');







