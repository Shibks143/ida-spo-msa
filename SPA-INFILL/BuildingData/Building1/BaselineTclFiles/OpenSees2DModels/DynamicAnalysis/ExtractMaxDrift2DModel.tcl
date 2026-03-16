# ExtractMaxDrift2DModel ########################################################################
#
# Procedure that extracts the maximum story drift
#
# Developed by Henry Burton
#
# First Created: 09/22/2013
# 
#
# #######################################################################################

proc ExtractMaxDrift2DModel {numStories pathToOutputFile} {

 global maximumStoryDrift
 set maximumStoryDrift 0.0
 
 for {set story 1} { $story<=$numStories} {incr story} {
	set maxDriftOutputFile [open $pathToOutputFile/StoryDrifts/Story$story.out r];
	while {[gets $maxDriftOutputFile line] >= 0} {
		set drift [lindex $line 1];
		if {[expr abs($drift)] > $maximumStoryDrift} {
			set maximumStoryDrift [expr abs($drift)];
		}
		}
		close $maxDriftOutputFile
	}
 }
