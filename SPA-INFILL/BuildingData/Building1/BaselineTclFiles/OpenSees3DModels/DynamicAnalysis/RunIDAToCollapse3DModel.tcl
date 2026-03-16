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
set numColumnsPerStory *nColumns*

# Source procedures used to check for collapse
source ExtractBiDirectionalMaxDrift3DModel.tcl

set baseDir [pwd];					# sets base directory as current directory 
set dataDir Model
append dataDir BiDirectionalIDAToCollapseOutput;

# Define the periods to use for the Rayleigh damping calculations
set periodForRayleighDamping_1 *firstModePeriod*;	# Mode 1 period - NEEDS to be UPDATED
set periodForRayleighDamping_2 *thirdModePeriod*;	# Mode 3 period - NEEDS to be UPDATED

# Creating Output Directory
file mkdir $dataDir;

# Initializing processor information
set np [getNP]; # Getting the number of processors
set pid [getPID]; # Getting the processor ID number

# Setting up vector of ground motion ids
set groundMotionXIDs {}; 
set numberOfGroundMotionXIDs *NumberOfGroundMotions*; 
for {set gm 2} {$gm <= [expr 2*$numberOfGroundMotionXIDs]} {incr gm 2} {
	lappend groundMotionXIDs $gm
}

set groundMotionZIDs {}; 
set numberOfGroundMotionZIDs *NumberOfGroundMotions*; 
for {set gm 1} {$gm <= [expr 2*$numberOfGroundMotionZIDs]} {incr gm 2} {
	lappend groundMotionZIDs $gm
}

