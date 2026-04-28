
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

    %% ---- DS1 ----
    if runDS1 == 1
        script_DS1_FragParam_deltaY;
        masterScript_DS1_FragParam_v1;
    end

    %% ---- DS2 & DS3 ----
    if runDS23 == 1
        script_fun0_DS2_FragParam_v1_obsolete;
        masterScript_DS2_DS3_process_FragParam_v3;
        masterScript2_DS2_DS3_printSave_AllFragParam;
        tempPlotAfterPostProc;
    end

    %% ---- DS4 ----
    if runDS4 == 1
        masterScript_DS4_FragParam_v1;
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



