# Resilience module: scenario-based housing recovery

`sks_MasterDriver_ScenarioBasedHousingRecAndRes.m` is the single entry point of the resilience module. For a scenario earthquake of given magnitude M and distance Rjb, it estimates how the housing capacity of each building drops right after the earthquake and how it recovers with time, and from this recovery curve computes robustness, rapidity, resilience and the days needed to reach different recovery targets. It also computes the mean repair time as a function of Sa(T1).

The framework follows Burton et al. (2015), J. Struct. Eng.

Authors: Prof. Prakash S. Badal and Shivakumar K S, IIT Madras.
Units: Sa in g, time in days, rapidity in year^-1.

---

## Overall process

The driver loops over the buildings listed in it. For each building it runs the steps below, and after the loop it draws the figures that compare all buildings. Two flags in the driver control the work: **Resilience** (steps 1 to 5 and 7) and **meanRepTime** (steps 6 and 8). The building information and fragility step runs for every building whichever flag is on.

1. **Building information.**
   For each building the driver selects the IDA output folder, the number of stories and Sa_MCE (the 2475-year Sa(T1) from the PSHA). From the IDA results it reads the ground-motion set name, the list of records and the period T1 used to scale the records, so T1 is not typed by hand.

2. **Scenario intensity, Sa(T1)** (`BA_2008_nga.m`, `BSSA_2014_nga.m`; Resilience flag).
   The ground-motion models of Boore and Atkinson (2008) and Boore et al. (2014) give the median and the logarithmic standard deviation of Sa(T1) for the scenario (M, Rjb, fault type, Vs30). The model chosen in the driver (BSSA14 by default) is used to generate 10,000 random values of Sa(T1) with a fixed random seed, so that the results are repeatable.

3. **Fragility** (`extractFragilityForMIDR_v1.m`, from the RiskAndARCR folder).
   Fragility curves (median and record-to-record dispersion beta_RTR) are obtained for each damage state from the IDA results, using maximum interstory drift ratio limits. If a fragility saved earlier is newer than the IDA results, it is reused instead of being recomputed. The driver then adds the modelling, design-requirement and test-data uncertainties (beta_MDL, beta_DR, beta_TD) to beta_RTR to give beta_TOT, and prints the medians (as a ratio of Sa_MCE), beta_RTR and beta_TOT.

4. **Expected recovery function** (`fun3expctedRecovery_v1.m` → `fun2housingCapacity_v1.m`; Resilience flag).
   `fun2housingCapacity_v1.m` builds, for each damage state, the recovery of housing capacity with time from the durations of the recovery activities (inspection, assessment, mobilization, occupancy and functionality restoration, repair or replacement). These lead times are lognormal and are sampled by Monte Carlo; the replacement time depends on the number of stories. `fun3expctedRecovery_v1.m` weights these curves by the probability of each damage state at every Sa(T1) value from step 2, giving the expected recovery function Q(t) for each value and their mean over all values.

5. **Robustness, rapidity and resilience** (`sks_ComputeRobRapRes.m`; Resilience flag).
   From the mean recovery curve it computes the robustness (housing capacity right after the earthquake), the number of days to reach each recovery target (for example 75 % to 99 %), and the rapidity and resilience at each control time (for example 30, 180, 365, 545 and 730 days). Resilience is the normalized area under Q(t) up to the control time. The results are printed and saved with the recovery curves in the output folder of the scenario.

6. **Mean repair time** (`fun4meanRepTime_v1.m`; meanRepTime flag).
   On a fixed grid of Sa(T1) values (0.01 to 2.0 g), it computes the mean repair time and its dispersion, where repair time includes functionality and occupancy restoration and repair or replacement. The results are saved for each building.

7. **Resilience figures** (`sks_plotResilience.m` for each building, `sks_plotResilienceCombined.m` after the loop; Resilience flag).
   `sks_plotResilience.m` draws, for one building, the fragility curves (using `PlotLogNormalCDF_current.m`), the damage-state probabilities, resilience against Sa, and the recovery curves. `sks_plotResilienceCombined.m` draws the figures that compare all buildings: the recovery curves, their uncertainty, the combined fragility figure and the histogram of the scenario Sa(T1) values, and prints a table of T1, medians and beta_RTR.

