#----------------------------------------------------------------------------------#
#
# Units: kN, mm, seconds
#
# This file developed by: Curt Haselton of Stanford University (28 June 2005)
# Modified by: Prakash S Badal of IIT Bombay
# Date: 18 Mar 2016
#
# Other files used in developing this model:
#		none
#----------------------------------------------------------------------------------#

# Input the conctraint handler to use.  If Penalty is used, then input arguments.
	set constraintForEQ 	Transformation
	set constraintArg1EQ	"";	# Only needed for penalty method, so put "" is other method is used
	set constraintArg2EQ	"";	# Only needed for penalty method, so put "" is other method is used
	#set constraintForEQ 	Penalty
	#set constraintArg1EQ	1.0e15;	# Only needed for penalty method, so put "" is other method is used
	#set constraintArg2EQ	1.0e15;	# Only needed for penalty method, so put "" is other method is used

# Decide if largeDispl should be used for the joint elements
	set lrgDsp 1;	# Causes a bit more QNAN problems, but better to use.
	#set lrgDsp 0

# Geometric transformations
	# Transformation - for the elements of the lateral frame and the leaning column.
	# Do one for all elements
		set strGeomTransf LinearWithPDelta
		#set strGeoTransf Corotational

	# Transformation for gravity frame - gravity frame beams and columns
		#set gravFrameTranf $strGeoTransf;
		set gravFrameGeomTranf Linear;	# Make the leaning columns take care of all of the P-Delta
		#set gravFrameTranf LinearWithPDelta;

# Strut material for leaning column
	set E_strut [expr 1.00 * 29000.0 * 6.895 * $MPa]
	set A_strut 1e9
	set I_strut 1e9

# Elastic test material stiffness - used for joint hinges not connected to anything, etc.
	set E_elasticTestMaterial 	[expr 1700.0 * 29000.0 * 6.895 * $MPa];	# This is made to match the initial bond-slip M-Rot spring stifness for BS1

# Update this for the ARCHETYPES - Automate this!
	set dampRat		0.050;	# Changed to 5% for RC on 9-7-05 (for ATC-63 project)
#	set dampRat		0.065;	# Changed to 6.5% for matchin with haselton on 11-17-15 (PSB)
	set dampRatF	1.0;		# Factor on the damping ratio.

##########################################################################################
############## MODIFY THESE VALUES BEFORE RUNNING THE ANALYSES ###########################
##########################################################################################

	# Define the periods to use for the Rayleigh damping calculations
	set periodForRayleighDamping_1 1.84;	# Mode 1 period - NEEDS to be UPDATED
	set periodForRayleighDamping_2 0.34;	# Mode 3 period - NEEDS to be UPDATED

	set numModeRequested 14; # Number of modes requested. This is used in psb_WriteNeededInformationToFilesForMatlab.tcl while performing eigen value and eigen vector analyses.

##########################################################################################
##########################################################################################
##########################################################################################



	# set eqTimeHistoryPreFormatted 1; # now inputting through matlab via psb_VarDefinitionsFromMATLAB
				# 1- GM TH are manually curtailed and we do not want opensees to format the ground motion.
                                # NOTE- 1) When eqTimeHistoryPreFormatted is 1, it implies that the user has already 
                                # sorted and curtailed the GM and these curtailed Ground Motion values are saved in 
                                # C:\OpenSeesProcessingFiles\EQs.
                                # 
                                # NOTE- 2) If new GM time history is to be included, 
                                #   a) run the analysis with a value of 0 first, i.e. let opensees create the DtFile, 
                                # SortedEQFile and NumPointsFile,
                                #   b) use curtailGroundMotionBasedOnPGA module of prak_util_MULTIPLE_OPTIONS.m to curtail GM.
                                # This saves the revised SortedEQFile and NumPointsFile in C:\OpenSeesProcessingFiles\EQs,
                                #   c) finally, run the analysis with a value of 1 i.e. with curtailed GM.

# Define variables for the Clough hinges (with damage) (udpated on 6-8-06)
	set resStrRatio 	0.05;	# This is the residual strength ratio; this muct be non-zero or else we see a bug in the unloading/reloading stiffnesses	!!!
	set c		1.0;	# Exponent for deterioration

# Define stiffness factors for the plastic hinges and elastic elements.  stiffFactor1 primarily stiffness the PHs and stiffFactor2 stiffens the elastic elements. (6-8-06)
	set stiffFactor1 11.0
	set stiffFactor2 1.1

# Set stiffness of translational spring (see Abbie's notes dated 12-9-05)
	set groundDisplMatK 10000;

# Set a zero rotational stiffness term - this is used when defining the leaning column elements (I SHOULD JUST REMOVE THIS and PUT "0.0" in the element definitions)
	set IOfZero 0.001;

# Add a dummy value for the period for scaling defined by Matlab when running collapse anlayses.  This was added in attempt to avoid
#	an error when trying to output this value if Matlab was not used to drive collapse analyses (i.e. if we were doing stripe analysis 
#	not using Matlab as the driver).
	set periodUsedForScalingGroundMotionsFromMatlab -1;

# Define small masses for convergence.  These are applied by VB to virtually every DOF. 7-12-06
# This is what I used in DesA_Buffalo_v.9noGFrm when you consider the factor of 10 I used.
#	set smallMass1 0.03235;	# Translational x
#	set smallMass2 0.03235;	# Translational y
#	set smallMass3 4.313;	# Rotational

#	set smallLoadLean 0.001;  # Load on Leaning Column for Space frame


#	set smallMass1 0.00566;	# Translational x
#	set smallMass2 0.00566;	# Translational y
#	set smallMass3 487.303;	# Rotational

	set smallMass1 0.0001;	# Translational x
	set smallMass2 0.0001;	# Translational y
	set smallMass3 1.0;	# Rotational




