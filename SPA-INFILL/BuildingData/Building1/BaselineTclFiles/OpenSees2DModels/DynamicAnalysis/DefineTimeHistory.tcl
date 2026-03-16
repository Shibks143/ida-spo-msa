# Ground motion scale factor
set scalefactor [expr $g*$scale/100*$MCE_SF];

source DynamicAnalysisCollapseSolver.tcl

source DefineDynamicAnalysisParameters2DModel.tcl


############ LATERAL LOADS ##############
set GM_dt $dt; #($eqNumber);
set GM_numPoints $numPoints; #($eqNumber);
set GM_FileName "histories/$eqFileName($eqNumber)";

set Gaccel "Series -dt $GM_dt -filePath $GM_FileName -factor $scalefactor"
pattern UniformExcitation  2   1  -accel   $Gaccel
#########################################

		
	# Call Dynamic Analysis Solver and run for collapse tracing
		set currentTime [getTime];
		set dtAn [expr 0.5*$GM_dt];		# timestep of initial analysis	
		set GMtime [expr $GM_dt*$GM_numPoints];
		set firstTimeCheck [clock seconds];
		
		
		
#                            input Motion  simul. step  duration numStories Drift Limit    List Nodes    StoryH 1   StoryH Typical    Analysis Start Time
DynamicAnalysisCollapseSolver    $GM_dt  	$dtAn       $GMtime  $NStories     0.10   	   $FloorNodes   $HFirstStory    $HTypicalStory          $firstTimeCheck

