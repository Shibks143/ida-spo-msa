##############################################################################################################################
# RunIDAToCollapse															                             		             #
#	This module runs incremental dynamic analyses for a given model for a specified number of ground motions to collapse     #
# 														             														 #
# 	Created by: Henry Burton, Stanford University, October 7, 2012									                         #
#								     						                                                                 #
# Units: kips, inches, seconds                                                                                               #
##############################################################################################################################

wipe all;	# Clears memory

set baseDir [pwd];					# sets base directory as current directory 
set dataDir Model
append dataDir IDAOutput;

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

# Ground motion scales to run
set allScales {*AllScales*};

# Scale factor needed to anchor median ground motion ste to MCE level
set MCEScaleFactor *MCEScaleFactor*;

set IDAStartT [clock seconds];


# Looping over alll ground motions
foreach groundMotionNumber $groundMotionIDs {
	if {[expr {$groundMotionNumber % $np}] == $pid} {
		set eqNumber $groundMotionNumber;
		set dt [lindex $groundMotionTimeStep [expr $groundMotionNumber - 1]];
		set numPoints [lindex $groundMotionNumPoints [expr $groundMotionNumber - 1]];
		set MCE_SF $MCEScaleFactor;
		# puts "Ground parameters defined"
	
		# Run IDA until maximum scale is reached
		foreach scale $allScales {	
			cd $baseDir
			source Model.tcl
			wipe;
		}
	}
}



set IDAEndT [clock seconds];
set IDARunTime [expr ($IDAEndT - $IDAStartT)/3600];
puts "Run Time = $IDARunTime Hours"
