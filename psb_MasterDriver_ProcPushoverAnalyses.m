%
% Procedure: MasterDriver_ProcessPushoverAnalyses.m
% -------------------
% This processes the pushover (monotonic and cyclic) analyses, then
% makes/saves all of the results.
%
% Assumptions and Notices: 
%   - none
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


clear; % DO NOT REMOVE THIS COMMAND. BECAUSE WE SAVE THE MATLAB SPACE AT THE END AND WHATEVER IS THERE IN THE MATSPACE BEFORE ANALYSIS IS RUN WILL BE SAVED. 
tic 

baseFolder = pwd;

fileNameLIST = {'ID2433_R5_5Story_v.02';}; 

% Set the options for processing and plotting
% Stuff to change
eqNumber_PO = 9991;                     % 9991 for monotonic, 9992 for cyclic
runOpenSees_and_ProcResults = 1;        % no need to execute OpenSees, and process it (say, for debugging the plottins)
isProcessPOAnalysis = 1;                % no need to process, if once processed (& say, code is being re-run to generate new plots)

isPlotPO = 1;                           % 1- Yes plot it. 0- No, do not plot it
plotRoofDriftRatio = 1;                 % Plot roof drift ratio instead of roof displacement.
determinePeriodBasedDuctility = 1;      % (10-28-15, PSB) FEMA-P695 sec 6.3 to find out period-based ductility

isPlotStoryPO = 0;                      % This plots the story POs versus story shear and base shear both.  The 
                                        % processors that this calls were fixed and updated by CBH on 6-16-08.
storyNumLIST = 1;                       % Stories to plot story PO

isPlotPOMaxDriftLevel = 1;              % Interstorydrift ratio vs Floor number 
                                        % Max drifts over PO

maxNumPoints = 10000000;                % Large number does not limit the length of the plot       
markerType_PO = 'b-';
lineWidth_PO = 3;
% plotDefoShape = 1;                    % plot deformed shape

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
% No need to change this stuff
poModelType = 2;                        % Always use 2; 1 for nlBmCol/dispBmCol, 2 for lumpedPlast
saTOneForRun_PO = 0.00;                 % Always use 0.00


runDifferentPushoverPatterns = [
                                  0.4401491  0.3248811  0.3024556
                                  0.2886080  0.2630745  0.2696329
                                  0.1689272  0.2012678  0.2124970
                                  0.0811068  0.1394612  0.1456358
                                  0.0212089  0.0713154  0.0697788
                                ];                              
patternNames = {'Parabolic','Linear','Mode Shape'};

numSPO_patterns = size(runDifferentPushoverPatterns, 2);

shearHingeOrNot = 0; % if there is a shear Hinge then different opensees file is used; using 1 would always work 
                     % but may not be the fastest in case of haselton-type models with flexural-only hinges

