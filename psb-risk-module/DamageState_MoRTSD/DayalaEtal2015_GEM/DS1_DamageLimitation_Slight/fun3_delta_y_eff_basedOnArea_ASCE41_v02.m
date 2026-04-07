function [delta_y_eff, Vyield, BS, deltaD] = fun3_delta_y_eff_basedOnArea_ASCE41_v02(BuildingID)

% idealizing trilinear pushover curve as per ASCE 41-13 section 7.4.3.2.4 which in turn refers to FEMA 440 section 4.3
doPlot = 1;
baseFolder = pwd;

% BuildingID = '2227v01';
% roof drift ratio corresponding to the performance limit of 4% or 2% of Max IDR
% perfLimit = 0.02; 

% old code for fetching folder location
% cd H:\Arch_ResponseReductionFactorCalculation
% [analysisTypeFolder, designR] = returnBuildingInfo(BuildingID);

% new updated code for fetching folder location
% cd H:\DamageIndex\Automated
cd ..\..\..\DamageIndex\Automated\
[~, analysisTypeFolder, ~, ~] = returnModelFolderInfo(BuildingID);

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
cd(baseFolder)

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


%% idealizing trilinear pushover curve as per ASCE 41-13 section 7.4.3.2.4 which in turn refers to FEMA 440 section 4.3
% first point is default
pointA = [0, 0];

% third point is point with maximum base shear
[Vb_max, indexForVbMax] = max(BS);

% [Vb_max, indexForVbMax] = max(baseShearArray);
deltaD = defoVec(indexForVbMax);
pointC = [deltaD, Vb_max];

% second point is found out iteratively
fprintf('Vb_max  Guessed Vy  Guessed deltaY  ActualArea  GuessedArea \n');

% find actual area under C (one time calculation)    

% (9-26-20, PSB) commented the following two out. Apparently, I am not directly using another function that uses spline to find area 
%     descretizedDefoUptoPointC = 0:1:deltaD; % used for integration
%     descretizedBaseShearArrayUptoPointC = interp1(defoVec, BS, descretizedDefoUptoPointC);

% area using spline is more precise than area using trapz
%     actualAreaUptoC = trapz(descretizedDefoUptoPointC, descretizedBaseShearArrayUptoPointC);
%     actualAreaUptoC = fun3a_findAreaUsingSpline(descretizedDefoUptoPointC, descretizedBaseShearArrayUptoPointC, deltaD);
    actualAreaUptoC = fun3a_findAreaUsingSpline(defoVec, BS, deltaD);


%% iterate to zero in on Vy by using Newton Line search
    guessedVy = Vb_max; % first guess
    toleranceRequiredInVy = 1e-5;
    toleranceInVy = 100; % initiate tolerance. Keep it a high value, to reduce run time. 
                         % It doesn't effect precision, toleranceRequiredInVy does.
    
    baseShearArrayUptoC = BS(1:indexForVbMax);
    deformationArrayUptoC = defoVec(1:indexForVbMax);
    
    while guessedVy > Vb_max / 8  % just a random stopping criteria, to stop if something goes wrong
%         counterForIteration = counterForIteration + 1;
        
%         firstIntersectionWithActualCurve_X = interp1(baseShearArrayUptoC, deformationArrayUptoC, guessedVy * 0.60);
        ix = find(baseShearArrayUptoC >= guessedVy * 0.60, 1);
        firstIntersectionWithActualCurve_X = interp1([baseShearArrayUptoC(ix-1), baseShearArrayUptoC(ix)], ...
                    [deformationArrayUptoC(ix-1), deformationArrayUptoC(ix)], guessedVy * 0.60, 'pchip');
        
        firstIntersectionWithActualCurve_Y = guessedVy * 0.60;
        guessedDeltaY = 1/0.6 * firstIntersectionWithActualCurve_X; % simple linear interpolation

        guessedPointB = [guessedDeltaY, guessedVy];
       
        guessedAreaUptoC = guessedVy * guessedDeltaY / 2 + (deltaD - guessedDeltaY) * (guessedVy + Vb_max) / 2;

