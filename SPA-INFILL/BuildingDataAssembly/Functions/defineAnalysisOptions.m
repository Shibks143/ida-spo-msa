% This function is used to generate a structure containing pushover
% analysis options
function analysisOptions = defineAnalysisOptions(...
    AnalysisOptionsLocation)

    % Go to folder where pushover analysis Options are stored
    cd(AnalysisOptionsLocation)
    
    % X-Direction frame lines for 2D models
    analysisOptions.XFrameLinesFor2DModels = ...
        load('XFrameLinesFor2DModels.txt');
    % Z-Direction frame lines for 2D models
    analysisOptions.ZFrameLinesFor2DModels = ...
        load('ZFrameLinesFor2DModels.txt');
end

