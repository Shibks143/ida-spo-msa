#----------------------------------------------------------------------------------#
# DefineEarthquakeRecordInformation
#		In this module, information needs to be define for each EQ record.
#		This is used when running the EQ (things like filename, etc.)
#
# Units: kips, in, sec
#
# This file developed by: Curt Haselton of Stanford University
# Updated: 28 June 2005
# Date: 26 May 2004
#
# Other files used in developing this model:
#		Cordova's model
#----------------------------------------------------------------------------------#

# Notice - the PO uses eqNumber = 999, so don't use that!!!

# Define earthquake information
#	Note that for the formatted records (i.e. not in PEER format), we need filename, dtForEQ, numPointsForEQ, and saTOneForEQ;
#	but for the PEER formatted EQ's, we just need the filename and the saTOneForEQ.


################ Define added record information for ATC-63 Far-Field Record Set 7-14-06 (these are the records that are in Set D but not in Set C) #################################################
####################################################################################################################################

# A note on the EQ numbering scheme:
#	First/second numbers - 	(always 12) - just means that this set is part of the ATC-63 Far-Field Set
#	Third/forth numbers - 	(e.g. 05)	- index for the event (e.g. 05 is Hector Mine)
#	Fifth  -     		(e.g. 1) 	- index for the recording from the event (e.g. 1 is for the recording of the Amboy station for the Hector Mine event)
#	Sixth - 			(1 of 2)	- component index (i.e. two different horizontal components)

set eqFileName(120131)	NORTHR/STN020.at2
set eqFileName(120132)	NORTHR/STN110.at2
set eqFileName(120141)	NORTHR/STM090.at2
set eqFileName(120142)	NORTHR/STM360.at2
set eqFileName(120151)	NORTHR/MU2035.at2
set eqFileName(120152)	NORTHR/MU2125.at2
set eqFileName(120161)	NORTHR/LOS000.at2
set eqFileName(120162)	NORTHR/LOS270.at2
set eqFileName(120631)	IMPVALL/H-CXO225.at2
set eqFileName(120632)	IMPVALL/H-CXO315.at2
set eqFileName(120641)	IMPVALL/H-SHP000.at2
set eqFileName(120642)	IMPVALL/H-SHP270.at2
set eqFileName(120731)	KOBE/KAK000.at2
set eqFileName(120732)	KOBE/KAK090.at2
set eqFileName(120741)	KOBE/KJM000.at2
set eqFileName(120742)	KOBE/KJM090.at2
set eqFileName(120931)	LANDERS/JOS000.at2
set eqFileName(120932)	LANDERS/JOS090.at2
set eqFileName(121031)	LOMAP/CH12000.at2
set eqFileName(121032)	LOMAP/CH10270.at2
set eqFileName(121041)	LOMAP/HSP000.at2
set eqFileName(121042)	LOMAP/HSP090.at2
set eqFileName(121051)	LOMAP/HCH090.at2
set eqFileName(121052)	LOMAP/HCH180.at2
set eqFileName(121061)	LOMAP/HDA165.at2
set eqFileName(121062)	LOMAP/HDA255.at2
set eqFileName(121231)	SUPERST/B-WSM090.at2
set eqFileName(121232)	SUPERST/B-WSM180.at2
set eqFileName(121431)	CHICHI/TCU095-E.at2
set eqFileName(121432)	CHICHI/TCU095-N.at2
set eqFileName(121441)	CHICHI/TCU070-E.at2
set eqFileName(121442)	CHICHI/TCU070-N.at2
set eqFileName(121451)	CHICHI/WGK-E.at2
set eqFileName(121452)	CHICHI/WGK-N.at2
set eqFileName(121461)	CHICHI/CHY006-N.at2
set eqFileName(121462)	CHICHI/CHY006-W.at2

##################################################################################################
####################################################################################################################################


################ Define record information for ATC-63 Near-Field Record Set 5-31-06 #################################################
####################################################################################################################################

# A note on the EQ numbering scheme:
#	First number 	- 	(always 8) - means that we are using the PEER-NGA record numbering
#	Second number 	- 	(always 2) - means that these are the ROTATED (Fault-normal/parallel) PEER-NGA records
#	Third-sixth numbers - 	(e.g. 0723)	- PEER-NGA record number (e.g. 0723 is Superstition Hills at Parchute station)
#	Seventh - 			(1 of 2)	- component index - 1 is Fault-Normal, 2 is Fault Parallel

# Input the set WITH pulses
# FN Component
set eqFileName(8201801)	IMPVALL/H-E05_233_FN.acc
set eqFileName(8201811)	IMPVALL/H-E06_233_FN.acc
set eqFileName(8201821)	IMPVALL/H-E07_233_FN.acc
set eqFileName(8202921)	ITALY/A-STU_223_FN.acc
set eqFileName(8207231)	SUPERST/B-PTS_037_FN.acc
set eqFileName(8208021)	LOMAP/STG_038_FN.acc
set eqFileName(8208211)	ERZIKAN/ERZ_032_FN.acc
set eqFileName(8208281)	CAPEMEND/PET_260_FN.acc
set eqFileName(8208791)	LANDERS/LCN_239_FN.acc
set eqFileName(8210441)	NORTHR/NWH_032_FN.acc
set eqFileName(8210631)	NORTHR/RRS_032_FN.acc
set eqFileName(8210861)	NORTHR/SYL_032_FN.acc
set eqFileName(8215031)	CHICHI/TCU065_272_FN.acc
set eqFileName(8215101)	CHICHI/TCU075_271_FN.acc
set eqFileName(8215291)	CHICHI/TCU102_278_FN.acc
set eqFileName(8216051)	DUZCE/DZC_172_FN.acc

# FP Component
set eqFileName(8201802)	IMPVALL/H-E05_323_FP.acc
set eqFileName(8201812)	IMPVALL/H-E06_323_FP.acc
set eqFileName(8201822)	IMPVALL/H-E07_323_FP.acc
set eqFileName(8202922)	ITALY/A-STU_313_FP.acc
set eqFileName(8207232)	SUPERST/B-PTS_127_FP.acc
set eqFileName(8208022)	LOMAP/STG_128_FP.acc
set eqFileName(8208212)	ERZIKAN/ERZ_122_FP.acc
set eqFileName(8208282)	CAPEMEND/PET_350_FP.acc
set eqFileName(8208792)	LANDERS/LCN_329_FP.acc
set eqFileName(8210442)	NORTHR/NWH_122_FP.acc
set eqFileName(8210632)	NORTHR/RRS_122_FP.acc
set eqFileName(8210862)	NORTHR/SYL_122_FP.acc
set eqFileName(8215032)	CHICHI/TCU065_002_FP.acc
set eqFileName(8215102)	CHICHI/TCU075_001_FP.acc
set eqFileName(8215292)	CHICHI/TCU102_008_FP.acc
set eqFileName(8216052)	DUZCE/DZC_262_FP.acc

# Commented on 6-30-06 because these are now defined by Matlab during the collapse simulations.  I will need to add these back if I ever want to do stripe runs.
## Sa values - comp
#set saTOneForEQ(8201801)  0.6983
#set saTOneForEQ(8201802)  0.3876
#set saTOneForEQ(8201811)  0.4294
#set saTOneForEQ(8201812)  0.6023
#set saTOneForEQ(8201821)  0.6571
#set saTOneForEQ(8201822)  0.6435
#set saTOneForEQ(8202921)  0.2524
#set saTOneForEQ(8202922)  0.4130
#set saTOneForEQ(8207231)  0.9739
#set saTOneForEQ(8207232)  0.5093
#set saTOneForEQ(8208021)  0.4652
#set saTOneForEQ(8208022)  0.3221
#set saTOneForEQ(8208211)  0.9758
#set saTOneForEQ(8208212)  0.3662
#set saTOneForEQ(8208281)  0.9220
#set saTOneForEQ(8208282)  0.6980
#set saTOneForEQ(8208791)  0.4347
#set saTOneForEQ(8208792)  0.3365
#set saTOneForEQ(8210441)  1.3726
#set saTOneForEQ(8210442)  0.4347
#set saTOneForEQ(8210631)  1.9596
#set saTOneForEQ(8210632)  0.4650
#set saTOneForEQ(8210861)  0.8944
#set saTOneForEQ(8210862)  0.6459
#set saTOneForEQ(8215031)  1.3297
#set saTOneForEQ(8215032)  1.1024
#set saTOneForEQ(8215101)  0.3448
#set saTOneForEQ(8215102)  0.3393
#set saTOneForEQ(8215291)  0.5952
#set saTOneForEQ(8215292)  0.5754
#set saTOneForEQ(8216051)  0.5351
#set saTOneForEQ(8216052)  0.7325
#
## Sa values - geoMean
#set saTOneForEQGeoMean(820180)	0.520250978
#set saTOneForEQGeoMean(820181)	0.508554442
#set saTOneForEQGeoMean(820182)	0.650264446
#set saTOneForEQGeoMean(820292)	0.322864058
#set saTOneForEQGeoMean(820723)	0.704277836
#set saTOneForEQGeoMean(820802)	0.387092909
#set saTOneForEQGeoMean(820821)	0.597777517
#set saTOneForEQGeoMean(820828)	0.802219421
#set saTOneForEQGeoMean(820879)	0.382461175
#set saTOneForEQGeoMean(821044)	0.772443668
#set saTOneForEQGeoMean(821063)	0.954575298
#set saTOneForEQGeoMean(821086)	0.760061155
#set saTOneForEQGeoMean(821503)	1.210727583
#set saTOneForEQGeoMean(821510)	0.342038945
#set saTOneForEQGeoMean(821529)	0.585216268
#set saTOneForEQGeoMean(821605)	0.626067688

# Input the set NO WITH pulses
# FN Component
set eqFileName(8200061)	IMPVALL/I-ELC_233_FN.acc
set eqFileName(8201601)	IMPVALL/H-BCR_233_FN.acc
set eqFileName(8201651)	IMPVALL/H-CHI_233_FN.acc
set eqFileName(8204951)	NAHANNI/S1_070_FN.acc
set eqFileName(8204961)	NAHANNI/S2_070_FN.acc
set eqFileName(8207411)	LOMAP/BRN_038_FN.acc
set eqFileName(8207531)	LOMAP/CLS_038_FN.acc
set eqFileName(8207651) LOMAP/G01_038_FN.acc
set eqFileName(8210041)	NORTHR/0637_032_FN.acc
set eqFileName(8210481)	NORTHR/STC_032_FN.acc
set eqFileName(8210871)	NORTHR/TAR_032_FN.acc
set eqFileName(8211761)	KOCAELI/YPT_180_FN.acc
set eqFileName(8215041)	CHICHI/TCU067_285_FN.acc
set eqFileName(8215071)	CHICHI/TCU071_271_FN.acc
set eqFileName(8215171)	CHICHI/TCU084_271_FN.acc

# FP Component
set eqFileName(8200062)	IMPVALL/I-ELC_323_FP.acc
set eqFileName(8201602)	IMPVALL/H-BCR_323_FP.acc
set eqFileName(8201652)	IMPVALL/H-CHI_323_FP.acc
set eqFileName(8204952)	NAHANNI/S1_160_FP.acc
set eqFileName(8204962)	NAHANNI/S2_160_FP.acc
set eqFileName(8207412)	LOMAP/BRN_128_FP.acc
set eqFileName(8207532)	LOMAP/CLS_128_FP.acc
set eqFileName(8207652) LOMAP/G01_128_FP.acc
set eqFileName(8210042)	NORTHR/0637_122_FP.acc
set eqFileName(8210482)	NORTHR/STC_122_FP.acc
set eqFileName(8210872)	NORTHR/TAR_122_FP.acc
set eqFileName(8211762)	CHICHI/CHY014_022_FP.acc
set eqFileName(8215042)	CHICHI/TCU081_036_FP.acc
set eqFileName(8215072)	CHICHI/TCU084_001_FP.acc
set eqFileName(8215172)	CHICHI/TCU100_008_FP.acc
set eqFileName(8235482)	LOMAP/HYN_128_FP.acc
set eqFileName(8211762)	KOCAELI/YPT_270_FP.acc
set eqFileName(8215042)	CHICHI/TCU067_015_FP.acc
set eqFileName(8215072)	CHICHI/TCU071_001_FP.acc
set eqFileName(8215172)	CHICHI/TCU084_001_FP.acc

# Commented on 6-30-06 because these are now defined by Matlab during the collapse simulations.  I will need to add these back if I ever want to do stripe runs.
## Sa - comp
#set saTOneForEQ(8200061)  0.3380
#set saTOneForEQ(8200062)  0.3807
#set saTOneForEQ(8201601)  0.4420
#set saTOneForEQ(8201602)  0.4405
#set saTOneForEQ(8201651)  0.4140
#set saTOneForEQ(8201652)  0.3665
#set saTOneForEQ(8204951)  0.5338
#set saTOneForEQ(8204952)  0.2943
#set saTOneForEQ(8204961)  0.1619
#set saTOneForEQ(8204962)  0.2859
#set saTOneForEQ(8207411)  0.5530
#set saTOneForEQ(8207412)  0.4466
#set saTOneForEQ(8207531)  0.5259
#set saTOneForEQ(8207532)  0.4974
#set saTOneForEQ(8207651)  0.2350
#set saTOneForEQ(8207652)  0.2177
#set saTOneForEQ(8210041)  0.6234
#set saTOneForEQ(8210042)  0.9957
#set saTOneForEQ(8210481)  0.8073
#set saTOneForEQ(8210482)  0.3990
#set saTOneForEQ(8210871)  0.5445
#set saTOneForEQ(8210872)  0.7551
#set saTOneForEQ(8211761)  0.3752
#set saTOneForEQ(8211762)  0.3508
#set saTOneForEQ(8215041)  0.8888
#set saTOneForEQ(8215042)  0.4611
#set saTOneForEQ(8215071)  0.7482
#set saTOneForEQ(8215072)  0.7512
#set saTOneForEQ(8215171)  2.5389
#set saTOneForEQ(8215172)  0.8593
#
## Sa - geoMean
#set saTOneForEQGeoMean(820006)	0.3587
#set saTOneForEQGeoMean(820160)	0.4412
#set saTOneForEQGeoMean(820165)	0.3895
#set saTOneForEQGeoMean(820495)	0.3964
#set saTOneForEQGeoMean(820496)	0.2151
#set saTOneForEQGeoMean(820741)	0.4970
#set saTOneForEQGeoMean(820753)	0.5115
#set saTOneForEQGeoMean(820765)	0.2262
#set saTOneForEQGeoMean(821004)	0.7879
#set saTOneForEQGeoMean(821048)	0.5675
#set saTOneForEQGeoMean(821087)	0.6412
#set saTOneForEQGeoMean(821176)	0.3628
#set saTOneForEQGeoMean(821504)	0.6402
#set saTOneForEQGeoMean(821507)	0.7497
#set saTOneForEQGeoMean(821517)	1.4771

# Motions with questionsable pulses or pulses in the Fault-Parallel direction (added 6-6-06)
# FN Component
set eqFileName(8201261)	GAZLI/GAZ_177_FN.acc
set eqFileName(8208251)	CAPEMEND/CPM_260_FN.acc
set eqFileName(8211651)	KOCAELI/IZT_180_FN.acc
set eqFileName(8221141)	DENALI/ps10_199_FN.acc

# FP Component
set eqFileName(8201262)	GAZLI/GAZ_267_FP.acc
set eqFileName(8208252)	CAPEMEND/CPM_350_FP.acc
set eqFileName(8211652)	KOCAELI/IZT_270_FP.acc
set eqFileName(8221142)	DENALI/ps10_289_FP.acc

# Commented on 6-30-06 because these are now defined by Matlab during the collapse simulations.  I will need to add these back if I ever want to do stripe runs.
## Sa - comp - both FN and FP
#set saTOneForEQ(8201261)	0.814
#set saTOneForEQ(8201262)	0.418
#set saTOneForEQ(8208251)	0.419
#set saTOneForEQ(8208252)	0.727
#set saTOneForEQ(8211651)	0.291
#set saTOneForEQ(8211652)	0.279
#set saTOneForEQ(8221141)	0.694
#set saTOneForEQ(8221142)	0.823
#
## Sa - geoMean
#set saTOneForEQGeoMean(820126)	0.583
#set saTOneForEQGeoMean(820825)	0.552
#set saTOneForEQGeoMean(821165)	0.285
#set saTOneForEQGeoMean(822114)	0.756



################ Define record information for ATC-63 Far-Field Record Set 3-31-06 #################################################
####################################################################################################################################

# A note on the EQ numbering scheme:
#	First/second numbers - 	(always 12) - just means that this set is part of the ATC-63 Far-Field Set
#	Third/forth numbers - 	(e.g. 05)	- index for the event (e.g. 05 is Hector Mine)
#	Fifth  -     		(e.g. 1) 	- index for the recording from the event (e.g. 1 is for the recording of the Amboy station for the Hector Mine event)
#	Sixth - 			(1 of 2)	- component index (i.e. two different horizontal components)

# Define EQ file names
set eqFileName(120111)	NORTHR/MUL009.at2
set eqFileName(120121)	NORTHR/LOS000.at2
set eqFileName(120211)	KERN/TAF021.at2
set eqFileName(120311)	BORREGO/A-ELC180.at2
set eqFileName(120411)	DUZCE/BOL000.at2
set eqFileName(120511)	HECTOR/21081090.at2
set eqFileName(120521)	HECTOR/HEC000.at2
set eqFileName(120611)	IMPVALL/H-DLT262.at2
set eqFileName(120621)	IMPVALL/H-E11140.at2
set eqFileName(120711)	KOBE/NIS000.at2
set eqFileName(120721)	KOBE/SHI000.at2
set eqFileName(120811)	KOCAELI/DZC180.at2
set eqFileName(120821)	KOCAELI/ARC000.at2
set eqFileName(120911)	LANDERS/YER270.at2
set eqFileName(120921)	LANDERS/CLW-LN.at2
set eqFileName(121011)	LOMAP/CAP000.at2
set eqFileName(121021)	LOMAP/G03000.at2
set eqFileName(121111)	MANJIL/ABBAR--L.at2
set eqFileName(121211)	SUPERST/B-ICC000.at2
set eqFileName(121221)	SUPERST/B-POE270.at2
set eqFileName(121311)	CAPEMEND/EUR000.at2
set eqFileName(121321)	CAPEMEND/RIO270.at2
set eqFileName(121411)	CHICHI/CHY101-E.at2
set eqFileName(121421)	CHICHI/TCU045-E.at2
set eqFileName(121511)	SFERN/PEL090.at2
set eqFileName(121611)	STELIAS/059v2009.at2
set eqFileName(121621)	STELIAS/059v2090.at2
set eqFileName(121711)	FRIULI/A-TMZ000.at2
# Second horizontal component of each record
set eqFileName(120112)	NORTHR/MUL279.at2
set eqFileName(120122)	NORTHR/LOS270.at2
set eqFileName(120212)	KERN/TAF111.at2
set eqFileName(120312)	BORREGO/A-ELC270.at2
set eqFileName(120412)	DUZCE/BOL090.at2
set eqFileName(120512)	HECTOR/21081360.at2
set eqFileName(120522)	HECTOR/HEC090.at2
set eqFileName(120612)	IMPVALL/H-DLT352.at2
set eqFileName(120622)	IMPVALL/H-E11230.at2
set eqFileName(120712)	KOBE/NIS090.at2
set eqFileName(120722)	KOBE/SHI090.at2
set eqFileName(120812)	KOCAELI/DZC270.at2
set eqFileName(120822)	KOCAELI/ARC090.at2
set eqFileName(120912)	LANDERS/YER360.at2
set eqFileName(120922)	LANDERS/CLW-TR.at2
set eqFileName(121012)	LOMAP/CAP090.at2
set eqFileName(121022)	LOMAP/G03090.at2
set eqFileName(121112)	MANJIL/ABBAR--T.at2
set eqFileName(121212)	SUPERST/B-ICC090.at2
set eqFileName(121222)	SUPERST/B-POE360.at2
set eqFileName(121312)	CAPEMEND/EUR090.at2
set eqFileName(121322)	CAPEMEND/RIO360.at2
set eqFileName(121412)	CHICHI/CHY101-N.at2
set eqFileName(121422)	CHICHI/TCU045-N.at2
set eqFileName(121512)	SFERN/PEL180.at2
set eqFileName(121612)	STELIAS/059v2279.at2
set eqFileName(121622)	STELIAS/059v2180.at2
set eqFileName(121712)	FRIULI/A-TMZ270.at2

