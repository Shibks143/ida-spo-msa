#----------------------------------------------------------------------------------#
# RedefineEverythingAneReSetUpModelSENSITIVITY
#		This module redefines all of the input parameters and re-sets up the 
#		analysis model.  This is just like the similar non-sensitivity file, except for
#		this file is called during a senstivity analysis so that is will alter the
#		sensitivity variable as appropriate before the next EQ is run.
#
#		This file is set up to run with the related Matlab driver file.
#
# Units: kips, in, sec
#
# This file developed by: Curt Haselton of Stanford University
# Date: 2 Oct 2003
#
# Other files used in developing this model:
#		none
##----------------------------------------------------------------------------------#

puts "Re-Setting up the model..."
		
source psb_DefineFunctionsAndProcedures.tcl
puts "Functions re-defined"

source psb_DefineUnitsAndConstants.tcl

source psb_DefineVariablesAtMeanValues.tcl
puts "Variables re-defined"

source psb_SetAnalysisOptions.tcl
puts "Analysis options are re-set"

# Jump out of the model folder into the sensitivity folder to see what variable needs to
#	be altered for the sensitivity analysis - at this point we are reading the file made
#	by the sensitivity file "RunAllSensitivityAnalyses.tcl" in the "Sensitivity Analysis" 
#	folder.

	set modelFolder [pwd] 
	# (11-21-15, PSB) Now modelFolder is model_eqNumber in specific model
	puts "modelFolder is $modelFolder"

	cd ..
# (11-21-15, PSB) now base directory is one more folder below hence extra cd ..
	cd ..
	set baseDirWhenDoingSens [pwd]
# (11-21-15, PSB) folder's name is changed to Prak_Sensitivity_Analysis
	cd $baseDirWhenDoingSens/psb_Sensitivity_Analysis
#	cd $baseDirWhenDoingSens/Sensitivity_Analysi

	cd sens_$eqNumber;	 # (11-21-15, PSB)
	source psb_VarDefinitionsFromMATLAB.tcl

	source psb_AlterVarForColSensMATLAB(made_by_RunCollapseSensitivityAnalysisMATLAB).tcl
	#puts "Variable $... altered to $..."

	# Alter the anlysisType name based on the information just extracted from the file
	set analysisType ($model)_($variableNameAlteredForSens)_($variableValueAlteredForSens)_($elementsUsedForModel);	
		#NOTE: This becomes the output folder name and is included in the 
		# output file name

#####

# Back to the model folder
cd ..
cd $modelFolder

set currenFolderForDiplay [pwd]
puts "the output in the line below should should look like .../\PrakRuns/\Models/\CivilBldg_3story_ID0001_v.01_trying/\model_120711 \n";
puts "CurrenFolder is $currenFolderForDiplay"

# Now source in a file that defines multiple values based on a single variable (this can
#	be used to vary things more easily with the sensitivity analyses).
# source DefineMultipleVariablesBasedOnOneVariable.tcl

source psb_SetUpModel.tcl
puts "Model is re-set up"

