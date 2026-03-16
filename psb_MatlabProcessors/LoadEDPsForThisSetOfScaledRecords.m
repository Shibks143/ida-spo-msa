                
                    % Load data file
                    load('DATA_reducedSensDataForThisSingleRun.mat', 'PGA', 'floorAccelToSave', 'isCurrentAnalysisConv', 'maxDriftRatioForFullStr', 'storyDriftRatioToSave', 'beamAbsMaxPHRPerFloor', 'columnAbsMaxPHRPerStory', 'jointShearDistortionAbsMaxPerFloor', 'roofDriftRatioToSave');

                    % Loop and save the EDP values for this EQ/SF 
                    IDR_residual_maxAllStories.allEQs(eqIndex) = 0.0;
                    for storyNum = 1:numStories
                        IDR_max{storyNum}.allEQs(eqIndex) = storyDriftRatioToSave{storyNum}.AbsMax;
                        IDR_residual{storyNum}.allEQs(eqIndex) = abs(storyDriftRatioToSave{storyNum}.Residual);
                        % Keep track of maximum residual (absMax transient
                        % drift was done from before and is below)
                        if(abs(IDR_residual{storyNum}.allEQs(eqIndex)) > abs(IDR_residual_maxAllStories.allEQs(eqIndex)))
                            IDR_residual_maxAllStories.allEQs(eqIndex) = abs(IDR_residual{storyNum}.allEQs(eqIndex));
                        end
                    end
                    RDR_max.allEQs(eqIndex) = roofDriftRatioToSave.AbsMax;                      % Modified on 7-25-06
                    RDR_absResidual.allEQs(eqIndex) = abs(roofDriftRatioToSave.Residual);       % Added on 7-25-06
                    IDR_maxAllStories.allEQs(eqIndex) = maxDriftRatioForFullStr;
                    PGAToSave.allEQs(eqIndex) = PGA; % g-units - just two names for the same thing
                    %PGA.allEQs(eqIndex) = PGA; % g-units - just two names for the same thing
                    for floorNum = 2:numFloors
                        PFA{floorNum}.allEQs(eqIndex) = floorAccelToSave{floorNum}.absAbsMaxUnfiltered / g;
                    end     
                    beamAbsMaxPHR_maxAllFloors.allEQs(eqIndex) = 0.0;
                    for floorNum = 2:numFloors
                        beamAbsMaxPHR_allBeams{floorNum}.allEQs(eqIndex) = beamAbsMaxPHRPerFloor{floorNum}.maxAllBeams;
                        beamAbsMaxPHR_interiorBeams{floorNum}.allEQs(eqIndex) = beamAbsMaxPHRPerFloor{floorNum}.maxInteriorBeams;
                        beamAbsMaxPHR_exteriorBeams{floorNum}.allEQs(eqIndex) = beamAbsMaxPHRPerFloor{floorNum}.maxExteriorBeams;
                        if(beamAbsMaxPHR_allBeams{floorNum}.allEQs(eqIndex) > beamAbsMaxPHR_maxAllFloors.allEQs(eqIndex))
                            beamAbsMaxPHR_maxAllFloors.allEQs(eqIndex) = beamAbsMaxPHR_allBeams{floorNum}.allEQs(eqIndex);
                        end
                    end
                    columnAbsMaxPHR_maxAllStories.allEQs(eqIndex) = 0.0;
                    for storyNum = 1:numStories
                        columnAbsMaxPHR_allColumns{storyNum}.allEQs(eqIndex) = columnAbsMaxPHRPerStory{storyNum}.maxAllColumns;
                        columnAbsMaxPHR_interiorColumns{storyNum}.allEQs(eqIndex) = columnAbsMaxPHRPerStory{storyNum}.maxInteriorColumns;
                        columnAbsMaxPHR_exteriorColumns{storyNum}.allEQs(eqIndex) = columnAbsMaxPHRPerStory{storyNum}.maxExteriorColumns;
                        if(columnAbsMaxPHR_allColumns{storyNum}.allEQs(eqIndex) > columnAbsMaxPHR_maxAllStories.allEQs(eqIndex))
                            columnAbsMaxPHR_maxAllStories.allEQs(eqIndex) = columnAbsMaxPHR_allColumns{storyNum}.allEQs(eqIndex);
                        end                    
                    end
                    jointShearDistortionAbsMax_maxAllFloors.allEQs(eqIndex) = 0.0;
                    for floorNum = 2:numFloors
                        jointShearDistortionAbsMax_allJoints{floorNum}.allEQs(eqIndex) = jointShearDistortionAbsMaxPerFloor{floorNum}.maxAllJoints;
                        jointShearDistortionAbsMax_interiorJoints{floorNum}.allEQs(eqIndex) = jointShearDistortionAbsMaxPerFloor{floorNum}.maxInteriorJoints;
                        jointShearDistortionAbsMax_exteriorJoints{floorNum}.allEQs(eqIndex) = jointShearDistortionAbsMaxPerFloor{floorNum}.maxExteriorJoints;
                        if(jointShearDistortionAbsMax_allJoints{floorNum}.allEQs(eqIndex) > jointShearDistortionAbsMax_maxAllFloors.allEQs(eqIndex))
                            jointShearDistortionAbsMax_maxAllFloors.allEQs(eqIndex) = jointShearDistortionAbsMax_allJoints{floorNum}.allEQs(eqIndex);
                        end                    
                    end
                    isNonConverged = ~isCurrentAnalysisConv;
                    %cd ..;
                    clear PGA floorAccelToSave isCurrentAnalysisConv maxDriftRatioForFullStr storyDriftRatioToSave