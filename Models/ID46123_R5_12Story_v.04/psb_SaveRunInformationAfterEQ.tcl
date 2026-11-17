#----------------------------------------------------------------------------------#
# SaveRunInformationAfterEQ
#		This module saves information after the EQ runs (analysis settings, 
#		time that is took for analysis, etc.) 
#
# Units: kips, inches, seconds
#
# This file developed by: Curt Haselton of Stanford University
# Updated: 28 June 2005
# Date: 17 Sept 2003
#
# Other files used in developing this model:
#		Paul Cordova's Taiwan frame model (SU)
#----------------------------------------------------------------------------------#



		# Print some information about this specific run to the folder for this run - we need this to be in the 
		#	output directory, so go to that directory, put the files there, then come back to this directory.
			set startDir [pwd]
			cd ..
			cd ..
			
			set baseDir [pwd]
			cd $baseDir/Output/$analysisType/EQ_$eqNumber/Sa_$saTOneForRun
			set runDir [pwd]

			file mkdir RunInformation; 
			cd $runDir/RunInformation/

			set filename1 printFileForOpenStudio.txt
			print $filename1

#			set filename2 [open scaleFactorForRunOUT.out w]
#			puts $filename2 $scaleFactor 
#			close $filename2 
#
#			set filename3 [open sectionBeingUsedOUT.out w]
#			puts $filename3 $sectionsToUse 
#			close $filename3 

			set filename4 [open elementBeingUsedOUT.out w]
			puts $filename4 $elementsUsedForModel 
			close $filename4 

			set filename5 [open minutesToRunThisAnalysisOUT.out w]
			puts $filename5 $minutesToRunThisAnalysis 
			close $filename5 

			# Write the eigenvalues
			puts "(9-19-15) Not performing post-EQ eigen analysis- PSB"
# following command throws error and stops the code from running

#			puts "Starting post-EQ eigen analysis"
#			set eigenvaluesAfterEQ [eigen 6]
#			puts "Did post-EQ eigen analysis"
#			set filename6 [open eigenvaluesAfterEQOUT.out w]
#			puts $filename6 $eigenvaluesAfterEQ 
#			close $filename6 

			set filename7 [open geomTransfPrimaryOUT.out w]
			puts $filename7 $strGeomTransf 
			close $filename7 

			set filename7 [open geomTransfGravFrameOUT.out w]
			puts $filename7 $gravFrameGeomTranf 
			close $filename7 

			set filename8 [open testTypeUsedOUT.out w]
			puts $filename8 $testType
			close $filename8

#			set filename9 [open solutionAlgorithmUsedOUT.out w]
#			puts $filename9 $solutionAlgorithm
#			close $filename9 

#			set filename10 [open useGravityFrameOUT.out w]
#			puts $filename10 $useGravityFrame
#			close $filename10 
#
#			set filename11 [open useLeaningColumnOUT.out w]
#			puts $filename11 $useLeaningColumn
#			close $filename11 
#
#			set filename12 [open useJointModelsOUT.out w]
#			puts $filename12 $useJointModels
#			close $filename12 

			set filename13 [open defineJointRecordersOUT.out w]
			puts $filename13 $defineJointRecorders 
			close $filename13 

			set filename14 [open dtForAnalysisOUT.out w]
			puts $filename14 $dtForAnalysis
			close $filename14 

#			set filename15 [open eqFullLengthOUT.out w]
#			puts $filename15 [expr $dtForEQ($eqNumber) * $numPointsForEQ($eqNumber)]
#			close $filename15 

#			set filename16 [open gravFrameColTypeToUseOUT.out w]
#			puts $filename16 $gravFrameColTypeToUse 
#			close $filename16 

			if {$defineJointRecorders == 1} {
				set filename17 [open jointNumToRecordLISTOUT.out w]
				puts $filename17 $jointNumToRecordLIST
				close $filename17
			}

#			set filename18 [open concreteModelToUseForBeamsOUT.out w]
#			puts $filename18 $concreteModelToUseForBeams
#			close $filename18 
#
#			set filename19 [open concreteModelToUseForColumnsOUT.out w]
#			puts $filename19 $concreteModelToUseForColumns
#			close $filename19 
#
#			set filename20 [open modelForBondSpringsOUT.out w]
#			puts $filename20 $modelForBondSprings
#			close $filename20 

