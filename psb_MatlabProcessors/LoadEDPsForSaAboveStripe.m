                    saFolderName = sprintf('Sa_%.2f', saLevel_aboveStripe);
                    cd(saFolderName);
                    load('DATA_reducedSensDataForThisSingleRun.mat', 'PGA', 'floorAccelToSave', 'isCurrentAnalysisConv', 'maxDriftRatioForFullStr', 'storyDriftRatioToSave', 'beamAbsMaxPHRPerFloor', 'columnAbsMaxPHRPerStory', 'jointShearDistortionAbsMaxPerFloor', 'roofDriftRatioToSave', 'periodUsedForScalingGroundMotionsFromMatlab');
                    % Loop and save the EDP values for this EQ/Sa below the
                    % stripe Sa 
                    for storyNum = 1:numStories
                        IDR_max_aboveStripe{storyNum} = storyDriftRatioToSave{storyNum}.AbsMax;
                        IDR_residual_aboveStripe{storyNum} = abs(storyDriftRatioToSave{storyNum}.Residual);
                    end
                    RDR_max_aboveStripe = roofDriftRatioToSave.AbsMax;                      % Modified on 7-25-06
                    RDR_absResidual_aboveStripe = abs(roofDriftRatioToSave.Residual);       % Added on 7-25-06
                    IDR_maxAllStories_aboveStripe = maxDriftRatioForFullStr;
                    PGA_aboveStripe = PGA; % g-units
                    for floorNum = 2:numFloors
                        PFA_aboveStripe{floorNum} = floorAccelToSave{floorNum}.absAbsMaxUnfiltered / g;
                    end     
                    beamAbsMaxPHR_maxAllFloors_aboveStripe = 0.0;
                    for floorNum = 2:numFloors
                        beamAbsMaxPHR_allBeams_aboveStripe{floorNum} = beamAbsMaxPHRPerFloor{floorNum}.maxAllBeams;
                        beamAbsMaxPHR_interiorBeams_aboveStripe{floorNum} = beamAbsMaxPHRPerFloor{floorNum}.maxInteriorBeams;
                        beamAbsMaxPHR_exteriorBeams_aboveStripe{floorNum} = beamAbsMaxPHRPerFloor{floorNum}.maxExteriorBeams;
                        if(beamAbsMaxPHR_allBeams_aboveStripe{floorNum} > beamAbsMaxPHR_maxAllFloors_aboveStripe)
                            beamAbsMaxPHR_maxAllFloors_aboveStripe = beamAbsMaxPHR_allBeams_aboveStripe{floorNum};
                        end
                    end
                    columnAbsMaxPHR_maxAllStories_aboveStripe = 0.0;
                    for storyNum = 1:numStories
                        columnAbsMaxPHR_allColumns_aboveStripe{storyNum} = columnAbsMaxPHRPerStory{storyNum}.maxAllColumns;
                        columnAbsMaxPHR_interiorColumns_aboveStripe{storyNum} = columnAbsMaxPHRPerStory{storyNum}.maxInteriorColumns;
                        columnAbsMaxPHR_exteriorColumns_aboveStripe{storyNum} = columnAbsMaxPHRPerStory{storyNum}.maxExteriorColumns;
                        if(columnAbsMaxPHR_allColumns_aboveStripe{storyNum} > columnAbsMaxPHR_maxAllStories_aboveStripe)
                            columnAbsMaxPHR_maxAllStories_aboveStripe = columnAbsMaxPHR_allColumns_aboveStripe{storyNum};
                        end                    
                    end
                    jointShearDistortionAbsMax_maxAllFloors_aboveStripe = 0.0;
                    for floorNum = 2:numFloors
                        jointShearDistortionAbsMax_allJoints_aboveStripe{floorNum} = jointShearDistortionAbsMaxPerFloor{floorNum}.maxAllJoints;
                        jointShearDistortionAbsMax_interiorJoints_aboveStripe{floorNum} = jointShearDistortionAbsMaxPerFloor{floorNum}.maxInteriorJoints;
                        jointShearDistortionAbsMax_exteriorJoints_aboveStripe{floorNum} = jointShearDistortionAbsMaxPerFloor{floorNum}.maxExteriorJoints;
                        if(jointShearDistortionAbsMax_allJoints_aboveStripe{floorNum} > jointShearDistortionAbsMax_maxAllFloors_aboveStripe)
                            jointShearDistortionAbsMax_maxAllFloors_aboveStripe = jointShearDistortionAbsMax_allJoints_aboveStripe{floorNum};
                        end                    
                    end
                    isNonConverged_aboveStripe = ~isCurrentAnalysisConv;
                    cd ..;
                    clear PGA floorAccelToSave isCurrentAnalysisConv maxDriftRatioForFullStr storyDriftRatioToSave