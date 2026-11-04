# Risk and ARCR master driver

`sks_MasterDriver_RunNProcRiskandARCRCal.m` is the single entry point of the seismic risk and annualized repair cost ratio (ARCR) module. Starting from the incremental dynamic analysis (IDA) results of one building, it generates fragility data, checks intensity-measure efficiency, runs the site hazard analysis, computes the seismic risk of each damage state, and computes the expected annual repair cost.


---

## Overall process

The driver works in six stages. Each stage is switched on or off by one flag in the driver, so they can be run together or one at a time.

1. **Fragility generation** (`sks_FragilityData.m`).
   Reads the IDA results of the building and, for every ground motion, finds the intensity Sa(T1) at which each damage state is first reached. From these points it fits a lognormal fragility curve (median and dispersion beta_RTR) for each damage state and saves them as a data file.
   - MIDR path: `sks_FragilityDataGen_MIDR.m` → `extractFragilityForDifferentIM_v2.m` → `prak_util_extractFragDataPoints_v02.m` and `prak_util_ratioOfSaTnewToSaTold.m`. Damage states IO, LS, CP and dynamic instability, defined by maximum interstory drift ratio.
   - PHR path: `sks_DS1_FragParam_deltaY.m` and `sks_DS1_FragParam.m` (DS1, yield), `sks_DS2_FragParam.m`, `sks_DS2_DS3_Process_FragParam.m`, `sks_DS2_DS3_printSave_AllFragParam.m` and `sks_PlotAfterPostProc.m` (DS2 and DS3, hinge rotation), `sks_DS4_FragParam.m` (DS4, collapse), and finally `sks_FragilityDataGen_PHR.m` → `extractFragilityForDS_DayalaEtAl_v1.m`, which collects all four damage states.

2. **Intensity-measure efficiency** (`sks_IM_efficieny.m` → `sks_IM_efficieny_MIDR.m` or `sks_IM_efficiency_PHR.m`).
   Repeats the fragility fit using Sa at many periods instead of only T1, and finds for each damage state the period that gives the smallest dispersion. The geometric mean of these periods is Togm, which can be used as an alternative intensity measure.

3. **Hazard** (`runHazardDriver`, a local function of the driver → `masterDriver_PlotHazardCurvesTwoLocDiffT1.m`).
   Reads the probabilistic seismic hazard (Raghukanth 2026) for the selected location through `findHazValRaghukanth20260818_v4.m` and `extractHazForLoc_20260818_v1.m` (file `hazard_20260818.mat`), fits the hazard curve with `returnHazCurveRaghukanth20200111_v2.m`, and produces hazard curves (`sks_plotHazardCurves_v1.m`), Sa values for return periods from 75 to 9975 years, the uniform hazard spectrum (`sks_generateUHS_v1.m`) and its comparison with the IS 1893 spectrum (`sks_ISResponseSpectrum_v1.m`, `sks_UHS_ISResponse_combined_v1.m`, `sks_getZoneFactor_v1.m`). This stage produces figures and tables for reporting; the risk and ARCR stages read the hazard again by themselves.

4. **Seismic risk** (`sks_seismicRiskCal.m` → `sks_seismicRiskCal_MIDR.m` → `masterFunRiskCal_MIDR.m`).
   Loads the fragility data file from stage 1, reads the hazard curve at the same period (`findHazValRaghukanth20260818_v4.m`, `returnHazCurveRaghukanth20200111_v2.m`) and integrates the two with `computeRiskSingleSite_v3.m` to obtain lambda_DS, the mean annual frequency of exceeding each damage state. It also reports the hazard at 475 and 2475 years and the margin between the fragility median and the 2475-year hazard. For PHR, risk is computed in the ARCR stage instead.

5. **ARCR** (`sks_AnnualizedRCR_MIDR.m` for MIDR, `sks_AnnualizedRCR.m` → `masterFunLambdaARCR_v2.m` for PHR).
   Rebuilds the fragility directly from the IDA results (`extractFragilityForMIDR_v1.m` for MIDR, `extractFragilityForDS_DayalaEtAl_v1.m` for PHR), reads the hazard, recomputes lambda_DS for DS1 to DS4 with `computeRiskSingleSite_v3.m`, and combines them with the repair cost ratio of each damage state to give lambda_RCR, the expected annual repair cost as a fraction of replacement cost.

6. **RTGM.** Risk-targeted ground motion. Reserved; not implemented yet.