#			set filename22 [open useSeriesSpringWithBondAndPHOUT.out w]
#			puts $filename22 $useSeriesSpringWithBondAndPH 
#			close $filename22 
#
#			set filename23 [open useLEJointShearPanelOUT.out w]
#			puts $filename23 $useLEJointShearPanel
#			close $filename23 

			set filename24 [open onlyDefineLimitedRecForVariationsOUT.out w]
			puts $filename24 $onlyDefineLimitedRecForVariations 
			close $filename24 

#			set filename25 [open useLinearSectionShearOUT.out w]
#			puts $filename25 $useLinearSectionShear 
#			close $filename25

#			set filename26 [open useLinearBondOUT.out w]
#			puts $filename26 $useLinearBond 
#			close $filename26


			set filename27 [open findgroundDisplOUT.out w]
			puts $filename27 $findgroundDispl 
			close $filename27

# Save information that is also saved in "MatlabInformation", but save it here as well in the case that I changed analysis options
#	between runs.
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
	# Save the eigenvalues that were computed before the EQ
	set fileEight [open eigenvaluesBeforeEQOUT.out w]
	puts $fileEight $eigenvalues
	close $fileEight
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

## Output the number of integration points for disp-based element (this is output indepenet of element being used)
#	set fileSixteen [open numIntPointsDispEleOUT.out w]
#	puts $fileSixteen $nIntPtDispEle
#	close $fileSixteen 

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

# Output the solution algorithm being used for the PO
	set fileTwentyTwo [open POsolutionAlgorithmOUT.out w]
	puts $fileTwentyTwo $POsolutionAlgorithm
	close $fileTwentyTwo 

# Output the solution algorithm being used for the EQs
	set fileTwentyThree [open EQsolutionAlgorithmOUT.out w]
	puts $fileTwentyThree $EQsolutionAlgorithm
	close $fileTwentyThree 

# Output the damping information
	set fileTwentyThree [open dampingRatOUT.out w]
	puts $fileTwentyThree $dampRat
	close $fileTwentyThree 

	set fileTwentyThree [open dampingPeriodForRayleighDamping1OUT.out w]
	puts $fileTwentyThree $periodForRayleighDamping_1
	close $fileTwentyThree 

	set fileTwentyThree [open dampingPeriodForRayleighDamping2OUT.out w]
	puts $fileTwentyThree $periodForRayleighDamping_2
	close $fileTwentyThree 

# Output if the element end recorders are being use
	set fileTwenty [open defineElementEndSectionRecordersOUT.out w]
	puts $fileTwenty $defineElementEndSectionRecorders
	close $fileTwenty 

# Define a few other placeholders in case I want to alter this and make it work for NlBmCol model in the future
	set fileTwenty [open defineMaterialRecordersOUT.out w]
	puts $fileTwenty $defineMaterialRecorders 
	close $fileTwenty 

# (7-4-19, PSB) added to create a file with hinge around the joint in RunInformation folder
	
# In non-ductile model, if shear limit state material are being recorded, output the list of such Nodes
if {[info exists recordShearLimitState] == 1 && $recordShearLimitState == 1} {
	set fileTwentyFour [open nodeNumForShearHingeToRecordLISTOUT.out w]
	foreach nodeNumForShearHingeToRecord $nodeNumForShearHingeToRecordLIST {
		puts $fileTwentyFour $nodeNumForShearHingeToRecord 
	}
	close $fileTwentyFour 
}

# In non-ductile model, if flexural hinges around joint are being recorded, output the list of such hinges
if {[info exists recordEveryFlexSpring] == 1 && $recordEveryFlexSpring == 1} {
	set fileTwentyFive [open hingeAroundJointToRecordMLISTOUT.out w]
	foreach hingeAroundJointToRecordM $hingeAroundJointToRecordMLIST {
		puts $fileTwentyFive $hingeAroundJointToRecordM 
	}
	close $fileTwentyFive 

	set fileTwentySix [open hingeAroundJointToRecordMVLISTOUT.out w]
	foreach hingeAroundJointToRecordMV $hingeAroundJointToRecordMVLIST {
		puts $fileTwentySix $hingeAroundJointToRecordMV 
	}
	close $fileTwentySix 
}
	



cd $startDir 
			
# end of file output

