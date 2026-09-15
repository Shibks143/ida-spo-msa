#----------------------------------------------------------------------------------#
# RunCollapseAnalysisIfSpecifiedSENSITIVITY.tcl
#	This runs the collapse analysis to find the Sa at collapse.  This must be used with a degrading model that is robust
#	with respect to convergence, as the algorithm does not terminate until the drifts have reached a particular 
#	level (usually 100% drift, defined in SetAnalysisOptions).  This is the same as the non-sensitivity version, but
#	it alteres the sensitivity variable before running the analysis.
#
# Units: N, mm
#----------------------------------------------------------------------------------#
	puts "Running the single record for the collapse analysis, with Matlab as driver..."

	# Set the dt to use from the input for collapse
	set dtForAnalysis [expr $dtForCollapseMATLAB]

			set start [clock seconds]

			source psb_RedefineEverythingAndReSetUpModelColSENSITIVITYMATLAB.tcl

			# Define recorders
			# Included by Shivakumar K S on 31st jan 2026
			set saTOneForRun [format "%.2f" $currentSaLevel]
			# set saTOneForRun [expr $currentSaLevel];	# Define this for the recorders to define correctly
			
puts "saTOneForRun is $saTOneForRun"
			cd ..; # this command is required for time-history but not for the pushover analysis, hence squeezing it in here. Rather than putting it in psb_DefineAllRecorders.tcl file
			source psb_DefineAllRecorders.tcl

			# Run analysis at the current Sa level
				# First initialize the variables that are returned from the analysis (using the upvar command)
				# 	***These variables are RETURNED from the function using UPVAR
				set isCollapsed 			               0;			# Not yet collapsed
				set isSingular 				               0;			# Not yet singular
				set isNonConv				               0;			# Not non-conv yet
				set maxStoryDriftRatioForFullStr 	       0;			# No drift yet
				set minStoryDriftRatioForFullStr 	       0;			# No drift yet
				set maxStoryResidualDriftRatioForFullStr   0;           # Initialize residual interstory drift ratio (post-earthquake state, evaluated after extra analysis duration); added 28-Feb-2026
                set minStoryResidualDriftRatioForFullStr   0;           # Initialize residual interstory drift ratio (post-earthquake state, evaluated after extra analysis duration); added 28-Feb-2026   
			    set absStoryResidualDriftRatioForFullStr   0;           # Initialize residual interstory drift ratio (post-earthquake state, evaluated after extra analysis duration); added 28-Feb-2026
			

			#############################################################################################################################################
			# Call the function to run the analysis
			# Note that the minStoryDriftRatioForCollapse is input to this function from the MATLAB input instead of from the SetAnalysisOptions.tcl!!!
			##############################################################################################################################################
			RunEQLoadingForCollapse \
    $eqNumber $currentSaLevel $scaleFactorForRunFromMatlab \
    $saCompScaled $saGeoMeanScaled $dtForAnalysis $g \
    $testType $allowNormDisplIncrForConv $analysisType \
    $EQsolutionAlgorithm $iterAlgo $iterAlgoArg \
    $nodeNumsAtEachFloorLIST $minStoryDriftRatioForCollapseMATLAB \
    $useINDAsCollapse $eqFormatForCollapseList $floorHeightsLIST \
    isCollapsed isSingular isNonConv \
    maxStoryDriftRatioForFullStr minStoryDriftRatioForFullStr \
    maxStoryResidualDriftRatioForFullStr minStoryResidualDriftRatioForFullStr \
    absStoryResidualDriftRatioForFullStr \
    maxStoryDriftRatioAtEachStoryAtEachRun \
    minStoryDriftRatioAtEachStoryAtEachRun \
    absStoryDriftRatioAtEachStoryAtEachRun \
    maxStoryResidualDriftRatioAtEachStoryAtEachRun \
    minStoryResidualDriftRatioAtEachStoryAtEachRun \
    absStoryResidualDriftRatioAtEachStoryAtEachRun \
    maxPeakFloorAccelerationAtEachFloorAtEachRun \
    minPeakFloorAccelerationAtEachFloorAtEachRun \
    absPeakFloorAccelerationAtEachFloorAtEachRun \
    $constraintForEQ $constraintArg1EQ $constraintArg2EQ \
    $extraSecondsToRunAnalysis $eqTimeHistoryPreFormatted
	
			# RunEQLoadingForCollapse $eqNumber $currentSaLevel $scaleFactorForRunFromMatlab $saCompScaled $saGeoMeanScaled $dtForAnalysis $g $testType $allowNormDisplIncrForConv $analysisType $EQsolutionAlgorithm $iterAlgo $iterAlgoArg $nodeNumsAtEachFloorLIST  $minStoryDriftRatioForCollapseMATLAB $useINDAsCollapse $eqFormatForCollapseList $floorHeightsLIST $isCollapsed $isSingular $isNonConv $maxStoryDriftRatioForFullStr $minStoryDriftRatioForFullStr $maxStoryResidualDriftRatioForFullStr $minStoryResidualDriftRatioForFullStr $absStoryResidualDriftRatioForFullStr $maxStoryDriftRatioAtEachStoryAtEachRun $minStoryDriftRatioAtEachStoryAtEachRun $absStoryDriftRatioAtEachStoryAtEachRun $maxStoryResidualDriftRatioAtEachStoryAtEachRun $minStoryResidualDriftRatioAtEachStoryAtEachRun $absStoryResidualDriftRatioAtEachStoryAtEachRun $maxPeakFloorAccelerationAtEachStoryAtEachRun $minPeakFloorAccelerationAtEachStoryAtEachRun $absPeakFloorAccelerationAtEachStoryAtEachRun $constraintForEQ $constraintArg1EQ $constraintArg2EQ $extraSecondsToRunAnalysis $eqTimeHistoryPreFormatted; # (4-16-16, PSB) Removed alpha1 and alpha2 from input
			# Updated on 6-29-06 so now the scaling is done in Matlab
	
			# EQ done now!
			# Output time that it took for the analysis
			set finish [clock seconds]
			set minutesToRunThisAnalysis [expr ($finish-$start)/60.0]
			puts "Time Duration for analysis of EQ $eqNumber at Sa of $saTOneForRun: $minutesToRunThisAnalysis minutes"

			# Print some information about this specific run to the folder for this run - we need this to be in the 
			#	output directory, so go to that directory, put the files there, then come back to this directory.
		
			source psb_DefineEarthquakeRecordInformation.tcl;	# I am not sure that we even need to source this here anymore
			# This is the same as the normal file for non-collapse, but also saves the collapse status
			source psb_SaveRunInformationAfterEQForCollapse.tcl

			# Wrap up and end this run
			remove recorders
			wipe all
			puts "Wiped"

