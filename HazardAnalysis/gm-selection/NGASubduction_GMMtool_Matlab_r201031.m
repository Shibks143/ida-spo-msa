%%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% --------------------------------------------------------------------
%%% --------------------------------------------------------------------
%%% -- NGA-Subduction: 
%%%                  Ground-Motion Characterization Tool
%%%                  Matlab Version
%%% --------------------------------------------------------------------
%%%                             October 2020
%%% --------------------------------------------------------------------
%%% Ground-Motion Model Tool developed by 
%%%            Silvia Mazzoni
%%%                smazzoni@ucla.edu
%%%            B. John Garrick Institute for the Risk Sciences
%%%                https://www.risksciences.ucla.edu/nhr3/gmtools
%%% --------------------------------------------------------------------
%%% Sources: 
%%%  KBCG20: 
%%%    Kuehn, Bozorgnia, Campbell, and Gregor, 
%%%         “Partially Nonergodic Ground-Motion Model for Subduction Regions using NGA-Subduction Database,” 
%%%         Report 4/2020, Pacific Earthquake Engineering Research Center, UC Berkeley
%%%  PSHAB20: 
%%%    Parker, G.A., Stewart, J.P., Hassani, B., Atkinson, G.M., and Boore, D.M. (2020). 
%%%         "NGA-Subduction Global Ground Motion Models with Regional Adjustment Factors." 
%%%         Report xx/2020, Pacific Earthquake Engineering Research Center, UC Berkeley
%%% --------------------------------------------------------------------
%%% Instruction: 
%%%   1. Enter the values of the user-input parameters.
%%%       Input ranges are given with each input parameters.
%%%   2. Run full script
%%%   3. Wait while script runs
%%%   4. A plot of the response spectra will open (you can copy and paste it elsewhere)
%%%   5. Result values are printed in Command Window (you can copy and
%%%   paste them elsewhere) and exported to a file
%%% --------------------------------------------------------------------
%%%   Notes:
%%%       The Median and Sigma models are described in the reports. 
%%%       Damping Ratio = 5%
%%%         You may speed up the program by managing the coefficients
%%%         tables more efficiently.
%%%       The program computes the geometric mean of the median ground-motion models, 
%%%           and the SRSS of the aleatory variability and epistemic uncertainty.	
%%% 
%%% --------------------------------------------------------------------
%%% Variables:
%%%   User-Input Parameters: given below
%%%   Output Variables:
%%%     InputTable:                             Matlab Table with all input variables
%%%     outIndivModelDataTable:        Matlab Table with all individual-model output
%%%     outDataTableScenario:           Matlab Table with the weighted-average model output
%%%     outAllScenarioDataTable:       Matlab Table with all input/output values. It written prented to a file.
%%%     
%%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% initialize
initializeTool; % do not remove this command




% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% user input:
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
User_Region = '0_global';   % Region (Options: 0_global, 1_Alaska, 2_Cascadia, 3_CentralAmerica&Mexico, 4_Japan, 5_NewZealand (PSHAB20 uses global model), 6_SouthAmerica, 7_Taiwan)
User_SubductionSlab = 'global';   % Subducting Slab (used to compute Mb) (Alaska,Aleutian,Cascadia,Central_America_N,Central_America_S,global,Japan_Pac,Japan_Phi,New_Zealand_N,New_Zealand_S,South_America_N,South_America_S,Taiwan_E,Taiwan_W)
User_Magnitude = 8;   % Moment Magnitude
User_Vs30 = 760;   % VS30 (m/sec)
User_Rrup = 200;   % Rupture Distance (km)
User_AlphaBackarc = 0;   % Fraction of Rrup in Backarc (Range: 0-1)
User_AlphaNankai = 0;   % Fraction of Rrup in Nankai Region (Range: 0-(1-AlphaBackArc))(Japan only)
User_Ztor = 10;   % Z_tor (km) (KBCG20 only)
User_Zhypo = 55;   % Hypocentral Depth (km) (PSHAB20 only)
User_EventType = '0_Interface';   % Event Type, (Options: 0_Interface, 1_Intraslab)
User_Z1pt0 = 550;   % Z1.0 input (m) (KBCG20 only)
User_Z2pt5 = 2000;   % Z2.5 input (m)
User_Mb = 7.9;   % Mb (KBCG20 only, can set = default)
User_PNWbasinStrux = '0_NoBasin';   % PNW Basin Structure (Options: 0_NoBasin,1_InSeattleBasin,2_InOtherPNWbasin)(Cascadia Only)
User_RelativeWeight_KBCG20 = 1;   % Relative Weight -- KBCG20 
User_RelativeWeight_PSHAB20 = 0;   % Relative Weight -- PSHAB20
User_EpiInSigmaModels = '1_Yes';   % Apply KBCG20 Epistemic to Sigma Models (Options: 0_None, 1_AllModels)
User_NsampleEpi = 100;   % Number of Samples in Epistemic-Uncertainty Calculation (0=none, Range: 100-800)
User_Nsigma = 1;   % Number of Sigma away from Median







User_PeriodList = [0.01,0.02,0.03,0.05,0.075,0.1,0.15,0.2,0.25,0.3,0.4,0.5,0.75,1,1.5,2,3,4,5,7.5,10,"PGA","PGV"]; % range:0.01-10sec (PGA: T=0, PGV: T=-1)



% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% the following commands compute the output values at each period and generate a figure of the data
% The user may edit these lines, if needed
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Compute Values at each Period


    disp( ' %%% Computing Spectra for Single Scenario')
    for iRow = 1:length(User_PeriodList)
        thisT = getTvalue(User_PeriodList(iRow));
        outTlist(iRow) = thisT;
        
        outMedianList(iRow) = NGAsubGMM_MedianPlusMinusSigma(thisT, User_Region,User_Magnitude,User_Vs30,User_Rrup,User_AlphaBackarc,User_AlphaNankai,User_Ztor,User_Zhypo,User_EventType,User_Z1pt0,User_Z2pt5,User_Mb,User_SubductionSlab,User_PNWbasinStrux,User_RelativeWeight_KBCG20,User_RelativeWeight_PSHAB20, 0,0,0);
        outMedianMinusNSigmaList(iRow) = NGAsubGMM_MedianPlusMinusSigma(thisT,  User_Region,User_Magnitude,User_Vs30,User_Rrup,User_AlphaBackarc,User_AlphaNankai,User_Ztor,User_Zhypo,User_EventType,User_Z1pt0,User_Z2pt5,User_Mb,User_SubductionSlab,User_PNWbasinStrux,User_RelativeWeight_KBCG20,User_RelativeWeight_PSHAB20, -1*User_Nsigma,User_EpiInSigmaModels,User_NsampleEpi);
        outMedianPlusNSigmaList(iRow) = NGAsubGMM_MedianPlusMinusSigma(thisT, User_Region,User_Magnitude,User_Vs30,User_Rrup,User_AlphaBackarc,User_AlphaNankai,User_Ztor,User_Zhypo,User_EventType,User_Z1pt0,User_Z2pt5,User_Mb,User_SubductionSlab,User_PNWbasinStrux,User_RelativeWeight_KBCG20,User_RelativeWeight_PSHAB20, +1*User_Nsigma,User_EpiInSigmaModels,User_NsampleEpi);

        inputArray(iRow,:) = {thisT, User_Region,User_Magnitude,User_Vs30,User_Rrup,User_AlphaBackarc,User_AlphaNankai,User_Ztor,User_Zhypo,User_EventType,User_Z1pt0,User_Z2pt5,User_Mb,User_SubductionSlab,User_PNWbasinStrux,User_RelativeWeight_KBCG20,User_RelativeWeight_PSHAB20,User_Nsigma};

        %%%% Individual-Model Data:
        Prog_MbDefault = getMbDefault("KBCG20",User_EventType,User_Region,User_SubductionSlab);
        if User_Mb>0
            inUser_Mb = User_Mb;
        else
            inUser_Mb = Prog_MbDefault;
        end
        outKBCG20_MedianPSA	= KBCG20_medPSA(thisT, User_Magnitude,User_Rrup, User_AlphaBackarc, User_AlphaNankai, User_Ztor, User_EventType, User_Vs30,User_Z1pt0,User_Z2pt5, inUser_Mb,User_Region,User_PNWbasinStrux);
        outKBCG20_Tau	= KBCG20_sigmaTau(thisT);
        outKBCG20_Phi	= KBCG20_sigmaPhi(thisT);
        outKBCG20_SigmaAleatory	= KBCG20_sigmaAleatory(thisT);
        outKBCG20_SigmaEpistemic	= KBCG20_SigmaEpistemic(thisT, User_Magnitude,User_Rrup, User_AlphaBackarc, User_AlphaNankai, User_Ztor, User_EventType, User_Vs30,User_Z1pt0,User_Z2pt5, inUser_Mb,User_Region,User_NsampleEpi,User_PNWbasinStrux);
        outKBCG20_SigmaTotal	= KBCG20_SigmaTotal(thisT, User_Magnitude,User_Rrup, User_AlphaBackarc, User_AlphaNankai, User_Ztor, User_EventType, User_Vs30,User_Z1pt0,User_Z2pt5, inUser_Mb,User_Region,User_NsampleEpi,User_PNWbasinStrux);
        outKBCG20_Median_minus_1_SigmaTotal	= exp( log(outKBCG20_MedianPSA)-User_Nsigma*outKBCG20_SigmaTotal);
        outKBCG20_Median_plus_1_SigmaTotal	= exp( log(outKBCG20_MedianPSA)+User_Nsigma*outKBCG20_SigmaTotal);
        outKBCG20_Median_minus_1_SigmaAleatory	= exp( log(outKBCG20_MedianPSA)-User_Nsigma*outKBCG20_SigmaAleatory);
        outKBCG20_Median_plus_1_SigmaAleatory	= exp( log(outKBCG20_MedianPSA)+User_Nsigma*outKBCG20_SigmaAleatory);
        outKBCG20_Median_minus_1_SigmaEpistemic	= exp( log(outKBCG20_MedianPSA)-User_Nsigma*outKBCG20_SigmaEpistemic);
        outKBCG20_Median_plus_1_SigmaEpistemic	= exp( log(outKBCG20_MedianPSA)+User_Nsigma*outKBCG20_SigmaEpistemic);
        outPSHAB20_MedianPSA	= PSHAB20_Median(User_EventType, User_Region, User_SubductionSlab, User_Rrup, User_Magnitude, User_Zhypo, thisT, User_Vs30, User_Z2pt5, User_PNWbasinStrux);
        outPSHAB20_Tau	= PSHAB20_Tau(thisT, User_Rrup, User_Vs30);
        outPSHAB20_PhiTot	= PSHAB20_PhiTot(thisT, User_Rrup, User_Vs30);
        outPSHAB20_PhiS2S	= PSHAB20_SigmaS2S(thisT, User_Rrup, User_Vs30);
        outPSHAB20_PhiSS	= PSHAB20_SigmaSS(thisT, User_Rrup, User_Vs30);
        outPSHAB20_SigmaAleatory	= PSHAB20_SigmaAleatory(thisT, User_Rrup, User_Vs30);
        outPSHAB20_SigmaEpistemic = PSHAB20_SigmaEpistemic(thisT, User_EventType, User_SubductionSlab);
        outPSHAB20_SigmaTotal	=PSHAB20_SigmaTotal(thisT, User_Rrup,  User_Vs30, User_EventType, User_SubductionSlab );
        outPSHAB20_Median_minus_1_SigmaTotal	= exp(log(outPSHAB20_MedianPSA)-User_Nsigma*outPSHAB20_SigmaTotal);
        outPSHAB20_Median_plus_1_SigmaTotal	= exp(log(outPSHAB20_MedianPSA)+User_Nsigma*outPSHAB20_SigmaTotal);
        outPSHAB20_Median_minus_1_SigmaAleatory	= exp(log(outPSHAB20_MedianPSA)-User_Nsigma*outPSHAB20_SigmaAleatory);
        outPSHAB20_Median_plus_1_SigmaAleatory	= exp(log(outPSHAB20_MedianPSA)+User_Nsigma*outPSHAB20_SigmaAleatory);
        outPSHAB20_Median_minus_1_SigmaEpistemic	= exp(log(outPSHAB20_MedianPSA)-User_Nsigma*outPSHAB20_SigmaEpistemic);
        outPSHAB20_Median_plus_1_SigmaEpistemic	= exp(log(outPSHAB20_MedianPSA)+User_Nsigma*outPSHAB20_SigmaEpistemic);
        outIndivModelData(iRow,:) = [thisT,outKBCG20_MedianPSA,outKBCG20_Tau,outKBCG20_Phi,outKBCG20_SigmaAleatory,outKBCG20_SigmaEpistemic,outKBCG20_SigmaTotal,outKBCG20_Median_minus_1_SigmaTotal,outKBCG20_Median_plus_1_SigmaTotal,outKBCG20_Median_minus_1_SigmaAleatory,outKBCG20_Median_plus_1_SigmaAleatory,outKBCG20_Median_minus_1_SigmaEpistemic,outKBCG20_Median_plus_1_SigmaEpistemic,outPSHAB20_MedianPSA,outPSHAB20_Tau,outPSHAB20_PhiTot,outPSHAB20_PhiS2S,outPSHAB20_PhiSS,outPSHAB20_SigmaAleatory,outPSHAB20_SigmaEpistemic,outPSHAB20_SigmaTotal,outPSHAB20_Median_minus_1_SigmaTotal,outPSHAB20_Median_plus_1_SigmaTotal,outPSHAB20_Median_minus_1_SigmaAleatory,outPSHAB20_Median_plus_1_SigmaAleatory,outPSHAB20_Median_minus_1_SigmaEpistemic,outPSHAB20_Median_plus_1_SigmaEpistemic];
    end

    % combine Data for output
    InputTable = cell2table(inputArray);
    InputTable.Properties.VariableNames = {'User_Tperiod','User_Region','User_Magnitude','User_Vs30','User_Rrup','User_AlphaBackarc','User_AlphaNankai','User_Ztor','User_Zhypo','User_EventType','User_Z1pt0','User_Z2pt5','User_Mb','User_SubductionSlab','User_PNWbasinStrux','User_RelativeWeight_KBCG20','User_RelativeWeight_PSHAB20','Nsigma'}';
    % weighted-average data
    outDataTableScenario = table(outTlist.',outMedianList.',outMedianMinusNSigmaList.',outMedianPlusNSigmaList.');
    outDataTableScenario.Properties.VariableNames = {'Period_s','PSA_median_g','PSA_median-N*Sigma_g','PSA_median+N*Sigma_g'};
    % Individual-Model Data:
    outIndivModelDataTable = array2table(outIndivModelData);
    outIndivModelDataTable.Properties.VariableNames = {'Period__s','KBCG20_MedianPSA','KBCG20_Tau','KBCG20_Phi','KBCG20_SigmaAleatory','KBCG20_SigmaEpistemic','KBCG20_SigmaTotal','KBCG20_Median_minus_1*SigmaTotal','KBCG20_Median_plus_1*SigmaTotal','KBCG20_Median_minus_1*SigmaAleatory','KBCG20_Median_plus_1*SigmaAleatory','KBCG20_Median_minus_1*SigmaEpistemic','KBCG20_Median_plus_1*SigmaEpistemic','PSHAB20_MedianPSA','PSHAB20_Tau','PSHAB20_PhiTot','PSHAB20_PhiS2S','PSHAB20_PhiSS','PSHAB20_SigmaAleatory','outPSHAB20_SigmaEpistemic','PSHAB20_SigmaTotal','PSHAB20_Median_minus_1*SigmaTotal','PSHAB20_Median_plus_1*SigmaTotal','PSHAB20_Median_minus_1*SigmaAleatory','PSHAB20_Median_plus_1*SigmaAleatory','PSHAB20_Median_minus_1*SigmaEpistemic','PSHAB20_Median_plus_1*SigmaEpistemic'};
    % combine
    outAllScenarioDataTable = [InputTable outDataTableScenario outIndivModelDataTable];
    
    disp('Scenario Input Data:');
    disp(InputTable(1,:));
    disp('Scenario Individual-Model Data:');
    disp(outIndivModelDataTable);
    disp('Scenario Weighted-Average Data:');
    disp(outDataTableScenario);
    outputFilename = 'NGAsubduction_GMMtool_Matlab_Out_ScenarioData.csv';
    writetable(outAllScenarioDataTable,outputFilename,'QuoteStrings',1);
    disp("Scenario-Study Results have been saved to " + outputFilename);
    
    
   
    % %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % --------------------------------------------------------------------
    figure()
    loglog(outTlist(1:end-2),outMedianList(1:end-2),'k','LineWidth',2)
    evalc('hold');;
    loglog(outTlist(1:end-2),outMedianMinusNSigmaList(1:end-2),'b--','LineWidth',2)
    loglog(outTlist(1:end-2),outMedianPlusNSigmaList(1:end-2),'b-.','LineWidth',2)
    legend("Median: M=" +User_Magnitude +",Rrup=" + User_Rrup + "km, Vs30=" + User_Vs30 + "m/s","Median-"+User_Nsigma+"*Sigma","Median+"+User_Nsigma+"*Sigma",'Location','southwest')
    xlabel("Period (sec)")
    ylabel("PSA RotD50 5%damp (g)")
    grid on


%%%%%
% The following script performs a large sensitivity study (see last function in this file)
% Running this sensitivity study make take a few minutes.
% The results from this study are output to a screen a to a csv file
 
 RunSensitivityStudy;  % uncomment to run this


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% program DO NOT edit lines below!!!
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function initializeTool()
    clc
    clear all
    close all
    disp(' %%% -- NGA-Subduction: ');
    disp(' %%%                  Ground-Motion Characterization Tool');
    disp(' %%%                  smazzoni@ucla.edu');
    disp(' %%%');
end

function thisT = getTvalue(thisTin)
    % code developed and written by Silvia Mazzoni
    %       smazzoni@ucla.edu, April 2020
    if isstring(thisTin)==1
        if lower(thisTin) == lower("PGA")
            thisT=0;
        elseif lower(thisTin) == lower("PGV")
            thisT=-1;
        else
            thisT = double(thisTin);
        end
    else
        thisT = thisTin;
    end
end










% logistc hinge function
function loghingeValue = loghinge(x, x0, a, b0, b1, delta)
    % CODE DEVELOPED/IMPLEMENTED BY
    %          Silvia Mazzoni, 2020
    %           smazzoni@ucla.edu
  loghingeValue = (a + b0 * (x - x0) + (b1 - b0) * delta * log(1 + exp((x - x0) / delta)));
end

% interpolation of adjustment to magnitude break point
function interp_dmbValue = interp_dmb(period)
    % CODE DEVELOPED/IMPLEMENTED BY
    %          Silvia Mazzoni, 2020
    %           smazzoni@ucla.edu
 
  Aarray = [0.01, 1, 3, 10];
  Carray = [0, 0, -0.4, -0.4];
  if period == 0 
    interp_dmbValue = interpolateArray(0.01, Aarray, Carray, "log", "linear", "constant");
  elseif period == -1 
    interp_dmbValue = 0;
  else
    interp_dmbValue = interpolateArray(period, Aarray, Carray, "log", "linear", "constant");
  end
end

