#----------------------------------------------------------------------------------#
# SetUpModel
#	This module sets up the model based on the previously defined variables.
#	When archetype models are used, this is where most of the information
#	will be pasted.
#
# Units: kN, mm, seconds
#
# This file developed by: Curt Haselton of Stanford University (28 June 2005)
# Modified by: Prakash S Badal of IIT Bombay
# Date: 20 Mar 2016
#
#----------------------------------------------------------------------------------#

#########################################
# Define the model builder for 2D models
model BasicBuilder -ndm 2 -ndf 3
#########################################

# Define a few materials not defined by the model code from VBA
	# Define the elastic material used for the SDOF to record ground displacement
	set groundDisplT 88888
	uniaxialMaterial Elastic $groundDisplT $groundDisplMatK

	# Stiff elastic strut material (used as rigid links)
	set strutMatT	599; 	# To agree with leaning column numbering
	uniaxialMaterial Elastic $strutMatT $E_strut

	# Make an elastic material for testing while building the model (this is also used for the joint bond-slip springs that are not connected to anything)
	set elastJointMatT	49999; 	# To agree with joint numbering
	uniaxialMaterial Elastic $elastJointMatT $E_elasticTestMaterial

# Define a node needed by the ground displacement recorder (not defined by VBA code), fix one of 
#	the nodes, define the spring to use, then apply the mass.
	if {($findgroundDispl == 1)} {
		node 88001 [expr 0.0] [expr 0.0]
		node 88002 [expr 0.0] [expr 0.0]
		fix 88001 1 1 1
		transSpring2D 88888 88001 88002 $groundDisplT 
		#set largeGDMass 2533030; #units are kips-s^2/in
		set largeGDMass 5e+5; #units are kN-s^2/mm
 		mass 88002 $largeGDMass 0 0 
	}

# Set up the geometeric transformations here, so they won't need to be made by the VBA code
	# Geometric transformation - for everything but the gravity frame
	set primaryGeomTransT 1
	geomTransf $strGeomTransf $primaryGeomTransT 
	# Geometric transformation - for the gravity frame
	set gravFrameGeomTranfT 2
	geomTransf $gravFrameGeomTranf $gravFrameGeomTranfT 

# Source the code pasted from Excel VBA
	source psb_ModelCodePastedFromExcelVBA.tcl

# Do gravity load analysis

# (01-04-16, PSB) RECORDER BELOW IS TEMPORARY COMMAND. REMOVE FOR TIME-HISTORY/PUSHOVER ANALYSIS
#	source Prak_GravityRecorder.tcl

	source psb_PeformGravityLoadAnalysis.tcl 	





