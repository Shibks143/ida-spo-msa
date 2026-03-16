
% If the Sa below the stripe is 0.0, then place zero in all of the EDPs;
% otherwise open the file and read the EDPs.
if (saLevel_belowStripe < 0.01)
    % Place zeros for all the EDPs
    for storyNum = 1:numStories
        IDR_max_belowStripe{storyNum} = 0.0;
        IDR_residual_belowStripe{storyNum} = 0.0;
    end
    RDR_max_belowStripe = 0.0;              % Modified on 7-25-06
    RDR_absResidual_belowStripe = 0.0;      % Added on 7-25-06
    IDR_maxAllStories_belowStripe = 0.0;
    PGA_belowStripe = 0.0; % g-units
    for floorNum = 2:numFloors
        PFA_belowStripe{floorNum} = 0.0;
    end  
    beamAbsMaxPHR_maxAllFloors_belowStripe = 0.0;
    for floorNum = 2:numFloors
        beamAbsMaxPHR_allBeams_belowStripe{floorNum} = 0.0;
        beamAbsMaxPHR_interiorBeams_belowStripe{floorNum} = 0.0;
        beamAbsMaxPHR_exteriorBeams_belowStripe{floorNum} = 0.0;        
    end
    columnAbsMaxPHR_maxAllStories_belowStripe = 0.0;
    for storyNum = 1:numStories
        columnAbsMaxPHR_allColumns_belowStripe{storyNum} = 0.0;
        columnAbsMaxPHR_interiorColumns_belowStripe{storyNum} = 0.0;
        columnAbsMaxPHR_exteriorColumns_belowStripe{storyNum} = 0.0;        
    end
    jointShearDistortionAbsMax_maxAllFloors_belowStripe = 0.0;
    for floorNum = 2:numFloors
        jointShearDistortionAbsMax_allJoints_belowStripe{floorNum} = 0.0;
        jointShearDistortionAbsMax_interiorJoints_belowStripe{floorNum} = 0.0;
        jointShearDistortionAbsMax_exteriorJoints_belowStripe{floorNum} = 0.0;        
    end
    isNonConverged_belowStripe = 0;    % Save it is converged.
    
else
    % Load the EDPs as typical
    saFolderName = sprintf('Sa_%.2f', saLevel_belowStripe);
    cd(saFolderName);
    load('DATA_reducedSensDataForThisSingleRun.mat', 'PGA', 'floorAccelToSave', 'isCurrentAnalysisConv', 'maxDriftRatioForFullStr', 'storyDriftRatioToSave', 'beamAbsMaxPHRPerFloor', 'columnAbsMaxPHRPerStory', 'jointShearDistortionAbsMaxPerFloor', 'roofDriftRatioToSave', 'periodUsedForScalingGroundMotionsFromMatlab');
    % Loop and save the EDP values for this EQ/Sa below the
    % stripe Sa 
    for storyNum = 1:numStories
        IDR_max_belowStripe{storyNum} = storyDriftRatioToSave{storyNum}.AbsMax;
        IDR_residual_belowStripe{storyNum} = abs(storyDriftRatioToSave{storyNum}.Residual);
    end
    RDR_max_belowStripe = roofDriftRatioToSave.AbsMax;       % Modified on 7-25-06
    RDR_absResidual_belowStripe = abs(roofDriftRatioToSave.Residual);       % Added on 7-25-06
    IDR_maxAllStories_belowStripe = maxDriftRatioForFullStr;
    PGA_belowStripe = PGA; % g-units
    for floorNum = 2:numFloors
        PFA_belowStripe{floorNum} = floorAccelToSave{floorNum}.absAbsMaxUnfiltered / g;
    end     
    beamAbsMaxPHR_maxAllFloors_belowStripe = 0.0;
    for floorNum = 2:numFloors
        beamAbsMaxPHR_allBeams_belowStripe{floorNum} = beamAbsMaxPHRPerFloor{floorNum}.maxAllBeams;
        beamAbsMaxPHR_interiorBeams_belowStripe{floorNum} = beamAbsMaxPHRPerFloor{floorNum}.maxInteriorBeams;
        beamAbsMaxPHR_exteriorBeams_belowStripe{floorNum} = beamAbsMaxPHRPerFloor{floorNum}.maxExteriorBeams;      
        if(beamAbsMaxPHR_allBeams_belowStripe{floorNum} > beamAbsMaxPHR_maxAllFloors_belowStripe)
            beamAbsMaxPHR_maxAllFloors_belowStripe = beamAbsMaxPHR_allBeams_belowStripe{floorNum};
        end        
    end
    columnAbsMaxPHR_maxAllStories_belowStripe = 0.0;
    for storyNum = 1:numStories
        columnAbsMaxPHR_allColumns_belowStripe{storyNum} = columnAbsMaxPHRPerStory{storyNum}.maxAllColumns;
        columnAbsMaxPHR_interiorColumns_belowStripe{storyNum} = columnAbsMaxPHRPerStory{storyNum}.maxInteriorColumns;
        columnAbsMaxPHR_exteriorColumns_belowStripe{storyNum} = columnAbsMaxPHRPerStory{storyNum}.maxExteriorColumns;
        if(columnAbsMaxPHR_allColumns_belowStripe{storyNum} > columnAbsMaxPHR_maxAllStories_belowStripe)
            columnAbsMaxPHR_maxAllStories_belowStripe = columnAbsMaxPHR_allColumns_belowStripe{storyNum};
        end             
    end
    jointShearDistortionAbsMax_maxAllFloors_belowStripe = 0.0;
    for floorNum = 2:numFloors
        jointShearDistortionAbsMax_allJoints_belowStripe{floorNum} = jointShearDistortionAbsMaxPerFloor{floorNum}.maxAllJoints;
        jointShearDistortionAbsMax_interiorJoints_belowStripe{floorNum} = jointShearDistortionAbsMaxPerFloor{floorNum}.maxInteriorJoints;
        jointShearDistortionAbsMax_exteriorJoints_belowStripe{floorNum} = jointShearDistortionAbsMaxPerFloor{floorNum}.maxExteriorJoints; 
        if(jointShearDistortionAbsMax_allJoints_belowStripe{floorNum} > jointShearDistortionAbsMax_maxAllFloors_belowStripe)
            jointShearDistortionAbsMax_maxAllFloors_belowStripe = jointShearDistortionAbsMax_allJoints_belowStripe{floorNum};
        end            
    end
    isNonConverged_belowStripe = ~isCurrentAnalysisConv;
    cd ..;
    clear PGA floorAccelToSave isCurrentAnalysisConv maxDriftRatioForFullStr storyDriftRatioToSave
end