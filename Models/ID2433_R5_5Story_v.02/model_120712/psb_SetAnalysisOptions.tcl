#----------------------------------------------------------------------------------#
# SetAnalysisOptions
#		This module defines the analysis options (i.e. what analyses are to be 
#			run when the RunMeanAnalysis.tcl file is executed).  
#			The list of nodes to record (or the option to record all nodes), 
#			the LIST of nodes for each building level, etc.
#
# Units: kN, mm, seconds
#
# This file developed by: Curt Haselton of Stanford University (28 June 2005)
# Modified by: Prakash S Badal of IIT Bombay
# Date: 20 Mar 2016
#
# Other files used in developing this model:
#		None
#----------------------------------------------------------------------------------#

##############################################################################################
# Model Name (define naming for use in output files; to keep output organized)
##############################################################################################

	# Define the name of the model and the period for ground motion scaling.  
	#	The name needs to be the name of the folder that this model 
	#	is in and the name is added to all output files.  NOTICE that this dictates 
	#	what folder the output results are written to.
		set model ID2433_R5_5Story_v.02

	# Define a variable name - I use this to keep track of the sensitivity analysis results,
	#	but you could use this to keep track of analyses for different type of cyclic 
	#	pushover methods.
		set variable AllVar;	# This is the model variable that will be altered later if a 
					#	sensitivity analysis is run. If you alter this definition 
					#	in this file, it will affect the output file naming, but will 
					#	not work for sensitivity analysis.

	# Define the value of the above variable (for similar use in the output file naming). This is 
	#	primarily used for sensitivity analysis, but we could adapt it for your analyses with 
	#	different cyclic load histories.
		#set variableVal Mean;	
		set variableVal 0.00;	

##############################################################################################
# Model Type and Options (define which model to use)
##############################################################################################

	# Select elements to use - this is just a CONSTANT now and is used in the naming of the folders
		set elementsUsedForModel clough;


##############################################################################################
# Analysis Settings (tell the program what to do)
##############################################################################################

	##############################################################################################
	# Monotonic Static Pushover Analysis
	##############################################################################################

		# Put whether or not to do a pushover analysis
			set runPushover YES
			#set runPushover NO

		# Maximum displacement for pushover (of control node)
 			set maxPushoverDisp 1045.0;	
            # set maxPushoverDisp 820.0;	

		# Define the PO number - for output files/folders and post-processing - this allows you to keep results from 
		#	organized from different analyses.
			set poNumberMono 9991

	##############################################################################################
	# Cyclic Static Pushover Analysis
	##############################################################################################
			# set runCyclicPushover YES
			set runCyclicPushover NO

	# FIX THIS
			set maxDisp 500.0;	# Roof displacement at 80% base shear strength from the monotonic pushover
			set dispHistoryForCyclicPO {[expr 0.1*$maxDisp] [expr -0.1*$maxDisp] [expr 0.2*$maxDisp] [expr -0.2*$maxDisp] [expr 0.3*$maxDisp] [expr -0.3*$maxDisp] [expr 0.4*$maxDisp] [expr -0.4*$maxDisp] [expr 0.5*$maxDisp] [expr -0.5*$maxDisp] [expr 0.6*$maxDisp] [expr -0.6*$maxDisp] [expr 0.7*$maxDisp] [expr -0.7*$maxDisp] [expr 0.8*$maxDisp] [expr -0.8*$maxDisp] [expr 0.9*$maxDisp] [expr -0.9*$maxDisp] [expr 1.0*$maxDisp] [expr -1.0*$maxDisp] 0.0};

	
		# Define the PO number - for output files/folders and post-processing - this allows you to keep results from 
		#	organized from different analyses.
			set poNumberCyclic 9992

	
	##############################################################################################
	# Eigenvalue Analysis
	##############################################################################################

		# Specify if you want an eigen analysis run and output to Matlab
			set runEigenAnalysisForMatlab 1
			#set runEigenAnalysisForMatlab 0

	###############################################################################################
	# Display mode - This will create a visualization window for the model
	set displayMode "displayON"
	# set displayMode "displayOFF"


############## End of standard user input #################################################################################
###########################################################################################################################
###########################################################################################################################

# Input the convergence test that you want to use - use for PO and for EQ
	set testType RelativeNormDispIncr;		# For EQ - use this one, so that reducing step size will not mess up tolerance!
	#set testType NormDispIncr;			# For EQ 
	#set testTypeForPO RelativeNormDispIncr;	# For PO 
	set testTypeForPO NormDispIncr;		# For PO - use this one, as per meeting notes with Frank on 10-13-04! 

	set defaultTolerance 1.0e-4

