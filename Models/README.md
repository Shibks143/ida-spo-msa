## 3. Creating a new model from this one (e.g. ID46053 → ID46123)

Use ID46053 as the template. Only 4 files change from model to model; the other 18 are copied as-is.

### 3.1 Files to replace or edit for each model

| # | File | What to change |
|---|------|----------------|
| 1 | `psb_ModelCodePastedFromExcelVBA.tcl` | Replace the whole file with the new building's Excel/VBA output (`Models/VBA_MODEL_FILES/`). |
| 2 | `psb_DefinePushoverLoading.tcl` | Replace the `load <node> <Fx> 0.0 0.0` lines inside `pattern Plain 13 Linear { }` with the new building's lateral load pattern from the same Excel sheet. |
| 3 | `psb_SetAnalysisOptions.tcl` | Line 26: `set model <FolderName>` (must equal the folder name exactly).<br>Line 63: `set maxPushoverDisp <value>`. |
| 4 | `psb_DefineVariablesAtMeanValues.tcl` | Line 54: `set periodForRayleighDamping_1 <T1>` (mode-1 period from eigen analysis after SPO: MatlabInformation\eigenvaluesOUT.out. Each value is ω², so T = 2π / √value.).<br>Line 55: `set periodForRayleighDamping_2 <T3>` (mode-3 period from eigen analysis after SPO: MatlabInformation\eigenvaluesOUT.out. Each value is ω², so T = 2π / √value). |

### 3.2 Unchanged files (copy from ID46053 as-is)

1. `psb_DefineAllRecorders.tcl`
2. `psb_DefineEarthquakeRecordInformation.tcl`
3. `psb_DefineFunctionsAndProcedures.tcl`
4. `psb_DefineUnitsAndConstants.tcl`
5. `psb_PeformGravityLoadAnalysis.tcl`
6. `psb_RedefineEverythingAndReSetUpModel.tcl`
7. `psb_RedefineEverythingAndReSetUpModelColSENSITIVITYMATLAB.tcl`
8. `psb_RunCyclicPushoverIfSpecified.tcl`
9. `psb_RunCyclicPushoverLoading.tcl`
10. `psb_RunMeanAnalysis.tcl`
11. `psb_RunPushoverIfSpecified.tcl`
12. `psb_RunPushoverLoading.tcl`
13. `psb_RunSingleColRecordSensMATLAB.tcl`
14. `psb_SaveRunInformationAfterEQ.tcl`
15. `psb_SaveRunInformationAfterEQForCollapse.tcl`
16. `psb_SetUpModel.tcl`
17. `psb_SolutionAlgorithmSubFile.tcl`
18. `psb_WriteNeededInformationToFilesForMatlab.tcl`

### 3.3 Step-by-step checklist

1. Copy the 22 `psb_*.tcl` files and this README from ID46053 to the new folder (not the `model_*` folders).
2. Replace `psb_ModelCodePastedFromExcelVBA.tcl` (§3.1 #1).
3. Replace the load lines in `psb_DefinePushoverLoading.tcl` (§3.1 #2).
4. Edit `set model` and `maxPushoverDisp` in `psb_SetAnalysisOptions.tcl` (§3.1 #3).
5. Edit `periodForRayleighDamping_1/2` in `psb_DefineVariablesAtMeanValues.tcl` (§3.1 #4).
6. Update the MATLAB driver(s) in the repository root (see §4).
7. Run SPO first as a sanity check. Then run IDA/MSA.