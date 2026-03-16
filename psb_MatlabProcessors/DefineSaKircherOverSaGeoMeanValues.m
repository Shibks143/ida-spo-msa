%
% Procedure: DefineSaKircherOverSaGeoMeanValues.m
% -------------------
% This defines the ratio of Sa,Kircher(1s) (ATC-63 definition) to Sa,geoMean(1s);
% this is defined for each EQ record.  This is done seperately for both GM
% Set C and GM Set G.
%
% Author: Curt Haselton 
% Date Written: 7-20-06
% UPDATED: 6-9-08 (per 90% draft normalization factors for the FF set)
%
% Sources of Code: none
%
% Functions and Procedures called: none
%
% Variable definitions: 
%           - not done
% -------------------

% Define the axis label that will be used for the Sa,Kircher(1s)
axisLabelForSaKircher = 'Sa_{ATC-63}(T=1.0s) [g]';


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% NEWER normalization values per 90% draft report (NOTICE: This
% normalization is not consistent with what was done for the RC SMF archtype
% models (chapter 9) in the ATC-63 report, so the results coming out of
% this may differ slightly from the 

% ATC-63 Far-Field Ground Motion Set C - Define the values of Sa,Kircher(T=1sec)/Sa,geoMean(T=1sec)
saKircherAtOneSecOverSaGeoMeanAtOneSec{120111} =	0.564;
saKircherAtOneSecOverSaGeoMeanAtOneSec{120112} =	0.564;
saKircherAtOneSecOverSaGeoMeanAtOneSec{120121} =	0.883;
saKircherAtOneSecOverSaGeoMeanAtOneSec{120122} =	0.883;
saKircherAtOneSecOverSaGeoMeanAtOneSec{120411} =	0.627;
saKircherAtOneSecOverSaGeoMeanAtOneSec{120412} =	0.627;
saKircherAtOneSecOverSaGeoMeanAtOneSec{120521} =	0.907;
saKircherAtOneSecOverSaGeoMeanAtOneSec{120522} =	0.907;
saKircherAtOneSecOverSaGeoMeanAtOneSec{120611} =	0.771;
saKircherAtOneSecOverSaGeoMeanAtOneSec{120612} =	0.771;
saKircherAtOneSecOverSaGeoMeanAtOneSec{120621} =	1.516;
saKircherAtOneSecOverSaGeoMeanAtOneSec{120622} =	1.516;
saKircherAtOneSecOverSaGeoMeanAtOneSec{120711} =	1.173;
saKircherAtOneSecOverSaGeoMeanAtOneSec{120712} =	1.173;
saKircherAtOneSecOverSaGeoMeanAtOneSec{120721} =	1.191;
saKircherAtOneSecOverSaGeoMeanAtOneSec{120722} =	1.191;
saKircherAtOneSecOverSaGeoMeanAtOneSec{120811} =	1.015;
saKircherAtOneSecOverSaGeoMeanAtOneSec{120812} =	1.015;
saKircherAtOneSecOverSaGeoMeanAtOneSec{120821} =	2.356;
saKircherAtOneSecOverSaGeoMeanAtOneSec{120822} =	2.356;
saKircherAtOneSecOverSaGeoMeanAtOneSec{120911} =	0.903;
saKircherAtOneSecOverSaGeoMeanAtOneSec{120912} =	0.903;
saKircherAtOneSecOverSaGeoMeanAtOneSec{120921} =	1.165;
saKircherAtOneSecOverSaGeoMeanAtOneSec{120922} =	1.165;
saKircherAtOneSecOverSaGeoMeanAtOneSec{121011} =	0.927;
saKircherAtOneSecOverSaGeoMeanAtOneSec{121012} =	0.927;
saKircherAtOneSecOverSaGeoMeanAtOneSec{121021} =	1.288;
saKircherAtOneSecOverSaGeoMeanAtOneSec{121022} =	1.288;
saKircherAtOneSecOverSaGeoMeanAtOneSec{121111} =	1.043;
saKircherAtOneSecOverSaGeoMeanAtOneSec{121112} =	1.043;
saKircherAtOneSecOverSaGeoMeanAtOneSec{121211} =	1.499;
saKircherAtOneSecOverSaGeoMeanAtOneSec{121212} =	1.499;
saKircherAtOneSecOverSaGeoMeanAtOneSec{121221} =	0.914;
saKircherAtOneSecOverSaGeoMeanAtOneSec{121222} =	0.914;
saKircherAtOneSecOverSaGeoMeanAtOneSec{121321} =	0.959;
saKircherAtOneSecOverSaGeoMeanAtOneSec{121322} =	0.959;
saKircherAtOneSecOverSaGeoMeanAtOneSec{121411} =	1.289;
saKircherAtOneSecOverSaGeoMeanAtOneSec{121412} =	1.289;
saKircherAtOneSecOverSaGeoMeanAtOneSec{121421} =	1.042;
saKircherAtOneSecOverSaGeoMeanAtOneSec{121422} =	1.042;
saKircherAtOneSecOverSaGeoMeanAtOneSec{121511} =	0.880;
saKircherAtOneSecOverSaGeoMeanAtOneSec{121512} =	0.880;
saKircherAtOneSecOverSaGeoMeanAtOneSec{121711} =	0.924;
saKircherAtOneSecOverSaGeoMeanAtOneSec{121712} =	0.924;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%% OLDER VALUES USED FOR RUNS DONE IN MY THESIS AND THE ATC-63 REPORT.
%%%% NOTICE THAT THE ATC-63 REPORT ARCHETYPE RESULTS ARE BASED ON THE
%%%% NUMBERS BELOW.  EVEN SO, FOR THE 90% DRAFT REPORT, THE NORMALIZATIONS
%%%% FACTORS WERE CHANGED AND DO NOT AGREE WITH VALUES BELOW.

% % ATC-63 Far-Field Ground Motion Set C - Define the values of Sa,Kircher(T=1sec)/Sa,geoMean(T=1sec)
% saKircherAtOneSecOverSaGeoMeanAtOneSec{120111} =	0.521;
% saKircherAtOneSecOverSaGeoMeanAtOneSec{120112} =	0.521;
% saKircherAtOneSecOverSaGeoMeanAtOneSec{120121} =	0.946;
% saKircherAtOneSecOverSaGeoMeanAtOneSec{120122} =	0.946;
% saKircherAtOneSecOverSaGeoMeanAtOneSec{120411} =	0.672;
% saKircherAtOneSecOverSaGeoMeanAtOneSec{120412} =	0.672;
% saKircherAtOneSecOverSaGeoMeanAtOneSec{120521} =	0.972;
% saKircherAtOneSecOverSaGeoMeanAtOneSec{120522} =	0.972;
% saKircherAtOneSecOverSaGeoMeanAtOneSec{120611} =	0.826;
% saKircherAtOneSecOverSaGeoMeanAtOneSec{120612} =	0.826;
% saKircherAtOneSecOverSaGeoMeanAtOneSec{120621} =	1.625;
% saKircherAtOneSecOverSaGeoMeanAtOneSec{120622} =	1.625;
% saKircherAtOneSecOverSaGeoMeanAtOneSec{120711} =	0.757;
% saKircherAtOneSecOverSaGeoMeanAtOneSec{120712} =	0.757;
% saKircherAtOneSecOverSaGeoMeanAtOneSec{120721} =	1.276;
% saKircherAtOneSecOverSaGeoMeanAtOneSec{120722} =	1.276;
% saKircherAtOneSecOverSaGeoMeanAtOneSec{120811} =	1.088;
% saKircherAtOneSecOverSaGeoMeanAtOneSec{120812} =	1.088;
% saKircherAtOneSecOverSaGeoMeanAtOneSec{120821} =	2.525;
% saKircherAtOneSecOverSaGeoMeanAtOneSec{120822} =	2.525;
% saKircherAtOneSecOverSaGeoMeanAtOneSec{120911} =	0.968;
% saKircherAtOneSecOverSaGeoMeanAtOneSec{120912} =	0.968;
% saKircherAtOneSecOverSaGeoMeanAtOneSec{120921} =	1.338;
% saKircherAtOneSecOverSaGeoMeanAtOneSec{120922} =	1.338;
% saKircherAtOneSecOverSaGeoMeanAtOneSec{121011} =	1.316;
% saKircherAtOneSecOverSaGeoMeanAtOneSec{121012} =	1.316;
% saKircherAtOneSecOverSaGeoMeanAtOneSec{121021} =	1.380;
% saKircherAtOneSecOverSaGeoMeanAtOneSec{121022} =	1.380;
% saKircherAtOneSecOverSaGeoMeanAtOneSec{121111} =	1.118;
% saKircherAtOneSecOverSaGeoMeanAtOneSec{121112} =	1.118;
% saKircherAtOneSecOverSaGeoMeanAtOneSec{121211} =	1.607;
% saKircherAtOneSecOverSaGeoMeanAtOneSec{121212} =	1.607;
% saKircherAtOneSecOverSaGeoMeanAtOneSec{121221} =	0.844;
% saKircherAtOneSecOverSaGeoMeanAtOneSec{121222} =	0.844;
% saKircherAtOneSecOverSaGeoMeanAtOneSec{121321} =	0.556;
% saKircherAtOneSecOverSaGeoMeanAtOneSec{121322} =	0.556;
% saKircherAtOneSecOverSaGeoMeanAtOneSec{121411} =	0.891;
% saKircherAtOneSecOverSaGeoMeanAtOneSec{121412} =	0.891;
% saKircherAtOneSecOverSaGeoMeanAtOneSec{121421} =	1.902;
% saKircherAtOneSecOverSaGeoMeanAtOneSec{121422} =	1.902;
% saKircherAtOneSecOverSaGeoMeanAtOneSec{121511} =	0.944;
% saKircherAtOneSecOverSaGeoMeanAtOneSec{121512} =	0.944;
% saKircherAtOneSecOverSaGeoMeanAtOneSec{121711} =	0.991;
% saKircherAtOneSecOverSaGeoMeanAtOneSec{121712} =	0.991;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% ATC-63 Near-Field Ground Motion Set G - Define the values of Sa,Kircher(T=1sec)/Sa,geoMean(T=1sec)
saKircherAtOneSecOverSaGeoMeanAtOneSec{8201811} =	1.471;
saKircherAtOneSecOverSaGeoMeanAtOneSec{8201812} =   1.471;
saKircherAtOneSecOverSaGeoMeanAtOneSec{8201821} =	1.074;
saKircherAtOneSecOverSaGeoMeanAtOneSec{8201822} =	1.074;
saKircherAtOneSecOverSaGeoMeanAtOneSec{8202921} =	1.207;
saKircherAtOneSecOverSaGeoMeanAtOneSec{8202922} =	1.207;
saKircherAtOneSecOverSaGeoMeanAtOneSec{8207231} =	0.910;
saKircherAtOneSecOverSaGeoMeanAtOneSec{8207232} =	0.910;
saKircherAtOneSecOverSaGeoMeanAtOneSec{8208021} =	1.062;
saKircherAtOneSecOverSaGeoMeanAtOneSec{8208022} =	1.062;
saKircherAtOneSecOverSaGeoMeanAtOneSec{8208211} =	1.026;
saKircherAtOneSecOverSaGeoMeanAtOneSec{8208212} =	1.026;
saKircherAtOneSecOverSaGeoMeanAtOneSec{8208281} =	0.774;
saKircherAtOneSecOverSaGeoMeanAtOneSec{8208282} =	0.774;
saKircherAtOneSecOverSaGeoMeanAtOneSec{8208791} =	2.266;
saKircherAtOneSecOverSaGeoMeanAtOneSec{8208792} =	2.266;
saKircherAtOneSecOverSaGeoMeanAtOneSec{8210631} =	1.021;
saKircherAtOneSecOverSaGeoMeanAtOneSec{8210632} =	1.021;
saKircherAtOneSecOverSaGeoMeanAtOneSec{8210861} =	1.108;
saKircherAtOneSecOverSaGeoMeanAtOneSec{8210862} =	1.108;
saKircherAtOneSecOverSaGeoMeanAtOneSec{8211651} =	0.842;
saKircherAtOneSecOverSaGeoMeanAtOneSec{8211652} =	0.842;
saKircherAtOneSecOverSaGeoMeanAtOneSec{8215031} =	0.748;
saKircherAtOneSecOverSaGeoMeanAtOneSec{8215032} =	0.748;
saKircherAtOneSecOverSaGeoMeanAtOneSec{8215291} =	1.333;
saKircherAtOneSecOverSaGeoMeanAtOneSec{8215292} =	1.333;
saKircherAtOneSecOverSaGeoMeanAtOneSec{8216051} =	0.991;
saKircherAtOneSecOverSaGeoMeanAtOneSec{8216052} =	0.991;
saKircherAtOneSecOverSaGeoMeanAtOneSec{8201261} =	0.994;
saKircherAtOneSecOverSaGeoMeanAtOneSec{8201262} =	0.994;
saKircherAtOneSecOverSaGeoMeanAtOneSec{8201601} =	1.007;
saKircherAtOneSecOverSaGeoMeanAtOneSec{8201602} =	1.007;
saKircherAtOneSecOverSaGeoMeanAtOneSec{8201651} =	0.645;
saKircherAtOneSecOverSaGeoMeanAtOneSec{8201652} =	0.645;
saKircherAtOneSecOverSaGeoMeanAtOneSec{8204951} =	0.992;
saKircherAtOneSecOverSaGeoMeanAtOneSec{8204952} =	0.992;
saKircherAtOneSecOverSaGeoMeanAtOneSec{8204961} =	1.191;
saKircherAtOneSecOverSaGeoMeanAtOneSec{8204962} =	1.191;
saKircherAtOneSecOverSaGeoMeanAtOneSec{8207411} =	0.879;
saKircherAtOneSecOverSaGeoMeanAtOneSec{8207412} =	0.879;
saKircherAtOneSecOverSaGeoMeanAtOneSec{8207531} =	0.836;
saKircherAtOneSecOverSaGeoMeanAtOneSec{8207532} =	0.836;
saKircherAtOneSecOverSaGeoMeanAtOneSec{8208251} =	1.364;
saKircherAtOneSecOverSaGeoMeanAtOneSec{8208252} =	1.364;
saKircherAtOneSecOverSaGeoMeanAtOneSec{8210041} =	0.821;
saKircherAtOneSecOverSaGeoMeanAtOneSec{8210042} =	0.821;
saKircherAtOneSecOverSaGeoMeanAtOneSec{8210481} =	0.750;
saKircherAtOneSecOverSaGeoMeanAtOneSec{8210482} =	0.750;
saKircherAtOneSecOverSaGeoMeanAtOneSec{8211761} =	1.534;
saKircherAtOneSecOverSaGeoMeanAtOneSec{8211762} =	1.534;
saKircherAtOneSecOverSaGeoMeanAtOneSec{8215041} =	0.860;
saKircherAtOneSecOverSaGeoMeanAtOneSec{8215042} =	0.860;
saKircherAtOneSecOverSaGeoMeanAtOneSec{8215171} =	0.545;
saKircherAtOneSecOverSaGeoMeanAtOneSec{8215172} =	0.545;
saKircherAtOneSecOverSaGeoMeanAtOneSec{8221141} =	1.162;
saKircherAtOneSecOverSaGeoMeanAtOneSec{8221142} =	1.162;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

