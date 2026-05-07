
function sks_FragilityData(MIDR_or_PHR, MIDRInputs, PHRInputs, runFlags)

% extract flags
runDS1  = runFlags.runDS1;
runDS23 = runFlags.runDS23;
runDS4  = runFlags.runDS4;
runFrag = runFlags.runFrag;

if strcmp(MIDR_or_PHR, 'MIDR')
    sks_FragilityDataGen_MIDR(MIDRInputs);
elseif strcmp(MIDR_or_PHR, 'PHR')

    % Backup only if any preprocessing will run
    if runDS1 || runDS23 || runDS4
        PHRInputs_backup = PHRInputs;
    end

    %% ----Run DS1 ----
    if runDS1 == 1
        sks_DS1_FragParam_deltaY(PHRInputs);
        sks_DS1_FragParam(PHRInputs)
    end

    %% ---- Run DS2 & DS3 ----
    if runDS23 == 1
        sks_DS2_FragParam(PHRInputs);
        sks_DS2_DS3_Process_FragParam(PHRInputs);
        sks_DS2_DS3_printSave_AllFragParam(PHRInputs);
        sks_PlotAfterPostProc(PHRInputs);
    end

    %% ----Run DS4 ----
    if runDS4 == 1
        sks_DS4_FragParam(PHRInputs);
    end

    %% ---- Restore before fragility ----
    if (runDS1 || runDS23 || runDS4) && runFrag
        PHRInputs = PHRInputs_backup;
    end

    %% ---- Fragility ----
    if runFrag == 1
        sks_FragilityDataGen_PHR(PHRInputs);
    end

end