# Commented on 6-30-06 because these are now defined by Matlab during the collapse simulations.  I will need to add these back if I ever want to do stripe runs.
## Define single component Sa at 1 second period
#set saTOneForEQ(120111)  1.0198
#set saTOneForEQ(120112)  0.9398
#set saTOneForEQ(120121)  0.3783
#set saTOneForEQ(120122)  0.6338
#set saTOneForEQ(120211)  0.1776
#set saTOneForEQ(120212)  0.1593
#set saTOneForEQ(120311)  0.1812
#set saTOneForEQ(120312)  0.1321
#set saTOneForEQ(120411)  0.7188
#set saTOneForEQ(120412)  1.1559
#set saTOneForEQ(120511)  0.2334
#set saTOneForEQ(120512)  0.2111
#set saTOneForEQ(120521)  0.3535
#set saTOneForEQ(120522)  0.3728
#set saTOneForEQ(120611)  0.2624
#set saTOneForEQ(120612)  0.4815
#set saTOneForEQ(120621)  0.2416
#set saTOneForEQ(120622)  0.2262
#set saTOneForEQ(120711)  0.3055
#set saTOneForEQ(120712)  0.2873
#set saTOneForEQ(120721)  0.3325
#set saTOneForEQ(120722)  0.2268
#set saTOneForEQ(120811)  0.4345
#set saTOneForEQ(120812)  0.6092
#set saTOneForEQ(120821)  0.1126
#set saTOneForEQ(120822)  0.1117
#set saTOneForEQ(120911)  0.4993
#set saTOneForEQ(120912)  0.3257
#set saTOneForEQ(120921)  0.1977
#set saTOneForEQ(120922)  0.3647
#set saTOneForEQ(121011)  0.4557
#set saTOneForEQ(121012)  0.2783
#set saTOneForEQ(121021)  0.2669
#set saTOneForEQ(121022)  0.3765
#set saTOneForEQ(121111)  0.3538
#set saTOneForEQ(121112)  0.5420
#set saTOneForEQ(121211)  0.3080
#set saTOneForEQ(121212)  0.2467
#set saTOneForEQ(121221)  0.3267
#set saTOneForEQ(121222)  0.3433
#set saTOneForEQ(121311)  0.1446
#set saTOneForEQ(121312)  0.2340
#set saTOneForEQ(121321)  0.5384
#set saTOneForEQ(121322)  0.3881
#set saTOneForEQ(121411)  0.4864
#set saTOneForEQ(121412)  0.9488
#set saTOneForEQ(121421)  0.2983
#set saTOneForEQ(121422)  0.4336
#set saTOneForEQ(121511)  0.2459
#set saTOneForEQ(121512)  0.1542
#set saTOneForEQ(121611)  0.1774
#set saTOneForEQ(121612)  0.1031
#set saTOneForEQ(121621)  0.2620
#set saTOneForEQ(121622)  0.3009
#set saTOneForEQ(121711)  0.2469
#set saTOneForEQ(121712)  0.2953
#
## Define the geometric mean Sa at 1 second period
#set saTOneForEQGeoMean(12011)	0.979
#set saTOneForEQGeoMean(12012)	0.490
#set saTOneForEQGeoMean(12021)	0.168
#set saTOneForEQGeoMean(12031)	0.155
#set saTOneForEQGeoMean(12041)	0.912
#set saTOneForEQGeoMean(12051)	0.222
#set saTOneForEQGeoMean(12052)	0.363
#set saTOneForEQGeoMean(12061)	0.355
#set saTOneForEQGeoMean(12062)	0.234
#set saTOneForEQGeoMean(12071)	0.296
#set saTOneForEQGeoMean(12072)	0.275
#set saTOneForEQGeoMean(12081)	0.514
#set saTOneForEQGeoMean(12082)	0.112
#set saTOneForEQGeoMean(12091)	0.403
#set saTOneForEQGeoMean(12092)	0.269
#set saTOneForEQGeoMean(12101)	0.356
#set saTOneForEQGeoMean(12102)	0.317
#set saTOneForEQGeoMean(12111)	0.438
#set saTOneForEQGeoMean(12121)	0.276
#set saTOneForEQGeoMean(12122)	0.335
#set saTOneForEQGeoMean(12131)	0.184
#set saTOneForEQGeoMean(12132)	0.457
#set saTOneForEQGeoMean(12141)	0.679
#set saTOneForEQGeoMean(12142)	0.360
#set saTOneForEQGeoMean(12151)	0.195
#set saTOneForEQGeoMean(12161)	0.135
#set saTOneForEQGeoMean(12162)	0.281
#set saTOneForEQGeoMean(12171)	0.270
#
# Define the scale factors for the Code scaling method; to get the 
# MEDIAN of the record set to Sa = 1.0g at 1.0 seconds.  These values
# are used in the scaling by the code method (to scale the whole GM 
# set together rather than based on the Sa of an individual record alone).
#set scaleFactorForMeanOfCodeGMSetToBeOne(XXX)	XX
# NOTICE: I removed this because I am not running by the Code scaling mehtod now (I am doing this with post-processing)






################ Define record information for ATC-63 record Set A on 8-16-05 #################################################
# Set A #######################################################################################################################
# See associated hand notes dated 8-15-05 in ATC-63 folder
# A note on the EQ numbering scheme:
#	First number - 	(1) 		- just means that this set is part of the ATC-63 project (or EERI paper with Baker; but projects are related )
#	Second number - 	(1)	 	- just to signify that this is the first record set used in the ATC-63 project (record Set A)
#	Third/Forth -     (00-09) 	- Event number (just index)
#	Fifth - 		(1-2)		- Component number (i.e. two different horizontal components)

# Define EQ file names
set eqFileName(11011)	G03000.AT2
set eqFileName(11012)	G03090.AT2
set eqFileName(11021)	WVC000.AT2
set eqFileName(11022)	WVC270.AT2
set eqFileName(11031)	HOL090.AT2
set eqFileName(11032)	HOL360.AT2
set eqFileName(11041)	ORR090.AT2
set eqFileName(11042)	ORR360.AT2
set eqFileName(11051)	PEL090.AT2
set eqFileName(11052)	PEL180.AT2
set eqFileName(11061)	ORR021.AT2
set eqFileName(11062)	ORR291.AT2
set eqFileName(11071)	JOS000.AT2
set eqFileName(11072)	JOS090.AT2
set eqFileName(11081)	YER270.AT2
set eqFileName(11082)	YER360.AT2
set eqFileName(11091)	H-E11140.AT2
set eqFileName(11092)	H-E11230.AT2
set eqFileName(11101)	H-DLT262.AT2
set eqFileName(11102)	H-DLT352.AT2
set eqFileName(11111)	DZC180.AT2
set eqFileName(11112)	DZC270.AT2
set eqFileName(11121)	B-ICC000.AT2
set eqFileName(11122)	B-ICC090.AT2
set eqFileName(11131)	B-WSM180.AT2
set eqFileName(11132)	B-WSM090.AT2
# Additions on 8-23-05
set eqFileName(11141)	I-ELC180.AT2
set eqFileName(11142)	I-ELC270.AT2
set eqFileName(11151)	A-TMZ000.AT2
set eqFileName(11152)	A-TMZ270.AT2
set eqFileName(11161)	GAZ000.AT2
set eqFileName(11162)	GAZ090.AT2
set eqFileName(11171)	DAY-LN.AT2
set eqFileName(11172)	DAY-TR.AT2
set eqFileName(11181)	TAB-LN.AT2
set eqFileName(11182)	TAB-TR.AT2
set eqFileName(11191)	A-STU000.AT2
set eqFileName(11192)	A-STU270.AT2
set eqFileName(11201)	COR--L.AT2
set eqFileName(11202)	COR--T.AT2
set eqFileName(11211)	S1010.AT2
set eqFileName(11212)	S1280.AT2
set eqFileName(11221)	S2240.AT2
set eqFileName(11222)	S2330.AT2
set eqFileName(11231)	45O02EW.AT2
set eqFileName(11232)	45O02NS.AT2
set eqFileName(11241)	A-MAT083.AT2
set eqFileName(11242)	A-MAT353.AT2
set eqFileName(11251)	ERZ-NS.AT2
set eqFileName(11252)	ERZ-EW.AT2
set eqFileName(11261)	CPM000.AT2
set eqFileName(11262)	CPM090.AT2
set eqFileName(11271)	PET000.AT2
set eqFileName(11272)	PET090.AT2
set eqFileName(11281)	YPT060.AT2
set eqFileName(11282)	YPT330.AT2
set eqFileName(11291)	BOL000.AT2
set eqFileName(11292)	BOL090.AT2
set eqFileName(11301)	DZC180_1999_11_12.AT2
set eqFileName(11302)	DZC270_1999_11_12.AT2
set eqFileName(11311)	ABBAR--L.AT2
set eqFileName(11312)	ABBAR--T.AT2
set eqFileName(11321)	HEC000.AT2
set eqFileName(11322)	HEC090.AT2

# Commented on 6-30-06 because these are now defined by Matlab during the collapse simulations.  I will need to add these back if I ever want to do stripe runs.
## Define single component Sa at 1 second period
#set saTOneForEQ(11011)  0.2669
#set saTOneForEQ(11012)  0.3765
#set saTOneForEQ(11021)  0.5116
#set saTOneForEQ(11022)  0.6496
#set saTOneForEQ(11031)  0.2319
#set saTOneForEQ(11032)  0.4520
#set saTOneForEQ(11041)  0.5325
#set saTOneForEQ(11042)  0.9632
#set saTOneForEQ(11051)  0.2459
#set saTOneForEQ(11052)  0.1542
#set saTOneForEQ(11061)  0.1601
#set saTOneForEQ(11062)  0.3222
#set saTOneForEQ(11071)  0.4023
#set saTOneForEQ(11072)  0.5288
#set saTOneForEQ(11081)  0.4993
#set saTOneForEQ(11082)  0.3257
#set saTOneForEQ(11091)  0.2416
#set saTOneForEQ(11092)  0.2262
#set saTOneForEQ(11101)  0.2624
#set saTOneForEQ(11102)  0.4815
#set saTOneForEQ(11111)  0.4345
#set saTOneForEQ(11112)  0.6092
#set saTOneForEQ(11121)  0.3080
#set saTOneForEQ(11122)  0.2467
#set saTOneForEQ(11131)  0.4791
#set saTOneForEQ(11132)  0.2441
#set saTOneForEQ(11141)	0.4862
#set saTOneForEQ(11142)	0.2736
#set saTOneForEQ(11151)	0.2469
#set saTOneForEQ(11152)	0.2953
#set saTOneForEQ(11161)	0.7973
#set saTOneForEQ(11162)	0.4422
#set saTOneForEQ(11171)	0.2234
#set saTOneForEQ(11172)	0.3426
#set saTOneForEQ(11181)	0.7098
#set saTOneForEQ(11182)	0.664
#set saTOneForEQ(11191)	0.2931
#set saTOneForEQ(11192)	0.3752
#set saTOneForEQ(11201)	0.2928
#set saTOneForEQ(11202)	0.2575
#set saTOneForEQ(11211)	0.4295
#set saTOneForEQ(11212)	0.4848
#set saTOneForEQ(11221)	0.1341
#set saTOneForEQ(11222)	0.2846
#set saTOneForEQ(11231)	0.1975
#set saTOneForEQ(11232)	0.2653
#set saTOneForEQ(11241)	0.2182
#set saTOneForEQ(11242)	0.2218
#set saTOneForEQ(11251)	0.8482
#set saTOneForEQ(11252)	0.5898
#set saTOneForEQ(11261)	0.7461
#set saTOneForEQ(11262)	0.3314
#set saTOneForEQ(11271)	0.6084
#set saTOneForEQ(11272)	0.9845
#set saTOneForEQ(11281)	0.3255
#set saTOneForEQ(11282)	0.3783
#set saTOneForEQ(11291)	0.7188
#set saTOneForEQ(11292)	1.1559
#set saTOneForEQ(11301)	0.5337
#set saTOneForEQ(11302)	0.7564
#set saTOneForEQ(11311)	0.3538
#set saTOneForEQ(11312)	0.542
#set saTOneForEQ(11321)	0.3535
#set saTOneForEQ(11322)	0.3728
#
## Define the geometric mean Sa at 1 second period
#set saTOneForEQGeoMean(1101)	0.3170
#set saTOneForEQGeoMean(1102)	0.5765
#set saTOneForEQGeoMean(1103)	0.3238
#set saTOneForEQGeoMean(1104)	0.7162
#set saTOneForEQGeoMean(1105)	0.1947
#set saTOneForEQGeoMean(1106)	0.2271
#set saTOneForEQGeoMean(1107)	0.4612
#set saTOneForEQGeoMean(1108)	0.4033
#set saTOneForEQGeoMean(1109)	0.2338
#set saTOneForEQGeoMean(1110)	0.3555
#set saTOneForEQGeoMean(1111)	0.5145
#set saTOneForEQGeoMean(1112)	0.2757
#set saTOneForEQGeoMean(1113)	0.3420
#set saTOneForEQGeoMean(1114)	0.3647
#set saTOneForEQGeoMean(1115)	0.2700
#set saTOneForEQGeoMean(1116)	0.5938
#set saTOneForEQGeoMean(1117)	0.2767
#set saTOneForEQGeoMean(1118)	0.6865
#set saTOneForEQGeoMean(1119)	0.3316
#set saTOneForEQGeoMean(1120)	0.2746
#set saTOneForEQGeoMean(1121)	0.4563
#set saTOneForEQGeoMean(1122)	0.1954
#set saTOneForEQGeoMean(1123)	0.2289
#set saTOneForEQGeoMean(1124)	0.2200
#set saTOneForEQGeoMean(1125)	0.7073
#set saTOneForEQGeoMean(1126)	0.4972
#set saTOneForEQGeoMean(1127)	0.7739
#set saTOneForEQGeoMean(1128)	0.3509
#set saTOneForEQGeoMean(1129)	0.9115
#set saTOneForEQGeoMean(1130)	0.6354
#set saTOneForEQGeoMean(1131)	0.4379
#set saTOneForEQGeoMean(1132)	0.3630

# I CHANGED THIS TO BE BASED ON THE MEDIAN INSTEAD OF THE MEAN (ON 9-7-05); BASED ON KIRCHER'S 
#	RECOMENDATION ON PHONE CALL ON 9-6-05
## Define the scale factors for the Code scaling method; to get the 
## MEAN of the record set to Sa = 1.0g at 1.0 seconds.  These values
## are used in the scaling by the code method (to scale the whole GM 
## set together rather than based on the Sa of an individual record alone).
## These values are copied straight out of:
## "Ground Motion Set for Collapse Analysis (without epsilon)_ATC-63_GMSetA_version 7 (8-27-05).xls"
#set scaleFactorForMeanOfCodeGMSetToBeOne(1101)	1.79
#set scaleFactorForMeanOfCodeGMSetToBeOne(1102)	1.37
#set scaleFactorForMeanOfCodeGMSetToBeOne(1103)	3.10
#set scaleFactorForMeanOfCodeGMSetToBeOne(1104)	1.39
#set scaleFactorForMeanOfCodeGMSetToBeOne(1105)	4.25
#set scaleFactorForMeanOfCodeGMSetToBeOne(1106)	3.39
#set scaleFactorForMeanOfCodeGMSetToBeOne(1107)	2.00
#set scaleFactorForMeanOfCodeGMSetToBeOne(1108)	1.72
#set scaleFactorForMeanOfCodeGMSetToBeOne(1109)	1.88
#set scaleFactorForMeanOfCodeGMSetToBeOne(1110)	2.44
#set scaleFactorForMeanOfCodeGMSetToBeOne(1111)	1.37
#set scaleFactorForMeanOfCodeGMSetToBeOne(1112)	1.66
#set scaleFactorForMeanOfCodeGMSetToBeOne(1113)	2.63
#set scaleFactorForMeanOfCodeGMSetToBeOne(1114)	3.39
#set scaleFactorForMeanOfCodeGMSetToBeOne(1115)	3.96
#set scaleFactorForMeanOfCodeGMSetToBeOne(1116)	4.30 - wrong! do not use!
#set scaleFactorForMeanOfCodeGMSetToBeOne(1117)	3.87
#set scaleFactorForMeanOfCodeGMSetToBeOne(1118)	1.51
#set scaleFactorForMeanOfCodeGMSetToBeOne(1119)	2.34
#set scaleFactorForMeanOfCodeGMSetToBeOne(1120)	3.82
#set scaleFactorForMeanOfCodeGMSetToBeOne(1121)	2.32
#set scaleFactorForMeanOfCodeGMSetToBeOne(1122)	3.57
#set scaleFactorForMeanOfCodeGMSetToBeOne(1123)	-1; # do not ue this record; it was removed from the set
#set scaleFactorForMeanOfCodeGMSetToBeOne(1124)	4.96
#set scaleFactorForMeanOfCodeGMSetToBeOne(1125)	1.49
#set scaleFactorForMeanOfCodeGMSetToBeOne(1126)	1.21
#set scaleFactorForMeanOfCodeGMSetToBeOne(1127)	1.47
#set scaleFactorForMeanOfCodeGMSetToBeOne(1128)	1.64
#set scaleFactorForMeanOfCodeGMSetToBeOne(1129)	1.73
#set scaleFactorForMeanOfCodeGMSetToBeOne(1130)	-1; # do not ue this record; it was removed from the set
#set scaleFactorForMeanOfCodeGMSetToBeOne(1131)	2.17
#set scaleFactorForMeanOfCodeGMSetToBeOne(1132)	3.00

# Define the scale factors for the Code scaling method; to get the 
# MEDIAN of the record set to Sa = 1.0g at 1.0 seconds.  These values
# are used in the scaling by the code method (to scale the whole GM 
# set together rather than based on the Sa of an individual record alone).
# These values are copied straight out of:
# "Ground Motion Set for Collapse Analysis (without epsilon)_ATC-63_GMSetA_version 8 (9-7-05).xls"

