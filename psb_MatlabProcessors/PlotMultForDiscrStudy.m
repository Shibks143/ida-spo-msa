%
% Procedure: 
% -------------------
% This procedure is just work that I did to plot all of the stuff that I needed for the discretization study.
% 
% Assumptions and Notices: 
%
% Author: Curt Haselton 
% Date Written: 6-11-04
%
% Units: 
%
% -------------------

% Do all plots to compare different levels of discretization - 2, 3, 4 elements per hinge region (all with numIntPts = 3).  Use the following models:
%   - VarID1-v.13 - 2 ele per hinge
%   - VarID1-v.14 - 3 ele per hinge
%   - VarID1-v.15 - 4 ele per hinge

% Decide what you want to plot...
%     plotDisplTH = 1;
    plotDisplTH = 0;

%     plotStoryDrifts = 1;
    plotStoryDrifts = 0;
    
%     plotPFAs = 1;
    plotPFAs = 0;

    plotHingeMRot = 1;
%     plotHingeMRot = 0;

    if(plotHingeMRot == 1)
        memberNumToPlotHingeLIST = [1]; % Element numbers to plot hinge responces
        memberEndNumLIST = [1]; % Parallel list
    end


% Do plots for TH responces, peak story drifts, PFA's and hinge rotations...

% First, define some stuff that will be needed later.
    maxNumPoints = 1000000000;
    dofNum = 1;     % All plots of lateral displacements
    % Define what runs and Sa levels to use for the plots...
    eqNumber = 1;
    analysisTypeLIST = {'(MeanDesign_VarID1_v.13)_(AllVar)_(Mean)_(dispBeamColumn)', '(MeanDesign_VarID1_v.14)_(AllVar)_(Mean)_(dispBeamColumn)', '(MeanDesign_VarID1_v.15)_(AllVar)_(Mean)_(dispBeamColumn)'};
    numElePerHingeLIST = [2, 3, 4]; %Parallel list showing numEle per hinge for th above models (for hinge rotation calcs and plots).
    saTOneForRunLIST = [0.30, 1.50, 0.75];
    markerTypeLIST = ['b:', 'r-', 'b-.'];   % Marker types to use for analyses
    figureNum = 1;


% Do TH floor displacement plots...
if(plotDisplTH == 1)
    % Loop for all plots that need to be done.
    for(saIndex = 1:length(saTOneForRunLIST))
        saTOneForRun = saTOneForRunLIST(saIndex);
        disp(saTOneForRun)
        
        % Plot roof (floor 5 displ. TH) - node 289
            figure(figureNum)
            nodeNum = 289;
        
            for(analysisTypeIndex = 1: length(analysisTypeLIST))
                analysisType = analysisTypeLIST{analysisTypeIndex};
                markerType = markerTypeLIST(analysisTypeIndex);
                
                % Call the plot procedure
                PlotNodeDisplTH
                
                hold on
            end
        
            legend('2 ele per hinge', '3 ele per hinge', '4 ele per hinge');
            titleText = sprintf('Comparison of Roof Displacements for Levels of Discretization, EQ1, Sa of %.2f g', saTOneForRun)
            title(titleText)
            xlabel('Time (seconds)')
            ylabel('Lateral Displacement (inches)')

            % Go to the next figure
            hold off
            figureNum = figureNum + 1;
            
        % Plot floor 4 (floor 5 displ. TH) - node 199
            figure(figureNum)
            nodeNum = 199;
        
            for(analysisTypeIndex = 1: length(analysisTypeLIST))
                analysisType = analysisTypeLIST{analysisTypeIndex};
                markerType = markerTypeLIST(analysisTypeIndex);
                
                % Call the plot procedure
                PlotNodeDisplTH
                
                hold on
            end
        
            legend('2 ele per hinge', '3 ele per hinge', '4 ele per hinge');
            titleText = sprintf('Comparison of Floor Four Displacements for Levels of Discretization, EQ1, Sa of %.2f g', saTOneForRun)
            title(titleText)
            xlabel('Time (seconds)')
            ylabel('Lateral Displacement (inches)')

            % Go to the next figure
            hold off
            figureNum = figureNum + 1;
            
        % Plot floor 3 (floor 3 displ. TH) - node 109
            figure(figureNum)
            nodeNum = 109;
        
            for(analysisTypeIndex = 1: length(analysisTypeLIST))
                analysisType = analysisTypeLIST{analysisTypeIndex};
                markerType = markerTypeLIST(analysisTypeIndex);
                
                % Call the plot procedure
                PlotNodeDisplTH
                
                hold on
            end
        
            legend('2 ele per hinge', '3 ele per hinge', '4 ele per hinge');
            titleText = sprintf('Comparison of Floor Three Displacements for Levels of Discretization, EQ1, Sa of %.2f g', saTOneForRun)
            title(titleText)
            xlabel('Time (seconds)')
            ylabel('Lateral Displacement (inches)')

            % Go to the next figure
            hold off
            figureNum = figureNum + 1;
            
        % Plot floor 2 (floor 2 displ. TH) - node 19
            figure(figureNum)
            nodeNum = 19;
        
            for(analysisTypeIndex = 1: length(analysisTypeLIST))
                analysisType = analysisTypeLIST{analysisTypeIndex};
                markerType = markerTypeLIST(analysisTypeIndex);
                
                % Call the plot procedure
                PlotNodeDisplTH
                
                hold on
            end
        
            legend('2 ele per hinge', '3 ele per hinge', '4 ele per hinge');
            titleText = sprintf('Comparison of Floor Two Displacements for Levels of Discretization, EQ1, Sa of %.2f g', saTOneForRun)
            title(titleText)
            xlabel('Time (seconds)')
            ylabel('Lateral Displacement (inches)')

            % Go to the next figure
            hold off
            figureNum = figureNum + 1;
    end
