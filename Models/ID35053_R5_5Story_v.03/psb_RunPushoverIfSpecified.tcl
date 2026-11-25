#----------------------------------------------------------------------------------#
# RunPushoverIfSpecified.tcl
#	This module runs Pushover anaysis if this option is set in the 
#		SetAnalysisOptions.tcl module.  This is currently set-up to run a standard
#		nonlinear static pushover analysis, but I can help you change the analysis 
#		program in order to run a cyclic static analysis.
#
# Units: kN, mm, seconds
#
# This file developed by: Curt Haselton of Stanford University (28 June 2005)
# Modified by: Prakash S Badal of IIT Bombay
# Date: 18 Mar 2016
#
#----------------------------------------------------------------------------------#

source psb_SetAnalysisOptions.tcl


if {$runPushover == "YES"} {

	puts "Running Pushover..."

	# Set up the model
	source psb_RedefineEverythingAndReSetUpModel.tcl

	# Define pushover loading
	# (26-Nov-2026, sks) If MATLAB (psb_MasterDriver_ProcPushoverAnalyses.m) sets PUSHOVER_LATERALFORCE_ON_FLOORS
	#	(lateral force at each floor, roof first, adds up to 1.0), that pattern is used and shared between the
	#	column lines by equal-bay tributary width (1/6, 2/6, 2/6, 1/6 for 3 bays).
	#	Otherwise ('Parabolic Stiffness'), the design-sheet loading in psb_DefinePushoverLoading.tcl is used, as before.
	if {[info exists env(PUSHOVER_LATERALFORCE_ON_FLOORS)] && $env(PUSHOVER_LATERALFORCE_ON_FLOORS) != ""} {
		set pushoverLateralForceOnFloorsLIST $env(PUSHOVER_LATERALFORCE_ON_FLOORS);	# roof first
		set numFloors      [llength $pushoverLateralForceOnFloorsLIST]
		set numColumnLines 4;								# 3 bays in all current models
		set numBays        [expr $numColumnLines - 1]
		puts "Pushover loading from MATLAB (PUSHOVER_LATERALFORCE_ON_FLOORS), roof first: $pushoverLateralForceOnFloorsLIST"
		pattern Plain 13 Linear {
			for {set floorIndex 0} {$floorIndex < $numFloors} {incr floorIndex} {
				set floorNum     [expr $numFloors + 1 - $floorIndex];	# roof first
				set forceOnFloor [lindex $pushoverLateralForceOnFloorsLIST $floorIndex]
				for {set columnLine 1} {$columnLine <= $numColumnLines} {incr columnLine} {
					# equal bays: end column lines take half a bay, interior ones a full bay
					if {$columnLine == 1 || $columnLine == $numColumnLines} {
						set columnLineShare [expr 1.0 / (2.0 * $numBays)]
					} else {
						set columnLineShare [expr 1.0 / $numBays]
					}
					set loadedNode [expr 200000 + $floorNum*1000 + $columnLine*10 + 3];	# 2FFc3
					load $loadedNode [expr $forceOnFloor * $columnLineShare] 0.0 0.0
				}
			}
		}
	} else {
		puts "Pushover loading from psb_DefinePushoverLoading.tcl (design sheet)"
		source psb_DefinePushoverLoading.tcl
	}

	# Set up recorders for pushover
	set saTOneForRun 0.00; 			# Dummy number used for pushover anlysis	
	set eqNumber [expr $poNumberMono];	# Dummy number used for pushover anlysis
	source psb_DefineAllRecorders.tcl

	# Run Loading
	source psb_RunPushoverLoading.tcl

	# Erase Everything to proceed to the next step
	remove recorders
	wipe all
	puts "Wiped"
}
