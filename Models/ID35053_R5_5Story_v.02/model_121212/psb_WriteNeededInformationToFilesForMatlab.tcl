#----------------------------------------------------------------------------------#
# WriteNeededInformationToFilesForMatlab
#		In this module, information is written to files for Matlab to open and 
#			use.  This information is mostly input information, but some 
#			calculated information may be included as well.
#
# Units: kN, mm, seconds
#
# This file developed by: Curt Haselton of Stanford University (28 June 2005)
# Modified by: Prakash S Badal of IIT Bombay
# Date: 18 Mar 2016
#
#----------------------------------------------------------------------------------#

# Go into the output directory
	cd ..
	cd ..;	#Gets to main directory
	set currentDir [pwd]
	cd $currentDir/Output/

# Make a new directory for this anlaysisType if one does nto exist
	file mkdir $analysisType; 	#This makes the directory for the analysis (for the case that the folder is not made yet)
	cd $currentDir/Output/$analysisType 
	puts "Current Directory is: $currentDir"

# Creat new directory for all of these output files to go into
	file mkdir MatlabInformation
	cd $currentDir/Output/$analysisType/MatlabInformation

# Make print file to save much of the information about the model
	print printFile.out

# UPDTE THIS TO BE FOR THE NON-FORMATTED RECORD
# Write EQ name information to a file

# (3-23-16, PSB) obsolete here	
#	set fileOne [open eqNumberToRunLISTOUT.out w]
#	foreach eqNumberTemp $eqNumberToRunLISTFormattedRec {
#		puts $fileOne "$eqNumberTemp"
#	}
#	close $fileOne

# (3-23-16, PSB) obsolete here	
# Write Sa levels that were used in analysis to a file
#	set fileTwo [open saTOneForRunLISTOUT.out w]
#	foreach saTOneForRun $saTOneForRunLISTFormattedRec {
#		puts $fileTwo $saTOneForRun
#	}
#	close $fileTwo

# Output the LIST of elements to record
	set fileFour [open elementNumToRecordLISTOUT.out w]
	foreach eleNum $elementNumToRecordLIST {
		puts $fileFour $eleNum
	}
	close $fileFour

# Output the node numbers that were recorded
	set fileFive [open nodeNumToRecordLISTOUT.out w]
	foreach nodeNum $nodeNumToRecordLIST {
		puts $fileFive $nodeNum
	}
	close $fileFive

# Output the node numbers associated with each floor
	set fileSix [open nodeNumsAtEachFloorLISTOUT.out w]
	foreach nodeNum $nodeNumsAtEachFloorLIST {
		puts $fileSix $nodeNum
	}
	close $fileSix

# Write the PO control node number
	set fileSeven [open poControlNodeNumOUT.out w]
	puts $fileSeven $poControlNodeNum
	close $fileSeven

# Write whther or not the eigne analysis is being done...
	set fileSevenB [open runEigenAnalysisForMatlabOUT.out w]
	puts $fileSevenB $runEigenAnalysisForMatlab
	close $fileSevenB


if {$runEigenAnalysisForMatlab == 1} {

	puts "CHECK: Running Eigen Analysis for Matlab"

	# Notice: I have not been able to get this eigenvector stuff to work well, but I am just leaving it 
	#	here as a placeholder.

	# EIGENVALUE(S)

	# Write the eigenvalues
		puts "Starting eigen analysis"
		set eigenvalues [eigen $numModeRequested]; # numModeRequested is defined in psb_DefineVariablesAtMeanValues.tcl file
		puts "Did first eigen analysis"
		set fileEight [open eigenvaluesOUT.out w]
		puts $fileEight $eigenvalues
		close $fileEight

	# EIGENVECTOR(S)
# (4-28-16, PSB) Included eigenvector determination part in the code
puts "Starting eigen Vector analysis"

set fileEightB [open eigenVectorOUT.out w]; 

set numLevels [llength $nodeNumsAtEachFloorLIST];
puts "numLevels is $numLevels";

for {set currLevelNum 0} {$currLevelNum < $numLevels} {incr currLevelNum 1} {
	for {set modeNum 1} {$modeNum <= $numModeRequested} {incr modeNum 1} {
		set currentMode [expr $modeNum]
	
		if {$currLevelNum == 0} {
			set currentNode 201011
		} else {
			set currentNode [lindex $nodeNumsAtEachFloorLIST $currLevelNum]
		}

		set dofOfInterest 1
		set eigVectorLIST($currLevelNum,[expr $modeNum - 1]) [nodeEigenvector $currentNode $currentMode $dofOfInterest];
#	puts "currLevelNum is $currLevelNum currentMode is $currentMode currentNode is $currentNode \n";
#	puts $eigVectorLIST($currLevelNum,[expr $modeNum - 1])
	puts -nonewline $fileEightB $eigVectorLIST($currLevelNum,[expr $modeNum - 1])
   }
   	puts -nonewline $fileEightB "\n"
 }
	puts "Determined eigen Vectors."
}

