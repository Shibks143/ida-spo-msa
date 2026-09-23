# ----------------------------------------------------------------------------------#
# RunMeanAnalysis
# This module is the ROOT file that should be run in order to run the 
# simulation.  It calls the other modules in accordance with the 
# program structure definition in the "OS Program Structure" excel file.

# Units: kN, mm, seconds

# This file developed by: Curt Haselton of Stanford University (28 June 2005)
# Modified by: Prakash S Badal of IIT Bombay
# Date: 18 Mar 2016

# ------------------------------------------------------------------------#
########################################################################
# Analysis...
# Clear the memory
	wipe all
	puts "Wiped"
	# puts "SPO_INDEX from MATLAB: $env(SPO_INDEX)"; # this is reuired only for multiple load patterns 

# Call the files to define the variables, functions, etc.
	source psb_DefineUnitsAndConstants.tcl

	source psb_DefineVariablesAtMeanValues.tcl
	puts "Variables defined \n"

	source psb_DefineFunctionsAndProcedures.tcl
	puts "\n Functions defined \n"

	source psb_SetAnalysisOptions.tcl
	puts "\n Analysis options are set \n"

# Now source in a file that defines multiple values based on a single variable (this can
	# be used to vary things more easily with the sensitivity analyses, or it can define
	# multiple variables based on a single variable in "DefineVariablesAtMeanValues.tcl)).  
	# For a normal analysis (i.e. not a sensitivity) you do not need to worry about what 
	# this is doing.
	# source DefineMultipleVariablesBasedOnOneVariable.tcl

# Call the file to create the structural model.  At this point this is just being 
	# to get output information that we need regarding the model.  In a few steps,
	# the model will be cleared and will be reconstrucred.
	source psb_SetUpModel.tcl; 	# Note that this includes mass, DL, LL, fixities.
	puts "\n Model is set up \n"

# Call the file to output all of the information that we want to save, 
	# which documents how we did this analysis (analysis settings, etc.).
	source psb_WriteNeededInformationToFilesForMatlab.tcl

# Clear memory
	wipe all
	puts "\n Wiped \n"

# Set up the model and run the pushover if the settings in SetAnalysisOptions.tcl say to do so.
	source psb_RunPushoverIfSpecified.tcl
	wipe all

# Set up the model and run the cyclic pushover if the settings in SetAnalysisOptions.tcl say to do so.
	source psb_RunCyclicPushoverIfSpecified.tcl
	wipe all

# Run Analysis types based on input in SetAnalysisOptions.tcl.  Note that the 
	# model is re-setup each time a new earthquake is run.

# (3-23-16, PSB) obsolete here. Using MATLAB masterDriver for IDA	
	# if {$runIDAsForEqLIST == "YES"} {
		# puts "Running EQ's..."
		# source psb_RunAnalysisForAllEQsAndImLevels.tcl
	# }

# Clear memory
	wipe all
	puts "Wiped"

# Run the collaspe analysis if specified
# NOTICE that you should not use this' you should use the Matlab script to do collapse analysis!
	# source RunCollapseAnalysisIfSpecified.tcl

# Clear memory
	wipe all
	puts "Wiped"

# Go back to initial directory (where we started)
	set baseDir [pwd];
