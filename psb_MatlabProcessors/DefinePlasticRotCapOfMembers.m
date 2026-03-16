%
% Procedure: DefinePlasticRotCapOfMembers.m
% -------------------
% This procedure is simply to input the maximum plastic rotation capcaityie sof all of the members (for later PADI computations).
% 
% Assumptions and Notices: 
%           - This must be run with the current directory started in the "MatlabProcessing" folder.
%
% Author: Curt Haselton 
% Date Written: 7-16-04
%
% Sources of Code: none
%
% Functions and Procedures called: none
%
% Variable definitions:
%
%   sectionPlasticRotCap.BS1axial000 = ultimate plastic rotation of BS1 at axial load of 0 (for BS1-4, CS1-6)
%   elementPHRCapacity{eleNum} = ultimate plastic rotation of element (1-36 for the nlBmCol model).
%
%
%
%
%
%
%
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%





% Define plastic rotation capacities of the sections - these are now based on calculations from the Fardis paper in the Otani symposium.
%   This value is the value used at the peak of the M-Rot curve (at the start of buckling or fracture or whatever).  This is based on the Fardis
%   ultimate plastic rotation for CYCLIC loading.
% Note that I will define these differently, based on what design variant is being used.

if((variantNum == 1) | (variantNum == 11) | (variantNum == 12) | (variantNum == 13)| (variantNum == 14) | (variantNum == 15))

%     % DesID1 - based on CYCLIC PHR capacity
    % From hand notes on 2-19-05
%     sectionPlasticRotCap.CS1axial218 = 0.037;
%     sectionPlasticRotCap.CS2axial410 = 0.035;
%     sectionPlasticRotCap.CS3axial298 = 0.036;
%     sectionPlasticRotCap.CS4axial190 = 0.034;
%     sectionPlasticRotCap.CS4axial087 = 0.035;
%     sectionPlasticRotCap.CS5axial156 = 0.035;
%     sectionPlasticRotCap.CS6axial099 = 0.038;
%     sectionPlasticRotCap.CS6axial045 = 0.039;
%     sectionPlasticRotCap.BS1axial000 = 0.048;
%     sectionPlasticRotCap.BS2axial000 = 0.050;
%     sectionPlasticRotCap.BS3axial000 = 0.052;
%     sectionPlasticRotCap.BS4axial000 = 0.052;
    
    % DesID1 - based on MONOTONIC PHR capacity - to the point of 20% strength loss (straight from Fardis)
    % From hand notes on 2-19-05
    sectionPlasticRotCap.CS1axial218 = 0.067;
    sectionPlasticRotCap.CS2axial410 = 0.064;
    sectionPlasticRotCap.CS3axial298 = 0.062;
    sectionPlasticRotCap.CS4axial190 = 0.066;
    sectionPlasticRotCap.CS4axial087 = 0.068;
    sectionPlasticRotCap.CS5axial156 = 0.066;
    sectionPlasticRotCap.CS6axial099 = 0.070;
    sectionPlasticRotCap.CS6axial045 = 0.072;
    sectionPlasticRotCap.BS1axial000 = 0.087;
    sectionPlasticRotCap.BS2axial000 = 0.089;
    sectionPlasticRotCap.BS3axial000 = 0.092;
    sectionPlasticRotCap.BS4axial000 = 0.092;

elseif ((variantNum == 2))
    
%     % Based on CYCLIC PHR capacity
    % From hand notes on 2-19-05
