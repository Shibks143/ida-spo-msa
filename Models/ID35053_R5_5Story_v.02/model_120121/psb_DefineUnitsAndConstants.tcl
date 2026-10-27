#----------------------------------------------------------------------------------#
# DefineUnitsAndConstants
#	This file is used to define units and constants.
#
# Units: kN, mm, sec
#
# This file developed by: Curt Haselton of Stanford University (28 June 2005)
# Modified by: Prakash S Badal of IIT Bombay
# Date: 18 Mar 2016
#
# Other files used in developing this model:
#		none
#----------------------------------------------------------------------------------#

# Define units - With base units are kN, mm and sec
	set mm 1.0
	set kN 1.0
	set m 1000.0
	set cm 100.0
	set N [expr 1/1000.0]
	
#	puts "Check N is $N "
#	puts "Check m is $m "
#	puts "Check cm is $cm "
	
	set kPa [expr ($kN) * (1/$m) * (1/$m)]
	set MPa [expr ($N) * (1/$mm) * (1/$mm)]

#	puts "Check kPa is $kPa"
#	puts "Check MPa is $MPa"

	set kNpcm [expr ($kN) * (1/$m) * (1/$m) * (1/$m)]

	set sec 1.0

# Define constants
	set pi [expr acos(-1)]
	set hugeNumber 10000000.0
	set g [expr 9.807 * $m/($sec*$sec)]
#	set g 9.807

#	puts "g is $g"

