#----------------------------------------------------------------------------------#
# RunCyclicPushoverLoading
#	This module runs the cyclic static pushover analysis.  This uses the reference 
#		load distribution from DefinePushoverLoading.tcl.  The control 
#		node and the displacement TH for the PO are both defined
#		in SetAnalysisOptions.tcl.  
#
# Units: kips, in, sec
#
# This file developed by: Curt Haselton of Stanford University
# Date: July 7, 2005
#
# Other files used in developing this model:
#		Paul Cordova's file: Pushover Loading, for Taiwan frame.
#----------------------------------------------------------------------------------#

puts "Pushover loading started..."

# Create an output file that records what happens in the analysis (for debugging promarily)...




# Intialize it to say that we didn't use NormDisplIncr and change this later if we do use it - this is output to a file
#	at the bottom of this script.
	set usedNormDisplIncr 0

# Initialize variables that tell how to perform the SPO - note that the signs of some of these variables are 
#	automatically adjusted in the solution loop, so the PO with go positive or negative. 
	set POdof 1;		# For the reference displacement, use the horizontal displacement of the control node.
	set numSteps 0; 		# Not used anymore!		# This is number of steps to do before we go into the analysis loop
	# Load control for first push
		set initialIncr_LCfirstStep 	5.0;	# These numbers where basically just changed around until the analysis worked well!
		set maxIncr_LCfirstStep 	10.0;			
		set minIncr_LCfirstStep 	3.0;#0.5;
		set Jd_LCfirstStep 		3;	
	# Load control for all subsequent pushes
		set initialIncr_LCotherSteps 	5.0;	# These numbers where basically just changed around until the analysis worked well!
		set maxIncr_LCotherSteps 	10.0;		
		set minIncr_LCotherSteps 	3.0;#0.5;
		set Jd_LCotherSteps 		3;	
	# Displacement control for first push
		set initialIncr_DCfirstStep 	0.04;	# These numbers where basically just changed around until the analysis worked well!
		set maxIncr_DCfirstStep 	0.2;			
		set minIncr_DCfirstStep 	0.0004;
		set Jd_DCfirstStep 		3;	
	# Displacement control for all subsequent pushes (same as step one for now)
		set initialIncr_DCotherSteps 	0.004; #0.0004;	# These numbers where basically just changed around until the analysis worked well!
		set maxIncr_DCotherSteps 	0.2;		
		set minIncr_DCotherSteps 	0.00004; #0.00004;
		set Jd_DCotherSteps 		3;
