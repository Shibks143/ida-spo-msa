%
% Procedure: RunCollapseAnaMATLAB_NEWER_proc.m
% -------------------
% This is the same as RunCollapseAnaMATLAB_NEWER.m, but it is just a
% procedure.
%
% Assumptions and Notices: 
%           - none
%
% Author: Curt Haselton 
% Date Written: 6-28-06
%
% Functions and Procedures called: none
%
% Variable definitions: 
%       - not listed
%
% Units: Whatever OpenSees is using - just be consistent!
%
% -------------------
% Save current folder



function sks_writePushoverLoading(runDifferentPushoverPatterns, SPO_index)

% currentPushoverPattern =[0.4401491;
%                          0.2886080;
%                          0.1689272;
%                          0.0811068;
%                          0.0212089];

%% 1. open the file
% filePath = fullfile(pwd, "Models", "ID2433_R5_5Story_v.02");
% cd(filePath);

 
[numFloors, numPatterns] = size(runDifferentPushoverPatterns);
myFileStream = fopen("psb_DefinePushoverLoading.tcl", 'w');

fprintf(myFileStream, '# This file was created by the MATLAB function (WriteVariablesToFileForOpensees.m), for a single collapse\n'); 
fprintf(myFileStream, '#----------------------------------------------------------------------------------#\n');
fprintf(myFileStream, '# DefinePushoverLoading\n');
fprintf(myFileStream, '#		This module defines the pushover reference load patterns that is used \n');
fprintf(myFileStream, '#		for the pushover analysis.\n');
fprintf(myFileStream, '#\n');
fprintf(myFileStream, '# Units: kN, mm, seconds\n');
fprintf(myFileStream, '#\n');
fprintf(myFileStream, '# This file developed by: Curt Haselton of Stanford University (28 June 2005)\n');
fprintf(myFileStream, '# Modified by: Prakash S Badal of IIT Bombay (20 Mar 2016)\n');
fprintf(myFileStream, '# Remodified by: Shivakumar K S of IIT Madras (21 Oct 2025) \n');
fprintf(myFileStream, '#\n');
fprintf(myFileStream, '#----------------------------------------------------------------------------------#\n');
fprintf(myFileStream, '\n');
fprintf(myFileStream, '#########################################################################################################################\n');
fprintf(myFileStream, '########### Start of code pasted from Excel Structural Design Sheet output to DefinePushoverLoading.tcl #################\n');
fprintf(myFileStream, '########### This code was created using a Visual Basic script in the Structural Design Excel sheet ######################\n');
fprintf(myFileStream, '########### Created by Curt B. Haselton, Stanford University, June 10, 2006 #############################################\n');
fprintf(myFileStream, '#########################################################################################################################\n');
fprintf(myFileStream, '\n');
fprintf(myFileStream, '#########################################################################################################################\n');
fprintf(myFileStream, '### AUTO-GENERATED DEFINE PUSHOVER LOADING\n');
fprintf(myFileStream, '# Contains %d pushover patterns\n', numPatterns);
fprintf(myFileStream, ' \n');

% fprintf(myFileStream, '    pattern Plain 3 Linear {\n');
% fprintf(myFileStream, '#       node        FX		  FY   MZ \n');
% fprintf(myFileStream, '###### ASCE 7-10 LOADING\n');
% fprintf(myFileStream, '# load, 206013, 0.3379116383, 0.0, 0.0 \n');
% fprintf(myFileStream, '# load, 205013, 0.2667118509, 0.0, 0.0 \n');
% fprintf(myFileStream, '# load, 204013, 0.1984595113, 0.0, 0.0 \n');
% fprintf(myFileStream, '# load, 203013, 0.1306150544, 0.0, 0.0 \n');
% fprintf(myFileStream, '# load, 202013, 0.0663019451, 0.0, 0.0 \n');
% fprintf(myFileStream, '}\n');


 % till here header code
fprintf(myFileStream, '#############################################\n\n');
fprintf(myFileStream, '# SINGLE PUSHOVER PATTERN %d ONLY\n', SPO_index);
fprintf(myFileStream, '#############################################\n\n');

% SINGLE PATTERN for each SPO_index
pattern_id = 10 + SPO_index;  % 11 or 12 or 13 
fprintf(myFileStream, 'pattern Plain %d Linear {\n', pattern_id);
fprintf(myFileStream, '# node    FX      FY   MZ\n');

floor_levels = (numFloors+1):-1:2;
node_start   = 13;
num_nodes    = 4;
node_step    = 10;
FY = 0; MZ = 0;

for j = 1:numFloors
    forceOnLevel = runDifferentPushoverPatterns(j, SPO_index);  %  SPO_index column
    for i = 1:num_nodes
        node = 200000 + floor_levels(j)*1000 + node_start + node_step*(i-1);
        if i == 1 || i == num_nodes
            forceOnNode = forceOnLevel  * (1/6);
        else
            forceOnNode = forceOnLevel  * (2/6);
        end
        fprintf(myFileStream, "    load %d %.10f %.1f %.1f\n", node, forceOnNode, FY, MZ);
    end
end
fprintf(myFileStream, "}\n");
fclose(myFileStream);
end

