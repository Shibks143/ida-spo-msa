




collapseDriftThreshold = 0.15; %0.12  % Value above which record is considered collapsed - used for computing collapse Sa level

% NOTICE: You can only do one at a time now!

% analysisTypeLIST = {'(DesID1_v.63)_(AllVar)_(0.00)_(clough)'};
analysisTypeLIST = {'(DesID3_v.10)_(AllVar)_(0.00)_(clough)'};
% analysisTypeLIST = {'(DesID5_v.2)_(AllVar)_(0.00)_(clough)'};
% analysisTypeLIST = {'(DesID6_v.4)_(AllVar)_(0.00)_(clough)'};
% analysisTypeLIST = {'(DesID9_v.3noGFrm)_(AllVar)_(0.00)_(clough)'};
% analysisTypeLIST = {'(DesID9_v.3withGFrm)_(AllVar)_(0.00)_(clough)'};
% analysisTypeLIST = {'(DesID10_v.3)_(AllVar)_(0.00)_(clough)'};
% analysisTypeLIST = {'(DesA_Buffalo_v.5noGFrm)_(AllVar)_(0.00)_(clough)'};
% analysisTypeLIST = {'(DesA_Buffalo_v.7noGFrm)_(AllVar)_(0.00)_(clough)'};
% analysisTypeLIST = {'(DesA_Buffalo_v.9noGFrm)_(AllVar)_(0.00)_(clough)'};
% analysisTypeLIST = {'(DesWA_ATC63_v.22dispEle)_(AllVar)_(0.00)_(nonlinearBeamColumn)'};



if(length(analysisTypeLIST) > 1)
    error('You can only plot one at a time now b/c I canged the plotter on 3-14-05!')
end

% Define a LIST of EQ's to run for collapse analysis - the same LIST is run for all sensitivity variable runs

%%%%%%%%%%%%%%%%%%%%%%%
%         %%% Bin 4A - ALL
%         eqNumberLIST = [94100, 94101, 94102, 94103, 94104, 94105, 94106, 94107, 94108, 94109];
%         %%%%% Bin 4AEXTRA (4C) - all records
%         eqNumberLIST = [94300, 94301, 94302, 94303, 94304, 94305, 94306, 94307, 94308, 94309, 94310, 94311, 94312, 94313, 94314, 94315, 94316, 94317, 94318, 94319, 94320, 94321, 94322, 94323, 94324, 94325];
%         %%%% Bin 4A and 4C
%         eqNumberLIST = [94100, 94101, 94102, 94103, 94104, 94105, 94106, 94107, 94108, 94109, 94300, 94301, 94302, 94303, 94304, 94305, 94306, 94307, 94308, 94309, 94310, 94311, 94312, 94313, 94314, 94315, 94316, 94317, 94318, 94319, 94320, 94321, 94322, 94323, 94324, 94325];
%         %%%% Bin 4A and 4C - WITHOUT LAST TWO (just b/c I did not run them)
%         eqNumberLIST = [94100, 94101, 94102, 94103, 94104, 94105, 94106, 94107, 94108, 94109, 94300, 94301, 94302, 94303, 94304, 94305, 94306, 94307, 94308, 94309, 94310, 94311, 94312, 94313, 94314, 94315, 94316, 94317, 94318, 94319, 94320, 94321, 94322, 94323];
        

%         % Bin 3A - ALL
%         eqNumberLIST = [93100, 93101, 93102, 93103, 93104, 93105, 93106, 93107, 93108, 93109];

%         % TEmp
%         eqNumberLIST = [94323];

%         %%% ATC-63 Set A (record 23 and 30 excluded) - Both PEER and PEER-NGA formats
%         eqNumberLIST = [1101, 1102, 1103, 1104, 1105, 1106, 1107, 1108, 1109, 1110, 1111, 1112, 1113, 1114, 1115, 1116, 1117, 1118, 1119, 1120, 1121, 1122, 1124, 1125, 1126, 1127, 1128, 1129, 1131, 1132];
%         %%% ATC-63 part of Set A that are PEER records
%         eqNumberLIST = [1101, 1102, 1103, 1104, 1105, 1106, 1107, 1108, 1109, 1110, 1111, 1112, 1113];
        %%% ATC-63 part of Set A that are PEER-NGA records
%         eqNumberLIST = [1114, 1115, 1116, 1117, 1118, 1119, 1120, 1121, 1122, 1124, 1125, 1126, 1127, 1128, 1129, 1131, 1132];
 
% % Temp
        eqNumberLIST = [94105];



