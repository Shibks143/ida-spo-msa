############ LATERAL LOADS ##############
set GM_dt $dt; #($eqNumber);
set GM_numPoints $numPoints; #($eqNumber);
set GM_FileName "histories/$eqFileName($eqNumber)";

set Gaccel "Series -dt $GM_dt -filePath $GM_FileName -factor $scalefactor"
pattern UniformExcitation  2   $groundMotionDirection  -accel   $Gaccel
#########################################

# Call Dynamic Analysis Solver and run for collapse tracing
set currentTime [getTime];
set dtAn 1.4662e-007; #[expr 0.5*$GM_dt];		# timestep of initial analysis	
set GMtime [expr $GM_dt*$GM_numPoints];
set firstTimeCheck [clock seconds];

constraints Transformation;
numberer RCM;
system UmfPack;
algorithm Linear;
integrator CentralDifference;
analysis Transient;

set dt_analysis $dtAn;    			                # timestep of analysis
set NumSteps [expr round(($GMtime + 0.0)/$dt_analysis)];	# number of steps in analysis
set ok [analyze $NumSteps $dt_analysis];