8. **Mean repair time figures** (`sks_plotMeanRepairTime.m`, after the loop; meanRepTime flag).
   Reads the mean repair time of every building saved in step 6 and plots the mean repair time and its dispersion against Sa(T1)/Sa_MCE.

All figures are formatted and saved with `sks_figureFormat.m` and `sks_figureExport.m` (psb_MatlabProcessors folder).

---

## Steps to run

**Step 1. Open the correct folder.**
Set the MATLAB current folder to `psb_risk-ARCR-Resilience\Resilience` and open `sks_MasterDriver_ScenarioBasedHousingRecAndRes.m`. The driver builds its paths from the current folder. The fragility function is in the RiskAndARCR folder, the ground-motion models are in `HazardAnalysis\gm-selection\GMPE`, and the figure functions are in psb_MatlabProcessors; these folders must be on the MATLAB path.

**Step 2. List the buildings.**
In the first input block, list the building IDs to analyse (for example 46053v02 and 35053v02). Each ID must have a matching entry in the building section inside the loop, which gives its IDA output folder, number of stories and Sa_MCE (0.80 g for 46053v02, 0.68 g for 35053v02). To add a new building, add a new entry there.

**Step 3. Define the scenario earthquake.**
In the scenario block, enter the magnitude M, the Joyner-Boore distance Rjb, the number of Sa(T1) realizations, the random seed, the ground-motion model (BA08 or BSSA14), Vs30, and the fault type, region and basin depth required by each model.

**Step 4. Set the fragility options.**
In the fragility block, enter the interstory drift limits that define the damage states (the last value, 0, stands for collapse) and the three additional uncertainties beta_MDL, beta_DR and beta_TD. If the drift limits or the IDA results change, delete the saved fragility of that building so that it is recomputed.

**Step 5. Set the resilience options.**
In the resilience block, enter the recovery targets in percent, the maximum housing capacity (1 for normalized results) and the control times in days at which rapidity and resilience are reported.

**Step 6. Set the plot and save options.**
Choose whether to print results, save figures and show legends, the colours, and whether the mean repair time is plotted with 16 % and 84 % bounds (single building only). The output folder for figures is named after the scenario (M and Rjb) and is created inside `Output_Res` if it does not exist.

**Step 7. Choose what to run.**
Set the two flags, Resilience and meanRepTime, to 1 or 0. With only meanRepTime on, the scenario Sa(T1) values and the recovery curves are not computed.

**Step 8. Run the driver.**
For each building the Command Window shows the ground-motion set, the number of records and T1, the fragility table, the robustness, the days to reach each recovery target, and the rapidity and resilience at each control time. When all buildings are done, the combined figures and the mean repair time figures are drawn, and the driver returns to the Resilience folder.

---

## Outputs

- **Command Window:** for each building, the fragility medians (as a ratio of Sa_MCE), beta_RTR and beta_TOT; robustness; days to reach each recovery target; rapidity and resilience at each control time. After the loop, a table of T1, medians and beta_RTR of all buildings.
- **Scenario folder** `Output_Res\figures_resCombined_M<M>_R<Rjb>_R2_RESUnc`: per-building figures from `sks_plotResilience.m` (fragility, damage-state probabilities, resilience against Sa, recovery curves), combined figures from `sks_plotResilienceCombined.m` (recovery curves, their uncertainty, combined fragility, histogram of Sa), and the saved recovery results of each building.
- **Mean repair time folder** `Output_Res\figures_repTimeVsSa_R1_betaTOT`: the mean repair time results of each building from `fun4meanRepTime_v1.m`, and the figures of mean repair time and its dispersion against Sa(T1)/Sa_MCE from `sks_plotMeanRepairTime.m`.

---

## When adding or changing a building

Add or edit its entry in the building section inside the loop (IDA output folder, number of stories, Sa_MCE), add its ID to the building list, and make sure its IDA results exist. If the IDA was rerun, delete its saved fragility so that `extractFragilityForMIDR_v1.m` recomputes it.