set RunIDs {}; 
set numberOfRunIDs *NumberOfGroundMotions*; 
for {set gm 1} {$gm <= $numberOfRunIDs} {incr gm} {
	lappend RunIDs $gm
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

# Setting up vector with MCE scale factor for each ground motion pair
set MCEScaleFactors {}; 
set MCEScaleFactorsFile [open $pathToTextFile/BiDirectionMCEScaleFactors.txt r];
while {[gets $MCEScaleFactorsFile line] >= 0} {
	lappend MCEScaleFactors $line;
}
close $MCEScaleFactorsFile;
puts "MCE Scale Factors defined"

# Initial increment for ground motion scales
set initialGroundMotionScaleIncrement *InitialGroundMotionIncrementScaleForCollapse*;
set reducedGroundMotionScaleIncrement *ReducedGroundMotionIncrementScaleForCollapse*;

# Define response parameter limits used to check for collapse
# Drift Limit For Collapse
set collapseDriftLimit *CollapseDriftLimit*;

set IDAStartT [clock seconds]


# Create folders used to store output
cd $dataDir
file mkdir IDAMaxXDrifts
file mkdir IDAMaxZDrifts
file mkdir IDAGMScales


cd $baseDir

# Looping over alll ground motions
foreach runNumber $RunIDs {
	if {[expr {$runNumber % $np}] == $pid} {
		set maximumXStoryDrift 0.0;	
		set maximumZStoryDrift 0.0;	
		
		# Define ground motion parameters
		set groundMotionXNumber [lindex $groundMotionXIDs [expr $runNumber - 1]];
		set groundMotionZNumber [lindex $groundMotionZIDs [expr $runNumber - 1]];
		set currentGrounMotionScale $initialGroundMotionScaleIncrement;
		set dt [lindex $groundMotionTimeStep [expr $groundMotionZNumber - 1]];
		set eqXNumber $groundMotionXNumber;
		set eqZNumber $groundMotionZNumber;
		set eqNumber $runNumber;
		set numPoints [lindex $groundMotionNumPoints [expr $groundMotionZNumber - 1]];
		set MCE_SF [lindex $MCEScaleFactors [expr $runNumber - 1]];
		puts "Ground parameters defined"
		
		# Intialize vectors used to store relevant response parameters
		set listOfScalesRun {};
		set listOfMaximumXStoryDrifts {};
		set listOfMaximumZStoryDrifts {};
		
		# Update vectors used to store relevant response parameters
		lappend listOfMaximumXStoryDrifts $maximumXStoryDrift;	
		lappend listOfMaximumZStoryDrifts $maximumZStoryDrift;
		lappend listOfScalesRun 0.0;	
		
		# Run IDA until collapse response parameter limit is exceeded
		while {$maximumZStoryDrift <  $collapseDriftLimit && $maximumXStoryDrift <  $collapseDriftLimit} {
			# Define current scale to run		
			set scale $currentGrounMotionScale;
			# Sourcing model to run		
			source Model.tcl
			wipe;
			# Defining path to output data for current model
			set pathToOutputFile $baseDir/$dataDir/EQ_$eqNumber/Scale_[format "%i" $scale]
			
			# Extracting global EDPs
			# Extracting maximum story drift
			ExtractBiDirectionalMaxDrift3DModel $NStories $numColumnsPerStory $pathToOutputFile	
			
			# Updating vectors used to store relevant response parameters
			if {$maximumZStoryDrift <  $collapseDriftLimit && $maximumXStoryDrift <  $collapseDriftLimit} {
				lappend listOfScalesRun $scale;	
				lappend listOfMaximumXStoryDrifts $maximumXStoryDrift;
				lappend listOfMaximumZStoryDrifts $maximumZStoryDrift;			
			}
			incr currentGrounMotionScale $initialGroundMotionScaleIncrement;
		}
		
		# Reduce ground motion scale to obtain refined estimate of collapse scale
		set currentGrounMotionScale [expr $currentGrounMotionScale - 2*$initialGroundMotionScaleIncrement + $reducedGroundMotionScaleIncrement]
		
		# Initialize response parameters used to check for collapse
		set maximumXStoryDrift 0.0;	
		set maximumZStoryDrift 0.0;	
		
		# Run IDA until collapse drift limit is exceeded
		while {$maximumZStoryDrift <  $collapseDriftLimit && $maximumXStoryDrift <  $collapseDriftLimit} {
			# Define current scale to run		
			set scale $currentGrounMotionScale;
			# Sourcing model to run		
			source Define_GM_Record_Info.tcl
			source Model.tcl
			wipe;
			# Defining path to output data for current model
			set pathToOutputFile $baseDir/$dataDir/EQ_$runNumber/Scale_[format "%i" $scale]
			
			# Extracting global EDPs
			# Extracting maximum story drift
			ExtractBiDirectionalMaxDrift3DModel $NStories $numColumnsPerStory $pathToOutputFile	
			
			# Updating vectors used to store relevant response parameters		
			lappend listOfScalesRun $scale;	
			lappend listOfMaximumXStoryDrifts $maximumXStoryDrift;
			lappend listOfMaximumZStoryDrifts $maximumZStoryDrift;			
			incr counterForScales;	
			incr currentGrounMotionScale $reducedGroundMotionScaleIncrement;
		}
		
		
		# Create output text file consisting of maximum story drifts
		set maxXDriftsFile "$dataDir/IDAMaxXDrifts/EQ_$eqNumber.txt"
		set MaxXDrifts [open $maxXDriftsFile "w"]
		foreach maxXDrift $listOfMaximumXStoryDrifts {
			puts $MaxXDrifts "$maxXDrift"
		}
		close $MaxXDrifts
		
		# Create output text file consisting of maximum story drifts
		set maxZDriftsFile "$dataDir/IDAMaxZDrifts/EQ_$eqNumber.txt"
		set MaxZDrifts [open $maxZDriftsFile "w"]
		foreach maxZDrift $listOfMaximumZStoryDrifts {
			puts $MaxZDrifts "$maxZDrift"
		}
		close $MaxZDrifts

		# Create output text file consisting of ground motion scales
		set idaScalesFile "$dataDir/IDAGMScales/EQ_$eqNumber.txt"
		set IDAScales [open $idaScalesFile "w"]
		foreach gmScale $listOfScalesRun {
			puts $IDAScales "$gmScale"
		}
		close $IDAScales
	}
}

set IDAEndT [clock seconds];
set IDARunTime [expr ($IDAEndT - $IDAStartT)/3600];
puts "Run Time = $IDARunTime Hours"
