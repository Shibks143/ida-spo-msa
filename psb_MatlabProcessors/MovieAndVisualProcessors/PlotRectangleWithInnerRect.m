%
% Procedure: PlotRectangleWithInnerRect.m
% -------------------
% This procedure plots rectangle (can be used for a joint in a frame or a
%   rectangle to show shear damage in a wall visual) and an inner rectangle
%   to show the level of shear damage.
%
% 
% Variable definitions:
%       - isLimitHeightOfInnerRect - if this is ==1, then the inner
%       rectangle height never goes beyond the outer rectangle height (for
%       shear wall movies)
%
% Assumptions and Notices: 
%       - none
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
function[] = PlotRectangleWithInnerRect(xLoc, yLoc, rectWidth, rectHeight, ratioOfPlasticDemandToCap, rectLineWidth, rectLineStyle, rectInnerColor, isLimitHeightOfInnerRect)

% Define a lower bound plastic rotation demand for the inner rectangle to be
% plotted.  This is done because when the inner rectangle has zero
% dimension, then the rectangle plotter returns an error.  If the plastic
% rotation demand is small, then we don't need an inner rectangle anyway,
% so just exclude it!
    minRatioOfPlasticDemandToCapToPlot = 0.01;

% Plot the outer rectangle
    rectangle('Position', [xLoc, yLoc, rectWidth, rectHeight], 'Curvature', [0.0,0.0], 'LineWidth', rectLineWidth, 'LineStyle', rectLineStyle);

% Plot the inner rectangle - compute the edge location to make the
%   rectangles concentric.  Only plot this if the ratioOfPlasticDemandToCap
%   is > 0.01 (to avoid an error trying to plot an inner rectangle that doesn't
%   exist).
    if(ratioOfPlasticDemandToCap > minRatioOfPlasticDemandToCapToPlot)
        currentWidthOfInnerRectangle = ratioOfPlasticDemandToCap * rectWidth;
        currentHeightOfInnerRectangle = ratioOfPlasticDemandToCap * rectHeight;
        % Adjust the height of the inner rectangle if appropriate
        if((isLimitHeightOfInnerRect == 1) && (currentHeightOfInnerRectangle > rectHeight))
            currentHeightOfInnerRectangle = rectHeight;
        end
        xLoc_innerRect = xLoc + 0.5*rectWidth - 0.5*currentWidthOfInnerRectangle;
        yLoc_innerRect = yLoc + 0.5*rectHeight - 0.5*currentHeightOfInnerRectangle;
        rectangle('Position', [xLoc_innerRect, yLoc_innerRect, currentWidthOfInnerRectangle, currentHeightOfInnerRectangle], 'Curvature', [0.0,0.0], 'LineWidth', rectLineWidth, 'LineStyle', rectLineStyle, 'FaceColor', rectInnerColor);
        hold on
    end


