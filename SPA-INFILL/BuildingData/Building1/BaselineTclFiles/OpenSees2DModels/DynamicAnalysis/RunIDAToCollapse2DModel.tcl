##############################################################################################################################
# RunIDAToCollapse															                             		             #
#	This module runs incremental dynamic analyses for a given model for a specified number of ground motions to collapse     #
# 														             														 #
# 	Created by: Henry Burton, Stanford University, October 7, 2012									                         #
#								     						                                                                 #
# Units: kips, inches, seconds                                                                                               #
##############################################################################################################################

wipe all;	# Clears memory

# Define model properties
set NStories *nStories*

# Source procedures used to check for collapse
source ExtractMaxDrift2DModel.tcl

set baseDir [pwd];					# sets base directory as current directory 
set dataDir Model
append dataDir CollapseOutput;

# Define the periods to use for the Rayleigh damping calculations
set periodForRayleighDamping_1 *firstModePeriod*;	# Mode 1 period - NEEDS to be UPDATED
set periodForRayleighDamping_2 *thirdModePeriod*;	# Mode 3 period - NEEDS to be UPDATED

# Creating Output Directory
file mkdir $dataDir;

# Initializing processor information
set np [getNP]; # Getting the number of processors
set pid [getPID]; # Getting the processor ID number

# Setting up vector of ground motion ids
set groundMotionIDs {}; 
set numberOfGroundMotionIDs *NumberOfGroundMotions*; 
for {set gm 1} {$gm <= $numberOfGroundMotionIDs} {incr gm} {
	lappend groundMotionIDs $gm
}
puts "Ground motion ID's defined"

# Setting up vector with number of steps per ground motion
set groundMotionNumPoints {}; 
set pathToTextFile $baseDir/GroundMotionInfo;
set groundMotionNumPointsFile [open $pathToTextFile/GMNumPoints.txt r];
while {[gets $groundMotionNumPointsFile line] >= 0} {
	lappend groundMotionNumPoints $line;
}
close $groundMotionNumPointsFile;
puts "Ground motion number of steps defined"
	
# Setting up vector with size of time step for each ground motion
set groundMotionTimeStep {}; 
set groundMotionTimeStepFile [open $pathToTextFile/GMTimeSteps.txt r];
while {[gets $groundMotionTimeStepFile line] >= 0} {
	lappend groundMotionTimeStep $line;
}
close $groundMotionTimeStepFile;
puts "Ground motion time steps defined"

# Initial increment for ground motion scales
set initialGroundMotionScaleIncrement *InitialGroundMotionIncrementScaleForCollapse*;
set reducedGroundMotionScaleIncrement *ReducedGroundMotionIncrementScaleForCollapse*;

# Define response parameter limits used to check for collapse
# Drift Limit For Collapse
set collapseDriftLimit *CollapseDriftLimit*;

# Scale factor needed to anchor median ground motion ste to MCE level
set MCE_SF *MCEScaleFactor*;

set IDAStartT [clock seconds]


# Create folders used to store output
cd $dataDir
file mkdir IDAMaxDrifts
file mkdir IDAGMScales

# Looping over alll ground motions
foreach groundMotionNumber $groundMotionIDs {
	if {[expr {$groundMotionNumber % $np}] == $pid} {
		# Initialize response parameters used to check for collapse
		set maximumStoryDrift 0.0;	
		
		# Define ground motion parameters
		set currentGrounMotionScale $initialGroundMotionScaleIncrement;
		set dt [lindex $groundMotionTimeStep [expr $groundMotionNumber - 1]];
		set eqNumber $groundMotionNumber;
		set numPoints [lindex $groundMotionNumPoints [expr $groundMotionNumber - 1]];
		puts "Ground parameters defined"
		
		# Initialize vectors used to store relevant response parameters
		set listOfScalesRun {};
		set listOfMaximumStoryDrifts {};
		
		# Update vectors used to store relevant response parameters
		lappend listOfMaximumStoryDrifts $maximumStoryDrift;	
		lappend listOfScalesRun 0.0;	
		
		# Run IDA until collapse response parameter limit is exceeded
		while {$maximumStoryDrift <  $collapseDriftLimit} {
			# Define current scale to run		
			set scale $currentGrounMotionScale;
			# Sourcing model to run		
			cd $baseDir
			source Model.tcl
			wipe;
			# Defining path to output data for current model
			set pathToOutputFile $baseDir/$dataDir/EQ_$eqNumber/Scale_[format "%i" $scale]
			
			# Extracting maximum story drift
			ExtractMaxDrift2DModel $NStories $pathToOutputFile	
			
			# Updating vectors used to store relevant response parameters
			if {$maximumStoryDrift <  $collapseDriftLimit} {
				lappend listOfMaximumStoryDrifts $maximumStoryDrift;	
				lappend listOfScalesRun $scale;				
			}
			incr currentGrounMotionScale $initialGroundMotionScaleIncrement;
		}
		
		# Reduce ground motion scale to obtain refined estimate of collapse scale
		set currentGrounMotionScale [expr $currentGrounMotionScale - 2*$initialGroundMotionScaleIncrement + $reducedGroundMotionScaleIncrement]
		
		# Initialize response parameters used to check for collapse
		set maximumStoryDrift 0.0;	
		
		# Run IDA until collapse drift limit is exceeded
		while {$maximumStoryDrift <  $collapseDriftLimit} {
			# Define current scale to run		
			set scale $currentGrounMotionScale;
			# Sourcing model to run		
			source Define_GM_Record_Info.tcl
			cd $baseDir
			source Model.tcl
			wipe;
			# Defining path to output data for current model
			set pathToOutputFile $baseDir/$dataDir/EQ_$eqNumber/Scale_[format "%i" $scale]
			
			# Extracting maximum story drift
			ExtractMaxDrift2DModel $NStories $pathToOutputFile
			
			# Updating vectors used to store relevant response parameters
			lappend listOfMaximumStoryDrifts $maximumStoryDrift;	
			lappend listOfScalesRun $scale;				
			incr currentGrounMotionScale $reducedGroundMotionScaleIncrement;
		}		
		
		# Create output text file consisting of maximum story drifts
		set maxDriftsFile "$dataDir/IDAMaxDrifts/EQ_$eqNumber.txt"
		set MaxDrifts [open $maxDriftsFile "w"]
		foreach maxDrift $listOfMaximumStoryDrifts {
			puts $MaxDrifts "$maxDrift"
		}
		close $MaxDrifts

		# Create output text file consisting of ground motion scales
		set idaScalesFile "$dataDir/IDAGMScales/EQ_$eqNumber.txt"
		set IDAScales [open $idaScalesFile "w"]
		foreach gmScale $listOfScalesRun {
			puts $IDAScales "$gmScale"
		}
		close $IDAScales
		
		# Delete unwanted folders
		cd $baseDir/$dataDir
		file delete -force EQ_$eqNumber
		cd $baseDir
	}
}

set IDAEndT [clock seconds];
set IDARunTime [expr ($IDAEndT - $IDAStartT)/3600];
puts "Run Time = $IDARunTime Hours"
