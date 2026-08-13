% function fun_correctTimeHistoryForNonZeroBeginning(eqLIST)

clear; baseFolder = pwd;

% eqNumberLIST_forProc_SetNBCC2020_Sca_1p5 = [90011	90012	90021	90022	90031	90032	90041	90042	90051	90052	90061	90062	90071	90072	90081	90082	90091	90092	90101	90102	90111	90112	90121	90122	90131	90132	90141	90142	90151	90152	90161	90162	90171	90172	90181	90182	90191	90192	90201	90202	90211	90212	90221	90222	90231	90232	90241	90242	90251	90252	90261	90262	90271	90272	90281	90282	90291	90292	90301	90302	90311	90312	90321	90322	90331	90332	90341	90342	90351	90352	90361	90362	90371	90372	90381	90382	90391	90392	90401	90402];
eqNumberLIST_forProc_SetNBCC2020_Sca_1p6 = [160011	160012	160021	160022	160031	160032	160041	160042	160051	160052	160061	160062	160071	160072	160081	160082	160091	160092	160101	160102	160111	160112	160121	160122	160131	160132	160141	160142	160151	160152	160161	160162	160171	160172	160181	160182	160191	160192	160201	160202	160211	160212	160221	160222	160231	160232	160241	160242	160251	160252	160261	160262	160271	160272	160281	160282	160291	160292	160301	160302];

eqLIST = eqNumberLIST_forProc_SetNBCC2020_Sca_1p6;
numEq = size(eqLIST, 2);
count = 0;
for eqFileIndex = 1:numEq%length(eqNumberLIST)
    cd C:\OpenSeesProcessingFiles\EQs
    
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
        fun_saveResSpecStandalone(eqNumber, TH, dt);
        cd ('CorrectedTH_And_RespSpec');
        writematrix(TH, sprintf('SortedEQFile_(%i).txt', eqNumber));
        cd ..
    end
end
T = table(PGA_vals, accn1st5sMeanVal, aa1st5sToPGA_ratioVal, accn1st5sMeanVal, accn1st5sMaxVal, accn1st5sMinVal, accn1st5sRangeByMean);
fprintf('%i/%i ground motion records corrected. \n', count, numEq);
cd(baseFolder);