# Commented on 6-30-06 because these are now defined by Matlab during the collapse simulations.  
## NOTICE that even though the variable name says "MEAN", it is really scaling the MEDIAN of all of the components to 1.0g
#set scaleFactorForMeanOfCodeGMSetToBeOne(1101)	1.954
#set scaleFactorForMeanOfCodeGMSetToBeOne(1102)	1.497
#set scaleFactorForMeanOfCodeGMSetToBeOne(1103)	3.384
#set scaleFactorForMeanOfCodeGMSetToBeOne(1104)	1.516
#set scaleFactorForMeanOfCodeGMSetToBeOne(1105)	4.645
#set scaleFactorForMeanOfCodeGMSetToBeOne(1106)	3.697
#set scaleFactorForMeanOfCodeGMSetToBeOne(1107)	2.183
#set scaleFactorForMeanOfCodeGMSetToBeOne(1108)	1.880
#set scaleFactorForMeanOfCodeGMSetToBeOne(1109)	2.054
#set scaleFactorForMeanOfCodeGMSetToBeOne(1110)	2.661
#set scaleFactorForMeanOfCodeGMSetToBeOne(1111)	1.492
#set scaleFactorForMeanOfCodeGMSetToBeOne(1112)	1.807
#set scaleFactorForMeanOfCodeGMSetToBeOne(1113)	2.874
#set scaleFactorForMeanOfCodeGMSetToBeOne(1114)	3.697
#set scaleFactorForMeanOfCodeGMSetToBeOne(1115)	4.325
#set scaleFactorForMeanOfCodeGMSetToBeOne(1116)	1.830;		# Scaled factor corected on 10-24-05 (see hand notes) - was 4.695
#set scaleFactorForMeanOfCodeGMSetToBeOne(1117)	4.223
#set scaleFactorForMeanOfCodeGMSetToBeOne(1118)	1.649
#set scaleFactorForMeanOfCodeGMSetToBeOne(1119)	2.556
#set scaleFactorForMeanOfCodeGMSetToBeOne(1120)	4.170
#set scaleFactorForMeanOfCodeGMSetToBeOne(1121)	2.535
#set scaleFactorForMeanOfCodeGMSetToBeOne(1122)	3.892
#set scaleFactorForMeanOfCodeGMSetToBeOne(1123)	-1; # do not ue this record; it was removed from the set
#set scaleFactorForMeanOfCodeGMSetToBeOne(1124)	5.416
#set scaleFactorForMeanOfCodeGMSetToBeOne(1125)	1.626
#set scaleFactorForMeanOfCodeGMSetToBeOne(1126)	1.325
#set scaleFactorForMeanOfCodeGMSetToBeOne(1127)	1.606
#set scaleFactorForMeanOfCodeGMSetToBeOne(1128)	1.792
#set scaleFactorForMeanOfCodeGMSetToBeOne(1129)	1.889
#set scaleFactorForMeanOfCodeGMSetToBeOne(1130)	-1; # do not ue this record; it was removed from the set
#set scaleFactorForMeanOfCodeGMSetToBeOne(1131)	2.364
#set scaleFactorForMeanOfCodeGMSetToBeOne(1132)	3.277




######################################################################################################################################################
################ Define record information for record set for EERI epsilon paper with Baker (and ATC-63 work) on 9-5-05 #################################################33
# Set B #######################################################################################################################
# See associated hand notes dated 9-5-05 in documentation for 2005 EERI paper with Baker
# NOTICE that this set is just a single component for each record; NOT geometric mean
#
# A note on the EQ numbering scheme:
#	First number - 	(1) 		- just means that this set is part of the ATC-63 project (or EERI paper with Baker; but projects are related )
#	Second number - 	(2)	 	- just to signify that this is the second record set used in the ATC-63 project (record Set B)
#	Third/Forth -     (00-09) 	- Event number (just index)


# ****
# NOTICE: To use these records, there are some older sensitivity study records that need to be removed (1250ff)!!!
# ****



set eqFileName(1201)	EUR090.AT2
set eqFileName(1202)	RIO360.AT2
set eqFileName(1203)	FAT000.AT2
set eqFileName(1204)	CLW-TR.AT2
set eqFileName(1205)	HOS090.AT2
set eqFileName(1206)	YER270.AT2
set eqFileName(1207)	AGW090.AT2
set eqFileName(1208)	A09137.AT2
set eqFileName(1209)	BRK090.AT2
set eqFileName(1210)	CAP000.AT2
set eqFileName(1211)	G02090.AT2
set eqFileName(1212)	GGB270.AT2
set eqFileName(1213)	GGB360.AT2
set eqFileName(1214)	HWB220.AT2
set eqFileName(1215)	HSP000.AT2
set eqFileName(1216)	HSP090.AT2
set eqFileName(1217)	HCH090.AT2
set eqFileName(1218)	HCH180.AT2
set eqFileName(1219)	HDA165.AT2
set eqFileName(1220)	HDA255.AT2
set eqFileName(1221)	TIB180.AT2
set eqFileName(1222)	TIB270.AT2
set eqFileName(1223)	PAE000.AT2
set eqFileName(1224)	PAE090.AT2
set eqFileName(1225)	SLC270.AT2
set eqFileName(1226)	SLC360.AT2
set eqFileName(1227)	RCH190.AT2
set eqFileName(1228)	RCH280.AT2
set eqFileName(1229)	STG090.AT2
set eqFileName(1230)	PRS090.AT2
set eqFileName(1231)	SFO000.AT2
set eqFileName(1232)	SFO090.AT2
set eqFileName(1233)	SVL270.AT2
set eqFileName(1234)	SVL360.AT2
set eqFileName(1235)	CMR270.AT2
set eqFileName(1236)	CNP196.AT2
set eqFileName(1237)	LOS000.AT2
set eqFileName(1238)	ORR090.AT2
set eqFileName(1239)	ORR360.AT2
set eqFileName(1240)	WIL180.AT2
set eqFileName(1241)	BLD090.AT2
set eqFileName(1242)	CCN090.AT2
set eqFileName(1243)	STN020.AT2
set eqFileName(1244)	STN110.AT2
set eqFileName(1245)	UNI005.AT2
set eqFileName(1246)	NEE090.AT2
set eqFileName(1247)	NEE180.AT2
set eqFileName(1248)	SAR270.AT2
set eqFileName(1249)	STM090.AT2
set eqFileName(1250)	STM360.AT2
set eqFileName(1251)	TAR090.AT2
set eqFileName(1252)	TAR360.AT2
set eqFileName(1253)	SSE240.AT2
set eqFileName(1254)	PVE155.AT2
set eqFileName(1255)	TLI249.AT2
set eqFileName(1256)	TLI339.AT2
set eqFileName(1257)	B-ICC090.AT2
set eqFileName(1258)	B-IVW090.AT2
set eqFileName(1259)	B-IVW360.AT2
set eqFileName(1260)	45C00NS.AT2
set eqFileName(1261)	45E01EW.AT2
set eqFileName(1262)	45I01NS.AT2
set eqFileName(1263)	45I07NS.AT2
set eqFileName(1264)	45M01NS.AT2
set eqFileName(1265)	45O02NS.AT2

set saTOneForEQ(1201)  0.2340
set saTOneForEQ(1202)  0.3881
set saTOneForEQ(1203)  0.1216
set saTOneForEQ(1204)  0.3647
set saTOneForEQ(1205)  0.1847
set saTOneForEQ(1206)  0.4993
set saTOneForEQ(1207)  0.1830
set saTOneForEQ(1208)  0.1600
set saTOneForEQ(1209)  0.3271
set saTOneForEQ(1210)  0.4557
set saTOneForEQ(1211)  0.4026
set saTOneForEQ(1212)  0.5079
set saTOneForEQ(1213)  0.3435
set saTOneForEQ(1214)  0.3498
set saTOneForEQ(1215)  1.0025
set saTOneForEQ(1216)  0.3631
set saTOneForEQ(1217)  0.5052
set saTOneForEQ(1218)  0.6760
set saTOneForEQ(1219)  0.3457
set saTOneForEQ(1220)  0.5481
set saTOneForEQ(1221)  0.3627
set saTOneForEQ(1222)  0.5338
set saTOneForEQ(1223)  0.2320
set saTOneForEQ(1224)  0.6162
set saTOneForEQ(1225)  0.5508
set saTOneForEQ(1226)  0.4970
set saTOneForEQ(1227)  0.4074
set saTOneForEQ(1228)  0.2592
set saTOneForEQ(1229)  0.3442
set saTOneForEQ(1230)  0.2878
set saTOneForEQ(1231)  0.3708
set saTOneForEQ(1232)  0.3604
set saTOneForEQ(1233)  0.2585
set saTOneForEQ(1234)  0.2870
set saTOneForEQ(1235)  0.1696
set saTOneForEQ(1236)  0.5031
set saTOneForEQ(1237)  0.3783
set saTOneForEQ(1238)  0.5325
set saTOneForEQ(1239)  0.9632
set saTOneForEQ(1240)  0.5854
set saTOneForEQ(1241)  0.1606
set saTOneForEQ(1242)  0.2679
set saTOneForEQ(1243)  0.3629
set saTOneForEQ(1244)  0.4960
set saTOneForEQ(1245)  0.2209
set saTOneForEQ(1246)  0.0556
set saTOneForEQ(1247)  0.1187
set saTOneForEQ(1248)  0.1743
set saTOneForEQ(1249)  0.3262
set saTOneForEQ(1250)  0.1776
set saTOneForEQ(1251)  0.7861
set saTOneForEQ(1252)  0.5024
set saTOneForEQ(1253)  0.2550
set saTOneForEQ(1254)  0.0479
set saTOneForEQ(1255)  0.0355
set saTOneForEQ(1256)  0.2340
set saTOneForEQ(1257)  0.2467
set saTOneForEQ(1258)  0.2031
set saTOneForEQ(1259)  0.4397
set saTOneForEQ(1260)  0.2900
set saTOneForEQ(1261)  0.3563
set saTOneForEQ(1262)  0.3221
set saTOneForEQ(1263)  0.3155
set saTOneForEQ(1264)  0.3131
set saTOneForEQ(1265)  0.2653





#######################################################################################################################
################ Define record information for record set on 12-15-04 #################################################33
# A note on the EQ numbering scheme:
#	First number - 	(9) 		- just to signify that this in the EQ set based on geometric mean Sa
#	Second number - 	(1-7) 	- Bin number (based on what hazard level the bin was selected for)
#	Third number - 	(1-3) 	- Sub-bin number (selected to match different contributors observed from the dissagregation)
#	Forth/Fifth -     (00-09) 	- Event number (just index)
#	Sixth - 		(1-2)		- Component number (i.e. two different horzontal components)

# Bin 1A -- 7B filenames (Geometric mean set)
set eqFileName(911001)	PDL120.AT2
set eqFileName(911002)	PDL210.AT2
set eqFileName(911011)	H-BRA225.AT2
set eqFileName(911012)	H-BRA315.AT2
set eqFileName(911021)	HD1165.AT2
set eqFileName(911022)	HD1255.AT2
set eqFileName(911031)	HD4165.AT2
set eqFileName(911032)	HD4255.AT2
set eqFileName(911041)	H08000.AT2
set eqFileName(911042)	H08090.AT2
set eqFileName(911051)	JOS000.AT2
set eqFileName(911052)	JOS090.AT2
set eqFileName(911061)	B-WSM090.AT2
set eqFileName(911062)	B-WSM180.AT2
set eqFileName(911071)	STG000.AT2
set eqFileName(911072)	STG090.AT2
set eqFileName(911081)	WVC000.AT2
set eqFileName(911082)	WVC270.AT2
set eqFileName(911091)	WIL090.AT2
set eqFileName(911092)	WIL180.AT2

set eqFileName(912001)	TAF021.AT2
set eqFileName(912002)	TAF111.AT2
set eqFileName(912011)	A2E000.AT2
set eqFileName(912012)	A2E090.AT2
set eqFileName(912021)	EUR000.AT2
set eqFileName(912022)	EUR090.AT2
set eqFileName(912031)	H05000.AT2
set eqFileName(912032)	H05090.AT2
set eqFileName(912041)	ATK000.AT2
set eqFileName(912042)	ATK090.AT2
set eqFileName(912051)	BRS090.AT2
set eqFileName(912052)	BRS180.AT2
set eqFileName(912061)	FAT000.AT2
set eqFileName(912062)	FAT090.AT2
set eqFileName(912071)	CHY055-E.AT2
set eqFileName(912072)	CHY055-N.AT2
set eqFileName(912081)	CHY093-E.AT2
set eqFileName(912082)	CHY093-N.AT2
set eqFileName(912091)	HWA015-N.AT2
set eqFileName(912092)	HWA015-W.AT2

set eqFileName(921001)	SBA132.AT2
set eqFileName(921002)	SBA222.AT2
set eqFileName(921011)	H-BRA225.AT2
set eqFileName(921012)	H-BRA315.AT2
set eqFileName(921021)	H-PVP045.AT2
set eqFileName(921022)	H-PVP135.AT2
set eqFileName(921031)	SJB213.AT2
set eqFileName(921032)	SJB303.AT2
set eqFileName(921041)	HD4165.AT2
set eqFileName(921042)	HD4255.AT2
set eqFileName(921051)	AGW240.AT2
set eqFileName(921052)	AGW330.AT2
set eqFileName(921061)	PSA000.AT2
set eqFileName(921062)	PSA090.AT2
set eqFileName(921071)	JOS000.AT2
set eqFileName(921072)	JOS090.AT2
set eqFileName(921081)	A-CTS000.AT2
set eqFileName(921082)	A-CTS090.AT2
set eqFileName(921091)	A-PAS180.AT2
set eqFileName(921092)	A-PAS270.AT2

set eqFileName(922001)	TAF021.AT2
set eqFileName(922002)	TAF111.AT2
set eqFileName(922011)	HWB220.AT2
set eqFileName(922012)	HWB310.AT2
set eqFileName(922021)	EUR000.AT2
set eqFileName(922022)	EUR090.AT2
set eqFileName(922031)	IND000.AT2
set eqFileName(922032)	IND090.AT2
set eqFileName(922041)	ATK000.AT2
set eqFileName(922042)	ATK090.AT2
set eqFileName(922051)	BRS090.AT2
set eqFileName(922052)	BRS180.AT2
set eqFileName(922061)	CNA000.AT2
set eqFileName(922062)	CNA090.AT2
set eqFileName(922071)	CHY004-E.AT2
set eqFileName(922072)	CHY004-N.AT2
set eqFileName(922081)	HWA015-N.AT2
set eqFileName(922082)	HWA015-W.AT2
set eqFileName(922091)	HWA028-N.AT2
set eqFileName(922092)	HWA028-W.AT2

set eqFileName(931001)	C05085.AT2
set eqFileName(931002)	C05355.AT2
set eqFileName(931011)	H-PLS045.AT2
set eqFileName(931012)	H-PLS135.AT2
set eqFileName(931021)	H-CXO225.AT2
set eqFileName(931022)	H-CXO315.AT2
set eqFileName(931031)	H-E01140.AT2
set eqFileName(931032)	H-E01230.AT2
set eqFileName(931041)	H-WSM090.AT2
set eqFileName(931042)	H-WSM180.AT2
set eqFileName(931051)	H-GH2000.AT2
set eqFileName(931052)	H-GH2090.AT2
set eqFileName(931061)	H-GH3000.AT2
set eqFileName(931062)	H-GH3090.AT2
set eqFileName(931071)	G02000.AT2
set eqFileName(931072)	G02090.AT2
set eqFileName(931081)	B-BEN270.AT2
set eqFileName(931082)	B-BEN360.AT2
set eqFileName(931091)	A-COM140.AT2
set eqFileName(931092)	A-COM230.AT2

set eqFileName(932001)	PVE065.AT2
set eqFileName(932002)	PVE155.AT2
set eqFileName(932011)	H-VCT075.AT2
set eqFileName(932012)	H-VCT345.AT2
set eqFileName(932021)	H-C08000.AT2
set eqFileName(932022)	H-C08270.AT2
set eqFileName(932031)	HWB220.AT2
set eqFileName(932032)	HWB310.AT2
set eqFileName(932041)	IND000.AT2
set eqFileName(932042)	IND090.AT2
set eqFileName(932051)	LAN090.AT2
set eqFileName(932052)	LAN360.AT2
set eqFileName(932061)	MJO000.AT2
set eqFileName(932062)	MJO090.AT2
set eqFileName(932071)	NHO180.AT2
set eqFileName(932072)	NHO270.AT2
set eqFileName(932081)	WAI200-NRTHR.AT2
set eqFileName(932082)	WAI290-NRTHR.AT2
set eqFileName(932091)	TTN014-N.AT2
set eqFileName(932092)	TTN014-W.AT2

set eqFileName(933001)	PAS180.AT2
set eqFileName(933002)	PAS270.AT2
set eqFileName(933011)	SBF042.AT2
set eqFileName(933012)	SBF132.AT2
set eqFileName(933021)	ING000.AT2
set eqFileName(933022)	ING090.AT2
set eqFileName(933031)	DWN000.AT2
set eqFileName(933032)	DWN090.AT2
set eqFileName(933041)	W15090.AT2
set eqFileName(933042)	W15180.AT2
set eqFileName(933051)	FLE144.AT2
set eqFileName(933052)	FLE234.AT2
set eqFileName(933061)	WAI200-LNDRS.AT2
set eqFileName(933062)	WAI290-LNDRS.AT2
set eqFileName(933071)	ARC172.AT2
set eqFileName(933072)	ARC262.AT2
set eqFileName(933081)	CDF000.AT2
set eqFileName(933082)	CDF090.AT2
set eqFileName(933091)	KUT090.AT2
set eqFileName(933092)	KUT180.AT2

set eqFileName(941001)	L01021.AT2
set eqFileName(941002)	L01111.AT2
set eqFileName(941011)	H-PV1000.AT2
set eqFileName(941012)	H-PV1090.AT2
set eqFileName(941021)	HD4165.AT2
set eqFileName(941022)	HD4255.AT2
set eqFileName(941031)	NPS210.AT2
set eqFileName(941032)	NPS300.AT2
set eqFileName(941041)	MVH045.AT2
set eqFileName(941042)	MVH135.AT2
set eqFileName(941051)	A-ZAK270.AT2
set eqFileName(941052)	A-ZAK360.AT2
set eqFileName(941061)	A-EJS048.AT2
set eqFileName(941062)	A-EJS318.AT2
set eqFileName(941071)	A-DEL000.AT2
set eqFileName(941072)	A-DEL090.AT2
set eqFileName(941081)	PET000.AT2
set eqFileName(941082)	PET090.AT2
set eqFileName(941091)	RRS228.AT2
set eqFileName(941092)	RRS318.AT2

set eqFileName(942001)	ATS000.AT2
set eqFileName(942002)	ATS090.AT2

set eqFileName(951001)	L01021.AT2
set eqFileName(951002)	L01111.AT2
set eqFileName(951011)	PDL120.AT2
set eqFileName(951012)	PDL210.AT2
set eqFileName(951021)	HD5165.AT2
set eqFileName(951022)	HD5255.AT2
set eqFileName(951031)	MVH045.AT2
set eqFileName(951032)	MVH135.AT2
set eqFileName(951041)	A-ZAK270.AT2
set eqFileName(951042)	A-ZAK360.AT2
set eqFileName(951051)	A-DEL000.AT2
set eqFileName(951052)	A-DEL090.AT2
set eqFileName(951061)	HCH090.AT2
set eqFileName(951062)	HCH180.AT2
set eqFileName(951071)	WAH000.AT2
set eqFileName(951072)	WAH090.AT2
set eqFileName(951081)	RIO270.AT2
set eqFileName(951082)	RIO360.AT2
set eqFileName(951091)	SPV270.AT2
set eqFileName(951092)	SPV360.AT2

set eqFileName(952001)	TIB180.AT2
set eqFileName(952002)	TIB270.AT2
set eqFileName(952011)	ATS000.AT2
set eqFileName(952012)	ATS090.AT2
set eqFileName(952021)	HWA014-N.AT2
set eqFileName(952022)	HWA014-W.AT2
set eqFileName(952031)	KAU020-N.AT2
set eqFileName(952032)	KAU020-W.AT2