%         % Bin 4A - only those that control collapse for DesID1_v.61_clough (noGFrm) - see notes on 1-31-05
%         eqNumberLIST = [941002, 941012, 941022, 941032, 941042, 941051, 941062, 941072, 941082, 941092];
%         % Bin 4A - only those that control collapse for DesID3_v.7_clough (noGFrm) - see notes on 2-4-05
%         eqNumberLIST = [941002, 941011, 941022, 941032, 941042, 941051, 941062, 941072, 941082, 941092];
%         % Bin 4A - only those that control collapse for DesID3_v.8_clough (noGFrm) - see notes on 2-14-05
%         eqNumberLIST = [941002, 941011, 941022, 941032, 941042, 941051, 941062, 941072, 941082, 941092];
%         % Bin 4A - only those that control collapse for DesID6_v.1_clough (noGFrm) - see notes on 2-4-05
%         eqNumberLIST = [941002, 941011, 941022, 941032, 941042, 941051, 941062, 941072, 941082, 941092];
%         % Bin 4A - only those that control collapse for DesID5_v.1_clough (noGFrm) - see notes on 2-14-05
%         eqNumberLIST = [941002, 941011, 941022, 941032, 941042, 941051, 941062, 941072, 941082, 941092];
%         % Bin 4A - only those that control collapse for DesID9_v.1_clough (noGFrm) - see notes on 2-4-05
%         eqNumberLIST = [941002, 941011, 941022, 941032, 941042, 941051, 941062, 941071, 941082, 941092];
%         % Bin 4A - only those that control collapse for DesID9_v.2_clough (noGFrm) - see notes on 2-14-05
%         eqNumberLIST = [941002, 941011, 941022, 941032, 941042, 941052, 941062, 941071, 941082, 941092];