%     % Define these PHR capacities simply based on DesID1 elements (slightly approx. due to axial load level, but okay)
%     sectionPlasticRotCap.CS1axial218 = 0.037;
%     sectionPlasticRotCap.CS2axial410 = 0.035;
%     sectionPlasticRotCap.CS3axial298 = sectionPlasticRotCap.CS2axial410;
%     sectionPlasticRotCap.CS4axial190 = sectionPlasticRotCap.CS2axial410;
%     sectionPlasticRotCap.CS4axial087 = sectionPlasticRotCap.CS2axial410;
%     sectionPlasticRotCap.CS5axial156 = sectionPlasticRotCap.CS1axial218;
%     sectionPlasticRotCap.CS6axial099 = sectionPlasticRotCap.CS1axial218;
%     sectionPlasticRotCap.CS6axial045 = sectionPlasticRotCap.CS1axial218;
%     sectionPlasticRotCap.BS1axial000 = 0.048;
%     sectionPlasticRotCap.BS2axial000 = sectionPlasticRotCap.BS1axial000;
%     sectionPlasticRotCap.BS3axial000 = sectionPlasticRotCap.BS1axial000;
%     sectionPlasticRotCap.BS4axial000 = sectionPlasticRotCap.BS1axial000;
    
    % Based on MONOTONIC PHR capacity - to the point of 20% strength loss (straight from Fardis)
    % Define these PHR capacities simply based on DesID1 elements (slightly approx. due to axial load level, but okay)
    % From hand notes on 2-19-05
    sectionPlasticRotCap.CS1axial218 = 0.067;
    sectionPlasticRotCap.CS2axial410 = 0.064;
    sectionPlasticRotCap.CS3axial298 = sectionPlasticRotCap.CS2axial410;
    sectionPlasticRotCap.CS4axial190 = sectionPlasticRotCap.CS2axial410;
    sectionPlasticRotCap.CS4axial087 = sectionPlasticRotCap.CS2axial410;
    sectionPlasticRotCap.CS5axial156 = sectionPlasticRotCap.CS1axial218;
    sectionPlasticRotCap.CS6axial099 = sectionPlasticRotCap.CS1axial218;
    sectionPlasticRotCap.CS6axial045 = sectionPlasticRotCap.CS1axial218;
    sectionPlasticRotCap.BS1axial000 = 0.087;
    sectionPlasticRotCap.BS2axial000 = sectionPlasticRotCap.BS1axial000;
    sectionPlasticRotCap.BS3axial000 = sectionPlasticRotCap.BS1axial000;
    sectionPlasticRotCap.BS4axial000 = sectionPlasticRotCap.BS1axial000;

elseif ((variantNum == 3) | (variantNum == 9))

%     % DesID3 - based on CYCLIC PHR capacity
    % From hand notes on 2-19-05
    % Just use values from DesID1 for now - close enough
%     sectionPlasticRotCap.CS1axial218 = 0.037;
%     sectionPlasticRotCap.CS2axial410 = 0.035;
%     sectionPlasticRotCap.CS3axial298 = 0.036;
%     sectionPlasticRotCap.CS4axial190 = 0.034;
%     sectionPlasticRotCap.CS4axial087 = 0.035;
%     sectionPlasticRotCap.CS5axial156 = 0.035;
%     sectionPlasticRotCap.CS6axial099 = 0.038;
%     sectionPlasticRotCap.CS6axial045 = 0.039;
%     sectionPlasticRotCap.BS1axial000 = 0.048;
%     sectionPlasticRotCap.BS2axial000 = 0.050;
%     sectionPlasticRotCap.BS3axial000 = 0.052;
%     sectionPlasticRotCap.BS4axial000 = 0.052;
    
    % DesID3 - based on MONOTONIC PHR capacity - to the point of 20% strength loss (straight from Fardis)
    % From hand notes on 2-19-05
    % Just use values from DesID1 for now - close enough
    sectionPlasticRotCap.CS1axial218 = 0.067;
    sectionPlasticRotCap.CS2axial410 = 0.064;
    sectionPlasticRotCap.CS3axial298 = 0.062;
    sectionPlasticRotCap.CS4axial190 = 0.066;
    sectionPlasticRotCap.CS4axial087 = 0.068;
    sectionPlasticRotCap.CS5axial156 = 0.066;
    sectionPlasticRotCap.CS6axial099 = 0.070;
    sectionPlasticRotCap.CS6axial045 = 0.072;
    sectionPlasticRotCap.BS1axial000 = 0.087;
    sectionPlasticRotCap.BS2axial000 = 0.089;
    sectionPlasticRotCap.BS3axial000 = 0.092;
    sectionPlasticRotCap.BS4axial000 = 0.092;

elseif ((variantNum == 5))

%     % DesID5 - based on CYCLIC PHR capacity
    % From hand notes on 2-19-05
