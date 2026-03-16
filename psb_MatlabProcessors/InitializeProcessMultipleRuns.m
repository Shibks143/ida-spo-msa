




% ElementUsed - top decide which processor to use
    elementUsed = 1;    % Nonlnear beam column
%   elementUsed = 2;    % Lumped plasticity

% Say that we are not using the floor acceleration filter (b/c I didn't
% finish the filter)
    useProcessorWithFilt = 0;   % i.e. don't use the processor with the floor acceleration filter

  

% %% 
% analysisTypeLIST = {'(DesID1_v.60NoGFrm)_(AllVar)_(Mean)_(nonlinearBeamColumn)'}; 
% modelNameLIST = {'DesID1_v.60NoGFrm'};

analysisTypeLIST = {'(DesID1_v.65)_(AllVar)_(Mean)_(nonlinearBeamColumn)'}; 
modelNameLIST = {'DesID1_v.65'};

% analysisTypeLIST = {'(DesID1_v.63)_(AllVar)_(Mean)_(clough)', '(DesID3_v.9noGFrm)_(AllVar)_(Mean)_(clough)', '(DesID5_v.2)_(AllVar)_(Mean)_(clough)', '(DesID10_v.2)_(AllVar)_(Mean)_(clough)'}; 
% modelNameLIST = {'DesID1_v.63', 'DesID3_v.9noGFrm', 'DesID5_v.2', 'DesID10_v.2'};


% analysisTypeLIST = {'(DesID1_v.63)_(dampRatF)_(0.31)_(clough)', '(DesID1_v.63)_(elaElementStfRatio)_(1.62)_(clough)', '(DesID1_v.63)_(hingeStrF)_(1.21)_(clough)', '(DesID1_v.63)_(hingeStrColF)_(0.74)_(clough)', '(DesID1_v.63)_(DLF)_(1.22)_(clough)', '(DesID1_v.63)_(lambdaFactor)_(0.13)_(clough)'}; 
% modelNameLIST = {'DesID1_v.63', 'DesID1_v.63', 'DesID1_v.63', 'DesID1_v.63', 'DesID1_v.63', 'DesID1_v.63'};

% analysisTypeLIST = {'(DesID1_v.63)_(AllVar)_(Mean)_(nonlinearBeamColumn)', '(DesID1_v.63)_(dampRatF)_(0.00)_(nonlinearBeamColumn)'}; 
% modelNameLIST = {'DesID1_v.63', 'DesID1_v.63'};

% analysisTypeLIST = {'(DesID1_v.63)_(AllVar)_(Mean)_(clough)'}; 
% modelNameLIST = {'DesID1_v.63'};

% analysisTypeLIST = {'(DesID3_v.9withGFrmWithCD)_(AllVar)_(0.00)_(clough)'}; 
% modelNameLIST = {'DesID3_v.9withGFrmWithCD'};

% analysisTypeLIST = {'(DesID1_v.63withGFrmHyst)_(AllVar)_(Mean)_(clough)'}; 
% modelNameLIST = {'DesID1_v.63withGFrmHyst'};

% analysisTypeLIST = {'(DesID3_v.9withGFrmWithCD)_(AllVar)_(Mean)_(clough)'};
% modelNameLIST = {'DesID3_v.9withGFrmWithCD'};

