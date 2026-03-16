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

function sks_writePushoverLoading(currentPushoverPattern, SPO_index)
% currentPushoverPattern =[0.4401491;
%                          0.2886080;
%                          0.1689272;
%                          0.0811068;
%                          0.0212089];

%% 1. open the file
filename = sprintf("psb_DefinePushoverLoading.tcl", SPO_index); %remove existing content and starts 
myFileStream = fopen (filename, 'w');
fprintf(myFileStream, '# This file was created by the MATLAB function (WriteVariablesToFileForOpensees.m), for a single collapse\n'); 
fprintf(myFileStream, '#----------------------------------------------------------------------------------#\n');
fprintf(myFileStream, '# DefinePushoverLoading\n');
fprintf(myFileStream, '#		This module defines the pushover reference load pattern that is used \n');
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
fprintf(myFileStream, '### DEFINE PUSHOVER LOADING\n');
fprintf(myFileStream, ' \n');
fprintf(myFileStream, '    pattern Plain 2 Linear {\n');
fprintf(myFileStream, '#       node        FX		  FY   MZ \n');


fprintf(myFileStream, '###### ASCE 7-10 LOADING\n');
fprintf(myFileStream, '# load, 206013, 0.3379116383, 0.0, 0.0 \n');
fprintf(myFileStream, '# load, 205013, 0.2667118509, 0.0, 0.0 \n');
fprintf(myFileStream, '# load, 204013, 0.1984595113, 0.0, 0.0 \n');
fprintf(myFileStream, '# load, 203013, 0.1306150544, 0.0, 0.0 \n');
fprintf(myFileStream, '# load, 202013, 0.0663019451, 0.0, 0.0 \n');
fprintf(myFileStream, '\n');


fprintf(myFileStream, '###### PushoverPatterns LOADING\n');
numFloors = length(currentPushoverPattern); % automatically detect number of levels
floor_levels = (numFloors+1):-1:2;          % e.g., 6:-1:2 for 5 floors

% floor_levels = 6:-1:2;
node_start = 13;
num_nodes = 4;
node_step = 10;
FY = 0.0;
MZ = 0.0;

for j = 1:length(floor_levels)
    floor_level = floor_levels(j);
    for i = 1:num_nodes
        ForceOnALevel = currentPushoverPattern(j); % Each pattern value for (level, node)
        node = 200000 + floor_level*1000 + node_start + node_step*(i-1);
        % Assign 1/6 to start/end, 2/6 to middle nodes
        if i == 1 || i == num_nodes
            ForceOnNodes = ForceOnALevel * (1/6);
        else
            ForceOnNodes = ForceOnALevel * (2/6);
        end
        fprintf(myFileStream, 'load\t%d\t%.10f\t%.1f\t%.1f\n', node, ForceOnNodes, FY, MZ);
    end
end



fprintf(myFileStream, '}\n');
fclose(myFileStream);


