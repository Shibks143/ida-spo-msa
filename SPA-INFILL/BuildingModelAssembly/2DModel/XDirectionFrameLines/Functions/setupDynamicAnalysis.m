% This function is used to setup root tcl files for running dynamic
% analysis
function setupDynamicAnalysis(BuildingModelDirectory,buildingGeometry,...
    dynamicAnalysisParameters,dynamicPropertiesObject,FrameLineNumber) 

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%      Define Root Tcl File for Running Single Scale Dynamic Analysis     %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    % Define directory where OpenSees model tcl files are stored
    FrameLineModelFolder = sprintf('Line_%d',FrameLineNumber);
    AnalysisModelDirectory = strcat(BuildingModelDirectory,...
        '\OpenSees2DModels\XDirectionFrameLines\',FrameLineModelFolder,...
        '\DynamicAnalysis');
    
    % Go to directory where tcl files are located
    cd(AnalysisModelDirectory)
    
    % Tcl file to be updated
    original_OpenSees_file = ('RunSingleScale2DModel.tcl');
    
    %Tcl file with updated parameters
    updated_OpenSees_file = ('RunSingleScale2DModelFinal.tcl');
    
    % Open tcl file to be updated
    fileID = fopen(original_OpenSees_file);

    % Read original file data into vector 
    fileData = fread(fileID);
    
    % Update ground motion parameters
    fileData = strrep(fileData,'*NumberOfGroundMotions*',...
            num2str(dynamicAnalysisParameters. ...
            NumberOfUniDirectionGroundMotions));
    fileData = strrep(fileData,'*SingleScaleToRun*',...
            num2str(dynamicAnalysisParameters.SingleScaleToRun));
    fileData = strrep(fileData,'*MCEScaleFactor*',...
            num2str(dynamicAnalysisParameters.UniDirectionMCEScaleFactor));
        
    % Model dynamic properties
    fileData = strrep(fileData,'*firstModePeriod*',...
        num2str(dynamicPropertiesObject.modalPeriods3DModel(1)));
    fileData = strrep(fileData,'*thirdModePeriod*',...
        num2str(dynamicPropertiesObject.modalPeriods3DModel(3)));
    
    % Open tcl file to write updated parameters
    updatedDataFile = fopen(updated_OpenSees_file,'w');

    % Write file with updated parameters
    fprintf(updatedDataFile,'%c',fileData);

    % Close all files
    fclose('all');
    
    
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%      Define Root Tcl File for Running Incremental Dynamic Analysis      %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

     % Tcl file to be updated
    original_OpenSees_file = ('RunIDA2DModel.tcl');
    
    %Tcl file with updated parameters
    updated_OpenSees_file = ('RunIDA2DModelFinal.tcl');
    
    % Open tcl file to be updated
    fileID = fopen(original_OpenSees_file);

    % Read original file data into vector 
    fileData = fread(fileID);
    
    % Update ground motion parameters
    fileData = strrep(fileData,'*NumberOfGroundMotions*',...
            num2str(dynamicAnalysisParameters. ...
            NumberOfUniDirectionGroundMotions));
    fileData = strrep(fileData,'*AllScales*',...
            num2str((dynamicAnalysisParameters.scalesForIDA)'));
    fileData = strrep(fileData,'*MCEScaleFactor*',...
            num2str(dynamicAnalysisParameters.UniDirectionMCEScaleFactor));
        
    % Model dynamic properties
    fileData = strrep(fileData,'*firstModePeriod*',...
        num2str(dynamicPropertiesObject.modalPeriods3DModel(1)));
    fileData = strrep(fileData,'*thirdModePeriod*',...
        num2str(dynamicPropertiesObject.modalPeriods3DModel(3)));
    
    % Open tcl file to write updated parameters
    updatedDataFile = fopen(updated_OpenSees_file,'w');

    % Write file with updated parameters
    fprintf(updatedDataFile,'%c',fileData);

    % Close all files
    fclose('all');
    
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%            Define Root Tcl File for Running Incremental Dynamic         %
%                           Analysis to Collapse                          %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

     % Tcl file to be updated
    original_OpenSees_file = ('RunIDAToCollapse2DModel.tcl');
    
    %Tcl file with updated parameters
    updated_OpenSees_file = ('RunIDAToCollapse2DModelFinal.tcl');
    
    % Open tcl file to be updated
    fileID = fopen(original_OpenSees_file);

    % Read original file data into vector 
    fileData = fread(fileID);
    
    % Update ground motion parameters
    fileData = strrep(fileData,'*NumberOfGroundMotions*',...
            num2str(dynamicAnalysisParameters. ...
            NumberOfUniDirectionGroundMotions));
    fileData = strrep(fileData,...
            '*InitialGroundMotionIncrementScaleForCollapse*',...
            num2str(dynamicAnalysisParameters. ...
            InitialGroundMotionIncrementScaleForCollapse));
    fileData = strrep(fileData,...
            '*ReducedGroundMotionIncrementScaleForCollapse*',...
            num2str(dynamicAnalysisParameters. ...
            ReducedGroundMotionIncrementScaleForCollapse));
    fileData = strrep(fileData,'*MCEScaleFactor*',...
            num2str(dynamicAnalysisParameters.UniDirectionMCEScaleFactor));
        
    % Model dynamic properties
    fileData = strrep(fileData,'*firstModePeriod*',...
        num2str(dynamicPropertiesObject.modalPeriods3DModel(1)));
    fileData = strrep(fileData,'*thirdModePeriod*',...
        num2str(dynamicPropertiesObject.modalPeriods3DModel(3)));
    
    % Collapse criteria
    fileData = strrep(fileData,'*CollapseDriftLimit*',...
        num2str(dynamicAnalysisParameters.CollapseDriftLimit));
    
    % Update geometry parameters
    fileData = strrep(fileData,'*nStories*',...
        num2str(buildingGeometry.numberOfStories));
    fileData = strrep(fileData,'*nColumns*',...
        num2str((buildingGeometry.numberOfXBays + 1)*...
        (buildingGeometry.numberOfZBays + 1)));
    
    % Open tcl file to write updated parameters
    updatedDataFile = fopen(updated_OpenSees_file,'w');

    % Write file with updated parameters
    fprintf(updatedDataFile,'%c',fileData);

    % Close all files
    fclose('all');
    

end