% analysisTypeLIST = {'(DesID1_v.63)_(elaElementStfRatio)_(0.25)_(clough)', '(DesID1_v.63)_(elaElementStfRatio)_(0.50)_(clough)', '(DesID1_v.63)_(elaElementStfRatio)_(0.75)_(clough)', '(DesID1_v.63)_(elaElementStfRatio)_(1.00)_(clough)', '(DesID1_v.63)_(elaElementStfRatio)_(1.25)_(clough)', '(DesID1_v.63)_(elaElementStfRatio)_(1.50)_(clough)', '(DesID1_v.63)_(elaElementStfRatio)_(1.75)_(clough)', '(DesID1_v.63)_(elaElementStfRatio)_(2.00)_(clough)', '(DesID1_v.63)_(elaElementStfRatio)_(2.25)_(clough)', '(DesID1_v.63)_(elaElementStfRatio)_(2.50)_(clough)', '(DesID1_v.63)_(elaElementStfRatio)_(2.75)_(clough)', '(DesID1_v.63)_(elaElementStfRatio)_(3.00)_(clough)', '(DesID1_v.63)_(dampRatF)_(0.00)_(clough)'}; 
% modelNameLIST = {'DesID1_v.63', 'DesID1_v.63', 'DesID1_v.63', 'DesID1_v.63', 'DesID1_v.63', 'DesID1_v.63', 'DesID1_v.63', 'DesID1_v.63', 'DesID1_v.63', 'DesID1_v.63', 'DesID1_v.63', 'DesID1_v.63', 'DesID1_v.63'};

% analysisTypeLIST = {'(DesA_Buffalo_v.9noGFrm)_(AllVar)_(Mean)_(clough)'}; 
% modelNameLIST = {'DesA_Buffalo_v.9noGFrm'};

% analysisTypeLIST = {'(DesC_Buffalo_v.7noGFrm)_(AllVar)_(Mean)_(clough)'}; 
% modelNameLIST = {'DesC_Buffalo_v.7noGFrm'};

% analysisTypeLIST = {'(DesID1_v.63)_(yieldedPHStiffF)_(1.87)_(clough)'}; 
% modelNameLIST = {'DesID1_v.63'};

% analysisTypeLIST = {'(DesWA_ATC63_v.12)_(rebarModelToUse)_(2.00)_(nonlinearBeamColumn)'}; 
% modelNameLIST = {'DesWA_ATC63_v.12'};

% Error check
if(length(analysisTypeLIST) ~= length(modelNameLIST))
    length1 = length(analysisTypeLIST)
    length2 = length(modelNameLIST)
    error('The lists must be the same length!');    
end



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Geometric Mean set - 12-15-04 - Just the 2% in 50 year stripe
%   Make 3D EQ list matrix (row 1 is for EQ1) - MUST HAVE SAME # of EQ's for each stripe (for how it processes now)

% % Just 2% in 50 year stripe
% eqNumberAllStripesLISTGeoMean = { [94100, 94101, 94102, 94103, 94104, 94105, 94106, 94107, 94108, 94109] };
% saTOneForRunLIST = [0.82];  % This is for each stripe in the above list.


% eqNumberAllStripesLISTGeoMean = { [999991] };
% saTOneForRunLIST = [0.10, 1.00, 2.00];  % This is for each stripe in the above list.


% eqNumberAllStripesLISTGeoMean = {  [94100]};
% saTOneForRunLIST = [2.69];  % This is for each stripe in the above list.


%%% All runs
eqNumberAllStripesLISTGeoMean = {   [91100, 91101, 91102, 91103, 91104, 91105, 91106, 91107, 91108, 91109],
							        [91200, 91201, 91202, 91203, 91204, 91205, 91206, 91207, 91208, 91209],
							        [92100, 92101, 92102, 92103, 92104, 92105, 92106, 92107, 92108, 92109],
							        [92200, 92201, 92202, 92203, 92204, 92205, 92206, 92207, 92208, 92209],
							        [93100, 93101, 93102, 93103, 93104, 93105, 93106, 93107, 93108, 93109],
							        [93200, 93201, 93202, 93203, 93204, 93105, 93206, 93207, 93208, 93209],
							        [93300, 93301, 93302, 93303, 93304, 93105, 93306, 93307, 93308, 93309],
							        [94100, 94101, 94102, 94103, 94104, 94105, 94106, 94107, 94108, 94109],
							        [94200],
							        [95100, 95101, 95102, 95103, 95104, 95105, 95106, 95107, 95108, 95109],
							        [95200, 95201, 95202, 95203],
							        [96100, 96101, 96102, 96103, 96104, 96105, 96106, 96107, 96108, 96109],
							        [96200, 96201, 96202],
							        [97100, 97101, 97102, 97103, 97104, 97105, 97106, 97107, 97108, 97109],
							        [97200, 97201, 97202, 97203, 97204, 97105, 97206, 97207, 97208, 97209],
							        [94100, 94101, 94102, 94103, 94104, 94105, 94106, 94107, 94108, 94109],
							        [94200] };
