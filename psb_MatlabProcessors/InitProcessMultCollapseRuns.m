








collapseDriftThreshold = 0.10; %0.12;  % Value above which record is considered collapsed


dataSavingOption = 1;   % Decide what data files to save (1 - save all data; 2 - save reduced amount of data; 3 - save both of the above files)

% analysisTypeLIST = {'(MeanDesign_VarID1_v.TEST)_(AllVar)_(Mean)_(BeamWHinges)'};
% saLevelLIST = [0.25, 0.50, 0.75, 1.00, 1.25, 1.50];
% eqNameLIST = {'LP89g04CH', 'tcu082CH'};



% All
% analysisTypeLIST = {'(DesID1_v.60)_(AllVar)_(0.00)_(clough)', '(DesID1_v.60)_(cappingRotationF)_(0.13)_(clough)', '(DesID1_v.60)_(cappingRotationF)_(1.87)_(clough)', '(DesID1_v.60)_(hingeStrF)_(0.79)_(clough)', '(DesID1_v.60)_(hingeStrF)_(1.21)_(clough)', '(DesID1_v.60)_(lambdaFactor)_(0.22)_(clough)', '(DesID1_v.60)_(lambdaFactor)_(1.78)_(clough)', '(DesID1_v.60)_(postCapStiffRatF)_(0.13)_(clough)', '(DesID1_v.60)_(postCapStiffRatF)_(1.87)_(clough)', '(DesID8_v.1)_(AllVar)_(0.00)_(clough)'};
% modelNameLIST = {'DesID1_v.60', 'DesID1_v.60', 'DesID1_v.60', 'DesID1_v.60', 'DesID1_v.60', 'DesID1_v.60', 'DesID1_v.60', 'DesID1_v.60', 'DesID1_v.60', 'DesID8_v.1'};

% % The rest on 1-24-05
% analysisTypeLIST = { '(DesID1_v.60)_(hingeStrF)_(0.79)_(clough)', '(DesID1_v.60)_(hingeStrF)_(1.21)_(clough)', '(DesID1_v.60)_(lambdaFactor)_(0.22)_(clough)', '(DesID1_v.60)_(lambdaFactor)_(1.78)_(clough)', '(DesID1_v.60)_(postCapStiffRatF)_(0.13)_(clough)', '(DesID1_v.60)_(postCapStiffRatF)_(1.87)_(clough)', '(DesID8_v.1)_(AllVar)_(0.00)_(clough)'};
% modelNameLIST = {'DesID1_v.60', 'DesID1_v.60', 'DesID1_v.60', 'DesID1_v.60', 'DesID1_v.60', 'DesID1_v.60', 'DesID8_v.1'};

% analysisTypeLIST = {'(DesID1_v.61)_(elaElementStfRatio)_(0.38)_(clough)', '(DesID1_v.61)_(elaElementStfRatio)_(1.62)_(clough)'};
% modelNameLIST = {'DesID1_v.61', 'DesID1_v.61'};

% analysisTypeLIST = {'(DesID1_v.64noGFrm)_(AllVar)_(0.00)_(clough)'};
% modelNameLIST = {'DesID1_v.64noGFrm'};

% analysisTypeLIST = {'(DesID3_v.10)_(AllVar)_(0.00)_(clough)'};
% modelNameLIST = {'DesID3_v.10'};
% 
analysisTypeLIST = {'(DesWA_ATC63_v.22dispEle)_(AllVar)_(0.00)_(nonlinearBeamColumn)'};
modelNameLIST = {'DesWA_ATC63_v.22dispEle'};

% analysisTypeLIST = {'(DesC_Buffalo_v.9noGFrm)_(AllVar)_(0.00)_(clough)'};
% modelNameLIST = {'DesC_Buffalo_v.9noGFrm'};

% analysisTypeLIST = {'(DesA_Buffalo_v.9noGFrm)_(AllVar)_(0.00)_(clough)'};
% modelNameLIST = {'DesA_Buffalo_v.9noGFrm'};

