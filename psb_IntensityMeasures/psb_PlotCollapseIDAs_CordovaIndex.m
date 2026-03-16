function [alpha, periodRat] = psb_PlotCollapseIDAs_CordovaIndex(analysisTypeFolder, eqNumberLIST, eqListForCollapseIDAs_Name, markerTypeLine, markerTypeDot, isPlotIndividualPoints, collapseDriftThreshold, T1, dampRat, optimizeCordovaParams, processAllComp, alphaDefault, periodRatDefault, doPlotSaveCAlpha)
baseFolder = pwd; 
% eqNumberLIST_forProcessing_SetC = [120111, 120112, 120121, 120122,	120411, 120412,	120521, 120522,	120611, 120612,	120621, 120622,	120711, 120712,	120721, 120722,	120811, 120812,	120821, 120822,	120911, 120912,	120921, 120922,	121011, 121012,	121021, 121022,	121111, 121112,	121211, 121212,	121221, 121222,	121321, 121322,	121411, 121412,	121421, 121422,	121511, 121512,	121711, 121712];
% eqListForCollapseIDAs_Name_SetC = 'GMSetC';
% eqNumberLIST_forCollapseIDAs_SetC = [12011	12012	12041	12052	12061	12062	12071	12072	12081	12082	12091	12092	12101	12102	12111	12121	12122	12132	12141	12142	12151	12171];
% 
% analysisTypeFolder = '(CivilBldg_3story_ID9901_v.02_trying)_(AllVar)_(0.00)_(clough)';
% eqNumberLIST = eqNumberLIST_forCollapseIDAs_SetC;
% eqListForCollapseIDAs_Name = eqListForCollapseIDAs_Name_SetC;
% markerTypeLine = 'b';
% markerTypeDot = 'bo';
% isPlotIndividualPoints = 1;
% collapseDriftThreshold = 0.12;
% T1 = 1.02;
% dampRat = 0.05;
% 
% processAllComp = 1; % 1- all component; 0- control component
% saveMatFile = 1; % 1- Aye! save it; 0- Nay! don't save it
% doPlotSaveCDF = 1; % 1- plotCDF and save it
% doPlotSaveCAlpha = 1; % 1- plot optimum C-alpha and optimum sigma graphs

% alphaDefault = 0.60; % now importing from the output of psb_OptimizeCordovaParametersAndPlotCDF 
% periodRatDefault = 2.50;

% optimizeCordovaParams = 0; % 1- yes optimize it for minimu sigma value. 0-  use standard value of 2.0 and 0.5

if optimizeCordovaParams == 1
    [periodRat, alpha] = psb_OptimizeCordovaParameters(analysisTypeFolder, eqListForCollapseIDAs_Name, T1, dampRat, processAllComp, doPlotSaveCAlpha);
else
    periodRat = periodRatDefault; alpha = alphaDefault;
end

% Input what max drift value you want on X axis for the plot
maxXOnAxis = 0.10; %0.30;
figureNumAllComp = 1;           % Plot of results for all components
figureNumControllingComp = 2;   % Plot of results for only controlling components
ControllingCompNumLIST =[];
dampRat = 0.05; % This is used when converting to Sa,Kircher

% Initialize a vector - twice as long as the eqNumerLIST b/c I do two comp. per EQ
collapseLevelForAllComp = zeros(1,(2.0*length(eqNumberLIST)));   
collapseLevelForControllingComp = zeros(1,(length(eqNumberLIST)));   
eqCompNumberLIST = zeros(1,(2.0*length(eqNumberLIST))); 
eqCompInd = 1;

