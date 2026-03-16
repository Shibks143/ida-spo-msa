% buildingInfo{bldgID}.jointWidth(1, currentColLineNum), buildingInfo{bldgID}.jointHeight(1, currentColLineNum)


%
% Procedure: DrawDistortedFrame.m
% -------------------
% This procedure plots the frame in it's displaced shape.
% 
% Variable definitions:
%       bldgID - ID to determine which building to plot (as defined in
%               DefineInfoForBuildings.m)
%       floorDispVECTOR - vector of floor displacements (floor numbers are
%               same as defined in DefineInfoForBuildings.m; floor 1 in the
%               ground and floor 2 is the first raised floor)
%       plasticRotationARRAY - cell array - this is an array that defines the plastic
%               rotation demands at each joint (based on joint number;
%               joint numbers are from the OpenSees model and must be
%               consistent with those in DefineInfoForBuildings.m).
%               (e.g. plasticRotationARRAY{jointNum}.jointNodePHRDemand{1} =
%               0.035; means that the node at the bottom of this joint has
%               the 0.035 plastic rotation demand
%               Note that for the column bases, we use hingeNumber (for the column base hinge) instead
%               of joint number.
%       analysisType, eqNum, saLevel - just the normal definitions (to put
%               the title on the plot).
%       titleOption - option regarding title of the graph
%               =1 uses a full title including the analysis Type, EQ#, and Sa level
%               =2 uses a title that includes just EQID and Sa level
%       maxOnDemandCapacityRatioToPlot - This is simply a variable that allowes
%               the user to control the maximum demand-capacity ratio that will be
%               plotted on the frame.  This is useful when plotting
%               collapse modes because often the last time step is unstable
%               and can lead to huge circle/squares in the plot.  If you
%               don't want touse this, siply set it to be a huge number.
%       saDefType - type of SA definition we want to put on the titles
%               =1 for Sa,comp
%               =2 for Sa,geoMean
%               =3 for Sa,codeDef
%
%
%
%
% Assumptions and Notices: 
%       - This will only work for a regualr frame that has equal bay width
%           and has uniform story heights (other than first story being
%           different)
%       - The building information for the desired bldgID must be defined
%           in DefineInfoForBuildings.m.
%
%
% Author: Curt Haselton 
% Date Written: 12-03-05
% Modified: Abbie Liel, 12/11/05
% Sources of Code: none
%
% Functions and Procedures called: none
%
% Units: kips and inches
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function[] = psb_DrawDistortedFrame(buildingInfo, bldgID, floorDispVECTOR, plasticRotationARRAY, analysisType, eqNum, saLevel, isHingesHighlighted, hingeHighlighted_1, hingeHighlighted_2, highlightedHingeColor_1, highlightedHingeColor_2, titleOption, maxOnDemandCapacityRatioToPlot, saDefType, periodUsedForScalingGroundMotionsFromMatlab)

% Define the plot options
    % Set a scale to scale up the y-direction (make it look bigger) becuase
    % Matlab makes the plot slightly distorted.
    yScale = 2.0;   % Scale revised from 1.4 to 2.0 so it looks right on the full screen (4-20-16, PSB)

    jointLineWidth = 1;
    %jointLineStyle = 'k-'; % Doesn't work now

    groundLineWidth = 2;
    groundLineStyle = 'k-';
    
    elementLineWidth = 1;      
    elementLineStyle = 'k-';
    dummyBeamLineStyle = 'k--';
    
    diameterOfPHCircle = 0.75*max(buildingInfo{bldgID}.jointWidth);
    circleLineWidth = 1;      
    circleLineStyle = '-';
    circleInnerColor = 'b';     % For the smaller circle that shows the level of plastic rotation demand  
    circleInnerColor_afterCap = 'r';     % For the smaller circle that shows the level of plastic rotation demand  

    % Information for the inner rectangle in the joints
    %innerRectangleLineStyle = '-';
    rectLineWidth = 1;      
    rectLineStyle = '-';
    rectInnerColor = 'b';               % For the smaller rectangle that shows the level of plastic rotation demand  
    rectInnerColor_afterCap = 'r';      % For the smaller rectangle that shows the level of plastic rotation demand  
    isLimitHeightOfInnerRect = 0;       % Do not confine the height of the inner rectangle to stay within the outer rectangle.
                                        %   If the joint fails significantly in shear, then the inner rectangle will become
                                        %   larger than the outer rectangle.
    
    % Decide the smallest value that the PHR ratio shhould be to plot it
    smallestPHRRatioToPlot = 0.05;   % 5% of the capping plastic rotation
    
    
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Do computations for the joint plastic hinge demands
    numStories = buildingInfo{bldgID}.numStories;
    numFloors = numStories + 1;
    numColLines = buildingInfo{bldgID}.numBays + 1;
    numBays = numColLines - 1;
%     lowestFloorWithBeam = buildingInfo{bldgID}.lowestFloorWithBeam;
    
    if(isfield(buildingInfo{bldgID}, 'lowestFloorWithBeam') == 1)
        lowestFloorWithBeam = buildingInfo{bldgID}.lowestFloorWithBeam;
    else
        lowestFloorWithBeam = 0;
    end
    
    % Loop over all joints
    for currentFloorNum = 2:numFloors
        for currentColLineNum = 1:numColLines
            currentJointNum = buildingInfo{bldgID}.jointNumber(currentFloorNum, currentColLineNum);

            % Loop over the five nodes at the joint and compute the plastic
            % rotation demand/capacity ratio
            for currentJointNodeNum = 1:5
                currentPHRotationDemand = plasticRotationARRAY{currentJointNum}.jointNodePHRDemand{currentJointNodeNum};
%                 [currentFloorNum, currentColLineNum, currentJointNodeNum]
                currentPHRotationCapacity = buildingInfo{bldgID}.plastHingeRotCapAtJoint(currentFloorNum, currentColLineNum).node(currentJointNodeNum);
                % NOTICE: This is limited my a maximum value that the user
                % inputs (for plotting), which is 3 as of now!
                plasticRotationDemandCapacityRatio{currentFloorNum, currentColLineNum}.jointNode{currentJointNodeNum} = min(maxOnDemandCapacityRatioToPlot, (currentPHRotationDemand / currentPHRotationCapacity));
            end; % end for joint nodes loop
        end; % end for colLines loop
    end; % end for floorNum loop
    
    % Now loop over the column base hinges at the foundation level (not
    % within a joint)
    currentFloorNum = 1;
    currentNodeNum = 1;     % Just say it's node 1 when at the base (dummy variable)
    
    for currentColLineNum = 1:numColLines
        currentHingeNumber = buildingInfo{bldgID}.hingeElementNumAtColBase(currentColLineNum);
        currentPHRotationDemand = plasticRotationARRAY{currentHingeNumber}.columnBasePHRDemand;
        currentPHRotationCapacity = buildingInfo{bldgID}.plastHingeRotCapAtJoint(currentFloorNum, currentColLineNum).node(currentNodeNum);
        plasticRotationDemandCapacityRatio{currentFloorNum, currentColLineNum}.jointNode{currentNodeNum} = min(maxOnDemandCapacityRatioToPlot, (currentPHRotationDemand / currentPHRotationCapacity));
    end; % end for colLines loop
    
% (11-14-15, PSB) Save as mat file to check the structure of 2-D cell
%     tempFolderPath = pwd;
%     cd E:\MyOPENSEES\THESIS\HaseltonRuns
%     save ('plasticRotationDemandCapacityRatio.mat', 'plasticRotationDemandCapacityRatio')
%     cd(tempFolderPath)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Do this plotting
% Initialize the plot
    hold on
    % Make axes so frame in centered - make (0,0) at left bottom corner of
    % frame.  Also, make sure the plot dimension is symetrical in x and y
    % (so the building doesn't look stretched).
    
% (3-27-16, PSB) modifying code to encorporate buildings with unequal bayWidth and upperStories
    if length(buildingInfo{bldgID}.bayWidth) == 1 % older DefineInfoForBuildings (needs all bayWidth to be equal)
        xDimNeededForBldg = buildingInfo{bldgID}.bayWidth * buildingInfo{bldgID}.numBays;
        yDimNeededForBldg = buildingInfo{bldgID}.storyHeight_upperStories * buildingInfo{bldgID}.numStories;
    else
        xDimNeededForBldg = sum(buildingInfo{bldgID}.bayWidth); % newer DefineInfoForBuildings (needs all upperStories to be equal)
        yDimNeededForBldg = buildingInfo{bldgID}.storyHeight_firstStory + sum(buildingInfo{bldgID}.storyHeight_upperStories);
    end
%     [xDimNeededForBldg, yDimNeededForBldg]
    

    maxDimNeededForBldg = 1.25*max(xDimNeededForBldg, (yDimNeededForBldg * yScale));
    xMin = (-0.50 * maxDimNeededForBldg + 0.5*xDimNeededForBldg);
    xMax = (+0.50 * maxDimNeededForBldg + 0.5*xDimNeededForBldg);
    yMin = (-0.50 * maxDimNeededForBldg / yScale + 0.5*yDimNeededForBldg);
    yMax = (+0.50 * maxDimNeededForBldg / yScale + 0.5*yDimNeededForBldg);
    %(Note: axis set after plotting)
    
% (4-19-16, PSB) Commenting yScale thing out, since axis equal command does exactly 
% what we've tried to do using yScale
% (4-20-16, PSB) It works. However, the plot size is scaled down, so let's
% stick with yScale for now.

%     maxDimNeededForBldg = 1.25 * max(xDimNeededForBldg, yDimNeededForBldg);
%     xMin = (-0.50 * maxDimNeededForBldg + 0.5*xDimNeededForBldg);
%     xMax = (+0.50 * maxDimNeededForBldg + 0.5*xDimNeededForBldg);
%     yMin = (-0.50 * maxDimNeededForBldg + 0.5*yDimNeededForBldg);
%     yMax = (+0.50 * maxDimNeededForBldg + 0.5*yDimNeededForBldg);
% 
%     axis equal
    
% Draw a line for the ground 
    xLeft = (-0.25*buildingInfo{bldgID}.bayWidth(1,1)); % considers 25% of first bay, works with both- older and newer buildingInfo
    xRight = (xDimNeededForBldg + 0.25*buildingInfo{bldgID}.bayWidth(1,1));
    plot([xLeft, xRight], [0.0, 0.0], groundLineStyle, 'LineWidth', groundLineWidth);
    hold on
    
% Loop and plot all of the joints.  The joints are centered on the bay line
% and the top of the joint is level with the floor line.
    for currentFloorNum = 2:numFloors
        for currentColLineNum = 1:numColLines

            currentJointNodeNum = 5;    % For the shear spring
            
           if length(buildingInfo{bldgID}.bayWidth) == 1 % older DefineInfoForBuildings (needs all bayWidth to be equal)
            currentJointHeight = buildingInfo{bldgID}.jointHeight;
            currentJointWidth = buildingInfo{bldgID}.jointWidth;
           else            
            currentJointHeight = buildingInfo{bldgID}.jointHeight(1, currentColLineNum);
            currentJointWidth = buildingInfo{bldgID}.jointWidth(1, currentColLineNum);
           end
            
            % If we are at a highlighted node, then alter the hinge color
            % to use
            currentPHInfo = [currentFloorNum, currentColLineNum, currentJointNodeNum];
            if((isHingesHighlighted == 1) && ((min(currentPHInfo == hingeHighlighted_1)) == 1))
                disp('Highlighting first hinge');
                % This is the first highlighed hinge, so highlight with first hinge color
                rectInnerColor_toUse = highlightedHingeColor_1;
                rectInnerColor_afterCap_toUse = highlightedHingeColor_1;
            elseif((isHingesHighlighted == 1) && ((min(currentPHInfo == hingeHighlighted_2)) == 1))
                disp('Highlighting second hinge');
                % This is the second highlighed hinge, so highlight with first hinge color
                rectInnerColor_toUse = highlightedHingeColor_2;
                rectInnerColor_afterCap_toUse = highlightedHingeColor_2;
            else
                % An unhighlighed hinge, so don't alter color
                rectInnerColor_toUse = rectInnerColor;
                rectInnerColor_afterCap_toUse = rectInnerColor_afterCap;
            end
            

            % (3-27-16, PSB) revised to incorporate different bayWidth and storet height etc.
            % Find joint location
           if length(buildingInfo{bldgID}.bayWidth) == 1 % older DefineInfoForBuildings (needs all bayWidth to be equal)
                jointLeftBottomCorner_x = ((currentColLineNum - 1) * buildingInfo{bldgID}.bayWidth + floorDispVECTOR(currentFloorNum) - 0.5 * buildingInfo{bldgID}.jointWidth);
                jointLeftBottomCorner_y = (buildingInfo{bldgID}.storyHeight_firstStory + max((currentFloorNum - 2), 0) * buildingInfo{bldgID}.storyHeight_upperStories - 1.0 * buildingInfo{bldgID}.jointHeight);
            else
                jointLeftBottomCorner_x = ((sum(buildingInfo{bldgID}.bayWidth(1, 1:(currentColLineNum - 1)))) + floorDispVECTOR(currentFloorNum) - 0.5 * currentJointWidth);
                jointLeftBottomCorner_y = (buildingInfo{bldgID}.storyHeight_firstStory + (sum(buildingInfo{bldgID}.storyHeight_upperStories(1, 1:(currentFloorNum - 2)))) - 1.0 * currentJointHeight);
           end          % sum(.storyHeight_upperStories(1, 1:0)) = 0 when building is one storied. So no error handling needed there. We can define storyHeight_upperStories =  any number, even zero in the DefineInfo file
            
           
           % Find the level of shear damage
                currentPlasticRotationDemandCapacityRatio = plasticRotationDemandCapacityRatio{currentFloorNum, currentColLineNum}.jointNode{currentJointNodeNum};
            % Now plot the rectangle.  If there is only slight shear damage
            %   (less than smallestPHRRatioToPlot), then plot the joint
            %   with no shear damage shown, otherwise show shear damage.
                if(currentPlasticRotationDemandCapacityRatio > smallestPHRRatioToPlot)
                    % Plot with shear damage.  Plot color differently if
                    % before or after the cap
                    if(currentPlasticRotationDemandCapacityRatio < 1.0)
                        % Plot with non-capped color
                        PlotRectangleWithInnerRect(jointLeftBottomCorner_x, jointLeftBottomCorner_y, currentJointWidth, currentJointHeight, currentPlasticRotationDemandCapacityRatio, rectLineWidth, rectLineStyle, rectInnerColor_toUse, isLimitHeightOfInnerRect)
                        hold on
                    else
                        % Plot with capped color
                        % (11-14-15, PSB) since moment is more than capping, change the color (to say, red)
                        PlotRectangleWithInnerRect(jointLeftBottomCorner_x, jointLeftBottomCorner_y, currentJointWidth, currentJointHeight, currentPlasticRotationDemandCapacityRatio, rectLineWidth, rectLineStyle, rectInnerColor_afterCap_toUse, isLimitHeightOfInnerRect)
                        hold on
                    end
                else
                    % Plot without shear damage
                    currentPlasticRotationDemandCapacityRatio = 0.0;
                    PlotRectangleWithInnerRect(jointLeftBottomCorner_x, jointLeftBottomCorner_y, currentJointWidth, currentJointHeight, currentPlasticRotationDemandCapacityRatio, rectLineWidth, rectLineStyle, rectInnerColor_toUse, isLimitHeightOfInnerRect)
                    hold on
                end
            
                
            % Plot the plastic hinge circles around the joints for each of the four joint nodes (as long as the PHR demand ratio is larger than a small number like 0.01)...
                %%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                % Plot for joint node 1
                currentJointNodeNum = 1;
                % If we are at a highlighted node, then alter the hinge color
                % to use
                    currentPHInfo = [currentFloorNum, currentColLineNum, currentJointNodeNum];
                    if((isHingesHighlighted == 1) && ((min(currentPHInfo == hingeHighlighted_1)) == 1))
                        disp('Highlighting first hinge');
                        % This is the first highlighed hinge, so highlight with first hinge color
                        circleInnerColor_toUse = highlightedHingeColor_1;
                        circleInnerColor_afterCap_toUse = highlightedHingeColor_1;
                    elseif((isHingesHighlighted == 1) && ((min(currentPHInfo == hingeHighlighted_2)) == 1))
                        disp('Highlighting second hinge');
                        % This is the second highlighed hinge, so highlight with first hinge color
                        circleInnerColor_toUse = highlightedHingeColor_2;
                        circleInnerColor_afterCap_toUse = highlightedHingeColor_2;
                    else
                        % An unhighlighed hinge, so don't alter color
                        circleInnerColor_toUse = circleInnerColor;
                        circleInnerColor_afterCap_toUse = circleInnerColor_afterCap;
                    end
                
                % Find the coordinates of the circle for the PH and the demand/capacity ratio
                    phCircleLeftBottomCorner_x = jointLeftBottomCorner_x + 0.5*currentJointWidth - 0.5*diameterOfPHCircle;
                    phCircleLeftBottomCorner_y = jointLeftBottomCorner_y - 1.0*diameterOfPHCircle;
                    currentPlasticRotationDemandCapacityRatio = plasticRotationDemandCapacityRatio{currentFloorNum, currentColLineNum}.jointNode{currentJointNodeNum};
                % Plot the circle if the ratio is over the threshold
                    if(currentPlasticRotationDemandCapacityRatio > smallestPHRRatioToPlot)
                        if(currentPlasticRotationDemandCapacityRatio < 1.0)
                            % Plot PH normal color
                            PlotPlasticHinge(phCircleLeftBottomCorner_x, phCircleLeftBottomCorner_y, diameterOfPHCircle, currentPlasticRotationDemandCapacityRatio, circleLineWidth, circleLineStyle, circleInnerColor_toUse);
                        else 
                            % Plot red
                            PlotPlasticHinge(phCircleLeftBottomCorner_x, phCircleLeftBottomCorner_y, diameterOfPHCircle, currentPlasticRotationDemandCapacityRatio, circleLineWidth, circleLineStyle, circleInnerColor_afterCap_toUse);
                        end
                            hold on
                    end
                %%%%%%%%%%%%%%%%%%%%%%%%%%%%%

                %%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                % Plot for joint node 2
                currentJointNodeNum = 2;
                % If we are at a highlighted node, then alter the hinge color
                % to use
                
    % (3-30-16, PSB) Plot the beam joints (i.e. joint node 2 and 4):
    % currentFloorNum is more than or equal to lowestFloorWithBeam 
    % NOTE- lowestFloorWithBeam is equal to zero, if it is not defined in psb_DefineInfoForBuildings.m
    
        if(currentFloorNum >= lowestFloorWithBeam)
                    currentPHInfo = [currentFloorNum, currentColLineNum, currentJointNodeNum];
                    if((isHingesHighlighted == 1) && ((min(currentPHInfo == hingeHighlighted_1)) == 1))
                        disp('Highlighting first hinge');
                        % This is the first highlighed hinge, so highlight with first hinge color
                        circleInnerColor_toUse = highlightedHingeColor_1;
                        circleInnerColor_afterCap_toUse = highlightedHingeColor_1;
                    elseif((isHingesHighlighted == 1) && ((min(currentPHInfo == hingeHighlighted_2)) == 1))
                        disp('Highlighting second hinge');
                        % This is the second highlighed hinge, so highlight with first hinge color
                        circleInnerColor_toUse = highlightedHingeColor_2;
                        circleInnerColor_afterCap_toUse = highlightedHingeColor_2;
                    else
                        % An unhighlighed hinge, so don't alter color
                        circleInnerColor_toUse = circleInnerColor;
                        circleInnerColor_afterCap_toUse = circleInnerColor_afterCap;
                    end                
                % Find the coordinates of the circle for the PH and the demand/capacity ratio
                    phCircleLeftBottomCorner_x = jointLeftBottomCorner_x + 1.0*currentJointWidth;

                    if ((currentColLineNum > 4) && (currentColLineNum < 7) && (bldgID == 502)) 
                        phCircleLeftBottomCorner_x = jointLeftBottomCorner_x - 1.0*diameterOfPHCircle;
                    end
                    phCircleLeftBottomCorner_y = jointLeftBottomCorner_y + 0.5*currentJointHeight - 0.5*diameterOfPHCircle;
                    currentPlasticRotationDemandCapacityRatio = plasticRotationDemandCapacityRatio{currentFloorNum, currentColLineNum}.jointNode{currentJointNodeNum};
                % Plot the circle if the ratio is over the threshold
                
%                 disp(phCircleLeftBottomCorner_x);
%                 disp(phCircleLeftBottomCorner_y);
%                 disp(diameterOfPHCircle);
%                 disp(currentPlasticRotationDemandCapacityRatio);

                if(currentPlasticRotationDemandCapacityRatio > smallestPHRRatioToPlot)
                    if(currentPlasticRotationDemandCapacityRatio < 1.0)
                        % Plot PH normal color
                        PlotPlasticHinge(phCircleLeftBottomCorner_x, phCircleLeftBottomCorner_y, diameterOfPHCircle, currentPlasticRotationDemandCapacityRatio, circleLineWidth, circleLineStyle, circleInnerColor_toUse);
                    else
                        % Plot red
                        PlotPlasticHinge(phCircleLeftBottomCorner_x, phCircleLeftBottomCorner_y, diameterOfPHCircle, currentPlasticRotationDemandCapacityRatio, circleLineWidth, circleLineStyle, circleInnerColor_afterCap_toUse);
                    end
                    hold on
                end
                %%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        end

                %%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                % Plot for joint node 3
                currentJointNodeNum = 3;
                % If we are at a highlighted node, then alter the hinge color
                % to use
                    currentPHInfo = [currentFloorNum, currentColLineNum, currentJointNodeNum];
                    if((isHingesHighlighted == 1) && ((min(currentPHInfo == hingeHighlighted_1)) == 1))
                        disp('Highlighting first hinge');
                        % This is the first highlighed hinge, so highlight with first hinge color
                        circleInnerColor_toUse = highlightedHingeColor_1;
                        circleInnerColor_afterCap_toUse = highlightedHingeColor_1;
                    elseif((isHingesHighlighted == 1) && ((min(currentPHInfo == hingeHighlighted_2)) == 1))
                        disp('Highlighting second hinge');
                        % This is the second highlighed hinge, so highlight with first hinge color
                        circleInnerColor_toUse = highlightedHingeColor_2;
                        circleInnerColor_afterCap_toUse = highlightedHingeColor_2;
                    else
                        % An unhighlighed hinge, so don't alter color
                        circleInnerColor_toUse = circleInnerColor;
                        circleInnerColor_afterCap_toUse = circleInnerColor_afterCap;
                    end
                % Find the coordinates of the circle for the PH and the
                % demand/capacity ratio
                    phCircleLeftBottomCorner_x = jointLeftBottomCorner_x + 0.5*currentJointWidth - 0.5*diameterOfPHCircle;
                    phCircleLeftBottomCorner_y = jointLeftBottomCorner_y + 1.0*currentJointHeight;
                    currentPlasticRotationDemandCapacityRatio = plasticRotationDemandCapacityRatio{currentFloorNum, currentColLineNum}.jointNode{currentJointNodeNum};
                % Plot the circle if the ratio is over the threshold
                    if(currentPlasticRotationDemandCapacityRatio > smallestPHRRatioToPlot)
                        if(currentPlasticRotationDemandCapacityRatio < 1.0)
                            % Plot PH normal color
                            PlotPlasticHinge(phCircleLeftBottomCorner_x, phCircleLeftBottomCorner_y, diameterOfPHCircle, currentPlasticRotationDemandCapacityRatio, circleLineWidth, circleLineStyle, circleInnerColor_toUse);
                        else 
                            % Plot red
                            PlotPlasticHinge(phCircleLeftBottomCorner_x, phCircleLeftBottomCorner_y, diameterOfPHCircle, currentPlasticRotationDemandCapacityRatio, circleLineWidth, circleLineStyle, circleInnerColor_afterCap_toUse);
                        end
                            hold on
                    end      
                %%%%%%%%%%%%%%%%%%%%%%%%%%%%%

                %%%%%%%%%%%%%%%%%%%%%%%%%%%%
                % Plot for joint node 4
                currentJointNodeNum = 4;
                
    % (3-30-16, PSB) Plot the beam joints (i.e. joint node 2 and 4):
    % currentFloorNum is more than or equal to lowestFloorWithBeam 
    % NOTE- lowestFloorWithBeam is equal to zero, if it is not defined in psb_DefineInfoForBuildings.m
    
        if(currentFloorNum >= lowestFloorWithBeam)
                % If we are at a highlighted node, then alter the hinge color
                % to use
                    currentPHInfo = [currentFloorNum, currentColLineNum, currentJointNodeNum];
                    if((isHingesHighlighted == 1) && ((min(currentPHInfo == hingeHighlighted_1)) == 1))
                        disp('Highlighting first hinge');
                        % This is the first highlighed hinge, so highlight with first hinge color
                        circleInnerColor_toUse = highlightedHingeColor_1;
                        circleInnerColor_afterCap_toUse = highlightedHingeColor_1;
                    elseif((isHingesHighlighted == 1) && ((min(currentPHInfo == hingeHighlighted_2)) == 1))
                        disp('Highlighting second hinge');
                        % This is the second highlighed hinge, so highlight with first hinge color
                        circleInnerColor_toUse = highlightedHingeColor_2;
                        circleInnerColor_afterCap_toUse = highlightedHingeColor_2;
                    else
                        % An unhighlighed hinge, so don't alter color
                        circleInnerColor_toUse = circleInnerColor;
                        circleInnerColor_afterCap_toUse = circleInnerColor_afterCap;
                    end
                % Find the coordinates of the circle for the PH and the
                % demand/capacity ratio
                    phCircleLeftBottomCorner_x = jointLeftBottomCorner_x - 1.0*diameterOfPHCircle;
                    if ((currentColLineNum > 4) &&  (currentColLineNum < 7) && (bldgID == 502)) 
                        phCircleLeftBottomCorner_x = jointLeftBottomCorner_x + 1.0*currentJointWidth;
                    end
                    phCircleLeftBottomCorner_y = jointLeftBottomCorner_y + 0.5*currentJointHeight - 0.5*diameterOfPHCircle;
                    currentPlasticRotationDemandCapacityRatio = plasticRotationDemandCapacityRatio{currentFloorNum, currentColLineNum}.jointNode{currentJointNodeNum};
                % Plot the circle if the ratio is over the threshold
                    if(currentPlasticRotationDemandCapacityRatio > smallestPHRRatioToPlot)
                        if(currentPlasticRotationDemandCapacityRatio < 1.0)
                            % Plot PH normal color
                            PlotPlasticHinge(phCircleLeftBottomCorner_x, phCircleLeftBottomCorner_y, diameterOfPHCircle, currentPlasticRotationDemandCapacityRatio, circleLineWidth, circleLineStyle, circleInnerColor_toUse);
                        else 
                            % Plot red
                            PlotPlasticHinge(phCircleLeftBottomCorner_x, phCircleLeftBottomCorner_y, diameterOfPHCircle, currentPlasticRotationDemandCapacityRatio, circleLineWidth, circleLineStyle, circleInnerColor_afterCap_toUse);
                        end
                            hold on
                    end    
                %%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        end
            
        end
    end

    
% Loop and draw all of the hinge nodes at the column bases on the first
% story
    currentFloorNum = 1;    % Doing the column base hinges at the foundation level
    currentNodeNum = 1;     % Just say it's node 1 when at the base (dummy variable)
    for currentColLineNum = 1:numColLines
        % If we are at a highlighted node, then alter the hinge color to use

            currentPHInfo = [currentFloorNum, currentColLineNum, currentJointNodeNum];
            if((isHingesHighlighted == 1) && ((min(currentPHInfo == hingeHighlighted_1)) == 1))
                disp('Highlighting first hinge');
                % This is the first highlighed hinge, so highlight with first hinge color
                circleInnerColor_toUse = highlightedHingeColor_1;
                circleInnerColor_afterCap_toUse = highlightedHingeColor_1;
            elseif((isHingesHighlighted == 1) && ((min(currentPHInfo == hingeHighlighted_2)) == 1))
                disp('Highlighting second hinge');
                % This is the second highlighed hinge, so highlight with first hinge color
                circleInnerColor_toUse = highlightedHingeColor_2;
                circleInnerColor_afterCap_toUse = highlightedHingeColor_2;
            else
                % An unhighlighed hinge, so don't alter color
                circleInnerColor_toUse = circleInnerColor;
                circleInnerColor_afterCap_toUse = circleInnerColor_afterCap;
            end
            
    % (3-27-16, PSB) revised to incorporate different bayWidth and storet height etc.
        % Find the coordinates of the circle for the PH and the demand/capacity ratio
           if length(buildingInfo{bldgID}.bayWidth) == 1 % older DefineInfoForBuildings (needs all bayWidth to be equal)
                phCircleLeftBottomCorner_x = ((currentColLineNum - 1) * buildingInfo{bldgID}.bayWidth + floorDispVECTOR(currentFloorNum) - 0.5*diameterOfPHCircle);
                phCircleLeftBottomCorner_y = 0.0;
            else
                phCircleLeftBottomCorner_x = ((sum(buildingInfo{bldgID}.bayWidth(1, 1:(currentColLineNum - 1)))) + floorDispVECTOR(currentFloorNum) - 0.5*diameterOfPHCircle);
                phCircleLeftBottomCorner_y = 0.0;
           end          % sum(.storyHeight_upperStories(1, 1:0)) = 0 when building is one storied. So no error handling needed there. We can define storyHeight_upperStories =  any number, even zero in the DefineInfo file

            currentPlasticRotationDemandCapacityRatio = plasticRotationDemandCapacityRatio{currentFloorNum, currentColLineNum}.jointNode{currentNodeNum};
        % Plot the circle if the ratio is over the threshold
                if(currentPlasticRotationDemandCapacityRatio > smallestPHRRatioToPlot)
                    if(currentPlasticRotationDemandCapacityRatio < 1.0)
                        % Plot PH normal color
                        PlotPlasticHinge(phCircleLeftBottomCorner_x, phCircleLeftBottomCorner_y, diameterOfPHCircle, currentPlasticRotationDemandCapacityRatio, circleLineWidth, circleLineStyle, circleInnerColor_toUse);
                    else 
                        % Plot red
                        PlotPlasticHinge(phCircleLeftBottomCorner_x, phCircleLeftBottomCorner_y, diameterOfPHCircle, currentPlasticRotationDemandCapacityRatio, circleLineWidth, circleLineStyle, circleInnerColor_afterCap_toUse);
                    end
                    hold on
                end
    end
    
    
% Loop and draw all of the columns
    for currentStory = 1:numStories
        for currentColLineNum = 1:numColLines

            if length(buildingInfo{bldgID}.bayWidth) == 1 % older DefineInfoForBuildings (needs all bayWidth to be equal)
            currentJointHeight = buildingInfo{bldgID}.jointHeight;
           else            
            currentJointHeight = buildingInfo{bldgID}.jointHeight(1, currentColLineNum);
           end
            
            % Floor numbers
            currentFloorNum_bottom = currentStory;
            currentFloorNum_top = currentStory + 1;
            
% (3-27-16, PSB) revised to incorporate different bayWidth and storet height etc.
            % x-locations
           if length(buildingInfo{bldgID}.bayWidth) == 1 % older DefineInfoForBuildings (needs all bayWidth to be equal)
            colLocation_bottom_x = ((currentColLineNum - 1) * buildingInfo{bldgID}.bayWidth + floorDispVECTOR(currentFloorNum_bottom));
            colLocation_top_x = ((currentColLineNum - 1) * buildingInfo{bldgID}.bayWidth + floorDispVECTOR(currentFloorNum_top));
            else
            colLocation_bottom_x = ((sum(buildingInfo{bldgID}.bayWidth(1, 1:(currentColLineNum - 1)))) + floorDispVECTOR(currentFloorNum_bottom));
            colLocation_top_x = ((sum(buildingInfo{bldgID}.bayWidth(1, 1:(currentColLineNum - 1))))+ floorDispVECTOR(currentFloorNum_top));
           end 
            
            % y-locations
            if(currentStory == 1)
                colLocation_bottom_y = 0.0;
                colLocation_top_y = (buildingInfo{bldgID}.storyHeight_firstStory - 1.0*currentJointHeight);
            else
    % (3-27-16, PSB) revised to incorporate different bayWidth and storet height etc.
               if length(buildingInfo{bldgID}.bayWidth) == 1 % older DefineInfoForBuildings (needs all bayWidth to be equal)
                    colLocation_bottom_y = (buildingInfo{bldgID}.storyHeight_firstStory + (max((currentFloorNum_bottom - 2),0)) * buildingInfo{bldgID}.storyHeight_upperStories);
                    colLocation_top_y = (buildingInfo{bldgID}.storyHeight_firstStory + (max((currentFloorNum_top - 2),0)) * buildingInfo{bldgID}.storyHeight_upperStories - 1.0*currentJointHeight);
               else
                    colLocation_bottom_y = (buildingInfo{bldgID}.storyHeight_firstStory + (sum(buildingInfo{bldgID}.storyHeight_upperStories(1, 1:(currentFloorNum_bottom - 2)))));
                    colLocation_top_y = (buildingInfo{bldgID}.storyHeight_firstStory + (sum(buildingInfo{bldgID}.storyHeight_upperStories(1, 1:(currentFloorNum_top - 2)))) - 1.0 * currentJointHeight);
               end  
            
            end
            % Plot
            plot([colLocation_bottom_x, colLocation_top_x], [colLocation_bottom_y, colLocation_top_y], elementLineStyle, 'LineWidth', elementLineWidth);
        end
    end
    
% Loop and draw all of the beams
    for currentFloorNum = 2:numFloors
        for currentBayNum = 1:numBays
    
    % (3-27-16, PSB) revised to incorporate different bayWidth and storet height etc.
               if length(buildingInfo{bldgID}.bayWidth) == 1 % older DefineInfoForBuildings (needs all bayWidth to be equal)
                    beamLocation_y = (buildingInfo{bldgID}.storyHeight_firstStory + (max((currentFloorNum - 2),0))*buildingInfo{bldgID}.storyHeight_upperStories - 0.5*buildingInfo{bldgID}.jointHeight);
                    beamLocation_left_x = ((currentBayNum - 1) * buildingInfo{bldgID}.bayWidth + floorDispVECTOR(currentFloorNum) + 0.5*buildingInfo{bldgID}.jointWidth);
                    beamLocation_right_x = ((currentBayNum) * buildingInfo{bldgID}.bayWidth + floorDispVECTOR(currentFloorNum) - 0.5*buildingInfo{bldgID}.jointWidth);
               else
                    beamLocation_y = (buildingInfo{bldgID}.storyHeight_firstStory + (sum(buildingInfo{bldgID}.storyHeight_upperStories(1, 1:(currentFloorNum - 2)))) - 0.5 * buildingInfo{bldgID}.jointHeight(1, currentBayNum));
                    beamLocation_left_x = ((sum(buildingInfo{bldgID}.bayWidth(1, 1:(currentBayNum - 1)))) + floorDispVECTOR(currentFloorNum) + 0.5 * buildingInfo{bldgID}.jointWidth(1, currentBayNum));
                    beamLocation_right_x = ((sum(buildingInfo{bldgID}.bayWidth(1, 1:currentBayNum))) + floorDispVECTOR(currentFloorNum) - 0.5 * buildingInfo{bldgID}.jointWidth(1, currentBayNum + 1));
               end
    % (3-30-16, PSB) Plot the beams even if-
    % currentFloorNum is LESS than lowestFloorWithBeam. But don't plot hinge deformations etc.
    % However, make beams dotted if they are dummy. just to show dummy

                   if(currentFloorNum >= lowestFloorWithBeam)
                       plot([beamLocation_left_x, beamLocation_right_x], [beamLocation_y, beamLocation_y], elementLineStyle, 'LineWidth', elementLineWidth);
                   else
                       plot([beamLocation_left_x, beamLocation_right_x], [beamLocation_y, beamLocation_y], dummyBeamLineStyle, 'LineWidth', elementLineWidth);
                   end
        end
    end
    
% % OLD
%     jointLeftBottomCorner_x = ((currentColLineNum - 1) * buildingInfo{bldgID}.bayWidth + floorDispVECTOR(currentFloorNum) - 0.5 * buildingInfo{bldgID}.jointWidth);
%     jointLeftBottomCorner_x = ((sum(buildingInfo{bldgID}.bayWidth(1, 1:(currentColLineNum - 1)))) + floorDispVECTOR(currentFloorNum) - 0.5 * jointWidth);
% % NEW 
%     jointLeftBottomCorner_y = (buildingInfo{bldgID}.storyHeight_firstStory + max((currentFloorNum - 2), 0) * buildingInfo{bldgID}.storyHeight_upperStories - 1.0 * buildingInfo{bldgID}.jointHeight);
%     jointLeftBottomCorner_y = (buildingInfo{bldgID}.storyHeight_firstStory + (sum(buildingInfo{bldgID}.storyHeight_upperStories(1, 1:(currentFloorNum - 2)))) - 1.0 * buildingInfo{bldgID}.jointHeight(1, currentColLineNum));
    
    
% % OLD
% buildingInfo{bldgID}.jointWidth, buildingInfo{bldgID}.jointHeight
% % NEW
% jointWidthToUse, buildingInfo{bldgID}.jointHeight(1, currentColLineNum)


% Scale the axis (from calcs above)
    axis([xMin xMax yMin yMax])
    box on
    hold on
    
% Change the location of the axes, so we cannot see them
    set(gca,'XTick', [-1000000, 1000000]);
    set(gca,'YTick', [-1000000, 1000000]);

% Put a label on the figure
    if titleOption == 1
        % Use long title
        switch saDefType
            case 1
                titleText = sprintf('Analysis: %s, EQ: %d, Sa_{comp}(T=1sec): %.2fg', analysisType, eqNum, saLevel);
            case 2
                titleText = sprintf('Analysis: %s, EQ: %d, Sa_{g.m.}(T=%.2fsec): %.2fg', analysisType, eqNum, periodUsedForScalingGroundMotionsFromMatlab, saLevel);
            case 3
                titleText = sprintf('Analysis: %s, EQ: %d, Sa_{code}(T=1sec): %.2fg', analysisType, eqNum, saLevel);
            otherwise
                error('Invalid value for saDefType!');
        end
        %title(titleText);
        hx = xlabel(titleText); % Changed to be on the x-labl on 12-9-05
    elseif titleOption == 2
        % Use short title
        titleText = sprintf('EQ: %d, Sa(T=1sec): %.2fg', eqNum, saLevel);
        switch saDefType
            case 1
                titleText = sprintf('EQ: %d, Sa_{comp}(T=X.X_Sacomp_NOTUSEDFORARCH): %.2fg', eqNum, saLevel);
            case 2
                titleText = sprintf('EQ: %d, Sa_{g.m.}(T=%.2fsec): %.2fg', eqNum, periodUsedForScalingGroundMotionsFromMatlab, saLevel);
%                 titleText = sprintf('ID: %i, EQ: %d, Sa_{g.m.}(T=%.2fsec): %.2fg', bldgID, eqNum, periodUsedForScalingGroundMotionsFromMatlab, saLevel);
            case 3
                titleText = sprintf('EQ: %d, Sa_{code}(T=X.X_Sacode_NOTUSEDTORUNARCH): %.2fg', eqNum, saLevel);
            otherwise
                error('Invalid value for saDefType!');
        end
        %title(titleText);
        hx = xlabel(titleText); % Changed to be on the x-labl on 12-9-05
    elseif titleOption == 3
        % use pushover title
            titleText = sprintf('EQ: %d, Sa:%.2f', eqNum, saLevel);
    else
        error('Invalid titleOption');
    end
    
    
    % Create the label with our names - I removed this on 7-18-06 because
    % this function is used to plot collapse modes and I do not want the
    % label to plot over the collapse mode plots.
    %annotation('textbox',[0.3 0.12 0.46 0.06],'String','Deierlein, Haselton, Liel (Stanford University)', 'FontWeight', 'bold', 'EdgeColor', 'k', 'FontSize', 8, 'LineWidth', 1, 'LineStyle', ':', 'Color', 'k');
    %OLD - annotation('textbox',[0.5 0.005 0.45 0.06],'String','Deierlein, Haselton, Liel; Stanford University', 'FontWeight', 'bold', 'EdgeColor', 'k', 'FontSize', 8, 'LineWidth', 1, 'LineStyle', ':', 'Color', 'k');
    
    
    
    hold off
    
    
    
    
    
    
    
    







    
    
    

