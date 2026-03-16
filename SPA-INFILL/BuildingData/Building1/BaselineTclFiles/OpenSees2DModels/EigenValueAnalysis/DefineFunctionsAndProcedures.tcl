##############################################################################################################################
# DefineFunctionsAndProcedures									                             #
#	This file will be used to define functions and procedures that are used in the rest of the program		     #
# 														             #
# Created by: Henry Burton, Stanford University, 2010									     #
#								     						             #
# Units: kips, inches, seconds                                                                                               #
##############################################################################################################################
 

##############################################################################################################################
#          			Define Peak Oriented Ibarra Material for Beam and Column Plastic Hinges			     #
##############################################################################################################################

proc CreateIbarraMaterial { matTag EIeff myPos myNeg mcOverMy thetaCapPos thetaCapNeg thetaPC lambda c resStrRatio stiffFactor1 stiffFactor2 eleLength } {

	# Do needed calculations
		set elstk 	[expr $stiffFactor1 * ((6 * $EIeff) / $eleLength)];	# Initial elastic stiffness
		set alphaHardUnscaled 	[expr ((($myPos*$mcOverMy)-$myPos)/($thetaCapPos)) / $elstk];
		set alphaHardScaled	[expr $alphaHardUnscaled * ((-$stiffFactor2 * $alphaHardUnscaled ) / ($alphaHardUnscaled * ($alphaHardUnscaled - $stiffFactor2)))];	# This altered the stiffness to account for the elastic element stiffness - see hand notes on 1-6-05
		set alphaCapUnscaled	[expr ((-$myPos*$mcOverMy)/($thetaPC)) / $elstk];
		set alphaCapScaled	[expr $alphaCapUnscaled * ((-$stiffFactor2 * $alphaCapUnscaled) / ($alphaCapUnscaled * ($alphaCapUnscaled - $stiffFactor2)))];	# This altered the stiffness to account for the elastic element stiffness - see hand notes on 1-6-05
		set lambdaA 0; 							# No accelerated stiffness deterioration
		set lambdaS [expr $lambda * $stiffFactor1];		# Strength
		set lambdaK 0;							# No unloading stiffness deterioration because there is a bug in this portion of the model
		#set lambdaK [expr 2.0 * $lambda * $stiffFactor1];	# Unloading stiffness (2.0 is per Ibarra chapter 3)
		set lambdaD [expr $lambda * $stiffFactor1];		# Capping strength
		set dPlus 			    1;															# Unloading stiffness deterioration
		set dNeg 			1;														# Capping strength deterioration
		set thetaUlt 10; # Value does not matter. Just needs to be large.
		# set thetaCapNeg [expr -1.0*$thetaCapNeg]
	

	# Create the material model
		uniaxialMaterial Clough  $matTag $elstk $myPos $myNeg $alphaHardScaled $resStrRatio $alphaCapScaled	$thetaCapPos $thetaCapNeg $lambdaS $lambdaK $lambdaA $lambdaD  $c $c $c $c
	    # uniaxialMaterial ModIMKPeakOriented  $matTag $elstk $alphaHardScaled $alphaHardScaled $myPos $myNeg  $lambdaS $lambdaK $lambdaA $lambdaD  $c $c $c $c $thetaCapPos $thetaCapNeg $thetaPC $thetaPC $resStrRatio $resStrRatio $thetaUlt $thetaUlt  $dPlus $dNeg
		
}



##############################################################################################################################
#          				Define Ibarra Material for Infill Strut						     									 #
##############################################################################################################################


proc CreateIbarraStrutMaterial { matTag Ke FyPos FyNeg FcOverFy deltaCapPos deltaCapNeg deltaPC resStrRatio eleLength } {

	# Do needed calculations
		set elstk 	[expr $Ke*$eleLength];												# Initial elastic stiffness
		set alphaHard [expr ((($FyPos*$FcOverFy)-$FyPos)/($deltaCapPos)) / $Ke];		# Strain Hardening Ratio
		set alphaCap [expr ((-$FyPos*$FcOverFy)/($deltaPC)) / $Ke]; 					#Post-Capping Strain Hardening Ratio
		set lambdaA 0; 																# Accelerated stiffness deterioration
		set lambdaS 0;																# Strength Deterioration
		set lambdaK 0;																	# Unloading stiffness deterioration
		set lambdaD 0;																# Capping strength
		set c 1.0;
		set strainCapPos [expr $deltaCapPos/$eleLength];				# pre-capping positive strain				
		set strainCapNeg [expr $deltaCapNeg/$eleLength];				# pre-capping negative strain
		set strainPC [expr $deltaPC/$eleLength];				# pre-capping negative strain

	# Create the material model
		# uniaxialMaterial CloughHenry  $matTag $elstk $FyPos $FyNeg $alphaHard $resStrRatio $alphaCap $strainCapPos $strainCapNeg $lambdaS $lambdaK $lambdaA $lambdaD  $c $c $c $c

	
}