# Output the floor heights associated with each floor
	set fileTen [open floorHeightLISTOUT.out w]
	foreach floorHeight $floorHeightsLIST {
		puts $fileTen $floorHeight 
	}
	close $fileTen

# Output the list of base columns to compute the base shear
	set fileEleven [open columnNumsAtBaseLISTOUT.out w]
	foreach columnNum $columnNumsAtBaseLIST {
		puts $fileEleven $columnNum
	}
	close $fileEleven

# Output the element type being used for this analysis
	set fileTwelve [open elementBeingUsedForAnalysisOUT.out w]
		puts $fileTwelve $elementsUsedForModel 
	close $fileTwelve 

# Output the analysis type (full name - should be the output folder name)
	set fileThirteen [open analysisTypeOUT.out w]
		puts $fileThirteen $analysisType
	close $fileThirteen 

## Output if we are using the leaning column or not
#	set fileFourteen [open usingLeaningColumnOUT.out w]
#		puts $fileFourteen $useLeaningColumn 
#	close $fileFourteen 

# Output if the Hyst hinge recorders are being use
	set fileNineteen [open defineHystHingeRecordersOUT.out w]
	puts $fileNineteen $defineHystHingeRecorders 
	close $fileNineteen 

# If hyst hinge recorders are being used, output the list on hinge numbers to record...
if {$defineHystHingeRecorders == 1} {
	set fileTwentyOne [open hingeElementsToRecordLISTOUT.out w]
	foreach hingeElementsToRecord $hingeElementsToRecordLIST {
		puts $fileTwentyOne $hingeElementsToRecord 
	}
	close $fileTwentyOne 
} else {
	# Just write a dummy file so that there is not an error when Matlab looks for this file
	set fileTwentyOne [open hingeElementsToRecordLISTOUT.out w]
	set junkValue -1.0
	puts $fileTwentyOne $junkValue
	close $fileTwentyOne 
}


# Output steel model being used - added 12-6-05 AFTER many of the analysis were DONE
	set fileTwenty [open columnNumsAtEachStoryLISTOUT.out w]
	puts $fileTwenty $columnNumsAtEachStoryLIST 
	close $fileTwenty 

# Output column number lists at each floor - added 12-8-05
	set fileTwentyOne [open columnNumsAtEachStoryLISTOUT.out w]
	foreach colNumAtFloorLIST $columnNumsAtEachStoryLIST {
		puts $fileTwentyOne $colNumAtFloorLIST 
	}
	close $fileTwentyOne 

# Output if the element end recorders are being use
	set fileTwenty [open defineElementEndSectionRecordersOUT.out w]
	puts $fileTwenty $defineElementEndSectionRecorders
	close $fileTwenty 

# Define a few other placeholders in case I want to alter this and make it work for NlBmCol model in the future
	set fileTwenty [open defineMaterialRecordersOUT.out w]
	puts $fileTwenty $defineMaterialRecorders 
	close $fileTwenty 

# Define the period used for ground motion scaling (from MATLAB).  NOTICE - this was
#	added for collapse analyses run by Matlab.  I added a dummy value of "-1" 
#	to the Opensees model, so if we run stripe analyses without using Matlab, this 
#	value should be the dummy of "-1" and avoid an error (this has not been tested 
#	though) (6-30-06)
	set fileTwenty [open periodUsedForScalingGroundMotionsFromMatlabOUT.out w]
	puts $fileTwenty $periodUsedForScalingGroundMotionsFromMatlab
	close $fileTwenty 



# Go back to model directory
cd $currentDir/Models/$model