set eqFileName(961001)	PEL090-SFERN.AT2
set eqFileName(961002)	PEL180-SFERN.AT2
set eqFileName(961011)	H-PRK090.AT2
set eqFileName(961012)	H-PRK180.AT2
set eqFileName(961021)	DSP000.AT2
set eqFileName(961022)	DSP090.AT2
set eqFileName(961031)	MVH045.AT2
set eqFileName(961032)	MVH135.AT2
set eqFileName(961041)	A-ZAK270.AT2
set eqFileName(961042)	A-ZAK360.AT2
set eqFileName(961051)	A-HOL000.AT2
set eqFileName(961052)	A-HOL090.AT2
set eqFileName(961061)	A-ALH180.AT2
set eqFileName(961062)	A-ALH270.AT2
set eqFileName(961071)	A-DEL000.AT2
set eqFileName(961072)	A-DEL090.AT2
set eqFileName(961081)	STM090.AT2
set eqFileName(961082)	STM360.AT2
set eqFileName(961091)	SCS052.AT2
set eqFileName(961092)	SCS142.AT2
set eqFileName(962001)	TIB180.AT2
set eqFileName(962002)	TIB270.AT2
set eqFileName(962011)	HWA014-N.AT2
set eqFileName(962012)	HWA014-W.AT2
set eqFileName(962021)	KAU020-N.AT2
set eqFileName(962022)	KAU020-W.AT2

set eqFileName(971001)	PEL090-SFERN.AT2
set eqFileName(971002)	PEL180-SFERN.AT2
set eqFileName(971011)	SBA132.AT2
set eqFileName(971012)	SBA222.AT2
set eqFileName(971021)	H-PVY045.AT2
set eqFileName(971022)	H-PVY135.AT2
set eqFileName(971031)	G04270.AT2
set eqFileName(971032)	G04360.AT2
set eqFileName(971041)	NPS210.AT2
set eqFileName(971042)	NPS300.AT2
set eqFileName(971051)	A-ZAK270.AT2
set eqFileName(971052)	A-ZAK360.AT2
set eqFileName(971061)	A-ALH180.AT2
set eqFileName(971062)	A-ALH270.AT2
set eqFileName(971071)	WVC000.AT2
set eqFileName(971072)	WVC270.AT2
set eqFileName(971081)	PET000.AT2
set eqFileName(971082)	PET090.AT2
set eqFileName(971091)	RRS228.AT2
set eqFileName(971092)	RRS318.AT2

set eqFileName(972001)	TIB180.AT2
set eqFileName(972002)	TIB270.AT2
set eqFileName(972011)	A2E000.AT2
set eqFileName(972012)	A2E090.AT2
set eqFileName(972021)	HWB220.AT2
set eqFileName(972022)	HWB310.AT2
set eqFileName(972031)	EUR000.AT2
set eqFileName(972032)	EUR090.AT2
set eqFileName(972041)	IND000.AT2
set eqFileName(972042)	IND090.AT2
set eqFileName(972051)	ATK000.AT2
set eqFileName(972052)	ATK090.AT2
set eqFileName(972061)	BRS090.AT2
set eqFileName(972062)	BRS180.AT2
set eqFileName(972071)	HWA011-N.AT2
set eqFileName(972072)	HWA011-W.AT2
set eqFileName(972081)	HWA014-N.AT2
set eqFileName(972082)	HWA014-W.AT2
set eqFileName(972091)	KAU020-N.AT2
set eqFileName(972092)	KAU020-W.AT2

# Additional GMs added for Bin4A - called Bin4AExtra - labeled as Bin4C for numbering - 3-18-05
set eqFileName(943001)	H-CHI012.AT2
set eqFileName(943002)	H-CHI282.AT2;	# NOTE that this was fixed on 3-19-05 (was H-CHI082.AT2)
set eqFileName(943011)	B-LAD180.AT2
set eqFileName(943012)	B-LAD270.AT2
set eqFileName(943021)	A-ING000.AT2
set eqFileName(943022)	A-ING090.AT2
set eqFileName(943031)	A-HAR000.AT2
set eqFileName(943032)	A-HAR090.AT2
set eqFileName(943041)	A-116270.AT2
set eqFileName(943042)	A-116360.AT2
set eqFileName(943051)	A-HOL000.AT2
set eqFileName(943052)	A-HOL090.AT2
set eqFileName(943061)	A-OBR270.AT2
set eqFileName(943062)	A-OBR360.AT2
set eqFileName(943071)	A-ALH180.AT2
set eqFileName(943072)	A-ALH270.AT2
set eqFileName(943081)	A-NOR090.AT2
set eqFileName(943082)	A-NOR360.AT2
set eqFileName(943091)	A-CWC180.AT2
set eqFileName(943092)	A-CWC270.AT2
set eqFileName(943101)	A-CO2092.AT2
set eqFileName(943102)	A-CO2182.AT2
set eqFileName(943111)	A-BUE250.AT2
set eqFileName(943112)	A-BUE340.AT2
set eqFileName(943121)	A-W70000.AT2
set eqFileName(943122)	A-W70270.AT2
set eqFileName(943131)	A-FLE144.AT2
set eqFileName(943132)	A-FLE234.AT2
set eqFileName(943141)	A-LOA092.AT2
set eqFileName(943142)	A-LOA182.AT2
set eqFileName(943151)	A-NYA090.AT2
set eqFileName(943152)	A-NYA180.AT2
set eqFileName(943161)	A-CAS000.AT2
set eqFileName(943162)	A-CAS270.AT2
set eqFileName(943171)	A-WAT180.AT2
set eqFileName(943172)	A-WAT270.AT2
set eqFileName(943181)	A-JAB207.AT2
set eqFileName(943182)	A-JAB297.AT2
set eqFileName(943191)	HCH090.AT2
set eqFileName(943192)	HCH180.AT2
set eqFileName(943201)	HSP000.AT2
set eqFileName(943202)	HSP090.AT2
set eqFileName(943211)	RIO270.AT2
set eqFileName(943212)	RIO360.AT2
set eqFileName(943221)	JEN022.AT2
set eqFileName(943222)	JEN292.AT2
set eqFileName(943231)	SCS052.AT2
set eqFileName(943232)	SCS142.AT2
set eqFileName(943241)	STN020.AT2
set eqFileName(943242)	STN110.AT2
set eqFileName(943251)	FKS000.AT2
set eqFileName(943252)	FKS090.AT2

############################################################
# Bin 1A -- 7B Sa of COMPONENTS at T = 1.0 second (Geometric mean set)
set saTOneForEQ(911001)	0.1549
set saTOneForEQ(911002)	0.1166
set saTOneForEQ(911011)	0.2111
set saTOneForEQ(911012)	0.2914
set saTOneForEQ(911021)	0.1130
set saTOneForEQ(911022)	0.1599
set saTOneForEQ(911031)	0.1694
set saTOneForEQ(911032)	0.1850
set saTOneForEQ(911041)	0.0683
set saTOneForEQ(911042)	0.1539
set saTOneForEQ(911051)	0.0585
set saTOneForEQ(911052)	0.0535
set saTOneForEQ(911061)	0.2456
set saTOneForEQ(911062)	0.4812
set saTOneForEQ(911071)	0.4483
set saTOneForEQ(911072)	0.3462
set saTOneForEQ(911081)	0.5143
set saTOneForEQ(911082)	0.6519
set saTOneForEQ(911091)	0.1697
set saTOneForEQ(911092)	0.5885

set saTOneForEQ(912001)	0.1787
set saTOneForEQ(912002)	0.1603
set saTOneForEQ(912011)	0.2560
set saTOneForEQ(912012)	0.1770
set saTOneForEQ(912021)	0.1451
set saTOneForEQ(912022)	0.2343
set saTOneForEQ(912031)	0.0792
set saTOneForEQ(912032)	0.1036
set saTOneForEQ(912041)	0.2146
set saTOneForEQ(912042)	0.2745
set saTOneForEQ(912051)	0.0876
set saTOneForEQ(912052)	0.1506
set saTOneForEQ(912061)	0.1216
set saTOneForEQ(912062)	0.0580
set saTOneForEQ(912071)	0.1928
set saTOneForEQ(912072)	0.1470
set saTOneForEQ(912081)	0.0731
set saTOneForEQ(912082)	0.1178
set saTOneForEQ(912091)	0.2115
set saTOneForEQ(912092)	0.3176

set saTOneForEQ(921001)	0.0821
set saTOneForEQ(921002)	0.1764
set saTOneForEQ(921011)	0.2111
set saTOneForEQ(921012)	0.2914
set saTOneForEQ(921021)	0.5443
set saTOneForEQ(921022)	0.3118
set saTOneForEQ(921031)	0.0692
set saTOneForEQ(921032)	0.0865
set saTOneForEQ(921041)	0.1694
set saTOneForEQ(921042)	0.1850
set saTOneForEQ(921051)	0.0679
set saTOneForEQ(921052)	0.1255
set saTOneForEQ(921061)	0.1851
set saTOneForEQ(921062)	0.1530
set saTOneForEQ(921071)	0.0585
set saTOneForEQ(921072)	0.0535
set saTOneForEQ(921081)	0.0480
set saTOneForEQ(921082)	0.0608
set saTOneForEQ(921091)	0.1288
set saTOneForEQ(921092)	0.0844

set saTOneForEQ(922001)	0.1787
set saTOneForEQ(922002)	0.1603
set saTOneForEQ(922011)	0.3516
set saTOneForEQ(922012)	0.1592
set saTOneForEQ(922021)	0.1451
set saTOneForEQ(922022)	0.2343
set saTOneForEQ(922031)	0.1185
set saTOneForEQ(922032)	0.1729
set saTOneForEQ(922041)	0.2146
set saTOneForEQ(922042)	0.2745
set saTOneForEQ(922051)	0.0876
set saTOneForEQ(922052)	0.1506
set saTOneForEQ(922061)	0.1211
set saTOneForEQ(922062)	0.0980
set saTOneForEQ(922071)	0.1122
set saTOneForEQ(922072)	0.1483
set saTOneForEQ(922081)	0.2115
set saTOneForEQ(922082)	0.3176
set saTOneForEQ(922091)	0.2547
set saTOneForEQ(922092)	0.1185

set saTOneForEQ(931001)	0.1821
set saTOneForEQ(931002)	0.1517
set saTOneForEQ(931011)	0.0214
set saTOneForEQ(931012)	0.0600
set saTOneForEQ(931021)	0.1863
set saTOneForEQ(931022)	0.1539
set saTOneForEQ(931031)	0.1036
set saTOneForEQ(931032)	0.0704
set saTOneForEQ(931041)	0.0923
set saTOneForEQ(931042)	0.0959
set saTOneForEQ(931051)	0.1256
set saTOneForEQ(931052)	0.1106
set saTOneForEQ(931061)	0.1092
set saTOneForEQ(931062)	0.0612
set saTOneForEQ(931071)	0.0822
set saTOneForEQ(931072)	0.1020
set saTOneForEQ(931081)	0.0273
set saTOneForEQ(931082)	0.0214
set saTOneForEQ(931091)	0.0434
set saTOneForEQ(931092)	0.0488

set saTOneForEQ(932001)	0.0454
set saTOneForEQ(932002)	0.0482
set saTOneForEQ(932011)	0.0621
set saTOneForEQ(932012)	0.0703
set saTOneForEQ(932021)	0.0775
set saTOneForEQ(932022)	0.0737
set saTOneForEQ(932031)	0.3516
set saTOneForEQ(932032)	0.1592
set saTOneForEQ(932041)	0.1185
set saTOneForEQ(932042)	0.1729
set saTOneForEQ(932051)	0.0761
set saTOneForEQ(932052)	0.1237
set saTOneForEQ(932061)	0.0410
set saTOneForEQ(932062)	0.0247
set saTOneForEQ(932071)	0.0492
set saTOneForEQ(932072)	0.0588
set saTOneForEQ(932081)	0.0485
set saTOneForEQ(932082)	0.0644
set saTOneForEQ(932091)	0.1342
set saTOneForEQ(932092)	0.0763

set saTOneForEQ(933001)	0.0800
set saTOneForEQ(933002)	0.1675
set saTOneForEQ(933011)	0.0330
set saTOneForEQ(933012)	0.0462
set saTOneForEQ(933021)	0.1005
set saTOneForEQ(933022)	0.0998
set saTOneForEQ(933031)	0.1477
set saTOneForEQ(933032)	0.0835
set saTOneForEQ(933041)	0.0666
set saTOneForEQ(933042)	0.0596
set saTOneForEQ(933051)	0.0912
set saTOneForEQ(933052)	0.0863
set saTOneForEQ(933061)	0.1259
set saTOneForEQ(933062)	0.1406
set saTOneForEQ(933071)	0.0755
set saTOneForEQ(933072)	0.0499
set saTOneForEQ(933081)	0.0760
set saTOneForEQ(933082)	0.1278
set saTOneForEQ(933091)	0.2301
set saTOneForEQ(933092)	0.1112

set saTOneForEQ(941001)	0.3585
set saTOneForEQ(941002)	0.1574
set saTOneForEQ(941011)	0.5109
set saTOneForEQ(941012)	0.5559
set saTOneForEQ(941021)	0.1694
set saTOneForEQ(941022)	0.1850
set saTOneForEQ(941031)	0.8643
set saTOneForEQ(941032)	0.2752
set saTOneForEQ(941041)	0.5356
set saTOneForEQ(941042)	0.3445
set saTOneForEQ(941051)	0.4117
set saTOneForEQ(941052)	0.6001
set saTOneForEQ(941061)	0.3138
set saTOneForEQ(941062)	0.1419
set saTOneForEQ(941071)	0.3828
set saTOneForEQ(941072)	0.1231
set saTOneForEQ(941081)	0.6137
set saTOneForEQ(941082)	0.9907
set saTOneForEQ(941091)	1.8339
set saTOneForEQ(941092)	0.8155

set saTOneForEQ(942001)	0.4674
set saTOneForEQ(942002)	0.5858

set saTOneForEQ(951001)	0.3585
set saTOneForEQ(951002)	0.1574
set saTOneForEQ(951011)	0.1549
set saTOneForEQ(951012)	0.1166
set saTOneForEQ(951021)	0.1456
set saTOneForEQ(951022)	0.1632
set saTOneForEQ(951031)	0.5356
set saTOneForEQ(951032)	0.3445
set saTOneForEQ(951041)	0.4117
set saTOneForEQ(951042)	0.6001
set saTOneForEQ(951051)	0.3828
set saTOneForEQ(951052)	0.1231
set saTOneForEQ(951061)	0.5083
set saTOneForEQ(951062)	0.6787
set saTOneForEQ(951071)	0.5368
set saTOneForEQ(951072)	0.5788
set saTOneForEQ(951081)	0.5409
set saTOneForEQ(951082)	0.3895
set saTOneForEQ(951091)	1.1328
set saTOneForEQ(951092)	0.6359

set saTOneForEQ(952001)	0.3642
set saTOneForEQ(952002)	0.5366
set saTOneForEQ(952011)	0.4674
set saTOneForEQ(952012)	0.5858
set saTOneForEQ(952021)	0.3008
set saTOneForEQ(952022)	0.3396
set saTOneForEQ(952031)	0.2770
set saTOneForEQ(952032)	0.2538

set saTOneForEQ(961001)	0.2477
set saTOneForEQ(961002)	0.1554
set saTOneForEQ(961011)	0.2157
set saTOneForEQ(961012)	0.3430
set saTOneForEQ(961021)	0.3523
set saTOneForEQ(961022)	0.2004
set saTOneForEQ(961031)	0.5356
set saTOneForEQ(961032)	0.3445
set saTOneForEQ(961041)	0.4117
set saTOneForEQ(961042)	0.6001
set saTOneForEQ(961051)	0.1221
set saTOneForEQ(961052)	0.1009
set saTOneForEQ(961061)	0.3575
set saTOneForEQ(961062)	0.1924
set saTOneForEQ(961071)	0.3828
set saTOneForEQ(961072)	0.1231
set saTOneForEQ(961081)	0.3283
set saTOneForEQ(961082)	0.3425
set saTOneForEQ(961091)	1.3629
set saTOneForEQ(961092)	1.4029

set saTOneForEQ(962001)	0.3642
set saTOneForEQ(962002)	0.5366
set saTOneForEQ(962011)	0.3008
set saTOneForEQ(962012)	0.3396
set saTOneForEQ(962021)	0.2770
set saTOneForEQ(962022)	0.2538

set saTOneForEQ(971001)	0.2477
set saTOneForEQ(971002)	0.1554
set saTOneForEQ(971011)	0.0821
set saTOneForEQ(971012)	0.1764
set saTOneForEQ(971021)	0.9981
set saTOneForEQ(971022)	0.5021
set saTOneForEQ(971031)	0.2680
set saTOneForEQ(971032)	0.2731
set saTOneForEQ(971041)	0.8643
set saTOneForEQ(971042)	0.2752
set saTOneForEQ(971051)	0.4117
set saTOneForEQ(971052)	0.6001
set saTOneForEQ(971061)	0.3575
set saTOneForEQ(971062)	0.1924
set saTOneForEQ(971071)	0.5143
set saTOneForEQ(971072)	0.6519
set saTOneForEQ(971081)	0.6137
set saTOneForEQ(971082)	0.9907
set saTOneForEQ(971091)	1.8339
set saTOneForEQ(971092)	0.8155
set saTOneForEQ(972001)	0.3642
set saTOneForEQ(972002)	0.5366
set saTOneForEQ(972011)	0.2560
set saTOneForEQ(972012)	0.1770
set saTOneForEQ(972021)	0.3516
set saTOneForEQ(972022)	0.1592
set saTOneForEQ(972031)	0.1451
set saTOneForEQ(972032)	0.2343
set saTOneForEQ(972041)	0.1185
set saTOneForEQ(972042)	0.1729
set saTOneForEQ(972051)	0.2146
set saTOneForEQ(972052)	0.2745
set saTOneForEQ(972061)	0.0876
set saTOneForEQ(972062)	0.1506
set saTOneForEQ(972071)	0.2810
set saTOneForEQ(972072)	0.2165
set saTOneForEQ(972081)	0.3008
set saTOneForEQ(972082)	0.3396
set saTOneForEQ(972091)	0.2770
set saTOneForEQ(972092)	0.2538