% fprintf('%.1f \t %.5f \t %.5f \t %.1f \t\t %.1f \n', Vb_max, guessedVy, guessedDeltaY, actualAreaUptoC, guessedAreaUptoC);        
        
        if (guessedAreaUptoC < actualAreaUptoC) && (toleranceInVy <= toleranceRequiredInVy) % used to break the iteration
            convergedVy = guessedVy;
            convergedDeltaY = guessedDeltaY;
            if convergedVy > Vb_max || convergedDeltaY > deltaD
                error(' Either, convergedVy = %.2f > Vb_max = %.2f Or, \n convergedDeltaY = %.2f > deltaD = %.2f \n Probable mistake in actualArea calculation ', ...
                    convergedVy, Vb_max, convergedDeltaY, deltaD);
            end
            fprintf('%.1f \t %.4f \t %.4f \t\t %.4f \t %.4f \n', Vb_max, guessedVy, guessedDeltaY, actualAreaUptoC, guessedAreaUptoC);           
            fprintf('Final tolerance achieved = %f \n', toleranceInVy);

            fprintf('--------------------------------------------- \n');
            fprintf('---- PUSHOVER CURVE IDEALIZATION RESULTS ---- \n');
            fprintf('--------------------------------------------- \n');
            
            fprintf('Vy = %.2f, deltaY = %f \n', guessedVy, guessedDeltaY);
            fprintf('Vmax = %.2f, deltaD = %f \n', Vb_max, deltaD);

            break
        elseif guessedAreaUptoC < actualAreaUptoC % we have crossed the Vy estimate once.
            % reset guess to the last value, since we update the guessedVy by reducing it
            fprintf('%.1f \t %.3f \t %.3f \t\t %.4f \t %.4f \n', Vb_max, guessedVy, guessedDeltaY, actualAreaUptoC, guessedAreaUptoC);
            fprintf('Achieved tolerance = %f > Reqd tolerance = %f \n', toleranceInVy, toleranceRequiredInVy);
            guessedVy = guessedVy + toleranceInVy;
            toleranceInVy = toleranceInVy /10;
        end
%         gussessAreaUptoC_LIST(counterForIteration) = guessedAreaUptoC;
        guessedVy = guessedVy - toleranceInVy;
    end % end of the while loop used for zeroing in on Vy
    
    pointB = [guessedDeltaY, guessedVy]; % point B has been determined now
    
    fprintf('--------------------------------------------- \n');
 
    idealizedCurvePoints = [pointA; pointB; pointC];
    xCoords = idealizedCurvePoints(:, 1);     yCoords = idealizedCurvePoints(:, 2);


    delta_y_eff = pointB(1);
    Vyield = pointB(2);
    
%% Plot the actual curve and idealized pushover curve    
if doPlot == 1
    figure
    h1 = plot(defoVec, BS, 'k-', 'LineWidth', 2.4); hold on; grid on; 
    h2 = plot(xCoords, yCoords, 'm--', 'LineWidth', 2.4); 
    plot([delta_y_eff, delta_y_eff], [0, pointB(1, 2)], 'k--', 'LineWidth', 1);
    plot([0, delta_y_eff], [pointB(1, 2), pointB(1, 2)], 'k--', 'LineWidth', 1);
    legh = legend([h1, h2], 'Actual SPO Curve', 'Idealized Curve', 'Location', 'SouthEast');
    
    xUppLim = (ceil(max(defoVec)*100)) / 100; % round up to hundred's place
    yUppLim = (ceil(max(BS)/200)) * 200; % round up to second decimal place
    xlim([0 xUppLim]); ylim([0 yUppLim]);
    
    hx = xlabel('Roof Drift'); hy = ylabel('\it{V_B} (kN)');
    psb_FigureFormatScript_paper
    set(gca,'fontname','times')
    
    text(delta_y_eff, 0, '\Delta_y ', 'FontSize', 14, 'HorizontalAlignment', 'right', 'verticalAlignment', 'bottom')
    text(0, pointB(1, 2), ' \it{V_y}', 'FontSize', 14, 'HorizontalAlignment', 'left', 'verticalAlignment', 'bottom')
    
    cd(baseFolder)
    cd MultObjRTSD_results

    exportName = sprintf('pushoverIdealizedASCE41_%s', BuildingID);
    hgsave(exportName); % .fig file for Matlab
    print('-depsc', exportName); % .eps file for Linux (LaTeX)
    print('-dmeta', exportName); % .emf file for Windows (MSWORD)
    
    cd ..
end
     
cd(baseFolder)