Figures in all stages are formatted and saved with `sks_figureFormat.m` and `sks_figureExport.m`; model and output folders are located with `returnModelFolderInfo.m`.

---

## Steps to run

**Step 1. Open the correct folder.**
Set the MATLAB current folder to `psb_risk-ARCR-Resilience\RiskAndARCR` and open `sks_MasterDriver_RunNProcRiskandARCRCal.m`. The code builds its input and output paths from the current folder, so running it from elsewhere saves files in the wrong place.

**Step 2. Select the building.**
In the building section at the top of the driver, choose the IDA output folder of the building and its building ID. The zone written next to the building ID must be the zone of the site where the risk is computed (the same zone as in the site section), not the zone the building was designed for. If the two do not match, `masterFunRiskCal_MIDR.m` finds no building and stops.

**Step 3. Select the damage measure.**
Choose MIDR- or PHR-based damage states. MIDR is the default and works with the current IDA results. PHR needs joint and hinge response files that are recorded only when the IDA is run with those recorders switched on.

**Step 4. Select the ground-motion set.**
Choose the record set used in the IDA (for example FEMA P695 far-field set C). This fixes the list of records and the set name used in output file names.

**Step 5. Choose which stages to run.**
Set the six flags (fragility, IM efficiency, hazard, risk, ARCR, RTGM) to 1 or 0. Run the fragility stage (`sks_FragilityData.m`) whenever the building or the period changes, before running the risk stage (`sks_seismicRiskCal.m`). The IM-efficiency stage (`sks_IM_efficieny.m`) needs the multi-period fragility option.

**Step 6. Define the site.**
Enter the latitude and longitude, the location name used in the hazard file (Guwahati or Delhi), and the site zone.

**Step 7. Set the hazard options.**
Choose the hazard-curve fitting model used by `returnHazCurveRaghukanth20200111_v2.m`, and whether to use the PSHA hazard (default) or a code-idealized hazard built from zone values. With the PSHA hazard, the zone label does not change the results.

**Step 8. Enter the building periods.**
Enter the fundamental period T1 (1.36 s for 46053v02, 1.56 s for 35053v02), the approximate code period Ta, and Togm from the IM-efficiency stage. Choose single-period analysis (fragility at one period) or multi-period analysis (fragility at every period, needed for IM efficiency).

**Step 9. Select the intensity measure.**
Choose PGA, Sa(Ta), Sa(T1) or Sa(Togm). Sa(T1) is the default.

**Step 10. Check the remaining settings.**
The PHR settings (yield-drift basis, rotation limits) are used only by the PHR functions. The uncertainty values (design requirements, modelling and test data) are combined with the record-to-record dispersion to give the total dispersion of each fragility curve. Plot settings control the figure style and how much is printed.

**Step 11. Run the driver.**
When the hazard stage starts, `runHazardDriver` opens `masterDriver_PlotHazardCurvesTwoLocDiffT1.m` in the editor with a message box. Check its inputs (especially the conditioning period, which must equal T1, and the location), save it, and click OK. The run then continues through the remaining stages and prints the total run time.

---

## Outputs

- **Fragility stage** (`sks_FragilityDataGen_MIDR.m`): a fragility data file for the building in `DATA_files`.
- **IM-efficiency stage** (`sks_IM_efficieny_MIDR.m`): a table of the optimal period, median and dispersion for each damage state, the value of Togm, and figures in `Output_Risk\IM_efficiency_figures`.
- **Hazard stage** (`masterDriver_PlotHazardCurvesTwoLocDiffT1.m`): Sa values for the listed return periods in the Command Window, and hazard figures in the hazard folder.
- **Risk stage** (`masterFunRiskCal_MIDR.m`): a table with, for each damage state, the fragility median, the 475- and 2475-year hazard, the margin, and lambda_DS.
- **ARCR stage** (`sks_AnnualizedRCR_MIDR.m`): a table with lambda_DS1 to lambda_DS4 and lambda_RCR, a fragility data file named after the building and ground-motion set (saved by `extractFragilityForMIDR_v1.m`), and hazard, fragility and repair-cost figures in `Output_Risk`.

The return period of a damage state is 1/lambda_DS, and its probability of occurrence in 50 years is 1 − exp(−50 × lambda_DS).

---

## When switching to the other building

Change the IDA output folder, the building ID, and T1 in the driver; change the conditioning period in `masterDriver_PlotHazardCurvesTwoLocDiffT1.m` to the same T1; then run the fragility stage again before the risk stage.
