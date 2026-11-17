#----------------------------------------------------------------------------------#
# RedefineEverythingAneReSetUpModel
#		This module redefines all of the input parameters and re-sets up the 
#		analysis model.
#
# Units: kips, in, sec
#
# This file developed by: Curt Haselton of Stanford University
# Updated: 28 June 2005
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

# Now source in a file that defines multiple values based on a single variable (this can
#	be used to vary things more easily with the sensitivity analyses).
#source DefineMultipleVariablesBasedOnOneVariable.tcl

source psb_SetUpModel.tcl
puts "Model is re-set up"