% analysisTypeLIST = {'(DesID1_v.63)_(hingeStrColF)_(0.50)_(clough)', '(DesID1_v.63)_(hingeStrColF)_(0.74)_(clough)', '(DesID1_v.63)_(hingeStrColF)_(0.85)_(clough)', '(DesID1_v.63)_(hingeStrColF)_(1.00)_(clough)', '(DesID1_v.63)_(hingeStrColF)_(1.15)_(clough)', '(DesID1_v.63)_(hingeStrColF)_(1.26)_(clough)', '(DesID1_v.63)_(hingeStrColF)_(1.50)_(clough)', '(DesID1_v.63)_(postCapStiffRatF)_(0.05)_(clough)', '(DesID1_v.63)_(postCapStiffRatF)_(0.13)_(clough)', '(DesID1_v.63)_(postCapStiffRatF)_(0.50)_(clough)', '(DesID1_v.63)_(postCapStiffRatF)_(0.75)_(clough)', '(DesID1_v.63)_(postCapStiffRatF)_(1.00)_(clough)', '(DesID1_v.63)_(postCapStiffRatF)_(1.25)_(clough)', '(DesID1_v.63)_(postCapStiffRatF)_(1.50)_(clough)', '(DesID1_v.63)_(postCapStiffRatF)_(1.87)_(clough)', '(DesID1_v.63)_(postCapStiffRatF)_(2.25)_(clough)', '(DesID1_v.63)_(postCapStiffRatF)_(3.00)_(clough)', '(DesID1_v.63)_(cappingRotationF)_(0.13)_(clough)', '(DesID1_v.63)_(cappingRotationF)_(0.25)_(clough)', '(DesID1_v.63)_(cappingRotationF)_(0.50)_(clough)', '(DesID1_v.63)_(cappingRotationF)_(1.00)_(clough)', '(DesID1_v.63)_(cappingRotationF)_(1.40)_(clough)', '(DesID1_v.63)_(cappingRotationF)_(1.87)_(clough)', '(DesID1_v.63)_(cappingRotationF)_(2.50)_(clough)', '(DesID1_v.63)_(lambdaFactor)_(0.05)_(clough)', '(DesID1_v.63)_(lambdaFactor)_(0.13)_(clough)', '(DesID1_v.63)_(lambdaFactor)_(0.25)_(clough)', '(DesID1_v.63)_(lambdaFactor)_(0.50)_(clough)', '(DesID1_v.63)_(lambdaFactor)_(0.75)_(clough)', '(DesID1_v.63)_(lambdaFactor)_(1.00)_(clough)', '(DesID1_v.63)_(lambdaFactor)_(1.40)_(clough)', '(DesID1_v.63)_(lambdaFactor)_(1.87)_(clough)', '(DesID1_v.63)_(lambdaFactor)_(2.50)_(clough)', '(DesID1_v.63)_(capAndLambdaF)_(0.13)_(clough)', '(DesID1_v.63)_(capAndLambdaF)_(0.25)_(clough)', '(DesID1_v.63)_(capAndLambdaF)_(0.50)_(clough)', '(DesID1_v.63)_(capAndLambdaF)_(0.75)_(clough)', '(DesID1_v.63)_(capAndLambdaF)_(1.00)_(clough)', '(DesID1_v.63)_(capAndLambdaF)_(1.40)_(clough)', '(DesID1_v.63)_(capAndLambdaF)_(1.87)_(clough)', '(DesID1_v.63)_(capAndLambdaF)_(2.50)_(clough)'};
% modelNameLIST = {'DesID1_v.63', 'DesID1_v.63', 'DesID1_v.63', 'DesID1_v.63', 'DesID1_v.63', 'DesID1_v.63', 'DesID1_v.63', 'DesID1_v.63', 'DesID1_v.63', 'DesID1_v.63', 'DesID1_v.63', 'DesID1_v.63', 'DesID1_v.63', 'DesID1_v.63', 'DesID1_v.63', 'DesID1_v.63', 'DesID1_v.63', 'DesID1_v.63', 'DesID1_v.63', 'DesID1_v.63', 'DesID1_v.63', 'DesID1_v.63', 'DesID1_v.63', 'DesID1_v.63', 'DesID1_v.63', 'DesID1_v.63', 'DesID1_v.63', 'DesID1_v.63', 'DesID1_v.63', 'DesID1_v.63', 'DesID1_v.63', 'DesID1_v.63', 'DesID1_v.63', 'DesID1_v.63', 'DesID1_v.63', 'DesID1_v.63', 'DesID1_v.63', 'DesID1_v.63', 'DesID1_v.63', 'DesID1_v.63', 'DesID1_v.63'};