# Additional GMs added for Bin4A - called Bin4AExtra - labeled as Bin4C for numbering - 3-18-05
set saTOneForEQ(943001)	0.2817
set saTOneForEQ(943002)	0.4391
set saTOneForEQ(943011)	0.1508
set saTOneForEQ(943012)	0.1082
set saTOneForEQ(943021)	0.0609
set saTOneForEQ(943022)	0.2318
set saTOneForEQ(943031)	0.0772
set saTOneForEQ(943032)	0.0885
set saTOneForEQ(943041)	0.2229
set saTOneForEQ(943042)	0.1705
set saTOneForEQ(943051)	0.1221
set saTOneForEQ(943052)	0.1009
set saTOneForEQ(943061)	0.2335
set saTOneForEQ(943062)	0.2479
set saTOneForEQ(943071)	0.3575
set saTOneForEQ(943072)	0.1924
set saTOneForEQ(943081)	0.1125
set saTOneForEQ(943082)	0.2458
set saTOneForEQ(943091)	0.0864
set saTOneForEQ(943092)	0.0762
set saTOneForEQ(943101)	0.0955
set saTOneForEQ(943102)	0.1151
set saTOneForEQ(943111)	0.1369
set saTOneForEQ(943112)	0.0893
set saTOneForEQ(943121)	0.3035
set saTOneForEQ(943122)	0.1318
set saTOneForEQ(943131)	0.2548
set saTOneForEQ(943132)	0.1823
set saTOneForEQ(943141)	0.0784
set saTOneForEQ(943142)	0.1027
set saTOneForEQ(943151)	0.0854
set saTOneForEQ(943152)	0.1228
set saTOneForEQ(943161)	0.3900
set saTOneForEQ(943162)	0.1583
set saTOneForEQ(943171)	0.1384
set saTOneForEQ(943172)	0.1576
set saTOneForEQ(943181)	0.2060
set saTOneForEQ(943182)	0.3269
set saTOneForEQ(943191)	0.5083
set saTOneForEQ(943192)	0.6787
set saTOneForEQ(943201)	1.0080
set saTOneForEQ(943202)	0.3649
set saTOneForEQ(943211)	0.5409
set saTOneForEQ(943212)	0.3895
set saTOneForEQ(943221)	1.1022
set saTOneForEQ(943222)	1.7704
set saTOneForEQ(943231)	1.3629
set saTOneForEQ(943232)	1.4029
set saTOneForEQ(943241)	0.3655
set saTOneForEQ(943242)	0.5005
set saTOneForEQ(943251)	0.8820
set saTOneForEQ(943252)	0.5271


############################################################
# Bin 1A -- 7B Sa of Geometric mean of both horizontal components at T = 1.0 second (Geometric mean set)
set saTOneForEQGeoMean(91100)	0.134
set saTOneForEQGeoMean(91101)	0.248
set saTOneForEQGeoMean(91102)	0.134
set saTOneForEQGeoMean(91103)	0.177
set saTOneForEQGeoMean(91104)	0.103
set saTOneForEQGeoMean(91105)	0.056
set saTOneForEQGeoMean(91106)	0.344
set saTOneForEQGeoMean(91107)	0.394
set saTOneForEQGeoMean(91108)	0.579
set saTOneForEQGeoMean(91109)	0.316

set saTOneForEQGeoMean(91200)	0.169
set saTOneForEQGeoMean(91201)	0.213
set saTOneForEQGeoMean(91202)	0.184
set saTOneForEQGeoMean(91203)	0.091
set saTOneForEQGeoMean(91204)	0.243
set saTOneForEQGeoMean(91205)	0.115
set saTOneForEQGeoMean(91206)	0.084
set saTOneForEQGeoMean(91207)	0.168
set saTOneForEQGeoMean(91208)	0.093
set saTOneForEQGeoMean(91209)	0.259

set saTOneForEQGeoMean(92100)	0.120
set saTOneForEQGeoMean(92101)	0.248
set saTOneForEQGeoMean(92102)	0.412
set saTOneForEQGeoMean(92103)	0.077
set saTOneForEQGeoMean(92104)	0.177
set saTOneForEQGeoMean(92105)	0.092
set saTOneForEQGeoMean(92106)	0.168
set saTOneForEQGeoMean(92107)	0.056
set saTOneForEQGeoMean(92108)	0.054
set saTOneForEQGeoMean(92109)	0.104

set saTOneForEQGeoMean(92200)	0.169
set saTOneForEQGeoMean(92201)	0.237
set saTOneForEQGeoMean(92202)	0.184
set saTOneForEQGeoMean(92203)	0.143
set saTOneForEQGeoMean(92204)	0.243
set saTOneForEQGeoMean(92205)	0.115
set saTOneForEQGeoMean(92206)	0.109
set saTOneForEQGeoMean(92207)	0.129
set saTOneForEQGeoMean(92208)	0.259
set saTOneForEQGeoMean(92209)	0.174

set saTOneForEQGeoMean(93100)	0.166
set saTOneForEQGeoMean(93101)	0.036
set saTOneForEQGeoMean(93102)	0.169
set saTOneForEQGeoMean(93103)	0.085
set saTOneForEQGeoMean(93104)	0.094
set saTOneForEQGeoMean(93105)	0.118
set saTOneForEQGeoMean(93106)	0.082
set saTOneForEQGeoMean(93107)	0.092
set saTOneForEQGeoMean(93108)	0.024
set saTOneForEQGeoMean(93109)	0.046

set saTOneForEQGeoMean(93200)	0.047
set saTOneForEQGeoMean(93201)	0.066
set saTOneForEQGeoMean(93202)	0.076
set saTOneForEQGeoMean(93203)	0.237
set saTOneForEQGeoMean(93204)	0.143
set saTOneForEQGeoMean(93205)	0.097
set saTOneForEQGeoMean(93206)	0.032
set saTOneForEQGeoMean(93207)	0.054
set saTOneForEQGeoMean(93208)	0.056
set saTOneForEQGeoMean(93209)	0.101

set saTOneForEQGeoMean(93300)	0.116
set saTOneForEQGeoMean(93301)	0.039
set saTOneForEQGeoMean(93302)	0.100
set saTOneForEQGeoMean(93303)	0.111
set saTOneForEQGeoMean(93304)	0.063
set saTOneForEQGeoMean(93305)	0.089
set saTOneForEQGeoMean(93306)	0.133
set saTOneForEQGeoMean(93307)	0.061
set saTOneForEQGeoMean(93308)	0.099
set saTOneForEQGeoMean(93309)	0.160

set saTOneForEQGeoMean(94100)	0.238
set saTOneForEQGeoMean(94101)	0.533
set saTOneForEQGeoMean(94102)	0.177
set saTOneForEQGeoMean(94103)	0.488
set saTOneForEQGeoMean(94104)	0.430
set saTOneForEQGeoMean(94105)	0.497
set saTOneForEQGeoMean(94106)	0.211
set saTOneForEQGeoMean(94107)	0.217
set saTOneForEQGeoMean(94108)	0.780
set saTOneForEQGeoMean(94109)	1.223

set saTOneForEQGeoMean(94200)	0.523

set saTOneForEQGeoMean(95100)	0.238
set saTOneForEQGeoMean(95101)	0.134
set saTOneForEQGeoMean(95102)	0.154
set saTOneForEQGeoMean(95103)	0.430
set saTOneForEQGeoMean(95104)	0.497
set saTOneForEQGeoMean(95105)	0.217
set saTOneForEQGeoMean(95106)	0.587
set saTOneForEQGeoMean(95107)	0.557
set saTOneForEQGeoMean(95108)	0.459
set saTOneForEQGeoMean(95109)	0.849

set saTOneForEQGeoMean(95200)	0.442
set saTOneForEQGeoMean(95201)	0.523
set saTOneForEQGeoMean(95202)	0.320
set saTOneForEQGeoMean(95203)	0.265

set saTOneForEQGeoMean(96100)	0.196
set saTOneForEQGeoMean(96101)	0.272
set saTOneForEQGeoMean(96102)	0.266
set saTOneForEQGeoMean(96103)	0.430
set saTOneForEQGeoMean(96104)	0.497
set saTOneForEQGeoMean(96105)	0.111
set saTOneForEQGeoMean(96106)	0.262
set saTOneForEQGeoMean(96107)	0.217
set saTOneForEQGeoMean(96108)	0.335
set saTOneForEQGeoMean(96109)	1.383

set saTOneForEQGeoMean(96200)	0.442
set saTOneForEQGeoMean(96201)	0.320
set saTOneForEQGeoMean(96202)	0.265

set saTOneForEQGeoMean(97100)	0.196
set saTOneForEQGeoMean(97101)	0.120
set saTOneForEQGeoMean(97102)	0.708
set saTOneForEQGeoMean(97103)	0.271
set saTOneForEQGeoMean(97104)	0.488
set saTOneForEQGeoMean(97105)	0.497
set saTOneForEQGeoMean(97106)	0.262
set saTOneForEQGeoMean(97107)	0.579
set saTOneForEQGeoMean(97108)	0.780
set saTOneForEQGeoMean(97109)	1.223

set saTOneForEQGeoMean(97200)	0.442
set saTOneForEQGeoMean(97201)	0.213
set saTOneForEQGeoMean(97202)	0.237
set saTOneForEQGeoMean(97203)	0.184
set saTOneForEQGeoMean(97204)	0.143
set saTOneForEQGeoMean(97205)	0.243
set saTOneForEQGeoMean(97206)	0.115
set saTOneForEQGeoMean(97207)	0.247
set saTOneForEQGeoMean(97208)	0.320
set saTOneForEQGeoMean(97209)	0.265

# Additional GMs added for Bin4A - called Bin4AExtra - labeled as Bin4C for numbering - 3-18-05
set saTOneForEQGeoMean(94300)	0.3517
set saTOneForEQGeoMean(94301)	0.1277
set saTOneForEQGeoMean(94302)	0.1188
set saTOneForEQGeoMean(94303)	0.0827
set saTOneForEQGeoMean(94304)	0.1949
set saTOneForEQGeoMean(94305)	0.1110
set saTOneForEQGeoMean(94306)	0.2406
set saTOneForEQGeoMean(94307)	0.2623
set saTOneForEQGeoMean(94308)	0.1663
set saTOneForEQGeoMean(94309)	0.0811
set saTOneForEQGeoMean(94310)	0.1049
set saTOneForEQGeoMean(94311)	0.1105
set saTOneForEQGeoMean(94312)	0.2000
set saTOneForEQGeoMean(94313)	0.2155
set saTOneForEQGeoMean(94314)	0.0897
set saTOneForEQGeoMean(94315)	0.1024
set saTOneForEQGeoMean(94316)	0.2485
set saTOneForEQGeoMean(94317)	0.1477
set saTOneForEQGeoMean(94318)	0.2595
set saTOneForEQGeoMean(94319)	0.5873
set saTOneForEQGeoMean(94320)	0.6065
set saTOneForEQGeoMean(94321)	0.4590
set saTOneForEQGeoMean(94322)	1.3969
set saTOneForEQGeoMean(94323)	1.3828
set saTOneForEQGeoMean(94324)	0.4277
set saTOneForEQGeoMean(94325)	0.6818

# Record to use for Pauls damping test - just EQ 941082 (just the single comp.), but with 900 zeros added
set saTOneForEQGeoMean(99999) 0.9907

################ End of record set on 12-15-04 ######################################################

################### Record Information for previous record sets ######################################

# Define the EQ file name for all fo the EQ's to be used by this model
set eqFileName(1) 	IV79e01.txt
set eqFileName(2) 	IV79qkp.txt
set eqFileName(3) 	MH84g02.txt
set eqFileName(4) 	PS86psa.txt
set eqFileName(5) 	WN87cas.txt
set eqFileName(6) 	WN87w70.txt
set eqFileName(7) 	LP89cap.txt
set eqFileName(8) 	LP89g03.txt
set eqFileName(9) 	LP89g04.txt
set eqFileName(10) 	NR94cnp.txt
set eqFileName(11) 	NR94far.txt
set eqFileName(12) 	NR94stc.txt
set eqFileName(13) 	SF71pel.txt
set eqFileName(14) 	SF71bra.txt
set eqFileName(15) 	SF71icc.txt

# Record to use for Pauls damping test - just EQ 941082 (just the single comp.), but with 900 zeros added
set eqFileName(999991) 	EQ_999991.AT2
set eqFileName(999992) 	EQ_999992.AT2

# Bin 1A
set eqFileName(100) I-ELC270.AT2
set eqFileName(101) C05085.AT2
set eqFileName(102) PEL090-SFERN.AT2
set eqFileName(103) PEL180-SFERN.AT2
set eqFileName(104) H-E10320.AT2
set eqFileName(105) H-HVP315.AT2
set eqFileName(106) H-BRA225.AT2
set eqFileName(107) H-BRA315.AT2
set eqFileName(108) H-AGR003.AT2
set eqFileName(109) H-SHP000.AT2
set eqFileName(110) G03090.AT2
set eqFileName(111) G04270.AT2
set eqFileName(112) NPS300.AT2
set eqFileName(113) WWT180.AT2
set eqFileName(114) A-LAD180.AT2
set eqFileName(115) A-LAD270.AT2
set eqFileName(116) B-ICC090.AT2
set eqFileName(117) B-WSM090.AT2
set eqFileName(118) CAP090.AT2
set eqFileName(119) G04000.AT2
set eqFileName(120) BVA285.AT2
set eqFileName(121) STC090.AT2
set eqFileName(122) CWC180.AT2
set eqFileName(123) MU2125.AT2
set eqFileName(124) CNP106.AT2
set eqFileName(125) LOS000.AT2
set eqFileName(126) NIS000.AT2
set eqFileName(127) NIS090.AT2
set eqFileName(128) SHI090.AT2

# Bin 1B
set eqFileName(150) TIB180.AT2
set eqFileName(151) A2E000.AT2
set eqFileName(152) A2E090.AT2
set eqFileName(153) HWB220.AT2
set eqFileName(154) EUR000.AT2
set eqFileName(155) EUR090.AT2
set eqFileName(156) IND000.AT2
set eqFileName(157) IND090.AT2
set eqFileName(158) H05090.AT2
set eqFileName(159) HOS090-LNDRS.AT2
set eqFileName(160) HOS180-LNDRS.AT2
set eqFileName(161) FTI090.AT2
set eqFileName(162) HWA003-N.AT2
set eqFileName(163) HWA005-N.AT2
set eqFileName(164) HWA028-N.AT2
set eqFileName(165) KAU020-W.AT2
set eqFileName(166) TCU017-N.AT2
set eqFileName(167) TCU095-N.AT2

# Bin 2A
set eqFileName(200) C05085.AT2
set eqFileName(201) L01111.AT2
set eqFileName(202) PEL180-SFERN.AT2
set eqFileName(203) SBA222.AT2
set eqFileName(204) H-E10050.AT2
set eqFileName(205) H-CXO225.AT2
set eqFileName(206) H-E13140.AT2
set eqFileName(207) H-BRA225.AT2
set eqFileName(208) H-E12140.AT2
set eqFileName(209) H-VC1000.AT2
set eqFileName(210) HD3165.AT2
set eqFileName(211) HD5165.AT2
set eqFileName(212) G03090.AT2
set eqFileName(213) G04270.AT2
set eqFileName(214) DSP090.AT2
set eqFileName(215) A-LAD180.AT2
set eqFileName(216) B-PLS135.AT2
set eqFileName(217) B-BRA225.AT2
set eqFileName(218) B-IVW090.AT2
set eqFileName(219) AGW090.AT2
set eqFileName(220) FOR090.AT2
set eqFileName(221) W15180.AT2
set eqFileName(222) LOS000.AT2
set eqFileName(223) ABN090.AT2
set eqFileName(224) SKI000.AT2
set eqFileName(225) SHI090.AT2

# Bin 2B
set eqFileName(250) TIB180.AT2
set eqFileName(251) TIB270.AT2
set eqFileName(252) HWA2-W.AT2
set eqFileName(253) NCU-E.AT2
set eqFileName(254) TCU011-W.AT2
set eqFileName(255) TCU083-W.AT2
set eqFileName(256) TCU095-N.AT2
set eqFileName(257) TCU095-W.AT2
set eqFileName(258) TTN032-N.AT2

# Bin 3A
set eqFileName(300) CHY017-E.AT2
set eqFileName(301) CHY019-E.AT2
set eqFileName(302) CHY027-W.AT2
set eqFileName(303) CHY050-W.AT2
set eqFileName(304) CHY057-W.AT2
set eqFileName(305) CHY060-N.AT2
set eqFileName(306) CHY062-N.AT2
set eqFileName(307) CHY093-E.AT2
set eqFileName(308) ENA-N.AT2
set eqFileName(309) HWA002-E.AT2
set eqFileName(310) HWA006-N.AT2
set eqFileName(311) HWA023-N.AT2
set eqFileName(312) HWA034-N.AT2
set eqFileName(313) HWA035-N.AT2
set eqFileName(314) HWA038-N.AT2
set eqFileName(315) HWA056-W.AT2
set eqFileName(316) ILA051-N.AT2
set eqFileName(317) KAU050-W.AT2
set eqFileName(318) NSK-N.AT2
set eqFileName(319) TCU025-N.AT2
set eqFileName(320) TCU085-N.AT2
set eqFileName(321) TTN014-W.AT2
set eqFileName(322) TTN041-E.AT2
set eqFileName(323) TTN041-N.AT2

# Bin 3B
set eqFileName(350) PEL180-KERNC.AT2
set eqFileName(351) PAS270.AT2
set eqFileName(352) SJC033.AT2
set eqFileName(353) SJC303.AT2
set eqFileName(354) RCH190.AT2
set eqFileName(355) RCH280.AT2
set eqFileName(356) ING090.AT2
set eqFileName(357) RO3000.AT2
set eqFileName(358) COM140.AT2
set eqFileName(359) OR2280.AT2
set eqFileName(360) BPK180.AT2
set eqFileName(361) FLO290.AT2
set eqFileName(362) CDF000.AT2
set eqFileName(363) CDF090.AT2
set eqFileName(364) HOS180-NRTHR.AT2
set eqFileName(365) FUK000.AT2
set eqFileName(366) FUK090.AT2
set eqFileName(367) KAU037-N.AT2
set eqFileName(368) KAU073-W.AT2
set eqFileName(369) TAP067-N.AT2
set eqFileName(370) TAP069-N.AT2
set eqFileName(371) TAP078-N.AT2

# Bin 4A
set eqFileName(400) L01021.AT2
set eqFileName(401) H-CHI012.AT2
set eqFileName(402) H-CHI282.AT2
set eqFileName(403) NPS210.AT2
set eqFileName(404) MVH045.AT2
set eqFileName(405) A-ZAK270.AT2
set eqFileName(406) A-ZAK360.AT2
set eqFileName(407) A-ING090.AT2
set eqFileName(408) A-LBR000.AT2
set eqFileName(409) A-LBR090.AT2
set eqFileName(410) A-DWN180.AT2
set eqFileName(411) A-116270.AT2
set eqFileName(412) A-OBR270.AT2
set eqFileName(413) A-OBR360.AT2
set eqFileName(414) A-SMA360.AT2
set eqFileName(415) A-ALH180.AT2
set eqFileName(416) A-NOR360.AT2
set eqFileName(417) A-W70000.AT2
set eqFileName(418) A-FLE144.AT2
set eqFileName(419) A-EJS048.AT2
set eqFileName(420) A-CAS000.AT2
set eqFileName(421) A-OR2010.AT2
set eqFileName(422) A-DEL000.AT2
set eqFileName(423) A-JAB297.AT2
set eqFileName(424) HSP000.AT2
set eqFileName(425) PET090.AT2
set eqFileName(426) JEN292.AT2
set eqFileName(427) RRS228.AT2
set eqFileName(428) MUL009.AT2
set eqFileName(429) MUL279.AT2
set eqFileName(430) WIL180.AT2
set eqFileName(431) STN110.AT2
set eqFileName(432) FKS000.AT2
set eqFileName(433) BOL000.AT2
set eqFileName(434) BOL090.AT2
set eqFileName(435) CHY006-N.AT2
set eqFileName(436) CHY034-N.AT2
set eqFileName(437) TCU072-W.AT2
set eqFileName(438) TCU074-W.AT2
set eqFileName(439) TCU084-N.AT2
set eqFileName(440) TCU084-W.AT2

# Bin 4B
# NO RECORDS