##############################################################################################################################
#          				Define Ibarra Material for Column Shear					     									 #
##############################################################################################################################


proc CreateIbarraShearMaterial { matTag Ke FyPos FyNeg FcOverFy deltaCapPos deltaCapNeg deltaPC resStrRatio } {

	# Do needed calculations
		set elstk 	[expr $Ke];												# Initial elastic stiffness
		set alphaHard [expr ((($FyPos*$FcOverFy)-$FyPos)/($deltaCapPos)) / $Ke];		# Strain Hardening Ratio
		set alphaCap [expr ((-$FyPos*$FcOverFy)/($deltaPC)) / $Ke]; 					#Post-Capping Strain Hardening Ratio
		set lambdaA 0; 																# Accelerated stiffness deterioration
		set lambdaS 0;																# Strength Deterioration
		set lambdaK 0;																	# Unloading stiffness deterioration
		set lambdaD 0;																# Capping strength
		set c 1.0;
		set strainCapPos [expr $deltaCapPos];				# pre-capping positive strain				
		set strainCapNeg [expr $deltaCapNeg];				# pre-capping negative strain
		set strainPC [expr $deltaPC];				# pre-capping negative strain
		set dPlus 			    1;															# Unloading stiffness deterioration
		set dNeg 			1;														# Capping strength deterioration
	

	# Create the material model
		uniaxialMaterial Clough  $matTag $elstk $FyPos $FyNeg $alphaHard $resStrRatio $alphaCap $strainCapPos $strainCapNeg $lambdaS $lambdaK $lambdaA $lambdaD  $c $c $c $c
	   # uniaxialMaterial ModIMKPeakOriented  $matTag $elstk $alphaHard $alphaHard $FyPos $FyNeg  $lambdaS $lambdaK $lambdaA $lambdaD  $c $c $c $c $strainCapPos [expr -1.0*$strainCapNeg] $deltaPC $deltaPC $resStrRatio $resStrRatio [expr $deltaPC +  $deltaCapPos] [expr $deltaPC +  $deltaCapPos]  $dPlus $dNeg
				
	
	
}

##############################################################################################################################
#          	   Define Rotational Spring with Ibarra Material for Beam and Column Plastic Hinges			     				 #
##############################################################################################################################


proc rotSpring2DModIKModel {eleID nodeR nodeC matID} {
#
# Create the zero length element
      
 
      element zeroLength $eleID $nodeR $nodeC -mat $matID -dir 6
 
# Constrain the translational DOF with a multi-point constraint
#          			retained constrained DOF_1 DOF_2 ... DOF_n
           equalDOF    $nodeR     $nodeC     1     2
}


##############################################################################################################################
#          	   				Define 3D Spring with Inelastic Flexural and Shear Materials				     				 #
##############################################################################################################################


proc ColShearAndFlexuralSpring2DModIKModel {eleID nodeR nodeC flexmatID shearmatID axialmatID} {
# Create the zero length element
      element zeroLength $eleID $nodeR $nodeC -mat $shearmatID $axialmatID $flexmatID -dir 1 2 6    
}

proc rotLeaningCol {eleID nodeR nodeC} {

	#Spring Stiffness
	set K 1e-9; # k/in

	# Create the material and zero length element (spring)
    uniaxialMaterial Elastic  $eleID  $K	
	element zeroLength $eleID $nodeR $nodeC -mat $eleID -dir 6

	
	# Constrain the translational DOF with a multi-point constraint	
	#   		retained constrained DOF_1 DOF_2
 
	equalDOF    $nodeR     $nodeC     1     2
}

puts "All Functions and Procedures have Been Sourced"