%     sectionPlasticRotCap.CS1axial218 = 0.032;
%     sectionPlasticRotCap.CS2axial410 = 0.030;
%     sectionPlasticRotCap.CS3axial298 = 0.031;
%     sectionPlasticRotCap.CS4axial190 = 0.040;
%     sectionPlasticRotCap.CS4axial087 = 0.046;
%     sectionPlasticRotCap.CS5axial156 = 0.035;
%     sectionPlasticRotCap.CS6axial099 = 0.039;
%     sectionPlasticRotCap.CS6axial045 = 0.042;
%     sectionPlasticRotCap.BS1axial000 = 0.049;
%     sectionPlasticRotCap.BS2axial000 = 0.052;
%     sectionPlasticRotCap.BS3axial000 = 0.051;
%     sectionPlasticRotCap.BS4axial000 = 0.051;
    
    % DesID5 - based on MONOTONIC PHR capacity - to the point of 20% strength loss (straight from Fardis)
    % From hand notes on 2-19-05
    sectionPlasticRotCap.CS1axial218 = 0.065;
    sectionPlasticRotCap.CS2axial410 = 0.049;
    sectionPlasticRotCap.CS3axial298 = 0.056;
    sectionPlasticRotCap.CS4axial190 = 0.067;
    sectionPlasticRotCap.CS4axial087 = 0.078;
    sectionPlasticRotCap.CS5axial156 = 0.067;
    sectionPlasticRotCap.CS6axial099 = 0.077;
    sectionPlasticRotCap.CS6axial045 = 0.083;
    sectionPlasticRotCap.BS1axial000 = 0.090;
    sectionPlasticRotCap.BS2axial000 = 0.094;
    sectionPlasticRotCap.BS3axial000 = 0.092;
    sectionPlasticRotCap.BS4axial000 = 0.092;
    
elseif ((variantNum == 6) | (variantNum == 16))

%     % DesID6 - based on CYCLIC PHR capacity
    % From hand notes on 2-19-05
%     sectionPlasticRotCap.CS1axial218 = 0.033;
%     sectionPlasticRotCap.CS2axial410 = 0.032;
%     sectionPlasticRotCap.CS3axial298 = 0.030;
%     sectionPlasticRotCap.CS4axial190 = 0.033;
%     sectionPlasticRotCap.CS4axial087 = 0.037;
%     sectionPlasticRotCap.CS5axial156 = 0.031;
%     sectionPlasticRotCap.CS6axial099 = 0.033;
%     sectionPlasticRotCap.CS6axial045 = 0.034;
%     sectionPlasticRotCap.BS1axial000 = 0.051;
%     sectionPlasticRotCap.BS2axial000 = 0.053;
%     sectionPlasticRotCap.BS3axial000 = 0.052;
%     sectionPlasticRotCap.BS4axial000 = 0.052;
    
    % DesID6 - based on MONOTONIC PHR capacity - to the point of 20% strength loss (straight from Fardis)
    % From hand notes on 2-19-05
    sectionPlasticRotCap.CS1axial218 = 0.062;
    sectionPlasticRotCap.CS2axial410 = 0.052;
    sectionPlasticRotCap.CS3axial298 = 0.055;
    sectionPlasticRotCap.CS4axial190 = 0.061;
    sectionPlasticRotCap.CS4axial087 = 0.067;
    sectionPlasticRotCap.CS5axial156 = 0.063;
    sectionPlasticRotCap.CS6axial099 = 0.067;
    sectionPlasticRotCap.CS6axial045 = 0.071;
    sectionPlasticRotCap.BS1axial000 = 0.092;
    sectionPlasticRotCap.BS2axial000 = 0.096;
    sectionPlasticRotCap.BS3axial000 = 0.095;
    sectionPlasticRotCap.BS4axial000 = 0.095;
    
elseif ((variantNum == 10) | (variantNum == 110))

