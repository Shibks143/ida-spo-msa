#----------------------------------------------------------------------------------#
# DefineAllRecorders
#		Recorders are defined for nodes, elements, and PHR's.  Recorders can 
#			also be created for strains, curvatures, etc (for fiber model).
#           The recorders that are defined here depend on the input in the 
#			"SetAnalysisOptions.tcl" file.
#			
# Units: kN, mm, sec 
#
# This file developed by: Curt Haselton of Stanford University
# Revised for personal use by: Prakash Singh of IIT Bombay
# Date: 28 Mar 2016
#
# Other files used in developing this model:
#		test_simPlanned by Paul Cordova of Stanford University
#----------------------------------------------------------------------------------#

# Go into the output directory and created needed folders for the output
	cd ..
	cd ..;	# Go up two directories to get to the main folder

	# cd ..; # (03-08-16) This cd should not be here for Pushover, but is required for time history.
 	 # hence suppressed in the file named psb_RunSingleColRecordSensMATLAB.tcl 
	 # See right before source psb_DefineAllRecorders.tcl command in psb_RunSingleColRecordSensMATLAB.tcl

	set baseDir [pwd];			#Sets baseDir as the current directory
	cd $baseDir/Output/
	file mkdir Conv_Warning_Files; 	# Make a folder for the convergence warning files (this is remade for every run, but this should be alright)
	file mkdir $analysisType; 
	cd $baseDir/Output/$analysisType;  	#NOTICE: other folder is made in the "Write...Matlab" module
	#puts "Current Directory is: $currentDir"

	# Notice that even though we recreate the directory, it doesn't erase previous info in the directory!
	# Note that the order of these directories was changed on 5-7-04
	file mkdir EQ_$eqNumber; 	# This command (mkdir) makes a folder
	cd $baseDir/Output/$analysisType/EQ_$eqNumber

	file mkdir Sa_$saTOneForRun; 	# This command makes a folder
	cd $baseDir/Output/$analysisType/EQ_$eqNumber/Sa_$saTOneForRun

	# Create new directory for all of this output to go into - Nodes, then Elements
	file mkdir Nodes
	cd $baseDir/Output/$analysisType/EQ_$eqNumber/Sa_$saTOneForRun/Nodes
	file mkdir DisplTH
	file mkdir AccelTH
	file mkdir GroundDisplTH

	cd $baseDir/Output/$analysisType/EQ_$eqNumber/Sa_$saTOneForRun
	file mkdir Elements
	cd $baseDir/Output/$analysisType/EQ_$eqNumber/Sa_$saTOneForRun/Elements
	file mkdir EleLocalTH
	file mkdir EleGlobalTH
	file mkdir EleForceDefTH
	file mkdir ElePHRTH
	file mkdir EleEndSecRec
	file mkdir Hinges
	file mkdir Joints

	cd $baseDir/Output/$analysisType/EQ_$eqNumber/Sa_$saTOneForRun
	file mkdir MaterialRecorders

# Make print file
print printFile.out

################## Recorders ################################################################################

# NOTICE: All recorder names updated on 7-14-06 to have shorter names (this also makes the filenames work for UNIX).