if runOpenSees_and_ProcResults == 1
    for SPO_index = 1:numSPO_patterns
        setenv('SPO_INDEX', num2str(SPO_index));  % set env var
        fprintf('Running SPO_index = %d, using pattern_%d\n', SPO_index, SPO_index);
        system('echo %SPO_INDEX%');  % verify environment variable
        
    
        for buildingIndex = 1:size(fileNameLIST, 1)
            % for buildingIndex = 7
            fileName = fileNameLIST{buildingIndex, 1};
       
            % Define building information - change this for the building being used
            analysisType_forPO = sprintf('(%s)_(AllVar)_(0.00)_(clough)', fileName);
            % currentPushoverPattern = runDifferentPushoverPatterns(:, buildingIndex); 
    
            cd ("Models")
            cd (fileName)
    
            % (21-Oct-2025, sks) write the current pushover pattern to psb_definePushoverLoading.tcl 
            % sks_writePushoverLoading(runDifferentPushoverPatterns);
            sks_writePushoverLoading(runDifferentPushoverPatterns, SPO_index);  % Pass SPO_index!
    
            fprintf('Running %i/%i... Building: %s  \n', buildingIndex, length(fileNameLIST), fileName);
            %writeAFunction_to_pass_on_pushoverPattern_to_tcl_file_basically_update_DefinePushoverLoading_tcl
            if shearHingeOrNot == 0
                if ~exist('C:\temp', 'dir')
                mkdir('C:\temp');
                end
                % Pass SPO_INDEX directly to OpenSees command line
                system(sprintf('set SPO_INDEX=%d && OpenSees psb_RunMeanAnalysis.tcl > C:\\temp\\outp_SPO%d.txt 2>&1', SPO_index, SPO_index));
            else
                system(sprintf('set SPO_INDEX=%d && OpenSees_64-kNmmMPa-PSB-11-01-16 psb_RunMeanAnalysis.tcl > C:\\temp\\outp_SPO%d.txt 2>&1', SPO_index, SPO_index));
            end
    
    
            % if shearHingeOrNot == 0
            %     !OpenSees psb_RunMeanAnalysis.tcl > "C:\Users\Shivakumar K S\OneDrive\Desktop\outp_opensees_2025_.txt" 2>&1
            % else
            %     !OpenSees_64-kNmmMPa-PSB-11-01-16 psb_RunMeanAnalysis.tcl > "C:\Users\Shivakumar K S\OneDrive\Desktop\outp_opensees_2025_.txt" 2>&1
            % end
    
    
        cd(baseFolder)
    
        %% comment out above portion, if only plotting of the pushover curve is required to be done
    
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        % Call the procedure to do the processing and plotting
            cd psb_MatlabProcessors
            [plotArrayAndBaseShearArray, mu_T] = ProcessAndPlotPushoverAnalyses_proc(analysisType_forPO, isProcessPOAnalysis, poModelType, saTOneForRun_PO, ...
                                            eqNumber_PO, isPlotPO, plotRoofDriftRatio, maxNumPoints, markerType_PO, lineWidth_PO, isPlotStoryPO, ...
                                            storyNumLIST, isPlotPOMaxDriftLevel, determinePeriodBasedDuctility, SPO_index);
            cd ..
        %     (6-1-16, PSB) store oushover results to plot together
            cd Output
            cd(analysisType_forPO)
            SPO_dataFileName = sprintf('DATA_pushover_%i.mat', SPO_index);
            save(SPO_dataFileName);
            cd ..\..
            close;
            close;
        end
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        % Call the procedure to plot the deformed shape
        plotDefoShape = 0;   % 0 = do not plot deformed shape, 1 = plot deformed shape
        if plotDefoShape == 1
            fprintf('Plotting deformed shape...\n');
                % Go to visual processors folder
                cd psb_MatlabProcessors\MovieAndVisualProcessors
    
            for buildingIndex = 1:size(fileNameLIST, 1)
                fileName = fileNameLIST{buildingIndex, 1};
                understorePos = strfind(fileName, '_');
                bldgID_LIST(1, buildingIndex) = str2double(fileName(3:understorePos(1)-1));
                analysisDirLIST{buildingIndex, 1} = sprintf('(%s)_(AllVar)_(0.00)_(clough)', fileName);
            end
                driftPlotOption = 2;    % Plot the drifts at the last time step of the analysis (to show the collapse mechanism better), 1- undeformed building
                maxOnDemandCapacityRatioToPlot = 3.0;   % Limit the demand/capacity ratio to 3, so the plots won't be too crazy at collapse.
                pushoverStepNameIdentifier = 'lastStep'; 
                psb_pushoverDeformedShape(bldgID_LIST, analysisDirLIST, driftPlotOption, maxOnDemandCapacityRatioToPlot, pushoverStepNameIdentifier);
    
                cd ..\..
        end
    end % (13-Oct-25) closing the loop for different pushover patterns 
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%% Run sks_PushoverPlots.m for Combined plots (11-12-2025)%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

sks_PushoverPlots(analysisType_forPO, runDifferentPushoverPatterns, patternNames); % It is script file, 

toc