%     % DesID10 - based on CYCLIC PHR capacity
    % From hand notes on 2-19-05 - not put here - if needed, get it from the hand notes.
    
    % DesID10 - based on MONOTONIC PHR capacity - to the point of 20% strength loss (straight from Fardis)
    % From hand notes on 2-19-05
    sectionPlasticRotCap.CS1axial218 = 0.056;
    sectionPlasticRotCap.CS2axial410 = 0.046;
    sectionPlasticRotCap.CS3axial298 = 0.050;
    sectionPlasticRotCap.CS4axial190 = 0.056;
    sectionPlasticRotCap.CS4axial087 = 0.063;
    sectionPlasticRotCap.CS5axial156 = 0.058;
    sectionPlasticRotCap.CS6axial099 = 0.062;
    sectionPlasticRotCap.CS6axial045 = 0.066;
    sectionPlasticRotCap.BS1axial000 = 0.092;
    sectionPlasticRotCap.BS2axial000 = 0.096;
    sectionPlasticRotCap.BS3axial000 = 0.095;
    sectionPlasticRotCap.BS4axial000 = 0.095;
    
    
    
else
    error('Design variant not found (when trying to define plastic rotation capacities)')
end
    
    
% Now relate the section level capaciities to the element capacities
% Define the element PHR's
    % Story 1 columns
    elementPHRCapacity{1} = sectionPlasticRotCap.CS1axial218;
    elementPHRCapacity{2} = sectionPlasticRotCap.CS2axial410;
    elementPHRCapacity{3} = sectionPlasticRotCap.CS2axial410;
    elementPHRCapacity{4} = sectionPlasticRotCap.CS2axial410;
    elementPHRCapacity{5} = sectionPlasticRotCap.CS1axial218;
    
    % Story 2 columns
    elementPHRCapacity{10} = sectionPlasticRotCap.CS5axial156;
    elementPHRCapacity{11} = sectionPlasticRotCap.CS3axial298;
    elementPHRCapacity{12} = sectionPlasticRotCap.CS3axial298;
    elementPHRCapacity{13} = sectionPlasticRotCap.CS3axial298;
    elementPHRCapacity{14} = sectionPlasticRotCap.CS5axial156;
    
    % Story 3 columns
    elementPHRCapacity{19} = sectionPlasticRotCap.CS6axial099;
    elementPHRCapacity{20} = sectionPlasticRotCap.CS4axial190;
    elementPHRCapacity{21} = sectionPlasticRotCap.CS4axial190;
    elementPHRCapacity{22} = sectionPlasticRotCap.CS4axial190;
    elementPHRCapacity{23} = sectionPlasticRotCap.CS6axial099;
    
    % Story 4 columns
    elementPHRCapacity{28} = sectionPlasticRotCap.CS6axial045;
    elementPHRCapacity{29} = sectionPlasticRotCap.CS4axial087;
    elementPHRCapacity{30} = sectionPlasticRotCap.CS4axial087;
    elementPHRCapacity{31} = sectionPlasticRotCap.CS4axial087;
    elementPHRCapacity{32} = sectionPlasticRotCap.CS6axial045;
    
    % Floor 2 beams
    elementPHRCapacity{6} = sectionPlasticRotCap.BS1axial000;
    elementPHRCapacity{7} = sectionPlasticRotCap.BS1axial000;
    elementPHRCapacity{8} = sectionPlasticRotCap.BS1axial000;
    elementPHRCapacity{9} = sectionPlasticRotCap.BS1axial000;
    
    % Floor 3 beams
    elementPHRCapacity{15} = sectionPlasticRotCap.BS2axial000;
    elementPHRCapacity{16} = sectionPlasticRotCap.BS2axial000;
    elementPHRCapacity{17} = sectionPlasticRotCap.BS2axial000;
    elementPHRCapacity{18} = sectionPlasticRotCap.BS2axial000;
    
    % Floor 4 beams
    elementPHRCapacity{24} = sectionPlasticRotCap.BS3axial000;
    elementPHRCapacity{25} = sectionPlasticRotCap.BS3axial000;
    elementPHRCapacity{26} = sectionPlasticRotCap.BS3axial000;
    elementPHRCapacity{27} = sectionPlasticRotCap.BS3axial000;
    
    % Floor 5 beams
    elementPHRCapacity{33} = sectionPlasticRotCap.BS4axial000;
    elementPHRCapacity{34} = sectionPlasticRotCap.BS4axial000;
    elementPHRCapacity{35} = sectionPlasticRotCap.BS4axial000;
    elementPHRCapacity{36} = sectionPlasticRotCap.BS4axial000;