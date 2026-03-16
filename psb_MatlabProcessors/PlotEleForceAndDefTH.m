%
% Procedure: PlotEleForceAndDefTH.m
% -------------------
% This procedure plots the element end force and deformation an earthquake or PO.
% 
% Assumptions and Notices: 
%           - 
%
% Author: Curt Haselton 
% Date Written: 5-13-04
%
% Sources of Code: none
%
% Functions and Procedures called: none
%
% Variable definitions: 
%           - eleEndNum - 1 is end i, 2 is end j
%           - responseNum - 1 is axial, 2 is flexural
%
%
% Units: Whatever OpenSees is using - just be consistent!
%
% -------------------
%function[void] = PlotEleEndForceAndDefTH(eleNum, eleEndNum, responseNum, analysisType, saTOneForRun, eqNumber, maxNumPoints, markerType)

% First change the directory to get into the correct folder for processing
cd ..;
cd Output;
cd(analysisType);



% saTOneForRun = 0.00;
% eqNumber = 999;


% Create Sa and EQ folder names for later use
saFolder = sprintf('Sa_%.2f', saTOneForRun);
eqFolder = sprintf('EQ_%d', eqNumber);

% Open the .mat file that holds all of the data that we need, go into folder to get it
cd(eqFolder);
cd(saFolder);
load('DATA_allDataForThisSingleRun.mat');

% Do plot
    eleForceDefTotalArray = elementArray{eleNum}.forceAndDeformation; % Note that this is a structure with information for both ends i and j
    
    % Choose the correct end information based on the user input into eleEndNum (1=endi, 2=endj)
        if(eleEndNum == 1)
            % Use end i
            disp('End i being used for forceDef plot')
            eleForceDefEndArray = eleForceDefTotalArray.endi;
        elseif (eleEndNum == 2)
            % Use end j
            disp('End j being used for forceDef plot')
            eleForceDefEndArray = eleForceDefTotalArray.endj  ;   
        else
            disp('Error!!! The eleEndNum needs to be 1 or 2 (1=endi, 2=endj)')
        end
    
    
        % Choose the correct responseNum (1=axial, 2=flexural) information based on the user input into responseNum
        if(responseNum == 1)
            % Use end i
            disp('Axial response being plotted')
            
            % Make vectors for the plot
            axialStrainVector = eleForceDefEndArray(:, 1);
            axialForceVector = eleForceDefEndArray(:, 3);

            % Do plot and definitions for labels
            plot(axialStrainVector, axialForceVector, markerType);
            legendName = sprintf('forceAndDef in Element %d, end %d, axial DOF ', eleNum, eleEndNum);
            titleText = sprintf('Axial-Strain Responce in Element %d for end %d at Sa of %.2f for EQ %d for Analysis %s', eleNum, eleEndNum, saTOneForRun, eqNumber, analysisType);
            yLabel = sprintf('Local Force End Section of Element %d, End %d (units)', eleNum, eleEndNum);
            xlabel('Axial Strain of Section (units)');

        elseif (responseNum == 2)
            % Use end j
            disp('Flexural response being plotted')

            % Make vectors for the plot
            curvatureVector = eleForceDefEndArray(:, 2);
            momentVector = eleForceDefEndArray(:, 4);

            % Do plot and definitions for labels
            plot(curvatureVector, momentVector, markerType);
            legendName = sprintf('forceAndDef in Element %d, end %d, flexural DOF ', eleNum, eleEndNum);
            titleText = sprintf('Moment-Curvature Responce in Element %d for end %d at Sa of %.2f for EQ %d for Analysis %s', eleNum, eleEndNum, saTOneForRun, eqNumber, analysisType);
            yLabel = sprintf('Local Force End Section of Element %d, End %d (units)', eleNum, eleEndNum);
            xlabel('Curvature of Section (units)');

        else
            disp('Error!!! The responseNum needs to be 1 or 2 (1=axial, 2=flexural)')
        end
        titleText

    % Plot - note that the psuedoTimeVector is from the file that was opened 

    
    hold on
    legend(legendName);
    grid on
    title(titleText);
    ylabel(yLabel);
    hold off


% Get back to the MatlabProcessors folder where we started
cd ..;
cd ..;
cd ..;
cd ..;
cd MatlabProcessors;