# Bin 5A
set eqFileName(500) L01021.AT2
set eqFileName(501) PEL090-SFERN.AT2
set eqFileName(502) H-PV1090.AT2
set eqFileName(503) HD3255.AT2
set eqFileName(504) HD4255.AT2
set eqFileName(505) MVH045.AT2
set eqFileName(506) A-ZAK270.AT2
set eqFileName(507) A-ZAK360.AT2
set eqFileName(508) B-IVW360.AT2
set eqFileName(509) HCH090.AT2
set eqFileName(510) HDA255.AT2
set eqFileName(511) PET000.AT2
set eqFileName(512) RIO270.AT2
set eqFileName(513) SPV270.AT2
set eqFileName(514) JEN022.AT2
set eqFileName(515) NWH360.AT2
set eqFileName(516) RO3090.AT2
set eqFileName(517) WIL180.AT2
set eqFileName(518) CNP196.AT2
set eqFileName(519) LOS270.AT2
set eqFileName(520) STN110.AT2
set eqFileName(521) AMA000.AT2
set eqFileName(522) FKS000.AT2
set eqFileName(523) FKS090.AT2
set eqFileName(524) MRG000.AT2
set eqFileName(525) YAE000.AT2

# Bin 5B
set eqFileName(550) TIB180.AT2
set eqFileName(551) TIB270.AT2
set eqFileName(552) HWA2-W.AT2
set eqFileName(553) NCU-E.AT2
set eqFileName(554) TCU011-W.AT2
set eqFileName(555) TCU083-W.AT2
set eqFileName(556) TCU095-N.AT2
set eqFileName(557) TCU095-W.AT2
set eqFileName(558) TTN032-N.AT2

# Bin 6A
set eqFileName(600) PEL090-SFERN.AT2
set eqFileName(601) H-AEP045.AT2
set eqFileName(602) H-CHI282.AT2
set eqFileName(603) H-CAK270.AT2
set eqFileName(604) HD3255.AT2
set eqFileName(605) HD4165.AT2
set eqFileName(606) HD4255.AT2
set eqFileName(607) MVH045.AT2
set eqFileName(608) A-ZAK270.AT2
set eqFileName(609) A-ZAK360.AT2
set eqFileName(610) A-CAS000.AT2
set eqFileName(611) A-OR2010.AT2
set eqFileName(612) A-DEL000.AT2
set eqFileName(613) B-IVW360.AT2
set eqFileName(614) RIO360.AT2
set eqFileName(615) SPV270.AT2
set eqFileName(616) JEN022.AT2
set eqFileName(617) NWH360.AT2
set eqFileName(618) HOL360.AT2
set eqFileName(619) CCN360.AT2
set eqFileName(620) LOS270.AT2
set eqFileName(621) STN110.AT2
set eqFileName(622) AMA000.AT2
set eqFileName(623) FKS000.AT2
set eqFileName(624) FKS090.AT2
set eqFileName(625) MRG000.AT2
set eqFileName(626) YAE000.AT2

# Bin 6B
set eqFileName(650) TIB180.AT2
set eqFileName(651) TIB270.AT2
set eqFileName(652) HWA2-W.AT2
set eqFileName(653) NCU-E.AT2
set eqFileName(654) TCU011-W.AT2
set eqFileName(655) TCU083-W.AT2
set eqFileName(656) TCU095-N.AT2
set eqFileName(657) TCU095-W.AT2
set eqFileName(658) TTN032-N.AT2

# Bin 7A
set eqFileName(700) PEL090-SFERN.AT2
set eqFileName(701) H-HVP225.AT2
set eqFileName(702) H-ECC002.AT2
set eqFileName(703) H-ECC092.AT2
set eqFileName(704) H-SHP270.AT2
set eqFileName(705) H-E12140.AT2
set eqFileName(706) H-Z10090.AT2
set eqFileName(707) H-Z16000.AT2
set eqFileName(708) HD4255.AT2
set eqFileName(709) G04270.AT2
set eqFileName(710) G04360.AT2
set eqFileName(711) WWT180.AT2
set eqFileName(712) WWT270.AT2
set eqFileName(713) A-LAD180.AT2
set eqFileName(714) A-LAD270.AT2
set eqFileName(715) B-WSM180.AT2
set eqFileName(716) B-IVW360.AT2
set eqFileName(717) SVL360.AT2
set eqFileName(718) STM090.AT2
set eqFileName(719) CNP106.AT2
set eqFileName(720) WPI316.AT2
set eqFileName(721) LOS000.AT2
set eqFileName(722) ABN000.AT2
set eqFileName(723) MRG090.AT2

# Bin 7B
set eqFileName(750) TIB180.AT2
set eqFileName(751) TIB270.AT2
set eqFileName(752) A2E000.AT2
set eqFileName(753) A2E090.AT2
set eqFileName(754) HWB220.AT2
set eqFileName(755) EUR000.AT2
set eqFileName(756) EUR090.AT2
set eqFileName(757) IND000.AT2
set eqFileName(758) IND090.AT2
set eqFileName(759) HOS090-LNDRS.AT2
set eqFileName(760) HOS180-LNDRS.AT2
set eqFileName(761) FTI090.AT2
set eqFileName(762) HWA003-N.AT2
set eqFileName(763) HWA011-N.AT2
set eqFileName(764) HWA014-N.AT2
set eqFileName(765) HWA015-W.AT2
set eqFileName(766) HWA031-N.AT2
set eqFileName(767) KAU020-N.AT2
set eqFileName(768) TCU095-N.AT2

## New records for sens study - 10-22-04
#set eqFileName(1250) TAF021.AT2
#set eqFileName(1253) A2E000.AT2
#set eqFileName(1256) EUR090.AT2
#set eqFileName(1300) C05355.AT2
#set eqFileName(1301) H-PTS225.AT2
#set eqFileName(1309) H-GH2000.AT2
#set eqFileName(1315) G02000.AT2
#set eqFileName(1318) A-SMA270.AT2
#set eqFileName(1350) TAF111.AT2
#set eqFileName(1351) PDL210.AT2
#set eqFileName(1352) H-CC4135.AT2
#set eqFileName(1354) H-C04000.AT2
#set eqFileName(1357) A2E000.AT2
#set eqFileName(1506) G04360.AT2
#set eqFileName(1522) LOS270.AT2
#set eqFileName(1626) STN110.AT2
#set eqFileName(1619) RIO360.AT2

#######################################################################################################################
# Define the dTforEQ for all fo the EQ's to be used by this model.  This is only needed for records that are formatted.  
#	For PEER records, this is automatically extracted from the file.
set dtForEQ(1) 	0.005
set dtForEQ(2) 	0.005
set dtForEQ(3) 	0.005
set dtForEQ(4) 	0.005
set dtForEQ(5) 	0.02
set dtForEQ(6) 	0.02
set dtForEQ(7) 	0.005
set dtForEQ(8) 	0.005
set dtForEQ(9) 	0.005
set dtForEQ(10) 	0.01
set dtForEQ(11) 	0.01
set dtForEQ(12) 	0.01
set dtForEQ(13) 	0.01
set dtForEQ(14) 	0.01
set dtForEQ(15) 	0.005

#######################################################################################################################
# Define the lengths of the EQ (number of points in record) for all fo the EQ's to be used by this model.  This is only 
#	needed for records that are formatted.  For PEER records, this is automatically extracted from the file.
set numPointsForEQ(1) 	7805 
set numPointsForEQ(2) 	7995 
set numPointsForEQ(3) 	5990 
set numPointsForEQ(4) 	5995 
set numPointsForEQ(5) 	1559 
set numPointsForEQ(6) 	1590 
set numPointsForEQ(7) 	7990 
set numPointsForEQ(8) 	7985 
set numPointsForEQ(9) 	7990 
set numPointsForEQ(10) 	2495 
set numPointsForEQ(11) 	2995 
set numPointsForEQ(12) 	2995 
set numPointsForEQ(13) 	2800 
set numPointsForEQ(14) 	2210 
set numPointsForEQ(15) 	8000 

#######################################################################################################################
# Define the Sa value at T1 (units of g) (of the model) for the EQ) - for all fo the EQ's to be used by this model
##############################################
## These are for 1.25 seconds for records 1-15
#set saTOneForEQ(1) 	0.07
#set saTOneForEQ(2) 	0.33
#set saTOneForEQ(3) 	0.08
#set saTOneForEQ(4) 	0.12
#set saTOneForEQ(5) 	0.22
#set saTOneForEQ(6) 	0.12
#set saTOneForEQ(7) 	0.29
#set saTOneForEQ(8) 	0.38
#set saTOneForEQ(9) 	0.44
#set saTOneForEQ(10) 	0.40
#set saTOneForEQ(11) 	0.08
#set saTOneForEQ(12) 	0.44
#set saTOneForEQ(13) 	0.09
#set saTOneForEQ(14) 	0.09
#set saTOneForEQ(15) 	0.46

##############################################
# These are for 1.00 seconds for records 1-15
set saTOneForEQ(1) 	0.10
set saTOneForEQ(2) 	0.33
set saTOneForEQ(3) 	0.08
set saTOneForEQ(4) 	0.15
set saTOneForEQ(5) 	0.38
set saTOneForEQ(6) 	0.13
set saTOneForEQ(7) 	0.28
set saTOneForEQ(8) 	0.38
set saTOneForEQ(9) 	0.34
set saTOneForEQ(10) 	0.50
set saTOneForEQ(11) 	0.15
set saTOneForEQ(12) 	0.29
set saTOneForEQ(13) 	0.15
set saTOneForEQ(14) 	0.18
set saTOneForEQ(15) 	0.31

# Record to use for Pauls damping test - just EQ 941082 (with most of the record removed on 9-7-05; to reduce run time) (just the single comp.), but with 900 zeros added
set saTOneForEQ(999991) 0.9907
set saTOneForEQ(999992) 0.9907;	# Just junk

# Bin 1A - Scaled at 1.0 second
set saTOneForEQ(100) 	0.27
set saTOneForEQ(101) 	0.18
set saTOneForEQ(102) 	0.25
set saTOneForEQ(103) 	0.16
set saTOneForEQ(104) 	0.30
set saTOneForEQ(105) 	0.26
set saTOneForEQ(106) 	0.21
set saTOneForEQ(107) 	0.29
set saTOneForEQ(108) 	0.27
set saTOneForEQ(109) 	0.26
set saTOneForEQ(110) 	0.17
set saTOneForEQ(111) 	0.27
set saTOneForEQ(112) 	0.28
set saTOneForEQ(113) 	0.29
set saTOneForEQ(114) 	0.25
set saTOneForEQ(115) 	0.26
set saTOneForEQ(116) 	0.25
set saTOneForEQ(117) 	0.25
set saTOneForEQ(118) 	0.28
set saTOneForEQ(119) 	0.29
set saTOneForEQ(120) 	0.27
set saTOneForEQ(121) 	0.29
set saTOneForEQ(122) 	0.26
set saTOneForEQ(123) 	0.24
set saTOneForEQ(124) 	0.29
set saTOneForEQ(125) 	0.38
set saTOneForEQ(126) 	0.31
set saTOneForEQ(127) 	0.29
set saTOneForEQ(128) 	0.23

# Bin 1B - Scaled at 1.0 second
set saTOneForEQ(150) 	0.36
set saTOneForEQ(151) 	0.26
set saTOneForEQ(152) 	0.18
set saTOneForEQ(153) 	0.35
set saTOneForEQ(154) 	0.15
set saTOneForEQ(155) 	0.23
set saTOneForEQ(156) 	0.12
set saTOneForEQ(157) 	0.17
set saTOneForEQ(158) 	0.10
set saTOneForEQ(159) 	0.19
set saTOneForEQ(160) 	0.16
set saTOneForEQ(161) 	0.13
set saTOneForEQ(162) 	0.27
set saTOneForEQ(163) 	0.25
set saTOneForEQ(164) 	0.25
set saTOneForEQ(165) 	0.25
set saTOneForEQ(166) 	0.25
set saTOneForEQ(167) 	0.27

# Bin 2A - Scaled at 1.0 second
set saTOneForEQ(200) 	0.18
set saTOneForEQ(201) 	0.16
set saTOneForEQ(202) 	0.16
set saTOneForEQ(203) 	0.18
set saTOneForEQ(204) 	0.20
set saTOneForEQ(205) 	0.19
set saTOneForEQ(206) 	0.15
set saTOneForEQ(207) 	0.21
set saTOneForEQ(208) 	0.19
set saTOneForEQ(209) 	0.19
set saTOneForEQ(210) 	0.13
set saTOneForEQ(211) 	0.15
set saTOneForEQ(212) 	0.17
set saTOneForEQ(213) 	0.27
set saTOneForEQ(214) 	0.20
set saTOneForEQ(215) 	0.25
set saTOneForEQ(216) 	0.16
set saTOneForEQ(217) 	0.18
set saTOneForEQ(218) 	0.20
set saTOneForEQ(219) 	0.18
set saTOneForEQ(220) 	0.19
set saTOneForEQ(221) 	0.19
set saTOneForEQ(222) 	0.38
set saTOneForEQ(223) 	0.18
set saTOneForEQ(224) 	0.19
set saTOneForEQ(225) 	0.23

# Bin 2B - Scaled at 1.0 second
set saTOneForEQ(250) 	0.36
set saTOneForEQ(251) 	0.54
set saTOneForEQ(252) 	0.38
set saTOneForEQ(253) 	0.21
set saTOneForEQ(254) 	0.21
set saTOneForEQ(255) 	0.22
set saTOneForEQ(256) 	0.27
set saTOneForEQ(257) 	0.37
set saTOneForEQ(258) 	0.24

# Bin 3A - Scaled at 1.0 second
set saTOneForEQ(300) 	0.10
set saTOneForEQ(301) 	0.06
set saTOneForEQ(302) 	0.10
set saTOneForEQ(303) 	0.05
set saTOneForEQ(304) 	0.06
set saTOneForEQ(305) 	0.09
set saTOneForEQ(306) 	0.05
set saTOneForEQ(307) 	0.07
set saTOneForEQ(308) 	0.06
set saTOneForEQ(309) 	0.07
set saTOneForEQ(310) 	0.09
set saTOneForEQ(311) 	0.06
set saTOneForEQ(312) 	0.10
set saTOneForEQ(313) 	0.08
set saTOneForEQ(314) 	0.07
set saTOneForEQ(315) 	0.07
set saTOneForEQ(316) 	0.05
set saTOneForEQ(317) 	0.07
set saTOneForEQ(318) 	0.06
set saTOneForEQ(319) 	0.06
set saTOneForEQ(320) 	0.06
set saTOneForEQ(321) 	0.08
set saTOneForEQ(322) 	0.07
set saTOneForEQ(323) 	0.06

# Bin 3B - Scaled at 1.0 second
set saTOneForEQ(350) 	0.12
set saTOneForEQ(351) 	0.17
set saTOneForEQ(352) 	0.06
set saTOneForEQ(353) 	0.07
set saTOneForEQ(354) 	0.41
set saTOneForEQ(355) 	0.26
set saTOneForEQ(356) 	0.10
set saTOneForEQ(357) 	0.10
set saTOneForEQ(358) 	0.10
set saTOneForEQ(359) 	0.10
set saTOneForEQ(360) 	0.10
set saTOneForEQ(361) 	0.10
set saTOneForEQ(362) 	0.08
set saTOneForEQ(363) 	0.13
set saTOneForEQ(364) 	0.07
set saTOneForEQ(365) 	0.09
set saTOneForEQ(366) 	0.10
set saTOneForEQ(367) 	0.10
set saTOneForEQ(368) 	0.10
set saTOneForEQ(369) 	0.10
set saTOneForEQ(370) 	0.09
set saTOneForEQ(371) 	0.10

# Bin 4A - Scaled at 1.0 second
set saTOneForEQ(400) 	0.36
set saTOneForEQ(401) 	0.28
set saTOneForEQ(402) 	0.44
set saTOneForEQ(403) 	0.86
set saTOneForEQ(404) 	0.54
set saTOneForEQ(405) 	0.41
set saTOneForEQ(406) 	0.60
set saTOneForEQ(407) 	0.23
set saTOneForEQ(408) 	0.25
set saTOneForEQ(409) 	0.21
set saTOneForEQ(410) 	0.36
set saTOneForEQ(411) 	0.22
set saTOneForEQ(412) 	0.23
set saTOneForEQ(413) 	0.25
set saTOneForEQ(414) 	0.21
set saTOneForEQ(415) 	0.36
set saTOneForEQ(416) 	0.25
set saTOneForEQ(417) 	0.30
set saTOneForEQ(418) 	0.25
set saTOneForEQ(419) 	0.31
set saTOneForEQ(420) 	0.39
set saTOneForEQ(421) 	0.45
set saTOneForEQ(422) 	0.38
set saTOneForEQ(423) 	0.33
set saTOneForEQ(424) 	1.01
set saTOneForEQ(425) 	0.99
set saTOneForEQ(426) 	1.77
set saTOneForEQ(427) 	1.83
set saTOneForEQ(428) 	1.02
set saTOneForEQ(429) 	0.94
set saTOneForEQ(430) 	0.59
set saTOneForEQ(431) 	0.50
set saTOneForEQ(432) 	0.88
set saTOneForEQ(433) 	0.72
set saTOneForEQ(434) 	1.16
set saTOneForEQ(435) 	0.88
set saTOneForEQ(436) 	1.13
set saTOneForEQ(437) 	1.03
set saTOneForEQ(438) 	1.43
set saTOneForEQ(439) 	0.86
set saTOneForEQ(440) 	2.55

# Bin 4B - No records in this bin

# Bin 5A - Scaled at 1.0 second
set saTOneForEQ(500) 	0.36
set saTOneForEQ(501) 	0.25
set saTOneForEQ(502) 	0.51
set saTOneForEQ(503) 	0.17
set saTOneForEQ(504) 	0.19
set saTOneForEQ(505) 	0.54
set saTOneForEQ(506) 	0.41
set saTOneForEQ(507) 	0.60
set saTOneForEQ(508) 	0.44
set saTOneForEQ(509) 	0.51
set saTOneForEQ(510) 	0.55
set saTOneForEQ(511) 	0.61
set saTOneForEQ(512) 	0.54
set saTOneForEQ(513) 	1.13
set saTOneForEQ(514) 	1.10
set saTOneForEQ(515) 	1.17
set saTOneForEQ(516) 	0.61
set saTOneForEQ(517) 	0.59
set saTOneForEQ(518) 	0.51
set saTOneForEQ(519) 	0.64
set saTOneForEQ(520) 	0.50
set saTOneForEQ(521) 	0.94
set saTOneForEQ(522) 	0.88
set saTOneForEQ(523) 	0.53
set saTOneForEQ(524) 	0.64
set saTOneForEQ(525) 	0.46

# Bin 5B - Scaled at 1.0 second
set saTOneForEQ(550) 	0.36
set saTOneForEQ(551) 	0.54
set saTOneForEQ(552) 	0.38
set saTOneForEQ(553) 	0.21
set saTOneForEQ(554) 	0.21
set saTOneForEQ(555) 	0.22
set saTOneForEQ(556) 	0.27
set saTOneForEQ(557) 	0.37
set saTOneForEQ(558) 	0.24

# Bin 6A - Scaled at 1.0 second
set saTOneForEQ(600) 	0.25
set saTOneForEQ(601) 	0.42
set saTOneForEQ(602) 	0.44
set saTOneForEQ(603) 	0.46
set saTOneForEQ(604) 	0.17
set saTOneForEQ(605) 	0.17
set saTOneForEQ(606) 	0.19
set saTOneForEQ(607) 	0.54
set saTOneForEQ(608) 	0.41
set saTOneForEQ(609) 	0.60
set saTOneForEQ(610) 	0.39
set saTOneForEQ(611) 	0.45
set saTOneForEQ(612) 	0.38
set saTOneForEQ(613) 	0.44
set saTOneForEQ(614) 	0.39
set saTOneForEQ(615) 	1.13
set saTOneForEQ(616) 	1.10
set saTOneForEQ(617) 	1.17
set saTOneForEQ(618) 	0.45
set saTOneForEQ(619) 	0.43
set saTOneForEQ(620) 	0.64
set saTOneForEQ(621) 	0.50
set saTOneForEQ(622) 	0.94
set saTOneForEQ(623) 	0.88
set saTOneForEQ(624) 	0.53
set saTOneForEQ(625) 	0.64
set saTOneForEQ(626) 	0.46