% interpolation of k1/k2 (values taken from Campbell and Bozorgnia (2014)
function interp_k1k2Value = interp_k1k2(period)
    % CODE DEVELOPED/IMPLEMENTED BY
    %          Silvia Mazzoni, 2020
    %           smazzoni@ucla.edu
  periods = [0.005, 0.01, 0.02, 0.03, 0.05, 0.075, 0.1, 0.15, 0.2, 0.25, 0.3, 0.4, 0.5, 0.75, 1., 1.5, 2., 3., 4., 5., 7.5, 10.];
  k1 = [865., 865., 865., 908., 1054., 1086., 1032., 878., 748., 654., 587., 503., 457., 410.,400., 400., 400., 400., 400., 400., 400., 400.];
  k2 = [-1.186, -1.186, -1.219, -1.273, -1.346, -1.471, -1.624, -1.931, -2.188, -2.381, -2.518,-2.657, -2.669, -2.401, -1.955, -1.025, -0.299, 0., 0., 0., 0., 0.];
  
  if period == 0 
      ap_k1 = interpolateArray(0.005, periods, k1, "log", "linear", "constant");
      ap_k2 = interpolateArray(0.005, periods, k2, "log", "linear", "constant");
  elseif period == -1 
      ap_k1 = 400.0;
      ap_k2 = -1.995;
  else
     ap_k1 = interpolateArray(period, periods, k1, "log", "linear", "constant");
      ap_k2 = interpolateArray(period, periods, k2, "log", "linear", "constant");
  end
    interp_k1k2Value = [ap_k1, ap_k2];
end


% funcation to calculate Z_1/Z2pt5 from Vs30
function calc_z_from_Vs30Value = calc_z_from_Vs30(Vs30, coeffs)
    % CODE DEVELOPED/IMPLEMENTED BY
    %          Silvia Mazzoni, 2020
    %           smazzoni@ucla.edu
  
  zref = coeffs(1) + (coeffs(2) - coeffs(1)) * exp((log(Vs30) - coeffs(3)) / coeffs(4)) / (1 + exp((log(Vs30) - coeffs(3)) / coeffs(4)));
  
  calc_z_from_Vs30Value = zref;
  
end





%%% function to calculate median prediction

%The following function calculates the median prediction of KBCG20, as described in chapter 4 of the PEER report.
%It takes as input the predictor variables, as well as a set of coefficients.
%Later, we define a function that acts as a wrapper around this function, and will take as input period, region index, and  select the appropriate coefficients and pass them on.
%
%The inputs are

% `m`: moment magnitude
% `rlist`: a vector of length 3, which contains the distance in subregion 1,2,3 relative to volcanic arc; `rlist = c(R1,R2,R3)`. Typically, `R1=R3=0` (corresponding to forearc).
% `ztor`: depth to top of rupture in km.
% `EventType`: flag for interface (`EventType = 0`) and intraslab (`EventType = 1`). Must be 0 || 1.
% `Vs30`: $V_{S30}$ n m/s.
% `fx`: arc crossing flag. Must be 0 || 1.
% `delta_ln_z`: difference between natural log of observed Z1.0/Z2.5 value and reference Z1.0/Z2.5 from $V_{S30}$.
% `coeffs`: vector containing coefficients needed to calculate median prediction.
% `coeffs_attn`: vector of length 6 to calcualte anelastic attenuation.
% `mbreak` and `zbreak`: magnitude and depth scaling break point
% `k1` and `k2`: parameters needed for site amplification
% `nft1` and `nft2`: coefficients needed for pseudo-depth term.
% `pgarock`: median pga prediction at $V_{S30} = 1100$

% function to calculate median prediction

function KBCG20_medValue = KBCG20_med(M, Rrup, AlphaBackarc, AlphaNankai, Ztor, EventType, Vs30, delta_ln_z, coeffs, coeffs_attn, coeffs_z, mbreak, zbreak, k1, k2, nft1, nft2, pgarock, region)
      % CODE DEVELOPED/IMPLEMENTED BY
    %          Silvia Mazzoni, 2020
    %           smazzoni@ucla.edu
 

  if LeftNumber(region, 1) == 1 
        distR1 = 0;
        distR3 = 0;
   elseif LeftNumber(region, 1) == 2 
        distR1 = 0;
        distR3 = 0;
   elseif LeftNumber(region, 1) == 3 
        distR1 = AlphaBackarc * Rrup;
        distR3 = 0;
   elseif LeftNumber(region, 1) == 4 
        distR1 = AlphaBackarc * Rrup;
        distR3 = AlphaNankai * Rrup;
   elseif LeftNumber(region, 1) == 5 
        distR1 = 0;
        distR3 = 0;
   elseif LeftNumber(region, 1) == 6 
        distR1 = AlphaBackarc * Rrup;
        distR3 = 0;
   elseif LeftNumber(region, 1) == 7 
        distR1 = 0;
        distR3 = 0;
   else  % reg=0
        distR1 = AlphaBackarc * Rrup;
        distR3 = 0;
   end

    distR2 = Rrup - distR1 - distR3;
    
   
   
  theta10 = 0;
  vsrock = 1100;
  c = 1.88;
  n = 1.18;
  minmb = 6.;
  delta = 0.1;
  deltaz = 1;
  refzif = 15;
  refzslab = 50;
  thisFs = (LeftNumber(EventType, 1));

    %check if cross arc:
        fx = 1;
        if distR1 == 0 && distR2 == 0 
            fx = 0;
        end
        if distR2 == 0 && distR3 == 0 
            fx = 0;
        end
        if distR1 == 0 && distR3 == 0 
            fx = 0;
        end
  
  fmag = (1 - thisFs) * loghinge(M, mbreak, coeffs(6) * (mbreak - minmb), coeffs(6), coeffs(8), delta) + thisFs * loghinge(M, mbreak, coeffs(7) * (mbreak - minmb), coeffs(7), coeffs(8), delta);
  fgeom = (1 - thisFs) * (coeffs(3) + coeffs(5) * M) * log(Rrup + 10 ^ (nft1 + nft2 * (M - 6)));
  fgeom_slab = thisFs * (coeffs(4) + coeffs(5) * M) * log(Rrup + 10 ^ (nft1 + nft2 * (M - 6)));
  fdepth = (1 - thisFs) * loghinge(Ztor, zbreak, coeffs(12) * (zbreak - refzif), coeffs(12), theta10, deltaz) + thisFs * loghinge(Ztor, zbreak, coeffs(13) * (zbreak - refzslab), coeffs(13), theta10, deltaz);
  

    DotProduct123 = distR1 * coeffs_attn(1) + distR2 * coeffs_attn(2) + distR3 * coeffs_attn(3);
    DotProduct456 = distR1 * coeffs_attn(4) + distR2 * coeffs_attn(5) + distR3 * coeffs_attn(6);

  fattn = fx * DotProduct123 + (1 - fx) * DotProduct456 + fx * coeffs(14);

  
  if Vs30 < k1
    fsite = coeffs(11) * log(Vs30 / k1) + k2 * (log(pgarock + c * (Vs30 / k1) ^ n) - log(pgarock + c));
  else
    fsite = (coeffs(11) + k2 * n) * log(Vs30 / k1);
  end

  fbasin = coeffs_z(1) + coeffs_z(2) * delta_ln_z;

  Median = (1 - thisFs) * coeffs(1) + thisFs * coeffs(2) + fmag + fgeom + fgeom_slab + fdepth + fattn + fsite + fbasin;
  KBCG20_medValue = Median;

end



%%% function to calculate median prediction for a given scenario and period
%This is a function that calculates median predictions of KBCG20 for a given scenario.
%I takes as input period, the predictor variables for the scenarios, selects the appropriate coefficients/parameters, and calls the function defined in the previous section.
%
%The arguments are similar to the function before.

% `m`: moment magnitude
% `rlist`: a vector of length 3, which contains the distances in subregion 1,2,3 relative to volcanic arc; `rlist = array(R1,R2,R3)`. for regions Alaska, Cascadia, New Zealand, and Taiwan, $R1 = R2 = 0$.
% `ztor`: depth to top of rupture in km.
% `EventType`: flag for interface (`EventType = 0`) and intraslab (`EventType = 1`). Must be 0 || 1.
% `Vs30`: $V_{S30}$ n m/s.
% `Z1pt0`: depth to a shear wave horizon of 1000 m/s, in m. Used for regions Alaska and New Zealand.
% `Z2pt5`: depth to a shear wave horizon of 2500 m/s, in m. Used for regions Cascadia and Japan.
% `fx`: arc crossing flag. Must be 0 || 1.
% `mb`: Magnitude scaling break point. Should be set regionally dependent based on Campbell (2020).

%The last input is a region index `region`, which is as follows:
%
%* 0: global
%* 1: Alaska
%* 2: Cascadia
%* 3: Central America & Mexico
%* 4: Japan
%* 5: New Zealand
%* 6: South America
%* 7: Taiwan
%
%The opional argumen `Seattle_Basin` is a flag that should be set to `TRUE`
%if the site is in the Seattle Basin, and `FALSE` otherwise. % 10/28/2020:
%this has changed
%This flag determines which basin depth amplification model is used for Cascadia.
%It does not have an impact on any other region.
%


function KBCG20_medPSAValue = KBCG20_medPSA(period, Magnitude, Rrup, AlphaBackarc, AlphaNankai, Ztor, EventType, Vs30, Z1pt0, Z2pt5, Mb, UserRegion, PNWbasinStrux)
    % CODE DEVELOPED/IMPLEMENTED BY
    %          Silvia Mazzoni, 2020
    %           smazzoni@ucla.edu

 


    thisOut = -999;
    XinterpMin = 0;
    XinterpMax = 10;
    XinterpType = "log";
    YinterpType = "log";
    extrapolateType = "extrapolate";

    Parameters = readtable('NGAsubGMM_KBCG20_coefficients.csv','PreserveVariableNames',true);
    TvalueList = Parameters.T;
    InterpArray = interpolateFunction(period, TvalueList, XinterpType, extrapolateType, XinterpMin, XinterpMax);
    
    period0 = TvalueList(InterpArray(1), 1);
    y0 = KBCG20_medPSA_AtTlist(period0, Magnitude, Rrup, AlphaBackarc, AlphaNankai, Ztor, EventType, Vs30, Z1pt0, Z2pt5, Mb, UserRegion, PNWbasinStrux);
    
    if InterpArray(2) <= 0 
        thisOut = y0;
    else
        period1 = TvalueList(InterpArray(2), 1);
        y1 = KBCG20_medPSA_AtTlist(period1, Magnitude, Rrup, AlphaBackarc, AlphaNankai, Ztor, EventType, Vs30, Z1pt0, Z2pt5, Mb, UserRegion, PNWbasinStrux);
        if lower(LeftString(YinterpType, strlength("log"))) == lower("log") 
            if y0 <= 0 
                y0 = 0.000000001;
            end
            if y1 <= 0 
                y1 = 0.000000001;
            end
            y0 = log(y0);
            y1 = log(y1);
        end
        thisOut = y0 + (y1 - y0) * InterpArray(3);
        if lower(LeftString(YinterpType, strlength("log"))) == lower("log") 
            thisOut = exp(thisOut);
        end

    end
    
    KBCG20_medPSAValue = thisOut;

end


% function to calculate median prediction using mean coefficients
function KBCG20_medPSA_AtTlistValue = KBCG20_medPSA_AtTlist(period, M, Rrup, AlphaBackarc, AlphaNankai, Ztor, EventType, Vs30, Z1pt0, Z2pt5, Mb, region, PNWbasinStrux)
    % CODE DEVELOPED/IMPLEMENTED BY
    %          Silvia Mazzoni, 2020
    %           smazzoni@ucla.edu

    KBCG20_medPSA_AtTlistValue = -999;
  % need to add some checks for input (period, region)
  % coefficients to calculate zref from vs30
  pars_z_ja = [7.6893685375, 2.30258509299405, 6.3091864, 0.7528670225, 1.2952369625];
  pars_z_casc = [8.29404964010203, 2.30258509299405, 6.39692965521615, 0.27081459, 1.7381352625];
  pars_z_nz = [6.859789675, 2.30258509299405, 5.745692775, 0.91563524375, 1.03531412375];
  pars_z_tw = [6.30560665, 2.30258509299405, 6.1104992125, 0.43671102, 0.7229702975];
  
  Parameters = readtable('NGAsubGMM_KBCG20_coefficients.csv','PreserveVariableNames',true);
  parameters_zmod = readtable("NGAsubGMM_KBCG20_params_Z_ALL_allregca_attn3_corrreg_cs_dmb.csv",'PreserveVariableNames',true);

  % calculate rock PGA
  period_used = 0.;
  vsrock = 1100;
  pars_period = getRangeRowT(Parameters, period_used);
  pars_period_zmod = getRangeRowT(parameters_zmod, period_used) ; % silviamazzoni: I added this

  coeffs = getSubArrayRange(pars_period, 2, 15);
  k1k2 = interp_k1k2(period_used);
  dmb = 0;

  delta_ln_z = 0;
  coeffs_z = [0, 0];
  coeffs_z2 = [0, 0];

  if LeftNumber(region, 1) == 1 
    coeffs = updateArray(coeffs, [1, 2, 11], pars_period, [17, 24, 31]);
    coeffs_attn = makeArray(pars_period, [38, 45, 52, 59, 66, 73]);
   elseif LeftNumber(region, 1) == 2 
    coeffs = updateArray(coeffs, [1, 2, 11], pars_period, [18, 25, 32]);
    coeffs_attn = makeArray(pars_period, [39, 46, 53, 60, 67, 74]);
    if LeftNumber(PNWbasinStrux, 1) == 1
        coeff_seattle = getRangeValueT(parameters_zmod, period_used, "mean_residual_Seattle_basin");
        coeffs_z2 = [coeff_seattle, 0];
    elseif LeftNumber(PNWbasinStrux, 1) == 2
        coeffs_z2 = makeArray(pars_period_zmod, [2, 3]);
    end
   elseif LeftNumber(region, 1) == 3 
    coeffs = updateArray(coeffs, [1, 2, 11], pars_period, [19, 26, 33]);
    coeffs_attn = makeArray(pars_period, [40, 47, 54, 61, 68, 75]);
   elseif LeftNumber(region, 1) == 4 
	dmb = interp_dmb(period_used);
    coeffs = updateArray(coeffs, [1, 2, 11], pars_period, [20, 27, 34]);
    coeffs_attn = makeArray(pars_period, [41, 48, 55, 62, 69, 76]);
    coeffs_z2 = makeArray(pars_period_zmod, [5, 6]);
   elseif LeftNumber(region, 1) == 5 
    coeffs = updateArray(coeffs, [1, 2, 11], pars_period, [21, 28, 35]);
    coeffs_attn = makeArray(pars_period, [42, 49, 56, 63, 70, 77]);
    coeffs_z2 = makeArray(pars_period_zmod, [7, 8]);
   elseif LeftNumber(region, 1) == 6 
	dmb = interp_dmb(period_used);
    coeffs = updateArray(coeffs, [1, 2, 11], pars_period, [22, 29, 36]);
    coeffs_attn = makeArray(pars_period, [43, 50, 57, 64, 71, 78]);
   elseif LeftNumber(region, 1) == 7 
    coeffs = updateArray(coeffs, [1, 2, 11], pars_period, [23, 30, 37]);
    coeffs_attn = makeArray(pars_period, [44, 51, 58, 65, 72, 79]);
    coeffs_z2 = makeArray(pars_period_zmod, [9, 10]);
   else  % LeftNumber(region,1)==0
    coeffs_attn = makeArray(pars_period, [11, 11, 11, 11, 10, 11]);
    delta_ln_z = 0;
    coeffs_z = [0, 0];
  end

   
  delta_bz = makeArray(pars_period, [80, 81]);
  coeffs_nft = makeArray(pars_period, [82, 83]);
  thisFs = (LeftNumber(EventType, 1));
  mbreak = (1 - thisFs) * (Mb + dmb) + thisFs * Mb;
  zbreak = (1 - thisFs) * (30 + delta_bz(1)) + thisFs * (80 + delta_bz(2));
 
  mbreak_pga = mbreak;
  zbreak_pga = zbreak;
  k1k2_pga = k1k2;
  coeffs_pga = coeffs;   % silviamazzoni: I added this so I alway have coeffs
  coeffs_attn_pga = coeffs_attn;
  coeffs_z_pga = coeffs_z;
  coeffs_z_pga2 = coeffs_z2;
  coeffs_nft_pga = coeffs_nft;
  pgarock = exp(KBCG20_med(M, Rrup, AlphaBackarc, AlphaNankai, Ztor, EventType, vsrock, delta_ln_z, coeffs_pga, coeffs_attn_pga, coeffs_z_pga, mbreak_pga, zbreak_pga, k1k2_pga(1), k1k2_pga(2), coeffs_nft_pga(1), coeffs_nft_pga(2), 0, region));
  
  % calculate PSA
  period_used = period;
  pars_period = getRangeRowT(Parameters, period_used);
  pars_period_zmod = getRangeRowT(parameters_zmod, period_used) ;% silviamazzoni: I added this
  coeffs = getSubArrayRange(pars_period, 2, 15);
  k1k2 = interp_k1k2(period_used);
  dmb = 0;
  

    delta_ln_z = 0;
    coeffs_z = [0, 0];
  if LeftNumber(region, 1) == 1 
    coeffs = updateArray(coeffs, [1, 2, 11], pars_period, [17, 24, 31]);
    coeffs_attn = makeArray(pars_period, [38, 45, 52, 59, 66, 73]);
   elseif LeftNumber(region, 1) == 2 
    coeffs = updateArray(coeffs, [1, 2, 11], pars_period, [18, 25, 32]);
    coeffs_attn = makeArray(pars_period, [39, 46, 53, 60, 67, 74]);
    if lower(Z2pt5) == 'default' | Z2pt5<0
    	delta_ln_z = 0;
    else
    	delta_ln_z = log(Z2pt5) - calc_z_from_Vs30(Vs30, pars_z_casc);
    end
    
    if LeftNumber(PNWbasinStrux, 1) == 1
        coeff_seattle = getRangeValueT(parameters_zmod, period_used, "mean_residual_Seattle_basin");
       coeffs_z = [coeff_seattle, 0];
    elseif LeftNumber(PNWbasinStrux, 1) == 2
        coeffs_z = makeArray(pars_period_zmod, [2, 3]);
    end
   elseif LeftNumber(region, 1) == 3 
    coeffs = updateArray(coeffs, [1, 2, 11], pars_period, [19, 26, 33]);
    coeffs_attn = makeArray(pars_period, [40, 47, 54, 61, 68, 75]);
   elseif LeftNumber(region, 1) == 4 
  	dmb = interp_dmb(period_used);
    coeffs = updateArray(coeffs, [1, 2, 11], pars_period, [20, 27, 34]);
    coeffs_attn = makeArray(pars_period, [41, 48, 55, 62, 69, 76]);
    if lower(Z2pt5) == 'default' | Z2pt5<0
    	delta_ln_z = 0;
    else
    	delta_ln_z = log(Z2pt5) - calc_z_from_Vs30(Vs30, pars_z_ja);
    end
    coeffs_z = makeArray(pars_period_zmod, [5, 6]);
   elseif LeftNumber(region, 1) == 5 
    coeffs = updateArray(coeffs, [1, 2, 11], pars_period, [21, 28, 35]);
    coeffs_attn = makeArray(pars_period, [42, 49, 56, 63, 70, 77]);
	if lower(Z1pt0) == 'default' | Z1pt0<0
	 	delta_ln_z = 0;
	else
    	delta_ln_z = log(Z1pt0) - calc_z_from_Vs30(Vs30, pars_z_nz);
	end
    coeffs_z = makeArray(pars_period_zmod, [7, 8]);
   elseif LeftNumber(region, 1) == 6 
  	dmb = interp_dmb(period_used);
    coeffs = updateArray(coeffs, [1, 2, 11], pars_period, [22, 29, 36]);
    coeffs_attn = makeArray(pars_period, [43, 50, 57, 64, 71, 78]);
   elseif LeftNumber(region, 1) == 7 
    coeffs = updateArray(coeffs, [1, 2, 11], pars_period, [23, 30, 37]);
    coeffs_attn = makeArray(pars_period, [44, 51, 58, 65, 72, 79]);
	if lower(Z1pt0) == 'default' | Z1pt0<0
	 	delta_ln_z = 0;
	else
    	delta_ln_z = log(Z1pt0) - calc_z_from_Vs30(Vs30, pars_z_tw);
	end
    coeffs_z = makeArray(pars_period_zmod, [9, 10]);
   else  % reg=0
    coeffs_attn = makeArray(pars_period, [11, 11, 11, 11, 10, 11]);
   end
  
  delta_bz = makeArray(pars_period, [80, 81]);
  coeffs_nft = makeArray(pars_period, [82, 83]);
  
  thisFs = (LeftNumber(EventType, 1));
  mbreak = (1 - thisFs) * (Mb + dmb) + thisFs * Mb;
  zbreak = (1 - thisFs) * (30 + delta_bz(1)) + thisFs * (80 + delta_bz(2));
  Med = KBCG20_med(M, Rrup, AlphaBackarc, AlphaNankai, Ztor, EventType, Vs30, delta_ln_z, coeffs, coeffs_attn, coeffs_z, mbreak, zbreak, k1k2(1), k1k2(2), coeffs_nft(1), coeffs_nft(2), pgarock, region);
  med_pga = KBCG20_med(M, Rrup, AlphaBackarc, AlphaNankai, Ztor, EventType, Vs30, delta_ln_z, coeffs_pga, coeffs_attn_pga, coeffs_z_pga2, mbreak_pga, zbreak_pga, k1k2_pga(1), k1k2_pga(2), coeffs_nft_pga(1), coeffs_nft_pga(2), pgarock, region);

  if Med < med_pga && period <= 0.1 
    Med = med_pga;
  end

  KBCG20_medPSA_AtTlistValue = exp(Med);
  
end

function getRangeRowTValue = getRangeRowT(thisRange, Xvalue)
    % CODE DEVELOPED/IMPLEMENTED BY
    %          Silvia Mazzoni, 2020
    %           smazzoni@ucla.edu
   getRangeRowTValue = table2array(thisRange(thisRange.T==Xvalue,:));
 
end


function getSubArrayRangeValue = getSubArrayRange(inArray, startIndex, endIndex)
    % CODE DEVELOPED/IMPLEMENTED BY
    %          Silvia Mazzoni, 2020
    %           smazzoni@ucla.edu

    
    irow = 1;
    for thisIndex = startIndex : endIndex
        temP(irow) = inArray(thisIndex);
        irow = irow + 1;
    end
    getSubArrayRangeValue = temP;
end

function interpolateArrayValue = interpolateArray(Xpoint, Xlist, Ylist, XinterpType, YinterpType, extrapolateType,  XinterpMin , XinterpMax)
    % CODE DEVELOPED/IMPLEMENTED BY
    %          Silvia Mazzoni, 2020
    %           smazzoni@ucla.edu

    interpolateArrayValue = -999;
    if nargin<7
        XinterpMin = -1e16;
    end
    if nargin<8
        XinterpMax = +1e16;
    end
    
    irow = 0;
    start0 = -1;
    endrow0 = -1;
    [nrows,ncols] = size(Xlist);
        if nrows == 1 && ncols>0 
            Xlist = Xlist.';
        end
        [nrows,ncols] = size(Ylist);
        if nrows == 1 && ncols>0 
            Ylist = Ylist.';
        end
    [nrows,ncols] = size(Xlist);

    for irow = 1 : nrows
        this = Xlist(irow);
        if Xpoint == this 
            interpolateArrayValue = Ylist(irow);
            return
        end
        if this >= XinterpMin && this <= XinterpMax 
            if start0 < 0 
                start0 = irow;
            end
            end0 = irow;
        end
    end
   iend = irow ;
    istart = start0;
    Xstart = Xlist(start0);
    Xend = Xlist(end0);
    if (Xend - Xpoint) * (Xstart - Xpoint) <= 0  % point is within limits
        for i = istart : iend - 1
            thisx = Xlist(i);
            nextX = Xlist(i + 1);
            if (Xpoint - thisx) * (Xpoint - nextX) <= 0   % point is between these two
                l1 = i;
                l2 = i + 1;
                break
            end
        end
    else
        if (Xend - Xstart) * (Xend - Xpoint) > 0 
            l1 = istart;
            if LeftString(lower(extrapolateType), strlength("extra")) == lower("extra") 
                l2 = istart + 1;
            else
                l2 = istart;
            end
        else
            l1 = iend;
            if LeftString(lower(extrapolateType), strlength("extra")) == lower("extra") 
                l2 = iend - 1;
            else
                interpolateArrayValue = Ylist(end0);
                return
            end
        end
    end
    
    x0 = Xlist(l1);
    x1 = Xlist(l2);
    y0 = Ylist(l1);
    y1 = Ylist(l2);
    hereX = Xpoint;
    if lower(LeftString(XinterpType, strlength("log"))) == lower("log") 
        if x0 <= 0 
            x0 = 0.000000001;
        end
        if x1 <= 0 
            x1 = 0.000000002;
        end
        if hereX <= 0 
            hereX = 0.000000001;
        end
        x0 = log(x0);
        x1 = log(x1);
        hereX = log(hereX);
    end
    if lower(LeftString(YinterpType, strlength("log"))) == lower("log") 
        if y0 <= 0 
            y0 = 0.000000001;
        end
        if y1 <= 0 
            y1 = 0.000000001;
        end
        y0 = log(y0);
        y1 = log(y1);
    end
    interpolateArrayValue = y0 + (y1 - y0) * (hereX - x0) / (x1 - x0);
    

    if lower(LeftString(YinterpType, strlength("log"))) == lower("log") 
        interpolateArrayValue = exp(interpolateArrayValue);
    end
end

function LeftStringValue = LeftString(instring,ncars)
    inn =  char(instring);
    LeftStringValue = inn(1:ncars);
end
function LeftNumberValue = LeftNumber(instring,ncars)
    thisString = num2str(instring);
    inn =  char(thisString);
    LeftNumberValue=str2num(inn(1:ncars));
end


function makeArrayValue = makeArray(oldArray, oldArrayIndices)
    % CODE DEVELOPED/IMPLEMENTED BY
    %          Silvia Mazzoni, 2020
    %           smazzoni@ucla.edu

    
    newIndex = 1;
    [nrow,ncol] = size(oldArrayIndices);
    [nrowOldArray,ncolOldArray] = size(oldArrayIndices);
    
    nrowMax = nrow;
    if ncol>nrow
        nrowMax = ncol;
    end
   for irow = 1 : nrowMax
        if nrow==1 && ncol> 1 
            oldIndex = oldArrayIndices(1,irow);
        else
            oldIndex = oldArrayIndices(irow,1);
        end
       
        if nrowOldArray==1 && ncolOldArray > 1 
            newArray(newIndex) = oldArray(1,oldIndex);
        else
            newArray(newIndex) = oldArray(oldIndex,1);
        end
        newIndex = newIndex + 1;
   end
    makeArrayValue = newArray;
end

function updateArrayValue = updateArray(newArray, newArrayIndices, oldArray, oldArrayIndices)
    % CODE DEVELOPED/IMPLEMENTED BY
    %          Silvia Mazzoni, 2020
    %           smazzoni@ucla.edu

   
       [Nrow,Ncol]=size(oldArrayIndices);
       if Nrow==1 && Ncol>1 
           oldArrayIndices = oldArrayIndices.';
       end
      [NN,Ncol]=size(oldArrayIndices);
    for irow = 1 : NN
        oldIndex = oldArrayIndices(irow);
        newIndex = newArrayIndices(irow);

        newArray(newIndex) = oldArray(oldIndex);
    end
    updateArrayValue = newArray;
end


function interpolatefunctionValue = interpolateFunction(Xpoint, Xlist, XinterpType, extrapolateType, XinterpMin ,XinterpMax )
    % CODE DEVELOPED/IMPLEMENTED BY
    %          Silvia Mazzoni, 2020
    %           smazzoni@ucla.edu
 %   % % debug.print "interpolateFunction"
     if nargin<7
        XinterpMin = -1e16;
     end
     if nargin<8
        XinterpMax = +1e16;
    end
    interpolatefunctionValue = -999;
    irow = 0;
    start0 = -1;
    endrow0 = -1;
    [NN,CC] = size(Xlist);
    for irow = 1 : NN
        this = Xlist(irow, 1);
        if Xpoint == this 
            interpolatefunctionValue = [irow, -1, 0];
            return
        end
        if this >= XinterpMin && this <= XinterpMax 
            if start0 < 0 
                start0 = irow;
            end
            end0 = irow;
        end
    end
    iend = irow - 1;
    
    istart = start0;
    Xstart = Xlist(start0, 1);
    Xend = Xlist(end0, 1);
    
    if (Xend - Xpoint) * (Xstart - Xpoint) <= 0  % point is within limits
        for i = istart : iend - 1
            thisx = Xlist(i, 1);
            nextX = Xlist(i + 1, 1);
            if (Xpoint - thisx) * (Xpoint - nextX) <= 0   % point is between these two
                l1 = i;
                l2 = i + 1;
                break
            end
        end
    else
        if (Xend - Xstart) * (Xend - Xpoint) > 0 
            l1 = istart;
            if LeftString(lower(extrapolateType), strlength("extra")) == lower("extra") 
                l2 = istart + 1;
            else
                l2 = istart;
            end
        else
            l1 = iend;
            if LeftString(lower(extrapolateType), strlength("extra")) == lower("extra") 
                l2 = iend - 1;
            else
                interpolatefunctionValue = [end0, -1, 0];
                return
            end
        end
    end
    
        


%Interp:
    x0 = Xlist(l1, 1);
    x1 = Xlist(l2, 1);

    hereX = Xpoint;
    if lower(LeftString(XinterpType, strlength("log"))) == lower("log") 
        if x0 <= 0 
            x0 = 0.000000001;
        end
        if x1 <= 0 
            x1 = 0.000000002;
        end
        if hereX <= 0 
            hereX = 0.000000001;
        end
        x0 = log(x0);
        x1 = log(x1);
        hereX = log(hereX);
    end

    interpolatefunctionValue = [l1, l2, (hereX - x0) / (x1 - x0)];
    

end

function KBCG20_posteriorAtTlistValue =  KBCG20_posteriorAtTlist(period, M, Rrup, AlphaBackarc, AlphaNankai, Ztor, EventType, Vs30, Z1pt0, Z2pt5, Mb, region, num_samples, PNWbasinStrux )
    % CODE DEVELOPED/IMPLEMENTED BY
    %          Silvia Mazzoni, 2020
    %           smazzoni@ucla.edu
  % need to add some checks for input (period, region)
  
    KBCG20_posteriorAtTlistValue = -999;
    if nargin<13
        num_samples = 100;
    end
    if nargin<14
        PNWbasinStrux = 0;
    end

  pars_z_ja = [7.6893685375, 2.30258509299405, 6.3091864, 0.7528670225, 1.2952369625];
  pars_z_casc = [8.29404964010203, 2.30258509299405, 6.39692965521615, 0.27081459, 1.7381352625];
  pars_z_nz = [6.859789675, 2.30258509299405, 5.745692775, 0.91563524375, 1.03531412375];
  pars_z_tw = [6.30560665, 2.30258509299405, 6.1104992125, 0.43671102, 0.7229702975];
  

  Parameters = readtable('NGAsubGMM_KBCG20_coefficients.csv','PreserveVariableNames',true);
 parameters_zmod = readtable("NGAsubGMM_KBCG20_params_Z_ALL_allregca_attn3_corrreg_cs_dmb.csv",'PreserveVariableNames',true);
    
  
  % calculate rock PGA
  thisPeriod = 0.;
  vsrock = 1100;
  pars_period = getRangeRowT(Parameters, thisPeriod);
  pars_period_zmod = getRangeRowT(parameters_zmod, thisPeriod) ; % silviamazzoni, I added this
  coeffs = getSubArrayRange(pars_period, 2, 15);
  k1k2 = interp_k1k2(thisPeriod);
  dmb = 0;
  
 
    delta_ln_z = 0;
    coeffs_z = [0, 0];
  if LeftNumber(region, 1) == 1 
    coeffs = updateArray(coeffs, [1, 2, 11], pars_period, [17, 24, 31]);
    coeffs_attn = makeArray(pars_period, [38, 45, 52, 59, 66, 73]);
   elseif LeftNumber(region, 1) == 2 
    coeffs = updateArray(coeffs, [1, 2, 11], pars_period, [18, 25, 32]);
    coeffs_attn = makeArray(pars_period, [39, 46, 53, 60, 67, 74]);
   elseif LeftNumber(region, 1) == 3 
    coeffs = updateArray(coeffs, [1, 2, 11], pars_period, [19, 26, 33]);
    coeffs_attn = makeArray(pars_period, [40, 47, 54, 61, 68, 75]);
   elseif LeftNumber(region, 1) == 4 
  	dmb = interp_dmb(thisPeriod);
    coeffs = updateArray(coeffs, [1, 2, 11], pars_period, [20, 27, 34]);
    coeffs_attn = makeArray(pars_period, [41, 48, 55, 62, 69, 76]);
   elseif LeftNumber(region, 1) == 5 
    coeffs = updateArray(coeffs, [1, 2, 11], pars_period, [21, 28, 35]);
    coeffs_attn = makeArray(pars_period, [42, 49, 56, 63, 70, 77]);
   elseif LeftNumber(region, 1) == 6 
  	dmb = interp_dmb(thisPeriod);
    coeffs = updateArray(coeffs, [1, 2, 11], pars_period, [22, 29, 36]);
    coeffs_attn = makeArray(pars_period, [43, 50, 57, 64, 71, 78]);
   elseif LeftNumber(region, 1) == 7 
    coeffs = updateArray(coeffs, [1, 2, 11], pars_period, [23, 30, 37]);
    coeffs_attn = makeArray(pars_period, [44, 51, 58, 65, 72, 79]);
   else  % reg=0
    coeffs_attn = makeArray(pars_period, [11, 11, 11, 11, 10, 11]);
  end
  
  
  delta_bz = makeArray(pars_period, [80, 81]);
  coeffs_nft = makeArray(pars_period, [82, 83]);
  thisFs = (LeftNumber(EventType, 1));
  mbreak = (1 - thisFs) * (Mb + dmb) + thisFs * Mb;
  zbreak = (1 - thisFs) * (30 + delta_bz(1)) + thisFs * (80 + delta_bz(2));
    pgarock = exp(KBCG20_med(M, Rrup, AlphaBackarc, AlphaNankai, Ztor, EventType, vsrock, delta_ln_z, coeffs, coeffs_attn, coeffs_z, mbreak, zbreak, k1k2(1), k1k2(2), coeffs_nft(1), coeffs_nft(2), 0, region));
  
  
  % calculate PSA
  thisPeriod = period;
      Tnumeric=[-1,0,0.01,0.02,0.03,0.05,0.075,0.1,0.15,0.2,0.25,0.3,0.4,0.5,0.75,1,1.5,2,3,4,5,7.5,10];
    Tstring=["T-1.00","T00.00","T00.01","T00.02","T00.03","T00.05","T00.07","T00.10","T00.15","T00.20","T00.25","T00.30","T00.40","T00.50","T00.75","T01.00","T01.50","T02.00","T03.00","T04.00","T05.00","T07.50","T10.00"];
    KBCG20_PeriodMapData = table(Tnumeric.',Tstring.');


    thisTstring = KBCG20_PeriodMapData(KBCG20_PeriodMapData.Var1==thisPeriod,:).Var2;
    parameters_posterior = readtable('posterior_coefficients_KBCG20_' + thisTstring + '.csv','PreserveVariableNames',true);
  
  pars_period_zmod = getRangeRowT(parameters_zmod, thisPeriod) ; % silviamazzoni, I added this
  Parameters = readtable('NGAsubGMM_KBCG20_coefficients.csv','PreserveVariableNames',true);
  
  
  coeffs = getSubArrayRange(pars_period, 2, 15);
  k1k2 = interp_k1k2(thisPeriod);
  dmb = 0;

    
    for k = 1 : num_samples
        pars_period = table2array(parameters_posterior(k,:));
        
        coeffs = getSubArrayRange(pars_period, 2, 15);
        
          delta_ln_z = 0;
          coeffs_z = [0, 0];
        if LeftNumber(region, 1) == 1 
          coeffs = updateArray(coeffs, [1, 2, 11], pars_period, [17, 24, 31]);
          coeffs_attn = makeArray(pars_period, [38, 45, 52, 59, 66, 73]);
         elseif LeftNumber(region, 1) == 2 
          coeffs = updateArray(coeffs, [1, 2, 11], pars_period, [18, 25, 32]);
          coeffs_attn = makeArray(pars_period, [39, 46, 53, 60, 67, 74]);
		  if lower(Z2pt5) == 'default' | Z2pt5<0
		  	delta_ln_z = 0;
		  else
          	delta_ln_z = log(Z2pt5) - calc_z_from_Vs30(Vs30, pars_z_casc);
		  end
          
          if LeftNumber(PNWbasinStrux, 1) == 1 
              coeff_seattle = getRangeValueT(parameters_zmod, thisPeriod, "mean_residual_Seattle_basin");
              coeffs_z = [coeff_seattle, 0];
          elseif LeftNumber(PNWbasinStrux, 1) == 2
              coeffs_z = makeArray(pars_period_zmod, [2, 3]);
          end
         elseif LeftNumber(region, 1) == 3 
          coeffs = updateArray(coeffs, [1, 2, 11], pars_period, [19, 26, 33]);
          coeffs_attn = makeArray(pars_period, [40, 47, 54, 61, 68, 75]);
         elseif LeftNumber(region, 1) == 4 
  		  dmb = interp_dmb(thisPeriod);
          coeffs = updateArray(coeffs, [1, 2, 11], pars_period, [20, 27, 34]);
          coeffs_attn = makeArray(pars_period, [41, 48, 55, 62, 69, 76]);
		  if lower(Z2pt5) == 'default' | Z2pt5<0
		  	delta_ln_z = 0;
		  else
          	delta_ln_z = log(Z2pt5) - calc_z_from_Vs30(Vs30, pars_z_ja);
		  end
          coeffs_z = makeArray(pars_period_zmod, [5, 6]);;
         elseif LeftNumber(region, 1) == 5 
          coeffs = updateArray(coeffs, [1, 2, 11], pars_period, [21, 28, 35]);
          coeffs_attn = makeArray(pars_period, [42, 49, 56, 63, 70, 77]);
		  if lower(Z1pt0) == 'default' | Z1pt0<0
		  	delta_ln_z = 0;
		  else
          	delta_ln_z = log(Z1pt0) - calc_z_from_Vs30(Vs30, pars_z_nz);
		  end
          coeffs_z = makeArray(pars_period_zmod, [7, 8]);
         elseif LeftNumber(region, 1) == 6 
  		  dmb = interp_dmb(thisPeriod);
          coeffs = updateArray(coeffs, [1, 2, 11], pars_period, [22, 29, 36]);
          coeffs_attn = makeArray(pars_period, [43, 50, 57, 64, 71, 78]);
         elseif LeftNumber(region, 1) == 7 
          coeffs = updateArray(coeffs, [1, 2, 11], pars_period, [23, 30, 37]);
          coeffs_attn = makeArray(pars_period, [44, 51, 58, 65, 72, 79]);
		  if lower(Z1pt0) == 'default' | Z1pt0<0
		  	delta_ln_z = 0;
		  else
          	delta_ln_z = log(Z1pt0) - calc_z_from_Vs30(Vs30, pars_z_tw);
		  end
          coeffs_z = makeArray(pars_period_zmod, [9, 10]);
         else  % reg=0
          coeffs = updateArray(coeffs, [1, 2, 11], pars_period, [172, 173, 174]);
          coeffs_attn = makeArray(pars_period, [175, 176, 177, 178, 179, 180]);
        end
        
    
        delta_bz = makeArray(pars_period, [80, 81]);
        coeffs_nft = makeArray(pars_period, [82, 83]);
        thisFs = (LeftNumber(EventType, 1));

        mbreak = (1 - thisFs) * (Mb + dmb) + thisFs * Mb;
        zbreak = (1 - thisFs) * (30 + delta_bz(1)) + thisFs * (80 + delta_bz(2));
        
        Med = KBCG20_med(M, Rrup, AlphaBackarc, AlphaNankai, Ztor, EventType, Vs30, delta_ln_z, coeffs, coeffs_attn, coeffs_z, mbreak, zbreak, k1k2(1), k1k2(2), coeffs_nft(1), coeffs_nft(2), pgarock, region);
        med_predictions(k) = Med;
    end
    

    KBCG20_posteriorAtTlist_All(1) = getMeanOfArray(med_predictions);
    KBCG20_posteriorAtTlist_All(2) = getMedianOfArray(med_predictions);
    KBCG20_posteriorAtTlist_All(3) = getStdDev(med_predictions);
    for i = 1: length(med_predictions)
        KBCG20_posteriorAtTlist_All(3 + i  ) = med_predictions(i);
    end
    KBCG20_posteriorAtTlistValue = KBCG20_posteriorAtTlist_All;
end


function getMeanOfArrayValue = getMeanOfArray(inArray)
    % CODE DEVELOPED/IMPLEMENTED BY
    %          Silvia Mazzoni, 2020
    %           smazzoni@ucla.edu

    getMeanOfArrayValue = 0;
    iCount = 0;

    for ii = 1 : length(inArray)
        getMeanOfArrayValue = getMeanOfArrayValue + inArray(ii);
        iCount = iCount + 1;
    end
    getMeanOfArrayValue = getMeanOfArrayValue / iCount;
    
end

function getMedianOfArrayValue = getMedianOfArray(inArray)
    % CODE DEVELOPED/IMPLEMENTED BY
    %          Silvia Mazzoni, 2020
    %           smazzoni@ucla.edu

    inArray = BubbleSrt(inArray, "True");
    num_samples = length(inArray);
    if round(num_samples / 2, 0) == num_samples / 2
        getMedianOfArrayValue = 0.5 * (inArray(num_samples / 2) + inArray(num_samples / 2 + 1));
    else
        getMedianOfArrayValue = inArray((num_samples + 1) / 2);
    end
    
end

%https://www.mrexcel.com/board/threads/standard-deviation-of-an-array.206375/
%************************************************************************
%*               Standard Deviation  of a 1D array                        *
%************************************************************************
function getStdDevValue = getStdDev(Arr)
    % CODE DEVELOPED/IMPLEMENTED BY
    %          Silvia Mazzoni, 2020
    %           smazzoni@ucla.edu
    
     k1 = 1;
     k2 = length(Arr);

     n = 0;
     avg = getMeanOfArray(Arr);
     SumSq = 0;
     for i = k1 : k2
        n = n + 1;
          SumSq = SumSq + (Arr(i) - avg) ^ 2;
     end
 
     getStdDevValue = sqrt(SumSq / (n - 1));

end


%https://stackoverflow.com/questions/11504418/excel-vba-quickest-way-to-sort-an-array-of-numbers-in-descending-order%
% Omit plngLeft & plngRight; they are used internally during recursion

function BubbleSrtValue = BubbleSrt(ArrayIn, Ascending)
    % CODE DEVELOPED/IMPLEMENTED BY
    %          Silvia Mazzoni, 2020
    %           smazzoni@ucla.edu


    
    if Ascending == "True"
        for i = 1 : length(ArrayIn)
             for j = i + 1 : length(ArrayIn)
                 if ArrayIn(i) > ArrayIn(j) 
                     SrtTemp = ArrayIn(j);
                     ArrayIn(j) = ArrayIn(i);
                     ArrayIn(i) = SrtTemp;
                 end
             end
         end
    else
        for i = 1 : length(ArrayIn)
             for j = i + 1 : length(ArrayIn)
                 if ArrayIn(i) < ArrayIn(j) 
                     SrtTemp = ArrayIn(j);
                     ArrayIn(j) = ArrayIn(i);
                     ArrayIn(i) = SrtTemp;
                 end
             end
         end
    end
    
    BubbleSrtValue = ArrayIn;

end

function KBCG20_posteriorValue = KBCG20_posterior(period, M, Rrup, AlphaBackarc, AlphaNankai, Ztor, EventType, Vs30, Z1pt0, Z2pt5, Mb, region, num_samples  , PNWbasinStrux)
    % CODE DEVELOPED/IMPLEMENTED BY
    %          Silvia Mazzoni, 2020
    %           smazzoni@ucla.edu

    if nargin<13
        num_samples = 100;
    end
    if nargin<14
        PNWbasinStrux = 0;
    end
    thisOut = -999;
    XinterpMin = 0;
    XinterpMax = 10;
    XinterpType = "log";
    YinterpType = "linear"; % KBCG20_posteriorAtTlist values are logs already
    extrapolateType = "extrapolate";
    
    Parameters = readtable('NGAsubGMM_KBCG20_coefficients.csv','PreserveVariableNames',true);
    TvalueList = Parameters.T;
    InterpArray = interpolateFunction(period, TvalueList, XinterpType, extrapolateType, XinterpMin, XinterpMax);
    
    period0 = TvalueList(InterpArray(1), 1);
    KBCG20_posteriorAtTlist0 = KBCG20_posteriorAtTlist(period0, M, Rrup, AlphaBackarc, AlphaNankai, Ztor, EventType, Vs30, Z1pt0, Z2pt5, Mb, region, num_samples, PNWbasinStrux);
    y0 = InterpArray(1);
    if InterpArray(2) <= 0 
        KBCG20_posteriorValue = KBCG20_posteriorAtTlist0;
        return
    else
        period1 = TvalueList(InterpArray(2), 1);
        KBCG20_posteriorAtTlist1 = KBCG20_posteriorAtTlist(period1, M, Rrup, AlphaBackarc, AlphaNankai, Ztor, EventType, Vs30, Z1pt0, Z2pt5, Mb, region, num_samples, PNWbasinStrux);
        for iCase = 1: length(KBCG20_posteriorAtTlist0)
            y0 = KBCG20_posteriorAtTlist0(iCase);
            y1 = KBCG20_posteriorAtTlist1(iCase);
        
            if lower(LeftString(YinterpType, strlength("log"))) == lower("log") 
                if y0 <= 0 
                    y0 = 0.000000001;
                end
                if y1 <= 0 
                    y1 = 0.000000001;
                end
                y0 = log(y0);
                y1 = log(y1);
            end
            y0;
            y1;
            InterpArray(3);
            y0 + (y1 - y0) * InterpArray(3);
            med_predictions(iCase) = y0 + (y1 - y0) * InterpArray(3);
            if lower(LeftString(YinterpType, strlength("log"))) == lower("log") 
                med_predictions(iCase) = exp(med_predictions(iCase));
            end
        end

    end

    KBCG20_posteriorValue = med_predictions;

end





% function to calculate aliatory sigma



function KBCG20_sigmaAleatoryValue = KBCG20_sigmaAleatory(period)
    % CODE DEVELOPED/IMPLEMENTED BY
    %          Silvia Mazzoni, 2020
    %           smazzoni@ucla.edu

    thisOut = -999;
    XinterpMin = 0;
    XinterpMax = 10;
    XinterpType = "log";
    YinterpType = "linear";
    extrapolateType = "extrapolate";
    
     Parameters = readtable('NGAsubGMM_KBCG20_coefficients.csv','PreserveVariableNames',true);
    TvalueList = Parameters.T;
    InterpArray = interpolateFunction(period, TvalueList, XinterpType, extrapolateType, XinterpMin, XinterpMax);
    
    period0 = TvalueList(InterpArray(1), 1);
    y0 = KBCG20_sigmaAleatoryAtTlist(period0);
    
    if InterpArray(2) <= 0 
        thisOut = y0;
    else
        period1 = TvalueList(InterpArray(2), 1);
        y1 = KBCG20_sigmaAleatoryAtTlist(period1);
        if lower(LeftString(YinterpType, strlength("log"))) == lower("log") 
            if y0 <= 0 
                y0 = 0.000000001;
            end
            if y1 <= 0 
                y1 = 0.000000001;
            end
            y0 = log(y0);
            y1 = log(y1);
        end
        thisOut = y0 + (y1 - y0) * InterpArray(3);
        if lower(LeftString(YinterpType, strlength("log"))) == lower("log") 
            thisOut = exp(thisOut);
        end

    end

    KBCG20_sigmaAleatoryValue = thisOut;

end


function KBCG20_sigmaAleatoryAtTlistValue = KBCG20_sigmaAleatoryAtTlist(period)
      % CODE DEVELOPED/IMPLEMENTED BY
    %          Silvia Mazzoni, 2020
    %           smazzoni@ucla.edu

  Parameters = readtable('NGAsubGMM_KBCG20_coefficients.csv','PreserveVariableNames',true);
  % calculate PSA
  period_used = period;
  pars_period = getRangeRowT(Parameters, period_used);

  Phi = pars_period(84);
  Tau = pars_period(85);
  KBCG20_sigmaAleatoryAtTlistValue = sqrt(Phi * Phi + Tau * Tau);
  
end

function KBCG20_sigmaPhiValue = KBCG20_sigmaPhi(period)
      % CODE DEVELOPED/IMPLEMENTED BY
    %          Silvia Mazzoni, 2020
    %           smazzoni@ucla.edu

    Parameters = readtable('NGAsubGMM_KBCG20_coefficients.csv','PreserveVariableNames',true);

  % calculate PSA
  period_used = period;
  pars_period = getRangeRowT(Parameters, period_used);

  Phi = pars_period(84);
  KBCG20_sigmaPhiValue = Phi;
  
end

function KBCG20_sigmaTauValue = KBCG20_sigmaTau(period)
      % CODE DEVELOPED/IMPLEMENTED BY
    %          Silvia Mazzoni, 2020
    %           smazzoni@ucla.edu

   Parameters = readtable('NGAsubGMM_KBCG20_coefficients.csv','PreserveVariableNames',true);
 
  % calculate PSA
  period_used = getTFvalue(period);
  pars_period = getRangeRowT(Parameters, period_used);
  Tau = pars_period(85);
  KBCG20_sigmaTauValue = Tau;
  
end



function KBCG20_SigmaEpistemicValue = KBCG20_SigmaEpistemic(period, M, Rrup, AlphaBackarc, AlphaNankai, Ztor, EventType, Vs30, Z1pt0, Z2pt5, Mb, region,  num_samples , PNWbasinStrux )
    % CODE DEVELOPED/IMPLEMENTED BY
    %          Silvia Mazzoni, 2020
    %           smazzoni@ucla.edu

    if nargin<13
        num_samples = 100;
    end
    if nargin<14
        PNWbasinStrux = 0;
    end
    %  % % debug.print "KBCG20_SigmaEpistemic"
    if num_samples == 0 
        KBCG20_SigmaEpistemicValue = 0;
    elseif num_samples < 50 
        KBCG20_SigmaEpistemicValue = "not enough samples, please select a value =0 || between 50 and 800";
    elseif num_samples <= 800 
    
        thisKBCG20_posterior = KBCG20_posterior(period, M, Rrup, AlphaBackarc, AlphaNankai, Ztor, EventType, Vs30, Z1pt0, Z2pt5, Mb, region, num_samples, PNWbasinStrux);
        KBCG20_SigmaEpistemicValue = thisKBCG20_posterior(3);
    else
        KBCG20_SigmaEpistemicValue = "Please enter a value =0 || between 50 and 800";
    end
    
    
end

function KBCG20_SigmaTotalValue = KBCG20_SigmaTotal(period, M, Rrup, AlphaBackarc, AlphaNankai, Ztor, EventType, Vs30, Z1pt0, Z2pt5, Mb, region,  num_samples  ,  PNWbasinStrux )
    % CODE DEVELOPED/IMPLEMENTED BY
    %          Silvia Mazzoni, 2020
    %           smazzoni@ucla.edu
    if nargin<13
        num_samples = 100;
    end
    if nargin<14
        PNWbasinStrux = 0;
    end
    SigmaAleatory = KBCG20_sigmaAleatory(period);
    if num_samples == 0 
        SigmaEpistemic = 0.;
    else
        SigmaEpistemic = KBCG20_SigmaEpistemic(period, M, Rrup, AlphaBackarc, AlphaNankai, Ztor, EventType, Vs30, Z1pt0, Z2pt5, Mb, region, num_samples, PNWbasinStrux);
    end
    KBCG20_SigmaTotalValue = sqrt(SigmaAleatory * SigmaAleatory + SigmaEpistemic * SigmaEpistemic);
    
end
 
function PSHAB20_SigmaTotalValue = PSHAB20_SigmaTotal(period, Rrup,  Vs30, EventType,   SubductionSlab )
    % CODE DEVELOPED/IMPLEMENTED BY
    %          Silvia Mazzoni, 2020
    %           smazzoni@ucla.edu
    SigmaAleatory = PSHAB20_SigmaAleatory(period, Rrup, Vs30);
    SigmaEpistemic = PSHAB20_SigmaEpistemic(period, EventType, SubductionSlab);
    PSHAB20_SigmaTotalValue = sqrt(SigmaAleatory * SigmaAleatory + SigmaEpistemic * SigmaEpistemic);
    
end
    




%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% updated 6/1/2020 by Silvia Mazzoni

% GMM_at_760_slab_v4.R

%#Grace Parker
%#Modified February 26 to expand comments
%#Modified March 25, 2020 to call coefficients from master table

%# Input Parameters --------------------------------------------------------

%#Event type: 0 == interface, 1 == slab

%#region corresponds to options in the DatabaseRegion column of the flatfile, plus global. Must be a string. If no matches, default will be global model:
%# "global", "Alaska", "Cascadia", "CAM", "Japan", "SA" or "Taiwan"

%#Saturation Region corresponds to regions defined by R. Archuleta and C. Ji:
%# "global", "Aleutian","Alaska","Cascadia","Central_America_S", "Central_America_N", "Japan_Pac","Japan_Phi","South_America_N","South_America_S", "Taiwan_W","Taiwan_E"

%# Rrup is number in kilometers

%#Hypocentral depth in km. To use Ztor value to estimate hypocentral depth, see Ch. 4.3.3 of Parker et al. PEER report

%# period can be: (-1,0,0.01,0.02,0.025,0.03,0.04,0.05,0.075,0.1,0.15,0.2,0.25,0.3,0.4,0.5,0.75,1,1.5,2,2.5,3,4,5,7.5,10)
%# where -1 == PGV and 0 == PGA

%# Other pertinent information ---------------------------------------------
%#Coefficient files must be in the active working directory
%# This function has no site term. Can only estimate ground motion at the reference condition VS30 = 760m/s
%# The output is the desired median model prediction in LN units
%# Take the exponential to get PGA, PSA in g or the PGV in cm/s

%#Function to compute GMM predictions at 760m/s for slab and interface


function PSHAB20_GMM_at_760_SlabValue = PSHAB20_GMM_at_760_Slab(EventType, UserRegion, saturation_region_user, Rrup, M, hypocentral_depth, period)
      % CODE DEVELOPED/IMPLEMENTED BY
    %          Silvia Mazzoni, 2020
    %           smazzoni@ucla.edu

%  % % debug.print "PSHAB20_GMM_at_760_Slab"
  PSHAB20_GMM_at_760_SlabValue = -999;
  if (LeftNumber(EventType, 1)) == 0 
    return % ("This function is only for slab")
  end
  region = getPSHABregion(UserRegion);
  saturation_region = getPSHABSubductionRegion(saturation_region_user);
 
  %%import Coefficients
  
%%  Import Master Coefficient Table -----------------------------------------
    CoefficientsTable = readtable('PSHAB20_Table_E2_Slab_Coefficients_OneRowHeader.csv','PreserveVariableNames',true);
  
   %%Define mb based on Archuleta and Ji (2019)
    Mb = getMbDefault("PSHAB20",EventType, UserRegion, saturation_region);
    
%%  Constant ----------------------------------------------------------------
%  %Isolate constant
  if region == "global" 
    c0 = getRangeValueT(CoefficientsTable, period, "Global_c0");
   elseif region == "Alaska" | region == "SA" 
    c0 = getRangeValueT(CoefficientsTable, period, saturation_region + "_c0");
   else
    c0 = getRangeValueT(CoefficientsTable, period, region + "_c0");
  end
    % silviamazzoni, I added this:
    if checkEmptyNA999(c0)
        c0 = getRangeValueT(CoefficientsTable, period, "Global_c0");
    end
%  % Path Term ---------------------------------------------------------------

%  %near-source saturation
  if M <= Mb 
    littleM = (Log10(35) - Log10(3.12)) / (Mb - 4);
    h = 10 ^ (littleM * (M - Mb) + Log10(35));
   else
    h = 35;
  end
  Rref = sqrt(1 + h ^ 2);
  r = sqrt(Rrup ^ 2 + h ^ 2);
  LogR = log(r);
  R_Rref = log(r / Rref);
  
 
%  %Need  to isolate regional anelastic coefficient, a0
  if region == "global" 
    a0 = getRangeValueT(CoefficientsTable, period, "Global_a0");
   else
    a0 = getRangeValueT(CoefficientsTable, period, region + "_a0");
  end
  if checkEmptyNA999(a0)
    a0 = getRangeValueT(CoefficientsTable, period, "Global_a0");
  end
  

  
  c1 = getRangeValueT(CoefficientsTable, period, "c1");
  b4 = getRangeValueT(CoefficientsTable, period, "b4");
  Fp = (c1 * LogR + (b4 * M) * R_Rref + a0 * r);
  
 
%  % Magnitude Scaling -------------------------------------------------------
  c4 = getRangeValueT(CoefficientsTable, period, "c4");
  c5 = getRangeValueT(CoefficientsTable, period, "c5");
  c6 = getRangeValueT(CoefficientsTable, period, "c6");
  Fm = c4 * func1(M, Mb) + c6 * func2(M, Mb) + c5 * func3(M, Mb);
 
  
  
  
%  % Source Depth Scaling ----------------------------------------------------
  Db = getRangeValueT(CoefficientsTable, period, "db_km");
  d = getRangeValueT(CoefficientsTable, period, "d");
  littleM = getRangeValueT(CoefficientsTable, period, 'm');
  if hypocentral_depth >= Db 
    Fd = d;
   elseif hypocentral_depth <= 20 
    Fd = littleM * (20 - Db) + d;
  else
    Fd = littleM * (hypocentral_depth - Db) + d;
  end
  
  
    mu = c0 + Fp + Fm + Fd;
    PSHAB20_GMM_at_760_SlabValue = mu;
    
end

  function func1value = func1(M, Mb)
    % CODE DEVELOPED/IMPLEMENTED BY
    %          Silvia Mazzoni, 2020
    %           smazzoni@ucla.edu
    if M <= Mb 
        func1value = M - Mb;
    else
        func1value = 0;
    end
  end
  function func2value = func2(M, Mb)
    % CODE DEVELOPED/IMPLEMENTED BY
    %          Silvia Mazzoni, 2020
    %           smazzoni@ucla.edu
    if M > Mb 
        func2value = M - Mb;
    else
        func2value = 0;
    end
  end
  function func3value = func3(M, Mb)
    % CODE DEVELOPED/IMPLEMENTED BY
    %          Silvia Mazzoni, 2020
    %           smazzoni@ucla.edu
    if M <= Mb 
        func3value = (M - Mb) ^ 2;
    else
        func3value = 0;
    end
  end


function getPSHABregionValue = getPSHABregion(UserRegion)
    %' CODE DEVELOPED/IMPLEMENTED BY
    %'          Silvia Mazzoni, 2020
    %'           smazzoni@ucla.edu

   PSHAB_RegionIDList = ["global","Alaska","Cascadia","CAM","Japan","global","SA","Taiwan"];
   RegionIDList = ["0_global","1_Alaska","2_Cascadia","3_CentralAmerica&Mexico","4_Japan","5_NewZealand","6_SouthAmerica","7_Taiwan"];
   PSHAB_RegionIDListMap = table(RegionIDList.',PSHAB_RegionIDList.');


    getPSHABregionValue = PSHAB_RegionIDListMap(PSHAB_RegionIDListMap.Var1==UserRegion,:).Var2;

 
    end 


function getPSHABSubductionRegionValue = getPSHABSubductionRegion(UserSubductionRegion)
    %' CODE DEVELOPED/IMPLEMENTED BY
    %'          Silvia Mazzoni, 2020
    %'           smazzoni@ucla.edu
    PSHAB_SubdRegionIDList = ["Alaska","Aleutian","Cascadia","CAM_N","CAM_S","global","Japan_Pac","Japan_Phi","New_Zealand_N","New_Zealand_S","SA_N","SA_S","Taiwan_E","Taiwan_W","Alaska","Aleutian","Cascadia","CAM_N","CAM_S","global","Japan_Pac","Japan_Phi","New_Zealand_N","New_Zealand_S","SA_N","SA_S","Taiwan_E","Taiwan_W"];
    SubdRegionIDList = ["Alaska","Aleutian","Cascadia","CAM_N","CAM_S","global","Japan_Pac","Japan_Phi","NZ_N","NZ_S","SA_N","SA_S","Taiwan_E","Taiwan_W","Alaska","Aleutian","Cascadia","Central_America_N","Central_America_S","global","Japan_Pac","Japan_Phi","New_Zealand_N","New_Zealand_S","South_America_N","South_America_S","Taiwan_E","Taiwan_W"];
    PSHAB_SubductionRegionIDListMap = table(SubdRegionIDList.',PSHAB_SubdRegionIDList.');


    out = PSHAB_SubductionRegionIDListMap(PSHAB_SubductionRegionIDListMap.Var1==UserSubductionRegion,:).Var2;
    getPSHABSubductionRegionValue = out(1);
 
    end 


function getMbDefaultValue = getMbDefault(NGAsubModelLabel,EventType, UserRegion, saturation_region_user)
    % CODE DEVELOPED/IMPLEMENTED BY
    %          Silvia Mazzoni, 2020
    %           smazzoni@ucla.edu
    % Silvia Mazzoni: I inserted the global model and replaced the NA values with those of the global model

     

    if (LeftNumber(EventType, 1)) == 1 | (LeftNumber(EventType, 1)) == 5
        if NGAsubModelLabel == "KBCG20" 
            %MbKBCG20Intraslab
            saturation_region_here = saturation_region_user;
            saturation_regions_SBZ = ["global", "Aleutian", "Alaska", "Cascadia", "Central_America_N", "Central_America_S", "Japan_Pac", "Japan_Phi", "New_Zealand_N", "New_Zealand_S", "South_America_N", "South_America_S", "Taiwan_W", "Taiwan_E"];
            thisMbList = [7.6, 8, 7.2, 7.2, 7.4, 7.6, 7.6, 7.6, 7.6, 7.6, 7.3, 7.2, 7.7, 7.7];
            User_regions_SBZ = ["0_global", "1_Alaska", "1_Alaska", "2_Cascadia", "3_CentralAmerica&Mexico", "3_CentralAmerica&Mexico", "4_Japan", "4_Japan", "5_NewZealand", "5_NewZealand", "6_SouthAmerica", "6_SouthAmerica", "7_Taiwan", "7_Taiwan"];
        else
            %MbPSHAB20Intraslab
            saturation_region_here = getPSHABSubductionRegion(saturation_region_user);
            Mb_global_Slab = 7.6;
            saturation_regions_SBZ = ["global", "Aleutian", "Alaska", "-999", "Cascadia", "CAM_S", "CAM_N", "Japan_Pac", "Japan_Phi", "New_Zealand_N", "New_Zealand_S", "SA_N", "SA_S", "Taiwan_W", "Taiwan_E"];
            thisMbList = [Mb_global_Slab, 7.98, 7.2, Mb_global_Slab, 7.2, 7.6, 7.4, 7.65, 7.55, Mb_global_Slab, Mb_global_Slab, 7.3, 7.25, 7.7, 7.7];
            User_regions_SBZ = ["0_global", "1_Alaska", "1_Alaska", "0_global", "2_Cascadia", "3_CentralAmerica&Mexico", "3_CentralAmerica&Mexico", "4_Japan", "4_Japan", "5_NewZealand", "5_NewZealand", "6_SouthAmerica", "6_SouthAmerica", "7_Taiwan", "7_Taiwan"];
       end
    else

        if NGAsubModelLabel == "KBCG20" 
            %MbKBCG20Interface
            saturation_region_here = saturation_region_user;
            saturation_regions_SBZ = ["global", "Aleutian", "Alaska", "Cascadia", "Central_America_N", "Central_America_S", "Japan_Pac", "Japan_Phi", "New_Zealand_N", "New_Zealand_S", "South_America_N", "South_America_S", "Taiwan_W", "Taiwan_E"];
            thisMbList = [7.9, 8, 8.6, 8, 7.4, 7.5, 8.5, 7.7, 8.3, 8, 8.5, 8.6, 7.1, 7.1];
            User_regions_SBZ = ["0_global", "1_Alaska", "1_Alaska", "2_Cascadia", "3_CentralAmerica&Mexico", "3_CentralAmerica&Mexico", "4_Japan", "4_Japan", "5_NewZealand", "5_NewZealand", "6_SouthAmerica", "6_SouthAmerica", "7_Taiwan", "7_Taiwan"];
        else
            %MbPSHAB20Interface 
            saturation_region_here = getPSHABSubductionRegion(saturation_region_user);
            Mb_global_IF = 7.9;
            saturation_regions_SBZ = ["global", "Aleutian", "Alaska", "-999", "Cascadia", "CAM_S", "CAM_N", "Japan_Pac", "Japan_Phi", "New_Zealand_N", "New_Zealand_S", "SA_N", "SA_S", "Taiwan_W", "Taiwan_E"];
            thisMbList = [Mb_global_IF, 8, 8.6, Mb_global_IF, 7.7, 7.4, 7.4, 8.5, 7.7, Mb_global_IF, Mb_global_IF, 8.5, 8.6, 7.1, 7.1];
            User_regions_SBZ = ["0_global", "1_Alaska", "1_Alaska", "0_global", "2_Cascadia", "3_CentralAmerica&Mexico", "3_CentralAmerica&Mexico", "4_Japan", "4_Japan", "5_NewZealand", "5_NewZealand", "6_SouthAmerica", "6_SouthAmerica", "7_Taiwan", "7_Taiwan"];
        end

    end

    thisSaturationRegionDbRegion = getArrayMap(saturation_region_here, saturation_regions_SBZ, User_regions_SBZ);
    if lower(thisSaturationRegionDbRegion) ~= lower(UserRegion) 
        saturation_region_here = "global";
    end
    
    Mb = getArrayMap(saturation_region_here, saturation_regions_SBZ, thisMbList);
    
    
    if checkEmptyNA999(Mb)
      Mb = getArrayMap("global", saturation_regions_SBZ, thisMbList);
    end

    getMbDefaultValue = Mb;


end




function getArrayMapValue = getArrayMap(Xvalue, Xarray, Yarray)
    % CODE DEVELOPED/IMPLEMENTED BY
    %          Silvia Mazzoni, 2020
    %           smazzoni@ucla.edu
	MapTable = table(Xarray.',Yarray.');
    getArrayMapValue = MapTable(MapTable.Var1==Xvalue,:).Var2;

end



function getRangeValueValue = getRangeValue(thisRange, Xvalue, xHeader, yHeader)
    % CODE DEVELOPED/IMPLEMENTED BY
    %          Silvia Mazzoni, 2020
    %           smazzoni@ucla.edu
    Xvalue = convertStringsToChars(Xvalue)
     getRangeValueValue = table2array(thisRange(thisRange.xHeader==Xvalue,yHeader))
end
function getRangeValueRegionValue = getRangeValueRegion(thisRange, Xvalue,  yHeader)
    % CODE DEVELOPED/IMPLEMENTED BY
    %          Silvia Mazzoni, 2020
    %           smazzoni@ucla.edu
   % Xvalue = convertStringsToChars(Xvalue)
   getRangeValueRegionValue = -999;
    [Nrow,Ncol] = size(thisRange);

    for i=1:Nrow
        thisRegionHere = table2array(thisRange(i,'Region'));
        thisRegionHere = string(thisRegionHere);
        if lower(thisRegionHere) == lower(Xvalue)
            %a = 'found'
            getRangeValueRegionValue = table2array(thisRange(i,yHeader));
        end
    end
end
function getRangeValueTValue = getRangeValueT(thisRange, Xvalue, yHeader)
    % CODE DEVELOPED/IMPLEMENTED BY
    %          Silvia Mazzoni, 2020
    %           smazzoni@ucla.edu
    getRangeValueTValue = table2array(thisRange(thisRange.T==Xvalue,yHeader));
    if iscell(getRangeValueTValue)
        getRangeValueTValue = char(getRangeValueTValue);
    end
end

function checkEmptyNA999value = checkEmptyNA999(thisvalue)
    checkEmptyNA999value = false;
    if ischar(thisvalue) 
        if thisvalue == 'NA'
           checkEmptyNA999value = true;
        end
    elseif isempty(thisvalue)
        checkEmptyNA999value = true;
    elseif thisvalue == -999
        checkEmptyNA999value = true;
    end
    
end
    
 

% GMM_at_VS30_slab_v4.R

%#Grace Parker
%#Modified February 26 to expand comments
%#Modified March 25, 2020 to call consolidated coefficient table

%# Input Parameters --------------------------------------------------------

%#Event type: 0 == interface, 1 == slab

%#region corresponds to options in the DatabaseRegion column of the flatfile, plus global. Must be a string. If no matches, default will be global model:
%# "global", "Alaska", "Cascadia", "CAM", "Japan", "SA" or "Taiwan"

%#Saturation Region corresponds to regions defined by R. Archuleta and C. Ji:
%# "global", "Aleutian","Alaska","Cascadia","Central_America_S", "Central_America_N", "Japan_Pac","Japan_Phi","South_America_N","South_America_S", "Taiwan_W","Taiwan_E"

%# Rrup is number in kilometers

%#Hypocentral depth in km. To use Ztor value to estimate hypocentral depth, see Ch. XXX of Parker et al. PEER report

%# period can be: (-1,0,0.01,0.02,0.025,0.03,0.04,0.05,0.075,0.1,0.15,0.2,0.25,0.3,0.4,0.5,0.75,1,1.5,2,2.5,3,4,5,7.5,10)
%# where -1 == PGV and 0 == PGA

%#VS30 in units m/s

%#Z2.5 in units m. Only used if DatabaseRegion == "Japan" or "Cascadia". Can also specify "default" to get no basin term

%#basin is only used if DatabaseRegion == "Cascadia". Value can be 0, 1, or 2, where 0 == having an estimate of Z2.5 outside mapped basin, 1 == Seattle basin, and 0 == other mapped basin (Tacoma, Everett, Georgia, etc.)

%# Other pertinent information ---------------------------------------------
%#Coefficient files must be in the active working directory
%# "GMM_at_VS30_Slab_v2.R" calls function "GMM_at_760_Slab_v2.R" to compute PGAr in the nonlinear site term. This function must be in the R environment else an error will occur.
%# The output is the desired median model prediction in LN units
%# Take the exponential to get PGA, PSA in g or  PGV in cm/s


%#Function to compute GMM predictions at various VS30s for slab


function PSHAB20_GMM_at_VS30_SlabValue = PSHAB20_GMM_at_VS30_Slab(EventType, UserRegion, saturation_region_user, Rrup, M, hypocentral_depth, period, Vs30, Z2pt5, basin)
    % CODE DEVELOPED/IMPLEMENTED BY
    %          Silvia Mazzoni, 2020
    %           smazzoni@ucla.edu

 %     % % debug.print "PSHAB20_GMM_at_VS30_SlabValue"
 
  PSHAB20_GMM_at_VS30_SlabValue = -999;
  if (LeftNumber(EventType, 1)) == 0 
    return % ("This function is only for slab")
  end
  region = getPSHABregion(UserRegion);
  saturation_region = getPSHABSubductionRegion(saturation_region_user);

  basin = LeftNumber(basin, 1);
  %%import coefficients
     CoefficientsTable = readtable('PSHAB20_Table_E2_Slab_Coefficients_OneRowHeader.csv','PreserveVariableNames',true); 
  
    %Define mb based on Archuleta and Ji (2019)
    Mb = getMbDefault("PSHAB20",EventType, UserRegion, saturation_region);
 
% % Constant ----------------------------------------------------------------
%  %Isolate constant
  if region == "global" 
    c0 = getRangeValueT(CoefficientsTable, period,  "Global_c0");
   elseif region == "Alaska" | region == "SA" 
    c0 = getRangeValueT(CoefficientsTable, period,  saturation_region + "_c0");
   else
    c0 = getRangeValueT(CoefficientsTable, period,  region + "_c0");
  end
  if checkEmptyNA999(c0)
      c0 = getRangeValueT(CoefficientsTable, period,  "Global_c0");
  end
  
%%  Path Term ---------------------------------------------------------------
 
%  %near-source saturation
  if M <= Mb 
    littleM = (Log10(35) - Log10(3.12)) / (Mb - 4);
    h = 10 ^ (littleM * (M - Mb) + Log10(35));
   else
    h = 35;
  end
  

  Rref = sqrt(1 + h ^ 2);
  r = sqrt(Rrup ^ 2 + h ^ 2);
  LogR = log(r);
  R_Rref = log(r / Rref);
  
  
%  %Need  to isolate regional anelastic coefficient, a0
  if region == "global" 
    a0 = getRangeValueT(CoefficientsTable, period,  "Global_a0");
  else
    a0 = getRangeValueT(CoefficientsTable, period,  region + "_a0");
  end
  if checkEmptyNA999(a0)
    a0 = getRangeValueT(CoefficientsTable, period,  "Global_a0");
  end
  
  c1 = getRangeValueT(CoefficientsTable, period,  "c1");
  b4 = getRangeValueT(CoefficientsTable, period,  "b4");
  Fp = (c1 * LogR + (b4 * M) * R_Rref + a0 * r);
  
  
%%  Magnitude Scaling -------------------------------------------------------

    c4 = getRangeValueT(CoefficientsTable, period,  "c4");
    c5 = getRangeValueT(CoefficientsTable, period,  "c5");
    c6 = getRangeValueT(CoefficientsTable, period,  "c6");
  
  Fm = c4 * func1(M, Mb) + c6 * func2(M, Mb) + c5 * func3(M, Mb);
  
%%  Source Depth Scaling ----------------------------------------------------
    Db = getRangeValueT(CoefficientsTable, period,  "db_km");
    d = getRangeValueT(CoefficientsTable, period,  "d");
    littleM = getRangeValueT(CoefficientsTable, period,  "m");
  %%compute depth scaling term
  if hypocentral_depth >= Db 
    Fd = d;
   elseif hypocentral_depth <= 20 
    Fd = littleM * (20 - Db) + d;
   else
    Fd = littleM * (hypocentral_depth - Db) + d;
  end
  
%%  Linear Site Amplification ----------------------------------------------

    %% Site Coefficients
    V1 = getRangeValueT(CoefficientsTable, period,  "V1_m_s");
    V2 = getRangeValueT(CoefficientsTable, period,  "V2_m_s");
    Vref = getRangeValueT(CoefficientsTable, period,  "Vref_m_s");
    
  if region == "global" | region == "CAM" 
    s2 = getRangeValueT(CoefficientsTable, period,  "Global_s2");
    s1 = s2;
   elseif region == "Taiwan" | region == "Japan" 
    s2 = getRangeValueT(CoefficientsTable, period,  region + "_s2");
    s1 = getRangeValueT(CoefficientsTable, period,  region + "_s1");
  else
    s2 = getRangeValueT(CoefficientsTable, period,  region + "_s2");
    s1 = s2;
  end
    
  %%Compute linear site term
    if Vs30 <= V1 
      Flin = s1 * log(Vs30 / V1) + s2 * log(V1 / Vref);
     elseif Vs30 <= V2 
      Flin = s2 * log(Vs30 / Vref);
     else
      Flin = s2 * log(V2 / Vref);
    end
    
% % Nonlinear Site Term -----------------------------------------------------
  PGAr = exp(PSHAB20_GMM_at_760_Slab(EventType, UserRegion, saturation_region, Rrup, M, hypocentral_depth, 0));
    f3 = 0.05;
    Vb = 200;
    Vref_Fnl = 760;
   
  if period >= 3 
    Fnl = 0;
   else
    f4 = getRangeValueT(CoefficientsTable, period,  "f4");
    f5 = getRangeValueT(CoefficientsTable, period,  "f5");
    f2 = f4 * (exp(f5 * (min(Vs30, Vref_Fnl) - Vb)) - exp(f5 * (Vref_Fnl - Vb)));
    Fnl = 0 + f2 * log((PGAr + f3) / f3);
  end
    
    

    
%%  Basin Term --------------------------------------------------------------
    if isstring(Z2pt5)
        if Z2pt5== "default" | Z2pt5== "Default"
            Fb = 0;
        end
    elseif Z2pt5 <= 0 | (region ~= "Japan" && region ~= "Cascadia") 
        Fb = 0;
    else
        if region == "Cascadia" 
          theta0 = 3.94;
          theta1 = -0.42;
          vmu = 200;
          vsig = 0.2;
          e1 = getRangeValueT(CoefficientsTable, period,  "C_e1");
          
    
            C_e3 = getRangeValueT(CoefficientsTable, period,  "C_e3");
            C_e2 = getRangeValueT(CoefficientsTable, period,  "C_e2");
          
         if basin == 0 
            del_None = getRangeValueT(CoefficientsTable, period,  "del_None");
            e3 = C_e3 + del_None;
            e2 = C_e2 + del_None;
           elseif basin == 1 
            del_Seattle = getRangeValueT(CoefficientsTable, period,  "del_Seattle");
            e3 = C_e3 + del_Seattle;
            e2 = C_e2 + del_Seattle;
          else
            e3 = C_e3;
            e2 = C_e2;
          end
          
         elseif region == "Japan" 
            
          theta0 = 3.05;
          theta1 = -0.8;
          vmu = 500;
          vsig = 0.33;
          e3 = getRangeValueT(CoefficientsTable, period,  "J_e3");
          e2 = getRangeValueT(CoefficientsTable, period,  "J_e2");
          e1 = getRangeValueT(CoefficientsTable, period,  "J_e1");

        end
        
        Z2pt5_pred = 10 ^ (theta0 + theta1 * (1 + erf((Log10(Vs30) - Log10(vmu)) / (vsig * sqrt(2)))));
        delZ2pt5 = log(Z2pt5) - log(Z2pt5_pred);
   
        if delZ2pt5 <= (e1 / e3) 
          Fb = e1;
         elseif delZ2pt5 >= (e2 / e3) 
          Fb = e2;
        else
          Fb = e3 * delZ2pt5;
        end
    end

    mu = c0 + Fp + Fm + Fd + Fnl + Flin + Fb;


 
    PSHAB20_GMM_at_VS30_SlabValue = mu;
  
end
   
function Log10Value = Log10(x)
    % CODE DEVELOPED/IMPLEMENTED BY
    %          Silvia Mazzoni, 2020
    %           smazzoni@ucla.edu
    Log10Value = log(x) / log(10.);
end

% updated 6/1/2020 by Silvia Mazzoni
% GMM_at_760_IF_v4.R

%#Grace Parker
%#Modified February 26 to expand comments
%#Modified March 25, 2020 to call consolidated coefficient tables

%# Input Parameters --------------------------------------------------------

%#Event type: 0 == interface, 1 == slab

%#region corresponds to options in the DatabaseRegion column of the flatfile, plus global. Must be a string. If no matches, default will be global model:
%# "global", "Alaska", "Cascadia", "CAM", "Japan", "SA" or "Taiwan"

%#Saturation Region corresponds to regions defined by R. Archuleta and C. Ji:
%# "global", "Aleutian","Alaska","Cascadia","CAM_S", "CAM_N", "Japan_Pac","Japan_Phi","SA_N","SA_S", "Taiwan_W","Taiwan_E"

%# Rrup is number in kilometers

%# period can be: (-1,0,0.01,0.02,0.025,0.03,0.04,0.05,0.075,0.1,0.15,0.2,0.25,0.3,0.4,0.5,0.75,1,1.5,2,2.5,3,4,5,7.5,10)
%# where -1 == PGV and 0 == PGA

%# Other pertinent information ---------------------------------------------
%# Coefficient files must be in the active working directory
%# This function has no site term. Can only estimate ground motion at the reference condition VS30 = 760m/s
%# The output is the desired median model prediction in LN units
%# Take the exponential to get PGA, PSA in g or the PGV in cm/s





function PSHAB20_GMM_at_760_IFValue = PSHAB20_GMM_at_760_IF(EventType, UserRegion, saturation_region_user, Rrup, M, period)
    % CODE DEVELOPED/IMPLEMENTED BY
    %          Silvia Mazzoni, 2020
    %           smazzoni@ucla.edu
 % % % debug.print "PSHAB20_GMM_at_760_IF"
  PSHAB20_GMM_at_760_IFValue = -999;
  if (LeftNumber(EventType, 1)) == 1 | (LeftNumber(EventType, 1)) == 5 
    return; % ("This function is only for IF")
  end
  region = getPSHABregion(UserRegion);
  saturation_region = getPSHABSubductionRegion(saturation_region_user);
 
%%  Import Master Coefficient Table -----------------------------------------
  %%import CoefficientsTable
  CoefficientsTable = readtable('PSHAB20_Table_E1_Interface_Coefficients_OneRowHeader.csv','PreserveVariableNames',true);
  
  %%Define Mb
    Mb = getMbDefault("PSHAB20",EventType, UserRegion, saturation_region);

%%  Constant ----------------------------------------------------------------
  if region == "global"
    c0 = getRangeValueT(CoefficientsTable, period, "Global_c0");
  else
    c0 = getRangeValueT(CoefficientsTable, period, saturation_region + "_c0");
  end
  
%%  Path Term ---------------------------------------------------------------
  h = 10 ^ (-0.82 + 0.252 * M);
  Rref = sqrt(1 + h ^ 2);
  r = sqrt(Rrup ^ 2 + h ^ 2);
  LogR = log(r);
  R_Rref = log(r / Rref);
  
%  %Need  to isolate regional anelastic coefficient, a0
  if region == "global"  
    a0 = getRangeValueT(CoefficientsTable, period, "Global_a0");
   else
    a0 = getRangeValueT(CoefficientsTable, period, region + "_a0");
  end
  
  if checkEmptyNA999(a0)
    a0 = getRangeValueT(CoefficientsTable, period, "Global_a0");
  end

  c1 = getRangeValueT(CoefficientsTable, period, "c1");
  b4 = getRangeValueT(CoefficientsTable, period, "b4");
  Fp = (c1 * LogR + (b4 * M) * R_Rref + a0 * r);
  
  
  
%%  Magnitude Scaling -------------------------------------------------------
  c4 = getRangeValueT(CoefficientsTable, period, "c4");
  c5 = getRangeValueT(CoefficientsTable, period, "c5");
  c6 = getRangeValueT(CoefficientsTable, period, "c6");
  Fm = c4 * func1(M, Mb) + c6 * func2(M, Mb) + c5 * func3(M, Mb);

%%  Add it all up! ----------------------------------------------------------

    
  mu = c0 + Fp + Fm;

  PSHAB20_GMM_at_760_IFValue = mu;
  
  
end


% Updated by Silvia Mazzoni 6/1/2020

% GMM_at_Vs30_IF_v4.R

%#Grace Parker
%#Modified February 26, 2020, to expand comments
%#Modified March 25, 2020, to take coefficients from "Table_E1_Interface_Coefficients.csv"

%# Input Parameters --------------------------------------------------------

%#Event type: 0 == interface, 1 == slab

%#region corresponds to options in the DatabaseRegion column of the flatfile, plus global. Must be a string. If no matches, default will be global model:
  %# "global", "Alaska", "Cascadia", "CAM", "Japan", "SA" or "Taiwan"

%#Saturation Region corresponds to regions defined by R. Archuleta and C. Ji:
  %# "global", "Aleutian","Alaska","Cascadia","CAM_S", "CAM_N", "Japan_Pac","Japan_Phi","SA_N","SA_S", "Taiwan_W","Taiwan_E"

%# Rrup is number in kilometers

%# period can be: (-1,0,0.01,0.02,0.025,0.03,0.04,0.05,0.075,0.1,0.15,0.2,0.25,0.3,0.4,0.5,0.75,1,1.5,2,2.5,3,4,5,7.5,10)
  %# where -1 == PGV and 0 == PGA

%#VS30 in units m/s

%#Z2.5 in units m. Only used if DatabaseRegion == "Japan" or "Cascadia". Can also specify "default" to get no basin term

%#basin is only used if DatabaseRegion == "Cascadia". Value can be 0, 1, or 2, where 0 == having an estimate of Z2.5 outside mapped basin, 1 == Seattle basin, and 0 == other mapped basin (Tacoma, Everett, Georgia, etc.)

%# Other pertinent information ---------------------------------------------
%#Coefficient files must be in the active working directory
%# "GMM_at_VS30_IF_v3.R" calls function "GMM_at_760_IF_v2.R" to compute PGAr in the nonlinear site term. This function must be in the R environment else an error will occur.
%# The output is the desired median model prediction in LN units
%
function PSHAB20_GMM_at_VS30_IFValue = PSHAB20_GMM_at_VS30_IF(EventType, UserRegion, saturation_region_user, Rrup, M, period, Vs30, Z2pt5, basin)
    % CODE DEVELOPED/IMPLEMENTED BY
    %          Silvia Mazzoni, 2020
    %           smazzoni@ucla.edu

%  % % debug.print "PSHAB20_GMM_at_VS30_IF"
  PSHAB20_GMM_at_VS30_IFValue = -999;
  if (LeftNumber(EventType, 1)) == 1 | (LeftNumber(EventType, 1)) == 5 
    return % ("This function is only for IF")
  end
  region = getPSHABregion(UserRegion);
  saturation_region = getPSHABSubductionRegion(saturation_region_user);
  basin = LeftNumber(basin, 1);
  
%%  Import Master Coefficient Table -----------------------------------------
  CoefficientsTable = readtable('PSHAB20_Table_E1_Interface_Coefficients_OneRowHeader.csv','PreserveVariableNames',true);
  
  
  %%Define Mb
        Mb = getMbDefault("PSHAB20",EventType, UserRegion, saturation_region);
  
%%  Constant ----------------------------------------------------------------
    if region == "global"
        c0 = getRangeValueT(CoefficientsTable, period, "Global_c0");
    else
        c0 = getRangeValueT(CoefficientsTable, period, saturation_region + "_c0");
    end
    if checkEmptyNA999(c0)
        c0 = getRangeValueT(CoefficientsTable, period, "Global_c0");
    end
  
%%  Path Term ---------------------------------------------------------------
  h = 10 ^ (-0.82 + 0.252 * M);
  Rref = sqrt(1 + h ^ 2);
  r = sqrt(Rrup ^ 2 + h ^ 2);
  LogR = log(r);
  R_Rref = log(r / Rref);
  
%  %Need  to isolate regional anelastic coefficient, a0
  if region == "global" 
    a0 = getRangeValueT(CoefficientsTable, period, "Global_a0");
   else
    a0 = getRangeValueT(CoefficientsTable, period, region + "_a0");
  end
  
  if checkEmptyNA999(a0)
    a0 = getRangeValueT(CoefficientsTable, period, "Global_a0");
  end
  
  c1 = getRangeValueT(CoefficientsTable, period, "c1");
  b4 = getRangeValueT(CoefficientsTable, period, "b4");
  Fp = (c1 * LogR + (b4 * M) * R_Rref + a0 * r);
  

  
%%  Magnitude Scaling -------------------------------------------------------
  
    c4 = getRangeValueT(CoefficientsTable, period, "c4");
    c5 = getRangeValueT(CoefficientsTable, period, "c5");
    c6 = getRangeValueT(CoefficientsTable, period, "c6");

  Fm = c4 * func1(M, Mb) + c6 * func2(M, Mb) + c5 * func3(M, Mb);


% % Linear Site Amplification ----------------------------------------------
 
  
    %% Site Coefficients
    V1 = getRangeValueT(CoefficientsTable, period, "V1_m_s");
    V2 = getRangeValueT(CoefficientsTable, period, "V2_m_s");
    Vref = getRangeValueT(CoefficientsTable, period, "Vref_m_s");
    
  if region == "global" | region == "CAM" 
    s2 = getRangeValueT(CoefficientsTable, period, "Global_s2");
    s1 = s2;
   elseif region == "Taiwan" | region == "Japan" 
    s2 = getRangeValueT(CoefficientsTable, period, region + "_s2");
    s1 = getRangeValueT(CoefficientsTable, period, region + "_s1");
   else
    s2 = getRangeValueT(CoefficientsTable, period, region + "_s2");
    s1 = s2;
  end
    
  %%Compute linear site term
    if Vs30 <= V1 
      Flin = s1 * log(Vs30 / V1) + s2 * log(V1 / Vref);
     elseif Vs30 <= V2 
      Flin = s2 * log(Vs30 / Vref);
     else
      Flin = s2 * log(V2 / Vref);
    end
  
  
% % Nonlinear Site Term -----------------------------------------------------
  PGAr = exp(PSHAB20_GMM_at_760_IF(EventType, UserRegion, saturation_region, Rrup, M, 0));
  % % debug.print "PGAr: " & PGAr
    f3 = 0.05;
    Vb = 200;
    Vref_Fnl = 760;
  if period >= 3 
    Fnl = 0;
   else
    f4 = getRangeValueT(CoefficientsTable, period, "f4");
    f5 = getRangeValueT(CoefficientsTable, period, "f5");
    f2 = f4 * (exp(f5 * (min(Vs30, Vref_Fnl) - Vb)) - exp(f5 * (Vref_Fnl - Vb)));
    Fnl = 0 + f2 * log((PGAr + f3) / f3);
  end
  
  
%%  Basin Term --------------------------------------------------------------
    if isstring(Z2pt5)
        if Z2pt5== "default" | Z2pt5== "Default"
            Fb = 0;
        end
    elseif Z2pt5 <= 0 | (region ~= "Japan" && region ~= "Cascadia") 
        Fb = 0;
    else
        if region == "Cascadia" 
          theta0 = 3.94;
          theta1 = -0.42;
          vmu = 200;
          vsig = 0.2;
          e1 = getRangeValueT(CoefficientsTable, period, "C_e1");
        
        
          if basin == 0 
            C_e3 = getRangeValueT(CoefficientsTable, period, "C_e3");
            C_e2 = getRangeValueT(CoefficientsTable, period, "C_e2");
            del_None = getRangeValueT(CoefficientsTable, period, "del_None");
            e3 = C_e3 + del_None;
            e2 = C_e2 + del_None;
           elseif basin == 1 
            C_e3 = getRangeValueT(CoefficientsTable, period, "C_e3");
            C_e2 = getRangeValueT(CoefficientsTable, period, "C_e2");
            del_Seattle = getRangeValueT(CoefficientsTable, period, "del_Seattle");
            e3 = C_e3 + del_Seattle;
            e2 = C_e2 + del_Seattle;
           else
            C_e3 = getRangeValueT(CoefficientsTable, period, "C_e3");
            C_e2 = getRangeValueT(CoefficientsTable, period, "C_e2");
            e3 = C_e3;
            e2 = C_e2;
          end
          
         elseif region == "Japan" 
          theta0 = 3.05;
          theta1 = -0.8;
          vmu = 500;
          vsig = 0.33;
          e3 = getRangeValueT(CoefficientsTable, period, "J_e3");
          e2 = getRangeValueT(CoefficientsTable, period, "J_e2");
          e1 = getRangeValueT(CoefficientsTable, period, "J_e1");
        end
        
        Z2pt5_pred = 10 ^ (theta0 + theta1 * (1 + erf((Log10(Vs30) - Log10(vmu)) / (vsig * sqrt(2)))));
        delZ2pt5 = log(Z2pt5) - log(Z2pt5_pred);
   

        if delZ2pt5 <= (e1 / e3) 
          Fb = e1;
         elseif delZ2pt5 >= (e2 / e3) 
          Fb = e2;
         else
          Fb = e3 * delZ2pt5;
        end
    end

  
%  % Add it all up! ----------------------------------------------------------

   mu = c0 + Fp  + Fnl + Fb + Flin + Fm;
  
  PSHAB20_GMM_at_VS30_IFValue = mu;
end










function PSHAB20_MedianValue = PSHAB20_Median(EventType, UserRegion, SubductionSlab, Rrup, Magnitude, Zhypo, period, Vs30, Z2pt5, PNWbasinStrux)
    % CODE DEVELOPED/IMPLEMENTED BY
    %          Silvia Mazzoni, 2020
    %           smazzoni@ucla.edu

%    % % debug.print "PSHAB20_Median"
    thisOut = -999;
    XinterpMin = 0;
    XinterpMax = 10;
    XinterpType = "log";
    YinterpType = "log";
    extrapolateType = "extrapolate";
    
    Parameters = readtable('PSHAB20_Table_E2_Slab_Coefficients_OneRowHeader.csv','PreserveVariableNames',true);
    TvalueList = Parameters.T;
    
    InterpArray = interpolateFunction(period, TvalueList, XinterpType, extrapolateType, XinterpMin, XinterpMax);
    
    period0 = TvalueList(InterpArray(1), 1);
    y0 = PSHAB20_Median_AtTlist(EventType, UserRegion, SubductionSlab, Rrup, Magnitude, Zhypo, period0, Vs30, Z2pt5, PNWbasinStrux);

    if InterpArray(2) <= 0
        thisOut = y0;
    else
        period1 = TvalueList(InterpArray(2), 1);
        y1 = PSHAB20_Median_AtTlist(EventType, UserRegion, SubductionSlab, Rrup, Magnitude, Zhypo, period1, Vs30, Z2pt5, PNWbasinStrux);
        b = y1
        if lower(LeftString(YinterpType, strlength("log"))) == lower("log") 
            if y0 <= 0 
                y0 = 0.000000001;
            end
            if y1 <= 0 
                y1 = 0.000000001;
            end
            y0 = log(y0);
            y1 = log(y1);
        end
        thisOut = y0 + (y1 - y0) * InterpArray(3);
        if lower(LeftString(YinterpType, strlength("log"))) == lower("log") 
            thisOut = exp(thisOut);
        end

    end

    PSHAB20_MedianValue = thisOut;

end

function PSHAB20_Median_AtTlistValue = PSHAB20_Median_AtTlist(EventType, UserRegion, saturation_region, Rrup, M, hypocentral_depth, period, Vs30, Z2pt5, basin)
    % CODE DEVELOPED/IMPLEMENTED BY
    %          Silvia Mazzoni, 2020
    %           smazzoni@ucla.edu
    if LeftNumber(EventType, 1) == 1 | LeftNumber(EventType, 1) == 5 
        PSHAB20_Median_AtTlistValue = exp(PSHAB20_GMM_at_VS30_Slab(EventType, UserRegion, saturation_region, Rrup, M, hypocentral_depth, period, Vs30, Z2pt5, basin));
    else
        PSHAB20_Median_AtTlistValue = exp(PSHAB20_GMM_at_VS30_IF(EventType, UserRegion, saturation_region, Rrup, M, period, Vs30, Z2pt5, basin));
    end

end



function PSHAB20_SigmaEpistemicValue = PSHAB20_SigmaEpistemic(Ts, EventType, saturation_region_user)

    % CODE DEVELOPED/IMPLEMENTED BY
    %          Silvia Mazzoni, 2020
    %           smazzoni@ucla.edu

    PSHAB20_SigmaEpistemicValue = -999;

   if (LeftNumber(EventType, 1)) == 0 
        CoefficientsTable = readtable("PSHAB20_EpistemicModelCoefficients_Interface.csv");
   else
        CoefficientsTable = readtable("PSHAB20_EpistemicModelCoefficients_Slab.csv");
   end
   
    
    saturation_region = getPSHABSubductionRegion(saturation_region_user);
    if saturation_region == "Taiwan_W" || saturation_region == "Taiwan_E"
    	saturation_region = "Taiwan";
    end
    
    if saturation_region == "New_Zealand_N" || saturation_region == "New_Zealand_S"
    	saturation_region = "global";
    end
    
    SigEp1 = getRangeValueRegion(CoefficientsTable, saturation_region,  'SigEp1');
    if SigEp1 == -999
        saturation_region = "global";
        SigEp1 = getRangeValueRegion(CoefficientsTable, saturation_region,  'SigEp1');
    end
    SigEp2 = getRangeValueRegion(CoefficientsTable, saturation_region, 'SigEp2');
    T1 = getRangeValueRegion(CoefficientsTable, saturation_region, 'T1');
    T2 = getRangeValueRegion(CoefficientsTable, saturation_region, 'T2');
    if Ts < T1 || Ts == 0
        sigma_epi = SigEp1;
    elseif Ts > T2
        sigma_epi = SigEp2;
    else
        sigma_epi = SigEp1 - (SigEp1 - SigEp2) * (log(Ts / T1) / log(T2 / T1));
    end     
    PSHAB20_SigmaEpistemicValue = sigma_epi;

end





function PSHAB20_SigmaAleatoryValue = PSHAB20_SigmaAleatory(period, Rrup, Vs30)
    % CODE DEVELOPED/IMPLEMENTED BY
    %          Silvia Mazzoni, 2020
    %           smazzoni@ucla.edu

    thisOut = -999;
    XinterpMin = 0;
    XinterpMax = 10;
    XinterpType = "log";
    YinterpType = "linear";
    extrapolateType = "extrapolate";
    
    Parameters = readtable('PSHAB20_Table_E2_Slab_Coefficients_OneRowHeader.csv','PreserveVariableNames',true);
    TvalueList = Parameters.T;
    InterpArray = interpolateFunction(period, TvalueList, XinterpType, extrapolateType, XinterpMin, XinterpMax);
    
    period0 = TvalueList(InterpArray(1), 1);
    y0 = PSHAB20_SigmaAleatoryAtTlist(period0, Rrup, Vs30);
    
    if InterpArray(2) <= 0 
        thisOut = y0;
    else
        period1 = TvalueList(InterpArray(2), 1);
        y1 = PSHAB20_SigmaAleatoryAtTlist(period1, Rrup, Vs30);
        if lower(LeftString(YinterpType, strlength("log"))) == lower("log") 
            if y0 <= 0 
                y0 = 0.000000001;
            end
            if y1 <= 0 
                y1 = 0.000000001;
            end
            y0 = log(y0);
            y1 = log(y1);
        end
        thisOut = y0 + (y1 - y0) * InterpArray(3);
        if lower(LeftString(YinterpType, strlength("log"))) == lower("log") 
            thisOut = exp(thisOut);
        end

    end

    PSHAB20_SigmaAleatoryValue = thisOut;

end

function PSHAB20_SigmaAleatoryAtTlistValue = PSHAB20_SigmaAleatoryAtTlist(period, Rrup, Vs30)
    % CODE DEVELOPED/IMPLEMENTED BY
    %          Silvia Mazzoni, 2020
    %           smazzoni@ucla.edu

    PSHAB20_SigmaAleatoryAtTlistValue = -999;

    PhiTot = PSHAB20_PhiTot(period, Rrup, Vs30);
    Tau = PSHAB20_Tau(period, Rrup, Vs30);


    PSHAB20_SigmaAleatoryAtTlistValue = sqrt(PhiTot * PhiTot + Tau * Tau);

end



function PSHAB20_TauValue = PSHAB20_Tau(period, Rrup, Vs30)
    % CODE DEVELOPED/IMPLEMENTED BY
    %          Silvia Mazzoni, 2020
    %           smazzoni@ucla.edu

    PSHAB20_TauValue = -999;
    SigmacoefficientsTable = readtable("PSHAB20_Table_E3_AleatoryCoefficients_OneRowHeader.csv",'PreserveVariableNames',true);
    Tau = getRangeValueT(SigmacoefficientsTable, period, "Tau");
    PSHAB20_TauValue = Tau;
end


function PSHAB20_PhiTotValue = PSHAB20_PhiTot(period, Rrup, Vs30)
    % CODE DEVELOPED/IMPLEMENTED BY
    %          Silvia Mazzoni, 2020
    %           smazzoni@ucla.edu

    PSHAB20_PhiTotValue = -999;
    SigmacoefficientsTable = readtable("PSHAB20_Table_E3_AleatoryCoefficients_OneRowHeader.csv",'PreserveVariableNames',true);
    
    PhiTot_Phi1squared = getRangeValueT(SigmacoefficientsTable, period, "PhiTot_Phi1squared");
    PhiTot_Phi2squared = getRangeValueT(SigmacoefficientsTable, period, "PhiTot_Phi2squared");
    PhiTot_PhiVsquared = getRangeValueT(SigmacoefficientsTable, period, "PhiTot_PhiVsquared");
    
    %Corner Distances:
    R1 = 200;    % km
    R2 = 500;    % km
    
    V1 = 200;    % m/s
    V2 = 500;    % m/s
    
    if Vs30 <= V1 
        Rprime = max(R1, min(R2, Rrup));
        deltaVar = PhiTot_PhiVsquared * (log(R2 / Rprime)) / (log(R2 / R1));
    elseif Vs30 < V2 
        Rprime = max(R1, min(R2, Rrup));
        deltaVar = PhiTot_PhiVsquared * (log(R2 / Rprime)) / (log(R2 / R1)) * (log(V2 / Vs30)) / (log(V2 / V1));
    else
        deltaVar = 0;
    end
    
    if Rrup < R1 
        phiSquared = PhiTot_Phi1squared;
    elseif Rrup < R2 
        phiSquared = (PhiTot_Phi2squared - PhiTot_Phi1squared) / (log(R2 / R1)) * (log(Rrup / R1)) + PhiTot_Phi1squared;
    else
        phiSquared = PhiTot_Phi2squared;
        
    end

    PSHAB20_PhiTotValue = sqrt(phiSquared + deltaVar);

end

function PSHAB20_SigmaS2SValue = PSHAB20_SigmaS2S(period, Rrup, Vs30)
    % CODE DEVELOPED/IMPLEMENTED BY
    %          Silvia Mazzoni, 2020
    %           smazzoni@ucla.edu

    PSHAB20_SigmaS2SValue = -999;
    SigmacoefficientsTable = readtable("PSHAB20_Table_E3_AleatoryCoefficients_OneRowHeader.csv",'PreserveVariableNames',true);
    
    PhiS2S_PhiS2S0squared = getRangeValueT(SigmacoefficientsTable, period, "PhiS2S_PhiS2S0squared");
    PhiS2S_a1 = getRangeValueT(SigmacoefficientsTable, period, "PhiS2S_a1");
    VM = getRangeValueT(SigmacoefficientsTable, period, "VM");
    
    %Corner Distances:
    R3 = 200;    % km
    R4 = 500;    % km
   
    V3 = 200;    % m/s
    V4 = 800;    % m/s
    
    if Vs30 <= V3 
        Rprime = max(R3, min(R4, Rrup));
        deltaVarS2S = PhiS2S_a1 * log(V3 / VM) * (log(R4 / Rprime)) / (log(R4 / R3));
    elseif Vs30 < VM 
        Rprime = max(R3, min(R4, Rrup));
        deltaVarS2S = PhiS2S_a1 * log(Vs30 / VM) * (log(R4 / Rprime)) / (log(R4 / R3));
    elseif Vs30 < V4 
        deltaVarS2S = PhiS2S_a1 * log(Vs30 / VM);
    else
        deltaVarS2S = PhiS2S_a1 * log(V4 / VM);
    end
    
    PSHAB20_SigmaS2SValue = sqrt(PhiS2S_PhiS2S0squared + deltaVarS2S);

end


function PSHAB20_SigmaSSValue = PSHAB20_SigmaSS(period, Rrup, Vs30)
    % CODE DEVELOPED/IMPLEMENTED BY
    %          Silvia Mazzoni, 2020
    %           smazzoni@ucla.edu

    PSHAB20_SigmaSSValue = -999;
    SigmacoefficientsTable = readtable("PSHAB20_Table_E3_AleatoryCoefficients_OneRowHeader.csv",'PreserveVariableNames',true);
    
    PhiSS_PhiSS1squared = getRangeValueT(SigmacoefficientsTable, period, "PhiSS_PhiSS1squared");
     PhiSS_PhiSS2squared = getRangeValueT(SigmacoefficientsTable, period, "PhiSS_PhiSS2squared");
    PhiSS_a2 = getRangeValueT(SigmacoefficientsTable, period, "PhiSS_a2");
    VM = getRangeValueT(SigmacoefficientsTable, period, "VM");
    
    %Corner Distances:
    R3 = 200;    % km
    R4 = 500;    % km
    R5 = 500;    % km
    R6 = 800;    % km
    
    V3 = 200;    % m/s
    V4 = 800;    % m/s
    
    if Rrup < R5 
        phiSquaredSS = PhiSS_PhiSS1squared;
    elseif Rrup < R6 
        phiSquaredSS = (PhiSS_PhiSS2squared - PhiSS_PhiSS1squared) / (log(R6 / R5)) * (log(Rrup / R5)) + PhiSS_PhiSS1squared;
    else
        phiSquaredSS = PhiSS_PhiSS2squared;
        
    end

    if Vs30 <= V3 
        Rprime = max(R3, min(R4, Rrup));
        deltaVarSS = PhiSS_a2 * log(V3 / VM) * (log(R4 / Rprime)) / (log(R4 / R3));
    elseif Vs30 < VM 
        Rprime = max(R3, min(R4, Rrup));
        deltaVarSS = PhiSS_a2 * log(Vs30 / VM) * (log(R4 / Rprime)) / (log(R4 / R3));
    elseif Vs30 < V4 
        deltaVarSS = PhiSS_a2 * log(Vs30 / VM);
    else
        deltaVarSS = PhiSS_a2 * log(V4 / VM);
    end


    PSHAB20_SigmaSSValue = sqrt(phiSquaredSS + deltaVarSS);

end







function NGAsubGMM_MedianPlusMinusSigmaValue = NGAsubGMM_MedianPlusMinusSigma(UserPeriod,  UserRegion, Magnitude, Vs30, Rrup, AlphaBackarc, AlphaNankai, Ztor, Zhypo, EventType, Z1pt0, Z2pt5, MbUser, SubductionSlab, PNWbasinStrux, Weight_KBCG20, Weight_PSHAB20,  User_NSigma, User_EpiInSigmaModels, User_NsampleEpi ,User_MeanType)
    % CODE DEVELOPED/IMPLEMENTED BY
    %          Silvia Mazzoni, 2020
    %           smazzoni@ucla.edu
     NGAsubGMM_MedianPlusMinusSigmaValue = 0;
     if nargin<21
         User_MeanType= "geometric";
     end
     
	if MbUser>0
	    Mb = MbUser;
	else
	    Mb =getMbDefault("KBCG20",EventType, UserRegion, SubductionSlab);
	end

    

    
    period = getTFvalue(UserPeriod);
    WeightedSum = 0;
    WeightSum = 0;
    
    if Weight_KBCG20 > 0 
        KBCG20median = KBCG20_medPSA(period, Magnitude, Rrup, AlphaBackarc, AlphaNankai, Ztor, EventType, Vs30, Z1pt0, Z2pt5, Mb, UserRegion, PNWbasinStrux);
        SigmaAleatoryKBCG20 = KBCG20_sigmaAleatory(period);
        if LeftNumber(User_EpiInSigmaModels, 1) == 1  ; % all models
            SigmaEpistemicKBCG20 = KBCG20_SigmaEpistemic(period, Magnitude, Rrup, AlphaBackarc, AlphaNankai, Ztor, EventType, Vs30, Z1pt0, Z2pt5, Mb, UserRegion, User_NsampleEpi, PNWbasinStrux);
        else    % none
            SigmaEpistemicKBCG20 = 0;
        end
       KBCG20SigmaTotal = sqrt(SigmaAleatoryKBCG20 * SigmaAleatoryKBCG20 + SigmaEpistemicKBCG20 * SigmaEpistemicKBCG20);
       KBCG20 = exp(log(KBCG20median)+User_NSigma*KBCG20SigmaTotal);
       
        WeightSum = WeightSum + Weight_KBCG20;
        if lower(User_MeanType) == "arithmetic" 
            WeightedSum = WeightedSum + KBCG20 * Weight_KBCG20;
        else
            WeightedSum = WeightedSum + log(KBCG20) * Weight_KBCG20;
        end
    end 
    if Weight_PSHAB20 > 0 
       PSHAB20median = PSHAB20_Median(EventType, UserRegion, SubductionSlab, Rrup, Magnitude, Zhypo, period, Vs30, Z2pt5, PNWbasinStrux);
        SigmaAleatoryPSHAB20 = PSHAB20_SigmaAleatory(period, Rrup, Vs30);
        if LeftNumber(User_EpiInSigmaModels, 1) == 1  ; % all models
            SigmaEpistemicPSHAB20 = PSHAB20_SigmaEpistemic(period,EventType,SubductionSlab);
        else    % none
            SigmaEpistemicPSHAB20 = 0;
        end
       PSHAB20SigmaTotal = sqrt(SigmaAleatoryPSHAB20 * SigmaAleatoryPSHAB20 + SigmaEpistemicPSHAB20 * SigmaEpistemicPSHAB20);
       PSHAB20 = exp(log(PSHAB20median)+User_NSigma*PSHAB20SigmaTotal);
    
        
        WeightSum = WeightSum + Weight_PSHAB20;
        if lower(User_MeanType) == "arithmetic" 
            WeightedSum = WeightedSum + PSHAB20 * Weight_PSHAB20;
        else
            WeightedSum = WeightedSum + log(PSHAB20) * Weight_PSHAB20;
        end
    end 
    if WeightSum>0
        if lower(User_MeanType) == "arithmetic" 
            NGAsubGMM_MedianPlusMinusSigmaValue = WeightedSum / WeightSum;
        else
            NGAsubGMM_MedianPlusMinusSigmaValue = exp(WeightedSum / WeightSum);
        end
    end
    
end





function getTFvalueValue = getTFvalue(inValue)
    % CODE DEVELOPED/IMPLEMENTED BY
    %          Silvia Mazzoni, 2020
    %           smazzoni@ucla.edu

    % Code Written and developed by Silvia Mazzoni, smazzoni@ucla.edu, April 2020
    if ischar(inValue)
        if lower(inValue) == lower("pga") 
            getTFvalueValue = 0;
        elseif lower(inValue) == lower("pgv") 
            getTFvalueValue = -1;
        end
    else
        getTFvalueValue = inValue;
    end
end



% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function RunSensitivityStudy()
    prompt = 'Are you sure you want to run the Sensitivity Study? I may take a few minutes! y/n [n]:';
    str = input(prompt,'s');
    if isempty(str)
        str = 'N';
    end
    if lower(str) == 'y'
        disp(' %%% Performing Sensitivity Study')
        for iSet = 1:2
            thisCase = iSet;
            if iSet == 1    ; % interface

                  CaseLabel(iSet,:) = ["Mag=8,Vs30_mps=760,Reg=0_global,Rrup_km=200,alpBack=0,alpNank=0,Ztor_km=10,InterIntra=0_Interface,SeatBasn=0_NoBasin,Z1.0_m=550,Z2.5_m=2000,NsplEpi=100,Mbreak=7.9,Zhypo_km=55,SatReg=global,Basin=0_NoBasin,Nsigma=1,T_sec=0.01","Mag=8,Vs30_mps=760,Reg=0_global,Rrup_km=200,alpBack=0,alpNank=0,Ztor_km=10,InterIntra=0_Interface,SeatBasn=0_NoBasin,Z1.0_m=550,Z2.5_m=2000,NsplEpi=100,Mbreak=7.9,Zhypo_km=55,SatReg=global,Basin=0_NoBasin,Nsigma=1,T_sec=0.02","Mag=8,Vs30_mps=760,Reg=0_global,Rrup_km=200,alpBack=0,alpNank=0,Ztor_km=10,InterIntra=0_Interface,SeatBasn=0_NoBasin,Z1.0_m=550,Z2.5_m=2000,NsplEpi=100,Mbreak=7.9,Zhypo_km=55,SatReg=global,Basin=0_NoBasin,Nsigma=1,T_sec=0.03","Mag=8,Vs30_mps=760,Reg=0_global,Rrup_km=200,alpBack=0,alpNank=0,Ztor_km=10,InterIntra=0_Interface,SeatBasn=0_NoBasin,Z1.0_m=550,Z2.5_m=2000,NsplEpi=100,Mbreak=7.9,Zhypo_km=55,SatReg=global,Basin=0_NoBasin,Nsigma=1,T_sec=0.05","Mag=8,Vs30_mps=760,Reg=0_global,Rrup_km=200,alpBack=0,alpNank=0,Ztor_km=10,InterIntra=0_Interface,SeatBasn=0_NoBasin,Z1.0_m=550,Z2.5_m=2000,NsplEpi=100,Mbreak=7.9,Zhypo_km=55,SatReg=global,Basin=0_NoBasin,Nsigma=1,T_sec=0.075","Mag=8,Vs30_mps=760,Reg=0_global,Rrup_km=200,alpBack=0,alpNank=0,Ztor_km=10,InterIntra=0_Interface,SeatBasn=0_NoBasin,Z1.0_m=550,Z2.5_m=2000,NsplEpi=100,Mbreak=7.9,Zhypo_km=55,SatReg=global,Basin=0_NoBasin,Nsigma=1,T_sec=0.1","Mag=8,Vs30_mps=760,Reg=0_global,Rrup_km=200,alpBack=0,alpNank=0,Ztor_km=10,InterIntra=0_Interface,SeatBasn=0_NoBasin,Z1.0_m=550,Z2.5_m=2000,NsplEpi=100,Mbreak=7.9,Zhypo_km=55,SatReg=global,Basin=0_NoBasin,Nsigma=1,T_sec=0.15","Mag=8,Vs30_mps=760,Reg=0_global,Rrup_km=200,alpBack=0,alpNank=0,Ztor_km=10,InterIntra=0_Interface,SeatBasn=0_NoBasin,Z1.0_m=550,Z2.5_m=2000,NsplEpi=100,Mbreak=7.9,Zhypo_km=55,SatReg=global,Basin=0_NoBasin,Nsigma=1,T_sec=0.2","Mag=8,Vs30_mps=760,Reg=0_global,Rrup_km=200,alpBack=0,alpNank=0,Ztor_km=10,InterIntra=0_Interface,SeatBasn=0_NoBasin,Z1.0_m=550,Z2.5_m=2000,NsplEpi=100,Mbreak=7.9,Zhypo_km=55,SatReg=global,Basin=0_NoBasin,Nsigma=1,T_sec=0.25","Mag=8,Vs30_mps=760,Reg=0_global,Rrup_km=200,alpBack=0,alpNank=0,Ztor_km=10,InterIntra=0_Interface,SeatBasn=0_NoBasin,Z1.0_m=550,Z2.5_m=2000,NsplEpi=100,Mbreak=7.9,Zhypo_km=55,SatReg=global,Basin=0_NoBasin,Nsigma=1,T_sec=0.3","Mag=8,Vs30_mps=760,Reg=0_global,Rrup_km=200,alpBack=0,alpNank=0,Ztor_km=10,InterIntra=0_Interface,SeatBasn=0_NoBasin,Z1.0_m=550,Z2.5_m=2000,NsplEpi=100,Mbreak=7.9,Zhypo_km=55,SatReg=global,Basin=0_NoBasin,Nsigma=1,T_sec=0.4","Mag=8,Vs30_mps=760,Reg=0_global,Rrup_km=200,alpBack=0,alpNank=0,Ztor_km=10,InterIntra=0_Interface,SeatBasn=0_NoBasin,Z1.0_m=550,Z2.5_m=2000,NsplEpi=100,Mbreak=7.9,Zhypo_km=55,SatReg=global,Basin=0_NoBasin,Nsigma=1,T_sec=0.5","Mag=8,Vs30_mps=760,Reg=0_global,Rrup_km=200,alpBack=0,alpNank=0,Ztor_km=10,InterIntra=0_Interface,SeatBasn=0_NoBasin,Z1.0_m=550,Z2.5_m=2000,NsplEpi=100,Mbreak=7.9,Zhypo_km=55,SatReg=global,Basin=0_NoBasin,Nsigma=1,T_sec=0.75","Mag=8,Vs30_mps=760,Reg=0_global,Rrup_km=200,alpBack=0,alpNank=0,Ztor_km=10,InterIntra=0_Interface,SeatBasn=0_NoBasin,Z1.0_m=550,Z2.5_m=2000,NsplEpi=100,Mbreak=7.9,Zhypo_km=55,SatReg=global,Basin=0_NoBasin,Nsigma=1,T_sec=1","Mag=8,Vs30_mps=760,Reg=0_global,Rrup_km=200,alpBack=0,alpNank=0,Ztor_km=10,InterIntra=0_Interface,SeatBasn=0_NoBasin,Z1.0_m=550,Z2.5_m=2000,NsplEpi=100,Mbreak=7.9,Zhypo_km=55,SatReg=global,Basin=0_NoBasin,Nsigma=1,T_sec=1.5","Mag=8,Vs30_mps=760,Reg=0_global,Rrup_km=200,alpBack=0,alpNank=0,Ztor_km=10,InterIntra=0_Interface,SeatBasn=0_NoBasin,Z1.0_m=550,Z2.5_m=2000,NsplEpi=100,Mbreak=7.9,Zhypo_km=55,SatReg=global,Basin=0_NoBasin,Nsigma=1,T_sec=2","Mag=8,Vs30_mps=760,Reg=0_global,Rrup_km=200,alpBack=0,alpNank=0,Ztor_km=10,InterIntra=0_Interface,SeatBasn=0_NoBasin,Z1.0_m=550,Z2.5_m=2000,NsplEpi=100,Mbreak=7.9,Zhypo_km=55,SatReg=global,Basin=0_NoBasin,Nsigma=1,T_sec=3","Mag=8,Vs30_mps=760,Reg=0_global,Rrup_km=200,alpBack=0,alpNank=0,Ztor_km=10,InterIntra=0_Interface,SeatBasn=0_NoBasin,Z1.0_m=550,Z2.5_m=2000,NsplEpi=100,Mbreak=7.9,Zhypo_km=55,SatReg=global,Basin=0_NoBasin,Nsigma=1,T_sec=4","Mag=8,Vs30_mps=760,Reg=0_global,Rrup_km=200,alpBack=0,alpNank=0,Ztor_km=10,InterIntra=0_Interface,SeatBasn=0_NoBasin,Z1.0_m=550,Z2.5_m=2000,NsplEpi=100,Mbreak=7.9,Zhypo_km=55,SatReg=global,Basin=0_NoBasin,Nsigma=1,T_sec=5","Mag=8,Vs30_mps=760,Reg=0_global,Rrup_km=200,alpBack=0,alpNank=0,Ztor_km=10,InterIntra=0_Interface,SeatBasn=0_NoBasin,Z1.0_m=550,Z2.5_m=2000,NsplEpi=100,Mbreak=7.9,Zhypo_km=55,SatReg=global,Basin=0_NoBasin,Nsigma=1,T_sec=7.5","Mag=8,Vs30_mps=760,Reg=0_global,Rrup_km=200,alpBack=0,alpNank=0,Ztor_km=10,InterIntra=0_Interface,SeatBasn=0_NoBasin,Z1.0_m=550,Z2.5_m=2000,NsplEpi=100,Mbreak=7.9,Zhypo_km=55,SatReg=global,Basin=0_NoBasin,Nsigma=1,T_sec=10","Mag=4,Vs30_mps=760,Reg=0_global,Rrup_km=200,alpBack=0,alpNank=0,Ztor_km=10,InterIntra=0_Interface,SeatBasn=0_NoBasin,Z1.0_m=550,Z2.5_m=2000,NsplEpi=100,Mbreak=7.9,Zhypo_km=55,SatReg=global,Basin=0_NoBasin,Nsigma=1,T_sec=0.01","Mag=4.25,Vs30_mps=760,Reg=0_global,Rrup_km=200,alpBack=0,alpNank=0,Ztor_km=10,InterIntra=0_Interface,SeatBasn=0_NoBasin,Z1.0_m=550,Z2.5_m=2000,NsplEpi=100,Mbreak=7.9,Zhypo_km=55,SatReg=global,Basin=0_NoBasin,Nsigma=1,T_sec=0.01","Mag=4.5,Vs30_mps=760,Reg=0_global,Rrup_km=200,alpBack=0,alpNank=0,Ztor_km=10,InterIntra=0_Interface,SeatBasn=0_NoBasin,Z1.0_m=550,Z2.5_m=2000,NsplEpi=100,Mbreak=7.9,Zhypo_km=55,SatReg=global,Basin=0_NoBasin,Nsigma=1,T_sec=0.01","Mag=4.75,Vs30_mps=760,Reg=0_global,Rrup_km=200,alpBack=0,alpNank=0,Ztor_km=10,InterIntra=0_Interface,SeatBasn=0_NoBasin,Z1.0_m=550,Z2.5_m=2000,NsplEpi=100,Mbreak=7.9,Zhypo_km=55,SatReg=global,Basin=0_NoBasin,Nsigma=1,T_sec=0.01","Mag=5,Vs30_mps=760,Reg=0_global,Rrup_km=200,alpBack=0,alpNank=0,Ztor_km=10,InterIntra=0_Interface,SeatBasn=0_NoBasin,Z1.0_m=550,Z2.5_m=2000,NsplEpi=100,Mbreak=7.9,Zhypo_km=55,SatReg=global,Basin=0_NoBasin,Nsigma=1,T_sec=0.01","Mag=5.25,Vs30_mps=760,Reg=0_global,Rrup_km=200,alpBack=0,alpNank=0,Ztor_km=10,InterIntra=0_Interface,SeatBasn=0_NoBasin,Z1.0_m=550,Z2.5_m=2000,NsplEpi=100,Mbreak=7.9,Zhypo_km=55,SatReg=global,Basin=0_NoBasin,Nsigma=1,T_sec=0.01","Mag=5.5,Vs30_mps=760,Reg=0_global,Rrup_km=200,alpBack=0,alpNank=0,Ztor_km=10,InterIntra=0_Interface,SeatBasn=0_NoBasin,Z1.0_m=550,Z2.5_m=2000,NsplEpi=100,Mbreak=7.9,Zhypo_km=55,SatReg=global,Basin=0_NoBasin,Nsigma=1,T_sec=0.01","Mag=5.75,Vs30_mps=760,Reg=0_global,Rrup_km=200,alpBack=0,alpNank=0,Ztor_km=10,InterIntra=0_Interface,SeatBasn=0_NoBasin,Z1.0_m=550,Z2.5_m=2000,NsplEpi=100,Mbreak=7.9,Zhypo_km=55,SatReg=global,Basin=0_NoBasin,Nsigma=1,T_sec=0.01","Mag=6,Vs30_mps=760,Reg=0_global,Rrup_km=200,alpBack=0,alpNank=0,Ztor_km=10,InterIntra=0_Interface,SeatBasn=0_NoBasin,Z1.0_m=550,Z2.5_m=2000,NsplEpi=100,Mbreak=7.9,Zhypo_km=55,SatReg=global,Basin=0_NoBasin,Nsigma=1,T_sec=0.01","Mag=6.25,Vs30_mps=760,Reg=0_global,Rrup_km=200,alpBack=0,alpNank=0,Ztor_km=10,InterIntra=0_Interface,SeatBasn=0_NoBasin,Z1.0_m=550,Z2.5_m=2000,NsplEpi=100,Mbreak=7.9,Zhypo_km=55,SatReg=global,Basin=0_NoBasin,Nsigma=1,T_sec=0.01","Mag=6.5,Vs30_mps=760,Reg=0_global,Rrup_km=200,alpBack=0,alpNank=0,Ztor_km=10,InterIntra=0_Interface,SeatBasn=0_NoBasin,Z1.0_m=550,Z2.5_m=2000,NsplEpi=100,Mbreak=7.9,Zhypo_km=55,SatReg=global,Basin=0_NoBasin,Nsigma=1,T_sec=0.01","Mag=6.75,Vs30_mps=760,Reg=0_global,Rrup_km=200,alpBack=0,alpNank=0,Ztor_km=10,InterIntra=0_Interface,SeatBasn=0_NoBasin,Z1.0_m=550,Z2.5_m=2000,NsplEpi=100,Mbreak=7.9,Zhypo_km=55,SatReg=global,Basin=0_NoBasin,Nsigma=1,T_sec=0.01","Mag=7,Vs30_mps=760,Reg=0_global,Rrup_km=200,alpBack=0,alpNank=0,Ztor_km=10,InterIntra=0_Interface,SeatBasn=0_NoBasin,Z1.0_m=550,Z2.5_m=2000,NsplEpi=100,Mbreak=7.9,Zhypo_km=55,SatReg=global,Basin=0_NoBasin,Nsigma=1,T_sec=0.01","Mag=7.25,Vs30_mps=760,Reg=0_global,Rrup_km=200,alpBack=0,alpNank=0,Ztor_km=10,InterIntra=0_Interface,SeatBasn=0_NoBasin,Z1.0_m=550,Z2.5_m=2000,NsplEpi=100,Mbreak=7.9,Zhypo_km=55,SatReg=global,Basin=0_NoBasin,Nsigma=1,T_sec=0.01","Mag=7.5,Vs30_mps=760,Reg=0_global,Rrup_km=200,alpBack=0,alpNank=0,Ztor_km=10,InterIntra=0_Interface,SeatBasn=0_NoBasin,Z1.0_m=550,Z2.5_m=2000,NsplEpi=100,Mbreak=7.9,Zhypo_km=55,SatReg=global,Basin=0_NoBasin,Nsigma=1,T_sec=0.01","Mag=7.75,Vs30_mps=760,Reg=0_global,Rrup_km=200,alpBack=0,alpNank=0,Ztor_km=10,InterIntra=0_Interface,SeatBasn=0_NoBasin,Z1.0_m=550,Z2.5_m=2000,NsplEpi=100,Mbreak=7.9,Zhypo_km=55,SatReg=global,Basin=0_NoBasin,Nsigma=1,T_sec=0.01","Mag=8,Vs30_mps=760,Reg=0_global,Rrup_km=200,alpBack=0,alpNank=0,Ztor_km=10,InterIntra=0_Interface,SeatBasn=0_NoBasin,Z1.0_m=550,Z2.5_m=2000,NsplEpi=100,Mbreak=7.9,Zhypo_km=55,SatReg=global,Basin=0_NoBasin,Nsigma=1,T_sec=0.01","Mag=8.25,Vs30_mps=760,Reg=0_global,Rrup_km=200,alpBack=0,alpNank=0,Ztor_km=10,InterIntra=0_Interface,SeatBasn=0_NoBasin,Z1.0_m=550,Z2.5_m=2000,NsplEpi=100,Mbreak=7.9,Zhypo_km=55,SatReg=global,Basin=0_NoBasin,Nsigma=1,T_sec=0.01","Mag=8.5,Vs30_mps=760,Reg=0_global,Rrup_km=200,alpBack=0,alpNank=0,Ztor_km=10,InterIntra=0_Interface,SeatBasn=0_NoBasin,Z1.0_m=550,Z2.5_m=2000,NsplEpi=100,Mbreak=7.9,Zhypo_km=55,SatReg=global,Basin=0_NoBasin,Nsigma=1,T_sec=0.01","Mag=8.75,Vs30_mps=760,Reg=0_global,Rrup_km=200,alpBack=0,alpNank=0,Ztor_km=10,InterIntra=0_Interface,SeatBasn=0_NoBasin,Z1.0_m=550,Z2.5_m=2000,NsplEpi=100,Mbreak=7.9,Zhypo_km=55,SatReg=global,Basin=0_NoBasin,Nsigma=1,T_sec=0.01","Mag=9,Vs30_mps=760,Reg=0_global,Rrup_km=200,alpBack=0,alpNank=0,Ztor_km=10,InterIntra=0_Interface,SeatBasn=0_NoBasin,Z1.0_m=550,Z2.5_m=2000,NsplEpi=100,Mbreak=7.9,Zhypo_km=55,SatReg=global,Basin=0_NoBasin,Nsigma=1,T_sec=0.01","Mag=9.25,Vs30_mps=760,Reg=0_global,Rrup_km=200,alpBack=0,alpNank=0,Ztor_km=10,InterIntra=0_Interface,SeatBasn=0_NoBasin,Z1.0_m=550,Z2.5_m=2000,NsplEpi=100,Mbreak=7.9,Zhypo_km=55,SatReg=global,Basin=0_NoBasin,Nsigma=1,T_sec=0.01","Mag=8,Vs30_mps=760,Reg=0_global,Rrup_km=10,alpBack=0,alpNank=0,Ztor_km=10,InterIntra=0_Interface,SeatBasn=0_NoBasin,Z1.0_m=550,Z2.5_m=2000,NsplEpi=100,Mbreak=7.9,Zhypo_km=55,SatReg=global,Basin=0_NoBasin,Nsigma=1,T_sec=0.01","Mag=8,Vs30_mps=760,Reg=0_global,Rrup_km=13,alpBack=0,alpNank=0,Ztor_km=10,InterIntra=0_Interface,SeatBasn=0_NoBasin,Z1.0_m=550,Z2.5_m=2000,NsplEpi=100,Mbreak=7.9,Zhypo_km=55,SatReg=global,Basin=0_NoBasin,Nsigma=1,T_sec=0.01","Mag=8,Vs30_mps=760,Reg=0_global,Rrup_km=16.9,alpBack=0,alpNank=0,Ztor_km=10,InterIntra=0_Interface,SeatBasn=0_NoBasin,Z1.0_m=550,Z2.5_m=2000,NsplEpi=100,Mbreak=7.9,Zhypo_km=55,SatReg=global,Basin=0_NoBasin,Nsigma=1,T_sec=0.01","Mag=8,Vs30_mps=760,Reg=0_global,Rrup_km=21.97,alpBack=0,alpNank=0,Ztor_km=10,InterIntra=0_Interface,SeatBasn=0_NoBasin,Z1.0_m=550,Z2.5_m=2000,NsplEpi=100,Mbreak=7.9,Zhypo_km=55,SatReg=global,Basin=0_NoBasin,Nsigma=1,T_sec=0.01","Mag=8,Vs30_mps=760,Reg=0_global,Rrup_km=28.561,alpBack=0,alpNank=0,Ztor_km=10,InterIntra=0_Interface,SeatBasn=0_NoBasin,Z1.0_m=550,Z2.5_m=2000,NsplEpi=100,Mbreak=7.9,Zhypo_km=55,SatReg=global,Basin=0_NoBasin,Nsigma=1,T_sec=0.01","Mag=8,Vs30_mps=760,Reg=0_global,Rrup_km=37.1293,alpBack=0,alpNank=0,Ztor_km=10,InterIntra=0_Interface,SeatBasn=0_NoBasin,Z1.0_m=550,Z2.5_m=2000,NsplEpi=100,Mbreak=7.9,Zhypo_km=55,SatReg=global,Basin=0_NoBasin,Nsigma=1,T_sec=0.01","Mag=8,Vs30_mps=760,Reg=0_global,Rrup_km=48.26809,alpBack=0,alpNank=0,Ztor_km=10,InterIntra=0_Interface,SeatBasn=0_NoBasin,Z1.0_m=550,Z2.5_m=2000,NsplEpi=100,Mbreak=7.9,Zhypo_km=55,SatReg=global,Basin=0_NoBasin,Nsigma=1,T_sec=0.01","Mag=8,Vs30_mps=760,Reg=0_global,Rrup_km=62.7485169999999,alpBack=0,alpNank=0,Ztor_km=10,InterIntra=0_Interface,SeatBasn=0_NoBasin,Z1.0_m=550,Z2.5_m=2000,NsplEpi=100,Mbreak=7.9,Zhypo_km=55,SatReg=global,Basin=0_NoBasin,Nsigma=1,T_sec=0.01","Mag=8,Vs30_mps=760,Reg=0_global,Rrup_km=81.5730720999999,alpBack=0,alpNank=0,Ztor_km=10,InterIntra=0_Interface,SeatBasn=0_NoBasin,Z1.0_m=550,Z2.5_m=2000,NsplEpi=100,Mbreak=7.9,Zhypo_km=55,SatReg=global,Basin=0_NoBasin,Nsigma=1,T_sec=0.01","Mag=8,Vs30_mps=760,Reg=0_global,Rrup_km=106.04499373,alpBack=0,alpNank=0,Ztor_km=10,InterIntra=0_Interface,SeatBasn=0_NoBasin,Z1.0_m=550,Z2.5_m=2000,NsplEpi=100,Mbreak=7.9,Zhypo_km=55,SatReg=global,Basin=0_NoBasin,Nsigma=1,T_sec=0.01","Mag=8,Vs30_mps=760,Reg=0_global,Rrup_km=137.858491849,alpBack=0,alpNank=0,Ztor_km=10,InterIntra=0_Interface,SeatBasn=0_NoBasin,Z1.0_m=550,Z2.5_m=2000,NsplEpi=100,Mbreak=7.9,Zhypo_km=55,SatReg=global,Basin=0_NoBasin,Nsigma=1,T_sec=0.01","Mag=8,Vs30_mps=760,Reg=0_global,Rrup_km=179.2160394037,alpBack=0,alpNank=0,Ztor_km=10,InterIntra=0_Interface,SeatBasn=0_NoBasin,Z1.0_m=550,Z2.5_m=2000,NsplEpi=100,Mbreak=7.9,Zhypo_km=55,SatReg=global,Basin=0_NoBasin,Nsigma=1,T_sec=0.01","Mag=8,Vs30_mps=760,Reg=0_global,Rrup_km=232.980851224809,alpBack=0,alpNank=0,Ztor_km=10,InterIntra=0_Interface,SeatBasn=0_NoBasin,Z1.0_m=550,Z2.5_m=2000,NsplEpi=100,Mbreak=7.9,Zhypo_km=55,SatReg=global,Basin=0_NoBasin,Nsigma=1,T_sec=0.01","Mag=8,Vs30_mps=760,Reg=0_global,Rrup_km=302.875106592252,alpBack=0,alpNank=0,Ztor_km=10,InterIntra=0_Interface,SeatBasn=0_NoBasin,Z1.0_m=550,Z2.5_m=2000,NsplEpi=100,Mbreak=7.9,Zhypo_km=55,SatReg=global,Basin=0_NoBasin,Nsigma=1,T_sec=0.01","Mag=8,Vs30_mps=760,Reg=0_global,Rrup_km=393.737638569928,alpBack=0,alpNank=0,Ztor_km=10,InterIntra=0_Interface,SeatBasn=0_NoBasin,Z1.0_m=550,Z2.5_m=2000,NsplEpi=100,Mbreak=7.9,Zhypo_km=55,SatReg=global,Basin=0_NoBasin,Nsigma=1,T_sec=0.01","Mag=8,Vs30_mps=760,Reg=0_global,Rrup_km=511.858930140906,alpBack=0,alpNank=0,Ztor_km=10,InterIntra=0_Interface,SeatBasn=0_NoBasin,Z1.0_m=550,Z2.5_m=2000,NsplEpi=100,Mbreak=7.9,Zhypo_km=55,SatReg=global,Basin=0_NoBasin,Nsigma=1,T_sec=0.01","Mag=8,Vs30_mps=760,Reg=0_global,Rrup_km=665.416609183177,alpBack=0,alpNank=0,Ztor_km=10,InterIntra=0_Interface,SeatBasn=0_NoBasin,Z1.0_m=550,Z2.5_m=2000,NsplEpi=100,Mbreak=7.9,Zhypo_km=55,SatReg=global,Basin=0_NoBasin,Nsigma=1,T_sec=0.01","Mag=8,Vs30_mps=760,Reg=0_global,Rrup_km=865.04159193813,alpBack=0,alpNank=0,Ztor_km=10,InterIntra=0_Interface,SeatBasn=0_NoBasin,Z1.0_m=550,Z2.5_m=2000,NsplEpi=100,Mbreak=7.9,Zhypo_km=55,SatReg=global,Basin=0_NoBasin,Nsigma=1,T_sec=0.01","Mag=8,Vs30_mps=760,Reg=0_global,Rrup_km=1124.55406951957,alpBack=0,alpNank=0,Ztor_km=10,InterIntra=0_Interface,SeatBasn=0_NoBasin,Z1.0_m=550,Z2.5_m=2000,NsplEpi=100,Mbreak=7.9,Zhypo_km=55,SatReg=global,Basin=0_NoBasin,Nsigma=1,T_sec=0.01","Mag=8,Vs30_mps=760,Reg=0_global,Rrup_km=1461.92029037544,alpBack=0,alpNank=0,Ztor_km=10,InterIntra=0_Interface,SeatBasn=0_NoBasin,Z1.0_m=550,Z2.5_m=2000,NsplEpi=100,Mbreak=7.9,Zhypo_km=55,SatReg=global,Basin=0_NoBasin,Nsigma=1,T_sec=0.01","Mag=8,Vs30_mps=760,Reg=0_global,Rrup_km=1900.49637748807,alpBack=0,alpNank=0,Ztor_km=10,InterIntra=0_Interface,SeatBasn=0_NoBasin,Z1.0_m=550,Z2.5_m=2000,NsplEpi=100,Mbreak=7.9,Zhypo_km=55,SatReg=global,Basin=0_NoBasin,Nsigma=1,T_sec=0.01","Mag=8,Vs30_mps=760,Reg=0_global,Rrup_km=2470.64529073449,alpBack=0,alpNank=0,Ztor_km=10,InterIntra=0_Interface,SeatBasn=0_NoBasin,Z1.0_m=550,Z2.5_m=2000,NsplEpi=100,Mbreak=7.9,Zhypo_km=55,SatReg=global,Basin=0_NoBasin,Nsigma=1,T_sec=0.01","Mag=8,Vs30_mps=150,Reg=0_global,Rrup_km=200,alpBack=0,alpNank=0,Ztor_km=10,InterIntra=0_Interface,SeatBasn=0_NoBasin,Z1.0_m=550,Z2.5_m=2000,NsplEpi=100,Mbreak=7.9,Zhypo_km=55,SatReg=global,Basin=0_NoBasin,Nsigma=1,T_sec=0.01","Mag=8,Vs30_mps=169.5,Reg=0_global,Rrup_km=200,alpBack=0,alpNank=0,Ztor_km=10,InterIntra=0_Interface,SeatBasn=0_NoBasin,Z1.0_m=550,Z2.5_m=2000,NsplEpi=100,Mbreak=7.9,Zhypo_km=55,SatReg=global,Basin=0_NoBasin,Nsigma=1,T_sec=0.01","Mag=8,Vs30_mps=191.535,Reg=0_global,Rrup_km=200,alpBack=0,alpNank=0,Ztor_km=10,InterIntra=0_Interface,SeatBasn=0_NoBasin,Z1.0_m=550,Z2.5_m=2000,NsplEpi=100,Mbreak=7.9,Zhypo_km=55,SatReg=global,Basin=0_NoBasin,Nsigma=1,T_sec=0.01","Mag=8,Vs30_mps=216.43455,Reg=0_global,Rrup_km=200,alpBack=0,alpNank=0,Ztor_km=10,InterIntra=0_Interface,SeatBasn=0_NoBasin,Z1.0_m=550,Z2.5_m=2000,NsplEpi=100,Mbreak=7.9,Zhypo_km=55,SatReg=global,Basin=0_NoBasin,Nsigma=1,T_sec=0.01","Mag=8,Vs30_mps=244.5710415,Reg=0_global,Rrup_km=200,alpBack=0,alpNank=0,Ztor_km=10,InterIntra=0_Interface,SeatBasn=0_NoBasin,Z1.0_m=550,Z2.5_m=2000,NsplEpi=100,Mbreak=7.9,Zhypo_km=55,SatReg=global,Basin=0_NoBasin,Nsigma=1,T_sec=0.01","Mag=8,Vs30_mps=276.365276895,Reg=0_global,Rrup_km=200,alpBack=0,alpNank=0,Ztor_km=10,InterIntra=0_Interface,SeatBasn=0_NoBasin,Z1.0_m=550,Z2.5_m=2000,NsplEpi=100,Mbreak=7.9,Zhypo_km=55,SatReg=global,Basin=0_NoBasin,Nsigma=1,T_sec=0.01","Mag=8,Vs30_mps=312.29276289135,Reg=0_global,Rrup_km=200,alpBack=0,alpNank=0,Ztor_km=10,InterIntra=0_Interface,SeatBasn=0_NoBasin,Z1.0_m=550,Z2.5_m=2000,NsplEpi=100,Mbreak=7.9,Zhypo_km=55,SatReg=global,Basin=0_NoBasin,Nsigma=1,T_sec=0.01","Mag=8,Vs30_mps=352.890822067225,Reg=0_global,Rrup_km=200,alpBack=0,alpNank=0,Ztor_km=10,InterIntra=0_Interface,SeatBasn=0_NoBasin,Z1.0_m=550,Z2.5_m=2000,NsplEpi=100,Mbreak=7.9,Zhypo_km=55,SatReg=global,Basin=0_NoBasin,Nsigma=1,T_sec=0.01","Mag=8,Vs30_mps=398.766628935964,Reg=0_global,Rrup_km=200,alpBack=0,alpNank=0,Ztor_km=10,InterIntra=0_Interface,SeatBasn=0_NoBasin,Z1.0_m=550,Z2.5_m=2000,NsplEpi=100,Mbreak=7.9,Zhypo_km=55,SatReg=global,Basin=0_NoBasin,Nsigma=1,T_sec=0.01","Mag=8,Vs30_mps=450.60629069764,Reg=0_global,Rrup_km=200,alpBack=0,alpNank=0,Ztor_km=10,InterIntra=0_Interface,SeatBasn=0_NoBasin,Z1.0_m=550,Z2.5_m=2000,NsplEpi=100,Mbreak=7.9,Zhypo_km=55,SatReg=global,Basin=0_NoBasin,Nsigma=1,T_sec=0.01","Mag=8,Vs30_mps=509.185108488333,Reg=0_global,Rrup_km=200,alpBack=0,alpNank=0,Ztor_km=10,InterIntra=0_Interface,SeatBasn=0_NoBasin,Z1.0_m=550,Z2.5_m=2000,NsplEpi=100,Mbreak=7.9,Zhypo_km=55,SatReg=global,Basin=0_NoBasin,Nsigma=1,T_sec=0.01","Mag=8,Vs30_mps=575.379172591816,Reg=0_global,Rrup_km=200,alpBack=0,alpNank=0,Ztor_km=10,InterIntra=0_Interface,SeatBasn=0_NoBasin,Z1.0_m=550,Z2.5_m=2000,NsplEpi=100,Mbreak=7.9,Zhypo_km=55,SatReg=global,Basin=0_NoBasin,Nsigma=1,T_sec=0.01","Mag=8,Vs30_mps=650.178465028752,Reg=0_global,Rrup_km=200,alpBack=0,alpNank=0,Ztor_km=10,InterIntra=0_Interface,SeatBasn=0_NoBasin,Z1.0_m=550,Z2.5_m=2000,NsplEpi=100,Mbreak=7.9,Zhypo_km=55,SatReg=global,Basin=0_NoBasin,Nsigma=1,T_sec=0.01","Mag=8,Vs30_mps=734.701665482489,Reg=0_global,Rrup_km=200,alpBack=0,alpNank=0,Ztor_km=10,InterIntra=0_Interface,SeatBasn=0_NoBasin,Z1.0_m=550,Z2.5_m=2000,NsplEpi=100,Mbreak=7.9,Zhypo_km=55,SatReg=global,Basin=0_NoBasin,Nsigma=1,T_sec=0.01","Mag=8,Vs30_mps=830.212881995213,Reg=0_global,Rrup_km=200,alpBack=0,alpNank=0,Ztor_km=10,InterIntra=0_Interface,SeatBasn=0_NoBasin,Z1.0_m=550,Z2.5_m=2000,NsplEpi=100,Mbreak=7.9,Zhypo_km=55,SatReg=global,Basin=0_NoBasin,Nsigma=1,T_sec=0.01","Mag=8,Vs30_mps=938.140556654591,Reg=0_global,Rrup_km=200,alpBack=0,alpNank=0,Ztor_km=10,InterIntra=0_Interface,SeatBasn=0_NoBasin,Z1.0_m=550,Z2.5_m=2000,NsplEpi=100,Mbreak=7.9,Zhypo_km=55,SatReg=global,Basin=0_NoBasin,Nsigma=1,T_sec=0.01","Mag=8,Vs30_mps=1060.09882901969,Reg=0_global,Rrup_km=200,alpBack=0,alpNank=0,Ztor_km=10,InterIntra=0_Interface,SeatBasn=0_NoBasin,Z1.0_m=550,Z2.5_m=2000,NsplEpi=100,Mbreak=7.9,Zhypo_km=55,SatReg=global,Basin=0_NoBasin,Nsigma=1,T_sec=0.01","Mag=8,Vs30_mps=1197.91167679225,Reg=0_global,Rrup_km=200,alpBack=0,alpNank=0,Ztor_km=10,InterIntra=0_Interface,SeatBasn=0_NoBasin,Z1.0_m=550,Z2.5_m=2000,NsplEpi=100,Mbreak=7.9,Zhypo_km=55,SatReg=global,Basin=0_NoBasin,Nsigma=1,T_sec=0.01","Mag=8,Vs30_mps=1353.64019477524,Reg=0_global,Rrup_km=200,alpBack=0,alpNank=0,Ztor_km=10,InterIntra=0_Interface,SeatBasn=0_NoBasin,Z1.0_m=550,Z2.5_m=2000,NsplEpi=100,Mbreak=7.9,Zhypo_km=55,SatReg=global,Basin=0_NoBasin,Nsigma=1,T_sec=0.01","Mag=8,Vs30_mps=1529.61342009602,Reg=0_global,Rrup_km=200,alpBack=0,alpNank=0,Ztor_km=10,InterIntra=0_Interface,SeatBasn=0_NoBasin,Z1.0_m=550,Z2.5_m=2000,NsplEpi=100,Mbreak=7.9,Zhypo_km=55,SatReg=global,Basin=0_NoBasin,Nsigma=1,T_sec=0.01","Mag=8,Vs30_mps=1728.4631647085,Reg=0_global,Rrup_km=200,alpBack=0,alpNank=0,Ztor_km=10,InterIntra=0_Interface,SeatBasn=0_NoBasin,Z1.0_m=550,Z2.5_m=2000,NsplEpi=100,Mbreak=7.9,Zhypo_km=55,SatReg=global,Basin=0_NoBasin,Nsigma=1,T_sec=0.01","Mag=8,Vs30_mps=1953.16337612061,Reg=0_global,Rrup_km=200,alpBack=0,alpNank=0,Ztor_km=10,InterIntra=0_Interface,SeatBasn=0_NoBasin,Z1.0_m=550,Z2.5_m=2000,NsplEpi=100,Mbreak=7.9,Zhypo_km=55,SatReg=global,Basin=0_NoBasin,Nsigma=1,T_sec=0.01","Mag=8,Vs30_mps=760,Reg=0_global,Rrup_km=200,alpBack=0,alpNank=0,Ztor_km=10,InterIntra=0_Interface,SeatBasn=0_NoBasin,Z1.0_m=550,Z2.5_m=2000,NsplEpi=100,Mbreak=7.9,Zhypo_km=55,SatReg=global,Basin=0_NoBasin,Nsigma=1,T_sec=0.01","Mag=8,Vs30_mps=760,Reg=1_Alaska,Rrup_km=200,alpBack=0,alpNank=0,Ztor_km=10,InterIntra=0_Interface,SeatBasn=0_NoBasin,Z1.0_m=550,Z2.5_m=2000,NsplEpi=100,Mbreak=8.6,Zhypo_km=55,SatReg=Alaska,Basin=0_NoBasin,Nsigma=1,T_sec=0.01","Mag=8,Vs30_mps=760,Reg=1_Alaska,Rrup_km=200,alpBack=0,alpNank=0,Ztor_km=10,InterIntra=0_Interface,SeatBasn=0_NoBasin,Z1.0_m=550,Z2.5_m=2000,NsplEpi=100,Mbreak=8,Zhypo_km=55,SatReg=Aleutian,Basin=0_NoBasin,Nsigma=1,T_sec=0.01","Mag=8,Vs30_mps=760,Reg=2_Cascadia,Rrup_km=200,alpBack=0,alpNank=0,Ztor_km=10,InterIntra=0_Interface,SeatBasn=0_NoBasin,Z1.0_m=550,Z2.5_m=2000,NsplEpi=100,Mbreak=7.7,Zhypo_km=55,SatReg=Cascadia,Basin=0_NoBasin,Nsigma=1,T_sec=0.01","Mag=8,Vs30_mps=760,Reg=2_Cascadia,Rrup_km=200,alpBack=0,alpNank=0,Ztor_km=10,InterIntra=0_Interface,SeatBasn=1_InSeattleBasin,Z1.0_m=550,Z2.5_m=2000,NsplEpi=100,Mbreak=7.7,Zhypo_km=55,SatReg=Cascadia,Basin=1_InSeattleBasin,Nsigma=1,T_sec=0.01","Mag=8,Vs30_mps=760,Reg=2_Cascadia,Rrup_km=200,alpBack=0,alpNank=0,Ztor_km=10,InterIntra=0_Interface,SeatBasn=2_InOtherPNWbasin,Z1.0_m=550,Z2.5_m=2000,NsplEpi=100,Mbreak=7.7,Zhypo_km=55,SatReg=Cascadia,Basin=2_InOtherPNWbasin,Nsigma=1,T_sec=0.01","Mag=8,Vs30_mps=760,Reg=3_CentralAmerica&Mexico,Rrup_km=200,alpBack=0,alpNank=0,Ztor_km=10,InterIntra=0_Interface,SeatBasn=2_InOtherPNWbasin,Z1.0_m=550,Z2.5_m=2000,NsplEpi=100,Mbreak=7.4,Zhypo_km=55,SatReg=Central_America_N,Basin=0_NoBasin,Nsigma=1,T_sec=0.01","Mag=8,Vs30_mps=760,Reg=3_CentralAmerica&Mexico,Rrup_km=200,alpBack=0,alpNank=0,Ztor_km=10,InterIntra=0_Interface,SeatBasn=2_InOtherPNWbasin,Z1.0_m=550,Z2.5_m=2000,NsplEpi=100,Mbreak=7.4,Zhypo_km=55,SatReg=Central_America_S,Basin=0_NoBasin,Nsigma=1,T_sec=0.01","Mag=8,Vs30_mps=760,Reg=4_Japan,Rrup_km=200,alpBack=0,alpNank=0,Ztor_km=10,InterIntra=0_Interface,SeatBasn=2_InOtherPNWbasin,Z1.0_m=550,Z2.5_m=2000,NsplEpi=100,Mbreak=8.5,Zhypo_km=55,SatReg=Japan_Pac,Basin=0_NoBasin,Nsigma=1,T_sec=0.01","Mag=8,Vs30_mps=760,Reg=4_Japan,Rrup_km=200,alpBack=0,alpNank=0,Ztor_km=10,InterIntra=0_Interface,SeatBasn=2_InOtherPNWbasin,Z1.0_m=550,Z2.5_m=2000,NsplEpi=100,Mbreak=7.7,Zhypo_km=55,SatReg=Japan_Phi,Basin=0_NoBasin,Nsigma=1,T_sec=0.01","Mag=8,Vs30_mps=760,Reg=5_NewZealand,Rrup_km=200,alpBack=0,alpNank=0,Ztor_km=10,InterIntra=0_Interface,SeatBasn=2_InOtherPNWbasin,Z1.0_m=550,Z2.5_m=2000,NsplEpi=100,Mbreak=7.9,Zhypo_km=55,SatReg=New_Zealand_N,Basin=0_NoBasin,Nsigma=1,T_sec=0.01","Mag=8,Vs30_mps=760,Reg=5_NewZealand,Rrup_km=200,alpBack=0,alpNank=0,Ztor_km=10,InterIntra=0_Interface,SeatBasn=2_InOtherPNWbasin,Z1.0_m=550,Z2.5_m=2000,NsplEpi=100,Mbreak=7.9,Zhypo_km=55,SatReg=New_Zealand_S,Basin=0_NoBasin,Nsigma=1,T_sec=0.01","Mag=8,Vs30_mps=760,Reg=6_SouthAmerica,Rrup_km=200,alpBack=0,alpNank=0,Ztor_km=10,InterIntra=0_Interface,SeatBasn=2_InOtherPNWbasin,Z1.0_m=550,Z2.5_m=2000,NsplEpi=100,Mbreak=8.5,Zhypo_km=55,SatReg=South_America_N,Basin=0_NoBasin,Nsigma=1,T_sec=0.01","Mag=8,Vs30_mps=760,Reg=6_SouthAmerica,Rrup_km=200,alpBack=0,alpNank=0,Ztor_km=10,InterIntra=0_Interface,SeatBasn=2_InOtherPNWbasin,Z1.0_m=550,Z2.5_m=2000,NsplEpi=100,Mbreak=8.6,Zhypo_km=55,SatReg=South_America_S,Basin=0_NoBasin,Nsigma=1,T_sec=0.01","Mag=8,Vs30_mps=760,Reg=7_Taiwan,Rrup_km=200,alpBack=0,alpNank=0,Ztor_km=10,InterIntra=0_Interface,SeatBasn=2_InOtherPNWbasin,Z1.0_m=550,Z2.5_m=2000,NsplEpi=100,Mbreak=7.1,Zhypo_km=55,SatReg=Taiwan_E,Basin=0_NoBasin,Nsigma=1,T_sec=0.01","Mag=8,Vs30_mps=760,Reg=7_Taiwan,Rrup_km=200,alpBack=0,alpNank=0,Ztor_km=10,InterIntra=0_Interface,SeatBasn=2_InOtherPNWbasin,Z1.0_m=550,Z2.5_m=2000,NsplEpi=100,Mbreak=7.1,Zhypo_km=55,SatReg=Taiwan_W,Basin=0_NoBasin,Nsigma=1,T_sec=0.01"];
                  CaseLabelRegion(iSet,:) = ["0_GLB_GLB_Mb7.9","0_GLB_GLB_Mb7.9","0_GLB_GLB_Mb7.9","0_GLB_GLB_Mb7.9","0_GLB_GLB_Mb7.9","0_GLB_GLB_Mb7.9","0_GLB_GLB_Mb7.9","0_GLB_GLB_Mb7.9","0_GLB_GLB_Mb7.9","0_GLB_GLB_Mb7.9","0_GLB_GLB_Mb7.9","0_GLB_GLB_Mb7.9","0_GLB_GLB_Mb7.9","0_GLB_GLB_Mb7.9","0_GLB_GLB_Mb7.9","0_GLB_GLB_Mb7.9","0_GLB_GLB_Mb7.9","0_GLB_GLB_Mb7.9","0_GLB_GLB_Mb7.9","0_GLB_GLB_Mb7.9","0_GLB_GLB_Mb7.9","0_GLB_GLB_Mb7.9","0_GLB_GLB_Mb7.9","0_GLB_GLB_Mb7.9","0_GLB_GLB_Mb7.9","0_GLB_GLB_Mb7.9","0_GLB_GLB_Mb7.9","0_GLB_GLB_Mb7.9","0_GLB_GLB_Mb7.9","0_GLB_GLB_Mb7.9","0_GLB_GLB_Mb7.9","0_GLB_GLB_Mb7.9","0_GLB_GLB_Mb7.9","0_GLB_GLB_Mb7.9","0_GLB_GLB_Mb7.9","0_GLB_GLB_Mb7.9","0_GLB_GLB_Mb7.9","0_GLB_GLB_Mb7.9","0_GLB_GLB_Mb7.9","0_GLB_GLB_Mb7.9","0_GLB_GLB_Mb7.9","0_GLB_GLB_Mb7.9","0_GLB_GLB_Mb7.9","0_GLB_GLB_Mb7.9","0_GLB_GLB_Mb7.9","0_GLB_GLB_Mb7.9","0_GLB_GLB_Mb7.9","0_GLB_GLB_Mb7.9","0_GLB_GLB_Mb7.9","0_GLB_GLB_Mb7.9","0_GLB_GLB_Mb7.9","0_GLB_GLB_Mb7.9","0_GLB_GLB_Mb7.9","0_GLB_GLB_Mb7.9","0_GLB_GLB_Mb7.9","0_GLB_GLB_Mb7.9","0_GLB_GLB_Mb7.9","0_GLB_GLB_Mb7.9","0_GLB_GLB_Mb7.9","0_GLB_GLB_Mb7.9","0_GLB_GLB_Mb7.9","0_GLB_GLB_Mb7.9","0_GLB_GLB_Mb7.9","0_GLB_GLB_Mb7.9","0_GLB_GLB_Mb7.9","0_GLB_GLB_Mb7.9","0_GLB_GLB_Mb7.9","0_GLB_GLB_Mb7.9","0_GLB_GLB_Mb7.9","0_GLB_GLB_Mb7.9","0_GLB_GLB_Mb7.9","0_GLB_GLB_Mb7.9","0_GLB_GLB_Mb7.9","0_GLB_GLB_Mb7.9","0_GLB_GLB_Mb7.9","0_GLB_GLB_Mb7.9","0_GLB_GLB_Mb7.9","0_GLB_GLB_Mb7.9","0_GLB_GLB_Mb7.9","0_GLB_GLB_Mb7.9","0_GLB_GLB_Mb7.9","0_GLB_GLB_Mb7.9","0_GLB_GLB_Mb7.9","0_GLB_GLB_Mb7.9","0_GLB_GLB_Mb7.9","0_GLB_GLB_Mb7.9","0_GLB_GLB_Mb7.9","0_GLB_GLB_Mb7.9","1_AK_AK_Mb8.6","1_AK_Aleu_Mb8","2_CSC_CSC_Mb7.7","2_CSC_CSC_Mb7.7_1_InSeattleBasin","2_CSC_CSC_Mb7.7_2_InOtherPNWbasin","3_CAM_CAM_N_Mb7.4","3_CAM_CAM_S_Mb7.4","4_JP_JP_Pac_Mb8.5","4_JP_JP_Phi_Mb7.7","5_NZ_NZ_N_Mb7.9","5_NZ_NZ_S_Mb7.9","6_SAM_SAM_N_Mb8.5","6_SAM_SAM_S_Mb8.6","7_TW_TW_E_Mb7.1","7_TW_TW_W_Mb7.1"];

                  Mag(iSet,:) = [8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,4,4.25,4.5,4.75,5,5.25,5.5,5.75,6,6.25,6.5,6.75,7,7.25,7.5,7.75,8,8.25,8.5,8.75,9,9.25,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8];
                  Vs30mps(iSet,:) = [760,760,760,760,760,760,760,760,760,760,760,760,760,760,760,760,760,760,760,760,760,760,760,760,760,760,760,760,760,760,760,760,760,760,760,760,760,760,760,760,760,760,760,760,760,760,760,760,760,760,760,760,760,760,760,760,760,760,760,760,760,760,760,760,760,150,169.5,191.535,216.43455,244.5710415,276.365276895,312.29276289135,352.890822067225,398.766628935964,450.60629069764,509.185108488333,575.379172591816,650.178465028752,734.701665482489,830.212881995213,938.140556654591,1060.09882901969,1197.91167679225,1353.64019477524,1529.61342009602,1728.4631647085,1953.16337612061,760,760,760,760,760,760,760,760,760,760,760,760,760,760,760,760];
                  Reg(iSet,:) = ["0_global","0_global","0_global","0_global","0_global","0_global","0_global","0_global","0_global","0_global","0_global","0_global","0_global","0_global","0_global","0_global","0_global","0_global","0_global","0_global","0_global","0_global","0_global","0_global","0_global","0_global","0_global","0_global","0_global","0_global","0_global","0_global","0_global","0_global","0_global","0_global","0_global","0_global","0_global","0_global","0_global","0_global","0_global","0_global","0_global","0_global","0_global","0_global","0_global","0_global","0_global","0_global","0_global","0_global","0_global","0_global","0_global","0_global","0_global","0_global","0_global","0_global","0_global","0_global","0_global","0_global","0_global","0_global","0_global","0_global","0_global","0_global","0_global","0_global","0_global","0_global","0_global","0_global","0_global","0_global","0_global","0_global","0_global","0_global","0_global","0_global","0_global","0_global","1_Alaska","1_Alaska","2_Cascadia","2_Cascadia","2_Cascadia","3_CentralAmerica&Mexico","3_CentralAmerica&Mexico","4_Japan","4_Japan","5_NewZealand","5_NewZealand","6_SouthAmerica","6_SouthAmerica","7_Taiwan","7_Taiwan"];
                  Rrup_km(iSet,:) = [200,200,200,200,200,200,200,200,200,200,200,200,200,200,200,200,200,200,200,200,200,200,200,200,200,200,200,200,200,200,200,200,200,200,200,200,200,200,200,200,200,200,200,10,13,16.9,21.97,28.561,37.1293,48.26809,62.7485169999999,81.5730720999999,106.04499373,137.858491849,179.2160394037,232.980851224809,302.875106592252,393.737638569928,511.858930140906,665.416609183177,865.04159193813,1124.55406951957,1461.92029037544,1900.49637748807,2470.64529073449,200,200,200,200,200,200,200,200,200,200,200,200,200,200,200,200,200,200,200,200,200,200,200,200,200,200,200,200,200,200,200,200,200,200,200,200,200,200];
                  alpBack(iSet,:) = [0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0];
                  alpNank(iSet,:) = [0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0];
                  Ztor_km(iSet,:) = [10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10];
                  SeatBasn(iSet,:) = ["0_NoBasin","0_NoBasin","0_NoBasin","0_NoBasin","0_NoBasin","0_NoBasin","0_NoBasin","0_NoBasin","0_NoBasin","0_NoBasin","0_NoBasin","0_NoBasin","0_NoBasin","0_NoBasin","0_NoBasin","0_NoBasin","0_NoBasin","0_NoBasin","0_NoBasin","0_NoBasin","0_NoBasin","0_NoBasin","0_NoBasin","0_NoBasin","0_NoBasin","0_NoBasin","0_NoBasin","0_NoBasin","0_NoBasin","0_NoBasin","0_NoBasin","0_NoBasin","0_NoBasin","0_NoBasin","0_NoBasin","0_NoBasin","0_NoBasin","0_NoBasin","0_NoBasin","0_NoBasin","0_NoBasin","0_NoBasin","0_NoBasin","0_NoBasin","0_NoBasin","0_NoBasin","0_NoBasin","0_NoBasin","0_NoBasin","0_NoBasin","0_NoBasin","0_NoBasin","0_NoBasin","0_NoBasin","0_NoBasin","0_NoBasin","0_NoBasin","0_NoBasin","0_NoBasin","0_NoBasin","0_NoBasin","0_NoBasin","0_NoBasin","0_NoBasin","0_NoBasin","0_NoBasin","0_NoBasin","0_NoBasin","0_NoBasin","0_NoBasin","0_NoBasin","0_NoBasin","0_NoBasin","0_NoBasin","0_NoBasin","0_NoBasin","0_NoBasin","0_NoBasin","0_NoBasin","0_NoBasin","0_NoBasin","0_NoBasin","0_NoBasin","0_NoBasin","0_NoBasin","0_NoBasin","0_NoBasin","0_NoBasin","0_NoBasin","0_NoBasin","0_NoBasin","1_InSeattleBasin","2_InOtherPNWbasin","2_InOtherPNWbasin","2_InOtherPNWbasin","2_InOtherPNWbasin","2_InOtherPNWbasin","2_InOtherPNWbasin","2_InOtherPNWbasin","2_InOtherPNWbasin","2_InOtherPNWbasin","2_InOtherPNWbasin","2_InOtherPNWbasin"];
                  Z1pt0m(iSet,:) = [550,550,550,550,550,550,550,550,550,550,550,550,550,550,550,550,550,550,550,550,550,550,550,550,550,550,550,550,550,550,550,550,550,550,550,550,550,550,550,550,550,550,550,550,550,550,550,550,550,550,550,550,550,550,550,550,550,550,550,550,550,550,550,550,550,550,550,550,550,550,550,550,550,550,550,550,550,550,550,550,550,550,550,550,550,550,550,550,550,550,550,550,550,550,550,550,550,550,550,550,550,550,550];
                  Z2pt5m(iSet,:) = [2000,2000,2000,2000,2000,2000,2000,2000,2000,2000,2000,2000,2000,2000,2000,2000,2000,2000,2000,2000,2000,2000,2000,2000,2000,2000,2000,2000,2000,2000,2000,2000,2000,2000,2000,2000,2000,2000,2000,2000,2000,2000,2000,2000,2000,2000,2000,2000,2000,2000,2000,2000,2000,2000,2000,2000,2000,2000,2000,2000,2000,2000,2000,2000,2000,2000,2000,2000,2000,2000,2000,2000,2000,2000,2000,2000,2000,2000,2000,2000,2000,2000,2000,2000,2000,2000,2000,2000,2000,2000,2000,2000,2000,2000,2000,2000,2000,2000,2000,2000,2000,2000,2000];
                  NsplEpi(iSet,:) = [100,100,100,100,100,100,100,100,100,100,100,100,100,100,100,100,100,100,100,100,100,100,100,100,100,100,100,100,100,100,100,100,100,100,100,100,100,100,100,100,100,100,100,100,100,100,100,100,100,100,100,100,100,100,100,100,100,100,100,100,100,100,100,100,100,100,100,100,100,100,100,100,100,100,100,100,100,100,100,100,100,100,100,100,100,100,100,100,100,100,100,100,100,100,100,100,100,100,100,100,100,100,100];
                  Mbreak(iSet,:) = [7.9,7.9,7.9,7.9,7.9,7.9,7.9,7.9,7.9,7.9,7.9,7.9,7.9,7.9,7.9,7.9,7.9,7.9,7.9,7.9,7.9,7.9,7.9,7.9,7.9,7.9,7.9,7.9,7.9,7.9,7.9,7.9,7.9,7.9,7.9,7.9,7.9,7.9,7.9,7.9,7.9,7.9,7.9,7.9,7.9,7.9,7.9,7.9,7.9,7.9,7.9,7.9,7.9,7.9,7.9,7.9,7.9,7.9,7.9,7.9,7.9,7.9,7.9,7.9,7.9,7.9,7.9,7.9,7.9,7.9,7.9,7.9,7.9,7.9,7.9,7.9,7.9,7.9,7.9,7.9,7.9,7.9,7.9,7.9,7.9,7.9,7.9,7.9,8.6,8,7.7,7.7,7.7,7.4,7.4,8.5,7.7,7.9,7.9,8.5,8.6,7.1,7.1];
                  Zhypo_km(iSet,:) = [55,55,55,55,55,55,55,55,55,55,55,55,55,55,55,55,55,55,55,55,55,55,55,55,55,55,55,55,55,55,55,55,55,55,55,55,55,55,55,55,55,55,55,55,55,55,55,55,55,55,55,55,55,55,55,55,55,55,55,55,55,55,55,55,55,55,55,55,55,55,55,55,55,55,55,55,55,55,55,55,55,55,55,55,55,55,55,55,55,55,55,55,55,55,55,55,55,55,55,55,55,55,55];
                  SatReg(iSet,:) = ["global","global","global","global","global","global","global","global","global","global","global","global","global","global","global","global","global","global","global","global","global","global","global","global","global","global","global","global","global","global","global","global","global","global","global","global","global","global","global","global","global","global","global","global","global","global","global","global","global","global","global","global","global","global","global","global","global","global","global","global","global","global","global","global","global","global","global","global","global","global","global","global","global","global","global","global","global","global","global","global","global","global","global","global","global","global","global","global","Alaska","Aleutian","Cascadia","Cascadia","Cascadia","Central_America_N","Central_America_S","Japan_Pac","Japan_Phi","New_Zealand_N","New_Zealand_S","South_America_N","South_America_S","Taiwan_E","Taiwan_W"];
                  Basin(iSet,:) = ["0_NoBasin","0_NoBasin","0_NoBasin","0_NoBasin","0_NoBasin","0_NoBasin","0_NoBasin","0_NoBasin","0_NoBasin","0_NoBasin","0_NoBasin","0_NoBasin","0_NoBasin","0_NoBasin","0_NoBasin","0_NoBasin","0_NoBasin","0_NoBasin","0_NoBasin","0_NoBasin","0_NoBasin","0_NoBasin","0_NoBasin","0_NoBasin","0_NoBasin","0_NoBasin","0_NoBasin","0_NoBasin","0_NoBasin","0_NoBasin","0_NoBasin","0_NoBasin","0_NoBasin","0_NoBasin","0_NoBasin","0_NoBasin","0_NoBasin","0_NoBasin","0_NoBasin","0_NoBasin","0_NoBasin","0_NoBasin","0_NoBasin","0_NoBasin","0_NoBasin","0_NoBasin","0_NoBasin","0_NoBasin","0_NoBasin","0_NoBasin","0_NoBasin","0_NoBasin","0_NoBasin","0_NoBasin","0_NoBasin","0_NoBasin","0_NoBasin","0_NoBasin","0_NoBasin","0_NoBasin","0_NoBasin","0_NoBasin","0_NoBasin","0_NoBasin","0_NoBasin","0_NoBasin","0_NoBasin","0_NoBasin","0_NoBasin","0_NoBasin","0_NoBasin","0_NoBasin","0_NoBasin","0_NoBasin","0_NoBasin","0_NoBasin","0_NoBasin","0_NoBasin","0_NoBasin","0_NoBasin","0_NoBasin","0_NoBasin","0_NoBasin","0_NoBasin","0_NoBasin","0_NoBasin","0_NoBasin","0_NoBasin","0_NoBasin","0_NoBasin","0_NoBasin","1_InSeattleBasin","2_InOtherPNWbasin","0_NoBasin","0_NoBasin","0_NoBasin","0_NoBasin","0_NoBasin","0_NoBasin","0_NoBasin","0_NoBasin","0_NoBasin","0_NoBasin"];
                  Nsigma(iSet,:) = [1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1];
                  InterIntra(iSet,:) = ["0_Interface","0_Interface","0_Interface","0_Interface","0_Interface","0_Interface","0_Interface","0_Interface","0_Interface","0_Interface","0_Interface","0_Interface","0_Interface","0_Interface","0_Interface","0_Interface","0_Interface","0_Interface","0_Interface","0_Interface","0_Interface","0_Interface","0_Interface","0_Interface","0_Interface","0_Interface","0_Interface","0_Interface","0_Interface","0_Interface","0_Interface","0_Interface","0_Interface","0_Interface","0_Interface","0_Interface","0_Interface","0_Interface","0_Interface","0_Interface","0_Interface","0_Interface","0_Interface","0_Interface","0_Interface","0_Interface","0_Interface","0_Interface","0_Interface","0_Interface","0_Interface","0_Interface","0_Interface","0_Interface","0_Interface","0_Interface","0_Interface","0_Interface","0_Interface","0_Interface","0_Interface","0_Interface","0_Interface","0_Interface","0_Interface","0_Interface","0_Interface","0_Interface","0_Interface","0_Interface","0_Interface","0_Interface","0_Interface","0_Interface","0_Interface","0_Interface","0_Interface","0_Interface","0_Interface","0_Interface","0_Interface","0_Interface","0_Interface","0_Interface","0_Interface","0_Interface","0_Interface","0_Interface","0_Interface","0_Interface","0_Interface","0_Interface","0_Interface","0_Interface","0_Interface","0_Interface","0_Interface","0_Interface","0_Interface","0_Interface","0_Interface","0_Interface","0_Interface"];
                  T_sec(iSet,:) = [0.01,0.02,0.03,0.05,0.075,0.1,0.15,0.2,0.25,0.3,0.4,0.5,0.75,1,1.5,2,3,4,5,7.5,10,0.01,0.01,0.01,0.01,0.01,0.01,0.01,0.01,0.01,0.01,0.01,0.01,0.01,0.01,0.01,0.01,0.01,0.01,0.01,0.01,0.01,0.01,0.01,0.01,0.01,0.01,0.01,0.01,0.01,0.01,0.01,0.01,0.01,0.01,0.01,0.01,0.01,0.01,0.01,0.01,0.01,0.01,0.01,0.01,0.01,0.01,0.01,0.01,0.01,0.01,0.01,0.01,0.01,0.01,0.01,0.01,0.01,0.01,0.01,0.01,0.01,0.01,0.01,0.01,0.01,0.01,0.01,0.01,0.01,0.01,0.01,0.01,0.01,0.01,0.01,0.01,0.01,0.01,0.01,0.01,0.01,0.01];

            else; % intraslab

                  CaseLabel(iSet,:) = ["Mag=8,Vs30_mps=760,Reg=0_global,Rrup_km=200,alpBack=0,alpNank=0,Ztor_km=40,InterIntra=1_Intraslab,SeatBasn=0_NoBasin,Z1.0_m=550,Z2.5_m=2000,NsplEpi=100,Mbreak=7.6,Zhypo_km=55,SatReg=global,Basin=0_NoBasin,Nsigma=1,T_sec=0.01","Mag=8,Vs30_mps=760,Reg=0_global,Rrup_km=200,alpBack=0,alpNank=0,Ztor_km=40,InterIntra=1_Intraslab,SeatBasn=0_NoBasin,Z1.0_m=550,Z2.5_m=2000,NsplEpi=100,Mbreak=7.6,Zhypo_km=55,SatReg=global,Basin=0_NoBasin,Nsigma=1,T_sec=0.02","Mag=8,Vs30_mps=760,Reg=0_global,Rrup_km=200,alpBack=0,alpNank=0,Ztor_km=40,InterIntra=1_Intraslab,SeatBasn=0_NoBasin,Z1.0_m=550,Z2.5_m=2000,NsplEpi=100,Mbreak=7.6,Zhypo_km=55,SatReg=global,Basin=0_NoBasin,Nsigma=1,T_sec=0.03","Mag=8,Vs30_mps=760,Reg=0_global,Rrup_km=200,alpBack=0,alpNank=0,Ztor_km=40,InterIntra=1_Intraslab,SeatBasn=0_NoBasin,Z1.0_m=550,Z2.5_m=2000,NsplEpi=100,Mbreak=7.6,Zhypo_km=55,SatReg=global,Basin=0_NoBasin,Nsigma=1,T_sec=0.05","Mag=8,Vs30_mps=760,Reg=0_global,Rrup_km=200,alpBack=0,alpNank=0,Ztor_km=40,InterIntra=1_Intraslab,SeatBasn=0_NoBasin,Z1.0_m=550,Z2.5_m=2000,NsplEpi=100,Mbreak=7.6,Zhypo_km=55,SatReg=global,Basin=0_NoBasin,Nsigma=1,T_sec=0.075","Mag=8,Vs30_mps=760,Reg=0_global,Rrup_km=200,alpBack=0,alpNank=0,Ztor_km=40,InterIntra=1_Intraslab,SeatBasn=0_NoBasin,Z1.0_m=550,Z2.5_m=2000,NsplEpi=100,Mbreak=7.6,Zhypo_km=55,SatReg=global,Basin=0_NoBasin,Nsigma=1,T_sec=0.1","Mag=8,Vs30_mps=760,Reg=0_global,Rrup_km=200,alpBack=0,alpNank=0,Ztor_km=40,InterIntra=1_Intraslab,SeatBasn=0_NoBasin,Z1.0_m=550,Z2.5_m=2000,NsplEpi=100,Mbreak=7.6,Zhypo_km=55,SatReg=global,Basin=0_NoBasin,Nsigma=1,T_sec=0.15","Mag=8,Vs30_mps=760,Reg=0_global,Rrup_km=200,alpBack=0,alpNank=0,Ztor_km=40,InterIntra=1_Intraslab,SeatBasn=0_NoBasin,Z1.0_m=550,Z2.5_m=2000,NsplEpi=100,Mbreak=7.6,Zhypo_km=55,SatReg=global,Basin=0_NoBasin,Nsigma=1,T_sec=0.2","Mag=8,Vs30_mps=760,Reg=0_global,Rrup_km=200,alpBack=0,alpNank=0,Ztor_km=40,InterIntra=1_Intraslab,SeatBasn=0_NoBasin,Z1.0_m=550,Z2.5_m=2000,NsplEpi=100,Mbreak=7.6,Zhypo_km=55,SatReg=global,Basin=0_NoBasin,Nsigma=1,T_sec=0.25","Mag=8,Vs30_mps=760,Reg=0_global,Rrup_km=200,alpBack=0,alpNank=0,Ztor_km=40,InterIntra=1_Intraslab,SeatBasn=0_NoBasin,Z1.0_m=550,Z2.5_m=2000,NsplEpi=100,Mbreak=7.6,Zhypo_km=55,SatReg=global,Basin=0_NoBasin,Nsigma=1,T_sec=0.3","Mag=8,Vs30_mps=760,Reg=0_global,Rrup_km=200,alpBack=0,alpNank=0,Ztor_km=40,InterIntra=1_Intraslab,SeatBasn=0_NoBasin,Z1.0_m=550,Z2.5_m=2000,NsplEpi=100,Mbreak=7.6,Zhypo_km=55,SatReg=global,Basin=0_NoBasin,Nsigma=1,T_sec=0.4","Mag=8,Vs30_mps=760,Reg=0_global,Rrup_km=200,alpBack=0,alpNank=0,Ztor_km=40,InterIntra=1_Intraslab,SeatBasn=0_NoBasin,Z1.0_m=550,Z2.5_m=2000,NsplEpi=100,Mbreak=7.6,Zhypo_km=55,SatReg=global,Basin=0_NoBasin,Nsigma=1,T_sec=0.5","Mag=8,Vs30_mps=760,Reg=0_global,Rrup_km=200,alpBack=0,alpNank=0,Ztor_km=40,InterIntra=1_Intraslab,SeatBasn=0_NoBasin,Z1.0_m=550,Z2.5_m=2000,NsplEpi=100,Mbreak=7.6,Zhypo_km=55,SatReg=global,Basin=0_NoBasin,Nsigma=1,T_sec=0.75","Mag=8,Vs30_mps=760,Reg=0_global,Rrup_km=200,alpBack=0,alpNank=0,Ztor_km=40,InterIntra=1_Intraslab,SeatBasn=0_NoBasin,Z1.0_m=550,Z2.5_m=2000,NsplEpi=100,Mbreak=7.6,Zhypo_km=55,SatReg=global,Basin=0_NoBasin,Nsigma=1,T_sec=1","Mag=8,Vs30_mps=760,Reg=0_global,Rrup_km=200,alpBack=0,alpNank=0,Ztor_km=40,InterIntra=1_Intraslab,SeatBasn=0_NoBasin,Z1.0_m=550,Z2.5_m=2000,NsplEpi=100,Mbreak=7.6,Zhypo_km=55,SatReg=global,Basin=0_NoBasin,Nsigma=1,T_sec=1.5","Mag=8,Vs30_mps=760,Reg=0_global,Rrup_km=200,alpBack=0,alpNank=0,Ztor_km=40,InterIntra=1_Intraslab,SeatBasn=0_NoBasin,Z1.0_m=550,Z2.5_m=2000,NsplEpi=100,Mbreak=7.6,Zhypo_km=55,SatReg=global,Basin=0_NoBasin,Nsigma=1,T_sec=2","Mag=8,Vs30_mps=760,Reg=0_global,Rrup_km=200,alpBack=0,alpNank=0,Ztor_km=40,InterIntra=1_Intraslab,SeatBasn=0_NoBasin,Z1.0_m=550,Z2.5_m=2000,NsplEpi=100,Mbreak=7.6,Zhypo_km=55,SatReg=global,Basin=0_NoBasin,Nsigma=1,T_sec=3","Mag=8,Vs30_mps=760,Reg=0_global,Rrup_km=200,alpBack=0,alpNank=0,Ztor_km=40,InterIntra=1_Intraslab,SeatBasn=0_NoBasin,Z1.0_m=550,Z2.5_m=2000,NsplEpi=100,Mbreak=7.6,Zhypo_km=55,SatReg=global,Basin=0_NoBasin,Nsigma=1,T_sec=4","Mag=8,Vs30_mps=760,Reg=0_global,Rrup_km=200,alpBack=0,alpNank=0,Ztor_km=40,InterIntra=1_Intraslab,SeatBasn=0_NoBasin,Z1.0_m=550,Z2.5_m=2000,NsplEpi=100,Mbreak=7.6,Zhypo_km=55,SatReg=global,Basin=0_NoBasin,Nsigma=1,T_sec=5","Mag=8,Vs30_mps=760,Reg=0_global,Rrup_km=200,alpBack=0,alpNank=0,Ztor_km=40,InterIntra=1_Intraslab,SeatBasn=0_NoBasin,Z1.0_m=550,Z2.5_m=2000,NsplEpi=100,Mbreak=7.6,Zhypo_km=55,SatReg=global,Basin=0_NoBasin,Nsigma=1,T_sec=7.5","Mag=8,Vs30_mps=760,Reg=0_global,Rrup_km=200,alpBack=0,alpNank=0,Ztor_km=40,InterIntra=1_Intraslab,SeatBasn=0_NoBasin,Z1.0_m=550,Z2.5_m=2000,NsplEpi=100,Mbreak=7.6,Zhypo_km=55,SatReg=global,Basin=0_NoBasin,Nsigma=1,T_sec=10","Mag=4,Vs30_mps=760,Reg=0_global,Rrup_km=200,alpBack=0,alpNank=0,Ztor_km=10,InterIntra=1_Intraslab,SeatBasn=0_NoBasin,Z1.0_m=550,Z2.5_m=2000,NsplEpi=100,Mbreak=7.6,Zhypo_km=55,SatReg=global,Basin=0_NoBasin,Nsigma=1,T_sec=0.01","Mag=4.25,Vs30_mps=760,Reg=0_global,Rrup_km=200,alpBack=0,alpNank=0,Ztor_km=10,InterIntra=1_Intraslab,SeatBasn=0_NoBasin,Z1.0_m=550,Z2.5_m=2000,NsplEpi=100,Mbreak=7.6,Zhypo_km=55,SatReg=global,Basin=0_NoBasin,Nsigma=1,T_sec=0.01","Mag=4.5,Vs30_mps=760,Reg=0_global,Rrup_km=200,alpBack=0,alpNank=0,Ztor_km=10,InterIntra=1_Intraslab,SeatBasn=0_NoBasin,Z1.0_m=550,Z2.5_m=2000,NsplEpi=100,Mbreak=7.6,Zhypo_km=55,SatReg=global,Basin=0_NoBasin,Nsigma=1,T_sec=0.01","Mag=4.75,Vs30_mps=760,Reg=0_global,Rrup_km=200,alpBack=0,alpNank=0,Ztor_km=10,InterIntra=1_Intraslab,SeatBasn=0_NoBasin,Z1.0_m=550,Z2.5_m=2000,NsplEpi=100,Mbreak=7.6,Zhypo_km=55,SatReg=global,Basin=0_NoBasin,Nsigma=1,T_sec=0.01","Mag=5,Vs30_mps=760,Reg=0_global,Rrup_km=200,alpBack=0,alpNank=0,Ztor_km=10,InterIntra=1_Intraslab,SeatBasn=0_NoBasin,Z1.0_m=550,Z2.5_m=2000,NsplEpi=100,Mbreak=7.6,Zhypo_km=55,SatReg=global,Basin=0_NoBasin,Nsigma=1,T_sec=0.01","Mag=5.25,Vs30_mps=760,Reg=0_global,Rrup_km=200,alpBack=0,alpNank=0,Ztor_km=10,InterIntra=1_Intraslab,SeatBasn=0_NoBasin,Z1.0_m=550,Z2.5_m=2000,NsplEpi=100,Mbreak=7.6,Zhypo_km=55,SatReg=global,Basin=0_NoBasin,Nsigma=1,T_sec=0.01","Mag=5.5,Vs30_mps=760,Reg=0_global,Rrup_km=200,alpBack=0,alpNank=0,Ztor_km=10,InterIntra=1_Intraslab,SeatBasn=0_NoBasin,Z1.0_m=550,Z2.5_m=2000,NsplEpi=100,Mbreak=7.6,Zhypo_km=55,SatReg=global,Basin=0_NoBasin,Nsigma=1,T_sec=0.01","Mag=5.75,Vs30_mps=760,Reg=0_global,Rrup_km=200,alpBack=0,alpNank=0,Ztor_km=10,InterIntra=1_Intraslab,SeatBasn=0_NoBasin,Z1.0_m=550,Z2.5_m=2000,NsplEpi=100,Mbreak=7.6,Zhypo_km=55,SatReg=global,Basin=0_NoBasin,Nsigma=1,T_sec=0.01","Mag=6,Vs30_mps=760,Reg=0_global,Rrup_km=200,alpBack=0,alpNank=0,Ztor_km=10,InterIntra=1_Intraslab,SeatBasn=0_NoBasin,Z1.0_m=550,Z2.5_m=2000,NsplEpi=100,Mbreak=7.6,Zhypo_km=55,SatReg=global,Basin=0_NoBasin,Nsigma=1,T_sec=0.01","Mag=6.25,Vs30_mps=760,Reg=0_global,Rrup_km=200,alpBack=0,alpNank=0,Ztor_km=10,InterIntra=1_Intraslab,SeatBasn=0_NoBasin,Z1.0_m=550,Z2.5_m=2000,NsplEpi=100,Mbreak=7.6,Zhypo_km=55,SatReg=global,Basin=0_NoBasin,Nsigma=1,T_sec=0.01","Mag=6.5,Vs30_mps=760,Reg=0_global,Rrup_km=200,alpBack=0,alpNank=0,Ztor_km=10,InterIntra=1_Intraslab,SeatBasn=0_NoBasin,Z1.0_m=550,Z2.5_m=2000,NsplEpi=100,Mbreak=7.6,Zhypo_km=55,SatReg=global,Basin=0_NoBasin,Nsigma=1,T_sec=0.01","Mag=6.75,Vs30_mps=760,Reg=0_global,Rrup_km=200,alpBack=0,alpNank=0,Ztor_km=10,InterIntra=1_Intraslab,SeatBasn=0_NoBasin,Z1.0_m=550,Z2.5_m=2000,NsplEpi=100,Mbreak=7.6,Zhypo_km=55,SatReg=global,Basin=0_NoBasin,Nsigma=1,T_sec=0.01","Mag=7,Vs30_mps=760,Reg=0_global,Rrup_km=200,alpBack=0,alpNank=0,Ztor_km=10,InterIntra=1_Intraslab,SeatBasn=0_NoBasin,Z1.0_m=550,Z2.5_m=2000,NsplEpi=100,Mbreak=7.6,Zhypo_km=55,SatReg=global,Basin=0_NoBasin,Nsigma=1,T_sec=0.01","Mag=7.25,Vs30_mps=760,Reg=0_global,Rrup_km=200,alpBack=0,alpNank=0,Ztor_km=10,InterIntra=1_Intraslab,SeatBasn=0_NoBasin,Z1.0_m=550,Z2.5_m=2000,NsplEpi=100,Mbreak=7.6,Zhypo_km=55,SatReg=global,Basin=0_NoBasin,Nsigma=1,T_sec=0.01","Mag=7.5,Vs30_mps=760,Reg=0_global,Rrup_km=200,alpBack=0,alpNank=0,Ztor_km=10,InterIntra=1_Intraslab,SeatBasn=0_NoBasin,Z1.0_m=550,Z2.5_m=2000,NsplEpi=100,Mbreak=7.6,Zhypo_km=55,SatReg=global,Basin=0_NoBasin,Nsigma=1,T_sec=0.01","Mag=7.75,Vs30_mps=760,Reg=0_global,Rrup_km=200,alpBack=0,alpNank=0,Ztor_km=10,InterIntra=1_Intraslab,SeatBasn=0_NoBasin,Z1.0_m=550,Z2.5_m=2000,NsplEpi=100,Mbreak=7.6,Zhypo_km=55,SatReg=global,Basin=0_NoBasin,Nsigma=1,T_sec=0.01","Mag=8,Vs30_mps=760,Reg=0_global,Rrup_km=200,alpBack=0,alpNank=0,Ztor_km=10,InterIntra=1_Intraslab,SeatBasn=0_NoBasin,Z1.0_m=550,Z2.5_m=2000,NsplEpi=100,Mbreak=7.6,Zhypo_km=55,SatReg=global,Basin=0_NoBasin,Nsigma=1,T_sec=0.01","Mag=8.25,Vs30_mps=760,Reg=0_global,Rrup_km=200,alpBack=0,alpNank=0,Ztor_km=10,InterIntra=1_Intraslab,SeatBasn=0_NoBasin,Z1.0_m=550,Z2.5_m=2000,NsplEpi=100,Mbreak=7.6,Zhypo_km=55,SatReg=global,Basin=0_NoBasin,Nsigma=1,T_sec=0.01","Mag=8.5,Vs30_mps=760,Reg=0_global,Rrup_km=200,alpBack=0,alpNank=0,Ztor_km=10,InterIntra=1_Intraslab,SeatBasn=0_NoBasin,Z1.0_m=550,Z2.5_m=2000,NsplEpi=100,Mbreak=7.6,Zhypo_km=55,SatReg=global,Basin=0_NoBasin,Nsigma=1,T_sec=0.01","Mag=8.75,Vs30_mps=760,Reg=0_global,Rrup_km=200,alpBack=0,alpNank=0,Ztor_km=10,InterIntra=1_Intraslab,SeatBasn=0_NoBasin,Z1.0_m=550,Z2.5_m=2000,NsplEpi=100,Mbreak=7.6,Zhypo_km=55,SatReg=global,Basin=0_NoBasin,Nsigma=1,T_sec=0.01","Mag=9,Vs30_mps=760,Reg=0_global,Rrup_km=200,alpBack=0,alpNank=0,Ztor_km=10,InterIntra=1_Intraslab,SeatBasn=0_NoBasin,Z1.0_m=550,Z2.5_m=2000,NsplEpi=100,Mbreak=7.6,Zhypo_km=55,SatReg=global,Basin=0_NoBasin,Nsigma=1,T_sec=0.01","Mag=9.25,Vs30_mps=760,Reg=0_global,Rrup_km=200,alpBack=0,alpNank=0,Ztor_km=10,InterIntra=1_Intraslab,SeatBasn=0_NoBasin,Z1.0_m=550,Z2.5_m=2000,NsplEpi=100,Mbreak=7.6,Zhypo_km=55,SatReg=global,Basin=0_NoBasin,Nsigma=1,T_sec=0.01","Mag=8,Vs30_mps=760,Reg=0_global,Rrup_km=40,alpBack=0,alpNank=0,Ztor_km=10,InterIntra=1_Intraslab,SeatBasn=0_NoBasin,Z1.0_m=550,Z2.5_m=2000,NsplEpi=100,Mbreak=7.9,Zhypo_km=55,SatReg=global,Basin=0_NoBasin,Nsigma=1,T_sec=0.01","Mag=8,Vs30_mps=760,Reg=0_global,Rrup_km=52,alpBack=0,alpNank=0,Ztor_km=10,InterIntra=1_Intraslab,SeatBasn=0_NoBasin,Z1.0_m=550,Z2.5_m=2000,NsplEpi=100,Mbreak=7.9,Zhypo_km=55,SatReg=global,Basin=0_NoBasin,Nsigma=1,T_sec=0.01","Mag=8,Vs30_mps=760,Reg=0_global,Rrup_km=67.6,alpBack=0,alpNank=0,Ztor_km=10,InterIntra=1_Intraslab,SeatBasn=0_NoBasin,Z1.0_m=550,Z2.5_m=2000,NsplEpi=100,Mbreak=7.9,Zhypo_km=55,SatReg=global,Basin=0_NoBasin,Nsigma=1,T_sec=0.01","Mag=8,Vs30_mps=760,Reg=0_global,Rrup_km=87.88,alpBack=0,alpNank=0,Ztor_km=10,InterIntra=1_Intraslab,SeatBasn=0_NoBasin,Z1.0_m=550,Z2.5_m=2000,NsplEpi=100,Mbreak=7.9,Zhypo_km=55,SatReg=global,Basin=0_NoBasin,Nsigma=1,T_sec=0.01","Mag=8,Vs30_mps=760,Reg=0_global,Rrup_km=114.244,alpBack=0,alpNank=0,Ztor_km=10,InterIntra=1_Intraslab,SeatBasn=0_NoBasin,Z1.0_m=550,Z2.5_m=2000,NsplEpi=100,Mbreak=7.9,Zhypo_km=55,SatReg=global,Basin=0_NoBasin,Nsigma=1,T_sec=0.01","Mag=8,Vs30_mps=760,Reg=0_global,Rrup_km=148.5172,alpBack=0,alpNank=0,Ztor_km=10,InterIntra=1_Intraslab,SeatBasn=0_NoBasin,Z1.0_m=550,Z2.5_m=2000,NsplEpi=100,Mbreak=7.9,Zhypo_km=55,SatReg=global,Basin=0_NoBasin,Nsigma=1,T_sec=0.01","Mag=8,Vs30_mps=760,Reg=0_global,Rrup_km=193.07236,alpBack=0,alpNank=0,Ztor_km=10,InterIntra=1_Intraslab,SeatBasn=0_NoBasin,Z1.0_m=550,Z2.5_m=2000,NsplEpi=100,Mbreak=7.9,Zhypo_km=55,SatReg=global,Basin=0_NoBasin,Nsigma=1,T_sec=0.01","Mag=8,Vs30_mps=760,Reg=0_global,Rrup_km=250.994068,alpBack=0,alpNank=0,Ztor_km=10,InterIntra=1_Intraslab,SeatBasn=0_NoBasin,Z1.0_m=550,Z2.5_m=2000,NsplEpi=100,Mbreak=7.9,Zhypo_km=55,SatReg=global,Basin=0_NoBasin,Nsigma=1,T_sec=0.01","Mag=8,Vs30_mps=760,Reg=0_global,Rrup_km=326.2922884,alpBack=0,alpNank=0,Ztor_km=10,InterIntra=1_Intraslab,SeatBasn=0_NoBasin,Z1.0_m=550,Z2.5_m=2000,NsplEpi=100,Mbreak=7.9,Zhypo_km=55,SatReg=global,Basin=0_NoBasin,Nsigma=1,T_sec=0.01","Mag=8,Vs30_mps=760,Reg=0_global,Rrup_km=424.179974919999,alpBack=0,alpNank=0,Ztor_km=10,InterIntra=1_Intraslab,SeatBasn=0_NoBasin,Z1.0_m=550,Z2.5_m=2000,NsplEpi=100,Mbreak=7.9,Zhypo_km=55,SatReg=global,Basin=0_NoBasin,Nsigma=1,T_sec=0.01","Mag=8,Vs30_mps=760,Reg=0_global,Rrup_km=551.433967395999,alpBack=0,alpNank=0,Ztor_km=10,InterIntra=1_Intraslab,SeatBasn=0_NoBasin,Z1.0_m=550,Z2.5_m=2000,NsplEpi=100,Mbreak=7.9,Zhypo_km=55,SatReg=global,Basin=0_NoBasin,Nsigma=1,T_sec=0.01","Mag=8,Vs30_mps=760,Reg=0_global,Rrup_km=716.864157614799,alpBack=0,alpNank=0,Ztor_km=10,InterIntra=1_Intraslab,SeatBasn=0_NoBasin,Z1.0_m=550,Z2.5_m=2000,NsplEpi=100,Mbreak=7.9,Zhypo_km=55,SatReg=global,Basin=0_NoBasin,Nsigma=1,T_sec=0.01","Mag=8,Vs30_mps=760,Reg=0_global,Rrup_km=931.923404899238,alpBack=0,alpNank=0,Ztor_km=10,InterIntra=1_Intraslab,SeatBasn=0_NoBasin,Z1.0_m=550,Z2.5_m=2000,NsplEpi=100,Mbreak=7.9,Zhypo_km=55,SatReg=global,Basin=0_NoBasin,Nsigma=1,T_sec=0.01","Mag=8,Vs30_mps=760,Reg=0_global,Rrup_km=1211.50042636901,alpBack=0,alpNank=0,Ztor_km=10,InterIntra=1_Intraslab,SeatBasn=0_NoBasin,Z1.0_m=550,Z2.5_m=2000,NsplEpi=100,Mbreak=7.9,Zhypo_km=55,SatReg=global,Basin=0_NoBasin,Nsigma=1,T_sec=0.01","Mag=8,Vs30_mps=760,Reg=0_global,Rrup_km=1574.95055427971,alpBack=0,alpNank=0,Ztor_km=10,InterIntra=1_Intraslab,SeatBasn=0_NoBasin,Z1.0_m=550,Z2.5_m=2000,NsplEpi=100,Mbreak=7.9,Zhypo_km=55,SatReg=global,Basin=0_NoBasin,Nsigma=1,T_sec=0.01","Mag=8,Vs30_mps=760,Reg=0_global,Rrup_km=2047.43572056362,alpBack=0,alpNank=0,Ztor_km=10,InterIntra=1_Intraslab,SeatBasn=0_NoBasin,Z1.0_m=550,Z2.5_m=2000,NsplEpi=100,Mbreak=7.9,Zhypo_km=55,SatReg=global,Basin=0_NoBasin,Nsigma=1,T_sec=0.01","Mag=8,Vs30_mps=760,Reg=0_global,Rrup_km=2661.66643673271,alpBack=0,alpNank=0,Ztor_km=10,InterIntra=1_Intraslab,SeatBasn=0_NoBasin,Z1.0_m=550,Z2.5_m=2000,NsplEpi=100,Mbreak=7.9,Zhypo_km=55,SatReg=global,Basin=0_NoBasin,Nsigma=1,T_sec=0.01","Mag=8,Vs30_mps=760,Reg=0_global,Rrup_km=3460.16636775252,alpBack=0,alpNank=0,Ztor_km=10,InterIntra=1_Intraslab,SeatBasn=0_NoBasin,Z1.0_m=550,Z2.5_m=2000,NsplEpi=100,Mbreak=7.9,Zhypo_km=55,SatReg=global,Basin=0_NoBasin,Nsigma=1,T_sec=0.01","Mag=8,Vs30_mps=760,Reg=0_global,Rrup_km=4498.21627807827,alpBack=0,alpNank=0,Ztor_km=10,InterIntra=1_Intraslab,SeatBasn=0_NoBasin,Z1.0_m=550,Z2.5_m=2000,NsplEpi=100,Mbreak=7.9,Zhypo_km=55,SatReg=global,Basin=0_NoBasin,Nsigma=1,T_sec=0.01","Mag=8,Vs30_mps=760,Reg=0_global,Rrup_km=5847.68116150175,alpBack=0,alpNank=0,Ztor_km=10,InterIntra=1_Intraslab,SeatBasn=0_NoBasin,Z1.0_m=550,Z2.5_m=2000,NsplEpi=100,Mbreak=7.9,Zhypo_km=55,SatReg=global,Basin=0_NoBasin,Nsigma=1,T_sec=0.01","Mag=8,Vs30_mps=760,Reg=0_global,Rrup_km=7601.98550995228,alpBack=0,alpNank=0,Ztor_km=10,InterIntra=1_Intraslab,SeatBasn=0_NoBasin,Z1.0_m=550,Z2.5_m=2000,NsplEpi=100,Mbreak=7.9,Zhypo_km=55,SatReg=global,Basin=0_NoBasin,Nsigma=1,T_sec=0.01","Mag=8,Vs30_mps=760,Reg=0_global,Rrup_km=9882.58116293796,alpBack=0,alpNank=0,Ztor_km=10,InterIntra=1_Intraslab,SeatBasn=0_NoBasin,Z1.0_m=550,Z2.5_m=2000,NsplEpi=100,Mbreak=7.9,Zhypo_km=55,SatReg=global,Basin=0_NoBasin,Nsigma=1,T_sec=0.01","Mag=8,Vs30_mps=150,Reg=0_global,Rrup_km=200,alpBack=0,alpNank=0,Ztor_km=10,InterIntra=1_Intraslab,SeatBasn=0_NoBasin,Z1.0_m=550,Z2.5_m=2000,NsplEpi=100,Mbreak=7.6,Zhypo_km=55,SatReg=global,Basin=0_NoBasin,Nsigma=1,T_sec=0.01","Mag=8,Vs30_mps=169.5,Reg=0_global,Rrup_km=200,alpBack=0,alpNank=0,Ztor_km=10,InterIntra=1_Intraslab,SeatBasn=0_NoBasin,Z1.0_m=550,Z2.5_m=2000,NsplEpi=100,Mbreak=7.6,Zhypo_km=55,SatReg=global,Basin=0_NoBasin,Nsigma=1,T_sec=0.01","Mag=8,Vs30_mps=191.535,Reg=0_global,Rrup_km=200,alpBack=0,alpNank=0,Ztor_km=10,InterIntra=1_Intraslab,SeatBasn=0_NoBasin,Z1.0_m=550,Z2.5_m=2000,NsplEpi=100,Mbreak=7.6,Zhypo_km=55,SatReg=global,Basin=0_NoBasin,Nsigma=1,T_sec=0.01","Mag=8,Vs30_mps=216.43455,Reg=0_global,Rrup_km=200,alpBack=0,alpNank=0,Ztor_km=10,InterIntra=1_Intraslab,SeatBasn=0_NoBasin,Z1.0_m=550,Z2.5_m=2000,NsplEpi=100,Mbreak=7.6,Zhypo_km=55,SatReg=global,Basin=0_NoBasin,Nsigma=1,T_sec=0.01","Mag=8,Vs30_mps=244.5710415,Reg=0_global,Rrup_km=200,alpBack=0,alpNank=0,Ztor_km=10,InterIntra=1_Intraslab,SeatBasn=0_NoBasin,Z1.0_m=550,Z2.5_m=2000,NsplEpi=100,Mbreak=7.6,Zhypo_km=55,SatReg=global,Basin=0_NoBasin,Nsigma=1,T_sec=0.01","Mag=8,Vs30_mps=276.365276895,Reg=0_global,Rrup_km=200,alpBack=0,alpNank=0,Ztor_km=10,InterIntra=1_Intraslab,SeatBasn=0_NoBasin,Z1.0_m=550,Z2.5_m=2000,NsplEpi=100,Mbreak=7.6,Zhypo_km=55,SatReg=global,Basin=0_NoBasin,Nsigma=1,T_sec=0.01","Mag=8,Vs30_mps=312.29276289135,Reg=0_global,Rrup_km=200,alpBack=0,alpNank=0,Ztor_km=10,InterIntra=1_Intraslab,SeatBasn=0_NoBasin,Z1.0_m=550,Z2.5_m=2000,NsplEpi=100,Mbreak=7.6,Zhypo_km=55,SatReg=global,Basin=0_NoBasin,Nsigma=1,T_sec=0.01","Mag=8,Vs30_mps=352.890822067225,Reg=0_global,Rrup_km=200,alpBack=0,alpNank=0,Ztor_km=10,InterIntra=1_Intraslab,SeatBasn=0_NoBasin,Z1.0_m=550,Z2.5_m=2000,NsplEpi=100,Mbreak=7.6,Zhypo_km=55,SatReg=global,Basin=0_NoBasin,Nsigma=1,T_sec=0.01","Mag=8,Vs30_mps=398.766628935964,Reg=0_global,Rrup_km=200,alpBack=0,alpNank=0,Ztor_km=10,InterIntra=1_Intraslab,SeatBasn=0_NoBasin,Z1.0_m=550,Z2.5_m=2000,NsplEpi=100,Mbreak=7.6,Zhypo_km=55,SatReg=global,Basin=0_NoBasin,Nsigma=1,T_sec=0.01","Mag=8,Vs30_mps=450.60629069764,Reg=0_global,Rrup_km=200,alpBack=0,alpNank=0,Ztor_km=10,InterIntra=1_Intraslab,SeatBasn=0_NoBasin,Z1.0_m=550,Z2.5_m=2000,NsplEpi=100,Mbreak=7.6,Zhypo_km=55,SatReg=global,Basin=0_NoBasin,Nsigma=1,T_sec=0.01","Mag=8,Vs30_mps=509.185108488333,Reg=0_global,Rrup_km=200,alpBack=0,alpNank=0,Ztor_km=10,InterIntra=1_Intraslab,SeatBasn=0_NoBasin,Z1.0_m=550,Z2.5_m=2000,NsplEpi=100,Mbreak=7.6,Zhypo_km=55,SatReg=global,Basin=0_NoBasin,Nsigma=1,T_sec=0.01","Mag=8,Vs30_mps=575.379172591816,Reg=0_global,Rrup_km=200,alpBack=0,alpNank=0,Ztor_km=10,InterIntra=1_Intraslab,SeatBasn=0_NoBasin,Z1.0_m=550,Z2.5_m=2000,NsplEpi=100,Mbreak=7.6,Zhypo_km=55,SatReg=global,Basin=0_NoBasin,Nsigma=1,T_sec=0.01","Mag=8,Vs30_mps=650.178465028752,Reg=0_global,Rrup_km=200,alpBack=0,alpNank=0,Ztor_km=10,InterIntra=1_Intraslab,SeatBasn=0_NoBasin,Z1.0_m=550,Z2.5_m=2000,NsplEpi=100,Mbreak=7.6,Zhypo_km=55,SatReg=global,Basin=0_NoBasin,Nsigma=1,T_sec=0.01","Mag=8,Vs30_mps=734.701665482489,Reg=0_global,Rrup_km=200,alpBack=0,alpNank=0,Ztor_km=10,InterIntra=1_Intraslab,SeatBasn=0_NoBasin,Z1.0_m=550,Z2.5_m=2000,NsplEpi=100,Mbreak=7.6,Zhypo_km=55,SatReg=global,Basin=0_NoBasin,Nsigma=1,T_sec=0.01","Mag=8,Vs30_mps=830.212881995213,Reg=0_global,Rrup_km=200,alpBack=0,alpNank=0,Ztor_km=10,InterIntra=1_Intraslab,SeatBasn=0_NoBasin,Z1.0_m=550,Z2.5_m=2000,NsplEpi=100,Mbreak=7.6,Zhypo_km=55,SatReg=global,Basin=0_NoBasin,Nsigma=1,T_sec=0.01","Mag=8,Vs30_mps=938.140556654591,Reg=0_global,Rrup_km=200,alpBack=0,alpNank=0,Ztor_km=10,InterIntra=1_Intraslab,SeatBasn=0_NoBasin,Z1.0_m=550,Z2.5_m=2000,NsplEpi=100,Mbreak=7.6,Zhypo_km=55,SatReg=global,Basin=0_NoBasin,Nsigma=1,T_sec=0.01","Mag=8,Vs30_mps=1060.09882901969,Reg=0_global,Rrup_km=200,alpBack=0,alpNank=0,Ztor_km=10,InterIntra=1_Intraslab,SeatBasn=0_NoBasin,Z1.0_m=550,Z2.5_m=2000,NsplEpi=100,Mbreak=7.6,Zhypo_km=55,SatReg=global,Basin=0_NoBasin,Nsigma=1,T_sec=0.01","Mag=8,Vs30_mps=1197.91167679225,Reg=0_global,Rrup_km=200,alpBack=0,alpNank=0,Ztor_km=10,InterIntra=1_Intraslab,SeatBasn=0_NoBasin,Z1.0_m=550,Z2.5_m=2000,NsplEpi=100,Mbreak=7.6,Zhypo_km=55,SatReg=global,Basin=0_NoBasin,Nsigma=1,T_sec=0.01","Mag=8,Vs30_mps=1353.64019477524,Reg=0_global,Rrup_km=200,alpBack=0,alpNank=0,Ztor_km=10,InterIntra=1_Intraslab,SeatBasn=0_NoBasin,Z1.0_m=550,Z2.5_m=2000,NsplEpi=100,Mbreak=7.6,Zhypo_km=55,SatReg=global,Basin=0_NoBasin,Nsigma=1,T_sec=0.01","Mag=8,Vs30_mps=1529.61342009602,Reg=0_global,Rrup_km=200,alpBack=0,alpNank=0,Ztor_km=10,InterIntra=1_Intraslab,SeatBasn=0_NoBasin,Z1.0_m=550,Z2.5_m=2000,NsplEpi=100,Mbreak=7.6,Zhypo_km=55,SatReg=global,Basin=0_NoBasin,Nsigma=1,T_sec=0.01","Mag=8,Vs30_mps=1728.4631647085,Reg=0_global,Rrup_km=200,alpBack=0,alpNank=0,Ztor_km=10,InterIntra=1_Intraslab,SeatBasn=0_NoBasin,Z1.0_m=550,Z2.5_m=2000,NsplEpi=100,Mbreak=7.6,Zhypo_km=55,SatReg=global,Basin=0_NoBasin,Nsigma=1,T_sec=0.01","Mag=8,Vs30_mps=1953.16337612061,Reg=0_global,Rrup_km=200,alpBack=0,alpNank=0,Ztor_km=10,InterIntra=1_Intraslab,SeatBasn=0_NoBasin,Z1.0_m=550,Z2.5_m=2000,NsplEpi=100,Mbreak=7.6,Zhypo_km=55,SatReg=global,Basin=0_NoBasin,Nsigma=1,T_sec=0.01","Mag=8,Vs30_mps=760,Reg=0_global,Rrup_km=200,alpBack=0,alpNank=0,Ztor_km=10,InterIntra=1_Intraslab,SeatBasn=0_NoBasin,Z1.0_m=550,Z2.5_m=2000,NsplEpi=100,Mbreak=7.6,Zhypo_km=55,SatReg=global,Basin=0_NoBasin,Nsigma=1,T_sec=0.01","Mag=8,Vs30_mps=760,Reg=1_Alaska,Rrup_km=200,alpBack=0,alpNank=0,Ztor_km=10,InterIntra=1_Intraslab,SeatBasn=0_NoBasin,Z1.0_m=550,Z2.5_m=2000,NsplEpi=100,Mbreak=7.2,Zhypo_km=55,SatReg=Alaska,Basin=0_NoBasin,Nsigma=1,T_sec=0.01","Mag=8,Vs30_mps=760,Reg=1_Alaska,Rrup_km=200,alpBack=0,alpNank=0,Ztor_km=10,InterIntra=1_Intraslab,SeatBasn=0_NoBasin,Z1.0_m=550,Z2.5_m=2000,NsplEpi=100,Mbreak=8,Zhypo_km=55,SatReg=Aleutian,Basin=0_NoBasin,Nsigma=1,T_sec=0.01","Mag=8,Vs30_mps=760,Reg=2_Cascadia,Rrup_km=200,alpBack=0,alpNank=0,Ztor_km=10,InterIntra=1_Intraslab,SeatBasn=0_NoBasin,Z1.0_m=550,Z2.5_m=2000,NsplEpi=100,Mbreak=7.2,Zhypo_km=55,SatReg=Cascadia,Basin=0_NoBasin,Nsigma=1,T_sec=0.01","Mag=8,Vs30_mps=760,Reg=2_Cascadia,Rrup_km=200,alpBack=0,alpNank=0,Ztor_km=10,InterIntra=1_Intraslab,SeatBasn=1_InSeattleBasin,Z1.0_m=550,Z2.5_m=2000,NsplEpi=100,Mbreak=7.2,Zhypo_km=55,SatReg=Cascadia,Basin=1_InSeattleBasin,Nsigma=1,T_sec=0.01","Mag=8,Vs30_mps=760,Reg=2_Cascadia,Rrup_km=200,alpBack=0,alpNank=0,Ztor_km=10,InterIntra=1_Intraslab,SeatBasn=2_InOtherPNWbasin,Z1.0_m=550,Z2.5_m=2000,NsplEpi=100,Mbreak=7.2,Zhypo_km=55,SatReg=Cascadia,Basin=2_InOtherPNWbasin,Nsigma=1,T_sec=0.01","Mag=8,Vs30_mps=760,Reg=3_CentralAmerica&Mexico,Rrup_km=200,alpBack=0,alpNank=0,Ztor_km=10,InterIntra=1_Intraslab,SeatBasn=2_InOtherPNWbasin,Z1.0_m=550,Z2.5_m=2000,NsplEpi=100,Mbreak=7.4,Zhypo_km=55,SatReg=Central_America_N,Basin=0_NoBasin,Nsigma=1,T_sec=0.01","Mag=8,Vs30_mps=760,Reg=3_CentralAmerica&Mexico,Rrup_km=200,alpBack=0,alpNank=0,Ztor_km=10,InterIntra=1_Intraslab,SeatBasn=2_InOtherPNWbasin,Z1.0_m=550,Z2.5_m=2000,NsplEpi=100,Mbreak=7.6,Zhypo_km=55,SatReg=Central_America_S,Basin=0_NoBasin,Nsigma=1,T_sec=0.01","Mag=8,Vs30_mps=760,Reg=4_Japan,Rrup_km=200,alpBack=0,alpNank=0,Ztor_km=10,InterIntra=1_Intraslab,SeatBasn=2_InOtherPNWbasin,Z1.0_m=550,Z2.5_m=2000,NsplEpi=100,Mbreak=7.6,Zhypo_km=55,SatReg=Japan_Pac,Basin=0_NoBasin,Nsigma=1,T_sec=0.01","Mag=8,Vs30_mps=760,Reg=4_Japan,Rrup_km=200,alpBack=0,alpNank=0,Ztor_km=10,InterIntra=1_Intraslab,SeatBasn=2_InOtherPNWbasin,Z1.0_m=550,Z2.5_m=2000,NsplEpi=100,Mbreak=7.6,Zhypo_km=55,SatReg=Japan_Phi,Basin=0_NoBasin,Nsigma=1,T_sec=0.01","Mag=8,Vs30_mps=760,Reg=5_NewZealand,Rrup_km=200,alpBack=0,alpNank=0,Ztor_km=10,InterIntra=1_Intraslab,SeatBasn=2_InOtherPNWbasin,Z1.0_m=550,Z2.5_m=2000,NsplEpi=100,Mbreak=7.6,Zhypo_km=55,SatReg=New_Zealand_N,Basin=0_NoBasin,Nsigma=1,T_sec=0.01","Mag=8,Vs30_mps=760,Reg=5_NewZealand,Rrup_km=200,alpBack=0,alpNank=0,Ztor_km=10,InterIntra=1_Intraslab,SeatBasn=2_InOtherPNWbasin,Z1.0_m=550,Z2.5_m=2000,NsplEpi=100,Mbreak=7.6,Zhypo_km=55,SatReg=New_Zealand_S,Basin=0_NoBasin,Nsigma=1,T_sec=0.01","Mag=8,Vs30_mps=760,Reg=6_SouthAmerica,Rrup_km=200,alpBack=0,alpNank=0,Ztor_km=10,InterIntra=1_Intraslab,SeatBasn=2_InOtherPNWbasin,Z1.0_m=550,Z2.5_m=2000,NsplEpi=100,Mbreak=7.3,Zhypo_km=55,SatReg=South_America_N,Basin=0_NoBasin,Nsigma=1,T_sec=0.01","Mag=8,Vs30_mps=760,Reg=6_SouthAmerica,Rrup_km=200,alpBack=0,alpNank=0,Ztor_km=10,InterIntra=1_Intraslab,SeatBasn=2_InOtherPNWbasin,Z1.0_m=550,Z2.5_m=2000,NsplEpi=100,Mbreak=7.2,Zhypo_km=55,SatReg=South_America_S,Basin=0_NoBasin,Nsigma=1,T_sec=0.01","Mag=8,Vs30_mps=760,Reg=7_Taiwan,Rrup_km=200,alpBack=0,alpNank=0,Ztor_km=10,InterIntra=1_Intraslab,SeatBasn=2_InOtherPNWbasin,Z1.0_m=550,Z2.5_m=2000,NsplEpi=100,Mbreak=7.7,Zhypo_km=55,SatReg=Taiwan_E,Basin=0_NoBasin,Nsigma=1,T_sec=0.01","Mag=8,Vs30_mps=760,Reg=7_Taiwan,Rrup_km=200,alpBack=0,alpNank=0,Ztor_km=10,InterIntra=1_Intraslab,SeatBasn=2_InOtherPNWbasin,Z1.0_m=550,Z2.5_m=2000,NsplEpi=100,Mbreak=7.7,Zhypo_km=55,SatReg=Taiwan_W,Basin=0_NoBasin,Nsigma=1,T_sec=0.01"];
                  CaseLabelRegion(iSet,:) = ["0_GLB_GLB_Mb7.6","0_GLB_GLB_Mb7.6","0_GLB_GLB_Mb7.6","0_GLB_GLB_Mb7.6","0_GLB_GLB_Mb7.6","0_GLB_GLB_Mb7.6","0_GLB_GLB_Mb7.6","0_GLB_GLB_Mb7.6","0_GLB_GLB_Mb7.6","0_GLB_GLB_Mb7.6","0_GLB_GLB_Mb7.6","0_GLB_GLB_Mb7.6","0_GLB_GLB_Mb7.6","0_GLB_GLB_Mb7.6","0_GLB_GLB_Mb7.6","0_GLB_GLB_Mb7.6","0_GLB_GLB_Mb7.6","0_GLB_GLB_Mb7.6","0_GLB_GLB_Mb7.6","0_GLB_GLB_Mb7.6","0_GLB_GLB_Mb7.6","0_GLB_GLB_Mb7.6","0_GLB_GLB_Mb7.6","0_GLB_GLB_Mb7.6","0_GLB_GLB_Mb7.6","0_GLB_GLB_Mb7.6","0_GLB_GLB_Mb7.6","0_GLB_GLB_Mb7.6","0_GLB_GLB_Mb7.6","0_GLB_GLB_Mb7.6","0_GLB_GLB_Mb7.6","0_GLB_GLB_Mb7.6","0_GLB_GLB_Mb7.6","0_GLB_GLB_Mb7.6","0_GLB_GLB_Mb7.6","0_GLB_GLB_Mb7.6","0_GLB_GLB_Mb7.6","0_GLB_GLB_Mb7.6","0_GLB_GLB_Mb7.6","0_GLB_GLB_Mb7.6","0_GLB_GLB_Mb7.6","0_GLB_GLB_Mb7.6","0_GLB_GLB_Mb7.6","0_GLB_GLB_Mb7.9","0_GLB_GLB_Mb7.9","0_GLB_GLB_Mb7.9","0_GLB_GLB_Mb7.9","0_GLB_GLB_Mb7.9","0_GLB_GLB_Mb7.9","0_GLB_GLB_Mb7.9","0_GLB_GLB_Mb7.9","0_GLB_GLB_Mb7.9","0_GLB_GLB_Mb7.9","0_GLB_GLB_Mb7.9","0_GLB_GLB_Mb7.9","0_GLB_GLB_Mb7.9","0_GLB_GLB_Mb7.9","0_GLB_GLB_Mb7.9","0_GLB_GLB_Mb7.9","0_GLB_GLB_Mb7.9","0_GLB_GLB_Mb7.9","0_GLB_GLB_Mb7.9","0_GLB_GLB_Mb7.9","0_GLB_GLB_Mb7.9","0_GLB_GLB_Mb7.9","0_GLB_GLB_Mb7.6","0_GLB_GLB_Mb7.6","0_GLB_GLB_Mb7.6","0_GLB_GLB_Mb7.6","0_GLB_GLB_Mb7.6","0_GLB_GLB_Mb7.6","0_GLB_GLB_Mb7.6","0_GLB_GLB_Mb7.6","0_GLB_GLB_Mb7.6","0_GLB_GLB_Mb7.6","0_GLB_GLB_Mb7.6","0_GLB_GLB_Mb7.6","0_GLB_GLB_Mb7.6","0_GLB_GLB_Mb7.6","0_GLB_GLB_Mb7.6","0_GLB_GLB_Mb7.6","0_GLB_GLB_Mb7.6","0_GLB_GLB_Mb7.6","0_GLB_GLB_Mb7.6","0_GLB_GLB_Mb7.6","0_GLB_GLB_Mb7.6","0_GLB_GLB_Mb7.6","0_GLB_GLB_Mb7.6","1_AK_AK_Mb7.2","1_AK_Aleu_Mb8","2_CSC_CSC_Mb7.2","2_CSC_CSC_Mb7.2_1_InSeattleBasin","2_CSC_CSC_Mb7.2_2_InOtherPNWbasin","3_CAM_CAM_N_Mb7.4","3_CAM_CAM_S_Mb7.6","4_JP_JP_Pac_Mb7.6","4_JP_JP_Phi_Mb7.6","5_NZ_NZ_N_Mb7.6","5_NZ_NZ_S_Mb7.6","6_SAM_SAM_N_Mb7.3","6_SAM_SAM_S_Mb7.2","7_TW_TW_E_Mb7.7","7_TW_TW_W_Mb7.7"];

                  Mag(iSet,:) = [8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,4,4.25,4.5,4.75,5,5.25,5.5,5.75,6,6.25,6.5,6.75,7,7.25,7.5,7.75,8,8.25,8.5,8.75,9,9.25,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8];
                  Vs30mps(iSet,:) = [760,760,760,760,760,760,760,760,760,760,760,760,760,760,760,760,760,760,760,760,760,760,760,760,760,760,760,760,760,760,760,760,760,760,760,760,760,760,760,760,760,760,760,760,760,760,760,760,760,760,760,760,760,760,760,760,760,760,760,760,760,760,760,760,760,150,169.5,191.535,216.43455,244.5710415,276.365276895,312.29276289135,352.890822067225,398.766628935964,450.60629069764,509.185108488333,575.379172591816,650.178465028752,734.701665482489,830.212881995213,938.140556654591,1060.09882901969,1197.91167679225,1353.64019477524,1529.61342009602,1728.4631647085,1953.16337612061,760,760,760,760,760,760,760,760,760,760,760,760,760,760,760,760];
                  Reg(iSet,:) = ["0_global","0_global","0_global","0_global","0_global","0_global","0_global","0_global","0_global","0_global","0_global","0_global","0_global","0_global","0_global","0_global","0_global","0_global","0_global","0_global","0_global","0_global","0_global","0_global","0_global","0_global","0_global","0_global","0_global","0_global","0_global","0_global","0_global","0_global","0_global","0_global","0_global","0_global","0_global","0_global","0_global","0_global","0_global","0_global","0_global","0_global","0_global","0_global","0_global","0_global","0_global","0_global","0_global","0_global","0_global","0_global","0_global","0_global","0_global","0_global","0_global","0_global","0_global","0_global","0_global","0_global","0_global","0_global","0_global","0_global","0_global","0_global","0_global","0_global","0_global","0_global","0_global","0_global","0_global","0_global","0_global","0_global","0_global","0_global","0_global","0_global","0_global","0_global","1_Alaska","1_Alaska","2_Cascadia","2_Cascadia","2_Cascadia","3_CentralAmerica&Mexico","3_CentralAmerica&Mexico","4_Japan","4_Japan","5_NewZealand","5_NewZealand","6_SouthAmerica","6_SouthAmerica","7_Taiwan","7_Taiwan"];
                  Rrup_km(iSet,:) = [200,200,200,200,200,200,200,200,200,200,200,200,200,200,200,200,200,200,200,200,200,200,200,200,200,200,200,200,200,200,200,200,200,200,200,200,200,200,200,200,200,200,200,40,52,67.6,87.88,114.244,148.5172,193.07236,250.994068,326.2922884,424.179974919999,551.433967395999,716.864157614799,931.923404899238,1211.50042636901,1574.95055427971,2047.43572056362,2661.66643673271,3460.16636775252,4498.21627807827,5847.68116150175,7601.98550995228,9882.58116293796,200,200,200,200,200,200,200,200,200,200,200,200,200,200,200,200,200,200,200,200,200,200,200,200,200,200,200,200,200,200,200,200,200,200,200,200,200,200];
                  alpBack(iSet,:) = [0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0];
                  alpNank(iSet,:) = [0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0];
                  Ztor_km(iSet,:) = [40,40,40,40,40,40,40,40,40,40,40,40,40,40,40,40,40,40,40,40,40,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10];
                  SeatBasn(iSet,:) = ["0_NoBasin","0_NoBasin","0_NoBasin","0_NoBasin","0_NoBasin","0_NoBasin","0_NoBasin","0_NoBasin","0_NoBasin","0_NoBasin","0_NoBasin","0_NoBasin","0_NoBasin","0_NoBasin","0_NoBasin","0_NoBasin","0_NoBasin","0_NoBasin","0_NoBasin","0_NoBasin","0_NoBasin","0_NoBasin","0_NoBasin","0_NoBasin","0_NoBasin","0_NoBasin","0_NoBasin","0_NoBasin","0_NoBasin","0_NoBasin","0_NoBasin","0_NoBasin","0_NoBasin","0_NoBasin","0_NoBasin","0_NoBasin","0_NoBasin","0_NoBasin","0_NoBasin","0_NoBasin","0_NoBasin","0_NoBasin","0_NoBasin","0_NoBasin","0_NoBasin","0_NoBasin","0_NoBasin","0_NoBasin","0_NoBasin","0_NoBasin","0_NoBasin","0_NoBasin","0_NoBasin","0_NoBasin","0_NoBasin","0_NoBasin","0_NoBasin","0_NoBasin","0_NoBasin","0_NoBasin","0_NoBasin","0_NoBasin","0_NoBasin","0_NoBasin","0_NoBasin","0_NoBasin","0_NoBasin","0_NoBasin","0_NoBasin","0_NoBasin","0_NoBasin","0_NoBasin","0_NoBasin","0_NoBasin","0_NoBasin","0_NoBasin","0_NoBasin","0_NoBasin","0_NoBasin","0_NoBasin","0_NoBasin","0_NoBasin","0_NoBasin","0_NoBasin","0_NoBasin","0_NoBasin","0_NoBasin","0_NoBasin","0_NoBasin","0_NoBasin","0_NoBasin","1_InSeattleBasin","2_InOtherPNWbasin","2_InOtherPNWbasin","2_InOtherPNWbasin","2_InOtherPNWbasin","2_InOtherPNWbasin","2_InOtherPNWbasin","2_InOtherPNWbasin","2_InOtherPNWbasin","2_InOtherPNWbasin","2_InOtherPNWbasin","2_InOtherPNWbasin"];
                  Z1pt0m(iSet,:) = [550,550,550,550,550,550,550,550,550,550,550,550,550,550,550,550,550,550,550,550,550,550,550,550,550,550,550,550,550,550,550,550,550,550,550,550,550,550,550,550,550,550,550,550,550,550,550,550,550,550,550,550,550,550,550,550,550,550,550,550,550,550,550,550,550,550,550,550,550,550,550,550,550,550,550,550,550,550,550,550,550,550,550,550,550,550,550,550,550,550,550,550,550,550,550,550,550,550,550,550,550,550,550];
                  Z2pt5m(iSet,:) = [2000,2000,2000,2000,2000,2000,2000,2000,2000,2000,2000,2000,2000,2000,2000,2000,2000,2000,2000,2000,2000,2000,2000,2000,2000,2000,2000,2000,2000,2000,2000,2000,2000,2000,2000,2000,2000,2000,2000,2000,2000,2000,2000,2000,2000,2000,2000,2000,2000,2000,2000,2000,2000,2000,2000,2000,2000,2000,2000,2000,2000,2000,2000,2000,2000,2000,2000,2000,2000,2000,2000,2000,2000,2000,2000,2000,2000,2000,2000,2000,2000,2000,2000,2000,2000,2000,2000,2000,2000,2000,2000,2000,2000,2000,2000,2000,2000,2000,2000,2000,2000,2000,2000];
                  NsplEpi(iSet,:) = [100,100,100,100,100,100,100,100,100,100,100,100,100,100,100,100,100,100,100,100,100,100,100,100,100,100,100,100,100,100,100,100,100,100,100,100,100,100,100,100,100,100,100,100,100,100,100,100,100,100,100,100,100,100,100,100,100,100,100,100,100,100,100,100,100,100,100,100,100,100,100,100,100,100,100,100,100,100,100,100,100,100,100,100,100,100,100,100,100,100,100,100,100,100,100,100,100,100,100,100,100,100,100];
                  Mbreak(iSet,:) = [7.6,7.6,7.6,7.6,7.6,7.6,7.6,7.6,7.6,7.6,7.6,7.6,7.6,7.6,7.6,7.6,7.6,7.6,7.6,7.6,7.6,7.6,7.6,7.6,7.6,7.6,7.6,7.6,7.6,7.6,7.6,7.6,7.6,7.6,7.6,7.6,7.6,7.6,7.6,7.6,7.6,7.6,7.6,7.9,7.9,7.9,7.9,7.9,7.9,7.9,7.9,7.9,7.9,7.9,7.9,7.9,7.9,7.9,7.9,7.9,7.9,7.9,7.9,7.9,7.9,7.6,7.6,7.6,7.6,7.6,7.6,7.6,7.6,7.6,7.6,7.6,7.6,7.6,7.6,7.6,7.6,7.6,7.6,7.6,7.6,7.6,7.6,7.6,7.2,8,7.2,7.2,7.2,7.4,7.6,7.6,7.6,7.6,7.6,7.3,7.2,7.7,7.7];
                  Zhypo_km(iSet,:) = [55,55,55,55,55,55,55,55,55,55,55,55,55,55,55,55,55,55,55,55,55,55,55,55,55,55,55,55,55,55,55,55,55,55,55,55,55,55,55,55,55,55,55,55,55,55,55,55,55,55,55,55,55,55,55,55,55,55,55,55,55,55,55,55,55,55,55,55,55,55,55,55,55,55,55,55,55,55,55,55,55,55,55,55,55,55,55,55,55,55,55,55,55,55,55,55,55,55,55,55,55,55,55];
                  SatReg(iSet,:) = ["global","global","global","global","global","global","global","global","global","global","global","global","global","global","global","global","global","global","global","global","global","global","global","global","global","global","global","global","global","global","global","global","global","global","global","global","global","global","global","global","global","global","global","global","global","global","global","global","global","global","global","global","global","global","global","global","global","global","global","global","global","global","global","global","global","global","global","global","global","global","global","global","global","global","global","global","global","global","global","global","global","global","global","global","global","global","global","global","Alaska","Aleutian","Cascadia","Cascadia","Cascadia","Central_America_N","Central_America_S","Japan_Pac","Japan_Phi","New_Zealand_N","New_Zealand_S","South_America_N","South_America_S","Taiwan_E","Taiwan_W"];
                  Basin(iSet,:) = ["0_NoBasin","0_NoBasin","0_NoBasin","0_NoBasin","0_NoBasin","0_NoBasin","0_NoBasin","0_NoBasin","0_NoBasin","0_NoBasin","0_NoBasin","0_NoBasin","0_NoBasin","0_NoBasin","0_NoBasin","0_NoBasin","0_NoBasin","0_NoBasin","0_NoBasin","0_NoBasin","0_NoBasin","0_NoBasin","0_NoBasin","0_NoBasin","0_NoBasin","0_NoBasin","0_NoBasin","0_NoBasin","0_NoBasin","0_NoBasin","0_NoBasin","0_NoBasin","0_NoBasin","0_NoBasin","0_NoBasin","0_NoBasin","0_NoBasin","0_NoBasin","0_NoBasin","0_NoBasin","0_NoBasin","0_NoBasin","0_NoBasin","0_NoBasin","0_NoBasin","0_NoBasin","0_NoBasin","0_NoBasin","0_NoBasin","0_NoBasin","0_NoBasin","0_NoBasin","0_NoBasin","0_NoBasin","0_NoBasin","0_NoBasin","0_NoBasin","0_NoBasin","0_NoBasin","0_NoBasin","0_NoBasin","0_NoBasin","0_NoBasin","0_NoBasin","0_NoBasin","0_NoBasin","0_NoBasin","0_NoBasin","0_NoBasin","0_NoBasin","0_NoBasin","0_NoBasin","0_NoBasin","0_NoBasin","0_NoBasin","0_NoBasin","0_NoBasin","0_NoBasin","0_NoBasin","0_NoBasin","0_NoBasin","0_NoBasin","0_NoBasin","0_NoBasin","0_NoBasin","0_NoBasin","0_NoBasin","0_NoBasin","0_NoBasin","0_NoBasin","0_NoBasin","1_InSeattleBasin","2_InOtherPNWbasin","0_NoBasin","0_NoBasin","0_NoBasin","0_NoBasin","0_NoBasin","0_NoBasin","0_NoBasin","0_NoBasin","0_NoBasin","0_NoBasin"];
                  Nsigma(iSet,:) = [1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1];
                  InterIntra(iSet,:) = ["1_Intraslab","1_Intraslab","1_Intraslab","1_Intraslab","1_Intraslab","1_Intraslab","1_Intraslab","1_Intraslab","1_Intraslab","1_Intraslab","1_Intraslab","1_Intraslab","1_Intraslab","1_Intraslab","1_Intraslab","1_Intraslab","1_Intraslab","1_Intraslab","1_Intraslab","1_Intraslab","1_Intraslab","1_Intraslab","1_Intraslab","1_Intraslab","1_Intraslab","1_Intraslab","1_Intraslab","1_Intraslab","1_Intraslab","1_Intraslab","1_Intraslab","1_Intraslab","1_Intraslab","1_Intraslab","1_Intraslab","1_Intraslab","1_Intraslab","1_Intraslab","1_Intraslab","1_Intraslab","1_Intraslab","1_Intraslab","1_Intraslab","1_Intraslab","1_Intraslab","1_Intraslab","1_Intraslab","1_Intraslab","1_Intraslab","1_Intraslab","1_Intraslab","1_Intraslab","1_Intraslab","1_Intraslab","1_Intraslab","1_Intraslab","1_Intraslab","1_Intraslab","1_Intraslab","1_Intraslab","1_Intraslab","1_Intraslab","1_Intraslab","1_Intraslab","1_Intraslab","1_Intraslab","1_Intraslab","1_Intraslab","1_Intraslab","1_Intraslab","1_Intraslab","1_Intraslab","1_Intraslab","1_Intraslab","1_Intraslab","1_Intraslab","1_Intraslab","1_Intraslab","1_Intraslab","1_Intraslab","1_Intraslab","1_Intraslab","1_Intraslab","1_Intraslab","1_Intraslab","1_Intraslab","1_Intraslab","1_Intraslab","1_Intraslab","1_Intraslab","1_Intraslab","1_Intraslab","1_Intraslab","1_Intraslab","1_Intraslab","1_Intraslab","1_Intraslab","1_Intraslab","1_Intraslab","1_Intraslab","1_Intraslab","1_Intraslab","1_Intraslab"];
                  T_sec(iSet,:) = [0.01,0.02,0.03,0.05,0.075,0.1,0.15,0.2,0.25,0.3,0.4,0.5,0.75,1,1.5,2,3,4,5,7.5,10,0.01,0.01,0.01,0.01,0.01,0.01,0.01,0.01,0.01,0.01,0.01,0.01,0.01,0.01,0.01,0.01,0.01,0.01,0.01,0.01,0.01,0.01,0.01,0.01,0.01,0.01,0.01,0.01,0.01,0.01,0.01,0.01,0.01,0.01,0.01,0.01,0.01,0.01,0.01,0.01,0.01,0.01,0.01,0.01,0.01,0.01,0.01,0.01,0.01,0.01,0.01,0.01,0.01,0.01,0.01,0.01,0.01,0.01,0.01,0.01,0.01,0.01,0.01,0.01,0.01,0.01,0.01,0.01,0.01,0.01,0.01,0.01,0.01,0.01,0.01,0.01,0.01,0.01,0.01,0.01,0.01,0.01];
      
            end
            [junk,NN] = size(T_sec);
            iRowStart = 1;
            iRowEnd = NN;

            for irow = iRowStart:iRowEnd
                thisCaseLabel = CaseLabel(iSet,irow);
                thisMagnitude = Mag(iSet,irow);
                thisVs30 = Vs30mps(iSet,irow);
                thisRegion = Reg(iSet,irow);
                thisRrup = Rrup_km(iSet,irow);
                thisAlphaBackarc = alpBack(iSet,irow);
                thisAlphaNankai = alpNank(iSet,irow);
                thisZtor = Ztor_km(iSet,irow);
                thisSeatBasn = SeatBasn(iSet,irow);
                thisZ1pt0 = Z1pt0m(iSet,irow);
                thisZ2pt5 = Z2pt5m(iSet,irow);
                thisNsampleEpi = NsplEpi(iSet,irow);
                thisMb = Mbreak(iSet,irow);
                thisZhypo = Zhypo_km(iSet,irow);
                thisSubductionSlab = SatReg(iSet,irow);
                thisPNWbasinStrux = Basin(iSet,irow);
                thisNsigma = Nsigma(iSet,irow);
                thisEventType = InterIntra(iSet,irow);
                thisT = T_sec(iSet,irow);

                hereKBCG20MedianPSA = KBCG20_medPSA(thisT, thisMagnitude,thisRrup, thisAlphaBackarc, thisAlphaNankai, thisZtor, thisEventType, thisVs30,thisZ1pt0,thisZ2pt5, thisMb,thisRegion,thisPNWbasinStrux);
                hereKBCG20Tau = KBCG20_sigmaTau(thisT);
                hereKBCG20Phi = KBCG20_sigmaPhi(thisT);
                hereKBCG20SigmaAleatory = KBCG20_sigmaAleatory(thisT);
                hereKBCG20SigmaEpistemic = KBCG20_SigmaEpistemic(thisT, thisMagnitude,thisRrup, thisAlphaBackarc, thisAlphaNankai, thisZtor, thisEventType, thisVs30,thisZ1pt0,thisZ2pt5, thisMb,thisRegion,thisNsampleEpi,thisPNWbasinStrux);
                hereKBCG20SigmaTotal = KBCG20_SigmaTotal(thisT, thisMagnitude,thisRrup, thisAlphaBackarc, thisAlphaNankai, thisZtor, thisEventType, thisVs30,thisZ1pt0,thisZ2pt5, thisMb,thisRegion,thisNsampleEpi,thisPNWbasinStrux);
                hereKBCG20MedianMinusNsigmaxSigmaTotal = exp( log(hereKBCG20MedianPSA)-thisNsigma*hereKBCG20SigmaTotal);
                hereKBCG20MedianPlusNsigmaxSigmaTotal = exp( log(hereKBCG20MedianPSA)+thisNsigma*hereKBCG20SigmaTotal);
                hereKBCG20MedianMinusNsigmaxSigmaAleatory = exp( log(hereKBCG20MedianPSA)-thisNsigma*hereKBCG20SigmaAleatory);
                hereKBCG20MedianPlusNsigmaxSigmaAleatory = exp( log(hereKBCG20MedianPSA)+thisNsigma*hereKBCG20SigmaAleatory);
                hereKBCG20MedianMinusNsigmaxSigmaEpistemic = exp( log(hereKBCG20MedianPSA)-thisNsigma*hereKBCG20SigmaEpistemic);
                hereKBCG20MedianPlusNsigmaxSigmaEpistemic = exp( log(hereKBCG20MedianPSA)+thisNsigma*hereKBCG20SigmaEpistemic);
                herePSHAB20MedianPSA = PSHAB20_Median(thisEventType, thisRegion, thisSubductionSlab, thisRrup, thisMagnitude, thisZhypo, thisT, thisVs30, thisZ2pt5, thisPNWbasinStrux);
                herePSHAB20Tau = PSHAB20_Tau(thisT, thisRrup, thisVs30);
                herePSHAB20PhiTot = PSHAB20_PhiTot(thisT, thisRrup, thisVs30);
                herePSHAB20PhiS2S = PSHAB20_SigmaS2S(thisT, thisRrup, thisVs30);
                herePSHAB20PhiSS = PSHAB20_SigmaSS(thisT, thisRrup, thisVs30);
                herePSHAB20SigmaAleatory = PSHAB20_SigmaAleatory(thisT, thisRrup, thisVs30);
                herePSHAB20SigmaEpistemic = PSHAB20_SigmaEpistemic(thisT, thisEventType, thisSubductionSlab);
                herePSHAB20SigmaTotal = PSHAB20_SigmaTotal(thisT, thisRrup,  thisVs30, thisEventType, thisSubductionSlab);
                herePSHAB20MedianMinusNsigmaxSigmaTotal = exp(log(herePSHAB20MedianPSA)-thisNsigma*herePSHAB20SigmaTotal);
                herePSHAB20MedianPlusNsigmaxSigmaTotal = exp(log(herePSHAB20MedianPSA)+thisNsigma*herePSHAB20SigmaTotal);
                herePSHAB20MedianMinusNsigmaxSigmaAleatory = exp(log(herePSHAB20MedianPSA)-thisNsigma*herePSHAB20SigmaAleatory);
                herePSHAB20MedianPlusNsigmaxSigmaAleatory = exp(log(herePSHAB20MedianPSA)+thisNsigma*herePSHAB20SigmaAleatory);
                herePSHAB20MedianMinusNsigmaxSigmaEpistemic = exp(log(herePSHAB20MedianPSA)-thisNsigma*herePSHAB20SigmaEpistemic);
                herePSHAB20MedianPlusNsigmaxSigmaEpistemic = exp(log(herePSHAB20MedianPSA)+thisNsigma*herePSHAB20SigmaEpistemic);
                outMatrixRows(irow + (iSet-1)*NN,:) = [hereKBCG20MedianPSA,hereKBCG20Tau,hereKBCG20Phi,hereKBCG20SigmaAleatory,hereKBCG20SigmaEpistemic,hereKBCG20SigmaTotal,hereKBCG20MedianMinusNsigmaxSigmaTotal,hereKBCG20MedianPlusNsigmaxSigmaTotal,hereKBCG20MedianMinusNsigmaxSigmaAleatory,hereKBCG20MedianPlusNsigmaxSigmaAleatory,hereKBCG20MedianMinusNsigmaxSigmaEpistemic,hereKBCG20MedianPlusNsigmaxSigmaEpistemic,herePSHAB20MedianPSA,herePSHAB20Tau,herePSHAB20PhiTot,herePSHAB20PhiS2S,herePSHAB20PhiSS,herePSHAB20SigmaAleatory,herePSHAB20SigmaEpistemic,herePSHAB20SigmaTotal,herePSHAB20MedianMinusNsigmaxSigmaTotal,herePSHAB20MedianPlusNsigmaxSigmaTotal,herePSHAB20MedianMinusNsigmaxSigmaAleatory,herePSHAB20MedianPlusNsigmaxSigmaAleatory,herePSHAB20MedianMinusNsigmaxSigmaEpistemic,herePSHAB20MedianPlusNsigmaxSigmaEpistemic];
            end;    % for irow
        end;    % for iset
        outDataTableStudy = array2table(outMatrixRows);
        outDataTableHeader = {'KBCG20MedianPSA','KBCG20Tau','KBCG20Phi','KBCG20SigmaAleatory','KBCG20SigmaEpistemic','KBCG20SigmaTotal','KBCG20MedianMinusNsigmaxSigmaTotal','KBCG20MedianPlusNsigmaxSigmaTotal','KBCG20MedianMinusNsigmaxSigmaAleatory','KBCG20MedianPlusNsigmaxSigmaAleatory','KBCG20MedianMinusNsigmaxSigmaEpistemic','KBCG20MedianPlusNsigmaxSigmaEpistemic','PSHAB20MedianPSA','PSHAB20Tau','PSHAB20PhiTot','PSHAB20PhiS2S','PSHAB20PhiSS','PSHAB20SigmaAleatory','PSHAB20SigmaEpistemic','PSHAB20SigmaTotal','PSHAB20MedianMinusNsigmaxSigmaTotal','PSHAB20MedianPlusNsigmaxSigmaTotal','PSHAB20MedianMinusNsigmaxSigmaAleatory','PSHAB20MedianPlusNsigmaxSigmaAleatory','PSHAB20MedianMinusNsigmaxSigmaEpistemic','PSHAB20MedianPlusNsigmaxSigmaEpistemic'};
        outDataTableStudy.Properties.VariableNames =outDataTableHeader;
        inDataTable = table([CaseLabel(1,:),CaseLabel(2,:)].',[CaseLabelRegion(1,:),CaseLabelRegion(2,:)].',[Mag(1,:),Mag(2,:)].',[Vs30mps(1,:),Vs30mps(2,:)].',[Reg(1,:),Reg(2,:)].',[Rrup_km(1,:),Rrup_km(2,:)].',[alpBack(1,:),alpBack(2,:)].',[alpNank(1,:),alpNank(2,:)].',[Ztor_km(1,:),Ztor_km(2,:)].',[SeatBasn(1,:),SeatBasn(2,:)].',[Z1pt0m(1,:),Z1pt0m(2,:)].',[Z2pt5m(1,:),Z2pt5m(2,:)].',[NsplEpi(1,:),NsplEpi(2,:)].',[Mbreak(1,:),Mbreak(2,:)].',[Zhypo_km(1,:),Zhypo_km(2,:)].',[SatReg(1,:),SatReg(2,:)].',[Basin(1,:),Basin(2,:)].',[Nsigma(1,:),Nsigma(2,:)].',[InterIntra(1,:),InterIntra(2,:)].',[T_sec(1,:),T_sec(2,:)].');
        inDataTableHeader = {'CaseLabel','CaseLabelRegion','Mag','Vs30mps','Reg','Rrup_km','alpBack','alpNank','Ztor_km','SeatBasn','Z1pt0m','Z2pt5m','NsplEpi','Mbreak','Zhypo_km','SatReg','Basin','Nsigma','InterIntra','T_sec'};
        inDataTable.Properties.VariableNames =inDataTableHeader;
        AllDataTableSensitivity = [inDataTable outDataTableStudy];
        disp(AllDataTableSensitivity)
        outputFilename = 'NGAsubduction_GMMtool_Matlab_Out_SensitivityStudy.csv';
        writetable(AllDataTableSensitivity,outputFilename,'Delimiter',',','QuoteStrings',true)
        disp("Sensitivity-Study Results have been saved to " + outputFilename);
   
    end
 end


