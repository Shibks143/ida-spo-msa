%
% Procedure: PlotThingsForMultipleRuns.m
% -------------------
% This procedure simply calls the Plot scripts multiple times to plot a lot of data.
% 
% Assumptions and Notices: 
%
% Author: Curt Haselton 
% Date Written: 5-11-04
%
% Units: Whatever OpenSees is using - just be consistent!
%
% -------------------

maxNumPoints = 1000000000;
markerType = 'b';

figureNum = 0;

nodeNum = 72;
dofNum = 1;

    for analysisTypeNum = 1:length(analysisTypeLIST)
        
        for saLevelNum = 1:length(saLevelLIST)

            for eqNameNum = 1:length(eqNameLIST)

                analysisType = analysisTypeLIST{analysisTypeNum}
                saLevel = saLevelLIST(saLevelNum)
                eqName = eqNameLIST{eqNameNum}
                figureNum = figureNum + 1;

                % Do all of the stuff in here that you want done for each of these runs
                figure(figureNum);
                
                PlotNodeDisplTH
                
                
                

            end

        end 

    end
    
    
    
    % Plot pushover if needed
    
    if(plotPushover == 1)
        
        saLevelNum = 0.00;
        eqName = 'Pushover';
        
        for analysisTypeNum = 1:length(analysisTypeLIST)
            analysisType = analysisTypeLIST{analysisTypeNum}
            figureNum = figureNum + 1;
            figure(figureNum);
            
            PlotPushover
            
        
        end
        
    end 
    
    
    
    
    
    
    
    
    
    % Just for reference...
    %function[void] = PlotNodeDisplTH(nodeNum, dofNum, analysisType, saLevel, eqName, maxNumPoints, markerType)