# Bin 6B - Scaled at 1.0 second
set saTOneForEQ(650) 	0.36
set saTOneForEQ(651) 	0.54
set saTOneForEQ(652) 	0.38
set saTOneForEQ(653) 	0.21
set saTOneForEQ(654) 	0.21
set saTOneForEQ(655) 	0.22
set saTOneForEQ(656) 	0.27
set saTOneForEQ(657) 	0.37
set saTOneForEQ(658) 	0.24

# Bin 7A - Scaled at 1.0 second
set saTOneForEQ(700) 	0.25
set saTOneForEQ(701) 	0.34
set saTOneForEQ(702) 	0.42
set saTOneForEQ(703) 	0.36
set saTOneForEQ(704) 	0.29
set saTOneForEQ(705) 	0.19
set saTOneForEQ(706) 	0.30
set saTOneForEQ(707) 	0.31
set saTOneForEQ(708) 	0.19
set saTOneForEQ(709) 	0.27
set saTOneForEQ(710) 	0.27
set saTOneForEQ(711) 	0.29
set saTOneForEQ(712) 	0.31
set saTOneForEQ(713) 	0.25
set saTOneForEQ(714) 	0.26
set saTOneForEQ(715) 	0.48
set saTOneForEQ(716) 	0.44
set saTOneForEQ(717) 	0.29
set saTOneForEQ(718) 	0.33
set saTOneForEQ(719) 	0.29
set saTOneForEQ(720) 	0.58
set saTOneForEQ(721) 	0.38
set saTOneForEQ(722) 	0.36
set saTOneForEQ(723) 	0.31

# Bin 7B - Scaled at 1.0 second
set saTOneForEQ(750) 	0.36
set saTOneForEQ(751) 	0.54
set saTOneForEQ(752) 	0.26
set saTOneForEQ(753) 	0.18
set saTOneForEQ(754) 	0.35
set saTOneForEQ(755) 	0.15
set saTOneForEQ(756) 	0.23
set saTOneForEQ(757) 	0.12
set saTOneForEQ(758) 	0.17
set saTOneForEQ(759) 	0.19
set saTOneForEQ(760) 	0.16
set saTOneForEQ(761) 	0.13
set saTOneForEQ(762) 	0.27
set saTOneForEQ(763) 	0.28
set saTOneForEQ(764) 	0.30
set saTOneForEQ(765) 	0.32
set saTOneForEQ(766) 	0.31
set saTOneForEQ(767) 	0.28
set saTOneForEQ(768) 	0.27

## New records for sens study - 10-22-04
#set saTOneForEQ(1250) 	0.18
#set saTOneForEQ(1253) 	0.26
#set saTOneForEQ(1256) 	0.23
#set saTOneForEQ(1300) 	0.15
#set saTOneForEQ(1301) 	0.11
#set saTOneForEQ(1309) 	0.13
#set saTOneForEQ(1315) 	0.08
#set saTOneForEQ(1318) 	0.05
#set saTOneForEQ(1350) 	0.16
#set saTOneForEQ(1351) 	0.12
#set saTOneForEQ(1352) 	0.11
#set saTOneForEQ(1354) 	0.04
#set saTOneForEQ(1357) 	0.17
#set saTOneForEQ(1506) 	0.27
#set saTOneForEQ(1522) 	0.64
#set saTOneForEQ(1626) 	0.50
#set saTOneForEQ(1619) 	0.39

####################################################################
####################################################################
# Add new records for ATC-63 Appenidix A Robustness study (12-4-08).
#	This is "Set 2".  These data were created using the MATLAB function (Driver_SortASetOfEqRecordsAndMakeEQInfoFile.m).