if {$defineRecorders == "YES"} {

############## NODES #########################################################################################
# TH displ's and accels - for only a list of nodes or for all nodes ------------------------------------
if {$recordNodesInList == "YES"} {
	# TH displacements and accelerations
	cd $baseDir/Output/$analysisType/EQ_$eqNumber/Sa_$saTOneForRun/Nodes/DisplTH
	foreach nodeNum $nodeNumToRecordLIST {
		#recorder Node -file ($analysisType)_EQ_($eqNumber)_Sa_($saTOneForRun)_THNodeDispl_$nodeNum.out -time -node $nodeNum -dof 1 2 3 disp
		recorder Node -file THNodeDispl_$nodeNum.out -time -node $nodeNum -dof 1 2 3 disp
	}

	cd $baseDir/Output/$analysisType/EQ_$eqNumber/Sa_$saTOneForRun/Nodes/AccelTH
	foreach nodeNum $nodeNumToRecordLIST {
		#recorder Node -file ($analysisType)_EQ_($eqNumber)_Sa_($saTOneForRun)_THNodeAccel_$nodeNum.out  -time -node $nodeNum -dof 1 2 3 accel
		recorder Node -file THNodeAccel_$nodeNum.out  -time -node $nodeNum -dof 1 2 3 accel
	}
}


if {$findgroundDispl == 1.0} {
	cd $baseDir/Output/$analysisType/EQ_$eqNumber/Sa_$saTOneForRun/Nodes/GroundDisplTH
	foreach nodeNum $groundDisplLIST {
		#recorder Node -file ($analysisType)_EQ_($eqNumber)_Sa_($saTOneForRun)_GroundDispl_$nodeNum.out -time -node $nodeNum -dof 1 disp
		recorder Node -file GroundDispl_$nodeNum.out -time -node $nodeNum -dof 1 disp
	}
}

############## ELEMENTS #########################################################################################

# Record the element force responses, if I am not limiting the recorders.
if {$onlyDefineLimitedRecForVariations != 1} {

	#puts "Check: Defining element recorders"

	# Element force time histories - local coordinates
		puts "Defining element local force recorders..."
		cd $baseDir/Output/$analysisType/EQ_$eqNumber/Sa_$saTOneForRun/Elements/EleLocalTH
		set currentDir [pwd]
	

		# Do recorders for all element types other than the generlaizesYieldSurface by Kaul and Deierlein
		foreach eleNum $elementNumToRecordLIST {
			# Removed 6-15-06 to save hard drive space
	# recorder Element $eleNum   -file ($analysisType)_EQ_($eqNumber)_Sa_($saTOneForRun)_THEleLocal_$eleNum.out  localForces
	recorder Element -file THEleLocal_$eleNum.out -ele $eleNum localForces 
	recorder Element -file THEleLocalWithTime_$eleNum.out -time -ele $eleNum localForces 

# (9-19-2015) modified this command line as per new recorder command -PSB

	}

}

# Element force time histories - global coordinates; it records only the columns at the base of the building (for base shear calcs.)
	puts "Defining element global force recorders..."
	cd $baseDir/Output/$analysisType/EQ_$eqNumber/Sa_$saTOneForRun/Elements/EleGlobalTH

	# OLD - I took this out in place of the new recorder method for all stories (removed 9-12-05)
#	# Do recorders for all element types other than the generlaizesYieldSurface by Kaul and Deierlein
#	foreach eleNum $columnNumsAtBaseLIST {
#		recorder Element $eleNum   -file ($analysisType)_EQ_($eqNumber)_Sa_($saTOneForRun)_THEleGlobal_$eleNum.out  globalForces
#	}

	# Do global element force recorders for all columns of each floor (for global and story pushover calculations) (added 9-12-05)
	foreach colNumForSingleStoryLIST $columnNumsAtEachStoryLIST {
		foreach colNum $colNumForSingleStoryLIST {
			# Define a single recorder
			#recorder Element $colNum -file ($analysisType)_EQ_($eqNumber)_Sa_($saTOneForRun)_THEleGlobal_$colNum.out  globalForces
	recorder Element -file THEleGlobal_$colNum.out -ele $colNum globalForces 
# (9-19-2015) modified this command line as per new recorder command -PSB
		}
	}



# Make recorders for the JOINT elements
if {$defineJointRecorders == 1} {
	puts "Defining joint recorders..."
	cd $baseDir/Output/$analysisType/EQ_$eqNumber/Sa_$saTOneForRun/Elements/Joints
	set currentDir [pwd]

	foreach jointNum $jointNumToRecordLIST {
		# See Appendix B of Altoontash thesis for reference
	# recorder Element $jointNum -file Joint_ForceAndDef_$jointNum.out defoANDforce
	recorder Element -file Joint_ForceAndDef_$jointNum.out -ele $jointNum defoANDforce 
# (9-19-2015) modified this command line as per new recorder command -PSB
	}

} else {
	puts "NOTICE: The JOINT recorders are NOT being defined."
}


# Define the hysteretic hinge recorders
if {($defineHystHingeRecorders == 1)} {
	puts "Defining hinge element recorders..."
	cd $baseDir/Output/$analysisType/EQ_$eqNumber/Sa_$saTOneForRun/Elements/Hinges
	foreach hingeEleNum $hingeElementsToRecordLIST {
	#recorder Element $hingeEleNum -file ($analysisType)_EQ_($eqNumber)_Sa_($saTOneForRun)_HingeForceTH_$hingeEleNum.out force
	#recorder Element $hingeEleNum -file ($analysisType)_EQ_($eqNumber)_Sa_($saTOneForRun)_HingeRotTH_$hingeEleNum.out deformatio
	
	# recorder Element $hingeEleNum -file HingeForceTH_$hingeEleNum.out force
	# recorder Element $hingeEleNum -file HingeRotTH_$hingeEleNum.out deformation

	recorder Element -file HingeForceTH_$hingeEleNum.out -ele $hingeEleNum force 
	recorder Element -file HingeRotTH_$hingeEleNum.out -ele $hingeEleNum deformation 
# (9-19-2015) modified this command line as per new recorder command -PSB
	}
}


###################################################################################################
###################################################################################################
# Recorder used for fiber analyses
###################################################################################################

# Define PH rotation recorders for all elements, if we are using the fiber model (for clough, the PHR is in the joint recorders)
# Only define for the nlBmCol of displBmCol elements
if {$elementsUsedForModel == "nonlinearBeamColumn"} {
	puts "Defining fiber element PHR recorders..."
	cd $baseDir/Output/$analysisType/EQ_$eqNumber/Sa_$saTOneForRun/Elements/ElePHRTH
	foreach eleNum $elementNumToRecordLIST {
		#recorder Element $eleNum   -file ($analysisType)_EQ_($eqNumber)_Sa_($saTOneForRun)_THPHR_$eleNum.out  plasticRotation
		# recorder Element $eleNum   -file THPHR_$eleNum.out  plasticRotation

	recorder Element -file THPHR_$eleNum.out  -ele $eleNum plasticRotation
# (9-19-2015) modified this command line as per new recorder command -PSB
	}
}

# Define element end section recorders
if {$defineElementEndSectionRecorders == 1} {
	# I am not defining any of these recorders now
}


# Define Material Recorders - This is done manually for a single element, is just for the fiber model, and 
#	is primarily for testing.
if {($defineMaterialRecorders == 1) && ($elementsUsedForModel == "nonlinearBeamColumn")} {
	puts "Defining material stress-strain recorders..."
	cd $baseDir/Output/$analysisType/EQ_$eqNumber/Sa_$saTOneForRun/MaterialRecorders

	# Define Material recorders

	# Cover Concrete
	set zCoverCFib 0;
	set yCoverCFib 19.0;

	# Confined Concrete
	set zConfCFib 0;
	set yConfCFib [expr 19.0 - $bmCover - 1.0];
	# Steel
	set zTSFib 0;
	set yTSFib [expr 19.0 - $bmCover];

	# Confined concrete
#	recorder Element 18  -file Element18EndiConfConcStressTop.out 	-time section 1 		fiber $yConfCFib 			$zConfCFib stressStrain
#	recorder Element 18  -file Element18EndiConfConcStressBottom.out 	-time section 1 		fiber [expr -$yConfCFib] 	$zConfCFib stressStrain
#	recorder Element 18  -file Element18EndjConfConcStressTop.out 	-time section $nIntPt 	fiber $yConfCFib 			$zConfCFib stressStrain
#	recorder Element 18  -file Element18EndjConfConcStressBottom.out 	-time section $nIntPt 	fiber [expr -$yConfCFib] 	$zConfCFib stressStrain

	recorder Element -file Element18EndiConfConcStressTop.out -time -ele 18 section 1 fiber $yConfCFib $zConfCFib stressStrain
	recorder Element -file Element18EndiConfConcStressBottom.out -time -ele 18 section 1 fiber [expr -$yConfCFib] 	$zConfCFib stressStrain
	recorder Element -file Element18EndjConfConcStressTop.out -time -ele 18 section $nIntPt fiber $yConfCFib $zConfCFib stressStrain
	recorder Element -file Element18EndjConfConcStressBottom.out -time -ele 18 section $nIntPt fiber [expr -$yConfCFib] $zConfCFib stressStrain
# (9-19-2015) modified this command line as per new recorder command -PSB


	# Cover concrete
#	recorder Element 18  -file Element18EndiCoverConcStressTop.out 	-time section 1 		fiber $yCoverCFib 		$zCoverCFib stressStrain
#	recorder Element 18  -file Element18EndiCoverConcStressBottom.out -time section 1 		fiber [expr -$yCoverCFib ] 	$zCoverCFib stressStrain
#	recorder Element 18  -file Element18EndjCoverConcStressTop.out 	-time section $nIntPt 	fiber $yCoverCFib 		$zCoverCFib stressStrain
#	recorder Element 18  -file Element18EndjCoverConcStressBottom.out -time section $nIntPt 	fiber [expr -$yCoverCFib ] 	$zCoverCFib stressStrain


#	recorder Element 18  -file Element18EndiSteelStressBottom.out 	-time section 1 		fiber [expr -$yTSFib] 		$zTSFib stressStrain
#	recorder Element 18  -file Element18EndiSteelStressTop.out 		-time section 1 		fiber [expr +$yTSFib] 		$zTSFib stressStrain
#	recorder Element 18  -file Element18EndjSteelStressBottom.out 	-time section $nIntPt 	fiber [expr -$yTSFib] 		$zTSFib stressStrain
#	recorder Element 18  -file Element18EndjSteelStressTop.out 		-time section $nIntPt 	fiber [expr +$yTSFib] 		$zTSFib stressStrain


	recorder Element -file Element18EndiCoverConcStressTop.out -time -ele 18 section 1 fiber $yConfCFib $zConfCFib stressStrain
	recorder Element -file Element18EndiCoverConcStressBottom.out -time -ele 18 section $nIntPt fiber [expr -$yConfCFib] $zConfCFib stressStrain
	recorder Element -file Element18EndjCoverConcStressTop.out -time -ele 18 section $nIntPt fiber $yConfCFib $zConfCFib stressStrain
	recorder Element -file Element18EndjCoverConcStressBottom.out -time -ele 18 section $nIntPt fiber [expr -$yConfCFib] $zConfCFib stressStrain

	recorder Element -file Element18EndiSteelStressBottom.out -time -ele 18 section 1 fiber [expr -$yTSFib] $zTSFib stressStrain
	recorder Element -file Element18EndiSteelStressTop.out -time -ele 18 section 1 fiber [expr +$yTSFib] $zTSFib stressStrain
	recorder Element -file Element18EndjSteelStressBottom.out -time -ele 18 section $nIntPt fiber [expr -$yTSFib] $zTSFib stressStrain
	recorder Element -file Element18EndjSteelStressTop.out -time -ele 18 section $nIntPt fiber [expr -$yTSFib] $zTSFib stressStrain

	# (9-19-2015) modified this command line as per new recorder command -PSB


}

}; # Why is this here???


