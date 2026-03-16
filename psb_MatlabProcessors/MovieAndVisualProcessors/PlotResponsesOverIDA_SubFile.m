                    % Open the data file
                    startingPath = [pwd];
                    cd ..;
                    cd ..;
                    cd Output;
                    cd(analysisType);
                    eqFolder = sprintf('EQ_%d', eqNumber);
                    saFolder = sprintf('Sa_%.2f', saLevel);
                    cd(eqFolder);
                    cd(saFolder);
                    load('DATA_allDataForThisSingleRun.mat', 'elementArray', 'nodeArray', 'nodeNumsAtEachFloorLIST', 'storyDriftRatio');
                    cd(startingPath);                

                    % Plot the joint response.  I know it is bad, but do
                    % some hard-coding
                    currentAnalysisStepNum = 1;
                    markerTypeLine = markerTypeLineForIDA;
                    currentResponseDotFaceColor = 'w';
                    DrawJointResponseWithDot(buildingInfo, bldgID, analysisType, eqNumber, saLevel, colLineNum, floorNum, jointNodeNum, elementArray, currentAnalysisStepNum, markerTypeLine, currentResponseDotFaceColor)
   