# Select the solution algorithm to use
if {$cyclicPOsolutionAlgorithm == "McKennaCordovaModified"} {

	# Use this algorithm!

	puts "Cyclic PO Solution Algorithm: McKennaCordovaModified"

	set numItersForPOTop 3
	set numItersForPOBot 2

	# Define numerical options
		# Convergence test
			#                  tolerance maxIter displayCode
			test $testTypeForPO 1.0e-06     10         0;		# Reduce the number of iterations and possibly decrease the tolerance, so we will switch to displ. control quicker

		# Solution algorithm
			algorithm Newton; 		# Changed on 2-17-05 to get PO to work better (to conv. to V = 0).
			#algorithm NewtonLineSearch

		# DOF numberer
			numberer RCM

		# Constraint handler
			constraints Transformation

		# System of equations solver
			system SparseGeneral -piv

		# Analysis type
			analysis Static

	# Initialise the current control node displacement and compute the maximum displacement desired.
		#set currentDisp [nodeDisp $poControlNodeNum $POdof]
		#set maxDisp [expr $maxPushoverDisp + [nodeDisp $poControlNodeNum $POdof]]

	# Start clock to time the length of analysis
	set start [clock seconds]
	set loopCounter 0

	# Do a loop to run each push of the cyclic displacment history
	foreach currentPODisplTarget $dispHistoryForCyclicPO {

		# Just a counter
			set loopCounter [expr $loopCounter + 1];

		# Determine the direction of loading, so we know which way to push it...
			# Find the current displacement
			set currentDisp [nodeDisp $poControlNodeNum $POdof]

			# Determine which way to push to get to desired displacement
			if {$currentPODisplTarget > $currentDisp} {
				set poDirection 1.0;
				set factorOnJd 1; 	# Same as poDirection, but Jd needs to be an integer
			} else {
				set poDirection -1.0;
				set factorOnJd -1; 	# Same as poDirection, but Jd needs to be an integer

			}

		################################################################
#		# Checks - checking looping for each PO thrust
#			if {$loopCounter == 2} {
#				# Stop analysis and report info, for debugging
#				puts "loopCounter is $loopCounter"
#				puts "poDirection is $poDirection"
#				puts "currentPODisplTarget is $currentPODisplTarget"
#				This line stops analysis
#			}
		################################################################
		## Checks - for debugging - they look good
		#	#puts "poDirection is $poDirection"
		#	#puts "currentPODisplTarget is $currentPODisplTarget"
		#
		################################################################
		
#		# Start the PO stroke with load control, then later switch to displacement control after the load control fails
#			# Set up load control integrator - use different arguments depending if it is the first step or not (because later steps can have more difficult 
#			if {$loopCounter == 1} {
#				# Do for 1st step
#				puts "######### 1st step - load control ##########"
#				# Prototype: integrator LoadControl $dLambda1 <$Jd $minLambda $maxLambda>
#				integrator LoadControl [expr $initialIncr_LCfirstStep * $poDirection] [expr $Jd_LCfirstStep * $factorOnJd] [expr $minIncr_LCfirstStep * $poDirection] [expr $maxIncr_LCfirstStep * $poDirection]
#			} else {
#				# Do for later steps
#				puts "######### Later step - load control ##########"
#				# Prototype: integrator LoadControl $dLambda1 <$Jd $minLambda $maxLambda>
#				integrator LoadControl [expr $initialIncr_LCotherSteps * $poDirection] [expr $Jd_LCotherSteps * $factorOnJd] [expr $minIncr_LCotherSteps * $poDirection] [expr $maxIncr_LCotherSteps * $poDirection]
#			}



		# Loop and run load control until it fails or until we get to the current target displacement
			# Put an if statment to control if this is used on every stroke
			


	# TAKE THIS IF STATEMENT OF IF YOU WANT

#			# RUN THE LOAD CONTROL STEPS - Do not do for first stroke b/c displ control works fine
#			if {$loopCounter != 1} {			
#				set ok 0;	# To make it enter the loop
#				while {$ok == 0 && ( (($poDirection == 1.0) && ($currentDisp < $currentPODisplTarget)) || (($poDirection == -1.0) && ($currentDisp > $currentPODisplTarget)) )} {
#					# Do next load step
#						set ok [analyze 1]
#					# Get and display current displacement
#						set currentDisp [nodeDisp $poControlNodeNum $POdof]
#						puts "Current displacement (LC) is: $currentDisp"
#				}
#			}

		# Now use the displacement control integrator for the rest of this PO stroke.
			# Use different arguments depending if it is the first step or not (because later steps can have more difficult 
			#	convergence due to unloading)
#				puts "#########################################################################"
#				puts "#########################################################################"
#				puts "##### Switching to Displacement Control #################################"
#				puts "#########################################################################"
#				puts "#########################################################################"
			if {$loopCounter == 1} {
				# Do for 1st step
				puts "######### 1st step - displacement control ##########"
				set currentIntAlgoUsed DC
				integrator DisplacementControl $poControlNodeNum $POdof [expr $initialIncr_DCfirstStep * $poDirection] [expr $Jd_DCfirstStep * $factorOnJd] [expr $minIncr_DCfirstStep * $poDirection] [expr $maxIncr_DCfirstStep * $poDirection];
			} else {
				set currentIntAlgoUsed LC
				integrator LoadControl [expr $initialIncr_LCotherSteps * $poDirection] [expr $Jd_LCotherSteps * $factorOnJd] [expr $minIncr_LCotherSteps * $poDirection] [expr $maxIncr_LCotherSteps * $poDirection]

#		 # Tests for debugging 		
#			if {($loopCounter != 1)} {
#				puts "loopCounter is $loopCounter"
#				puts "currentDisp is $currentDisp"
#				puts "poDirection is $poDirection"
#				puts "currentPODisplTarget is $currentPODisplTarget"
#				adadasd - stop analysis
#			}



#				# Do for later steps
#				puts "######### Later step - displacement control ##########"
#				integrator DisplacementControl $poControlNodeNum $POdof [expr $initialIncr_DCotherSteps * $poDirection] [expr $Jd_DCotherSteps * $factorOnJd] [expr $minIncr_DCotherSteps * $poDirection] [expr $maxIncr_DCotherSteps * $poDirection];
			}



		# Do one step before entering analysis loop (this was just found to help convergence)
		# 	Note that ok == 0 means that it converged.  
			#set ok [analyze $numSteps];
			#set ok 0
 
		# Do analysis loop: take step, check convergence, if not converged make adjustments and try to take step again....keep 
		# 	going until we get to desired displacement.
		# Do the PO loop to push positive or negative based on value of "pushoverDirection" (from above)
		while {(($ok == 0) && (($poDirection == 1.0) && ($currentDisp < $currentPODisplTarget)) || (($poDirection == -1.0) && ($currentDisp > $currentPODisplTarget)) )} {
			set ok [analyze 1]


			# Wipe analysis, run eigenvalue analysis, then recreate the analysis objects for the cyclic PO
			# (make a script that redefines most of the analysis objects)
				# Do this and save the eigenvalues and eigenvectors
				# Also do this in the convergence loop





			if {$ok != 0} {

				# Once we get here it means that the LC or DC integrator defined above failed; so now change it to DC and
				#	do not ever change it back to LC for the rest of this stroke.
				# NOTE: It seems like I could make this go faster!
				set currentIntAlgoUsed DC
				if {$loopCounter == 1} {
					integrator DisplacementControl $poControlNodeNum $POdof [expr $initialIncr_DCfirstStep * $poDirection] [expr $Jd_DCfirstStep * $factorOnJd] [expr $minIncr_DCfirstStep * $poDirection] [expr $maxIncr_DCfirstStep * $poDirection];
				} else {
					integrator DisplacementControl $poControlNodeNum $POdof [expr $initialIncr_DCotherSteps * $poDirection] [expr $Jd_DCotherSteps * $factorOnJd] [expr $minIncr_DCotherSteps * $poDirection] [expr $maxIncr_DCotherSteps * $poDirection];
				}

				# Keep track of whether or not NormDisplIncr was used.
				if {$allowNormDisplIncrForConv == 1} {
					# If it's not converged (not ok), then use NormDisplIncr to try to obtain convergence (if allowed in SetAnalysisOptions)
					puts "NOTICE: Using NormDisplIncr for convergence"
					set usedNormDisplIncr 1
					set testToUse NormDispIncr 

				} else {
					# If NormDisplIncr is not allowed in SetAnalysisOptions, then use the specified test.
					puts "NOTICE: Reducing step size for convergence, but not using NormDisplIncr."
					set testToUse $testTypeForPO;	# Set to test specified in SetAnalysisOptions.tcl
				}

				# Do loop to get convergence
        			for {set j 1} {$j <= $numItersForPOBot } { incr j 1 } {
					if {$ok == 0} {break}
					test $testToUse 1.0e-06     10         1;
	  				algorithm NewtonLineSearch;	# -initial
					#integrator DisplacementControl $poControlNodeNum $POdof $initialIncr $Jd $minIncr $maxIncr;	# alter these numbers
					#integrator DisplacementControl $poControlNodeNum $POdof [expr $initialIncr/100.0] $Jd [expr $minIncr/100.0] [expr $maxIncr/500.0]
	  				set ok [analyze 1]
					test $testTypeForPO 1.0e-06     10         0; # Set back to test specified in SetAnalysisOptions.tcl
        				algorithm Newton
	  				#integrator DisplacementControl $poControlNodeNum $POdof $initialIncr $Jd $minIncr $maxIncr; # This is just back to the original numbers  
	  				if {$ok == 0} {break}
				}

				# Do loop
        			for {set j 1} {$j <= $numItersForPOBot } { incr j 1 } {
					if {$ok == 0} {break}
					test $testToUse 1.0e-06     1000         1;
	  				algorithm Newton -initial
					#integrator DisplacementControl $poControlNodeNum $POdof $initialIncr $Jd $minIncr $maxIncr;	# alter these numbers
					#integrator DisplacementControl $poControlNodeNum $POdof [expr $initialIncr/100.0] $Jd [expr $minIncr/100.0] [expr $maxIncr/500.0]
	  				set ok [analyze 1]
					test $testTypeForPO 1.0e-06     10         0; # Set back to test specified in SetAnalysisOptions.tcl
        				algorithm Newton
	  				#integrator DisplacementControl $poControlNodeNum $POdof $initialIncr $Jd $minIncr $maxIncr; # This is just back to the original numbers  
				}
				# Do loop
        			for {set j 1} {$j <= $numItersForPOBot } { incr j 1 } {
					if {$ok == 0} {break}
					test $testToUse 1.0e-05     10         1;
	  				algorithm NewtonLineSearch;	# -initial
					#integrator DisplacementControl $poControlNodeNum $POdof $initialIncr $Jd $minIncr $maxIncr;	# alter these numbers
					#integrator DisplacementControl $poControlNodeNum $POdof [expr $initialIncr/100.0] $Jd [expr $minIncr/100.0] [expr $maxIncr/500.0]
	  				set ok [analyze 1]
					test $testTypeForPO 1.0e-06     10         0; # Set back to test specified in SetAnalysisOptions.tcl
        				algorithm Newton
	  				#integrator DisplacementControl $poControlNodeNum $POdof $initialIncr $Jd $minIncr $maxIncr; # This is just back to the original numbers  
				}

				# Do loop
        			for {set j 1} {$j <= $numItersForPOBot } { incr j 1 } {
					if {$ok == 0} {break}
					test $testToUse 1.0e-05     1000         1;
	  				algorithm Newton -initial
					#integrator DisplacementControl $poControlNodeNum $POdof $initialIncr $Jd $minIncr $maxIncr;	# alter these numbers
					#integrator DisplacementControl $poControlNodeNum $POdof [expr $initialIncr/100.0] $Jd [expr $minIncr/100.0] [expr $maxIncr/500.0]
	  				set ok [analyze 1]
					test $testTypeForPO 1.0e-06     10         0; # Set back to test specified in SetAnalysisOptions.tcl
        				algorithm Newton
	  				#integrator DisplacementControl $poControlNodeNum $POdof $initialIncr $Jd $minIncr $maxIncr; # This is just back to the original numbers  
				}
				# Do loop
        			for {set j 1} {$j <= $numItersForPOBot } { incr j 1 } {
					if {$ok == 0} {break}
					test $testToUse 1.0e-04     10         1;
	  				algorithm NewtonLineSearch;	# -initial
					#integrator DisplacementControl $poControlNodeNum $POdof $initialIncr $Jd $minIncr $maxIncr;	# alter these numbers
					#integrator DisplacementControl $poControlNodeNum $POdof [expr $initialIncr/100.0] $Jd [expr $minIncr/100.0] [expr $maxIncr/500.0]
	  				set ok [analyze 1]
					test $testTypeForPO 1.0e-06     10         0; # Set back to test specified in SetAnalysisOptions.tcl
        				algorithm Newton
	  				#integrator DisplacementControl $poControlNodeNum $POdof $initialIncr $Jd $minIncr $maxIncr; # This is just back to the original numbers  
				}
				# Do loop
        			for {set j 1} {$j <= $numItersForPOBot } { incr j 1 } {
					if {$ok == 0} {break}
					test $testToUse 1.0e-04     1000         1;
	  				algorithm Newton -initial
					#integrator DisplacementControl $poControlNodeNum $POdof $initialIncr $Jd $minIncr $maxIncr;	# alter these numbers
					#integrator DisplacementControl $poControlNodeNum $POdof [expr $initialIncr/100.0] $Jd [expr $minIncr/100.0] [expr $maxIncr/500.0]
	  				set ok [analyze 1]
					test $testTypeForPO 1.0e-06     10         0; # Set back to test specified in SetAnalysisOptions.tcl
        				algorithm Newton
	  				#integrator DisplacementControl $poControlNodeNum $POdof $initialIncr $Jd $minIncr $maxIncr; # This is just back to the original numbers  
				}
				
#				# If we get to here and ok != 0, then we have tried everything and still not converged, so report this
#				#	and break from this solution algorithm loop
#	  				if {$ok != 0} {
#						puts "##############################################################################"
#						puts "##############################################################################"
#						puts "We tried everything in the solution algorithm loop and still did not converge!"
#						puts "##############################################################################"
#						puts "##############################################################################"
#
#						# Break 
#						break
#					}
			};	# End of loop to try to get convergence for this step

			# Get and display current displacement
			set currentDisp [nodeDisp $poControlNodeNum $POdof]
			puts "Current displacement ($currentIntAlgoUsed) is: $currentDisp"
		}

		# When we get here, we are done with one push of the cyclic PO
			puts "#########################################################################"
			puts "#########################################################################"
			puts "##### Done with this push, current displacement is $currentDisp #########"
			puts "#########################################################################"
			puts "#########################################################################"

	}; # End of cyclic PO

	# After PO is completed, output maximum displacement reached.
	#puts "MaxDisp is $maxDisp. We reached $currentDisp"

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
	set scaleFactor 			1.0
	set dtForAnalysis 		-1.0
	# Just to avoid an error when doing post-EQ calculations
	set dtForEQ(9999) 		0.0
	set numPointsForEQ(9999) 	0.0 

# Save information to file after the PO
wipeAnalysis; # Added so the post-EQ eigenvalue can be computed
source SaveRunInformationAfterEQ.tcl


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






