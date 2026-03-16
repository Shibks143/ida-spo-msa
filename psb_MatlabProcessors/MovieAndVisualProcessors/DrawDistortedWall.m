%
% Procedure: DrawDistortedWall.m
% -------------------
% This procedure plots the frame in it's displaced shape.
% 
%
% Variable definitions:
%       bldgID - ID to determine which building to plot (as defined in
%               DefineInfoForBuildings.m)
%       floorDispVECTOR - vector of floor displacements (floor numbers are
%               same as defined in DefineInfoForBuildings.m; floor 1 in the
%               ground and floor 2 is the first raised floor)
%       curvatureDemandARRAY - cell array - this is an array that defines the curvature 
%               demands at each story.
%               (e.g. curvatureDemandARRAY{storyNum} = 0.0035; 
%       shearSpringDispDemandARRAY - cell array - this is an array that
%               defines the shear dispalcement (i.e. shear distortion angle
%               multiplied by story height) demands at each story.
%               (shearSpringDispDemandARRAY{storyNum})
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
% Date Written: 12-04-04
%
% Sources of Code: none
%
% Functions and Procedures called: none
%
% Units: kips and inches
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function[] = DrawDistortedWall(buildingInfo, bldgID, floorDispVECTOR, curvatureDemandVECTOR, shearSpringDispDemandVECTOR, analysisType, eqNum, saLevel, titleOption, maxOnDemandCapacityRatioToPlot, saDefType)

% Define the plot options
    % Set a scale to scale up the y-direction (make it look bigger) becuase
    % Matlab makes the plot slightly distorted.
    yScale = 1.4;   % This was scaled so it looks right on the plot (12-3-05)

    groundLineWidth = 2;
    groundLineStyle = 'k-';
    
    wallLineWidth = 1;      
    wallLineStyle = 'k-';
    
    diameterOfPHCircle = 0.75 * min(buildingInfo{bldgID}.storyHeight_upperStories, buildingInfo{bldgID}.wallWidth);
    circleLineWidth = 1;      
    circleLineStyle = '-';
    circleInnerColor = 'b';     % For the smaller circle that shows the level of plastic rotation demand  
    circleInnerColor_afterCap = 'r';     % For the smaller circle that shows the level of plastic rotation demand  

    % Information for the inner rectangle for the shear deformation
    rectangleDimension = diameterOfPHCircle;
    rectLineWidth = 1;      
    rectLineStyle = '-';
    rectInnerColor = 'b';               % For the smaller rectangle that shows the level of plastic rotation demand  
    rectInnerColor_afterCap = 'r';     % For the smaller rectangle that shows the level of plastic rotation demand  
    
    % Decide the smallest value that the PHR ratio shhould be to plot it
    smallestDemandCapacityRatioToPlot = 0.05;   % 5% of the capping plastic rotation

    % Limit the height of the inner rectangle so it does not go vertically
    % out of the outer rectangle
    isLimitHeightOfInnerRect = 1;   

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Do computations for the joint plastic hinge demands
    numStories = buildingInfo{bldgID}.numStories;
    numFloors = numStories + 1;
    
    % Loop over all stories and compute the damage ratios for flexure and
    % shear
    for currentStoryNum = 1:numStories        
        demandCapacityRatio{currentStoryNum}.flexuralCurvature = min(maxOnDemandCapacityRatioToPlot, (curvatureDemandVECTOR{currentStoryNum} /  buildingInfo{bldgID}.curvatureCap(currentStoryNum)));
        demandCapacityRatio{currentStoryNum}.shearSpringDisp = min(maxOnDemandCapacityRatioToPlot, (shearSpringDispDemandVECTOR{currentStoryNum} /  buildingInfo{bldgID}.shearSpringDispCap(currentStoryNum)));
    
%         % Checks
%         currentStoryNum
%         currentFlexDemandCapacityRatio = demandCapacityRatio{currentStoryNum}.flexuralCurvature
%         currentShearDemandCapacityRatio = demandCapacityRatio{currentStoryNum}.shearSpringDisp
    
    end; % end for storyNum loop
    
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Do this plotting
% Initialize the plot
    % Make axes so frame in centered - make (0,0) at left bottom corner of
    % frame.  Also, make sure the plot dimension is symetrical in x and y
    % (so the building doesn't look stretched).
    xDimNeededForBldg = buildingInfo{bldgID}.wallWidth;
    yDimNeededForBldg = buildingInfo{bldgID}.storyHeight_upperStories * buildingInfo{bldgID}.numStories;
    maxDimNeededForBldg = 1.35*max(xDimNeededForBldg, (yDimNeededForBldg * yScale));
    xMin = (-0.50 * maxDimNeededForBldg + 0.5*xDimNeededForBldg);
    xMax = (+0.50 * maxDimNeededForBldg + 0.5*xDimNeededForBldg);
    yMin = (-0.50 * maxDimNeededForBldg / yScale + 0.5*yDimNeededForBldg);
    yMax = (+0.50 * maxDimNeededForBldg / yScale + 0.5*yDimNeededForBldg);
    %(Note: axis set after plotting)
  
% Draw a line for the ground
    xLeft = (-0.25*buildingInfo{bldgID}.wallWidth);
    xRight = (xDimNeededForBldg + 0.25*buildingInfo{bldgID}.wallWidth);
    plot([xLeft, xRight], [0.0, 0.0], groundLineStyle, 'LineWidth', groundLineWidth);
    hold on
    
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Loop and plot all of the wall lines.  Also plot the PH circle and the
% shear boxes in this same loop.
    for currentStory = 1:numStories
        % Floor numbers
        currentFloorNum_bottom = currentStory;
        currentFloorNum_top = currentStory + 1;
        
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        % Plot the wall edge lines
        % x-locations
        lineLocation_bottom_x_left = 0.0 + floorDispVECTOR(currentFloorNum_bottom);
        lineLocation_top_x_left = 0.0 + floorDispVECTOR(currentFloorNum_top);
        lineLocation_bottom_x_right = 0.0 + floorDispVECTOR(currentFloorNum_bottom) + buildingInfo{bldgID}.wallWidth;
        lineLocation_top_x_right = 0.0 + floorDispVECTOR(currentFloorNum_top) + buildingInfo{bldgID}.wallWidth;
        % y-locations
        if(currentStory == 1)
            lineLocation_bottom_y_right = 0.0;
            lineLocation_top_y_right = buildingInfo{bldgID}.storyHeight_firstStory;
            lineLocation_bottom_y_left = lineLocation_bottom_y_right;
            lineLocation_top_y_left = lineLocation_top_y_right;
        elseif(currentStory == numStories)
            % Change the heights of the edges of the wall to make it look
            % like the wall is deforming correctly.  To do this, take the
            % drift level of the top floor and multiply it by 1/2 the wall
            % width.
            topStoryDrift = (lineLocation_top_x_left - lineLocation_bottom_x_left) / buildingInfo{bldgID}.storyHeight_upperStories;
            % Compute vertical displacement from top story drift assuming
            % top of wall and side of wall make a 90 degree angle.
            verticalDispOfWallEdgeAtRoof_left = 0.5*topStoryDrift * buildingInfo{bldgID}.wallWidth;
            verticalDispOfWallEdgeAtRoof_right = -verticalDispOfWallEdgeAtRoof_left;
            % Compute the top y-locations
            lineLocation_top_y_left = verticalDispOfWallEdgeAtRoof_left + (buildingInfo{bldgID}.storyHeight_firstStory + (max((currentFloorNum_top - 2),0))*buildingInfo{bldgID}.storyHeight_upperStories);
            lineLocation_top_y_right = verticalDispOfWallEdgeAtRoof_right + (buildingInfo{bldgID}.storyHeight_firstStory + (max((currentFloorNum_top - 2),0))*buildingInfo{bldgID}.storyHeight_upperStories);
            % Bottom location just like other floors
            lineLocation_bottom_y_right = (buildingInfo{bldgID}.storyHeight_firstStory + (max((currentFloorNum_bottom - 2),0))*buildingInfo{bldgID}.storyHeight_upperStories);
            lineLocation_bottom_y_left = lineLocation_bottom_y_right;
        else
            lineLocation_bottom_y_right = (buildingInfo{bldgID}.storyHeight_firstStory + (max((currentFloorNum_bottom - 2),0))*buildingInfo{bldgID}.storyHeight_upperStories);
            lineLocation_top_y_right = (buildingInfo{bldgID}.storyHeight_firstStory + (max((currentFloorNum_top - 2),0))*buildingInfo{bldgID}.storyHeight_upperStories);            
            lineLocation_bottom_y_left = lineLocation_bottom_y_right;
            lineLocation_top_y_left = lineLocation_top_y_right;
        end
        % Plot
        plot([lineLocation_bottom_x_left, lineLocation_top_x_left], [lineLocation_bottom_y_left, lineLocation_top_y_left], wallLineStyle, 'LineWidth', wallLineWidth);
        plot([lineLocation_bottom_x_right, lineLocation_top_x_right], [lineLocation_bottom_y_right, lineLocation_top_y_right], wallLineStyle, 'LineWidth', wallLineWidth);
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        % Compute the locations of the PH circle and then plot it for this
        % story.
        % Place the PH circle in the LEFT one half of the displaced story
        centerXLocationInStory = 0.5 * (lineLocation_bottom_x_left + lineLocation_top_x_right) - 0.25*buildingInfo{bldgID}.wallWidth;
        centerYLocationInStory = 0.5 * (lineLocation_bottom_y_left + lineLocation_top_y_right);
        phCircleLeftBottomCorner_x = centerXLocationInStory - 0.5*diameterOfPHCircle;
        phCircleLeftBottomCorner_y = centerYLocationInStory - 0.5*diameterOfPHCircle;
        % Compute current felxural demand/capacity ratio
        currentFlexDemandCapacityRatio = demandCapacityRatio{currentStory}.flexuralCurvature;
        % Plot the circle if the ratio is over the threshold
            if(currentFlexDemandCapacityRatio > smallestDemandCapacityRatioToPlot)
                if(currentFlexDemandCapacityRatio < 1.0)
                    % Plot PH normal color
                    PlotPlasticHinge(phCircleLeftBottomCorner_x, phCircleLeftBottomCorner_y, diameterOfPHCircle, currentFlexDemandCapacityRatio, circleLineWidth, circleLineStyle, circleInnerColor);
                else 
                    % Plot red
                    PlotPlasticHinge(phCircleLeftBottomCorner_x, phCircleLeftBottomCorner_y, diameterOfPHCircle, currentFlexDemandCapacityRatio, circleLineWidth, circleLineStyle, circleInnerColor_afterCap);
                end
                hold on
            end
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        % Compute the locations of the shear damage squares and then plot it for this
        % story.
        % Place the shear damage squares in the RIGHT one half of the displaced story
        centerXLocationInStory = 0.5 * (lineLocation_bottom_x_left + lineLocation_top_x_right) + 0.25*buildingInfo{bldgID}.wallWidth;
        centerYLocationInStory = 0.5 * (lineLocation_bottom_y_left + lineLocation_top_y_right);
        shearSquareLeftBottomCorner_x = centerXLocationInStory - 0.5*rectangleDimension;
        shearSquareLeftBottomCorner_y = centerYLocationInStory - 0.5*rectangleDimension;
        % Compute current felxural demand/capacity ratio
        currentShearDemandCapacityRatio = demandCapacityRatio{currentStory}.shearSpringDisp;
        % Plot the square if the ratio is over the threshold
            if(currentShearDemandCapacityRatio > smallestDemandCapacityRatioToPlot)
                % Plot with shear damage.  Plot color differently if
                % before or after the cap
                if(currentShearDemandCapacityRatio < 1.0)
                    % Plot with non-capped color
                    PlotRectangleWithInnerRect(shearSquareLeftBottomCorner_x, shearSquareLeftBottomCorner_y, rectangleDimension, rectangleDimension, currentShearDemandCapacityRatio, rectLineWidth, rectLineStyle, rectInnerColor, isLimitHeightOfInnerRect);
                else
                    % Plot with capped color
                    PlotRectangleWithInnerRect(shearSquareLeftBottomCorner_x, shearSquareLeftBottomCorner_y, rectangleDimension, rectangleDimension, currentShearDemandCapacityRatio, rectLineWidth, rectLineStyle, rectInnerColor_afterCap, isLimitHeightOfInnerRect);
                end
            else
                % Don't plot anything 
            end
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    end         
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    % Plot the line for the top of the wall.  This line uses the fact that
    % the loop above ended with the top story
    plot([lineLocation_top_x_left, lineLocation_top_x_right], [lineLocation_top_y_left, lineLocation_top_y_right], wallLineStyle, 'LineWidth', wallLineWidth);
            

        
        
        
%         % Plot the boxes to show the shear damage
%                         % Find joint location
%                 jointLeftBottomCorner_x = ((currentColLineNum - 1) * buildingInfo{bldgID}.bayWidth + floorDispVECTOR(currentFloorNum) - 0.5*buildingInfo{bldgID}.jointWidth);
%                 jointLeftBottomCorner_y = (buildingInfo{bldgID}.storyHeight_firstStory + (max((currentFloorNum - 2),0))*buildingInfo{bldgID}.storyHeight_upperStories - 1.0*buildingInfo{bldgID}.jointHeight);
%             % Find the level of shear damage
%                 currentPlasticRotationDemandCapacityRatio = plasticRotationDemandCapacityRatio{currentFloorNum, currentColLineNum}.jointNode{currentJointNodeNum};
%             % Now plot the rectangle.  If there is only slight shear damage
%             %   (less than smallestPHRRatioToPlot), then plot the joint
%             %   with no shear damage shown, otherwise show shear damage.
%                 if(currentPlasticRotationDemandCapacityRatio > smallestPHRRatioToPlot)
%                     % Plot with shear damage.  Plot color differently if
%                     % before or after the cap
%                     if(currentPlasticRotationDemandCapacityRatio < 1.0)
%                         % Plot with non-capped color
%                         PlotRectangleWithInnerRect(jointLeftBottomCorner_x, jointLeftBottomCorner_y, buildingInfo{bldgID}.jointWidth, buildingInfo{bldgID}.jointHeight, currentPlasticRotationDemandCapacityRatio, rectLineWidth, rectLineStyle, rectInnerColor_toUse)
%                     else
%                         % Plot with capped color
%                         PlotRectangleWithInnerRect(jointLeftBottomCorner_x, jointLeftBottomCorner_y, buildingInfo{bldgID}.jointWidth, buildingInfo{bldgID}.jointHeight, currentPlasticRotationDemandCapacityRatio, rectLineWidth, rectLineStyle, rectInnerColor_afterCap_toUse)
%                     end
%                 else
%                     % Plot without shear damage
%                     currentPlasticRotationDemandCapacityRatio = 0.0;
%                     PlotRectangleWithInnerRect(jointLeftBottomCorner_x, jointLeftBottomCorner_y, buildingInfo{bldgID}.jointWidth, buildingInfo{bldgID}.jointHeight, currentPlasticRotationDemandCapacityRatio, rectLineWidth, rectLineStyle, rectInnerColor_toUse)
%                 end
            
            
    
            
% Scale the axis (from calcs above)
    axis([xMin xMax yMin yMax])

% Set the axes to be white to remove them from the plot
    %set(gca,'Color','w', 'XColor','w', 'YColor','w');

% Change the location of the axes, so we cannot see them
    set(gca,'XTick', [-1000000000, 100000000000]);
    set(gca,'YTick', [-1000000000, 100000000000]);
    
    
% Put a label on the figure
    if(titleOption == 1)
        % Use long title
        switch saDefType
            case 1
                titleText = sprintf('Analysis: %s, EQ: %d, Sa_{comp}(T=1sec): %.2fg', analysisType, eqNum, saLevel);
            case 2
                titleText = sprintf('Analysis: %s, EQ: %d, Sa_{g.m.}(T=1sec): %.2fg', analysisType, eqNum, saLevel);
            case 3
                titleText = sprintf('Analysis: %s, EQ: %d, Sa_{code}(T=1sec): %.2fg', analysisType, eqNum, saLevel);
            otherwise
                error('Invalid value for saDefType!');
        end
        %title(titleText);
        hx = xlabel(titleText); % Changed to be on the x-labl on 12-9-05
    elseif(titleOption == 2)
        % Use short title
        titleText = sprintf('EQ: %d, Sa(T=1sec): %.2fg', eqNum, saLevel);
        switch saDefType
            case 1
                titleText = sprintf('EQ: %d, Sa_{comp}(T=1sec): %.2fg', eqNum, saLevel);
            case 2
                titleText = sprintf('EQ: %d, Sa_{g.m.}(T=1sec): %.2fg', eqNum, saLevel);
            case 3
                titleText = sprintf('EQ: %d, Sa_{code}(T=1sec): %.2fg', eqNum, saLevel);
            otherwise
                error('Invalid value for saDefType!');
        end
        %title(titleText);
        hx = xlabel(titleText); % Changed to be on the x-labl on 12-9-05
    else
        error('Invalid titleOption');
    end
    
    annotation('textbox',[0.25 0.12 0.55 0.06],'String','Deierlein, Haselton, Takagi, Liel (Stanford University)', 'FontWeight', 'bold', 'EdgeColor', 'k', 'FontSize', 8, 'LineWidth', 1, 'LineStyle', ':', 'Color', 'k');
    %annotation('textbox',[0.5 0.005 0.45 0.06],'String','Deierlein, Haselton, Liel; Stanford University', 'FontWeight', 'bold', 'EdgeColor', 'k', 'FontSize', 8, 'LineWidth', 1, 'LineStyle', ':', 'Color', 'k');
    hold off
    
    
    
    
    
    
    
    
    







    
    
    

