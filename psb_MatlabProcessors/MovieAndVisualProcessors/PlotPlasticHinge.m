%
% Procedure: PlotPlasticHinge.m
% -------------------
% This procedure plots one plastic hinge at a given location.  This plots
% the outer circle and the inner circle that represents the level of
% plastic rotation demand (when plastic rotation gets to cap, then the
% inner circle fills the outer circle).
%
% 
% Variable definitions:
%
%
% Assumptions and Notices: 
%       - none
%
%
% Author: Curt Haselton 
% Date Written: 12-03-04
%
% Sources of Code: none
%
% Functions and Procedures called: none
%
% Units: kips and inches
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function[] = PlotPlasticHinge(xLoc, yLoc, circleDiameter, ratioOfPlasticDemandToCap, circleLineWidth, circleLineStyle, circleInnerColor)


% Plot the outer circle - curvatures are such that it plots a circle
    rectangle('Position', [xLoc, yLoc, circleDiameter, circleDiameter], 'Curvature', [1 1], 'LineWidth', circleLineWidth, 'LineStyle', circleLineStyle)

% Plot the inner circle - compute the edge location to make the circles
% concentric
    innerCircleDiameter = ratioOfPlasticDemandToCap * circleDiameter;
    xLoc_innerCircle = xLoc + 0.5*circleDiameter - 0.5*innerCircleDiameter;
    yLoc_innerCircle = yLoc + 0.5*circleDiameter - 0.5*innerCircleDiameter;
    rectangle('Position', [xLoc_innerCircle, yLoc_innerCircle, innerCircleDiameter, innerCircleDiameter], 'Curvature', [1 1], 'LineWidth', circleLineWidth, 'LineStyle', circleLineStyle, 'FaceColor', circleInnerColor)



