end
    
 

% Do story drift plots...
if(plotStoryDrifts == 1)
    % Loop for all plots that need to be done.
    for(saIndex = 1:length(saTOneForRunLIST))
        figure(figureNum)
        saTOneForRun = saTOneForRunLIST(saIndex);
        disp(saTOneForRun)
        
            for(analysisTypeIndex = 1: length(analysisTypeLIST))
                analysisType = analysisTypeLIST{analysisTypeIndex};
                markerType = markerTypeLIST(analysisTypeIndex);
                
                % Call the plot procedure
                PlotMaxDriftLevel
                
                hold on
            end
        
            legend('2 ele per hinge', '3 ele per hinge', '4 ele per hinge');
            titleText = sprintf('Comparison of Story Drifts for Levels of Discretization, EQ1, Sa of %.2f g', saTOneForRun)
            title(titleText)
            xlabel('Story Drift (% drift)')
            ylabel('Floor Number')
         
            % Go to the next figure
            hold off
            figureNum = figureNum + 1;
    end
end



% Do PFA plots...
if(plotPFAs == 1)
    % Loop for all plots that need to be done.
    for(saIndex = 1:length(saTOneForRunLIST))
        figure(figureNum)
        saTOneForRun = saTOneForRunLIST(saIndex);
        disp(saTOneForRun)
        
            for(analysisTypeIndex = 1: length(analysisTypeLIST))
                analysisType = analysisTypeLIST{analysisTypeIndex};
                markerType = markerTypeLIST(analysisTypeIndex);
                
                % Call the plot procedure
                PlotMaxFloorAccel
                
                hold on
            end
        
            legend('2 ele per hinge', '3 ele per hinge', '4 ele per hinge');
            titleText = sprintf('Comparison of Floor Accelerations for Levels of Discretization, EQ1, Sa of %.2f g', saTOneForRun)
            title(titleText)
            xlabel('Peak Floor Acceleration (g)')
            ylabel('Floor Number')
         
            % Go to the next figure
            hold off
            figureNum = figureNum + 1;
    end
end




% Do hinge responce plots...
if(plotHingeMRot == 1)
    
    % Loop for all hinge to be plotted
    for(hingePlotIndex = 1:length(memberNumToPlotHingeLIST))
        memberNum = memberNumToPlotHingeLIST(hingePlotIndex);
        memberEndNum = memberEndNumLIST(hingePlotIndex);

        % Loop for all plots that need to be done.
        for(saIndex = 1:length(saTOneForRunLIST))
            figure(figureNum)
            saTOneForRun = saTOneForRunLIST(saIndex);
            disp(saTOneForRun)
        
                for(analysisTypeIndex = 1: length(analysisTypeLIST))
                    analysisType = analysisTypeLIST{analysisTypeIndex};
                    markerType = markerTypeLIST(analysisTypeIndex);
                    numElePerHinge = numElePerHingeLIST(analysisTypeIndex)
                
                    % Call the plot procedure
                    PlotMRotTHDisplEle
                
                    hold on
                end
        
                legend('2 ele per hinge', '3 ele per hinge', '4 ele per hinge');
                titleText = sprintf('Comparison of Hinge Rotations for Levels of Discr., EQ1, Sa of %.2f g, Member %d, end %d', saTOneForRun, memberNum, memberEndNum)
                title(titleText)
                xlabel('Hinge Rotation (radians)')
                ylabel('Moment (kip-inch)')
         
                % Go to the next figure
                hold off
                figureNum = figureNum + 1;
        end
    end
end





