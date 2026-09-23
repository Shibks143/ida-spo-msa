#----------------------------------------------------------------------------------#
# RunCyclicPushoverIfSpecified.tcl
#	This module runs cyclic static pushover anaysis if this option is set in the 
#		SetAnalysisOptions.tcl module.  Note that this is not set up yet for 
#		sensitivity analyses
#
# Units: kips, in, sec
#
# This file developed by: Curt Haselton of Stanford University
# Date: July 6, 2005
#
# Other files used in developing this model:
#	- none
#----------------------------------------------------------------------------------#

source psb_SetAnalysisOptions.tcl


if {$runCyclicPushover == "YES"} {

	puts "Running Cyclic Pushover..."

	# Set up the model
	source psb_RedefineEverythingAndReSetUpModel.tcl

	# Define pushover loading
	source psb_DefinePushoverLoading.tcl

	# Set up recorders for pushover
	set saTOneForRun 0.00; 		# Dummy number used for pushover anlysis	
	set eqNumber [expr $poNumberCyclic];	
	source psb_DefineAllRecorders.tcl

	# Run Loading
	source psb_RunCyclicPushoverLoading.tcl

	# Erase Everything to proceed to the next step
	remove recorders
	wipe all
	puts "Wiped"
}
