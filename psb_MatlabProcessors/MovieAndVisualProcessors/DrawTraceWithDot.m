%
% Procedure: DrawTraceWithDot.m
% -------------------
% 
% Plots a trace of ground or roof displacement on subplot.  
%
% Variable definitions:
%       bldgID - ID to determine which building to plot (as defined in
%               DefineInfoForBuildings.m)
%       floorDispVECTOR - vector of floor displacements (floor numbers are
%               same as defined in DefineInfoForBuildings.m; floor 1 in the
%               ground and floor 2 is the first raised floor)
%       analysisType, eqNum, saLevel - just the normal definitions (to put
%               the title on the plot).
%
%
% Assumptions and Notices: 
%       - none
%
% Author: Abbie Liel 
% Date Written: 12-11-05
%
%
% Functions and Procedures called: none
%
% Units: kips and inches
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function[] = DrawTraceWithDot(Displ, currentAnalysisStepNum, isGroundorRoof)

% Set max number of points high to draw the full response
    maxNumPoints = 10000000000.0;

% Dot for current response
    currentResponseDotMarker = 'ko';
    currentResponseDotSize = 6;
    traceMarker = 'k-';
    dotColor = 'm';
    
    % Adjust for there not being the same number of data points in each column and for the numDataPoint inputted possible being higher than the actual number.
    length_temp = length(Displ);
    time=0:1:length_temp;
  
    if(length_temp < maxNumPoints)
        %Just use total number of entries for each data column
        numDataPointsUsed = length_temp;
    else
        %Use the maxNumPoints provide by the caller
        numDataPointsUsed = maxNumPoints;
    end
    
    % Plot the full response
    plot(time(1:numDataPointsUsed), Displ(1:numDataPointsUsed), traceMarker);
    hold on
    
    % Plot a dot at the current response point; first do error check
    if(currentAnalysisStepNum > numDataPointsUsed)
        % Report an error 
        error('The currentAnalysisStepNum is larger than the number of steps in the analysis!');
    else
        currentD = Displ(currentAnalysisStepNum);
        currentTime = time(currentAnalysisStepNum);
        plot(currentTime, currentD, currentResponseDotMarker, 'MarkerSize', currentResponseDotSize, 'MarkerFaceColor', dotColor);
     end
    
    
    if isGroundorRoof ==1
        titleText = sprintf('Ground Displacement'); 
    elseif isGroundorRoof ==2
        titleText = sprintf('Roof (Total) Displacement'); 
    else
        titleText = sprintf('Displacement');
    end
    hold on
    title(titleText);
    grid on
    hy = ylabel('Displ (inch)');
    hx = xlabel('Time');
    FigureFormatScript_Movies
    set(gca,'xtick',[10000]); %Set ticks outside range so that units won't show because pseudo time values
    hold off




















