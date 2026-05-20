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
	source psb_DefinePushoverLoading.tcl

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