% analysisTypeLIST = {'(DesID1_v.63)_(cappingRotationF)_(0.13)_(clough)'};
% modelNameLIST = {'DesID1_v.63'};

% analysisTypeLIST = {'(DesID1_v.63)_(cappingRotationF)_(0.13)_(clough)'};
% modelNameLIST = {'DesID1_v.63'};

% % Collapse sens, study on 3-22-05
% analysisTypeLIST = {'(DesID1_v.63)_(dampRatF)_(0.31)_(clough)', '(DesID1_v.63)_(dampRatF)_(1.69)_(clough)', '(DesID1_v.63)_(elaElementStfRatio)_(0.38)_(clough)', '(DesID1_v.63)_(elaElementStfRatio)_(1.62)_(clough)', '(DesID1_v.63)_(hingeStrF)_(0.79)_(clough)', '(DesID1_v.63)_(hingeStrF)_(1.21)_(clough)', '(DesID1_v.63)_(hingeStrColF)_(0.74)_(clough)', '(DesID1_v.63)_(hingeStrColF)_(1.26)_(clough)', '(DesID1_v.63)_(lambdaFactor)_(0.13)_(clough)', '(DesID1_v.63)_(lambdaFactor)_(1.87)_(clough)', '(DesID1_v.63)_(cappingRotationF)_(0.13)_(clough)', '(DesID1_v.63)_(cappingRotationF)_(1.87)_(clough)', '(DesID1_v.63)_(postCapStiffRatF)_(0.13)_(clough)', '(DesID1_v.63)_(postCapStiffRatF)_(1.87)_(clough)', '(DesID1_v.63)_(DLF)_(0.89)_(clough)', '(DesID1_v.63)_(DLF)_(1.22)_(clough)', '(DesID1_v.63)_(yieldedPHStiffF)_(0.13)_(clough)', '(DesID1_v.63)_(yieldedPHStiffF)_(1.87)_(clough)'}; 
% modelNameLIST = {'DesID1_v.63', 'DesID1_v.63', 'DesID1_v.63', 'DesID1_v.63', 'DesID1_v.63', 'DesID1_v.63', 'DesID1_v.63', 'DesID1_v.63', 'DesID1_v.63', 'DesID1_v.63', 'DesID1_v.63', 'DesID1_v.63', 'DesID1_v.63', 'DesID1_v.63', 'DesID1_v.63', 'DesID1_v.63', 'DesID1_v.63', 'DesID1_v.63'};


% analysisTypeLIST = {'(DesID9_v.3withGFrm)_(AllVar)_(0.00)_(clough)'};
% modelNameLIST = {'DesID9_v.3withGFrm'};

% analysisTypeLIST = {'(DesID5_v.1)_(AllVar)_(0.00)_(clough)'};
% modelNameLIST = {'DesID5_v.1'};

% analysisTypeLIST = {'(DesID1_v.61)_(hingeStrF)_(1.21)_(clough)'};
% modelNameLIST = {'DesID1_v.61'};

% analysisTypeLIST = {'(DesID1_v.61)_(hingeStrF)_(0.79)_(clough)', '(DesID1_v.61)_(hingeStrF)_(1.21)_(clough)', '(DesID1_v.61)_(lambdaFactor)_(0.22)_(clough)', '(DesID1_v.61)_(lambdaFactor)_(1.78)_(clough)'};
% modelNameLIST = {'DesID1_v.61', 'DesID1_v.61', 'DesID1_v.61', 'DesID1_v.61'};


%         eqNumberLIST = [400, 401, 402, 403, 404, 405 406, 407, 408, 409, 410, 411, 412, 413, 414, 415, 416, 417, 418, 419, 420, 421, 422, 423, 424, 425, 426, 427, 428, 429, 430, 431, 432, 433, 434, 435, 436, 437, 438, 439, 440];
%         eqNumberLIST = [400, 401, 402, 403, 404, 405 406, 407, 408, 409, 410, 411, 412, 413, 414, 415, 416, 417, 418, 419];

