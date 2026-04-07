function [delta_y_eff, Vyield, delta_u, deltaForVbmax, BS] = fun2_delta_y_eff_v05_FEMAP695(BuildingID)
% delta Yield Effective as per FEMA P 695 Figure 6-5 
fprintf('Processing building - %s ... \n', BuildingID);

baseFolder = pwd;

% BuildingID = '2227v01';
% roof drift ratio corresponding to the performance limit of 4% or 2% of Max IDR
% perfLimit = 0.02; 

% this function acts as a common file for location of outputs.

% old code for fetching folder location
% cd H:\Arch_ResponseReductionFactorCalculation
% [analysisTypeFolder, designR] = returnBuildingInfo(BuildingID);

% new updated code for fetching folder location
cd H:\DamageIndex\Automated
[~, analysisTypeFolder, designR, ~] = returnModelFolderInfo(BuildingID);
cd(baseFolder)

% switch BuildingID
% 
%     case '2206v01'
% analysisTypeFolder = 'I:\PrakRuns_I\Output\(ID2206_R3_7Story_v.01_SlabNotConsidered)_(AllVar)_(0.00)_(clough)';
% %         saMedianCol = 0.328; betaRTR = 0.336; % record-to-record
%         designR = 3;
% 
%     case '2206v02'
% analysisTypeFolder = 'I:\PrakRuns_I\Output\(ID2206_R3_7Story_v.02_SlabNotConsidered_CorrectedJointShear)_(AllVar)_(0.00)_(clough)';
%         designR = 3;
%         
%     case '2206v03'
% analysisTypeFolder = 'I:\PrakRuns_I\Output\(ID2206_R3_7Story_v.03_SlabNotConsidered_CORRECTShearPanel)_(AllVar)_(0.00)_(clough)';
%         designR = 3;
% 
%     case '2207v01'
% analysisTypeFolder = 'I:\PrakRuns_I\Output\(ID2207_R5_7Story_v.01_SlabNotConsidered)_(AllVar)_(0.00)_(clough)';
% %         saMedianCol = 0.440; betaRTR = 0.408; % record-to-record
%         designR = 5;
%     
%     case '2207v02'
% analysisTypeFolder = 'I:\PrakRuns_I\Output\(ID2207_R5_7Story_v.02_SlabNotConsidered_CorrectedJointShear)_(AllVar)_(0.00)_(clough)';
%         designR = 5;
%         
%     case '2207v03GMSetC'
% analysisTypeFolder = 'I:\PrakRuns_I\Output\(ID2207_R5_7Story_v.03_SlabNotConsidered_CORRECTShearPanel)_(AllVar)_(0.00)_(clough)_GMSetC';
%         designR = 5;
%         
%     case '2207v03GMSetMum22'
% analysisTypeFolder = 'I:\PrakRuns_I\Output\(ID2207_R5_7Story_v.03_SlabNotConsidered_CORRECTShearPanel)_(AllVar)_(0.00)_(clough)_GMSetMum22';
%         designR = 5;
% 
%     case '2207v06' % codal time period = 0.91 used for scaling, redesigned considering LL reduction, selfwt correction
% analysisTypeFolder = 'I:\PrakRuns_I\Output\(ID2207_R5_7Story_v.06_ReducedLL_codalTimeP)_(AllVar)_(0.00)_(clough)';
%         designR = 5;
%         
%     case '2209v01' % analytical time period = 3.74 used for scaling. This is not correct, since Cs is based on codal time period.
% analysisTypeFolder = 'I:\PrakRuns_I\Output\(ID2209_R5_12Story_v.01)_(AllVar)_(0.00)_(clough)';
% %         saMedianCol = 0.440; betaRTR = 0.408; % record-to-record
%         designR = 5;
%     
%     case '2209v01b' % codal time period = 1.35 used for scaling
% analysisTypeFolder = 'I:\PrakRuns_I\Output\(ID2209_R5_12Story_v.01b_codalTimePForScaling)_(AllVar)_(0.00)_(clough)';
% %         saMedianCol = 0.440; betaRTR = 0.408; % record-to-record
%         designR = 5;
% 
%     case '2209v02' % codal time period = 1.35 used for scaling
% analysisTypeFolder = 'I:\PrakRuns_I\Output\(ID2209_R5_12Story_v.02_designWithReducedLL_codalTimeP)_(AllVar)_(0.00)_(clough)';
% %         saMedianCol = 0.440; betaRTR = 0.408; % record-to-record
%         designR = 5;
% 
%     case '2209v03' % analytical time period = 3.74 used for scaling. This is not correct, since Cs is based on codal time period.
% analysisTypeFolder = 'I:\PrakRuns_I\Output\(ID2209_R5_12Story_v.03_selfWtMatch)_(AllVar)_(0.00)_(clough)';
% %         saMedianCol = 0.440; betaRTR = 0.408; % record-to-record
%         designR = 5;
% 
%     case '2211v01' % analytical time period = 3.74 used for scaling. This is not correct, since Cs is based on codal time period.
% % analysisTypeFolder = 'I:\PrakRuns_I\Output\(ID2211_R5_2Story_v.01)_(AllVar)_(0.00)_(clough)';
% analysisTypeFolder = 'J:\PrakRuns_I_Output\(ID2211_R5_2Story_v.01)_(AllVar)_(0.00)_(clough)';
% %         saMedianCol = 0.440; betaRTR = 0.408; % record-to-record
%         designR = 5;
% 
%     case '2213v01' % analytical time period = 3.74 used for scaling. This is not correct, since Cs is based on codal time period.
% % analysisTypeFolder = 'I:\PrakRuns_I\Output\(ID2213_R5_4Story_v.01)_(AllVar)_(0.00)_(clough)';
% analysisTypeFolder = 'J:\PrakRuns_I_Output\(ID2213_R5_4Story_v.01)_(AllVar)_(0.00)_(clough)';
% %         saMedianCol = 0.440; betaRTR = 0.408; % record-to-record
%         designR = 5;
% 
%     case '2215v01' % analytical time period = 3.74 used for scaling. This is not correct, since Cs is based on codal time period.
% analysisTypeFolder = 'I:\PrakRuns_I\Output\(ID2215_R5_12Story_v.01)_(AllVar)_(0.00)_(clough)';
% %         saMedianCol = 0.440; betaRTR = 0.408; % record-to-record
%         designR = 5;
%     
%     case '2217v01' % analytical time period = 3.74 used for scaling. This is not correct, since Cs is based on codal time period.
% analysisTypeFolder = 'I:\PrakRuns_I\Output\(ID2217_R5_12Story_v.01)_(AllVar)_(0.00)_(clough)';
% %         saMedianCol = 0.440; betaRTR = 0.408; % record-to-record
%         designR = 5;
% 
%     case '2219v01' % analytical time period = 3.74 used for scaling. This is not correct, since Cs is based on codal time period.
% analysisTypeFolder = 'I:\PrakRuns_I\Output\(ID2219_R5_2Story_v.01)_(AllVar)_(0.00)_(clough)';
% %         saMedianCol = 0.440; betaRTR = 0.408; % record-to-record
%         designR = 5;
% 
%     case '2221v01' % analytical time period = 3.74 used for scaling. This is not correct, since Cs is based on codal time period.
% analysisTypeFolder = 'I:\PrakRuns_I\Output\(ID2221_R5_4Story_v.01)_(AllVar)_(0.00)_(clough)';
% %         saMedianCol = 0.440; betaRTR = 0.408; % record-to-record
%         designR = 5;
%     
%     case '2223v01' % analytical time period = 3.74 used for scaling. This is not correct, since Cs is based on codal time period.
% analysisTypeFolder = 'I:\PrakRuns_I\Output\(ID2223_R5_7Story_v.01)_(AllVar)_(0.00)_(clough)';
% %         saMedianCol = 0.440; betaRTR = 0.408; % record-to-record
%         designR = 5;
%     
%     case '2225v01b' % analytical time period = 3.74 used for scaling. This is not correct, since Cs is based on codal time period.
% analysisTypeFolder = 'I:\PrakRuns_I\Output\(ID2225_R5_12Story_v.01b_codalTimeP_exactSW)_(AllVar)_(0.00)_(clough)';
% %         saMedianCol = 0.440; betaRTR = 0.408; % record-to-record
%         designR = 5;
%     
%     case '2227v01' % analytical time period = 3.74 used for scaling. This is not correct, since Cs is based on codal time period.
% analysisTypeFolder = 'I:\PrakRuns_I\Output\(ID2227_R5_4Story_v.01)_(AllVar)_(0.00)_(clough)';
% %         saMedianCol = 0.440; betaRTR = 0.408; % record-to-record
%         designR = 5;
%     
%     case '2229v01' % analytical time period = 3.74 used for scaling. This is not correct, since Cs is based on codal time period.
% analysisTypeFolder = 'I:\PrakRuns_I\Output\(ID2229_R5_7Story_v.01)_(AllVar)_(0.00)_(clough)';
% %         saMedianCol = 0.440; betaRTR = 0.408; % record-to-record
%         designR = 5;
% 
%     case '2231v01' % analytical time period = 3.74 used for scaling. This is not correct, since Cs is based on codal time period.
% analysisTypeFolder = 'I:\PrakRuns_I\Output\(ID2231_R5_4Story_v.01)_(AllVar)_(0.00)_(clough)';
% %         saMedianCol = 0.440; betaRTR = 0.408; % record-to-record
%         designR = 5;
% 
%     case '2233v01' % analytical time period = 3.74 used for scaling. This is not correct, since Cs is based on codal time period.
% analysisTypeFolder = 'I:\PrakRuns_I\Output\(ID2233_R5_7Story_v.01)_(AllVar)_(0.00)_(clough)';
% %         saMedianCol = 0.440; betaRTR = 0.408; % record-to-record
%         designR = 5;
% 
%     case '2235v01' % analytical time period = 3.74 used for scaling. This is not correct, since Cs is based on codal time period.
% analysisTypeFolder = 'I:\PrakRuns_I\Output\(ID2235_R5_4Story_v.01)_(AllVar)_(0.00)_(clough)';
% %         saMedianCol = 0.440; betaRTR = 0.408; % record-to-record
%         designR = 5;
% 
%     case '2237v01' % analytical time period = 3.74 used for scaling. This is not correct, since Cs is based on codal time period.
% analysisTypeFolder = 'I:\PrakRuns_I\Output\(ID2237_R5_7Story_v.01)_(AllVar)_(0.00)_(clough)';
% %         saMedianCol = 0.440; betaRTR = 0.408; % record-to-record
%         designR = 5;
%         
% end