for eqInd = 1:(length(eqNumberLIST))
    eqNumber = eqNumberLIST(eqInd);
   
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%%%%%%% START: Loop for component 1 of the EQ %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    eqCompNumber = eqNumber * 10.0 + 1.0;
    eqCompNumberLIST(eqCompInd) = eqCompNumber;

    % Go to the correct folder
        cd ..
        cd Output;
        cd(analysisTypeFolder);

        eqFolder = sprintf('EQ_%.0f', eqCompNumber);
        cd(eqFolder)

    % Open the file that has the collapse data
        load('DATA_collapseIDAPlotDataForThisEQ.mat');
        collapseLevelFromFileOpened = collapseSaLevel;
        clear collapseSaLevel;  % I don't want to use this value in the file that comes from when I ran the collapse analysis.  This value is slightly inaccurate in some cases.
        load('DATA_CollapseResultsForThisSingleEQ.mat', 'toleranceAchieved', 'periodUsedForScalingGroundMotions');
        
    % Save collapse level for all EQs - this is from what is saved when the collapse run is done - DO NOT USE THIS RESULT FOR COMPUTATIONS!!!
        eqCompNumber;

        cordovaLevelsForIDAPlotLIST = psb_retrieveCordovaIM(saLevelsForIDAPlotLIST, eqCompNumber, dampRat, T1, alpha, periodRat); % this is an array, just like saLevelsForIDAPlotLIST is

    % Process the vector of IDA results to remove the results for singular or non-converegd records...
        % Loop through the vectors from the file that was opened and only put the results in the 
        %   plot vector if they are converged (if it's not collapsed) and non-singular (if it's not collapsed)
        subLoopIndex = 1;
        for loopIndex = 1:length(maxDriftRatioForPlotLIST)
            if((isCollapsedLIST(loopIndex) == 0) && (isSingularLIST(loopIndex) || isNonConvLIST(loopIndex)))
                % If this is the case, don't add it to the plot list
            else
                % If we get here, we are okay, so add it to the plot list
                maxDriftRatioForPlotPROCLISTC1(subLoopIndex) = maxDriftRatioForPlotLIST(loopIndex);
%                 SaLevelsForIDAPlotPROCLISTC1(subLoopIndex) = saLevelsForIDAPlotLIST(loopIndex);
                cordovaLevelsForIDAPlotPROCLISTC1(subLoopIndex) = cordovaLevelsForIDAPlotLIST(loopIndex);
                %isCollapseLISTPROCC1(subLoopIndex) = isCollapsedLIST(loopIndex);
                subLoopIndex = subLoopIndex + 1;
            end
        end
        
%         maxDriftRatioForPlotPROCLISTC1
%         cordovaLevelsForIDAPlotPROCLISTC1
        
    % Plot - note that the psuedoTimeVector is from the file that was opened 
            figure(figureNumAllComp);
            plot(maxDriftRatioForPlotPROCLISTC1, cordovaLevelsForIDAPlotPROCLISTC1, markerTypeLine);
        
        % Plot the points for each run, if told to
        if(isPlotIndividualPoints == 1)
            for i = 1:length(cordovaLevelsForIDAPlotPROCLISTC1)
                hold on
                    plot(maxDriftRatioForPlotPROCLISTC1(i), cordovaLevelsForIDAPlotPROCLISTC1(i), markerTypeDot);
            end 
        end
        
        % Find the collapse Sa level for the component and save it.  Loop to find the collapse point, then average the Sa level just 
        %   below and just above the collapse point.
            % Loop to get to the collapse point
            for index = 1:length(maxDriftRatioForPlotPROCLISTC1)
                if(maxDriftRatioForPlotPROCLISTC1(index) > collapseDriftThreshold) 
                    break;    
                end
            end
            
            %%collapseLevelCompOne = (saLevelsForIDAPlotPROCLISTC1(index) +
            %%saLevelsForIDAPlotPROCLISTC1(index - 1)) / 2.0;
            % Take average and call that the collapse capacity.  If one
            % value is over 15 (this happens when there was a convergence
            % error it looks like), then just use the minimum of the two
            % values. (altered on 0-28-05)
            if(max(abs(cordovaLevelsForIDAPlotPROCLISTC1(index)), abs(cordovaLevelsForIDAPlotPROCLISTC1(index - 1))) < 15.0);
                % Compute it the normal way
                collapseLevelCompOne = (cordovaLevelsForIDAPlotPROCLISTC1(index) + cordovaLevelsForIDAPlotPROCLISTC1(index - 1)) / 2.0;
            else
                disp('***********************************');
                disp('******* Fixing error **************');
                disp('***********************************');
                toleranceAchieved
                % If this error has occured, just take the Sa value just
                % before the error and call this the collapse (the minimim
                % of the two values)
                collapseLevelCompOne = min(abs(cordovaLevelsForIDAPlotPROCLISTC1(index)), abs(cordovaLevelsForIDAPlotPROCLISTC1(index - 1)));
            end
            