saTOneForRunLIST = [0.26, 0.26, 0.19, 0.19, 0.10, 0.10, 0.10, 0.82, 0.82, 0.55, 0.55, 0.44, 0.44, 0.30, 0.30, 1.20, 1.20];

% %%% All runs
% eqNumberAllStripesLISTGeoMean = {   [99999] };
% saTOneForRunLIST = [0.82];


% %%%%%% Sensitivity set created on 2-20-05 trying to be somewhat random within bins
% 	eqNumberAllStripesLISTGeoMean =  { [91104, 91107, 91109, 91200, 91205, 91208, 92102, 92107, 92108, 92109],						
%                                 [92200, 92201, 92202, 92203, 92204, 92205, 92206, 92207, 92208, 92209],
% 							    [93100, 93105, 93109, 93202, 93203, 93207, 93208, 93303, 93307, 93308],							
%                                 [95101, 95102, 95104, 95105, 95106, 95108, 95109, 95200, 95201, 95203],
% 							    [96100, 96102, 96103, 96104, 96105, 96106, 96107, 96108, 96200, 96201],
% 							    [97101, 97103, 97104, 97107, 97108, 97201, 97203, 97105, 97206, 97207],
% 							    [94100, 94101, 94102, 94103, 94105, 94106, 94107, 94108, 94109, 94200],
% 							    [94100, 94101, 94102, 94103, 94105, 94106, 94107, 94108, 94109, 94200] };
%     saTOneForRunLIST  =  [0.26, 0.19, 0.10, 0.55, 0.44, 0.30, 0.82, 1.20];


    
% % % Reduced sensitivity set for 2-20/27-05 (DesID1_v.63 sensitivity study)
% eqNumberAllStripesLISTGeoMean = { [94200]};
% saTOneForRunLIST = [1.21];
    
    

% % % Reduced sensitivity set for 2-20/27-05 (DesID1_v.63 sensitivity study)
% eqNumberAllStripesLISTGeoMean = { [92200, 92201, 92202, 92203, 92204, 92205, 92206, 92207, 92208, 92209],
%                                   [95101, 95102, 95104, 95105, 95106, 95108, 95109, 95200, 95201, 95203],
%                                   [94100, 94101, 94102, 94103, 94105, 94106, 94107, 94108, 94109, 94200],
%                                   [97101, 97103, 97104, 97107, 97108, 97201, 97203, 97105, 97206, 97207]};
% saTOneForRunLIST = [0.19, 0.55, 0.82, 0.30];




% % % Set of runs to test other GM selection (simplified)
% eqNumberAllStripesLISTGeoMean = {   [95100, 95101, 95102, 95103, 95104, 95105, 95106, 95107, 95108, 95109],
%                                     [95100, 95101, 95102, 95103, 95104, 95105, 95106, 95107, 95108, 95109],
%                                     [95100, 95101, 95102, 95103, 95104, 95105, 95106, 95107, 95108, 95109],
%                                     [95100, 95101, 95102, 95103, 95104, 95105, 95106, 95107, 95108, 95109],
%                                     [95100, 95101, 95102, 95103, 95104, 95105, 95106, 95107, 95108, 95109],
%                                     [95200, 95201, 95202, 95203],
%                                     [95200, 95201, 95202, 95203],
%                                     [95200, 95201, 95202, 95203],
%                                     [95200, 95201, 95202, 95203],
%                                     [95200, 95201, 95202, 95203],
%                                     [93100, 93101, 93102, 93103, 93104, 93105, 93106, 93107, 93108, 93109],
%                                     [93100, 93101, 93102, 93103, 93104, 93105, 93106, 93107, 93108, 93109],
%                                     [93100, 93101, 93102, 93103, 93104, 93105, 93106, 93107, 93108, 93109],
%                                     [93100, 93101, 93102, 93103, 93104, 93105, 93106, 93107, 93108, 93109],
%                                     [93100, 93101, 93102, 93103, 93104, 93105, 93106, 93107, 93108, 93109]};
% saTOneForRunLIST = [0.19, 0.26, 0.55, 0.82, 1.20, 0.19, 0.26, 0.55, 0.82, 1.20, 0.19, 0.26, 0.55, 0.82, 1.20];