# If you do use the RealtiveDisplIncr, decide if you will let NormDisplIncr be used when there are convergence problems
#	For now this only affects the EQ algorithm
	# DO I EVEN USE THIS EVEN USED IN THE ALGORITHM ANYMORE? - I don't thinks so, for EQ!  I think that it is still used in the PO algorithm.
	set allowNormDisplIncrForConv	1;	# Yes, allow it
#	set allowNormDisplIncrForConv	0;	# No, don't allow it

# Choose Iteration algorithm and input arguments to algorithm
#	set iterAlgo Newton;	# Use this
#	set iterAlgoArg ""
	set iterAlgo NewtonLineSearch
	set iterAlgoArg 0.6

# Define the solution algorithms we want to use
	# Static monotonic pushover
	set POsolutionAlgorithm Cordova; 		# Use this

	# Cyclic monotonic pushover
	set cyclicPOsolutionAlgorithm McKennaCordovaModified; 	# An algorithm that I made from another algorithm by P. Cordova (which originated from F. McKenna)

	# Earthquake
	#set EQsolutionAlgorithm Cordova;
	#set EQsolutionAlgorithm CordovaMod;		# Use this one for levels where I may need acceleration results (maybe - see 
								#	notes on 10-13-04, which is Frank meeting) This was used for most of 
								# 	analysis of DesID1 (nlBmCol at least).  Also, after a time test, I see that
								#	this seems to run in comparable times with the CordovaFrank algorithm (see
								#	notes in computer for mean design, on 10-14-04).
	set EQsolutionAlgorithm CordovaFrank;	# This may cause more porblems when adding the ground accelerations in post=processing, 
								#	but it should work ok if you need to use it (i.e. if the accelerations are not
								#	added back in perfectly, then it's not a big deal).
	#set EQsolutionAlgorithm CordovaModOlder;	
	#set EQsolutionAlgorithm Oldv13;	# Just testing old alog. - seems to be giving large errors, but still "converging"
	#set EQsolutionAlgorithm VanNuys;
	#set EQsolutionAlgorithm I880;

# Decide whether recorders should be made
	# All recorders
	set defineRecorders YES
	#set defineRecorders NO

	# Option to define limited recorders
	#set onlyDefineLimitedRecForVariations 1;	# This reduces the number of recorders to be only what is needed for the EDP transfer to Caltech (to reduce the data created during the analysis).
	set onlyDefineLimitedRecForVariations 0

	# Decide about joint recorders
	set defineJointRecorders 1
	#set defineJointRecorders 0

	# Deiced whether you want recorders for the Hyst hinges (hinge numbers defined later)
 	set defineHystHingeRecorders 1;	# These are also for the gravity frame, so use them!!!
	#set defineHystHingeRecorders 0

	# Set to record the nodes in the list if you would like
	set recordNodesInList YES
	#set recordNodesInList NO

# Collapse analysis setting - I am not sure if this is used when I run collapse analysis with Matlab
	set useINDAsCollapse 0;	# Don't use IND for collapse, if it goes IND, let it return an error!!!
#	set minStoryDriftRatioForCollapse 0.12; # using the value from MATLAB

# Decide if you want it to stop the anaysis over a specified maximum story drift (so that if stripe anlyses collapse, the
#	EQ will stop and we will go to the next EQ.  This uses the same nodes and collapse threshol as for collapse 
#	anlyses (threshold input above)
	set stopStripeAnalysisForCollapse 1;	# Yes, stop
	##set stopStripeAnalysisForCollapse 0;	# No, just let the analysis die and have an error

# Put place-older in case I want to use this for fiber analyses in the future
	set defineElementEndSectionRecorders 0;
	set defineMaterialRecorders 0;

# End of user input----------------------------------------------------------------------------------

# Here, I am making the analysisType name that will be used if I am running a mean analysis
#	If a sensitivity anlysis is run, this value is changed during the sensitivity anlysis.
#NOTE: This becomes the output folder name and is included in the output file names.
	set analysisType ($model)_($variable)_($variableVal)_($elementsUsedForModel);	
	puts "CHECK: In SetAnalysisOptions, analysisType is set to: $analysisType"
														
# Decide whether to add element to "measure" ground displacement
	set findgroundDispl 1.0;
	puts "findgroundDispl is $findgroundDispl"
	if {$findgroundDispl == 1.0} {
		set groundDisplLIST {88002}
	}