%         % Full list of Bin 4A
%         eqNumberLIST = [941001, 941002, 941011, 941012, 941021, 941022, 941031, 941032, 941041, 941042, 941051, 941052, 941061, 941062, 941071, 941072, 941081, 941082, 941091, 941092];
%         % Bin 4A - only those that control collapse for DesID1_v.60_clough (noGFrm) - see notes on 1-31-05
%         eqNumberLIST = [941002, 941012, 941022, 941032, 941042, 941051, 941062, 941072, 941082, 941092];

%         % Bin 4AEXTRA (4C) - all records
%         eqNumberLIST = [943001, 943002, 943011, 943012, 943021, 943022, 943031, 943032, 943041, 943042, 943051, 943052, 943061, 943062, 943071, 943072, 943081, 943082, 943091, 943092, 943101, 943102, 943111, 943112, 943121, 943122, 943131, 943132, 943141, 943142, 943151, 943152, 943161, 943162, 943171, 943172, 943181, 943182, 943191, 943192, 943201, 943202, 943211, 943212, 943221, 943222, 943231, 943232, 943241, 943242, 943251, 943252];
   
%         %%% ATC-63 FULL Set A (record 23 and 30 excluded)
%         eqNumberLIST = [11011, 11012, 11021, 11022, 11031, 11032, 11041, 11042, 11051, 11052, 11061, 11062, 11071, 11072, 11081, 11082, 11091, 11092, 11101, 11102, 11111, 11112, 11121, 11122, 11131, 11132, 11141, 11142, 11151, 11152, 11161, 11162, 11171, 11172, 11181, 11182, 11191, 11192, 11201, 11202, 11211, 11212, 11221, 11222, 11241, 11242, 11251, 11252, 11261, 11262, 11271, 11272, 11281, 11282, 11291, 11292, 11311, 11312, 11321, 11322];
        %%% ATC-63 part of Set A that are PEER records
%         eqNumberLIST = [11011, 11012, 11021, 11022, 11031, 11032, 11041, 11042, 11051, 11052, 11061, 11062, 11071, 11072, 11081, 11082, 11091, 11092, 11101, 11102, 11111, 11112, 11121, 11122, 11131, 11132];
%         %%% ATC-63 part of Set A that are PEER-NGA records
%         eqNumberLIST = [11141, 11142, 11151, 11152, 11161, 11162, 11171, 11172, 11181, 11182, 11191, 11192, 11201, 11202, 11211, 11212, 11221, 11222, 11241, 11242, 11251, 11252, 11261, 11262, 11271, 11272, 11281, 11282, 11291, 11292, 11311, 11312, 11321, 11322];
 
% %         %%% temp
        eqNumberLIST = [11062];


%         % Bin 4A - only those that control collapse for DesID1_v.63_clough(noGFrm)
%         eqNumberLIST = [941002, 941012, 941022, 941032, 941042, 941051, 941062, 941072, 941082, 941092];

%         % Bin 4A - single run for sens study
%         eqNumberLIST = [941001, 941002];

        
%         % Full list of Bin 5A
%         eqNumberLIST = [951001, 951002, 951011, 951012, 951021, 951022, 951031, 951032, 951041, 951042, 951051, 951052, 951061, 951062, 951071, 951072, 951081, 951082, 951091, 951092];
%         % Bin 5A - only those that control collapse for DesID1_v.61_clough (noGFrm) - see notes on 1-31-05
%         eqNumberLIST = [951002, 951012, 951022, 951032, 951041, 951052, 951061, 951071, 951082, 951092];        
        
% %         % Full list of Bin 3B
%         eqNumberLIST = [932001, 932002, 932011, 932012, 932021, 932022, 932031, 932032, 932041, 932042, 932051, 932052, 932061, 932062, 932071, 932072, 932081, 932082, 932091, 932092];
        
%         eqNumberLIST = [951071];


% Not used
% processPushover = 1;    
processPushover = 0;    

% For collapse processor
% toleranceUsedInCollapseAlgo = 0.30;
    

% For the IDA plotter
markerTypeLine = 'b';
markerTypeDot = 'ko';
isPlotIndividualPoints = 1;







