            for storyNum = 1:numStories
                IDR_max{storyNum}.allEQs(eqIndex) = nan;
                IDR_residual{storyNum}.allEQs(eqIndex) = nan;
            end
            IDR_residual_maxAllStories.allEQs(eqIndex) = nan;   % Added on 8-3-07
            RDR_max.allEQs(eqIndex) = nan;              % Modified on 7-25/26-06
            RDR_absResidual.allEQs(eqIndex) = nan;      % Added on 7-25/26-06
            IDR_maxAllStories.allEQs(eqIndex) = nan;
            PGAToSave.allEQs(eqIndex) = nan;
            for floorNum = 2:numFloors
                PFA{floorNum}.allEQs(eqIndex) = nan;
            end
            
    beamAbsMaxPHR_maxAllFloors.allEQs(eqIndex) = nan;
    for floorNum = 2:numFloors
        beamAbsMaxPHR_allBeams{floorNum}.allEQs(eqIndex) = nan;
        beamAbsMaxPHR_interiorBeams{floorNum}.allEQs(eqIndex) = nan;
        beamAbsMaxPHR_exteriorBeams{floorNum}.allEQs(eqIndex) = nan;        
    end
    columnAbsMaxPHR_maxAllStories.allEQs(eqIndex) = nan;
    for storyNum = 1:numStories
        columnAbsMaxPHR_allColumns{storyNum}.allEQs(eqIndex) = nan;
        columnAbsMaxPHR_interiorColumns{storyNum}.allEQs(eqIndex) = nan;
        columnAbsMaxPHR_exteriorColumns{storyNum}.allEQs(eqIndex) = nan;        
    end
    jointShearDistortionAbsMax_maxAllFloors.allEQs(eqIndex) = nan;
    for floorNum = 2:numFloors
        jointShearDistortionAbsMax_allJoints{floorNum}.allEQs(eqIndex) = nan;
        jointShearDistortionAbsMax_interiorJoints{floorNum}.allEQs(eqIndex) = nan;
        jointShearDistortionAbsMax_exteriorJoints{floorNum}.allEQs(eqIndex) = nan;        
    end