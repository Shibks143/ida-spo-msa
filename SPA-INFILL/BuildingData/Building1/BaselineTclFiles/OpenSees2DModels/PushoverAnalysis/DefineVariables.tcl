##############################################################################################################################
# DefineVariables													     													 #
#	This file will be used to define all variables that will be used in the analysis				   					     #
# 														             														 #
# Created by: Henry Burton, Stanford University, 2010									                                     #
# Units: kips, inches, seconds                                                                                               #
##############################################################################################################################
 


##############################################################################################################################
#          					                            Miscellaneous	                				         		     #
##############################################################################################################################

# Define Geometric Transformations
	set PDeltaTransf 1;
	set LinearTransf 2;
	set TransBeamLinearTransf 3;
	set LongBeamLinearTransf 4;
	
# set up geometric transformations of element
	geomTransf PDelta $PDeltaTransf; 							# PDelta transformation
	geomTransf Linear $LinearTransf;
	
# Residual strength ratio for beam-column flexure
set resStrRatioBeamColumnFlexure 0.01

# Residual strength ratio for column shear
set resStrRatioColumnShear 0.01

# Define stiffness factors for plastic hinges and elastic elements
	set stiffFactor1 11;
	set stiffFactor2 1;

#Define residual strength ratio for Clough Beam-Column Elements
	set resStrRatioBeamColumn .01;

# UDamping ratio used for Rayleigh Damping
	set dampRat		0.050;		# Damping Ratio
	set dampRatF	1.0;		# Factor on the damping ratio.

# Define the periods to use for the Rayleigh damping calculations
	set periodForRayleighDamping_1 0.77;	# Mode 1 period - NEEDS to be UPDATED
	set periodForRayleighDamping_2 0.11;	# Mode 3 period - NEEDS to be UPDATED
	

# define p-delta columns and rigid links
	set TrussMatID 60000;		# define a material ID
	
# Define P-Delta Rigid Link Material
	uniaxialMaterial Elastic $TrussMatID 1.0;		# define truss material
	
	set Arigid 20000.0;		# define area of truss section (make much larger than A of frame elements)
	set Irigid 9000000.0;	# moment of inertia for p-delta columns  (make much larger than I of frame elements)
	set LargeStiff 1e6
# Define material for gap element at rocking spine
	set SpineBaseMatID 70000;
	set SpineBaseMatID2 80000;
	set SpineBaseVerticalCompressionStiff $LargeStiff; # Assuming 4ft square footing and 200 pci subgrade modulus
	set SpineBaseLateralStiff $LargeStiff; # Assuming 4ft square footing and 200 pci subgrade modulus
	set Negligible 1e-12

# Define material ID for columns and beam shear springs
	set ColumnShearSpringMatID 90000;
	
# Define very stiff uniaxial material
	set StiffMat 1200
	
# Define very stiff uniaxial material	
	set SoftMat 1300
	
	uniaxialMaterial Elastic $StiffMat $LargeStiff;		# define truss material
	uniaxialMaterial Elastic $SoftMat $Negligible;		# define truss material	
	# Define compression only material	
	set CompressionOnlyMat 700000;
	uniaxialMaterial ENT $CompressionOnlyMat $LargeStiff;		
	
puts "Variables Defined"