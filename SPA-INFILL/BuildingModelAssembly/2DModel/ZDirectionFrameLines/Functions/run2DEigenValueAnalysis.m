% This function is used to run an eigen value analysis for an OpenSees 
% model
function run2DEigenValueAnalysis(BuildingModelDirectory,FrameLineNumber,...
    BuildingModelDataDirectory,dynamicPropertiesObject)    

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                       Run Eigen Value Analysis                          %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    % Frame line folder
    FrameLineModelFolder = sprintf('Line_%d',FrameLineNumber);

    % Define directory where OpenSees model tcl files are stored
    AnalysisModelDirectory = strcat(BuildingModelDirectory,...
        '\OpenSees2DModels\ZDirectionFrameLines\',FrameLineModelFolder,...
        '\EigenValueAnalysis');
    
    cd(AnalysisModelDirectory)

    % Run eigen value analysis
    !OpenSees Model.tcl
    
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%              Extract Modal Periods from Eigen Value Analysis            %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    % Define folder where modal periods are stored
    ModalPeriodsFolder = strcat(BuildingModelDirectory,...
        '\OpenSees2DModels\ZDirectionFrameLines\',FrameLineModelFolder,...
        '\EigenValueAnalysis\Analysis_Results\Modes');
    
    % Go to folder where modal periods are stored
    cd(ModalPeriodsFolder)
    
    % Extract modal periods and attach to 'dynamicPropertiesObject'
    dynamicPropertiesObject.modalPeriods3DModel = load('periods.out');
    cd(BuildingModelDataDirectory)
    save('dynamicPropertiesObject.mat','dynamicPropertiesObject','-mat')   
    
end