# Define the recorders for section level responses in the fiber model, if I am not limiting the recorders.
if {$onlyDefineLimitedRecForVariations != 1} {
	# Do recorders for force and deformation of the end SECTIONS of each element - Records all in element to record list
	# Note - this recorder outputs four columns of data as follows: axial strain, curvature, axial force, moment
	# Note - the number of integration points is different to force/disp based elements, so differentiate between
	#	which element is being used.
	# This is only done if the fiber model is being used.
	if {$defineElementEndSectionRecorders == 1} {
		# Only do this if the fiber model is being used
		if {$elementsUsedForModel == "nonlinearBeamColumn"} {
			set nIntPt $nIntPtForceEle
			puts "Defining fiber element force-deformation recorders..."

			cd $baseDir/Output/$analysisType/EQ_$eqNumber/Sa_$saTOneForRun/Elements/EleForceDefTH
			set currentDir [pwd]
			foreach eleNum $elementNumToRecordLIST {
				#recorder Element $eleNum   -file ($analysisType)_EQ_($eqNumber)_Sa_($saTOneForRun)_THEleForceDef_endi_$eleNum.out section 1 forceAndDeformation
				#recorder Element $eleNum   -file ($analysisType)_EQ_($eqNumber)_Sa_($saTOneForRun)_THEleForceDef_endj_$eleNum.out section $nIntPt forceAndDeformation
				
# recorder Element $eleNum   -file THEleForceDef_endi_$eleNum.out section 1 forceAndDeformation
# recorder Element $eleNum   -file THEleForceDef_endj_$eleNum.out section $nIntPt forceAndDeformation

recorder Element -file THEleForceDef_endi_$eleNum.out section 1 -ele $eleNum forceAndDeformation
recorder Element -file THEleForceDef_endj_$eleNum.out section $nIntPt -ele $eleNum forceAndDeformation
# (9-19-2015) modified this command line as per new recorder command -PSB

			}
		} else {
			puts "NOTICE: The end section forceAndDeformation recorders aren't being defined AT ALL."
		}
	}
}