%             % Sometimes there is an error where the first value after collapse in the processor is 100, so if the collapse Sa level is over 50, then just use the 
%             %   collapse Sa level from the file that was opened.
%                 if(collapseLevelCompOne > 50.0)
%                     collapseLevelCompOne = collapseLevelFromFileOpened;
%                 end

            collapseLevelCompOne;
            collapseSaLevel = collapseLevelCompOne;
            collapseLevelForAllComp(eqCompInd) = collapseLevelCompOne;

        % Save a file for this EQ component
            % Rename variables to be general to either component 1 or 2
            maxDriftRatioForPlotPROCLIST = maxDriftRatioForPlotPROCLISTC1;
            cordovaLevelsForIDAPlotPROCLIST = cordovaLevelsForIDAPlotPROCLISTC1;
            % Save file
%             eqCompColFileName = sprintf('DATA_collapse_Cordova_ProcessedIDADataForThisEQ.mat');
%             save(eqCompColFileName, 'analysisTypeFolder', 'maxDriftRatioForPlotPROCLIST', 'cordovaLevelsForIDAPlotPROCLIST', 'collapseSaLevel');        
            save DATA_collapse_Cordova_ProcessedIDADataForThisEQ.mat analysisTypeFolder maxDriftRatioForPlotPROCLIST cordovaLevelsForIDAPlotPROCLIST collapseSaLevel;        
            
        % Clear the results from the last loop (i.e. extracted data from EQ specific mat file)
        clear maxDriftRatioForPlotLIST saLevelsForIDAPlotLIST
 
        % Go back to the analysisTyoeFolder in output i.e. one folder backwards
        cd ..;
       
        eqCompInd = eqCompInd + 1;
        
    %%%%%%%%%%%%% END: Loop for component 1 of the EQ %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    %%%%%%%%%%%%% START: Loop for component 2 of the EQ %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    eqCompNumber = eqNumber * 10.0 + 2.0;
    eqCompNumberLIST(eqCompInd) = eqCompNumber;


    % Go to the correct folder
        eqFolder = sprintf('EQ_%.0f', eqCompNumber);
        cd(eqFolder)

    % Open the file that has the collapse data
        load('DATA_collapseIDAPlotDataForThisEQ.mat');
        collapseLevelFromFileOpened = collapseSaLevel;
        clear collapseSaLevel;  % I don't want to use this value in the file that comes from when I ran the collapse analysis.  This value is slightly inaccurate in some cases.
        
    % Save collapse level for all EQs - this is from what is saved when the collapse run is done.
        eqCompNumber;
        cordovaLevelsForIDAPlotLIST = psb_retrieveCordovaIM(saLevelsForIDAPlotLIST, eqCompNumber, dampRat, T1, alpha, periodRat); % this is an array, just like saLevelsForIDAPlotLIST is
        
        % Process the vector of IDA results to remove the results for singular or non-converegd records...
        % Loop through the vectors from the file that was opened and only put the results in the 
        %   plot vector if they are converged (if it's not collapsed) and non-singular (if it's not collapsed)
        subLoopIndex = 1;
        for loopIndex = 1:length(maxDriftRatioForPlotLIST)
            if((isCollapsedLIST(loopIndex) == 0) && (isSingularLIST(loopIndex) || isNonConvLIST(loopIndex)))
                % If this is the case, don't add it to th eplot list
            else
                % If we get here, we are okay, so add it to the plot list
                maxDriftRatioForPlotPROCLISTC2(subLoopIndex) = maxDriftRatioForPlotLIST(loopIndex);
