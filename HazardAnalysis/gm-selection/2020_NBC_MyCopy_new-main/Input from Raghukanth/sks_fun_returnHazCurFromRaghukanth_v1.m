function [imVals, afeVals, poeVals50y] = sks_fun_returnHazCurFromRaghukanth_v1(latLon, T1, fitModel, N)
%% Returns a hazard curve (imVals, afeVals, poeVals50y) at a given (lat, lon) and
%  period T1, built from Raghukanth's gridded hazard data (hazard_20200111.mat),
%  in the SAME output format as fun_returnHazCurFromPSHAFiles_v2 (the OpenQuake reader).
%
%  This lets Raghukanth-based hazard curves be used as a drop-in replacement
%  anywhere the OpenQuake hazard-curve reader was being used (e.g. as the
%  "saT1Tr = interp1(poeVals50y, imVals, poeT)" step in fun_deagg_v2), for
%  everything EXCEPT actual M-R-epsilon deaggregation, which needs source-level
%  data.

narginchk(2, 4)
switch nargin
    case 2
        fitModel = '3param'; N = 21;
    case 3
        N = 21;
end

doPlot = 0; plotType = 'loglog'; locationLIST = {}; imTypeForPlot = 'Sa_T1'; legendName = {};

%% Step 1: get the sparse (10-point) AFE-vs-Sa curve at period T1, at this location

[imValLIST, afe_Sa_T1_LIST] = findHazValRaghukanth20200111_v4(latLon, doPlot, plotType, locationLIST, T1);

%% Step 2: densify/fit the sparse curve into a smooth numerical hazard curve
[imValDisc, afeDisc, ~] = returnHazCurveRaghukanth20200111_v2(fitModel, imValLIST, afe_Sa_T1_LIST, N, doPlot, plotType, imTypeForPlot, legendName);

%% Step 3: package outputs to match fun_returnHazCurFromPSHAFiles_v2's interface
imVals  = imValDisc;
afeVals = afeDisc;
poeVals50y = 1 - exp(-afeVals*50); % standard Poisson AFE -> 50-yr POE conversion

end