% 	set eqNumberToRunLISTPEERRecGeoMean { {92200 92201 92202 92203 92204 92205 92206 92207 92208 92209}
% 							  {95101 95102 95104 95105 95106 95108 95109 95200 95201 95203}
% 							  {97101 97103 97104 97107 97108 97201 97203 97105 97206 97207}
% 							  {94100 94101 94102 94103 94105 94106 94107 94108 94109 94200} }
% 	set saTOneForRunLISTPEERRecGeoMean  { 0.19 0.55 0.30 0.82 }


% eqNumberAllStripesLISTGeoMean = {   [94100, 94101, 94102, 94103, 94104, 94105, 94106, 94107, 94108, 94109],
% 							        [94200],
% 							        [94100, 94101, 94102, 94103, 94104, 94105, 94106, 94107, 94108, 94109],
% 							        [94200] };
% saTOneForRunLIST = [0.82, 0.82, 1.20, 1.20];





%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% % FULL data set, as of 9-9-04
% 	eqNumberAllStripesLIST = 	{ 	[100, 101, 102, 103, 104, 105, 106, 107, 108, 109, 110, 111, 112, 113, 114, 115, 116, 117, 118, 119, 120, 121, 122, 123, 124, 125, 126, 127, 128, 150, 151, 152, 153, 154, 155, 156, 157, 158, 159, 160, 161, 162, 163, 164, 165, 166, 167],
% 							        [200, 201, 202, 203, 204, 205, 206, 207, 208, 209, 210, 211, 212, 213, 214, 215, 216, 217, 218, 219, 220, 221, 222, 223, 224, 225, 250, 251, 252, 253, 254, 255, 256, 257, 258],
% 							        [300, 301, 302, 303, 304, 305, 306, 307, 308, 309, 310, 311, 312, 313, 314, 315, 316, 317, 318, 319, 320, 321, 322, 323, 350, 351, 352, 353, 354, 355, 356, 357, 358, 359, 360, 361, 362, 363, 364, 365, 366, 367, 368, 369, 370, 371],
% 							        [400, 401, 402, 403, 404, 405, 406, 407, 408, 409, 410, 411, 412, 413, 414, 415, 416, 417, 418, 419, 420, 421, 422, 423, 424, 425, 426, 427, 428, 429, 430, 431, 432, 433, 434, 435, 436, 437, 438, 439, 440],
% 							        [500, 501, 502, 503, 504, 505, 506, 507, 508, 509, 510, 511, 512, 513, 514, 515, 516, 517, 518, 519, 520, 521, 522, 523, 524, 525, 550, 551, 552, 553, 554, 555, 556, 557, 558],
% 							        [600, 601, 602, 603, 604, 605, 606, 607, 608, 609, 610, 611, 612, 613, 614, 615, 616, 617, 618, 619, 620, 621, 622, 623, 624, 625, 626, 650, 651, 652, 653, 654, 655, 656, 657, 658],
% 							        [700, 701, 702, 703, 704, 705, 706, 707, 708, 709, 710, 711, 712, 713, 714, 715, 716, 717, 718, 719, 720, 721, 722, 723, 750, 751, 752, 753, 754, 755, 756, 757, 758, 759, 760, 761, 762, 763, 764, 765, 766, 767, 768] };
% 	saTOneForRunLIST  =	[ 0.26, 0.19, 0.10, 0.82, 0.55, 0.44, 0.30 ];
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% % Close to full data set, but with out the 10 sens EQ's per stripe, as of 9-9-04
% 	eqNumberAllStripesLIST = { 	[105, 106, 107, 108, 109, 110, 111, 112, 113, 114, 115, 116, 117, 118, 119, 120, 121, 122, 123, 124, 125, 126, 127, 128, 155, 156, 157, 158, 159, 160, 161, 162, 163, 164, 165, 166, 167],
% 							        [205, 206, 207, 208, 209, 210, 211, 212, 213, 214, 215, 216, 217, 218, 219, 220, 221, 222, 223, 224, 225, 255, 256, 257, 258],
% 							        [300, 306, 307, 308, 309, 310, 311, 312, 313, 314, 315, 316, 317, 318, 319, 320, 321, 322, 323, 355, 356, 357, 358, 359, 360, 361, 362, 363, 364, 365, 366, 367, 368, 369, 370, 371],
% 							        [410, 411, 412, 413, 414, 415, 416, 417, 418, 419, 420, 421, 422, 423, 424, 425, 426, 427, 428, 429, 430, 431, 432, 433, 434, 435, 436, 437, 438, 439, 440],
% 							        [505, 506, 507, 508, 509, 510, 511, 512, 513, 514, 515, 516, 517, 518, 519, 520, 521, 522, 523, 524, 525, 555, 556, 557, 558],
% 							        [605, 606, 607, 608, 609, 610, 611, 612, 613, 614, 615, 616, 617, 618, 619, 620, 621, 622, 623, 624, 625, 626, 655, 656, 657, 658],
% 							        [705, 706, 707, 708, 709, 710, 711, 712, 713, 714, 715, 716, 717, 718, 719, 720, 721, 722, 723, 755, 756, 757, 758, 759, 760, 761, 762, 763, 764, 765, 766, 767, 768] };
%     saTOneForRunLIST  = 	[ 0.26, 0.19, 0.10, 0.82, 0.55, 0.44, 0.30 ];
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%



% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% % All 7 stripes for PRELIM sensitivity runs.
% %   Make 3D EQ list matrix (row 1 is for EQ1) - MUST HAVE SAME # of EQ's for each stripe (for how it processes now)
% eqNumberAllStripesLIST = {  [100, 101, 102, 103, 104, 150, 151, 152, 153, 154],
%                             [200, 201, 202, 203, 204, 250, 251, 252, 253, 254],
%                             [301, 302, 303, 304, 305, 350, 351, 352, 353, 354], 
%                             [400, 401, 402, 403, 404, 405, 406, 407, 408, 409],
%                             [500, 501, 502, 503, 504, 550, 551, 552, 553, 554],
%                             [600, 601, 602, 603, 604, 650, 651, 652, 653, 654],
%                             [700, 701, 702, 703, 704, 750, 751, 752, 753, 754] };
% 
% % For UCLA stripes
% saTOneForRunLIST = [0.26, 0.19, 0.10, 0.82, 0.55, 0.44, 0.33];  % This is for each stripe in the above list.
%     % NOTICE: Stripe 7 should be 0.30g, but I made a mistake and ran all of the sensitivities at 0.33g, so I am now using that!!!
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%



% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% % All 7 stripes for NEWER sensitivity runs.
% %   Make 3D EQ list matrix (row 1 is for EQ1) - MUST HAVE SAME # of EQ's for each stripe (for how it processes now)
% eqNumberAllStripesLIST = {  [100, 101, 102, 103, 104, 150, 151, 152, 153, 154],
%                             [200, 201, 202, 203, 204, 250, 252, 1250, 1253, 1256],
%                             [1300, 1301, 1309, 1315, 1318, 1350, 1351, 1352, 1354, 1357], 
%                             [400, 401, 402, 403, 404, 405, 406, 407, 408, 409],
%                             [500, 501, 502, 503, 504, 550, 551, 552, 1506, 1522],
%                             [600, 601, 602, 603, 604, 650, 651, 652, 1619, 1626],
%                             [700, 701, 702, 703, 704, 750, 751, 752, 753, 754],
%                             [400, 401, 402, 403, 404, 405, 406, 407, 408, 409]};
% 
% % For UCLA stripes
% saTOneForRunLIST = [0.26, 0.19, 0.10, 0.82, 0.55, 0.44, 0.30, 1.20];  % This is for each stripe in the above list.
%     % NOTICE: Stripe 7 should be 0.30g, but I made a mistake and ran all of the sensitivities at 0.33g, so I am now using that!!!
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%



% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%    % 10 EQ stripes, then the rest needed to makethe full EQ data set
%    %   Make 3D EQ list matrix (row 1 is for EQ1) - MUST HAVE SAME # of EQ's for each stripe (for how it processes now)
% eqNumberAllStripesLIST = {  [100, 101, 102, 103, 104, 150, 151, 152, 153, 154],
%                             [200, 201, 202, 203, 204, 250, 251, 252, 253, 254],
%                             [301, 302, 303, 304, 305, 350, 351, 352, 353, 354], 
%                             [400, 401, 402, 403, 404, 405, 406, 407, 408, 409],
%                             [500, 501, 502, 503, 504, 550, 551, 552, 553, 554],
%                             [600, 601, 602, 603, 604, 650, 651, 652, 653, 654],
%                             [700, 701, 702, 703, 704, 750, 751, 752, 753, 754],
%                             [105, 106, 107, 108, 109, 110, 111, 112, 113, 114, 115, 116, 117, 118, 119, 120, 121, 122, 123, 124, 125, 126, 127, 128, 155, 156, 157, 158, 159, 160, 161, 162, 163, 164, 165, 166, 167],
% 						    [205, 206, 207, 208, 209, 210, 211, 212, 213, 214, 215, 216, 217, 218, 219, 220, 221, 222, 223, 224, 225, 255, 256, 257, 258],
% 					        [300, 306, 307, 308, 309, 310, 311, 312, 313, 314, 315, 316, 317, 318, 319, 320, 321, 322, 323, 355, 356, 357, 358, 359, 360, 361, 362, 363, 364, 365, 366, 367, 368, 369, 370, 371],
% 						    [410, 411, 412, 413, 414, 415, 416, 417, 418, 419, 420, 421, 422, 423, 424, 425, 426, 427, 428, 429, 430, 431, 432, 433, 434, 435, 436, 437, 438, 439, 440],
% 						    [505, 506, 507, 508, 509, 510, 511, 512, 513, 514, 515, 516, 517, 518, 519, 520, 521, 522, 523, 524, 525, 555, 556, 557, 558],
% 						    [605, 606, 607, 608, 609, 610, 611, 612, 613, 614, 615, 616, 617, 618, 619, 620, 621, 622, 623, 624, 625, 626, 655, 656, 657, 658],
% 						    [705, 706, 707, 708, 709, 710, 711, 712, 713, 714, 715, 716, 717, 718, 719, 720, 721, 722, 723, 755, 756, 757, 758, 759, 760, 761, 762, 763, 764, 765, 766, 767, 768]};
% 
% % For UCLA stripes
% saTOneForRunLIST = [0.26, 0.19, 0.10, 0.82, 0.55, 0.44, 0.33, 0.26, 0.19, 0.10, 0.82, 0.55, 0.44, 0.33];  % This is for each stripe in the above list.
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%




    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    








% processPushover = 1;    
processPushover = 0;    

