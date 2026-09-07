#----------------------------------------------------------------------------------#
# RunPushoverLoading
#	This module runs the pushover analysis.  This uses the reference 
#		load distribution from DefinePushoverLoading.tcl.  The control 
#		node and the maximum displacement for the PO are both defined
#		in SetAnalysisOptions.tcl.  This currelty does a standard monotonic
#		SPO analysis, but I can help you to alter this to do a cyclic static 
#		analysis (please contact me when you would like this).
#
# Units: kN, mm, seconds
#
# This file developed by: Curt Haselton of Stanford University (28 June 2005)
# Modified by: Prakash S Badal of IIT Bombay
# Date: 20 Mar 2016
#
##----------------------------------------------------------------------------------#

puts "Pushover loading started..."


# NOTICE: The cyclic PO algorithm is more elegant (uses load control until it stops, then uses displ. control), so I should 
#	things to make the monotonic PO use the cyclic PO algorithm (with just one stroke).

# Intialize it (variable usedNormDisplIncr) to say that we didn't use NormDisplIncr and change this later if we do use it - this is output to a file
#	at the bottom of this script.
#	Basically, this is used for testing convergence type in case displacement increment has failed.
	set usedNormDisplIncr 0

# Initialize variables that tell how to perform the SPO
	set POdof 1;		# For the reference displacement, use the horizontal displacement of the control node.
	set initialIncr 0.0001;	# These numbers where basically just changed around until the analysis worked well!
	set maxIncr 10;			
	set minIncr 0.00001; # increments are in units of mm
	set Jd 3;	
	set numSteps 1;		# This is number of steps for each analysis loop.

	set tempDisp 0; 	# this is just an indicator used for printing displacement during the analysis

# Select the solution algorithm to use
if {$POsolutionAlgorithm == "Cordova"} {

	# Use this algorithm!

	puts "PO Solution Algorithm: Cordova"

	# Define convergence test and numbers of iterations to use in top and bottom loops
	#                  tolerance maxIter displayCode
	# Changed to realtive with 10^-6 based on recomendation of Frank M on 5-3-04
	# (3-20-16, PSB) Changed to realtive with 10^-5 based on units in mm 
	test $testTypeForPO 1.0e-04     10         0;

	set numItersForPOTop 3
	set numItersForPOBot 2

	# Solution algorithm
	algorithm Newton; 		# Changed on 2-17-05 to get PO to work better (to conv. to V = 0).
#	algorithm NewtonLineSearch

	# DOF numberer
	numberer RCM

	# Constraint handler
	constraints Transformation

	# System of equations solver
	system SparseGeneral -piv

	# Analysis type
	analysis Static

	# Initialise the current control node displacement and compute the maximum displacement desired.
	set currentDisp [nodeDisp $poControlNodeNum $POdof]
	set maxDisp [expr $maxPushoverDisp + [nodeDisp $poControlNodeNum $POdof]]

	# Use displacement control integrator.  I could start with force control and the switch to displacement control, but
	#	it is simpler to just use diplacement control for the entire SPO.
	integrator DisplacementControl $poControlNodeNum $POdof $initialIncr $Jd $minIncr $maxIncr;	# alter these numbers

	# Start clock to time the length of analysis
	set start [clock seconds]

	# Do one step before entering analysis loop (this was just found to help convergence)
	# 	Note that ok == 0 means that it converged.
 		puts "Prakash 1 ";
#	set ok [analyze $numSteps];
	set ok 0
 		puts "Prakash 2 ";

	# Do analysis loop: take step, check convergence, if not converged make adjustments and try to take step again....keep going until we get to desired displacement.

	while {$ok == 0 && $currentDisp < $maxDisp} {
	set ok [analyze 1]

	
		if {$ok != 0} {
		test NormDispIncr 1.0e-3 5000 1     ;# increase max number of iterations 
		# test NormUnbalance 1.0e-4 1000 1 2
		# test RelativeEnergyIncr 1.0e-4 1000 1
		
		# algorithm ModifiedNewton -initial      ;# use initial elastic stiffness for NewtonRaphson
		# algorithm KrylovNewton -initial      ;# use initial elastic stiffness for NewtonRaphson
		# algorithm Broyden 10000
		# algorithm BFGS
		algorithm NewtonLineSearch -tol 0.001 -maxIter 1000

		#puts "Time Newton Initial [getTime]" ;# output time algorithm was changed
		set ok [analyze 1 ] 			;# analyse 1 step with new settings
		#set ans [gets stdin] 		        ;# pauses tcl script
		algorithm Newton                        ;# restore algorithm to Newton with current stiffness
		test $testTypeForPO 1.0e-04     10         0;          ;# restore max number of iterations
	}
		# Save and display current displacement
 
	set currentDisp [nodeDisp $poControlNodeNum $POdof]
	
	if {[expr round(fmod($currentDisp, 10))] == 0} {
		if {$tempDisp != [expr (round($currentDisp) - round(fmod($currentDisp, 10))) / 10]} {
			puts "Current displacement is: $currentDisp"
		} 
	}

	set tempDisp [expr (round($currentDisp) - round(fmod($currentDisp, 10))) / 10];

		
#	if {[expr round(fmod($currentDisp * 10, 100))] == 0} {
#		puts "Current displacement is: $currentDisp"
#	}
	
}

	# After PO is completed, output maximum displacement reached.
	puts "MaxDisp is $maxDisp. We reached $currentDisp"

} else {
	puts "ERROR: No solution algorithm used for PO loading - Check analysis options"
}

# Output time that it took for the analysis
	set finish [clock seconds]
	set minutesToRunThisAnalysis [expr ($finish-$start)/60.0]
	puts "Time Duration for Pushover analysis: $minutesToRunThisAnalysis minutes"

#loadConst -time 0.0;	# What is this doing???

############ End PO loading ###############

# Set scale factor to avaoid an error in the next file (just a detail for the output files)
	set scaleFactor 1.0
	set dtForAnalysis -1.0
	# Just to avoid an error when doing post-EQ calculations
	set dtForEQ(999) 	0.0
	set numPointsForEQ(999) 0.0 

# Save information to file after the PO
source psb_SaveRunInformationAfterEQ.tcl


# Output file saying whether or not it used NormDisplIncr (just for the knowledge of the analyst)
	set startDir [pwd]
	cd ..
	cd ..
			
	set baseDir [pwd]
	cd $baseDir/Output/$analysisType/EQ_$eqNumber/Sa_$saTOneForRun
	set runDir [pwd]

	file mkdir RunInformation; 
	cd $runDir/RunInformation/

	set filenameEQ [open usedNormDisplIncrOUT.out w]
	puts $filenameEQ $usedNormDisplIncr
	close $filenameEQ 

	cd $startDir 