%                 saLevelsForIDAPlotPROCLISTC2(subLoopIndex) = saLevelsForIDAPlotLIST(loopIndex);
                cordovaLevelsForIDAPlotPROCLISTC2(subLoopIndex) = cordovaLevelsForIDAPlotLIST(loopIndex);
                %isCollapseLISTPROCC2(subLoopIndex) = isCollapsedLIST(loopIndex);
                
                subLoopIndex = subLoopIndex + 1;
            end

        end
    
    % Plot - note that the psuedoTimeVector is from the file that was opened 
        figure(figureNumAllComp);        
        plot(maxDriftRatioForPlotPROCLISTC2, cordovaLevelsForIDAPlotPROCLISTC2, markerTypeLine);
        
        % Plot the points for each run, if told to
        if(isPlotIndividualPoints == 1)
            for i = 1:length(cordovaLevelsForIDAPlotPROCLISTC2)
                hold on
                plot(maxDriftRatioForPlotPROCLISTC2(i), cordovaLevelsForIDAPlotPROCLISTC2(i), markerTypeDot);
            end 
        end
        
        % Find the collapse Sa level for the component and save it.  Loop to find the collapse point, then average the Sa level just 
        %   below and just above the collapse point.
            % Loop to get to the collapse point
            for index = 1:length(maxDriftRatioForPlotPROCLISTC2)
                if(maxDriftRatioForPlotPROCLISTC2(index) > collapseDriftThreshold) 
                    break;    
                end
            end
            
            % Take average and call that the collapse capacity.  If one
            % value is over 15 (this happens when there was a convergence
            % error it looks like), then just use the minimum of the two
            % values. (altered on 0-28-05)
            if(max(abs(cordovaLevelsForIDAPlotPROCLISTC2(index)), abs(cordovaLevelsForIDAPlotPROCLISTC2(index - 1))) < 15.0);
                % Compute it the normal way
                collapseLevelCompTwo = (cordovaLevelsForIDAPlotPROCLISTC2(index) + cordovaLevelsForIDAPlotPROCLISTC2(index - 1)) / 2.0;
            else
                disp('***********************************');
                disp('******* Fixing error **************');
                disp('***********************************');
                toleranceAchieved
                % If this error has occured, just take the Sa value just
                % before the error and call this the collapse (the minimim
                % of the two values)
                collapseLevelCompTwo = min(abs(cordovaLevelsForIDAPlotPROCLISTC2(index)), abs(cordovaLevelsForIDAPlotPROCLISTC2(index - 1)));
            end    
            
%             % Sometimes there is an error where the first value after collapse in the processor is 100, so if the collapse Sa level is over 50, then just use the 
%             %   collapse Sa level from the file that was opened.
%                 if(collapseLevelCompTwo > 50.0)
%                     collapseLevelCompTwo = collapseLevelFromFileOpened;
%                 end
                
            collapseLevelCompTwo;
            collapseSaLevel = collapseLevelCompTwo;
            collapseLevelForAllComp(eqCompInd) = collapseLevelCompTwo;
        
        % Save a file for this EQ component
            % Rename variables to be general to either component 1 or 2
            maxDriftRatioForPlotPROCLIST = maxDriftRatioForPlotPROCLISTC2;
            cordovaLevelsForIDAPlotPROCLIST = cordovaLevelsForIDAPlotPROCLISTC2;
            % Save file
