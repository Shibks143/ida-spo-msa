
clear; % DO NOT REMOVE THIS COMMAND. BECAUSE WE SAVE THE MATLAB SPACE AT THE END AND WHATEVER IS THERE IN THE MATSPACE BEFORE ANALYSIS IS RUN WILL BE SAVED. 
tic 

baseFolder = pwd;

fileNameLIST = {'model_1';
                'model_2';
}; 

shearHingeOrNot = 0; % if there is a shear Hinge then different opensees file is used; using 1 would always work 
                     % but may not be the fastest in case of haselton-type models with flexural-only hinges

plotDefoShape = 1;                    % plot deformed shape

for buildingIndex = 1:size(fileNameLIST, 1)
% for buildingIndex = 7
    fileName = fileNameLIST{buildingIndex, 1};

% cd I:\PrakRuns_I\Models\
% cd K:\Models\
cd Models\
cd(fileName)

% !OpenSees_32-kNmmMPa-PSB-18-10-16 psb_RunMeanAnalysis.tcl
% !OpenSees_2.5.0_32bit psb_RunMeanAnalysis.tcl
% !opensees_2.5.0 psb_RunMeanAnalysis.tcl
% !OpenSees_64-kNmmMPa-PSB-22-10-16 psb_RunMeanAnalysis.tcl  % DO NOT USE, it's very slow due to selection of the built solution in "debug mode" in Visual Studio 

% !OpenSees_64-kNmmMPa-PSB-10-24-16-RELEASE psb_RunMeanAnalysis.tcl 
% !OpenSees_64-kNmmMPa-PSB-11-01-16 psb_RunMeanAnalysis.tcl > "C:\Users\Prakash\Desktop\outp_NEW.txt" 2>&1

fprintf('Running %i/%i... Building: %s  \n', buildingIndex, length(fileNameLIST), fileName);
!OpenSees psb_RunMeanAnalysis.tcl > "C:\Users\sks\OneDrive\Desktop\outp_temp1.txt" 2>&1

cd(baseFolder)


%% comment out above portion, if only plotting of the pushover curve is required to be done

%
% Procedure: MasterDriver_ProcessPushoverAnalyses.m
% -------------------
% This processes the pushover (monotonic and cyclic) analyses, then
% makes/saves all of the results.
%
% Assumptions and Notices: 
%   - none
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
baseFolder = pwd;

% Define building information - change this for the building being used

analysisType_forPO = sprintf('(%s)_(AllVar)_(0.00)_(clough)', fileName);

% Set the options for processing and plotting
    % Stuff to change
    eqNumber_PO = 9991;                     % 9991 for monotonic, 9992 for cyclic
    isProcessPOAnalysis = 1;                % no need to process, if once processed (& say, code is being re-run to generate new plots)
    
    isPlotPO = 1;                           % 1- Yes plot it. 0- No, do not plot it
    plotRoofDriftRatio = 1;                 % Plot roof drift ratio instead of roof displacement.
    determinePeriodBasedDuctility = 1;      % (10-28-15, PSB) FEMA-P695 sec 6.3 to find out period-based ductility
    
    isPlotStoryPO = 0;                      % This plots the story POs versus story shear and base shear both.  The 
                                            %   processors that this calls were fixed and updated by CBH on 6-16-08.
    storyNumLIST = [2];                     % Stories to plot story PO
    
    isPlotPOMaxDriftLevel = 1;              % Interstorydrift ratio vs Floor number 
                                            % Max drifts over PO
    
    maxNumPoints = 10000000;                % Large number does not limit the length of the plot       
    markerType_PO = 'b-';
    lineWidth_PO = 3;
%     plotDefoShape = 1;                    % plot deformed shape
    
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
    % No need to change this stuff
    poModelType = 2;                        % Always use 2; 1 for nlBmCol/dispBmCol, 2 for lumpedPlast
    saTOneForRun_PO = 0.00;                 % Always use 0.00
    
    
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Call the procedure to do the processing and plotting
    cd psb_MatlabProcessors
    [plotArrayAndBaseShearArray, mu_T] = ProcessAndPlotPushoverAnalyses_proc(analysisType_forPO, isProcessPOAnalysis, poModelType, saTOneForRun_PO, ...
                                    eqNumber_PO, isPlotPO, plotRoofDriftRatio, maxNumPoints, markerType_PO, lineWidth_PO, isPlotStoryPO, ...
                                    storyNumLIST, isPlotPOMaxDriftLevel, determinePeriodBasedDuctility);
    cd ..
%     (6-1-16, PSB) store oushover results to plot together
    cd Output
    cd(analysisType_forPO)
    save('DATA_pushover.mat');
    cd ..\..
    close;
    close;
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Call the procedure to plot the deformed shape
if plotDefoShape == 1
    fprintf('Plotting deformed shape...\n');
        % Go to visual processors folder
        cd psb_MatlabProcessors\MovieAndVisualProcessors
    for buildingIndex = 1:size(fileNameLIST, 1)
        fileName = fileNameLIST{buildingIndex, 1};
        bldgID_LIST(1, buildingIndex) = str2double(fileName(3:strfind(fileName, '_')-1));
        analysisDirLIST{buildingIndex, 1} = sprintf('(%s)_(AllVar)_(0.00)_(clough)', fileName);
    end
        driftPlotOption = 2;    % Plot the drifts at the last time step of the analysis (to show the collapse mechanism better), 1- undeformed building
        maxOnDemandCapacityRatioToPlot = 3.0;   % Limit the demand/capacity ratio to 3, so the plots won't be too crazy at collapse.
        pushoverStepNameIdentifier = 'lastStep'; 

        psb_pushoverDeformedShape(bldgID_LIST, analysisDirLIST, driftPlotOption, maxOnDemandCapacityRatioToPlot, pushoverStepNameIdentifier);

        cd ..\..
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
   toc