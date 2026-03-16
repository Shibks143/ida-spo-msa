# This file was created by the MATLAB function (WriteVariablesToFileForOpensees.m), for a single collapse
#----------------------------------------------------------------------------------#
# DefinePushoverLoading
#		This module defines the pushover reference load pattern that is used 
#		for the pushover analysis.
#
# Units: kN, mm, seconds
#
# This file developed by: Curt Haselton of Stanford University (28 June 2005)
# Modified by: Prakash S Badal of IIT Bombay (20 Mar 2016)
# Remodified by: Shivakumar K S of IIT Madras (21 Oct 2025) 
#
#----------------------------------------------------------------------------------#

#########################################################################################################################
########### Start of code pasted from Excel Structural Design Sheet output to DefinePushoverLoading.tcl #################
########### This code was created using a Visual Basic script in the Structural Design Excel sheet ######################
########### Created by Curt B. Haselton, Stanford University, June 10, 2006 #############################################
#########################################################################################################################

#########################################################################################################################
### DEFINE PUSHOVER LOADING
 
    pattern Plain 2 Linear {
#       node        FX		  FY   MZ 
###### ASCE 7-10 LOADING
# load, 206013, 0.3379116383, 0.0, 0.0 
# load, 205013, 0.2667118509, 0.0, 0.0 
# load, 204013, 0.1984595113, 0.0, 0.0 
# load, 203013, 0.1306150544, 0.0, 0.0 
# load, 202013, 0.0663019451, 0.0, 0.0 

###### Parabolic, Linear LOADING
load	206013	0.0733581833	0.0	0.0
load	206023	0.1467163667	0.0	0.0
load	206033	0.1467163667	0.0	0.0
load	206043	0.0733581833	0.0	0.0
load	205013	0.0481013333	0.0	0.0
load	205023	0.0962026667	0.0	0.0
load	205033	0.0962026667	0.0	0.0
load	205043	0.0481013333	0.0	0.0
load	204013	0.0281545333	0.0	0.0
load	204023	0.0563090667	0.0	0.0
load	204033	0.0563090667	0.0	0.0
load	204043	0.0281545333	0.0	0.0
load	203013	0.0135178000	0.0	0.0
load	203023	0.0270356000	0.0	0.0
load	203033	0.0270356000	0.0	0.0
load	203043	0.0135178000	0.0	0.0
load	202013	0.0035348167	0.0	0.0
load	202023	0.0070696333	0.0	0.0
load	202033	0.0070696333	0.0	0.0
load	202043	0.0035348167	0.0	0.0
}