set eqFileName(9900121) A_PEERNGADatabase/KERN/PEL090.at2
set eqFileName(9900122) A_PEERNGADatabase/KERN/PEL180.at2
set eqFileName(9900651) A_PEERNGADatabase/SFERN/OPP000.at2
set eqFileName(9900652) A_PEERNGADatabase/SFERN/OPP270.at2
set eqFileName(9900681) A_PEERNGADatabase/SFERN/PEL090.at2
set eqFileName(9900682) A_PEERNGADatabase/SFERN/PEL180.at2
set eqFileName(9900811) A_PEERNGADatabase/SFERN/PPP000.at2
set eqFileName(9900812) A_PEERNGADatabase/SFERN/PPP270.at2
set eqFileName(9900881) A_PEERNGADatabase/SFERN/FSD172.at2
set eqFileName(9900882) A_PEERNGADatabase/SFERN/FSD262.at2
set eqFileName(9901221) A_PEERNGADatabase/FRIULI/A-COD000.at2
set eqFileName(9901222) A_PEERNGADatabase/FRIULI/A-COD270.at2
set eqFileName(9901251) A_PEERNGADatabase/FRIULI/A-TMZ000.at2
set eqFileName(9901252) A_PEERNGADatabase/FRIULI/A-TMZ270.at2
set eqFileName(9901371) A_PEERNGADatabase/TABAS/BAJ-L1.at2
set eqFileName(9901372) A_PEERNGADatabase/TABAS/BAJ-T1.at2
set eqFileName(9901381) A_PEERNGADatabase/TABAS/BOS-L1.at2
set eqFileName(9901382) A_PEERNGADatabase/TABAS/BOS-T1.at2
set eqFileName(9901401) A_PEERNGADatabase/TABAS/FER-L1.at2
set eqFileName(9901402) A_PEERNGADatabase/TABAS/FER-T1.at2
set eqFileName(9901621) A_PEERNGADatabase/IMPVALL/H-CXO225.at2
set eqFileName(9901622) A_PEERNGADatabase/IMPVALL/H-CXO315.at2
set eqFileName(9901631) A_PEERNGADatabase/IMPVALL/H-CAL225.at2
set eqFileName(9901632) A_PEERNGADatabase/IMPVALL/H-CAL315.at2
set eqFileName(9901641) A_PEERNGADatabase/IMPVALL/H-CPE147.at2
set eqFileName(9901642) A_PEERNGADatabase/IMPVALL/H-CPE237.at2
set eqFileName(9901661) A_PEERNGADatabase/IMPVALL/H-CC4045.at2
set eqFileName(9901662) A_PEERNGADatabase/IMPVALL/H-CC4135.at2
set eqFileName(9901671) A_PEERNGADatabase/IMPVALL/H-CMP015.at2
set eqFileName(9901672) A_PEERNGADatabase/IMPVALL/H-CMP285.at2
set eqFileName(9901691) A_PEERNGADatabase/IMPVALL/H-DLT262.at2
set eqFileName(9901692) A_PEERNGADatabase/IMPVALL/H-DLT352.at2
set eqFileName(9901721) A_PEERNGADatabase/IMPVALL/H-E01140.at2
set eqFileName(9901722) A_PEERNGADatabase/IMPVALL/H-E01230.at2
set eqFileName(9901741) A_PEERNGADatabase/IMPVALL/H-E11140.at2
set eqFileName(9901742) A_PEERNGADatabase/IMPVALL/H-E11230.at2
set eqFileName(9901751) A_PEERNGADatabase/IMPVALL/H-E12140.at2
set eqFileName(9901752) A_PEERNGADatabase/IMPVALL/H-E12230.at2
set eqFileName(9901761) A_PEERNGADatabase/IMPVALL/H-E13140.at2
set eqFileName(9901762) A_PEERNGADatabase/IMPVALL/H-E13230.at2
set eqFileName(9901861) A_PEERNGADatabase/IMPVALL/H-NIL090.at2
set eqFileName(9901862) A_PEERNGADatabase/IMPVALL/H-NIL360.at2
set eqFileName(9901871) A_PEERNGADatabase/IMPVALL/H-PTS225.at2
set eqFileName(9901872) A_PEERNGADatabase/IMPVALL/H-PTS315.at2
set eqFileName(9901891) A_PEERNGADatabase/IMPVALL/H-SHP000.at2
set eqFileName(9901892) A_PEERNGADatabase/IMPVALL/H-SHP270.at2
set eqFileName(9901901) A_PEERNGADatabase/IMPVALL/H-SUP045.at2
set eqFileName(9901902) A_PEERNGADatabase/IMPVALL/H-SUP135.at2
set eqFileName(9901911) A_PEERNGADatabase/IMPVALL/H-VCT075.at2
set eqFileName(9901912) A_PEERNGADatabase/IMPVALL/H-VCT345.at2
set eqFileName(9901921) A_PEERNGADatabase/IMPVALL/H-WSM090.at2
set eqFileName(9901922) A_PEERNGADatabase/IMPVALL/H-WSM180.at2
set eqFileName(9902881) A_PEERNGADatabase/ITALY/A-BRZ000.at2
set eqFileName(9902882) A_PEERNGADatabase/ITALY/A-BRZ270.at2
set eqFileName(9902891) A_PEERNGADatabase/ITALY/A-CTR000.at2
set eqFileName(9902892) A_PEERNGADatabase/ITALY/A-CTR270.at2
set eqFileName(9907191) A_PEERNGADatabase/SUPERST/B-BRA225.at2
set eqFileName(9907192) A_PEERNGADatabase/SUPERST/B-BRA315.at2
set eqFileName(9907211) A_PEERNGADatabase/SUPERST/B-ICC000.at2
set eqFileName(9907212) A_PEERNGADatabase/SUPERST/B-ICC090.at2
set eqFileName(9907221) A_PEERNGADatabase/SUPERST/B-KRN270.at2
set eqFileName(9907222) A_PEERNGADatabase/SUPERST/B-KRN360.at2
set eqFileName(9907251) A_PEERNGADatabase/SUPERST/B-POE270.at2
set eqFileName(9907252) A_PEERNGADatabase/SUPERST/B-POE360.at2
set eqFileName(9907281) A_PEERNGADatabase/SUPERST/B-WSM090.at2
set eqFileName(9907282) A_PEERNGADatabase/SUPERST/B-WSM180.at2
set eqFileName(9907291) A_PEERNGADatabase/SUPERST/B-IVW090.at2
set eqFileName(9907292) A_PEERNGADatabase/SUPERST/B-IVW360.at2
set eqFileName(9907311) A_PEERNGADatabase/LOMAP/A10000.at2
set eqFileName(9907312) A_PEERNGADatabase/LOMAP/A10090.at2
set eqFileName(9907331) A_PEERNGADatabase/LOMAP/A2E000.at2
set eqFileName(9907332) A_PEERNGADatabase/LOMAP/A2E090.at2
set eqFileName(9907341) A_PEERNGADatabase/LOMAP/A3E000.at2
set eqFileName(9907342) A_PEERNGADatabase/LOMAP/A3E090.at2
set eqFileName(9907351) A_PEERNGADatabase/LOMAP/A07000.at2
set eqFileName(9907352) A_PEERNGADatabase/LOMAP/A07090.at2
set eqFileName(9907361) A_PEERNGADatabase/LOMAP/A09137.at2
set eqFileName(9907362) A_PEERNGADatabase/LOMAP/A09227.at2
set eqFileName(9907371) A_PEERNGADatabase/LOMAP/AGW000.at2
set eqFileName(9907372) A_PEERNGADatabase/LOMAP/AGW090.at2
set eqFileName(9907431) A_PEERNGADatabase/LOMAP/BVR220.at2
set eqFileName(9907432) A_PEERNGADatabase/LOMAP/BVR310.at2
set eqFileName(9907461) A_PEERNGADatabase/LOMAP/BVC220.at2
set eqFileName(9907462) A_PEERNGADatabase/LOMAP/BVC310.at2
set eqFileName(9907491) A_PEERNGADatabase/LOMAP/UCS045.at2
set eqFileName(9907492) A_PEERNGADatabase/LOMAP/UCS135.at2
set eqFileName(9907511) A_PEERNGADatabase/LOMAP/CLR090.at2
set eqFileName(9907512) A_PEERNGADatabase/LOMAP/CLR180.at2
set eqFileName(9907521) A_PEERNGADatabase/LOMAP/CAP000.at2
set eqFileName(9907522) A_PEERNGADatabase/LOMAP/CAP090.at2
set eqFileName(9907561) A_PEERNGADatabase/LOMAP/DFS270.at2
set eqFileName(9907562) A_PEERNGADatabase/LOMAP/DFS360.at2
set eqFileName(9907691) A_PEERNGADatabase/LOMAP/G06000.at2
set eqFileName(9907692) A_PEERNGADatabase/LOMAP/G06090.at2
set eqFileName(9907711) A_PEERNGADatabase/LOMAP/GGB270.at2
set eqFileName(9907712) A_PEERNGADatabase/LOMAP/GGB360.at2
set eqFileName(9907761) A_PEERNGADatabase/LOMAP/HSP000.at2
set eqFileName(9907762) A_PEERNGADatabase/LOMAP/HSP090.at2
set eqFileName(9907781) A_PEERNGADatabase/LOMAP/HDA165.at2
set eqFileName(9907782) A_PEERNGADatabase/LOMAP/HDA255.at2
set eqFileName(9907861) A_PEERNGADatabase/LOMAP/PAE325.at2
set eqFileName(9907862) A_PEERNGADatabase/LOMAP/PAE055.at2
set eqFileName(9907961) A_PEERNGADatabase/LOMAP/PRS000.at2
set eqFileName(9907962) A_PEERNGADatabase/LOMAP/PRS090.at2
set eqFileName(9908061) A_PEERNGADatabase/LOMAP/SVL270.at2
set eqFileName(9908062) A_PEERNGADatabase/LOMAP/SVL360.at2
set eqFileName(9908071) A_PEERNGADatabase/LOMAP/SUF090.at2
set eqFileName(9908072) A_PEERNGADatabase/LOMAP/SUF180.at2
set eqFileName(9908261) A_PEERNGADatabase/CAPEMEND/EUR000.at2
set eqFileName(9908262) A_PEERNGADatabase/CAPEMEND/EUR090.at2
set eqFileName(9908271) A_PEERNGADatabase/CAPEMEND/FOR000.at2
set eqFileName(9908272) A_PEERNGADatabase/CAPEMEND/FOR090.at2
set eqFileName(9908291) A_PEERNGADatabase/CAPEMEND/RIO270.at2
set eqFileName(9908292) A_PEERNGADatabase/CAPEMEND/RIO360.at2
set eqFileName(9908321) A_PEERNGADatabase/LANDERS/ABY000.at2
set eqFileName(9908322) A_PEERNGADatabase/LANDERS/ABY090.at2
set eqFileName(9908361) A_PEERNGADatabase/LANDERS/BAK050.at2
set eqFileName(9908362) A_PEERNGADatabase/LANDERS/BAK140.at2
set eqFileName(9908381) A_PEERNGADatabase/LANDERS/BRS000.at2
set eqFileName(9908382) A_PEERNGADatabase/LANDERS/BRS090.at2
set eqFileName(9908411) A_PEERNGADatabase/LANDERS/BFS000.at2
set eqFileName(9908412) A_PEERNGADatabase/LANDERS/BFS090.at2
set eqFileName(9908471) A_PEERNGADatabase/LANDERS/CAS000.at2
set eqFileName(9908472) A_PEERNGADatabase/LANDERS/CAS270.at2
set eqFileName(9908501) A_PEERNGADatabase/LANDERS/DSP000.at2
set eqFileName(9908502) A_PEERNGADatabase/LANDERS/DSP090.at2
set eqFileName(9908541) A_PEERNGADatabase/LANDERS/FEA000.at2
set eqFileName(9908542) A_PEERNGADatabase/LANDERS/FEA090.at2
set eqFileName(9908551) A_PEERNGADatabase/LANDERS/FTI000.at2
set eqFileName(9908552) A_PEERNGADatabase/LANDERS/FTI090.at2
set eqFileName(9908601) A_PEERNGADatabase/LANDERS/H05000.at2
set eqFileName(9908602) A_PEERNGADatabase/LANDERS/H05090.at2
set eqFileName(9908611) A_PEERNGADatabase/LANDERS/WAI200.at2
set eqFileName(9908612) A_PEERNGADatabase/LANDERS/WAI290.at2
set eqFileName(9908641) A_PEERNGADatabase/LANDERS/JOS000.at2
set eqFileName(9908642) A_PEERNGADatabase/LANDERS/JOS090.at2
set eqFileName(9908701) A_PEERNGADatabase/LANDERS/OBR000.at2
set eqFileName(9908702) A_PEERNGADatabase/LANDERS/OBR090.at2
set eqFileName(9908741) A_PEERNGADatabase/LANDERS/OR2010.at2
set eqFileName(9908742) A_PEERNGADatabase/LANDERS/OR2280.at2
set eqFileName(9908781) A_PEERNGADatabase/LANDERS/DEL000.at2
set eqFileName(9908782) A_PEERNGADatabase/LANDERS/DEL090.at2
set eqFileName(9908801) A_PEERNGADatabase/LANDERS/MCF000.at2
set eqFileName(9908802) A_PEERNGADatabase/LANDERS/MCF090.at2
set eqFileName(9908841) A_PEERNGADatabase/LANDERS/PSA000.at2
set eqFileName(9908842) A_PEERNGADatabase/LANDERS/PSA090.at2
set eqFileName(9908851) A_PEERNGADatabase/LANDERS/PMN000.at2
set eqFileName(9908852) A_PEERNGADatabase/LANDERS/PMN090.at2
set eqFileName(9908881) A_PEERNGADatabase/LANDERS/HOS090.at2
set eqFileName(9908882) A_PEERNGADatabase/LANDERS/HOS180.at2
set eqFileName(9908951) A_PEERNGADatabase/LANDERS/TAR000.at2
set eqFileName(9908952) A_PEERNGADatabase/LANDERS/TAR090.at2
set eqFileName(9908971) A_PEERNGADatabase/LANDERS/29P000.at2
set eqFileName(9908972) A_PEERNGADatabase/LANDERS/29P090.at2
set eqFileName(9909001) A_PEERNGADatabase/LANDERS/YER270.at2
set eqFileName(9909002) A_PEERNGADatabase/LANDERS/YER360.at2
set eqFileName(9909421) A_PEERNGADatabase/NORTHR/ALH090.at2
set eqFileName(9909422) A_PEERNGADatabase/NORTHR/ALH360.at2
set eqFileName(9909451) A_PEERNGADatabase/NORTHR/ANA090.at2
set eqFileName(9909452) A_PEERNGADatabase/NORTHR/ANA180.at2
set eqFileName(9909511) A_PEERNGADatabase/NORTHR/JAB220.at2
set eqFileName(9909512) A_PEERNGADatabase/NORTHR/JAB310.at2
set eqFileName(9909521) A_PEERNGADatabase/NORTHR/MU2035.at2
set eqFileName(9909522) A_PEERNGADatabase/NORTHR/MU2125.at2
set eqFileName(9909601) A_PEERNGADatabase/NORTHR/LOS000.at2
set eqFileName(9909602) A_PEERNGADatabase/NORTHR/LOS270.at2
set eqFileName(9909641) A_PEERNGADatabase/NORTHR/CAS000.at2
set eqFileName(9909642) A_PEERNGADatabase/NORTHR/CAS270.at2
set eqFileName(9909651) A_PEERNGADatabase/NORTHR/GRA074.at2
set eqFileName(9909652) A_PEERNGADatabase/NORTHR/GRA344.at2
set eqFileName(9909741) A_PEERNGADatabase/NORTHR/GLP177.at2
set eqFileName(9909742) A_PEERNGADatabase/NORTHR/GLP267.at2
set eqFileName(9909851) A_PEERNGADatabase/NORTHR/BLD090.at2
set eqFileName(9909852) A_PEERNGADatabase/NORTHR/BLD360.at2
set eqFileName(9909871) A_PEERNGADatabase/NORTHR/CEN155.at2
set eqFileName(9909872) A_PEERNGADatabase/NORTHR/CEN245.at2
set eqFileName(9909901) A_PEERNGADatabase/NORTHR/LAC090.at2
set eqFileName(9909902) A_PEERNGADatabase/NORTHR/LAC180.at2
set eqFileName(9910001) A_PEERNGADatabase/NORTHR/PIC090.at2
set eqFileName(9910002) A_PEERNGADatabase/NORTHR/PIC180.at2
set eqFileName(9910031) A_PEERNGADatabase/NORTHR/STN020.at2
set eqFileName(9910032) A_PEERNGADatabase/NORTHR/STN110.at2
set eqFileName(9910171) A_PEERNGADatabase/NORTHR/BRC000.at2
set eqFileName(9910172) A_PEERNGADatabase/NORTHR/BRC090.at2
set eqFileName(9910201) A_PEERNGADatabase/NORTHR/H12090.at2
set eqFileName(9910202) A_PEERNGADatabase/NORTHR/H12180.at2
set eqFileName(9910261) A_PEERNGADatabase/NORTHR/LOA092.at2
set eqFileName(9910262) A_PEERNGADatabase/NORTHR/LOA182.at2
set eqFileName(9910281) A_PEERNGADatabase/NORTHR/LV2000.at2
set eqFileName(9910282) A_PEERNGADatabase/NORTHR/LV2090.at2
set eqFileName(9910381) A_PEERNGADatabase/NORTHR/BLF206.at2
set eqFileName(9910382) A_PEERNGADatabase/NORTHR/BLF296.at2
set eqFileName(9910421) A_PEERNGADatabase/NORTHR/CWC180.at2
set eqFileName(9910422) A_PEERNGADatabase/NORTHR/CWC270.at2
set eqFileName(9910431) A_PEERNGADatabase/NORTHR/NEE090.at2
set eqFileName(9910432) A_PEERNGADatabase/NORTHR/NEE180.at2
set eqFileName(9910561) A_PEERNGADatabase/NORTHR/PHE090.at2
set eqFileName(9910562) A_PEERNGADatabase/NORTHR/PHE180.at2
set eqFileName(9910791) A_PEERNGADatabase/NORTHR/SEA000.at2
set eqFileName(9910792) A_PEERNGADatabase/NORTHR/SEA090.at2
set eqFileName(9910831) A_PEERNGADatabase/NORTHR/GLE170.at2
set eqFileName(9910832) A_PEERNGADatabase/NORTHR/GLE260.at2
set eqFileName(9911051) A_PEERNGADatabase/KOBE/HIK000.at2
set eqFileName(9911052) A_PEERNGADatabase/KOBE/HIK090.at2
set eqFileName(9911061) A_PEERNGADatabase/KOBE/KJM000.at2
set eqFileName(9911062) A_PEERNGADatabase/KOBE/KJM090.at2
set eqFileName(9911071) A_PEERNGADatabase/KOBE/KAK000.at2
set eqFileName(9911072) A_PEERNGADatabase/KOBE/KAK090.at2
set eqFileName(9911091) A_PEERNGADatabase/KOBE/MZH000.at2
set eqFileName(9911092) A_PEERNGADatabase/KOBE/MZH090.at2
set eqFileName(9911111) A_PEERNGADatabase/KOBE/NIS000.at2
set eqFileName(9911112) A_PEERNGADatabase/KOBE/NIS090.at2
set eqFileName(9911121) A_PEERNGADatabase/KOBE/OKA000.at2
set eqFileName(9911122) A_PEERNGADatabase/KOBE/OKA090.at2
set eqFileName(9911131) A_PEERNGADatabase/KOBE/OSA000.at2
set eqFileName(9911132) A_PEERNGADatabase/KOBE/OSA090.at2
set eqFileName(9911161) A_PEERNGADatabase/KOBE/SHI000.at2
set eqFileName(9911162) A_PEERNGADatabase/KOBE/SHI090.at2
set eqFileName(9911171) A_PEERNGADatabase/KOBE/TOT000.at2
set eqFileName(9911172) A_PEERNGADatabase/KOBE/TOT090.at2
set eqFileName(9911441) A_PEERNGADatabase/AQABA/EIL-EW.at2
set eqFileName(9911442) A_PEERNGADatabase/AQABA/EIL-NS.at2
set eqFileName(9911481) A_PEERNGADatabase/KOCAELI/ARC000.at2
set eqFileName(9911482) A_PEERNGADatabase/KOCAELI/ARC090.at2
set eqFileName(9911491) A_PEERNGADatabase/KOCAELI/ATK000.at2
set eqFileName(9911492) A_PEERNGADatabase/KOCAELI/ATK090.at2
set eqFileName(9911531) A_PEERNGADatabase/KOCAELI/BTS000.at2
set eqFileName(9911532) A_PEERNGADatabase/KOCAELI/BTS090.at2
set eqFileName(9911541) A_PEERNGADatabase/KOCAELI/BRS090.at2
set eqFileName(9911542) A_PEERNGADatabase/KOCAELI/BRS180.at2
set eqFileName(9911551) A_PEERNGADatabase/KOCAELI/BUR000.at2
set eqFileName(9911552) A_PEERNGADatabase/KOCAELI/BUR090.at2
set eqFileName(9911581) A_PEERNGADatabase/KOCAELI/DZC180.at2
set eqFileName(9911582) A_PEERNGADatabase/KOCAELI/DZC270.at2
set eqFileName(9911591) A_PEERNGADatabase/KOCAELI/ERG180.at2
set eqFileName(9911592) A_PEERNGADatabase/KOCAELI/ERG090.at2
set eqFileName(9911601) A_PEERNGADatabase/KOCAELI/FAT000.at2
set eqFileName(9911602) A_PEERNGADatabase/KOCAELI/FAT090.at2
set eqFileName(9911621) A_PEERNGADatabase/KOCAELI/GYN000.at2
set eqFileName(9911622) A_PEERNGADatabase/KOCAELI/GYN090.at2
set eqFileName(9911631) A_PEERNGADatabase/KOCAELI/DHM000.at2
set eqFileName(9911632) A_PEERNGADatabase/KOCAELI/DHM090.at2
set eqFileName(9911661) A_PEERNGADatabase/KOCAELI/IZN180.at2
set eqFileName(9911662) A_PEERNGADatabase/KOCAELI/IZN090.at2
set eqFileName(9911671) A_PEERNGADatabase/KOCAELI/KUT090.at2
set eqFileName(9911672) A_PEERNGADatabase/KOCAELI/KUT180.at2
set eqFileName(9911701) A_PEERNGADatabase/KOCAELI/MCD000.at2
set eqFileName(9911702) A_PEERNGADatabase/KOCAELI/MCD090.at2
set eqFileName(9911771) A_PEERNGADatabase/KOCAELI/ZYT000.at2
set eqFileName(9911772) A_PEERNGADatabase/KOCAELI/ZYT090.at2
set eqFileName(9911801) A_PEERNGADatabase/CHICHI/CHY002-N.at2
set eqFileName(9911802) A_PEERNGADatabase/CHICHI/CHY002-W.at2
set eqFileName(9912421) A_PEERNGADatabase/CHICHI/CHY099-N.at2
set eqFileName(9912422) A_PEERNGADatabase/CHICHI/CHY099-W.at2
set eqFileName(9912741) A_PEERNGADatabase/CHICHI/HWA025-E.at2
set eqFileName(9912742) A_PEERNGADatabase/CHICHI/HWA025-N.at2
set eqFileName(9912931) A_PEERNGADatabase/CHICHI/HWA046-N.at2
set eqFileName(9912932) A_PEERNGADatabase/CHICHI/HWA046-W.at2
set eqFileName(9913061) A_PEERNGADatabase/CHICHI/HWA2-E.at2
set eqFileName(9913062) A_PEERNGADatabase/CHICHI/HWA2-N.at2
set eqFileName(9913171) A_PEERNGADatabase/CHICHI/ILA013-N.at2
set eqFileName(9913172) A_PEERNGADatabase/CHICHI/ILA013-W.at2
set eqFileName(9913181) A_PEERNGADatabase/CHICHI/ILA014-N.at2
set eqFileName(9913182) A_PEERNGADatabase/CHICHI/ILA014-W.at2
set eqFileName(9913231) A_PEERNGADatabase/CHICHI/ILA027-E.at2
set eqFileName(9913232) A_PEERNGADatabase/CHICHI/ILA027-N.at2
set eqFileName(9913371) A_PEERNGADatabase/CHICHI/ILA049-E.at2
set eqFileName(9913372) A_PEERNGADatabase/CHICHI/ILA049-N.at2
set eqFileName(9913421) A_PEERNGADatabase/CHICHI/ILA055-N.at2
set eqFileName(9913422) A_PEERNGADatabase/CHICHI/ILA055-W.at2
set eqFileName(9913801) A_PEERNGADatabase/CHICHI/KAU054-E.at2
set eqFileName(9913802) A_PEERNGADatabase/CHICHI/KAU054-N.at2
set eqFileName(9914571) A_PEERNGADatabase/CHICHI/TAP097-N.at2
set eqFileName(9914572) A_PEERNGADatabase/CHICHI/TAP097-W.at2
set eqFileName(9914701) A_PEERNGADatabase/CHICHI/TCU014-E.at2
set eqFileName(9914702) A_PEERNGADatabase/CHICHI/TCU014-N.at2
set eqFileName(9914721) A_PEERNGADatabase/CHICHI/TCU017-E.at2
set eqFileName(9914722) A_PEERNGADatabase/CHICHI/TCU017-N.at2
set eqFileName(9914791) A_PEERNGADatabase/CHICHI/TCU034-E.at2
set eqFileName(9914792) A_PEERNGADatabase/CHICHI/TCU034-N.at2
set eqFileName(9914911) A_PEERNGADatabase/CHICHI/TCU051-E.at2
set eqFileName(9914912) A_PEERNGADatabase/CHICHI/TCU051-N.at2
set eqFileName(9915011) A_PEERNGADatabase/CHICHI/TCU063-E.at2
set eqFileName(9915012) A_PEERNGADatabase/CHICHI/TCU063-N.at2
set eqFileName(9915321) A_PEERNGADatabase/CHICHI/TCU105-E.at2
set eqFileName(9915322) A_PEERNGADatabase/CHICHI/TCU105-N.at2
set eqFileName(9915501) A_PEERNGADatabase/CHICHI/TCU136-N.at2
set eqFileName(9915502) A_PEERNGADatabase/CHICHI/TCU136-W.at2
set eqFileName(9915881) A_PEERNGADatabase/CHICHI/TTN044-N.at2
set eqFileName(9915882) A_PEERNGADatabase/CHICHI/TTN044-W.at2
set eqFileName(9916021) A_PEERNGADatabase/DUZCE/BOL000.at2
set eqFileName(9916022) A_PEERNGADatabase/DUZCE/BOL090.at2
set eqFileName(9916141) A_PEERNGADatabase/DUZCE/1061-N.at2
set eqFileName(9916142) A_PEERNGADatabase/DUZCE/1061-E.at2
set eqFileName(9916191) A_PEERNGADatabase/DUZCE/MDR000.at2
set eqFileName(9916192) A_PEERNGADatabase/DUZCE/MDR090.at2
set eqFileName(9916261) A_PEERNGADatabase/SITKA/212V5090.at2
set eqFileName(9916262) A_PEERNGADatabase/SITKA/212V5180.at2
set eqFileName(9916281) A_PEERNGADatabase/STELIAS/059v2090.at2
set eqFileName(9916282) A_PEERNGADatabase/STELIAS/059v2180.at2
set eqFileName(9916291) A_PEERNGADatabase/STELIAS/059v2009.at2
set eqFileName(9916292) A_PEERNGADatabase/STELIAS/059v2279.at2
set eqFileName(9916331) A_PEERNGADatabase/MANJIL/ABBAR--L.at2
set eqFileName(9916332) A_PEERNGADatabase/MANJIL/ABBAR--T.at2
set eqFileName(9916341) A_PEERNGADatabase/MANJIL/184057.at2
set eqFileName(9916342) A_PEERNGADatabase/MANJIL/184327.at2
set eqFileName(9916361) A_PEERNGADatabase/MANJIL/185066.at2
set eqFileName(9916362) A_PEERNGADatabase/MANJIL/185336.at2
set eqFileName(9916371) A_PEERNGADatabase/MANJIL/188040.at2
set eqFileName(9916372) A_PEERNGADatabase/MANJIL/188310.at2
set eqFileName(9916401) A_PEERNGADatabase/MANJIL/189042.at2
set eqFileName(9916402) A_PEERNGADatabase/MANJIL/189132.at2
set eqFileName(9917621) A_PEERNGADatabase/HECTOR/21081090.at2
set eqFileName(9917622) A_PEERNGADatabase/HECTOR/21081360.at2
set eqFileName(9917661) A_PEERNGADatabase/HECTOR/32075140.at2
set eqFileName(9917662) A_PEERNGADatabase/HECTOR/32075050.at2
set eqFileName(9917681) A_PEERNGADatabase/HECTOR/23559090.at2
set eqFileName(9917682) A_PEERNGADatabase/HECTOR/23559360.at2
set eqFileName(9917701) A_PEERNGADatabase/HECTOR/22791016.at2
set eqFileName(9917702) A_PEERNGADatabase/HECTOR/22791106.at2
set eqFileName(9917761) A_PEERNGADatabase/HECTOR/12149360.at2
set eqFileName(9917762) A_PEERNGADatabase/HECTOR/12149090.at2
set eqFileName(9917821) A_PEERNGADatabase/HECTOR/1436a180.at2
set eqFileName(9917822) A_PEERNGADatabase/HECTOR/1436c270.at2
set eqFileName(9917831) A_PEERNGADatabase/HECTOR/32577360.at2
set eqFileName(9917832) A_PEERNGADatabase/HECTOR/32577090.at2
set eqFileName(9917841) A_PEERNGADatabase/HECTOR/11684360.at2
set eqFileName(9917842) A_PEERNGADatabase/HECTOR/11684090.at2
set eqFileName(9917851) A_PEERNGADatabase/HECTOR/0525c090.at2
set eqFileName(9917852) A_PEERNGADatabase/HECTOR/0525a360.at2
set eqFileName(9917871) A_PEERNGADatabase/HECTOR/HEC000.at2
set eqFileName(9917872) A_PEERNGADatabase/HECTOR/HEC090.at2
set eqFileName(9917881) A_PEERNGADatabase/HECTOR/12331360.at2
set eqFileName(9917882) A_PEERNGADatabase/HECTOR/12331090.at2
set eqFileName(9917891) A_PEERNGADatabase/HECTOR/23583360.at2
set eqFileName(9917892) A_PEERNGADatabase/HECTOR/23583090.at2
set eqFileName(9917911) A_PEERNGADatabase/HECTOR/12026090.at2
set eqFileName(9917912) A_PEERNGADatabase/HECTOR/12026360.at2
set eqFileName(9917921) A_PEERNGADatabase/HECTOR/12543360.at2
set eqFileName(9917922) A_PEERNGADatabase/HECTOR/12543090.at2
set eqFileName(9917941) A_PEERNGADatabase/HECTOR/22170090.at2
set eqFileName(9917942) A_PEERNGADatabase/HECTOR/22170360.at2
set eqFileName(9917951) A_PEERNGADatabase/HECTOR/12647090.at2
set eqFileName(9917952) A_PEERNGADatabase/HECTOR/12647180.at2
set eqFileName(9918071) A_PEERNGADatabase/HECTOR/0530a270.at2
set eqFileName(9918072) A_PEERNGADatabase/HECTOR/0530c360.at2
set eqFileName(9918081) A_PEERNGADatabase/HECTOR/0517a180.at2
set eqFileName(9918082) A_PEERNGADatabase/HECTOR/0517c270.at2
set eqFileName(9918101) A_PEERNGADatabase/HECTOR/11625090.at2
set eqFileName(9918102) A_PEERNGADatabase/HECTOR/11625180.at2
set eqFileName(9918121) A_PEERNGADatabase/HECTOR/1434a180.at2
set eqFileName(9918122) A_PEERNGADatabase/HECTOR/1434c270.at2
set eqFileName(9918131) A_PEERNGADatabase/HECTOR/0544c090.at2
set eqFileName(9918132) A_PEERNGADatabase/HECTOR/0544a360.at2
set eqFileName(9918161) A_PEERNGADatabase/HECTOR/0534a180.at2
set eqFileName(9918162) A_PEERNGADatabase/HECTOR/0534c270.at2
set eqFileName(9918171) A_PEERNGADatabase/HECTOR/11591090.at2
set eqFileName(9918172) A_PEERNGADatabase/HECTOR/11591180.at2
set eqFileName(9918251) A_PEERNGADatabase/HECTOR/23542360.at2
set eqFileName(9918252) A_PEERNGADatabase/HECTOR/23542090.at2
set eqFileName(9918291) A_PEERNGADatabase/HECTOR/0591c090.at2
set eqFileName(9918292) A_PEERNGADatabase/HECTOR/0591a360.at2
set eqFileName(9918311) A_PEERNGADatabase/HECTOR/12618090.at2
set eqFileName(9918312) A_PEERNGADatabase/HECTOR/12618180.at2
set eqFileName(9918321) A_PEERNGADatabase/HECTOR/0205c090.at2
set eqFileName(9918322) A_PEERNGADatabase/HECTOR/0205a360.at2
set eqFileName(9918351) A_PEERNGADatabase/HECTOR/13172360.at2
set eqFileName(9918352) A_PEERNGADatabase/HECTOR/13172090.at2
set eqFileName(9918361) A_PEERNGADatabase/HECTOR/22161090.at2
set eqFileName(9918362) A_PEERNGADatabase/HECTOR/22161360.at2
set eqFileName(9918371) A_PEERNGADatabase/HECTOR/0521a360.at2
set eqFileName(9918372) A_PEERNGADatabase/HECTOR/0521c090.at2
set eqFileName(9918381) A_PEERNGADatabase/HECTOR/1405a065.at2
set eqFileName(9918382) A_PEERNGADatabase/HECTOR/1405c155.at2
set eqFileName(9918411) A_PEERNGADatabase/HECTOR/23573090.at2
set eqFileName(9918412) A_PEERNGADatabase/HECTOR/23573180.at2
set eqFileName(9921101) A_PEERNGADatabase/DENALI/0593090.at2
set eqFileName(9921102) A_PEERNGADatabase/DENALI/0593360.at2
set eqFileName(9921131) A_PEERNGADatabase/DENALI/ps09013.at2
set eqFileName(9921132) A_PEERNGADatabase/DENALI/ps09103.at2
set eqFileName(9921151) A_PEERNGADatabase/DENALI/ps11066.at2
set eqFileName(9921152) A_PEERNGADatabase/DENALI/ps11336.at2
set eqFileName(9935491) A_PEERNGADatabase/NORTHR/5080-360.at2
set eqFileName(9935492) A_PEERNGADatabase/NORTHR/5080-270.at2