############## End recorders ###################################

######################################################
# Source in some commands to display the model
if {$displayMode == "displayON"} {
#	# a window to plot the nodal displacements versus load for node 36
#	recorder plot Node_$name.out Node3Xdisp 10 340 300 300 -columns 4 1 -columns 3 1 -columns 2 1	

	# a window showing the displaced shape
	recorder display g3 10 10 600 600 -wipe

	# next three commmands define viewing system, all values in global coords
	vrp 0.0 300.0 0;    # point on the view plane in global coord, center of local viewing system
	vup 0 1 0 ;           # dirn defining up direction of view plane
	vpn 0 0 1;            # direction of outward normal to view plane

	# next three commands define view, all values in local coord system
	prp 0 0 100;                   # eye location in local coord sys defined by viewing system
#	viewWindow -1600 1600 -600 1200;  # view bounds uMin, uMax, vMin, vMax in local coords
	viewWindow -12000 70000 -1000 32000;  # view bounds uMin, uMax, vMin, vMax in local coords
	plane 0 150;                   # distance to front and back clipping planes from eye
	projection 0;                  # projection mode

	port -1 1 -1 1;                # area of window that will be drawn into
	fill 1;                        # fill mode
	display 1 0 10;                
}
######################################################

# Go back to the model folder
cd $baseDir/Models/$model