%             eqCompColFileName = sprintf('DATA_collapse_Cordova_ProcessedIDADataForThisEQ.mat');
%             save(eqCompColFileName, 'analysisTypeFolder', 'maxDriftRatioForPlotPROCLIST', 'cordovaLevelsForIDAPlotPROCLIST', 'collapseSaLevel');        
            save DATA_collapse_Cordova_ProcessedIDADataForThisEQ.mat analysisTypeFolder maxDriftRatioForPlotPROCLIST cordovaLevelsForIDAPlotPROCLIST collapseSaLevel;        
        
        % Clear the results from the last loop
        clear maxDriftRatioForPlotLIST saLevelsForIDAPlotLIST
 
        % Go back to the analysisTyoeFolder in output i.e. one folder backwards        cd ..;
        cd ..
        cd ..
        
        eqCompInd = eqCompInd + 1;
        
    %%%%%%%%%%%%% END: Loop for component 2 of the EQ %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
       
    %%%%%%%%%%%%%% START: Find component that controls the buiding collapse capacity and plot this on the second plot
    
    % Find the EQ component that controls and plot the controlling component
    if(collapseLevelCompTwo > collapseLevelCompOne)
        temp = sprintf('EQ: %d - component 1 controls, SaCollapse = %0.2f', eqNumber, collapseLevelCompOne);
        disp(temp);
        
        % Plot - note that the psuedoTimeVector is from the file that was opened 
            figure(figureNumControllingComp);
            plot(maxDriftRatioForPlotPROCLISTC1, cordovaLevelsForIDAPlotPROCLISTC1, markerTypeLine);
            
            % Plot the points for each run, if told to
            if(isPlotIndividualPoints == 1)
                for i = 1:length(cordovaLevelsForIDAPlotPROCLISTC1)
                    hold on
                    plot(maxDriftRatioForPlotPROCLISTC1(i), cordovaLevelsForIDAPlotPROCLISTC1(i), markerTypeDot);
                end 
            end

        % Save the collapse capacity for this controlling component
        collapseLevelForAllControlComp(eqInd) = collapseLevelCompOne;
        ControllingCompNumLIST = [[ControllingCompNumLIST] (eqNumber*10+1)];    
            
            
    else
        temp = sprintf('EQ: %d - component 2 controls, SaCollapse = %0.2f', eqNumber, collapseLevelCompTwo);
        disp(temp);

        % Plot - note that the psuedoTimeVector is from the file that was opened 
            figure(figureNumControllingComp);
            plot(maxDriftRatioForPlotPROCLISTC2, cordovaLevelsForIDAPlotPROCLISTC2, markerTypeLine);
           
            % Plot the points for each run, if told to
            if(isPlotIndividualPoints == 1)
                for i = 1:length(cordovaLevelsForIDAPlotPROCLISTC2)
                    hold on
                    plot(maxDriftRatioForPlotPROCLISTC2(i), cordovaLevelsForIDAPlotPROCLISTC2(i), markerTypeDot);
                end 
            end

        % Save the collapse capacity for this controlling component
        collapseLevelForAllControlComp(eqInd) = collapseLevelCompTwo;
        ControllingCompNumLIST = [[ControllingCompNumLIST] (eqNumber*10+2)];
            
    end
    
    
    %%%%%%%%%%%%%% END: Find component that controls the buiding collapse capacity and plot this on the seconds plot

    
    clear collapseSaLevelCompOne collapseSaLevelCompTwo isCollapseLISTPROCC1 maxDriftRatioForPlotPROCLISTC1 cordovaLevelsForIDAPlotPROCLISTC1 isCollapseLISTPROCC2 maxDriftRatioForPlotPROCLISTC2 cordovaLevelsForIDAPlotPROCLISTC2;
    
end

% Do collapse statistics - for all components
    analysisTypeFolder;
    meanCollapseSaTOneAllComp = mean(collapseLevelForAllComp);
    medianCollapseSaTOneAllComp = (median(collapseLevelForAllComp));
    meanLnCollapseSaTOneAllComp = mean(log(collapseLevelForAllComp));
    stDevCollapseSaTOneAllComp = std(collapseLevelForAllComp);
    stDevLnCollapseSaTOneAllComp = std(log(collapseLevelForAllComp));
    
