source DefineDynamicAnalysisParameters3DModel.tcl
source DynamicAnalysisBiDirectionCollapseSolver.tcl
source DynamicAnalysisCollapseSolver.tcl\

# Ground motion parameters
set GM_dt $dt; #($eqNumber);
set GM_numPoints $numPoints; #($eqNumber);
set GMX_FileName "histories/$eqFileName($eqXNumber)";
set GMZ_FileName "histories/$eqFileName($eqZNumber)";
set GaccelX "Series -dt $GM_dt -filePath $GMX_FileName -factor $scalefactor"
set GaccelZ "Series -dt $GM_dt -filePath $GMZ_FileName -factor $scalefactor"
pattern UniformExcitation  2   1  -accel   $GaccelX
pattern UniformExcitation  3   3  -accel   $GaccelZ

# Call Dynamic Analysis Solver and run for collapse tracing
set currentTime [getTime];
set dtAn [expr 0.5*$GM_dt];		# timestep of initial analysis	
set GMtime [expr $GM_dt*$GM_numPoints];
set firstTimeCheck [clock seconds];	
		
		
		
# input Motion  simul. step  duration numStories Drift Limit    List Nodes    StoryH 1   StoryH Typical    Analysis Start Time
DynamicAnalysisBiDirectionCollapseSolver    $GM_dt  	$dtAn       $GMtime  $NStories     0.1   	   $FloorNodes   $HFirstStory    $HTypicalStory          $firstTimeCheck

# input Motion  simul. step  duration numStories Drift Limit    List Nodes    StoryH 1   StoryH Typical    Analysis Start Time
# DynamicAnalysisCollapseSolver    $GM_dt  	$dtAn       $GMtime  $NStories     0.05   	   $FloorNodes   $HFirstStory    $HTypicalStory          $firstTimeCheck     $groundMotionDirection