%%%%%%%%%%%%%%%%%%%%%%%
%         % Full list of Bin 5A
%         eqNumberLIST = [951001, 951002, 951011, 951012, 951021, 951022, 951031, 951032, 951041, 951042, 951051, 951052, 951061, 951062, 951071, 951072, 951081, 951082, 951091, 951092];
%         % Bin 5A - all but EQ 95107 (b/c it's not plotting right)
%         eqNumberLIST = [951001, 951002, 951011, 951012, 951021, 951022, 951031, 951032, 951041, 951042, 951051, 951052, 951061, 951062, 951081, 951082, 951091, 951092];

% %           % Bin 5A - only those that control collapse for DesID1_v.61_clough (noGFrm) - see notes on 1-31-05
%             eqNumberLIST = [951002, 951012, 951022, 951032, 951041, 951052, 951061, 951071, 951082, 951092];
%             % Bin 5A - NO 951071 (b/c it's not plotting right) - only those that control collapse for DesID1_v.61_clough (noGFrm) - see notes on 1-31-05
%             eqNumberLIST = [951002, 951012, 951022, 951032, 951041, 951052, 951061, 951082, 951092];
%         % Bin 4A AND 5A - only the component that causes collapse for DesID1_v.61_clough (noGFrm) - no duplicates, so 16 recors total
%         eqNumberLIST = [941002, 941012, 941022, 941032, 941042, 941051, 941062, 941072, 941082, 941092, 951012, 951022, 951061, 951071, 951082, 951092];




%%%%%%%%%%%%%%%%%%%%%%%
%     % Bins 4A and 5A - full list
%         eqNumberLIST = [941001, 941002, 941011, 941012, 941021, 941022, 941031, 941032, 941041, 941042, 941051, 941052, 941061, 941062, 941071, 941072, 941081, 941082, 941091, 941092, 951011, 951012, 951021, 951022, 951061, 951062, 951071, 951072, 951081, 951082, 951091, 951092];
%     % Bins 4A and 5A - all but EQ 95107 (it's not plotting right)
%         eqNumberLIST = [941001, 941002, 941011, 941012, 941021, 941022, 941031, 941032, 941041, 941042, 941051, 941052, 941061, 941062, 941071, 941072, 941081, 941082, 941091, 941092, 951011, 951012, 951021, 951022, 951061, 951062, 951081, 951082, 951091, 951092];

%     % Bin 4A and 5A - only those that control collapse for DesID1_v.61_clough (noGFrm) - see notes on 1-31-05
%         eqNumberLIST = [941002, 941012, 941022, 941032, 941042, 941051, 941062, 941072, 941082, 941092, 951012, 951022, 951061, 951071, 951082, 951092];
%     % Bin 4A and 5A - NO EQ 951071 - only those that control collapse for DesID1_v.61_clough (noGFrm) - see notes on 1-31-05
%         eqNumberLIST = [941002, 941012, 941022, 941032, 941042, 941051, 941062, 941072, 941082, 941092, 951012, 951022, 951061, 951082, 951092];
%         % Bin 3b
%         eqNumberLIST = [932001, 932002, 932011, 932012, 932021, 932022, 932031, 932032, 932041, 932042, 932051, 932052, 932061, 932062, 932071, 932072, 932081, 932082, 932091, 932092];



%          eqNumberLIST = [941021, 941022];



%         eqNumberLIST = [400, 401, 402, 403, 404, 405 406, 407, 408, 409, 410, 411, 412, 413, 414, 415, 416, 417, 418, 419, 420, 421, 422, 423, 424, 425, 426, 427, 428, 429, 430, 431, 432, 433, 434, 435, 436, 437, 438, 439, 440];






%         % Bin 5A - all but EQ 95107 (b/c it's not plotting right)
%         eqNumberLIST = [951001, 951002, 951011, 951012, 951021, 951022, 951031, 951032, 951041, 951042, 951051, 951052, 951061, 951062, 951081, 951082, 951091, 951092];

% %           % Bin 5A - only those that control collapse for DesID1_v.61_clough (noGFrm) - see notes on 1-31-05
%             eqNumberLIST = [951002, 951012, 951022, 951032, 951041, 951052, 951061, 951071, 951082, 951092];
%             % Bin 5A - NO 951071 (b/c it's not plotting right) - only those that control collapse for DesID1_v.61_clough (noGFrm) - see notes on 1-31-05
%             eqNumberLIST = [951002, 951012, 951022, 951032, 951041, 951052, 951061, 951082, 951092];
%         % Bin 4A AND 5A - only the component that causes collapse for DesID1_v.61_clough (noGFrm) - no duplicates, so 16 recors total
%         eqNumberLIST = [941002, 941012, 941022, 941032, 941042, 941051, 941062, 941072, 941082, 941092, 951012, 951022, 951061, 951071, 951082, 951092];




%%%%%%%%%%%%%%%%%%%%%%%
%     % Bins 4A and 5A - full list
%         eqNumberLIST = [941001, 941002, 941011, 941012, 941021, 941022, 941031, 941032, 941041, 941042, 941051, 941052, 941061, 941062, 941071, 941072, 941081, 941082, 941091, 941092, 951011, 951012, 951021, 951022, 951061, 951062, 951071, 951072, 951081, 951082, 951091, 951092];
%     % Bins 4A and 5A - all but EQ 95107 (it's not plotting right)
%         eqNumberLIST = [941001, 941002, 941011, 941012, 941021, 941022, 941031, 941032, 941041, 941042, 941051, 941052, 941061, 941062, 941071, 941072, 941081, 941082, 941091, 941092, 951011, 951012, 951021, 951022, 951061, 951062, 951081, 951082, 951091, 951092];

%     % Bin 4A and 5A - only those that control collapse for DesID1_v.61_clough (noGFrm) - see notes on 1-31-05
%         eqNumberLIST = [941002, 941012, 941022, 941032, 941042, 941051, 941062, 941072, 941082, 941092, 951012, 951022, 951061, 951071, 951082, 951092];
%     % Bin 4A and 5A - NO EQ 951071 - only those that control collapse for DesID1_v.61_clough (noGFrm) - see notes on 1-31-05
%         eqNumberLIST = [941002, 941012, 941022, 941032, 941042, 941051, 941062, 941072, 941082, 941092, 951012, 951022, 951061, 951082, 951092];
%         % Bin 3b
%         eqNumberLIST = [932001, 932002, 932011, 932012, 932021, 932022, 932031, 932032, 932041, 932042, 932051, 932052, 932061, 932062, 932071, 932072, 932081, 932082, 932091, 932092];



%          eqNumberLIST = [941021, 941022];



%         eqNumberLIST = [400, 401, 402, 403, 404, 405 406, 407, 408, 409, 410, 411, 412, 413, 414, 415, 416, 417, 418, 419, 420, 421, 422, 423, 424, 425, 426, 427, 428, 429, 430, 431, 432, 433, 434, 435, 436, 437, 438, 439, 440];




% markerTypeLine = 'r';   % Marker for lines
% markerTypeDot = 'ro';   % Marker for points

markerTypeLine = 'b';   % Marker for lines
markerTypeDot = 'bo';   % Marker for points




% Decide if you want circles for each point
    isPlotIndividualPoints = 1;
%     isPlotIndividualPoints = 0;



