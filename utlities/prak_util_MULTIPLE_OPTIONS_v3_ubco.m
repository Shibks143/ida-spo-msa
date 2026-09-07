clear
% clearvars -except eqDetails
tic
baseFolder = pwd; baseF = pwd;

% =========================== recent What-to-do's ===========================  
% ========= (do NOT clutter this list; clear it every and now then) =========
% whatToDo = '6b.extractTimePOneBldg_QUICK';
% whatToDo = '12e1.VerySimpleTH_plot';
% whatToDo = '36.PlotStoryWiseAxialShearMomentAtTheEndOfPushover';
% ====================================================================

% ====================================================================
% ===================== LIST OF ALL WHAT-TO-DO's =====================
%  whatToDo = '1.compareTHResponse';
%   whatToDo = '1a.compareTHResponseMThetaOfColumn';
%  whatToDo = '2.compareNonStandardTH';
%   whatToDo = '3a.compareIDAForSoil';
%   whatToDo = '3b.compareGeneralIDA';
%  whatToDo = '4a.minutesToRunThisAnalysisNEW';
% %  whatToDo = '4b.minutesToRunThisAnalysisOLD';
%  whatToDo = '5.extractEqDetails';
%   whatToDo = '5a.extractEqDetailsMumbai245_92_22';
%   whatToDo = '5b.extractEqDetailsMumbai2p56';
%   whatToDo = '5c.extractEqDetailsGM_Paper2';
%   whatToDo = '5d.extractEqDetailsGM_2211_Del22';
%  whatToDo = '6.extractTimePeriodsForAllEQ';
%   whatToDo = '6a.extractTimePeriodsForAllBldgs';
%  whatToDo = '7.extractResponseSpectra';
%   whatToDo = '7a.extractResponseSpectraWithScaledIS1893';
%   whatToDo = '7a1.extractResponseSpectraWithScaledSiteSpecificUHSDelhiOrGuwahati';
%   whatToDo = '7a2.extractResponseSpectraWithScaledSiteSpecificUHS_CMSDelhiOrGuwahati';
%   whatToDo = '7a3.extractResponseSpectraWithScaledVancouverResponseSpectrum';
%   whatToDo = '7b.extractSaValForVariousEQs';
%   whatToDo = '7c.plotUHS_CMS_WithGMPM';
%  whatToDo = '8.compareOrPlotGroundMotionTH';
%  whatToDo = '9.curtailGroundMotionBasedOnPGA';
%   whatToDo = '9a.curtailGroundMotionBasedOnPGAForMumbai250';
%   whatToDo = '9b.curtailGroundMotionBasedOnPGAForMumbai50Remaining';
%   whatToDo = '9c.curtailGroundMotionBasedOnPGAForMumbai22Remaining';
%   whatToDo = '9d.curtailGroundMotionBasedOnPGAForMumbai2602p56';
%   whatToDo = '9d.curtailGroundMotionBasedOnPGAForVanBRBGF40_1p50';
%  whatToDo = '10.extractMaxTolUsedOUT';
%   whatToDo = '10a.extractIsCollIsNonConvOUT'; % CONVERGENCE ISSUES
%  whatToDo = '11.PlotMPhiWithBackboneCurve';
%   whatToDo = '11a.PlotBackboneCurve';
%  whatToDo = '12.PlotGeneralMPhi';
% %   whatToDo = '12a.PlotGeneralMPhiShearPanel';
%   whatToDo = '12b.PlotGeneralMPhiLimitStateCurve';
%   whatToDo = '12c.PlotGeneralMPhiLimitStateCurve_Axial';
%   whatToDo = '12d.PlotShearHingeOfLimitState';
%   whatToDo = '12e.PlotSimpleMPhi';
%   whatToDo = '12e1.VerySimpleTH_plot';
%   whatToDo = '12f.PlotMThetaOfRotHinge';
% whatToDo = '12f1.plotForceDeformationHysteresis_BRBGF_BRB';
% whatToDo = '12f2.plotForceDeformationHysteresis_BRBGF_Dowel';
%   whatToDo = '12g.PlotTH_Snippet';
%     whatToDo = '12g1.FindScalingFactorToMatchSaT1_ofOneBuilding';
%   whatToDo = '12h.PlotTH_Tiles_P695AndBRBGF_SaT1_etc';
%  whatToDo = '13.countNumberOfAnalyses';
%  whatToDo = '14.copyFilesIntoManyFolders';
%   whatToDo = '14a.RenameAndReplaceFilesBasedOnSomeRule';
%   whatToDo = '14ap.RenameAndReplaceFilesBasedOnSomeRule';
%   whatToDo = '14app.RenameAndReplaceFilesBasedOnSomeRule';
%   whatToDo = '14b.changeVariableNamesInSeveralMatFile';
%   whatToDo = '14c.copySingleFileToManyFolders';
%   whatToDo = '14d.copyFilesFromOneLayerForBackup';
%  whatToDo = '15.FindModalParticipationFactorAndModeShapes';
%   whatToDo = '15a.FindModalParticipationFactorAndModeShapes_Multiple';
%   whatToDo = '15b.FindModalParticipationFactorAndModeShapes_Examiner';
%   whatToDo = '15c.FindModalParticipationFactorAndModeShapes_ResBldgs';
%  whatToDo = '16.ReadMultipleCsvFilesAndClubThemIntoOne';
%  whatToDo = '17.DetermineIDR';
%  whatToDo = '18.extract_MuSa_betaRTR'; % (this is simplified version of case-21, not necessarily Obsolete) Prefer Case- 21
%   whatToDo = '18a.extract_SaColMinMax'; % now case 18. includes this (use 21d. for fragility correpsonding to different damage states
%  whatToDo = '19.psb_PlotDefoShapeSingleEQ_v1';
%  whatToDo = '20.extractMaxAndMinAxialLoad';
%  whatToDo = '21.extract_MuSa_betaRTR_and_convertFragilityToNewTimeP';
%   whatToDo = '21p.extract_MuSa_betaRTR_and_convertFragilityToNewTimeP';
%   whatToDo = '21a.convertFragilityToIM_vamva';
%   whatToDo = '21b.extractFragility_SaT1geoM';
%   whatToDo = '21c.extractFragility_PGA';
%   whatToDo = '21d.extractFragility_PGA_SMRFArch'; % IM = PGA for SMRFArch
%   whatToDo = '21e.extractFragility_SaTa_SMRFArch'; % IM = same as used for analysis; SaTa for SMRFArch
%   whatToDo = '21f.extractFragility_PGA_MultiRTSDPaper_CS'; % IM = PGA for multi-objective RTSD framework paper using GM suite matching with CS
%   whatToDo = '21g.extractFragility_SaTa_MultiRTSDPaper_CS'; % IM = same as 21f; with SaTa as IM 
%  whatToDo = '22.findNumOfRepetitionInAList';
%  whatToDo = '23.findEqFoldersWithoutMatFiles';
%  whatToDo = '24.combineFourFigures';
%   whatToDo = '24a.combineFourFigures';
%   whatToDo = '24b.combineFourFigures';
%   whatToDo = '24c.combineSixFigures';
%   whatToDo = '24d.combineSixFigures';
%   whatToDo = '24e.combineSixFigures';
%   whatToDo = '24f.combineSixFigures';
%   whatToDo = '24g.combineSixFigures';
%   whatToDo = '24p_g.combineDifferentFiguresOnSamePlot_2225';
%   whatToDo = '24p_g.combineDifferentFiguresOnSamePlot_2437';
%   whatToDo = '24g.combineThreeFigures_CND';
%  whatToDo = '25.extractVmaxAndMuT'; %  % Note that "H:\Arch_RRF_usingSPO\scriptForBatchCalFEMAP695AndASCE41Both" incorporates this case and more. 
%  whatToDo = '26.openMultiplePushoverCurves';
%   whatToDo = '26a.openMultiplePushoverCurvesAndCopy';
%   whatToDo = '26b.openMultiplePushoverCurvesAndCopy';
%   whatToDo = '26c.openMultiplePushoverCurvesAndCopy';
%   whatToDo = '26d.openMultiplePushoverCurvesAndCopy';
%   whatToDo = '26e.openMultiplePushoverCurvesAndCopy';
%  whatToDo = '27.extractCurvatureForCriticalMembersInSPO'; % not yet implemented. Check "H:\P1_rotationDuctility".
%  whatToDo = '28.openMultiple_TCL_files';
%  whatToDo = '29.convertImageToBnW';
%  whatToDo = '30.readTextFilesSevenSections';
%  whatToDo = '31.opentextFilesInNotepad++';
% whatToDo = '32.CopyAllMatFilesFromAnalysisOutput';
whatToDo = '32a.CopyAllMatFilesFromAnalysisOutput_BRBGF';
% whatToDo = '32b.CopyAllFigFilesFromMultipleDirectory_GMReport';
% whatToDo = '32c.FormatFigFilesInBulk_GMReport_Overleaf';
% whatToDo = '33.plotIDA_quantiles_mean_84_16';
% whatToDo = '33a.plotIDA_quantiles_mean_84_16_BRBGF';
% whatToDo = '33b.postProcIDAForGlulamColCapacity_quantiles_mean_84_16_BRBGF';
% whatToDo = '34.PlotResidualDriftVsMaxIDR';
% whatToDo = '34a.PlotResidualDriftVsMaxIDR_BRBGF';
% whatToDo = '35.PlotPeakFloorAccnVsSa_IDA_Fragility';
% whatToDo = '36.PlotStoryWiseAxialShearMomentAtTheEndOfPushover';
% whatToDo = '37.Add100AtTheEndOfIDA';
% whatToDo = '38.saveAndPlotResidualDriftRatio_IDA'
% whatToDo = '39.PlotStoryWise_MaxIDR_ResIDR_PFA_atMCE_tiledLayout_BRBGF';
% whatToDo = '39a.PlotStoryWise_MaxIDR_ResIDR_PFA_atMCE_separateFigs';
% whatToDo = '40.findGlulamAxialForceForTruncatedIDA_checkOnGFOnly';
% whatToDo = '40a.findGlulamAxialForceForTruncatedIDA_checkOnAllStories';
% whatToDo = '41.scriptBulkDownload';
% whatToDo = '42.fun_correctInBulk_GMReport';
% whatToDo = '43.combineMultipleMatFiles';

    fprintf('What to Do? Executing %s.\n', whatToDo);

 axisNumberFontSize = 16; xAxisLabelFontSize = 20; yAxisLabelFontSize = 20; legendFontSize = 16;
 titleFontSize = 20;
 
% %  Either compare time history responses OR list the time taken in
% % minutes to run analyses

switch whatToDo
    case '1.compareTHResponse'
  %%
        outputFilenameLIST = {
%     '(Arch_4story_ID1010_v.13_Alt_modForSF)_(AllVar)_(0.00)_(clough)0.02dtForAnalysis'
%     '(Arch_4story_ID1010_v.13_Alt_modForSF)_(AllVar)_(0.00)_(clough)0.01dtForAnalysis'
%     '(Arch_4story_ID1010_v.13_Alt_modForSF)_(AllVar)_(0.00)_(clough)0.001dtForAnalysis'
%     '(Arch_4story_ID1010_v.13_Alt_modForSF)_(AllVar)_(0.00)_(clough)'
%     '(Arch_4story_ID1010_v.13_Alt_modForSF)_(AllVar)_(0.00)_(clough)0.005dtForCurtailedAnalysis'
%     '(Archetype1Story_2063_modForSF)_(AllVar)_(0.00)_(clough)'
%     '(Archetype1Story_2063_modForSF)_(AllVar)_(0.00)_(clough)(0.005_0.42_0.34_0.05_test_)'

%     '(Arch_8story_ID1012_v.61_modForSF)_(AllVar)_(0.00)_(clough)'
%     '(Arch_8story_ID1012_v.61_modForSF(changedFoot))_(AllVar)_(0.00)_(clough)'
% 
%     '(Arch_8story_ID1012_v.61_modForSF)_(AllVar)_(0.00)_(clough)10ExtraSec'
%     '(Arch_8story_ID1012_v.61_modForSF)_(AllVar)_(0.00)_(clough)NoExtraSec'
%     '(Arch_8story_ID1012_v.61_modForSF(changedFoot))_(AllVar)_(0.00)_(clough)'
%     
%     '(CivilBldg_3story_ID0001_v.01_trying)_(AllVar)_(0.00)_(clough)'
%     '(debuggingTheErrorInITHA)_(AllVar)_(0.00)_(clough)'
%     '(DebugConventinalUnits)_(AllVar)_(0.00)_(clough)'
%     '(Arch_4story_ID1010_v.13_Alt_modForSF)_(AllVar)_(0.00)_(clough)(0.05_1.35_0.25_0.05_C)'
%     '(Haselton_1010)_(AllVar)_(0.00)_(clough)'
%     '(Arch_4story_ID1010_v.13_Alt_modForSF)_(AllVar)_(0.00)_(clough)(0.001_0.86_0.15_0.05_Test)'

%     '(CivilBldg_3story_ID0001_v.02_trying)_(AllVar)_(0.00)_(clough)'
%     '(CivilBldg_3story_ID0001_v.03_ReleasedDummy)_(AllVar)_(0.00)_(clough)'
    
%     '(psb_RunSingleInelasticDynamicAnalysis)_(AllVar)_(0.00)_(clough)' % Run independently
%     '(CivilBldg_3story_ID9901_v.02_trying)_(AllVar)_(0.00)_(clough)'% Run through MATLAB
    
%     '(CivilBldg_3story_ID9901_v.02_trying)_(AllVar)_(0.00)_(clough)' % 5% damping in mode 1 and mode 3
%     '(CivilBldg_3story_ID9901_v.06_10damp_effectOfDamping)_(AllVar)_(0.00)_(clough)' % 10% damping in mode 1 and mode 3
%     '(CivilBldg_3story_ID9901_v.07_30damp_effectOfDamping)_(AllVar)_(0.00)_(clough)' % 30% damping in mode 1 and mode 3
%     '(CivilBldg_3story_ID9901_v.10_5pcRayleighIn1stN3rdMode)_(AllVar)_(0.00)_(clough)'
%     '(CivilBldg_3story_ID9901_v.02_trying)_(AllVar)_(0.00)_(clough)'
%     '(SingleRun_Filiatrault_ID8802(R4)_v.06(AfterIntensity2_colOrientationCorrected))_(AllVar)_(0.00)_(clough)'

%     '(ID2221_R5_4Story_v.02)_(AllVar)_(0.00)_(clough)'
%     '(ID2221_R5_4Story_v.03_revisedLambda)_(AllVar)_(0.00)_(clough)'
    
%     'J:\PrakRuns_I_Output\(ID2221_R5_4Story_v.02)_(AllVar)_(0.00)_(clough)'
%     'I:\PrakRuns_I\Output\(ID2221_R5_4Story_v.04)_(AllVar)_(0.00)_(clough)'
    
%     'I:\PrakRuns_I\Output\(ID2206_R3_7Story_v.05_ShearHingeModel1B_full)_(AllVar)_(0.00)_(clough)'
%     'I:\PrakRuns_I\Output\(ID2206_R3_7Story_v.05_ShearHingeModel1C_full)_(AllVar)_(0.00)_(clough)'

%      'I:\PrakRuns_I\Output\(ID2206_R3_7Story_v.05_ShearHingeModel1C_full)_(AllVar)_(0.00)_(clough)'
%      'I:\PrakRuns_I\Output\(ID2206_R3_7Story_v.05_ShearHingeModel1C_WITHOUT_SHEAR_HINGE)_(AllVar)_(0.00)_(clough)'
%      'I:\PrakRuns_I\Output\(ID2206_R3_7Story_v.05_ShearHingeModel1C_Joint2D)_(AllVar)_(0.00)_(clough)'
    
%      'I:\PrakRuns_I\Output\(ID2319_R3_7Story_v.01)_(AllVar)_(0.00)_(clough)'
%      'I:\PrakRuns_I\Output\(ID2319_R3_7Story_v.02)_(AllVar)_(0.00)_(clough)'     
%      'I:\PrakRuns_I\Output\(ID2316_R3_7Story_v.01)_(AllVar)_(0.00)_(clough)'
%      'I:\PrakRuns_I\Output\(ID2311_R3_7Story_v.01)_(AllVar)_(0.00)_(clough)'

%      'I:\PrakRuns_I\Output\(Temp_2316_SingleAnalysis)_(AllVar)_(0.00)_(clough)'

% 'I:\PrakRuns_I\Output\(ID2316_R3_7Story_v.01)_(AllVar)_(0.00)_(clough)OLD'
% 'I:\PrakRuns_I\Output\(ID2316_R3_7Story_v.01)_(AllVar)_(0.00)_(clough)'

% 'I:\PrakRuns_I\Output\(ID2316_R3_7Story_v.01)_(AllVar)_(0.00)_(clough)'
% 'I:\PrakRuns_I\Output\(psb_RunSingleInelasticDynamicAnalysis_2316_autoChangeOfDt_WORKS)_(AllVar)_(0.00)_(clough)'
% 'I:\PrakRuns_I\Output\(ID2316_R3_7Story_TEMP)_(AllVar)_(0.00)_(clough)'

%     'K:\Output\(ID2311_R3_7Story_v.01)_(AllVar)_(0.00)_(clough)_dtBy2'
%     'I:\PrakRuns_I\Output\(ID2311_R3_7Story_v.01)_(AllVar)_(0.00)_(clough)'
%     'K:\Output\(ID2316_R3_7Story_v.01)_(AllVar)_(0.00)_(clough)'

%     'K:\Output\(ID2306_R3_7Story_v.01)_(AllVar)_(0.00)_(clough)_dtBy10'
%     'K:\Output\(ID2311_R3_7Story_v.01)_(AllVar)_(0.00)_(clough)_dtBy10'

%     'J:\PrakRuns_I_Output\(ID2221_R5_4Story_v.02)_(AllVar)_(0.00)_(clough)'
%     'J:\PrakRuns_I_Output\(ID2227_R5_4Story_v.02)_(AllVar)_(0.00)_(clough)'
    
    'H:\PrakRuns\Output\(SingleRun_Filiatrault_ID8802(R4)_v.08(NoLeaningCol))_(AllVar)_(0.00)_(clough)'
    };

strForLegend = {
% 'dt=0.02'
% 'dt=0.01'
% 'dt=0.001'
% 'dt=0.02_New'
%  'dt=0.005'
% 'dt=0.001'
% 'dt=0.005'

% 'RotStiffFoot = 3,772,675'
% 'RotStiffFoot = 12,800,000'

% 'RotStiffFoot = 12,800,000 10 extra Seconds'
% 'RotStiffFoot = 12,800,000'
% 'RotStiffFoot = 3,772,675'
% 'coded in kN-mm units'
% 'coded in conventional units'
% 'v2'
% 'v3'

%  'Run independently'
%  'Run through MATLAB'

% '5% damping'
% '10% damping'
% '30% damping'
% 'Tolerance of Sa_col = 0.02'
% 'Tolerance of Sa_col = 0.06'

% 'Top floor disp for v02'
% 'Top floor disp for v04'

% 'Top floor disp for v05_1B_4DFlexJt&VHinge'
% 'Top floor disp for v05_1C_0DFlexJt&3M+1MVHinge'

% 'Top floor disp for v05_1C_0DFlexJt&3M+1MV_Hinge'
% 'Top floor disp for v05_1C_0DFlexJt&4M_No_V_Hinge'
% 'Top floor disp for v05_1C_4DFlexJt&No_V_Hinge'

%  '2319_v02_Top floor displacement time history'
%  '2316_v01_Top floor displacement time history'

%  '2316_Temp Top floor displacement time history'
 
%  '2316 with dt/2'
%  '2316 with dt/10'

% '2316 with dt/10 Sa = 1.32'
% '2316 with dt/10 Sa = 1.31'

%  '2311_v01_Top floor disp. time history (SCWB = 2.0) dtBy2'
%  '2311_v01_Top floor disp. time history (SCWB = 2.0) dtBy10'
%  '2316_v01_Top floor disp. time history (SCWB = 1.5)'

%  '2306_v01_Top floor disp. TH (SCWB = 2.5) dtBy10'
%  '2311_v01_Top floor disp. TH (SCWB = 2.0) dtBy10'
 
%  'ID-2221 (3 bays)'
%  'ID-2227 (5 bays)'

    'Top floor relative displacement, 0.21g'
};

divideByBldgHeight = 0; % 1- yes divide. 0- No, let it be displ
   
C = {'r','b','g','k','y',[.5 .6 .7],[.8 .2 .6],}; % Cell array of 7 colors.
MarkerTypeList={'r-','b--','k-.','g--','y..',[.5 .6 .7],[.8 .2 .6],}; % Cell array of 7 markers.

figure()

for outputFileIndex=1:length(outputFilenameLIST)
   
outputFileName=outputFilenameLIST{outputFileIndex};
% common parameters for comparison
eqNumber = 880102; 
Sa = 0.42;
objectType = 'Nodes';
% objectType ='Elements';
nodeNumber = 203013;

eqFolder = sprintf('EQ_%d',eqNumber);
SaFolder = sprintf('Sa_%3.2f',Sa);

currentFolder = pwd;

% cd Output
%  cd H:\PrakRuns\Output
% cd I:\PrakRuns_I\Output

% if(outputFileIndex == 1)
%     cd H:\PrakRuns\Output
% elseif (outputFileIndex == 2)
%     cd E:\MyOPENSEES\THESIS\HaseltonRuns\Output
% end


cd(outputFileName)
cd(eqFolder)
cd(SaFolder)
cd(objectType)
cd DisplTH
displFileName = sprintf('THNodeDispl_%d.out',nodeNumber);
displTH = load(displFileName);
timeArray = displTH(:,1);


if divideByBldgHeight == 0
    xDisplArray = displTH(:,2);
else
    cd .. 
    cd ..
    cd RunInformation

    floorHeightLIST = load('floorHeightLISTOUT.out');
    bldgHeight = max(floorHeightLIST);
    
    xDisplArray = displTH(:,2)/bldgHeight;
end

% plot(timeArray, xDisplArray,'-','color',C{outputFileIndex},'LineWidth',1.0); hold on;
plot(timeArray, xDisplArray,MarkerTypeList{outputFileIndex},'LineWidth',1.0); hold on; grid on;
hx = xlabel('Time (second) \rightarrow');

if divideByBldgHeight == 0
    hy = ylabel('Displacement (mm) \rightarrow');
else
    hy = ylabel('Drift (unitless) \rightarrow');
end

fprintf('residual drift is %8.6f \n',xDisplArray(end));

% changing directory back to the original folder 
cd(currentFolder)
end
legend(strForLegend, 'Interpreter', 'none'); %, 'Location', 'SouthEast');
htitle = title(sprintf('EqID = %i, Sa = %.2fg', eqNumber, Sa));
psb_FigureFormatScript


    exportName = 'DisplacementHistoryTopFloor_v8';
%     exportName = 'Displacement history of 2221 vs 2227';
%     cd H:\PrakRuns\
    cd H:\PrakRuns\Filiatrault
    print('-dmeta', exportName);
    disp(['File saved as ', fullfile(pwd, exportName)]);    
    
    case '1a.compareTHResponseMThetaOfColumn'
  %%
        outputFilenameLIST = {
%     '(ID2221_R5_4Story_v.02)_(AllVar)_(0.00)_(clough)'
%     '(ID2221_R5_4Story_v.03_revisedLambda)_(AllVar)_(0.00)_(clough)'
    
    'J:\PrakRuns_I_Output\(ID2221_R5_4Story_v.02)_(AllVar)_(0.00)_(clough)'
    'J:\PrakRuns_I_Output\(ID2227_R5_4Story_v.02)_(AllVar)_(0.00)_(clough)'
    };

strForLegend = {
% 'Top floor disp for v02'
% 'Top floor disp for v03'

 'ID-2221 (3 bays)'
 'ID-2227 (5 bays)'
};

divideByBldgHeight = 0; % 1- yes divide. 0- No, let it be displ

    
C = {'r','b','g','k','y',[.5 .6 .7],[.8 .2 .6],}; % Cell array of 7 colors.
MarkerTypeList={'r-','b--','k-.','g--','y..',[.5 .6 .7],[.8 .2 .6],}; % Cell array of 7 markers.

for outputFileIndex=1:length(outputFilenameLIST)
   
outputFileName=outputFilenameLIST{outputFileIndex};
% common parameters for comparison
eqNumber = 121111;
Sa = 1.32;

% objectType = 'Nodes';
% objNumber = 205013; % nodeNumber, in this case


%% NOTE- FOR COLUMN OR BEAM'S MOMENT ROTATION TIME HISTORY, ENTER THE JOINT
% NUMBER TIMES 10 + CORRESPONDING LOCATION ID OF THE SPRING. e.g.- for 3rd
% floor column bottom spring, enter (4030 * 10 + 3 ) = 403013
objectType ='Elements';
objNumber = 403013; % eleNumber, in this case. 


eqFolder = sprintf('EQ_%d',eqNumber);
SaFolder = sprintf('Sa_%3.2f',Sa);

currentFolder = pwd;

% cd Output
%  cd H:\PrakRuns\Output
cd I:\PrakRuns_I\Output

% if(outputFileIndex == 1)
%     cd H:\PrakRuns\Output
% elseif (outputFileIndex == 2)
%     cd E:\MyOPENSEES\THESIS\HaseltonRuns\Output
% end


cd(outputFileName)
cd(eqFolder)
cd(SaFolder)
cd(objectType)

if strcmp(objectType, 'Nodes')
    cd DisplTH
    displFileName = sprintf('THNodeDispl_%d.out',objNumber);
    displTH = load(displFileName);
    timeArray = displTH(:,1);
elseif strcmp(objectType, 'Elements')
%     cd EleLocalTH
    cd Joints
    jointNumber = fix(objNumber/10);
    springID = rem(objNumber, 10);
    displFileName = sprintf('Joint_ForceAndDef_%d.out', jointNumber);
    objectTH = load(displFileName);
    % there are 5 columns of deformation followed by 5 columns of forces
    timeArray = objectTH(:, springID); % force (moment for columns, etc.)
    xDisplArray = objectTH(:, 5+springID); % deformation (rotation for columns, etc.)
    displTH = [timeArray xDisplArray]; % just so that the objectType = 'Nodes' part of the code continues to work after this 'if'
end


if divideByBldgHeight == 0
    xDisplArray = displTH(:,2);
else
    cd .. 
    cd ..
    cd RunInformation

    floorHeightLIST = load('floorHeightLISTOUT.out');
    bldgHeight = max(floorHeightLIST);
    
    xDisplArray = displTH(:,2)/bldgHeight;
end

% plot(timeArray, xDisplArray,'-','color',C{outputFileIndex},'LineWidth',1.0); hold on;
plot(timeArray, xDisplArray,MarkerTypeList{outputFileIndex},'LineWidth',1.0); hold on; grid on;
% comet(timeArray, xDisplArray); 



if strcmp(objectType, 'Nodes')
    hx = xlabel('Time (second) \rightarrow');
        if divideByBldgHeight == 0
            hy = ylabel('Displacement (mm) \rightarrow');
        else
            hy = ylabel('Drift (unitless) \rightarrow');
        end
elseif strcmp(objectType, 'Elements')
    hx = xlabel('Rotation (rad) \rightarrow');
    hy = ylabel('Moment (kN-mm) \rightarrow');
end
fprintf('residual drift is %8.6f \n',xDisplArray(end));

% changing directory back to the original folder 
cd(currentFolder)
end
legend(strForLegend, 'Location', 'southeast');
psb_FigureFormatScript

%     exportName = 'DisplacementHistoryTopFloor';
    exportName = 'Displacement history of 2221 vs 2227';
    cd H:\PrakRuns\ % cd H:\PrakRuns\Filiatrault
    print('-dmeta', exportName);
    disp(['File saved as ', fullfile(pwd, exportName)]);    
    
    case '2.compareNonStandardTH'
%%
cd 'H:\PrakRuns\Output'
outputFolderLIST = {
    '(CivilBldg_3story_ID9901_v.10_5pcRayleighIn1stN3rdMode)_(AllVar)_(0.00)_(clough)'
%     '(temp)_(AllVar)_(0.00)_(clough)'
    '(CivilBldg_3story_ID9901_v.12_5pcRayleigh_1st2ndMode_K_tangent)_(AllVar)_(0.00)_(clough)'
    };

strForLegend = {
'Initial Rayleigh 5% in 1st and 3rd mode'
'Tangent Rayleigh 5% in 1st and 3rd mode'
% 'Tolerance of 0.02 in Sa_{col} minIDRmaxForCol = 0.12'
% 'Tolerance of 0.06 in Sa_{col} minIDRmaxForCol = 0.18'
};

divideByBldgHeight = 0; % 1- yes divide. 0- No, let it be displ

C = {'r','b','g','k','y',[.5 .6 .7],[.8 .2 .6],}; % Cell array of 7 colors.
MarkerTypeList={'r-','b--','k-.','g--','y..',[.5 .6 .7],[.8 .2 .6],}; % Cell array of 7 markers.

for outputFileIndex=1:length(outputFolderLIST)
   
outputFileName=outputFolderLIST{outputFileIndex};
% common parameters for comparison
eqNumber = 121322;
Sa = 2.52;
objectType = 'Nodes';
% objectType ='Elements';
nodeNumber = 205013;

eqFolder = sprintf('EQ_%d',eqNumber);
SaFolder = sprintf('Sa_%3.2f',Sa);

currentFolder = pwd;

cd(outputFileName)
cd(eqFolder)
cd(SaFolder)
cd(objectType)
cd DisplTH
displFileName = sprintf('THNodeDispl_%d.out',nodeNumber);
displTH = load(displFileName);
timeArray = displTH(:,1);

cd .. 
cd ..
cd RunInformation

floorHeightLIST = load('floorHeightLISTOUT.out');
bldgHeight = max(floorHeightLIST);

if divideByBldgHeight == 0
    xDisplArray = displTH(:,2);
else
    xDisplArray = displTH(:,2)/bldgHeight;
end

% plot(timeArray, xDisplArray,'-','color',C{outputFileIndex},'LineWidth',1.0); hold on;
plot(timeArray, xDisplArray,MarkerTypeList{outputFileIndex},'LineWidth',1.0); hold on; grid on;
xlabel('Time (second) \rightarrow');

if divideByBldgHeight == 0
    ylabel('Displacement (consistent unit) \rightarrow');
else
    ylabel('Drift (unitless) \rightarrow');
end

fprintf('residual drift is %8.6f',xDisplArray(end));

% changing directory back to the original folder 
cd(currentFolder)
end
legend(strForLegend);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%% Part  - 2 %%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    case '3a.compareIDAForSoil'
 %%
 outputFilenameLIST = {
'(Arch_8story_ID1012_v.61_modForSF)_(AllVar)_(0.00)_(clough)'
'(Arch_8story_ID1012_v.61_modForSF_10_times)_(AllVar)_(0.00)_(clough)'
'(Arch_8story_ID1012_v.61_modForSF_20_times)_(AllVar)_(0.00)_(clough)'
'(Arch_8story_ID1012_v.61_modForSF_0.1_times)_(AllVar)_(0.00)_(clough)'
'(Arch_8story_ID1012_v.61_modForSF_0.05_times)_(AllVar)_(0.00)_(clough)'
};

% common parameters for comparison
    eqNumber = 120122;
    buildingID = 1012; % used for naming plots only
    
    strForLegend = {
'RotStiffFoot = Actual'
'RotStiffFoot = 10 \times Actual'
'RotStiffFoot = 20 \times Actual'
'RotStiffFoot = (1/10) \times Actual'
'RotStiffFoot = (1/20) \times Actual'
};
    
C = {'r','b','g','k','y',[.5 .6 .7],[.8 .2 .6],}; % Cell array of 7 colors.
MarkerTypeList={'r-o','b-d','k-+','g-<','k-s',[.5 .6 .7],[.8 .2 .6],}; % Cell array of 7 markers.
% MarkerTypeList={'k-o','k--d','k-.+','k-*','k-s',[.5 .6 .7],[.8 .2 .6],}; % Cell array of 7 markers.

for outputFileIndex = 1:length(outputFilenameLIST)
   
outputFileName = outputFilenameLIST{outputFileIndex};

currentFolder = pwd;
cd E:\MyOPENSEES\THESIS\HaseltonRuns\Output
cd(outputFileName)
eqFolder = sprintf('EQ_%d',eqNumber);
cd(eqFolder)

    load DATA_collapse_ProcessedIDADataForThisEQ ;
    saLevels = saLevelsForIDAPlotPROCLIST;
    maxDriftRatio = maxDriftRatioForPlotPROCLIST;

% plot(timeArray, xDisplArray,'-','color',C{outputFileIndex},'LineWidth',1.0); hold on;
plot(maxDriftRatio, saLevels, MarkerTypeList{outputFileIndex}, 'LineWidth', 1.5); hold on; grid on;

    str1 = '$IDR_{max} \rightarrow$'; str2 = '$S_a(T_1) \quad [g] \rightarrow$';
    hx = xlabel(str1, 'Interpreter', 'latex');    hy = ylabel(str2, 'Interpreter', 'latex');
    set(hx, 'FontSize', xAxisLabelFontSize); set(hy, 'FontSize', yAxisLabelFontSize);

% changing directory back to the original folder 
cd(currentFolder)
end
    set(gca, 'FontSize', axisNumberFontSize); grid on;
    xlim([0 0.15]);
    htitle =  title(['IDA curves for EQ no ' num2str(eqNumber)]); set(htitle, 'FontSize', titleFontSize);
    h_legend = legend(strForLegend);    set(h_legend,'FontSize', legendFontSize, 'Location', 'southeast');
% 	set(h_legend,'Interpreter','latex');          

% Save the plot as a .fig file in Output folder
    cd E:\MyOPENSEES\THESIS\HaseltonRuns\Output
        plotName = sprintf('IDA_EQ_%d_BldgID_%d.fig', eqNumber, buildingID);
        hgsave(plotName);
% Export the plot as a .emf file 
%          exportName = sprintf('IDA_EQ_%d_BldgID_%d.emf', eqNumber, buildingID);
%         print('-dmeta', exportName);
          
% Export the plot as a .eps file 
          exportName = sprintf('IDA_EQ_%d_BldgID_%d.eps', eqNumber, buildingID);
          print('-depsc', exportName);prak
          
    case '3b.compareGeneralIDA'
 %%
%  outputFilenameLIST = {
% '(CivilBldg_3story_ID9901_v.10_5pcRayleighIn1stN3rdMode)_(AllVar)_(0.00)_(clough)'
% '(CivilBldg_3story_ID9901_v.10b_5pcRayleighIn1stN3rdMode_0.18IDRmaxCol)_(AllVar)_(0.00)_(clough)'
% '(CivilBldg_3story_ID9901_v.12_5pcRayleigh_1st2ndMode_K_tangent)_(AllVar)_(0.00)_(clough)'
% };

%  outputFilenameLIST = {
% '(ID2206_R3_7Story_v.06)_(AllVar)_(0.00)_(clough)_dtBy20'
% '(ID2321_R3_7Story_v.01)_(AllVar)_(0.00)_(clough)_dtBy20'
% '(ID2319_R3_7Story_v.02)_(AllVar)_(0.00)_(clough)_dtBy20'
% '(ID2316_R3_7Story_v.01)_(AllVar)_(0.00)_(clough)_dtBy10'
% '(ID2311_R3_7Story_v.01)_(AllVar)_(0.00)_(clough)_dtBy10'
% '(ID2306_R3_7Story_v.01)_(AllVar)_(0.00)_(clough)_dtBy10'
% '(ID2301_R3_7Story_v.01)_(AllVar)_(0.00)_(clough)_dtBy10'
% };

 outputFilenameLIST = {
'(ID2221_R5_4Story_v.02)_(AllVar)_(0.00)_(clough)'
'(ID2227_R5_4Story_v.02)_(AllVar)_(0.00)_(clough)'
};

% common parameters for comparison
    eqNumber = 121111; % 120812, 121011, 121422, 120812, 121111, 120411;

%     plotNameID = 'effectOfSCWBonIDA'; % used for naming plots only
    plotNameID = 'diffBet2221&2227'; % used for naming plots only
    
%     strForLegend = {
% 'Tolerance of 0.02 in Sa_{col} minIDRmaxForCol = 0.12'
% 'Tolerance of 0.02 in Sa_{col} minIDRmaxForCol = 0.18'
% 'Tolerance of 0.02 in Sa_{col} minIDRmaxForCol = 0.12'
% };
    
%     strForLegend = {
% '2206, IS-1893-2001'
% '2321, SCWB = 1.0'
% '2319, SCWB = 1.2'
% '2316, SCWB = 1.5'
% '2311, SCWB = 2.0'
% '2306, SCWB = 2.5'
% '2301, SCWB = 3.0'
% };

    strForLegend = {
'2221'
'2227'
};

C = {'r','b','g','k','y',[.5 .6 .7],[.8 .2 .6],}; % Cell array of 7 colors.
MarkerTypeList={'r-o','b-d','k-+','g-<','k-s','y-o','m-o',[.5 .6 .7],[.8 .2 .6],}; % Cell array of 7 markers.
% MarkerTypeList={'k-o','k--d','k-.+','k-*','k-s',[.5 .6 .7],[.8 .2 .6],}; % Cell array of 7 markers.

for outputFileIndex = 1:length(outputFilenameLIST)
   
outputFileName = outputFilenameLIST{outputFileIndex};

currentFolder = pwd;
% cd E:\MyOPENSEES\THESIS\HaseltonRuns\Output
% cd H:\PrakRuns\Output
% cd K:\Output

cd J:\PrakRuns_I_Output
cd(outputFileName)
eqFolder = sprintf('EQ_%d',eqNumber);
cd(eqFolder)

    load DATA_collapse_ProcessedIDADataForThisEQ ;
    saLevels = saLevelsForIDAPlotPROCLIST;
    maxDriftRatio = maxDriftRatioForPlotPROCLIST;

% plot(timeArray, xDisplArray,'-','color',C{outputFileIndex},'LineWidth',1.0); hold on;
plot(maxDriftRatio, saLevels, MarkerTypeList{outputFileIndex}, 'LineWidth', 1.5); hold on; grid on;

    str1 = '$IDR_{max} \rightarrow$'; str2 = '$S_a(T_1) \quad [g] \rightarrow$';
    hx = xlabel(str1, 'Interpreter', 'latex');    hy = ylabel(str2, 'Interpreter', 'latex');
    set(hx, 'FontSize', xAxisLabelFontSize); set(hy, 'FontSize', yAxisLabelFontSize);

% changing directory back to the original folder 
cd(currentFolder)
end
    set(gca, 'FontSize', axisNumberFontSize); grid on;
    xlim([0 0.15]);
    htitle =  title(['IDA curves for EQ no ' num2str(eqNumber)]); set(htitle, 'FontSize', titleFontSize);
    h_legend = legend(strForLegend);    set(h_legend,'FontSize', legendFontSize, 'Location', 'southeast');
% 	set(h_legend,'Interpreter','latex');          

% Save the plot as a .fig file in Output folder
%     cd E:\MyOPENSEES\THESIS\HaseltonRuns\Output
    cd I:\PrakRuns_I\Output
        plotName = sprintf('IDA_EQ_%d_BldgID_%s.fig', eqNumber, plotNameID);
        hgsave(plotName);
% Export the plot as a .emf file 
%          exportName = sprintf('IDA_EQ_%d_BldgID_%d.emf', eqNumber, plotNameID);
%         print('-dmeta', exportName);
          
% Export the plot as a .eps file 
          exportName = sprintf('IDA_EQ_%d_BldgID_%s.eps', eqNumber, plotNameID);
          print('-depsc', exportName);

    case '4a.minutesToRunThisAnalysisNEW' 
%% (approximate run time- 50 sec)
%%%%%%%%%%%%%%%%%%%%%%%%% start of the input %%%%%%%%%%%%%%%%%%%%%%%%%% 
% cd H:\PrakRuns\Output\
% cd '(CivilBldg_3story_ID9901_v.09_curtailedGMduration)_(AllVar)_(0.00)_(clough)'
% cd '(CivilBldg_3story_ID9901_v.10_5pcRayleighIn1stN3rdMode)_(AllVar)_(0.00)_(clough)'
% cd '(CivilBldg_3story_ID9901_v.11_5pcRayleighIn1stN2ndMode)_(AllVar)_(0.00)_(clough)'
% cd '(CivilBldg_3story_ID9901_v.02_trying)_(AllVar)_(0.00)_(clough)'
% cd '(CivilBldg_3story_ID9901_v.04_trying)_(AllVar)_(0.00)_(clough)'
% cd '(CivilBldg_3story_ID9901_v.07_30damp_effectOfDamping)_(AllVar)_(0.00)_(clough)'
% cd '(CivilBldg_3story_ID9901_v.06_10damp_effectOfDamping)_(AllVar)_(0.00)_(clough)'
% cd '(CivilBldg_3story_ID9901_v.08_2damp_effectOfDamping)_(AllVar)_(0.00)_(clough)'

cd H:\PrakRuns_FDA\Output\(ID2207_R5_7Story_v.03_SlabNotConsidered_CORRECTShearPanel_FDAMum245)_(AllVar)_(0.00)_(clough)_(FDA)

eqNumberLIST_forProcessing_SetC = [120111, 120112, 120121, 120122,	120411, 120412,	120521, 120522,	120611, 120612,	120621, 120622,	120711, 120712,	120721, 120722,	120811, 120812,	120821, 120822,	120911, 120912,	120921, 120922,	121011, 121012,	121021, 121022,	121111, 121112,	121211, 121212,	121221, 121222,	121321, 121322,	121411, 121412,	121421, 121422,	121511, 121512,	121711, 121712];
eqNumberLIST_forProcessing_SetMumbai245 = [6000701	6000702	6002501	6002502	6006801	6006802	6008001	6008002	6008101	6008102	6016601	6016602	6023001	6023002	6023201	6023202	6024601	6024602	6028901	6028902	6030301	6030302	6031001	6031002	6031201	6031202	6032501	6032502	6032801	6032802	6033401	6033402	6034001	6034002	6035401	6035402	6047801	6047802	6049501	6049502	6052901	6052902	6053801	6053802	6054301	6054302	6057001	6057002	6057201	6057202	6057401	6057402	6057901	6057902	6061401	6061402	6063801	6063802	6064101	6064102	6067601	6067602	6072601	6072602	6074601	6074602	6078201	6078202	6079401	6079402	6079701	6079702	6080601	6080602	6081301	6081302	6081601	6081602	6086201	6086202	6088601	6088602	6091001	6091002	6091801	6091802	6092001	6092002	6092101	6092102	6092301	6092302	6092601	6092602	6092901	6092902	6093101	6093102	6093201	6093202	6094101	6094102	6094201	6094202	6094401	6094402	6095301	6095302	6095401	6095402	6095601	6095602	6095901	6095902	6096401	6096402	6096601	6096602	6097601	6097602	6097801	6097802	6097901	6097902	6098801	6098802	6099301	6099302	6099801	6099802	6100401	6100402	6100801	6100802	6101101	6101102	6102001	6102002	6102301	6102302	6103801	6103802	6104201	6104202	6104601	6104602	6104701	6104702	6104901	6104902	6105601	6105602	6105701	6105702	6106501	6106502	6107901	6107902	6108201	6108202	6108701	6108702	6109901	6109902	6110201	6110202	6110501	6110502	6114401	6114402	6115801	6115802	6117201	6117202	6119101	6119102	6119301	6119302	6121801	6121802	6122101	6122102	6122401	6122402	6123001	6123002	6124901	6124902	6125801	6125802	6127201	6127202	6128101	6128102	6128601	6128602	6128901	6128902	6130301	6130302, ...
        6136101	6136102	6138701	6138702	6143701	6143702	6147101	6147102	6151501	6151502	6151701	6151702	6152001	6152002	6152101	6152102	6156001	6156002	6158101	6158102	6159301	6159302	6160001	6160002	6160401	6160402	6160501	6160502	6164001	6164002	6164301	6164302	6168101	6168102	6175401	6175402	6176001	6176002	6178001	6178002	6178601	6178602	6180501	6180502	6180601	6180602	6181101	6181102	6182001	6182002	6182301	6182302	6182901	6182902	6183101	6183102	6183701	6183702	6199401	6199402	6199501	6199502	6199701	6199702	6200301	6200302	6209701	6209702	6210001	6210002	6211101	6211102	6211201	6211202	6222201	6222202	6225201	6225202	6225301	6225302	6228101	6228102	6228501	6228502	6228701	6228702	6235101	6235102	6237201	6237202	6238101	6238102	6239401	6239402	6239701	6239702	6241101	6241102	6241301	6241302	6245701	6245702	6246201	6246202	6246301	6246302	6248301	6248302	6249501	6249502	6250101	6250102	6257301	6257302	6259301	6259302	6259501	6259502	6261301	6261302	6262101	6262102	6262401	6262402	6263801	6263802	6264401	6264402	6266001	6266002	6269801	6269802	6271601	6271602	6271701	6271702	6273001	6273002	6275301	6275302	6278401	6278402	6278501	6278502	6280701	6280702	6282101	6282102	6286301	6286302	6286901	6286902	6287301	6287302	6287401	6287402	6288801	6288802	6293701	6293702	6293801	6293802	6294001	6294002	6294401	6294402	6294701	6294702	6294801	6294802	6294901	6294902	6296201	6296202	6297601	6297602	6298201	6298202	6298501	6298502	6299201	6299202	6299301	6299302	6299601	6299602	6302701	6302702	6305401	6305402	6306001	6306002	6306101	6306102	6306201	6306202	6307701	6307702	6308701	6308702, ...
        6312001	6312002	6316701	6316702	6317401	6317402	6317501	6317502	6317701	6317702	6319701	6319702	6320301	6320302	6321301	6321302	6322101	6322102	6322501	6322502	6323201	6323202	6323301	6323302	6323801	6323802	6323901	6323902	6324801	6324802	6325301	6325302	6326401	6326402	6326701	6326702	6328301	6328302	6328401	6328402	6330501	6330502	6330601	6330602	6332001	6332002	6332601	6332602	6332701	6332702	6333201	6333202	6333301	6333302	6334101	6334102	6334201	6334202	6334901	6334902	6335001	6335002	6335101	6335102	6336901	6336902	6343901	6343902	6345601	6345602	6346101	6346102	6346401	6346402	6346501	6346502	6347101	6347102	6347501	6347502	6348601	6348602	6349501	6349502	6350801	6350802	6352701	6352702	6352901	6352902];

% eqNumLIST = eqNumberLIST_forProcessing_SetC;
eqNumLIST = eqNumberLIST_forProcessing_SetMumbai245;

buildingID = 2207; % used for naming the graph only
saInitial = 0.40; % very low value, to avoid prompting user for input every time
saIncrForSearch = 0.10; % keeping it small should not compromize performace much
saFinal = 0.90; % very high value, to avoid prompting user for input every time

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%% end of the input %%%%%%%%%%%%%%%%%%%%%%%%%% 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


for eqIndex = 1:length(eqNumLIST)
    currentEq = eqNumLIST(eqIndex);
    currentEqFolder = sprintf('EQ_%s', num2str(currentEq)); 
    cd(currentEqFolder)
    
    currentSa = saInitial; % initiate
    saIndex = 0; % counter of number of Sa Indices

% % Store Data for this one EQ
while currentSa <= saFinal %saIndex < 10 
    currentSaFolder = sprintf('Sa_%s', num2str(currentSa, '%.2f')); 
    if(~exist(currentSaFolder, 'dir'))
        currentSa = currentSa + 0.01;
        continue
    end
% % do following if the folder with Sa value exists
    saIndex = saIndex + 1;
    
    cd(currentSaFolder)
    cd RunInformation
    minutesToRun(eqIndex, saIndex) = load('minutesToRunThisAnalysisOUT.out');
    cd ..
    cd .. % back to the currentEqFolder. For processing next Sa

    currentSa = currentSa + 0.01;
end
    cd .. % back to specific output folder for processing next Eq
end

    case '4b.minutesToRunThisAnalysisOld'
%%
outputFilenameLIST = {
%     '(Arch_4story_ID1010_v.13_Alt_modForSF)_(AllVar)_(0.00)_(clough)0.02dtForAnalysis'
%     '(Arch_4story_ID1010_v.13_Alt_modForSF)_(AllVar)_(0.00)_(clough)0.01dtForAnalysis'
%     '(Arch_4story_ID1010_v.13_Alt_modForSF)_(AllVar)_(0.00)_(clough)0.001dtForAnalysis'
%     '(Arch_4story_ID1010_v.13_Alt_modForSF)_(AllVar)_(0.00)_(clough)'
%     '(Arch_8story_ID1012_v.61_modForSF)_(AllVar)_(0.00)_(clough)'
%     '(Arch_8story_ID1012_v.61_modForSF(changedFoot))_(AllVar)_(0.00)_(clough)'
    '(CivilBldg_3story_ID9901_v.07_30damp_effectOfDamping)_(AllVar)_(0.00)_(clough)'
    };
    
eqNumberLIST = [120121 120122 120411 120412];
SaLIST = [0.11 0.32 0.52 0.72 0.92 1.12];

            currentFolder= pwd;
            
for outputFileIndex = 1:length(outputFilenameLIST)
    outputFileName = outputFilenameLIST{outputFileIndex};
        for eqNumberFileIndex = 1:length(eqNumberLIST)
            eqNumber = eqNumberLIST(eqNumberFileIndex);
                for SaIndex = 1:length(SaLIST)
                    Sa = SaLIST(SaIndex);
                    eqFolder = sprintf('EQ_%d',eqNumber);
                    SaFolder = sprintf('Sa_%3.2f',Sa);
                    
                    cd Output; 
                    cd(outputFileName); cd(eqFolder); cd(SaFolder);
                    cd RunInformation;

                    minutesToRun=load('minutesToRunThisAnalysisOUT.out');
                    msgToDisplay=sprintf('For %s, EQ %i, Sa %4.2fg TimeTaken is %4.2fmins',outputFileName,eqNumber,Sa,minutesToRun);
                    disp(msgToDisplay);
        % save data in a matrix
                    str1 = ['outputFile' num2str(outputFileIndex)];
                    dataForTimeTakenInMinutes.(str1)(eqNumberFileIndex, SaIndex) = minutesToRun;
                    
                    cd(currentFolder);                
                end
        end
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%% Part  - 3 %%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    case '5.extractEqDetails'
%%
eqNumberLIST_forProcessing_SetC = [120111, 120112, 120121, 120122,	120411, 120412,	120521, 120522,	120611, 120612,	120621, 120622,	120711, 120712,	120721, 120722,	120811, 120812,	120821, 120822,	120911, 120912,	120921, 120922,	121011, 121012,	121021, 121022,	121111, 121112,	121211, 121212,	121221, 121222,	121321, 121322,	121411, 121412,	121421, 121422,	121511, 121512,	121711, 121712];
eqNumberLIST_forProcessing_SetD = [120111	120112	120121	120122	120131	120132	120141	120142	120151	120152	120161	120162	120411	120412	120521	120522	120611	120612	120621	120622	120631	120632	120641	120642	120711	120712	120721	120722	120731	120732	120741	120742	120811	120812	120821	120822	120911	120912	120921	120922	120931	120932	121011	121012	121021	121022	121031	121032	121041	121042	121051	121052	121061	121062	121111	121112	121211	121212	121221	121222	121231	121232	121321	121322	121411	121412	121421	121422	121431	121432	121441	121442	121451	121452	121461	121462	121511	121512	121711	121712];
   eqLIST = eqNumberLIST_forProcessing_SetC;
cd C:\OpenSeesProcessingFiles\EQs

totNumOfEQs = length(eqLIST);

eqDetails = zeros(totNumOfEQs, 4); % First col is for eqNumber, second for dt, third for NPts and forth for duration of EQ.

for eqIndex = 1:totNumOfEQs
    eqNumber = eqLIST(eqIndex);
    NPtFile = sprintf('NumPointsFile_(%i).txt', eqNumber);
%     currentNPt = load(NPtFile);
    dtFile = sprintf('DtFile_(%i).txt', eqNumber);
    gmFile = sprintf('SortedEQFile_(%i).txt', eqNumber);
    
    eqDetails(eqIndex, 1) = eqNumber;
    eqDetails(eqIndex, 2) = load(dtFile);
    eqDetails(eqIndex, 3) = load(NPtFile);
    eqDetails(eqIndex, 4) = eqDetails(eqIndex, 2) * (eqDetails(eqIndex, 3) - 1);

%     groundMotionDetail{eqNumber}.eqNumber = eqNumber;
%     groundMotionDetail{eqNumber}.dt = load(dtFile);
%     groundMotionDetail{eqNumber}.NumPt = load(NPtFile);
%     groundMotionDetail{eqNumber}.duration = load(dtFile) * (load(NPtFile) - 1);
%     groundMotionDetail{eqNumber}.timeHistory = load(gmFile);
end

save eqDetailsForSetC.mat eqDetails
disp(['File saved as ', fullfile(pwd, 'eqDetailsForSetC.mat')]);

cd(baseFolder)

% clearvars -except eqDetails 

    case '5a.extractEqDetailsMumbai245_92_22'
%%
eqNumberLIST_forProcessing_SetC = [120111, 120112, 120121, 120122,	120411, 120412,	120521, 120522,	120611, 120612,	120621, 120622,	120711, 120712,	120721, 120722,	120811, 120812,	120821, 120822,	120911, 120912,	120921, 120922,	121011, 121012,	121021, 121022,	121111, 121112,	121211, 121212,	121221, 121222,	121321, 121322,	121411, 121412,	121421, 121422,	121511, 121512,	121711, 121712];
eqNumberLIST_forProcessing_SetD = [120111	120112	120121	120122	120131	120132	120141	120142	120151	120152	120161	120162	120411	120412	120521	120522	120611	120612	120621	120622	120631	120632	120641	120642	120711	120712	120721	120722	120731	120732	120741	120742	120811	120812	120821	120822	120911	120912	120921	120922	120931	120932	121011	121012	121021	121022	121031	121032	121041	121042	121051	121052	121061	121062	121111	121112	121211	121212	121221	121222	121231	121232	121321	121322	121411	121412	121421	121422	121431	121432	121441	121442	121451	121452	121461	121462	121511	121512	121711	121712];

eqNumberLIST_forProcessing_SetMumbai245 = [6000701	6000702	6002501	6002502	6006801	6006802	6008001	6008002	6008101	6008102	6016601	6016602	6023001	6023002	6023201	6023202	6024601	6024602	6028901	6028902	6030301	6030302	6031001	6031002	6031201	6031202	6032501	6032502	6032801	6032802	6033401	6033402	6034001	6034002	6035401	6035402	6047801	6047802	6049501	6049502	6052901	6052902	6053801	6053802	6054301	6054302	6057001	6057002	6057201	6057202	6057401	6057402	6057901	6057902	6061401	6061402	6063801	6063802	6064101	6064102	6067601	6067602	6072601	6072602	6074601	6074602	6078201	6078202	6079401	6079402	6079701	6079702	6080601	6080602	6081301	6081302	6081601	6081602	6086201	6086202	6088601	6088602	6091001	6091002	6091801	6091802	6092001	6092002	6092101	6092102	6092301	6092302	6092601	6092602	6092901	6092902	6093101	6093102	6093201	6093202	6094101	6094102	6094201	6094202	6094401	6094402	6095301	6095302	6095401	6095402	6095601	6095602	6095901	6095902	6096401	6096402	6096601	6096602	6097601	6097602	6097801	6097802	6097901	6097902	6098801	6098802	6099301	6099302	6099801	6099802	6100401	6100402	6100801	6100802	6101101	6101102	6102001	6102002	6102301	6102302	6103801	6103802	6104201	6104202	6104601	6104602	6104701	6104702	6104901	6104902	6105601	6105602	6105701	6105702	6106501	6106502	6107901	6107902	6108201	6108202	6108701	6108702	6109901	6109902	6110201	6110202	6110501	6110502	6114401	6114402	6115801	6115802	6117201	6117202	6119101	6119102	6119301	6119302	6121801	6121802	6122101	6122102	6122401	6122402	6123001	6123002	6124901	6124902	6125801	6125802	6127201	6127202	6128101	6128102	6128601	6128602	6128901	6128902	6130301	6130302, ...
6136101	6136102	6138701	6138702	6143701	6143702	6147101	6147102	6151501	6151502	6151701	6151702	6152001	6152002	6152101	6152102	6156001	6156002	6158101	6158102	6159301	6159302	6160001	6160002	6160401	6160402	6160501	6160502	6164001	6164002	6164301	6164302	6168101	6168102	6175401	6175402	6176001	6176002	6178001	6178002	6178601	6178602	6180501	6180502	6180601	6180602	6181101	6181102	6182001	6182002	6182301	6182302	6182901	6182902	6183101	6183102	6183701	6183702	6199401	6199402	6199501	6199502	6199701	6199702	6200301	6200302	6209701	6209702	6210001	6210002	6211101	6211102	6211201	6211202	6222201	6222202	6225201	6225202	6225301	6225302	6228101	6228102	6228501	6228502	6228701	6228702	6235101	6235102	6237201	6237202	6238101	6238102	6239401	6239402	6239701	6239702	6241101	6241102	6241301	6241302	6245701	6245702	6246201	6246202	6246301	6246302	6248301	6248302	6249501	6249502	6250101	6250102	6257301	6257302	6259301	6259302	6259501	6259502	6261301	6261302	6262101	6262102	6262401	6262402	6263801	6263802	6264401	6264402	6266001	6266002	6269801	6269802	6271601	6271602	6271701	6271702	6273001	6273002	6275301	6275302	6278401	6278402	6278501	6278502	6280701	6280702	6282101	6282102	6286301	6286302	6286901	6286902	6287301	6287302	6287401	6287402	6288801	6288802	6293701	6293702	6293801	6293802	6294001	6294002	6294401	6294402	6294701	6294702	6294801	6294802	6294901	6294902	6296201	6296202	6297601	6297602	6298201	6298202	6298501	6298502	6299201	6299202	6299301	6299302	6299601	6299602	6302701	6302702	6305401	6305402	6306001	6306002	6306101	6306102	6306201	6306202	6307701	6307702	6308701	6308702, ...
6312001	6312002	6316701	6316702	6317401	6317402	6317501	6317502	6317701	6317702	6319701	6319702	6320301	6320302	6321301	6321302	6322101	6322102	6322501	6322502	6323201	6323202	6323301	6323302	6323801	6323802	6323901	6323902	6324801	6324802	6325301	6325302	6326401	6326402	6326701	6326702	6328301	6328302	6328401	6328402	6330501	6330502	6330601	6330602	6332001	6332002	6332601	6332602	6332701	6332702	6333201	6333202	6333301	6333302	6334101	6334102	6334201	6334202	6334901	6334902	6335001	6335002	6335101	6335102	6336901	6336902	6343901	6343902	6345601	6345602	6346101	6346102	6346401	6346402	6346501	6346502	6347101	6347102	6347501	6347502	6348601	6348602	6349501	6349502	6350801	6350802	6352701	6352702	6352901	6352902];

eqNumberLIST_forProcessing_SetMumbai97 = [6152601	6152602	6245701	6245702	6045901	6045902	6182901	6182902	6160401	6160402	6262401	6262402	6349501	6349502	6104601	6104602	6333301	6333302	6000701	6000702	6288801	6288802	6248301	6248302	6334201	6334202	6105601	6105602	6163301	6163302	6108701	6108702	6032501	6032502	6088401	6088402	6035401	6035402	6263801	6263802	6094701	6094702	6199401	6199402	6136101	6136102	6321701	6321702	6158101	6158102	6092001	6092002	6110501	6110502	6321201	6321202	6064101	6064102	6091001	6091002	6236201	6236202	6138701	6138702	6262101	6262102	6002501	6002502	6128701	6128702	6302401	6302402	6104701	6104702	6298501	6298502	6103801	6103802	6282101	6282102	6278501	6278502	6111801	6111802	6031201	6031202	6156001	6156002	6100201	6100202	6028801	6028802	6026201	6026202	6128101	6128102	6079401	6079402	6079701	6079702	6094101	6094102	6332701	6332702	6035301	6035302	6057201	6057202	6149601	6149602	6329101	6329102	6229101	6229102	6239401	6239402	6211101	6211102	6321801	6321802	6123001	6123002	6092601	6092602	6107901	6107902	6125801	6125802	6006901	6006902	6293701	6293702	6023101	6023102	6228101	6228102	6263201	6263202	6151101	6151102	6300001	6300002	6163001	6163002	6325301	6325302	6323301	6323302	6199701	6199702	6305401	6305402	6091401	6091402	6134801	6134802	6351301	6351302	6148501	6148502	6151801	6151802	6259501	6259502	6110201	6110202	6317501	6317502	6281101	6281102	6079101	6079102	6297301	6297302	6211601	6211602	6240001	6240002	6095901	6095902	6031001	6031002	6346501	6346502	6347701	6347702	6323801	6323802	6257301	6257302	6023701	6023702	6072601	6072602];
   
eqNumberLIST_forProcessing_SetMumbai22 = [6018001	6018002	6034201	6034202	6151301	6151302	6105601	6105602	6282101	6282102	6302701	6302702	6055201	6055202	6278401	6278402	6002501	6002502	6265901	6265902	6072601	6072602	6326401	6326402	6096301	6096302	6350801	6350802	6092101	6092102	6280901	6280902	6095901	6095902	6332601	6332602	6108601	6108602	6032201	6032202	6279301	6279302	6159401	6159402];

% eqLIST = eqNumberLIST_forProcessing_SetMumbai245;
eqLIST = eqNumberLIST_forProcessing_SetMumbai22;

cd C:\OpenSeesProcessingFiles\EQs

totNumOfEQs = length(eqLIST);

eqDetails = zeros(totNumOfEQs, 4); % First col is for eqNumber, second for dt, third for NPts and forth for duration of EQ.

for eqIndex = 1:totNumOfEQs
    eqNumber = eqLIST(eqIndex);
    NPtFile = sprintf('NumPointsFile_(%i).txt', eqNumber);
%     currentNPt = load(NPtFile);
    dtFile = sprintf('DtFile_(%i).txt', eqNumber);
    gmFile = sprintf('SortedEQFile_(%i).txt', eqNumber);
    
    eqDetails(eqIndex, 1) = eqNumber;
    eqDetails(eqIndex, 2) = load(dtFile);
    
    fprintf('eqNumber = %i, dtFileContent = %s \n', eqNumber, load(dtFile));
    
    eqDetails(eqIndex, 3) = load(NPtFile);
    eqDetails(eqIndex, 4) = eqDetails(eqIndex, 2) * (eqDetails(eqIndex, 3) - 1);

%     groundMotionDetail{eqNumber}.eqNumber = eqNumber;
%     groundMotionDetail{eqNumber}.dt = load(dtFile);
%     groundMotionDetail{eqNumber}.NumPt = load(NPtFile);
%     groundMotionDetail{eqNumber}.duration = load(dtFile) * (load(NPtFile) - 1);
%     groundMotionDetail{eqNumber}.timeHistory = load(gmFile);
end

% outpFilename = 'eqDetailsForSetMumbai245.mat';
outpFilename = 'eqDetailsForSetMumbai22.mat';
save(outpFilename, 'eqDetails');
disp(['File saved as ', fullfile(pwd, outpFilename)]);

cd(baseFolder)

% clearvars -except eqDetails 

    case '5b.extractEqDetailsMumbai2p56'
%%
eqNumberLIST_forProcessing_SetC = [120111, 120112, 120121, 120122,	120411, 120412,	120521, 120522,	120611, 120612,	120621, 120622,	120711, 120712,	120721, 120722,	120811, 120812,	120821, 120822,	120911, 120912,	120921, 120922,	121011, 121012,	121021, 121022,	121111, 121112,	121211, 121212,	121221, 121222,	121321, 121322,	121411, 121412,	121421, 121422,	121511, 121512,	121711, 121712];
eqNumberLIST_forProcessing_SetD = [120111	120112	120121	120122	120131	120132	120141	120142	120151	120152	120161	120162	120411	120412	120521	120522	120611	120612	120621	120622	120631	120632	120641	120642	120711	120712	120721	120722	120731	120732	120741	120742	120811	120812	120821	120822	120911	120912	120921	120922	120931	120932	121011	121012	121021	121022	121031	121032	121041	121042	121051	121052	121061	121062	121111	121112	121211	121212	121221	121222	121231	121232	121321	121322	121411	121412	121421	121422	121431	121432	121441	121442	121451	121452	121461	121462	121511	121512	121711	121712];

eqNumberLIST_forProcessing_SetMumbai245 = [6000701	6000702	6002501	6002502	6006801	6006802	6008001	6008002	6008101	6008102	6016601	6016602	6023001	6023002	6023201	6023202	6024601	6024602	6028901	6028902	6030301	6030302	6031001	6031002	6031201	6031202	6032501	6032502	6032801	6032802	6033401	6033402	6034001	6034002	6035401	6035402	6047801	6047802	6049501	6049502	6052901	6052902	6053801	6053802	6054301	6054302	6057001	6057002	6057201	6057202	6057401	6057402	6057901	6057902	6061401	6061402	6063801	6063802	6064101	6064102	6067601	6067602	6072601	6072602	6074601	6074602	6078201	6078202	6079401	6079402	6079701	6079702	6080601	6080602	6081301	6081302	6081601	6081602	6086201	6086202	6088601	6088602	6091001	6091002	6091801	6091802	6092001	6092002	6092101	6092102	6092301	6092302	6092601	6092602	6092901	6092902	6093101	6093102	6093201	6093202	6094101	6094102	6094201	6094202	6094401	6094402	6095301	6095302	6095401	6095402	6095601	6095602	6095901	6095902	6096401	6096402	6096601	6096602	6097601	6097602	6097801	6097802	6097901	6097902	6098801	6098802	6099301	6099302	6099801	6099802	6100401	6100402	6100801	6100802	6101101	6101102	6102001	6102002	6102301	6102302	6103801	6103802	6104201	6104202	6104601	6104602	6104701	6104702	6104901	6104902	6105601	6105602	6105701	6105702	6106501	6106502	6107901	6107902	6108201	6108202	6108701	6108702	6109901	6109902	6110201	6110202	6110501	6110502	6114401	6114402	6115801	6115802	6117201	6117202	6119101	6119102	6119301	6119302	6121801	6121802	6122101	6122102	6122401	6122402	6123001	6123002	6124901	6124902	6125801	6125802	6127201	6127202	6128101	6128102	6128601	6128602	6128901	6128902	6130301	6130302, ...
6136101	6136102	6138701	6138702	6143701	6143702	6147101	6147102	6151501	6151502	6151701	6151702	6152001	6152002	6152101	6152102	6156001	6156002	6158101	6158102	6159301	6159302	6160001	6160002	6160401	6160402	6160501	6160502	6164001	6164002	6164301	6164302	6168101	6168102	6175401	6175402	6176001	6176002	6178001	6178002	6178601	6178602	6180501	6180502	6180601	6180602	6181101	6181102	6182001	6182002	6182301	6182302	6182901	6182902	6183101	6183102	6183701	6183702	6199401	6199402	6199501	6199502	6199701	6199702	6200301	6200302	6209701	6209702	6210001	6210002	6211101	6211102	6211201	6211202	6222201	6222202	6225201	6225202	6225301	6225302	6228101	6228102	6228501	6228502	6228701	6228702	6235101	6235102	6237201	6237202	6238101	6238102	6239401	6239402	6239701	6239702	6241101	6241102	6241301	6241302	6245701	6245702	6246201	6246202	6246301	6246302	6248301	6248302	6249501	6249502	6250101	6250102	6257301	6257302	6259301	6259302	6259501	6259502	6261301	6261302	6262101	6262102	6262401	6262402	6263801	6263802	6264401	6264402	6266001	6266002	6269801	6269802	6271601	6271602	6271701	6271702	6273001	6273002	6275301	6275302	6278401	6278402	6278501	6278502	6280701	6280702	6282101	6282102	6286301	6286302	6286901	6286902	6287301	6287302	6287401	6287402	6288801	6288802	6293701	6293702	6293801	6293802	6294001	6294002	6294401	6294402	6294701	6294702	6294801	6294802	6294901	6294902	6296201	6296202	6297601	6297602	6298201	6298202	6298501	6298502	6299201	6299202	6299301	6299302	6299601	6299602	6302701	6302702	6305401	6305402	6306001	6306002	6306101	6306102	6306201	6306202	6307701	6307702	6308701	6308702, ...
6312001	6312002	6316701	6316702	6317401	6317402	6317501	6317502	6317701	6317702	6319701	6319702	6320301	6320302	6321301	6321302	6322101	6322102	6322501	6322502	6323201	6323202	6323301	6323302	6323801	6323802	6323901	6323902	6324801	6324802	6325301	6325302	6326401	6326402	6326701	6326702	6328301	6328302	6328401	6328402	6330501	6330502	6330601	6330602	6332001	6332002	6332601	6332602	6332701	6332702	6333201	6333202	6333301	6333302	6334101	6334102	6334201	6334202	6334901	6334902	6335001	6335002	6335101	6335102	6336901	6336902	6343901	6343902	6345601	6345602	6346101	6346102	6346401	6346402	6346501	6346502	6347101	6347102	6347501	6347502	6348601	6348602	6349501	6349502	6350801	6350802	6352701	6352702	6352901	6352902];

eqNumberLIST_forProcessing_SetMumbai97 = [6152601	6152602	6245701	6245702	6045901	6045902	6182901	6182902	6160401	6160402	6262401	6262402	6349501	6349502	6104601	6104602	6333301	6333302	6000701	6000702	6288801	6288802	6248301	6248302	6334201	6334202	6105601	6105602	6163301	6163302	6108701	6108702	6032501	6032502	6088401	6088402	6035401	6035402	6263801	6263802	6094701	6094702	6199401	6199402	6136101	6136102	6321701	6321702	6158101	6158102	6092001	6092002	6110501	6110502	6321201	6321202	6064101	6064102	6091001	6091002	6236201	6236202	6138701	6138702	6262101	6262102	6002501	6002502	6128701	6128702	6302401	6302402	6104701	6104702	6298501	6298502	6103801	6103802	6282101	6282102	6278501	6278502	6111801	6111802	6031201	6031202	6156001	6156002	6100201	6100202	6028801	6028802	6026201	6026202	6128101	6128102	6079401	6079402	6079701	6079702	6094101	6094102	6332701	6332702	6035301	6035302	6057201	6057202	6149601	6149602	6329101	6329102	6229101	6229102	6239401	6239402	6211101	6211102	6321801	6321802	6123001	6123002	6092601	6092602	6107901	6107902	6125801	6125802	6006901	6006902	6293701	6293702	6023101	6023102	6228101	6228102	6263201	6263202	6151101	6151102	6300001	6300002	6163001	6163002	6325301	6325302	6323301	6323302	6199701	6199702	6305401	6305402	6091401	6091402	6134801	6134802	6351301	6351302	6148501	6148502	6151801	6151802	6259501	6259502	6110201	6110202	6317501	6317502	6281101	6281102	6079101	6079102	6297301	6297302	6211601	6211602	6240001	6240002	6095901	6095902	6031001	6031002	6346501	6346502	6347701	6347702	6323801	6323802	6257301	6257302	6023701	6023702	6072601	6072602];
   
eqNumberLIST_forProcessing_SetMumbai22 = [6018001	6018002	6034201	6034202	6151301	6151302	6105601	6105602	6282101	6282102	6302701	6302702	6055201	6055202	6278401	6278402	6002501	6002502	6265901	6265902	6072601	6072602	6326401	6326402	6096301	6096302	6350801	6350802	6092101	6092102	6280901	6280902	6095901	6095902	6332601	6332602	6108601	6108602	6032201	6032202	6279301	6279302	6159401	6159402];

% eqLIST = eqNumberLIST_forProcessing_SetMumbai245;

eqNumberLIST_forProcessing_SetMum2p56 = [6000901	6000902	6003801	6003802	6004001	6004002	6006901	6006902	6007701	6007702	6007801	6007802	6007901	6007902	6015401	6015402	6017201	6017202	6018701	6018702	6019201	6019202	6021001	6021002	6026901	6026902	6028601	6028602	6028801	6028802	6029201	6029202	6029501	6029502	6030001	6030002	6030201	6030202	6030301	6030302	6031201	6031202	6031901	6031902	6032201	6032202	6035401	6035402	6039101	6039102	6041401	6041402	6042501	6042502	6042801	6042802	6042901	6042902	6043101	6043102	6045301	6045302	6045601	6045602	6046801	6046802	6047001	6047002	6049201	6049202	6051001	6051002	6053001	6053002	6055001	6055002	6057001	6057002	6057201	6057202	6057301	6057302	6057501	6057502	6057701	6057702	6057801	6057802	6058401	6058402	6062401	6062402	6067401	6067402	6072001	6072002	6072101	6072102	6072401	6072402	6073501	6073502	6073701	6073702	6074201	6074202	6078201	6078202	6078601	6078602	6078901	6078902	6080001	6080002	6080601	6080602	6084301	6084302	6085401	6085402	6085901	6085902	6086201	6086202	6088201	6088202	6088301	6088302	6088501	6088502	6089701	6089702	6090901	6090902	6091901	6091902	6092101	6092102	6095801	6095802	6096301	6096302	6096801	6096802	6098501	6098502	6098601	6098602	6100801	6100802	6101501	6101502	6102401	6102402	6102601	6102602	6103401	6103402	6104201	6104202	6104601	6104602	6104801	6104802	6105701	6105702	6107401	6107402	6107701	6107702	6107801	6107802	6108001	6108002	6108601	6108602	6108701	6108702	6109001	6109002	6110001	6110002	6110101	6110102	6110701	6110702	6111601	6111602	6114401	6114402	6114501	6114502	6115801	6115802	6116601	6116602	6120401	6120402	6123401	6123402 ...
6124801	6124802	6125801	6125802	6126501	6126502	6126901	6126902	6127301	6127302	6127701	6127702	6128801	6128802	6130001	6130002	6131201	6131202	6131701	6131702	6134401	6134402	6135201	6135202	6135501	6135502	6138301	6138302	6139001	6139002	6140401	6140402	6147001	6147002	6148301	6148302	6150901	6150902	6151201	6151202	6151801	6151802	6153501	6153502	6153901	6153902	6154501	6154502	6155701	6155702	6156501	6156502	6157001	6157002	6158801	6158802	6159201	6159202	6159401	6159402	6161101	6161102	6162201	6162202	6162601	6162602	6163301	6163302	6163401	6163402	6176201	6176202	6176801	6176802	6177501	6177502	6179101	6179102	6180501	6180502	6180901	6180902	6181601	6181602	6182101	6182102	6182901	6182902	6183501	6183502	6183601	6183602	6184001	6184002	6206801	6206802	6210401	6210402	6211201	6211202	6220801	6220802	6222101	6222102	6222301	6222302	6226601	6226602	6226701	6226702	6227001	6227002	6227901	6227902	6228401	6228402	6229301	6229302	6245701	6245702	6247701	6247702	6247801	6247802	6248201	6248202	6249801	6249802	6255901	6255902	6256901	6256902	6258701	6258702	6259201	6259202	6259901	6259902	6260001	6260002	6260501	6260502	6260801	6260802	6262601	6262602	6263401	6263402	6264701	6264702	6269601	6269602	6271601	6271602	6271801	6271802	6273301	6273302	6274201	6274202	6274301	6274302	6274401	6274402	6274801	6274802	6277001	6277002	6281001	6281002	6284501	6284502	6285001	6285002	6285201	6285202	6287701	6287702	6288601	6288602	6289501	6289502	6294501	6294502	6294601	6294602	6295101	6295102	6295201	6295202	6295601	6295602	6295801	6295802	6296001	6296002	6296101	6296102	6299001	6299002 ...
6299201	6299202	6299301	6299302	6299401	6299402	6301101	6301102	6302401	6302402	6306201	6306202	6309801	6309802	6310201	6310202	6318701	6318702	6322201	6322202	6322301	6322302	6322401	6322402	6324501	6324502	6326001	6326002	6326701	6326702	6327101	6327102	6328301	6328302	6328501	6328502	6328801	6328802	6329201	6329202	6330201	6330202	6330301	6330302	6331301	6331302	6331401	6331402	6331501	6331502	6332001	6332002	6334101	6334102	6334801	6334802	6335001	6335002	6338101	6338102	6338201	6338202	6340001	6340002	6344201	6344202	6345501	6345502	6345901	6345902	6346101	6346102	6346301	6346302	6347101	6347102	6347201	6347202	6347701	6347702	6349101	6349102	6349201	6349202	6349601	6349602	6349701	6349702	6349801	6349802	6350101	6350102	6350901	6350902	6351101	6351102	6351401	6351402	6352501	6352502	6353901	6353902																																																																																																		 ...
6031401	6031402	6057501	6057502	6075401	6075402	6088401	6088402	6104601	6104602	6122401	6122402	6127701	6127702	6150401	6150402	6151201	6151202	6176801	6176802	6182301	6182302	6184101	6184102	6227901	6227902	6229201	6229202	6271601	6271602	6296401	6296402	6322301	6322302	6322401	6322402	6324501	6324502	6331401	6331402	6336701	6336702	6347701	6347702 ...
6039201	6039202	6080201	6080202	6082501	6082502	6098501	6098502	6101501	6101502	6118701	6118702	6120801	6120802	6130001	6130002	6139101	6139102	6150401	6150402	6155701	6155702	6158801	6158802	6247901	6247902	6264601	6264602	6274001	6274002	6280901	6280902	6293801	6293802	6293901	6293902	6295301	6295302	6295901	6295902	6298801	6298802	6348001	6348002];

% all downloaded ground motions

eqLIST = eqNumberLIST_forProcessing_SetMum2p56;

cd C:\OpenSeesProcessingFiles\EQs

totNumOfEQs = length(eqLIST);

eqDetails = zeros(totNumOfEQs, 4); % First col is for eqNumber, second for dt, third for NPts and forth for duration of EQ.

for eqIndex = 1:totNumOfEQs
    eqNumber = eqLIST(eqIndex);
    NPtFile = sprintf('NumPointsFile_(%i).txt', eqNumber);
%     currentNPt = load(NPtFile);
    dtFile = sprintf('DtFile_(%i).txt', eqNumber);
    gmFile = sprintf('SortedEQFile_(%i).txt', eqNumber);
    
    eqDetails(eqIndex, 1) = eqNumber;
    eqDetails(eqIndex, 2) = load(dtFile);
    
    fprintf('eqNumber = %i, dtFileContent = %s \n', eqNumber, load(dtFile));
    
    eqDetails(eqIndex, 3) = load(NPtFile);
    eqDetails(eqIndex, 4) = eqDetails(eqIndex, 2) * (eqDetails(eqIndex, 3) - 1);

%     groundMotionDetail{eqNumber}.eqNumber = eqNumber;
%     groundMotionDetail{eqNumber}.dt = load(dtFile);
%     groundMotionDetail{eqNumber}.NumPt = load(NPtFile);
%     groundMotionDetail{eqNumber}.duration = load(dtFile) * (load(NPtFile) - 1);
%     groundMotionDetail{eqNumber}.timeHistory = load(gmFile);
end

% outpFilename = 'eqDetailsForSetMumbai245.mat';
outpFilename = 'eqDetailsForSetMum2p56.mat';
save(outpFilename, 'eqDetails');
disp(['File saved as ', fullfile(pwd, outpFilename)]);

cd(baseFolder)

% clearvars -except eqDetails         
    
    case '5c.extractEqDetailsGM_Paper2'
%% 20×2 ground motion suites for bldg IDs- 3040, 3042, 3044, 3045, 3047, respectively.
eqNumberConditionalSpectra_304X = [
6000901	6000902	6001641	6001642	6001831	6001832	6004971	6004972	6007991	6007992	6008821	6008822	6009501	6009502	6010931	6010932	6012581	6012582	6012851	6012852	6013681	6013682	6013911	6013912	6016461	6016462	6019841	6019842	6022521	6022522	6029271	6029272	6032351	6032352	6033271	6033272	6033501	6033502	6034521	6034522 ...
6001881	6001882	6003521	6003522	6003931	6003932	6005451	6005452	6007241	6007242	6007611	6007612	6007811	6007812	6010131	6010132	6010701	6010702	6013491	6013492	6018301	6018302	6020261	6020262	6022791	6022792	6028181	6028182	6028301	6028302	6029331	6029332	6029871	6029872	6032871	6032872	6033821	6033822	6034921	6034922 ...
6001561	6001562	6002161	6002162	6003111	6003112	6006651	6006652	6007231	6007232	6007491	6007492	6008541	6008542	6009501	6009502	6009731	6009732	6013471	6013472	6015131	6015132	6017641	6017642	6020261	6020262	6026211	6026212	6029891	6029892	6032401	6032402	6033481	6033482	6034731	6034732	6034921	6034922	6034971	6034972 ...
6000211	6000212	6001111	6001112	6001231	6001232	6005301	6005302	6009901	6009902	6010021	6010022	6012111	6012112	6012321	6012322	6015211	6015212	6015851	6015852	6016271	6016272	6022701	6022702	6026501	6026502	6026571	6026572	6027931	6027932	6029101	6029102	6029801	6029802	6032831	6032832	6033821	6033822	6034041	6034042 ...
6000161	6000162	6001231	6001232	6004541	6004542	6004711	6004712	6004921	6004922	6004971	6004972	6006181	6006182	6006651	6006652	6007991	6007992	6008491	6008492	6008951	6008952	6010471	6010472	6017641	6017642	6020091	6020092	6021041	6021042	6023081	6023082	6026501	6026502	6026991	6026992	6032131	6032132	6033851	6033852
];

% all downloaded ground motions
eqLIST = eqNumberConditionalSpectra_304X;

cd C:\OpenSeesProcessingFiles\EQs

totNumOfEQs = length(eqLIST);
eqDetails = zeros(totNumOfEQs, 4); % First col is for eqNumber, second for dt, third for NPts and forth for duration of EQ.
for eqIndex = 1:totNumOfEQs
    eqNumber = eqLIST(eqIndex);
    NPtFile = sprintf('NumPointsFile_(%i).txt', eqNumber);
%     currentNPt = load(NPtFile);
    dtFile = sprintf('DtFile_(%i).txt', eqNumber);
    gmFile = sprintf('SortedEQFile_(%i).txt', eqNumber);
    
    eqDetails(eqIndex, 1) = eqNumber;
    eqDetails(eqIndex, 2) = load(dtFile);
    
    fprintf('eqNumber = %i, dtFileContent = %s \n', eqNumber, load(dtFile));
    
    eqDetails(eqIndex, 3) = load(NPtFile);
    eqDetails(eqIndex, 4) = eqDetails(eqIndex, 2) * (eqDetails(eqIndex, 3) - 1);

%     groundMotionDetail{eqNumber}.eqNumber = eqNumber;
%     groundMotionDetail{eqNumber}.dt = load(dtFile);
%     groundMotionDetail{eqNumber}.NumPt = load(NPtFile);
%     groundMotionDetail{eqNumber}.duration = load(dtFile) * (load(NPtFile) - 1);
%     groundMotionDetail{eqNumber}.timeHistory = load(gmFile);
end

outpFilename = 'eqDetailsForSetMumCS_bldgs3040X.mat';
save(outpFilename, 'eqDetails');
disp(['File saved as ', fullfile(pwd, outpFilename)]);

cd(baseFolder)

% clearvars -except eqDetails         
        
    case '5d.extractEqDetailsGM_2211_Del22'
%% 20×2 ground motion suites for bldg IDs- 3040, 3042, 3044, 3045, 3047, respectively.
eqNumberConditionalSpectra_2211 = [
6001631	6001632	6002221	6002222	6003671	6003672	6004101	6004102	6004141	6004142	6004191	6004192	6004591	6004592	6004991	6004992	6005231	6005232	6006491	6006492	6007511	6007512	6008141	6008142	6010121	6010122	6010281	6010282	6010481	6010482	6011591	6011592	6012561	6012562	6013991	6013992	6022351	6022352	6024081	6024082	6032061	6032062	6032791	6032792 ...
6001731	6001732	6002481	6002482	6002651	6002652	6002901	6002902	6004061	6004062	6004151	6004152	6004581	6004582	6005641	6005642	6005891	6005892	6007511	6007512	6007891	6007892	6008091	6008092	6009681	6009682	6009871	6009872	6010121	6010122	6010191	6010192	6010301	6010302	6010481	6010482	6010851	6010852	6011491	6011492	6016111	6016112	6023951	6023952 ...
6000341	6000342	6001831	6001832	6003141	6003142	6004091	6004092	6004191	6004192	6004991	6004992	6005301	6005302	6006391	6006392	6007691	6007692	6009081	6009082	6009701	6009702	6009711	6009712	6009871	6009872	6010121	6010122	6010301	6010302	6012571	6012572	6016111	6016112	6017361	6017362	6023951	6023952	6029501	6029502	6032061	6032062	6032861	6032862 ...
6000311	6000312	6001601	6001602	6001831	6001832	6002121	6002122	6002851	6002852	6003411	6003412	6003521	6003522	6004081	6004082	6004091	6004092	6004571	6004572	6004581	6004582	6004611	6004612	6006331	6006332	6006921	6006922	6007861	6007862	6009521	6009522	6009681	6009682	6009871	6009872	6011351	6011352	6014361	6014362	6023951	6023952	6026271	6026272 ...
];

% all downloaded ground motions
eqLIST = eqNumberConditionalSpectra_2211;

cd C:\OpenSeesProcessingFiles\EQs

totNumOfEQs = length(eqLIST);
eqDetails = zeros(totNumOfEQs, 4); % First col is for eqNumber, second for dt, third for NPts and forth for duration of EQ.
for eqIndex = 1:totNumOfEQs
    eqNumber = eqLIST(eqIndex);
    NPtFile = sprintf('NumPointsFile_(%i).txt', eqNumber);
%     currentNPt = load(NPtFile);
    dtFile = sprintf('DtFile_(%i).txt', eqNumber);
    gmFile = sprintf('SortedEQFile_(%i).txt', eqNumber);
    
    eqDetails(eqIndex, 1) = eqNumber;
    eqDetails(eqIndex, 2) = load(dtFile);
    
    fprintf('eqNumber = %i, dtFileContent = %s \n', eqNumber, load(dtFile));
    
    eqDetails(eqIndex, 3) = load(NPtFile);
    eqDetails(eqIndex, 4) = eqDetails(eqIndex, 2) * (eqDetails(eqIndex, 3) - 1);

%     groundMotionDetail{eqNumber}.eqNumber = eqNumber;
%     groundMotionDetail{eqNumber}.dt = load(dtFile);
%     groundMotionDetail{eqNumber}.NumPt = load(NPtFile);
%     groundMotionDetail{eqNumber}.duration = load(dtFile) * (load(NPtFile) - 1);
%     groundMotionDetail{eqNumber}.timeHistory = load(gmFile);
end

outpFilename = 'eqDetailsForSetDelCS_bldgs2211.mat';
save(outpFilename, 'eqDetails');
disp(['File saved as ', fullfile(pwd, outpFilename)]);

cd(baseFolder)

% clearvars -except eqDetails         
        
    case '6.extractTimePeriodsForAllEQ'
%%
cd H:\PrakRuns\Output\(CivilBldg_3story_ID9901_v.02_trying)_(AllVar)_(0.00)_(clough);

eqNumberLIST_forProcessing_SetC = [120111, 120112, 120121, 120122,	120411, 120412,	120521, 120522,	120611, 120612,	120621, 120622,	120711, 120712,	120721, 120722,	120811, 120812,	120821, 120822,	120911, 120912,	120921, 120922,	121011, 121012,	121021, 121022,	121111, 121112,	121211, 121212,	121221, 121222,	121321, 121322,	121411, 121412,	121421, 121422,	121511, 121512,	121711, 121712];

 axisNumberFontSize = 16; xAxisLabelFontSize = 20; yAxisLabelFontSize = 20; legendFontSize = 16;
 titleFontSize = 20;


%% step 1- extract the valid spectral acceleration folders list for each EQ. Save Sa values in the process.
for i = 1:length(eqNumberLIST_forProcessing_SetC)
    currentFolder = ['EQ_', num2str(eqNumberLIST_forProcessing_SetC(i))];
    cd(currentFolder)
   
    filesLIST = dir();     % Get a list of all files and folders in this folder.
    dirFlags = [filesLIST.isdir];     % Get a logical vector that tells which is a directory.
    foldersLIST = filesLIST(dirFlags);     % Extract only those that are directories.

    % Use folder names to list eigenvalues from each Sa folder of each
    % earthquake. Also store Sa values using filenames.
    for k = 3 : length(foldersLIST)
%     	fprintf('Sub folder #%d = %s\n', k, foldersLIST(k).name);
        currentFolder = foldersLIST(k).name; 

        cd(currentFolder)
        cd 'RunInformation'
        EqListWithEigVal(i, (k-2)).eigValList = load('eigenvaluesAfterEQOUT.out');
        cd ..
        cd ..
        
    % extract the list of spectral accelerations
        currSa = str2double(currentFolder(4:end)); % initial 3 letters are Sa_
        saList(i, (k-2)) = currSa;
    end
    
    cd ..
end

%% step 2- Save sensible (which are not spurious) time periods after EQ for each Sa, for each EQ.
timePeriodAfterEqLIST = zeros(size(EqListWithEigVal));
for i = 1 : size(EqListWithEigVal, 1)
    for j = 1 : size(EqListWithEigVal, 2)
        currEigValList = EqListWithEigVal(i, j).eigValList;
        if(isempty(currEigValList) == 0)
            % eigen values less than or equal to 2.5 are spurious, they give time period of more than 4 seconds
            % value of 2.5 is chosen somewhat based on results. One of the data points is more than 4 sec. 
            currEigVal = min(currEigValList(currEigValList > 2.5));      % find minimum "good" eigenvalue
            % [i j] = find(A==min(A(A>1))); % can be used to find index of the minimum saught for number
            timePeriodAfterEqLIST(i, j) = 2 * pi / sqrt(currEigVal);
        end
    end
end
    

%% step 3- plot the time periods against Sa values for required number of earthquakes
figure(10)
for i = 1:length(eqNumberLIST_forProcessing_SetC)
    currSaList = saList(i, :);
    currentTimePeriodList = timePeriodAfterEqLIST(i, :);
    plot(currSaList(currSaList > 0), currentTimePeriodList(currentTimePeriodList > 0)); hold on; grid on;
    if i == 36
        plot(currSaList(currSaList > 0), currentTimePeriodList(currentTimePeriodList > 0), 'r-', 'LineWidth', 2);
    end
end
    grid on;
    
    str1 = '$S_a (T_1,$ undamaged structure) $[g] \rightarrow$'; 
    str2 = 'Time period $[sec] \rightarrow$';
    str3 = 'Effect of damage on time period';
    
    hx = xlabel(str1, 'Interpreter', 'latex');    hy = ylabel(str2, 'Interpreter', 'latex');
    htitle = title(str3);
%     h_legend = legend(strForLegend);    
    
    set(hx, 'FontSize', xAxisLabelFontSize); set(hy, 'FontSize', yAxisLabelFontSize);
    set(gca, 'FontSize', axisNumberFontSize); 
    set(htitle, 'FontSize', titleFontSize);
%     set(h_legend,'FontSize', legendFontSize, 'Location', 'southeast');
        
    disp(['plot is saved here: ' pwd ]);% here is where the plot is saved

    exportName = sprintf('TimePeriodVsSa.eps');
%          print('-dmeta', exportName);   
         print('-depsc', exportName)

    case '6a.extractTimePeriodsForAllBldgs'
%%
% cd H:\PrakRuns\Output\(CivilBldg_3story_ID9901_v.02_trying)_(AllVar)_(0.00)_(clough);
% cd J:\Output
% cd I:\PrakRuns_I\Output
cd K:\Output

% eqNumberLIST_forProcessing_SetC = [120111, 120112, 120121, 120122,	120411, 120412,	120521, 120522,	120611, 120612,	120621, 120622,	120711, 120712,	120721, 120722,	120811, 120812,	120821, 120822,	120911, 120912,	120921, 120922,	121011, 121012,	121021, 121022,	121111, 121112,	121211, 121212,	121221, 121222,	121321, 121322,	121411, 121412,	121421, 121422,	121511, 121512,	121711, 121712];
% bldgIdLIST = [2205	2207	2209	2211	2213	2215	2217	2219	2221	2223	2225	2227	2229	2231	2233	2235	2237	2433	2435	2437	2439	2441	2443	2445	2447];
% bldgIdLIST = [30401 30402 30421 30422 30441 30442 30451 30452 30471 30472];
bldgIdLIST = [2207	2209	2211	2213	2451	2453	2215	2217	2219	2221	2433	2435	2223	2457	2459	2461	2463	2225	2227	2437	2439	2229	2231	2441	2443	2233	2235	2445	2447	2237];

% outpFolderLIST = {'(ID2205_R5_4Story_v.02)_(AllVar)_(0.00)_(clough)'
%             '(ID2207_R5_7Story_v.07)_(AllVar)_(0.00)_(clough)'
%             '(ID2209_R5_12Story_v.04)_(AllVar)_(0.00)_(clough)'
%             '(ID2211_R5_2Story_v.02)_(AllVar)_(0.00)_(clough)'
%             '(ID2213_R5_4Story_v.03)_(AllVar)_(0.00)_(clough)'
%             '(ID2215_R5_12Story_v.02)_(AllVar)_(0.00)_(clough)'
%             '(ID2217_R5_12Story_v.02)_(AllVar)_(0.00)_(clough)'
%             '(ID2219_R5_2Story_v.02)_(AllVar)_(0.00)_(clough)'
%             '(ID2221_R5_4Story_v.05)_(AllVar)_(0.00)_(clough)'
%             '(ID2223_R5_7Story_v.02)_(AllVar)_(0.00)_(clough)'
%             '(ID2225_R5_12Story_v.02)_(AllVar)_(0.00)_(clough)'
%             '(ID2227_R5_4Story_v.04)_(AllVar)_(0.00)_(clough)'
%             '(ID2229_R5_7Story_v.02)_(AllVar)_(0.00)_(clough)'
%             '(ID2231_R5_4Story_v.02)_(AllVar)_(0.00)_(clough)'
%             '(ID2233_R5_7Story_v.02)_(AllVar)_(0.00)_(clough)'
%             '(ID2235_R5_4Story_v.02)_(AllVar)_(0.00)_(clough)'
%             '(ID2237_R5_7Story_v.02)_(AllVar)_(0.00)_(clough)'
%             '(ID2433_R5_5Story_v.01)_(AllVar)_(0.00)_(clough)'
%             '(ID2435_R5_6Story_v.01)_(AllVar)_(0.00)_(clough)'
%             '(ID2437_R5_5Story_v.01)_(AllVar)_(0.00)_(clough)'
%             '(ID2439_R5_6Story_v.01)_(AllVar)_(0.00)_(clough)'
%             '(ID2441_R5_5Story_v.01)_(AllVar)_(0.00)_(clough)'
%             '(ID2443_R5_6Story_v.01)_(AllVar)_(0.00)_(clough)'
%             '(ID2445_R5_5Story_v.01)_(AllVar)_(0.00)_(clough)'
%             '(ID2447_R5_6Story_v.01)_(AllVar)_(0.00)_(clough)'};
% outpFolderLIST = {'(ID3040_R0_4Story_v.02)_(AllVar)_(0.00)_(clough)'
%             '(ID3042_R0_4Story_v.02)_(AllVar)_(0.00)_(clough)'
%             '(ID3044_R0_4Story_v.02)_(AllVar)_(0.00)_(clough)'
%             '(ID3045_R0_4Story_v.02)_(AllVar)_(0.00)_(clough)'
%             '(ID30471_XZ_R0_4Story_v.02)_(AllVar)_(0.00)_(clough)'
%             '(ID30472_YZ_R0_4Story_v.02)_(AllVar)_(0.00)_(clough)'};
%         
% outpFolderLIST = {'(ID30401_XZ_R0_4Story_v.02)_(AllVar)_(0.00)_(clough)'
%                 '(ID30402_YZ_R0_4Story_v.02)_(AllVar)_(0.00)_(clough)'
%                 '(ID30421_XZ_R0_4Story_v.02)_(AllVar)_(0.00)_(clough)'
%                 '(ID30422_YZ_R0_4Story_v.02)_(AllVar)_(0.00)_(clough)'
%                 '(ID30441_XZ_R0_4Story_v.02)_(AllVar)_(0.00)_(clough)'
%                 '(ID30442_YZ_R0_4Story_v.02)_(AllVar)_(0.00)_(clough)'
%                 '(ID30451_XZ_R0_4Story_v.02)_(AllVar)_(0.00)_(clough)'
%                 '(ID30452_YZ_R0_4Story_v.02)_(AllVar)_(0.00)_(clough)'
%                 '(ID30471_XZ_R0_4Story_v.02)_(AllVar)_(0.00)_(clough)'
%                 '(ID30472_YZ_R0_4Story_v.02)_(AllVar)_(0.00)_(clough)'};

outpFolderLIST = {'(ID2207_R5_7Story_v.09)_(AllVar)_(0.00)_(clough)'
    '(ID2209_R5_12Story_v.05)_(AllVar)_(0.00)_(clough)'
    '(ID2211_R5_2Story_v.03)_(AllVar)_(0.00)_(clough)'
    '(ID2213_R5_4Story_v.04)_(AllVar)_(0.00)_(clough)'
    '(ID2451_R5_5Story_v.02)_(AllVar)_(0.00)_(clough)'
    '(ID2453_R5_6Story_v.02)_(AllVar)_(0.00)_(clough)'
    '(ID2215_R5_7Story_v.03)_(AllVar)_(0.00)_(clough)'
    '(ID2217_R5_12Story_v.03)_(AllVar)_(0.00)_(clough)'
    '(ID2219_R5_2Story_v.03)_(AllVar)_(0.00)_(clough)'
    '(ID2221_R5_4Story_v.06)_(AllVar)_(0.00)_(clough)'
    '(ID2433_R5_5Story_v.02)_(AllVar)_(0.00)_(clough)'
    '(ID2435_R5_6Story_v.02)_(AllVar)_(0.00)_(clough)' 
    '(ID2223_R5_7Story_v.03)_(AllVar)_(0.00)_(clough)'
    '(ID2457_R5_8Story_v.01)_(AllVar)_(0.00)_(clough)'
    '(ID2459_R5_9Story_v.01)_(AllVar)_(0.00)_(clough)'
    '(ID2461_R5_10Story_v.01)_(AllVar)_(0.00)_(clough)'
    '(ID2463_R5_11Story_v.01)_(AllVar)_(0.00)_(clough)'
    '(ID2225_R5_12Story_v.03)_(AllVar)_(0.00)_(clough)'
    '(ID2227_R5_4Story_v.05)_(AllVar)_(0.00)_(clough)'
    '(ID2437_R5_5Story_v.02)_(AllVar)_(0.00)_(clough)'
    '(ID2439_R5_6Story_v.02)_(AllVar)_(0.00)_(clough)'
    '(ID2229_R5_7Story_v.03)_(AllVar)_(0.00)_(clough)'
    '(ID2231_R5_4Story_v.04)_(AllVar)_(0.00)_(clough)'
    '(ID2441_R5_5Story_v.02)_(AllVar)_(0.00)_(clough)'
    '(ID2443_R5_6Story_v.02)_(AllVar)_(0.00)_(clough)'
    '(ID2233_R5_7Story_v.03)_(AllVar)_(0.00)_(clough)'
    '(ID2235_R5_4Story_v.04)_(AllVar)_(0.00)_(clough)'
    '(ID2445_R5_5Story_v.02)_(AllVar)_(0.00)_(clough)'
    '(ID2447_R5_6Story_v.02a)_(AllVar)_(0.00)_(clough)'
    '(ID2237_R5_7Story_v.03a)_(AllVar)_(0.00)_(clough)'
    };


 for i = 1:length(outpFolderLIST)
    currentFolder = outpFolderLIST{i};
    cd(currentFolder) 
    cd 'MatlabInformation'
    eigenValLIST(i, :) = load('eigenvaluesOUT.out');
    cd ..
    cd ..
 end
 
 timeP1LIST = zeros(length(outpFolderLIST), 1);
 timeP2LIST = timeP1LIST; timeP3LIST = timeP1LIST; timeP4LIST = timeP1LIST; timeP5LIST = timeP1LIST;
 for i = 1:length(outpFolderLIST)
     currEigValLIST = eigenValLIST(i, :);
% remove the spurious eigenvalues that are less than 0.5, they correspond to timeP of more than 8.9 sec.
     currEigValLIST(1:find(currEigValLIST < 0.5, 1, 'last' )) = [];
     timeP1LIST(i, 1) = 2 * pi / sqrt(currEigValLIST(1));
     timeP2LIST(i, 1) = 2 * pi / sqrt(currEigValLIST(2));
     timeP3LIST(i, 1) = 2 * pi / sqrt(currEigValLIST(3));
     timeP4LIST(i, 1) = 2 * pi / sqrt(currEigValLIST(4));
     timeP5LIST(i, 1) = 2 * pi / sqrt(currEigValLIST(5));
 end

T(:, 1:6) = table(bldgIdLIST', timeP1LIST, timeP2LIST, timeP3LIST, timeP4LIST, timeP5LIST);
T.Properties.VariableNames{1} = sprintf('bldgID'); %_%i', seedVal);
T.Properties.VariableNames{2} = sprintf('timeP1'); %runT_%i', seedVal);
T.Properties.VariableNames{3} = sprintf('timeP2'); %runT_%i', seedVal);
T.Properties.VariableNames{4} = sprintf('timeP3'); %runT_%i', seedVal);
T.Properties.VariableNames{5} = sprintf('timeP4'); %runT_%i', seedVal);
T.Properties.VariableNames{6} = sprintf('timeP5'); %runT_%i', seedVal);
disp(T);
         
    
    case '6b.extractTimePOneBldg_QUICK'
%%
cd C:\BRB_local\Output\
outpFolderLIST = {'(BRB_18story_v8)_(AllVar)_(0.00)_(clough)'};
bldgIdLIST = [6210]; % IDs only to print, not used in this program
 for i = 1:length(outpFolderLIST)
    currentFolder = outpFolderLIST{i};
    cd(currentFolder) 
    cd 'MatlabInformation'
    eigenValLIST(i, :) = load('eigenvaluesOUT.out');
    cd ..
    cd ..
 end
 
 timeP1LIST = zeros(length(outpFolderLIST), 1);
 timeP2LIST = timeP1LIST; timeP3LIST = timeP1LIST; timeP4LIST = timeP1LIST; timeP5LIST = timeP1LIST;
 for i = 1:length(outpFolderLIST)
     currEigValLIST = eigenValLIST(i, :);
% remove the spurious eigenvalues that are less than 0.5, they correspond to timeP of more than 8.9 sec.
%      currEigValLIST(1:find(currEigValLIST < 0.5, 1, 'last' )) = [];
     currEigValLIST(currEigValLIST < 0.5) = [];
     timeP1LIST(i, 1) = 2 * pi / sqrt(currEigValLIST(1));
     timeP2LIST(i, 1) = 2 * pi / sqrt(currEigValLIST(2));
     timeP3LIST(i, 1) = 2 * pi / sqrt(currEigValLIST(3));
     timeP4LIST(i, 1) = 2 * pi / sqrt(currEigValLIST(4));
%      timeP5LIST(i, 1) = 2 * pi / sqrt(currEigValLIST(5));
 end

T(:, 1:6) = table(bldgIdLIST', timeP1LIST, timeP2LIST, timeP3LIST, timeP4LIST, timeP5LIST);
T.Properties.VariableNames{1} = sprintf('bldgID'); %_%i', seedVal);
T.Properties.VariableNames{2} = sprintf('timeP1'); %runT_%i', seedVal);
T.Properties.VariableNames{3} = sprintf('timeP2'); %runT_%i', seedVal);
T.Properties.VariableNames{4} = sprintf('timeP3'); %runT_%i', seedVal);
T.Properties.VariableNames{5} = sprintf('timeP4'); %runT_%i', seedVal);
% T.Properties.VariableNames{6} = sprintf('timeP5'); %runT_%i', seedVal);
disp(T);    
    case '7.extractResponseSpectra'
%%
eqNumberLIST_forProcessing_SetC = [120111, 120112, 120121, 120122,	120411, 120412,	120521, 120522,	120611, 120612,	120621, 120622,	120711, 120712,	120721, 120722,	120811, 120812,	120821, 120822,	120911, 120912,	120921, 120922,	121011, 121012,	121021, 121022,	121111, 121112,	121211, 121212,	121221, 121222,	121321, 121322,	121411, 121412,	121421, 121422,	121511, 121512,	121711, 121712];
eqNumberLIST_forProcessing_SetD = [120111	120112	120121	120122	120131	120132	120141	120142	120151	120152	120161	120162	120411	120412	120521	120522	120611	120612	120621	120622	120631	120632	120641	120642	120711	120712	120721	120722	120731	120732	120741	120742	120811	120812	120821	120822	120911	120912	120921	120922	120931	120932	121011	121012	121021	121022	121031	121032	121041	121042	121051	121052	121061	121062	121111	121112	121211	121212	121221	121222	121231	121232	121321	121322	121411	121412	121421	121422	121431	121432	121441	121442	121451	121452	121461	121462	121511	121512	121711	121712];
   eqLIST = eqNumberLIST_forProcessing_SetC;
   dampRat = 0.05;
   plotDomainLogLog = 1; % 0- linear domain, 1- log log domain
%    plotPercentiles = [0.16, 0.84];
   plotPercentiles = [0.05, 0.95];

   
cd C:\OpenSeesProcessingFiles\EQ_Spectra_Saved

totNumOfEQs = length(eqLIST);

eqDetails = zeros(totNumOfEQs, 4); %First col is for eqNumber, second for dt, third for NPts and forth for duration of EQ.

for eqIndex = 1:totNumOfEQs
    eqNumber = eqLIST(eqIndex);
    respSpecFile = sprintf('SaEQSpectrum_EQ_%i.mat', eqNumber);
    load(respSpecFile, 'dampRatioLIST', 'periodVector', 'SaAbs');

    dampRatIndex = find(dampRatioLIST == dampRat);
    
    groundMotionDetails{eqIndex}.eqNumber = eqNumber;
    groundMotionDetails{eqIndex}.periodVector = periodVector;
    groundMotionDetails{eqIndex}.SaList = SaAbs(:, dampRatIndex);
    
%     plot(periodVector, SaAbs(:, dampRatIndex), 'k-', 'LineWidth', 0.5); grid on; hold on;
    if plotDomainLogLog == 0
        plot(periodVector, SaAbs(:, dampRatIndex), '-', 'color', [0.5 0.5 0.5], 'LineWidth', 1); hold on; grid on; box on; 
    elseif plotDomainLogLog == 1
        loglog(periodVector, SaAbs(:, dampRatIndex), '-', 'color', [0.5 0.5 0.5], 'LineWidth', 1); hold on; grid on; box on;
    end
end

lenPeriodVector = length(groundMotionDetails{1}.periodVector); % choosing first periodVector for plotting fractiles.
saList = zeros(lenPeriodVector, totNumOfEQs);

    for periodIndex = 1:lenPeriodVector 
        currentPeriod = groundMotionDetails{1}.periodVector(periodIndex);
        for eqIndex = 1:totNumOfEQs
            currenEqPeriodList = groundMotionDetails{eqIndex}.periodVector;
            currenSaList = groundMotionDetails{eqIndex}.SaList;
            saList(periodIndex, eqIndex) = interp1(currenEqPeriodList, currenSaList, currentPeriod);
        end
    end

if plotDomainLogLog == 0
    fractileSaList1 = quantile(saList, 0.50, 2);
    h1 = plot(groundMotionDetails{1}.periodVector, fractileSaList1, 'r-', 'LineWidth', 3);

    fractileSaList2 = quantile(saList, plotPercentiles(1), 2);
    h2 = plot(groundMotionDetails{1}.periodVector, fractileSaList2, 'r--', 'LineWidth', 3);

    fractileSaList3 = quantile(saList, plotPercentiles(2), 2);
    h3 = plot(groundMotionDetails{1}.periodVector, fractileSaList3, 'r--', 'LineWidth', 3);

%     fractileSaList4 = quantile(saList, 0.97725, 2);
%     h4 = plot(groundMotionDetails{1}.periodVector, fractileSaList4, 'r-.', 'LineWidth', 3);
    
elseif plotDomainLogLog == 1
    fractileSaList1 = quantile(saList, 0.50, 2);
    h1 = loglog(groundMotionDetails{1}.periodVector, fractileSaList1, 'r-', 'LineWidth', 3);

    fractileSaList2 = quantile(saList, plotPercentiles(1), 2);
    h2 = loglog(groundMotionDetails{1}.periodVector, fractileSaList2, 'r--', 'LineWidth', 3);

    fractileSaList3 = quantile(saList, plotPercentiles(2), 2);
    h3 = loglog(groundMotionDetails{1}.periodVector, fractileSaList3, 'r--', 'LineWidth', 3);

%     fractileSaList4 = quantile(saList, 0.97725, 2);
%     h4 = loglog(groundMotionDetails{1}.periodVector, fractileSaList4, 'r-.', 'LineWidth', 3);
end

    % For sigma function, second input; 0- normalized by (n - 1), 1- normalized by n.
    % third input is for dimension of the matrix

%     h4 = plot(groundMotionDetails{1}.periodVector, mean(saList, 2) + 1.96 * std(saList, 0, 2), 'b--', 'LineWidth', 3);

%     strForLegend = { 'Median'
%                     '\pm 1 \sigma'};
%                     %' 97.5%ile'};

    strForLegend = { 'Median'
                    '5 and 95 %ile'};

% 	axisNumberFontSize = 16; xAxisLabelFontSize = 20; yAxisLabelFontSize = 20; 
% 	legendFontSize = 16; titleFontSize = 20;

    hx = xlabel('Time period (sec)');
    hy = ylabel('S_a (g)'); 
    htitle = title('Pseudo Acceleration Response Spectra');
    
%     legh = legend([h1, h2], strForLegend);    
    legh = legend([h1, h2], strForLegend);    
    psb_FigureFormatScript
%     FigureFormatScript
    
%     hx = xlabel(str1, 'Interpreter', 'latex'); hy = ylabel(str2, 'Interpreter', 'latex');
%     htitle = title(str3); 
%     h_legend = legend([h1, h2], strForLegend);    

%     h_legend = legend([h1, h2, h4], strForLegend);    
    
%     set(hx, 'FontSize', xAxisLabelFontSize); set(hy, 'FontSize', yAxisLabelFontSize);
%     set(htitle, 'FontSize', titleFontSize);
%     set(h_legend,'FontSize', legendFontSize, 'Location', 'northeast');

%     set(gca, 'FontSize', axisNumberFontSize); 
    xlim([0.05 10]); ylim([0.01 4]);
    
% cd H:\PrakRuns\Output
cd H:\GM_FEMAP695
   exportName = sprintf('responseSpectrumFarFiledFEMAP695_5_95_Loglog');
   hgsave(exportName); % .fig file for Matlab
   print('-depsc', exportName); % .eps file for Linux (LaTeX)
   print('-dmeta', exportName); % .emf file for Windows (MSWORD)
   print('-dpng', exportName); % .png file for small sized files
    
    
disp(['Plot saved as- ' fullfile(pwd, exportName)]);

    case '7a.extractResponseSpectraWithScaledIS1893'
%%
eqNumberLIST_forProcessing_SetC = [120111, 120112, 120121, 120122,	120411, 120412,	120521, 120522,	120611, 120612,	120621, 120622,	120711, 120712,	120721, 120722,	120811, 120812,	120821, 120822,	120911, 120912,	120921, 120922,	121011, 121012,	121021, 121022,	121111, 121112,	121211, 121212,	121221, 121222,	121321, 121322,	121411, 121412,	121421, 121422,	121511, 121512,	121711, 121712];
eqNumberLIST_forProcessing_SetD = [120111	120112	120121	120122	120131	120132	120141	120142	120151	120152	120161	120162	120411	120412	120521	120522	120611	120612	120621	120622	120631	120632	120641	120642	120711	120712	120721	120722	120731	120732	120741	120742	120811	120812	120821	120822	120911	120912	120921	120922	120931	120932	121011	121012	121021	121022	121031	121032	121041	121042	121051	121052	121061	121062	121111	121112	121211	121212	121221	121222	121231	121232	121321	121322	121411	121412	121421	121422	121431	121432	121441	121442	121451	121452	121461	121462	121511	121512	121711	121712];
   eqLIST = eqNumberLIST_forProcessing_SetC;
   dampRat = 0.05;
   plotDomainLogLog = 0; % 0- linear domain, 1- log log domain
   plotPercentiles = [0.05, 0.95];
%    plotPercentiles = [0.05, 0.95];
    Tmatch = 1;
   
cd C:\OpenSeesProcessingFiles\EQ_Spectra_Saved

totNumOfEQs = length(eqLIST);

eqDetails = zeros(totNumOfEQs, 4); %First col is for eqNumber, second for dt, third for NPts and forth for duration of EQ.

for eqIndex = 1:totNumOfEQs
    eqNumber = eqLIST(eqIndex);
    respSpecFile = sprintf('SaEQSpectrum_EQ_%i.mat', eqNumber);
    load(respSpecFile, 'dampRatioLIST', 'periodVector', 'SaAbs');

    dampRatIndex = find(dampRatioLIST == dampRat);
    
    groundMotionDetails{eqIndex}.eqNumber = eqNumber;
    groundMotionDetails{eqIndex}.periodVector = periodVector;
    groundMotionDetails{eqIndex}.SaList = SaAbs(:, dampRatIndex);
    
%     plot(periodVector, SaAbs(:, dampRatIndex), 'k-', 'LineWidth', 0.5); grid on; hold on;
    if plotDomainLogLog == 0
        plot(periodVector, SaAbs(:, dampRatIndex), '-', 'color', [0.5 0.5 0.5], 'LineWidth', 1); hold on; grid on; box on; 
    elseif plotDomainLogLog == 1
        loglog(periodVector, SaAbs(:, dampRatIndex), '-', 'color', [0.5 0.5 0.5], 'LineWidth', 1); hold on; grid on; box on;
    end
end

lenPeriodVector = length(groundMotionDetails{1}.periodVector); % choosing first periodVector for plotting fractiles.
saList = zeros(lenPeriodVector, totNumOfEQs);

    for periodIndex = 1:lenPeriodVector 
        currentPeriod = groundMotionDetails{1}.periodVector(periodIndex);
        for eqIndex = 1:totNumOfEQs
            currenEqPeriodList = groundMotionDetails{eqIndex}.periodVector;
            currenSaList = groundMotionDetails{eqIndex}.SaList;
            saList(periodIndex, eqIndex) = interp1(currenEqPeriodList, currenSaList, currentPeriod);
        end
    end

if plotDomainLogLog == 0
    fractileSaList1 = quantile(saList, 0.50, 2);
    h1 = plot(groundMotionDetails{1}.periodVector, fractileSaList1, 'r-', 'LineWidth', 3);

    fractileSaList2 = quantile(saList, plotPercentiles(1), 2);
    h2 = plot(groundMotionDetails{1}.periodVector, fractileSaList2, 'r--', 'LineWidth', 3);

    fractileSaList3 = quantile(saList, plotPercentiles(2), 2);
    h3 = plot(groundMotionDetails{1}.periodVector, fractileSaList3, 'r--', 'LineWidth', 3);

%     fractileSaList4 = quantile(saList, 0.97725, 2);
%     h4 = plot(groundMotionDetails{1}.periodVector, fractileSaList4, 'r-.', 'LineWidth', 3);
    
elseif plotDomainLogLog == 1
    fractileSaList1 = quantile(saList, 0.50, 2);
    h1 = loglog(groundMotionDetails{1}.periodVector, fractileSaList1, 'r-', 'LineWidth', 3);

    fractileSaList2 = quantile(saList, plotPercentiles(1), 2);
    h2 = loglog(groundMotionDetails{1}.periodVector, fractileSaList2, 'r--', 'LineWidth', 3);

    fractileSaList3 = quantile(saList, plotPercentiles(2), 2);
    h3 = loglog(groundMotionDetails{1}.periodVector, fractileSaList3, 'r--', 'LineWidth', 3);

%     fractileSaList4 = quantile(saList, 0.97725, 2);
%     h4 = loglog(groundMotionDetails{1}.periodVector, fractileSaList4, 'r-.', 'LineWidth', 3);
end

    % For sigma function, second input; 0- normalized by (n - 1), 1- normalized by n.
    % third input is for dimension of the matrix

%     h4 = plot(groundMotionDetails{1}.periodVector, mean(saList, 2) + 1.96 * std(saList, 0, 2), 'b--', 'LineWidth', 3);

%     strForLegend = { 'Median'
%                     '\pm 1 \sigma'};
%                     %' 97.5%ile'};

%     strForLegend = { 'Median'
%                     '5 and 95 %ile'};

% 	axisNumberFontSize = 16; xAxisLabelFontSize = 20; yAxisLabelFontSize = 20; 
% 	legendFontSize = 16; titleFontSize = 20;

    hx = xlabel('Period (sec)');
    hy = ylabel('Spectral Acceleration (g)'); 
%     htitle = title('Pseudo Acceleration Response Spectra');
    
%     legh = legend([h1, h2], strForLegend);    
%     legh = legend([h1, h2], strForLegend);    

%     psb_FigureFormatScript
%     FigureFormatScript
    
%     hx = xlabel(str1, 'Interpreter', 'latex'); hy = ylabel(str2, 'Interpreter', 'latex');
%     htitle = title(str3); 
%     h_legend = legend([h1, h2], strForLegend);    

%     h_legend = legend([h1, h2, h4], strForLegend);    
    
%     set(hx, 'FontSize', xAxisLabelFontSize); set(hy, 'FontSize', yAxisLabelFontSize);
%     set(htitle, 'FontSize', titleFontSize);
%     set(h_legend,'FontSize', legendFontSize, 'Location', 'northeast');

%     set(gca, 'FontSize', axisNumberFontSize); 
    
    
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%    
%%% Now, we plot IS 1893 response spectra scaled at certain period, Tmatch %%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    timeP = 0.05:0.01:10;
    sa1893Unscaled = zeros(size(timeP));
    sa1893Unscaled(1:6) = 1 + 15*timeP(1:6);
    sa1893Unscaled(7:36) = 2.5;
    sa1893Unscaled(37:end) = 1./timeP(37:end);
    
    sa1893UnscaledAtTmatch = interp1(timeP, sa1893Unscaled, Tmatch, 'pchip');
    
% median value of 22x2 FF ground motion at matching period
    saMedianFFAtTmatch = interp1(groundMotionDetails{1}.periodVector, fractileSaList1, Tmatch, 'pchip');
    
% scale UHS such that it matches with median of 22x2 FF ground motion at matching period    
    scalingForSa = saMedianFFAtTmatch / sa1893UnscaledAtTmatch; % sa1893Unscaled(96) = 1.0 sec
    scaledCodalHazard = sa1893Unscaled * scalingForSa;

if plotDomainLogLog == 0   
    xlim([0 4]); ylim([0 2.5]);
    h4 = plot(timeP, scaledCodalHazard, 'b-', 'LineWidth', 3);
    exportName = sprintf('responseSpectrumFarFiledFEMAP695_%i_%i_Linear_1893_1sec', plotPercentiles(1)*100, plotPercentiles(2)*100);
elseif plotDomainLogLog == 1
    xlim([0.05 4]); ylim([0.01 4]);
    h4 = loglog(timeP, scaledCodalHazard, 'b-', 'LineWidth', 3);
    exportName = sprintf('responseSpectrumFarFiledFEMAP695_%i_%i_Loglog_1893_1sec', plotPercentiles(1)*100, plotPercentiles(2)*100);
end
    strForLegend = { 'Median'
                    '5 and 95 percentile'
                    'IS 1893 (part 1)'};
       legh = legend([h1, h2, h4], strForLegend);   
%  psb_FigureFormatScript
psb_FigureFormatScript_forReport
set(gca,'fontname','times')
    
% cd H:\PrakRuns\Output
cd H:\GM_FEMAP695
%    exportName = 'responseSpectrumFarFiledFEMAP695_5_95_Loglog_1893_1sec';
%    exportName = sprintf('resSpecFF_FEMAP695_%i_%i_Loglog_1893_1sec', plotPercentiles(1)*100, plotPercentiles(2)*100);
   exportName = sprintf('resSpecFF_FEMAP695_%i_%i_Linear_1893_1sec_v3', plotPercentiles(1)*100, plotPercentiles(2)*100);
   hgsave(exportName); % .fig file for Matlab
   print('-depsc', exportName); % .eps file for Linux (LaTeX)
   print('-dmeta', exportName); % .emf file for Windows (MSWORD)
   print('-dpng', exportName); % .png file for small sized files
   print('-djpeg', exportName); % .jpeg file for small sized files
   print('-djpeg', [exportName '_r300'], '-r300');
    
    
disp(['Plot saved as- ' fullfile(pwd, exportName)]);

    case '7a1.extractResponseSpectraWithScaledSiteSpecificUHSDelhiOrGuwahati'
%%
eqNumberLIST_forProcessing_SetC = [120111, 120112, 120121, 120122,	120411, 120412,	120521, 120522,	120611, 120612,	120621, 120622,	120711, 120712,	120721, 120722,	120811, 120812,	120821, 120822,	120911, 120912,	120921, 120922,	121011, 121012,	121021, 121022,	121111, 121112,	121211, 121212,	121221, 121222,	121321, 121322,	121411, 121412,	121421, 121422,	121511, 121512,	121711, 121712];
eqNumberLIST_forProcessing_SetD = [120111	120112	120121	120122	120131	120132	120141	120142	120151	120152	120161	120162	120411	120412	120521	120522	120611	120612	120621	120622	120631	120632	120641	120642	120711	120712	120721	120722	120731	120732	120741	120742	120811	120812	120821	120822	120911	120912	120921	120922	120931	120932	121011	121012	121021	121022	121031	121032	121041	121042	121051	121052	121061	121062	121111	121112	121211	121212	121221	121222	121231	121232	121321	121322	121411	121412	121421	121422	121431	121432	121441	121442	121451	121452	121461	121462	121511	121512	121711	121712];
   eqLIST = eqNumberLIST_forProcessing_SetC;
   dampRat = 0.05;
   plotDomainLogLog = 0; % 0- linear domain, 1- log log domain
   plotPercentiles = [0.05, 0.95];
%    plotPercentiles = [0.05, 0.95];

% Data for the UHS of a specific site (this UHS will be further scaled to match at the matching period, Tmatch) 
%     latLon = [28.62   77.22]; locName = 'Delhi'; % locName used for filename only
%     latLon = [26.17   91.77]; locName = 'Guwahati'; % locName used for filename only
    latLonLIST = [28.62   77.22;   % Delhi 
              26.17   91.77];  % Guwahati
    locName = {'Delhi', 'Guwahati'}; % locName used for filename only
    
    Tr = 475; Tmatch = 1.35;
    doPlot = 0; plotType = 'linear'; locationLIST = []; % these are fixed inputs for extracting UHS from cd 'H:\UniformRiskMap\Input from Raghukanth'

cd C:\OpenSeesProcessingFiles\EQ_Spectra_Saved

totNumOfEQs = length(eqLIST);

eqDetails = zeros(totNumOfEQs, 4); %First col is for eqNumber, second for dt, third for NPts and forth for duration of EQ.
figure()
for eqIndex = 1:totNumOfEQs
    eqNumber = eqLIST(eqIndex);
    respSpecFile = sprintf('SaEQSpectrum_EQ_%i.mat', eqNumber);
    load(respSpecFile, 'dampRatioLIST', 'periodVector', 'SaAbs');

    dampRatIndex = find(dampRatioLIST == dampRat);
    
    groundMotionDetails{eqIndex}.eqNumber = eqNumber;
    groundMotionDetails{eqIndex}.periodVector = periodVector;
    groundMotionDetails{eqIndex}.SaList = SaAbs(:, dampRatIndex);
    
%     plot(periodVector, SaAbs(:, dampRatIndex), 'k-', 'LineWidth', 0.5); grid on; hold on;
    if plotDomainLogLog == 0
        h(1) = plot(periodVector, SaAbs(:, dampRatIndex), '-', 'color', [0.4 0.8 0.2], 'LineWidth', 0.8); hold on; grid on; box on; 
    elseif plotDomainLogLog == 1
        h(1) = loglog(periodVector, SaAbs(:, dampRatIndex), '-', 'color', [0.4 0.8 0.2], 'LineWidth', 0.8); hold on; grid on; box on;
    end
end

lenPeriodVector = length(groundMotionDetails{1}.periodVector); % choosing first periodVector for plotting fractiles.
saList = zeros(lenPeriodVector, totNumOfEQs);

    for periodIndex = 1:lenPeriodVector 
        currentPeriod = groundMotionDetails{1}.periodVector(periodIndex);
        for eqIndex = 1:totNumOfEQs
            currenEqPeriodList = groundMotionDetails{eqIndex}.periodVector;
            currenSaList = groundMotionDetails{eqIndex}.SaList;
            saList(periodIndex, eqIndex) = interp1(currenEqPeriodList, currenSaList, currentPeriod);
        end
    end

if plotDomainLogLog == 0
    fractileSaList1 = quantile(saList, 0.50, 2);
    h(2) = plot(groundMotionDetails{1}.periodVector, fractileSaList1, 'k-', 'LineWidth', 2);
elseif plotDomainLogLog == 1
    fractileSaList1 = quantile(saList, 0.50, 2);
    h(2) = loglog(groundMotionDetails{1}.periodVector, fractileSaList1, 'k-', 'LineWidth', 2);
end
    fractileSaList2 = quantile(saList, plotPercentiles(1), 2);
    h(3) = plot(groundMotionDetails{1}.periodVector, fractileSaList2, 'k--', 'LineWidth', 2);

    fractileSaList3 = quantile(saList, plotPercentiles(2), 2);
    h(4) = plot(groundMotionDetails{1}.periodVector, fractileSaList3, 'k--', 'LineWidth', 2);

%     fractileSaList4 = quantile(saList, 0.97725, 2);
%     h(5) = plot(groundMotionDetails{1}.periodVector, fractileSaList4, 'k-.', 'LineWidth', 2);

% 	axisNumberFontSize = 16; xAxisLabelFontSize = 20; yAxisLabelFontSize = 20; 
% 	legendFontSize = 16; titleFontSize = 20;

    hx = xlabel('Period (sec)');
    hy = ylabel('Spectral Acceleration (g)'); 
    
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%    
%%% Now, we plot site-specific UHS scaled at a certain time period %%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% giving location- and matching time period-specific inputs at the top now.   
%     latLon = [28.62   77.22]; % Delhi
% %     latLon = [26.17   91.77]; % Guwahati
% 	Tr = 475; doPlot = 0; plotType = 'linear'; locationLIST = [];
%     
    
% median value of 22x2 FF ground motion at matching period
    saMedianFFAtTmatch = interp1(groundMotionDetails{1}.periodVector, fractileSaList1, Tmatch, 'pchip');

    strForLegend = {'Individual records'
                    'Median'
                    '5 and 95 percentile'}; % legend for 22x2 median and \pm eps; further legends assigned inside the loop
    
    locConcat = ''; % initialize concatenated city list for figure name
    color = {'r', 'b', 'm'};
    lineStyle = {'-.', ':'};
    cd 'H:\UniformRiskMap\Input from Raghukanth'
    for j = 1:size(latLonLIST, 1)
        latLon = latLonLIST(j, :);
        [T1UHS, SaUHS] = returnUHSForASite_v1(latLon, Tr, doPlot, plotType, locationLIST);
        saSiteUHSAtTmatch = interp1(T1UHS, SaUHS, Tmatch, 'pchip');
        
        % scale UHS such that it matches with median of 22x2 FF ground motion at matching period
        scalingForSa = saMedianFFAtTmatch / saSiteUHSAtTmatch;
        scaledSaUHS = SaUHS * scalingForSa;
        h(4+j) = plot(T1UHS, scaledSaUHS, lineStyle{1, j}, 'color', color{1, j}, 'LineWidth', 2);
        
        if plotDomainLogLog == 0
            xlim([0.3 2]); ylim([0 2.5]);
        elseif plotDomainLogLog == 1
            xlim([0.2 2]); ylim([0.05 2.5]);
        end
        strForLegend{3 + j, 1} = sprintf('%s (%iy)', locName{1, j}, Tr);
        locConcat = [locConcat, locName{1, j}(1:3)]; % concatenate first three letters of the city name for figure name
    end
    if plotDomainLogLog == 1; legLoc = 'southwest'; else; legLoc = 'northeast'; end
    legh = legend(h([1, 2, 3, 5:4+size(latLonLIST, 1)]), strForLegend, 'Location', legLoc); % basically, NO SOUP FOR YOU, h(4). 
    
    %  psb_FigureFormatScript
    psb_FigureFormatScript_forReport
    set(gca,'fontname','times')
    
% cd H:\PrakRuns\Output
cd H:\GM_FEMAP695

   exportName = sprintf('resSpecFF_FEMAP695_%i_%i_Lin_%s_%iyRP_%ip%isec_v1', plotPercentiles(1)*100, plotPercentiles(2)*100, locConcat, Tr, floor(Tmatch), int8(mod(Tmatch*100, 100)));
%  exportName = sprintf('resSpecFF_FEMAP695_%i_%i_Log_%s_%iyRP_%ip%isec_v1', plotPercentiles(1)*100, plotPercentiles(2)*100, locConcat, Tr, floor(Tmatch), int8(mod(Tmatch*100, 100)));
   hgsave(exportName); % .fig file for Matlab
   print('-depsc', exportName); % .eps file for Linux (LaTeX)
   print('-dmeta', exportName); % .emf file for Windows (MSWORD)
   print('-dpng', exportName); % .png file for small sized files
   print('-djpeg', exportName); % .jpeg file for small sized files
   print('-djpeg', [exportName '_r300'], '-r300');
%     
%     
% disp(['Plot saved as- ' fullfile(pwd, exportName)]);

    case '7a2.extractResponseSpectraWithScaledSiteSpecificUHS_CMSDelhiOrGuwahati'
%%
eqNumberLIST_forProcessing_SetC = [120111, 120112, 120121, 120122,	120411, 120412,	120521, 120522,	120611, 120612,	120621, 120622,	120711, 120712,	120721, 120722,	120811, 120812,	120821, 120822,	120911, 120912,	120921, 120922,	121011, 121012,	121021, 121022,	121111, 121112,	121211, 121212,	121221, 121222,	121321, 121322,	121411, 121412,	121421, 121422,	121511, 121512,	121711, 121712];
eqNumberLIST_forProcessing_SetD = [120111	120112	120121	120122	120131	120132	120141	120142	120151	120152	120161	120162	120411	120412	120521	120522	120611	120612	120621	120622	120631	120632	120641	120642	120711	120712	120721	120722	120731	120732	120741	120742	120811	120812	120821	120822	120911	120912	120921	120922	120931	120932	121011	121012	121021	121022	121031	121032	121041	121042	121051	121052	121061	121062	121111	121112	121211	121212	121221	121222	121231	121232	121321	121322	121411	121412	121421	121422	121431	121432	121441	121442	121451	121452	121461	121462	121511	121512	121711	121712];
   eqLIST = eqNumberLIST_forProcessing_SetC;
   dampRat = 0.05;
   plotDomainLogLog = 0; % 0- linear domain, 1- log log domain
   plotPercentiles = [0.05, 0.95];
%    plotPercentiles = [0.05, 0.95];

% Data for the UHS of a specific site (this UHS will be further scaled to match at the matching period, Tmatch) 
%     latLon = [28.62   77.22]; locName = 'Delhi'; % locName used for filename only
%     latLon = [26.17   91.77]; locName = 'Guwahati'; % locName used for filename only
    latLonLIST = [28.62   77.22;   % Delhi 
              26.17   91.77];  % Guwahati
    locName = {'Delhi', 'Guwahati'}; % locName used for filename only
    
    Tr = 475; Tmatch = 1.35;
    doPlot = 0; plotType = 'linear'; locationLIST = []; % these are fixed inputs for extracting UHS from cd 'H:\UniformRiskMap\Input from Raghukanth'

cd C:\OpenSeesProcessingFiles\EQ_Spectra_Saved

totNumOfEQs = length(eqLIST);

eqDetails = zeros(totNumOfEQs, 4); %First col is for eqNumber, second for dt, third for NPts and forth for duration of EQ.
figure()
for eqIndex = 1:totNumOfEQs
    eqNumber = eqLIST(eqIndex);
    respSpecFile = sprintf('SaEQSpectrum_EQ_%i.mat', eqNumber);
    load(respSpecFile, 'dampRatioLIST', 'periodVector', 'SaAbs');

    dampRatIndex = find(dampRatioLIST == dampRat);
    
    groundMotionDetails{eqIndex}.eqNumber = eqNumber;
    groundMotionDetails{eqIndex}.periodVector = periodVector;
    groundMotionDetails{eqIndex}.SaList = SaAbs(:, dampRatIndex);
    
%     plot(periodVector, SaAbs(:, dampRatIndex), 'k-', 'LineWidth', 0.5); grid on; hold on;
    if plotDomainLogLog == 0
        h(1) = plot(periodVector, SaAbs(:, dampRatIndex), '-', 'color', [0.4 0.8 0.2], 'LineWidth', 0.8); hold on; grid on; box on; 
    elseif plotDomainLogLog == 1
        h(1) = loglog(periodVector, SaAbs(:, dampRatIndex), '-', 'color', [0.4 0.8 0.2], 'LineWidth', 0.8); hold on; grid on; box on;
    end
end

lenPeriodVector = length(groundMotionDetails{1}.periodVector); % choosing first periodVector for plotting fractiles.
saList = zeros(lenPeriodVector, totNumOfEQs);

    for periodIndex = 1:lenPeriodVector 
        currentPeriod = groundMotionDetails{1}.periodVector(periodIndex);
        for eqIndex = 1:totNumOfEQs
            currenEqPeriodList = groundMotionDetails{eqIndex}.periodVector;
            currenSaList = groundMotionDetails{eqIndex}.SaList;
            saList(periodIndex, eqIndex) = interp1(currenEqPeriodList, currenSaList, currentPeriod);
        end
    end

if plotDomainLogLog == 0
    fractileSaList1 = quantile(saList, 0.50, 2);
    h(2) = plot(groundMotionDetails{1}.periodVector, fractileSaList1, 'k-', 'LineWidth', 2);
elseif plotDomainLogLog == 1
    fractileSaList1 = quantile(saList, 0.50, 2);
    h(2) = loglog(groundMotionDetails{1}.periodVector, fractileSaList1, 'k-', 'LineWidth', 2);
end
    fractileSaList2 = quantile(saList, plotPercentiles(1), 2);
    h(3) = plot(groundMotionDetails{1}.periodVector, fractileSaList2, 'k--', 'LineWidth', 2);

    fractileSaList3 = quantile(saList, plotPercentiles(2), 2);
    h(4) = plot(groundMotionDetails{1}.periodVector, fractileSaList3, 'k--', 'LineWidth', 2);

%     fractileSaList4 = quantile(saList, 0.97725, 2);
%     h(5) = plot(groundMotionDetails{1}.periodVector, fractileSaList4, 'k-.', 'LineWidth', 2);

% 	axisNumberFontSize = 16; xAxisLabelFontSize = 20; yAxisLabelFontSize = 20; 
% 	legendFontSize = 16; titleFontSize = 20;

    hx = xlabel('Period (sec)');
    hy = ylabel('Spectral Acceleration (g)'); 
    
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%    
%%% Now, we plot site-specific UHS scaled at a certain time period %%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% giving location- and matching time period-specific inputs at the top now.   
%     latLon = [28.62   77.22]; % Delhi
% %     latLon = [26.17   91.77]; % Guwahati
% 	Tr = 475; doPlot = 0; plotType = 'linear'; locationLIST = [];
%     
    
% median value of 22x2 FF ground motion at matching period
    saMedianFFAtTmatch = interp1(groundMotionDetails{1}.periodVector, fractileSaList1, Tmatch, 'pchip');

    strForLegend = {'Individual records'
                    'Median'
                    '5 and 95 percentile'}; % legend for 22x2 median and \pm eps; further legends assigned inside the loop
    
    case '7a3.extractResponseSpectraWithScaledVancouverResponseSpectrum'
%%
eqNumberLIST_forProcessing_SetC = [120111, 120112, 120121, 120122,	120411, 120412,	120521, 120522,	120611, 120612,	120621, 120622,	120711, 120712,	120721, 120722,	120811, 120812,	120821, 120822,	120911, 120912,	120921, 120922,	121011, 121012,	121021, 121022,	121111, 121112,	121211, 121212,	121221, 121222,	121321, 121322,	121411, 121412,	121421, 121422,	121511, 121512,	121711, 121712];
eqNumberLIST_forProcessing_SetG = [8201811	8201812	8201821	8201822	8202921	8202922	8207231	8207232	8208021	8208022	8208211	8208212	8208281	8208282	8208791	8208792	8210631	8210632	8210861	8210862	8211651	8211652	8215031	8215032	8215291	8215292	8216051	8216052	8201261	8201262	8201601	8201602	8201651	8201652	8204951	8204952	8204961	8204962	8207411	8207412	8207531	8207532	8208251	8208252	8210041	8210042	8210481	8210482	8211761	8211762	8215041	8215042	8215171	8215172	8221141	8221142];
eqNumberLIST_forProcessing_SetD = [120111	120112	120121	120122	120131	120132	120141	120142	120151	120152	120161	120162	120411	120412	120521	120522	120611	120612	120621	120622	120631	120632	120641	120642	120711	120712	120721	120722	120731	120732	120741	120742	120811	120812	120821	120822	120911	120912	120921	120922	120931	120932	121011	121012	121021	121022	121031	121032	121041	121042	121051	121052	121061	121062	121111	121112	121211	121212	121221	121222	121231	121232	121321	121322	121411	121412	121421	121422	121431	121432	121441	121442	121451	121452	121461	121462	121511	121512	121711	121712];

eqLIST = eqNumberLIST_forProcessing_SetC;
GMSuiteName = 'FF'; % SetC- 'FF', SetG- 'NF', SetD- 'FFExt';
dampRat = 0.05;
plotDomainLogLog = 0; % 0- linear domain, 1- log log domain, 2- semilogy
plotType = 'linear'; % 'linear', 'loglog', 'semilogy', 'semilogx'

plotPercentiles = [0.05, 0.95];
%    plotPercentiles = [0.05, 0.95];
Tmatch = 1;
   
cd C:\OpenSeesProcessingFiles\EQ_Spectra_Saved

totNumOfEQs = length(eqLIST);

eqDetails = zeros(totNumOfEQs, 4); %First col is for eqNumber, second for dt, third for NPts and forth for duration of EQ.

for eqIndex = 1:totNumOfEQs
    eqNumber = eqLIST(eqIndex);
    respSpecFile = sprintf('SaEQSpectrum_EQ_%i.mat', eqNumber);
    load(respSpecFile, 'dampRatioLIST', 'periodVector', 'SaAbs');

    dampRatIndex = find(dampRatioLIST == dampRat);
    
    groundMotionDetails{eqIndex}.eqNumber = eqNumber;
    groundMotionDetails{eqIndex}.periodVector = periodVector;
    groundMotionDetails{eqIndex}.SaList = SaAbs(:, dampRatIndex);
    
%     plot(periodVector, SaAbs(:, dampRatIndex), 'k-', 'LineWidth', 0.5); grid on; hold on;
    plot(periodVector, SaAbs(:, dampRatIndex), '-', 'color', [0.5 0.5 0.5], 'LineWidth', 1); hold on; grid on; box on; 
    ax = gca;
    switch plotType
        case 'loglog'  ; ax.XScale = 'log'; ax.YScale = 'log'; hold on;
        case 'semilogy' ; ax.XScale = 'linear'; ax.YScale = 'log'; hold on;
        case 'semilogx' ; ax.XScale = 'log'; ax.YScale = 'linear'; hold on;
    end

end

lenPeriodVector = length(groundMotionDetails{1}.periodVector); % choosing first periodVector for plotting fractiles.
saList = zeros(lenPeriodVector, totNumOfEQs);

    for periodIndex = 1:lenPeriodVector 
        currentPeriod = groundMotionDetails{1}.periodVector(periodIndex);
        for eqIndex = 1:totNumOfEQs
            currenEqPeriodList = groundMotionDetails{eqIndex}.periodVector;
            currenSaList = groundMotionDetails{eqIndex}.SaList;
            saList(periodIndex, eqIndex) = interp1(currenEqPeriodList, currenSaList, currentPeriod);
        end
    end

fractileSaList1 = quantile(saList, 0.50, 2);
h1 = plot(groundMotionDetails{1}.periodVector, fractileSaList1, 'r-', 'LineWidth', 3);

fractileSaList2 = quantile(saList, plotPercentiles(1), 2);
h2 = plot(groundMotionDetails{1}.periodVector, fractileSaList2, 'r--', 'LineWidth', 3);

fractileSaList3 = quantile(saList, plotPercentiles(2), 2);
h3 = plot(groundMotionDetails{1}.periodVector, fractileSaList3, 'r--', 'LineWidth', 3);
    
ax = gca;
switch plotType
    case 'loglog'  ; ax.XScale = 'log'; ax.YScale = 'log'; hold on;
    case 'semilogy' ; ax.XScale = 'linear'; ax.YScale = 'log'; hold on;
    case 'semilogx' ; ax.XScale = 'log'; ax.YScale = 'linear'; hold on;
end

hx = xlabel('Period (sec)');
hy = ylabel('Spectral Acceleration (g)');
    
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%    
%%% Now, we plot IS 1893 response spectra scaled at certain period, Tmatch %%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    timeP = 0.05:0.01:10;
    sa1893Unscaled = zeros(size(timeP));
    sa1893Unscaled(1:6) = 1 + 15*timeP(1:6);
    sa1893Unscaled(7:36) = 2.5;
    sa1893Unscaled(37:end) = 1./timeP(37:end);
    
    sa1893UnscaledAtTmatch = interp1(timeP, sa1893Unscaled, Tmatch, 'pchip');
    
% median value of 22x2 FF ground motion at matching period
    saMedianFFAtTmatch = interp1(groundMotionDetails{1}.periodVector, fractileSaList1, Tmatch, 'pchip');
    
% scale UHS such that it matches with median of 22x2 FF ground motion at matching period    
    scalingForSa = saMedianFFAtTmatch / sa1893UnscaledAtTmatch; % sa1893Unscaled(96) = 1.0 sec
    scaledCodalHazard = sa1893Unscaled * scalingForSa;
    
    
    h4 = plot(timeP, scaledCodalHazard, 'b-', 'LineWidth', 3);
    xlim([0.05 4]); ylim([0.01 4]);
    ax = gca;
    switch plotType
        case 'loglog'  ; ax.XScale = 'log'; ax.YScale = 'log'; hold on;
        case 'semilogy' ; ax.XScale = 'linear'; ax.YScale = 'log'; hold on;
        case 'semilogx' ; ax.XScale = 'log'; ax.YScale = 'linear'; hold on;
    end
    strForLegend = { 'Median'
                    '5 and 95 percentile'
                    'NBCC (2020)'};
       legh = legend([h1, h2, h4], strForLegend);   
%  psb_FigureFormatScript
psb_FigureFormatScript_forReport
set(gca,'fontname','times')
    
% cd H:\PrakRuns\Output
cd H:\GM_FEMAP695
%    exportName = 'responseSpectrumFarFiledFEMAP695_5_95_Loglog_1893_1sec';
%    exportName = sprintf('resSpecFF_FEMAP695_%i_%i_Loglog_1893_1sec', plotPercentiles(1)*100, plotPercentiles(2)*100);
   exportName = sprintf('resSpec_%s_FEMAP695_%i_%i_%s_NBCC2020_%ip%isec', GMSuiteName, plotPercentiles(1)*100, plotPercentiles(2)*100, plotType, floor(Tmatch), int8(mod(Tmatch*100, 100)));
   hgsave(exportName); % .fig file for Matlab
   print('-depsc', exportName); % .eps file for Linux (LaTeX)
   print('-dmeta', exportName); % .emf file for Windows (MSWORD)
   print('-dpng', exportName); % .png file for small sized files
   print('-djpeg', exportName); % .jpeg file for small sized files
   print('-djpeg', [exportName '_r300'], '-r300');
    
fprintf('Plot saved as- %s', fullfile(pwd, exportName));


%% extract and plot UHS                
%     locConcat = ''; % initialize concatenated city list for figure name
%     color = {'r', 'b', 'm'};
%     lineStyle = {'-.', ':'};
%     cd 'H:\UniformRiskMap\Input from Raghukanth'
%     for j = 1:size(latLonLIST, 1)
%         latLon = latLonLIST(j, :);
%         
%         
% %% extract and plot UHS and CMS
%     M_bar = 7; Rjb_bar = 15; % deaggregation
%     Vs30 = 760; % rock site
%     faultType = 'Strike-slip';
%     GMPM = 'BA08'; % 'BJF97' 'AS97' 'BA08' 'C97' 'ABS96' 'RI07' (for epsilon calculation) step-2 options 
%     [T1UHS, SaUHS, T1CMS, SaCMS] = returnCMSForASite_v1(latLon, Tr, Tmatch, M_bar, Rjb_bar, Vs30, faultType, GMPM);
% %         [T1UHS, SaUHS] = returnUHSForASite_v1(latLon, Tr, doPlot, plotType, locationLIST);
% 
%         saSiteUHSAtTmatch = interp1(T1UHS, SaUHS, Tmatch, 'pchip');
%         
%         % scale "UHS" such that it matches with median of 22x2 FF ground motion at matching period
%         scalingForSa = saMedianFFAtTmatch / saSiteUHSAtTmatch;
%         scaledSaUHS = SaUHS * scalingForSa;
%         h(3+2*j) = plot(T1UHS, scaledSaUHS, lineStyle{1, 1}, 'color', color{1, j}, 'LineWidth', 2);
% 
%         % scale "CMS" such that it matches with median of 22x2 FF ground motion at matching period
%         scaledSaCMS = SaCMS * scalingForSa;
%         h(4+2*j) = plot(T1CMS, scaledSaCMS, lineStyle{1, 2}, 'color', color{1, j}, 'LineWidth', 2);
%         
%         if plotDomainLogLog == 0
%             xlim([0.3 2]); ylim([0 2.5]);
%         elseif plotDomainLogLog == 1
%             xlim([0.2 2]); ylim([0.05 2.5]);
%         end
%         strForLegend{2 + 2*j, 1} = sprintf('%s UHS (%iy)', locName{1, j}, Tr); % one legend omitted due to +-
%         strForLegend{3 + 2*j, 1} = sprintf('%s CMS (%iy)', locName{1, j}, Tr); % one legend omitted due to +-
%         
%         locConcat = [locConcat, locName{1, j}(1:3)]; % concatenate first three letters of the city name for figure name
%     end
%     switch plotType
%         case 'loglog'  ; legLoc = 'southwest'; else; legLoc = 'northeast'; 
%     end
%     legh = legend(h([1, 2, 3, 5:4+2*size(latLonLIST, 1)]), strForLegend, 'Location', legLoc); % basically, NO SOUP FOR YOU, h(4). 
%     
%     %  psb_FigureFormatScript
%     psb_FigureFormatScript_forReport
%     set(gca,'fontname','times')
    
% cd H:\GM_FEMAP695
% 
%    exportName = sprintf('resSpecFF_FEMAP695_%i_%i_Lin_%s_%iyRP_UHSCMS_%ip%isec_v1', plotPercentiles(1)*100, plotPercentiles(2)*100, locConcat, Tr, floor(Tmatch), int8(mod(Tmatch*100, 100)));
% %  exportName = sprintf('resSpecFF_FEMAP695_%i_%i_Log_%s_%iyRP_%ip%isec_v1', plotPercentiles(1)*100, plotPercentiles(2)*100, locConcat, Tr, floor(Tmatch), int8(mod(Tmatch*100, 100)));
%    hgsave(exportName); % .fig file for Matlab
%    print('-depsc', exportName); % .eps file for Linux (LaTeX)
%    print('-dmeta', exportName); % .emf file for Windows (MSWORD)
%    print('-dpng', exportName); % .png file for small sized files
%    print('-djpeg', exportName); % .jpeg file for small sized files
%    print('-djpeg', [exportName '_r300'], '-r300');
% %     
% fprintf('Plot saved as- %s', fullfile(pwd, exportName));

    case '7b.extractSaValForVariousEQs'
%%
eqNumberLIST_forCollapseIDAs_SetC = [12011	12012	12041	12052	12061	12062	12071	12072	12081	12082	12091	12092	12101	12102	12111	12121	12122	12132	12141	12142	12151	12171];
eqNumberLIST_forCollapseIDAs_SetD = [12011	12012	12013	12014	12015	12016	12041	12052	12061	12062	12063	12064	12071	12072	12073	12074	12081	12082	12091	12092	12093	12101	12102	12103	12104	12105	12106	12111	12121	12122	12123	12132	12141	12142	12143	12144	12145	12146	12151	12171];

   eqLIST = eqNumberLIST_forCollapseIDAs_SetC;
   dampRat = 0.05;
   timeP = 0.50;
cd C:\OpenSeesProcessingFiles\EQ_Spectra_Saved

totNumOfEQs = length(eqLIST);

eqDetails = zeros(totNumOfEQs, 4); %First col is for eqNumber, second is SaVal in direction 1, third is SaVal in direction 2, forth is geoMean of Sa1 and Sa2

for eqIndex = 1:totNumOfEQs
    eqNum = eqLIST(eqIndex);
    
% find the first SaValue
    eqNumComp1 = eqLIST(eqIndex) * 10 + 1;
    respSpecFile = sprintf('SaEQSpectrum_EQ_%i.mat', eqNumComp1);
    load(respSpecFile, 'dampRatioLIST', 'periodVector', 'SaAbs');
    
%     dampRatIndex1 = find(dampRatioLIST == dampRat);
    dampRatIndex1 = find(abs(dampRatioLIST == dampRat) < 1e-5);
    timePIndex1 = find(abs(periodVector - timeP) < 1e-4);
    SaVal1 = SaAbs(timePIndex1, dampRatIndex1);
    
% find the second SaValue
    eqNumComp2 = eqLIST(eqIndex) * 10 + 2;
    respSpecFile = sprintf('SaEQSpectrum_EQ_%i.mat', eqNumComp2);
    load(respSpecFile, 'dampRatioLIST', 'periodVector', 'SaAbs');
    
%     dampRatIndex2 = find(dampRatioLIST == dampRat);
    dampRatIndex2 = find(abs(dampRatioLIST == dampRat) < 1e-5);
    timePIndex2 = find(abs(periodVector - timeP) < 1e-4);
    SaVal2 = SaAbs(timePIndex2, dampRatIndex2);
    
    SaGeoMean = sqrt(SaVal1 * SaVal2);
    eqDetails(eqIndex, 1) = eqNum;
    eqDetails(eqIndex, 2) = SaVal1;
    eqDetails(eqIndex, 3) = SaVal2;
    eqDetails(eqIndex, 4) = SaGeoMean;
    
    fprintf('# sqrt(%.4f * %.4f) = %.3f EQ %i and %i (for T = %.2f sec) \n', SaVal1, SaVal2, SaGeoMean, eqNumComp1, eqNumComp2, timeP);
end

    case '7c.plotUHS_CMS_WithGMPM'
%%
   baseFolder = pwd;
   eqComponent = 120911;
   dampRat = 0.05;
   eqNumber = fix(eqComponent/10);
   
   GMPE = 'AS_1997_horiz';
%    GMPE = 'BJF_1997_horiz';
   conditioningTimeP = 1.32; % conditionaing time period

 
   cd C:\OpenSeesProcessingFiles\EQ_Spectra_Saved
    respSpecFile = sprintf('SaEQSpectrum_EQ_%i.mat', eqComponent);
    load(respSpecFile, 'dampRatioLIST', 'periodVector', 'SaAbs');
    dampRatIndex = find(dampRatioLIST == dampRat);
    saList = SaAbs(:, dampRatIndex);
    
   cd C:\OpenSeesProcessingFiles\EQs
    load('eqEvent_Site_Record_Info.mat', 'campbellDistLIST', 'closestDistFaultRuptureLIST', 'epicentralDistLIST', ...
        'eqNumberLIST', 'eventLIST', 'faultTypeLIST', 'JBDistLIST', 'magnitudeLIST', 'vs30LIST')
    eqNumIndex = find(eqNumberLIST==eqNumber); % find the index

    campbellDist = campbellDistLIST(eqNumIndex);
    closestDistFaultRupture = closestDistFaultRuptureLIST(eqNumIndex);
    epicentralDist = epicentralDistLIST(eqNumIndex);
    eventName = eventLIST(eqNumIndex);
    faultType = faultTypeLIST(eqNumIndex);
    JBDist = JBDistLIST(eqNumIndex);
    magnitude = magnitudeLIST(eqNumIndex);
    vs30 = vs30LIST(eqNumIndex);

    cd(baseFolder)

% plot the actual response spectrum
    h1 = plot(periodVector, saList, 'b-', 'LineWidth', 3); hold on; grid on;
        
    if (strcmp(GMPE, 'BJF_1997_horiz'))
         periodVectorNEW = periodVector(periodVector <= 2);
         periodVectorNEW = periodVectorNEW(periodVectorNEW >= 0.001); % limits of time-period on GMPE

         saPredicted = zeros(1, length(periodVectorNEW));
         sigmaPredicted = zeros(1, length(periodVectorNEW));

        % Fault_Type    = 1 for strike-slip fault 
        %               = 2 for reverse-slip fault
        %               = 0 for non-specified mechanism        
        if(strcmp(faultType, 'Strike-slip'))
            Fault_Type = 1;
        elseif(strcmp(faultType, 'Thrust'))
            Fault_Type = 2;
        else
            Fault_Type = 0;
        end
        
        for periodIndex = 1:length(periodVectorNEW)
            [saPredicted(periodIndex), sigmaPredicted(periodIndex)] = BJF_1997_horiz(magnitude, JBDist, periodVectorNEW(periodIndex), Fault_Type, vs30, 0);
        end

%         strForLegend = {'Actual Response Spectrum' 
        
        strForLegend = {'temp'
                'BJF 1997 Median Spectrum'
                'Predicted Median \pm 1 \sigma'
                'Predicted Median \pm 2 \sigma'};
        strForLegend{1} = [eventName{1} ' Resp Spectrum'];
        
    elseif (strcmp(GMPE, 'AS_1997_horiz'))
         periodVectorNEW = periodVector(periodVector <= 5);
         periodVectorNEW = periodVectorNEW(periodVectorNEW >= 0.01); % limits of time-period on GMPE

         saPredicted = zeros(1, length(periodVectorNEW));
         sigmaPredicted = zeros(1, length(periodVectorNEW));
        
        %   is_soil         = 1 for soil prediction
        %                   = 0 for rock
        %   fault_type      = 1 for Reverse
        %                   = 0.5 for reverse/oblique
        %                   = 0 otherwise
        %   HW              = 1 for Hanging Wall sites
        %                   = 0 otherwise        

        
        if (vs30 >= 760)
            is_soil = 0;
        else
            is_soil = 1;
        end
        
        if(strcmp(faultType, 'Thrust'))
            Fault_Type = 1;
        elseif(strcmp(faultType, 'reverse/oblique'))
            Fault_Type = 0.5;
        else
            Fault_Type = 0;
        end    
        
        HW = 0;
        
        for periodIndex = 1:length(periodVectorNEW)
            [saPredicted(periodIndex), sigmaPredicted(periodIndex)] = AS_1997_horiz(magnitude, closestDistFaultRupture, periodVectorNEW(periodIndex), is_soil, Fault_Type, HW, 0);
        end        
        
        strForLegend = {'temp'
                'AS97 Median Spectrum'
                'Predicted Median \pm 1 \sigma'
                'Predicted Median \pm 1.5 \sigma'};
        strForLegend{1} = [eventName{1} ' Resp Spectrum'];                
                
    else
        
    end
    

    
% plot the predicted response spectrum
    h2 = plot(periodVectorNEW, saPredicted, 'r-', 'LineWidth', 3);
% plot the predicted response spectrum + 1 * sigma
    h3 = plot(periodVectorNEW, exp(log(saPredicted) + 1 * sigmaPredicted), 'r--', 'LineWidth', 3);
% plot the predicted response spectrum - 1 * sigma
    h4 = plot(periodVectorNEW, exp(log(saPredicted) - 1 * sigmaPredicted), 'r--', 'LineWidth', 3);
% plot the predicted response spectrum + 2 * sigma
    h5 = plot(periodVectorNEW, exp(log(saPredicted) + 1.5 * sigmaPredicted), 'r-.', 'LineWidth', 3);
% plot the predicted response spectrum - 2 * sigma
    h6 = plot(periodVectorNEW, exp(log(saPredicted) - 1.5 * sigmaPredicted), 'r-.', 'LineWidth', 3);

    
%     fractileSaList3 = quantile(saList, 0.16, 2);
%     h3 = plot(groundMotionDetails{1}.periodVector, fractileSaList3, 'r--', 'LineWidth', 3);

    % For sigma function, second input; 0- normalized by (n - 1), 1- normalized by n.
    % third input is for dimension of the matrix

%     h4 = plot(groundMotionDetails{1}.periodVector, mean(saList, 2) + 1.96 * std(saList, 0, 2), 'b--', 'LineWidth', 3);

% 	axisNumberFontSize = 16; xAxisLabelFontSize = 20; yAxisLabelFontSize = 20; 
% 	legendFontSize = 16; titleFontSize = 20;

    hx = xlabel('Time period (sec)');
    hy = ylabel('S_a (g)'); 
    htitle = title('Pseudo Acceleration Response Spectra');
    
    legh = legend([h1, h2, h3, h5], strForLegend);
    psb_FigureFormatScript
    
%     FigureFormatScript
    
%     hx = xlabel(str1, 'Interpreter', 'latex'); hy = ylabel(str2, 'Interpreter', 'latex');
%     htitle = title(str3); 
%     h_legend = legend([h1, h2], strForLegend);    

%     h_legend = legend([h1, h2, h4], strForLegend);    
    
%     set(hx, 'FontSize', xAxisLabelFontSize); set(hy, 'FontSize', yAxisLabelFontSize);
%     set(htitle, 'FontSize', titleFontSize);
%     set(h_legend,'FontSize', legendFontSize, 'Location', 'northeast');

%     set(gca, 'FontSize', axisNumberFontSize); 
xlim([0 max(periodVectorNEW)]); 
%     xlim([0 3]); 
    ylim([0 1]);
%     ylim([0 2.5]);
    
cd H:\PrakRuns\Output
   exportName = sprintf('responseSpectrumAgainstGMPM');
   hgsave(exportName); % .fig file for Matlab
   print('-depsc', exportName); % .eps file for Linux (LaTeX)
   print('-dmeta', exportName); % .emf file for Windows (MSWORD)


disp(['Plot saved as- ' fullfile(pwd, exportName)]);
% 

%%%% second part - plotting of CMS - starts from here
actualSaVal = interp1(periodVector, saList, conditioningTimeP, 'pchip');
predictedMeanSa = interp1(periodVectorNEW, saPredicted, conditioningTimeP, 'pchip');
predictedSigmaLnSa = interp1(periodVectorNEW, sigmaPredicted, conditioningTimeP, 'pchip');
epsilonValAtConditioningTimeP = (log(actualSaVal) - log(predictedMeanSa)) / predictedSigmaLnSa;
fprintf('At conditioning timeP of %.2f, epsilon Value = %.3f\n', conditioningTimeP, epsilonValAtConditioningTimeP);

% (Log) Response Spectrum Mean: meanReq
rho = zeros(1,length(periodVectorNEW));
cd(baseFolder)
for i = 1:length(periodVectorNEW)
    rho(i) = baker_jayaram_correlation(periodVectorNEW(i), conditioningTimeP);
end
meanCMS = log(saPredicted) + sigmaPredicted .* epsilonValAtConditioningTimeP .* rho;
meanUHS = log(saPredicted) + sigmaPredicted .* epsilonValAtConditioningTimeP;

figure

h11 = plot(periodVectorNEW, saPredicted, 'r-', 'LineWidth', 3); hold on; grid on; % mean AS97 
h12 = plot(periodVector, saList, 'b-', 'LineWidth', 3); % actual Sa
h13 = loglog(periodVectorNEW, exp(meanUHS), 'r--', 'linewidth', 3); % UHS
h14 = loglog(periodVectorNEW, exp(meanCMS), 'm-.', 'linewidth', 3); % CMS

legh = legend('AS97 Median spectrum', 'Landers Response Spectrum', 'Uniform Hazard Spectrum', 'Conditional Mean Spectrum');
xlim([0 max(periodVectorNEW)]); 
% xlim([0 3]); 
ylim([0 1]);

    hx = xlabel('Time period (sec)');
    hy = ylabel('S_a (g)'); 
    htitle = title('Pseudo Acceleration Response Spectra');
    
psb_FigureFormatScript

cd H:\PrakRuns\Output
   exportName = sprintf('CMS_UHS_AgainstGMPM_AS97');
   hgsave(exportName); % .fig file for Matlab
   print('-depsc', exportName); % .eps file for Linux (LaTeX)
   print('-dmeta', exportName); % .emf file for Windows (MSWORD)


disp(['Plot saved as- ' fullfile(pwd, exportName)]);

    case '8.compareOrPlotGroundMotionTH'
%%
eqNumberLIST_forProcessing_SetC = [120111, 120112, 120121, 120122,	120411, 120412,	120521, 120522,	120611, 120612,	120621, 120622,	120711, 120712,	120721, 120722,	120811, 120812,	120821, 120822,	120911, 120912,	120921, 120922,	121011, 121012,	121021, 121022,	121111, 121112,	121211, 121212,	121221, 121222,	121321, 121322,	121411, 121412,	121421, 121422,	121511, 121512,	121711, 121712];

eqNumberLIST = eqNumberLIST_forProcessing_SetC; % [880101];%121411      121412      121421      121422];
strForLegend = {''}; % {'880101'}; %'121411'      '121412'      '121421'      '121422'};

% eqNumberLIST = eqNumberLIST_forProcessing_SetC; %[121422];
doPlotCutOffLine = 0;

C = {'r','b','g','k','y',[.5 .6 .7],[.8 .2 .6]}; % Cell array of 7 colors.
MarkerTypeList={'r-','b--','k-.','g--','y..',[.5 .6 .7],[.8 .2 .6]}; % Cell array of 7 markers.
 % cd EQ folder
 cd C:\OpenSeesProcessingFiles\EQs%\ORIGINAL_TIME_HISTORIES

for eqFileIndex=1:length(eqNumberLIST)
    eqNumber = eqNumberLIST(eqFileIndex);
    eqFolder = sprintf('EQ_%d',eqNumber);

    dt = load(sprintf('DtFile_(%i).txt', eqNumber));
    numPoints = load(sprintf('NumPointsFile_(%i).txt', eqNumber));
    GMTimeHistory = load(sprintf('SortedEQFile_(%i).txt', eqNumber));
    timeArray = 0:dt:dt * (numPoints - 1);

    figure
    
    % plot(timeArray, xDisplArray,'-','color',C{outputFileIndex},'LineWidth',1.0); hold on;
    plot(timeArray, GMTimeHistory, MarkerTypeList{eqFileIndex},'LineWidth',1.0); hold on; grid on;
    hx = xlabel('Time (s)');

    hy = ylabel('Ground Accelration (g) ');
    
%     htitle = title('Time History of Input GM');
    ylim([-0.5 0.5]);
    xlim([0 30]);
    
    if (doPlotCutOffLine == 1)
        plot(timeArray, 0.05 * max(GMTimeHistory) * ones(numPoints, 1), MarkerTypeList{eqFileIndex}, 'LineWidth', 0.5)
    end
    fprintf('PGA for eqNum %i is %5.3f\n', eqNumber, max(GMTimeHistory));
    
    
    legend(strForLegend{eqFileIndex});
    psb_FigureFormatScript
end
    
%     cd H:\PrakRuns\Output
%     exportName = sprintf('GroundMotionTH%s.emf',strForLegend{1});
%     print('-dmeta', exportName);

    case '9.curtailGroundMotionBasedOnPGA'      
%% 
% This saves the files in H:\PrakRuns just to be cautious, I am not pasting these values in final directory.
eqNumberLIST_forProcessing_SetC = [120111, 120112, 120121, 120122,	120411, 120412,	120521, 120522,	120611, 120612,	120621, 120622,	120711, 120712,	120721, 120722,	120811, 120812,	120821, 120822,	120911, 120912,	120921, 120922,	121011, 121012,	121021, 121022,	121111, 121112,	121211, 121212,	121221, 121222,	121321, 121322,	121411, 121412,	121421, 121422,	121511, 121512,	121711, 121712];
eqNumberLIST_forProcessing_SetD = [120111	120112	120121	120122	120131	120132	120141	120142	120151	120152	120161	120162	120411	120412	120521	120522	120611	120612	120621	120622	120631	120632	120641	120642	120711	120712	120721	120722	120731	120732	120741	120742	120811	120812	120821	120822	120911	120912	120921	120922	120931	120932	121011	121012	121021	121022	121031	121032	121041	121042	121051	121052	121061	121062	121111	121112	121211	121212	121221	121222	121231	121232	121321	121322	121411	121412	121421	121422	121431	121432	121441	121442	121451	121452	121461	121462	121511	121512	121711	121712];
%    eqLIST = eqNumberLIST_forProcessing_SetC;
    eqLIST = [880101];
   doPlot = 1; % 1- Plot. 0- don't plot. Use 1, when processing smaller number of EQs

cutOffFraction = 0.05; % this is the fraction of PGA, below which GM would be curtailed from tails (beginning and end)
minCurtailFraction = 0.05; % don't curtail the time history less than this fraction on either side.
                           % this is to avoid unnecessarily modifying time histories without much advantage.
  
MarkerTypeList={'r-','b--','k-.','g--','y..',[.5 .6 .7],[.8 .2 .6],}; % Cell array of 7 markers.
totNumOfEQs = length(eqLIST);
for eqIndex = 1:totNumOfEQs
    GMTimeHistory = []; % initiate everytime
    timeArray = [];
    
    cd C:\OpenSeesProcessingFiles\EQs\ORIGINAL_TIME_HISTORIES
    eqNumber = eqLIST(eqIndex);

    dt = load(sprintf('DtFile_(%i).txt', eqNumber));
    numPoints = load(sprintf('NumPointsFile_(%i).txt', eqNumber));
    GMTimeHistory = load(sprintf('SortedEQFile_(%i).txt', eqNumber));
    timeArray = 0:dt:dt * (numPoints - 1);
    
    cutOffValue = cutOffFraction * max(abs(GMTimeHistory));

    if (doPlot == 1)
        figure(51) % random number to avoid possible conflict, just in case of some other existing figure
        plot(timeArray, GMTimeHistory, MarkerTypeList{eqIndex},'LineWidth',1.0); hold on; grid on;
        xlabel('Time (second) \rightarrow'); ylabel('Ground accelration (g) \rightarrow');
        % plot the cut off line
        plot(timeArray, cutOffValue * ones(length(timeArray), 1), 'k-', 'LineWidth', 1);
    end    

    fprintf('PGA for eqNum %i is %5.3f \n', eqNumber, max(GMTimeHistory));

% find the first time step when acceleration exceeds the cut-off value
    firstTimeIndexOfCurtailedGM = find(abs(GMTimeHistory) > cutOffValue, 1);
        
% find the last time step after which, acceleration does not exceed the cut-off value
    reversedGM = (fliplr(GMTimeHistory'))'; % transpose of left-to-right-flipped-transpose
    lastTimeIndexOfCurtailedGM = numPoints - find(abs(reversedGM) > cutOffValue, 1);

% If initial and final both curtailmenta are too small, don't do it. Continue to the next earthquake
    if ((firstTimeIndexOfCurtailedGM < minCurtailFraction * numPoints) && (lastTimeIndexOfCurtailedGM > (1 - minCurtailFraction) * numPoints))
        fprintf('Possible curtailment is too small on either sides. Hence, is not performed. \n');

        cd H:\PrakRuns
        save(sprintf('SortedEQFile_(%i).txt', eqNumber), 'GMTimeHistory', '-ascii');
        save(sprintf('NumPointsFile_(%i).txt', eqNumber), 'numPoints', '-ascii');
        disp(['Files saved as ', fullfile(pwd, sprintf('SortedEQFile_(%i).txt', eqNumber)), ' and ', sprintf('NumPointsFile_(%i).txt', eqNumber)]);
        fprintf('---------------------------------------------- \n');
        continue
    end
        
% During initial timeperiod, if reduction in GM duration is less than 5%, don't do it.
    if (firstTimeIndexOfCurtailedGM < minCurtailFraction * numPoints)
%         fprintf('First Time Index exceeding the cut-off is %i, this is less than %i (i.e. less than %i%% away from start of GM) \n hence, no curtailement from left side is done! \n', firstTimeIndexOfCurtailedGM, minCurtailFraction * numPoints, minCurtailFraction * 100);
        fprintf('--- No curtailment from Left side is done --- \t');
        firstTimeIndexOfCurtailedGM = 1;
    else
        firstTimeIndexOfCurtailedGM = firstTimeIndexOfCurtailedGM - round(0.01 * numPoints); % include some points even before cut off
        fprintf('--- %i%% curtailment from Left side is done --- \t', round((firstTimeIndexOfCurtailedGM / numPoints) * 100));
    end
    
% During final timeperiod, if reduction in GM duration is less than 5%, don't do it.
    if (lastTimeIndexOfCurtailedGM > (1 - minCurtailFraction) * numPoints)
%         fprintf('Last Time Index exceeding the cut-off is %i, this is more than %i (i.e. less than %i%% away from end of GM) \n hence, no curtailement from right side is done! \n', lastTimeIndexOfCurtailedGM, (1- minCurtailFraction) * numPoints, minCurtailFraction * 100);
        fprintf('--- No curtailment from Right side is done --- \n');
        lastTimeIndexOfCurtailedGM = numPoints;
    else
        lastTimeIndexOfCurtailedGM = lastTimeIndexOfCurtailedGM + round(0.01 * numPoints); % include some points even after cut off
        fprintf('--- %i%% curtailment from Right side is done --- \n', round(100 - (lastTimeIndexOfCurtailedGM / numPoints) * 100));
    end

    curtailedGMTimeHistory = GMTimeHistory(firstTimeIndexOfCurtailedGM:lastTimeIndexOfCurtailedGM);
    curtailedNumPoints = lastTimeIndexOfCurtailedGM - firstTimeIndexOfCurtailedGM + 1;
    curtailedTimeArray = 0:dt:dt * (curtailedNumPoints - 1);
    
    if (doPlot == 1)
        figure(52)
        plot(curtailedTimeArray, curtailedGMTimeHistory, MarkerTypeList{eqIndex},'LineWidth',1.0); hold on; grid on;
        xlabel('Time (second) \rightarrow'); ylabel('Ground accelration (g) \rightarrow');
    end
    
    cd H:\PrakRuns
    save(sprintf('SortedEQFile_(%i).txt', eqNumber), 'curtailedGMTimeHistory', '-ascii');
    save(sprintf('NumPointsFile_(%i).txt', eqNumber), 'curtailedNumPoints', '-ascii');
    disp(['Files saved as ', fullfile(pwd, sprintf('SortedEQFile_(%i).txt', eqNumber)), ' and ', sprintf('NumPointsFile_(%i).txt', eqNumber)]);
    
    curtailmentPercentage(eqIndex) = round((numPoints - curtailedNumPoints)/ numPoints *100);
    fprintf('NumPoints were reduced from %i to %i (%i%% curtailment) \n', numPoints, curtailedNumPoints, curtailmentPercentage(eqIndex));
    fprintf('---------------------------------------------- \n');
   
end

    case '9a.curtailGroundMotionBasedOnPGAForMumbai250'
%% 
% This saves the files in H:\PrakRuns just to be cautious, I am not pasting these values in final directory.
eqNumberLIST_forProcessing_SetC = [120111, 120112, 120121, 120122,	120411, 120412,	120521, 120522,	120611, 120612,	120621, 120622,	120711, 120712,	120721, 120722,	120811, 120812,	120821, 120822,	120911, 120912,	120921, 120922,	121011, 121012,	121021, 121022,	121111, 121112,	121211, 121212,	121221, 121222,	121321, 121322,	121411, 121412,	121421, 121422,	121511, 121512,	121711, 121712];
eqNumberLIST_forProcessing_SetD = [120111	120112	120121	120122	120131	120132	120141	120142	120151	120152	120161	120162	120411	120412	120521	120522	120611	120612	120621	120622	120631	120632	120641	120642	120711	120712	120721	120722	120731	120732	120741	120742	120811	120812	120821	120822	120911	120912	120921	120922	120931	120932	121011	121012	121021	121022	121031	121032	121041	121042	121051	121052	121061	121062	121111	121112	121211	121212	121221	121222	121231	121232	121321	121322	121411	121412	121421	121422	121431	121432	121441	121442	121451	121452	121461	121462	121511	121512	121711	121712];

eqNumberLIST_forProcessing_SetMumbai245 = [6000701	6000702	6002501	6002502	6006801	6006802	6008001	6008002	6008101	6008102	6016601	6016602	6023001	6023002	6023201	6023202	6024601	6024602	6028901	6028902	6030301	6030302	6031001	6031002	6031201	6031202	6032501	6032502	6032801	6032802	6033401	6033402	6034001	6034002	6035401	6035402	6047801	6047802	6049501	6049502	6052901	6052902	6053801	6053802	6054301	6054302	6057001	6057002	6057201	6057202	6057401	6057402	6057901	6057902	6061401	6061402	6063801	6063802	6064101	6064102	6067601	6067602	6072601	6072602	6074601	6074602	6078201	6078202	6079401	6079402	6079701	6079702	6080601	6080602	6081301	6081302	6081601	6081602	6086201	6086202	6088601	6088602	6091001	6091002	6091801	6091802	6092001	6092002	6092101	6092102	6092301	6092302	6092601	6092602	6092901	6092902	6093101	6093102	6093201	6093202	6094101	6094102	6094201	6094202	6094401	6094402	6095301	6095302	6095401	6095402	6095601	6095602	6095901	6095902	6096401	6096402	6096601	6096602	6097601	6097602	6097801	6097802	6097901	6097902	6098801	6098802	6099301	6099302	6099801	6099802	6100401	6100402	6100801	6100802	6101101	6101102	6102001	6102002	6102301	6102302	6103801	6103802	6104201	6104202	6104601	6104602	6104701	6104702	6104901	6104902	6105601	6105602	6105701	6105702	6106501	6106502	6107901	6107902	6108201	6108202	6108701	6108702	6109901	6109902	6110201	6110202	6110501	6110502	6114401	6114402	6115801	6115802	6117201	6117202	6119101	6119102	6119301	6119302	6121801	6121802	6122101	6122102	6122401	6122402	6123001	6123002	6124901	6124902	6125801	6125802	6127201	6127202	6128101	6128102	6128601	6128602	6128901	6128902	6130301	6130302, ...
6136101	6136102	6138701	6138702	6143701	6143702	6147101	6147102	6151501	6151502	6151701	6151702	6152001	6152002	6152101	6152102	6156001	6156002	6158101	6158102	6159301	6159302	6160001	6160002	6160401	6160402	6160501	6160502	6164001	6164002	6164301	6164302	6168101	6168102	6175401	6175402	6176001	6176002	6178001	6178002	6178601	6178602	6180501	6180502	6180601	6180602	6181101	6181102	6182001	6182002	6182301	6182302	6182901	6182902	6183101	6183102	6183701	6183702	6199401	6199402	6199501	6199502	6199701	6199702	6200301	6200302	6209701	6209702	6210001	6210002	6211101	6211102	6211201	6211202	6222201	6222202	6225201	6225202	6225301	6225302	6228101	6228102	6228501	6228502	6228701	6228702	6235101	6235102	6237201	6237202	6238101	6238102	6239401	6239402	6239701	6239702	6241101	6241102	6241301	6241302	6245701	6245702	6246201	6246202	6246301	6246302	6248301	6248302	6249501	6249502	6250101	6250102	6257301	6257302	6259301	6259302	6259501	6259502	6261301	6261302	6262101	6262102	6262401	6262402	6263801	6263802	6264401	6264402	6266001	6266002	6269801	6269802	6271601	6271602	6271701	6271702	6273001	6273002	6275301	6275302	6278401	6278402	6278501	6278502	6280701	6280702	6282101	6282102	6286301	6286302	6286901	6286902	6287301	6287302	6287401	6287402	6288801	6288802	6293701	6293702	6293801	6293802	6294001	6294002	6294401	6294402	6294701	6294702	6294801	6294802	6294901	6294902	6296201	6296202	6297601	6297602	6298201	6298202	6298501	6298502	6299201	6299202	6299301	6299302	6299601	6299602	6302701	6302702	6305401	6305402	6306001	6306002	6306101	6306102	6306201	6306202	6307701	6307702	6308701	6308702, ...
6312001	6312002	6316701	6316702	6317401	6317402	6317501	6317502	6317701	6317702	6319701	6319702	6320301	6320302	6321301	6321302	6322101	6322102	6322501	6322502	6323201	6323202	6323301	6323302	6323801	6323802	6323901	6323902	6324801	6324802	6325301	6325302	6326401	6326402	6326701	6326702	6328301	6328302	6328401	6328402	6330501	6330502	6330601	6330602	6332001	6332002	6332601	6332602	6332701	6332702	6333201	6333202	6333301	6333302	6334101	6334102	6334201	6334202	6334901	6334902	6335001	6335002	6335101	6335102	6336901	6336902	6343901	6343902	6345601	6345602	6346101	6346102	6346401	6346402	6346501	6346502	6347101	6347102	6347501	6347502	6348601	6348602	6349501	6349502	6350801	6350802	6352701	6352702	6352901	6352902																																																																																																														];

eqNumberLIST_forProcessing_SetMumbai97 = [6152601	6152602	6245701	6245702	6045901	6045902	6182901	6182902	6160401	6160402	6262401	6262402	6349501	6349502	6104601	6104602	6333301	6333302	6000701	6000702	6288801	6288802	6248301	6248302	6334201	6334202	6105601	6105602	6163301	6163302	6108701	6108702	6032501	6032502	6088401	6088402	6035401	6035402	6263801	6263802	6094701	6094702	6199401	6199402	6136101	6136102	6321701	6321702	6158101	6158102	6092001	6092002	6110501	6110502	6321201	6321202	6064101	6064102	6091001	6091002	6236201	6236202	6138701	6138702	6262101	6262102	6002501	6002502	6128701	6128702	6302401	6302402	6104701	6104702	6298501	6298502	6103801	6103802	6282101	6282102	6278501	6278502	6111801	6111802	6031201	6031202	6156001	6156002	6100201	6100202	6028801	6028802	6026201	6026202	6128101	6128102	6079401	6079402	6079701	6079702	6094101	6094102	6332701	6332702	6035301	6035302	6057201	6057202	6149601	6149602	6329101	6329102	6229101	6229102	6239401	6239402	6211101	6211102	6321801	6321802	6123001	6123002	6092601	6092602	6107901	6107902	6125801	6125802	6006901	6006902	6293701	6293702	6023101	6023102	6228101	6228102	6263201	6263202	6151101	6151102	6300001	6300002	6163001	6163002	6325301	6325302	6323301	6323302	6199701	6199702	6305401	6305402	6091401	6091402	6134801	6134802	6351301	6351302	6148501	6148502	6151801	6151802	6259501	6259502	6110201	6110202	6317501	6317502	6281101	6281102	6079101	6079102	6297301	6297302	6211601	6211602	6240001	6240002	6095901	6095902	6031001	6031002	6346501	6346502	6347701	6347702	6323801	6323802	6257301	6257302	6023701	6023702	6072601	6072602];


%    eqLIST = eqNumberLIST_forProcessing_SetC;
%    eqLIST = eqNumberLIST_forProcessing_SetMumbai245;
   eqLIST = eqNumberLIST_forProcessing_SetMumbai97;
   doPlot = 0; % 1- Plot. 0- don't plot. Use 1, when processing smaller number of EQs

cutOffFraction = 0.05; % this is the fraction of PGA, below which GM would be curtailed from tails (beginning and end)
minCurtailFraction = 0.05; % don't curtail the time history less than this fraction on either side.
                           % this is to avoid unnecessarily modifying time histories without much advantage.
  
MarkerTypeList={'r-','b--','k-.','g--','y..',[.5 .6 .7],[.8 .2 .6],}; % Cell array of 7 markers.
totNumOfEQs = length(eqLIST);
for eqIndex = 1:totNumOfEQs
    GMTimeHistory = []; % initiate everytime
    timeArray = [];
    
%     cd C:\OpenSeesProcessingFiles\EQs\ORIGINAL_TIME_HISTORIES
    cd C:\OpenSeesProcessingFiles\EQs\Prak_Mumbai_GM_Sorted_Original
    
    locationToSaveTheFiles = 'H:\GMSelection\MUMBAI_SelectedGroundMotions\CurtailedTH';
    
    eqNumber = eqLIST(eqIndex);

    dt = load(sprintf('DtFile_(%i).txt', eqNumber));
    numPoints = load(sprintf('NumPointsFile_(%i).txt', eqNumber));
    GMTimeHistory = load(sprintf('SortedEQFile_(%i).txt', eqNumber));
    timeArray = 0:dt:dt * (numPoints - 1);
    
    cutOffValue = cutOffFraction * max(abs(GMTimeHistory));

    if (doPlot == 1)
        figure(51) % random number to avoid possible conflict, just in case of some other existing figure
        plot(timeArray, GMTimeHistory, MarkerTypeList{eqIndex},'LineWidth',1.0); hold on; grid on;
        xlabel('Time (second) \rightarrow'); ylabel('Ground accelration (g) \rightarrow');
        % plot the cut off line
        plot(timeArray, cutOffValue * ones(length(timeArray), 1), 'k-', 'LineWidth', 1);
    end    

    fprintf('PGA for eqNum %i is %5.3f \n', eqNumber, max(GMTimeHistory));

% find the first time step when acceleration exceeds the cut-off value
    firstTimeIndexOfCurtailedGM = find(abs(GMTimeHistory) > cutOffValue, 1);
        
% find the last time step after which, acceleration does not exceed the cut-off value
    reversedGM = (fliplr(GMTimeHistory'))'; % transpose of left-to-right-flipped-transpose
    lastTimeIndexOfCurtailedGM = numPoints - find(abs(reversedGM) > cutOffValue, 1);

% If initial and final both curtailmenta are too small, don't do it. Continue to the next earthquake
    if ((firstTimeIndexOfCurtailedGM < minCurtailFraction * numPoints) && (lastTimeIndexOfCurtailedGM > (1 - minCurtailFraction) * numPoints))
        fprintf('Possible curtailment is too small on either sides. Hence, is not performed. \n');

        cd(locationToSaveTheFiles)
        save(sprintf('SortedEQFile_(%i).txt', eqNumber), 'GMTimeHistory', '-ascii');
        save(sprintf('NumPointsFile_(%i).txt', eqNumber), 'numPoints', '-ascii');
        disp(['Files saved as ', fullfile(pwd, sprintf('SortedEQFile_(%i).txt', eqNumber)), ' and ', sprintf('NumPointsFile_(%i).txt', eqNumber)]);
        fprintf('---------------------------------------------- \n');
        continue
    end
        
% During initial timeperiod, if reduction in GM duration is less than 5%, don't do it.
    if (firstTimeIndexOfCurtailedGM < minCurtailFraction * numPoints)
%         fprintf('First Time Index exceeding the cut-off is %i, this is less than %i (i.e. less than %i%% away from start of GM) \n hence, no curtailement from left side is done! \n', firstTimeIndexOfCurtailedGM, minCurtailFraction * numPoints, minCurtailFraction * 100);
        fprintf('--- No curtailment from Left side is done --- \t');
        firstTimeIndexOfCurtailedGM = 1;
    else
        firstTimeIndexOfCurtailedGM = firstTimeIndexOfCurtailedGM - round(0.01 * numPoints); % include some points even before cut off
        fprintf('--- %i%% curtailment from Left side is done --- \t', round((firstTimeIndexOfCurtailedGM / numPoints) * 100));
    end
    
% During final timeperiod, if reduction in GM duration is less than 5%, don't do it.
    if (lastTimeIndexOfCurtailedGM > (1 - minCurtailFraction) * numPoints)
%         fprintf('Last Time Index exceeding the cut-off is %i, this is more than %i (i.e. less than %i%% away from end of GM) \n hence, no curtailement from right side is done! \n', lastTimeIndexOfCurtailedGM, (1- minCurtailFraction) * numPoints, minCurtailFraction * 100);
        fprintf('--- No curtailment from Right side is done --- \n');
        lastTimeIndexOfCurtailedGM = numPoints;
    else
        lastTimeIndexOfCurtailedGM = lastTimeIndexOfCurtailedGM + round(0.01 * numPoints); % include some points even after cut off
        fprintf('--- %i%% curtailment from Right side is done --- \n', round(100 - (lastTimeIndexOfCurtailedGM / numPoints) * 100));
    end

    curtailedGMTimeHistory = GMTimeHistory(firstTimeIndexOfCurtailedGM:lastTimeIndexOfCurtailedGM);
    curtailedNumPoints = lastTimeIndexOfCurtailedGM - firstTimeIndexOfCurtailedGM + 1;
    curtailedTimeArray = 0:dt:dt * (curtailedNumPoints - 1);
    
    if (doPlot == 1)
        figure(52)
        plot(curtailedTimeArray, curtailedGMTimeHistory, MarkerTypeList{eqIndex},'LineWidth',1.0); hold on; grid on;
        xlabel('Time (second) \rightarrow'); ylabel('Ground accelration (g) \rightarrow');
    end
    
    cd(locationToSaveTheFiles)
    save(sprintf('SortedEQFile_(%i).txt', eqNumber), 'curtailedGMTimeHistory', '-ascii');
    save(sprintf('NumPointsFile_(%i).txt', eqNumber), 'curtailedNumPoints', '-ascii');
    disp(['Files saved as ', fullfile(pwd, sprintf('SortedEQFile_(%i).txt', eqNumber)), ' and ', sprintf('NumPointsFile_(%i).txt', eqNumber)]);
    
    curtailmentPercentage(eqIndex) = round((numPoints - curtailedNumPoints)/ numPoints *100);
    fprintf('NumPoints were reduced from %i to %i (%i%% curtailment) \n', numPoints, curtailedNumPoints, curtailmentPercentage(eqIndex));
    fprintf('---------------------------------------------- \n');
   
end

    case '9b.curtailGroundMotionBasedOnPGAForMumbai50Remaining'
        %% 
% This saves the files in H:\PrakRuns just to be cautious, I am not pasting these values in final directory.
eqNumberLIST_forProcessing_SetC = [120111, 120112, 120121, 120122,	120411, 120412,	120521, 120522,	120611, 120612,	120621, 120622,	120711, 120712,	120721, 120722,	120811, 120812,	120821, 120822,	120911, 120912,	120921, 120922,	121011, 121012,	121021, 121022,	121111, 121112,	121211, 121212,	121221, 121222,	121321, 121322,	121411, 121412,	121421, 121422,	121511, 121512,	121711, 121712];
eqNumberLIST_forProcessing_SetD = [120111	120112	120121	120122	120131	120132	120141	120142	120151	120152	120161	120162	120411	120412	120521	120522	120611	120612	120621	120622	120631	120632	120641	120642	120711	120712	120721	120722	120731	120732	120741	120742	120811	120812	120821	120822	120911	120912	120921	120922	120931	120932	121011	121012	121021	121022	121031	121032	121041	121042	121051	121052	121061	121062	121111	121112	121211	121212	121221	121222	121231	121232	121321	121322	121411	121412	121421	121422	121431	121432	121441	121442	121451	121452	121461	121462	121511	121512	121711	121712];

eqNumberLIST_forProcessing_SetMumbai245 = [6000701	6000702	6002501	6002502	6006801	6006802	6008001	6008002	6008101	6008102	6016601	6016602	6023001	6023002	6023201	6023202	6024601	6024602	6028901	6028902	6030301	6030302	6031001	6031002	6031201	6031202	6032501	6032502	6032801	6032802	6033401	6033402	6034001	6034002	6035401	6035402	6047801	6047802	6049501	6049502	6052901	6052902	6053801	6053802	6054301	6054302	6057001	6057002	6057201	6057202	6057401	6057402	6057901	6057902	6061401	6061402	6063801	6063802	6064101	6064102	6067601	6067602	6072601	6072602	6074601	6074602	6078201	6078202	6079401	6079402	6079701	6079702	6080601	6080602	6081301	6081302	6081601	6081602	6086201	6086202	6088601	6088602	6091001	6091002	6091801	6091802	6092001	6092002	6092101	6092102	6092301	6092302	6092601	6092602	6092901	6092902	6093101	6093102	6093201	6093202	6094101	6094102	6094201	6094202	6094401	6094402	6095301	6095302	6095401	6095402	6095601	6095602	6095901	6095902	6096401	6096402	6096601	6096602	6097601	6097602	6097801	6097802	6097901	6097902	6098801	6098802	6099301	6099302	6099801	6099802	6100401	6100402	6100801	6100802	6101101	6101102	6102001	6102002	6102301	6102302	6103801	6103802	6104201	6104202	6104601	6104602	6104701	6104702	6104901	6104902	6105601	6105602	6105701	6105702	6106501	6106502	6107901	6107902	6108201	6108202	6108701	6108702	6109901	6109902	6110201	6110202	6110501	6110502	6114401	6114402	6115801	6115802	6117201	6117202	6119101	6119102	6119301	6119302	6121801	6121802	6122101	6122102	6122401	6122402	6123001	6123002	6124901	6124902	6125801	6125802	6127201	6127202	6128101	6128102	6128601	6128602	6128901	6128902	6130301	6130302, ...
6136101	6136102	6138701	6138702	6143701	6143702	6147101	6147102	6151501	6151502	6151701	6151702	6152001	6152002	6152101	6152102	6156001	6156002	6158101	6158102	6159301	6159302	6160001	6160002	6160401	6160402	6160501	6160502	6164001	6164002	6164301	6164302	6168101	6168102	6175401	6175402	6176001	6176002	6178001	6178002	6178601	6178602	6180501	6180502	6180601	6180602	6181101	6181102	6182001	6182002	6182301	6182302	6182901	6182902	6183101	6183102	6183701	6183702	6199401	6199402	6199501	6199502	6199701	6199702	6200301	6200302	6209701	6209702	6210001	6210002	6211101	6211102	6211201	6211202	6222201	6222202	6225201	6225202	6225301	6225302	6228101	6228102	6228501	6228502	6228701	6228702	6235101	6235102	6237201	6237202	6238101	6238102	6239401	6239402	6239701	6239702	6241101	6241102	6241301	6241302	6245701	6245702	6246201	6246202	6246301	6246302	6248301	6248302	6249501	6249502	6250101	6250102	6257301	6257302	6259301	6259302	6259501	6259502	6261301	6261302	6262101	6262102	6262401	6262402	6263801	6263802	6264401	6264402	6266001	6266002	6269801	6269802	6271601	6271602	6271701	6271702	6273001	6273002	6275301	6275302	6278401	6278402	6278501	6278502	6280701	6280702	6282101	6282102	6286301	6286302	6286901	6286902	6287301	6287302	6287401	6287402	6288801	6288802	6293701	6293702	6293801	6293802	6294001	6294002	6294401	6294402	6294701	6294702	6294801	6294802	6294901	6294902	6296201	6296202	6297601	6297602	6298201	6298202	6298501	6298502	6299201	6299202	6299301	6299302	6299601	6299602	6302701	6302702	6305401	6305402	6306001	6306002	6306101	6306102	6306201	6306202	6307701	6307702	6308701	6308702, ...
6312001	6312002	6316701	6316702	6317401	6317402	6317501	6317502	6317701	6317702	6319701	6319702	6320301	6320302	6321301	6321302	6322101	6322102	6322501	6322502	6323201	6323202	6323301	6323302	6323801	6323802	6323901	6323902	6324801	6324802	6325301	6325302	6326401	6326402	6326701	6326702	6328301	6328302	6328401	6328402	6330501	6330502	6330601	6330602	6332001	6332002	6332601	6332602	6332701	6332702	6333201	6333202	6333301	6333302	6334101	6334102	6334201	6334202	6334901	6334902	6335001	6335002	6335101	6335102	6336901	6336902	6343901	6343902	6345601	6345602	6346101	6346102	6346401	6346402	6346501	6346502	6347101	6347102	6347501	6347502	6348601	6348602	6349501	6349502	6350801	6350802	6352701	6352702	6352901	6352902																																																																																																														];

eqNumberLIST_forProcessing_SetMumbai97 = [6152601	6152602	6245701	6245702	6045901	6045902	6182901	6182902	6160401	6160402	6262401	6262402	6349501	6349502	6104601	6104602	6333301	6333302	6000701	6000702	6288801	6288802	6248301	6248302	6334201	6334202	6105601	6105602	6163301	6163302	6108701	6108702	6032501	6032502	6088401	6088402	6035401	6035402	6263801	6263802	6094701	6094702	6199401	6199402	6136101	6136102	6321701	6321702	6158101	6158102	6092001	6092002	6110501	6110502	6321201	6321202	6064101	6064102	6091001	6091002	6236201	6236202	6138701	6138702	6262101	6262102	6002501	6002502	6128701	6128702	6302401	6302402	6104701	6104702	6298501	6298502	6103801	6103802	6282101	6282102	6278501	6278502	6111801	6111802	6031201	6031202	6156001	6156002	6100201	6100202	6028801	6028802	6026201	6026202	6128101	6128102	6079401	6079402	6079701	6079702	6094101	6094102	6332701	6332702	6035301	6035302	6057201	6057202	6149601	6149602	6329101	6329102	6229101	6229102	6239401	6239402	6211101	6211102	6321801	6321802	6123001	6123002	6092601	6092602	6107901	6107902	6125801	6125802	6006901	6006902	6293701	6293702	6023101	6023102	6228101	6228102	6263201	6263202	6151101	6151102	6300001	6300002	6163001	6163002	6325301	6325302	6323301	6323302	6199701	6199702	6305401	6305402	6091401	6091402	6134801	6134802	6351301	6351302	6148501	6148502	6151801	6151802	6259501	6259502	6110201	6110202	6317501	6317502	6281101	6281102	6079101	6079102	6297301	6297302	6211601	6211602	6240001	6240002	6095901	6095902	6031001	6031002	6346501	6346502	6347701	6347702	6323801	6323802	6257301	6257302	6023701	6023702	6072601	6072602];
eqNumberLIST_forProcessing_SetMumbai50Remaining = [6109301	6109302	6153801	6153802	6225501	6225502	6249201	6249202	6265801	6265802	6279701	6279702	6288701	6288702	6330901	6330902	6333101	6333102	6348201	6348202	6063401	6063402	6076101	6076102	6080701	6080702	6108601	6108602	6110601	6110602	6118701	6118702	6248501	6248502	6302301	6302302	6347001	6347002];

%    eqLIST = eqNumberLIST_forProcessing_SetC;
%    eqLIST = eqNumberLIST_forProcessing_SetMumbai245;
   eqLIST = eqNumberLIST_forProcessing_SetMumbai50Remaining;
   doPlot = 0; % 1- Plot. 0- don't plot. Use 1, when processing smaller number of EQs

cutOffFraction = 0.05; % this is the fraction of PGA, below which GM would be curtailed from tails (beginning and end)
minCurtailFraction = 0.05; % don't curtail the time history less than this fraction on either side.
                           % this is to avoid unnecessarily modifying time histories without much advantage.
  
MarkerTypeList={'r-','b--','k-.','g--','y..',[.5 .6 .7],[.8 .2 .6],}; % Cell array of 7 markers.
totNumOfEQs = length(eqLIST);
for eqIndex = 1:totNumOfEQs
    GMTimeHistory = []; % initiate everytime
    timeArray = [];
    
%     cd C:\OpenSeesProcessingFiles\EQs\ORIGINAL_TIME_HISTORIES
    cd C:\OpenSeesProcessingFiles\EQs\Prak_Mumbai_GM_Sorted_Original
    
    locationToSaveTheFiles = 'H:\GMSelection\MUMBAI_SelectedGroundMotions\CurtailedTH1';
    
    eqNumber = eqLIST(eqIndex);

    dt = load(sprintf('DtFile_(%i).txt', eqNumber));
    numPoints = load(sprintf('NumPointsFile_(%i).txt', eqNumber));
    GMTimeHistory = load(sprintf('SortedEQFile_(%i).txt', eqNumber));
    timeArray = 0:dt:dt * (numPoints - 1);
    
    cutOffValue = cutOffFraction * max(abs(GMTimeHistory));

    if (doPlot == 1)
        figure(51) % random number to avoid possible conflict, just in case of some other existing figure
        plot(timeArray, GMTimeHistory, MarkerTypeList{eqIndex},'LineWidth',1.0); hold on; grid on;
        xlabel('Time (second) \rightarrow'); ylabel('Ground accelration (g) \rightarrow');
        % plot the cut off line
        plot(timeArray, cutOffValue * ones(length(timeArray), 1), 'k-', 'LineWidth', 1);
    end    

    fprintf('PGA for eqNum %i is %5.3f \n', eqNumber, max(GMTimeHistory));

% find the first time step when acceleration exceeds the cut-off value
    firstTimeIndexOfCurtailedGM = find(abs(GMTimeHistory) > cutOffValue, 1);
        
% find the last time step after which, acceleration does not exceed the cut-off value
    reversedGM = (fliplr(GMTimeHistory'))'; % transpose of left-to-right-flipped-transpose
    lastTimeIndexOfCurtailedGM = numPoints - find(abs(reversedGM) > cutOffValue, 1);

% If initial and final both curtailmenta are too small, don't do it. Continue to the next earthquake
    if ((firstTimeIndexOfCurtailedGM < minCurtailFraction * numPoints) && (lastTimeIndexOfCurtailedGM > (1 - minCurtailFraction) * numPoints))
        fprintf('Possible curtailment is too small on either sides. Hence, is not performed. \n');

        cd(locationToSaveTheFiles)
        save(sprintf('SortedEQFile_(%i).txt', eqNumber), 'GMTimeHistory', '-ascii');
        save(sprintf('NumPointsFile_(%i).txt', eqNumber), 'numPoints', '-ascii');
        disp(['Files saved as ', fullfile(pwd, sprintf('SortedEQFile_(%i).txt', eqNumber)), ' and ', sprintf('NumPointsFile_(%i).txt', eqNumber)]);
        fprintf('---------------------------------------------- \n');
        continue
    end
        
% During initial timeperiod, if reduction in GM duration is less than 5%, don't do it.
    if (firstTimeIndexOfCurtailedGM < minCurtailFraction * numPoints)
%         fprintf('First Time Index exceeding the cut-off is %i, this is less than %i (i.e. less than %i%% away from start of GM) \n hence, no curtailement from left side is done! \n', firstTimeIndexOfCurtailedGM, minCurtailFraction * numPoints, minCurtailFraction * 100);
        fprintf('--- No curtailment from Left side is done --- \t');
        firstTimeIndexOfCurtailedGM = 1;
    else
        firstTimeIndexOfCurtailedGM = firstTimeIndexOfCurtailedGM - round(0.01 * numPoints); % include some points even before cut off
        fprintf('--- %i%% curtailment from Left side is done --- \t', round((firstTimeIndexOfCurtailedGM / numPoints) * 100));
    end
    
% During final timeperiod, if reduction in GM duration is less than 5%, don't do it.
    if (lastTimeIndexOfCurtailedGM > (1 - minCurtailFraction) * numPoints)
%         fprintf('Last Time Index exceeding the cut-off is %i, this is more than %i (i.e. less than %i%% away from end of GM) \n hence, no curtailement from right side is done! \n', lastTimeIndexOfCurtailedGM, (1- minCurtailFraction) * numPoints, minCurtailFraction * 100);
        fprintf('--- No curtailment from Right side is done --- \n');
        lastTimeIndexOfCurtailedGM = numPoints;
    else
        lastTimeIndexOfCurtailedGM = lastTimeIndexOfCurtailedGM + round(0.01 * numPoints); % include some points even after cut off
        fprintf('--- %i%% curtailment from Right side is done --- \n', round(100 - (lastTimeIndexOfCurtailedGM / numPoints) * 100));
    end

    curtailedGMTimeHistory = GMTimeHistory(firstTimeIndexOfCurtailedGM:lastTimeIndexOfCurtailedGM);
    curtailedNumPoints = lastTimeIndexOfCurtailedGM - firstTimeIndexOfCurtailedGM + 1;
    curtailedTimeArray = 0:dt:dt * (curtailedNumPoints - 1);
    
    if (doPlot == 1)
        figure(52)
        plot(curtailedTimeArray, curtailedGMTimeHistory, MarkerTypeList{eqIndex},'LineWidth',1.0); hold on; grid on;
        xlabel('Time (second) \rightarrow'); ylabel('Ground accelration (g) \rightarrow');
    end
    
    cd(locationToSaveTheFiles)
    save(sprintf('SortedEQFile_(%i).txt', eqNumber), 'curtailedGMTimeHistory', '-ascii');
    save(sprintf('NumPointsFile_(%i).txt', eqNumber), 'curtailedNumPoints', '-ascii');
    disp(['Files saved as ', fullfile(pwd, sprintf('SortedEQFile_(%i).txt', eqNumber)), ' and ', sprintf('NumPointsFile_(%i).txt', eqNumber)]);
    
    curtailmentPercentage(eqIndex) = round((numPoints - curtailedNumPoints)/ numPoints *100);
    fprintf('NumPoints were reduced from %i to %i (%i%% curtailment) \n', numPoints, curtailedNumPoints, curtailmentPercentage(eqIndex));
    fprintf('---------------------------------------------- \n');
   
end

    case '9c.curtailGroundMotionBasedOnPGAForMumbai22Remaining'
        %% 
% This saves the files in H:\PrakRuns just to be cautious, I am not pasting these values in final directory.
eqNumberLIST_forProcessing_SetC = [120111, 120112, 120121, 120122,	120411, 120412,	120521, 120522,	120611, 120612,	120621, 120622,	120711, 120712,	120721, 120722,	120811, 120812,	120821, 120822,	120911, 120912,	120921, 120922,	121011, 121012,	121021, 121022,	121111, 121112,	121211, 121212,	121221, 121222,	121321, 121322,	121411, 121412,	121421, 121422,	121511, 121512,	121711, 121712];
eqNumberLIST_forProcessing_SetD = [120111	120112	120121	120122	120131	120132	120141	120142	120151	120152	120161	120162	120411	120412	120521	120522	120611	120612	120621	120622	120631	120632	120641	120642	120711	120712	120721	120722	120731	120732	120741	120742	120811	120812	120821	120822	120911	120912	120921	120922	120931	120932	121011	121012	121021	121022	121031	121032	121041	121042	121051	121052	121061	121062	121111	121112	121211	121212	121221	121222	121231	121232	121321	121322	121411	121412	121421	121422	121431	121432	121441	121442	121451	121452	121461	121462	121511	121512	121711	121712];

eqNumberLIST_forProcessing_SetMumbai245 = [6000701	6000702	6002501	6002502	6006801	6006802	6008001	6008002	6008101	6008102	6016601	6016602	6023001	6023002	6023201	6023202	6024601	6024602	6028901	6028902	6030301	6030302	6031001	6031002	6031201	6031202	6032501	6032502	6032801	6032802	6033401	6033402	6034001	6034002	6035401	6035402	6047801	6047802	6049501	6049502	6052901	6052902	6053801	6053802	6054301	6054302	6057001	6057002	6057201	6057202	6057401	6057402	6057901	6057902	6061401	6061402	6063801	6063802	6064101	6064102	6067601	6067602	6072601	6072602	6074601	6074602	6078201	6078202	6079401	6079402	6079701	6079702	6080601	6080602	6081301	6081302	6081601	6081602	6086201	6086202	6088601	6088602	6091001	6091002	6091801	6091802	6092001	6092002	6092101	6092102	6092301	6092302	6092601	6092602	6092901	6092902	6093101	6093102	6093201	6093202	6094101	6094102	6094201	6094202	6094401	6094402	6095301	6095302	6095401	6095402	6095601	6095602	6095901	6095902	6096401	6096402	6096601	6096602	6097601	6097602	6097801	6097802	6097901	6097902	6098801	6098802	6099301	6099302	6099801	6099802	6100401	6100402	6100801	6100802	6101101	6101102	6102001	6102002	6102301	6102302	6103801	6103802	6104201	6104202	6104601	6104602	6104701	6104702	6104901	6104902	6105601	6105602	6105701	6105702	6106501	6106502	6107901	6107902	6108201	6108202	6108701	6108702	6109901	6109902	6110201	6110202	6110501	6110502	6114401	6114402	6115801	6115802	6117201	6117202	6119101	6119102	6119301	6119302	6121801	6121802	6122101	6122102	6122401	6122402	6123001	6123002	6124901	6124902	6125801	6125802	6127201	6127202	6128101	6128102	6128601	6128602	6128901	6128902	6130301	6130302, ...
6136101	6136102	6138701	6138702	6143701	6143702	6147101	6147102	6151501	6151502	6151701	6151702	6152001	6152002	6152101	6152102	6156001	6156002	6158101	6158102	6159301	6159302	6160001	6160002	6160401	6160402	6160501	6160502	6164001	6164002	6164301	6164302	6168101	6168102	6175401	6175402	6176001	6176002	6178001	6178002	6178601	6178602	6180501	6180502	6180601	6180602	6181101	6181102	6182001	6182002	6182301	6182302	6182901	6182902	6183101	6183102	6183701	6183702	6199401	6199402	6199501	6199502	6199701	6199702	6200301	6200302	6209701	6209702	6210001	6210002	6211101	6211102	6211201	6211202	6222201	6222202	6225201	6225202	6225301	6225302	6228101	6228102	6228501	6228502	6228701	6228702	6235101	6235102	6237201	6237202	6238101	6238102	6239401	6239402	6239701	6239702	6241101	6241102	6241301	6241302	6245701	6245702	6246201	6246202	6246301	6246302	6248301	6248302	6249501	6249502	6250101	6250102	6257301	6257302	6259301	6259302	6259501	6259502	6261301	6261302	6262101	6262102	6262401	6262402	6263801	6263802	6264401	6264402	6266001	6266002	6269801	6269802	6271601	6271602	6271701	6271702	6273001	6273002	6275301	6275302	6278401	6278402	6278501	6278502	6280701	6280702	6282101	6282102	6286301	6286302	6286901	6286902	6287301	6287302	6287401	6287402	6288801	6288802	6293701	6293702	6293801	6293802	6294001	6294002	6294401	6294402	6294701	6294702	6294801	6294802	6294901	6294902	6296201	6296202	6297601	6297602	6298201	6298202	6298501	6298502	6299201	6299202	6299301	6299302	6299601	6299602	6302701	6302702	6305401	6305402	6306001	6306002	6306101	6306102	6306201	6306202	6307701	6307702	6308701	6308702, ...
6312001	6312002	6316701	6316702	6317401	6317402	6317501	6317502	6317701	6317702	6319701	6319702	6320301	6320302	6321301	6321302	6322101	6322102	6322501	6322502	6323201	6323202	6323301	6323302	6323801	6323802	6323901	6323902	6324801	6324802	6325301	6325302	6326401	6326402	6326701	6326702	6328301	6328302	6328401	6328402	6330501	6330502	6330601	6330602	6332001	6332002	6332601	6332602	6332701	6332702	6333201	6333202	6333301	6333302	6334101	6334102	6334201	6334202	6334901	6334902	6335001	6335002	6335101	6335102	6336901	6336902	6343901	6343902	6345601	6345602	6346101	6346102	6346401	6346402	6346501	6346502	6347101	6347102	6347501	6347502	6348601	6348602	6349501	6349502	6350801	6350802	6352701	6352702	6352901	6352902																																																																																																														];

eqNumberLIST_forProcessing_SetMumbai97 = [6152601	6152602	6245701	6245702	6045901	6045902	6182901	6182902	6160401	6160402	6262401	6262402	6349501	6349502	6104601	6104602	6333301	6333302	6000701	6000702	6288801	6288802	6248301	6248302	6334201	6334202	6105601	6105602	6163301	6163302	6108701	6108702	6032501	6032502	6088401	6088402	6035401	6035402	6263801	6263802	6094701	6094702	6199401	6199402	6136101	6136102	6321701	6321702	6158101	6158102	6092001	6092002	6110501	6110502	6321201	6321202	6064101	6064102	6091001	6091002	6236201	6236202	6138701	6138702	6262101	6262102	6002501	6002502	6128701	6128702	6302401	6302402	6104701	6104702	6298501	6298502	6103801	6103802	6282101	6282102	6278501	6278502	6111801	6111802	6031201	6031202	6156001	6156002	6100201	6100202	6028801	6028802	6026201	6026202	6128101	6128102	6079401	6079402	6079701	6079702	6094101	6094102	6332701	6332702	6035301	6035302	6057201	6057202	6149601	6149602	6329101	6329102	6229101	6229102	6239401	6239402	6211101	6211102	6321801	6321802	6123001	6123002	6092601	6092602	6107901	6107902	6125801	6125802	6006901	6006902	6293701	6293702	6023101	6023102	6228101	6228102	6263201	6263202	6151101	6151102	6300001	6300002	6163001	6163002	6325301	6325302	6323301	6323302	6199701	6199702	6305401	6305402	6091401	6091402	6134801	6134802	6351301	6351302	6148501	6148502	6151801	6151802	6259501	6259502	6110201	6110202	6317501	6317502	6281101	6281102	6079101	6079102	6297301	6297302	6211601	6211602	6240001	6240002	6095901	6095902	6031001	6031002	6346501	6346502	6347701	6347702	6323801	6323802	6257301	6257302	6023701	6023702	6072601	6072602];
eqNumberLIST_forProcessing_SetMumbai50Remaining = [6109301	6109302	6153801	6153802	6225501	6225502	6249201	6249202	6265801	6265802	6279701	6279702	6288701	6288702	6330901	6330902	6333101	6333102	6348201	6348202	6063401	6063402	6076101	6076102	6080701	6080702	6108601	6108602	6110601	6110602	6118701	6118702	6248501	6248502	6302301	6302302	6347001	6347002];

eqNumberLIST_forProcessing_SetMumbai22Remaining = [6018001	6018002	6032201	6032202	6034201	6034202	6055201	6055202	6096301	6096302	6151301	6151302	6159401	6159402	6265901	6265902	6279301	6279302	6280901	6280902];

%    eqLIST = eqNumberLIST_forProcessing_SetC;
%    eqLIST = eqNumberLIST_forProcessing_SetMumbai245;
%    eqLIST = eqNumberLIST_forProcessing_SetMumbai50Remaining;
   eqLIST = eqNumberLIST_forProcessing_SetMumbai22Remaining;

   doPlot = 0; % 1- Plot. 0- don't plot. Use 1, when processing smaller number of EQs

cutOffFraction = 0.05; % this is the fraction of PGA, below which GM would be curtailed from tails (beginning and end)
minCurtailFraction = 0.05; % don't curtail the time history less than this fraction on either side.
                           % this is to avoid unnecessarily modifying time histories without much advantage.
  
MarkerTypeList={'r-','b--','k-.','g--','y..',[.5 .6 .7],[.8 .2 .6],}; % Cell array of 7 markers.
totNumOfEQs = length(eqLIST);
for eqIndex = 1:totNumOfEQs
    GMTimeHistory = []; % initiate everytime
    timeArray = [];
    
%     cd C:\OpenSeesProcessingFiles\EQs\ORIGINAL_TIME_HISTORIES
    cd C:\OpenSeesProcessingFiles\EQs\Prak_Mumbai_GM_Sorted_Original
    
    locationToSaveTheFiles = 'H:\GMSelection\MUMBAI_SelectedGroundMotions\CurtailedTH1';
    
    eqNumber = eqLIST(eqIndex);

    dt = load(sprintf('DtFile_(%i).txt', eqNumber));
    numPoints = load(sprintf('NumPointsFile_(%i).txt', eqNumber));
    GMTimeHistory = load(sprintf('SortedEQFile_(%i).txt', eqNumber));
    timeArray = 0:dt:dt * (numPoints - 1);
    
    cutOffValue = cutOffFraction * max(abs(GMTimeHistory));

    if (doPlot == 1)
        figure(51) % random number to avoid possible conflict, just in case of some other existing figure
        plot(timeArray, GMTimeHistory, MarkerTypeList{eqIndex},'LineWidth',1.0); hold on; grid on;
        xlabel('Time (second) \rightarrow'); ylabel('Ground accelration (g) \rightarrow');
        % plot the cut off line
        plot(timeArray, cutOffValue * ones(length(timeArray), 1), 'k-', 'LineWidth', 1);
    end    

    fprintf('PGA for eqNum %i is %5.3f \n', eqNumber, max(GMTimeHistory));

% find the first time step when acceleration exceeds the cut-off value
    firstTimeIndexOfCurtailedGM = find(abs(GMTimeHistory) > cutOffValue, 1);
        
% find the last time step after which, acceleration does not exceed the cut-off value
    reversedGM = (fliplr(GMTimeHistory'))'; % transpose of left-to-right-flipped-transpose
    lastTimeIndexOfCurtailedGM = numPoints - find(abs(reversedGM) > cutOffValue, 1);

% If initial and final both curtailmenta are too small, don't do it. Continue to the next earthquake
    if ((firstTimeIndexOfCurtailedGM < minCurtailFraction * numPoints) && (lastTimeIndexOfCurtailedGM > (1 - minCurtailFraction) * numPoints))
        fprintf('Possible curtailment is too small on either sides. Hence, is not performed. \n');

        cd(locationToSaveTheFiles)
        save(sprintf('SortedEQFile_(%i).txt', eqNumber), 'GMTimeHistory', '-ascii');
        save(sprintf('NumPointsFile_(%i).txt', eqNumber), 'numPoints', '-ascii');
        disp(['Files saved as ', fullfile(pwd, sprintf('SortedEQFile_(%i).txt', eqNumber)), ' and ', sprintf('NumPointsFile_(%i).txt', eqNumber)]);
        fprintf('---------------------------------------------- \n');
        continue
    end
        
% During initial timeperiod, if reduction in GM duration is less than 5%, don't do it.
    if (firstTimeIndexOfCurtailedGM < minCurtailFraction * numPoints)
%         fprintf('First Time Index exceeding the cut-off is %i, this is less than %i (i.e. less than %i%% away from start of GM) \n hence, no curtailement from left side is done! \n', firstTimeIndexOfCurtailedGM, minCurtailFraction * numPoints, minCurtailFraction * 100);
        fprintf('--- No curtailment from Left side is done --- \t');
        firstTimeIndexOfCurtailedGM = 1;
    else
        firstTimeIndexOfCurtailedGM = firstTimeIndexOfCurtailedGM - round(0.01 * numPoints); % include some points even before cut off
        fprintf('--- %i%% curtailment from Left side is done --- \t', round((firstTimeIndexOfCurtailedGM / numPoints) * 100));
    end
    
% During final timeperiod, if reduction in GM duration is less than 5%, don't do it.
    if (lastTimeIndexOfCurtailedGM > (1 - minCurtailFraction) * numPoints)
%         fprintf('Last Time Index exceeding the cut-off is %i, this is more than %i (i.e. less than %i%% away from end of GM) \n hence, no curtailement from right side is done! \n', lastTimeIndexOfCurtailedGM, (1- minCurtailFraction) * numPoints, minCurtailFraction * 100);
        fprintf('--- No curtailment from Right side is done --- \n');
        lastTimeIndexOfCurtailedGM = numPoints;
    else
        lastTimeIndexOfCurtailedGM = lastTimeIndexOfCurtailedGM + round(0.01 * numPoints); % include some points even after cut off
        fprintf('--- %i%% curtailment from Right side is done --- \n', round(100 - (lastTimeIndexOfCurtailedGM / numPoints) * 100));
    end

    curtailedGMTimeHistory = GMTimeHistory(firstTimeIndexOfCurtailedGM:lastTimeIndexOfCurtailedGM);
    curtailedNumPoints = lastTimeIndexOfCurtailedGM - firstTimeIndexOfCurtailedGM + 1;
    curtailedTimeArray = 0:dt:dt * (curtailedNumPoints - 1);
    
    if (doPlot == 1)
        figure(52)
        plot(curtailedTimeArray, curtailedGMTimeHistory, MarkerTypeList{eqIndex},'LineWidth',1.0); hold on; grid on;
        xlabel('Time (second) \rightarrow'); ylabel('Ground accelration (g) \rightarrow');
    end
    
    cd(locationToSaveTheFiles)
    save(sprintf('SortedEQFile_(%i).txt', eqNumber), 'curtailedGMTimeHistory', '-ascii');
    save(sprintf('NumPointsFile_(%i).txt', eqNumber), 'curtailedNumPoints', '-ascii');
    disp(['Files saved as ', fullfile(pwd, sprintf('SortedEQFile_(%i).txt', eqNumber)), ' and ', sprintf('NumPointsFile_(%i).txt', eqNumber)]);
    
    curtailmentPercentage(eqIndex) = round((numPoints - curtailedNumPoints)/ numPoints *100);
    fprintf('NumPoints were reduced from %i to %i (%i%% curtailment) \n', numPoints, curtailedNumPoints, curtailmentPercentage(eqIndex));
    fprintf('---------------------------------------------- \n');
   
end

    case '9d.curtailGroundMotionBasedOnPGAForMumbai2602p56'
        %% 
% This saves the files in H:\PrakRuns just to be cautious, I am not pasting these values in final directory.
eqNumberLIST_forProcessing_SetC = [120111, 120112, 120121, 120122,	120411, 120412,	120521, 120522,	120611, 120612,	120621, 120622,	120711, 120712,	120721, 120722,	120811, 120812,	120821, 120822,	120911, 120912,	120921, 120922,	121011, 121012,	121021, 121022,	121111, 121112,	121211, 121212,	121221, 121222,	121321, 121322,	121411, 121412,	121421, 121422,	121511, 121512,	121711, 121712];
eqNumberLIST_forProcessing_SetD = [120111	120112	120121	120122	120131	120132	120141	120142	120151	120152	120161	120162	120411	120412	120521	120522	120611	120612	120621	120622	120631	120632	120641	120642	120711	120712	120721	120722	120731	120732	120741	120742	120811	120812	120821	120822	120911	120912	120921	120922	120931	120932	121011	121012	121021	121022	121031	121032	121041	121042	121051	121052	121061	121062	121111	121112	121211	121212	121221	121222	121231	121232	121321	121322	121411	121412	121421	121422	121431	121432	121441	121442	121451	121452	121461	121462	121511	121512	121711	121712];

eqNumberLIST_forProcessing_SetMumbai245 = [6000701	6000702	6002501	6002502	6006801	6006802	6008001	6008002	6008101	6008102	6016601	6016602	6023001	6023002	6023201	6023202	6024601	6024602	6028901	6028902	6030301	6030302	6031001	6031002	6031201	6031202	6032501	6032502	6032801	6032802	6033401	6033402	6034001	6034002	6035401	6035402	6047801	6047802	6049501	6049502	6052901	6052902	6053801	6053802	6054301	6054302	6057001	6057002	6057201	6057202	6057401	6057402	6057901	6057902	6061401	6061402	6063801	6063802	6064101	6064102	6067601	6067602	6072601	6072602	6074601	6074602	6078201	6078202	6079401	6079402	6079701	6079702	6080601	6080602	6081301	6081302	6081601	6081602	6086201	6086202	6088601	6088602	6091001	6091002	6091801	6091802	6092001	6092002	6092101	6092102	6092301	6092302	6092601	6092602	6092901	6092902	6093101	6093102	6093201	6093202	6094101	6094102	6094201	6094202	6094401	6094402	6095301	6095302	6095401	6095402	6095601	6095602	6095901	6095902	6096401	6096402	6096601	6096602	6097601	6097602	6097801	6097802	6097901	6097902	6098801	6098802	6099301	6099302	6099801	6099802	6100401	6100402	6100801	6100802	6101101	6101102	6102001	6102002	6102301	6102302	6103801	6103802	6104201	6104202	6104601	6104602	6104701	6104702	6104901	6104902	6105601	6105602	6105701	6105702	6106501	6106502	6107901	6107902	6108201	6108202	6108701	6108702	6109901	6109902	6110201	6110202	6110501	6110502	6114401	6114402	6115801	6115802	6117201	6117202	6119101	6119102	6119301	6119302	6121801	6121802	6122101	6122102	6122401	6122402	6123001	6123002	6124901	6124902	6125801	6125802	6127201	6127202	6128101	6128102	6128601	6128602	6128901	6128902	6130301	6130302, ...
6136101	6136102	6138701	6138702	6143701	6143702	6147101	6147102	6151501	6151502	6151701	6151702	6152001	6152002	6152101	6152102	6156001	6156002	6158101	6158102	6159301	6159302	6160001	6160002	6160401	6160402	6160501	6160502	6164001	6164002	6164301	6164302	6168101	6168102	6175401	6175402	6176001	6176002	6178001	6178002	6178601	6178602	6180501	6180502	6180601	6180602	6181101	6181102	6182001	6182002	6182301	6182302	6182901	6182902	6183101	6183102	6183701	6183702	6199401	6199402	6199501	6199502	6199701	6199702	6200301	6200302	6209701	6209702	6210001	6210002	6211101	6211102	6211201	6211202	6222201	6222202	6225201	6225202	6225301	6225302	6228101	6228102	6228501	6228502	6228701	6228702	6235101	6235102	6237201	6237202	6238101	6238102	6239401	6239402	6239701	6239702	6241101	6241102	6241301	6241302	6245701	6245702	6246201	6246202	6246301	6246302	6248301	6248302	6249501	6249502	6250101	6250102	6257301	6257302	6259301	6259302	6259501	6259502	6261301	6261302	6262101	6262102	6262401	6262402	6263801	6263802	6264401	6264402	6266001	6266002	6269801	6269802	6271601	6271602	6271701	6271702	6273001	6273002	6275301	6275302	6278401	6278402	6278501	6278502	6280701	6280702	6282101	6282102	6286301	6286302	6286901	6286902	6287301	6287302	6287401	6287402	6288801	6288802	6293701	6293702	6293801	6293802	6294001	6294002	6294401	6294402	6294701	6294702	6294801	6294802	6294901	6294902	6296201	6296202	6297601	6297602	6298201	6298202	6298501	6298502	6299201	6299202	6299301	6299302	6299601	6299602	6302701	6302702	6305401	6305402	6306001	6306002	6306101	6306102	6306201	6306202	6307701	6307702	6308701	6308702, ...
6312001	6312002	6316701	6316702	6317401	6317402	6317501	6317502	6317701	6317702	6319701	6319702	6320301	6320302	6321301	6321302	6322101	6322102	6322501	6322502	6323201	6323202	6323301	6323302	6323801	6323802	6323901	6323902	6324801	6324802	6325301	6325302	6326401	6326402	6326701	6326702	6328301	6328302	6328401	6328402	6330501	6330502	6330601	6330602	6332001	6332002	6332601	6332602	6332701	6332702	6333201	6333202	6333301	6333302	6334101	6334102	6334201	6334202	6334901	6334902	6335001	6335002	6335101	6335102	6336901	6336902	6343901	6343902	6345601	6345602	6346101	6346102	6346401	6346402	6346501	6346502	6347101	6347102	6347501	6347502	6348601	6348602	6349501	6349502	6350801	6350802	6352701	6352702	6352901	6352902																																																																																																														];

eqNumberLIST_forProcessing_SetMumbai97 = [6152601	6152602	6245701	6245702	6045901	6045902	6182901	6182902	6160401	6160402	6262401	6262402	6349501	6349502	6104601	6104602	6333301	6333302	6000701	6000702	6288801	6288802	6248301	6248302	6334201	6334202	6105601	6105602	6163301	6163302	6108701	6108702	6032501	6032502	6088401	6088402	6035401	6035402	6263801	6263802	6094701	6094702	6199401	6199402	6136101	6136102	6321701	6321702	6158101	6158102	6092001	6092002	6110501	6110502	6321201	6321202	6064101	6064102	6091001	6091002	6236201	6236202	6138701	6138702	6262101	6262102	6002501	6002502	6128701	6128702	6302401	6302402	6104701	6104702	6298501	6298502	6103801	6103802	6282101	6282102	6278501	6278502	6111801	6111802	6031201	6031202	6156001	6156002	6100201	6100202	6028801	6028802	6026201	6026202	6128101	6128102	6079401	6079402	6079701	6079702	6094101	6094102	6332701	6332702	6035301	6035302	6057201	6057202	6149601	6149602	6329101	6329102	6229101	6229102	6239401	6239402	6211101	6211102	6321801	6321802	6123001	6123002	6092601	6092602	6107901	6107902	6125801	6125802	6006901	6006902	6293701	6293702	6023101	6023102	6228101	6228102	6263201	6263202	6151101	6151102	6300001	6300002	6163001	6163002	6325301	6325302	6323301	6323302	6199701	6199702	6305401	6305402	6091401	6091402	6134801	6134802	6351301	6351302	6148501	6148502	6151801	6151802	6259501	6259502	6110201	6110202	6317501	6317502	6281101	6281102	6079101	6079102	6297301	6297302	6211601	6211602	6240001	6240002	6095901	6095902	6031001	6031002	6346501	6346502	6347701	6347702	6323801	6323802	6257301	6257302	6023701	6023702	6072601	6072602];
eqNumberLIST_forProcessing_SetMumbai50Remaining = [6109301	6109302	6153801	6153802	6225501	6225502	6249201	6249202	6265801	6265802	6279701	6279702	6288701	6288702	6330901	6330902	6333101	6333102	6348201	6348202	6063401	6063402	6076101	6076102	6080701	6080702	6108601	6108602	6110601	6110602	6118701	6118702	6248501	6248502	6302301	6302302	6347001	6347002];

eqNumberLIST_forProcessing_SetMumbai22Remaining = [6018001	6018002	6032201	6032202	6034201	6034202	6055201	6055202	6096301	6096302	6151301	6151302	6159401	6159402	6265901	6265902	6279301	6279302	6280901	6280902];


newRSN260_dir1 = [6000901	6003801	6004001	6007701	6007801	6007901	6015401	6017201	6018701	6019201	6021001	6026901	6028601	6029201	6029501	6030001	6030201	6031401	6031901	6039101	6039201	6041401	6042501	6042801	6042901	6043101	6045301	6045601	6046801	6047001	6049201	6051001	6053001	6055001	6057301	6057501	6057701	6057801	6058401	6062401	6067401	6072001	6072101	6072401	6073501	6073701	6074201	6075401	6078601	6078901	6080001	6080201	6082501	6084301	6085401	6085901	6088201	6088301	6088501	6089701	6090901	6091901	6095801	6096801	6098501	6098601	6101501	6102401	6102601	6103401	6104801	6107401	6107701	6107801	6108001	6109001	6110001	6110101	6110701	6111601	6114501	6116601	6120401	6120801	6123401	6124801	6126501	6126901	6127301	6127701	6128801	6130001	6131201	6131701	6134401	6135201	6135501	6138301	6139001	6139101	6140401	6147001	6148301	6150401	6150901	6151201	6153501	6153901	6154501	6155701	6156501	6157001	6158801	6159201	6161101	6162201	6162601	6163401	6176201	6176801	6177501	6179101	6180901	6181601	6182101	6183501	6183601	6184001	6184101	6206801	6210401	6220801	6222101	6222301	6226601	6226701	6227001	6227901	6228401	6229201	6229301	6247701	6247801	6247901	6248201	6249801	6255901	6256901	6258701	6259201	6259901	6260001	6260501	6260801	6262601	6263401	6264601	6264701	6269601	6271801	6273301	6274001	6274201	6274301	6274401	6274801	6277001	6281001	6284501	6285001	6285201	6287701	6288601	6289501	6293901	6294501	6294601	6295101	6295201	6295301	6295601	6295801	6295901	6296001	6296101	6296401	6298801	6299001	6299401	6301101	6309801	6310201	6318701	6322201	6322301	6322401	6324501	6326001	6327101	6328501	6328801	6329201	6330201	6330301	6331301	6331401	6331501	6334801	6336701	6338101	6338201	6340001	6344201	6345501	6345901	6346301	6347201	6348001	6349101	6349201	6349601	6349701	6349801	6350101	6350901	6351101	6351401	6352501	6353901];
newRSN260_dir2 = [6000902	6003802	6004002	6007702	6007802	6007902	6015402	6017202	6018702	6019202	6021002	6026902	6028602	6029202	6029502	6030002	6030202	6031402	6031902	6039102	6039202	6041402	6042502	6042802	6042902	6043102	6045302	6045602	6046802	6047002	6049202	6051002	6053002	6055002	6057302	6057502	6057702	6057802	6058402	6062402	6067402	6072002	6072102	6072402	6073502	6073702	6074202	6075402	6078602	6078902	6080002	6080202	6082502	6084302	6085402	6085902	6088202	6088302	6088502	6089702	6090902	6091902	6095802	6096802	6098502	6098602	6101502	6102402	6102602	6103402	6104802	6107402	6107702	6107802	6108002	6109002	6110002	6110102	6110702	6111602	6114502	6116602	6120402	6120802	6123402	6124802	6126502	6126902	6127302	6127702	6128802	6130002	6131202	6131702	6134402	6135202	6135502	6138302	6139002	6139102	6140402	6147002	6148302	6150402	6150902	6151202	6153502	6153902	6154502	6155702	6156502	6157002	6158802	6159202	6161102	6162202	6162602	6163402	6176202	6176802	6177502	6179102	6180902	6181602	6182102	6183502	6183602	6184002	6184102	6206802	6210402	6220802	6222102	6222302	6226602	6226702	6227002	6227902	6228402	6229202	6229302	6247702	6247802	6247902	6248202	6249802	6255902	6256902	6258702	6259202	6259902	6260002	6260502	6260802	6262602	6263402	6264602	6264702	6269602	6271802	6273302	6274002	6274202	6274302	6274402	6274802	6277002	6281002	6284502	6285002	6285202	6287702	6288602	6289502	6293902	6294502	6294602	6295102	6295202	6295302	6295602	6295802	6295902	6296002	6296102	6296402	6298802	6299002	6299402	6301102	6309802	6310202	6318702	6322202	6322302	6322402	6324502	6326002	6327102	6328502	6328802	6329202	6330202	6330302	6331302	6331402	6331502	6334802	6336702	6338102	6338202	6340002	6344202	6345502	6345902	6346302	6347202	6348002	6349102	6349202	6349602	6349702	6349802	6350102	6350902	6351102	6351402	6352502	6353902];
for i = 1:length(newRSN260_dir1)
    eqNumLIST_forProc_SetMum250_2p56(1, 2*i - 1) = newRSN260_dir1(i);
    eqNumLIST_forProc_SetMum250_2p56(1, 2*i) = newRSN260_dir2(i);
end

%    eqLIST = eqNumberLIST_forProcessing_SetC;
%    eqLIST = eqNumberLIST_forProcessing_SetMumbai245;
%    eqLIST = eqNumberLIST_forProcessing_SetMumbai50Remaining;
%    eqLIST = eqNumberLIST_forProcessing_SetMumbai22Remaining;
   eqLIST = eqNumLIST_forProc_SetMum250_2p56;

   doPlot = 0; % 1- Plot. 0- don't plot. Use 1, ONLY when processing smaller number of EQs

cutOffFraction = 0.05; % this is the fraction of PGA, below which GM would be curtailed from tails (beginning and end)
minCurtailFraction = 0.05; % don't curtail the time history less than this fraction on either side.
                           % this is to avoid unnecessarily modifying time histories without much advantage.
  
MarkerTypeList={'r-','b--','k-.','g--','y..',[.5 .6 .7],[.8 .2 .6],}; % Cell array of 7 markers.
totNumOfEQs = length(eqLIST);
for eqIndex = 1:totNumOfEQs
    GMTimeHistory = []; % initiate everytime
    timeArray = [];
    
%     cd C:\OpenSeesProcessingFiles\EQs\ORIGINAL_TIME_HISTORIES
%     cd C:\OpenSeesProcessingFiles\EQs\Prak_Mumbai_GM_Sorted_Original
    cd C:\OpenSeesProcessingFiles\EQs\Prak_Mum_2p56_GM_Sorted_Original
    
%     locationToSaveTheFiles = 'H:\GMSelection\MUMBAI_SelectedGroundMotions\CurtailedTH1';
    locationToSaveTheFiles = 'H:\GMSelection\MUMBAI_SelectedGroundMotions\CurtailedTH_Mum2p56';
    
    eqNumber = eqLIST(eqIndex);

    dt = load(sprintf('DtFile_(%i).txt', eqNumber));
    numPoints = load(sprintf('NumPointsFile_(%i).txt', eqNumber));
    GMTimeHistory = load(sprintf('SortedEQFile_(%i).txt', eqNumber));
    timeArray = 0:dt:dt * (numPoints - 1);
    
    cutOffValue = cutOffFraction * max(abs(GMTimeHistory));

    if (doPlot == 1)
        figure(51) % random number to avoid possible conflict, just in case of some other existing figure
        plot(timeArray, GMTimeHistory, MarkerTypeList{eqIndex},'LineWidth',1.0); hold on; grid on;
        xlabel('Time (second) \rightarrow'); ylabel('Ground accelration (g) \rightarrow');
        % plot the cut off line
        plot(timeArray, cutOffValue * ones(length(timeArray), 1), 'k-', 'LineWidth', 1);
    end    

    fprintf('PGA for eqNum %i is %5.3f \n', eqNumber, max(GMTimeHistory));

% find the first time step when acceleration exceeds the cut-off value
    firstTimeIndexOfCurtailedGM = find(abs(GMTimeHistory) > cutOffValue, 1);
        
% find the last time step after which, acceleration does not exceed the cut-off value
    reversedGM = (fliplr(GMTimeHistory'))'; % transpose of left-to-right-flipped-transpose
    lastTimeIndexOfCurtailedGM = numPoints - find(abs(reversedGM) > cutOffValue, 1);

% If initial and final both curtailmenta are too small, don't do it. Continue to the next earthquake
    if ((firstTimeIndexOfCurtailedGM < minCurtailFraction * numPoints) && (lastTimeIndexOfCurtailedGM > (1 - minCurtailFraction) * numPoints))
        fprintf('Possible curtailment is too small on either sides. Hence, is not performed. \n');

        cd(locationToSaveTheFiles)
        save(sprintf('SortedEQFile_(%i).txt', eqNumber), 'GMTimeHistory', '-ascii');
        save(sprintf('NumPointsFile_(%i).txt', eqNumber), 'numPoints', '-ascii');
        disp(['Files saved as ', fullfile(pwd, sprintf('SortedEQFile_(%i).txt', eqNumber)), ' and ', sprintf('NumPointsFile_(%i).txt', eqNumber)]);
        fprintf('---------------------------------------------- \n');
        continue
    end
        
% During initial timeperiod, if reduction in GM duration is less than 5%, don't do it.
    if (firstTimeIndexOfCurtailedGM < minCurtailFraction * numPoints)
%         fprintf('First Time Index exceeding the cut-off is %i, this is less than %i (i.e. less than %i%% away from start of GM) \n hence, no curtailement from left side is done! \n', firstTimeIndexOfCurtailedGM, minCurtailFraction * numPoints, minCurtailFraction * 100);
        fprintf('--- No curtailment from Left side is done --- \t');
        firstTimeIndexOfCurtailedGM = 1;
    else
        firstTimeIndexOfCurtailedGM = firstTimeIndexOfCurtailedGM - round(0.01 * numPoints); % include some points even before cut off
        fprintf('--- %i%% curtailment from Left side is done --- \t', round((firstTimeIndexOfCurtailedGM / numPoints) * 100));
    end
    
% During final timeperiod, if reduction in GM duration is less than 5%, don't do it.
    if (lastTimeIndexOfCurtailedGM > (1 - minCurtailFraction) * numPoints)
%         fprintf('Last Time Index exceeding the cut-off is %i, this is more than %i (i.e. less than %i%% away from end of GM) \n hence, no curtailement from right side is done! \n', lastTimeIndexOfCurtailedGM, (1- minCurtailFraction) * numPoints, minCurtailFraction * 100);
        fprintf('--- No curtailment from Right side is done --- \n');
        lastTimeIndexOfCurtailedGM = numPoints;
    else
        lastTimeIndexOfCurtailedGM = lastTimeIndexOfCurtailedGM + round(0.01 * numPoints); % include some points even after cut off
        fprintf('--- %i%% curtailment from Right side is done --- \n', round(100 - (lastTimeIndexOfCurtailedGM / numPoints) * 100));
    end

    curtailedGMTimeHistory = GMTimeHistory(firstTimeIndexOfCurtailedGM:lastTimeIndexOfCurtailedGM);
    curtailedNumPoints = lastTimeIndexOfCurtailedGM - firstTimeIndexOfCurtailedGM + 1;
    curtailedTimeArray = 0:dt:dt * (curtailedNumPoints - 1);
    
    if (doPlot == 1)
        figure(52)
        plot(curtailedTimeArray, curtailedGMTimeHistory, MarkerTypeList{eqIndex},'LineWidth',1.0); hold on; grid on;
        xlabel('Time (second) \rightarrow'); ylabel('Ground accelration (g) \rightarrow');
    end
    
    cd(locationToSaveTheFiles)
    save(sprintf('SortedEQFile_(%i).txt', eqNumber), 'curtailedGMTimeHistory', '-ascii');
    save(sprintf('NumPointsFile_(%i).txt', eqNumber), 'curtailedNumPoints', '-ascii');
    disp(['Files saved as ', fullfile(pwd, sprintf('SortedEQFile_(%i).txt', eqNumber)), ' and ', sprintf('NumPointsFile_(%i).txt', eqNumber)]);
    
    curtailmentPercentage(eqIndex) = round((numPoints - curtailedNumPoints)/ numPoints *100);
    fprintf('NumPoints were reduced from %i to %i (%i%% curtailment) \n', numPoints, curtailedNumPoints, curtailmentPercentage(eqIndex));
    fprintf('---------------------------------------------- \n');
   
end
       
    case '10.extractMaxTolUsedOUT'   
%%        
cd H:\PrakRuns\Output\(CivilBldg_3story_ID9901_v.09_curtailedGMduration)_(AllVar)_(0.00)_(clough)
% cd H:\PrakRuns\Output\(CivilBldg_3story_ID9901_v.02_trying)_(AllVar)_(0.00)_(clough)
% cd H:\PrakRuns\Output\(CivilBldg_3story_ID9901_v.04_trying)_(AllVar)_(0.00)_(clough)
% cd H:\PrakRuns\Output\(CivilBldg_3story_ID9901_v.07_30damp_effectOfDamping)_(AllVar)_(0.00)_(clough)
% cd H:\PrakRuns\Output\(CivilBldg_3story_ID9901_v.06_10damp_effectOfDamping)_(AllVar)_(0.00)_(clough)
% cd H:\PrakRuns\Output\(CivilBldg_3story_ID9901_v.08_2damp_effectOfDamping)_(AllVar)_(0.00)_(clough)

eqNumberLIST_forProcessing_SetC = [120111, 120112, 120121, 120122,	120411, 120412,	120521, 120522,	120611, 120612,	120621, 120622,	120711, 120712,	120721, 120722,	120811, 120812,	120821, 120822,	120911, 120912,	120921, 120922,	121011, 121012,	121021, 121022,	121111, 121112,	121211, 121212,	121221, 121222,	121321, 121322,	121411, 121412,	121421, 121422,	121511, 121512,	121711, 121712];
eqNumLIST = eqNumberLIST_forProcessing_SetC;

buildingID = 9901; % used for naming the graph only
saInitial = 0.01; % very low value, to avoid prompting user for input every time
saFinal = 5.01; % very high value, to avoid prompting user for input every time
%%%%%%%%%%%%%%%%%%%%%%%%%% end of the input %%%%%%%%%%%%%%%%%%%%%%%%%% 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

for eqIndex = 1:length(eqNumLIST)
    currentEq = eqNumLIST(eqIndex);
    currentEqFolder = sprintf('EQ_%s', num2str(currentEq)); 
    cd(currentEqFolder)
    
    currentSa = saInitial; % initiate
    saIndex = 0; % counter of number of Sa Indices

% % Store Data for this one EQ
while currentSa <= saFinal %saIndex < 10 
    currentSaFolder = sprintf('Sa_%s', num2str(currentSa)); 
    if(~exist(currentSaFolder, 'dir'))
        currentSa = currentSa + 0.01;
        continue
    end
% % do following if the folder with Sa value exists
    saIndex = saIndex + 1;
    
    cd(currentSaFolder)
    cd RunInformation
    maxTolUsedOUT(eqIndex, saIndex) = load('maxTolUsedOUT.out');
    cd ..
    cd .. % back to the currentEqFolder. For processing next Sa

    currentSa = currentSa + 0.01;
end
    cd .. % back to specific output folder for processing next Eq
end

    case '10a.extractIsCollIsNonConvOUT'   
%%        
% cd H:\PrakRuns\Output\(CivilBldg_3story_ID9901_v.09_curtailedGMduration)_(AllVar)_(0.00)_(clough)
% cd I:\PrakRuns_I\Output\(ID2207_R5_7Story_v.07)_(AllVar)_(0.00)_(clough)
% cd I:\PrakRuns_I\Output\(ID2206_R3_7Story_v.05_ShearHingeModel1B_full)_(AllVar)_(0.00)_(clough)
% cd I:\PrakRuns_I\Output\(ID2206_R3_7Story_v.05_ShearHingeModel1C_full)_(AllVar)_(0.00)_(clough)
% cd I:\PrakRuns_I\Output\(ID2206_R3_7Story_v.05_ShearHingeModel1C_full_DamSt)_(AllVar)_(0.00)_(clough)
% cd I:\PrakRuns_I\Output\(ID2316_R3_7Story_v.01)_(AllVar)_(0.00)_(clough)OLD

cd I:\PrakRuns_I\Output\(ID2316_R3_7Story_TEMP)_(AllVar)_(0.00)_(clough)\


eqNumberLIST_forProcessing_SetC = [120111, 120112, 120121, 120122,	120411, 120412,	120521, 120522,	120611, 120612,	120621, 120622,	120711, 120712,	120721, 120722,	120811, 120812,	120821, 120822,	120911, 120912,	120921, 120922,	121011, 121012,	121021, 121022,	121111, 121112,	121211, 121212,	121221, 121222,	121321, 121322,	121411, 121412,	121421, 121422,	121511, 121512,	121711, 121712];
% eqNumLIST = eqNumberLIST_forProcessing_SetC;

eqNumLIST = 120111;

% eqNumLIST = [120521	120522	120721	120722	120912	120921	121022	121111];

% eqNumLIST = [120411	120412	120521	120522	120711	120712	120721	120722	120911	120912	120921	121111];
% eqNumLIST = [121112];

% eqNumLIST = [6002501];

buildingID = 2316; % used for naming the graph only
saInitial = 0.01; % very low value, to avoid prompting user for input every time
saFinal = 7.01; % very high value, to avoid prompting user for input every time
%%%%%%%%%%%%%%%%%%%%%%%%%% end of the input %%%%%%%%%%%%%%%%%%%%%%%%%% 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

for eqIndex = 1:length(eqNumLIST)
    currentEq = eqNumLIST(eqIndex);
    currentEqFolder = sprintf('EQ_%s', num2str(currentEq)); 
    cd(currentEqFolder)
    
    currentSa = saInitial; % initiate
    saIndex = 0; % counter of number of Sa Indices

% % Store Data for this one EQ
while currentSa <= saFinal %saIndex < 10 
    currentSaFolder = sprintf('Sa_%s', num2str(currentSa)); 
    if(~exist(currentSaFolder, 'dir'))
        currentSa = currentSa + 0.01;
        continue
    end
% % do following if the folder with Sa value exists
    saIndex = saIndex + 1;
    
    cd(currentSaFolder)
    cd RunInformation
%     maxTolUsedOUT(eqIndex, saIndex) = load('maxTolUsedOUT.out');
    isCollapsedForEachRunLIST(eqIndex, saIndex) = load('isCollapsedOUT.out');
    isNonConvForEachRunLIST(eqIndex, saIndex) = load('isNonConvOUT.out');
    saLevelForEachRunLIST(eqIndex, saIndex) = currentSa;
    cd ..
    cd .. % back to the currentEqFolder. For processing next Sa

    currentSa = currentSa + 0.01;
end
    cd .. % back to specific output folder for processing next Eq
end
% To differentiate the nonCollapse and COnverged cases from NOT-ANALYZED cases, equate them to -99 
    isCollapsedForEachRunLIST(saLevelForEachRunLIST == 0) = -99;
    isNonConvForEachRunLIST(saLevelForEachRunLIST == 0) = -99;
    eqNumLIST = eqNumLIST';

    case '11.PlotMPhiWithBackboneCurve'
%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%% DO NOT CHANGE THIS BLOCK IF BACKBONE CURVE IS NOT TO BE PLOTTED %%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
doPlotBackboneCurveAsWell = 1; % 1- Yes, plot. 0- No, don't plot.
backboneCurveToPlot = 'CreateIbarraMaterial	302021	55956830252.497	242839.2766	-242839.2766	1.206532735	0.057470341	-0.057470341	0.1	98.49657903	$c	$resStrRatio	$stiffFactor1	$stiffFactor2	3240';
% backboneCurveToPlot = 'CreateIbarraMaterial	303021	55956830252.497	279912.5624	-279912.5624	1.211465998	0.062093024	-0.062093024	0.1	103.1174271	$c	$resStrRatio	$stiffFactor1	$stiffFactor2	2840';
% backboneCurveToPlot = 'CreateIbarraMaterial	301021	85485403976.2832	309914.939	-309914.939	1.208480433	0.057709503	-0.057709503	0.1	105.7361377	$c	$resStrRatio	$stiffFactor1	$stiffFactor2	2400';


% backboneCurveToPlot = 'CreateIbarraMaterial	203012	152178184842.34	302646.5183	-274651.5568	1.22087264	0.053083736	-0.054915073	0.1	114.1000948	$c	$resStrRatio	$stiffFactor1	$stiffFactor2	8650';
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%% DO NOT CHANGE THIS BLOCK IF BACKBONE CURVE IS NOT TO BE PLOTTED %%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% cd('H:\PrakRuns\Output\(CivilBldg_3story_ID9901_v.09_curtailedGMduration)_(AllVar)_(0.00)_(clough)\EQ_120522\Sa_0.98\Elements\Joints');
cd('H:\PrakRuns\Output');
cd('(CivilBldg_3story_ID9901_v.10_5pcRayleighIn1stN3rdMode)_(AllVar)_(0.00)_(clough)');

% eqNum = 120122;
% saVal = 1.32;

eqNum = 121411;
saVal = 0.84;
cd(fullfile(sprintf('EQ_%i', eqNum), sprintf('Sa_%3.2f', saVal), 'Elements', 'Joints'));

Phifiles = {
    'Joint_ForceAndDef_40302.out'
%     'THEleLocalWithTime_30301.out'
    };  % x-axis entries. Names of the files M and Phi are symbolic
% a = {1, 1};    % Column number for the first set of files (X-axis file)
a = {1};

Mfiles = Phifiles; % often this is the case. If not, define below.

% Mfiles = {
%     'disp_5.out'
%     'disp_10.out'
%         };  % y-axis entries

    
% b = {2, 2};    % Column number for the second set of files (Y-axis file)
b = {6};

absol = 1;    % 0-absolute values to be plotted
              % 1-exact algebraic values to be plotted

legendLIST = {
%     'Moment-rotation history of top of the column at GF ($matTag = 302021)'
    'M-theta TH of right-to-left beam of 2nd floor GF (matTag = 203012)'
%         'Displacement of node 4 for 5% rayleigh damp'
%         'Displacement of node 4 for 10% rayleigh damp'
    };  % Used only for legend entries

facx = 1.0;   % factor to be multiplied to x-axis values
facy = 1.0/1000;   % factor to be multiplied to y-axis values

% Graph and Axes titles

strx = '\theta (radians) ';
stry = 'M (kN-m) ';
nameOfPlot = 'Moment-Rotation Hysterisis Curve';

% strx = 'Time(sec) \rightarrow';
% stry = 'Horiz accel of Node 3 (g) \rightarrow';
% nameOfPlot = 'Accel Response at node 3 and Input GM';

% strx = 'Time(sec) \rightarrow';
% stry = 'Displacement of Node 4 (mm) \rightarrow';
% nameOfPlot = 'Time history of displacement of node 4';
   
if (length(Mfiles) ~= length(Phifiles))
    error('MPhi:Unequal','Unequal number of inputs for M and Phi \n');
end
C = {'r','b','g','k','y',[.5 .6 .7],[.8 .2 .6],}; % Cell array of 7 colors.

for p = 1:length(Mfiles)
    Phi = load(Phifiles{p});
    M = load(Mfiles{p});
    % since filename is a cell, curly braces shall be used
    
cur = (Phi(:,a{p})); mom=M(:,b{p}); % Reading the input file, and taking absolute values
    
%      figure(p)       %COMMENT OUT THIS LINE TO PLOT ON THE SAME GRAPH
    
if absol == 0
plot([0; abs(facx * cur)], [0; abs(facy * mom)], '-', 'color', C{p}, 'LineWidth', 2); hold on;
elseif absol == 1
plot([0; facx * cur], [0; facy * mom], '-', 'color', C{p}, 'LineWidth', 2); hold on;
end

% plot(facx*cur,facy*mom,'-','color',C{p},'LineWidth',1,'Marker','.'); hold on;
% plot(x,x.^ii,'color',C{ii},'marker','o')
end
p=length(Mfiles);  % resetting the number of records to previous value.
        
%axis([T_min,T_max,0.001,3]);
hx = xlabel(strx);
hy = ylabel(stry); grid on;
htitle = title(nameOfPlot);
% legh = legend(legendLIST);
% str=sprintf('Velocity Response Spectrum (%4.3f damping) for %10s',zet, filename{p});
      

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%% BLOCK FOR PLOTTING BACKBONE CURVE STARTS FROM HERE %%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if (doPlotBackboneCurveAsWell == 1)
backboneCurveToPlot = strsplit(backboneCurveToPlot, '\t');

resStrRatio = 0.01;	% This is the residual strength ratio; this muct be non-zero or else we see a bug in the unloading/reloading stiffnesses
c =	1.0;	% Exponent for deterioration
stiffFactor1 = 11.0;
stiffFactor2 = 1.1;

EIeff = str2double(backboneCurveToPlot{3});
myPos = str2double(backboneCurveToPlot{4});
myNeg = str2double(backboneCurveToPlot{5});
mcOverMy = str2double(backboneCurveToPlot{6});
thetaCapPos = str2double(backboneCurveToPlot{7});
thetaCapNeg = str2double(backboneCurveToPlot{8});
thetaPC = str2double(backboneCurveToPlot{9});
lambda = str2double(backboneCurveToPlot{10});

eleLength = str2double(backboneCurveToPlot{15});

elstk =	stiffFactor1 * ((6 * EIeff) / eleLength);	% Initial elastic stiffness
alphaHardUnscaled = (((myPos * mcOverMy) - myPos)/(thetaCapPos)) / elstk;
alphaHardScaled	= alphaHardUnscaled * ((-stiffFactor2 * alphaHardUnscaled ) / (alphaHardUnscaled * (alphaHardUnscaled - stiffFactor2)));	% This altered the stiffness to account for the elastic element stiffness - see hand notes on 1-6-05
alphaCapUnscaled	= ((-myPos*mcOverMy)/(thetaPC)) / elstk;
alphaCapScaled	= alphaCapUnscaled * ((-stiffFactor2 * alphaCapUnscaled) / (alphaCapUnscaled * (alphaCapUnscaled - stiffFactor2)));	% This altered the stiffness to account for the elastic element stiffness - see hand notes on 1-6-05
lambdaA = 0; 							% No accelerated stiffness deterioration Strength
lambdaS = lambda * stiffFactor1;		
lambdaK = 0;							% No unloading stiffness deterioration because there is a bug in this portion of the model
lambdaD = lambda * stiffFactor1;		% Capping strength

% calculation of x-axis data

thetaYPos = myPos / elstk;
mCapPos = myPos * mcOverMy;
mResPos = myPos * resStrRatio;
thetaCPos = thetaYPos + (mCapPos - myPos) / (alphaHardScaled * elstk);
thetaRPos = thetaCPos + (mResPos - mCapPos) / (alphaCapScaled * elstk);
thetaUPos = thetaCPos + thetaPC;

thetaYNeg = myNeg / elstk;
mCapNeg = myNeg * mcOverMy;
mResNeg = myNeg * resStrRatio;
thetaCNeg = thetaYNeg + (mCapNeg - myNeg) / (alphaHardScaled * elstk);
thetaRNeg = thetaCNeg + (mResNeg - mCapNeg) / (alphaCapScaled * elstk);
thetaUNeg = thetaCNeg + (-thetaPC);

figure(1)

xData = [thetaUNeg, thetaRNeg, thetaCNeg, thetaYNeg, 0, thetaYPos, thetaCPos, thetaRPos, thetaUPos];
yData = [mResNeg, mResNeg, mCapNeg, myNeg, 0, myPos, mCapPos, mResPos, mResPos] / 1000;

pause(3)
plot(xData, yData, 'k--', 'LineWidth', 2);

strx = '\theta (radians) ';
stry = 'M (kN-m)';
strTitle = 'Moment-Rotation Hysterisis Curve';

legendLIST = [legendLIST 'Backbone Curve'];

hx = xlabel(strx); hy = ylabel(stry); grid on; htitle = title(strTitle); legh = legend(legendLIST);

psb_FigureFormatScript


end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%% BLOCK FOR PLOTTING BACKBONE CURVE ENDS HERE %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


psb_FigureFormatScript
    
    xlim([-0.025 0.025]);
    cd H:\PrakRuns\Output
    exportName = sprintf('hystereticCurve.emf');
    print('-dmeta', exportName);
cd(baseFolder)

    case '11a.PlotBackboneCurve'
%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%% DO NOT CHANGE THIS BLOCK IF BACKBONE CURVE IS NOT TO BE PLOTTED %%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
doPlotBackboneCurveAsWell = 1; % 1- Yes, plot. 0- No, don't plot.
% backboneCurveToPlot = 'CreateIbarraMaterial	302021	55956830252.497	242839.2766	-242839.2766	1.206532735	0.057470341	-0.057470341	0.1	98.49657903	$c	$resStrRatio	$stiffFactor1	$stiffFactor2	3240';

%% bldg ID- 2221
% backboneCurveToPlot = 'CreateIbarraMaterial	303011	35991288021.5809	430945.3942	-430945.3942	1.189495499	0.066401741	-0.066401741	0.1	94.48715052	$c	$resStrRatio	$stiffFactor1	$stiffFactor2	3150';
% backboneCurveToPlot = 'CreateIbarraMaterial	303021	82150823343.2928	635725.8419	-635725.8419	1.186615397	0.038273678	-0.038273678	0.1	89.66010705	$c	$resStrRatio	$stiffFactor1	$stiffFactor2	3150';

%% bldg ID- 2227
% backboneCurveToPlot = 'CreateIbarraMaterial	303011	35991288021.5809	464643.8094	-464643.8094	1.189495499	0.067203739	-0.067203739	0.1	94.48715052	$c	$resStrRatio	$stiffFactor1	$stiffFactor2	3150';
% backboneCurveToPlot = 'CreateIbarraMaterial	303021	82150823343.2928	644097.6414	-644097.6414	1.186615397	0.042995141	-0.042995141	0.1	89.48899956	$c	$resStrRatio	$stiffFactor1	$stiffFactor2	3150';

%% EXTERNAL COLUMNS
% backboneCurveToPlotLIST = {'CreateIbarraMaterial	303011	35991288021.5809	430945.3942	-430945.3942	1.189495499	0.066401741	-0.066401741	0.1	94.48715052	$c	$resStrRatio	$stiffFactor1	$stiffFactor2	3150',
% 'CreateIbarraMaterial	303011	35991288021.5809	464643.8094	-464643.8094	1.189495499	0.067203739	-0.067203739	0.1	94.48715052	$c	$resStrRatio	$stiffFactor1	$stiffFactor2	3150'};
% legendLIST = {'(2221) 3rd level EXT col', '(2227) 3rd level EXT col'};

%% INTERNAL COLUMNS
backboneCurveToPlotLIST = {'CreateIbarraMaterial	303021	82150823343.2928	635725.8419	-635725.8419	1.186615397	0.038273678	-0.038273678	0.1	89.66010705	$c	$resStrRatio	$stiffFactor1	$stiffFactor2	3150',
'CreateIbarraMaterial	303021	82150823343.2928	644097.6414	-644097.6414	1.186615397	0.042995141	-0.042995141	0.1	89.48899956	$c	$resStrRatio	$stiffFactor1	$stiffFactor2	3150'};
legendLIST = {'(2221) 3rd level INT col', '(2227) 3rd level INT col'};

% backboneCurveToPlot = 'CreateIbarraMaterial	203012	152178184842.34	302646.5183	-274651.5568	1.22087264	0.053083736	-0.054915073	0.1	114.1000948	$c	$resStrRatio	$stiffFactor1	$stiffFactor2	8650';
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%% BLOCK FOR PLOTTING BACKBONE CURVE STARTS FROM HERE %%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if (doPlotBackboneCurveAsWell == 1)
    
    for curveIndex = 1:length(backboneCurveToPlotLIST)
        backboneCurveToPlot = backboneCurveToPlotLIST{curveIndex, 1};
        
        backboneCurveToPlot = strsplit(backboneCurveToPlot, '\t');
        
        resStrRatio = 0.01;	% This is the residual strength ratio; this muct be non-zero or else we see a bug in the unloading/reloading stiffnesses
        c =	1.0;	% Exponent for deterioration
        stiffFactor1 = 11.0;
        stiffFactor2 = 1.1;
        
        EIeff = str2double(backboneCurveToPlot{3});
        myPos = str2double(backboneCurveToPlot{4});
        myNeg = str2double(backboneCurveToPlot{5});
        mcOverMy = str2double(backboneCurveToPlot{6});
        thetaCapPos = str2double(backboneCurveToPlot{7});
        thetaCapNeg = str2double(backboneCurveToPlot{8});
        thetaPC = str2double(backboneCurveToPlot{9});
        lambda = str2double(backboneCurveToPlot{10});
        
        eleLength = str2double(backboneCurveToPlot{15});
        
        elstk =	stiffFactor1 * ((6 * EIeff) / eleLength);	% Initial elastic stiffness
        alphaHardUnscaled = (((myPos * mcOverMy) - myPos)/(thetaCapPos)) / elstk;
        alphaHardScaled	= alphaHardUnscaled * ((-stiffFactor2 * alphaHardUnscaled ) / (alphaHardUnscaled * (alphaHardUnscaled - stiffFactor2)));	% This altered the stiffness to account for the elastic element stiffness - see hand notes on 1-6-05
        alphaCapUnscaled	= ((-myPos*mcOverMy)/(thetaPC)) / elstk;
        alphaCapScaled	= alphaCapUnscaled * ((-stiffFactor2 * alphaCapUnscaled) / (alphaCapUnscaled * (alphaCapUnscaled - stiffFactor2)));	% This altered the stiffness to account for the elastic element stiffness - see hand notes on 1-6-05
        lambdaA = 0; 							% No accelerated stiffness deterioration Strength
        lambdaS = lambda * stiffFactor1;
        lambdaK = 0;							% No unloading stiffness deterioration because there is a bug in this portion of the model
        lambdaD = lambda * stiffFactor1;		% Capping strength
        
        % calculation of x-axis data
        
        thetaYPos = myPos / elstk;
        mCapPos = myPos * mcOverMy;
        mResPos = myPos * resStrRatio;
        thetaCPos = thetaYPos + (mCapPos - myPos) / (alphaHardScaled * elstk);
        thetaRPos = thetaCPos + (mResPos - mCapPos) / (alphaCapScaled * elstk);
        thetaUPos = thetaCPos + thetaPC;
        
        thetaYNeg = myNeg / elstk;
        mCapNeg = myNeg * mcOverMy;
        mResNeg = myNeg * resStrRatio;
        thetaCNeg = thetaYNeg + (mCapNeg - myNeg) / (alphaHardScaled * elstk);
        thetaRNeg = thetaCNeg + (mResNeg - mCapNeg) / (alphaCapScaled * elstk);
        thetaUNeg = thetaCNeg + (-thetaPC);
        
%         figure(1)
        
        xData = [thetaUNeg, thetaRNeg, thetaCNeg, thetaYNeg, 0, thetaYPos, thetaCPos, thetaRPos, thetaUPos];
        yData = [mResNeg, mResNeg, mCapNeg, myNeg, 0, myPos, mCapPos, mResPos, mResPos] / 1000;
        
        
        lineColors = repmat({'r','b','g','k','y',[.5 .6 .7],'m'}, [1 4]); % Cell array of 28 colors.
        lineStyles = repmat({'-','--', '-.', ':', '-','--', '-.', ':', '-','--', '-.', ':'}, [1 4]);
        markers = repmat({''}, [1 28]);
        currentPlotStyle = [lineColors{curveIndex} lineStyles{curveIndex} markers{curveIndex}];
        
        % pause(3)
        plot(xData, yData, currentPlotStyle, 'LineWidth', 2); hold on;
    end
legh = legend(legendLIST, 'Location', 'SouthEast');
% legend(legendLIST, 'Location', 'SouthEast');
    
strx = '\theta (radians) ';
stry = 'M (kN-m)';
strTitle = 'Moment-Rotation Backbone Curve';

hx = xlabel(strx); hy = ylabel(stry); grid on; htitle = title(strTitle); 

% psb_FigureFormatScript
psb_FigureFormatScript_forReport

end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%% BLOCK FOR PLOTTING BACKBONE CURVE ENDS HERE %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


psb_FigureFormatScript
    
%     xlim([-0.025 0.025]);

%     cd H:\PrakRuns\Output
    cd I:\PrakRuns_I\Output\(ID2227_R5_4Story_v.02)_(AllVar)_(0.00)_(clough)
    exportName = sprintf('backboneCurves_2221_2227_EXT_3rdLevel.emf');
    print('-dmeta', exportName);
    
    
cd(baseFolder)

    case '12.PlotGeneralMPhi'
%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%% DO NOT CHANGE THIS BLOCK IF BACKBONE CURVE IS NOT TO BE PLOTTED %%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
doPlotBackboneCurveAsWell = 0; % 1- Yes, plot. 0- No, don't plot.
backboneCurveToPlot = 'CreateIbarraMaterial	302021	55956830252.497	242839.2766	-242839.2766	1.206532735	0.057470341	-0.057470341	0.1	98.49657903	$c	$resStrRatio	$stiffFactor1	$stiffFactor2	3240';
% backboneCurveToPlot = 'CreateIbarraMaterial	303021	55956830252.497	279912.5624	-279912.5624	1.211465998	0.062093024	-0.062093024	0.1	103.1174271	$c	$resStrRatio	$stiffFactor1	$stiffFactor2	2840';

% backboneCurveToPlot = 'CreateIbarraMaterial	203012	152178184842.34	302646.5183	-274651.5568	1.22087264	0.053083736	-0.054915073	0.1	114.1000948	$c	$resStrRatio	$stiffFactor1	$stiffFactor2	8650';
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%% DO NOT CHANGE THIS BLOCK IF BACKBONE CURVE IS NOT TO BE PLOTTED %%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% cd('H:\PrakRuns\Output\(CivilBldg_3story_ID9901_v.09_curtailedGMduration)_(AllVar)_(0.00)_(clough)\EQ_120522\Sa_0.98\Elements\Joints');
% cd('H:\PrakRuns\Output');
% cd('(CivilBldg_3story_ID9901_v.10_5pcRayleighIn1stN3rdMode)_(AllVar)_(0.00)_(clough)');

% cd('(ID2221_R5_4Story_v.02)_(AllVar)_(0.00)_(clough)');

% cd('I:\PrakRuns_I\Output\(psb_RunSingleInelasticDynamicAnalysis_2316)_(AllVar)_(0.00)_(clough)\EQ_120111');

% cd('I:\PrakRuns_I\Output\(ID2316_R3_7Story_TEMP)_(AllVar)_(0.00)_(clough)');

% cd I:\PrakRuns_I\Output\(psb_RunSingleInelasticDynamicAnalysis_2316_autoChangeOfDt_TRYING)_(AllVar)_(0.00)_(clough)\EQ_120111
% cd I:\PrakRuns_I\Output\(psb_RunSingleInelasticDynamicAnalysis_2316_autoChangeOfDt_WORKS)_(AllVar)_(0.00)_(clough)\EQ_120111

cd('I:\PrakRuns_I\Output')

% eqNum = 121111;
% saVal = 1.02;
% cd(fullfile(sprintf('EQ_%i', eqNum), sprintf('Sa_%3.2f', saVal), 'Elements', 'Joints'));

Phifiles = {
%     'Sa_0.11_dtBy2\Nodes\DisplTH\THNodeDispl_208013.out'
%     'Sa_0.11_dtBy5\Nodes\DisplTH\THNodeDispl_208013.out'
%     'Sa_0.11_dtBy10\Nodes\DisplTH\THNodeDispl_208013.out'
%     'Sa_0.11_dtBy20\Nodes\DisplTH\THNodeDispl_208013.out'
%     'Sa_0.11_dtBy50\Nodes\DisplTH\THNodeDispl_208013.out'

%     'EQ_120111_v1_withAutoDtChange\Sa_3.16\Nodes\DisplTH\THNodeDispl_208013.out'
%     'EQ_120111\Sa_3.16\Nodes\DisplTH\THNodeDispl_208013.out'
%     (psb_RunSingleInelasticDynamicAnalysis_2316)_(AllVar)_(0.00)_(clough)\EQ_120111
%     '(psb_RunSingleInelasticDynamicAnalysis_2316_internalDtChangeTRYING)_(AllVar)_(0.00)_(clough)\EQ_120111\Sa_0.11\Nodes\DisplTH\THNodeDispl_208013.out'
%     '(psb_RunSingleInelasticDynamicAnalysis_2316_internalDtChangeTRYING_v2)_(AllVar)_(0.00)_(clough)\EQ_120111\Sa_0.11\Nodes\DisplTH\THNodeDispl_208013.out'


%     '(psb_RunSingleInelasticDynamicAnalysis_2316)_(AllVar)_(0.00)_(clough)\EQ_120111\Sa_0.11_dtBy2\Nodes\DisplTH\THNodeDispl_208013.out'
%     '(psb_RunSingleInelasticDynamicAnalysis_2316)_(AllVar)_(0.00)_(clough)\EQ_120111\Sa_0.11_dtBy10\Nodes\DisplTH\THNodeDispl_208013.out'
%     '(psb_RunSingleInelasticDynamicAnalysis_2316_internalDtChangeTRYING_v3)_(AllVar)_(0.00)_(clough)\EQ_120111\Sa_0.11\Nodes\DisplTH\THNodeDispl_208013.out'
    
    
%     '(ID2316_R3_7Story_TEMP)_(AllVar)_(0.00)_(clough)\EQ_120111\Sa_3.11\Nodes\DisplTH\THNodeDispl_208013.out'
%     '(psb_RunSingleInelasticDynamicAnalysis_2316_internalDtChangeTRYING_v3)_(AllVar)_(0.00)_(clough)\EQ_120111\Sa_3.11\Nodes\DisplTH\THNodeDispl_208013.out'
    
    
%     '(ID2316_R3_7Story_TEMP)_(AllVar)_(0.00)_(clough)\EQ_120111_v1_withAutoDtChange\Sa_2.81\Nodes\DisplTH\THNodeDispl_208013.out'
%     '(psb_RunSingleInelasticDynamicAnalysis_2316_internalDtChangeTRYING_v3)_(AllVar)_(0.00)_(clough)\EQ_120111\Sa_2.81\Nodes\DisplTH\THNodeDispl_208013.out'
   
 %   '(ID2316_R3_7Story_TEMP)_(AllVar)_(0.00)_(clough)\EQ_120111_v1_withAutoDtChange\Sa_1.61\Nodes\DisplTH\THNodeDispl_208013.out'
 %   '(psb_RunSingleInelasticDynamicAnalysis_2316_internalDtChangeTRYING_v3)_(AllVar)_(0.00)_(clough)\EQ_120111\Sa_1.61\Nodes\DisplTH\THNodeDispl_208013.out'
    
%     '(ID2316_R3_7Story_TEMP)_(AllVar)_(0.00)_(clough)\EQ_120111_v1_withAutoDtChange\Sa_2.81\Nodes\DisplTH\THNodeDispl_208013.out'
%     '(ID2316_R3_7Story_v.01_adaptiveDt)_(AllVar)_(0.00)_(clough)\EQ_120111\Sa_2.81\Nodes\DisplTH\THNodeDispl_208013.out'
    
    
    '(ID2316_R3_7Story_v.01_adaptiveDt)_(AllVar)_(0.00)_(clough)\EQ_120921\Sa_0.11\Nodes\DisplTH\THNodeDispl_208013.out'
    
%     'Sa_0.41_dtBy2\Nodes\DisplTH\THNodeDispl_208013.out'
%     'Sa_0.41_dtBy5\Nodes\DisplTH\THNodeDispl_208013.out'
%     'Sa_0.41_dtBy10\Nodes\DisplTH\THNodeDispl_208013.out'
%     'Sa_0.41_dtBy20\Nodes\DisplTH\THNodeDispl_208013.out'

%     'Sa_1.31_dtBy10\Nodes\DisplTH\THNodeDispl_202013.out'
%     'Sa_1.31_dtBy20\Nodes\DisplTH\THNodeDispl_202013.out'
%     'Sa_1.32_dtBy10\Nodes\DisplTH\THNodeDispl_202013.out'
%     'Sa_1.32_dtBy20\Nodes\DisplTH\THNodeDispl_202013.out'    
    
    
    %     'Sa_0.11\Nodes\DisplTH\THNodeDispl_208013.out'
    
%     'THEleLocalWithTime_30301.out'
    };  % x-axis entries. Names of the files M and Phi are symbolic
% a = {1, 1};    % Column number for the first set of files (X-axis file)
a = {1, 1, 1, 1, 1};

Mfiles = Phifiles; % often this is the case. If not, define below.

% Mfiles = {
%     'disp_5.out'
%     'disp_10.out'
%         };  % y-axis entries

    
% b = {2, 2};    % Column number for the second set of files (Y-axis file)
b = {2, 2, 2, 2, 2};

absol = 1;    % 0-absolute values to be plotted
              % 1-exact algebraic values to be plotted

legendLIST = {
%     'Moment-rotation history of top of the column at GF ($matTag = 302021)'
%     'M-theta TH of right-to-left beam of 2nd floor GF (matTag = 203012)'
%         'Displacement of node 4 for 5% rayleigh damp'
%         'Displacement of node 4 for 10% rayleigh damp'

%         'Displacement of node 208013 for dt/2'
%         'Displacement of node 208013 for dt/5'
%         'Displacement of node 208013 for dt/10'
%         'Displacement of node 208013 for dt/20'
%         'Displacement of node 208013 for dt/50'
%         
%         'Analysis with $dt/2'
%         'Analysis with $dt/10'

%         'Old auto dt change code'
%         'New auto dt change code'

%         'Sa = 1.31g; dt_{ana} = dt/10'
%         'Sa = 1.31g; dt_{ana} = dt/20'
%         'Sa = 1.32g; dt_{ana} = dt/10'
%         'Sa = 1.32g; dt_{ana} = dt/20'
        
%         'Displacement of node 208013 for dt/50'

%         'Analysis with $dt/2'
%         'Analysis with $dt/10'
%         'Analysis with mixed $dt/2 & $dt/10'
%         'Analysis with mixed $dt/2 & $dt/5 _v03'
        
        'Analysis with $dt/10'
%         'Analysis with mixed $dt/2 & $dt/10'
        'Analysis with mixed $dt/2 & $dt/10 (internal auto dt change)'
        };  % Used only for legend entries

facx = 1.0;   % factor to be multiplied to x-axis values
facy = 1.0; %/1000;   % factor to be multiplied to y-axis values
% figure(7)
% Graph and Axes titles

% strx = '\theta (radians) \rightarrow';
% stry = 'M (kN-m) \rightarrow';
% nameOfPlot = 'Moment-rotation curve';

strx = 'Time (sec) \rightarrow';
stry = 'Displacement (mm) \rightarrow';
% nameOfPlot = 'Time history of top floor of BldgID 2316; EQ- 120111';
% nameOfPlot = 'Top floor disp. TH BldgID 2316; EQ- 120111';
nameOfPlot = 'Top floor disp. TH (BldgID 2316; EQ- NORTHR/MUL009; Sa- 2.81g)'; 
% nameOfPlot = 'Time history of top floor of BldgID 2316; EQ- 120111; Sa- 0.41g';

% strx = 'Time(sec) \rightarrow';
% stry = 'Horiz accel of Node 3 (g) \rightarrow';
% nameOfPlot = 'Accel Response at node 3 and Input GM';

% strx = 'Time(sec) \rightarrow';
% stry = 'Displacement of Node 4 (mm) \rightarrow';
% nameOfPlot = 'Time history of displacement of node 4';
   
if (length(Mfiles) ~= length(Phifiles))
    error('MPhi:Unequal','Unequal number of inputs for M and Phi \n');
end

% lineColors = {'b', 'r', 'k', 'g', 'y', 'b', 'r', 'k', 'g', 'y', 'b', 'r', 'k', 'g', 'y'};
lineColors = {'r','k','g','k','y',[.5 .6 .7],[.8 .2 .6]}; % Cell array of 7 colors.
lineStyles = {'-','--', '-.', ':', '-','--', '-.', ':', '-','--', '-.', ':'};
markers = {'','','','','','d','v','^','<','>','p','h','.',...
'+','*','o','x','^','<','h','.','>','p','s','d','v',...
'o','x','+','*','s','d','v','^','<','>','p','h','.'};
% markers = ['o','x','+','*','s','d','v','^','<','>','p','h','.',...
% '+','*','o','x','^','<','h','.','>','p','s','d','v',...
% 'o','x','+','*','s','d','v','^','<','>','p','h','.'];

for p = 1:length(Mfiles)
    Phi = load(Phifiles{p});
    M = load(Mfiles{p});
    % since filename is a cell, curly braces shall be used
    
    cur = (Phi(:,a{p})); mom=M(:,b{p}); % Reading the input file
    
    %      figure(p)       %COMMENT OUT THIS LINE TO PLOT ON THE SAME GRAPH
    currentPlotStyle = [lineColors{p} lineStyles{p} markers{p}];
    if absol == 0
        plot([0; abs(facx * cur)], [0; abs(facy * mom)], currentPlotStyle, 'LineWidth', 2); hold on;
    elseif absol == 1
        plot([0; (facx * cur)], [0; (facy * mom)], currentPlotStyle, 'LineWidth', 2); hold on;
    end
    % plot(facx*cur,facy*mom,'-','color',C{p},'LineWidth',1,'Marker','.'); hold on;
    % plot(x,x.^ii,'color',C{ii},'marker','o')
end

p=length(Mfiles);  % resetting the number of records to previous value.
        
%axis([T_min,T_max,0.001,3]);
hx = xlabel(strx);
hy = ylabel(stry); grid on;
htitle = title(nameOfPlot);
legh = legend(legendLIST);
% str=sprintf('Velocity Response Spectrum (%4.3f damping) for %10s',zet, filename{p});
      

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%% BLOCK FOR PLOTTING BACKBONE CURVE STARTS FROM HERE %%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if (doPlotBackboneCurveAsWell == 1)
backboneCurveToPlot = strsplit(backboneCurveToPlot, '\t');

resStrRatio = 0.01;	% This is the residual strength ratio; this muct be non-zero or else we see a bug in the unloading/reloading stiffnesses
c =	1.0;	% Exponent for deterioration
stiffFactor1 = 11.0;
stiffFactor2 = 1.1;

EIeff = str2double(backboneCurveToPlot{3});
myPos = str2double(backboneCurveToPlot{4});
myNeg = str2double(backboneCurveToPlot{5});
mcOverMy = str2double(backboneCurveToPlot{6});
thetaCapPos = str2double(backboneCurveToPlot{7});
thetaCapNeg = str2double(backboneCurveToPlot{8});
thetaPC = str2double(backboneCurveToPlot{9});
lambda = str2double(backboneCurveToPlot{10});

eleLength = str2double(backboneCurveToPlot{15});

elstk =	stiffFactor1 * ((6 * EIeff) / eleLength);	% Initial elastic stiffness
alphaHardUnscaled = (((myPos * mcOverMy) - myPos)/(thetaCapPos)) / elstk;
alphaHardScaled	= alphaHardUnscaled * ((-stiffFactor2 * alphaHardUnscaled ) / (alphaHardUnscaled * (alphaHardUnscaled - stiffFactor2)));	% This altered the stiffness to account for the elastic element stiffness - see hand notes on 1-6-05
alphaCapUnscaled	= ((-myPos*mcOverMy)/(thetaPC)) / elstk;
alphaCapScaled	= alphaCapUnscaled * ((-stiffFactor2 * alphaCapUnscaled) / (alphaCapUnscaled * (alphaCapUnscaled - stiffFactor2)));	% This altered the stiffness to account for the elastic element stiffness - see hand notes on 1-6-05
lambdaA = 0; 							% No accelerated stiffness deterioration Strength
lambdaS = lambda * stiffFactor1;		
lambdaK = 0;							% No unloading stiffness deterioration because there is a bug in this portion of the model
lambdaD = lambda * stiffFactor1;		% Capping strength

% calculation of x-axis data

thetaYPos = myPos / elstk;
mCapPos = myPos * mcOverMy;
mResPos = myPos * resStrRatio;
thetaCPos = thetaYPos + (mCapPos - myPos) / (alphaHardScaled * elstk);
thetaRPos = thetaCPos + (mResPos - mCapPos) / (alphaCapScaled * elstk);
thetaUPos = thetaCPos + thetaPC;

thetaYNeg = myNeg / elstk;
mCapNeg = myNeg * mcOverMy;
mResNeg = myNeg * resStrRatio;
thetaCNeg = thetaYNeg + (mCapNeg - myNeg) / (alphaHardScaled * elstk);
thetaRNeg = thetaCNeg + (mResNeg - mCapNeg) / (alphaCapScaled * elstk);
thetaUNeg = thetaCNeg + (-thetaPC);

figure(1)

xData = [thetaUNeg, thetaRNeg, thetaCNeg, thetaYNeg, 0, thetaYPos, thetaCPos, thetaRPos, thetaUPos];
yData = [mResNeg, mResNeg, mCapNeg, myNeg, 0, myPos, mCapPos, mResPos, mResPos] / 1000;

pause(1.5)
plot(xData, yData, 'k--', 'LineWidth', 2);

strx = '\theta (radians) \rightarrow';
stry = 'M (kN-m) \rightarrow';
strTitle = 'Moment-rotation curve';

legendLIST = [legendLIST 'Backbone Curve'];

hx = xlabel(strx); hy = ylabel(stry); grid on; htitle = title(strTitle); legh = legend(legendLIST);

psb_FigureFormatScript

end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%% BLOCK FOR PLOTTING BACKBONE CURVE ENDS HERE %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


psb_FigureFormatScript

    case '12a.PlotGeneralMPhiShearPanel'
%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%% DO NOT CHANGE THIS BLOCK IF BACKBONE CURVE IS NOT TO BE PLOTTED %%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
doPlotBackboneCurveAsWell = 0; % 1- Yes, plot. 0- No, don't plot.
% backboneCurveToPlot = 'CreateIbarraMaterial	302021	55956830252.497	242839.2766	-242839.2766	1.206532735	0.057470341	-0.057470341	0.1	98.49657903	$c	$resStrRatio	$stiffFactor1	$stiffFactor2	3240';
backboneCurveToPlot = 'CreateIbarraMaterial	40202	15287342475.9679	3057468.495	-3057468.495	1.25	0.004	-0.004	0.1	100	$c	$resStrRatio	$stiffFactor1	$stiffFactor2	650';
% backboneCurveToPlot = 'CreateIbarraMaterial	303021	55956830252.497	279912.5624	-279912.5624	1.211465998	0.062093024	-0.062093024	0.1	103.1174271	$c	$resStrRatio	$stiffFactor1	$stiffFactor2	2840';

% backboneCurveToPlot = 'CreateIbarraMaterial	203012	152178184842.34	302646.5183	-274651.5568	1.22087264	0.053083736	-0.054915073	0.1	114.1000948	$c	$resStrRatio	$stiffFactor1	$stiffFactor2	8650';
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%% DO NOT CHANGE THIS BLOCK IF BACKBONE CURVE IS NOT TO BE PLOTTED %%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% cd('H:\PrakRuns\Output\(CivilBldg_3story_ID9901_v.09_curtailedGMduration)_(AllVar)_(0.00)_(clough)\EQ_120522\Sa_0.98\Elements\Joints');
% cd('H:\PrakRuns\Output');
% cd('(CivilBldg_3story_ID9901_v.10_5pcRayleighIn1stN3rdMode)_(AllVar)_(0.00)_(clough)');

cd I:\PrakRuns_I\Output
cd('(ID2206_R3_7Story_v.04_HystereticShearPanelTryin)_(AllVar)_(0.00)_(clough)');

eqNum = 9991; %120122;
saVal = 0.00; %1.32;
cd(fullfile(sprintf('EQ_%i', eqNum), sprintf('Sa_%3.2f', saVal), 'Elements', 'Joints'));

Phifiles = {
    'Joint_ForceAndDef_40202.out'
%     'THEleLocalWithTime_30301.out'
    };  % x-axis entries. Names of the files M and Phi are symbolic
% a = {1, 1};    % Column number for the first set of files (X-axis file)
a = {5};

Mfiles = Phifiles; % often this is the case. If not, define below.
   
% b = {2, 2};    % Column number for the second set of files (Y-axis file)
b = {10};

absol = 0;    % 0-absolute values to be plotted
              % 1-exact algebraic values to be plotted

legendLIST = {
%     'Moment-rotation history of top of the column at GF ($matTag = 302021)'
%     'M-theta TH of right-to-left beam of 2nd floor GF (matTag = 203012)'
    'V_M-gamma of joint ID 203012'
%         'Displacement of node 4 for 5% rayleigh damp'
%         'Displacement of node 4 for 10% rayleigh damp'
    };  % Used only for legend entries

facx = 1.0;   % factor to be multiplied to x-axis values
facy = 1.0/1000;   % factor to be multiplied to y-axis values

% Graph and Axes titles

strx = '\theta (radians) \rightarrow';
stry = 'M (kN-m) \rightarrow';
nameOfPlot = 'Moment-rotation curve';

% strx = 'Time(sec) \rightarrow';
% stry = 'Horiz accel of Node 3 (g) \rightarrow';
% nameOfPlot = 'Accel Response at node 3 and Input GM';

% strx = 'Time(sec) \rightarrow';
% stry = 'Displacement of Node 4 (mm) \rightarrow';
% nameOfPlot = 'Time history of displacement of node 4';
   
if (length(Mfiles) ~= length(Phifiles))
    error('MPhi:Unequal','Unequal number of inputs for M and Phi \n');
end

% lineColors = {'b', 'r', 'k', 'g', 'y', 'b', 'r', 'k', 'g', 'y', 'b', 'r', 'k', 'g', 'y'};
lineColors = {'r','b','g','k','y',[.5 .6 .7],[.8 .2 .6]}; % Cell array of 7 colors.
lineStyles = {'-','--', '-.', ':', '-','--', '-.', ':', '-','--', '-.', ':'};
markers = {'','','','*','s','d','v','^','<','>','p','h','.',...
'+','*','o','x','^','<','h','.','>','p','s','d','v',...
'o','x','+','*','s','d','v','^','<','>','p','h','.'};
% markers = ['o','x','+','*','s','d','v','^','<','>','p','h','.',...
% '+','*','o','x','^','<','h','.','>','p','s','d','v',...
% 'o','x','+','*','s','d','v','^','<','>','p','h','.'];

for p = 1:length(Mfiles)
    Phi = load(Phifiles{p});
    M = load(Mfiles{p});
    % since filename is a cell, curly braces shall be used
    
    cur = (Phi(:,a{p})); mom=M(:,b{p}); % Reading the input file
    
    %      figure(p)       %COMMENT OUT THIS LINE TO PLOT ON THE SAME GRAPH
    currentPlotStyle = [lineColors{p} lineStyles{p} markers{p}];
    if absol == 0
        plot([0; abs(facx * cur)], [0; abs(facy * mom)], currentPlotStyle, 'LineWidth', 2); hold on;
    elseif absol == 1
        plot([0; (facx * cur)], [0; (facy * mom)], currentPlotStyle, 'LineWidth', 2); hold on;
    end
end
p=length(Mfiles);  % resetting the number of records to previous value.
        
%axis([T_min,T_max,0.001,3]);
hx = xlabel(strx);
hy = ylabel(stry); grid on;
htitle = title(nameOfPlot);
legh = legend(legendLIST);
% str=sprintf('Velocity Response Spectrum (%4.3f damping) for %10s',zet, filename{p});
      

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%% BLOCK FOR PLOTTING BACKBONE CURVE STARTS FROM HERE %%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if (doPlotBackboneCurveAsWell == 1)
backboneCurveToPlot = strsplit(backboneCurveToPlot, '\t');

resStrRatio = 0.01;	% This is the residual strength ratio; this muct be non-zero or else we see a bug in the unloading/reloading stiffnesses
c =	1.0;	% Exponent for deterioration
stiffFactor1 = 11.0;
stiffFactor2 = 1.1;

EIeff = str2double(backboneCurveToPlot{3});
myPos = str2double(backboneCurveToPlot{4});
myNeg = str2double(backboneCurveToPlot{5});
mcOverMy = str2double(backboneCurveToPlot{6});
thetaCapPos = str2double(backboneCurveToPlot{7});
thetaCapNeg = str2double(backboneCurveToPlot{8});
thetaPC = str2double(backboneCurveToPlot{9});
lambda = str2double(backboneCurveToPlot{10});

eleLength = str2double(backboneCurveToPlot{15});

elstk =	stiffFactor1 * ((6 * EIeff) / eleLength);	% Initial elastic stiffness
alphaHardUnscaled = (((myPos * mcOverMy) - myPos)/(thetaCapPos)) / elstk;
alphaHardScaled	= alphaHardUnscaled * ((-stiffFactor2 * alphaHardUnscaled ) / (alphaHardUnscaled * (alphaHardUnscaled - stiffFactor2)));	% This altered the stiffness to account for the elastic element stiffness - see hand notes on 1-6-05
alphaCapUnscaled	= ((-myPos*mcOverMy)/(thetaPC)) / elstk;
alphaCapScaled	= alphaCapUnscaled * ((-stiffFactor2 * alphaCapUnscaled) / (alphaCapUnscaled * (alphaCapUnscaled - stiffFactor2)));	% This altered the stiffness to account for the elastic element stiffness - see hand notes on 1-6-05
lambdaA = 0; 							% No accelerated stiffness deterioration Strength
lambdaS = lambda * stiffFactor1;		
lambdaK = 0;							% No unloading stiffness deterioration because there is a bug in this portion of the model
lambdaD = lambda * stiffFactor1;		% Capping strength

% calculation of x-axis data

thetaYPos = myPos / elstk;
mCapPos = myPos * mcOverMy;
mResPos = myPos * resStrRatio;
thetaCPos = thetaYPos + (mCapPos - myPos) / (alphaHardScaled * elstk);
thetaRPos = thetaCPos + (mResPos - mCapPos) / (alphaCapScaled * elstk);
thetaUPos = thetaCPos + thetaPC;

thetaYNeg = myNeg / elstk;
mCapNeg = myNeg * mcOverMy;
mResNeg = myNeg * resStrRatio;
thetaCNeg = thetaYNeg + (mCapNeg - myNeg) / (alphaHardScaled * elstk);
thetaRNeg = thetaCNeg + (mResNeg - mCapNeg) / (alphaCapScaled * elstk);
thetaUNeg = thetaCNeg + (-thetaPC);

figure(1)

xData = [thetaUNeg, thetaRNeg, thetaCNeg, thetaYNeg, 0, thetaYPos, thetaCPos, thetaRPos, thetaUPos];
yData = [mResNeg, mResNeg, mCapNeg, myNeg, 0, myPos, mCapPos, mResPos, mResPos] / 1000;

pause(1.5)
plot(xData, yData, 'k--', 'LineWidth', 2);

strx = '\theta (radians) \rightarrow';
stry = 'M (kN-m) \rightarrow';
strTitle = 'Moment-rotation curve';

legendLIST = [legendLIST 'Backbone Curve'];

hx = xlabel(strx); hy = ylabel(stry); grid on; htitle = title(strTitle); legh = legend(legendLIST);

psb_FigureFormatScript

end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%% BLOCK FOR PLOTTING BACKBONE CURVE ENDS HERE %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


psb_FigureFormatScript

    case '12b.PlotGeneralMPhiLimitStateCurve'
%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%% DO NOT CHANGE THIS BLOCK IF BACKBONE CURVE IS NOT TO BE PLOTTED %%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
doPlotBackboneCurveAsWell = 0; % 1- Yes, plot. 0- No, don't plot.
% backboneCurveToPlot = 'CreateIbarraMaterial	302021	55956830252.497	242839.2766	-242839.2766	1.206532735	0.057470341	-0.057470341	0.1	98.49657903	$c	$resStrRatio	$stiffFactor1	$stiffFactor2	3240';
backboneCurveToPlot = 'CreateIbarraMaterial	40202	15287342475.9679	3057468.495	-3057468.495	1.25	0.004	-0.004	0.1	100	$c	$resStrRatio	$stiffFactor1	$stiffFactor2	650';
% backboneCurveToPlot = 'CreateIbarraMaterial	303021	55956830252.497	279912.5624	-279912.5624	1.211465998	0.062093024	-0.062093024	0.1	103.1174271	$c	$resStrRatio	$stiffFactor1	$stiffFactor2	2840';

% backboneCurveToPlot = 'CreateIbarraMaterial	203012	152178184842.34	302646.5183	-274651.5568	1.22087264	0.053083736	-0.054915073	0.1	114.1000948	$c	$resStrRatio	$stiffFactor1	$stiffFactor2	8650';
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%% DO NOT CHANGE THIS BLOCK IF BACKBONE CURVE IS NOT TO BE PLOTTED %%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% cd('H:\PrakRuns\Output\(CivilBldg_3story_ID9901_v.09_curtailedGMduration)_(AllVar)_(0.00)_(clough)\EQ_120522\Sa_0.98\Elements\Joints');
% cd('H:\PrakRuns\Output');
% cd('(CivilBldg_3story_ID9901_v.10_5pcRayleighIn1stN3rdMode)_(AllVar)_(0.00)_(clough)');

cd I:\LimitStateMaterial\PushoverAnalysis
% cd Analysis_LimitStateMaterial(Load)-Pushover_40kipAxial
% cd Analysis_LimitStateMaterial(Load)-Pushover_70kipAxial
% cd Analysis_LimitStateMaterial(Load)-Pushover_100kipAxial

% eqNum = 9991; %120122;
% saVal = 0.00; %1.32;
% cd(fullfile(sprintf('EQ_%i', eqNum), sprintf('Sa_%3.2f', saVal), 'Elements', 'Joints'));

span = 58;

Phifiles = {
    'Analysis_LimitStateMaterial(Load)-Pushover_40kipAxial\node4DispX.out'
    'Analysis_LimitStateMaterial(Load)-Pushover_70kipAxial\node4DispX.out'
    'Analysis_LimitStateMaterial(Load)-Pushover_100kipAxial\node4DispX.out'
           };  % x-axis entries. Names of the files M and Phi are symbolic
% a = {1, 1};    % Column number for the first set of files (X-axis file)
a = {2, 2, 2};

% Mfiles = Phifiles; % often this is the case. If not, define below.

Mfiles = {
    % force along global X direction is shear in the element
    'Analysis_LimitStateMaterial(Load)-Pushover_40kipAxial\eleforcebasic.out' 
    'Analysis_LimitStateMaterial(Load)-Pushover_70kipAxial\eleforcebasic.out' 
    'Analysis_LimitStateMaterial(Load)-Pushover_100kipAxial\eleforcebasic.out' 
        };  % y-axis entries
% b = {2, 2};    % Column number for the second set of files (Y-axis file)
b = {2, 2, 2};

absol = 0;    % 0-absolute values to be plotted
              % 1-exact algebraic values to be plotted

legendLIST = {
%     'Axial force-Lateral deformation'
    'P = 40 kip'
    'P = 70 kip'
    'P = 100 kip'
%     'Moment-rotation history of top of the column at GF ($matTag = 302021)'
%     'M-theta TH of right-to-left beam of 2nd floor GF (matTag = 203012)'
%     'V_M-gamma of joint ID 203012'
%         'Displacement of node 4 for 5% rayleigh damp'
%         'Displacement of node 4 for 10% rayleigh damp'
    };  % Used only for legend entries

facx = 1.0/span;   % factor to be multiplied to x-axis values
facy = 1.0;%/1000;   % factor to be multiplied to y-axis values

% Graph and Axes titles

strx = 'Drift ratio';
stry = 'Base Shear (kips)';
nameOfPlot = 'Base Shear - drift';

% strx = '\theta (radians) \rightarrow';
% stry = 'M (kN-m) \rightarrow';
% nameOfPlot = 'Moment-rotation curve';

% strx = 'Time(sec) \rightarrow';
% stry = 'Horiz accel of Node 3 (g) \rightarrow';
% nameOfPlot = 'Accel Response at node 3 and Input GM';

% strx = 'Time(sec) \rightarrow';
% stry = 'Displacement of Node 4 (mm) \rightarrow';
% nameOfPlot = 'Time history of displacement of node 4';
   
if (length(Mfiles) ~= length(Phifiles))
    error('MPhi:Unequal','Unequal number of inputs for M and Phi \n');
end
% lineColors = {'b', 'r', 'k', 'g', 'y', 'b', 'r', 'k', 'g', 'y', 'b', 'r', 'k', 'g', 'y'};
lineColors = {'r','b','g','k','y',[.5 .6 .7],[.8 .2 .6]}; % Cell array of 7 colors.
lineStyles = {'-','--', '-.', ':', '-','--', '-.', ':', '-','--', '-.', ':'};
markers = {'','','','*','s','d','v','^','<','>','p','h','.',...
'+','*','o','x','^','<','h','.','>','p','s','d','v',...
'o','x','+','*','s','d','v','^','<','>','p','h','.'};
% markers = ['o','x','+','*','s','d','v','^','<','>','p','h','.',...
% '+','*','o','x','^','<','h','.','>','p','s','d','v',...
% 'o','x','+','*','s','d','v','^','<','>','p','h','.'];

for p = 1:length(Mfiles)
    Phi = load(Phifiles{p});
    M = load(Mfiles{p}); % since filename is a cell, curly braces shall be used
    
    cur = (Phi(:,a{p})); mom=M(:,b{p}); % Reading the input file
%     figure(p)       % Uncomment to have separate plots
    currentPlotStyle = [lineColors{p} lineStyles{p} markers{p}];
    if absol == 0
        plot([0; abs(facx * cur)], [0; abs(facy * mom)], currentPlotStyle, 'LineWidth', 2); hold on;
    elseif absol == 1
        plot([0; (facx * cur)], [0; (facy * mom)], currentPlotStyle, 'LineWidth', 2); hold on;
    end
end

p=length(Mfiles);  % resetting the number of records to previous value.
        
%axis([T_min,T_max,0.001,3]);
hx = xlabel(strx);
hy = ylabel(stry); grid on;
htitle = title(nameOfPlot);
legh = legend(legendLIST);
% str=sprintf('Velocity Response Spectrum (%4.3f damping) for %10s',zet, filename{p});
xlim([0 0.06]);   
ylim([0 25]);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%% BLOCK FOR PLOTTING BACKBONE CURVE STARTS FROM HERE %%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if (doPlotBackboneCurveAsWell == 1)
backboneCurveToPlot = strsplit(backboneCurveToPlot, '\t');

resStrRatio = 0.01;	% This is the residual strength ratio; this muct be non-zero or else we see a bug in the unloading/reloading stiffnesses
c =	1.0;	% Exponent for deterioration
stiffFactor1 = 11.0;
stiffFactor2 = 1.1;

EIeff = str2double(backboneCurveToPlot{3});
myPos = str2double(backboneCurveToPlot{4});
myNeg = str2double(backboneCurveToPlot{5});
mcOverMy = str2double(backboneCurveToPlot{6});
thetaCapPos = str2double(backboneCurveToPlot{7});
thetaCapNeg = str2double(backboneCurveToPlot{8});
thetaPC = str2double(backboneCurveToPlot{9});
lambda = str2double(backboneCurveToPlot{10});

eleLength = str2double(backboneCurveToPlot{15});

elstk =	stiffFactor1 * ((6 * EIeff) / eleLength);	% Initial elastic stiffness
alphaHardUnscaled = (((myPos * mcOverMy) - myPos)/(thetaCapPos)) / elstk;
alphaHardScaled	= alphaHardUnscaled * ((-stiffFactor2 * alphaHardUnscaled ) / (alphaHardUnscaled * (alphaHardUnscaled - stiffFactor2)));	% This altered the stiffness to account for the elastic element stiffness - see hand notes on 1-6-05
alphaCapUnscaled	= ((-myPos*mcOverMy)/(thetaPC)) / elstk;
alphaCapScaled	= alphaCapUnscaled * ((-stiffFactor2 * alphaCapUnscaled) / (alphaCapUnscaled * (alphaCapUnscaled - stiffFactor2)));	% This altered the stiffness to account for the elastic element stiffness - see hand notes on 1-6-05
lambdaA = 0; 							% No accelerated stiffness deterioration Strength
lambdaS = lambda * stiffFactor1;		
lambdaK = 0;							% No unloading stiffness deterioration because there is a bug in this portion of the model
lambdaD = lambda * stiffFactor1;		% Capping strength

% calculation of x-axis data

thetaYPos = myPos / elstk;
mCapPos = myPos * mcOverMy;
mResPos = myPos * resStrRatio;
thetaCPos = thetaYPos + (mCapPos - myPos) / (alphaHardScaled * elstk);
thetaRPos = thetaCPos + (mResPos - mCapPos) / (alphaCapScaled * elstk);
thetaUPos = thetaCPos + thetaPC;

thetaYNeg = myNeg / elstk;
mCapNeg = myNeg * mcOverMy;
mResNeg = myNeg * resStrRatio;
thetaCNeg = thetaYNeg + (mCapNeg - myNeg) / (alphaHardScaled * elstk);
thetaRNeg = thetaCNeg + (mResNeg - mCapNeg) / (alphaCapScaled * elstk);
thetaUNeg = thetaCNeg + (-thetaPC);

figure(1)

xData = [thetaUNeg, thetaRNeg, thetaCNeg, thetaYNeg, 0, thetaYPos, thetaCPos, thetaRPos, thetaUPos];
yData = [mResNeg, mResNeg, mCapNeg, myNeg, 0, myPos, mCapPos, mResPos, mResPos] / 1000;

pause(1.5)
plot(xData, yData, 'k--', 'LineWidth', 2);

strx = '\theta (radians) \rightarrow';
stry = 'M (kN-m) \rightarrow';
strTitle = 'Moment-rotation curve';

legendLIST = [legendLIST 'Backbone Curve'];

hx = xlabel(strx); hy = ylabel(stry); grid on; htitle = title(strTitle); legh = legend(legendLIST);

psb_FigureFormatScript

end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%% BLOCK FOR PLOTTING BACKBONE CURVE ENDS HERE %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


psb_FigureFormatScript

    case '12c.PlotGeneralMPhiLimitStateCurve_Axial'
%%

cd I:\LimitStateMaterial\PushoverAnalysis
% cd Analysis_LimitStateMaterial(Load)-Pushover_40kipAxial
% cd Analysis_LimitStateMaterial(Load)-Pushover_70kipAxial
% cd Analysis_LimitStateMaterial(Load)-Pushover_100kipAxial

% eqNum = 9991; %120122;
% saVal = 0.00; %1.32;
% cd(fullfile(sprintf('EQ_%i', eqNum), sprintf('Sa_%3.2f', saVal), 'Elements', 'Joints'));

span = 58;

Phifiles = {
    'Analysis_LimitStateMaterial(Load)-Pushover_40kipAxial\node4DispX.out'
    'Analysis_LimitStateMaterial(Load)-Pushover_70kipAxial\node4DispX.out'
    'Analysis_LimitStateMaterial(Load)-Pushover_100kipAxial\node4DispX.out'
           };  % x-axis entries. Names of the files M and Phi are symbolic
% a = {1, 1};    % Column number for the first set of files (X-axis file)
a = {2, 2, 2};

% Mfiles = Phifiles; % often this is the case. If not, define below.

Mfiles = {
    % force along global X direction is shear in the element
    'Analysis_LimitStateMaterial(Load)-Pushover_40kipAxial\eleforcebasic.out' 
    'Analysis_LimitStateMaterial(Load)-Pushover_70kipAxial\eleforcebasic.out' 
    'Analysis_LimitStateMaterial(Load)-Pushover_100kipAxial\eleforcebasic.out' 
        };  % y-axis entries
% b = {2, 2};    % Column number for the second set of files (Y-axis file)
% b = {2, 2, 2}; % force along global X axis, i.e. shear force in column
b = {3, 3, 3}; % force along global Y axis, i.e. axial force in column

absol = 0;    % 0-absolute values to be plotted
              % 1-exact algebraic values to be plotted

legendLIST = {
    'P = 40 kip'
    'P = 70 kip'
    'P = 100 kip'
    };  % Used only for legend entries

facx = 1.0/span;   % factor to be multiplied to x-axis values
facy = 1.0;%/1000;   % factor to be multiplied to y-axis values

% Graph and Axes titles

strx = 'Drift ratio';
stry = 'Axial load (kips)';
nameOfPlot = 'Axial load vs. Lateral drift';

   
if (length(Mfiles) ~= length(Phifiles))
    error('MPhi:Unequal','Unequal number of inputs for M and Phi \n');
end
% lineColors = {'b', 'r', 'k', 'g', 'y', 'b', 'r', 'k', 'g', 'y', 'b', 'r', 'k', 'g', 'y'};
lineColors = {'r','b','g','k','y',[.5 .6 .7],[.8 .2 .6]}; % Cell array of 7 colors.
lineStyles = {'-','--', '-.', ':', '-','--', '-.', ':', '-','--', '-.', ':'};
markers = {'','','','*','s','d','v','^','<','>','p','h','.',...
'+','*','o','x','^','<','h','.','>','p','s','d','v',...
'o','x','+','*','s','d','v','^','<','>','p','h','.'};
% markers = ['o','x','+','*','s','d','v','^','<','>','p','h','.',...
% '+','*','o','x','^','<','h','.','>','p','s','d','v',...
% 'o','x','+','*','s','d','v','^','<','>','p','h','.'];

for p = 1:length(Mfiles)
    Phi = load(Phifiles{p});
    M = load(Mfiles{p}); % since filename is a cell, curly braces shall be used
    
    cur = (Phi(:,a{p})); mom=M(:,b{p}); % Reading the input file
%     figure(p)       % Uncomment to have separate plots
    currentPlotStyle = [lineColors{p} lineStyles{p} markers{p}];
    
%     plotName = sprintf('h%i', length(Mfiles)+p);
    if absol == 0
        plotHandle(p) = plot([0; abs(facx * cur)], [0; abs(facy * mom)], currentPlotStyle, 'LineWidth', 2); hold on;
    elseif absol == 1
        plotHandle(p) = plot([0; (facx * cur)], [0; (facy * mom)], currentPlotStyle, 'LineWidth', 2); hold on;
    end
end

p=length(Mfiles);  % resetting the number of records to previous value.
        
%axis([T_min,T_max,0.001,3]);
hx = xlabel(strx);
hy = ylabel(stry); grid on;
htitle = title(nameOfPlot);
legh = legend([plotHandle(1), plotHandle(2), plotHandle(3)], legendLIST);
% str=sprintf('Velocity Response Spectrum (%4.3f damping) for %10s',zet, filename{p});
xlim([0 0.06]);   
ylim([0 25]);

psb_FigureFormatScript

    case '12d.PlotShearHingeOfLimitState'
%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%% DO NOT CHANGE THIS BLOCK IF BACKBONE CURVE IS NOT TO BE PLOTTED %%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
doPlotBackboneCurveAsWell = 0; % 1- Yes, plot. 0- No, don't plot.
% backboneCurveToPlot = 'CreateIbarraMaterial	302021	55956830252.497	242839.2766	-242839.2766	1.206532735	0.057470341	-0.057470341	0.1	98.49657903	$c	$resStrRatio	$stiffFactor1	$stiffFactor2	3240';
backboneCurveToPlot = 'CreateIbarraMaterial	40202	15287342475.9679	3057468.495	-3057468.495	1.25	0.004	-0.004	0.1	100	$c	$resStrRatio	$stiffFactor1	$stiffFactor2	650';
% backboneCurveToPlot = 'CreateIbarraMaterial	303021	55956830252.497	279912.5624	-279912.5624	1.211465998	0.062093024	-0.062093024	0.1	103.1174271	$c	$resStrRatio	$stiffFactor1	$stiffFactor2	2840';

% backboneCurveToPlot = 'CreateIbarraMaterial	203012	152178184842.34	302646.5183	-274651.5568	1.22087264	0.053083736	-0.054915073	0.1	114.1000948	$c	$resStrRatio	$stiffFactor1	$stiffFactor2	8650';
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%% DO NOT CHANGE THIS BLOCK IF BACKBONE CURVE IS NOT TO BE PLOTTED %%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
cd I:\PrakRuns_I\Output\(ID2206_R3_7Story_v.05_ShearHingeModel1B)_(AllVar)_(0.00)_(clough)\EQ_9991\Sa_0.00\Elements\ShearLimitState

% eqNum = 9991; %120122;
% saVal = 0.00; %1.32;
% cd(fullfile(sprintf('EQ_%i', eqNum), sprintf('Sa_%3.2f', saVal), 'Elements', 'Joints'));

span = 3900 - 750;

PhifilesTop = {
    'THNodeDispl_203021.out'
           };  
       
PhifilesBot = {
    'THNodeDispl_203026.out'
           };  
      
% x-axis entries are subtraction of PhitfilesTop and PhifilesBot
       
% a = {1, 1};    % Column number for the first set of files (X-axis file)
a = {2};

% Mfiles = Phifiles; % often this is the case. If not, define below.

Mfiles = {
    % force along global X direction is shear in the element
        'ShearHingeForceTH_60302.out' 
        };  % y-axis entries
b = {2};

absol = 0;    % 0-absolute values to be plotted
              % 1-exact algebraic values to be plotted

legendLIST = {
%     'Axial force-Lateral deformation'
    'Shear Hinge 60302'
    };  % Used only for legend entries

facx = 1.0/span;   % factor to be multiplied to x-axis values
facy = 1.0;%/1000;   % factor to be multiplied to y-axis values

% Graph and Axes titles

strx = 'Drift ratio';
stry = 'Base Shear (kN)';
nameOfPlot = 'Base Shear - drift';

% strx = '\theta (radians) \rightarrow';
% stry = 'M (kN-m) \rightarrow';
% nameOfPlot = 'Moment-rotation curve';

% strx = 'Time(sec) \rightarrow';
% stry = 'Horiz accel of Node 3 (g) \rightarrow';
% nameOfPlot = 'Accel Response at node 3 and Input GM';

% strx = 'Time(sec) \rightarrow';
% stry = 'Displacement of Node 4 (mm) \rightarrow';
% nameOfPlot = 'Time history of displacement of node 4';
   
if (length(Mfiles) ~= length(PhifilesTop)) || (length(Mfiles) ~= length(PhifilesBot))
    error('MPhi:Unequal','Unequal number of inputs for M and Phi \n');
end
% lineColors = {'b', 'r', 'k', 'g', 'y', 'b', 'r', 'k', 'g', 'y', 'b', 'r', 'k', 'g', 'y'};
lineColors = {'r','b','g','k','y',[.5 .6 .7],[.8 .2 .6]}; % Cell array of 7 colors.
lineStyles = {'-','--', '-.', ':', '-','--', '-.', ':', '-','--', '-.', ':'};
markers = {'','','','*','s','d','v','^','<','>','p','h','.',...
'+','*','o','x','^','<','h','.','>','p','s','d','v',...
'o','x','+','*','s','d','v','^','<','>','p','h','.'};
% markers = ['o','x','+','*','s','d','v','^','<','>','p','h','.',...
% '+','*','o','x','^','<','h','.','>','p','s','d','v',...
% 'o','x','+','*','s','d','v','^','<','>','p','h','.'];

for p = 1:length(Mfiles)
    PhiTop = load(PhifilesTop{p});
    PhiBot = load(PhifilesBot{p});
    Phi = PhiTop - PhiBot;
    
    M = load(Mfiles{p}); % since filename is a cell, curly braces shall be used
    
    cur = (Phi(:,a{p})); mom = M(:,b{p}); % Reading the input file
%     figure(p)       % Uncomment to have separate plots
    currentPlotStyle = [lineColors{p} lineStyles{p} markers{p}];
    if absol == 0
        plot([0; abs(facx * cur)], [0; abs(facy * mom)], currentPlotStyle, 'LineWidth', 2); hold on;
    elseif absol == 1
        plot([0; (facx * cur)], [0; (facy * mom)], currentPlotStyle, 'LineWidth', 2); hold on;
    end
end

p=length(Mfiles);  % resetting the number of records to previous value.
        
%axis([T_min,T_max,0.001,3]);
hx = xlabel(strx);
hy = ylabel(stry); grid on;
htitle = title(nameOfPlot);
legh = legend(legendLIST);
% str=sprintf('Velocity Response Spectrum (%4.3f damping) for %10s',zet, filename{p});
% xlim([0 0.06]);   
% ylim([0 25]);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%% BLOCK FOR PLOTTING BACKBONE CURVE STARTS FROM HERE %%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if (doPlotBackboneCurveAsWell == 1)
backboneCurveToPlot = strsplit(backboneCurveToPlot, '\t');

resStrRatio = 0.01;	% This is the residual strength ratio; this muct be non-zero or else we see a bug in the unloading/reloading stiffnesses
c =	1.0;	% Exponent for deterioration
stiffFactor1 = 11.0;
stiffFactor2 = 1.1;

EIeff = str2double(backboneCurveToPlot{3});
myPos = str2double(backboneCurveToPlot{4});
myNeg = str2double(backboneCurveToPlot{5});
mcOverMy = str2double(backboneCurveToPlot{6});
thetaCapPos = str2double(backboneCurveToPlot{7});
thetaCapNeg = str2double(backboneCurveToPlot{8});
thetaPC = str2double(backboneCurveToPlot{9});
lambda = str2double(backboneCurveToPlot{10});

eleLength = str2double(backboneCurveToPlot{15});

elstk =	stiffFactor1 * ((6 * EIeff) / eleLength);	% Initial elastic stiffness
alphaHardUnscaled = (((myPos * mcOverMy) - myPos)/(thetaCapPos)) / elstk;
alphaHardScaled	= alphaHardUnscaled * ((-stiffFactor2 * alphaHardUnscaled ) / (alphaHardUnscaled * (alphaHardUnscaled - stiffFactor2)));	% This altered the stiffness to account for the elastic element stiffness - see hand notes on 1-6-05
alphaCapUnscaled	= ((-myPos*mcOverMy)/(thetaPC)) / elstk;
alphaCapScaled	= alphaCapUnscaled * ((-stiffFactor2 * alphaCapUnscaled) / (alphaCapUnscaled * (alphaCapUnscaled - stiffFactor2)));	% This altered the stiffness to account for the elastic element stiffness - see hand notes on 1-6-05
lambdaA = 0; 							% No accelerated stiffness deterioration Strength
lambdaS = lambda * stiffFactor1;		
lambdaK = 0;							% No unloading stiffness deterioration because there is a bug in this portion of the model
lambdaD = lambda * stiffFactor1;		% Capping strength

% calculation of x-axis data

thetaYPos = myPos / elstk;
mCapPos = myPos * mcOverMy;
mResPos = myPos * resStrRatio;
thetaCPos = thetaYPos + (mCapPos - myPos) / (alphaHardScaled * elstk);
thetaRPos = thetaCPos + (mResPos - mCapPos) / (alphaCapScaled * elstk);
thetaUPos = thetaCPos + thetaPC;

thetaYNeg = myNeg / elstk;
mCapNeg = myNeg * mcOverMy;
mResNeg = myNeg * resStrRatio;
thetaCNeg = thetaYNeg + (mCapNeg - myNeg) / (alphaHardScaled * elstk);
thetaRNeg = thetaCNeg + (mResNeg - mCapNeg) / (alphaCapScaled * elstk);
thetaUNeg = thetaCNeg + (-thetaPC);

figure(1)

xData = [thetaUNeg, thetaRNeg, thetaCNeg, thetaYNeg, 0, thetaYPos, thetaCPos, thetaRPos, thetaUPos];
yData = [mResNeg, mResNeg, mCapNeg, myNeg, 0, myPos, mCapPos, mResPos, mResPos] / 1000;

pause(1.5)
plot(xData, yData, 'k--', 'LineWidth', 2);

strx = '\theta (radians) \rightarrow';
stry = 'M (kN-m) \rightarrow';
strTitle = 'Moment-rotation curve';

legendLIST = [legendLIST 'Backbone Curve'];

hx = xlabel(strx); hy = ylabel(stry); grid on; htitle = title(strTitle); legh = legend(legendLIST);

psb_FigureFormatScript

end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%% BLOCK FOR PLOTTING BACKBONE CURVE ENDS HERE %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


psb_FigureFormatScript

    case '12e.PlotSimpleMPhi'
%%
% cd I:\LimitStateMaterial\testingBuiltOpenseeskNmm\Analysis_LimitStateMaterial(Load)-Pushover
% cd I:\PrakRuns_I\Output\(ID2206_R3_7Story_v.05_ShearHingeModel1B)_(AllVar)_(0.00)_(clough)\EQ_9991\Sa_0.00\Elements\Joints
% cd I:\PrakRuns_I\Output\(ID2207_R5_7Story_v.03_SlabNotConsidered_CORRECTShearPanel)_(AllVar)_(0.00)_(clough)_GMSetC\EQ_9991\Sa_0.00\Elements\Joints
% cd I:\PrakRuns_I\Output\(ID2206_R3_7Story_v.03rev_SlabNotConsidered_BottomStoryHtCorrected)_(AllVar)_(0.00)_(clough)\EQ_9991\Sa_0.00\Elements\Joints
% eqNum = 9991; %120122;
% saVal = 0.00; %1.32;
% cd(fullfile(sprintf('EQ_%i', eqNum), sprintf('Sa_%3.2f', saVal), 'Elements', 'Joints'));

cd('I:\PrakRuns_I\Output');
span = 3900 - 750;

Phifiles = {
%     'secdeform1Column.out'
'(ID2221_R5_4Story_v.03_revisedLambda)_(AllVar)_(0.00)_(clough)\EQ_120122\Sa_1.92\Elements\Joints\Joint_ForceAndDef_40201.out'
'(ID2221_R5_4Story_v.02)_(AllVar)_(0.00)_(clough)\EQ_120122\Sa_1.92\Elements\Joints\Joint_ForceAndDef_40201.out'
           };  % x-axis entries. Names of the files M and Phi are symbolic
% a = {1, 1};    % Column number for the first set of files (X-axis file)
% a = {1	1	1	1	1	1	1	1	1	1	1	1	1	1	1	1	1	1	1	1	1	1	1	1	1	1	1	1};
% a = 3 * ones(length(Phifiles));
a = repmat(1, 1, length(Phifiles));

Mfiles = Phifiles; % often this is the case. If not, define below.

% Mfiles = {
%     'secforce1Column.out' 
%         };  % y-axis entries
% b = [2, 2];    % Column number for the second set of files (Y-axis file)
b = 6 * ones(1, length(Phifiles));
absol = 1;    % 0-absolute values to be plotted
              % 1-exact algebraic values to be plotted

legendLIST = {
%     'Axial force-Lateral deformation'
    'Moment-Curvature at col top'
%     'Moment-rotation history of top of the column at GF ($matTag = 302021)'
%     'M-theta TH of right-to-left beam of 2nd floor GF (matTag = 203012)'
%     'V_M-gamma of joint ID 203012'
%         'Displacement of node 4 for 5% rayleigh damp'
%         'Displacement of node 4 for 10% rayleigh damp'
    };  % Used only for legend entries

facx = 1.0;   % factor to be multiplied to x-axis values
facy = 1.0/1000;   % factor to be multiplied to y-axis values

% Graph and Axes titles

strx = 'Curvature (1/mm)';
stry = 'Moment (kN-m)';
nameOfPlot = 'Moment - curvature';
   
if (length(Mfiles) ~= length(Phifiles))
    error('MPhi:Unequal','Unequal number of inputs for M and Phi \n');
end
% lineColors = {'b', 'r', 'k', 'g', 'y', 'b', 'r', 'k', 'g', 'y', 'b', 'r', 'k', 'g', 'y'};
lineColors = repmat({'r','b','g','k','y',[.5 .6 .7],[.8 .2 .6]}, [1 4]); % Cell array of 28 colors.
lineStyles = repmat({'-','--', '-.', ':', '-','--', '-.', ':', '-','--', '-.', ':'}, [1 4]);
markers = {'','','','*','s','d','v','^','<','>','p','h','.',...
'+','*','o','x','^','<','h','.','>','p','s','d','v',...
'o','x','+','*','s','d','v','^','<','>','p','h','.'};
% markers = ['o','x','+','*','s','d','v','^','<','>','p','h','.',...
% '+','*','o','x','^','<','h','.','>','p','s','d','v',...
% 'o','x','+','*','s','d','v','^','<','>','p','h','.'];

for p = 1:length(Mfiles)
    Phi = load(Phifiles{p});
    M = load(Mfiles{p}); % since filename is a cell, curly braces shall be used
    
    cur = (Phi(:,a(p))); mom=M(:,b(p)); % Reading the input file
%     figure(p)       % Uncomment to have separate plots
    currentPlotStyle = [lineColors{p} lineStyles{p} markers{p}];
    if absol == 0
        plot([0; abs(facx * cur)], [0; abs(facy * mom)], currentPlotStyle, 'LineWidth', 2); hold on;
    elseif absol == 1
        plot([0; (facx * cur)], [0; (facy * mom)], currentPlotStyle, 'LineWidth', 2); hold on;
    end
end

p=length(Mfiles);  % resetting the number of records to previous value.
        
%axis([T_min,T_max,0.001,3]);
hx = xlabel(strx);
hy = ylabel(stry); grid on;
htitle = title(nameOfPlot);
legh = legend(legendLIST);
% str=sprintf('Velocity Response Spectrum (%4.3f damping) for %10s',zet, filename{p});
% xlim([0 0.06]);   
% ylim([0 25]);

psb_FigureFormatScript

    case '12e1.VerySimpleTH_plot'
%%
% cd('C:\BRB_local\Output\(BRB_18Story_ConfA_trial_new)_(AllVar)_(0.00)_(clough)\EQ_80011\Sa_4.11');
Phifiles = {
% 'C:\BRB_local\Output\(BRB_valid_v02_NoSlip)_(AllVar)_(0.00)_(clough)\EQ_80011\Sa_0.03\Elements\Hinges\HingeRotTH_301.out'
% 'C:\BRB_local\Output\(BRB_2Story_ConfA_trial)_(AllVar)_(0.00)_(clough)\EQ_80012\Sa_0.77\Elements\Hinges\HingeRotTH_60101.out'
% 'C:\BRB_local\Output\(BRB_20Story_ConfA_trial)_(AllVar)_(0.00)_(clough)\EQ_9991\Sa_0.00\Nodes\DisplTH\THNodeDispl_221011.out'
% 'Elements\Hinges\HingeRotTH_60101.out'
% 'Elements\EleLocalTH\brbDefo_401011.out'
% 'C:\BRB_local\Output\(BRB_18story_v4)_(AllVar)_(0.00)_(clough)\EQ_80011\Sa_0.11\Elements\Dowels\dowelRotTH_60201.out'
% 'C:\BRB_local\Output\(BRB_18story_v4)_(AllVar)_(0.00)_(clough)\EQ_80011\Sa_0.51\Elements\Dowels\dowelRotTH_60201.out'
% 'C:\BRB_local\Output\(BRB_18story_v4)_(AllVar)_(0.00)_(clough)\EQ_80011\Sa_0.91\Elements\Dowels\dowelRotTH_60201.out'
% 'C:\BRB_local\Output\(BRB_18story_v4)_(AllVar)_(0.00)_(clough)\EQ_80011\Sa_1.31\Elements\Dowels\dowelRotTH_60201.out'
% 'C:\BRB_local\Output\(BRB_18story_v4)_(AllVar)_(0.00)_(clough)\EQ_80011\Sa_1.71\Elements\Dowels\dowelRotTH_60201.out'
% 'C:\BRB_local\Output\(BRB_18story_v4)_(AllVar)_(0.00)_(clough)\EQ_80011\Sa_2.11\Elements\Dowels\dowelRotTH_60201.out'
% 'C:\BRB_local\Output\(BRB_18story_v4)_(AllVar)_(0.00)_(clough)\EQ_80011\Sa_2.51\Elements\Dowels\dowelRotTH_60201.out'
% 'C:\BRB_local\Output\(BRB_18story_v4)_(AllVar)_(0.00)_(clough)\EQ_80011\Sa_2.91\Elements\Dowels\dowelRotTH_60201.out'
% 'C:\BRB_local\Output\(BRB_18story_v4)_(AllVar)_(0.00)_(clough)\EQ_80011\Sa_3.31\Elements\Dowels\dowelRotTH_60201.out'
% 'C:\BRB_local\Output\(BRB_18story_v4)_(AllVar)_(0.00)_(clough)\EQ_80011\Sa_3.71\Elements\Dowels\dowelRotTH_60201.out'
% 'C:\BRB_local\Output\(BRB_18story_v4)_(AllVar)_(0.00)_(clough)\EQ_80011\Sa_4.11\Elements\Dowels\dowelRotTH_60201.out'
% 'C:\BRB_local\Output\(BRB_18story_v4)_(AllVar)_(0.00)_(clough)\EQ_80011\Sa_4.51\Elements\Dowels\dowelRotTH_60201.out'
% 'C:\BRB_local\Output\(BRB_18story_v4)_(AllVar)_(0.00)_(clough)\EQ_80011\Sa_4.91\Elements\Dowels\dowelRotTH_60201.out'
% 'C:\BRB_local\Output\(BRB_18story_v4)_(AllVar)_(0.00)_(clough)\EQ_80011\Sa_5.11\Elements\Dowels\dowelRotTH_60201.out'
% 'C:\BRB_local\Output\(BRB_18story_v4)_(AllVar)_(0.00)_(clough)\EQ_80011\Sa_5.31\Elements\Dowels\dowelRotTH_60201.out'

% 'C:\BRB_local\Output\(BRB_18story_v4)_(AllVar)_(0.00)_(clough)\EQ_80011\Sa_5.31\Elements\Dowels\dowelRotTH_60201.out'
% 'C:\BRB_local\Output\(BRB_18story_v4)_(AllVar)_(0.00)_(clough)\EQ_80011\Sa_5.31\Elements\Dowels\dowelRotTH_60202.out'

'C:\BRB_local\Output\(BRB_18story_v4)_(AllVar)_(0.00)_(clough)\EQ_80011\Sa_5.11\Nodes\DisplTH\THNodeDispl_202011.out'
'C:\BRB_local\Output\(BRB_18story_v4)_(AllVar)_(0.00)_(clough)\EQ_80011\Sa_5.11\Nodes\DisplTH\THNodeDispl_202011.out'
           };  % x-axis entries. Names of the files M and Phi are symbolic

Mfiles = {
% 'C:\BRB_local\Output\(BRB_valid_v02_NoSlip)_(AllVar)_(0.00)_(clough)\EQ_80011\Sa_0.03\Elements\Hinges\HingeForceTH_301.out'
% 'C:\BRB_local\Output\(BRB_2Story_ConfA_trial)_(AllVar)_(0.00)_(clough)\EQ_80012\Sa_0.77\Elements\Hinges\HingeForceTH_60101.out'
% 'C:\BRB_local\Output\(BRB_20Story_ConfA_trial)_(AllVar)_(0.00)_(clough)\EQ_9991\Sa_0.00\Elements\EleLocalTH\THEleLocal_20101.out'
% 'Elements\Hinges\HingeForceTH_60101.out'
% 'Elements\EleLocalTH\THEleLocal_401011.out'
% 'C:\BRB_local\Output\(BRB_18story_v4)_(AllVar)_(0.00)_(clough)\EQ_80022\Sa_1.71\Nodes\DisplTH\THNodeDispl_219011.out'
% 'C:\BRB_local\Output\(BRB_18story_v4_dtBy2)_(AllVar)_(0.00)_(clough)\EQ_80022\Sa_1.71\Nodes\DisplTH\THNodeDispl_219011.out'
% 'C:\BRB_local\Output\(BRB_18story_v4)_(AllVar)_(0.00)_(clough)\EQ_80011\Sa_0.11\Elements\Dowels\dowelForceTH_60201.out'
% 'C:\BRB_local\Output\(BRB_18story_v4)_(AllVar)_(0.00)_(clough)\EQ_80011\Sa_0.51\Elements\Dowels\dowelForceTH_60201.out'
% 'C:\BRB_local\Output\(BRB_18story_v4)_(AllVar)_(0.00)_(clough)\EQ_80011\Sa_0.91\Elements\Dowels\dowelForceTH_60201.out'
% 'C:\BRB_local\Output\(BRB_18story_v4)_(AllVar)_(0.00)_(clough)\EQ_80011\Sa_1.31\Elements\Dowels\dowelForceTH_60201.out'
% 'C:\BRB_local\Output\(BRB_18story_v4)_(AllVar)_(0.00)_(clough)\EQ_80011\Sa_1.71\Elements\Dowels\dowelForceTH_60201.out'
% 'C:\BRB_local\Output\(BRB_18story_v4)_(AllVar)_(0.00)_(clough)\EQ_80011\Sa_2.11\Elements\Dowels\dowelForceTH_60201.out'
% 'C:\BRB_local\Output\(BRB_18story_v4)_(AllVar)_(0.00)_(clough)\EQ_80011\Sa_2.51\Elements\Dowels\dowelForceTH_60201.out'
% 'C:\BRB_local\Output\(BRB_18story_v4)_(AllVar)_(0.00)_(clough)\EQ_80011\Sa_2.91\Elements\Dowels\dowelForceTH_60201.out'
% 'C:\BRB_local\Output\(BRB_18story_v4)_(AllVar)_(0.00)_(clough)\EQ_80011\Sa_3.31\Elements\Dowels\dowelForceTH_60201.out'
% 'C:\BRB_local\Output\(BRB_18story_v4)_(AllVar)_(0.00)_(clough)\EQ_80011\Sa_3.71\Elements\Dowels\dowelForceTH_60201.out'
% 'C:\BRB_local\Output\(BRB_18story_v4)_(AllVar)_(0.00)_(clough)\EQ_80011\Sa_4.11\Elements\Dowels\dowelForceTH_60201.out'
% 'C:\BRB_local\Output\(BRB_18story_v4)_(AllVar)_(0.00)_(clough)\EQ_80011\Sa_4.51\Elements\Dowels\dowelForceTH_60201.out'
% 'C:\BRB_local\Output\(BRB_18story_v4)_(AllVar)_(0.00)_(clough)\EQ_80011\Sa_4.91\Elements\Dowels\dowelForceTH_60201.out'
% 'C:\BRB_local\Output\(BRB_18story_v4)_(AllVar)_(0.00)_(clough)\EQ_80011\Sa_5.11\Elements\Dowels\dowelForceTH_60201.out'
% 'C:\BRB_local\Output\(BRB_18story_v4)_(AllVar)_(0.00)_(clough)\EQ_80011\Sa_5.31\Elements\Dowels\dowelForceTH_60201.out'

% 'C:\BRB_local\Output\(BRB_18story_v4)_(AllVar)_(0.00)_(clough)\EQ_80011\Sa_5.31\Elements\Dowels\dowelForceTH_60201.out'
% 'C:\BRB_local\Output\(BRB_18story_v4)_(AllVar)_(0.00)_(clough)\EQ_80011\Sa_5.31\Elements\Dowels\dowelForceTH_60202.out'

'C:\BRB_local\Output\(BRB_18story_v4)_(AllVar)_(0.00)_(clough)\EQ_80011\Sa_5.11\Elements\EleLocalTH\THEleLocal_401011.out'
'C:\BRB_local\Output\(BRB_18story_v4)_(AllVar)_(0.00)_(clough)\EQ_80011\Sa_5.11\Elements\EleLocalTH\THEleLocal_401012.out'
};  % y-axis entries. Names of the files M and Phi are symbolic

% Mfiles = Phifiles; % often this is the case. If not, define below.

a = 2 * ones(1, length(Phifiles)); b = 1 * ones(1, length(Phifiles)); % col numbers
absol = 0;    % 0-absolute values to be plotted; 1- algebraic values

% Graph and Axes titles
% strx = 'Curvature (1/mm)'; stry = 'Moment (kN-m)'; 
strx = 'Displacement (mm)'; stry = 'Axial Force (kN)'; 
legendLIST = {
    'Force-Defo of BRB-1'
    'Force-Defo of BRB-2'
    };  % Used only for legend entries; 'Force-Defo of Dowel in left BRBF'
% nameOfPlot = 'N_{st} = 18, EQ: 80011, Sa(1.2 s) = 5.31g, EleTag: 60201-2 (Top Dowel at Level-2)';
nameOfPlot = 'N_{st} = 18, EQ: 80011, Sa(1.2 s) = 5.11g, EleTag: 401011-2 (BRB on Floor-1)';

facx = 1.0;  facy = 1.0;   % factor to be multiplied to x- and y-axis values

   
% lineColors = {'b', 'r', 'k', 'g', 'y', 'b', 'r', 'k', 'g', 'y', 'b', 'r', 'k', 'g', 'y'};
lineColors = repmat({'r','b','g','k','y',[.5 .6 .7],[.8 .2 .6]}, [1 4]); % Cell array of 28 colors.
lineStyles = repmat({'-','--', '-.', ':', '-','--', '-.', ':', '-','--', '-.', ':'}, [1 4]);
markers = {'','','','','','*','s','d','v','^','<','>','p','h','.',...
'+','*','o','x','^','<','h','.','>','p','s','d','v',...
'o','x','+','*','s','d','v','^','<','>','p','h','.'};

h = animatedline;

for p = 1:length(Mfiles)
    Phi = dlmread(Phifiles{p});
    M = dlmread(Mfiles{p}); % since filename is a cell, curly braces shall be used
    cur = (Phi(:,a(p))); mom=M(:,b(p)); % Reading the input file

    if size(mom, 1) > size(cur, 1); mom(size(cur, 1)+1:end, :) = []; 
    elseif size(mom, 1) < size(cur, 1); cur(size(mom, 1)+1:end, :) = []; end

%     figure(p)       % Uncomment to have separate plots
    currentPlotStyle = [lineColors{p} lineStyles{p} markers{p}];
    if absol == 0
        cur = [0; facx * cur]; mom = [0; facy * mom];
        plot(cur, mom, currentPlotStyle, 'LineWidth', 1); hold on;
    elseif absol == 1
        cur = [0; abs(facx * cur)]; mom = [0; abs(facy * mom)];
        plot(cur, mom, currentPlotStyle, 'LineWidth', 1); hold on;
    end

%     xlim([-0.15 0.15]); ylim([-3000 3000]); grid on;
    for k = 1:size(cur, 1)
%         addpoints(h, -cur(k), mom(k)); drawnow; % activate to see the sequence of the plot 
    end
pause(1)
end
hx = xlabel(strx); hy = ylabel(stry); grid on; htitle = title(nameOfPlot); legh = legend(legendLIST, 'Location','southeast');
xlim([-300 300]); ylim([-2500 2500]);

    case '12f.PlotMThetaOfRotHinge'
%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%% DO NOT CHANGE THIS BLOCK IF BACKBONE CURVE IS NOT TO BE PLOTTED %%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
doPlotBackboneCurveAsWell = 0; % 1- Yes, plot. 0- No, don't plot.
backboneCurveToPlot = 'CreateIbarraMaterial	302021	55956830252.497	242839.2766	-242839.2766	1.206532735	0.057470341	-0.057470341	0.1	98.49657903	$c	$resStrRatio	$stiffFactor1	$stiffFactor2	3240';
% backboneCurveToPlot = 'CreateIbarraMaterial	303021	55956830252.497	279912.5624	-279912.5624	1.211465998	0.062093024	-0.062093024	0.1	103.1174271	$c	$resStrRatio	$stiffFactor1	$stiffFactor2	2840';

% backboneCurveToPlot = 'CreateIbarraMaterial	203012	152178184842.34	302646.5183	-274651.5568	1.22087264	0.053083736	-0.054915073	0.1	114.1000948	$c	$resStrRatio	$stiffFactor1	$stiffFactor2	8650';
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%% DO NOT CHANGE THIS BLOCK IF BACKBONE CURVE IS NOT TO BE PLOTTED %%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% cd('H:\PrakRuns\Output\(CivilBldg_3story_ID9901_v.09_curtailedGMduration)_(AllVar)_(0.00)_(clough)\EQ_120522\Sa_0.98\Elements\Joints');
% cd('H:\PrakRuns\Output');
% cd('(CivilBldg_3story_ID9901_v.10_5pcRayleighIn1stN3rdMode)_(AllVar)_(0.00)_(clough)');

% cd('(ID2221_R5_4Story_v.02)_(AllVar)_(0.00)_(clough)');
% cd('(ID2221_R5_4Story_v.03_revisedLambda)_(AllVar)_(0.00)_(clough)');

% cd('I:\PrakRuns_I\Output');

cd I:\PrakRuns_I\Output

eqNum = 120111;
saVal = 0.11;
% cd(fullfile(sprintf('EQ_%i', eqNum), sprintf('Sa_%3.2f', saVal), 'Elements', 'Joints'));
% cd(fullfile(sprintf('EQ_%i', eqNum), sprintf('Sa_%3.2f', saVal), 'Elements', 'Hinges'));

Phifiles = {
%     'HingeRotTH_6012.out'
%     'HingeDefTH_602011.out'
%     'HingeDefTH_608011.out'

%     '(ID2221_R5_4Story_v.02)_(AllVar)_(0.00)_(clough)\EQ_121111\Sa_1.02\Elements\Hinges\HingeRotTH_6022.out'
%     '(ID2221_R5_4Story_v.03_revisedLambda)_(AllVar)_(0.00)_(clough)\EQ_121111\Sa_1.02\Elements\Hinges\HingeRotTH_6022.out'

% '(ID2316_R3_7Story_v.01)_(AllVar)_(0.00)_(clough)OLD\EQ_120111\Sa_0.11\Elements\DamageIndex\HingeDefTH_608011.out'
% '(ID2316_R3_7Story_v.01)_(AllVar)_(0.00)_(clough)\EQ_120111\Sa_0.11\Elements\DamageIndex\HingeDefTH_608011.out'

% '(psb_RunSingleInelasticDynamicAnalysis_2316)_(AllVar)_(0.00)_(clough)\EQ_120111\Sa_0.11_dtBy2\Nodes\DisplTH\THNodeDispl_208013.out'
% '(psb_RunSingleInelasticDynamicAnalysis_2316)_(AllVar)_(0.00)_(clough)\EQ_120111\Sa_0.11_dtBy5\Nodes\DisplTH\THNodeDispl_208013.out'
% '(psb_RunSingleInelasticDynamicAnalysis_2316)_(AllVar)_(0.00)_(clough)\EQ_120111\Sa_0.11_dtBy10\Nodes\DisplTH\THNodeDispl_208013.out'
% '(psb_RunSingleInelasticDynamicAnalysis_2316)_(AllVar)_(0.00)_(clough)\EQ_120111\Sa_0.11_dtBy20\Nodes\DisplTH\THNodeDispl_208013.out'
% '(psb_RunSingleInelasticDynamicAnalysis_2316)_(AllVar)_(0.00)_(clough)\EQ_120111\Sa_0.11_dtBy50\Nodes\DisplTH\THNodeDispl_208013.out'

'(psb_RunSingleInelasticDynamicAnalysis_2316_v2_withShearHingeRecorders)_(AllVar)_(0.00)_(clough)\EQ_120111\Sa_0.11_dtBy2\Elements\DamageIndex\HingeDefTH_608011.out'
'(psb_RunSingleInelasticDynamicAnalysis_2316_v2_withShearHingeRecorders)_(AllVar)_(0.00)_(clough)\EQ_120111\Sa_0.11_dtBy5\Elements\DamageIndex\HingeDefTH_608011.out'
'(psb_RunSingleInelasticDynamicAnalysis_2316_v2_withShearHingeRecorders)_(AllVar)_(0.00)_(clough)\EQ_120111\Sa_0.11_dtBy10\Elements\DamageIndex\HingeDefTH_608011.out'
'(psb_RunSingleInelasticDynamicAnalysis_2316_v2_withShearHingeRecorders)_(AllVar)_(0.00)_(clough)\EQ_120111\Sa_0.11_dtBy20\Elements\DamageIndex\HingeDefTH_608011.out'
'(psb_RunSingleInelasticDynamicAnalysis_2316_v2_withShearHingeRecorders)_(AllVar)_(0.00)_(clough)\EQ_120111\Sa_0.11_dtBy50\Elements\DamageIndex\HingeDefTH_608011.out'

};  % x-axis entries. Names of the files M and Phi are symbolic

a = {3, 3, 3, 3, 3};    % Column number for the first set of files (X-axis file)
% a = {1};

% Mfiles = Phifiles; % often this is the case. If not, define below.

Mfiles = {
%     'HingeForceTH_602011.out'
%     'HingeForceTH_608011.out'

%     '(ID2221_R5_4Story_v.02)_(AllVar)_(0.00)_(clough)\EQ_121111\Sa_1.02\Elements\Hinges\HingeForceTH_6022.out'
%     '(ID2221_R5_4Story_v.03_revisedLambda)_(AllVar)_(0.00)_(clough)\EQ_121111\Sa_1.02\Elements\Hinges\HingeForceTH_6022.out'

%     '(ID2221_R5_4Story_v.02)_(AllVar)_(0.00)_(clough)\EQ_121111\Sa_1.02\Elements\Hinges\HingeForceTH_6022.out'
%     '(ID2221_R5_4Story_v.03_revisedLambda)_(AllVar)_(0.00)_(clough)\EQ_121111\Sa_1.02\Elements\Hinges\HingeForceTH_6022.out'

% '(ID2316_R3_7Story_v.01)_(AllVar)_(0.00)_(clough)OLD\EQ_120111\Sa_0.11\Elements\DamageIndex\HingeForceTH_608011.out'
% '(ID2316_R3_7Story_v.01)_(AllVar)_(0.00)_(clough)\EQ_120111\Sa_0.11\Elements\DamageIndex\HingeForceTH_608011.out'

'(psb_RunSingleInelasticDynamicAnalysis_2316_v2_withShearHingeRecorders)_(AllVar)_(0.00)_(clough)\EQ_120111\Sa_0.11_dtBy2\Elements\DamageIndex\HingeForceTH_608011.out'
'(psb_RunSingleInelasticDynamicAnalysis_2316_v2_withShearHingeRecorders)_(AllVar)_(0.00)_(clough)\EQ_120111\Sa_0.11_dtBy5\Elements\DamageIndex\HingeForceTH_608011.out'
'(psb_RunSingleInelasticDynamicAnalysis_2316_v2_withShearHingeRecorders)_(AllVar)_(0.00)_(clough)\EQ_120111\Sa_0.11_dtBy10\Elements\DamageIndex\HingeForceTH_608011.out'
'(psb_RunSingleInelasticDynamicAnalysis_2316_v2_withShearHingeRecorders)_(AllVar)_(0.00)_(clough)\EQ_120111\Sa_0.11_dtBy20\Elements\DamageIndex\HingeForceTH_608011.out'
'(psb_RunSingleInelasticDynamicAnalysis_2316_v2_withShearHingeRecorders)_(AllVar)_(0.00)_(clough)\EQ_120111\Sa_0.11_dtBy50\Elements\DamageIndex\HingeForceTH_608011.out'

};  % y-axis entries

    
b = {3, 3, 3, 3, 3};    % Column number for the second set of files (Y-axis file)
% b = {6};

absol = 1;    % 0-absolute values to be plotted
              % 1-exact algebraic values to be plotted

legendLIST = {
%     'Moment-rotation history of top of the column at GF ($matTag = 302021)'
%     'M-theta TH of right-to-left beam of 2nd floor GF (matTag = 203012)'
%     'M-theta TH of corner column bottom Hinge'
%     'M-theta TH of central column bottom Hinge.v02'
%     'M-theta TH of central column bottom Hinge.v03'
%         'Displacement of node 4 for 5% rayleigh damp'
%         'Displacement of node 4 for 10% rayleigh damp'

%     'M-theta TH of top column bottom Hinge 2316 with dt/2'
%     'M-theta TH of top column bottom Hinge 2316 with dt/10'

        'Moment-rotation of top-floor col hinge 608011 for dt/2'
        'Moment-rotation of top-floor col hinge 608011 for dt/5'
        'Moment-rotation of top-floor col hinge 608011 for dt/10'
        'Moment-rotation of top-floor col hinge 608011 for dt/20'
        'Moment-rotation of top-floor col hinge 608011 for dt/50'
};  % Used only for legend entries

facx = 1.0;   % factor to be multiplied to x-axis values
facy = 1.0/1000;   % factor to be multiplied to y-axis values

% Graph and Axes titles

strx = '\theta (radians) \rightarrow';
stry = 'M (kN-m) \rightarrow';
nameOfPlot = 'Moment-rotation curve';

% strx = 'Time(sec) \rightarrow';
% stry = 'Horiz accel of Node 3 (g) \rightarrow';
% nameOfPlot = 'Accel Response at node 3 and Input GM';

% strx = 'Time(sec) \rightarrow';
% stry = 'Displacement of Node 4 (mm) \rightarrow';
% nameOfPlot = 'Time history of displacement of node 4';
   
if (length(Mfiles) ~= length(Phifiles))
    error('MPhi:Unequal','Unequal number of inputs for M and Phi \n');
end

% lineColors = {'b', 'r', 'k', 'g', 'y', 'b', 'r', 'k', 'g', 'y', 'b', 'r', 'k', 'g', 'y'};
lineColors = {'r','b','g','k','m',[.5 .6 .7],[.8 .2 .6]}; % Cell array of 7 colors.
lineStyles = {'-','--', '-.', ':', '-','--', '-.', ':', '-','--', '-.', ':'};
markers = {'','','','*','s','d','v','^','<','>','p','h','.',...
'+','*','o','x','^','<','h','.','>','p','s','d','v',...
'o','x','+','*','s','d','v','^','<','>','p','h','.'};
% markers = ['o','x','+','*','s','d','v','^','<','>','p','h','.',...
% '+','*','o','x','^','<','h','.','>','p','s','d','v',...
% 'o','x','+','*','s','d','v','^','<','>','p','h','.'];

% figure 

for p = 1:length(Mfiles)
    Phi = load(Phifiles{p});
    M = load(Mfiles{p});
    % since filename is a cell, curly braces shall be used
    
    cur = (Phi(:,a{p})); mom=M(:,b{p}); % Reading the input file
    
    %      figure(p)       %COMMENT OUT THIS LINE TO PLOT ON THE SAME GRAPH
    currentPlotStyle = [lineColors{p} lineStyles{p} markers{p}];
    if absol == 0
        plot([0; abs(facx * cur)], [0; abs(facy * mom)], currentPlotStyle, 'LineWidth', 2); hold on;
    elseif absol == 1
        plot([0; (facx * cur)], [0; (facy * mom)], currentPlotStyle, 'LineWidth', 2); hold on;
%         comet([0; (facx * cur)], [0; (facy * mom)]);
    end
    % plot(facx*cur,facy*mom,'-','color',C{p},'LineWidth',1,'Marker','.'); hold on;
    % plot(x,x.^ii,'color',C{ii},'marker','o')
end

p=length(Mfiles);  % resetting the number of records to previous value.
        
%axis([T_min,T_max,0.001,3]);
hx = xlabel(strx);
hy = ylabel(stry); grid on;
htitle = title(nameOfPlot);
legh = legend(legendLIST);
% str=sprintf('Velocity Response Spectrum (%4.3f damping) for %10s',zet, filename{p});
      

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%% BLOCK FOR PLOTTING BACKBONE CURVE STARTS FROM HERE %%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if (doPlotBackboneCurveAsWell == 1)
backboneCurveToPlot = strsplit(backboneCurveToPlot, '\t');

resStrRatio = 0.01;	% This is the residual strength ratio; this muct be non-zero or else we see a bug in the unloading/reloading stiffnesses
c =	1.0;	% Exponent for deterioration
stiffFactor1 = 11.0;
stiffFactor2 = 1.1;

EIeff = str2double(backboneCurveToPlot{3});
myPos = str2double(backboneCurveToPlot{4});
myNeg = str2double(backboneCurveToPlot{5});
mcOverMy = str2double(backboneCurveToPlot{6});
thetaCapPos = str2double(backboneCurveToPlot{7});
thetaCapNeg = str2double(backboneCurveToPlot{8});
thetaPC = str2double(backboneCurveToPlot{9});
lambda = str2double(backboneCurveToPlot{10});

eleLength = str2double(backboneCurveToPlot{15});

elstk =	stiffFactor1 * ((6 * EIeff) / eleLength);	% Initial elastic stiffness
alphaHardUnscaled = (((myPos * mcOverMy) - myPos)/(thetaCapPos)) / elstk;
alphaHardScaled	= alphaHardUnscaled * ((-stiffFactor2 * alphaHardUnscaled ) / (alphaHardUnscaled * (alphaHardUnscaled - stiffFactor2)));	% This altered the stiffness to account for the elastic element stiffness - see hand notes on 1-6-05
alphaCapUnscaled	= ((-myPos*mcOverMy)/(thetaPC)) / elstk;
alphaCapScaled	= alphaCapUnscaled * ((-stiffFactor2 * alphaCapUnscaled) / (alphaCapUnscaled * (alphaCapUnscaled - stiffFactor2)));	% This altered the stiffness to account for the elastic element stiffness - see hand notes on 1-6-05
lambdaA = 0; 							% No accelerated stiffness deterioration Strength
lambdaS = lambda * stiffFactor1;		
lambdaK = 0;							% No unloading stiffness deterioration because there is a bug in this portion of the model
lambdaD = lambda * stiffFactor1;		% Capping strength

% calculation of x-axis data

thetaYPos = myPos / elstk;
mCapPos = myPos * mcOverMy;
mResPos = myPos * resStrRatio;
thetaCPos = thetaYPos + (mCapPos - myPos) / (alphaHardScaled * elstk);
thetaRPos = thetaCPos + (mResPos - mCapPos) / (alphaCapScaled * elstk);
thetaUPos = thetaCPos + thetaPC;

thetaYNeg = myNeg / elstk;
mCapNeg = myNeg * mcOverMy;
mResNeg = myNeg * resStrRatio;
thetaCNeg = thetaYNeg + (mCapNeg - myNeg) / (alphaHardScaled * elstk);
thetaRNeg = thetaCNeg + (mResNeg - mCapNeg) / (alphaCapScaled * elstk);
thetaUNeg = thetaCNeg + (-thetaPC);

figure(1)

xData = [thetaUNeg, thetaRNeg, thetaCNeg, thetaYNeg, 0, thetaYPos, thetaCPos, thetaRPos, thetaUPos];
yData = [mResNeg, mResNeg, mCapNeg, myNeg, 0, myPos, mCapPos, mResPos, mResPos] / 1000;

pause(1.5)
plot(xData, yData, 'k--', 'LineWidth', 2);

strx = '\theta (radians) \rightarrow';
stry = 'M (kN-m) \rightarrow';
strTitle = 'Moment-rotation curve';

legendLIST = [legendLIST 'Backbone Curve'];

hx = xlabel(strx); hy = ylabel(stry); grid on; htitle = title(strTitle); legh = legend(legendLIST);

psb_FigureFormatScript

end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%% BLOCK FOR PLOTTING BACKBONE CURVE ENDS HERE %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


psb_FigureFormatScript

    
    case '12f1.plotForceDeformationHysteresis_BRBGF_BRB'
%%
%%%%%%%%%%%% TO PLOT BACKBONE CURVE, TAKE CODE FROM 12f.
doPlotBackboneCurveAsWell = 0; % 1- Yes, plot. 0- No, don't plot.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
cd C:\BRB_local\Output\(BRB_18story_v8_SingleAnalysisPinch)_(AllVar)_(0.00)_(clough)
figSaveDir = 'C:\Users\prak\Drive-UBCO\WRITING_ubco\paper_work_ASCE_BRB\figures\hystereticResponses';
exportName = sprintf('temp_raw_BRB_ForceDefoAtMCE_v1');

% eqNum = 160011; saVal = 2.21;
% eqDir = sprintf('EQ_%i', eqNum); saDir = sprintf('Sa_%.2f', saVal);
% cd(eqDir); cd(saDir);

Phifiles = { % different cases help pick a good representative figure
% 'EQ_160051\Sa_0.31\Nodes\DisplTH\THNodeDispl_202011.out';
'EQ_160151\Sa_0.31\Nodes\DisplTH\THNodeDispl_202011.out';
'EQ_160152\Sa_0.31\Nodes\DisplTH\THNodeDispl_202011.out';

% 'EQ_160051\Sa_0.74\Nodes\DisplTH\THNodeDispl_202011.out';
% 'EQ_160151\Sa_0.99\Nodes\DisplTH\THNodeDispl_202011.out';
% 'EQ_160152\Sa_1.76\Nodes\DisplTH\THNodeDispl_202011.out';
};  % x-axis entries. Names of the files M and Phi are symbolic

% a = {3, 3, 3, 3, 3};    % Column number for the first set of files (X-axis file)
a ={2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2};

% Mfiles = Phifiles; % often this is the case. If not, define below.
Mfiles = {
% 'EQ_160051\Sa_0.31\Elements\EleLocalTH\THEleLocal_401011.out';
'EQ_160151\Sa_0.31\Elements\EleLocalTH\THEleLocal_401011.out';
'EQ_160152\Sa_0.31\Elements\EleLocalTH\THEleLocal_401011.out';

% 'EQ_160051\Sa_0.74\Elements\EleLocalTH\THEleLocal_401011.out';
% 'EQ_160151\Sa_0.99\Elements\EleLocalTH\THEleLocal_401011.out';
% 'EQ_160152\Sa_1.76\Elements\EleLocalTH\THEleLocal_401011.out';
};  % y-axis entries


    
% b = {3, 3, 3, 3, 3};    % Column number for the second set of files (Y-axis file)
b = {4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4};

absol = 1;    % 0-absolute values to be plotted
              % 1-exact algebraic values to be plotted

legendLIST = {
        ''
};  % Used only for legend entries

facx = 1.0;   % factor to be multiplied to x-axis values
facy = 1.0;   % factor to be multiplied to y-axis values

% Graph and Axes titles

strx = 'Deformation (mm)';
stry = 'Force (kN)';
nameOfPlot = '1st floor BRB. EQ-160022. Sa(T) = 0.31';
   
if (length(Mfiles) ~= length(Phifiles))
    error('MPhi:Unequal','Unequal number of inputs for M and Phi \n');
end

% lineColors = {'b', 'r', 'k', 'g', 'y', 'b', 'r', 'k', 'g', 'y', 'b', 'r', 'k', 'g', 'y'};
% lineColors = {'r','b','g','k','m',[.5 .6 .7],[.8 .2 .6]}; % Cell array of 7 colors.
% lineStyles = {'-','--', '-.', ':', '-','--', '-.', ':', '-','--', '-.', ':'};
% markers = {'','','','*','s','d','v','^','<','>','p','h','.',...
% '+','*','o','x','^','<','h','.','>','p','s','d','v',...
% 'o','x','+','*','s','d','v','^','<','>','p','h','.'};
% markers = ['o','x','+','*','s','d','v','^','<','>','p','h','.',...
% '+','*','o','x','^','<','h','.','>','p','s','d','v',...
% 'o','x','+','*','s','d','v','^','<','>','p','h','.'];

lineColors = repmat({'k'}, 1, 12); % Cell array of 8 colors.
lineStyles = repmat({'-'}, 1, 12);
markers = repmat({''}, 1, 12);

% figure 

for p = 1:length(Mfiles)
    figure(p);
    Phi = load(Phifiles{p});
    M = load(Mfiles{p});
    % since filename is a cell, curly braces shall be used
    
    cur = (Phi(:,a{p})); mom=M(:,b{p}); % Reading the input file
    
    %      figure(p)       %COMMENT OUT THIS LINE TO PLOT ON THE SAME GRAPH
    currentPlotStyle = [lineColors{p} lineStyles{p} markers{p}];
    if absol == 0
        plot([0; abs(facx * cur)], [0; abs(facy * mom)], currentPlotStyle, 'LineWidth', 1); hold on;
    elseif absol == 1
        plot([0; (facx * cur)], [0; (facy * mom)], currentPlotStyle, 'LineWidth', 1); hold on;
%         comet([0; (facx * cur)], [0; (facy * mom)]);
    end
%     xlim([-20 20]); ylim([-1500 1500]); % at MCE 0.31
    xlim([-200 200]); ylim([-2000 2000]); % at collapse
end

p=length(Mfiles);  % resetting the number of records to previous value.
        
%axis([T_min,T_max,0.001,3]);
hx = xlabel(strx);
hy = ylabel(stry); grid on;
htitle = title(nameOfPlot);
% legh = legend(legendLIST);
      
psb_FigureFormatScript

cd(figSaveDir);
extensions = {'fig', 'epsc'};
for k = 1:length(extensions)
	saveas(gcf, exportName, extensions{k})
end
fprintf('figures saved in %s.\n', pwd);
    
    case '12f2.plotForceDeformationHysteresis_BRBGF_Dowel'
%%
%%%%%%%%%%%% TO PLOT BACKBONE CURVE, TAKE CODE FROM 12f.
doPlotBackboneCurveAsWell = 0; % 1- Yes, plot. 0- No, don't plot.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% cd C:\BRB_local\Output\(BRB_18story_v8)_(AllVar)_(0.00)_(clough)\
cd C:\BRB_local\Output\(BRB_18story_v8_SingleAnalysisPinch)_(AllVar)_(0.00)_(clough)

figSaveDir = 'C:\Users\prak\Drive-UBCO\WRITING_ubco\paper_work_ASCE_BRB\figures\hystereticResponses';
exportName = sprintf('raw_TopDowel_ForceDefo');

% eqNum = 160011; saVal = 2.21;
% eqDir = sprintf('EQ_%i', eqNum); saDir = sprintf('Sa_%.2f', saVal);
% cd(eqDir); cd(saDir);

Phifiles = { % different cases help pick a good representative figure

% 'EQ_160051\Sa_0.31\Elements\Dowels\dowelRotTH_60102.out';
'EQ_160151\Sa_0.31\Elements\Dowels\dowelRotTH_60102.out';
'EQ_160152\Sa_0.31\Elements\Dowels\dowelRotTH_60102.out';

% 'EQ_160051\Sa_0.74\Elements\Dowels\dowelRotTH_60102.out';
% 'EQ_160151\Sa_0.99\Elements\Dowels\dowelRotTH_60102.out';
% 'EQ_160152\Sa_1.76\Elements\Dowels\dowelRotTH_60102.out';

};  % x-axis entries. Names of the files M and Phi are symbolic

% a = {3, 3, 3, 3, 3};    % Column number for the first set of files (X-axis file)
a ={1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1};

% Mfiles = Phifiles; % often this is the case. If not, define below.
Mfiles = {
% 'EQ_160051\Sa_0.31\Elements\Dowels\dowelForceTH_60102.out';
'EQ_160151\Sa_0.31\Elements\Dowels\dowelForceTH_60102.out';
'EQ_160152\Sa_0.31\Elements\Dowels\dowelForceTH_60102.out';

% 'EQ_160051\Sa_0.74\Elements\Dowels\dowelForceTH_60102.out';
% 'EQ_160151\Sa_0.99\Elements\Dowels\dowelForceTH_60102.out';
% 'EQ_160152\Sa_1.76\Elements\Dowels\dowelForceTH_60102.out';
};  % y-axis entries

    
% b = {3, 3, 3, 3, 3};    % Column number for the second set of files (Y-axis file)
b = {4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4};

absol = 1;    % 0-absolute values to be plotted
              % 1-exact algebraic values to be plotted

legendLIST = {
        ''
};  % Used only for legend entries

facx = 1.0;   % factor to be multiplied to x-axis values
facy = 1.0;   % factor to be multiplied to y-axis values

% Graph and Axes titles

strx = 'Deformation (mm)';
stry = 'Force (kN)';
nameOfPlot = '1st floor Top dowel. EQ-160022. Sa(T) = 1.61';
   
if (length(Mfiles) ~= length(Phifiles))
    error('MPhi:Unequal','Unequal number of inputs for M and Phi \n');
end

% lineColors = {'b', 'r', 'k', 'g', 'y', 'b', 'r', 'k', 'g', 'y', 'b', 'r', 'k', 'g', 'y'};
% lineColors = {'r','b','g','k','m',[.5 .6 .7],[.8 .2 .6]}; % Cell array of 7 colors.
% lineStyles = {'-','--', '-.', ':', '-','--', '-.', ':', '-','--', '-.', ':'};
% markers = {'','','','*','s','d','v','^','<','>','p','h','.',...
% '+','*','o','x','^','<','h','.','>','p','s','d','v',...
% 'o','x','+','*','s','d','v','^','<','>','p','h','.'};
% markers = ['o','x','+','*','s','d','v','^','<','>','p','h','.',...
% '+','*','o','x','^','<','h','.','>','p','s','d','v',...
% 'o','x','+','*','s','d','v','^','<','>','p','h','.'];

lineColors = repmat({'k'}, 1, 12); % Cell array of 8 colors.
lineStyles = repmat({'-'}, 1, 12);
markers = repmat({''}, 1, 12);

% figure 

for p = 1:length(Mfiles)
    figure(p);
    Phi = load(Phifiles{p});
    M = load(Mfiles{p});
    % since filename is a cell, curly braces shall be used
    
    cur = (Phi(:,a{p})); mom=M(:,b{p}); % Reading the input file
    
    %      figure(p)       %COMMENT OUT THIS LINE TO PLOT ON THE SAME GRAPH
    currentPlotStyle = [lineColors{p} lineStyles{p} markers{p}];
    if absol == 0
        plot([0; abs(facx * cur)], [0; abs(facy * mom)], currentPlotStyle, 'LineWidth',1); hold on;
    elseif absol == 1
        plot([0; (facx * cur)], [0; (facy * mom)], currentPlotStyle, 'LineWidth',1); hold on;
%         comet([0; (facx * cur)], [0; (facy * mom)]);
    end
    xlim([-50 50]); ylim([-2000 2000]);
end

p=length(Mfiles);  % resetting the number of records to previous value.
        
%axis([T_min,T_max,0.001,3]);
hx = xlabel(strx);
hy = ylabel(stry); grid on;
htitle = title(nameOfPlot);
% legh = legend(legendLIST);
psb_FigureFormatScript


cd(figSaveDir);
extensions = {'fig', 'epsc'};
for p = 1:3
    figure(p);
    for k = 1:length(extensions)
	    saveas(gcf, [exportName, '_EQ', num2str(p), '_v1'], extensions{k})
    end
end
fprintf('figures saved in %s.\n', pwd);
    
    
    
    
    case '12g.PlotTH_Snippet'
%%

eqId = 60221;

cd C:\OpenSeesProcessingFiles\EQs\
THfile = sprintf('SortedEQFile_(%i).txt', eqId);
dtFile = sprintf('DtFile_(%i).txt', eqId);
y = load(THfile); dt = load(dtFile);
t = 0:dt:(length(y)-1)*dt;
plot(t, y, 'b-', 'LineWidth', 0.4); axis off; pbaspect([3 1 1]);

cd(baseFolder);

exportName = sprintf('TH_snippet_%i', eqId);
extensions = {'meta'}; % {'fig', 'epsc', 'png', 'jpeg', 'meta'};

for k = 1:length(extensions)
	saveas(gcf, exportName, extensions{k})
end        
    
  
    case '12g1.FindScalingFactorToMatchSaT1_ofOneBuilding'
%%
        T1 = 1.06;
SaT1toMatch = 0.223;
dampRat = 0.05;

eqNumberLIST_forProcessing_SetDel22A = [6001631	6001632	6002221	6002222	6003671	6003672	6004101	6004102	6004141	6004142	6004191	6004192	6004591	6004592	6004991	6004992	6005231	6005232	6006491	6006492	6007511	6007512	6008141	6008142	6010121	6010122	6010281	6010282	6010481	6010482	6011591	6011592	6012561	6012562	6013991	6013992	6022351	6022352	6024081	6024082	6032061	6032062	6032791	6032792];
eqNumberLIST_forProcessing_SetDel22B = [6001731	6001732	6002481	6002482	6002651	6002652	6002901	6002902	6004061	6004062	6004151	6004152	6004581	6004582	6005641	6005642	6005891	6005892	6007511	6007512	6007891	6007892	6008091	6008092	6009681	6009682	6009871	6009872	6010121	6010122	6010191	6010192	6010301	6010302	6010481	6010482	6010851	6010852	6011491	6011492	6016111	6016112	6023951	6023952];
eqNumberLIST_forProcessing_SetDel22C = [6000341	6000342	6001831	6001832	6003141	6003142	6004091	6004092	6004191	6004192	6004991	6004992	6005301	6005302	6006391	6006392	6007691	6007692	6009081	6009082	6009701	6009702	6009711	6009712	6009871	6009872	6010121	6010122	6010301	6010302	6012571	6012572	6016111	6016112	6017361	6017362	6023951	6023952	6029501	6029502	6032061	6032062	6032861	6032862];
eqNumberLIST_forProcessing_SetDel22D = [6000311	6000312	6001601	6001602	6001831	6001832	6002121	6002122	6002851	6002852	6003411	6003412	6003521	6003522	6004081	6004082	6004091	6004092	6004571	6004572	6004581	6004582	6004611	6004612	6006331	6006332	6006921	6006922	6007861	6007862	6009521	6009522	6009681	6009682	6009871	6009872	6011351	6011352	6014361	6014362	6023951	6023952	6026271	6026272];

eqNumberLIST = eqNumberLIST_forProcessing_SetDel22A;

cd C:\OpenSeesProcessingFiles\EQ_Spectra_Saved    
for eqFileIndex = 1:length(eqNumberLIST)
    eqNumber = eqNumberLIST(eqFileIndex);
    
    respSpecFile = sprintf('SaEQSpectrum_EQ_%i.mat', eqNumber);
    load(respSpecFile, 'dampRatioLIST', 'periodVector', 'SaAbs');
    
    dampRatIndex = find(dampRatioLIST == dampRat);
    SaVector = SaAbs(:, dampRatIndex);
    
    SaT1curr = interp1(periodVector, SaVector, T1);
    scalingFac(eqFileIndex) = SaT1toMatch / SaT1curr;
end

for i = 1:22
    scalingFacForGeoM(i) = sqrt(scalingFac(1, 2*i-1) * scalingFac(1, 2*i));
end
    case '12h.PlotTH_Tiles_P695AndBRBGF_SaT1_etc'
%%
eqNumberLIST_forProcessing_SetC = [120111, 120112, 120121, 120122,	120411, 120412,	120521, 120522,	120611, 120612,	120621, 120622,	120711, 120712,	120721, 120722,	120811, 120812,	120821, 120822,	120911, 120912,	120921, 120922,	121011, 121012,	121021, 121022,	121111, 121112,	121211, 121212,	121221, 121222,	121321, 121322,	121411, 121412,	121421, 121422,	121511, 121512,	121711, 121712];
eqNumberLIST_forProcessing_SetMumbai22 = [6018001	6018002	6034201	6034202	6151301	6151302	6105601	6105602	6282101	6282102	6302701	6302702	6055201	6055202	6278401	6278402	6002501	6002502	6265901	6265902	6072601	6072602	6326401	6326402	6096301	6096302	6350801	6350802	6092101	6092102	6280901	6280902	6095901	6095902	6332601	6332602	6108601	6108602	6032201	6032202	6279301	6279302	6159401	6159402];
eqNumLIST_forProc_SetMum22_2p56 =  [6031401	6031402	6057501	6057502	6075401	6075402	6088401	6088402	6104601	6104602	6122401	6122402	6127701	6127702	6150401	6150402	6151201	6151202	6176801	6176802	6182301	6182302	6184101	6184102	6227901	6227902	6229201	6229202	6271601	6271602	6296401	6296402	6322301	6322302	6322401	6322402	6324501	6324502	6331401	6331402	6336701	6336702	6347701	6347702];
eqNumberLIST_forProc_SetNBCC2020_Sca_4p37 = [80011  80012  80021  80022  80031  80032  80041  80042  80051  80052  80061  80062  80071  80072  80081  80082  80091  80092  80101  80102  80111  80112  80121  80122  80131  80132  80141  80142  80151  80152  80161  80162  80171  80172  80181  80182  80191  80192  80201  80202  80211  80212  80221  80222  80231  80232  80241  80242  80251  80252  80261  80262  80271  80272  80281  80282  80291  80292  80301  80302  80311  80312  80321  80322  80331  80332  80341  80342  80351  80352  80361  80362  80371  80372  80381  80382  80391  80392  80401  80402];
eqNumberLIST_forProc_SetNBCC2020_Sca_1p5 = [90011	90012	90021	90022	90031	90032	90041	90042	90051	90052	90061	90062	90071	90072	90081	90082	90091	90092	90101	90102	90111	90112	90121	90122	90131	90132	90141	90142	90151	90152	90161	90162	90171	90172	90181	90182	90191	90192	90201	90202	90211	90212	90221	90222	90231	90232	90241	90242	90251	90252	90261	90262	90271	90272	90281	90282	90291	90292	90301	90302	90311	90312	90321	90322	90331	90332	90341	90342	90351	90352	90361	90362	90371	90372	90381	90382	90391	90392	90401	90402];

%% Extracted using H:\PrakRuns\plotTilesOfTH_findScalingToMatchSaT1
% after plotting the Mum22 gorund motion TH, I realize that their recorded values may look very small. Although, we were only interested in the
% spectral shape and is properly captured when observed from their scaled response spectra plot, the unscaled TH may look misleading. I am matching the TH
% records at the time period of itnerest, for that we need a scaling factor vector for each ground motion record as pasted below. 
scalingFac_Mum22 = [1.60470472404101,1.15871779801047,5.54114839753086,4.72050185693739,3.21397162430637,3.33879967653935,13.2558910579220,17.6046719604827,44.1117098558757,33.2965564297709,14.0153861156973,16.4263182614307,25.2884490388267,32.0957792278379,29.0910241838224,34.9565873030183,25.0708572036182,51.0478431410993,46.3101316104107,34.2047888106734,7.52873370194707,5.51975679362145,6.39268633316492,2.58057965154017,2.29463966174961,1.53362321213012,39.0322779596288,32.8904916014467,5.27304550578247,10.1031660784479,44.2506838831783,22.6874977838954,1.90971020236413,1.10245468925225,25.8687862124822,27.1024813389907,0.986926496896329,0.804126803921969,4.71608739323727,5.39238510716810,59.2432640119116,42.8823498822727,19.3974398561256,33.4059670996266];
scalingFac_NBCC_4p37 = [4.605	4.9813	3.6854	1.6063	1.1843	4.0333	3.5793	3.006	4.4852	2.7342	2.0055	1.6104	2.1665	4.8628	1.9723	2.6378	2.9245	3.6926	2.6495	3.1798	3.9714	0.6411	1.9292	2.368	4.6066	2.1239	1.7261	4.6159	4.8198	2.8923	3.7098	4.0482	3.5187	2.4229	1.3092	1.0248	2.3212	1.2642	0.6614	2.2952];
scalingFac_NBCC_4p37 = kron(scalingFac_NBCC_4p37, [1, 1]); % 'cause equal scaling for both components

scalingFac_NBCC_1p5 = [1.5232	3.55	4.099	4.5206	4.5591	2.3206	3.3719	4.8626	2.3002	2.5976	3.224	1.7274	3.2125	3.7175	1.8527	4.1192	2.4402	1.4834	1.8078	1.4433	1.8456	1.7786	1.7336	3.5543	3.9317	4.1293	3.8716	3.8775	0.7144	1.2064	1.0272	3.5942	3.2214	3.0753	4.7233	2.7865	1.8337	2.1348	4.7466	2.3877];
scalingFac_NBCC_1p5 = kron(scalingFac_NBCC_1p5, [1, 1]); % 'cause equal scaling for both components

% eqNumberLIST = eqNumberLIST_forProcessing_SetC;  suiteName =
% 'GroundMotionTHP695'; scaleTHForPlot = 0; scalingFac = scalingFac_Mum22; doSave = 0; 
eqNumberLIST = eqNumberLIST_forProc_SetNBCC2020_Sca_1p5; suiteName = 'GMSetNBCC2020_Sca_1p5'; 
scaleTHForPlot = 1; scalingFac = scalingFac_NBCC_1p5; doSave = 0; 

%% eqNumberLIST = eqNumLIST_forProc_SetMum22_2p56;  suiteName = 'GroundMotionTHMum22_2p56'; % gm records are not in the C drive
% eqNumberLIST = eqNumberLIST_forProcessing_SetMumbai22; suiteName = 'GroundMotionTHMum22_2p12'; scaleTHForPlot = 1;


strForLegend = {''}; % {'880101'}; %'121411'      '121412'      '121421'      '121422'};

% eqNumberLIST = eqNumberLIST_forProcessing_SetC; %[121422];
tMax = 30; % curtail the plot until tMax sec
aMax = 0.5; % plot the acceleration until aMax g
numGM = size(eqNumberLIST, 2);

% set(gcf, 'Position',  [10, 10, 900, 600])

rangeSplit = [1 20; 21 40; 41 60; 61 80];
for i = 1:size(rangeSplit, 1)
 cd C:\OpenSeesProcessingFiles\EQs%\ORIGINAL_TIME_HISTORIES
    currEqRange = rangeSplit(i, 1):rangeSplit(i, 2);
    count = 0;
%     f(1) = figure;
    figure('units','inch','position',[2,1,8.1,9]);
    for eqFileIndex = currEqRange%length(eqNumberLIST)
        count = count + 1;
        eqNumber = eqNumberLIST(eqFileIndex);
        eqFolder = sprintf('EQ_%d',eqNumber);
        
        dt = load(sprintf('DtFile_(%i).txt', eqNumber));
        numPoints = load(sprintf('NumPointsFile_(%i).txt', eqNumber));
        GMTimeHistory = load(sprintf('SortedEQFile_(%i).txt', eqNumber));
        timeArray = 0:dt:dt * (numPoints - 1);
        
        numTileRows = 5; numTileCols = 4;

        subplot(numTileRows, numTileCols, count);

%         if scaleTHForPlot == 1
%             PGA_target = 0.25 + 0.35 * rand; % random PGA target between 0.25 and 0.60g
%             scaleFac = PGA_target/max(abs(GMTimeHistory));
%         end
        
        if scaleTHForPlot == 1
            scaleFac = scalingFac(eqFileIndex);
        else 
            scaleFac = 1;
        end
        % plot(timeArray, xDisplArray,'-','color',C{outputFileIndex},'LineWidth',1.0); hold on;
        plot(timeArray, scaleFac * GMTimeHistory, 'k-','LineWidth',0.1); hold on; grid on;
        
        if ~isempty(find([1:numTileCols:numGM] == eqFileIndex, 1))
            hy = ylabel('a_g (g) ');
        end
        
%         if ~isempty(find([21:24, 41:44] == eqFileIndex, 1))
        if ~isempty(find((rangeSplit(i, end) - numTileCols + 1 : rangeSplit(i, end)) == eqFileIndex, 1))
            hx = xlabel('Time (s)');
        end
        
        %     htitle = title('Time History of Input GM');
        ylim([-0.5 0.5]);
%         xlim([0 tMax]);
        %     legend(strForLegend{eqFileIndex});
        legend(num2str(eqNumber));
%         set(gca, 'XTick', [0:5:tMax])
        set(gca, 'YTick', [-aMax:0.25:aMax])
        %     psb_FigureFormatScript_forReport
    end
    set(gcf, 'Renderer', 'painters');
    if doSave == 1
        extensions = {'fig', 'epsc'}; 
        cd 'C:\Users\prak\OneDrive - University of California, Davis\FII_BRB_Results\OpenQuake_GM_Outputs\TH_plots_1p5'
        exportName = sprintf('%s_to%i', suiteName, eqFileIndex);
        for k = 1:length(extensions); 	saveas(gcf, exportName, extensions{k}); end
        fprintf("Figures saved in %s.\n", pwd);
    end
end
cd(baseFolder);

    case '13.countNumberOfAnalyses'
%% (approximate run time- 30 sec)
%%%%%%%%%%%%%%%%%%%%%%%%% start of the input %%%%%%%%%%%%%%%%%%%%%%%%%% 
% cd H:\PrakRuns\Output\
% cd '(CivilBldg_3story_ID9901_v.13_5pcRayleigh_1st2ndMode_K_commit)_(AllVar)_(0.00)_(clough)'
% cd '(CivilBldg_3story_ID9901_v.10_5pcRayleighIn1stN3rdMode)_(AllVar)_(0.00)_(clough)'

cd I:\PrakRuns_I\Output\(ID2206_R3_7Story_v.05_ShearHingeModel1C_full_DamSt)_(AllVar)_(0.00)_(clough)

eqNumberLIST_forProcessing_SetC = [120111, 120112, 120121, 120122,	120411, 120412,	120521, 120522,	120611, 120612,	120621, 120622,	120711, 120712,	120721, 120722,	120811, 120812,	120821, 120822,	120911, 120912,	120921, 120922,	121011, 121012,	121021, 121022,	121111, 121112,	121211, 121212,	121221, 121222,	121321, 121322,	121411, 121412,	121421, 121422,	121511, 121512,	121711, 121712];
eqNumLIST = eqNumberLIST_forProcessing_SetC;

% buildingID = 9901; % used for naming the graph only
saInitial = 0.01; % very low value, to avoid prompting user for input every time
saFinal = 5.01; % very high value, to avoid prompting user for input every time

for eqIndex = 1:length(eqNumLIST)
    currentEq = eqNumLIST(eqIndex);
    currentEqFolder = sprintf('EQ_%s', num2str(currentEq)); 
    cd(currentEqFolder)
    
    currentSa = saInitial; % initiate
    saIndex = 0; % counter of number of Sa Indices
    
% % Store Data for this one EQ
% while currentSa <= saFinal %saIndex < 10 
%     currentSaFolder = sprintf('Sa_%s', num2str(currentSa)); 
%     if(~exist(currentSaFolder, 'dir'))
%         currentSa = currentSa + 0.01;
%         continue
%     end
% % % do following if the folder with Sa value exists
%     saIndex = saIndex + 1;
%     
% %     cd(currentSaFolder)
% %     cd RunInformation
% %     minutesToRun(eqIndex, saIndex) = load('minutesToRunThisAnalysisOUT.out');
% %     cd ..
% %     cd .. % back to the currentEqFolder. For processing next Sa
%     listOfAnalyzedSa{eqIndex}.listOfSa(saIndex) = currentSa;
% 
%     currentSa = currentSa + 0.01;
% end

        load DATA_CollapseResultsForThisSingleEQ.mat saLevelForEachRun;
        saValLIST = saLevelForEachRun(saLevelForEachRun > 0.01); % eliminate non-zero values
        saValLIST = sort(saValLIST); % this command makes "load DATA algo" same as the "searching algo"
        
        listOfAnalyzedSa{eqIndex}.listOfSa = saValLIST;
        
    cd .. % back to specific output folder for processing next Eq
end

%% finding total number of analyses
numOfAnalyzedSa = 0;
for i = 1:44
    numOfAnalyzedSa = numOfAnalyzedSa + length(listOfAnalyzedSa{1,i}.listOfSa); 
end

%% finding total number of analyses used for zeroing in on sa_collapse
% this includes everything between Sa_noCollapse and Sa_collapse using startStepSize
numOfAnalysesForZeroingIn = zeros(1, length(eqNumLIST));
for eqIndex = 1:length(eqNumLIST)
    numOfAnalysesForCurrentEq = length(listOfAnalyzedSa{eqIndex}.listOfSa);

        for saIndex = 1:numOfAnalysesForCurrentEq
            count = 0;
            % 0.10 is based on the fact that as of now, 0.20 is startStepSize and 0.02 is tolerance
            if(listOfAnalyzedSa{eqIndex}.listOfSa(saIndex+1) - listOfAnalyzedSa{eqIndex}.listOfSa(saIndex) <= 0.10)
                numOfAnalysesForZeroingIn(1, eqIndex) = numOfAnalysesForCurrentEq - saIndex - 1;
                break;
            end
        end
end

fprintf('Total Number of analyses for all EQs is %i \n', numOfAnalyzedSa);
fprintf('Number of analyses required for zeroing in is %i \n', sum(numOfAnalysesForZeroingIn));

    case '14.copyFilesIntoManyFolders'
%%        
        eqNumberLIST_forProcessing_SetC = [120111, 120112, 120121, 120122,	120411, 120412,	120521, 120522,	120611, 120612,	120621, 120622,	120711, 120712,	120721, 120722,	120811, 120812,	120821, 120822,	120911, 120912,	120921, 120922,	121011, 121012,	121021, 121022,	121111, 121112,	121211, 121212,	121221, 121222,	121321, 121322,	121411, 121412,	121421, 121422,	121511, 121512,	121711, 121712];        
        eqNumberLIST = eqNumberLIST_forProcessing_SetC;

        copyingFromDirectory = 'H:\PrakRuns\Models\CivilBldg_3story_ID9901_v.01_trying';
        pastingToDirectory = 'H:\PrakRuns\Models\CivilBldg_3story_ID9901_v.01_trying';
        fileNameTocopy = 'psb_SetAnalysisOptions.tcl';
        
        baseFolder = pwd;
        
        for eqNumberIndex = 1:length(eqNumberLIST)
            eqNumber = eqNumberLIST(eqNumberIndex);
            
%             eqDirectory = sprintf('EQ_%d',eqNumber);
            eqDirectory = sprintf('model_%d',eqNumber);
            
            cd(copyingFromDirectory)
%             cd(eqDirectory) % NOTE THAT I'M COPYING ALL THE FILES from CopyingDirectory right now. 
                            % In other cases, it might be
                            % required to cd to the respective eqDirectory for copying

            directoryToPasteIn = sprintf('%s\\%s',pastingToDirectory, eqDirectory);
            copyfile(fileNameTocopy, directoryToPasteIn)
            cd ..
        end
        
    case '14a.RenameAndReplaceFilesBasedOnSomeRule'
%%
%         function prak_util_renameAndCopyMultipleFiles2_Mumbai260()
        baseFolder = pwd;
        folderWithData = 'H:\GMSelection_New\temp1';
%         folderWithData = 'H:\GMSelection_New\2.PEERNGA_AllDownloadedRecords_Unformatted_RenamedWithEqID';
%         folderWithData = 'H:\GMSelection_New\3.PEERNGA_AllDownloadedRecords_Sorted';
%         folderWithData = 'H:\GMSelection_New\4.CurtailedTH';
%         folderWithData = 'H:\GMSelection_New\5.ResponseSpectra';
%         folderWithData = 'H:\GMSelection_New\6.TempFormatted';

        cd(folderWithData)
%         listOfFiles = dir('*).txt'); 
        listOfFiles = dir('*_EQ_6*.mat'); % list of spectral acceleration files
        
        folderForCopying = folderWithData;
        folderForPasting = folderWithData;
        warning('off') % turning warnings off, since FileRename function apparently throws multiple errors citing to some issue with the mex compiler that has probably to do with the macOS 
        for i = 1:size(listOfFiles, 1)
            oldFileName = listOfFiles(i, 1).name;
%% type-1 
%             startCharPos = strfind(oldFileName, '(') + 1;
%             endCharPos = strfind(oldFileName, ')') - 1;
%% type-2    
            startCharPos = strfind(oldFileName, '_6') + 1;
            endCharPos = strfind(oldFileName, '.mat') - 1;

            oldEqID = str2double(oldFileName(startCharPos:endCharPos));
            oldDirID = mod(oldEqID, 10);
            RSN = floor((oldEqID - 6000000)/100);
            newEqID = (6*100000 + RSN)*10 + oldDirID;

%             newFileName = sprintf('UnformattedFile_(%i).at2', newEqID);
            newFileName = [oldFileName(1:startCharPos-1), num2str(newEqID), oldFileName(endCharPos+1:end)];
            
            if exist(oldFileName) == 0
                warning('%s not found \n',oldFileName);
            end
            
            FileRename(fullfile(folderForCopying, oldFileName), fullfile(folderForPasting , newFileName));
        end
        warning('on'); % turning the warnings back on.
%% the following function is already placed in the PATH of matlab, and hence is not required on my machine.
        % pasting it here if have to use on other machine. To avoid the pain of
        % having to deal with two files. (PSB)

%         function [Status, Msg] = FileRename(Source, Dest, Mode)
%         % Rename file or folder
%         % This function renames the existing file or folder specified by the string
%         % Source to the name given by the string Dest. You can use FileRename to move
%         % a file from one folder to another folder or drive, but folders can be renamed
%         % only, not moved.
%         %
%         % Files and folders can be renamed by Matlab's MOVEFILE also, but this C-Mex is
%         % faster (timings vary with the size and number of the files due to the
%         % caching of write operations by the hard disk and the OS):
%         %    Matlab 2009a: 4 to 50 times faster,
%         %    Matlab 6.5:   1600 times faster (!).
%         %
%         % [Status, Msg] = FileRename(Source, Dest, [Mode])
%         % INPUT:
%         %   Source: String, name of the source file or folder.
%         %           Unicode and UNC paths are considered.
%         %   Dest:   String, name of the destination file or folder.
%         %   Mode:   String, if 'forced' an existing Dest file is overwritten,
%         %           if it is not write protected. Folders are *not* overwritten.
%         %           Optional, default: 'DoNotOverwrite'.
%         %
%         % OUTPUT:
%         %   Status: Scalar DOUBLE. Optional.
%         %            0: Success
%         %           -1: Source is not existing
%         %           -2: Dest is existing already
%         %           -3: Dest is write protected, in forced [Mode] only
%         %           -4: Unknown problems:
%         %               Source or Dest is accessed from another program,
%         %               Source is a folder and Dest is on another drive.
%         %   Msg: String, empty on success, some information in case of problems.
%         %
%         % COMPILE: The fast C-Mex file must be compiled before using.
%         %   See FileRename.c for details.
%         %
%         % Tested: Matlab 6.5, 7.7, 7.8, WinXP, 32bit
%         %         Compiler: LCC2.4, OWC1.8, BCC5.5, MSVC2008
%         % Assumed Compatibility: higher Matlab versions, Mac, Linux, 64bit
%         % Author: Jan Simon, Heidelberg, (C) 2006-2010 matlab.THISYEAR(a)nMINUSsimon.de
% 
%         % $JRev: R0c V:002 Sum:k2h6PfSIX+16 Date:29-Nov-2010 01:15:58 $
%         % $License: BSD $
%         % $UnitTest: uTest_FileRename $
%         % $File: Tools\GLFile\FileRename.m $
%         % History:
% 
%         % Initialize: ==================================================================
%         persistent Warned
%         if isempty(Warned)
%             %    warning(['JSimon:', mfilename, ':NoMex'], ...
%             %       'Cannot find compiled Mex. MOVEFILE is used instead.');
%         end
% 
%         % Do the work: =================================================================
%         % Fast alternative, but slower than the C-Mex:
%         %   java.io.File(Source).renameTo(java.io.File(Dest));
% 
%         if nargin == 2
%             %    [Status, Msg] = movefile(Source, Dest);
%             [Status, Msg] = copyfile(Source, Dest);
%         elseif nargin == 3
%             %    [Status, Msg] = movefile(Source, Dest, Mode);
%             [Status, Msg] = copyfile(Source, Dest, Mode);
%         else
%             error(['JSimon:', mfilename, ':BadNInput'], ...
%                 [mfilename, ': 2 or 3 inputs required.']);
%         end
% 
%         % Handle problems:
%         if Status ~= 1
%             if ~exist(Source, 'file')
%                 Status = -1;
%             elseif exist(Dest, 'file')
%                 Status = -2;
%             elseif exist(Dest, 'dir')  % Or write protected
%                 Status = -3;
%             else
%                 Status = -4;
%             end
%         end
% 
%         return;
%         end

    case '14ap.RenameAndReplaceFilesBasedOnSomeRule'
%%
%         function prak_util_renameAndCopyMultipleFiles2_Mumbai260()
        baseFolder = pwd;
        folderWithData = 'I:\PrakRuns_I\New folder';
        cd(folderWithData)
        listOfFiles = dir('*.m'); 
%         listOfFiles = dir('*_EQ_6*.mat'); % list of spectral acceleration files
        newFileNameLIST = {'psb_MasterDriver_RunAndProcessDynamicAnalyses_ID2207v09.m'	'psb_MasterDriver_RunAndProcessDynamicAnalyses_ID2209v05.m'	'psb_MasterDriver_RunAndProcessDynamicAnalyses_ID2211v03.m'	'psb_MasterDriver_RunAndProcessDynamicAnalyses_ID2213v04.m'	'psb_MasterDriver_RunAndProcessDynamicAnalyses_ID2451v02.m'	'psb_MasterDriver_RunAndProcessDynamicAnalyses_ID2453v02.m'	'psb_MasterDriver_RunAndProcessDynamicAnalyses_ID2215v03.m'	'psb_MasterDriver_RunAndProcessDynamicAnalyses_ID2217v03.m'	'psb_MasterDriver_RunAndProcessDynamicAnalyses_ID2219v03.m'	'psb_MasterDriver_RunAndProcessDynamicAnalyses_ID2221v06.m'	'psb_MasterDriver_RunAndProcessDynamicAnalyses_ID2433v02.m'	'psb_MasterDriver_RunAndProcessDynamicAnalyses_ID2435v02.m'	'psb_MasterDriver_RunAndProcessDynamicAnalyses_ID2223v03.m'	'psb_MasterDriver_RunAndProcessDynamicAnalyses_ID2457v01.m'	'psb_MasterDriver_RunAndProcessDynamicAnalyses_ID2459v01.m'	'psb_MasterDriver_RunAndProcessDynamicAnalyses_ID2461v01.m'	'psb_MasterDriver_RunAndProcessDynamicAnalyses_ID2463v01.m'	'psb_MasterDriver_RunAndProcessDynamicAnalyses_ID2225v03.m'	'psb_MasterDriver_RunAndProcessDynamicAnalyses_ID2227v05.m'	'psb_MasterDriver_RunAndProcessDynamicAnalyses_ID2437v02.m'	'psb_MasterDriver_RunAndProcessDynamicAnalyses_ID2439v02.m'	'psb_MasterDriver_RunAndProcessDynamicAnalyses_ID2229v03.m'	'psb_MasterDriver_RunAndProcessDynamicAnalyses_ID2231v04.m'	'psb_MasterDriver_RunAndProcessDynamicAnalyses_ID2441v02.m'	'psb_MasterDriver_RunAndProcessDynamicAnalyses_ID2443v02.m'	'psb_MasterDriver_RunAndProcessDynamicAnalyses_ID2233v03.m'	'psb_MasterDriver_RunAndProcessDynamicAnalyses_ID2235v04.m'	'psb_MasterDriver_RunAndProcessDynamicAnalyses_ID2445v02.m'	'psb_MasterDriver_RunAndProcessDynamicAnalyses_ID2447v02a.m'	'psb_MasterDriver_RunAndProcessDynamicAnalyses_ID2237v03a.m'};

        folderForCopying = folderWithData;
        folderForPasting = folderWithData;
        warning('off') % turning warnings off, since FileRename function apparently throws multiple errors citing to some issue with the mex compiler that has probably to do with the macOS 
        for i = 1:size(listOfFiles, 1)
            oldFileName = listOfFiles(i, 1).name;
%% type-1 
%             startCharPos = strfind(oldFileName, '(') + 1;
%             endCharPos = strfind(oldFileName, ')') - 1;
%% type-2    
            startCharPos = strfind(oldFileName, '_6') + 1;
            endCharPos = strfind(oldFileName, '.mat') - 1;

            oldEqID = str2double(oldFileName(startCharPos:endCharPos));
            oldDirID = mod(oldEqID, 10);
            RSN = floor((oldEqID - 6000000)/100);
            newEqID = (6*100000 + RSN)*10 + oldDirID;

%             newFileName = sprintf('UnformattedFile_(%i).at2', newEqID);
%             newFileName = [oldFileName(1:startCharPos-1), num2str(newEqID), oldFileName(endCharPos+1:end)];
            newFileName = newFileNameLIST{1, i};
            
            if exist(oldFileName) == 0
                warning('%s not found \n',oldFileName);
            end
            
            FileRename(fullfile(folderForCopying, oldFileName), fullfile(folderForPasting , newFileName));
        end
        warning('on'); % turning the warnings back on.
%% the following function is already placed in the PATH of matlab, and hence is not required on my machine.
        % pasting it here if have to use on other machine. To avoid the pain of
        % having to deal with two files. (PSB)

%         function [Status, Msg] = FileRename(Source, Dest, Mode)
%         % Rename file or folder
%         % This function renames the existing file or folder specified by the string
%         % Source to the name given by the string Dest. You can use FileRename to move
%         % a file from one folder to another folder or drive, but folders can be renamed
%         % only, not moved.
%         %
%         % Files and folders can be renamed by Matlab's MOVEFILE also, but this C-Mex is
%         % faster (timings vary with the size and number of the files due to the
%         % caching of write operations by the hard disk and the OS):
%         %    Matlab 2009a: 4 to 50 times faster,
%         %    Matlab 6.5:   1600 times faster (!).
%         %
%         % [Status, Msg] = FileRename(Source, Dest, [Mode])
%         % INPUT:
%         %   Source: String, name of the source file or folder.
%         %           Unicode and UNC paths are considered.
%         %   Dest:   String, name of the destination file or folder.
%         %   Mode:   String, if 'forced' an existing Dest file is overwritten,
%         %           if it is not write protected. Folders are *not* overwritten.
%         %           Optional, default: 'DoNotOverwrite'.
%         %
%         % OUTPUT:
%         %   Status: Scalar DOUBLE. Optional.
%         %            0: Success
%         %           -1: Source is not existing
%         %           -2: Dest is existing already
%         %           -3: Dest is write protected, in forced [Mode] only
%         %           -4: Unknown problems:
%         %               Source or Dest is accessed from another program,
%         %               Source is a folder and Dest is on another drive.
%         %   Msg: String, empty on success, some information in case of problems.
%         %
%         % COMPILE: The fast C-Mex file must be compiled before using.
%         %   See FileRename.c for details.
%         %
%         % Tested: Matlab 6.5, 7.7, 7.8, WinXP, 32bit
%         %         Compiler: LCC2.4, OWC1.8, BCC5.5, MSVC2008
%         % Assumed Compatibility: higher Matlab versions, Mac, Linux, 64bit
%         % Author: Jan Simon, Heidelberg, (C) 2006-2010 matlab.THISYEAR(a)nMINUSsimon.de
% 
%         % $JRev: R0c V:002 Sum:k2h6PfSIX+16 Date:29-Nov-2010 01:15:58 $
%         % $License: BSD $
%         % $UnitTest: uTest_FileRename $
%         % $File: Tools\GLFile\FileRename.m $
%         % History:
% 
%         % Initialize: ==================================================================
%         persistent Warned
%         if isempty(Warned)
%             %    warning(['JSimon:', mfilename, ':NoMex'], ...
%             %       'Cannot find compiled Mex. MOVEFILE is used instead.');
%         end
% 
%         % Do the work: =================================================================
%         % Fast alternative, but slower than the C-Mex:
%         %   java.io.File(Source).renameTo(java.io.File(Dest));
% 
%         if nargin == 2
%             %    [Status, Msg] = movefile(Source, Dest);
%             [Status, Msg] = copyfile(Source, Dest);
%         elseif nargin == 3
%             %    [Status, Msg] = movefile(Source, Dest, Mode);
%             [Status, Msg] = copyfile(Source, Dest, Mode);
%         else
%             error(['JSimon:', mfilename, ':BadNInput'], ...
%                 [mfilename, ': 2 or 3 inputs required.']);
%         end
% 
%         % Handle problems:
%         if Status ~= 1
%             if ~exist(Source, 'file')
%                 Status = -1;
%             elseif exist(Dest, 'file')
%                 Status = -2;
%             elseif exist(Dest, 'dir')  % Or write protected
%                 Status = -3;
%             else
%                 Status = -4;
%             end
%         end
% 
%         return;
%         end

    case '14app.RenameAndReplaceFilesBasedOnSomeRule'
%%
% % % % % % % % % % % %  RULE % % % % % % % % % % % %  
% For reducing # characters in filename, change the names starting with 
% psb_MasterDriver_RunAndProcessDynamicAnalyses_ID to psb_MasterDriver_RunNProcDynAna_

oldPrefix = 'psb_MasterDriver_RunAndProcessDynamicAnalyses_ID';
newPrefix = 'psb_MasterDriver_RunNProcDynAna_';

        baseFolder = pwd;
%         folderWithData = 'I:\PrakRuns_I\Move it back to PrakRuns_I\temp';
        folderWithData = 'H:\PrakRuns\temp';
        cd(folderWithData)
        listOfFiles = dir('*.m'); 
%         listOfFiles = dir('*_EQ_6*.mat'); % list of spectral acceleration files
%         newFileNameLIST = {'psb_MasterDriver_RunAndProcessDynamicAnalyses_ID2207v09.m'	'psb_MasterDriver_RunAndProcessDynamicAnalyses_ID2209v05.m'	'psb_MasterDriver_RunAndProcessDynamicAnalyses_ID2211v03.m'	'psb_MasterDriver_RunAndProcessDynamicAnalyses_ID2213v04.m'	'psb_MasterDriver_RunAndProcessDynamicAnalyses_ID2451v02.m'	'psb_MasterDriver_RunAndProcessDynamicAnalyses_ID2453v02.m'	'psb_MasterDriver_RunAndProcessDynamicAnalyses_ID2215v03.m'	'psb_MasterDriver_RunAndProcessDynamicAnalyses_ID2217v03.m'	'psb_MasterDriver_RunAndProcessDynamicAnalyses_ID2219v03.m'	'psb_MasterDriver_RunAndProcessDynamicAnalyses_ID2221v06.m'	'psb_MasterDriver_RunAndProcessDynamicAnalyses_ID2433v02.m'	'psb_MasterDriver_RunAndProcessDynamicAnalyses_ID2435v02.m'	'psb_MasterDriver_RunAndProcessDynamicAnalyses_ID2223v03.m'	'psb_MasterDriver_RunAndProcessDynamicAnalyses_ID2457v01.m'	'psb_MasterDriver_RunAndProcessDynamicAnalyses_ID2459v01.m'	'psb_MasterDriver_RunAndProcessDynamicAnalyses_ID2461v01.m'	'psb_MasterDriver_RunAndProcessDynamicAnalyses_ID2463v01.m'	'psb_MasterDriver_RunAndProcessDynamicAnalyses_ID2225v03.m'	'psb_MasterDriver_RunAndProcessDynamicAnalyses_ID2227v05.m'	'psb_MasterDriver_RunAndProcessDynamicAnalyses_ID2437v02.m'	'psb_MasterDriver_RunAndProcessDynamicAnalyses_ID2439v02.m'	'psb_MasterDriver_RunAndProcessDynamicAnalyses_ID2229v03.m'	'psb_MasterDriver_RunAndProcessDynamicAnalyses_ID2231v04.m'	'psb_MasterDriver_RunAndProcessDynamicAnalyses_ID2441v02.m'	'psb_MasterDriver_RunAndProcessDynamicAnalyses_ID2443v02.m'	'psb_MasterDriver_RunAndProcessDynamicAnalyses_ID2233v03.m'	'psb_MasterDriver_RunAndProcessDynamicAnalyses_ID2235v04.m'	'psb_MasterDriver_RunAndProcessDynamicAnalyses_ID2445v02.m'	'psb_MasterDriver_RunAndProcessDynamicAnalyses_ID2447v02a.m'	'psb_MasterDriver_RunAndProcessDynamicAnalyses_ID2237v03a.m'};

        folderForCopying = folderWithData;
        folderForPasting = folderWithData;
        warning('off') % turning warnings off, since FileRename function apparently throws multiple errors citing to some issue with the mex compiler that has probably to do with the macOS 
        for i = 1:size(listOfFiles, 1)
            oldFileName = listOfFiles(i, 1).name;
%% type-1 
%             startCharPos = strfind(oldFileName, '(') + 1;
%             endCharPos = strfind(oldFileName, ')') - 1;
%% type-2    
%             startCharPos = strfind(oldFileName, 'psb_MasterDriver_RunAndProcessDynamicAnalyses_ID') + 1;
%             endCharPos = strfind(oldFileName, '_ID') - 3;

%             oldEqID = str2double(oldFileName(startCharPos:endCharPos));
%             oldDirID = mod(oldEqID, 10);
%             RSN = floor((oldEqID - 6000000)/100);
%             newEqID = (6*100000 + RSN)*10 + oldDirID;

%             newFileName = sprintf('UnformattedFile_(%i).at2', newEqID);
%             newFileName = [oldFileName(1:startCharPos-1), num2str(newEqID), oldFileName(endCharPos+1:end)];
%             newFileName = newFileNameLIST{1, i};

            newFileName = strrep(oldFileName, oldPrefix, newPrefix);
            
            if exist(oldFileName) == 0
                warning('%s not found \n',oldFileName);
            end
            
            FileRename(fullfile(folderForCopying, oldFileName), fullfile(folderForPasting , newFileName));
        end
        warning('on'); % turning the warnings back on.
        
    case '14b.changeVariableNamesInSeveralMatFile'
%%
            folderWithData = 'H:\GMSelection_New\temp1';
            cd(folderWithData)
            listOfFiles = dir('*_EQ_6*.mat'); % list of spectral acceleration files
            for i = 1:size(listOfFiles, 1)
                matFileName = listOfFiles(i, 1).name;
                startCharPos = strfind(matFileName , '_6') + 1;
                endCharPos = strfind(matFileName , '.mat') - 1;

                newEqID = str2double(matFileName(startCharPos:endCharPos));
                m = matfile(matFileName,'Writable',true);
                % eqCompNum = m.eqCompNum; % without explicitly opening data file, we can access the variables
                m.eqCompNum = newEqID;
            end
            
    case '14c.copySingleFileToManyFolders'
%%        
        copyingFromDirectory = 'K:\Models\ID30401_XZ_R0_4Story_v.02';
        pasteToMainDir = 'I:\PrakRuns_I\Models\Archetypical SMRF_v21';
        fileNameTocopy = 'psb_SaveRunInformationAfterEQ.tcl';
        foldersForPasting1 ={'ID2207_R5_7Story_v.09'; % rename to comment out
                        'ID2209_R5_12Story_v.05';
                        'ID2211_R5_2Story_v.03';
                        'ID2213_R5_4Story_v.04';
                        'ID2215_R5_7Story_v.03';
                        'ID2217_R5_12Story_v.03';
                        'ID2219_R5_2Story_v.03';
                        'ID2221_R5_4Story_v.06';
                        'ID2223_R5_7Story_v.03';
                        'ID2225_R5_12Story_v.03';
                        'ID2227_R5_4Story_v.05';
                        'ID2229_R5_7Story_v.03';
                        'ID2231_R5_4Story_v.04';
                        'ID2233_R5_7Story_v.03';
                        'ID2235_R5_4Story_v.04';
                        'ID2237_R5_7Story_v.03a';
                        'ID2433_R5_5Story_v.02';
                        'ID2435_R5_6Story_v.02';
                        'ID2437_R5_5Story_v.02';
                        'ID2439_R5_6Story_v.02';
                        'ID2441_R5_5Story_v.02';
                        'ID2443_R5_6Story_v.02';
                        'ID2445_R5_5Story_v.02';
                        'ID2447_R5_6Story_v.02a';
                        'ID2451_R5_5Story_v.02';
                        'ID2453_R5_6Story_v.02';
                        'ID2457_R5_8Story_v.01';
                        'ID2459_R5_9Story_v.01';
                        'ID2461_R5_10Story_v.01';
                        'ID2463_R5_11Story_v.01';
                            };      
        
    foldersForPasting ={'ID30401_XZ_R0_4Story_v.02';
                        'ID30402_YZ_R0_4Story_v.02';
                        'ID30421_XZ_R0_4Story_v.02';
                        'ID30422_YZ_R0_4Story_v.02';
                        'ID30441_XZ_R0_4Story_v.02';
                        'ID30442_YZ_R0_4Story_v.02';
                        'ID30451_XZ_R0_4Story_v.02';
                        'ID30452_YZ_R0_4Story_v.02';
                        'ID30471_XZ_R0_4Story_v.02';
                        'ID30472_YZ_R0_4Story_v.02';};      

        baseFolder = pwd;
        for subDirIndex = 1:length(foldersForPasting)
            currenDir = foldersForPasting{subDirIndex};
            cd(copyingFromDirectory)
            directoryToPasteIn = sprintf('%s\\%s', pasteToMainDir, currenDir);
            copyfile(fileNameTocopy, directoryToPasteIn)
            cd ..
        end
          
    case '14d.copyFilesFromOneLayerForBackup'
%%        
%         copyingFromDirMain = 'I:\PrakRuns_I\Models\Archetypical SMRF_v21_SPO_1893 + IDA';
%         pastingToDirMain = 'C:\Users\prak.iitb1\Drive-2\20200216 Full BACKUP (Creating)\I drive\PrakRuns_I\Models\Archetypical SMRF_v21_SPO_1893 + IDA';

        copyingFromDirMain = 'I:\DesignOfBuildingsModels';
        pastingToDirMain = 'C:\Users\prak.iitb1\Drive-2\20200216 Full BACKUP (Creating)\I drive\DesignOfBuildingsModels';
        
        subDirectories = {    
'(model 1 for 2206 variation) 2301 R3_7story (2301, 2306, 2311 use it)'
'(model 2 for 2206 variation) 2316 R3_7story (2316 uses it)'
'(model 3 for 2206 variation) 2319 R3_7story (2319 uses it)'
'(model 4 for 2206 variation) 2321 R3_7story (2321 uses it)'
'(model 5 for 2206 variation) 2206 R3_7story_v06 (2206 uses it)'
'2203 R5_2story'
'2205 R5_4story'
'2206 R3_7story Paper_1'
'2207 R5_7story Paper_1'
'2208 R3_12story'
'2208 R3_12story_OLD'
'2209 R5_12story'
'2211 R5_2story'
'2213 R5_4story'
'2215 R5_7story'
'2217 R5_12story'
'2219 R5_2story'
'2221 R5_4story'
'2221 R5_4story_equalGF'
'2223 R5_7story'
'2225 R5_12story'
'2227 R5_4story'
'2229 R5_7story'
'2231 R5_4story'
'2233 R5_7story'
'2235 R5_4story'
'2237 R5_7story'
'2238 R3_2story'
'2433 R5_5story'
'2435 R5_6story'
'2437 R5_5story'
'2439 R5_6story'
'2441 R5_5story'
'2443 R5_6story'
'2445 R5_5story'
'2447 R5_6story'
'2449 R5_3story'
'2451 R5_5story'
'2453 R5_6story'
'2455 R5_3story'
'2457 R5_8story'
'2459 R5_9story'
'2461 R5_10story'
'2463 R5_11story'
'2507 R5_7story'
'2509 R5_12story'
'2511 R5_2story'
'2513 R5_4story'
'2515 R5_7story'
'2517 R5_12story'
'2521 R5_4story'
'2527 R5_4story'
'2XXX 12story for Level Labels'
% '3040 1893-1984_4story'
% '3042 R5_4story'
% '3044 R3_5story'
% '3045 R5_4story'
% '3047 R5_4story'
'3219 R0_2story'
'3221 R0_4story'
'3227 R0_4story'
'3231 R0_4story'
'3235 R0_4story'
'3437 R0_5story'
'3441 R0_5story'
'3445 R0_5story'
            };

%         fileNameTocopy = '*.tcl';
        fileNameTocopy = '*.EDB';
        
        baseFolder = pwd;
        
        for subDirIndex = 1:size(subDirectories, 1)
            subDir = subDirectories{subDirIndex, 1};
            
            copyingFromDirActual = sprintf('%s\\%s',copyingFromDirMain, subDir);
            cd(copyingFromDirActual);

            pastingToDirMainActual = sprintf('%s\\%s',pastingToDirMain, subDir);
            copyfile(fileNameTocopy, pastingToDirMainActual)
            cd ..
        end
        
    case '15.FindModalParticipationFactorAndModeShapes'
%%
%     cd K:\Output\(ID2221_R5_4Story_v.06)_(AllVar)_(0.00)_(clough)
    cd K:\Output\(ID2205_R5_4Story_v.03)_(AllVar)_(0.00)_(clough)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%% COPY this data from GeneralExcelSheet %%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%     M = [0.069012689
% 0.069922413
% 0.073561313
% 0.006961353
% ]; % mass per floor. First value is for topmost floor. ID-9901v15

%     M = [0.224765558
% 	0.224765558
% 	0.224765558
% 	0.224765558
% 	0.225137092
% 	0.225137092
% 	0.227101924]; % mass per floor. First value is for topmost floor. ID-2207v01

%     M = [0.226962322
%         0.226962322
%         0.226962322
%         0.226962322
%         0.226999376
%         0.226999376
%         0.228291425]; % mass per floor. First value is for topmost floor. ID-2206v03
    
%     M = [0.08547305
%         0.08547305
%         0.08547305
%         0.086122898]; % mass per floor. First value is for topmost floor. ID-3045v02
    
%     M = [0.086264335
%         0.086264335
%         0.086264335
%         0.087090023]; % 30471_XZ. mass per floor. First value is for topmost floor. ID-3045v02

%     M = [0.143523509
%         0.143523509
%         0.143523509
%         0.145037271]; % 30472_YZ. mass per floor. First value is for topmost floor. ID-3045v02

%     M = [0.257714908
%         0.257714908
%         0.257714908
%         0.259190443]; % 2221

    M = [0.25162737
        0.25162737
        0.25162737
        0.252674771]; % 2205


    totalMass = sum(M); % find the total mass. To be used later to find modal contribution
    g = 9810; % mm/sec^2
    W = fliplr(M' * g)'; % flipped the array and multiplied with g.
                       % Now the order is same as that for eigenVectors i.e. first value is for bottom-most floor
    
    cd MatlabInformation
    eigenValArray = load('eigenvaluesOUT.out');
    eigenVecArray = load('eigenVectorOUT.out');
    floorHeightList = load('floorHeightLISTOUT.out');

    firstSensibleEigenVector = find(eigenValArray > 0.50, 1, 'first'); % find first sensible EigenVector Column
    
    eigenValArray = eigenValArray(eigenValArray > 0.50); % removing spurious eigen values. 0.5 eigenvalue corresponds to 8.9 sec time period
    timePeriod = 2 * pi ./ sqrt(eigenValArray);
    
%     eigenVecArray = eigenVecArray(:, firstSensibleEigenVector:end); % removing spurious eigen vectors
    eigenVecArray = eigenVecArray(:, firstSensibleEigenVector:4); % removing spurious eigen vectors
    
%%% finding modal mass for each modes
    modalMass = zeros(1, size(eigenVecArray, 2)); % initiate the modal mass
    modalContribution = zeros(1, size(eigenVecArray, 2)); % initiate the modal contribution

    for modeNum = 1:size(eigenVecArray, 2)
        modalMass(modeNum) = (sum(W .* eigenVecArray(2:end, modeNum)) ^ 2) / (g * sum(W .* eigenVecArray(2:end, modeNum) .* eigenVecArray(2:end, modeNum)));
        modalContribution(modeNum) = modalMass(modeNum) / totalMass * 100; % in percentage
    end
    
    hFigure = figure(1);
    x = 500; y = 0; width = 400; height = 1000;
    set(hFigure, 'Position', [x y width height]);
    C = {'r','b','g','k','m',[.5 .6 .7],[.8 .2 .6],'r','b','g','k','m',[.5 .6 .7],[.8 .2 .6]}; % Cell array of 7 colors.
    strForLegend = [];
    
    for modeNum = 1:size(eigenVecArray, 2)
        currPlotData = [eigenVecArray(:, modeNum)'; floorHeightList'/1000];
%         plot(currPlotData(1, :), currPlotData(2, :)); 
        hold on; grid on; fnplt(cscvn(currPlotData), 'color', C{modeNum}, 5);
        strForLegend{modeNum} = sprintf('Mode %i', modeNum);
    end
    
    legh = legend(strForLegend); set(gca, 'XTick', []);
    htitle = title('Mode Shape of the Structure');
    
    psb_FigureFormatScript
    
    fprintf('Natural Time Periods of the structure are: \n');
    disp(timePeriod);
    
    fprintf('Modal contribution factor are: \n');
    disp(modalContribution);
    
    case '15a.FindModalParticipationFactorAndModeShapes_Multiple'
%%
    outpDirLIST = {'K:\Output\(ID2207_R5_7Story_v.09)_(AllVar)_(0.00)_(clough)'
        'K:\Output\(ID2209_R5_12Story_v.05)_(AllVar)_(0.00)_(clough)'
        'K:\Output\(ID2211_R5_2Story_v.03)_(AllVar)_(0.00)_(clough)'
        'K:\Output\(ID2213_R5_4Story_v.04)_(AllVar)_(0.00)_(clough)'
        'K:\Output\(ID2451_R5_5Story_v.02)_(AllVar)_(0.00)_(clough)'
        'K:\Output\(ID2453_R5_6Story_v.02)_(AllVar)_(0.00)_(clough)'
        'K:\Output\(ID2215_R5_7Story_v.03)_(AllVar)_(0.00)_(clough)'
        'K:\Output\(ID2217_R5_12Story_v.03)_(AllVar)_(0.00)_(clough)'
        'K:\Output\(ID2219_R5_2Story_v.03)_(AllVar)_(0.00)_(clough)'
        'K:\Output\(ID2221_R5_4Story_v.06)_(AllVar)_(0.00)_(clough)'
        'K:\Output\(ID2433_R5_5Story_v.02)_(AllVar)_(0.00)_(clough)'
        'K:\Output\(ID2435_R5_6Story_v.02)_(AllVar)_(0.00)_(clough)'
        'K:\Output\(ID2223_R5_7Story_v.03)_(AllVar)_(0.00)_(clough)'
        'K:\Output\(ID2457_R5_8Story_v.01)_(AllVar)_(0.00)_(clough)'
        'K:\Output\(ID2459_R5_9Story_v.01)_(AllVar)_(0.00)_(clough)'
        'K:\Output\(ID2461_R5_10Story_v.01)_(AllVar)_(0.00)_(clough)'
        'K:\Output\(ID2463_R5_11Story_v.01)_(AllVar)_(0.00)_(clough)'
        'K:\Output\(ID2225_R5_12Story_v.03)_(AllVar)_(0.00)_(clough)'
        'K:\Output\(ID2227_R5_4Story_v.05)_(AllVar)_(0.00)_(clough)'
        'K:\Output\(ID2437_R5_5Story_v.02)_(AllVar)_(0.00)_(clough)'
        'K:\Output\(ID2439_R5_6Story_v.02)_(AllVar)_(0.00)_(clough)'
        'K:\Output\(ID2229_R5_7Story_v.03)_(AllVar)_(0.00)_(clough)'
        'K:\Output\(ID2231_R5_4Story_v.04)_(AllVar)_(0.00)_(clough)'
        'K:\Output\(ID2441_R5_5Story_v.02)_(AllVar)_(0.00)_(clough)'
        'K:\Output\(ID2443_R5_6Story_v.02)_(AllVar)_(0.00)_(clough)'
        'K:\Output\(ID2233_R5_7Story_v.03)_(AllVar)_(0.00)_(clough)'
        'K:\Output\(ID2235_R5_4Story_v.04)_(AllVar)_(0.00)_(clough)'
        'K:\Output\(ID2445_R5_5Story_v.02)_(AllVar)_(0.00)_(clough)'
        'K:\Output\(ID2447_R5_6Story_v.02a)_(AllVar)_(0.00)_(clough)'
        'K:\Output\(ID2237_R5_7Story_v.03a)_(AllVar)_(0.00)_(clough)'
        };
    
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%% COPY this data from GeneralExcelSheet %%%%%%%%%%%%%%%%%
%%%%% COPY entire mass data from SummaryOfAllRuns SeisW&Mass sheet %%%%%%
%%%%%%%%%%%%%%%%%%% First value is for topmost floor. %%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
   
%     massLIST = [
%     0.252389985	0.251908333	0.25162737	0.252389985	0.25162737	0.25162737	0.253513838	0.256872018	0.252670948	0.257714908	0.256791743	0.256791743	0.257915596	0.25835711	0.257193119	0.257193119	0.257193119	0.25835711	0.426291539	0.424525484	0.424525484	0.426492227	0.121131498	0.120248471	0.120879205	0.120879205	0.200152905	0.198639144	0.199900612	0.199900612
%     0.252389985	0.251908333	0.252674771	0.252389985	0.25162737	0.25162737	0.253513838	0.256872018	0.253917125	0.257714908	0.256791743	0.256791743	0.257915596	0.25835711	0.257193119	0.257193119	0.257193119	0.25835711	0.426291539	0.424525484	0.424525484	0.426492227	0.121131498	0.120248471	0.120879205	0.120879205	0.200152905	0.198639144	0.199900612	0.199900612
%     0.252389985	0.251908333	0	0.252389985	0.253032187	0.25162737	0.253513838	0.256872018	0	0.257714908	0.25835711	0.256791743	0.257915596	0.25835711	0.257193119	0.257193119	0.257193119	0.25835711	0.426291539	0.426933741	0.424525484	0.426492227	0.121131498	0.12184633	0.120879205	0.120879205	0.200152905	0.201582569	0.199900612	0.199900612
%     0.252389985	0.251908333	0	0.253582645	0.253032187	0.254196177	0.253513838	0.256872018	0	0.259190443	0.25835711	0.259601376	0.257915596	0.25835711	0.259601376	0.259601376	0.259601376	0.25835711	0.428692151	0.426933741	0.429101172	0.426492227	0.121987768	0.12184633	0.122098624	0.122182722	0.201498471	0.201582569	0.201834862	0.20191896
%     0.254798242	0.255119343	0	0	0.254347171	0.254196177	0.255119343	0.25936055	0	0	0.259954969	0.259601376	0.259601376	0.25835711	0.259601376	0.259601376	0.259601376	0.261447706	0	0.429456677	0.429101172	0.429101172	0	0.122832569	0.122098624	0.122182722	0	0.203188073	0.201834862	0.20191896
%     0.254798242	0.255119343	0	0	0	0.255732875	0.255119343	0.25936055	0	0	0	0.261436239	0.259601376	0.261086468	0.259601376	0.259601376	0.259601376	0.261447706	0	0	0.432036952	0.429101172	0	0	0.123130734	0.122182722	0	0	0.203486239	0.20191896
%     0.256449618	0.255119343	0	0	0	0	0.256831881	0.25936055	0	0	0	0	0.261436239	0.261086468	0.261447706	0.259601376	0.259601376	0.261447706	0	0	0	0.432036952	0	0	0	0.123230122	0	0	0	0.203585627
%     0	0.255119343	0	0	0	0	0	0.25936055	0	0	0	0	0	0.263204205	0.261447706	0.261447706	0.261447706	0.261447706	0	0	0	0	0	0	0	0	0	0	0	0
%     0	0.257969113	0	0	0	0	0	0.262170183	0	0	0	0	0	0	0.263634251	0.261447706	0.261447706	0.263053211	0	0	0	0	0	0	0	0	0	0	0	0
%     0	0.257969113	0	0	0	0	0	0.262170183	0	0	0	0	0	0	0	0.263634251	0.261447706	0.263053211	0	0	0	0	0	0	0	0	0	0	0	0
%     0	0.257969113	0	0	0	0	0	0.262170183	0	0	0	0	0	0	0	0	0.263634251	0.263053211	0	0	0	0	0	0	0	0	0	0	0	0
%     0	0.260224465	0	0	0	0	0	0.264494343	0	0	0	0	0	0	0	0	0	0.265545566	0	0	0	0	0	0	0	0	0	0	0	0];

    massLIST = {[	0.252389985	0.252389985	0.252389985	0.252389985	0.254798242	0.254798242	0.256449618						];
    [	0.251908333	0.251908333	0.251908333	0.251908333	0.255119343	0.255119343	0.255119343	0.255119343	0.257969113	0.257969113	0.257969113	0.260224465	];
    [	0.25162737	0.252674771											];
    [	0.252389985	0.252389985	0.252389985	0.253582645									];
    [	0.25162737	0.25162737	0.253032187	0.253032187	0.254347171								];
    [	0.25162737	0.25162737	0.25162737	0.254196177	0.254196177	0.255732875							];
    [	0.253513838	0.253513838	0.253513838	0.253513838	0.255119343	0.255119343	0.256831881						];
    [	0.256872018	0.256872018	0.256872018	0.256872018	0.25936055	0.25936055	0.25936055	0.25936055	0.262170183	0.262170183	0.262170183	0.264494343	];
    [	0.252670948	0.253917125											];
    [	0.257714908	0.257714908	0.257714908	0.259190443									];
    [	0.256791743	0.256791743	0.25835711	0.25835711	0.259954969								];
    [	0.256791743	0.256791743	0.256791743	0.259601376	0.259601376	0.261436239							];
    [	0.257915596	0.257915596	0.257915596	0.257915596	0.259601376	0.259601376	0.261436239						];
    [	0.25835711	0.25835711	0.25835711	0.25835711	0.25835711	0.261086468	0.261086468	0.263204205					];
    [	0.257193119	0.257193119	0.257193119	0.259601376	0.259601376	0.259601376	0.261447706	0.261447706	0.263634251				];
    [	0.257193119	0.257193119	0.257193119	0.259601376	0.259601376	0.259601376	0.259601376	0.261447706	0.261447706	0.263634251			];
    [	0.257193119	0.257193119	0.257193119	0.259601376	0.259601376	0.259601376	0.259601376	0.261447706	0.261447706	0.261447706	0.263634251		];
    [	0.25835711	0.25835711	0.25835711	0.25835711	0.261447706	0.261447706	0.261447706	0.261447706	0.263053211	0.263053211	0.263053211	0.265545566	];
    [	0.426291539	0.426291539	0.426291539	0.428692151									];
    [	0.424525484	0.424525484	0.426933741	0.426933741	0.429456677								];
    [	0.424525484	0.424525484	0.424525484	0.429101172	0.429101172	0.432036952							];
    [	0.426492227	0.426492227	0.426492227	0.426492227	0.429101172	0.429101172	0.432036952						];
    [	0.121131498	0.121131498	0.121131498	0.121987768									];
    [	0.120248471	0.120248471	0.12184633	0.12184633	0.122832569								];
    [	0.120879205	0.120879205	0.120879205	0.122098624	0.122098624	0.123130734							];
    [	0.120879205	0.120879205	0.120879205	0.122182722	0.122182722	0.122182722	0.123230122						];
    [	0.200152905	0.200152905	0.200152905	0.201498471									];
    [	0.198639144	0.198639144	0.201582569	0.201582569	0.203188073								];
    [	0.199900612	0.199900612	0.199900612	0.201834862	0.201834862	0.203486239							];
    [	0.199900612	0.199900612	0.199900612	0.20191896	0.20191896	0.20191896	0.203585627						]};


    
    
for i = 1:length(outpDirLIST)
    currOutpDir = outpDirLIST{i};
    cd(currOutpDir);
        
    currM = massLIST{i}';
%     currM(currM == 0) = []; % remove zero entries towards the end; NOT needed anymore
    M = currM;
    
    totalMass = sum(M); % find the total mass. To be used later to find modal contribution
    g = 9810; % mm/sec^2
    W = fliplr(M' * g)'; % flipped the array and multiplied with g.
                       % Now the order is same as that for eigenVectors i.e. first value is for bottom-most floor
    
    cd MatlabInformation
    eigenValArray = load('eigenvaluesOUT.out');
    eigenVecArray = load('eigenVectorOUT.out');
    floorHeightList = load('floorHeightLISTOUT.out');

    firstSensibleEigenVector = find(eigenValArray > 0.50, 1, 'first'); % find first sensible EigenVector Column
    
    eigenValArray = eigenValArray(eigenValArray > 0.50); % removing spurious eigen values. 0.5 eigenvalue corresponds to 8.9 sec time period
    timePeriod = 2 * pi ./ sqrt(eigenValArray);
    timePeriodLIST(i, :) = timePeriod;
    
    eigenVecArray = eigenVecArray(:, firstSensibleEigenVector:end); % removing spurious eigen vectors
%     eigenVecArray = eigenVecArray(:, firstSensibleEigenVector:6); % removing spurious eigen vectors
    
%%% finding modal mass for each modes
    modalMass = zeros(1, size(eigenVecArray, 2)); % initiate the modal mass
    modalContribution = zeros(1, size(eigenVecArray, 2)); % initiate the modal contribution

    for modeNum = 1:size(eigenVecArray, 2)
        modalMass(modeNum) = (sum(W .* eigenVecArray(2:end, modeNum)) ^ 2) / (g * sum(W .* eigenVecArray(2:end, modeNum) .* eigenVecArray(2:end, modeNum)));
        modalContribution(modeNum) = modalMass(modeNum) / totalMass * 100; % in percentage
    end
    modalContributionLIST(i, :) = modalContribution;

    hFigure = figure(i);
    x = 500; y = 0; width = 400; height = 1000;
    set(hFigure, 'Position', [x y width height]);
    C = {'r','b','g','k','m',[.5 .6 .7],[.8 .2 .6],'r','b','g','k','m',[.5 .6 .7],[.8 .2 .6]}; % Cell array of 7 colors.
    strForLegend = [];
    
    for modeNum = 1:4 % size(eigenVecArray, 2)
        currPlotData = [eigenVecArray(:, modeNum)'; floorHeightList'/1000];
%         plot(currPlotData(1, :), currPlotData(2, :)); 
        hold on; grid on; fnplt(cscvn(currPlotData), 'color', C{modeNum}, 5);
        strForLegend{modeNum} = sprintf('Mode %i', modeNum);
        if modeNum == 1 % save first mode shape 
            firstModeShapeLIST{i} = eigenVecArray(:, modeNum)';
        end
    end
    
    legh = legend(strForLegend); set(gca, 'XTick', []);
    htitle = title('Mode Shape of the Structure');
    
    psb_FigureFormatScript
    
    fprintf('(%i/%i) Natural Time Periods of the structure are: \n', i, length(outpDirLIST));
    disp(timePeriod);
    
    fprintf('Modal contribution factor are: \n');
    disp(modalContribution);
    fprintf('------------------------------- \n');
end

    case '15b.FindModalParticipationFactorAndModeShapes_Examiner'
%%
    outpDirLIST = {'K:\Output\(ID2207_R5_7Story_v.09)_(AllVar)_(0.00)_(clough)'
        'K:\Output\(ID2209_R5_12Story_v.05)_(AllVar)_(0.00)_(clough)'
        'K:\Output\(ID2211_R5_2Story_v.03)_(AllVar)_(0.00)_(clough)'
        'K:\Output\(ID2213_R5_4Story_v.04)_(AllVar)_(0.00)_(clough)'
        'K:\Output\(ID2451_R5_5Story_v.02)_(AllVar)_(0.00)_(clough)'
        'K:\Output\(ID2453_R5_6Story_v.02)_(AllVar)_(0.00)_(clough)'
        'K:\Output\(ID2215_R5_7Story_v.03)_(AllVar)_(0.00)_(clough)'
        'K:\Output\(ID2217_R5_12Story_v.03)_(AllVar)_(0.00)_(clough)'
        'K:\Output\(ID2219_R5_2Story_v.03)_(AllVar)_(0.00)_(clough)'
        'K:\Output\(ID2221_R5_4Story_v.06)_(AllVar)_(0.00)_(clough)'
        'K:\Output\(ID2433_R5_5Story_v.02)_(AllVar)_(0.00)_(clough)'
        'K:\Output\(ID2435_R5_6Story_v.02)_(AllVar)_(0.00)_(clough)'
        'K:\Output\(ID2223_R5_7Story_v.03)_(AllVar)_(0.00)_(clough)'
        'K:\Output\(ID2457_R5_8Story_v.01)_(AllVar)_(0.00)_(clough)'
        'K:\Output\(ID2459_R5_9Story_v.01)_(AllVar)_(0.00)_(clough)'
        'K:\Output\(ID2461_R5_10Story_v.01)_(AllVar)_(0.00)_(clough)'
        'K:\Output\(ID2463_R5_11Story_v.01)_(AllVar)_(0.00)_(clough)'
        'K:\Output\(ID2225_R5_12Story_v.03)_(AllVar)_(0.00)_(clough)'
        'K:\Output\(ID2227_R5_4Story_v.05)_(AllVar)_(0.00)_(clough)'
        'K:\Output\(ID2437_R5_5Story_v.02)_(AllVar)_(0.00)_(clough)'
        'K:\Output\(ID2439_R5_6Story_v.02)_(AllVar)_(0.00)_(clough)'
        'K:\Output\(ID2229_R5_7Story_v.03)_(AllVar)_(0.00)_(clough)'
        'K:\Output\(ID2231_R5_4Story_v.04)_(AllVar)_(0.00)_(clough)'
        'K:\Output\(ID2441_R5_5Story_v.02)_(AllVar)_(0.00)_(clough)'
        'K:\Output\(ID2443_R5_6Story_v.02)_(AllVar)_(0.00)_(clough)'
        'K:\Output\(ID2233_R5_7Story_v.03)_(AllVar)_(0.00)_(clough)'
        'K:\Output\(ID2235_R5_4Story_v.04)_(AllVar)_(0.00)_(clough)'
        'K:\Output\(ID2445_R5_5Story_v.02)_(AllVar)_(0.00)_(clough)'
        'K:\Output\(ID2447_R5_6Story_v.02a)_(AllVar)_(0.00)_(clough)'
        'K:\Output\(ID2237_R5_7Story_v.03a)_(AllVar)_(0.00)_(clough)'
        };
    
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%% COPY this data from GeneralExcelSheet %%%%%%%%%%%%%%%%%
%%%%% COPY entire mass data from SummaryOfAllRuns SeisW&Mass sheet %%%%%%
%%%%%%%%%%%%%%%%%%% First value is for topmost floor. %%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
   
%     massLIST = [
%     0.252389985	0.251908333	0.25162737	0.252389985	0.25162737	0.25162737	0.253513838	0.256872018	0.252670948	0.257714908	0.256791743	0.256791743	0.257915596	0.25835711	0.257193119	0.257193119	0.257193119	0.25835711	0.426291539	0.424525484	0.424525484	0.426492227	0.121131498	0.120248471	0.120879205	0.120879205	0.200152905	0.198639144	0.199900612	0.199900612
%     0.252389985	0.251908333	0.252674771	0.252389985	0.25162737	0.25162737	0.253513838	0.256872018	0.253917125	0.257714908	0.256791743	0.256791743	0.257915596	0.25835711	0.257193119	0.257193119	0.257193119	0.25835711	0.426291539	0.424525484	0.424525484	0.426492227	0.121131498	0.120248471	0.120879205	0.120879205	0.200152905	0.198639144	0.199900612	0.199900612
%     0.252389985	0.251908333	0	0.252389985	0.253032187	0.25162737	0.253513838	0.256872018	0	0.257714908	0.25835711	0.256791743	0.257915596	0.25835711	0.257193119	0.257193119	0.257193119	0.25835711	0.426291539	0.426933741	0.424525484	0.426492227	0.121131498	0.12184633	0.120879205	0.120879205	0.200152905	0.201582569	0.199900612	0.199900612
%     0.252389985	0.251908333	0	0.253582645	0.253032187	0.254196177	0.253513838	0.256872018	0	0.259190443	0.25835711	0.259601376	0.257915596	0.25835711	0.259601376	0.259601376	0.259601376	0.25835711	0.428692151	0.426933741	0.429101172	0.426492227	0.121987768	0.12184633	0.122098624	0.122182722	0.201498471	0.201582569	0.201834862	0.20191896
%     0.254798242	0.255119343	0	0	0.254347171	0.254196177	0.255119343	0.25936055	0	0	0.259954969	0.259601376	0.259601376	0.25835711	0.259601376	0.259601376	0.259601376	0.261447706	0	0.429456677	0.429101172	0.429101172	0	0.122832569	0.122098624	0.122182722	0	0.203188073	0.201834862	0.20191896
%     0.254798242	0.255119343	0	0	0	0.255732875	0.255119343	0.25936055	0	0	0	0.261436239	0.259601376	0.261086468	0.259601376	0.259601376	0.259601376	0.261447706	0	0	0.432036952	0.429101172	0	0	0.123130734	0.122182722	0	0	0.203486239	0.20191896
%     0.256449618	0.255119343	0	0	0	0	0.256831881	0.25936055	0	0	0	0	0.261436239	0.261086468	0.261447706	0.259601376	0.259601376	0.261447706	0	0	0	0.432036952	0	0	0	0.123230122	0	0	0	0.203585627
%     0	0.255119343	0	0	0	0	0	0.25936055	0	0	0	0	0	0.263204205	0.261447706	0.261447706	0.261447706	0.261447706	0	0	0	0	0	0	0	0	0	0	0	0
%     0	0.257969113	0	0	0	0	0	0.262170183	0	0	0	0	0	0	0.263634251	0.261447706	0.261447706	0.263053211	0	0	0	0	0	0	0	0	0	0	0	0
%     0	0.257969113	0	0	0	0	0	0.262170183	0	0	0	0	0	0	0	0.263634251	0.261447706	0.263053211	0	0	0	0	0	0	0	0	0	0	0	0
%     0	0.257969113	0	0	0	0	0	0.262170183	0	0	0	0	0	0	0	0	0.263634251	0.263053211	0	0	0	0	0	0	0	0	0	0	0	0
%     0	0.260224465	0	0	0	0	0	0.264494343	0	0	0	0	0	0	0	0	0	0.265545566	0	0	0	0	0	0	0	0	0	0	0	0];

    massLIST = {[	0.252389985	0.252389985	0.252389985	0.252389985	0.254798242	0.254798242	0.256449618						];
    [	0.251908333	0.251908333	0.251908333	0.251908333	0.255119343	0.255119343	0.255119343	0.255119343	0.257969113	0.257969113	0.257969113	0.260224465	];
    [	0.25162737	0.252674771											];
    [	0.252389985	0.252389985	0.252389985	0.253582645									];
    [	0.25162737	0.25162737	0.253032187	0.253032187	0.254347171								];
    [	0.25162737	0.25162737	0.25162737	0.254196177	0.254196177	0.255732875							];
    [	0.253513838	0.253513838	0.253513838	0.253513838	0.255119343	0.255119343	0.256831881						];
    [	0.256872018	0.256872018	0.256872018	0.256872018	0.25936055	0.25936055	0.25936055	0.25936055	0.262170183	0.262170183	0.262170183	0.264494343	];
    [	0.252670948	0.253917125											];
    [	0.257714908	0.257714908	0.257714908	0.259190443									];
    [	0.256791743	0.256791743	0.25835711	0.25835711	0.259954969								];
    [	0.256791743	0.256791743	0.256791743	0.259601376	0.259601376	0.261436239							];
    [	0.257915596	0.257915596	0.257915596	0.257915596	0.259601376	0.259601376	0.261436239						];
    [	0.25835711	0.25835711	0.25835711	0.25835711	0.25835711	0.261086468	0.261086468	0.263204205					];
    [	0.257193119	0.257193119	0.257193119	0.259601376	0.259601376	0.259601376	0.261447706	0.261447706	0.263634251				];
    [	0.257193119	0.257193119	0.257193119	0.259601376	0.259601376	0.259601376	0.259601376	0.261447706	0.261447706	0.263634251			];
    [	0.257193119	0.257193119	0.257193119	0.259601376	0.259601376	0.259601376	0.259601376	0.261447706	0.261447706	0.261447706	0.263634251		];
    [	0.25835711	0.25835711	0.25835711	0.25835711	0.261447706	0.261447706	0.261447706	0.261447706	0.263053211	0.263053211	0.263053211	0.265545566	];
    [	0.426291539	0.426291539	0.426291539	0.428692151									];
    [	0.424525484	0.424525484	0.426933741	0.426933741	0.429456677								];
    [	0.424525484	0.424525484	0.424525484	0.429101172	0.429101172	0.432036952							];
    [	0.426492227	0.426492227	0.426492227	0.426492227	0.429101172	0.429101172	0.432036952						];
    [	0.121131498	0.121131498	0.121131498	0.121987768									];
    [	0.120248471	0.120248471	0.12184633	0.12184633	0.122832569								];
    [	0.120879205	0.120879205	0.120879205	0.122098624	0.122098624	0.123130734							];
    [	0.120879205	0.120879205	0.120879205	0.122182722	0.122182722	0.122182722	0.123230122						];
    [	0.200152905	0.200152905	0.200152905	0.201498471									];
    [	0.198639144	0.198639144	0.201582569	0.201582569	0.203188073								];
    [	0.199900612	0.199900612	0.199900612	0.201834862	0.201834862	0.203486239							];
    [	0.199900612	0.199900612	0.199900612	0.20191896	0.20191896	0.20191896	0.203585627						]};


    
    
% for i = 1:length(outpDirLIST)
for i = 3:8 % for examiner report
    currOutpDir = outpDirLIST{i};
    cd(currOutpDir);
        
    currM = massLIST{i}';
%     currM(currM == 0) = []; % remove zero entries towards the end; NOT needed anymore
    M = currM;
    
    totalMass = sum(M); % find the total mass. To be used later to find modal contribution
    g = 9810; % mm/sec^2
    W = fliplr(M' * g)'; % flipped the array and multiplied with g.
                       % Now the order is same as that for eigenVectors i.e. first value is for bottom-most floor
    
    cd MatlabInformation
    eigenValArray = load('eigenvaluesOUT.out');
    eigenVecArray = load('eigenVectorOUT.out');
    floorHeightList = load('floorHeightLISTOUT.out');

    firstSensibleEigenVector = find(eigenValArray > 0.50, 1, 'first'); % find first sensible EigenVector Column
    
    eigenValArray = eigenValArray(eigenValArray > 0.50); % removing spurious eigen values. 0.5 eigenvalue corresponds to 8.9 sec time period
    timePeriod = 2 * pi ./ sqrt(eigenValArray);
    timePeriodLIST(i, :) = timePeriod;
    
    eigenVecArray = eigenVecArray(:, firstSensibleEigenVector:end); % removing spurious eigen vectors
%     eigenVecArray = eigenVecArray(:, firstSensibleEigenVector:6); % removing spurious eigen vectors
    
%%% finding modal mass for each modes
    modalMass = zeros(1, size(eigenVecArray, 2)); % initiate the modal mass
    modalContribution = zeros(1, size(eigenVecArray, 2)); % initiate the modal contribution

    for modeNum = 1:size(eigenVecArray, 2)
        modalMass(modeNum) = (sum(W .* eigenVecArray(2:end, modeNum)) ^ 2) / (g * sum(W .* eigenVecArray(2:end, modeNum) .* eigenVecArray(2:end, modeNum)));
        modalContribution(modeNum) = modalMass(modeNum) / totalMass * 100; % in percentage
    end
    modalContributionLIST(i, :) = modalContribution;

    hFigure = figure(i);
    x = 500; y = 0; width = 400; height = 1000;
    set(hFigure, 'Position', [x y width height]);
    C = {'r','b','g','k','m',[.5 .6 .7],[.8 .2 .6],'r','b','g','k','m',[.5 .6 .7],[.8 .2 .6]}; % Cell array of 7 colors.
    strForLegend = [];
    
    for modeNum = 1:1 % size(eigenVecArray, 2)
        eigenVecArray(:, modeNum) = abs(eigenVecArray(:, modeNum)) / max(abs(eigenVecArray(:, modeNum)));
        
        currPlotData = [eigenVecArray(:, modeNum)'; floorHeightList'/1000];
%         plot(currPlotData(1, :), currPlotData(2, :)); 
        hold on; grid on; fnplt(cscvn(currPlotData), 'color', C{modeNum}, 3);
        
        normalizedHt = floorHeightList/floorHeightList(end);
        
        currParabola = [(normalizedHt'.^2); floorHeightList'/1000];
        fnplt(cscvn(currParabola), 'color', 'b', 3);
        
        strForLegend{modeNum} = sprintf('Mode %i', modeNum);
        if modeNum == 1 % save first mode shape 
            firstModeShapeLIST{i} = eigenVecArray(:, modeNum)';
        end
    end
    
    strForLegend = [strForLegend, 'Parabola']; 
    legh = legend(strForLegend, 'Location', 'NorthWest'); set(gca, 'XTick', []);
%     htitle = title('Mode Shape of the Structure');
    
    psb_FigureFormatScript
    
    fprintf('(%i/%i) Natural Time Periods of the structure are: \n', i, length(outpDirLIST));
    disp(timePeriod);
    
    fprintf('Modal contribution factor are: \n');
    disp(modalContribution);
    fprintf('------------------------------- \n');
    cd(baseFolder)
    print('-dmeta', ['modeShape_' num2str(i)]); % .emf file for Windows (MSWORD)
    pwd
end


    case '15c.FindModalParticipationFactorAndModeShapes_ResBldgs'
%%
    outpDirLIST = {'C:\ResilAnaOS_psb\Output\(ID1310_v.01_FF)_(AllVar)_(0.00)_(clough)'
                   'C:\ResilAnaOS_psb\Output\(ID1610_v.01_FF)_(AllVar)_(0.00)_(clough)'
                   'C:\ResilAnaOS_psb\Output\(ID1910_v.01_FF)_(AllVar)_(0.00)_(clough)'
        };
    
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%% COPY this data from GeneralExcelSheet Or, %%%%%%%%%%%%%%%%%
%%%%% COPY entire mass data from SummaryOfAllRuns SeisW&Mass sheet %%%%%%
%%%%%%%%%%%%%%%%%%% First value is for topmost floor. %%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
   
    massLIST = {[0.097251254	0.097251254	0.097251254									                                                ];
                [0.097862407	0.097862407	0.097862407	0.095573429	0.095573429	0.095573429						                        ];
                [0.095013333	0.095013333	0.095013333	0.095013333	0.095013333	0.095013333	0.097251254	0.097251254	0.097251254			]};

for i = 1:length(outpDirLIST)
    currOutpDir = outpDirLIST{i};
    cd(currOutpDir);
        
    currM = massLIST{i}';
%     currM(currM == 0) = []; % remove zero entries towards the end; NOT needed anymore
    M = currM;
    
    totalMass = sum(M); % find the total mass. To be used later to find modal contribution
    g = 9810; % mm/sec^2
    W = fliplr(M' * g)'; % flipped the array and multiplied with g.
                       % Now the order is same as that for eigenVectors i.e. first value is for bottom-most floor
    
    cd MatlabInformation
    eigenValArray = load('eigenvaluesOUT.out');
    eigenVecArray = load('eigenVectorOUT.out');
    floorHeightList = load('floorHeightLISTOUT.out');

    firstSensibleEigenVector = find(eigenValArray > 0.50, 1, 'first'); % find first sensible EigenVector Column
    
    eigenValArray = eigenValArray(eigenValArray > 0.50); % removing spurious eigen values. 0.5 eigenvalue corresponds to 8.9 sec time period
    timePeriod = 2 * pi ./ sqrt(eigenValArray);
    timePeriodLIST(i, :) = timePeriod;
    
    eigenVecArray = eigenVecArray(:, firstSensibleEigenVector:end); % removing spurious eigen vectors
%     eigenVecArray = eigenVecArray(:, firstSensibleEigenVector:6); % removing spurious eigen vectors
    
%%% finding modal mass for each modes
    modalMass = zeros(1, size(eigenVecArray, 2)); % initiate the modal mass
    modalContribution = zeros(1, size(eigenVecArray, 2)); % initiate the modal contribution

    for modeNum = 1:size(eigenVecArray, 2)
        modalMass(modeNum) = (sum(W .* eigenVecArray(2:end, modeNum)) ^ 2) / (g * sum(W .* eigenVecArray(2:end, modeNum) .* eigenVecArray(2:end, modeNum)));
        modalContribution(modeNum) = modalMass(modeNum) / totalMass * 100; % in percentage
    end
    modalContributionLIST(i, :) = modalContribution;
    eigenVecArrayLIST{i} = eigenVecArray;

    hFigure = figure(i);
    x = 500; y = 0; width = 400; height = 1000;
    set(hFigure, 'Position', [x y width height]);
    C = {'r','b','g','k','m',[.5 .6 .7],[.8 .2 .6],'r','b','g','k','m',[.5 .6 .7],[.8 .2 .6]}; % Cell array of 7 colors.
    strForLegend = [];
    
    for modeNum = 1:4 % size(eigenVecArray, 2)
        currPlotData = [eigenVecArray(:, modeNum)'; floorHeightList'/1000];
%         plot(currPlotData(1, :), currPlotData(2, :)); 
        hold on; grid on; fnplt(cscvn(currPlotData), 'color', C{modeNum}, 5);
        strForLegend{modeNum} = sprintf('Mode %i', modeNum);
        if modeNum == 1 % save first mode shape 
            firstModeShapeLIST{i} = eigenVecArray(:, modeNum)';
        end
    end
    
    legh = legend(strForLegend); set(gca, 'XTick', []);
    htitle = title('Mode Shape of the Structure');
    
    psb_FigureFormatScript
    
    fprintf('(%i/%i) Natural Time Periods of the structure are: \n', i, length(outpDirLIST));
    disp(timePeriod);
    
    fprintf('Modal contribution factor are: \n');
    disp(modalContribution);
    fprintf('------------------------------- \n');
%     cd(baseFolder);
%     print('-dmeta', ['modeShape_' num2str(i)]); % .emf file for Windows (MSWORD)
%     fprintf('Figures saved in %s.\n', pwd);
    fprintf('consider looking at the variables named, timePeriodLIST, modalContributionLIST, eigenVecArrayLIST.\n');
end
        
    case '16.ReadMultipleCsvFilesAndClubThemIntoOne'
%%
cd H:\Calibration\NonDuctileColumns

listOfNEESIDs = [150	151	152	154	155	172	26	27	28	29	30	31	32	33	34	59	6	60	64	65	66	67	68	69	7	70	71	72	8	9];
plotIndicesLIST = [1 2 3 4 5];

    for index = 1:length(listOfNEESIDs)
        fileName = sprintf('%s.csv', num2str(listOfNEESIDs(index)));
        fid = fopen(fileName,'rt');
        A{index} = textscan(fid, '%f %f', 'HeaderLines', 1, 'delimiter', ',');
        fclose(fid);
    end
    
    for plotIndex = 1:length(plotIndicesLIST)
        figure(100 + plotIndex)
        plot(A{plotIndex}{1,1}, A{plotIndex}{1,2})
    end
    
    case '17.DetermineIDR'
%%

cd I:\PrakRuns_I\Output\(psb_RunSingleInelasticDynamicAnalysis_2316_autoChangeOfDt_WORKS)_(AllVar)_(0.00)_(clough)\EQ_120111
% load 'Sa_1.31_dtBy10\Nodes\DisplTH\THNodeDispl_202013.out'

saFolderLIST = {
    'Sa_1.31_dtBy10'
    'Sa_1.31_dtBy20'
    'Sa_1.32_dtBy10'
    'Sa_1.32_dtBy20'
    };

colIndexForTime = 1;
colIndexForDisp = 2;

nodeLIST = 202013:6000:208013;

for p = 1:length(saFolderLIST)
    cd(saFolderLIST{p})
    cd Nodes\DisplTH
    
    for nodeIndex = 1:length(nodeLIST)
        nodeNum = nodeLIST(nodeIndex);
        analysisTH = load(sprintf('THNodeDispl_%i.out', nodeNum));
        
        floorDispTHLIST{p, nodeIndex}.timeStepLIST = analysisTH(:, colIndexForTime);
        floorDispTHLIST{p, nodeIndex}.floorDispTH = analysisTH(:, colIndexForDisp);
    end
    cd ..\..\..
end

    cd ..\RunInformation

    floorHeightLIST = load('floorHeightLISTOUT.out');
%     bldgHeight = max(floorHeightLIST);
    i = 1:length(floorHeightLIST) - 1; 
    floorHt(i) = floorHeightLIST(i+1) - floorHeightLIST(i); % ground floor height is represenetd by the first index

for p = 1:length(saFolderLIST)
    for floorIndex = 1:length(nodeLIST)-1 % floorIndex = 1 is for the ground floor
        topFloorDispTH = floorDispTHLIST{p, floorIndex}.floorDispTH;
        botFloorDispTH = floorDispTHLIST{p, floorIndex + 1}.floorDispTH;
        maxDrift = max(abs(max(topFloorDispTH - botFloorDispTH)), abs(min(topFloorDispTH - botFloorDispTH)));

        BldgIDRLIST(p, floorIndex) = maxDrift/floorHt(floorIndex);
    end
end

    case '18.extract_MuSa_betaRTR'
%%
% buildingIDLIST1 = {'2205v03'};
% folderLocationLIST1 = {'K:\Output\(ID2205_R5_4Story_v.03)_(AllVar)_(0.00)_(clough)'};
											
buildingIDLIST = {		'2205v03';                              ...  % PG-0 additional building for risk-paper
    '2207v09';	'2209v05';									...  % PG-1
	'2211v03';	'2213v04';	'2451v02';	'2453v02';	'2215v03';	'2217v03';	...  % PG-2
	'2219v03';	'2221v06';	'2433v02';	'2435v02';	'2223v03';	'2457v01';	'2459v01';	'2461v01';	'2463v01';	'2225v03';	...  % PG-3
	'2227v05';	'2437v02';	'2439v02';	'2229v03';							...  % PG-4
	'2231v04';	'2441v02';	'2443v02';	'2233v03';							...  % PG-5
	'2235v04';	'2445v02';	'2447v02a';	'2237v03a';	};						...  % PG-6

folderLocationLIST = {
    'K:\Output\(ID2205_R5_4Story_v.03)_(AllVar)_(0.00)_(clough)'
    'K:\Output\(ID2207_R5_7Story_v.09)_(AllVar)_(0.00)_(clough)'
    'K:\Output\(ID2209_R5_12Story_v.05)_(AllVar)_(0.00)_(clough)'
    'K:\Output\(ID2211_R5_2Story_v.03)_(AllVar)_(0.00)_(clough)'
    'K:\Output\(ID2213_R5_4Story_v.04)_(AllVar)_(0.00)_(clough)'
    'K:\Output\(ID2451_R5_5Story_v.02)_(AllVar)_(0.00)_(clough)'
    'K:\Output\(ID2453_R5_6Story_v.02)_(AllVar)_(0.00)_(clough)'
    'K:\Output\(ID2215_R5_7Story_v.03)_(AllVar)_(0.00)_(clough)'
    'K:\Output\(ID2217_R5_12Story_v.03)_(AllVar)_(0.00)_(clough)'
    'K:\Output\(ID2219_R5_2Story_v.03)_(AllVar)_(0.00)_(clough)'
    'K:\Output\(ID2221_R5_4Story_v.06)_(AllVar)_(0.00)_(clough)'
    'K:\Output\(ID2433_R5_5Story_v.02)_(AllVar)_(0.00)_(clough)'
    'K:\Output\(ID2435_R5_6Story_v.02)_(AllVar)_(0.00)_(clough)'
    'K:\Output\(ID2223_R5_7Story_v.03)_(AllVar)_(0.00)_(clough)'
    'K:\Output\(ID2457_R5_8Story_v.01)_(AllVar)_(0.00)_(clough)'
    'K:\Output\(ID2459_R5_9Story_v.01)_(AllVar)_(0.00)_(clough)'
    'K:\Output\(ID2461_R5_10Story_v.01)_(AllVar)_(0.00)_(clough)'
    'K:\Output\(ID2463_R5_11Story_v.01)_(AllVar)_(0.00)_(clough)'
    'K:\Output\(ID2225_R5_12Story_v.03)_(AllVar)_(0.00)_(clough)'
    'K:\Output\(ID2227_R5_4Story_v.05)_(AllVar)_(0.00)_(clough)'
    'K:\Output\(ID2437_R5_5Story_v.02)_(AllVar)_(0.00)_(clough)'
    'K:\Output\(ID2439_R5_6Story_v.02)_(AllVar)_(0.00)_(clough)'
    'K:\Output\(ID2229_R5_7Story_v.03)_(AllVar)_(0.00)_(clough)'
    'K:\Output\(ID2231_R5_4Story_v.04)_(AllVar)_(0.00)_(clough)'
    'K:\Output\(ID2441_R5_5Story_v.02)_(AllVar)_(0.00)_(clough)'
    'K:\Output\(ID2443_R5_6Story_v.02)_(AllVar)_(0.00)_(clough)'
    'K:\Output\(ID2233_R5_7Story_v.03)_(AllVar)_(0.00)_(clough)'
    'K:\Output\(ID2235_R5_4Story_v.04)_(AllVar)_(0.00)_(clough)'
    'K:\Output\(ID2445_R5_5Story_v.02)_(AllVar)_(0.00)_(clough)'
    'K:\Output\(ID2447_R5_6Story_v.02a)_(AllVar)_(0.00)_(clough)'
    'K:\Output\(ID2237_R5_7Story_v.03a)_(AllVar)_(0.00)_(clough)'};
    
% buildingIDLIST = {	'2221v06b'};
% folderLocationLIST = {'I:\PrakRuns_I\Output\(ID2221_R5_4Story_v.06b_noBondSlip)_(AllVar)_(0.00)_(clough)'};

numOfBldgs = length(folderLocationLIST);

ctrlCompMuSa = zeros(numOfBldgs, 1);
allCompMuSa = zeros(numOfBldgs, 1);
periodUsed = zeros(numOfBldgs, 1);
ctrlCompStDevLnSa = zeros(numOfBldgs, 1);
allCompStDevLnSa = zeros(numOfBldgs, 1);
allCollapseLevelSa = zeros(numOfBldgs, 44); % 44 is fixed for now, since we are using set C.
for bldgIndex = 1:numOfBldgs
    currBldgID = buildingIDLIST(bldgIndex);
    currLocation = folderLocationLIST(bldgIndex);
    currLocation  = char(currLocation);
    
    cd(currLocation)
% load the relevant variables
    try 
        fileNameToLoad = 'DATA_collapse_CollapseSaAndStats_GMSetC_SaGeoMean.mat';
        load(fileNameToLoad, 'collapseLevelForAllComp', 'collapseLevelForAllControlComp', 'meanLnCollapseSaTOneControlComp', 'meanLnCollapseSaTOneAllComp', 'periodUsedForScalingGroundMotions', 'stDevLnCollapseSaTOneAllComp', 'stDevLnCollapseSaTOneControlComp');
        GMset{bldgIndex, 1} = 'FEMA-P695 FF';
    catch 
        fileNameToLoad = 'DATA_collapse_CollapseSaAndStats_GMSetMum22_SaGeoMean.mat';
        load(fileNameToLoad, 'collapseLevelForAllComp', 'collapseLevelForAllControlComp', 'meanLnCollapseSaTOneControlComp', 'meanLnCollapseSaTOneAllComp', 'periodUsedForScalingGroundMotions', 'stDevLnCollapseSaTOneAllComp', 'stDevLnCollapseSaTOneControlComp');
        GMset{bldgIndex, 1}= 'Mum22';
    end
    
    ctrlCompMuSa(bldgIndex) = exp(meanLnCollapseSaTOneControlComp);
    allCompMuSa(bldgIndex) = exp(meanLnCollapseSaTOneAllComp);
    periodUsed(bldgIndex) = periodUsedForScalingGroundMotions;
    ctrlCompStDevLnSa(bldgIndex) = stDevLnCollapseSaTOneControlComp;
    allCompStDevLnSa(bldgIndex) = stDevLnCollapseSaTOneAllComp;
    allCollapseLevelSa(bldgIndex, :) = collapseLevelForAllComp;

    minColLevelSaAll(bldgIndex, :) = min(collapseLevelForAllComp);
    maxColLevelSaAll(bldgIndex, :) = max(collapseLevelForAllComp);
    minColLevelSaCtrl(bldgIndex, :) = min(collapseLevelForAllControlComp);
    maxColLevelSaCtrl(bldgIndex, :) = max(collapseLevelForAllControlComp);
    
    cd(baseFolder)
end

    T = table(buildingIDLIST, periodUsed, GMset, allCompMuSa, allCompStDevLnSa, ctrlCompMuSa, ctrlCompStDevLnSa, minColLevelSaAll, maxColLevelSaAll, minColLevelSaCtrl, maxColLevelSaCtrl);
    T.Properties.VariableNames{1} = 'BldgID';
    T.Properties.VariableNames{2} = 'timeP_sec';
    T.Properties.VariableNames{3} = 'GM_suite';
    T.Properties.VariableNames{4} = 'AllComp_mu_Sa_T1_g';
    T.Properties.VariableNames{5} = 'AllComp_sigma_ln';
    T.Properties.VariableNames{6} = 'CtrlComp_mu_Sa_T1_g';
    T.Properties.VariableNames{7} = 'CtrlComp_sigma_ln';
    T.Properties.VariableNames{8} = 'minSaColAll';
    T.Properties.VariableNames{9} = 'maxSaColAll';
    T.Properties.VariableNames{10} = 'minSaColCtrl';
    T.Properties.VariableNames{11} = 'maxSaColCtrl';

% T(:, 3*seedIndex:3*seedIndex+2) = table(kemOfOutputLIST', tauXLIST', (round(tElapsed*1000)/1000)');
% T.Properties.VariableNames{3*seedIndex} = sprintf('kem_%i', seedVal);
% T.Properties.VariableNames{3*seedIndex+1} = sprintf('tauX_%i', seedVal);
% T.Properties.VariableNames{3*seedIndex+2} = sprintf('runT_%i', seedVal);

disp(T);
% fileName = 'summary_bldg_fragility_params.xlsx';
% writetable(T, fileName);

    case '18a.extract_SaColMinMax'
%%
buildingIDLIST = {	'2205v03';                              ...  % PG-0 additional building for risk-paper
    '2207v09';	'2209v05';									...  % PG-1
	'2211v03';	'2213v04';	'2451v02';	'2453v02';	'2215v03';	'2217v03';	...  % PG-2
	'2219v03';	'2221v06';	'2433v02';	'2435v02';	'2223v03';	'2457v01';	'2459v01';	'2461v01';	'2463v01';	'2225v03';	...  % PG-3
	'2227v05';	'2437v02';	'2439v02';	'2229v03';							...  % PG-4
	'2231v04';	'2441v02';	'2443v02';	'2233v03';							...  % PG-5
	'2235v04';	'2445v02';	'2447v02a';	'2237v03a';	};						...  % PG-6

folderLocationLIST = {
    'K:\Output\(ID2205_R5_4Story_v.03)_(AllVar)_(0.00)_(clough)'
    'K:\Output\(ID2207_R5_7Story_v.09)_(AllVar)_(0.00)_(clough)'
    'K:\Output\(ID2209_R5_12Story_v.05)_(AllVar)_(0.00)_(clough)'
    'K:\Output\(ID2211_R5_2Story_v.03)_(AllVar)_(0.00)_(clough)'
    'K:\Output\(ID2213_R5_4Story_v.04)_(AllVar)_(0.00)_(clough)'
    'K:\Output\(ID2451_R5_5Story_v.02)_(AllVar)_(0.00)_(clough)'
    'K:\Output\(ID2453_R5_6Story_v.02)_(AllVar)_(0.00)_(clough)'
    'K:\Output\(ID2215_R5_7Story_v.03)_(AllVar)_(0.00)_(clough)'
    'K:\Output\(ID2217_R5_12Story_v.03)_(AllVar)_(0.00)_(clough)'
    'K:\Output\(ID2219_R5_2Story_v.03)_(AllVar)_(0.00)_(clough)'
    'K:\Output\(ID2221_R5_4Story_v.06)_(AllVar)_(0.00)_(clough)'
    'K:\Output\(ID2433_R5_5Story_v.02)_(AllVar)_(0.00)_(clough)'
    'K:\Output\(ID2435_R5_6Story_v.02)_(AllVar)_(0.00)_(clough)'
    'K:\Output\(ID2223_R5_7Story_v.03)_(AllVar)_(0.00)_(clough)'
    'K:\Output\(ID2457_R5_8Story_v.01)_(AllVar)_(0.00)_(clough)'
    'K:\Output\(ID2459_R5_9Story_v.01)_(AllVar)_(0.00)_(clough)'
    'K:\Output\(ID2461_R5_10Story_v.01)_(AllVar)_(0.00)_(clough)'
    'K:\Output\(ID2463_R5_11Story_v.01)_(AllVar)_(0.00)_(clough)'
    'K:\Output\(ID2225_R5_12Story_v.03)_(AllVar)_(0.00)_(clough)'
    'K:\Output\(ID2227_R5_4Story_v.05)_(AllVar)_(0.00)_(clough)'
    'K:\Output\(ID2437_R5_5Story_v.02)_(AllVar)_(0.00)_(clough)'
    'K:\Output\(ID2439_R5_6Story_v.02)_(AllVar)_(0.00)_(clough)'
    'K:\Output\(ID2229_R5_7Story_v.03)_(AllVar)_(0.00)_(clough)'
    'K:\Output\(ID2231_R5_4Story_v.04)_(AllVar)_(0.00)_(clough)'
    'K:\Output\(ID2441_R5_5Story_v.02)_(AllVar)_(0.00)_(clough)'
    'K:\Output\(ID2443_R5_6Story_v.02)_(AllVar)_(0.00)_(clough)'
    'K:\Output\(ID2233_R5_7Story_v.03)_(AllVar)_(0.00)_(clough)'
    'K:\Output\(ID2235_R5_4Story_v.04)_(AllVar)_(0.00)_(clough)'
    'K:\Output\(ID2445_R5_5Story_v.02)_(AllVar)_(0.00)_(clough)'
    'K:\Output\(ID2447_R5_6Story_v.02a)_(AllVar)_(0.00)_(clough)'
    'K:\Output\(ID2237_R5_7Story_v.03a)_(AllVar)_(0.00)_(clough)'};
    
numOfBldgs = length(folderLocationLIST);
for bldgIndex = 1:numOfBldgs
    currBldgID = buildingIDLIST(bldgIndex);
    currLocation = folderLocationLIST(bldgIndex);
    currLocation  = char(currLocation );
    
    cd(currLocation)
% load the relevant variables
    try 
        fileNameToLoad = 'DATA_collapse_CollapseSaAndStats_GMSetC_SaGeoMean.mat';
        load(fileNameToLoad, 'collapseLevelForAllComp', 'meanLnCollapseSaTOneControlComp', 'meanLnCollapseSaTOneAllComp', 'periodUsedForScalingGroundMotions', 'stDevLnCollapseSaTOneAllComp', 'stDevLnCollapseSaTOneControlComp');
        GMset{bldgIndex, 1} = 'FEMA-P695 FF';
    catch 
        fileNameToLoad = 'DATA_collapse_CollapseSaAndStats_GMSetMum22_SaGeoMean.mat';
        load(fileNameToLoad, 'collapseLevelForAllComp', 'meanLnCollapseSaTOneControlComp', 'meanLnCollapseSaTOneAllComp', 'periodUsedForScalingGroundMotions', 'stDevLnCollapseSaTOneAllComp', 'stDevLnCollapseSaTOneControlComp');
        GMset{bldgIndex, 1}= 'Mum22';
    end
    periodUsed(bldgIndex, :) = periodUsedForScalingGroundMotions;
    minColLevelSaAll(bldgIndex, :) = min(collapseLevelForAllComp);
    maxColLevelSaAll(bldgIndex, :) = max(collapseLevelForAllComp);
    cd(baseFolder)
end

    T = table(buildingIDLIST, periodUsed, GMset, minColLevelSaAll, maxColLevelSaAll);
    T.Properties.VariableNames{1} = 'BldgID';
    T.Properties.VariableNames{2} = 'timeP_sec';
    T.Properties.VariableNames{3} = 'GM_suite';
    T.Properties.VariableNames{4} = 'minSaColAll';
    T.Properties.VariableNames{5} = 'maxSaColAll';

    disp(T);
% fileName = 'summary_bldg_fragility_params.xlsx';
% writetable(T, fileName);

    case '19.psb_PlotDefoShapeSingleEQ_v1'
%%
% Same as file psb_PlotDefoShapeSingleEQ_v1 in I:\PrakRuns_I
% This case uses psb_CreatePlotOfFrameAtSpecifiedSa_proc located in I:\PrakRuns_I\psb_MatlabProcessors\MovieAndVisualProcessors
%
% -------------------
% This draws the distorted frame for a single Sa value.
%
% Assumptions and Notices: 
%   - Most of the post-processing assumes that the analyses were run with Sa,geoMean!
%
% Author: Prakash S Badal, IIT Bombay
%
% Units: Whatever OpenSees is using - kN, mm, radians
%
% -------------------

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 
% baseFolder = pwd;
%     
%     bldgID = 2221;
%     modelNameLIST = {'ID2221_R5_4Story_v.02'};
%     analysisTypeLIST = {'(ID2221_R5_4Story_v.02)_(AllVar)_(0.00)_(clough)'};

    bldgIDLIST = 2227;
    modelNameLIST = {'ID2227_R5_4Story_v.04'};
    analysisTypeLIST = {'(ID2227_R5_4Story_v.04)_(AllVar)_(0.00)_(clough)'};

%     bldgIDLIST = repmat([2439, 2447], 1, 2); % feel free to repeat bldgID
%     modelNameLIST = {'ID2439_R5_6Story_v.01'
%         'ID2447_R5_6Story_v.01'
%         'ID2439_R5_6Story_v.01'
%         'ID2447_R5_6Story_v.01'}; % feel free to repeat modelName
%     analysisTypeLIST = {'(ID2439_R5_6Story_v.01)_(AllVar)_(0.00)_(clough)'
%         '(ID2447_R5_6Story_v.01)_(AllVar)_(0.00)_(clough)'
%         '(ID2439_R5_6Story_v.01)_(AllVar)_(0.00)_(clough)'
%         '(ID2447_R5_6Story_v.01)_(AllVar)_(0.00)_(clough)'}; % feel free to repeat analysisType

%     bldgIDLIST = [2227, 2233, 2237]; % feel free to repeat bldgID
%     modelNameLIST = {'ID2227_R5_4Story_v.04'
%         'ID2233_R5_7Story_v.02'
%         'ID2237_R5_7Story_v.02'}; % feel free to repeat modelName
%     analysisTypeLIST = {'(ID2227_R5_4Story_v.04)_(AllVar)_(0.00)_(clough)'
%         '(ID2233_R5_7Story_v.02)_(AllVar)_(0.00)_(clough)'
%         '(ID2237_R5_7Story_v.02)_(AllVar)_(0.00)_(clough)'}; % feel free to repeat analysisType
    
% eqNumberLIST = eqNumberLIST_forProcessing_SetC;
eqNumberLIST = 120911 * ones(1, 1); % feel free to repeat eqNumbers

% SaValLIST = [0.34, 1.25, 1.19];
% SaValLIST = [0.41, 1.32, 1.32];
% SaValLIST = [0.82, 1.06, 1.01, 1.31];
SaValLIST = [0.41];

cd I:\PrakRuns_I\psb_MatlabProcessors\MovieAndVisualProcessors
% psb_CreateAllSubPlotsOfFrameAtCol_proc(analysisTypeLIST, modelNameLIST, bldgID, eqNumberLIST);

for listIndex = 1:length(bldgIDLIST)
    bldgID = bldgIDLIST(listIndex);
    modelName = modelNameLIST(listIndex);
    analysisType = analysisTypeLIST(listIndex);
    eqNumber = eqNumberLIST(listIndex);
    saVal = SaValLIST(listIndex);
    psb_CreatePlotOfFrameAtSpecifiedSa_proc(analysisType, modelName, bldgID, eqNumber, saVal);
end

% close; % close figure
% close; % close figure
% close; % close figure
% close; % close figure
% cd(baseFolder);

    case '20.extractMaxAndMinAxialLoad'
%%

cd J:\Output\
% cd '(ID2207_R5_7Story_v.07)_(AllVar)_(0.00)_(clough)'
cd '(ID2225_R5_12Story_v.02)_(AllVar)_(0.00)_(clough)'
% eqNum = 120122;
% saVal = 1.32;

eqNumLIST = 121011; %120111;
% saValLIST = [2.22];
% saValLIST = [0.11	0.42	0.72	1.02	1.32	1.62	1.92	2.22	2.27	2.33	2.52];
saValLIST = [0.11	0.42	0.72	1.02	1.32	1.62	1.92	2.22	2.27	2.33	2.39	2.45	2.52];

colLIST = [30101, 30102, 30103, 30104]; % GF columns
% colLIST = 30101;

maxAxialForceMatrix = zeros(length(saValLIST), length(colLIST));
minAxialForceMatrix = zeros(length(saValLIST), length(colLIST));

% for eqIndex = 1:length(eqNumLIST)
%     eqNum = eqNumLIST(eqIndex);
    eqNum = eqNumLIST(1);
    for saIndex = 1:length(saValLIST)
        saVal = saValLIST(saIndex);
        cd(fullfile(sprintf('EQ_%i', eqNum), sprintf('Sa_%3.2f', saVal), 'Elements', 'EleLocalTH'));
        for colIndex = 1:length(colLIST)
            colNum = colLIST(colIndex);
            localForceData = load(sprintf('THEleLocal_%i.out', colNum));
            axialForce = localForceData(:, 1);
            maxAxialForceMatrix(saIndex, colIndex) = max(axialForce);
            minAxialForceMatrix(saIndex, colIndex) = min(axialForce);
        end
        cd ..; cd ..; cd ..; cd ..; % back to building-specific output folder; % back to the EQ folder
    end
%     cd ..; % back to the building-specific output folder
% end
    
disp(maxAxialForceMatrix);
disp(minAxialForceMatrix);
    
    case '21.extract_MuSa_betaRTR_and_convertFragilityToNewTimeP'
%%

    % Define here the period for which new spectral intensity measure of the fragility function is required
% imType = 'Sa_timeP1_code'; % Sa(Tcode) using codal time period
% imType = 'Sa_timeP1_ana'; % Sa(T1) using first mode analytical time period
% imType = 'Sa_P1_P2_geoM'; % geoM of spectral acceleration of at first and second analytical time period
% imType = 'Sa_P1_P3_geoM'; % geoM of spectral acceleration of at first and third analytical time period
% imType = 'Sa_P1_P2_P3_geoM'; % geoM of spectral acceleration of at first, second, and third analytical time period
% imType = 'Sa_TimeGiven'; T_new1 = 3.00; % arbitrary period % in this case, T_new1 needs to be defined as well

% imTypeLIST = {'Sa_timeP1_code';
%               'Sa_timeP1_ana'; % Sa(T1) using first mode analytical time period
%               'Sa_P1_P2_geoM'; % geoM of spectral acceleration of at first and second analytical time period
%               'Sa_P1_P3_geoM'; % geoM of spectral acceleration of at first and third analytical time period
%               'Sa_P1_P2_P3_geoM'; % geoM of spectral acceleration of at first, second, and third analytical time period
%               'Sa_TimeGiven';};

imTypeLIST = {'Sa_TimeGiven';};
T_code = 0.61; % codal time period for Sa_timeP1_code case, this may or may not be same as the one used for analysis
T_given = 0.61; % arbitrary period for Sa_TimeGiven case, T_new1 needs to be defined as well
    

% storyDriftLIST = [0.00 0.04 0.02 0.0125 0.01 0.08]; % (values in percentage). 0.00 indicates sidesway collapse
storyDriftLIST = [0.00 0.04 0.02 0.01 0.0533 0.08]; % (values in percentage). 0.00 indicates sidesway collapse
% storyDriftLIST = [0.00 0.04 0.02 0.01]; % (values in percentage). 0.00 indicates sidesway collapse
% storyDriftLIST = [0.00];

% BuildingID = {'2205v02', '2207v07', '2209v04', ...
%               '2211v02', '2213v03', '2215v02', '2217v02', ...
%               '2219v02', '2221v05', '2433v01', '2435v01', '2223v02', '2225v02', ...
%               '2227v04', '2437v01', '2439v01', '2229v02', ...
%               '2231v02', '2441v01', '2443v01', '2233v02', ...
%               '2235v02', '2445v01', '2447v01', '2237v02'};      % not needed, since we're now extracting building ID from the name of he output folder.

eqNumberLIST_forProcessing_SetC = [120111, 120112, 120121, 120122,	120411, 120412,	120521, 120522,	120611, 120612,	120621, 120622,	120711, 120712,	120721, 120722,	120811, 120812,	120821, 120822,	120911, 120912,	120921, 120922,	121011, 121012,	121021, 121022,	121111, 121112,	121211, 121212,	121221, 121222,	121321, 121322,	121411, 121412,	121421, 121422,	121511, 121512,	121711, 121712];
eqNumLIST_forProc_SetMum250_2p56 = [6000901	6000902	6003801	6003802	6004001	6004002	6006901	6006902	6007701	6007702	6007801	6007802	6007901	6007902	6015401	6015402	6017201	6017202	6018701	6018702	6019201	6019202	6021001	6021002	6026901	6026902	6028601	6028602	6028801	6028802	6029201	6029202	6029501	6029502	6030001	6030002	6030201	6030202	6030301	6030302	6031201	6031202	6031901	6031902	6032201	6032202	6035401	6035402	6039101	6039102	6041401	6041402	6042501	6042502	6042801	6042802	6042901	6042902	6043101	6043102	6045301	6045302	6045601	6045602	6046801	6046802	6047001	6047002	6049201	6049202	6051001	6051002	6053001	6053002	6055001	6055002	6057001	6057002	6057201	6057202	6057301	6057302	6057501	6057502	6057701	6057702	6057801	6057802	6058401	6058402	6062401	6062402	6067401	6067402	6072001	6072002	6072101	6072102	6072401	6072402	6073501	6073502	6073701	6073702	6074201	6074202	6078201	6078202	6078601	6078602	6078901	6078902	6080001	6080002	6080601	6080602	6084301	6084302	6085401	6085402	6085901	6085902	6086201	6086202	6088201	6088202	6088301	6088302	6088501	6088502	6089701	6089702	6090901	6090902	6091901	6091902	6092101	6092102	6095801	6095802	6096301	6096302	6096801	6096802	6098501	6098502	6098601	6098602	6100801	6100802	6101501	6101502	6102401	6102402	6102601	6102602	6103401	6103402	6104201	6104202	6104601	6104602	6104801	6104802	6105701	6105702	6107401	6107402	6107701	6107702	6107801	6107802	6108001	6108002	6108601	6108602	6108701	6108702	6109001	6109002	6110001	6110002	6110101	6110102	6110701	6110702	6111601	6111602	6114401	6114402	6114501	6114502	6115801	6115802	6116601	6116602	6120401	6120402	6123401	6123402 ...
                                    6124801	6124802	6125801	6125802	6126501	6126502	6126901	6126902	6127301	6127302	6127701	6127702	6128801	6128802	6130001	6130002	6131201	6131202	6131701	6131702	6134401	6134402	6135201	6135202	6135501	6135502	6138301	6138302	6139001	6139002	6140401	6140402	6147001	6147002	6148301	6148302	6150901	6150902	6151201	6151202	6151801	6151802	6153501	6153502	6153901	6153902	6154501	6154502	6155701	6155702	6156501	6156502	6157001	6157002	6158801	6158802	6159201	6159202	6159401	6159402	6161101	6161102	6162201	6162202	6162601	6162602	6163301	6163302	6163401	6163402	6176201	6176202	6176801	6176802	6177501	6177502	6179101	6179102	6180501	6180502	6180901	6180902	6181601	6181602	6182101	6182102	6182901	6182902	6183501	6183502	6183601	6183602	6184001	6184002	6206801	6206802	6210401	6210402	6211201	6211202	6220801	6220802	6222101	6222102	6222301	6222302	6226601	6226602	6226701	6226702	6227001	6227002	6227901	6227902	6228401	6228402	6229301	6229302	6245701	6245702	6247701	6247702	6247801	6247802	6248201	6248202	6249801	6249802	6255901	6255902	6256901	6256902	6258701	6258702	6259201	6259202	6259901	6259902	6260001	6260002	6260501	6260502	6260801	6260802	6262601	6262602	6263401	6263402	6264701	6264702	6269601	6269602	6271601	6271602	6271801	6271802	6273301	6273302	6274201	6274202	6274301	6274302	6274401	6274402	6274801	6274802	6277001	6277002	6281001	6281002	6284501	6284502	6285001	6285002	6285201	6285202	6287701	6287702	6288601	6288602	6289501	6289502	6294501	6294502	6294601	6294602	6295101	6295102	6295201	6295202	6295601	6295602	6295801	6295802	6296001	6296002	6296101	6296102	6299001	6299002 ...
                                    6299201	6299202	6299301	6299302	6299401	6299402	6301101	6301102	6302401	6302402	6306201	6306202	6309801	6309802	6310201	6310202	6318701	6318702	6322201	6322202	6322301	6322302	6322401	6322402	6324501	6324502	6326001	6326002	6326701	6326702	6327101	6327102	6328301	6328302	6328501	6328502	6328801	6328802	6329201	6329202	6330201	6330202	6330301	6330302	6331301	6331302	6331401	6331402	6331501	6331502	6332001	6332002	6334101	6334102	6334801	6334802	6335001	6335002	6338101	6338102	6338201	6338202	6340001	6340002	6344201	6344202	6345501	6345502	6345901	6345902	6346101	6346102	6346301	6346302	6347101	6347102	6347201	6347202	6347701	6347702	6349101	6349102	6349201	6349202	6349601	6349602	6349701	6349702	6349801	6349802	6350101	6350102	6350901	6350902	6351101	6351102	6351401	6351402	6352501	6352502	6353901	6353902];
eqNumLIST_forProc_SetMum22_2p56 =  [6031401	6031402	6057501	6057502	6075401	6075402	6088401	6088402	6104601	6104602	6122401	6122402	6127701	6127702	6150401	6150402	6151201	6151202	6176801	6176802	6182301	6182302	6184101	6184102	6227901	6227902	6229201	6229202	6271601	6271602	6296401	6296402	6322301	6322302	6322401	6322402	6324501	6324502	6331401	6331402	6336701	6336702	6347701	6347702];
eqNumLIST_forProc_SetMum22Mean_2p56 =  [6039201	6039202	6080201	6080202	6082501	6082502	6098501	6098502	6101501	6101502	6118701	6118702	6120801	6120802	6130001	6130002	6139101	6139102	6150401	6150402	6155701	6155702	6158801	6158802	6247901	6247902	6264601	6264602	6274001	6274002	6280901	6280902	6293801	6293802	6293901	6293902	6295301	6295302	6295901	6295902	6298801	6298802	6348001	6348002];

GMset = 'setC';
% GMset = 'Mum250';
% GMset = 'Mum22';
% GMset  = 'Mum22MeanOnly';
% GMset = '2209v01';
% GMset = '2209v01b_codal';
% GMset = '2205v03_codal';


switch GMset
    case 'setC'
%         outpFolderLIST = {'K:\Output\(ID2207_R5_7Story_v.08)_(AllVar)_(0.00)_(clough)setC'};
%         outpFolderLIST = {'I:\PrakRuns_I\Output\(ID2221_R5_4Story_v.06b_noBondSlip)_(AllVar)_(0.00)_(clough)'};
%         outpFolderLIST = {'I:\PrakRuns_I\Output\(ID2225_R5_12Story_v.03b_noBondSlip)_(AllVar)_(0.00)_(clough)'};
        outpFolderLIST = {'I:\PrakRuns_I\Output\(ID2213_R5_4Story_v.04_p695_arias_2p5_97p5)_(AllVar)_(0.00)_(clough)'};
        
        eqNumberLIST = eqNumberLIST_forProcessing_SetC;
        matFileToLoad = {'DATA_collapse_CollapseSaAndStats_GMSetC_SaGeoMean.mat'};
    
    case 'Mum250'
        outpFolderLIST = {'K:\Output\(ID2207_R5_7Story_v.08)_(AllVar)_(0.00)_(clough)Mum250'};
        eqNumberLIST = eqNumLIST_forProc_SetMum250_2p56;
        matFileToLoad = {'DATA_collapse_CollapseSaAndStats_setMum250_2p56_SaGeoMean'};
    
    case 'Mum22'
        outpFolderLIST = {'K:\Output\(ID2207_R5_7Story_v.08)_(AllVar)_(0.00)_(clough)Mum22'};
        eqNumberLIST = eqNumLIST_forProc_SetMum22_2p56;
        matFileToLoad = {'DATA_collapse_CollapseSaAndStats_setMum22_2p56_SaGeoMean.mat'};

    case 'Mum22MeanOnly'
        outpFolderLIST = {'K:\Output\(ID2207_R5_7Story_v.08)_(AllVar)_(0.00)_(clough)Mum22Mu'};
        eqNumberLIST = eqNumLIST_forProc_SetMum22Mean_2p56;
        matFileToLoad = {'DATA_collapse_CollapseSaAndStats_setMum22Mean_2p56_SaGeoMean.mat'};
        
    case '2209v01'
        outpFolderLIST = {'K:\Output\(ID2209_R5_12Story_v.01)_(AllVar)_(0.00)_(clough)'};
        eqNumberLIST = eqNumberLIST_forProcessing_SetC;
        matFileToLoad = {'DATA_collapse_CollapseSaAndStats_GMSetC_SaGeoMean.mat'};

    case '2209v01b_codal'
        outpFolderLIST = {'K:\Output\(ID2209_R5_12Story_v.01b_codalTimePForScaling)_(AllVar)_(0.00)_(clough)'};
        eqNumberLIST = eqNumberLIST_forProcessing_SetC;
        matFileToLoad = {'DATA_collapse_CollapseSaAndStats_GMSetC_SaGeoMean.mat'};
        
    case '2205v03_codal'
        outpFolderLIST = {'K:\Output\(ID2205_R5_4Story_v.03)_(AllVar)_(0.00)_(clough)'};
        eqNumberLIST = eqNumberLIST_forProcessing_SetC;
        matFileToLoad = {'DATA_collapse_CollapseSaAndStats_GMSetC_SaGeoMean.mat'};
end
 
%% default array of mat files (set- C) 
% matFileToLoad = repmat('DATA_collapse_CollapseSaAndStats_GMSetC_SaGeoMean.mat', size(outpFolderLIST)); 

%% 1. extract the values of several analytical time periods from the building analysis folders

        for i = 1:length(outpFolderLIST)

          x = strfind(outpFolderLIST{i, 1}, '(ID');
          y = strfind(outpFolderLIST{i, 1}, '_');
          if y(1) > x % sometimes folder name contains underscore, in that case pick second occurance of underscore
              y = y(1);
          else
              y = y(2);
          end
          buildingID(i) = str2num(outpFolderLIST{i, 1}(x+3:y-1)); % extract building ID from output folder name
          currentFolder = outpFolderLIST{i};
          cd(currentFolder)
          cd 'MatlabInformation'
          eigenValLIST(i, :) = load('eigenvaluesOUT.out');
          cd ..
          cd ..
        end
        timeP1LIST = zeros(length(outpFolderLIST), 1);
        timeP2LIST = timeP1LIST; timeP3LIST = timeP1LIST; timeP4LIST = timeP1LIST; timeP5LIST = timeP1LIST;
        for i = 1:length(outpFolderLIST)
          currEigValLIST = eigenValLIST(i, :);
          % remove the spurious eigenvalues that are less than 0.5, they correspond to timeP of more than 8.9 sec.
          currEigValLIST(1:find(currEigValLIST < 0.5, 1, 'last' )) = [];
          timeP1LIST(i, 1) = 2 * pi / sqrt(currEigValLIST(1));
          timeP2LIST(i, 1) = 2 * pi / sqrt(currEigValLIST(2));
          timeP3LIST(i, 1) = 2 * pi / sqrt(currEigValLIST(3));
          timeP4LIST(i, 1) = 2 * pi / sqrt(currEigValLIST(4));
          timeP5LIST(i, 1) = 2 * pi / sqrt(currEigValLIST(5));
        end

    for imIndex= 1:length(imTypeLIST)
        imType = imTypeLIST{imIndex};
        
        for storyDriftIndex = 1:length(storyDriftLIST)
          currentStoryDrift = storyDriftLIST(storyDriftIndex);

          cd(baseFolder); % now we are in the original directory
          for j = 1:length(outpFolderLIST)
%% 2a. extract the old period and values of spectral acceleration corr. to story drift ratio as chosen above
        %                   fprintf('Running model %i/%i and drift ratio case %i/%i ...\n', j, length(outpFolderLIST), storyDriftIndex, length(storyDriftLIST));
              fprintf('Running model %i/%i, drift ratio case %i/%i, ...\n', j, length(outpFolderLIST), storyDriftIndex, length(storyDriftLIST));
        %                   [T_old, saT_oldAllComp] = prak_util_extractFragDataPoints_v01(outpFolderLIST{j}, eqNumberLIST, currentStoryDrift);
              [T_old, saT_oldAllComp] = prak_util_extractFragDataPoints_v02(outpFolderLIST{j}, eqNumberLIST, currentStoryDrift, matFileToLoad{j});
              saT_newAllComp = zeros(1, length(eqNumberLIST)); % initialize

%% 2b. depending on the intensity measure type, find ratio of scaling from old IM value to new value for each earthquake
              switch imType
                  case 'Sa_timeP1_code'
%                       saT_newAllComp = saT_oldAllComp; % same as T_code i.e. time period used for scaling
%                       fprintf('Intensity measure type is %s. P1_code = %.2f sec. \n', imType, T_old);
                      T_new1 = T_code;
                      for eqIndex = 1:length(eqNumberLIST)
                          eqNumber = eqNumberLIST(eqIndex);

                          ratioOfSaTnewToSaTold1 = prak_util_ratioOfSaTnewToSaTold(eqNumber, T_old, T_new1);
                          currentRatToScale = ratioOfSaTnewToSaTold1;

                          saT_newAllComp(eqIndex) = currentRatToScale * saT_oldAllComp(eqIndex);
                      end
                        if storyDriftIndex == 1; fprintf('Intensity measure type is %s. P1_code = %.2f sec. \n', imType, T_old); end
                      
                  case 'Sa_timeP1_ana' % Sa(T1) using first mode analytical time period
                      T_new1 = round(100 * timeP1LIST(j, 1))/100;
                      for eqIndex = 1:length(eqNumberLIST)
                          eqNumber = eqNumberLIST(eqIndex);

                          ratioOfSaTnewToSaTold1 = prak_util_ratioOfSaTnewToSaTold(eqNumber, T_old, T_new1);
                          currentRatToScale = ratioOfSaTnewToSaTold1;

                          saT_newAllComp(eqIndex) = currentRatToScale * saT_oldAllComp(eqIndex);
                      end
                        if storyDriftIndex == 1; fprintf('Intensity measure type is %s. P1_ana = %.2f sec. \n', imType, T_new1); end
                  case 'Sa_P1_P2_geoM' % geoM of spectral acceleration of at first and second analytical time period
                      T_new1 = round(100 * timeP1LIST(j, 1))/100;
                      T_new2 = round(100 * timeP2LIST(j, 1))/100;
                      for eqIndex = 1:length(eqNumberLIST)
                          eqNumber = eqNumberLIST(eqIndex);

                          ratioOfSaTnewToSaTold1 = prak_util_ratioOfSaTnewToSaTold(eqNumber, T_old, T_new1);
                          ratioOfSaTnewToSaTold2 = prak_util_ratioOfSaTnewToSaTold(eqNumber, T_old, T_new2);
                          currentRatToScale = (ratioOfSaTnewToSaTold1 * ratioOfSaTnewToSaTold2)^(1/2);

                          saT_newAllComp(eqIndex) = currentRatToScale * saT_oldAllComp(eqIndex);
                      end
                        if storyDriftIndex == 1; fprintf('Intensity measure type is %s. P1 = %.2f sec, P2 = %.2f sec. \n', imType, T_new1, T_new2); end
                  case 'Sa_P1_P3_geoM' % geoM of spectral acceleration of at first and third analytical time period
                      T_new1 = round(100 * timeP1LIST(j, 1))/100;
                      T_new3 = round(100 * timeP3LIST(j, 1))/100;
                      for eqIndex = 1:length(eqNumberLIST)
                          eqNumber = eqNumberLIST(eqIndex);

                          ratioOfSaTnewToSaTold1 = prak_util_ratioOfSaTnewToSaTold(eqNumber, T_old, T_new1);
                          ratioOfSaTnewToSaTold3 = prak_util_ratioOfSaTnewToSaTold(eqNumber, T_old, T_new3);
                          currentRatToScale = (ratioOfSaTnewToSaTold1 * ratioOfSaTnewToSaTold3)^(1/2);

                          saT_newAllComp(eqIndex) = currentRatToScale * saT_oldAllComp(eqIndex);
                      end
                          if storyDriftIndex == 1; fprintf('Intensity measure type is %s. P1 = %.2f sec, P3 = %.2f sec. \n', imType, T_new1, T_new3); end
                  case 'Sa_P1_P2_P3_geoM' % geoM of spectral acceleration of at first, second, and third analytical time period
                      T_new1 = round(100 * timeP1LIST(j, 1))/100;
                      T_new2 = round(100 * timeP2LIST(j, 1))/100;
                      T_new3 = round(100 * timeP3LIST(j, 1))/100;
                      for eqIndex = 1:length(eqNumberLIST)
                          eqNumber = eqNumberLIST(eqIndex);

                          ratioOfSaTnewToSaTold1 = prak_util_ratioOfSaTnewToSaTold(eqNumber, T_old, T_new1);
                          ratioOfSaTnewToSaTold2 = prak_util_ratioOfSaTnewToSaTold(eqNumber, T_old, T_new2);
                          ratioOfSaTnewToSaTold3 = prak_util_ratioOfSaTnewToSaTold(eqNumber, T_old, T_new3);
                          currentRatToScale = (ratioOfSaTnewToSaTold1 * ratioOfSaTnewToSaTold2 * ratioOfSaTnewToSaTold3)^(1/3);

                          saT_newAllComp(eqIndex) = currentRatToScale * saT_oldAllComp(eqIndex);
                      end
                          if storyDriftIndex == 1; fprintf('Intensity measure type is %s. P1 = %.2f sec, P2 = %.2f sec, P3 = %.2f sec. \n', imType, T_new1, T_new2, T_new3); end
                  case 'Sa_TimeGiven' % Sa(T1) using first mode analytical time period
                      %                       T_new1 = round(100 * timeP1LIST(j, 1))/100;
                      T_new1 = T_given;
                      for eqIndex = 1:length(eqNumberLIST)
                          eqNumber = eqNumberLIST(eqIndex);

                          ratioOfSaTnewToSaTold1 = prak_util_ratioOfSaTnewToSaTold(eqNumber, T_old, T_new1);
                          currentRatToScale = ratioOfSaTnewToSaTold1;

                          saT_newAllComp(eqIndex) = currentRatToScale * saT_oldAllComp(eqIndex);
                      end
                          if storyDriftIndex == 1; fprintf('Intensity measure type is %s. P1_new = %.2f sec. \n', imType, T_new1); end
              end

%% 2c. combine the new intensity measure values for different ground motions to find the fragility function parameters

              saT_newCtrlComp = zeros(1, length(eqNumberLIST)/2);

              for gmIndex = 1:length(eqNumberLIST)/2
                  saT_newCompOne = saT_newAllComp(gmIndex * 2 - 1);
                  saT_newCompTwo = saT_newAllComp(gmIndex * 2);
                  saT_newCtrlComp(gmIndex) = min(saT_newCompOne, saT_newCompTwo);
              end

              % Do collapse statistics - for all components
              meanCollapseSaTOneAllComp(j) = mean(saT_newAllComp);
              medianCollapseSaTOneAllComp(j) = (median(saT_newAllComp));
              meanLnCollapseSaTOneAllComp(j) = mean(log(saT_newAllComp));
              stDevCollapseSaTOneAllComp(j) = std(saT_newAllComp);
              stDevLnCollapseSaTOneAllComp(j) = std(log(saT_newAllComp));
              
              % Do collapse statistics - for controlling components
              meanCollapseSaTOneControlComp(j) = mean(saT_newCtrlComp);
              medianCollapseSaTOneControlComp(j) = (median(saT_newCtrlComp));
              meanLnCollapseSaTOneControlComp(j) = mean(log(saT_newCtrlComp));
              stDevCollapseSaTOneControlComp(j) = std(saT_newCtrlComp);
              stDevLnCollapseSaTOneControlComp(j) = std(log(saT_newCtrlComp));
              
          end
                      fragParamMu = exp(meanLnCollapseSaTOneControlComp)';
                      fragParamBetaRTR = stDevLnCollapseSaTOneControlComp';

%           fragParamMu = exp(meanLnCollapseSaTOneAllComp)';
%           fragParamBetaRTR = stDevLnCollapseSaTOneAllComp';
          
          

        %               T = table(buildingID' , timeP1LIST, fragParamMu, fragParamBetaRTR);
          if storyDriftIndex == 1 && imIndex == 1 % add building ID and time P only once
%             T = table(buildingID' , T_old);
            T = table(repmat(buildingID', length(imTypeLIST), 1), imTypeLIST);
            T.Properties.VariableNames{1} = 'bldg_ID';
            T.Properties.VariableNames{2} = 'imType';
          end
          
%           T(:, 2*storyDriftIndex+1:2*storyDriftIndex+2) = table(fragParamMu, fragParamBetaRTR);
          T(imIndex, 2*storyDriftIndex+1:2*storyDriftIndex+2) = table(fragParamMu, fragParamBetaRTR);
          T.Properties.VariableNames{2*storyDriftIndex+1} = sprintf('mu_%i', round(currentStoryDrift*100));
          T.Properties.VariableNames{2*storyDriftIndex+2} = sprintf('betaRTR_%i', round(currentStoryDrift*100));

        %               fprintf('____________________________________________\n');
        %               fprintf('Intensity measure type is %s \n', imType);
        %               fprintf('_________________________________________________________\n');
        %               fprintf('Fragility parameters for the Story drift ratio of %.2f%% are as follows- \n', currentStoryDrift*100);
        %               fprintf('_________________________________________________________\n');


          format long
        %               disp(T);
        end
    end
    
        disp(T);
        clearvars -except T baseFolder

    case '21p.extract_MuSa_betaRTR_and_convertFragilityToNewTimeP'
%%

    % Define here the period for which new spectral intensity measure of the fragility function is required
% imType = 'Sa_timeP1_code'; % Sa(Tcode) using codal time period
% imType = 'Sa_timeP1_ana'; % Sa(T1) using first mode analytical time period
% imType = 'Sa_P1_P2_geoM'; % geoM of spectral acceleration of at first and second analytical time period
% imType = 'Sa_P1_P3_geoM'; % geoM of spectral acceleration of at first and third analytical time period
% imType = 'Sa_P1_P2_P3_geoM'; % geoM of spectral acceleration of at first, second, and third analytical time period
% imType = 'Sa_TimeGiven'; T_new1 = 3.00; % arbitrary period % in this case, T_new1 needs to be defined as well

% imTypeLIST = {'Sa_timeP1_code';
%               'Sa_timeP1_ana'; % Sa(T1) using first mode analytical time period
%               'Sa_P1_P2_geoM'; % geoM of spectral acceleration of at first and second analytical time period
%               'Sa_P1_P3_geoM'; % geoM of spectral acceleration of at first and third analytical time period
%               'Sa_P1_P2_P3_geoM'; % geoM of spectral acceleration of at first, second, and third analytical time period
%               'Sa_TimeGiven';};

imTypeLIST = {'Sa_timeP1_code';};
T_code = 0.61; % codal time period for Sa_timeP1_code case, this may or may not be same as the one used for analysis
T_given = 5.11; % arbitrary period for Sa_TimeGiven case, T_new1 needs to be defined as well
    

% storyDriftLIST = [0.00 0.04 0.02 0.0125 0.01 0.08]; % (values in percentage). 0.00 indicates sidesway collapse
storyDriftLIST = [0.00 0.04 0.02 0.01 0.0533 0.08]; % (values in percentage). 0.00 indicates sidesway collapse
% storyDriftLIST = [0.00 0.04 0.02 0.01]; % (values in percentage). 0.00 indicates sidesway collapse
% storyDriftLIST = [0.00];

% BuildingID = {'2205v02', '2207v07', '2209v04', ...
%               '2211v02', '2213v03', '2215v02', '2217v02', ...
%               '2219v02', '2221v05', '2433v01', '2435v01', '2223v02', '2225v02', ...
%               '2227v04', '2437v01', '2439v01', '2229v02', ...
%               '2231v02', '2441v01', '2443v01', '2233v02', ...
%               '2235v02', '2445v01', '2447v01', '2237v02'};      % not needed, since we're now extracting building ID from the name of he output folder.

eqNumberLIST_forProcessing_SetC = [120111, 120112, 120121, 120122,	120411, 120412,	120521, 120522,	120611, 120612,	120621, 120622,	120711, 120712,	120721, 120722,	120811, 120812,	120821, 120822,	120911, 120912,	120921, 120922,	121011, 121012,	121021, 121022,	121111, 121112,	121211, 121212,	121221, 121222,	121321, 121322,	121411, 121412,	121421, 121422,	121511, 121512,	121711, 121712];
eqNumLIST_forProc_SetMum250_2p56 = [6000901	6000902	6003801	6003802	6004001	6004002	6006901	6006902	6007701	6007702	6007801	6007802	6007901	6007902	6015401	6015402	6017201	6017202	6018701	6018702	6019201	6019202	6021001	6021002	6026901	6026902	6028601	6028602	6028801	6028802	6029201	6029202	6029501	6029502	6030001	6030002	6030201	6030202	6030301	6030302	6031201	6031202	6031901	6031902	6032201	6032202	6035401	6035402	6039101	6039102	6041401	6041402	6042501	6042502	6042801	6042802	6042901	6042902	6043101	6043102	6045301	6045302	6045601	6045602	6046801	6046802	6047001	6047002	6049201	6049202	6051001	6051002	6053001	6053002	6055001	6055002	6057001	6057002	6057201	6057202	6057301	6057302	6057501	6057502	6057701	6057702	6057801	6057802	6058401	6058402	6062401	6062402	6067401	6067402	6072001	6072002	6072101	6072102	6072401	6072402	6073501	6073502	6073701	6073702	6074201	6074202	6078201	6078202	6078601	6078602	6078901	6078902	6080001	6080002	6080601	6080602	6084301	6084302	6085401	6085402	6085901	6085902	6086201	6086202	6088201	6088202	6088301	6088302	6088501	6088502	6089701	6089702	6090901	6090902	6091901	6091902	6092101	6092102	6095801	6095802	6096301	6096302	6096801	6096802	6098501	6098502	6098601	6098602	6100801	6100802	6101501	6101502	6102401	6102402	6102601	6102602	6103401	6103402	6104201	6104202	6104601	6104602	6104801	6104802	6105701	6105702	6107401	6107402	6107701	6107702	6107801	6107802	6108001	6108002	6108601	6108602	6108701	6108702	6109001	6109002	6110001	6110002	6110101	6110102	6110701	6110702	6111601	6111602	6114401	6114402	6114501	6114502	6115801	6115802	6116601	6116602	6120401	6120402	6123401	6123402 ...
                                    6124801	6124802	6125801	6125802	6126501	6126502	6126901	6126902	6127301	6127302	6127701	6127702	6128801	6128802	6130001	6130002	6131201	6131202	6131701	6131702	6134401	6134402	6135201	6135202	6135501	6135502	6138301	6138302	6139001	6139002	6140401	6140402	6147001	6147002	6148301	6148302	6150901	6150902	6151201	6151202	6151801	6151802	6153501	6153502	6153901	6153902	6154501	6154502	6155701	6155702	6156501	6156502	6157001	6157002	6158801	6158802	6159201	6159202	6159401	6159402	6161101	6161102	6162201	6162202	6162601	6162602	6163301	6163302	6163401	6163402	6176201	6176202	6176801	6176802	6177501	6177502	6179101	6179102	6180501	6180502	6180901	6180902	6181601	6181602	6182101	6182102	6182901	6182902	6183501	6183502	6183601	6183602	6184001	6184002	6206801	6206802	6210401	6210402	6211201	6211202	6220801	6220802	6222101	6222102	6222301	6222302	6226601	6226602	6226701	6226702	6227001	6227002	6227901	6227902	6228401	6228402	6229301	6229302	6245701	6245702	6247701	6247702	6247801	6247802	6248201	6248202	6249801	6249802	6255901	6255902	6256901	6256902	6258701	6258702	6259201	6259202	6259901	6259902	6260001	6260002	6260501	6260502	6260801	6260802	6262601	6262602	6263401	6263402	6264701	6264702	6269601	6269602	6271601	6271602	6271801	6271802	6273301	6273302	6274201	6274202	6274301	6274302	6274401	6274402	6274801	6274802	6277001	6277002	6281001	6281002	6284501	6284502	6285001	6285002	6285201	6285202	6287701	6287702	6288601	6288602	6289501	6289502	6294501	6294502	6294601	6294602	6295101	6295102	6295201	6295202	6295601	6295602	6295801	6295802	6296001	6296002	6296101	6296102	6299001	6299002 ...
                                    6299201	6299202	6299301	6299302	6299401	6299402	6301101	6301102	6302401	6302402	6306201	6306202	6309801	6309802	6310201	6310202	6318701	6318702	6322201	6322202	6322301	6322302	6322401	6322402	6324501	6324502	6326001	6326002	6326701	6326702	6327101	6327102	6328301	6328302	6328501	6328502	6328801	6328802	6329201	6329202	6330201	6330202	6330301	6330302	6331301	6331302	6331401	6331402	6331501	6331502	6332001	6332002	6334101	6334102	6334801	6334802	6335001	6335002	6338101	6338102	6338201	6338202	6340001	6340002	6344201	6344202	6345501	6345502	6345901	6345902	6346101	6346102	6346301	6346302	6347101	6347102	6347201	6347202	6347701	6347702	6349101	6349102	6349201	6349202	6349601	6349602	6349701	6349702	6349801	6349802	6350101	6350102	6350901	6350902	6351101	6351102	6351401	6351402	6352501	6352502	6353901	6353902];
eqNumLIST_forProc_SetMum22_2p56 =  [6031401	6031402	6057501	6057502	6075401	6075402	6088401	6088402	6104601	6104602	6122401	6122402	6127701	6127702	6150401	6150402	6151201	6151202	6176801	6176802	6182301	6182302	6184101	6184102	6227901	6227902	6229201	6229202	6271601	6271602	6296401	6296402	6322301	6322302	6322401	6322402	6324501	6324502	6331401	6331402	6336701	6336702	6347701	6347702];
eqNumLIST_forProc_SetMum22Mean_2p56 =  [6039201	6039202	6080201	6080202	6082501	6082502	6098501	6098502	6101501	6101502	6118701	6118702	6120801	6120802	6130001	6130002	6139101	6139102	6150401	6150402	6155701	6155702	6158801	6158802	6247901	6247902	6264601	6264602	6274001	6274002	6280901	6280902	6293801	6293802	6293901	6293902	6295301	6295302	6295901	6295902	6298801	6298802	6348001	6348002];

% GMset = 'setC';
% GMset = 'Mum250';
% GMset = 'Mum22';
% GMset  = 'Mum22MeanOnly';
% GMset = '2209v01';
% GMset = '2209v01b_codal';
% GMset = '2221v05bsetC';
GMset = '2213v03bsetC';

switch GMset
    case 'setC'
        outpFolderLIST = {'K:\Output\(ID2207_R5_7Story_v.08)_(AllVar)_(0.00)_(clough)setC'};
        eqNumberLIST = eqNumberLIST_forProcessing_SetC;
        matFileToLoad = {'DATA_collapse_CollapseSaAndStats_GMSetC_SaGeoMean.mat'};
    
    case 'Mum250'
        outpFolderLIST = {'K:\Output\(ID2207_R5_7Story_v.08)_(AllVar)_(0.00)_(clough)Mum250'};
        eqNumberLIST = eqNumLIST_forProc_SetMum250_2p56;
        matFileToLoad = {'DATA_collapse_CollapseSaAndStats_setMum250_2p56_SaGeoMean'};
    
    case 'Mum22'
        outpFolderLIST = {'K:\Output\(ID2207_R5_7Story_v.08)_(AllVar)_(0.00)_(clough)Mum22'};
        eqNumberLIST = eqNumLIST_forProc_SetMum22_2p56;
        matFileToLoad = {'DATA_collapse_CollapseSaAndStats_setMum22_2p56_SaGeoMean.mat'};

    case 'Mum22MeanOnly'
        outpFolderLIST = {'K:\Output\(ID2207_R5_7Story_v.08)_(AllVar)_(0.00)_(clough)Mum22Mu'};
        eqNumberLIST = eqNumLIST_forProc_SetMum22Mean_2p56;
        matFileToLoad = {'DATA_collapse_CollapseSaAndStats_setMum22Mean_2p56_SaGeoMean.mat'};
        
    case '2209v01'
        outpFolderLIST = {'K:\Output\(ID2209_R5_12Story_v.01)_(AllVar)_(0.00)_(clough)'};
        eqNumberLIST = eqNumberLIST_forProcessing_SetC;
        matFileToLoad = {'DATA_collapse_CollapseSaAndStats_GMSetC_SaGeoMean.mat'};

    case '2209v01b_codal'
        outpFolderLIST = {'K:\Output\(ID2209_R5_12Story_v.01b_codalTimePForScaling)_(AllVar)_(0.00)_(clough)'};
        eqNumberLIST = eqNumberLIST_forProcessing_SetC;
        matFileToLoad = {'DATA_collapse_CollapseSaAndStats_GMSetC_SaGeoMean.mat'};
        
    case '2221v05bsetC'
        outpFolderLIST = {'I:\PrakRuns_I\Output\(ID2221_R5_4Story_v.05b)_(AllVar)_(0.00)_(clough)'};
        eqNumberLIST = eqNumberLIST_forProcessing_SetC;
        matFileToLoad = {'DATA_collapse_CollapseSaAndStats_GMSetC_SaGeoMean.mat'};

    case '2213v03bsetC'
        outpFolderLIST = {'I:\PrakRuns_I\Output\(ID2213_R5_4Story_v.03b)_(AllVar)_(0.00)_(clough)'};
        eqNumberLIST = eqNumberLIST_forProcessing_SetC;
        matFileToLoad = {'DATA_collapse_CollapseSaAndStats_GMSetC_SaGeoMean.mat'};
    
end
 
%% default array of mat files (set- C) 
% matFileToLoad = repmat('DATA_collapse_CollapseSaAndStats_GMSetC_SaGeoMean.mat', size(outpFolderLIST)); 

                 
%% 1. extract the values of several analytical time periods from the building analysis folders

        for i = 1:length(outpFolderLIST)

          x = strfind(outpFolderLIST{i, 1}, '(ID');
          y = strfind(outpFolderLIST{i, 1}, '_');
          if y(1) > x % sometimes folder name contains underscore, in that case pick second occurance of underscore
              y = y(1);
          else
              y = y(2);
          end
          buildingID(i) = str2num(outpFolderLIST{i, 1}(x+3:y-1)); % extract building ID from output folder name
          currentFolder = outpFolderLIST{i};
          cd(currentFolder)
          cd 'MatlabInformation'
          eigenValLIST(i, :) = load('eigenvaluesOUT.out');
          cd ..
          cd ..
        end
        timeP1LIST = zeros(length(outpFolderLIST), 1);
        timeP2LIST = timeP1LIST; timeP3LIST = timeP1LIST; timeP4LIST = timeP1LIST; timeP5LIST = timeP1LIST;
        for i = 1:length(outpFolderLIST)
          currEigValLIST = eigenValLIST(i, :);
          % remove the spurious eigenvalues that are less than 0.5, they correspond to timeP of more than 8.9 sec.
          currEigValLIST(1:find(currEigValLIST < 0.5, 1, 'last' )) = [];
          timeP1LIST(i, 1) = 2 * pi / sqrt(currEigValLIST(1));
          timeP2LIST(i, 1) = 2 * pi / sqrt(currEigValLIST(2));
          timeP3LIST(i, 1) = 2 * pi / sqrt(currEigValLIST(3));
          timeP4LIST(i, 1) = 2 * pi / sqrt(currEigValLIST(4));
          timeP5LIST(i, 1) = 2 * pi / sqrt(currEigValLIST(5));
        end

    for imIndex= 1:length(imTypeLIST)
        imType = imTypeLIST{imIndex};
        
        for storyDriftIndex = 1:length(storyDriftLIST)
          currentStoryDrift = storyDriftLIST(storyDriftIndex);

          cd(baseFolder); % now we are in the original directory
          for j = 1:length(outpFolderLIST)
%% 2a. extract the old period and values of spectral acceleration corr. to story drift ratio as chosen above
        %                   fprintf('Running model %i/%i and drift ratio case %i/%i ...\n', j, length(outpFolderLIST), storyDriftIndex, length(storyDriftLIST));
              fprintf('Running model %i/%i, drift ratio case %i/%i, ...\n', j, length(outpFolderLIST), storyDriftIndex, length(storyDriftLIST));
        %                   [T_old, saT_oldAllComp] = prak_util_extractFragDataPoints_v01(outpFolderLIST{j}, eqNumberLIST, currentStoryDrift);
              [T_old, saT_oldAllComp] = prak_util_extractFragDataPoints_v02(outpFolderLIST{j}, eqNumberLIST, currentStoryDrift, matFileToLoad{j});
              saT_newAllComp = zeros(1, length(eqNumberLIST)); % initialize

%% 2b. depending on the intensity measure type, find ratio of scaling from old IM value to new value for each earthquake
              switch imType
                  case 'Sa_timeP1_code'
%                       saT_newAllComp = saT_oldAllComp; % same as T_code i.e. time period used for scaling
%                       fprintf('Intensity measure type is %s. P1_code = %.2f sec. \n', imType, T_old);
                      T_new1 = T_code;
                      for eqIndex = 1:length(eqNumberLIST)
                          eqNumber = eqNumberLIST(eqIndex);

                          ratioOfSaTnewToSaTold1 = prak_util_ratioOfSaTnewToSaTold(eqNumber, T_old, T_new1);
                          currentRatToScale = ratioOfSaTnewToSaTold1;

                          saT_newAllComp(eqIndex) = currentRatToScale * saT_oldAllComp(eqIndex);
                      end
                        if storyDriftIndex == 1; fprintf('Intensity measure type is %s. P1_code = %.2f sec. \n', imType, T_old); end
                  case 'Sa_timeP1_ana' % Sa(T1) using first mode analytical time period
                      T_new1 = round(100 * timeP1LIST(j, 1))/100;
                      for eqIndex = 1:length(eqNumberLIST)
                          eqNumber = eqNumberLIST(eqIndex);

                          ratioOfSaTnewToSaTold1 = prak_util_ratioOfSaTnewToSaTold(eqNumber, T_old, T_new1);
                          currentRatToScale = ratioOfSaTnewToSaTold1;

                          saT_newAllComp(eqIndex) = currentRatToScale * saT_oldAllComp(eqIndex);
                      end
                        if storyDriftIndex == 1; fprintf('Intensity measure type is %s. P1_ana = %.2f sec. \n', imType, T_new1); end
                  case 'Sa_P1_P2_geoM' % geoM of spectral acceleration of at first and second analytical time period
                      T_new1 = round(100 * timeP1LIST(j, 1))/100;
                      T_new2 = round(100 * timeP2LIST(j, 1))/100;
                      for eqIndex = 1:length(eqNumberLIST)
                          eqNumber = eqNumberLIST(eqIndex);

                          ratioOfSaTnewToSaTold1 = prak_util_ratioOfSaTnewToSaTold(eqNumber, T_old, T_new1);
                          ratioOfSaTnewToSaTold2 = prak_util_ratioOfSaTnewToSaTold(eqNumber, T_old, T_new2);
                          currentRatToScale = (ratioOfSaTnewToSaTold1 * ratioOfSaTnewToSaTold2)^(1/2);

                          saT_newAllComp(eqIndex) = currentRatToScale * saT_oldAllComp(eqIndex);
                      end
                        if storyDriftIndex == 1; fprintf('Intensity measure type is %s. P1 = %.2f sec, P2 = %.2f sec. \n', imType, T_new1, T_new2); end
                  case 'Sa_P1_P3_geoM' % geoM of spectral acceleration of at first and third analytical time period
                      T_new1 = round(100 * timeP1LIST(j, 1))/100;
                      T_new3 = round(100 * timeP3LIST(j, 1))/100;
                      for eqIndex = 1:length(eqNumberLIST)
                          eqNumber = eqNumberLIST(eqIndex);

                          ratioOfSaTnewToSaTold1 = prak_util_ratioOfSaTnewToSaTold(eqNumber, T_old, T_new1);
                          ratioOfSaTnewToSaTold3 = prak_util_ratioOfSaTnewToSaTold(eqNumber, T_old, T_new3);
                          currentRatToScale = (ratioOfSaTnewToSaTold1 * ratioOfSaTnewToSaTold3)^(1/2);

                          saT_newAllComp(eqIndex) = currentRatToScale * saT_oldAllComp(eqIndex);
                      end
                          if storyDriftIndex == 1; fprintf('Intensity measure type is %s. P1 = %.2f sec, P3 = %.2f sec. \n', imType, T_new1, T_new3); end
                  case 'Sa_P1_P2_P3_geoM' % geoM of spectral acceleration of at first, second, and third analytical time period
                      T_new1 = round(100 * timeP1LIST(j, 1))/100;
                      T_new2 = round(100 * timeP2LIST(j, 1))/100;
                      T_new3 = round(100 * timeP3LIST(j, 1))/100;
                      for eqIndex = 1:length(eqNumberLIST)
                          eqNumber = eqNumberLIST(eqIndex);

                          ratioOfSaTnewToSaTold1 = prak_util_ratioOfSaTnewToSaTold(eqNumber, T_old, T_new1);
                          ratioOfSaTnewToSaTold2 = prak_util_ratioOfSaTnewToSaTold(eqNumber, T_old, T_new2);
                          ratioOfSaTnewToSaTold3 = prak_util_ratioOfSaTnewToSaTold(eqNumber, T_old, T_new3);
                          currentRatToScale = (ratioOfSaTnewToSaTold1 * ratioOfSaTnewToSaTold2 * ratioOfSaTnewToSaTold3)^(1/3);

                          saT_newAllComp(eqIndex) = currentRatToScale * saT_oldAllComp(eqIndex);
                      end
                          if storyDriftIndex == 1; fprintf('Intensity measure type is %s. P1 = %.2f sec, P2 = %.2f sec, P3 = %.2f sec. \n', imType, T_new1, T_new2, T_new3); end
                  case 'Sa_TimeGiven' % Sa(T1) using first mode analytical time period
                      %                       T_new1 = round(100 * timeP1LIST(j, 1))/100;
                      T_new1 = T_given;
                      for eqIndex = 1:length(eqNumberLIST)
                          eqNumber = eqNumberLIST(eqIndex);

                          ratioOfSaTnewToSaTold1 = prak_util_ratioOfSaTnewToSaTold(eqNumber, T_old, T_new1);
                          currentRatToScale = ratioOfSaTnewToSaTold1;

                          saT_newAllComp(eqIndex) = currentRatToScale * saT_oldAllComp(eqIndex);
                      end
                          if storyDriftIndex == 1; fprintf('Intensity measure type is %s. P1_new = %.2f sec. \n', imType, T_new1); end
              end

%% 2c. combine the new intensity measure values for different ground motions to find the fragility function parameters

              saT_newCtrlComp = zeros(1, length(eqNumberLIST)/2);

              for gmIndex = 1:length(eqNumberLIST)/2
                  saT_newCompOne = saT_newAllComp(gmIndex * 2 - 1);
                  saT_newCompTwo = saT_newAllComp(gmIndex * 2);
                  saT_newCtrlComp(gmIndex) = min(saT_newCompOne, saT_newCompTwo);
              end

              % Do collapse statistics - for all components
              meanCollapseSaTOneAllComp(j) = mean(saT_newAllComp);
              medianCollapseSaTOneAllComp(j) = (median(saT_newAllComp));
              meanLnCollapseSaTOneAllComp(j) = mean(log(saT_newAllComp));
              stDevCollapseSaTOneAllComp(j) = std(saT_newAllComp);
              stDevLnCollapseSaTOneAllComp(j) = std(log(saT_newAllComp));

              % Do collapse statistics - for controlling components
              meanCollapseSaTOneControlComp(j) = mean(saT_newCtrlComp);
              medianCollapseSaTOneControlComp(j) = (median(saT_newCtrlComp));
              meanLnCollapseSaTOneControlComp(j) = mean(log(saT_newCtrlComp));
              stDevCollapseSaTOneControlComp(j) = std(saT_newCtrlComp);
              stDevLnCollapseSaTOneControlComp(j) = std(log(saT_newCtrlComp));
          end
        %               fragParamMu = exp(meanLnCollapseSaTOneControlComp)';
        %               fragParamBetaRTR = stDevLnCollapseSaTOneControlComp';

          fragParamMu = exp(meanLnCollapseSaTOneAllComp)';
          fragParamBetaRTR = stDevLnCollapseSaTOneAllComp';
          
          

        %               T = table(buildingID' , timeP1LIST, fragParamMu, fragParamBetaRTR);
          if storyDriftIndex == 1 && imIndex == 1 % add building ID and time P only once
%             T = table(buildingID' , T_old);
            T = table(repmat(buildingID', length(imTypeLIST), 1), imTypeLIST);
            T.Properties.VariableNames{1} = 'bldg_ID';
            T.Properties.VariableNames{2} = 'imType';
          end
          
%           T(:, 2*storyDriftIndex+1:2*storyDriftIndex+2) = table(fragParamMu, fragParamBetaRTR);
          T(imIndex, 2*storyDriftIndex+1:2*storyDriftIndex+2) = table(fragParamMu, fragParamBetaRTR);
          T.Properties.VariableNames{2*storyDriftIndex+1} = sprintf('mu_%i', round(currentStoryDrift*100));
          T.Properties.VariableNames{2*storyDriftIndex+2} = sprintf('betaRTR_%i', round(currentStoryDrift*100));

        %               fprintf('____________________________________________\n');
        %               fprintf('Intensity measure type is %s \n', imType);
        %               fprintf('_________________________________________________________\n');
        %               fprintf('Fragility parameters for the Story drift ratio of %.2f%% are as follows- \n', currentStoryDrift*100);
        %               fprintf('_________________________________________________________\n');


          format long
        %               disp(T);
        end
    end
    
        disp(T);
        clearvars -except T baseFolder

    case '21a.convertFragilityToIM_vamva'
%%
bldgIdLIST = [30401 30402 30421 30422 30441 30442 30451 30452 30471 30472];
% bldgIdLIST = [30441];
outpFolderLIST = {
                'K:\Output\(ID30401_XZ_R0_4Story_v.02)_(AllVar)_(0.00)_(clough)'
                'K:\Output\(ID30402_YZ_R0_4Story_v.02)_(AllVar)_(0.00)_(clough)'
                'K:\Output\(ID30421_XZ_R0_4Story_v.02)_(AllVar)_(0.00)_(clough)'
                'K:\Output\(ID30422_YZ_R0_4Story_v.02)_(AllVar)_(0.00)_(clough)'
                'K:\Output\(ID30441_XZ_R0_4Story_v.02)_(AllVar)_(0.00)_(clough)'
                'K:\Output\(ID30442_YZ_R0_4Story_v.02)_(AllVar)_(0.00)_(clough)'
                'K:\Output\(ID30451_XZ_R0_4Story_v.02)_(AllVar)_(0.00)_(clough)'
                'K:\Output\(ID30452_YZ_R0_4Story_v.02)_(AllVar)_(0.00)_(clough)'
                'K:\Output\(ID30471_XZ_R0_4Story_v.02)_(AllVar)_(0.00)_(clough)'
                'K:\Output\(ID30472_YZ_R0_4Story_v.02)_(AllVar)_(0.00)_(clough)'
                };

storyDriftLIST = [0.00, 0.04, 0.02, 0.01]; % (values in fraction). 0.00 indicates sidesway collapse
				
% GM suite for 3040, 3042, 3044, 3045, and 3047 respectively.
 eqLIST_LIST = [
                6000901	6000902	6001641	6001642	6001831	6001832	6004971	6004972	6007991	6007992	6008821	6008822	6009501	6009502	6010931	6010932	6012581	6012582	6012851	6012852	6013681	6013682	6013911	6013912	6016461	6016462	6019841	6019842	6022521	6022522	6029271	6029272	6032351	6032352	6033271	6033272	6033501	6033502	6034521	6034522;
                6001881	6001882	6003521	6003522	6003931	6003932	6005451	6005452	6007241	6007242	6007611	6007612	6007811	6007812	6010131	6010132	6010701	6010702	6013491	6013492	6018301	6018302	6020261	6020262	6022791	6022792	6028181	6028182	6028301	6028302	6029331	6029332	6029871	6029872	6032871	6032872	6033821	6033822	6034921	6034922;
                6001561	6001562	6002161	6002162	6003111	6003112	6006651	6006652	6007231	6007232	6007491	6007492	6008541	6008542	6009501	6009502	6009731	6009732	6013471	6013472	6015131	6015132	6017641	6017642	6020261	6020262	6026211	6026212	6029891	6029892	6032401	6032402	6033481	6033482	6034731	6034732	6034921	6034922	6034971	6034972;
                6000211	6000212	6001111	6001112	6001231	6001232	6005301	6005302	6009901	6009902	6010021	6010022	6012111	6012112	6012321	6012322	6015211	6015212	6015851	6015852	6016271	6016272	6022701	6022702	6026501	6026502	6026571	6026572	6027931	6027932	6029101	6029102	6029801	6029802	6032831	6032832	6033821	6033822	6034041	6034042;
                6000161	6000162	6001231	6001232	6004541	6004542	6004711	6004712	6004921	6004922	6004971	6004972	6006181	6006182	6006651	6006652	6007991	6007992	6008491	6008492	6008951	6008952	6010471	6010472	6017641	6017642	6020091	6020092	6021041	6021042	6023081	6023082	6026501	6026502	6026991	6026992	6032131	6032132	6033851	6033852;
                ];
				
 for i = 1:length(outpFolderLIST)
    currentFolder = outpFolderLIST{i};
    cd(currentFolder) 
    cd 'MatlabInformation'
    eigenValLIST(i, :) = load('eigenvaluesOUT.out');
 end
 
 timeP1LIST = zeros(length(outpFolderLIST), 1);
 timeP2LIST = timeP1LIST; 
 for i = 1:length(outpFolderLIST)
     currEigValLIST = eigenValLIST(i, :);
% remove the spurious eigenvalues that are less than 0.5, they correspond to timeP of more than 8.9 sec.
     currEigValLIST(1:find(currEigValLIST < 0.5, 1, 'last' )) = [];
     timeP1LIST(i, 1) = 2 * pi / sqrt(currEigValLIST(1));
     timeP2LIST(i, 1) = 2 * pi / sqrt(currEigValLIST(2));
 end

% geoMean of time periods of all 5 buildings along both direction
T1m = geomean(timeP1LIST);
T2m = geomean(timeP2LIST);

% time periods of interest as per Kazantzi and Vamvatsikos (2015)
Ti(1) = T2m;
Ti(2) = min((T2m+T1m)/2, 1.5*T2m);
Ti(3) = T1m;
Ti(4) = 1.5*T1m;
Ti(5) = 2.0*T1m;

Ti = round(100 * Ti)/100;

% changing variables here to check the code for just two buildings
% bldgIdLIST = [30471 30472];
% outpFolderLIST = {'I:\PrakRuns_I\Output\(ID30471_XZ_R0_4Story_v.02)_(AllVar)_(0.00)_(clough)'
%                 'I:\PrakRuns_I\Output\(ID30472_YZ_R0_4Story_v.02)_(AllVar)_(0.00)_(clough)'};
% eqLIST_LIST = [ 6000161	6000162	6001231	6001232	6004541	6004542	6004711	6004712	6004921	6004922	6004971	6004972	6006181	6006182	6006651	6006652	6007991	6007992	6008491	6008492	6008951	6008952	6010471	6010472	6017641	6017642	6020091	6020092	6021041	6021042	6023081	6023082	6026501	6026502	6026991	6026992	6032131	6032132	6033851	6033852;];

%% following loop is obsolete, since we extract T_old below using the same procedure
% for i = 1:length(outpFolderLIST)
%     currentFolder = outpFolderLIST{i};
%     cd(currentFolder)
%     fileNameToLoad = sprintf('DATA_collapse_CollapseSaAndStats_GMSetMum20_%i_SaGeoMean.mat', floor(bldgIdLIST(i)/10));
%     load(fileNameToLoad, 'collapseLevelForAllComp', 'meanLnCollapseSaTOneControlComp', 'meanLnCollapseSaTOneAllComp', 'periodUsedForScalingGroundMotions', 'stDevLnCollapseSaTOneAllComp', 'stDevLnCollapseSaTOneControlComp');
%     time_analysis(i) = periodUsedForScalingGroundMotions;
%     cd ..
% end

for storyDriftIndex = 1:length(storyDriftLIST)
          currentStoryDrift = storyDriftLIST(storyDriftIndex);

          cd(baseFolder); % now we are in the original directory
%% 2a. extract the old period and values of spectral acceleration corr. to story drift ratio as chosen above
    for j = 1:length(outpFolderLIST)

        eqNumberLIST = eqLIST_LIST(floor((j+1)/2), :); 

        matFileToLoad = sprintf('DATA_collapse_CollapseSaAndStats_GMSetMum20_%i_SaGeoMean.mat', floor(bldgIdLIST(j)/10));

        [T_old, saT_oldAllComp] = prak_util_extractFragDataPoints_v02(outpFolderLIST{j}, eqNumberLIST, currentStoryDrift, matFileToLoad);

        for eqIndex = 1:length(eqNumberLIST)
            eqNumber = eqNumberLIST(eqIndex);
            for k = 1:length(Ti)
                T_new1 = Ti(k);
                ratioOfSaTnewToSaTold1 = prak_util_ratioOfSaTnewToSaTold(eqNumber, T_old, T_new1);
                currentRatToScale = ratioOfSaTnewToSaTold1;
                saT_newAllComp(eqIndex, k) = currentRatToScale * saT_oldAllComp(eqIndex);
            end
                IM_newAllComp(eqIndex) = geomean(saT_newAllComp(eqIndex, :)); % since Vamvatsikos intensity measure involves taking geomean of all these spectral acceleration values
        end

%% 2c. combine the new intensity measure values for different ground motions to find the fragility function parameters

          IM_newCtrlComp = zeros(1, length(eqNumberLIST)/2);

          for gmIndex = 1:length(eqNumberLIST)/2
              saT_newCompOne = IM_newAllComp(gmIndex * 2 - 1);
              saT_newCompTwo = IM_newAllComp(gmIndex * 2);
              IM_newCtrlComp(gmIndex) = min(saT_newCompOne, saT_newCompTwo);
          end

          % Do collapse statistics - for all components
          meanCollapseSaTOneAllComp(j) = mean(IM_newAllComp);
          medianCollapseSaTOneAllComp(j) = (median(IM_newAllComp));
          meanLnCollapseSaTOneAllComp(j) = mean(log(IM_newAllComp));
          stDevCollapseSaTOneAllComp(j) = std(IM_newAllComp);
          stDevLnCollapseSaTOneAllComp(j) = std(log(IM_newAllComp));

          % Do collapse statistics - for controlling components
          meanCollapseSaTOneControlComp(j) = mean(IM_newCtrlComp);
          medianCollapseSaTOneControlComp(j) = (median(IM_newCtrlComp));
          meanLnCollapseSaTOneControlComp(j) = mean(log(IM_newCtrlComp));
          stDevCollapseSaTOneControlComp(j) = std(IM_newCtrlComp);
          stDevLnCollapseSaTOneControlComp(j) = std(log(IM_newCtrlComp));
          if storyDriftIndex == 1 && j == 1 % add building ID and time P only once
              T = table(bldgIdLIST');
              T.Properties.VariableNames{1} = 'bldg_ID';
          end
    end
	%               fragParamMu = exp(meanLnCollapseSaTOneControlComp)';
	%               fragParamBetaRTR = stDevLnCollapseSaTOneControlComp';

	  fragParamMu = exp(meanLnCollapseSaTOneAllComp)';
	  fragParamBetaRTR = stDevLnCollapseSaTOneAllComp';		
      T(:, 2*storyDriftIndex:2*storyDriftIndex+1) = table(fragParamMu, fragParamBetaRTR);
      T.Properties.VariableNames{2*storyDriftIndex} = sprintf('mu_%i', round(currentStoryDrift*100));
      T.Properties.VariableNames{2*storyDriftIndex+1} = sprintf('betaRTR_%i', round(currentStoryDrift*100));
%       format long
end
    
        disp(T);
        clearvars -except T baseFolder

    case '21b.extractFragility_SaT1geoM'
%%
bldgIdLIST = [30401 30402 30421 30422 30441 30442 30451 30452 30471 30472];
outpFolderLIST = {
                'K:\Output\(ID30401_XZ_R0_4Story_v.02)_(AllVar)_(0.00)_(clough)'
                'K:\Output\(ID30402_YZ_R0_4Story_v.02)_(AllVar)_(0.00)_(clough)'
                'K:\Output\(ID30421_XZ_R0_4Story_v.02)_(AllVar)_(0.00)_(clough)'
                'K:\Output\(ID30422_YZ_R0_4Story_v.02)_(AllVar)_(0.00)_(clough)'
                'K:\Output\(ID30441_XZ_R0_4Story_v.02)_(AllVar)_(0.00)_(clough)'
                'K:\Output\(ID30442_YZ_R0_4Story_v.02)_(AllVar)_(0.00)_(clough)'
                'K:\Output\(ID30451_XZ_R0_4Story_v.02)_(AllVar)_(0.00)_(clough)'
                'K:\Output\(ID30452_YZ_R0_4Story_v.02)_(AllVar)_(0.00)_(clough)'
                'K:\Output\(ID30471_XZ_R0_4Story_v.02)_(AllVar)_(0.00)_(clough)'
                'K:\Output\(ID30472_YZ_R0_4Story_v.02)_(AllVar)_(0.00)_(clough)'
                };

storyDriftLIST = [0.00, 0.04, 0.02, 0.01]; % (values in fraction). 0.00 indicates sidesway collapse
				
% GM suite for 3040, 3042, 3044, 3045, and 3047 respectively.
 eqLIST_LIST = [
                6000901	6000902	6001641	6001642	6001831	6001832	6004971	6004972	6007991	6007992	6008821	6008822	6009501	6009502	6010931	6010932	6012581	6012582	6012851	6012852	6013681	6013682	6013911	6013912	6016461	6016462	6019841	6019842	6022521	6022522	6029271	6029272	6032351	6032352	6033271	6033272	6033501	6033502	6034521	6034522;
                6001881	6001882	6003521	6003522	6003931	6003932	6005451	6005452	6007241	6007242	6007611	6007612	6007811	6007812	6010131	6010132	6010701	6010702	6013491	6013492	6018301	6018302	6020261	6020262	6022791	6022792	6028181	6028182	6028301	6028302	6029331	6029332	6029871	6029872	6032871	6032872	6033821	6033822	6034921	6034922;
                6001561	6001562	6002161	6002162	6003111	6003112	6006651	6006652	6007231	6007232	6007491	6007492	6008541	6008542	6009501	6009502	6009731	6009732	6013471	6013472	6015131	6015132	6017641	6017642	6020261	6020262	6026211	6026212	6029891	6029892	6032401	6032402	6033481	6033482	6034731	6034732	6034921	6034922	6034971	6034972;
                6000211	6000212	6001111	6001112	6001231	6001232	6005301	6005302	6009901	6009902	6010021	6010022	6012111	6012112	6012321	6012322	6015211	6015212	6015851	6015852	6016271	6016272	6022701	6022702	6026501	6026502	6026571	6026572	6027931	6027932	6029101	6029102	6029801	6029802	6032831	6032832	6033821	6033822	6034041	6034042;
                6000161	6000162	6001231	6001232	6004541	6004542	6004711	6004712	6004921	6004922	6004971	6004972	6006181	6006182	6006651	6006652	6007991	6007992	6008491	6008492	6008951	6008952	6010471	6010472	6017641	6017642	6020091	6020092	6021041	6021042	6023081	6023082	6026501	6026502	6026991	6026992	6032131	6032132	6033851	6033852;
                ];

for storyDriftIndex = 1:length(storyDriftLIST)
          currentStoryDrift = storyDriftLIST(storyDriftIndex);

          cd(baseFolder); % now we are in the original directory
%% 2a. extract the old period and values of spectral acceleration corr. to story drift ratio as chosen above
		for j = 1:length(outpFolderLIST)
			
			eqNumberLIST = eqLIST_LIST(floor((j+1)/2), :); 
			
			matFileToLoad = sprintf('DATA_collapse_CollapseSaAndStats_GMSetMum20_%i_SaGeoMean.mat', floor(bldgIdLIST(j)/10));
			
			[T_old, saT_oldAllComp] = prak_util_extractFragDataPoints_v02(outpFolderLIST{j}, eqNumberLIST, currentStoryDrift, matFileToLoad);
		
%% (6-21-19, PSB) commented the following to extract the analyzed fragility i.e. with Sa(T1,geoMean_individual)
% 			for eqIndex = 1:length(eqNumberLIST)
% 				eqNumber = eqNumberLIST(eqIndex);
% 				for k = 1:length(Ti)
% 					T_new1 = Ti(k);
% 					ratioOfSaTnewToSaTold1 = prak_util_ratioOfSaTnewToSaTold(eqNumber, T_old, T_new1);
% 					currentRatToScale = ratioOfSaTnewToSaTold1;
% 					saT_newAllComp(eqIndex, k) = currentRatToScale * saT_oldAllComp(eqIndex);
% 				end
% 					IM_newAllComp(eqIndex) = geomean(saT_newAllComp(eqIndex, :));
%             end
            IM_newAllComp = saT_oldAllComp; % (6-21-19, PSB) added this to extract the analyzed fragility

%% 2c. combine the new intensity measure values for different ground motions to find the fragility function parameters

		  IM_newCtrlComp = zeros(1, length(eqNumberLIST)/2);

          for gmIndex = 1:length(eqNumberLIST)/2
              saT_newCompOne = IM_newAllComp(gmIndex * 2 - 1);
              saT_newCompTwo = IM_newAllComp(gmIndex * 2);
              IM_newCtrlComp(gmIndex) = min(saT_newCompOne, saT_newCompTwo);
          end

		  % Do collapse statistics - for all components
		  meanCollapseSaTOneAllComp(j) = mean(IM_newAllComp);
		  medianCollapseSaTOneAllComp(j) = (median(IM_newAllComp));
		  meanLnCollapseSaTOneAllComp(j) = mean(log(IM_newAllComp));
		  stDevCollapseSaTOneAllComp(j) = std(IM_newAllComp);
		  stDevLnCollapseSaTOneAllComp(j) = std(log(IM_newAllComp));

		  % Do collapse statistics - for controlling components
		  meanCollapseSaTOneControlComp(j) = mean(IM_newCtrlComp);
		  medianCollapseSaTOneControlComp(j) = (median(IM_newCtrlComp));
		  meanLnCollapseSaTOneControlComp(j) = mean(log(IM_newCtrlComp));
		  stDevCollapseSaTOneControlComp(j) = std(IM_newCtrlComp);
		  stDevLnCollapseSaTOneControlComp(j) = std(log(IM_newCtrlComp));
          if storyDriftIndex == 1 && j == 1 % add building ID and time P only once
              T = table(bldgIdLIST');
              T.Properties.VariableNames{1} = 'bldg_ID';
          end
		end
	              fragParamMu = exp(meanLnCollapseSaTOneControlComp)';
	              fragParamBetaRTR = stDevLnCollapseSaTOneControlComp';

% 	  fragParamMu = exp(meanLnCollapseSaTOneAllComp)';
% 	  fragParamBetaRTR = stDevLnCollapseSaTOneAllComp';		
      T(:, 2*storyDriftIndex:2*storyDriftIndex+1) = table(fragParamMu, fragParamBetaRTR);
      T.Properties.VariableNames{2*storyDriftIndex} = sprintf('mu_%i', round(currentStoryDrift*100));
      T.Properties.VariableNames{2*storyDriftIndex+1} = sprintf('betaRTR_%i', round(currentStoryDrift*100));
%       format long
end
    
        disp(T);
        clearvars -except T baseFolder

    case '21c.extractFragility_PGA'
%%
bldgIdLIST = [30401 30402 30421 30422 30441 30442 30451 30452 30471 30472];
outpFolderLIST = {
                'K:\Output\(ID30401_XZ_R0_4Story_v.02)_(AllVar)_(0.00)_(clough)'
                'K:\Output\(ID30402_YZ_R0_4Story_v.02)_(AllVar)_(0.00)_(clough)'
                'K:\Output\(ID30421_XZ_R0_4Story_v.02)_(AllVar)_(0.00)_(clough)'
                'K:\Output\(ID30422_YZ_R0_4Story_v.02)_(AllVar)_(0.00)_(clough)'
                'K:\Output\(ID30441_XZ_R0_4Story_v.02)_(AllVar)_(0.00)_(clough)'
                'K:\Output\(ID30442_YZ_R0_4Story_v.02)_(AllVar)_(0.00)_(clough)'
                'K:\Output\(ID30451_XZ_R0_4Story_v.02)_(AllVar)_(0.00)_(clough)'
                'K:\Output\(ID30452_YZ_R0_4Story_v.02)_(AllVar)_(0.00)_(clough)'
                'K:\Output\(ID30471_XZ_R0_4Story_v.02)_(AllVar)_(0.00)_(clough)'
                'K:\Output\(ID30472_YZ_R0_4Story_v.02)_(AllVar)_(0.00)_(clough)'
                };

storyDriftLIST = [0.00, 0.04, 0.02, 0.01]; % (values in fraction). 0.00 indicates sidesway collapse
				
% GM suite for 3040, 3042, 3044, 3045, and 3047 respectively.
 eqLIST_LIST = [
                6000901	6000902	6001641	6001642	6001831	6001832	6004971	6004972	6007991	6007992	6008821	6008822	6009501	6009502	6010931	6010932	6012581	6012582	6012851	6012852	6013681	6013682	6013911	6013912	6016461	6016462	6019841	6019842	6022521	6022522	6029271	6029272	6032351	6032352	6033271	6033272	6033501	6033502	6034521	6034522;
                6001881	6001882	6003521	6003522	6003931	6003932	6005451	6005452	6007241	6007242	6007611	6007612	6007811	6007812	6010131	6010132	6010701	6010702	6013491	6013492	6018301	6018302	6020261	6020262	6022791	6022792	6028181	6028182	6028301	6028302	6029331	6029332	6029871	6029872	6032871	6032872	6033821	6033822	6034921	6034922;
                6001561	6001562	6002161	6002162	6003111	6003112	6006651	6006652	6007231	6007232	6007491	6007492	6008541	6008542	6009501	6009502	6009731	6009732	6013471	6013472	6015131	6015132	6017641	6017642	6020261	6020262	6026211	6026212	6029891	6029892	6032401	6032402	6033481	6033482	6034731	6034732	6034921	6034922	6034971	6034972;
                6000211	6000212	6001111	6001112	6001231	6001232	6005301	6005302	6009901	6009902	6010021	6010022	6012111	6012112	6012321	6012322	6015211	6015212	6015851	6015852	6016271	6016272	6022701	6022702	6026501	6026502	6026571	6026572	6027931	6027932	6029101	6029102	6029801	6029802	6032831	6032832	6033821	6033822	6034041	6034042;
                6000161	6000162	6001231	6001232	6004541	6004542	6004711	6004712	6004921	6004922	6004971	6004972	6006181	6006182	6006651	6006652	6007991	6007992	6008491	6008492	6008951	6008952	6010471	6010472	6017641	6017642	6020091	6020092	6021041	6021042	6023081	6023082	6026501	6026502	6026991	6026992	6032131	6032132	6033851	6033852;
                ];

for storyDriftIndex = 1:length(storyDriftLIST)
    currentStoryDrift = storyDriftLIST(storyDriftIndex);

    cd(baseFolder); % now we are in the original directory
%% 2a. extract the old period and values of spectral acceleration corr. to story drift ratio as chosen above
    for j = 1:length(outpFolderLIST)

        eqNumberLIST = eqLIST_LIST(floor((j+1)/2), :);

        matFileToLoad = sprintf('DATA_collapse_CollapseSaAndStats_GMSetMum20_%i_SaGeoMean.mat', floor(bldgIdLIST(j)/10));

        [T_old, saT_oldAllComp] = prak_util_extractFragDataPoints_v02(outpFolderLIST{j}, eqNumberLIST, currentStoryDrift, matFileToLoad);

        %% (6-28-19, PSB) extract fragility with PGA as Intensity Measure
        for eqIndex = 1:length(eqNumberLIST)
            eqNumber = eqNumberLIST(eqIndex);
            T_new1 = 0.00;
            ratioOfSaTnewToSaTold1 = prak_util_ratioOfSaTnewToSaTold(eqNumber, T_old, T_new1); % for PGA (modified the function for considering PGA)
            currentRatToScale = ratioOfSaTnewToSaTold1;
            saT_newAllComp(eqIndex) = currentRatToScale * saT_oldAllComp(eqIndex);
            IM_newAllComp(eqIndex) = saT_newAllComp(eqIndex); % (6-21-19, PSB) added this to extract the fragility for PGA
        end
%% 2b. depending on the intensity measure type, find ratio of scaling from old IM value to new value for each earthquake (NOT NEEDED in case of PGA)

%% 2c. combine the new intensity measure values for different ground motions to find the fragility function parameters

    IM_newCtrlComp = zeros(1, length(eqNumberLIST)/2);

        for gmIndex = 1:length(eqNumberLIST)/2
            saT_newCompOne = IM_newAllComp(gmIndex * 2 - 1);
            saT_newCompTwo = IM_newAllComp(gmIndex * 2);
            IM_newCtrlComp(gmIndex) = min(saT_newCompOne, saT_newCompTwo);
        end

        % Do collapse statistics - for all components
        meanCollapseSaTOneAllComp(j) = mean(IM_newAllComp);
        medianCollapseSaTOneAllComp(j) = (median(IM_newAllComp));
        meanLnCollapseSaTOneAllComp(j) = mean(log(IM_newAllComp));
        stDevCollapseSaTOneAllComp(j) = std(IM_newAllComp);
        stDevLnCollapseSaTOneAllComp(j) = std(log(IM_newAllComp));

        % Do collapse statistics - for controlling components
        meanCollapseSaTOneControlComp(j) = mean(IM_newCtrlComp);
        medianCollapseSaTOneControlComp(j) = (median(IM_newCtrlComp));
        meanLnCollapseSaTOneControlComp(j) = mean(log(IM_newCtrlComp));
        stDevCollapseSaTOneControlComp(j) = std(IM_newCtrlComp);
        stDevLnCollapseSaTOneControlComp(j) = std(log(IM_newCtrlComp));
        if storyDriftIndex == 1 && j == 1 % add building ID and time P only once
            T = table(bldgIdLIST');
            T.Properties.VariableNames{1} = 'bldg_ID';
        end
    end
	%               fragParamMu = exp(meanLnCollapseSaTOneControlComp)';
	%               fragParamBetaRTR = stDevLnCollapseSaTOneControlComp';

	  fragParamMu_ALL = exp(meanLnCollapseSaTOneAllComp)';
	  fragParamBetaRTR_ALL = stDevLnCollapseSaTOneAllComp';		
      T(:, 4*storyDriftIndex-2:4*storyDriftIndex-1) = table(fragParamMu_ALL, fragParamBetaRTR_ALL);
      T.Properties.VariableNames{4*storyDriftIndex-2} = sprintf('mu_%i_ALL', round(currentStoryDrift*100));
      T.Properties.VariableNames{4*storyDriftIndex-1} = sprintf('betaRTR_%i_ALL', round(currentStoryDrift*100));

      fragParamMu_CTRL = exp(meanLnCollapseSaTOneControlComp)';
	  fragParamBetaRTR_CTRL = stDevLnCollapseSaTOneControlComp';		
      T(:, 4*storyDriftIndex:4*storyDriftIndex+1) = table(fragParamMu_CTRL, fragParamBetaRTR_CTRL);
      T.Properties.VariableNames{4*storyDriftIndex} = sprintf('mu_%i_CTRL', round(currentStoryDrift*100));
      T.Properties.VariableNames{4*storyDriftIndex+1} = sprintf('betaRTR_%i_CTRL', round(currentStoryDrift*100));

      %       format long
end
    
        disp(T);
        clearvars -except T baseFolder

    case '21d.extractFragility_PGA_SMRFArch'
%%
bldgIdLIST1 = [2205];
outpFolderLIST1 = {'K:\Output\(ID2205_R5_4Story_v.03)_(AllVar)_(0.00)_(clough)'};

bldgIdLIST = [2205, 2207,2209,2211,2213,2451,2453,2215,2217,2219,2221,2433,2435,...
              2223,2457,2459,2461,2463,2225,2227,2437,2439,2229,2231,2441,...
              2443,2233,2235,2445,2447,2237];
          
outpFolderLIST = {
                'K:\Output\(ID2205_R5_4Story_v.03)_(AllVar)_(0.00)_(clough)'
                'K:\Output\(ID2207_R5_7Story_v.09)_(AllVar)_(0.00)_(clough)';
                'K:\Output\(ID2209_R5_12Story_v.05)_(AllVar)_(0.00)_(clough)';
                'K:\Output\(ID2211_R5_2Story_v.03)_(AllVar)_(0.00)_(clough)';
                'K:\Output\(ID2213_R5_4Story_v.04)_(AllVar)_(0.00)_(clough)';
                'K:\Output\(ID2451_R5_5Story_v.02)_(AllVar)_(0.00)_(clough)';
                'K:\Output\(ID2453_R5_6Story_v.02)_(AllVar)_(0.00)_(clough)';
                'K:\Output\(ID2215_R5_7Story_v.03)_(AllVar)_(0.00)_(clough)';
                'K:\Output\(ID2217_R5_12Story_v.03)_(AllVar)_(0.00)_(clough)';
                'K:\Output\(ID2219_R5_2Story_v.03)_(AllVar)_(0.00)_(clough)';
                'K:\Output\(ID2221_R5_4Story_v.06)_(AllVar)_(0.00)_(clough)';
                'K:\Output\(ID2433_R5_5Story_v.02)_(AllVar)_(0.00)_(clough)';
                'K:\Output\(ID2435_R5_6Story_v.02)_(AllVar)_(0.00)_(clough)';
                'K:\Output\(ID2223_R5_7Story_v.03)_(AllVar)_(0.00)_(clough)';
                'K:\Output\(ID2457_R5_8Story_v.01)_(AllVar)_(0.00)_(clough)';
                'K:\Output\(ID2459_R5_9Story_v.01)_(AllVar)_(0.00)_(clough)';
                'K:\Output\(ID2461_R5_10Story_v.01)_(AllVar)_(0.00)_(clough)';
                'K:\Output\(ID2463_R5_11Story_v.01)_(AllVar)_(0.00)_(clough)';
                'K:\Output\(ID2225_R5_12Story_v.03)_(AllVar)_(0.00)_(clough)';
                'K:\Output\(ID2227_R5_4Story_v.05)_(AllVar)_(0.00)_(clough)';
                'K:\Output\(ID2437_R5_5Story_v.02)_(AllVar)_(0.00)_(clough)';
                'K:\Output\(ID2439_R5_6Story_v.02)_(AllVar)_(0.00)_(clough)';
                'K:\Output\(ID2229_R5_7Story_v.03)_(AllVar)_(0.00)_(clough)';
                'K:\Output\(ID2231_R5_4Story_v.04)_(AllVar)_(0.00)_(clough)';
                'K:\Output\(ID2441_R5_5Story_v.02)_(AllVar)_(0.00)_(clough)';
                'K:\Output\(ID2443_R5_6Story_v.02)_(AllVar)_(0.00)_(clough)';
                'K:\Output\(ID2233_R5_7Story_v.03)_(AllVar)_(0.00)_(clough)';
                'K:\Output\(ID2235_R5_4Story_v.04)_(AllVar)_(0.00)_(clough)';
                'K:\Output\(ID2445_R5_5Story_v.02)_(AllVar)_(0.00)_(clough)';
                'K:\Output\(ID2447_R5_6Story_v.02a)_(AllVar)_(0.00)_(clough)';
                'K:\Output\(ID2237_R5_7Story_v.03a)_(AllVar)_(0.00)_(clough)';
                };

storyDriftLIST = [0.00, 0.04, 0.02, 0.01]; %, 0.533, 0.08]; % (values in fraction). 0.00 indicates sidesway collapse (dynamic instability)
				
% GM suite for 3040, 3042, 3044, 3045, and 3047 respectively.
eqNumberLIST_forProcessing_SetC = [120111, 120112, 120121, 120122,	120411, 120412,	120521, 120522,	120611, 120612,	120621, 120622,	120711, 120712,	120721, 120722,	120811, 120812,	120821, 120822,	120911, 120912,	120921, 120922,	121011, 121012,	121021, 121022,	121111, 121112,	121211, 121212,	121221, 121222,	121321, 121322,	121411, 121412,	121421, 121422,	121511, 121512,	121711, 121712];
eqLIST_LIST = eqNumberLIST_forProcessing_SetC;

for storyDriftIndex = 1:length(storyDriftLIST)
    currentStoryDrift = storyDriftLIST(storyDriftIndex);

    cd(baseFolder); % now we are in the original directory
%% 2a. extract the old period and values of spectral acceleration corr. to story drift ratio as chosen above
    for j = 1:length(outpFolderLIST)
        if length(outpFolderLIST) ~= length(bldgIdLIST); error('Number of building IDs does not match the number of output folders'); end
        if mod(j-1, 5) == 0; fprintf('For (%i/%i) drift ratio value, executing (%i/%i) building...\n', storyDriftIndex, length(storyDriftLIST), j, length(outpFolderLIST)); end
        
        currBldgID = bldgIdLIST(1, j);
        
        eqNumberLIST = eqLIST_LIST; % eqNumberLIST = eqLIST_LIST(floor((j+1)/2), :);

%         matFileToLoad = sprintf('DATA_collapse_CollapseSaAndStats_GMSetMum20_%i_SaGeoMean.mat', floor(bldgIdLIST(j)/10));
        matFileToLoad = sprintf('DATA_collapse_CollapseSaAndStats_%s_SaGeoMean.mat', 'GMSetC');

        [T_old, saT_oldAllComp] = prak_util_extractFragDataPoints_v02(outpFolderLIST{j}, eqNumberLIST, currentStoryDrift, matFileToLoad);

%% 2b. depending on the intensity measure type, find ratio of scaling from old IM value to new value for each earthquake (NOT NEEDED in case of PGA)
% (6-28-19, PSB) extract fragility with PGA as Intensity Measure
        for eqIndex = 1:length(eqNumberLIST)
            eqNumber = eqNumberLIST(eqIndex);
            T_new1 = 0.00;
            ratioOfSaTnewToSaTold1 = prak_util_ratioOfSaTnewToSaTold(eqNumber, T_old, T_new1); % for PGA (modified the function for considering PGA)
            currentRatToScale = ratioOfSaTnewToSaTold1;
            saT_newAllComp(eqIndex) = currentRatToScale * saT_oldAllComp(eqIndex);
            IM_newAllComp(eqIndex) = saT_newAllComp(eqIndex); % (6-21-19, PSB) added this to extract the fragility for PGA
        end
        indFragDataAllComp{currBldgID, storyDriftIndex} = IM_newAllComp;
            
%% 2c. combine the new intensity measure values for different ground motions to find the fragility function parameters
    IM_newCtrlComp = zeros(1, length(eqNumberLIST)/2);

        for gmIndex = 1:length(eqNumberLIST)/2
            saT_newCompOne = IM_newAllComp(gmIndex * 2 - 1);
            saT_newCompTwo = IM_newAllComp(gmIndex * 2);
            IM_newCtrlComp(gmIndex) = min(saT_newCompOne, saT_newCompTwo);
        end
        indFragDataCtrlComp{currBldgID, storyDriftIndex} = IM_newCtrlComp;

        % Do collapse statistics - for all components
        meanCollapseSaTOneAllComp(j) = mean(IM_newAllComp);
        medianCollapseSaTOneAllComp(j) = (median(IM_newAllComp));
        meanLnCollapseSaTOneAllComp(j) = mean(log(IM_newAllComp));
        stDevCollapseSaTOneAllComp(j) = std(IM_newAllComp);
        stDevLnCollapseSaTOneAllComp(j) = std(log(IM_newAllComp));
        minColLevelSaAll(j) = min(IM_newAllComp);
        maxColLevelSaAll(j) = max(IM_newAllComp);


        % Do collapse statistics - for controlling components
        meanCollapseSaTOneControlComp(j) = mean(IM_newCtrlComp);
        medianCollapseSaTOneControlComp(j) = (median(IM_newCtrlComp));
        meanLnCollapseSaTOneControlComp(j) = mean(log(IM_newCtrlComp));
        stDevCollapseSaTOneControlComp(j) = std(IM_newCtrlComp);
        stDevLnCollapseSaTOneControlComp(j) = std(log(IM_newCtrlComp));
        minColLevelSaCtrl(j) = min(IM_newCtrlComp);
        maxColLevelSaCtrl(j) = max(IM_newCtrlComp);
        if storyDriftIndex == 1 && j == 1 % add building ID and time P only once
            T = table(bldgIdLIST');
            T.Properties.VariableNames{1} = 'bldg_ID';
        end
    end
	%               fragParamMu = exp(meanLnCollapseSaTOneControlComp)';
	%               fragParamBetaRTR = stDevLnCollapseSaTOneControlComp';

	  fragParamMu_ALL = exp(meanLnCollapseSaTOneAllComp);
	  fragParamBetaRTR_ALL = stDevLnCollapseSaTOneAllComp;		
      T(:, 8*storyDriftIndex-6:8*storyDriftIndex-5) = table(fragParamMu_ALL', fragParamBetaRTR_ALL');
      T(:, 8*storyDriftIndex-4:8*storyDriftIndex-3) = table(minColLevelSaAll', maxColLevelSaAll');
      T.Properties.VariableNames{8*storyDriftIndex-6} = sprintf('mu_%i_ALL', round(currentStoryDrift*100));
      T.Properties.VariableNames{8*storyDriftIndex-5} = sprintf('betaRTR_%i_ALL', round(currentStoryDrift*100));
      T.Properties.VariableNames{8*storyDriftIndex-4} = sprintf('minSa_%i_ALL', round(currentStoryDrift*100));
      T.Properties.VariableNames{8*storyDriftIndex-3} = sprintf('maxSa_%i_ALL', round(currentStoryDrift*100));

      fragParamMu_CTRL = exp(meanLnCollapseSaTOneControlComp);
	  fragParamBetaRTR_CTRL = stDevLnCollapseSaTOneControlComp;		
      T(:, 8*storyDriftIndex-2:8*storyDriftIndex-1) = table(fragParamMu_CTRL', fragParamBetaRTR_CTRL');
      T(:, 8*storyDriftIndex-0:8*storyDriftIndex+1) = table(minColLevelSaCtrl', maxColLevelSaCtrl');
      T.Properties.VariableNames{8*storyDriftIndex-2} = sprintf('mu_%i_CTRL', round(currentStoryDrift*100));
      T.Properties.VariableNames{8*storyDriftIndex-1} = sprintf('betaRTR_%i_CTRL', round(currentStoryDrift*100));
      T.Properties.VariableNames{8*storyDriftIndex-0} = sprintf('minSa_%i_CTRL', round(currentStoryDrift*100));
      T.Properties.VariableNames{8*storyDriftIndex+1} = sprintf('maxSa_%i_CTRL', round(currentStoryDrift*100));

      %       format long
end
    
        disp(T);
        clearvars -except T baseFolder indFragDataAllComp indFragDataCtrlComp bldgIdLIST eqNumberLIST storyDriftLIST
        
        fileNameToSave = 'indFragDataThreeDS_PGA';
        cd H:\DistributionGoodnessFit
        save(fileNameToSave, 'indFragDataAllComp', 'indFragDataCtrlComp', 'T', 'bldgIdLIST', 'eqNumberLIST', 'storyDriftLIST');
        fprintf('Data file saved in: %s\n', pwd);

    case '21e.extractFragility_SaTa_SMRFArch' 
%%
bldgIdLIST1 = [2205];
outpFolderLIST1 = {'K:\Output\(ID2205_R5_4Story_v.03)_(AllVar)_(0.00)_(clough)'};

bldgIdLIST = [2205, 2207,2209,2211,2213,2451,2453,2215,2217,2219,2221,2433,2435,...
              2223,2457,2459,2461,2463,2225,2227,2437,2439,2229,2231,2441,...
              2443,2233,2235,2445,2447,2237];
          
outpFolderLIST = {
                'K:\Output\(ID2205_R5_4Story_v.03)_(AllVar)_(0.00)_(clough)'
                'K:\Output\(ID2207_R5_7Story_v.09)_(AllVar)_(0.00)_(clough)';
                'K:\Output\(ID2209_R5_12Story_v.05)_(AllVar)_(0.00)_(clough)';
                'K:\Output\(ID2211_R5_2Story_v.03)_(AllVar)_(0.00)_(clough)';
                'K:\Output\(ID2213_R5_4Story_v.04)_(AllVar)_(0.00)_(clough)';
                'K:\Output\(ID2451_R5_5Story_v.02)_(AllVar)_(0.00)_(clough)';
                'K:\Output\(ID2453_R5_6Story_v.02)_(AllVar)_(0.00)_(clough)';
                'K:\Output\(ID2215_R5_7Story_v.03)_(AllVar)_(0.00)_(clough)';
                'K:\Output\(ID2217_R5_12Story_v.03)_(AllVar)_(0.00)_(clough)';
                'K:\Output\(ID2219_R5_2Story_v.03)_(AllVar)_(0.00)_(clough)';
                'K:\Output\(ID2221_R5_4Story_v.06)_(AllVar)_(0.00)_(clough)';
                'K:\Output\(ID2433_R5_5Story_v.02)_(AllVar)_(0.00)_(clough)';
                'K:\Output\(ID2435_R5_6Story_v.02)_(AllVar)_(0.00)_(clough)';
                'K:\Output\(ID2223_R5_7Story_v.03)_(AllVar)_(0.00)_(clough)';
                'K:\Output\(ID2457_R5_8Story_v.01)_(AllVar)_(0.00)_(clough)';
                'K:\Output\(ID2459_R5_9Story_v.01)_(AllVar)_(0.00)_(clough)';
                'K:\Output\(ID2461_R5_10Story_v.01)_(AllVar)_(0.00)_(clough)';
                'K:\Output\(ID2463_R5_11Story_v.01)_(AllVar)_(0.00)_(clough)';
                'K:\Output\(ID2225_R5_12Story_v.03)_(AllVar)_(0.00)_(clough)';
                'K:\Output\(ID2227_R5_4Story_v.05)_(AllVar)_(0.00)_(clough)';
                'K:\Output\(ID2437_R5_5Story_v.02)_(AllVar)_(0.00)_(clough)';
                'K:\Output\(ID2439_R5_6Story_v.02)_(AllVar)_(0.00)_(clough)';
                'K:\Output\(ID2229_R5_7Story_v.03)_(AllVar)_(0.00)_(clough)';
                'K:\Output\(ID2231_R5_4Story_v.04)_(AllVar)_(0.00)_(clough)';
                'K:\Output\(ID2441_R5_5Story_v.02)_(AllVar)_(0.00)_(clough)';
                'K:\Output\(ID2443_R5_6Story_v.02)_(AllVar)_(0.00)_(clough)';
                'K:\Output\(ID2233_R5_7Story_v.03)_(AllVar)_(0.00)_(clough)';
                'K:\Output\(ID2235_R5_4Story_v.04)_(AllVar)_(0.00)_(clough)';
                'K:\Output\(ID2445_R5_5Story_v.02)_(AllVar)_(0.00)_(clough)';
                'K:\Output\(ID2447_R5_6Story_v.02a)_(AllVar)_(0.00)_(clough)';
                'K:\Output\(ID2237_R5_7Story_v.03a)_(AllVar)_(0.00)_(clough)';
                };

storyDriftLIST = [0.00, 0.04, 0.02, 0.01]; %, 0.533, 0.08]; % (values in fraction). 0.00 indicates sidesway collapse (dynamic instability)
				
% GM suite for 3040, 3042, 3044, 3045, and 3047 respectively.
eqNumberLIST_forProcessing_SetC = [120111, 120112, 120121, 120122,	120411, 120412,	120521, 120522,	120611, 120612,	120621, 120622,	120711, 120712,	120721, 120722,	120811, 120812,	120821, 120822,	120911, 120912,	120921, 120922,	121011, 121012,	121021, 121022,	121111, 121112,	121211, 121212,	121221, 121222,	121321, 121322,	121411, 121412,	121421, 121422,	121511, 121512,	121711, 121712];
eqLIST_LIST = eqNumberLIST_forProcessing_SetC;

for storyDriftIndex = 1:length(storyDriftLIST)
    currentStoryDrift = storyDriftLIST(storyDriftIndex);

    cd(baseFolder); % now we are in the original directory
%% 2a. extract the old period and values of spectral acceleration corr. to story drift ratio as chosen above
    for j = 1:length(outpFolderLIST)
        if length(outpFolderLIST) ~= length(bldgIdLIST); error('Number of building IDs does not match the number of output folders'); end
        if mod(j-1, 5) == 0; fprintf('For (%i/%i) drift ratio value, executing (%i/%i) building...\n', storyDriftIndex, length(storyDriftLIST), j, length(outpFolderLIST)); end
        
        currBldgID = bldgIdLIST(1, j);
        
        eqNumberLIST = eqLIST_LIST; % eqNumberLIST = eqLIST_LIST(floor((j+1)/2), :);

%         matFileToLoad = sprintf('DATA_collapse_CollapseSaAndStats_GMSetMum20_%i_SaGeoMean.mat', floor(bldgIdLIST(j)/10));
        matFileToLoad = sprintf('DATA_collapse_CollapseSaAndStats_%s_SaGeoMean.mat', 'GMSetC');

        [T_old, saT_oldAllComp] = prak_util_extractFragDataPoints_v02(outpFolderLIST{j}, eqNumberLIST, currentStoryDrift, matFileToLoad);

%% 2b. depending on the intensity measure type, find ratio of scaling from old IM value to new value for each earthquake (NOT NEEDED in case of PGA)
% (6-28-19, PSB) extract fragility with PGA as Intensity Measure
        for eqIndex = 1:length(eqNumberLIST)
            eqNumber = eqNumberLIST(eqIndex);
            T_new1 = T_old;
            ratioOfSaTnewToSaTold1 = prak_util_ratioOfSaTnewToSaTold(eqNumber, T_old, T_new1); % for PGA (modified the function for considering PGA)
            currentRatToScale = ratioOfSaTnewToSaTold1;
            saT_newAllComp(eqIndex) = currentRatToScale * saT_oldAllComp(eqIndex);
            IM_newAllComp(eqIndex) = saT_newAllComp(eqIndex); % (6-21-19, PSB) added this to extract the fragility for PGA
        end
        indFragDataAllComp{currBldgID, storyDriftIndex} = IM_newAllComp;
            
%% 2c. combine the new intensity measure values for different ground motions to find the fragility function parameters
    IM_newCtrlComp = zeros(1, length(eqNumberLIST)/2);

        for gmIndex = 1:length(eqNumberLIST)/2
            saT_newCompOne = IM_newAllComp(gmIndex * 2 - 1);
            saT_newCompTwo = IM_newAllComp(gmIndex * 2);
            IM_newCtrlComp(gmIndex) = min(saT_newCompOne, saT_newCompTwo);
        end
        indFragDataCtrlComp{currBldgID, storyDriftIndex} = IM_newCtrlComp;

        % Do collapse statistics - for all components
        meanCollapseSaTOneAllComp(j) = mean(IM_newAllComp);
        medianCollapseSaTOneAllComp(j) = (median(IM_newAllComp));
        meanLnCollapseSaTOneAllComp(j) = mean(log(IM_newAllComp));
        stDevCollapseSaTOneAllComp(j) = std(IM_newAllComp);
        stDevLnCollapseSaTOneAllComp(j) = std(log(IM_newAllComp));
        minColLevelSaAll(j) = min(IM_newAllComp);
        maxColLevelSaAll(j) = max(IM_newAllComp);


        % Do collapse statistics - for controlling components
        meanCollapseSaTOneControlComp(j) = mean(IM_newCtrlComp);
        medianCollapseSaTOneControlComp(j) = (median(IM_newCtrlComp));
        meanLnCollapseSaTOneControlComp(j) = mean(log(IM_newCtrlComp));
        stDevCollapseSaTOneControlComp(j) = std(IM_newCtrlComp);
        stDevLnCollapseSaTOneControlComp(j) = std(log(IM_newCtrlComp));
        minColLevelSaCtrl(j) = min(IM_newCtrlComp);
        maxColLevelSaCtrl(j) = max(IM_newCtrlComp);
        if storyDriftIndex == 1 && j == 1 % add building ID and time P only once
            T = table(bldgIdLIST');
            T.Properties.VariableNames{1} = 'bldg_ID';
        end
    end
	%               fragParamMu = exp(meanLnCollapseSaTOneControlComp)';
	%               fragParamBetaRTR = stDevLnCollapseSaTOneControlComp';

	  fragParamMu_ALL = exp(meanLnCollapseSaTOneAllComp);
	  fragParamBetaRTR_ALL = stDevLnCollapseSaTOneAllComp;		
      T(:, 8*storyDriftIndex-6:8*storyDriftIndex-5) = table(fragParamMu_ALL', fragParamBetaRTR_ALL');
      T(:, 8*storyDriftIndex-4:8*storyDriftIndex-3) = table(minColLevelSaAll', maxColLevelSaAll');
      T.Properties.VariableNames{8*storyDriftIndex-6} = sprintf('mu_%i_ALL', round(currentStoryDrift*100));
      T.Properties.VariableNames{8*storyDriftIndex-5} = sprintf('betaRTR_%i_ALL', round(currentStoryDrift*100));
      T.Properties.VariableNames{8*storyDriftIndex-4} = sprintf('minSa_%i_ALL', round(currentStoryDrift*100));
      T.Properties.VariableNames{8*storyDriftIndex-3} = sprintf('maxSa_%i_ALL', round(currentStoryDrift*100));

      fragParamMu_CTRL = exp(meanLnCollapseSaTOneControlComp);
	  fragParamBetaRTR_CTRL = stDevLnCollapseSaTOneControlComp;		
      T(:, 8*storyDriftIndex-2:8*storyDriftIndex-1) = table(fragParamMu_CTRL', fragParamBetaRTR_CTRL');
      T(:, 8*storyDriftIndex-0:8*storyDriftIndex+1) = table(minColLevelSaCtrl', maxColLevelSaCtrl');
      T.Properties.VariableNames{8*storyDriftIndex-2} = sprintf('mu_%i_CTRL', round(currentStoryDrift*100));
      T.Properties.VariableNames{8*storyDriftIndex-1} = sprintf('betaRTR_%i_CTRL', round(currentStoryDrift*100));
      T.Properties.VariableNames{8*storyDriftIndex-0} = sprintf('minSa_%i_CTRL', round(currentStoryDrift*100));
      T.Properties.VariableNames{8*storyDriftIndex+1} = sprintf('maxSa_%i_CTRL', round(currentStoryDrift*100));

      %       format long
end
    
        disp(T);
        clearvars -except T baseFolder indFragDataAllComp indFragDataCtrlComp bldgIdLIST eqNumberLIST storyDriftLIST
        
        fileNameToSave = 'indFragDataThreeDS_SaTa';
        cd H:\DistributionGoodnessFit
        save(fileNameToSave, 'indFragDataAllComp', 'indFragDataCtrlComp', 'T', 'bldgIdLIST', 'eqNumberLIST', 'storyDriftLIST');
        fprintf('Data file saved in: %s\n', pwd);
    
    case '21f.extractFragility_PGA_MultiRTSDPaper_CS' % IM = PGA for multi-objective RTSD framework paper using GM suite matching with CS
%%
bldgIdLIST = {'2211v03_sca2',	'2211v03_sca4',	'2213v04_sca2',	'2213v04_sca4',	'2215v03_sca2',	'2215v03_sca4',	...
              '2219v03_sca2',	'2219v03_sca4',	'2221v06_sca2',	'2221v06_sca4',	'2223v03_sca2',	'2223v03_sca4'};
          
outpFolderLIST = {
            'I:\PrakRuns_I\Output\(ID2211_R5_2Story_v.03_CS_Del22_Sca2)_(AllVar)_(0.00)_(clough)';
            'I:\PrakRuns_I\Output\(ID2211_R5_2Story_v.03_CS_Del22_Sca4)_(AllVar)_(0.00)_(clough)';
            'I:\PrakRuns_I\Output\(ID2213_R5_4Story_v.04_CS_Del22_Sca2)_(AllVar)_(0.00)_(clough)';
            'I:\PrakRuns_I\Output\(ID2213_R5_4Story_v.04_CS_Del22_Sca4)_(AllVar)_(0.00)_(clough)';
            'I:\PrakRuns_I\Output\(ID2215_R5_7Story_v.03_CS_Del22_Sca2)_(AllVar)_(0.00)_(clough)';
            'I:\PrakRuns_I\Output\(ID2215_R5_7Story_v.03_CS_Del22_Sca4)_(AllVar)_(0.00)_(clough)';
            'I:\PrakRuns_I\Output\(ID2219_R5_2Story_v.03_CS_Guw22_Sca2)_(AllVar)_(0.00)_(clough)';
            'I:\PrakRuns_I\Output\(ID2219_R5_2Story_v.03_CS_Guw22_Sca4)_(AllVar)_(0.00)_(clough)';
            'I:\PrakRuns_I\Output\(ID2221_R5_4Story_v.06_CS_Guw22_Sca2)_(AllVar)_(0.00)_(clough)';
            'I:\PrakRuns_I\Output\(ID2221_R5_4Story_v.06_CS_Guw22_Sca4)_(AllVar)_(0.00)_(clough)';
            'I:\PrakRuns_I\Output\(ID2223_R5_7Story_v.03_CS_Guw22_Sca2)_(AllVar)_(0.00)_(clough)';
            'I:\PrakRuns_I\Output\(ID2223_R5_7Story_v.03_CS_Guw22_Sca4)_(AllVar)_(0.00)_(clough)';
                };

storyDriftLIST = [0.00, 0.04, 0.02, 0.01]; %, 0.533, 0.08]; % (values in fraction). 0.00 indicates sidesway collapse (dynamic instability)
				
% GM suite for 3040, 3042, 3044, 3045, and 3047 respectively.
eqNumberLIST_forProcessing_SetC = [120111, 120112, 120121, 120122,	120411, 120412,	120521, 120522,	120611, 120612,	120621, 120622,	120711, 120712,	120721, 120722,	120811, 120812,	120821, 120822,	120911, 120912,	120921, 120922,	121011, 121012,	121021, 121022,	121111, 121112,	121211, 121212,	121221, 121222,	121321, 121322,	121411, 121412,	121421, 121422,	121511, 121512,	121711, 121712];

eqNumberLIST_forProcessing_CS22_Mum_Guw = [
        6000311	6000312	6001601	6001602	6001831	6001832	6002121	6002122	6002851	6002852	6003411	6003412	6003521	6003522	6004081	6004082	6004091	6004092	6004571	6004572	6004581	6004582	6004611	6004612	6006331	6006332	6006921	6006922	6007861	6007862	6009521	6009522	6009681	6009682	6009871	6009872	6011351	6011352	6014361	6014362	6023951	6023952	6026271	6026272; ...
        6000341	6000342	6001831	6001832	6003141	6003142	6004091	6004092	6004191	6004192	6004991	6004992	6005301	6005302	6006391	6006392	6007691	6007692	6009081	6009082	6009701	6009702	6009711	6009712	6009871	6009872	6010121	6010122	6010301	6010302	6012571	6012572	6016111	6016112	6017361	6017362	6023951	6023952	6029501	6029502	6032061	6032062	6032861	6032862; ...
        6002301	6002302	6002501	6002502	6003391	6003392	6005481	6005482	6007201	6007202	6007531	6007532	6008321	6008322	6008361	6008362	6008501	6008502	6008731	6008732	6009311	6009312	6009701	6009702	6009891	6009892	6010781	6010782	6011581	6011582	6012921	6012922	6013161	6013162	6013611	6013612	6015321	6015322	6026181	6026182	6026611	6026612	6032701	6032702; ...
        6001601	6001602	6003121	6003122	6003391	6003392	6003411	6003412	6005501	6005502	6006341	6006342	6007851	6007852	6009311	6009312	6009601	6009602	6009921	6009922	6010081	6010082	6011081	6011082	6013381	6013382	6014391	6014392	6014571	6014572	6014971	6014972	6016811	6016812	6017761	6017762	6021111	6021112	6024531	6024532	6032671	6032672	6033991	6033992; ...
        6001581	6001582	6003001	6003002	6005711	6005712	6007281	6007282	6007371	6007372	6007571	6007572	6008841	6008842	6009491	6009492	6009881	6009882	6011111	6011112	6011201	6011202	6011821	6011822	6011931	6011932	6013091	6013092	6013441	6013442	6014181	6014182	6014751	6014752	6015381	6015382	6016281	6016282	6024571	6024572	6025091	6025092	6027341	6027342; ...
        6000361	6000362	6000961	6000962	6005761	6005762	6007261	6007262	6007371	6007372	6008061	6008062	6008611	6008612	6008741	6008742	6010871	6010872	6011191	6011192	6011201	6011202	6012261	6012262	6012661	6012662	6013441	6013442	6014131	6014132	6015811	6015812	6016281	6016282	6024781	6024782	6027111	6027112	6027391	6027392	6027501	6027502	6032601	6032602; ...
        6000961	6000962	6004071	6004072	6006391	6006392	6007271	6007272	6007281	6007282	6007441	6007442	6007731	6007732	6008251	6008252	6008791	6008792	6009021	6009022	6009521	6009522	6009591	6009592	6009871	6009872	6010041	6010042	6010501	6010502	6010771	6010772	6010871	6010872	6012381	6012382	6015461	6015462	6017621	6017622	6027391	6027392	6034741	6034742; ...
        6000311	6000312	6000791	6000792	6000881	6000882	6001581	6001582	6001601	6001602	6002801	6002802	6003351	6003352	6003601	6003602	6004101	6004102	6004181	6004182	6006371	6006372	6007731	6007732	6007991	6007992	6008791	6008792	6009901	6009902	6009931	6009932	6011351	6011352	6014891	6014892	6015201	6015202	6032691	6032692	6034741	6034742	6035041	6035042; ...
        6000061	6000062	6000951	6000952	6000961	6000962	6001431	6001432	6001501	6001502	6002651	6002652	6003591	6003592	6004951	6004952	6005291	6005292	6005641	6005642	6007271	6007272	6007521	6007522	6007661	6007662	6008081	6008082	6010041	6010042	6010501	6010502	6011201	6011202	6011661	6011662	6012921	6012922	6014891	6014892	6014921	6014922	6027521	6027522; ...
        6001641	6001642	6003601	6003602	6005811	6005812	6005871	6005872	6006451	6006452	6007441	6007442	6007541	6007542	6007651	6007652	6009521	6009522	6009701	6009702	6009891	6009892	6009901	6009902	6010041	6010042	6010391	6010392	6011071	6011072	6011541	6011542	6012471	6012472	6014711	6014712	6015131	6015132	6018351	6018352	6026551	6026552	6031051	6031052; ...
        6000771	6000772	6001601	6001602	6001801	6001802	6004951	6004952	6005291	6005292	6007531	6007532	6008061	6008062	6010421	6010422	6010441	6010442	6010541	6010542	6010631	6010632	6010861	6010862	6010871	6010872	6011011	6011012	6012621	6012622	6014771	6014772	6015111	6015112	6015211	6015212	6017871	6017872	6017921	6017922	6032751	6032752	6033171	6033172; ...
        6000301	6000302	6000961	6000962	6001601	6001602	6003411	6003412	6003591	6003592	6005741	6005742	6005841	6005842	6007251	6007252	6007961	6007962	6008621	6008622	6009001	6009002	6009311	6009312	6010871	6010872	6011061	6011062	6012251	6012252	6013271	6013272	6014891	6014892	6015401	6015402	6016021	6016022	6026521	6026522	6033021	6033022	6034961	6034962; ...
        ];
GMsuiteNameLIST = {'GMSetDel22_2211_Sca2', 'GMSetDel22_2211_Sca4', 'GMSetDel22_2213_Sca2', 'GMSetDel22_2213_Sca4', 'GMSetDel22_2215_Sca2', 'GMSetDel22_2215_Sca4', ...
                   'GMSetGuw22_2219_Sca2', 'GMSetGuw22_2219_Sca4', 'GMSetGuw22_2221_Sca2', 'GMSetGuw22_2221_Sca4', 'GMSetGuw22_2223_Sca2', 'GMSetGuw22_2223_Sca4'};
    
eqLIST_LIST = eqNumberLIST_forProcessing_CS22_Mum_Guw;

for storyDriftIndex = 1:length(storyDriftLIST)
    currentStoryDrift = storyDriftLIST(storyDriftIndex);

    cd(baseFolder); % now we are in the original directory
%% 2a. extract the old period and values of spectral acceleration corr. to story drift ratio as chosen above
    for j = 1:length(outpFolderLIST)
        if length(outpFolderLIST) ~= size(bldgIdLIST, 2); error('Number of building IDs does not match the number of output folders'); end
        if mod(j-1, 5) == 0; fprintf('For (%i/%i) drift ratio value, executing (%i/%i) building...\n', storyDriftIndex, length(storyDriftLIST), j, length(outpFolderLIST)); end
        
        currBldgID = bldgIdLIST{1, j};
        
%         eqNumberLIST = eqLIST_LIST; % eqNumberLIST = eqLIST_LIST(floor((j+1)/2), :);
        eqNumberLIST = eqLIST_LIST(j, :);

%         matFileToLoad = sprintf('DATA_collapse_CollapseSaAndStats_GMSetMum20_%i_SaGeoMean.mat', floor(bldgIdLIST(j)/10));
%         matFileToLoad = sprintf('DATA_collapse_CollapseSaAndStats_%s_SaGeoMean.mat', 'GMSetC');
        matFileToLoad = sprintf('DATA_collapse_CollapseSaAndStats_%s_SaGeoMean', GMsuiteNameLIST{1, j});

        [T_old, saT_oldAllComp] = prak_util_extractFragDataPoints_v02(outpFolderLIST{j}, eqNumberLIST, currentStoryDrift, matFileToLoad);

%% 2b. depending on the intensity measure type, find ratio of scaling from old IM value to new value for each earthquake (NOT NEEDED in case of PGA)
% (6-28-19, PSB) extract fragility with PGA as Intensity Measure
        for eqIndex = 1:length(eqNumberLIST)
            eqNumber = eqNumberLIST(eqIndex);
            T_new1 = 0.00;
            ratioOfSaTnewToSaTold1 = prak_util_ratioOfSaTnewToSaTold(eqNumber, T_old, T_new1); % for PGA (modified the function for considering PGA)
            currentRatToScale = ratioOfSaTnewToSaTold1;
            saT_newAllComp(eqIndex) = currentRatToScale * saT_oldAllComp(eqIndex);
            IM_newAllComp(eqIndex) = saT_newAllComp(eqIndex); % (6-21-19, PSB) added this to extract the fragility for PGA
        end
        indFragDataAllComp{j, storyDriftIndex} = IM_newAllComp;
            
%% 2c. combine the new intensity measure values for different ground motions to find the fragility function parameters
    IM_newCtrlComp = zeros(1, length(eqNumberLIST)/2);

        for gmIndex = 1:length(eqNumberLIST)/2
            saT_newCompOne = IM_newAllComp(gmIndex * 2 - 1);
            saT_newCompTwo = IM_newAllComp(gmIndex * 2);
            IM_newCtrlComp(gmIndex) = min(saT_newCompOne, saT_newCompTwo);
        end
        indFragDataCtrlComp{j, storyDriftIndex} = IM_newCtrlComp;

        % Do collapse statistics - for all components
        meanCollapseSaTOneAllComp(j) = mean(IM_newAllComp);
        medianCollapseSaTOneAllComp(j) = (median(IM_newAllComp));
        meanLnCollapseSaTOneAllComp(j) = mean(log(IM_newAllComp));
        stDevCollapseSaTOneAllComp(j) = std(IM_newAllComp);
        stDevLnCollapseSaTOneAllComp(j) = std(log(IM_newAllComp));
        minColLevelSaAll(j) = min(IM_newAllComp);
        maxColLevelSaAll(j) = max(IM_newAllComp);


        % Do collapse statistics - for controlling components
        meanCollapseSaTOneControlComp(j) = mean(IM_newCtrlComp);
        medianCollapseSaTOneControlComp(j) = (median(IM_newCtrlComp));
        meanLnCollapseSaTOneControlComp(j) = mean(log(IM_newCtrlComp));
        stDevCollapseSaTOneControlComp(j) = std(IM_newCtrlComp);
        stDevLnCollapseSaTOneControlComp(j) = std(log(IM_newCtrlComp));
        minColLevelSaCtrl(j) = min(IM_newCtrlComp);
        maxColLevelSaCtrl(j) = max(IM_newCtrlComp);
        if storyDriftIndex == 1 && j == 1 % add building ID and time P only once
            T = table(bldgIdLIST');
            T.Properties.VariableNames{1} = 'Bldg_ID';
        end
    end
	%               fragParamMu = exp(meanLnCollapseSaTOneControlComp)';
	%               fragParamBetaRTR = stDevLnCollapseSaTOneControlComp';

	  fragParamMu_ALL = exp(meanLnCollapseSaTOneAllComp);
	  fragParamBetaRTR_ALL = stDevLnCollapseSaTOneAllComp;		
      T(:, 8*storyDriftIndex-6:8*storyDriftIndex-5) = table(fragParamMu_ALL', fragParamBetaRTR_ALL');
      T(:, 8*storyDriftIndex-4:8*storyDriftIndex-3) = table(minColLevelSaAll', maxColLevelSaAll');
      T.Properties.VariableNames{8*storyDriftIndex-6} = sprintf('mu_%i_ALL', round(currentStoryDrift*100));
      T.Properties.VariableNames{8*storyDriftIndex-5} = sprintf('betaRTR_%i_ALL', round(currentStoryDrift*100));
      T.Properties.VariableNames{8*storyDriftIndex-4} = sprintf('minSa_%i_ALL', round(currentStoryDrift*100));
      T.Properties.VariableNames{8*storyDriftIndex-3} = sprintf('maxSa_%i_ALL', round(currentStoryDrift*100));

      fragParamMu_CTRL = exp(meanLnCollapseSaTOneControlComp);
	  fragParamBetaRTR_CTRL = stDevLnCollapseSaTOneControlComp;		
      T(:, 8*storyDriftIndex-2:8*storyDriftIndex-1) = table(fragParamMu_CTRL', fragParamBetaRTR_CTRL');
      T(:, 8*storyDriftIndex-0:8*storyDriftIndex+1) = table(minColLevelSaCtrl', maxColLevelSaCtrl');
      T.Properties.VariableNames{8*storyDriftIndex-2} = sprintf('mu_%i_CTRL', round(currentStoryDrift*100));
      T.Properties.VariableNames{8*storyDriftIndex-1} = sprintf('betaRTR_%i_CTRL', round(currentStoryDrift*100));
      T.Properties.VariableNames{8*storyDriftIndex-0} = sprintf('minSa_%i_CTRL', round(currentStoryDrift*100));
      T.Properties.VariableNames{8*storyDriftIndex+1} = sprintf('maxSa_%i_CTRL', round(currentStoryDrift*100));

      %       format long
end
    
        disp(T);
        clearvars -except T baseFolder indFragDataAllComp indFragDataCtrlComp bldgIdLIST eqNumberLIST storyDriftLIST
        
        fileNameToSave = 'fragDataCS22_PGA';
        cd H:\UniformRiskMap\Results
        save(fileNameToSave, 'indFragDataAllComp', 'indFragDataCtrlComp', 'T', 'bldgIdLIST', 'eqNumberLIST', 'storyDriftLIST');
        fprintf('Data file saved in: %s\n', pwd);
        
    case '21g.extractFragility_SaTa_MultiRTSDPaper_CS' % IM = same as 21f; with SaTa as IM 
%%
bldgIdLIST = {'2211v03_sca2',	'2211v03_sca4',	'2213v04_sca2',	'2213v04_sca4',	'2215v03_sca2',	'2215v03_sca4',	...
              '2219v03_sca2',	'2219v03_sca4',	'2221v06_sca2',	'2221v06_sca4',	'2223v03_sca2',	'2223v03_sca4'};
          
outpFolderLIST = {
            'I:\PrakRuns_I\Output\(ID2211_R5_2Story_v.03_CS_Del22_Sca2)_(AllVar)_(0.00)_(clough)';
            'I:\PrakRuns_I\Output\(ID2211_R5_2Story_v.03_CS_Del22_Sca4)_(AllVar)_(0.00)_(clough)';
            'I:\PrakRuns_I\Output\(ID2213_R5_4Story_v.04_CS_Del22_Sca2)_(AllVar)_(0.00)_(clough)';
            'I:\PrakRuns_I\Output\(ID2213_R5_4Story_v.04_CS_Del22_Sca4)_(AllVar)_(0.00)_(clough)';
            'I:\PrakRuns_I\Output\(ID2215_R5_7Story_v.03_CS_Del22_Sca2)_(AllVar)_(0.00)_(clough)';
            'I:\PrakRuns_I\Output\(ID2215_R5_7Story_v.03_CS_Del22_Sca4)_(AllVar)_(0.00)_(clough)';
            'I:\PrakRuns_I\Output\(ID2219_R5_2Story_v.03_CS_Guw22_Sca2)_(AllVar)_(0.00)_(clough)';
            'I:\PrakRuns_I\Output\(ID2219_R5_2Story_v.03_CS_Guw22_Sca4)_(AllVar)_(0.00)_(clough)';
            'I:\PrakRuns_I\Output\(ID2221_R5_4Story_v.06_CS_Guw22_Sca2)_(AllVar)_(0.00)_(clough)';
            'I:\PrakRuns_I\Output\(ID2221_R5_4Story_v.06_CS_Guw22_Sca4)_(AllVar)_(0.00)_(clough)';
            'I:\PrakRuns_I\Output\(ID2223_R5_7Story_v.03_CS_Guw22_Sca2)_(AllVar)_(0.00)_(clough)';
            'I:\PrakRuns_I\Output\(ID2223_R5_7Story_v.03_CS_Guw22_Sca4)_(AllVar)_(0.00)_(clough)';
                };

storyDriftLIST = [0.00, 0.04, 0.02, 0.01]; %, 0.533, 0.08]; % (values in fraction). 0.00 indicates sidesway collapse (dynamic instability)
				
% GM suite for 3040, 3042, 3044, 3045, and 3047 respectively.
eqNumberLIST_forProcessing_SetC = [120111, 120112, 120121, 120122,	120411, 120412,	120521, 120522,	120611, 120612,	120621, 120622,	120711, 120712,	120721, 120722,	120811, 120812,	120821, 120822,	120911, 120912,	120921, 120922,	121011, 121012,	121021, 121022,	121111, 121112,	121211, 121212,	121221, 121222,	121321, 121322,	121411, 121412,	121421, 121422,	121511, 121512,	121711, 121712];

eqNumberLIST_forProcessing_CS22_Mum_Guw = [
        6000311	6000312	6001601	6001602	6001831	6001832	6002121	6002122	6002851	6002852	6003411	6003412	6003521	6003522	6004081	6004082	6004091	6004092	6004571	6004572	6004581	6004582	6004611	6004612	6006331	6006332	6006921	6006922	6007861	6007862	6009521	6009522	6009681	6009682	6009871	6009872	6011351	6011352	6014361	6014362	6023951	6023952	6026271	6026272; ...
        6000341	6000342	6001831	6001832	6003141	6003142	6004091	6004092	6004191	6004192	6004991	6004992	6005301	6005302	6006391	6006392	6007691	6007692	6009081	6009082	6009701	6009702	6009711	6009712	6009871	6009872	6010121	6010122	6010301	6010302	6012571	6012572	6016111	6016112	6017361	6017362	6023951	6023952	6029501	6029502	6032061	6032062	6032861	6032862; ...
        6002301	6002302	6002501	6002502	6003391	6003392	6005481	6005482	6007201	6007202	6007531	6007532	6008321	6008322	6008361	6008362	6008501	6008502	6008731	6008732	6009311	6009312	6009701	6009702	6009891	6009892	6010781	6010782	6011581	6011582	6012921	6012922	6013161	6013162	6013611	6013612	6015321	6015322	6026181	6026182	6026611	6026612	6032701	6032702; ...
        6001601	6001602	6003121	6003122	6003391	6003392	6003411	6003412	6005501	6005502	6006341	6006342	6007851	6007852	6009311	6009312	6009601	6009602	6009921	6009922	6010081	6010082	6011081	6011082	6013381	6013382	6014391	6014392	6014571	6014572	6014971	6014972	6016811	6016812	6017761	6017762	6021111	6021112	6024531	6024532	6032671	6032672	6033991	6033992; ...
        6001581	6001582	6003001	6003002	6005711	6005712	6007281	6007282	6007371	6007372	6007571	6007572	6008841	6008842	6009491	6009492	6009881	6009882	6011111	6011112	6011201	6011202	6011821	6011822	6011931	6011932	6013091	6013092	6013441	6013442	6014181	6014182	6014751	6014752	6015381	6015382	6016281	6016282	6024571	6024572	6025091	6025092	6027341	6027342; ...
        6000361	6000362	6000961	6000962	6005761	6005762	6007261	6007262	6007371	6007372	6008061	6008062	6008611	6008612	6008741	6008742	6010871	6010872	6011191	6011192	6011201	6011202	6012261	6012262	6012661	6012662	6013441	6013442	6014131	6014132	6015811	6015812	6016281	6016282	6024781	6024782	6027111	6027112	6027391	6027392	6027501	6027502	6032601	6032602; ...
        6000961	6000962	6004071	6004072	6006391	6006392	6007271	6007272	6007281	6007282	6007441	6007442	6007731	6007732	6008251	6008252	6008791	6008792	6009021	6009022	6009521	6009522	6009591	6009592	6009871	6009872	6010041	6010042	6010501	6010502	6010771	6010772	6010871	6010872	6012381	6012382	6015461	6015462	6017621	6017622	6027391	6027392	6034741	6034742; ...
        6000311	6000312	6000791	6000792	6000881	6000882	6001581	6001582	6001601	6001602	6002801	6002802	6003351	6003352	6003601	6003602	6004101	6004102	6004181	6004182	6006371	6006372	6007731	6007732	6007991	6007992	6008791	6008792	6009901	6009902	6009931	6009932	6011351	6011352	6014891	6014892	6015201	6015202	6032691	6032692	6034741	6034742	6035041	6035042; ...
        6000061	6000062	6000951	6000952	6000961	6000962	6001431	6001432	6001501	6001502	6002651	6002652	6003591	6003592	6004951	6004952	6005291	6005292	6005641	6005642	6007271	6007272	6007521	6007522	6007661	6007662	6008081	6008082	6010041	6010042	6010501	6010502	6011201	6011202	6011661	6011662	6012921	6012922	6014891	6014892	6014921	6014922	6027521	6027522; ...
        6001641	6001642	6003601	6003602	6005811	6005812	6005871	6005872	6006451	6006452	6007441	6007442	6007541	6007542	6007651	6007652	6009521	6009522	6009701	6009702	6009891	6009892	6009901	6009902	6010041	6010042	6010391	6010392	6011071	6011072	6011541	6011542	6012471	6012472	6014711	6014712	6015131	6015132	6018351	6018352	6026551	6026552	6031051	6031052; ...
        6000771	6000772	6001601	6001602	6001801	6001802	6004951	6004952	6005291	6005292	6007531	6007532	6008061	6008062	6010421	6010422	6010441	6010442	6010541	6010542	6010631	6010632	6010861	6010862	6010871	6010872	6011011	6011012	6012621	6012622	6014771	6014772	6015111	6015112	6015211	6015212	6017871	6017872	6017921	6017922	6032751	6032752	6033171	6033172; ...
        6000301	6000302	6000961	6000962	6001601	6001602	6003411	6003412	6003591	6003592	6005741	6005742	6005841	6005842	6007251	6007252	6007961	6007962	6008621	6008622	6009001	6009002	6009311	6009312	6010871	6010872	6011061	6011062	6012251	6012252	6013271	6013272	6014891	6014892	6015401	6015402	6016021	6016022	6026521	6026522	6033021	6033022	6034961	6034962; ...
        ];
GMsuiteNameLIST = {'GMSetDel22_2211_Sca2', 'GMSetDel22_2211_Sca4', 'GMSetDel22_2213_Sca2', 'GMSetDel22_2213_Sca4', 'GMSetDel22_2215_Sca2', 'GMSetDel22_2215_Sca4', ...
                   'GMSetGuw22_2219_Sca2', 'GMSetGuw22_2219_Sca4', 'GMSetGuw22_2221_Sca2', 'GMSetGuw22_2221_Sca4', 'GMSetGuw22_2223_Sca2', 'GMSetGuw22_2223_Sca4'};
    
eqLIST_LIST = eqNumberLIST_forProcessing_CS22_Mum_Guw;

for storyDriftIndex = 1:length(storyDriftLIST)
    currentStoryDrift = storyDriftLIST(storyDriftIndex);

    cd(baseFolder); % now we are in the original directory
%% 2a. extract the old period and values of spectral acceleration corr. to story drift ratio as chosen above
    for j = 1:length(outpFolderLIST)
        if length(outpFolderLIST) ~= size(bldgIdLIST, 2); error('Number of building IDs does not match the number of output folders'); end
        if mod(j-1, 5) == 0; fprintf('For (%i/%i) drift ratio value, executing (%i/%i) building...\n', storyDriftIndex, length(storyDriftLIST), j, length(outpFolderLIST)); end
        
        currBldgID = bldgIdLIST{1, j};
        
%         eqNumberLIST = eqLIST_LIST; % eqNumberLIST = eqLIST_LIST(floor((j+1)/2), :);
        eqNumberLIST = eqLIST_LIST(j, :);

%         matFileToLoad = sprintf('DATA_collapse_CollapseSaAndStats_GMSetMum20_%i_SaGeoMean.mat', floor(bldgIdLIST(j)/10));
%         matFileToLoad = sprintf('DATA_collapse_CollapseSaAndStats_%s_SaGeoMean.mat', 'GMSetC');
        matFileToLoad = sprintf('DATA_collapse_CollapseSaAndStats_%s_SaGeoMean', GMsuiteNameLIST{1, j});

        [T_old, saT_oldAllComp] = prak_util_extractFragDataPoints_v02(outpFolderLIST{j}, eqNumberLIST, currentStoryDrift, matFileToLoad);

%% 2b. depending on the intensity measure type, find ratio of scaling from old IM value to new value for each earthquake (NOT NEEDED in case of PGA)
% (6-28-19, PSB) extract fragility with PGA as Intensity Measure
        for eqIndex = 1:length(eqNumberLIST)
            eqNumber = eqNumberLIST(eqIndex);
            T_new1 = T_old;
            ratioOfSaTnewToSaTold1 = prak_util_ratioOfSaTnewToSaTold(eqNumber, T_old, T_new1); % for PGA (modified the function for considering PGA)
            currentRatToScale = ratioOfSaTnewToSaTold1;
            saT_newAllComp(eqIndex) = currentRatToScale * saT_oldAllComp(eqIndex);
            IM_newAllComp(eqIndex) = saT_newAllComp(eqIndex); % (6-21-19, PSB) added this to extract the fragility for PGA
        end
        indFragDataAllComp{j, storyDriftIndex} = IM_newAllComp;
            
%% 2c. combine the new intensity measure values for different ground motions to find the fragility function parameters
    IM_newCtrlComp = zeros(1, length(eqNumberLIST)/2);

        for gmIndex = 1:length(eqNumberLIST)/2
            saT_newCompOne = IM_newAllComp(gmIndex * 2 - 1);
            saT_newCompTwo = IM_newAllComp(gmIndex * 2);
            IM_newCtrlComp(gmIndex) = min(saT_newCompOne, saT_newCompTwo);
        end
        indFragDataCtrlComp{j, storyDriftIndex} = IM_newCtrlComp;

        % Do collapse statistics - for all components
        meanCollapseSaTOneAllComp(j) = mean(IM_newAllComp);
        medianCollapseSaTOneAllComp(j) = (median(IM_newAllComp));
        meanLnCollapseSaTOneAllComp(j) = mean(log(IM_newAllComp));
        stDevCollapseSaTOneAllComp(j) = std(IM_newAllComp);
        stDevLnCollapseSaTOneAllComp(j) = std(log(IM_newAllComp));
        minColLevelSaAll(j) = min(IM_newAllComp);
        maxColLevelSaAll(j) = max(IM_newAllComp);


        % Do collapse statistics - for controlling components
        meanCollapseSaTOneControlComp(j) = mean(IM_newCtrlComp);
        medianCollapseSaTOneControlComp(j) = (median(IM_newCtrlComp));
        meanLnCollapseSaTOneControlComp(j) = mean(log(IM_newCtrlComp));
        stDevCollapseSaTOneControlComp(j) = std(IM_newCtrlComp);
        stDevLnCollapseSaTOneControlComp(j) = std(log(IM_newCtrlComp));
        minColLevelSaCtrl(j) = min(IM_newCtrlComp);
        maxColLevelSaCtrl(j) = max(IM_newCtrlComp);
        if storyDriftIndex == 1 && j == 1 % add building ID and time P only once
            T = table(bldgIdLIST');
            T.Properties.VariableNames{1} = 'Bldg_ID';
        end
    end
	%               fragParamMu = exp(meanLnCollapseSaTOneControlComp)';
	%               fragParamBetaRTR = stDevLnCollapseSaTOneControlComp';

	  fragParamMu_ALL = exp(meanLnCollapseSaTOneAllComp);
	  fragParamBetaRTR_ALL = stDevLnCollapseSaTOneAllComp;		
      T(:, 8*storyDriftIndex-6:8*storyDriftIndex-5) = table(fragParamMu_ALL', fragParamBetaRTR_ALL');
      T(:, 8*storyDriftIndex-4:8*storyDriftIndex-3) = table(minColLevelSaAll', maxColLevelSaAll');
      T.Properties.VariableNames{8*storyDriftIndex-6} = sprintf('mu_%i_ALL', round(currentStoryDrift*100));
      T.Properties.VariableNames{8*storyDriftIndex-5} = sprintf('betaRTR_%i_ALL', round(currentStoryDrift*100));
      T.Properties.VariableNames{8*storyDriftIndex-4} = sprintf('minSa_%i_ALL', round(currentStoryDrift*100));
      T.Properties.VariableNames{8*storyDriftIndex-3} = sprintf('maxSa_%i_ALL', round(currentStoryDrift*100));

      fragParamMu_CTRL = exp(meanLnCollapseSaTOneControlComp);
	  fragParamBetaRTR_CTRL = stDevLnCollapseSaTOneControlComp;		
      T(:, 8*storyDriftIndex-2:8*storyDriftIndex-1) = table(fragParamMu_CTRL', fragParamBetaRTR_CTRL');
      T(:, 8*storyDriftIndex-0:8*storyDriftIndex+1) = table(minColLevelSaCtrl', maxColLevelSaCtrl');
      T.Properties.VariableNames{8*storyDriftIndex-2} = sprintf('mu_%i_CTRL', round(currentStoryDrift*100));
      T.Properties.VariableNames{8*storyDriftIndex-1} = sprintf('betaRTR_%i_CTRL', round(currentStoryDrift*100));
      T.Properties.VariableNames{8*storyDriftIndex-0} = sprintf('minSa_%i_CTRL', round(currentStoryDrift*100));
      T.Properties.VariableNames{8*storyDriftIndex+1} = sprintf('maxSa_%i_CTRL', round(currentStoryDrift*100));

      %       format long
end
    
        disp(T);
        clearvars -except T baseFolder indFragDataAllComp indFragDataCtrlComp bldgIdLIST eqNumberLIST storyDriftLIST
        
        fileNameToSave = 'fragDataCS22_SaTa';
        cd H:\UniformRiskMap\Results
        save(fileNameToSave, 'indFragDataAllComp', 'indFragDataCtrlComp', 'T', 'bldgIdLIST', 'eqNumberLIST', 'storyDriftLIST');
        fprintf('Data file saved in: %s\n', pwd);
            
    case '22.findNumOfRepetitionInAList'
%%        
        A = [9	38	40	69	77	78	79	154	172	187	192	210	269	286	288	292	295	300	302	303	312	319	322	354	391	414	425	428	429	431	453	456	468	470	492	510	530	550	570	572	573	575	577	578	584	624	674	720	721	724	735	737	742	782	786	789	800	806	843	854	859	862	882	883	885	897	909	919	921	958	963	968	985	986	1008	1015	1024	1026	1034	1042	1046	1048	1057	1074	1077	1078	1080	1086	1087	1090	1100	1101	1107	1116	1144	1145	1158	1166	1204	1234	1248	1258	1265	1269	1273	1277	1288	1300	1312	1317	1344	1352	1355	1383	1390	1404	1470	1483	1509	1512	1518	1535	1539	1545	1557	1565	1570	1588	1592	1594	1611	1622	1626	1633	1634	1762	1768	1775	1791	1805	1809	1816	1821	1829	1835	1836	1840	2068	2104	2112	2208	2221	2223	2266	2267	2270	2279	2284	2293	2457	2477	2478	2482	2498	2559	2569	2587	2592	2599	2600	2605	2608	2626	2634	2647	2696	2716	2718	2733	2742	2743	2744	2748	2770	2810	2845	2850	2852	2877	2886	2895	2945	2946	2951	2952	2956	2958	2960	2961	2990	2992	2993	2994	3011	3024	3062	3098	3102	3187	3222	3223	3224	3245	3260	3267	3271	3283	3285	3288	3292	3302	3303	3313	3314	3315	3320	3341	3348	3350	3381	3382	3400	3442	3455	3459	3461	3463	3471	3472	3477	3491	3492	3496	3497	3498	3501	3509	3511	3514	3525	3539 ...
            314	575	754	884	1046	1224	1277	1504	1512	1768	1823	1841	2279	2292	2716	2964	3223	3224	3245	3314	3367	3477 ...
            392	802	825	985	1015	1187	1208	1300	1391	1504	1557	1588	2479	2646	2740	2809	2938	2939	2953	2959	2988	3480];

        A = sort(A);
        B = A(2:end) - A(1:end-1);
%         numOfRepetitions = sum(B == 0);
        numOfRepetitions = sum(abs(B - 0) <= 1e-6); % just in case, floating points pop up.
        disp(numOfRepetitions);
        
    case '23.findEqFoldersWithoutMatFiles'
        %%
        baseFolder = pwd;
        
        % eqNumLIST_forProc_SetMum250_2p56= [6338202	6340001	6340002	6344201	6344202	6345501	6345502	6345901	6345902	6346101	6346102	6346301	6346302	6347101	6347102	6347201	6347202	6347701	6347702	6349101	6349102	6349201	6349202	6349601	6349602	6349701	6349702	6349801	6349802	6350101	6350102	6350901	6350902	6351101	6351102	6351401	6351402	6352501	6352502	6353901	6353902	6274401	6274402	6274801	6274802	6277001	6277002	6281001	6281002	6284501	6284502	6285001	6285002	6285201	6285202	6287701	6287702	6288601	6288602	6289501	6289502	6294501	6294502	6294601	6294602	6295101	6295102	6295201	6295202	6295601	6295602	6295801	6295802	6296001	6296002	6296101	6296102	6299001	6299002	6299201	6299202	6299301	6299302	6299401	6299402	6301101	6301102	6302401	6302402	6306201	6306202	6309801	6309802	6310201	6310202	6318701	6318702	6322201	6322202	6322301	6322302	6322401	6322402	6324501	6324502	6326001	6326002	6326701	6326702	6327101	6327102	6328301	6328302	6328501	6328502	6328801	6328802	6329201	6329202	6330201	6330202	6330301	6330302	6331301	6331302	6331401	6331402	6331501	6331502	6332001	6332002	6334101	6334102	6334801	6334802	6335001	6335002	6338101	6338102	6338201];
        eqNumLIST_forProc_SetMum250_2p56= [6306201	6306202	6309801	6309802	6310201	6310202	6318701	6318702	6322201	6322202	6322301	6322302	6322401	6322402	6324501	6324502	6326001	6326002	6326701	6326702	6327101	6327102	6328301	6328302	6328501	6328502	6328801	6328802	6329201	6329202	6330201	6330202	6330301	6330302	6331301	6331302	6331401	6331402	6331501	6331502	6332001	6332002	6334101	6334102	6334801	6334802	6335001	6335002	6338101	6338102	6338201	6338202	6340001	6340002	6344201	6344202	6345501	6345502	6345901	6345902	6346101	6346102	6346301	6346302	6347101	6347102	6347201	6347202	6347701	6347702	6349101	6349102	6349201	6349202	6349601	6349602	6349701	6349702	6349801	6349802	6350101	6350102	6350901	6350902	6351101	6351102	6351401	6351402	6352501	6352502	6353901	6353902];
        
        eqList = eqNumLIST_forProc_SetMum250_2p56;
        
        cd K:\Output\(ID2207_R5_7Story_v.08)_(AllVar)_(0.00)_(clough)\temp
        
        % fileName ='DATA_CollapseResultsForThisSingleEQ.mat';
        fileName ='DATA_collapseIDAPlotDataForThisEQ.mat';
        eqNumWithoutMatFile = [];
        
        for i = 1:length(eqList)
            eqNum = eqList(i);
            eqFolder = sprintf('EQ_%i', eqNum);
            cd(eqFolder);
            
            if ~exist(fileName)
                eqNumWithoutMatFile = [eqNumWithoutMatFile, eqNum];
            end
            cd ..
        end
        
        % cd(baseFolder)
    
    case '24.combineFourFigures'
        %%
        baseFolder = pwd;

        cd 'C:\Users\Prakash\Google Drive\WRITINGS\Paper 1 (RRF)\Figures_p1\R2 figures'
        
%         g(1) = hgload('ASCELoading_NormalizedPushoverBaselineZone4WithLS_and_CP.fig');
%         g(2) = hgload('ASCELoading_NormalizedPushoverBaselineZone5WithLS_and_CP.fig');
%         g(3) = hgload('NormalizedPushoverBaselineZone4WithLS_and_CP.fig');
%         g(4) = hgload('NormalizedPushoverBaselineZone5WithLS_and_CP.fig');
        
        g(1) = hgload('ASCELoading_NormalizedPushoverBaselineZone4WithLS_and_CP_2213a_2221a.fig');
        g(2) = hgload('ASCELoading_NormalizedPushoverBaselineZone5WithLS_and_CP_2213a_2221a.fig');
        g(3) = hgload('NormalizedPushoverBaselineZone4WithLS_and_CP_2213a_2221a.fig');
        g(4) = hgload('NormalizedPushoverBaselineZone5WithLS_and_CP_2213a_2221a.fig');
        
        titleLIST = {'Zone-4 ASCE7 Loading', 'Zone-5 ASCE7 Loading', 'Zone-4 IS1893 Loading', 'Zone-5 IS1893 Loading'};
        exportName = sprintf('CombinedSPO_BaseLineBldgs_ISandASCE_loading_2213a_2221a');
        
%         cd 'C:\Users\Prakash\Google Drive\WRITINGS\Paper 2 (Moderate Seismicity)\P2_WorkingResults\pushover_paper2'
%         
%         g(1) = hgload('Pushover_Num_9991_(ID30401_XZ_R0_4Story_v_02)_(AllVar)_(0_00)_(clough).fig');
%         g(2) = hgload('Pushover_Num_9991_(ID30402_YZ_R0_4Story_v_02)_(AllVar)_(0_00)_(clough).fig');
%         g(3) = hgload('Pushover_Num_9991_(ID30421_XZ_R0_4Story_v_02)_(AllVar)_(0_00)_(clough).fig');
%         g(4) = hgload('Pushover_Num_9991_(ID30422_YZ_R0_4Story_v_02)_(AllVar)_(0_00)_(clough).fig');
%         titleLIST = {'30401', '30402', '30421', '30422'};
%         exportName = sprintf('Pushover_30401_30402_30421_30422_v2');
        
%         g(1) = hgload('Pushover_Num_9991_(ID30441_XZ_R0_4Story_v_02)_(AllVar)_(0_00)_(clough).fig');
%         g(2) = hgload('Pushover_Num_9991_(ID30442_YZ_R0_4Story_v_02)_(AllVar)_(0_00)_(clough).fig');
%         g(3) = hgload('Pushover_Num_9991_(ID30451_XZ_R0_4Story_v_02)_(AllVar)_(0_00)_(clough).fig');
%         g(4) = hgload('Pushover_Num_9991_(ID30452_YZ_R0_4Story_v_02)_(AllVar)_(0_00)_(clough).fig');
%         titleLIST = {'30441', '30442', '30451', '30452'};
%         exportName = sprintf('Pushover_30441_30442_30451_30452_v2');
        
%         g(1) = hgload('Pushover_Num_9991_(ID30401_XZ_R0_4Story_v_02)_(AllVar)_(0_00)_(clough).fig');
%         g(2) = hgload('Pushover_Num_9991_(ID30421_XZ_R0_4Story_v_02)_(AllVar)_(0_00)_(clough).fig');
%         g(3) = hgload('Pushover_Num_9991_(ID30441_XZ_R0_4Story_v_02)_(AllVar)_(0_00)_(clough).fig');
%         g(4) = hgload('Pushover_Num_9991_(ID30451_XZ_R0_4Story_v_02)_(AllVar)_(0_00)_(clough).fig');
%         titleLIST = {'30401', '30421', '30441', '30451'};
%         exportName = sprintf('Pushover_30401_30421_30441_30451_v2');
        
%         g(1) = hgload('Pushover_Num_9991_(ID30402_YZ_R0_4Story_v_02)_(AllVar)_(0_00)_(clough).fig');
%         g(2) = hgload('Pushover_Num_9991_(ID30422_YZ_R0_4Story_v_02)_(AllVar)_(0_00)_(clough).fig');
%         g(3) = hgload('Pushover_Num_9991_(ID30442_YZ_R0_4Story_v_02)_(AllVar)_(0_00)_(clough).fig');
%         g(4) = hgload('Pushover_Num_9991_(ID30452_YZ_R0_4Story_v_02)_(AllVar)_(0_00)_(clough).fig');
%         titleLIST = {'30402', '30422', '30442', '30452'};
%         exportName = sprintf('Pushover_30402_30422_30442_30452_v2');

%         g(1) = hgload('Pushover_Num_9991_(ID30471_XZ_R0_4Story_v_02)_(AllVar)_(0_00)_(clough).fig');
%         g(2) = hgload('Pushover_Num_9991_(ID30472_YZ_R0_4Story_v_02)_(AllVar)_(0_00)_(clough).fig');
%         titleLIST = {'30471', '30472'};
%         exportName = sprintf('Pushover_30471_30472_v2');
%         
        xlabelText = get(gca,'xlabel'); ylabelText = get(gca,'ylabel');
        
        numFigs = size(titleLIST, 2);
        
        % Prepare subplots
        figure
        for i = 1:numFigs
            h(i)=subplot(2,2,i);
            xlabel(xlabelText.String);
            ylabel(ylabelText.String);
            title(['Bldg. ID- ', titleLIST{i}]); grid on;
        end
        
        % Paste figures on the subplots
        for i = 1:numFigs
            copyobj(allchild(get(g(i), 'CurrentAxes')),h(i)); % associated axes
        end
        
        % xlim(h(1),[0 0.03]); ylim(h(1),[0 500]);
        % xlim(h(2),[0 0.025]); ylim(h(2),[0 500]);
        % xlim(h(3),[0 0.05]); ylim(h(3),[0 600]);
        % xlim(h(4),[0 0.05]); ylim(h(4),[0 500]);
        
        for i = 1:numFigs
%             xlim(h(i),[0 0.055]); ylim(h(i),[0, 750]);
            xlim(h(i),[0 0.05]); ylim(h(i),[0, 0.30]);
            close(g(i));
        end
        
       hgsave(exportName); % .fig file for Matlab
       print('-depsc', exportName); % .eps file for Linux (LaTeX)
       print('-dmeta', exportName); % .emf file for Windows (MSWORD)
       print('-dpng', exportName); % .png file for small sized files

        fprintf('Combined figure saved as %s/%s.', pwd, exportName);
        
        cd(baseFolder)
        
    case '24a.combineFourFigures'
        %%
        baseFolder = pwd;

        cd 'C:\Users\Prakash\Google Drive\WRITINGS\Paper 1 (RRF)\Figures_p1_r2\outliers omega0'
        
        g(1) = hgload('PushoverMaxDriftLevel_Num_9991_(ID2451_R5_5Story_v.01)_(AllVar)_(0.00)_(clough).fig');
        g(2) = hgload('PushoverMaxDriftLevel_Num_9991_(ID2453_R5_6Story_v.01)_(AllVar)_(0.00)_(clough).fig');
        g(3) = hgload('PushoverMaxDriftLevel_Num_9991_(ID2437_R5_5Story_v.01)_(AllVar)_(0.00)_(clough).fig');
        g(4) = hgload('PushoverMaxDriftLevel_Num_9991_(ID2229_R5_7Story_v.02)_(AllVar)_(0.00)_(clough).fig');
        
        titleLIST = {'2451', '2453', '2437', '2229'};
        exportName = sprintf('maxDriftRatio');
        
        xlabelText = get(gca,'xlabel'); ylabelText = get(gca,'ylabel');
        
        numFigs = size(titleLIST, 2);
        
        % Prepare subplots
        figure
        for i = 1:numFigs
            h(i)=subplot(2,2,i);
            xlabel(xlabelText.String);
            ylabel(ylabelText.String);
            title(['Bldg. ID- ', titleLIST{i}]); grid on;
        end
        
        % Paste figures on the subplots
        for i = 1:numFigs
            copyobj(allchild(get(g(i), 'CurrentAxes')),h(i)); % associated axes
        end
        
        % xlim(h(1),[0 0.03]); ylim(h(1),[0 500]);
        % xlim(h(2),[0 0.025]); ylim(h(2),[0 500]);
        % xlim(h(3),[0 0.05]); ylim(h(3),[0 600]);
        % xlim(h(4),[0 0.05]); ylim(h(4),[0 500]);
        
        for i = 1:numFigs
%             xlim(h(i),[0 0.055]); ylim(h(i),[0, 750]);
            xlim(h(i),[0 0.10]); ylim(h(i),[1, 8]);
            close(g(i));
        end
        
       hgsave(exportName); % .fig file for Matlab
       print('-depsc', exportName); % .eps file for Linux (LaTeX)
       print('-dmeta', exportName); % .emf file for Windows (MSWORD)
       print('-dpng', exportName); % .png file for small sized files

        fprintf('Combined figure saved as %s/%s.', pwd, exportName);
        
        cd(baseFolder)
        
    case '24b.combineFourFigures'
        %%
        baseFolder = pwd;

        cd 'C:\Users\Prakash\Google Drive\WRITINGS\Paper 1 (RRF)\Figures_p1_r2\outliers omega0'
        
        g(1) = hgload('PushoverMaxDriftLevel_Num_9991_(ID2433_R5_5Story_v.01)_(AllVar)_(0.00)_(clough).fig');
        g(2) = hgload('PushoverMaxDriftLevel_Num_9991_(ID2435_R5_6Story_v.01)_(AllVar)_(0.00)_(clough).fig');
        g(3) = hgload('PushoverMaxDriftLevel_Num_9991_(ID2445_R5_5Story_v.01)_(AllVar)_(0.00)_(clough).fig');
        g(4) = hgload('PushoverMaxDriftLevel_Num_9991_(ID2223_R5_7Story_v.02)_(AllVar)_(0.00)_(clough).fig');
        
        titleLIST = {'2433', '2435', '2445', '2223'};
        exportName = sprintf('maxDriftRatio_2433_2435_2445_2223');
        
        xlabelText = get(gca,'xlabel'); ylabelText = get(gca,'ylabel');
        
        numFigs = size(titleLIST, 2);
        
        % Prepare subplots
        figure
        for i = 1:numFigs
            h(i)=subplot(2,2,i);
            xlabel(xlabelText.String);
            ylabel(ylabelText.String);
            title(['Bldg. ID- ', titleLIST{i}]); grid on;
        end
        
        % Paste figures on the subplots
        for i = 1:numFigs
            copyobj(allchild(get(g(i), 'CurrentAxes')),h(i)); % associated axes
        end
        
        % xlim(h(1),[0 0.03]); ylim(h(1),[0 500]);
        % xlim(h(2),[0 0.025]); ylim(h(2),[0 500]);
        % xlim(h(3),[0 0.05]); ylim(h(3),[0 600]);
        % xlim(h(4),[0 0.05]); ylim(h(4),[0 500]);
        
        for i = 1:numFigs
%             xlim(h(i),[0 0.055]); ylim(h(i),[0, 750]);
            xlim(h(i),[0 0.13]); ylim(h(i),[1, 8]);
            close(g(i));
        end
        
       hgsave(exportName); % .fig file for Matlab
       print('-depsc', exportName); % .eps file for Linux (LaTeX)
       print('-dmeta', exportName); % .emf file for Windows (MSWORD)
       print('-dpng', exportName); % .png file for small sized files

        fprintf('Combined figure saved as %s/%s.', pwd, exportName);
        
        cd(baseFolder)
        
    case '24c.combineSixFigures'
        %%
        baseFolder = pwd;

        cd I:\PrakRuns_I\Output\2437_differentSPO
        
        g(1) = hgload('Pushover_Num_9991_(ID2437_R5_5Story_v_01)_(AllVar)_(0_00)_(clough).fig');
        g(2) = hgload('Pushover_Num_9991_(ID2437_R5_5Story_v_01_2)_(AllVar)_(0_00)_(clough).fig');
        g(3) = hgload('Pushover_Num_9991_(ID2437_R5_5Story_v_01_3)_(AllVar)_(0_00)_(clough).fig');
        g(4) = hgload('Pushover_Num_9991_(ID2437_R5_5Story_v_01_4)_(AllVar)_(0_00)_(clough).fig');
        g(5) = hgload('Pushover_Num_9991_(ID2437_R5_5Story_v_01_5)_(AllVar)_(0_00)_(clough).fig');
        g(6) = hgload('Pushover_Num_9991_(ID2437_R5_5Story_v_01_6)_(AllVar)_(0_00)_(clough).fig');
        
%         g(1) = hgload('PushoverMaxDriftLevel_Num_9991_(ID2437_R5_5Story_v.01)_(AllVar)_(0.00)_(clough).fig');
%         g(2) = hgload('PushoverMaxDriftLevel_Num_9991_(ID2437_R5_5Story_v.01_2)_(AllVar)_(0.00)_(clough).fig');
%         g(3) = hgload('PushoverMaxDriftLevel_Num_9991_(ID2437_R5_5Story_v.01_3)_(AllVar)_(0.00)_(clough).fig');
%         g(4) = hgload('PushoverMaxDriftLevel_Num_9991_(ID2437_R5_5Story_v.01_4)_(AllVar)_(0.00)_(clough).fig');
%         g(5) = hgload('PushoverMaxDriftLevel_Num_9991_(ID2437_R5_5Story_v.01_5)_(AllVar)_(0.00)_(clough).fig');
%         g(6) = hgload('PushoverMaxDriftLevel_Num_9991_(ID2437_R5_5Story_v.01_6)_(AllVar)_(0.00)_(clough).fig');
        
        titleLIST = {'Grid-1', 'Grid-2', 'Grid-3', 'Grid-4', 'Grid-5', 'Grid-6'};
        exportName = sprintf('Pushover2437_diffPointsForLoad');
%         exportName = sprintf('Pushover2437_MaxDriftLevel');
        
        xlabelText = get(gca,'xlabel'); ylabelText = get(gca,'ylabel');
        
        numFigs = size(titleLIST, 2);
        
        % Prepare subplots
        figure
        for i = 1:numFigs
            h(i)=subplot((numFigs/2),2,i);
            xlabel(xlabelText.String);
            ylabel(ylabelText.String);
            title(['Bldg. ID- 2437; ', titleLIST{i}]); grid on;
        end
        
        % Paste figures on the subplots
        for i = 1:numFigs
            copyobj(allchild(get(g(i), 'CurrentAxes')),h(i)); % associated axes
        end
        
        % xlim(h(1),[0 0.03]); ylim(h(1),[0 500]);
        % xlim(h(2),[0 0.025]); ylim(h(2),[0 500]);
        % xlim(h(3),[0 0.05]); ylim(h(3),[0 600]);
        % xlim(h(4),[0 0.05]); ylim(h(4),[0 500]);
        
        for i = 1:numFigs
            xlim(h(i),[0 0.06]); ylim(h(i),[0, 3500]);
%             xlim(h(i),[0 0.08]); ylim(h(i),[1, 8]);
            close(g(i));
        end
        
       hgsave(exportName); % .fig file for Matlab
       print('-depsc', exportName); % .eps file for Linux (LaTeX)
       print('-dmeta', exportName); % .emf file for Windows (MSWORD)
       print('-dpng', exportName); % .png file for small sized files

        fprintf('Combined figure saved as %s/%s.', pwd, exportName);
        
        cd(baseFolder)

    case '24d.combineSixFigures'
        %%
        baseFolder = pwd;

        cd I:\PrakRuns_I\Output\2229_differentSPO
        
%         g(1) = hgload('Pushover_Num_9991_(ID2229_R5_7Story_v_02)_(AllVar)_(0_00)_(clough).fig');
%         g(2) = hgload('Pushover_Num_9991_(ID2229_R5_7Story_v_02_2)_(AllVar)_(0_00)_(clough).fig');
%         g(3) = hgload('Pushover_Num_9991_(ID2229_R5_7Story_v_02_3)_(AllVar)_(0_00)_(clough).fig');
%         g(4) = hgload('Pushover_Num_9991_(ID2229_R5_7Story_v_02_4)_(AllVar)_(0_00)_(clough).fig');
%         g(5) = hgload('Pushover_Num_9991_(ID2229_R5_7Story_v_02_5)_(AllVar)_(0_00)_(clough).fig');
%         g(6) = hgload('Pushover_Num_9991_(ID2229_R5_7Story_v_02_6)_(AllVar)_(0_00)_(clough).fig');
        
        g(1) = hgload('PushoverMaxDriftLevel_Num_9991_(ID2229_R5_7Story_v.02)_(AllVar)_(0.00)_(clough).fig');
        g(2) = hgload('PushoverMaxDriftLevel_Num_9991_(ID2229_R5_7Story_v.02_2)_(AllVar)_(0.00)_(clough).fig');
        g(3) = hgload('PushoverMaxDriftLevel_Num_9991_(ID2229_R5_7Story_v.02_3)_(AllVar)_(0.00)_(clough).fig');
        g(4) = hgload('PushoverMaxDriftLevel_Num_9991_(ID2229_R5_7Story_v.02_4)_(AllVar)_(0.00)_(clough).fig');
        g(5) = hgload('PushoverMaxDriftLevel_Num_9991_(ID2229_R5_7Story_v.02_5)_(AllVar)_(0.00)_(clough).fig');
        g(6) = hgload('PushoverMaxDriftLevel_Num_9991_(ID2229_R5_7Story_v.02_6)_(AllVar)_(0.00)_(clough).fig');
        
        titleLIST = {'Grid-1', 'Grid-2', 'Grid-3', 'Grid-4', 'Grid-5', 'Grid-6'};
%         exportName = sprintf('Pushover2229_diffPointsForLoad');
        exportName = sprintf('Pushover2229_MaxDriftLevel');
        
        xlabelText = get(gca,'xlabel'); ylabelText = get(gca,'ylabel');
        
        numFigs = size(titleLIST, 2);
        
        % Prepare subplots
        figure
        for i = 1:numFigs
            h(i)=subplot((numFigs/2),2,i);
            xlabel(xlabelText.String);
            ylabel(ylabelText.String);
            title(['Bldg. ID- 2229; ', titleLIST{i}]); grid on;
        end
        
        % Paste figures on the subplots
        for i = 1:numFigs
            copyobj(allchild(get(g(i), 'CurrentAxes')),h(i)); % associated axes
        end
        
        % xlim(h(1),[0 0.03]); ylim(h(1),[0 500]);
        % xlim(h(2),[0 0.025]); ylim(h(2),[0 500]);
        % xlim(h(3),[0 0.05]); ylim(h(3),[0 600]);
        % xlim(h(4),[0 0.05]); ylim(h(4),[0 500]);
        
        for i = 1:numFigs
%             xlim(h(i),[0 0.06]); ylim(h(i),[0, 3500]);
            xlim(h(i),[0 0.08]); ylim(h(i),[1, 8]);
            close(g(i));
        end
        
       hgsave(exportName); % .fig file for Matlab
       print('-depsc', exportName); % .eps file for Linux (LaTeX)
       print('-dmeta', exportName); % .emf file for Windows (MSWORD)
       print('-dpng', exportName); % .png file for small sized files

        fprintf('Combined figure saved as %s/%s.', pwd, exportName);
        
        cd(baseFolder)

    case '24e.combineSixFigures'
        %%
        baseFolder = pwd;

        cd I:\PrakRuns_I\Output\2453_differentSPO
  
        g(1) = hgload('Pushover_Num_9991_(ID2453_R5_6Story_v_01)_(AllVar)_(0_00)_(clough).fig');
        g(2) = hgload('Pushover_Num_9991_(ID2453_R5_6Story_v_01_2)_(AllVar)_(0_00)_(clough).fig');
        g(3) = hgload('Pushover_Num_9991_(ID2453_R5_6Story_v_01_3)_(AllVar)_(0_00)_(clough).fig');
        g(4) = hgload('Pushover_Num_9991_(ID2453_R5_6Story_v_01_4)_(AllVar)_(0_00)_(clough).fig');
        
%         g(1) = hgload('PushoverMaxDriftLevel_Num_9991_(ID2453_R5_6Story_v.01)_(AllVar)_(0.00)_(clough).fig');
%         g(2) = hgload('PushoverMaxDriftLevel_Num_9991_(ID2453_R5_6Story_v.01_2)_(AllVar)_(0.00)_(clough).fig');
%         g(3) = hgload('PushoverMaxDriftLevel_Num_9991_(ID2453_R5_6Story_v.01_3)_(AllVar)_(0.00)_(clough).fig');
%         g(4) = hgload('PushoverMaxDriftLevel_Num_9991_(ID2453_R5_6Story_v.01_4)_(AllVar)_(0.00)_(clough).fig');
        
        titleLIST = {'Grid-1', 'Grid-2', 'Grid-3', 'Grid-4'};
        exportName = sprintf('Pushover2453_diffPointsForLoad');
%         exportName = sprintf('Pushover2453_MaxDriftLevel');
        
        xlabelText = get(gca,'xlabel'); ylabelText = get(gca,'ylabel');
        
        numFigs = size(titleLIST, 2);
        
        % Prepare subplots
        figure
        for i = 1:numFigs
            h(i)=subplot((numFigs/2),2,i);
            xlabel(xlabelText.String);
            ylabel(ylabelText.String);
            title(['Bldg. ID- 2453; ', titleLIST{i}]); grid on;
        end
        
        % Paste figures on the subplots
        for i = 1:numFigs
            copyobj(allchild(get(g(i), 'CurrentAxes')),h(i)); % associated axes
        end
        
        % xlim(h(1),[0 0.03]); ylim(h(1),[0 500]);
        % xlim(h(2),[0 0.025]); ylim(h(2),[0 500]);
        % xlim(h(3),[0 0.05]); ylim(h(3),[0 600]);
        % xlim(h(4),[0 0.05]); ylim(h(4),[0 500]);
        
        for i = 1:numFigs
            xlim(h(i),[0 0.06]); ylim(h(i),[0, 2000]);
%             xlim(h(i),[0 0.08]); ylim(h(i),[1, 8]);
            close(g(i));
        end
        
       hgsave(exportName); % .fig file for Matlab
       print('-depsc', exportName); % .eps file for Linux (LaTeX)
       print('-dmeta', exportName); % .emf file for Windows (MSWORD)
       print('-dpng', exportName); % .png file for small sized files

        fprintf('Combined figure saved as %s/%s.', pwd, exportName);
        
        cd(baseFolder)

    case '24f.combineSixFigures'
        %%
        baseFolder = pwd;

        cd I:\PrakRuns_I\Output\2451_differentSPO
  
%         g(1) = hgload('Pushover_Num_9991_(ID2451_R5_5Story_v_01)_(AllVar)_(0_00)_(clough).fig');
%         g(2) = hgload('Pushover_Num_9991_(ID2451_R5_5Story_v_01_2)_(AllVar)_(0_00)_(clough).fig');
%         g(3) = hgload('Pushover_Num_9991_(ID2451_R5_5Story_v_01_3)_(AllVar)_(0_00)_(clough).fig');
%         g(4) = hgload('Pushover_Num_9991_(ID2451_R5_5Story_v_01_4)_(AllVar)_(0_00)_(clough).fig');

        g(1) = hgload('PushoverMaxDriftLevel_Num_9991_(ID2451_R5_5Story_v.01)_(AllVar)_(0.00)_(clough).fig');
        g(2) = hgload('PushoverMaxDriftLevel_Num_9991_(ID2451_R5_5Story_v.01_2)_(AllVar)_(0.00)_(clough).fig');
        g(3) = hgload('PushoverMaxDriftLevel_Num_9991_(ID2451_R5_5Story_v.01_3)_(AllVar)_(0.00)_(clough).fig');
        g(4) = hgload('PushoverMaxDriftLevel_Num_9991_(ID2451_R5_5Story_v.01_4)_(AllVar)_(0.00)_(clough).fig');

        titleLIST = {'Grid-1', 'Grid-2', 'Grid-3', 'Grid-4'};
%         exportName = sprintf('Pushover2451_diffPointsForLoad');
        exportName = sprintf('Pushover2451_MaxDriftLevel');
        
        xlabelText = get(gca,'xlabel'); ylabelText = get(gca,'ylabel');
        
        numFigs = size(titleLIST, 2);
        
        % Prepare subplots
        figure
        for i = 1:numFigs
            h(i)=subplot((numFigs/2),2,i);
            xlabel(xlabelText.String);
            ylabel(ylabelText.String);
            title(['Bldg. ID- 2451; ', titleLIST{i}]); grid on;
        end
        
        % Paste figures on the subplots
        for i = 1:numFigs
            copyobj(allchild(get(g(i), 'CurrentAxes')),h(i)); % associated axes
        end
        
        % xlim(h(1),[0 0.03]); ylim(h(1),[0 500]);
        % xlim(h(2),[0 0.025]); ylim(h(2),[0 500]);
        % xlim(h(3),[0 0.05]); ylim(h(3),[0 600]);
        % xlim(h(4),[0 0.05]); ylim(h(4),[0 500]);
        
        for i = 1:numFigs
%             xlim(h(i),[0 0.06]); ylim(h(i),[0, 2000]);
            xlim(h(i),[0 0.08]); ylim(h(i),[1, 8]);
            close(g(i));
        end
        
       hgsave(exportName); % .fig file for Matlab
       print('-depsc', exportName); % .eps file for Linux (LaTeX)
       print('-dmeta', exportName); % .emf file for Windows (MSWORD)
       print('-dpng', exportName); % .png file for small sized files

        fprintf('Combined figure saved as %s\\%s.', pwd, exportName);
        
        cd(baseFolder)

    case '24g.combineSixFigures'
        %%
        baseFolder = pwd;

        cd I:\PrakRuns_I\Output\2225_differentSPO
  
%         g(1) = hgload('Pushover_Num_9991_(ID2225_R5_12Story_v_02)_(AllVar)_(0_00)_(clough).fig');
%         g(2) = hgload('Pushover_Num_9991_(ID2225_R5_12Story_v_02_2)_(AllVar)_(0_00)_(clough).fig');
%         g(3) = hgload('Pushover_Num_9991_(ID2225_R5_12Story_v_02_3)_(AllVar)_(0_00)_(clough).fig');
%         g(4) = hgload('Pushover_Num_9991_(ID2225_R5_12Story_v_02_4)_(AllVar)_(0_00)_(clough).fig');
        
        g(1) = hgload('PushoverMaxDriftLevel_Num_9991_(ID2225_R5_12Story_v.02)_(AllVar)_(0.00)_(clough).fig');
        g(2) = hgload('PushoverMaxDriftLevel_Num_9991_(ID2225_R5_12Story_v.02_2)_(AllVar)_(0.00)_(clough).fig');
        g(3) = hgload('PushoverMaxDriftLevel_Num_9991_(ID2225_R5_12Story_v.02_3)_(AllVar)_(0.00)_(clough).fig');
        g(4) = hgload('PushoverMaxDriftLevel_Num_9991_(ID2225_R5_12Story_v.02_4)_(AllVar)_(0.00)_(clough).fig');

        titleLIST = {'Grid-1', 'Grid-2', 'Grid-3', 'Grid-4'};
%         exportName = sprintf('Pushover2225_diffPointsForLoad');
        exportName = sprintf('Pushover2225_MaxDriftLevel');
        
        xlabelText = get(gca,'xlabel'); ylabelText = get(gca,'ylabel');
        
        numFigs = size(titleLIST, 2);
        
        % Prepare subplots
        figure
        for i = 1:numFigs
            h(i)=subplot((numFigs/2),2,i);
            xlabel(xlabelText.String);
            ylabel(ylabelText.String);
            title(['Bldg. ID- 2225; ', titleLIST{i}]); grid on;
        end
        
        % Paste figures on the subplots
        for i = 1:numFigs
            copyobj(allchild(get(g(i), 'CurrentAxes')),h(i)); % associated axes
        end
        
        % xlim(h(1),[0 0.03]); ylim(h(1),[0 500]);
        % xlim(h(2),[0 0.025]); ylim(h(2),[0 500]);
        % xlim(h(3),[0 0.05]); ylim(h(3),[0 600]);
        % xlim(h(4),[0 0.05]); ylim(h(4),[0 500]);
        
        for i = 1:numFigs
%             xlim(h(i),[0 0.06]); ylim(h(i),[0, 2000]);
            xlim(h(i),[0 0.08]); ylim(h(i),[1, 14]);
            close(g(i));
        end
        
       hgsave(exportName); % .fig file for Matlab
       print('-depsc', exportName); % .eps file for Linux (LaTeX)
       print('-dmeta', exportName); % .emf file for Windows (MSWORD)
       print('-dpng', exportName); % .png file for small sized files

        fprintf('Combined figure saved as %s\\%s.', pwd, exportName);
        
        cd(baseFolder)
        
    case '24p_g.combineDifferentFiguresOnSamePlot_2225'
        %%
        baseFolder = pwd;

        cd I:\PrakRuns_I\Output\2225_differentSPO
        
        exportName = 'combinedFig_2225_maxDrift';
        
        %% 2nd method
        % open figures;
        fig1 = openfig('PushoverMaxDriftLevel_Num_9991_(ID2225_R5_12Story_v.02_2)_(AllVar)_(0.00)_(clough).fig');
        fig2 = openfig('PushoverMaxDriftLevel_Num_9991_(ID2225_R5_12Story_v.02_3)_(AllVar)_(0.00)_(clough).fig');
        fig3 = openfig('PushoverMaxDriftLevel_Num_9991_(ID2225_R5_12Story_v.02_gridWiseSPO)_(AllVar)_(0.00)_(clough).fig');

        % get handles to axes and lines
        ax = findobj(fig1,'Type','Axes');
        
        L1 = findall(fig1,'Type','Line');% legend('A');
        for i = 1:length(L1); L1(i, 1).Color = 'r'; L1(i, 1).LineStyle = '-'; L1(i, 1).Marker = 'o'; L1(i, 1).MarkerSize = 8; L1(i, 1).LineWidth = 2.5; end
        
        L2 = findall(fig2,'Type','Line'); 
        for i = 1:length(L2); L2(i, 1).Color = 'g'; L2(i, 1).LineStyle = '--'; L2(i, 1).Marker = 's'; L2(i, 1).MarkerSize = 8; L2(i, 1).LineWidth = 2.5; end
        
        L3 = findall(fig3,'Type','Line'); 
        for i = 1:length(L3); L3(i, 1).Color = 'b'; L3(i, 1).LineStyle = '-.'; L3(i, 1).Marker = 'd'; L3(i, 1).MarkerSize = 8; L3(i, 1).LineWidth = 2.5; end
        
%         L4 = findall(fig4,'Type','Line'); 
%         for i = 1:length(L4); L4(i, 1).Color = 'm'; L4(i, 1).LineStyle = ':'; L4(i, 1).Marker = 'v'; L4(i, 1).MarkerSize = 8; L4(i, 1).LineWidth = 2.5; end
%         
%         L5 = findall(fig5,'Type','Line'); 
%         for i = 1:length(L5); L5(i, 1).Color = 'k'; L5(i, 1).LineStyle = '-'; L5(i, 1).Marker = 'x'; L5(i, 1).MarkerSize = 8; L5(i, 1).LineWidth = 2.5; end

        % copy lines to same figure
        p2_new = copyobj(L2,ax);
        p3_new = copyobj(L3,ax);
%         p4_new = copyobj(L4,ax);
%         p5_new = copyobj(L5,ax);
        
        % recreate legend
        % legend(ax,[L1(1),p2_new(1),p3_new(1),p4_new(1)])
%         close(fig2); close(fig3); close(fig4); close(fig5);
        close(fig2); close(fig3); 
                
        xlim(ax,[0 0.08]); ylim(ax,[1, 14]);

       hgsave(exportName); % .fig file for Matlab
       print('-depsc', exportName); % .eps file for Linux (LaTeX)
       print('-dmeta', exportName); % .emf file for Windows (MSWORD)
       print('-dpng', exportName); % .png file for small sized files

       fprintf('Combined figure saved as %s\\%s.', pwd, exportName);
        
       cd(baseFolder)

    case '24p_g.combineDifferentFiguresOnSamePlot_2437'
        %%
        baseFolder = pwd;

        cd I:\PrakRuns_I\Output\2437_differentSPO
        
        exportName = 'combinedFig_2437_maxDrift';
        
        %% 2nd method
        % open figures;
        fig1 = openfig('PushoverMaxDriftLevel_Num_9991_(ID2437_R5_5Story_v.01_2)_(AllVar)_(0.00)_(clough).fig');
        fig2 = openfig('PushoverMaxDriftLevel_Num_9991_(ID2437_R5_5Story_v.01_3)_(AllVar)_(0.00)_(clough).fig');
        fig3 = openfig('PushoverMaxDriftLevel_Num_9991_(ID2437_R5_5Story_v.01_4)_(AllVar)_(0.00)_(clough).fig');
        fig4 = openfig('PushoverMaxDriftLevel_Num_9991_(ID2437_R5_5Story_v.01_5)_(AllVar)_(0.00)_(clough).fig');
        fig5 = openfig('PushoverMaxDriftLevel_Num_9991_(ID2437_R5_5Story_v.01_gridWiseSPO)_(AllVar)_(0.00)_(clough).fig');

        % get handles to axes and lines
        ax = findobj(fig1,'Type','Axes');
        
        L1 = findall(fig1,'Type','Line');% legend('A');
        for i = 1:length(L1); L1(i, 1).Color = 'r'; L1(i, 1).LineStyle = '-'; L1(i, 1).Marker = 'o'; L1(i, 1).MarkerSize = 8; L1(i, 1).LineWidth = 2; end
        
        L2 = findall(fig2,'Type','Line'); 
        for i = 1:length(L2); L2(i, 1).Color = 'g'; L2(i, 1).LineStyle = '--'; L2(i, 1).Marker = 's'; L2(i, 1).MarkerSize = 8; L2(i, 1).LineWidth = 2; end
        
        L3 = findall(fig3,'Type','Line'); 
        for i = 1:length(L3); L3(i, 1).Color = 'b'; L3(i, 1).LineStyle = '-.'; L3(i, 1).Marker = 'd'; L3(i, 1).MarkerSize = 8; L3(i, 1).LineWidth = 2; end
        
        L4 = findall(fig4,'Type','Line'); 
        for i = 1:length(L4); L4(i, 1).Color = 'm'; L4(i, 1).LineStyle = ':'; L4(i, 1).Marker = 'v'; L4(i, 1).MarkerSize = 8; L4(i, 1).LineWidth = 2; end
        
        L5 = findall(fig5,'Type','Line'); 
        for i = 1:length(L5); L5(i, 1).Color = 'k'; L5(i, 1).LineStyle = '-'; L5(i, 1).Marker = 'x'; L5(i, 1).MarkerSize = 8; L5(i, 1).LineWidth = 2; end

        % copy lines to same figure
        p2_new = copyobj(L2,ax);
        p3_new = copyobj(L3,ax);
        p4_new = copyobj(L4,ax);
        p5_new = copyobj(L5,ax);
        
        % recreate legend
        % legend(ax,[L1(1),p2_new(1),p3_new(1),p4_new(1)])
        close(fig2); close(fig3); close(fig4); close(fig5);
                
        xlim(ax,[0 0.08]); ylim(ax,[1, 7]);

       hgsave(exportName); % .fig file for Matlab
       print('-depsc', exportName); % .eps file for Linux (LaTeX)
       print('-dmeta', exportName); % .emf file for Windows (MSWORD)
       print('-dpng', exportName); % .png file for small sized files

       fprintf('Combined figure saved as %s\\%s.', pwd, exportName);
        
       cd(baseFolder)


    case '24g.combineThreeFigures_CND'
        %%
        baseFolder = pwd;

        cd C:\Users\aprak\Drive_UBCO\WRITING_ubco\paper_sub_ResPaper_Spectra\Fig_R1\Fig8_FragCombining
                
        %% 2nd method
        % open figures;
        g(1) = hgload('1310v1_FF_Frag_Sa_0p83.fig'); xlabelText{1} = get(gca,'xlabel'); ylabelText{1} = get(gca,'ylabel');
        g(2) = hgload('1610v1_FF_Frag_Sa_1p68.fig'); xlabelText{2} = get(gca,'xlabel'); ylabelText{2} = get(gca,'ylabel');
        g(3) = hgload('1910v1_FF_Frag_Sa_2p41.fig'); xlabelText{3} = get(gca,'xlabel'); ylabelText{3} = get(gca,'ylabel');
        
        titleLIST = {'3-Story', '6-Story', '9-Story'};
        exportName = sprintf('combinedFig8');
        
        numFigs = size(titleLIST, 2);
        
        % Prepare subplots
        figure
        for i = 1:numFigs
            h(i)=subplot(1,3,i);
            xlabel(xlabelText{i}.String);
            ylabel(ylabelText{i}.String);
%             title(['Bldg. ID- ', titleLIST{i}]); grid on;
        end
        
        % Paste figures on the subplots
        for i = 1:numFigs
            copyobj(allchild(get(g(i), 'CurrentAxes')),h(i)); % associated axes
        end
        
        % xlim(h(1),[0 0.03]); ylim(h(1),[0 500]);
        % xlim(h(2),[0 0.025]); ylim(h(2),[0 500]);
        % xlim(h(3),[0 0.05]); ylim(h(3),[0 600]);
        % xlim(h(4),[0 0.05]); ylim(h(4),[0 500]);
        
        for i = 1:numFigs
%             xlim(h(i),[0 0.055]); ylim(h(i),[0, 750]);
            xlim(h(i),[0 4.5]); ylim(h(i),[0, 1]);
            close(g(i));
        end
        
        if 1 == 0
            extensions = {'fig', 'epsc', 'meta'};
            for k = 1:length(extensions)
    	        saveas(gcf, exportName, extensions{k})
            end
            fprintf('Combined figure saved as %s/%s.', pwd, exportName);
        end

        cd(baseFolder)



    case '25.extractVmaxAndMuT'
        %%	
%         cd I:\PrakRuns_I\Output
        cd K:\Output
%         cd I:\PrakRuns_I\Output\ASCEPushoverLoading

        modelFolderLIST = {
            'ID2205_R5_4Story_v.03';
            'ID2207_R5_7Story_v.09';
            'ID2209_R5_12Story_v.05';
            'ID2211_R5_2Story_v.03';
            'ID2213_R5_4Story_v.04';
            'ID2451_R5_5Story_v.02';
            'ID2453_R5_6Story_v.02';
            'ID2215_R5_7Story_v.03';
            'ID2217_R5_12Story_v.03';
            'ID2219_R5_2Story_v.03';
            'ID2221_R5_4Story_v.06';
            'ID2433_R5_5Story_v.02';
            'ID2435_R5_6Story_v.02';
            'ID2223_R5_7Story_v.03';
            'ID2457_R5_8Story_v.01';
            'ID2459_R5_9Story_v.01';
            'ID2461_R5_10Story_v.01';
            'ID2463_R5_11Story_v.01';
            'ID2225_R5_12Story_v.03';
            'ID2227_R5_4Story_v.05';
            'ID2437_R5_5Story_v.02';
            'ID2439_R5_6Story_v.02';
            'ID2229_R5_7Story_v.03';
            'ID2231_R5_4Story_v.04';
            'ID2441_R5_5Story_v.02';
            'ID2443_R5_6Story_v.02';
            'ID2233_R5_7Story_v.03';
            'ID2235_R5_4Story_v.04';
            'ID2445_R5_5Story_v.02';
            'ID2447_R5_6Story_v.02a';
            'ID2237_R5_7Story_v.03a';
            };

        for i = 1:size(modelFolderLIST, 1)
            modelFolder =  modelFolderLIST{i, 1};
            buildingID = str2double(modelFolder(3:strfind(modelFolder, '_')-1));
            analysisTypeFolder = sprintf('(%s)_(AllVar)_(0.00)_(clough)', modelFolder);
%             analysisTypeFolder = sprintf('(%s)_(AllVar)_(0.00)_(clough)_PushoverLoadASCE', modelFolder);
%             analysisTypeFolder = sprintf('(%s)_(AllVar)_(0.00)_(clough)_SPO1stMode', modelFolder);
%             analysisTypeFolder = sprintf('(%s)_(AllVar)_(0.00)_(clough)_SPO_ASCE7', modelFolder);
            cd(analysisTypeFolder)
            load('DATA_pushover.mat', 'plotArrayAndBaseShearArray', 'mu_T')
            cd ..
            
            BS = plotArrayAndBaseShearArray(:, 2);
            defoVec = plotArrayAndBaseShearArray(:, 1);
            
% (12-01-16, PSB) added the following two commands to adjust for the pushover curve starting from a non-origin points. This causes the initial slope to look different 
% from the actual value and gives a feeling that structure has yielded much earlier, in some cases even ealier than the factored design base shear value.
            %     offsetOfBaseShear = interp1(defoVec, BS, 0);
            ix = find(defoVec >= 0, 1);
            offsetOfBaseShear = interp1([defoVec(ix-1), defoVec(ix)], ...
            [BS(ix-1), BS(ix)], 0, 'pchip');
            BS = BS - offsetOfBaseShear;
            
            [V_maxLIST(i, 1), ~] = max(BS);
            mu_T_LIST(i, 1) = mu_T;
            bldgID_LIST(i, 1) = buildingID;
        end
		clearvars -except V_maxLIST mu_T_LIST bldgID_LIST baseFolder
        
    case '26.openMultiplePushoverCurves'
        %%
        close all
        cd K:\Output
%         cd I:\PrakRuns_I\Output
%         cd I:\PrakRuns_I\Output
        modelNameLIST = {  % archetypical SMRF v21, paper-1
            'ID2207_R5_7Story_v.09';% for deactivating, rename the variable to modelNameLIST1
            'ID2209_R5_12Story_v.05';
            'ID2211_R5_2Story_v.03';
            'ID2213_R5_4Story_v.04';
            'ID2451_R5_5Story_v.02';
            'ID2453_R5_6Story_v.02';
            'ID2215_R5_7Story_v.03';
            'ID2217_R5_12Story_v.03';
            'ID2219_R5_2Story_v.03';
            'ID2221_R5_4Story_v.06';
            'ID2433_R5_5Story_v.02';
            'ID2435_R5_6Story_v.02';
            'ID2223_R5_7Story_v.03';
            'ID2457_R5_8Story_v.01';
            'ID2459_R5_9Story_v.01';
            'ID2461_R5_10Story_v.01';
            'ID2463_R5_11Story_v.01';
            'ID2225_R5_12Story_v.03';
            'ID2227_R5_4Story_v.05';
            'ID2437_R5_5Story_v.02';
            'ID2439_R5_6Story_v.02';
            'ID2229_R5_7Story_v.03';
            'ID2231_R5_4Story_v.04';
            'ID2441_R5_5Story_v.02';
            'ID2443_R5_6Story_v.02';
            'ID2233_R5_7Story_v.03';
            'ID2235_R5_4Story_v.04';
            'ID2445_R5_5Story_v.02';
            'ID2447_R5_6Story_v.02a';
            'ID2237_R5_7Story_v.03a';
            };
        modelNameLIST2 = {'ID2459_R5_9Story_v.01';};
        modelNameLIST1 = {  % for deactivating, rename the variable to modelNameLIST1
            'ID30401_XZ_R0_4Story_v.02';
            'ID30402_YZ_R0_4Story_v.02';
            'ID30421_XZ_R0_4Story_v.02';
            'ID30422_YZ_R0_4Story_v.02';
            'ID30441_XZ_R0_4Story_v.02';
            'ID30442_YZ_R0_4Story_v.02';
            'ID30451_XZ_R0_4Story_v.02';
            'ID30452_YZ_R0_4Story_v.02';
            'ID30471_XZ_R0_4Story_v.02';
            'ID30472_YZ_R0_4Story_v.02';
            };
        
        for i = 1:size(modelNameLIST, 1)
            modelName = modelNameLIST{i, 1};
            analysisDir = sprintf('(%s)_(AllVar)_(0.00)_(clough)', modelName);
            cd(analysisDir);
            
            index   = strfind(modelName, '.'); first   = index(1);
            modelNameWithUnderscore = [modelName(1:first - 1), '_', modelName(first + length('.'):end)];
            fileName = sprintf('Pushover_Num_9991_(%s)_(AllVar)_(0_00)_(clough).fig', modelNameWithUnderscore);
%             fileName = sprintf('PushoverMaxDriftLevel_Num_9991_(%s)_(AllVar)_(0.00)_(clough).fig', modelName);
%             fileName = sprintf('CollapseIDA_ControlComp_SaGeoMean.fig');
%             fileName = sprintf('PushoverDeformedShape_lastStep_%s.fig', modelName);
            
            open(fileName)
            cd ..
        end
        
    case '26a.openMultiplePushoverCurvesAndCopy'
        %%
        close all
%         cd J:\Output
        cd I:\PrakRuns_I\Output
        modelNameLIST = {'ID2437_R5_5Story_v.01'
                'ID2437_R5_5Story_v.01_2';
                'ID2437_R5_5Story_v.01_3';
                'ID2437_R5_5Story_v.01_4';
                'ID2437_R5_5Story_v.01_5';
                'ID2437_R5_5Story_v.01_6';};
        for i = 1:size(modelNameLIST, 1)
            modelName = modelNameLIST{i, 1};
            analysisDir = sprintf('(%s)_(AllVar)_(0.00)_(clough)', modelName);
            cd(analysisDir);
            index   = strfind(modelName, '.'); first   = index(1);
            modelNameWithUnderscore = [modelName(1:first - 1), '_', modelName(first + length('.'):end)];
            fileName = sprintf('Pushover_Num_9991_(%s)_(AllVar)_(0_00)_(clough).fig', modelNameWithUnderscore); 
%             fileName = sprintf('PushoverMaxDriftLevel_Num_9991_(%s)_(AllVar)_(0.00)_(clough).fig', modelName);
            open(fileName);
            cd ..
            
            cd 2437_differentSPO
            savefig(fileName); locationForPrint = pwd;
            cd ..
        end    
        fprintf('Selected figures copied to %s\n', locationForPrint);
        
    case '26b.openMultiplePushoverCurvesAndCopy'
        %%
        close all
%         cd J:\Output
        cd I:\PrakRuns_I\Output
        modelNameLIST = {'ID2229_R5_7Story_v.02';
                         'ID2229_R5_7Story_v.02_2';
                         'ID2229_R5_7Story_v.02_3';
                         'ID2229_R5_7Story_v.02_4';
                         'ID2229_R5_7Story_v.02_5';
                         'ID2229_R5_7Story_v.02_6';};
        for i = 1:size(modelNameLIST, 1)
            modelName = modelNameLIST{i, 1};
            analysisDir = sprintf('(%s)_(AllVar)_(0.00)_(clough)', modelName);
            cd(analysisDir);
            index   = strfind(modelName, '.'); first   = index(1);
            modelNameWithUnderscore = [modelName(1:first - 1), '_', modelName(first + length('.'):end)];
%             fileName = sprintf('Pushover_Num_9991_(%s)_(AllVar)_(0_00)_(clough).fig', modelNameWithUnderscore); 
            fileName = sprintf('PushoverMaxDriftLevel_Num_9991_(%s)_(AllVar)_(0.00)_(clough).fig', modelName);
            open(fileName);
            cd ..
            
            cd 2229_differentSPO
            savefig(fileName); locationForPrint = pwd;
            cd ..
        end    
        fprintf('Selected figures copied to %s\n', locationForPrint);
        
    case '26c.openMultiplePushoverCurvesAndCopy'
        %%
        close all
%         cd J:\Output
        cd I:\PrakRuns_I\Output
        modelNameLIST = {'ID2453_R5_6Story_v.01';
                         'ID2453_R5_6Story_v.01_2';
                         'ID2453_R5_6Story_v.01_3';
                         'ID2453_R5_6Story_v.01_4';};
        for i = 1:size(modelNameLIST, 1)
            modelName = modelNameLIST{i, 1};
            analysisDir = sprintf('(%s)_(AllVar)_(0.00)_(clough)', modelName);
            cd(analysisDir);
            index   = strfind(modelName, '.'); first   = index(1);
            modelNameWithUnderscore = [modelName(1:first - 1), '_', modelName(first + length('.'):end)];
            fileName = sprintf('Pushover_Num_9991_(%s)_(AllVar)_(0_00)_(clough).fig', modelNameWithUnderscore); 
%             fileName = sprintf('PushoverMaxDriftLevel_Num_9991_(%s)_(AllVar)_(0.00)_(clough).fig', modelName);
            open(fileName);
            cd ..
            
            cd 2453_differentSPO
            savefig(fileName); locationForPrint = pwd;
            cd ..
        end    
        fprintf('Selected figures copied to %s\n', locationForPrint);
        
    case '26d.openMultiplePushoverCurvesAndCopy'
        %%
        close all
%         cd J:\Output
        cd I:\PrakRuns_I\Output
        modelNameLIST = {'ID2451_R5_5Story_v.01';
                         'ID2451_R5_5Story_v.01_2';
                         'ID2451_R5_5Story_v.01_3';
                         'ID2451_R5_5Story_v.01_4';};
        for i = 1:size(modelNameLIST, 1)
            modelName = modelNameLIST{i, 1};
            analysisDir = sprintf('(%s)_(AllVar)_(0.00)_(clough)', modelName);
            cd(analysisDir);
            index   = strfind(modelName, '.'); first   = index(1);
            modelNameWithUnderscore = [modelName(1:first - 1), '_', modelName(first + length('.'):end)];
            fileName = sprintf('Pushover_Num_9991_(%s)_(AllVar)_(0_00)_(clough).fig', modelNameWithUnderscore); 
%             fileName = sprintf('PushoverMaxDriftLevel_Num_9991_(%s)_(AllVar)_(0.00)_(clough).fig', modelName);
            open(fileName);
            cd ..
            
            cd 2451_differentSPO
            savefig(fileName); locationForPrint = pwd;
            cd ..
        end    
        fprintf('Selected figures copied to %s\n', locationForPrint);
        
    case '26e.openMultiplePushoverCurvesAndCopy'
        %%
        close all
%         cd J:\Output
        cd I:\PrakRuns_I\Output
        modelNameLIST = {'ID2225_R5_12Story_v.02';
                         'ID2225_R5_12Story_v.02_2';
                         'ID2225_R5_12Story_v.02_3';
                         'ID2225_R5_12Story_v.02_4';};
        for i = 1:size(modelNameLIST, 1)
            modelName = modelNameLIST{i, 1};
            analysisDir = sprintf('(%s)_(AllVar)_(0.00)_(clough)', modelName);
            cd(analysisDir);
            index   = strfind(modelName, '.'); first   = index(1);
            modelNameWithUnderscore = [modelName(1:first - 1), '_', modelName(first + length('.'):end)];
%             fileName = sprintf('Pushover_Num_9991_(%s)_(AllVar)_(0_00)_(clough).fig', modelNameWithUnderscore); 
            fileName = sprintf('PushoverMaxDriftLevel_Num_9991_(%s)_(AllVar)_(0.00)_(clough).fig', modelName);
            open(fileName);
            cd ..
            
            cd 2225_differentSPO
            savefig(fileName); locationForPrint = pwd;
            cd ..
        end    
        fprintf('Selected figures copied to %s\n', locationForPrint);
        
    case '27.extractCurvatureForCriticalMembersInSPO'
        %%
        cd J:\Output
        modelNameLIST = {'ID2207_R5_7Story_v.07';
            'ID2209_R5_12Story_v.04';
            'ID2211_R5_2Story_v.02';
            'ID2213_R5_4Story_v.03';
            'ID2215_R5_12Story_v.02';
            'ID2217_R5_12Story_v.02';
            'ID2219_R5_2Story_v.02';
            'ID2221_R5_4Story_v.05';
            'ID2223_R5_7Story_v.02';
            'ID2225_R5_12Story_v.02';
            'ID2227_R5_4Story_v.04';
            'ID2229_R5_7Story_v.02';
            'ID2231_R5_4Story_v.02';
            'ID2233_R5_7Story_v.02';
            'ID2235_R5_4Story_v.02';
            'ID2237_R5_7Story_v.02';
            'ID2433_R5_5Story_v.01';
            'ID2435_R5_6Story_v.01';
            'ID2437_R5_5Story_v.01';
            'ID2439_R5_6Story_v.01';
            'ID2441_R5_5Story_v.01';
            'ID2443_R5_6Story_v.01';
            'ID2445_R5_5Story_v.01';
            'ID2447_R5_6Story_v.01';};
        for i = 1:size(modelNameLIST, 1)
            modelName = modelNameLIST{i, 1};
            analysisDir = sprintf('(%s)_(AllVar)_(0.00)_(clough)', modelName);
            cd(analysisDir);

            index   = strfind(modelName, '.'); first   = index(1);
            modelNameWithUnderscore = [modelName(1:first - 1), '_', modelName(first + length('.'):end)];
            fileName = sprintf('Pushover_Num_9991_(%s)_(AllVar)_(0_00)_(clough).fig', modelNameWithUnderscore);
            fileName = sprintf('PushoverMaxDriftLevel_Num_9991_(%s)_(AllVar)_(0.00)_(clough)', modelName);
            
            open(fileName)
            cd ..
        end
        
    case '28.openMultiple_TCL_files'    
        %%
        close all
%         cd I:\PrakRuns_I\Models
%         cd('I:\PrakRuns_I\Models\Archetypical SMRF_v21')
%         cd K:\Models
%         cd('I:\PrakRuns_I\Models\Archetypical SMRF_v21_forSPO_ASCE')
        cd('I:\PrakRuns_I\Models')
        modelNameLIST = {
            'ID2207_R5_7Story_v.09';% for deactivating, rename the variable to modelNameLIST1
            'ID2209_R5_12Story_v.05';
            'ID2211_R5_2Story_v.03';
            'ID2213_R5_4Story_v.04';
            'ID2451_R5_5Story_v.02';
            'ID2453_R5_6Story_v.02';
            'ID2215_R5_7Story_v.03';
            'ID2217_R5_12Story_v.03';
            'ID2219_R5_2Story_v.03';
            'ID2221_R5_4Story_v.06';
            'ID2433_R5_5Story_v.02';
            'ID2435_R5_6Story_v.02';
            'ID2223_R5_7Story_v.03';
            'ID2457_R5_8Story_v.01';
            'ID2459_R5_9Story_v.01';
            'ID2461_R5_10Story_v.01';
            'ID2463_R5_11Story_v.01';
            'ID2225_R5_12Story_v.03';
            'ID2227_R5_4Story_v.05';
            'ID2437_R5_5Story_v.02';
            'ID2439_R5_6Story_v.02';
            'ID2229_R5_7Story_v.03';
            'ID2231_R5_4Story_v.04';
            'ID2441_R5_5Story_v.02';
            'ID2443_R5_6Story_v.02';
            'ID2233_R5_7Story_v.03';
            'ID2235_R5_4Story_v.04';
            'ID2445_R5_5Story_v.02';
            'ID2447_R5_6Story_v.02a';
            'ID2237_R5_7Story_v.03a';
            };
        modelNameLIST1 = {'ID30401_XZ_R0_4Story_v.02';
                'ID30402_YZ_R0_4Story_v.02';
                'ID30421_XZ_R0_4Story_v.02';
                'ID30422_YZ_R0_4Story_v.02';
                'ID30441_XZ_R0_4Story_v.02';
                'ID30442_YZ_R0_4Story_v.02';
                'ID30451_XZ_R0_4Story_v.02';
                'ID30452_YZ_R0_4Story_v.02';
                'ID30471_XZ_R0_4Story_v.02';
                'ID30472_YZ_R0_4Story_v.02';
                };
        for i = 1:size(modelNameLIST, 1)
            fprintf('%i/%i...\n', i, size(modelNameLIST, 1));
            modelName = modelNameLIST{i, 1};
            cd(modelName);
            !gvim psb_SetAnalysisOptions.tcl
%             !gvim psb_DefineVariablesAtMeanValues.tcl
%             !gvim psb_SaveRunInformationAfterEQ.tcl
%             !gvim psb_DefinePushoverLoading.tcl
            cd ..
        end
        
    case '29.convertImageToBnW'    
        %%
        % 0. Read in a colored image.
        fontSize = 20;
        folder = 'C:\Users\Prakash\Documents';
        baseFileName = 'Signature (PRAK).jpg';
        % Get the full filename, with path prepended.
        fullFileName = fullfile(folder, baseFileName);
        
        % Check if file exists.
        if ~exist(fullFileName, 'file')
            % File doesn't exist -- didn't find it there.  Check the search path for it.
            fullFileNameOnSearchPath = baseFileName; % No path this time.
            if ~exist(fullFileNameOnSearchPath, 'file')
                % Still didn't find it.  Alert user.
                errorMessage = sprintf('Error: %s does not exist in the search path folders.', fullFileName);
                uiwait(warndlg(errorMessage));
                return;
            end
        end
        grayImage = imread(fullFileName);
        
        % 1. Display the original image.
        subplot(2, 2, 1);
        imshow(grayImage, []);
        title('Original Image', 'FontSize', fontSize);
        set(gcf, 'Units', 'Normalized', 'OuterPosition', [0 0 1 1]); % Enlarge figure to full screen.
        
        % 2a. convert to grayscale image
        % numberOfColorBands should be = 1.
        [rows, columns, numberOfColorBands] = size(grayImage); % Get the dimensions of the image.
        if numberOfColorBands > 1
            grayImage = grayImage(:, :, 2); % Take green channel.
        end
        
        % 2b. Display the original gray scale image.
        subplot(2, 2, 2);
        imshow(grayImage, []);
        title('Original Grayscale Image', 'FontSize', fontSize);
        
        % 3a. Adjust the threshold such that there are no gray areas.
        threshold = 200;
        grayImage_BnW = grayImage; % initialize
        for i = 1: size(grayImage_BnW, 1)
            for j = 1: size(grayImage_BnW, 2)
                if grayImage_BnW(i, j) < threshold; grayImage_BnW(i, j) = 0; end
            end
        end
        
        % 3b. Display the black and white image.
        subplot(2, 2, 3);
        imshow(grayImage_BnW, []);
        title('Black and white image', 'FontSize', fontSize);
        
        % 4. Save black and white image in the location where it was originally stored
        figure(101);
        exportNameWithLoc = fullfile(folder, baseFileName(1:strfind(baseFileName, '.')-1));
        imshow(grayImage_BnW, []); print('-djpeg', [exportNameWithLoc '_BnW_r300'], '-r300');
        fprintf('Black and white image saved as %s.', [exportNameWithLoc '_BnW_r300']);
        close(101);
        
    case '30.readTextFilesSevenSections'
        %%
% -------------------
% This is a sample script file created mostly using one of the technical sessions for 
% CE 603, Numerical Methods course at IIT Bombay
% 
% The present file consists of different ways to read text input files.
%
% Assumptions and Notices: 
%   - There are seven different sections in the file.
%   - You can activate any of these by commenting the previously active section 
%     and un-commenting the new section. At present, Section- 1 is turned on.
%   - For the quick trial, I have provided two text files as well.
%   - One of these files is simple textfile and the other is a real recorded
%     time history data.
%   - The final Section (i.e. Section- 7) is written mainly with this time 
%     history data in the mind.
%   - Play with the content of the input file and program snippets given
%     here and understand behavior of each of the ways of reading files.
%   - No specific command for writing to the files have been given here.
%     But after understanding all of the codes given here, you should try
%     writing to a file by using fprintf. For more information, see the
%     first syntax type in the help for fprintf.
% 
% Author: Prakash S Badal, IIT Bombay
% Date: July 23, 2018
%
%
% -------------------

clear; % clear any present variables in the workspace

% Change the name of the file that you want to read. 
% Please note that the text file to be read and this script should be in the same folder

fileName = 'textFile1.txt';
% fileName = 'RSN7_NWCALIF.C_C-FRN045.AT2'; 

% Open the file in the read mode.
fid = fopen(fileName,'r');


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Section-1 (fscanf) works well with integers, floating-points 

A = fscanf(fid, '%f'); % f is the best bet here!
fclose(fid);


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Section-2 (fgetl) works well with texts, floating-points, in fact, everything. 
% fgetl- returns values line by line

% newline = fgetl(fid);
% disp(newline); pause(1); % display the newline and pause for a second.
% newline = fgetl(fid);
% disp(newline); pause(1);
% newline = fgetl(fid);
% disp(newline); pause(1);
% newline = fgetl(fid);
% disp(newline); pause(1);
% fclose(fid);


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Section-3 (fgetl) works well with texts, floating-points, in fact, everything.
% fgetl- read till a pre-defined line number (15 in this case)

% A = cell(0);
% for i = 1:15
%     newline = fgetl(fid);
%     A = [A; newline];
% end
% fclose(fid);


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Section-4 (fgetl) works well with texts, floating-points, in fact, everything.
% fgetl- read till the end of a file without knowledge over the length of the input file.

% A = cell(0);
% while ~feof(fid)
%     newline = fgetl(fid);
%     A = [A; newline];
% end
% fclose(fid);


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Section-5 (fgetl) works well with texts, floating-points, in fact, everything.
% fgetl- do not read the file after a condition is met

% A = cell(0);
% count = 0;
% newline = '';
% while (~feof(fid) && ~strcmp(newline, 'stop'))
%     newline = fgetl(fid);
% %     if isempty(line)||strncmp(line,'%',1)||~ischar(line)
% %         continue
% %     end
%     count = count + 1;
%     A = [A; newline];
% end
% fprintf('Number of lines in the file is %i \n', count); % disp(count); 
% fclose(fid);


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Section-6 (textscan) works well with Formatted data. e.g. '%s' as input. Floating-points, in fact, everything.
% different from fgetl 
% 1. All information is read in one go, so would be faster.
% 2. Unlike, fgetl there's no way to stop reading a large file.
% Downside- unformatted data, mixed type data can't be read

% A = textscan(fid, '%s','\n');
% fclose(fid);


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Section-7 (importdata) works well unFormatted data and is very fast.
% different from fgetl and textscan
% 1. All information is read in one go, so would be faster. But there's no way to stop reading a large file.
% 2. Unlike, textscan unformatted data can be read as well 

% fileName = 'RSN7_NWCALIF.C_C-FRN045.AT2';
% linesToSkip = 4;
% A = importdata(fileName, ' ', linesToSkip);
% temp1=reshape(A.data', numel(A.data), 1); % reshaping into one column
% temp1(~any(~isnan(temp1), 2),:)=[];
% 
% timeHistory = temp1;
% dtTimeHistory = str2double(A.colheaders{1, 4});
% plot(0:dtTimeHistory:(length(timeHistory)-1)*dtTimeHistory, timeHistory); grid on; hold on;
% xlabel('T (sec)');
% ylabel('Ground accn (g)');
% str=sprintf('Ground accn plot for %10s',fileName);
% title(str);


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%        
        
        

    case '31.opentextFilesInNotepad++'    
        %%
        close all
        baseFolder1 = 'C:\Users\psb\Desktop\OSResil\bldgModelsNoh';

        bldgID = '3S_MD_I'; % '3S_D_I';'3S_D_NI';'3S_MD_I';'3S_MD_NI';'6S_D_I';'6S_D_NI';'6S_MD_I';'6S_MD_NI';

        modelID = 'OpenSees2DModels\XDirectionFrameLines\Line_1\DynamicAnalysis';

        fileName = 'DefineColumnHingeMaterials2DModel.tcl';

        completeAdd = fullfile(baseFolder1, bldgID, modelID, fileName);

        commandText = sprintf('notepad++ %s', completeAdd);

        system(commandText)

    case '32.CopyAllMatFilesFromAnalysisOutput'    
        %%
        % baseFolder = pwd;

        dirToRead = 'P:\Resiliency\prak\ResilAnaOS_psb\Output\';
        dirToWrite = 'C:\Users\prak\Desktop\';

        zippedFileNameLIST = {'ID1310_v.01_FF';
            'ID1310_v.01_NF';
            'ID1610_v.01_FF';
            'ID1610_v.01_NF';
            'ID1910_v.01_FF';
            'ID1910_v.01_NF';};

        for k = 1:size(zippedFileNameLIST, 1)
            fprintf('Copying %i/%i...\n', k, size(zippedFileNameLIST, 1));
            zippedFileName = zippedFileNameLIST{k};
            analysisDir = sprintf('(%s)_(AllVar)_(0.00)_(clough)', zippedFileName);

            % if analysis dir exists, make a dir with same name in WriteDir
            cd(fullfile(dirToRead, analysisDir));
            mkdir(dirToWrite, analysisDir);

            % copy all emf, eps, fig, and mat files outside
            copyfile( '*.emf', fullfile(dirToWrite, analysisDir));
            copyfile( '*.eps', fullfile(dirToWrite, analysisDir));
            copyfile( '*.fig', fullfile(dirToWrite, analysisDir));
            copyfile( '*.mat', fullfile(dirToWrite, analysisDir));

            % also copy MatlabInformation and EQ_9991 directories from outside
            copyfile('MatlabInformation', fullfile(dirToWrite, analysisDir, 'MatlabInformation'));
            copyfile('EQ_9991', fullfile(dirToWrite, analysisDir, 'EQ_9991'));

            % search for all EQ directories
            eqDirPattern = sprintf('EQ_*');
            allEqDirInfo = dir(eqDirPattern);

            % Loop over all EQ directories
            for i = 1 : length(allEqDirInfo)
                cd(allEqDirInfo(i).name);

                % make the EQ-directory in Write directory
                mkdir(fullfile(dirToWrite, analysisDir, allEqDirInfo(i).name));

                % copy all mat files outside except for EQ_9991 (pushover) when a large needless file is saved
                if ~strcmp(allEqDirInfo(i).name, 'EQ_9991')
                    copyfile( '*.mat', fullfile(dirToWrite, analysisDir, allEqDirInfo(i).name));
                end

                % search for all Sa files
                saDirPattern = sprintf('Sa_*');
                allSaDirInfo = dir(saDirPattern);

                % Loop over all Sa directories
                for j = 1 : length(allSaDirInfo)
                    cd(allSaDirInfo(j).name);

                    % make the Sa-directory in EQ-directory
                    mkdir(fullfile(dirToWrite, analysisDir, allEqDirInfo(i).name, allSaDirInfo(j).name));

                    % copy all mat files outside (skip if there isn't one)
                    try
                        copyfile( '*.mat', fullfile(dirToWrite, analysisDir, allEqDirInfo(i).name, allSaDirInfo(j).name));
                    catch
                        warning('No .mat file in %s', fullfile(analysisDir, allEqDirInfo(i).name, allSaDirInfo(j).name));
                    end

                    cd .. % come out to EQ-dir
                end
                cd .. % come out to analysis-Dir
            end

            cd(dirToWrite); % come back home (not $HOME$. Haha!)
            zip(zippedFileName, fullfile(dirToWrite, analysisDir));
        end

    case '32a.CopyAllMatFilesFromAnalysisOutput_BRBGF'    
        %%
        % baseFolder = pwd;

        dirToRead = 'C:\BRB_local\Output\';
        dirToWrite = 'C:\Users\prak\OneDrive - University of California, Davis\FII_BRB_OpenSeesOutputsZip\';
%         dirToWrite = ['C:\Users\' , getenv('username') '\Desktop\'];

        zippedFileNameLIST = {'BRB_18story_v8Combined';};

        for k = 1:size(zippedFileNameLIST, 1)
            fprintf('Copying %i/%i...\n', k, size(zippedFileNameLIST, 1));
            zippedFileName = zippedFileNameLIST{k};
            analysisDir = sprintf('(%s)_(AllVar)_(0.00)_(clough)', zippedFileName);

            % if analysis dir exists, make a dir with same name in WriteDir
            cd(fullfile(dirToRead, analysisDir));
            mkdir(dirToWrite, analysisDir);

            % copy all emf, eps, fig, and mat files outside
            copyfile( '*.emf', fullfile(dirToWrite, analysisDir));
            copyfile( '*.eps', fullfile(dirToWrite, analysisDir));
            copyfile( '*.fig', fullfile(dirToWrite, analysisDir));
            copyfile( '*.mat', fullfile(dirToWrite, analysisDir));

            % also copy MatlabInformation and EQ_9991 directories from outside
            copyfile('MatlabInformation', fullfile(dirToWrite, analysisDir, 'MatlabInformation'));
            copyfile('EQ_9991', fullfile(dirToWrite, analysisDir, 'EQ_9991'));
            
            % search for all EQ directories
            eqDirPattern = sprintf('EQ_*');
            allEqDirInfo = dir(eqDirPattern);

            % Loop over all EQ directories
            for i = 1 : length(allEqDirInfo)
                cd(allEqDirInfo(i).name);

                % make the EQ-directory in Write directory
                mkdir(fullfile(dirToWrite, analysisDir, allEqDirInfo(i).name));

                % copy all mat files outside except for EQ_9991 (pushover) when a large needless file is saved
                if ~strcmp(allEqDirInfo(i).name, 'EQ_9991')
                    copyfile( '*.mat', fullfile(dirToWrite, analysisDir, allEqDirInfo(i).name));
                end

                % search for all Sa files
                saDirPattern = sprintf('Sa_*');
                allSaDirInfo = dir(saDirPattern);

                % Loop over all Sa directories
                for j = 1 : length(allSaDirInfo)
                    cd(allSaDirInfo(j).name);

                    % make the Sa-directory in EQ-directory
                    mkdir(fullfile(dirToWrite, analysisDir, allEqDirInfo(i).name, allSaDirInfo(j).name));

                    % copy all mat files outside (skip if there isn't one)
                    try
                        copyfile( '*.mat', fullfile(dirToWrite, analysisDir, allEqDirInfo(i).name, allSaDirInfo(j).name));
                    catch
                        warning('No .mat file in %s', fullfile(analysisDir, allEqDirInfo(i).name, allSaDirInfo(j).name));
                    end

                    cd .. % come out to EQ-dir
                end
                cd .. % come out to analysis-Dir
            end

            cd(dirToWrite); % come back home (not $HOME$. Haha!)
            zip(zippedFileName, fullfile(dirToWrite, analysisDir));
        end

    case '32b.CopyAllFigFilesFromMultipleDirectory_GMReport'
    %%
            dirToRead  = 'C:\Users\prak\Drive-UBCO\WRITING_ubco\Overleaf_Hazard_NRCan\Ch4ParamStudyResultsWithFigures';
            dirToWrite = 'C:\Users\prak\Drive-UBCO\WRITING_ubco\Overleaf_Hazard_NRCan\Ch4FigsRaw';
            
            % search for all directories
            cd(dirToRead); allDirInfo = dir;
            
            % Loop over all EQ directories
            for i = 3:length(allDirInfo) % first two are . and ..
                if allDirInfo(i).isdir == 0
                    continue
                else
                    caseName = allDirInfo(i).name; cd(caseName);
                    % search for all Summary directories
                    summaryDirPattern = sprintf('Summary_*');
                    summaryDirInfo = dir(summaryDirPattern);
                    cd(summaryDirInfo.name);
                    
                    figName = '1_AllRecordsSa.fig';  copyfile(figName, fullfile(dirToWrite, [caseName, figName]));
                    figName = '2_recordsMedian.fig'; copyfile(figName, fullfile(dirToWrite, [caseName, figName]));
                    figName = '3_recordsSigma.fig';  copyfile(figName, fullfile(dirToWrite, [caseName, figName]));
                    cd .. % come out to caseName directory
                    cd .. % come out to all dirToRead
                end
            end
    case '32c.FormatFigFilesInBulk_GMReport_Overleaf'
        %%
        dirToRead  = 'C:\Users\prak\Drive-UBCO\WRITING_ubco\Overleaf_Hazard_NRCan\Ch4FigsRaw';
        dirToWrite = 'C:\Users\prak\Drive-UBCO\WRITING_ubco\Overleaf_Hazard_NRCan\Ch4FigsEPS';

        % search for all directories
        cd(dirToRead);
        figFilePattern = sprintf('*.fig'); figFileInfo = dir(figFilePattern);

        % Loop over all fig files
        for i = 1:size(figFileInfo, 1) % [27, 30]
            figName = figFileInfo(i).name;  uiopen(figName, 1);

            [~,name,~] = fileparts(figName); exportName = sprintf('formatted_%s', name);
            fontFac = 2;
            formatGMRecordsFig_Case32c(exportName, fontFac, dirToWrite);
        end
    case '33.plotIDA_quantiles_mean_84_16'
%%
% plot mean 84%ile 16%ile IDA

cd C:\Users\aprak\Desktop\UBCO_AnalysisResults\

% cd '(ID_CLT_v7_RC_CLT)_(AllVar)_(0.00)_(clough)'; figNameToSave = 'raw_IDA_84_16_FF';
% cd '(ID_CLT_v7_RC_CLT_NF)_(AllVar)_(0.00)_(clough)'; figNameToSave = 'raw_IDA_84_16_NF';
cd '(ID_CLT_v7_RC_CLT_NBCC2020_Scaled)_(AllVar)_(0.00)_(clough)'; figNameToSave = 'raw_IDA_84_16_NBCC_Scaled';

dirToSaveFig = 'C:\Users\aprak\Drive_UBCO\WRITING_ubco\paper_work_RC_CLT_Ikenna';

% end of user inputs

% search for all EQ directories
eqDirPattern = sprintf('EQ_*');
allEqDirInfo = dir(eqDirPattern);

IDR_desc = 0:0.005:0.08; % for percentile IDAs
collIDRForCtrlComp = 0.12;

for i = 1:size(allEqDirInfo, 1)
    if strcmp(allEqDirInfo(i).name, 'EQ_9991'); allEqDirInfo(i) = []; break; end
end

% extract eventNums, useful for finding controling component
for i = 1:size(allEqDirInfo, 1)
    eqNum(i, 1) = str2double(allEqDirInfo(i).name(strfind(allEqDirInfo(i).name, '_') + 1:end));
end
eventNum = unique(floor(eqNum/10)); figure; 

% Loop over all EQ directories
for i = 1 : size(eventNum, 1)
    eqID_1 = eventNum(i, 1)*10 + 1;
    eqID_2 = eventNum(i, 1)*10 + 2;
    
    cd(sprintf('EQ_%i', eqID_1)); load('DATA_collapse_ProcessedIDADataForThisEQ.mat', 'saLevelsForIDAPlotPROCLIST', 'maxDriftRatioForPlotPROCLIST'); cd .. 
    sa1 = saLevelsForIDAPlotPROCLIST; idr1 = maxDriftRatioForPlotPROCLIST; sa1_8pc_MIDR = interp1(idr1, sa1, collIDRForCtrlComp, 'pchip');

    cd(sprintf('EQ_%i', eqID_2)); load('DATA_collapse_ProcessedIDADataForThisEQ.mat', 'saLevelsForIDAPlotPROCLIST', 'maxDriftRatioForPlotPROCLIST'); cd ..
    sa2 = saLevelsForIDAPlotPROCLIST; idr2 = maxDriftRatioForPlotPROCLIST; sa2_8pc_MIDR = interp1(idr2, sa2, collIDRForCtrlComp, 'pchip');
    % come out to analysis-Dir

    % use the controling component
    if sa1_8pc_MIDR < sa2_8pc_MIDR; idrCtrl = idr1; saCtrl = sa1; else; idrCtrl = idr2; saCtrl = sa2; end        

    Sa_desc(i, :) = interp1(idrCtrl, saCtrl, IDR_desc, 'pchip');
    plot(idrCtrl, saCtrl, 'LineWidth', 0.8, 'Color', [0.5 0.5 0.5]); hold on;
end

xlim([0 0.08]); ylim([0 3]);
Sa_desc_mean = quantile(Sa_desc, 0.50, 1); h1 = plot(IDR_desc, Sa_desc_mean, 'b-' , 'LineWidth', 3);
Sa_desc_84   = quantile(Sa_desc, 0.84, 1); h2 = plot(IDR_desc, Sa_desc_84  , 'b--', 'LineWidth', 3);
Sa_desc_16   = quantile(Sa_desc, 0.16, 1); h3 = plot(IDR_desc, Sa_desc_16  , 'b--', 'LineWidth', 3);

legh = legend([h1, h2], {'Mean', '84th/16th percentile'});
hx = xlabel('IDR_{max}'); hy = ylabel('Sa_{geoMean}(1.17 s)');

[~, a, ~] = fileparts(pwd); title(strrep(a, '_', '.'));

cd(dirToSaveFig); hgsave(figNameToSave);

   case '33a.plotIDA_quantiles_mean_84_16_BRBGF'
%%
% plot mean 84%ile 16%ile IDA

cd 'C:\BRB_local\Output\(BRB_18story_v8Combined)_(AllVar)_(0.00)_(clough)'; 

figNameToSave = 'raw_IDA_84_16_Sa_1p6_NBCC_Scaled';
dirToSaveFig = 'C:\Users\prak\Drive-UBCO\WRITING_ubco\paper_work_ASCE_BRB\figures\IDA_CDF';

% end of user inputs

% search for all EQ directories
eqDirPattern = sprintf('EQ_*');
allEqDirInfo = dir(eqDirPattern);

IDR_desc = 0:0.005:0.08; % for percentile IDAs
collIDRForCtrlComp = 0.06;

for i = 1:size(allEqDirInfo, 1)
    if strcmp(allEqDirInfo(i).name, 'EQ_9991'); allEqDirInfo(i) = []; break; end
end

% extract eventNums, useful for finding controling component
for i = 1:size(allEqDirInfo, 1)
    eqNum(i, 1) = str2double(allEqDirInfo(i).name(strfind(allEqDirInfo(i).name, '_') + 1:end));
end
eventNum = unique(floor(eqNum/10)); figure; 

% Loop over all EQ directories
for i = 1 : size(eventNum, 1)
    eqID_1 = eventNum(i, 1)*10 + 1;
    eqID_2 = eventNum(i, 1)*10 + 2;
    
    cd(sprintf('EQ_%i', eqID_1)); load('DATA_collapse_ProcessedIDADataForThisEQ.mat', 'saLevelsForIDAPlotPROCLIST', 'maxDriftRatioForPlotPROCLIST'); cd .. 
    sa1 = saLevelsForIDAPlotPROCLIST; idr1 = maxDriftRatioForPlotPROCLIST; 
    if sa1(end) ~= 100 sa1 = [sa1, 100]; idr1 = [idr1, 100]; end
    sa1_8pc_MIDR = interp1(idr1, sa1, collIDRForCtrlComp, 'pchip');

    cd(sprintf('EQ_%i', eqID_2)); load('DATA_collapse_ProcessedIDADataForThisEQ.mat', 'saLevelsForIDAPlotPROCLIST', 'maxDriftRatioForPlotPROCLIST'); cd ..
    sa2 = saLevelsForIDAPlotPROCLIST; idr2 = maxDriftRatioForPlotPROCLIST; 
    if sa2(end) ~= 100 sa2 = [sa2, 100]; idr2 = [idr2, 100]; end
    sa2_8pc_MIDR = interp1(idr2, sa2, collIDRForCtrlComp, 'pchip');
    % come out to analysis-Dir

    % use the controling component
    if sa1_8pc_MIDR < sa2_8pc_MIDR; idrCtrl = idr1; saCtrl = sa1; else; idrCtrl = idr2; saCtrl = sa2; end        

    Sa_desc(i, :) = interp1(idrCtrl, saCtrl, IDR_desc, 'pchip');
    plot(idrCtrl*100, saCtrl, 'LineWidth', 0.8, 'Color', [0.5 0.5 0.5]); hold on;
end

grid on; xlim([0 5]); ylim([0 3]);

Sa_desc_mean = quantile(Sa_desc, 0.50, 1); h1 = plot(IDR_desc*100, Sa_desc_mean, 'b-' , 'LineWidth', 3);
Sa_desc_84   = quantile(Sa_desc, 0.84, 1); h2 = plot(IDR_desc*100, Sa_desc_84  , 'b--', 'LineWidth', 3);
Sa_desc_16   = quantile(Sa_desc, 0.16, 1); h3 = plot(IDR_desc*100, Sa_desc_16  , 'b--', 'LineWidth', 3);

legh = legend([h1, h2], {'Mean', '84th/16th percentile'});
hx = xlabel('IDR_{max} (%)'); hy = ylabel('Sa_{geoMean}(1.60 s)');

[~, a, ~] = fileparts(pwd); title(strrep(a, '_', '.'));

cd(dirToSaveFig); hgsave(figNameToSave);

    case '33b.postProcIDAForGlulamColCapacity_quantiles_mean_84_16_BRBGF'
%%
cd 'C:\BRB_local\Output\(BRB_6story_v1Combined)_(AllVar)_(0.00)_(clough)'; 
figNameToSave = 'raw_IDA_84_16_Sa_0p58_NBCC_Scaled_postProc';
dirToSaveFig = 'C:\Users\prak\Drive-UBCO\WRITING_ubco\Overleaf_BRB_perfAssmt\Nst6_IDA_CDF';

% load mat file with post-processed glulam column data. (generated using Case 40)
load('C:\BRB_local\Output\(BRB_6story_v1Combined)_(AllVar)_(0.00)_(clough)\GlulamColData_ALL.mat', 'allGlulamColLocalForcePVData', 'saValForGlulamCapacity');
for i = 1:length(allGlulamColLocalForcePVData)
    eqIDinGlulamColData(i, 1) = allGlulamColLocalForcePVData(1, i).eqID;
    saAllGlulamCapacity(i, 1) = min(saValForGlulamCapacity(i, :)); % min of C, T, V
end

% end of user inputs

% search for all EQ directories
eqDirPattern = sprintf('EQ_*');
allEqDirInfo = dir(eqDirPattern);

IDR_desc = 0:0.005:0.08; % for percentile IDAs
collIDRForCtrlComp = 0.06; % this is used to decide which component in controling and the %ile plots are decided accordingly

for i = 1:size(allEqDirInfo, 1)
    if strcmp(allEqDirInfo(i).name, 'EQ_9991'); allEqDirInfo(i) = []; break; end
end

% extract eventNums, useful for finding controling component
for i = 1:size(allEqDirInfo, 1)
    eqNum(i, 1) = str2double(allEqDirInfo(i).name(strfind(allEqDirInfo(i).name, '_') + 1:end));
end
eventNum = unique(floor(eqNum/10)); figure; 

% Loop over all EQ directories
for i = 1 : size(eventNum, 1)
    eqID_1 = eventNum(i, 1)*10 + 1;
    eqID_2 = eventNum(i, 1)*10 + 2;
    
% process first component
    cd(sprintf('EQ_%i', eqID_1)); load('DATA_collapse_ProcessedIDADataForThisEQ.mat', 'saLevelsForIDAPlotPROCLIST', 'maxDriftRatioForPlotPROCLIST'); cd .. 
    sa1 = saLevelsForIDAPlotPROCLIST; idr1 = maxDriftRatioForPlotPROCLIST; 
    if sa1(end) ~= 100 sa1 = [sa1, 100]; idr1 = [idr1, 100]; end
    
    % we now check if Sa values are more than post-processed Sa for Glulam Capacity
    currentSaBasedOnGlulamCapacity1 = saAllGlulamCapacity(eqIDinGlulamColData == eqID_1);

    % in this piece, we interpolate idr for sa value where glulam reached its capacity
    % and then insert the corresponding sa and idr value in the plot
    X = sa1; Y = idr1;
    xq = currentSaBasedOnGlulamCapacity1; 
    ix = find(X >= xq, 1); % or <=
    if ~isempty(ix)
        yq = interp1([X(ix-1), X(ix)], [Y(ix-1), Y(ix)], xq, 'linear');
        sa1 = [sa1(1:ix-1) xq sa1(ix:end)];
        idr1 = [idr1(1:ix-1) yq idr1(ix:end)];
        idr1(sa1 > xq+1e-4) = 100; % floating point comparison
    end

    X = idr1; Y = sa1; xq = collIDRForCtrlComp; 
    ix = find(X >= xq, 1); % or <=
    yq = interp1([X(ix-1), X(ix)], [Y(ix-1), Y(ix)], xq, 'linear');
    sa1_8pc_MIDR = yq;

% process second component
    cd(sprintf('EQ_%i', eqID_2)); load('DATA_collapse_ProcessedIDADataForThisEQ.mat', 'saLevelsForIDAPlotPROCLIST', 'maxDriftRatioForPlotPROCLIST'); cd ..
    sa2 = saLevelsForIDAPlotPROCLIST; idr2 = maxDriftRatioForPlotPROCLIST; 
    if sa2(end) ~= 100 sa2 = [sa2, 100]; idr2 = [idr2, 100]; end

    % we now check if Sa values are more than post-processed Sa for Glulam Capacity
    currentSaBasedOnGlulamCapacity2 = saAllGlulamCapacity(eqIDinGlulamColData == eqID_2);

    % in this piece, we interpolate idr for sa value where glulam reached its capacity
    % and then insert the corresponding sa and idr value in the plot
    X = sa2; Y = idr2;
    xq = currentSaBasedOnGlulamCapacity2; 
    ix = find(X >= xq, 1); % or <=
    if ~isempty(ix)
        yq = interp1([X(ix-1), X(ix)], [Y(ix-1), Y(ix)], xq, 'linear');
        sa2 = [sa2(1:ix-1) xq sa2(ix:end)];
        idr2 = [idr2(1:ix-1) yq idr2(ix:end)];
        idr2(sa2 > xq+1e-4) = 100; % floating point comparison
    end

    X = idr2; Y = sa2; xq = collIDRForCtrlComp; 
    ix = find(X >= xq, 1); % or <=
    yq = interp1([X(ix-1), X(ix)], [Y(ix-1), Y(ix)], xq, 'linear');
    sa2_8pc_MIDR = yq;
    % come out to analysis-Dir

    % use the controling component
    if sa1_8pc_MIDR < sa2_8pc_MIDR; idrCtrl = idr1; saCtrl = sa1; else; idrCtrl = idr2; saCtrl = sa2; end        

    X = idrCtrl; Y = saCtrl; 
    Sa_desc(i, 1) = 0; % first point is zero
    for j = 2:length(IDR_desc)
        xq = IDR_desc(j); 
        ix = find(X >= xq, 1); % or <=
        yq = interp1([X(ix-1), X(ix)], [Y(ix-1), Y(ix)], xq, 'linear');
        Sa_desc(i, j) = yq;
    end
%     Sa_desc(i, :) = interp1(idrCtrl, saCtrl, IDR_desc, 'pchip');
    plot(idrCtrl*100, saCtrl, 'LineWidth', 0.8, 'Color', [0.5 0.5 0.5]); hold on;
end

grid on; xlim([0 5]); ylim([0 4.5]);

Sa_desc_mean = quantile(Sa_desc, 0.50, 1); h1 = plot(IDR_desc*100, Sa_desc_mean, 'b-' , 'LineWidth', 3);
Sa_desc_84   = quantile(Sa_desc, 0.84, 1); h2 = plot(IDR_desc*100, Sa_desc_84  , 'b--', 'LineWidth', 3);
Sa_desc_16   = quantile(Sa_desc, 0.16, 1); h3 = plot(IDR_desc*100, Sa_desc_16  , 'b--', 'LineWidth', 3);

legh = legend([h1, h2], {'Mean', '84th/16th percentile'});
hx = xlabel('IDR_{max} (%)'); hy = ylabel('Sa_{geoMean}(0.58 s)');

[~, a, ~] = fileparts(pwd); title(strrep(a, '_', '.'));

cd(dirToSaveFig); hgsave(figNameToSave);    
    
    case '34.PlotResidualDriftVsMaxIDR'
        %%
        % baseFolder = pwd;

outpDir = 'C:\Users\aprak\Desktop\UBCO_AnalysisResults\';

analysisDirLIST = {'(ID_CLT_v7_RC_CLT_NBCC2020_Scaled)_(AllVar)_(0.00)_(clough)';
    '(ID_CLT_v7_RC_CLT_flag_NBCC2020_Scaled)_(AllVar)_(0.00)_(clough)';
    '(ID_CLT_v7_RC_CLT_flag_0p6_NBCC2020_Scaled)_(AllVar)_(0.00)_(clough)';};

colorLIST =  {'k', 'r', 'b'};
markerLIST = {'o', 's', 'd'};

for k = 1:size(analysisDirLIST, 1)
    fprintf('Reading %i/%i...\n', k, size(analysisDirLIST, 1));
    analysisDir = analysisDirLIST{k};

    % if analysis dir exists, make a dir with same name in WriteDir
    cd(fullfile(outpDir, analysisDir));

    % search for all EQ directories
    eqDirPattern = sprintf('EQ_*');
    allEqDirInfo = dir(eqDirPattern);

    count = 0; 
    % Loop over all EQ directories
    for i = 1 : length(allEqDirInfo)
        cd(allEqDirInfo(i).name);

        % copy all mat files outside except for EQ_9991 (pushover) when a large needless file is saved
        if strcmp(allEqDirInfo(i).name, 'EQ_9991') || strcmp(allEqDirInfo(i).name, 'EQ_9992')
            continue;
        end

        % search for all Sa files
        saDirPattern = sprintf('Sa_*');
        allSaDirInfo = dir(saDirPattern);

        % Loop over all Sa directories
        for j = 1 : length(allSaDirInfo)
            cd(allSaDirInfo(j).name);

            % copy all mat files outside (skip if there isn't one)
            try
                load('DATA_reducedSensDataForThisSingleRun', 'roofDriftRatioToSave');
                count = count + 1;
                MIDR_RIDR_AllData{k}(count, :) = [roofDriftRatioToSave.AbsMax, abs(roofDriftRatioToSave.Residual)];
            catch
                warning('No .mat file in %s', fullfile(analysisDir));
            end

            cd .. % come out to EQ-dir
        end
        cd .. % come out to analysis-Dir
    end
end

% plotting in a different loop to avoid analyzing repeatedly % close all;
RIDR_threshold = 0.001;
for k = 1:size(analysisDirLIST, 1)
    MIDR = MIDR_RIDR_AllData{k}(:, 1); RIDR = MIDR_RIDR_AllData{k}(:, 2);
    
    % remove values below the threshold
    MIDR(RIDR < RIDR_threshold) = []; RIDR(RIDR < RIDR_threshold) = []; 
%     figure; 
    h(k) = plot(MIDR, RIDR, [colorLIST{k} markerLIST{k}]); hold on;

    p = polyfit(MIDR, RIDR, 1); px = [min(MIDR) max(MIDR)]; py = polyval(p, px);
    plot(px, py, 'Color', colorLIST{k}, 'LineWidth', 2);

    clearvars MIDR RIDR; % excuse 'em for the next plot
end

xlim([0 0.07]); ylim([0 0.07]); 

str1 = '$IDR_{max}$';  str2 = '$IDR_{res}$';
strForLegend = {'Slit' 'Flag-Shaped, \beta_F = 0.8' 'Flag-Shaped, \beta_F = 0.6'};

hx = xlabel(str1, 'Interpreter', 'latex'); hy = ylabel(str2, 'Interpreter', 'latex');
legh = legend(h, strForLegend); % htitle = title(str3); 
set(hx, 'FontSize', 16); set(hy, 'FontSize', 16);
set(legh,'FontSize', 11, 'Location', 'northwest');
set(gca, 'FontSize', 14); 
% set(htitle, 'FontSize', titleFontSize);

% for better formated figure, see \Drive_UBCO\WRITING_ubco\paper_sub_RC_CLT_Ikenna\Figs

   case '34a.PlotResidualDriftVsMaxIDR_BRBGF'
        %%
        % baseFolder = pwd;

outpDir = 'C:\BRB_local\Output\';

analysisDirLIST = {'(BRB_18story_v7Combined)_(AllVar)_(0.00)_(clough)'};

colorLIST =  {'k', 'r', 'b'};
markerLIST = {'o', 's', 'd'};

for k = 1:size(analysisDirLIST, 1)
    fprintf('Reading %i/%i...\n', k, size(analysisDirLIST, 1));
    analysisDir = analysisDirLIST{k};

    % if analysis dir exists, make a dir with same name in WriteDir
    cd(fullfile(outpDir, analysisDir));

    % search for all EQ directories
    eqDirPattern = sprintf('EQ_*');
    allEqDirInfo = dir(eqDirPattern);

    count = 0; 
    % Loop over all EQ directories
    for i = 1 : length(allEqDirInfo)
        cd(allEqDirInfo(i).name);

        % copy all mat files outside except for EQ_9991 (pushover) when a large needless file is saved
        if strcmp(allEqDirInfo(i).name, 'EQ_9991') || strcmp(allEqDirInfo(i).name, 'EQ_9992')
            continue;
        end

        % search for all Sa files
        saDirPattern = sprintf('Sa_*');
        allSaDirInfo = dir(saDirPattern);

        % Loop over all Sa directories
        for j = 1 : length(allSaDirInfo)
            cd(allSaDirInfo(j).name);

            % copy all mat files outside (skip if there isn't one)
            try
                load('DATA_reducedSensDataForThisSingleRun', 'roofDriftRatioToSave');
                count = count + 1;
                MIDR_RIDR_AllData{k}(count, :) = [roofDriftRatioToSave.AbsMax, abs(roofDriftRatioToSave.Residual)];
            catch
                warning('No .mat file in %s', fullfile(analysisDir));
            end

            cd .. % come out to EQ-dir
        end
        cd .. % come out to analysis-Dir
    end
end

% plotting in a different loop to avoid analyzing repeatedly % close all;
RIDR_threshold = 0.001;
for k = 1:size(analysisDirLIST, 1)
    MIDR = MIDR_RIDR_AllData{k}(:, 1); RIDR = MIDR_RIDR_AllData{k}(:, 2);
    
    % remove values below the threshold
    MIDR(RIDR < RIDR_threshold) = []; RIDR(RIDR < RIDR_threshold) = []; 
%     figure; 
    h(k) = plot(MIDR, RIDR, [colorLIST{k} markerLIST{k}]); hold on;

    p = polyfit(MIDR, RIDR, 1); px = [min(MIDR) max(MIDR)]; py = polyval(p, px);
%     plot(px, py, 'Color', colorLIST{k}, 'LineWidth', 2);
    plot([0 1], [0 1], 'k--', 'LineWidth', 0.8);

    clearvars MIDR RIDR; % excuse 'em for the next plot
end

xlim([0 0.04]); ylim([0 0.04]); 

str1 = '$IDR_{max}$';  str2 = '$IDR_{res}$';
strForLegend = {'BRBGF' 'Flag-Shaped, \beta_F = 0.8' 'Flag-Shaped, \beta_F = 0.6'};

hx = xlabel(str1, 'Interpreter', 'latex'); hy = ylabel(str2, 'Interpreter', 'latex');
% legh = legend(h, strForLegend); % htitle = title(str3); 
set(hx, 'FontSize', 16); set(hy, 'FontSize', 16);
% set(legh,'FontSize', 11, 'Location', 'northwest');
set(gca, 'FontSize', 14); 
% set(htitle, 'FontSize', titleFontSize);

% for better formated figure, see \Drive_UBCO\WRITING_ubco\paper_sub_RC_CLT_Ikenna\Figs

    case '35.PlotPeakFloorAccnVsSa_IDA_Fragility'
        %%
        % baseFolder = pwd;

outpDir = 'C:\Users\aprak\Desktop\UBCO_AnalysisResults\Results_Spectra_small';
modelNameLIST = {'ID1310_v.01_FF';
%                 'ID1310_v.01_NF';
                'ID1610_v.01_FF';
%                 'ID1610_v.01_NF';
                'ID1910_v.01_FF';
%                 'ID1910_v.01_NF';
                };
% PFA_threshold_Frag = [1, 1.17, 1.3, 1.58, 1.82, 2.25, 2.6]; % g
PFA_threshold_Frag = [1.17, 1.58, 1.82, 1.5, 2.6, 1.5, 2.25, 1.1, 2.4, 1.2, 2.4]; % g
figDir = 'C:\Users\aprak\Drive_UBCO\WRITING_ubco\paper_sub_ResPaper_Spectra\Figures_reformat_resave\IDA_MaxPFA_R2_format';

colorLIST =  {'b', 'b', 'b', 'b', 'b', 'b'};
% markerLIST = {'o', 's', 'd'};
markerLIST = {'-o', '-o', '-o', '-o', '-o', '-o'};

%% (1/3) extract Data
for k = 1:size(modelNameLIST, 1)
    fprintf('Reading %i/%i...\n', k, size(modelNameLIST, 1));
    analysisDir = sprintf('(%s)_(AllVar)_(0.00)_(clough)', modelNameLIST{k});

    % if analysis dir exists, make a dir with same name in WriteDir
    cd(fullfile(outpDir, analysisDir));

    % search for all EQ directories
    eqDirPattern = sprintf('EQ_*'); eqIndex = 0;
    allEqDirInfo = dir(eqDirPattern);

    % Loop over all EQ directories
    for i = 1 : length(allEqDirInfo)
        cd(allEqDirInfo(i).name);

        % copy all mat files outside except for EQ_9991 (pushover) when a large needless file is saved
        if strcmp(allEqDirInfo(i).name, 'EQ_9991') || strcmp(allEqDirInfo(i).name, 'EQ_9992')
            continue;
        else
            eqIndex = eqIndex + 1; count = 0; % reset the Sa-count
            eqStr = allEqDirInfo(i).name;
            eqNumberLISTAllBldgs{k}(eqIndex) = str2num(eqStr(4:end));
        end
        
        % search for all Sa files
        saDirPattern = sprintf('Sa_*');
        allSaDirInfo = dir(saDirPattern);

        % Loop over all Sa directories
        for j = 1:length(allSaDirInfo)
            cd(allSaDirInfo(j).name);

            % copy all mat files outside (skip if there isn't one)
            try
                load('DATA_reducedSensDataForThisSingleRun', 'saValue', 'floorAccelToSave', 'periodUsedForScalingGroundMotionsFromMatlab');
                count = count + 1;
                for p = 2:size(floorAccelToSave, 2);  PFA_temp(p) = floorAccelToSave{1, p}.absAbsMaxUnfiltered; end

                Sa_PFA_AllData{k}{eqIndex}(count, :) = [saValue, max(PFA_temp)];
                periodList(k) = periodUsedForScalingGroundMotionsFromMatlab;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% (10-17-22, psb) Note that taking maximum of PFA on each story distorts the
%%% nonstructural fragility, which must be considered for each floor. I am
%%% only doing this to get an idea of the fragility params for MaxPFA.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            catch
%                 warning('No .mat file in %s', fullfile(analysisDir));
            end

            cd .. % come out to EQ-dir
        end
        cd .. % come out to analysis-Dir
    end
end

%% (2/3) plotting in a different loop to avoid analyzing repeatedly % close all;
PFA_tooHigh_threshold_in_g = 10; 
for k = 1:size(modelNameLIST, 1)
    figure(100+k); % All components for IDA for MaxPFA
    for eqId = 1:size(Sa_PFA_AllData{k}, 2)
        Sa = Sa_PFA_AllData{k}{eqId}(:, 1); MaxPFA = Sa_PFA_AllData{k}{eqId}(:, 2);
        MaxPFA = MaxPFA./9810; % from mm/s2 to g

        % remove values over the threshold
        Sa(MaxPFA > PFA_tooHigh_threshold_in_g) = []; MaxPFA(MaxPFA > PFA_tooHigh_threshold_in_g) = [];

        % update Sa_PFA_AllData by removing Sa PFA for exorbitant PFAs
        Sa_PFA_AllData{k}{eqId} = [Sa, MaxPFA];

        %     figure;
        h(k) = plot([0; MaxPFA], [0; Sa], [colorLIST{k} markerLIST{k}]); hold on; grid on;
    end

    %     p = polyfit(MIDR, RIDR, 1); px = [min(MIDR) max(MIDR)]; py = polyval(p, px);
    %     plot(px, py, 'Color', colorLIST{k}, 'LineWidth', 2);

    %     clearvars Sa MaxPFA; % excuse 'em for the next plot
    xlim([0 5]); ylim([0 5]);

    str1 = '$PFA_{max}$ (g)'; str2 = sprintf('$Sa_{geoM}(T_1=%.2f)$ (g)', periodList(k));
    % strForLegend = {'Slit' 'Flag-Shaped, \beta_F = 0.8' 'Flag-Shaped, \beta_F = 0.6'};

    hx = xlabel(str1, 'Interpreter', 'latex'); hy = ylabel(str2, 'Interpreter', 'latex');
    % legh = legend(h, strForLegend); % htitle = title(str3);
    set(hx, 'FontSize', 16); set(hy, 'FontSize', 16);
    % set(legh,'FontSize', 11, 'Location', 'northwest');
    set(gca, 'FontSize', 14);
    % set(htitle, 'FontSize', titleFontSize);

    exportName = sprintf('IDA_PFA_%s', strrep(modelNameLIST{k}, '.', '_')); 
    extensions = {'fig', 'epsc'};
    for p = 1:length(extensions)
    	cd(figDir) ; saveas(gcf, exportName, extensions{p})
    end
end

%% (3/3) calculated frag params for MaxPFA 
for k = 1:size(modelNameLIST, 1) % for each building
    eqNumberLIST = eqNumberLISTAllBldgs{k};
    Sa_th = zeros(1, length(eqNumberLIST)); % for multiple buildings, it is crucial to initialize this variable

    for PFA_th_Index = 1:size(PFA_threshold_Frag, 2) % for each threshold
        PFA_th = PFA_threshold_Frag(1, PFA_th_Index);
        for eqId = 1:size(eqNumberLIST, 2) % iterate through all eqs to calculate frag
            Sa = Sa_PFA_AllData{k}{eqId}(:, 1); MaxPFA = Sa_PFA_AllData{k}{eqId}(:, 2);
            % interpolate for possibly non-monotonic data
            ix = find(MaxPFA >= PFA_th, 1); % or <=
            if ~isempty(ix)
                Sa_th(eqId) = interp1([MaxPFA(ix-1), MaxPFA(ix)], [Sa(ix-1), Sa(ix)], PFA_th, 'pchip');
            else
                Sa_th(eqId) = Sa(end);
            end
        end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% frag params calculation block begins 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% (unless debugging, close your eyes and move on to the end of this block)
    Sa_th_Ctrl = zeros(1, length(eqNumberLIST)/2); % for multiple buildings, it is crucial to initialize this variable
    
    for gmIndex = 1:length(eqNumberLIST)/2
        saT_CompOne = Sa_th(gmIndex * 2 - 1);
        saT_CompTwo = Sa_th(gmIndex * 2);

        Sa_th_Ctrl(gmIndex) = min(saT_CompOne, saT_CompTwo);
    end

% variables to store as a matrix in the .mat file
    % Do collapse statistics - for all components
    fragParamMuALL_mat(k, PFA_th_Index) = exp(mean(log(Sa_th)));
    fragParamBetaALL_mat(k, PFA_th_Index) = std(log(Sa_th));

    % Do collapse statistics - for Ctrlling components
    fragParamMuCtrl_mat(k, PFA_th_Index) = exp(mean(log(Sa_th_Ctrl)));
    fragParamBetaCtrl_mat(k, PFA_th_Index) = std(log(Sa_th_Ctrl));

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% frag params calculation block ends 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    end
end
fprintf('Buildings processed are: \n');
disp(modelNameLIST);
T = table(PFA_threshold_Frag', fragParamMuCtrl_mat', fragParamBetaCtrl_mat');
T.Properties.VariableNames = {'PFA (g)', 'mu_Ctrl (g)', 'betaRTR_Ctrl'};
disp(T);

%% (3/4) Plot controling component IDA for MaxPFA
for k = 1:size(modelNameLIST, 1) % for each building
    figure(200 + k); % control component of IDA for MaxPFA
    eqNumberLIST = eqNumberLISTAllBldgs{k};

    for gmIndex = 1:length(eqNumberLIST)/2
        ctrlEqId = gmIndex * 2 - 1; % default; update if it has higher Sa at the end
        if Sa_PFA_AllData{k}{gmIndex * 2 - 1}(end, 2) > Sa_PFA_AllData{k}{gmIndex * 2}(end, 2)
            ctrlEqId = gmIndex * 2;
        end
        Sa_ctrl = Sa_PFA_AllData{k}{ctrlEqId}(:, 1); MaxPFA_ctrl = Sa_PFA_AllData{k}{ctrlEqId}(:, 2);
        plot([0; MaxPFA_ctrl], [0; Sa_ctrl], [colorLIST{k} markerLIST{k}]); hold on; grid on;
    end

        xlim([0 4]); 
        switch k
            case {1 2}; ylim([0 4.0]);  case {3 4}; ylim([0 2.0]);   case {5 6}; ylim([0 1.0]);  
        end

        str1 = '$PFA_{max}$ (g)'; str2 = sprintf('$Sa_{geoM}(T_1=%.2f)$ (g)', periodList(k));
        hx = xlabel(str1, 'Interpreter', 'latex'); hy = ylabel(str2, 'Interpreter', 'latex');
        set(hx, 'FontSize', 16); set(hy, 'FontSize', 16);
        set(gca, 'FontSize', 14);
        exportName = sprintf('IDA_PFA_Ctrl_%s', strrep(modelNameLIST{k}, '.', '_'));
        extensions = {'fig', 'epsc'};
        for p = 1:length(extensions)
        	cd(figDir) ; saveas(gcf, exportName, extensions{p})
        end
end


    case '36.PlotStoryWiseAxialShearMomentAtTheEndOfPushover'
        %%
cd('C:\BRB_local\Output\(BRB_18story_v4a_PlayingWithGlulamSize)_(AllVar)_(0.00)_(clough)\EQ_9991\Sa_0.00\Elements\EleGlobalTH')
% to plot multiple columns, enter them in different rows; for a single, keep one row
% eleNumbers = 20101:100:21801; 
eleNumbers = [20101:100:21801; 20102:100:21802; 20103:100:21803; 20104:100:21804];

colIndexForShearAxialMoment = [4, 5, 6];
plotWhat = 1:3; % 1-shear, 2-axial, 3-moment

numCols = size(eleNumbers, 1); numStories = size(eleNumbers, 2);
forcesToPlot = zeros(1, numStories);

for plottingForceIndex = 1:length(plotWhat)
    colIndexInEleForceToPlot = colIndexForShearAxialMoment(plotWhat(plottingForceIndex));

    figure(plottingForceIndex); 
    for colID = 1:numCols
        for i = 1:numStories 
            p = eleNumbers(colID, i);
            fileName = sprintf("THEleGlobal_%i.out", p);
            eleForces = dlmread(fileName);
            forcesToPlot(i) = eleForces(end, colIndexInEleForceToPlot); % at the end of pushover
        end
        plot(forcesToPlot, 1:numStories); hold on; grid on;
    end
strx = 'Column Force (kN-mm-sec units)'; stry = 'Story, N_{st}'; 
nameOfPlot = 'N_{st} = 18, EQ: Pushover End, Sa(X.X s) = X.XXg, EleTag: Left most grid columns';
hx = xlabel(strx); hy = ylabel(stry); grid on; htitle = title(nameOfPlot); %legh = legend(legendLIST, 'Location','southeast');
end

% Graph and Axes titles
% legendLIST = {
%     'Force-Defo of BRB-1'
%     'Force-Defo of BRB-2'
%     };  % Used only for legend entries; 'Force-Defo of Dowel in left BRBF'
% xlim([-300 300]); ylim([-2500 2500]);
    
    case '37.Add100AtTheEndOfIDA'
%%    
    cd 'C:\BRB_local\Output\(BRB_18story_v8Combined)_(AllVar)_(0.00)_(clough)_adding100ToIDA'
    eqNumberLIST_forProcessing_SetNBCC2020_Sca_1p60 = [160011	160012	160021	160022	160031	160032	160041	160042	160051	160052	160061	160062	160071	160072	160081	160082	160091	160092	160101	160102	160111	160112	160121	160122	160131	160132	160141	160142	160151	160152	160161	160162	160171	160172	160181	160182	160191	160192	160201	160202	160211	160212	160221	160222	160231	160232	160241	160242	160251	160252	160261	160262	160271	160272	160281	160282	160291	160292	160301	160302];
    numEq = size(eqNumberLIST_forProcessing_SetNBCC2020_Sca_1p60, 2);
    
    fileName = 'DATA_collapseIDAPlotDataForThisEQ.mat';
    for i=1:numEq
        eqNum = eqNumberLIST_forProcessing_SetNBCC2020_Sca_1p60(1, i);
        EQdir = sprintf('EQ_%i', eqNum);
        cd(EQdir);
        load(fileName, 'saLevelsForIDAPlotLIST', 'maxDriftRatioForPlotLIST');
        if saLevelsForIDAPlotLIST(end) ~= 100
            saLevelsForIDAPlotLIST = [saLevelsForIDAPlotLIST, 100];
            maxDriftRatioForPlotLIST = [maxDriftRatioForPlotLIST, 100];
% Do NOT update the .mat file, other variables such as isConverged, isCollapsed are different sized and IDA plotting
% in full driver will STOP working. Instead, use this piece to update the plot of IDA wherever required.
%         IMP NOTE ABOVE. save(fileName, 'saLevelsForIDAPlotLIST', 'maxDriftRatioForPlotLIST', "-append"); % update
        end
        cd ..
    end
    
    case '38.saveAndPlotResidualDriftRatio_IDA'
%%
% WARNING: This script adds DATA filles DATA_ResIDR_DataForThisEQ in each EQ directory 

cd('C:\BRB_local\Output\(BRB_18story_v8Combined)_(AllVar)_(0.00)_(clough)');
eqNumberLIST = [160011	160012	160021	160022	160031	160032	160041	160042	160051	160052	160061	160062	160071	160072	160081	160082	160091	160092	160101	160102	160111	160112	160121	160122	160131	160132	160141	160142	160151	160152	160161	160162	160171	160172	160181	160182	160191	160192	160201	160202	160211	160212	160221	160222	160231	160232	160241	160242	160251	160252	160261	160262	160271	160272	160281	160282	160291	160292	160301	160302];

figure; 

% Loop over all EQ directories
for i = 1 : length(eqNumberLIST)
    eqNum = eqNumberLIST(i);
    eqDirName = sprintf('EQ_%i', eqNum);
    cd(eqDirName);
    load('DATA_collapse_ProcessedIDADataForThisEQ', 'saLevelsForIDAPlotPROCLIST');
    
    maxResDriftRatioForPlotPROCLIST = zeros(size(saLevelsForIDAPlotPROCLIST)); % reset for each EQ
    
    % Loop over all Sa directories
    for j = 2:length(saLevelsForIDAPlotPROCLIST)
        saVal = saLevelsForIDAPlotPROCLIST(1, j);
        if saVal == 100
            maxResDriftRatioForPlotPROCLIST(1, j) = 100;
        else
            saDirName = sprintf('Sa_%.2f', saVal);
            cd(saDirName);
            load('DATA_reducedSensDataForThisSingleRun', 'storyDriftRatioToSave');
            for floorNum = 1:size(storyDriftRatioToSave, 2)
                resDriftEachFloor(floorNum) = storyDriftRatioToSave{1, floorNum}.Residual;
            end
            maxResDriftRatioForPlotPROCLIST(1, j) = max(abs(resDriftEachFloor));
            cd .. % come out to EQ-dir
        end
    end
    save('DATA_ResIDR_DataForThisEQ', 'analysisType', 'maxResDriftRatioForPlotPROCLIST', 'saLevelsForIDAPlotPROCLIST');
    cd .. % come out to analysis-Dir

    % remove values below the threshold
    plot([0, maxResDriftRatioForPlotPROCLIST], [0, saLevelsForIDAPlotPROCLIST], 'bo-', 'LineWidth', 1); hold on; grid on;
end
hx = xlabel('$RDR_{\max}$', 'Interpreter', 'latex'); hy = ylabel('$Sa(T_1)_{geoMean}$ (g)', 'Interpreter', 'latex');  
xlim([0 0.02]); ylim([0 5]); 
psb_FigureFormatScript;

%%%%%%%%%% END OF Residual drift ratio plot code

exportName = sprintf('RIDR_AllComp_SaGeoMean');
% Not calculating for controling component at this point.

extensions = {'fig', 'epsc', 'png', 'jpeg', 'meta'};
for k = 1:length(extensions)
	saveas(gcf, exportName, extensions{k})
end
        
    case '39.PlotStoryWise_MaxIDR_ResIDR_PFA_atMCE_tiledLayout_BRBGF'
%%
cd('C:\BRB_local\Output\(BRB_18story_v8Combined)_(AllVar)_(0.00)_(clough)')
eqNumberLIST = [160011	160012	160021	160022	160031	160032	160041	160042	160051	160052	160061	160062	160071	160072	160081	160082	160091	160092	160101	160102	160111	160112	160121	160122	160131	160132	160141	160142	160151	160152	160161	160162	160171	160172	160181	160182	160191	160192	160201	160202	160211	160212	160221	160222	160231	160232	160241	160242	160251	160252	160261	160262	160271	160272	160281	160282	160291	160292	160301	160302];
SaMCE = 0.309; % equal to Sa(T) at MCE, if that's the scaling where the plot is required
figSaveDir = 'C:\Users\prak\Drive-UBCO\WRITING_ubco\paper_work_ASCE_BRB\figures\storyDriftRatio';
exportName = sprintf('Storywise_MIDR_RIDR_PFA_AtMCE');

figh = figure; t = tiledlayout(1, 3, 'TileSpacing','tight', 'Padding','tight');
x = 100; y = 100; width = 1500; height = 800;
set(figh, 'Position', [x y width height]);
a = nexttile; % maximum story drift 
b = nexttile; % residual story drift
c = nexttile; % maximum peal floor acceleration

% Loop over all EQ directories
for i = 1 : length(eqNumberLIST)
    eqNum = eqNumberLIST(i);
    eqDirName = sprintf('EQ_%i', eqNum);
    cd(eqDirName);
    load('DATA_collapse_ProcessedIDADataForThisEQ', 'saLevelsForIDAPlotPROCLIST');
    
    count = 0; saValList = []; maxDriftEachFloor = []; % reset

    for j = 1:length(saLevelsForIDAPlotPROCLIST)
        saVal = saLevelsForIDAPlotPROCLIST(1, j);
        if saVal == 0 || saVal == 100
            continue
        else
            count = count + 1;
            saValList(count, 1) = saVal;

            saDirName = sprintf('Sa_%.2f', saVal);
            cd(saDirName);
            load('DATA_reducedSensDataForThisSingleRun', 'storyDriftRatioToSave', 'floorAccelToSave');


            numFloors = size(storyDriftRatioToSave, 2);
            for floorNum = 1:numFloors
                maxDriftEachFloor(count, floorNum) = storyDriftRatioToSave{1, floorNum}.AbsMax;
                resDriftEachFloor(count, floorNum) = abs(storyDriftRatioToSave{1, floorNum}.Residual);
                
                levelNum = floorNum+1;  
                peakAccnEachFloor(count, floorNum) = floorAccelToSave{1, levelNum}.absAbsMaxUnfiltered;
            end
            cd .. % come out to EQ-dir
        end
    end

    X = saValList; xq = SaMCE;
    ix = find(X >= xq, 1); % or <=

    for floorNum = 1:numFloors
        Y = maxDriftEachFloor(:, floorNum);
        yq = interp1([X(ix-1), X(ix)], [Y(ix-1), Y(ix)], xq, 'pchip');
        MaxStoryDrift_eachFloorAtMCE(i, floorNum) = yq;

        Y = resDriftEachFloor(:, floorNum);
        yq = interp1([X(ix-1), X(ix)], [Y(ix-1), Y(ix)], xq, 'pchip');
        ResStoryDrift_eachFloorAtMCE(i, floorNum) = yq;

        Y = peakAccnEachFloor(:, floorNum);
        yq = interp1([X(ix-1), X(ix)], [Y(ix-1), Y(ix)], xq, 'pchip');
        peakFloorAccn_eachFloorAtMCE(i, floorNum) = yq/9810;
    end

    cd .. % come out to analysis-Dir
    axes(a); % change handle of tile axes
    plot(MaxStoryDrift_eachFloorAtMCE(i, :)*100, 1:numFloors, ':', 'LineWidth', 1.5); hold on; % plot MAXIMUM  story drift for each floor
    axes(b); % change handle of tile axes
    plot(ResStoryDrift_eachFloorAtMCE(i, :)*100, 1:numFloors, ':', 'LineWidth', 1.5); hold on; % plot RESIDUAL story drift for each floor
    axes(c);
    plot(peakFloorAccn_eachFloorAtMCE(i, :), 1:numFloors, ':', 'LineWidth', 1.5); hold on; % plot PEAK ACCELERATION for each floor
    
end
meanMaxStoryDrift_eachFloorAtMCE = mean(MaxStoryDrift_eachFloorAtMCE, 1);
meanResStoryDrift_eachFloorAtMCE = mean(ResStoryDrift_eachFloorAtMCE, 1);
meanpeakFloorAccn_eachFloorAtMCE = mean(peakFloorAccn_eachFloorAtMCE, 1);

axes(a); plot(meanMaxStoryDrift_eachFloorAtMCE*100, 1:numFloors, 'b-', 'LineWidth', 3.5); 
axes(b); plot(meanResStoryDrift_eachFloorAtMCE*100, 1:numFloors, 'b-', 'LineWidth', 3.5); 
axes(c); plot(meanpeakFloorAccn_eachFloorAtMCE, 1:numFloors, 'b-', 'LineWidth', 3.5); 

fprintf('Maximum Story drift ratio for each floor for different EQs is a matrix of size %i by %i \n', length(eqNumberLIST), numFloors); fprintf(repmat('-', 7));
fprintf('\nCheck variables MaxStoryDrift_eachFloorAtMCE, resDriftEachFloor, peakFloorAccn_eachFloorAtMCE for the raw data.\n'); fprintf(repmat('-', 7));

axes(a); xlim([0 1.5]); ylim([1, numFloors]);  hx = xlabel('MaxISDR (%)'); hy = ylabel('Storey');  psb_FigureFormatScript_paper_BigFonts;
axes(b); xlim([0 0.25]); ylim([1, numFloors]);  hx = xlabel('ResISDR (%)'); hy = ylabel('Storey');  psb_FigureFormatScript_paper_BigFonts;
axes(c); xlim([0 2]); ylim([1, numFloors]);  hx = xlabel('PFA (g)'); hy = ylabel('Storey');  psb_FigureFormatScript_paper_BigFonts;

% Not calculating for controling component at this point.

cd(figSaveDir);
extensions = {'fig', 'epsc'};
for k = 1:length(extensions)
	saveas(gcf, exportName, extensions{k})
end
fprintf('figures saved in %s.\n', pwd);

%%%%%%%%%%%%%%%%%% end of residual drift code saving figures
    
    case '39a.PlotStoryWise_MaxIDR_ResIDR_PFA_atMCE_separateFigs'
%%
cd('C:\BRB_local\Output\(BRB_6story_v1Combined)_(AllVar)_(0.00)_(clough)')
eqNumberLIST = 60000 + kron(1:30, [1, 1])*10 + repmat([1, 2], 1, 30); 
SaMCE = 0.668; % equal to Sa(T) at MCE, if that's the scaling where the plot is required
figSaveDir = 'C:\Users\prak\Drive-UBCO\WRITING_ubco\Overleaf_BRB_perfAssmt\Nst6_storyDriftRatio';
exportName1 = sprintf('Storywise_MIDR_AtMCE');
exportName2 = sprintf('Storywise_RIDR_AtMCE');
exportName3 = sprintf('Storywise_mPFA_AtMCE');

width = 450; height = 800;
set(figure(101), 'Position', [100 100 width height]);
set(figure(102), 'Position', [100 100 width height]);
set(figure(103), 'Position', [100 100 width height]);

% Loop over all EQ directories
for i = 1 : length(eqNumberLIST)
    eqNum = eqNumberLIST(i);
    eqDirName = sprintf('EQ_%i', eqNum);
    cd(eqDirName);
    load('DATA_collapse_ProcessedIDADataForThisEQ', 'saLevelsForIDAPlotPROCLIST');
    
    count = 0; saValList = []; maxDriftEachFloor = []; % reset

    for j = 1:length(saLevelsForIDAPlotPROCLIST)
        saVal = saLevelsForIDAPlotPROCLIST(1, j);
        if saVal == 0 || saVal == 100
            continue
        else
            count = count + 1;
            saValList(count, 1) = saVal;

            saDirName = sprintf('Sa_%.2f', saVal);
            cd(saDirName);
            load('DATA_reducedSensDataForThisSingleRun', 'storyDriftRatioToSave', 'floorAccelToSave');


            numFloors = size(storyDriftRatioToSave, 2);
            for floorNum = 1:numFloors
                maxDriftEachFloor(count, floorNum) = storyDriftRatioToSave{1, floorNum}.AbsMax;
                resDriftEachFloor(count, floorNum) = abs(storyDriftRatioToSave{1, floorNum}.Residual);
                
                levelNum = floorNum+1;  
                peakAccnEachFloor(count, floorNum) = floorAccelToSave{1, levelNum}.absAbsMaxUnfiltered;
            end
            cd .. % come out to EQ-dir
        end
    end

    X = saValList; xq = SaMCE;
    ix = find(X >= xq, 1); % or <=

    for floorNum = 1:numFloors
        Y = maxDriftEachFloor(:, floorNum);
        yq = interp1([X(ix-1), X(ix)], [Y(ix-1), Y(ix)], xq, 'pchip');
        MaxStoryDrift_eachFloorAtMCE(i, floorNum) = yq;

        Y = resDriftEachFloor(:, floorNum);
        yq = interp1([X(ix-1), X(ix)], [Y(ix-1), Y(ix)], xq, 'pchip');
        ResStoryDrift_eachFloorAtMCE(i, floorNum) = yq;

        Y = peakAccnEachFloor(:, floorNum);
        yq = interp1([X(ix-1), X(ix)], [Y(ix-1), Y(ix)], xq, 'pchip');
        peakFloorAccn_eachFloorAtMCE(i, floorNum) = yq/9810;
    end

    cd .. % come out to analysis-Dir
    figure(101); plot(MaxStoryDrift_eachFloorAtMCE(i, :)*100, 1:numFloors, ':', 'LineWidth', 1.5); hold on; % plot MAXIMUM  story drift for each floor
    figure(102); plot(ResStoryDrift_eachFloorAtMCE(i, :)*100, 1:numFloors, ':', 'LineWidth', 1.5); hold on; % plot RESIDUAL story drift for each floor
    figure(103); plot(peakFloorAccn_eachFloorAtMCE(i, :), 1:numFloors, ':', 'LineWidth', 1.5); hold on; % plot PEAK ACCELERATION for each floor
    
end
meanMaxStoryDrift_eachFloorAtMCE = mean(MaxStoryDrift_eachFloorAtMCE, 1);
meanResStoryDrift_eachFloorAtMCE = mean(ResStoryDrift_eachFloorAtMCE, 1);
meanpeakFloorAccn_eachFloorAtMCE = mean(peakFloorAccn_eachFloorAtMCE, 1);

figure(101); plot(meanMaxStoryDrift_eachFloorAtMCE*100, 1:numFloors, 'b-', 'LineWidth', 3.5); 
figure(102); plot(meanResStoryDrift_eachFloorAtMCE*100, 1:numFloors, 'b-', 'LineWidth', 3.5); 
figure(103); plot(meanpeakFloorAccn_eachFloorAtMCE, 1:numFloors, 'b-', 'LineWidth', 3.5); 

fprintf('Maximum Story drift ratio for each floor for different EQs is a matrix of size %i by %i \n', length(eqNumberLIST), numFloors); fprintf(repmat('-', 7));
fprintf('\nCheck variables MaxStoryDrift_eachFloorAtMCE, resDriftEachFloor, peakFloorAccn_eachFloorAtMCE for the raw data.\n'); fprintf(repmat('-', 7));

figure(101); xlim([0 1.5]); ylim([1, numFloors]);  hx = xlabel('MaxISDR (%)'); hy = ylabel('Storey');  psb_FigureFormatScript_paper_BigFonts;
figure(102); xlim([0 0.5]); ylim([1, numFloors]);  hx = xlabel('ResISDR (%)'); hy = ylabel('Storey');  psb_FigureFormatScript_paper_BigFonts;
figure(103); xlim([0 2]); ylim([1, numFloors]);  hx = xlabel('PFA (g)'); hy = ylabel('Storey');  psb_FigureFormatScript_paper_BigFonts;

% Not calculating for controling component at this point.

cd(figSaveDir);
extensions = {'fig', 'epsc'};
for k = 1:length(extensions)
	figure(101); saveas(gcf, exportName1, extensions{k});
    figure(102); saveas(gcf, exportName2, extensions{k});
    figure(103); saveas(gcf, exportName3, extensions{k});
end
fprintf('\n figures saved in %s.\n', pwd);

%%%%%%%%%%%%%%%%%% end of residual drift code saving figures

    case '40.findGlulamAxialForceForTruncatedIDA_checkOnGFOnly'
%%
    % Capacity of columns (this program only checks for failure at first floor)
    % Run time (in parallel) ~ 300 s for an EQs with 17 Sa (per core)
    outpDir = 'C:\BRB_local\Output\(BRB_18story_v8)_(AllVar)_(0.00)_(clough)';
    colNumListForMaxMin = [];
    Nst = 18;

    % Capacity of columns (this program only checks for failure at first floor)
    compCapacity1stFloor = 11249; tensCapacity1stFloor = 11459;  sheaCapacity1stFloor = 999; 

    for story = 1:Nst
        colNumThisStory = [20000+story*100+1, 20000+story*100+2, 20000+story*100+3, 20000+story*100+4];
        colNumListForMaxMin = [colNumListForMaxMin; colNumThisStory];
    end
    
    cd(outpDir)
    % scan for all EQ dirs
    eqDirPattern = sprintf('EQ_*');
    allEqDirInfo = dir(eqDirPattern);
    for i = 1:size(allEqDirInfo, 1)
        if strcmp(allEqDirInfo(i).name, 'EQ_9991'); allEqDirInfo(i) = []; break; end
    end
    % extract eventNums, useful for finding controling component
    for i = 1:size(allEqDirInfo, 1)
        eqID_list(i, 1) = str2double(allEqDirInfo(i).name(strfind(allEqDirInfo(i).name, '_') + 1:end));
    end
    % eventNum = unique(floor(eqNum/10));
    numOfEqs = length(eqID_list);
    
%     fprintf('Execution status: ');
    
    % scan for all Sa dirs by Looping over all EQ directories
    parfor i = 1:numOfEqs
        eqID = eqID_list(i, 1); cd(sprintf('EQ_%i', eqID));
        allGlulamColLocalForcePVData(i).eqID = eqID;
    
        saDirPattern = sprintf('Sa_*');
        allSaDirInfo = dir(saDirPattern);
    
        for j = 1:size(allSaDirInfo, 1)
            saVal = str2double(allSaDirInfo(j).name(strfind(allSaDirInfo(j).name, '_') + 1:end));
    
            cd(allSaDirInfo(j).name); cd Elements\EleLocalTH
            CmaxStorywise = zeros(1, Nst); TmaxStorywise = zeros(1, Nst); VmaxStorywise = zeros(1, Nst);
            for k = 1:Nst
                thisStoryCol = colNumListForMaxMin(k, :); Ncol = length(thisStoryCol);
    
                thisStoryCmax = 0;
                thisStoryTmax = 0;
                thisStoryVmax = 0; % initialize
                for p = 1:Ncol
                    thisColForces = load(sprintf('THEleLocal_%i.out', thisStoryCol(p)));
    
                    thisColPForce = thisColForces(:, 1); thisColVForce = thisColForces(:, 2);
    
                    thisColCmax = max(0, -min(thisColPForce)); % -ve is COMP, for first node
                    thisColTmax = max(0, max(thisColPForce)); % +ve is TENS, for first node
                    thisColVmax = max(abs(thisColVForce)); % shear is unsigned
    
                    if thisColCmax > thisStoryCmax; thisStoryCmax = thisColCmax; end
                    if thisColTmax > thisStoryTmax; thisStoryTmax = thisColTmax; end
                    if thisColVmax > thisStoryVmax; thisStoryVmax = thisColVmax; end
                end
                CmaxStorywise(1, k) = thisStoryCmax;
                TmaxStorywise(1, k) = thisStoryTmax;
                VmaxStorywise(1, k) = thisStoryVmax;
            end
            cd ..\..\..\ % back to EQ dir; ready for next Sa dir
            allGlulamColLocalForcePVData(i).saValues(j, 1) = saVal;
            allGlulamColLocalForcePVData(i).CmaxStorywise(j, 1:Nst) = CmaxStorywise;
            allGlulamColLocalForcePVData(i).TmaxStorywise(j, 1:Nst) = TmaxStorywise;
            allGlulamColLocalForcePVData(i).VmaxStorywise(j, 1:Nst) = VmaxStorywise;
        
%             fprintf('\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\bEQ- %2i/%2i, Sa- %2i/%2i', i, numOfEqs, j, size(allSaDirInfo, 1));
        end
        cd .. % back to analysis dir; ready for next EQ dir
    end
    
    cd(baseF); toc;
    
    singleVarWithAllData = [];
    for i = 1:numOfEqs
        eqIDtiled = allGlulamColLocalForcePVData(i).eqID * ones(size(allGlulamColLocalForcePVData(i).saValues));
        singleVarWithAllData = [singleVarWithAllData;
                                eqIDtiled, allGlulamColLocalForcePVData(i).saValues, ... 
                                allGlulamColLocalForcePVData(i).CmaxStorywise, ...
                                allGlulamColLocalForcePVData(i).TmaxStorywise, ...
                                allGlulamColLocalForcePVData(i).VmaxStorywise;];
    end
    
    for i = 1:numOfEqs
        Y = allGlulamColLocalForcePVData(i).saValues;
        saValForGlulamCapacity(i, 1:3) = [999 999 999]; % initialize that value is not exceeded
    
        % find Sa for compression capacity
        X = allGlulamColLocalForcePVData(i).CmaxStorywise(:, 1); xq = compCapacity1stFloor;
        ix = find(X >= xq, 1); % or <=
        if ~isempty(ix);  yq = interp1([X(ix-1), X(ix)], [Y(ix-1), Y(ix)], xq, 'linear'); saValForGlulamCapacity(i, 1) = yq; end
    
        % find Sa for tension capacity
        X = allGlulamColLocalForcePVData(i).TmaxStorywise(:, 1); xq = tensCapacity1stFloor;
        ix = find(X >= xq, 1); % or <=
        if ~isempty(ix); yq = interp1([X(ix-1), X(ix)], [Y(ix-1), Y(ix)], xq, 'linear'); saValForGlulamCapacity(i, 2) = yq; end
    
        % find Sa for shear capacity
        X = allGlulamColLocalForcePVData(i).VmaxStorywise(:, 1); xq = sheaCapacity1stFloor;
        ix = find(X >= xq, 1); % or <=
        if ~isempty(ix);  yq = interp1([X(ix-1), X(ix)], [Y(ix-1), Y(ix)], xq, 'linear'); saValForGlulamCapacity(i, 3) = yq; end
    end
    
    fprintf('%s\n', repmat('-', 1, 70));
    fprintf('For structured data, Open the variable named ''allGlulamColLocalForcePVData.''\n'); fprintf('%s\n', repmat('-', 1, 70));
    fprintf('For singular EQ | Sa | Cmax | Tmax | Vmax data, open the variable named ''singleVarWithAllData.''\n'); fprintf('%s\n', repmat('-', 1, 70));
    fprintf('Variable ''saValForGlulamCapacity'' has the values of Sa when capacities (C | T | V) are exceeded. \n '); fprintf('%s\n', repmat('-', 1, 70));
    
    uniqueNum = convertTo(datetime(),'ntfs'); matFileName = sprintf('GlulamColData_%i', uniqueNum);
    save(matFileName, 'allGlulamColLocalForcePVData', 'singleVarWithAllData', 'saValForGlulamCapacity');
    fprintf('filename saved is %s. \n ', matFileName); fprintf('%s\n', repmat('-', 1, 70));

    case '40a.findGlulamAxialForceForTruncatedIDA_checkOnAllStories'
%%
    % Capacity of columns (this program checks for failure at all floors)
    % Run time (in parallel) ~ 300 s for an EQs with 17 Sa (per core)
    outpDir = 'C:\BRB_local\Output\(BRB_6story_v1)_(AllVar)_(0.00)_(clough)';
    colNumListForMaxMin = [];
    Nst = 6;

    % Capacity of columns (bottom to top) (this program now checks for failure at all floors)
    compCapacityBotToTop = [repmat(3787, 1, 3), repmat(3387, 1, 3)]; 
    tensCapacityBotToTop = [repmat(3438, 1, 3), repmat(2674, 1, 3)]; 
    sheaCapacityBotToTop = [repmat(0300, 1, 3), repmat(0233, 1, 3)]; 

    for story = 1:Nst
        colNumThisStory = [20000+story*100+1, 20000+story*100+2, 20000+story*100+3, 20000+story*100+4];
        colNumListForMaxMin = [colNumListForMaxMin; colNumThisStory];
    end
    
    cd(outpDir)
    % scan for all EQ dirs
    eqDirPattern = sprintf('EQ_*');
    allEqDirInfo = dir(eqDirPattern);
    for i = 1:size(allEqDirInfo, 1) % remove pushover case
        if strcmp(allEqDirInfo(i).name, 'EQ_9991') || strcmp(allEqDirInfo(i).name, 'EQ_9992')
            allEqDirInfo(i) = []; % break; % no need to break, this is a quick check 
        end
    end
    % extract eventNums, useful for finding controling component
    for i = 1:size(allEqDirInfo, 1)
        eqID_list(i, 1) = str2double(allEqDirInfo(i).name(strfind(allEqDirInfo(i).name, '_') + 1:end));
    end
    % eventNum = unique(floor(eqNum/10));
    numOfEqs = length(eqID_list);
    
%     fprintf('Execution status: ');
    
    % scan for all Sa dirs by Looping over all EQ directories
    parfor i = 1:numOfEqs
        eqID = eqID_list(i, 1); cd(sprintf('EQ_%i', eqID));
        allGlulamColLocalForcePVData(i).eqID = eqID;
    
        saDirPattern = sprintf('Sa_*');
        allSaDirInfo = dir(saDirPattern);
    
        for j = 1:size(allSaDirInfo, 1)
            saVal = str2double(allSaDirInfo(j).name(strfind(allSaDirInfo(j).name, '_') + 1:end));
    
            cd(allSaDirInfo(j).name); cd Elements\EleLocalTH
            CmaxStorywise = zeros(1, Nst); TmaxStorywise = zeros(1, Nst); VmaxStorywise = zeros(1, Nst);
            for k = 1:Nst
                thisStoryCol = colNumListForMaxMin(k, :); Ncol = length(thisStoryCol);
    
                thisStoryCmax = 0;
                thisStoryTmax = 0;
                thisStoryVmax = 0; % initialize
                for p = 1:Ncol
                    thisColForces = load(sprintf('THEleLocal_%i.out', thisStoryCol(p)));
    
                    thisColPForce = thisColForces(:, 1); thisColVForce = thisColForces(:, 2);
    
                    thisColCmax = max(0, -min(thisColPForce)); % -ve is COMP, for first node
                    thisColTmax = max(0, max(thisColPForce)); % +ve is TENS, for first node
                    thisColVmax = max(abs(thisColVForce)); % shear is unsigned
    
                    if thisColCmax > thisStoryCmax; thisStoryCmax = thisColCmax; end
                    if thisColTmax > thisStoryTmax; thisStoryTmax = thisColTmax; end
                    if thisColVmax > thisStoryVmax; thisStoryVmax = thisColVmax; end
                end
                CmaxStorywise(1, k) = thisStoryCmax;
                TmaxStorywise(1, k) = thisStoryTmax;
                VmaxStorywise(1, k) = thisStoryVmax;
            end
            cd ..\..\..\ % back to EQ dir; ready for next Sa dir
            allGlulamColLocalForcePVData(i).saValues(j, 1) = saVal;
            allGlulamColLocalForcePVData(i).CmaxStorywise(j, 1:Nst) = CmaxStorywise;
            allGlulamColLocalForcePVData(i).TmaxStorywise(j, 1:Nst) = TmaxStorywise;
            allGlulamColLocalForcePVData(i).VmaxStorywise(j, 1:Nst) = VmaxStorywise;
        
%             fprintf('\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\bEQ- %2i/%2i, Sa- %2i/%2i', i, numOfEqs, j, size(allSaDirInfo, 1));
        end
        cd .. % back to analysis dir; ready for next EQ dir
    end
    
    cd(baseF); toc;
    
    singleVarWithAllData = [];
    for i = 1:numOfEqs
        eqIDtiled = allGlulamColLocalForcePVData(i).eqID * ones(size(allGlulamColLocalForcePVData(i).saValues));
        singleVarWithAllData = [singleVarWithAllData;
                                eqIDtiled, allGlulamColLocalForcePVData(i).saValues, ... 
                                allGlulamColLocalForcePVData(i).CmaxStorywise, ...
                                allGlulamColLocalForcePVData(i).TmaxStorywise, ...
                                allGlulamColLocalForcePVData(i).VmaxStorywise;];
    end
    
    for i = 1:numOfEqs
        Y = allGlulamColLocalForcePVData(i).saValues;
        saValForGlulamCapacity(i, 1:3) = [999 999 999]; % initialize that value is not exceeded
        criticalFloorGlulamCap(i, 1:3) = [999 999 999]; % initialize that value is not exceeded
        
        for j = 1:Nst
            % find Sa for compression capacity
            X = allGlulamColLocalForcePVData(i).CmaxStorywise(:, j); xq = compCapacityBotToTop(1, j);
            ix = find(X >= xq, 1); % or <=
            if ~isempty(ix)
                yq = interp1([X(ix-1), X(ix)], [Y(ix-1), Y(ix)], xq, 'linear'); 
                if yq < saValForGlulamCapacity(i, 1)
                    saValForGlulamCapacity(i, 1) = yq; % update saValForGlulamCapacity(i, 1) with smaller value
                    criticalFloorGlulamCap(i, 1) = j;
                end
            end
        
            % find Sa for tension capacity
            X = allGlulamColLocalForcePVData(i).TmaxStorywise(:, 1); xq = tensCapacityBotToTop(1, j);
            ix = find(X >= xq, 1); % or <=
            if ~isempty(ix)
                yq = interp1([X(ix-1), X(ix)], [Y(ix-1), Y(ix)], xq, 'linear'); 
                if yq < saValForGlulamCapacity(i, 2)
                    saValForGlulamCapacity(i, 2) = yq; % update saValForGlulamCapacity(i, 2) with smaller value
                    criticalFloorGlulamCap(i, 2) = j;
                end
            end
        
            % find Sa for shear capacity
            X = allGlulamColLocalForcePVData(i).VmaxStorywise(:, 1); xq = sheaCapacityBotToTop(1, j);
            ix = find(X >= xq, 1); % or <=
            if ~isempty(ix)
                yq = interp1([X(ix-1), X(ix)], [Y(ix-1), Y(ix)], xq, 'linear'); 
                if yq < saValForGlulamCapacity(i, 3)
                    saValForGlulamCapacity(i, 3) = yq; % update saValForGlulamCapacity(i, 3) with smaller value
                    criticalFloorGlulamCap(i, 3) = j;
                end
            end
        end
    end
    
    fprintf('%s\n', repmat('-', 1, 70));
    fprintf('For structured data, Open the variable named ''allGlulamColLocalForcePVData.''\n'); fprintf('%s\n', repmat('-', 1, 70));
    fprintf('For singular EQ | Sa | Cmax | Tmax | Vmax data, open the variable named ''singleVarWithAllData.''\n'); fprintf('%s\n', repmat('-', 1, 70));
    fprintf('Variable ''saValForGlulamCapacity'' has the values of Sa when capacities (C | T | V) are exceeded. \n '); fprintf('%s\n', repmat('-', 1, 70));
    fprintf('Variable ''criticalFloorGlulamCap'' has the critical floor when Glulam capacities governs (C | T | V). \n '); fprintf('%s\n', repmat('-', 1, 70));
    
    uniqueNum = convertTo(datetime(),'ntfs'); matFileName = sprintf('GlulamColData_%i', uniqueNum);
    save(matFileName, 'allGlulamColLocalForcePVData', 'singleVarWithAllData', 'saValForGlulamCapacity', 'criticalFloorGlulamCap');
    fprintf('filename saved is %s. \n ', matFileName); fprintf('%s\n', repmat('-', 1, 70));

    case '41.scriptBulkDownload'
%%
%     clear; clc; tic;
baseF = pwd;
entryType = 2;
username = "xxxxx";
password = "yyyyy";

dirLIST = {'C:\Users\prak\Drive-UBCO\WRITING_ubco\Overleaf_Hazard_NRCan\Ch4ParamStudyResultsWithFigures\1_T_cond_1s';
'C:\Users\prak\Drive-UBCO\WRITING_ubco\Overleaf_Hazard_NRCan\Ch4ParamStudyResultsWithFigures\2_T_cond_3s';
'C:\Users\prak\Drive-UBCO\WRITING_ubco\Overleaf_Hazard_NRCan\Ch4ParamStudyResultsWithFigures\3_range_0p5To3p0';
'C:\Users\prak\Drive-UBCO\WRITING_ubco\Overleaf_Hazard_NRCan\Ch4ParamStudyResultsWithFigures\4_range_0p2To4p5';
'C:\Users\prak\Drive-UBCO\WRITING_ubco\Overleaf_Hazard_NRCan\Ch4ParamStudyResultsWithFigures\5_UHS_MeanOnly';
'C:\Users\prak\Drive-UBCO\WRITING_ubco\Overleaf_Hazard_NRCan\Ch4ParamStudyResultsWithFigures\6_CMS_MeanOnly';
'C:\Users\prak\Drive-UBCO\WRITING_ubco\Overleaf_Hazard_NRCan\Ch4ParamStudyResultsWithFigures\7_TR_475';
'C:\Users\prak\Drive-UBCO\WRITING_ubco\Overleaf_Hazard_NRCan\Ch4ParamStudyResultsWithFigures\8_TR_4975';
'C:\Users\prak\Drive-UBCO\WRITING_ubco\Overleaf_Hazard_NRCan\Ch4ParamStudyResultsWithFigures\9_dMin_5km';
'C:\Users\prak\Drive-UBCO\WRITING_ubco\Overleaf_Hazard_NRCan\Ch4ParamStudyResultsWithFigures\10_NoScaling';
'C:\Users\prak\Drive-UBCO\WRITING_ubco\Overleaf_Hazard_NRCan\Ch4ParamStudyResultsWithFigures\11_maxScaling_10';
'C:\Users\prak\Drive-UBCO\WRITING_ubco\Overleaf_Hazard_NRCan\Ch4ParamStudyResultsWithFigures\12_maxScaling_2';};

for i = 5:12
    listOfRecordsFileName = fullfile(dirLIST{i, 1}, 'Summary_30GM_1p5_CB14_SF5_Van\SelectedRecs_Interface_Subduction.dat');
    if i == 5
        listOfRecordsFileName = fullfile(dirLIST{i, 1}, 'Summary_30GM_1p5_CB14_SF5_Van_UHS_meanOnly\SelectedRecs_Interface_Subduction.dat');
    elseif i == 6
        listOfRecordsFileName = fullfile(dirLIST{i, 1}, 'Summary_30GM_1p5_CB14_SF5_Van_meanOnly\SelectedRecs_Interface_Subduction.dat');
    elseif i == 10
        listOfRecordsFileName = fullfile(dirLIST{i, 1}, 'Summary_30GM_1p5_CB14_SFnone_Van\SelectedRecs_Interface_Subduction.dat');
    elseif i == 11
        listOfRecordsFileName = fullfile(dirLIST{i, 1}, 'Summary_30GM_1p5_CB14_SF10_Van\SelectedRecs_Interface_Subduction.dat');
    elseif i == 12
        listOfRecordsFileName = fullfile(dirLIST{i, 1}, 'Summary_30GM_1p5_CB14_SF2_Van\SelectedRecs_Interface_Subduction.dat');
    end
    dirToSave = fullfile(dirLIST{i, 1}, 'rawRecs');
    downloadAutoFiles(entryType, listOfRecordsFileName, dirToSave, username, password);
    cd(baseF)
end

    case '42.fun_correctInBulk_GMReport'
%%
    % function fun_correctTimeHistoryForNonZeroBeginning(eqLIST)

% clear; baseFolder = pwd;

eqLIST = kron(1:30, [1, 1])*10 + repmat([1, 2], 1, 30); 
numEq = size(eqLIST, 2);
count = 0;
for k = 1:13
    caseNumber = k-1;
    caseDir = sprintf('%i_formatted_psb', caseNumber);

for eqFileIndex = 1:numEq%length(eqNumberLIST)
%     cd C:\OpenSeesProcessingFiles\EQs
    cd C:\Users\prak\Desktop\github_repo_copy_for_analysis\NBCC2020_myCopy\GMSelection_format\
    cd(caseDir)

    eqNumber = eqLIST(1, eqFileIndex);
    dt = load(sprintf('DtFile_(%i).txt', eqNumber));
    numPoints = load(sprintf('NumPointsFile_(%i).txt', eqNumber));
    GMTimeHistory = load(sprintf('SortedEQFile_(%i).txt', eqNumber));
    
    cd(baseFolder); 

    timeArray = 0:dt:dt * (numPoints - 1);
    PGA = max(abs(GMTimeHistory));

    aa1st5sMean = mean(GMTimeHistory(timeArray <= 5)); % average acceleration for first 5 secon
    aa1st5sMeanToPGARatio = abs(aa1st5sMean)/PGA;
    accn1st5sMax = max(GMTimeHistory(timeArray <= 5));
    accn1st5sMin = min(GMTimeHistory(timeArray <= 5));
    accn1st5sMaxMinusMinByMean = (accn1st5sMax - accn1st5sMin)/abs(aa1st5sMean);

    PGA_vals(eqFileIndex, 1) = PGA;
    aa1st5sToPGA_ratioVal(eqFileIndex, 1) = aa1st5sMeanToPGARatio;

    accn1st5sMeanVal(eqFileIndex, 1) = aa1st5sMean; 
    accn1st5sMaxVal(eqFileIndex, 1) = accn1st5sMax; 
    accn1st5sMinVal(eqFileIndex, 1) = accn1st5sMin; 
    accn1st5sRangeByMean(eqFileIndex, 1) = accn1st5sMaxMinusMinByMean; 

    if aa1st5sMeanToPGARatio > 0.05
        count = count + 1;
        figure; plot(timeArray, GMTimeHistory, 'k-','LineWidth',0.1); hold on; grid on;

        GMTimeHistory = GMTimeHistory - aa1st5sMean;
        plot(timeArray, GMTimeHistory, 'r-','LineWidth',0.1); hold on; grid on; legend([num2str(eqNumber) 'original'], 'corrected');

        TH = GMTimeHistory;
%         fun_saveResSpecStandalone(eqNumber, TH, dt); % do not create RS
        cd C:\Users\prak\Desktop\github_repo_copy_for_analysis\NBCC2020_myCopy\GMSelection_format\
        cd(caseDir)
%         cd ('CorrectedTH_And_RespSpec'); % let it overwrite for GM report
        writematrix(TH, sprintf('SortedEQFile_(%i).txt', eqNumber));
        cd ..
    end
end
T = table(PGA_vals, accn1st5sMeanVal, aa1st5sToPGA_ratioVal, accn1st5sMeanVal, accn1st5sMaxVal, accn1st5sMinVal, accn1st5sRangeByMean);
fprintf('%i/%i ground motion records corrected. \n', count, numEq);
end
% cd(baseFolder);

    case '43.combineMultipleMatFiles'
%%
% make sure to maintain the order of file names (i.e., first file with initial EQs, etc.)
    matFileName1 = 'C:\BRB_local\Output\(BRB_6story_v1Combined)_(AllVar)_(0.00)_(clough)\GlulamColData_133305513945954950.mat';
    matFileName2 = 'C:\BRB_local\Output\(BRB_6story_v1Combined)_(AllVar)_(0.00)_(clough)\GlulamColData_133305525600540000.mat';
        
    outpMatFileName = 'C:\BRB_local\Output\(BRB_6story_v1Combined)_(AllVar)_(0.00)_(clough)\GlulamColData_ALL.mat';
    
    data1 = load(matFileName1);
    data2 = load(matFileName2);

allGlulamColLocalForcePVData = [data1.allGlulamColLocalForcePVData, data2.allGlulamColLocalForcePVData];
criticalFloorGlulamCap = [data1.criticalFloorGlulamCap; data2.criticalFloorGlulamCap]; 
saValForGlulamCapacity = [data1.saValForGlulamCapacity; data2.saValForGlulamCapacity]; 
singleVarWithAllData = [data1.singleVarWithAllData; data2.singleVarWithAllData]; 

save(outpMatFileName, 'allGlulamColLocalForcePVData', 'criticalFloorGlulamCap', 'saValForGlulamCapacity', 'singleVarWithAllData');

    case '99.EmptyCaseWriteOtherCasesAboveThis'
%%        
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%% DO NOT WRITE BELOW THIS COMMAND LINE %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%% END OF THE SWITCH CASE %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

end
cd(baseFolder)
fprintf('\n');
toc

function [T_old, saT_old_AllComp] = prak_util_extractFragDataPoints_v02(analysisTypeFolder, eqNumberLIST, newStoryDrift, matFileToLoad)
baseFolder = pwd;
% % BuildingID = '2207v07';
% analysisTypeFolder = 'J:\Output\(ID2207_R5_7Story_v.07)_(AllVar)_(0.00)_(clough)';
% eqNumberLIST_forProcessing_SetC = [120111, 120112, 120121, 120122,	120411, 120412,	120521, 120522,	120611, 120612,	120621, 120622,	120711, 120712,	120721, 120722,	120811, 120812,	120821, 120822,	120911, 120912,	120921, 120922,	121011, 121012,	121021, 121022,	121111, 121112,	121211, 121212,	121221, 121222,	121321, 121322,	121411, 121412,	121421, 121422,	121511, 121512,	121711, 121712];
% eqNumberLIST = eqNumberLIST_forProcessing_SetC;
% % eqListForCollapseIDAs_Name = 'GMSetC'; 
% newStoryDrift = 0.04;

cd(analysisTypeFolder)
saT_old_AllComp = zeros(1, length(eqNumberLIST));

if abs(newStoryDrift - 0.00)<1e-5 % sidesway collapse
%     load DATA_collapse_CollapseSaAndStats_GMSetC_SaGeoMean collapseLevelForAllComp periodUsedForScalingGroundMotions
    load(matFileToLoad, 'collapseLevelForAllComp', 'periodUsedForScalingGroundMotions');
    saT_old_AllComp = collapseLevelForAllComp ;
    T_old = periodUsedForScalingGroundMotions;
else
    for eqIndex = 1:length(eqNumberLIST)
        eqNumber = eqNumberLIST(eqIndex);
        eqFolder = sprintf('EQ_%d',eqNumber);
        cd(eqFolder)

        load DATA_collapse_ProcessedIDADataForThisEQ ;
        saLevels = saLevelsForIDAPlotPROCLIST;
        maxDriftRatio = maxDriftRatioForPlotPROCLIST;

        % simple interpolation may not work, since IDAs are non monotonous at times
    %     saCol_BasedOnDriftAllComp(eqIndex) = interp1(maxDriftRatio, saLevels, collapseDrift, 'pchip');
        ix = find(maxDriftRatio  > newStoryDrift, 1);
        if isempty(ix)
            saT_old_AllComp(eqIndex) = saLevels(end);
        else
            saT_old_AllComp(eqIndex) = interp1([maxDriftRatio(ix-1), maxDriftRatio(ix)], ...
                                                     [saLevels(ix-1), saLevels(ix)], newStoryDrift, 'pchip');
        end

        if eqIndex == 1 % loading only once
            load DATA_CollapseResultsForThisSingleEQ periodUsedForScalingGroundMotions % it is same for all the GMs. Can load only once for efficiency.
            T_old = periodUsedForScalingGroundMotions;
        end
        cd ..
    end
end       
    cd(baseFolder)
end

function saRatNewToOld = prak_util_ratioOfSaTnewToSaTold(eqNumber, T_old, T_new, dampRat)
%% (6-28-19, PSB) T_new = 0.00 will throw the ratio for PGA. Added this piece below on 6-28-19

baseFolder = pwd;
switch nargin 
    case 3
        dampRat = 0.05;
end

% We expect, T_old and T_new to be rounded to two decimal places, if not then let's do it now.

T_old = round(T_old *100)/100;
T_new = round(T_new *100)/100;


%% (6-28-19, PSB) Modifying to include ratio to PGA when T_new is entered as 0.00
if abs(T_new) < 0.001 % essentially, zero
    cd C:\OpenSeesProcessingFiles\EQ_Spectra_Saved
    respSpecFile = sprintf('SaEQSpectrum_EQ_%i.mat', eqNumber);
    load(respSpecFile, 'dampRatioLIST', 'periodVector', 'SaAbs');
    
% find the old SaValue
    dampRatIndex = find(abs(dampRatioLIST - dampRat) < 1e-5);
    timePIndexOld = find(abs(periodVector - T_old) < 1e-4);
    SaT_old = SaAbs(timePIndexOld, dampRatIndex);    
    
% % find the PGA value (essentially, SaT_new)
    cd C:\OpenSeesProcessingFiles\EQs
    timeHistoryFile = sprintf('SortedEQFile_(%i).txt', eqNumber);
    accnArray = load(timeHistoryFile);
    SaT_new = max(abs(min(accnArray)), abs(max(accnArray)));
    saRatNewToOld = SaT_new/SaT_old;

else
    cd C:\OpenSeesProcessingFiles\EQ_Spectra_Saved
    respSpecFile = sprintf('SaEQSpectrum_EQ_%i.mat', eqNumber);
    load(respSpecFile, 'dampRatioLIST', 'periodVector', 'SaAbs');
    
% find the old SaValue
    dampRatIndex = find(abs(dampRatioLIST - dampRat) < 1e-5);
    timePIndexOld = find(abs(periodVector - T_old) < 1e-4);
    SaT_old = SaAbs(timePIndexOld, dampRatIndex);
    
% find the new SaValue
    timePIndexNew = find(abs(periodVector - T_new) < 1e-4);
    SaT_new = SaAbs(timePIndexNew, dampRatIndex);
   
    saRatNewToOld = SaT_new/SaT_old;
end

cd(baseFolder)
end

function formatGMRecordsFig_Case32c(exportName, fontFac, dirToWrite)
% exportName = 'FXc_recordsSigma_1p6';  str1 = 'Period, $T$ (s)'; str2 = '$\sigma_{\ln S_a(T)}$'; yticks(0:0.2:0.8)
baseF  = pwd;
extensions = {'fig', 'epsc'}; % , 'png', 'jpeg', 'meta'
doSave = 1;

paperwidth = 0.48; %fontFac = 1.5;
% desired font sizes
xAxisLabelFontSize = 12*fontFac;
yAxisLabelFontSize = 12*fontFac;
axisNumberFontSize = 11*fontFac;
legendTextFontSize = 5.625*fontFac;
gridAlphas = [0.30, 0.50]; % default values are 0.15 (major) and 0.25 (minor)

% get handles
hax = gca; hx = get(hax, 'xlabel'); hy = get(hax, 'ylabel'); 
legh = findobj(gcf, 'Type', 'Legend');

% change legend entries
% x = get(legh, 'String'); % x{1, 2} = 'Lognormal CDF'; set(legh, 'String', x);
% x = {'$LS_1$', '$LS_2$', '$LS_3$', '$LS_4$'};

% set axis handles to LaTeX
% set(hx, 'string', str1); set(hy, 'string', str2); 

% set axis font sizes
set(hax, 'FontSize', axisNumberFontSize);
set(hx, 'FontSize', xAxisLabelFontSize, 'Interpreter', 'latex');
set(hy, 'FontSize', yAxisLabelFontSize, 'Interpreter', 'latex');
set(hax, 'GridAlpha', gridAlphas(1), 'MinorGridAlpha', gridAlphas(2))

% set legend sizes and number of columns
set(legh, 'FontSize', legendTextFontSize, 'location', 'southwest'); set(legh,'NumColumns', 1);
title([]); % grid on; % set(legh, 'Visible', 'off'); % for 9b and 9c

% set limits and ticks of axes
% xlim([0.25 3]); 
% ylim([0.5e-2 3]);
% xticks([1e-2 1e-1 1e0]); yticks([1e-6 1e-4 1e-2 1e0]);

% export as desired
if doSave == 1; cd(dirToWrite); for k = 1:length(extensions); saveas(gcf, exportName, extensions{k}); end; end
cd(baseF);
end