% Do collapse statistics - for controlling components
    analysisTypeFolder;
    meanCollapseSaTOneControlComp = mean(collapseLevelForAllControlComp);
    medianCollapseSaTOneControlComp = (median(collapseLevelForAllControlComp));
    meanLnCollapseSaTOneControlComp = mean(log(collapseLevelForAllControlComp));
    stDevCollapseSaTOneControlComp = std(collapseLevelForAllControlComp);
    stDevLnCollapseSaTOneControlComp = std(log(collapseLevelForAllControlComp));
    
% Save collapse results file
    % Go to the correct folder
%         cd Output; 

        
    % Save results in analysisTypeFolder
        cd(analysisTypeFolder);
        colFileName = sprintf('DATA_collapse_CORDOVA_CollapseSaAndStats_%s_SaGeoMean.mat', eqListForCollapseIDAs_Name);

        save(colFileName, 'analysisTypeFolder', 'collapseLevelForAllComp', 'collapseLevelForAllControlComp', 'eqNumberLIST', 'meanCollapseSaTOneAllComp',...
            'medianCollapseSaTOneAllComp', 'meanLnCollapseSaTOneAllComp', 'stDevCollapseSaTOneAllComp',...
            'stDevLnCollapseSaTOneAllComp', 'meanCollapseSaTOneControlComp', 'medianCollapseSaTOneControlComp',...
            'meanLnCollapseSaTOneControlComp', 'stDevCollapseSaTOneControlComp', 'stDevLnCollapseSaTOneControlComp', ...
            'eqCompNumberLIST', 'ControllingCompNumLIST', 'periodUsedForScalingGroundMotions', 'periodRat', 'alpha');

% Do final plot details - figure for all components
        figure(figureNumAllComp);
        hold on
        grid on
        
        str1 = '$IDR_{max}$';
        str3 = sprintf('Incremental Dynamic Analysis, ALL Components');
        hx = xlabel(str1, 'Interpreter', 'latex');
        hy = ylabel('anything');
        htitle = title(str3);

%         set(hy, 'Interpreter', 'latex', 'string', '$Sa_{cordova} = Sa_{T1} * (Sa_{Tf} / Sa_{T1}) ^ \alpha $');
        set(hy, 'Interpreter', 'latex', 'string', '$Sa_{cordova}$');

        xlim([0, maxXOnAxis])
        psb_FigureFormatScript
        
        % Save the plot
            plotName = sprintf('CollapseIDA_AllComp_CORDOVAIndex.fig');
            hgsave(plotName);
            exportName = sprintf('CollapseIDA_AllComp_CORDOVAIndex.eps');
            print('-depsc', exportName);
            
            disp(['IDA saved as ' fullfile(pwd, exportName)]);
        
        hold off

% Do final plot details - figure for controlling components
        figure(figureNumControllingComp);
        hold on
        grid on

        str1 = '$IDR_{max}$';
        str3 = sprintf('Incremental Dynamic Analysis, ONLY Controlling Component');
        hx = xlabel(str1, 'Interpreter', 'latex');
        hy = ylabel('anything');
        htitle = title(str3);
        
%         set(hy, 'Interpreter', 'latex', 'string', '$Sa_{cordova} = Sa_{T1} * (Sa_{Tf} / Sa_{T1}) ^ \alpha $');
        set(hy, 'Interpreter', 'latex', 'string', '$Sa_{cordova}$');

        xlim([0, maxXOnAxis])
        psb_FigureFormatScript
        
        % Save the plot
            plotName = sprintf('CollapseIDA_ControlComp_CORDOVA.fig');
            hgsave(plotName);

            exportName = sprintf('CollapseIDA_ControlComp_CORDOVA.eps');
            print('-depsc', exportName);
            
        hold off
        
        cd(baseFolder)
