source DefineDynamicAnalysisParameters3DModel.tcl
source DynamicAnalysisCollapseSolver.tcl


############ LATERAL LOADS ##############
set GM_dt $dt; #($eqNumber);
set GM_numPoints $numPoints; #($eqNumber);
set GM_FileName "histories/$eqFileName($eqNumber)";

set Gaccel "Series -dt $GM_dt -filePath $GM_FileName -factor $scalefactor"
pattern UniformExcitation  2   $groundMotionDirection  -accel   $Gaccel
#########################################

		
# Call Dynamic Analysis Solver and run for collapse tracing
set currentTime [getTime];
set dtAn [expr 0.5*$GM_dt];		# timestep of initial analysis	
set GMtime [expr $GM_dt*$GM_numPoints];
set firstTimeCheck [clock seconds];	
		
		
		
# input Motion  simul. step  duration numStories Drift Limit    List Nodes    StoryH 1   StoryH Typical    Analysis Start Time
DynamicAnalysisCollapseSolver    $GM_dt  	$dtAn       $GMtime  $NStories     0.05   	   $FloorNodes   $HFirstStory    $HTypicalStory          $firstTimeCheck     $groundMotionDirection