cd(analysisTypeFolder)
load('DATA_pushover.mat', 'plotArrayAndBaseShearArray')

BS = plotArrayAndBaseShearArray(:, 2);
defoVec = plotArrayAndBaseShearArray(:, 1);

% (12-01-16, PSB) added the following two commands to adjust for the
% pushover curve starting from a non-origin points. This causes the initial
% slope to look different from the actual value and gives a feeling that
% structure has yielded much earlier, in some cases even ealier than the
% factored design base shear value.

%     offsetOfBaseShear = interp1(defoVec, BS, 0); 
    ix = find(defoVec >= 0, 1);
    offsetOfBaseShear = interp1([defoVec(ix-1), defoVec(ix)], ...
                        [BS(ix-1), BS(ix)], 0, 'pchip');
    BS = BS - offsetOfBaseShear; 


    
[V_max, index] = max(BS);
V_temp = 0.1*V_max;
    BSTemp = BS(1:find(BS >= V_max*0.95, 1));
    dispTempVec = defoVec(1:find(BS >= V_max*0.95, 1));

disp_temp = interp1(BSTemp, dispTempVec, V_temp, 'linear');
delta_y_eff = disp_temp * V_max / V_temp;

% delta corresponding to Vbmax
deltaForVbmax = defoVec(index);


%     Vyield = interp1(defoVec, BS, delta_y_eff, 'pchip');
    ix = find(defoVec >= delta_y_eff, 1);
    Vyield = interp1([defoVec(ix-1), defoVec(ix)], ...
                    [BS(ix-1), BS(ix)], delta_y_eff, 'pchip');

BS_postVmax = BS(index:end);
defoVec_postVmax = defoVec(index:end);
% delta_u = interp1(BS_postVmax, defoVec_postVmax, 0.8*V_max);
    ix = find(BS_postVmax <= 0.8*V_max, 1);
    if isempty(ix)
        delta_u = 0;
    else
        delta_u = interp1([BS_postVmax(ix-1), BS_postVmax(ix)], ...
                            [defoVec_postVmax(ix-1), defoVec_postVmax(ix)], 0.8*V_max, 'pchip');
    end


  
cd(baseFolder)



