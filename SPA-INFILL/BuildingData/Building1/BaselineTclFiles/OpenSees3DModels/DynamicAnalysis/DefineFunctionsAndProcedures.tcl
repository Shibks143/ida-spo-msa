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
		# puts "$alphaHardUnscaled"
		# puts "$alphaHardScaled"

	# Create the material model
		uniaxialMaterial Clough  $matTag $elstk $myPos $myNeg $alphaHardScaled $resStrRatio $alphaCapScaled	$thetaCapPos $thetaCapNeg $lambdaS $lambdaK $lambdaA $lambdaD  $c $c $c $c
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
}

##############################################################################################################################
#          	   Define 3D Rotational Spring with Ibarra Material for Beam Plastic Hinges					     				 #
##############################################################################################################################


proc rotXBeamSpring3DModIKModel {eleID nodeR nodeC matID stiffmatID} {
#
# Create the zero length element
      
 
      element zeroLength $eleID $nodeR $nodeC -mat $stiffmatID $stiffmatID $stiffmatID $stiffmatID $stiffmatID $matID -dir 1 2 3 4 5 6 -orient 1 0 0 0 1 0 
}

proc rotZBeamSpring3DModIKModel {eleID nodeR nodeC matID stiffmatID} {
#
# Create the zero length element
      
 
      element zeroLength $eleID $nodeR $nodeC -mat $stiffmatID $stiffmatID $stiffmatID $stiffmatID $stiffmatID $matID -dir 1 2 3 4 5 6 -orient 0 0 -1 0 1 0 
}



##############################################################################################################################
#          	   				Define 3D Spring with Inelastic Flexural and Shear Materials				     				 #
##############################################################################################################################


proc rotColSpring3DModIKModel {eleID nodeR nodeC axialmatID shearLocalYmatID shearLocalZmatID flexLocalXmatID flexLocalYmatID flexLocalZmatID} {
#
# Create the zero length element
      
 
      element zeroLength $eleID $nodeR $nodeC -mat $axialmatID $shearLocalYmatID $shearLocalZmatID $flexLocalXmatID $flexLocalYmatID  $flexLocalZmatID -dir 1 2 3 4 5 6 -orient 0 1 0 1 0 0     
}

# puts "All Functions and Procedures have Been Sourced"