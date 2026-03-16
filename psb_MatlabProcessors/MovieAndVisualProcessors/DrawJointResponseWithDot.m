%
% Procedure: DrawJointResponseWithDot.m
% -------------------
% This procedure plots the response of a joint node with a dot at the
% current analysis step.  This procedure is designed so it does not have to
% reopen the file; instead the elementArray is passed from the calling
% fuction.  I use code from "PlotJointNodeMRotTH.m" to make this.
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
% Author: Curt Haselton 
% Date Written: 12-04-04
%
% Sources of Code: none
%
% Functions and Procedures called: none
%
% Units: kips and inches
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function[] = DrawJointResponseWithDot(buildingInfo, bldgID, analysisType, eqNum, saLevel, colLineNum, floorNum, jointNodeNum, elementArray, currentAnalysisStepNum, markerTypeLine, currentResponseDotFaceColor)

% Set max number of points high to draw the full response
    maxNumPoints = 10000000000.0;

% Dot for current response
    currentResponseDotMarker = 'ko';
    currentResponseDotSize = 6;

% Do plot
    momentIndex = jointNodeNum + 5;
    jointNum = buildingInfo{bldgID}.jointNumber(floorNum, colLineNum);
    moment = elementArray{jointNum}.JointForceAndDeformation(:, momentIndex);
    rotationIndex = jointNodeNum;
    rotation = elementArray{jointNum}.JointForceAndDeformation(:, rotationIndex);
    
    % Adjust for there not being the same number of data points in each column and for the numDataPoint inputted possible being higher than the actual number.
    length1 = length(moment);
    length2 = length(rotation);
    minLength = min(length1, length2);
  
    if(minLength < maxNumPoints)
        %Just use total number of entries for each data column
        numDataPointsUsed = minLength;
    else
        %Use the maxNumPoints provide by the caller
        numDataPointsUsed = maxNumPoints;
    end
    
    % Plot the full response
    plot(rotation(1:numDataPointsUsed), moment(1:numDataPointsUsed), markerTypeLine);
    hold on
    
    % Plot a dot at the current response point; first do error check
    if(currentAnalysisStepNum > numDataPointsUsed)
        % Report an error 
        error('The currentAnalysisStepNum is larger than the number of steps in the analysis!');
    else
        currentMoment = moment(currentAnalysisStepNum);
        currentRotation = rotation(currentAnalysisStepNum);
        plot(currentRotation, currentMoment, currentResponseDotMarker, 'MarkerSize', currentResponseDotSize, 'MarkerFaceColor', currentResponseDotFaceColor);
    end
    
%     % Do labeling and plot details
%     switch(jointNodeNum)
%         case(1)
%             titleText = sprintf('Flr%d, Col%d, Bottom; Sa = %.2fg', floorNum, colLineNum, saLevel);
%         case(2)
%             titleText = sprintf('Flr%d, Col%d, Right; Sa = %.2fg', floorNum, colLineNum, saLevel);       
%         case(3)
%             titleText = sprintf('Flr%d, Col%d, Top; Sa = %.2fg', floorNum, colLineNum, saLevel);  
%         case(4)
%             titleText = sprintf('Flr%d, Col%d, Left; Sa = %.2fg', floorNum, colLineNum, saLevel);            
%         case(5)
%             titleText = sprintf('Flr%d, Col%d, Shear Panel; Sa=%.2fg', floorNum, colLineNum, saLevel);
%         otherwise
%             error('Invalid value for jointNodeNum!')
%     end
    
    % Temp labels
            titleText = sprintf('Sa_{comp.} = %.2fg', saLevel);
    
    
    hold on
    title(titleText);
    grid on
    yLabel = sprintf('Moment [kip-inch]');
    hy = ylabel(yLabel);
    hx = xlabel('Plastic Rotation [rad]');
    %hx = xlabel('Shear Distortion [rad]');
    FigureFormatScript_Movies
    hold off




















