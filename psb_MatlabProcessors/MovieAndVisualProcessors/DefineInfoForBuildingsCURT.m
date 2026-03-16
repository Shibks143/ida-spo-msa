%
% Procedure: DefineInfoForBuildings.m
% -------------------
% This procedure defines the information for the buildings.  This
%   information consists of things like building geometry plastic rotation
%   capacities of elements, and some dimensional information for plotting the
%   building.
% 
% Buidling ID numbers: Frames are buildings 1-999 and walls are buildings 1000ff (format of input varies for frame/wall)
%       - Building 1: Design from the Benchmark study (4 story SMF; ID1_v.64), and ATC-63 Design A v.9
%       - Building 3: Design from the Benchmark study (4 story SMF; ID3_v.10)
%       - Building 5: Design from the Benchmark study (4 story SMF; ID5_v.3)
%       - Building 6: Design from the Benchmark study (4 story SMF; ID6_v.5)
%       - Building 9: Design from the Benchmark study (4 story SMF; ID9_v.4)
%       - Building 10: Design from the Benchmark study (4 story SMF; ID10_v.4)
%       - Building 11: Design from the Benchmark study (4 story SMF; ID11_v.2)
%
%       - Building 20: 4 Story OMF Frame ATC-63 (4 story OMF; DesB_v.5)
%       - Building 21: 4 Story IMF Frame ATC-63 (4 story IMF; DesC_v.9)
%
%       - Building 501: 12 Story IMF Frame ATC-63 (Full model)
%       - Building 502: 12 Story IMF Frame ATC-63 (Half model)
%
%       - Building 1000: Wall A from the ATC-63 project (12 story special core wall)
%
%
%
% Assumptions and Notices: 
%           - none
%
% Author: Curt Haselton 
% Date Written: 12-03-05
% Modified: Abbie Liel, 12/11/05
%
% Sources of Code: none
%
% Functions and Procedures called: none
%
% Units: kips and inches
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function[buildingInfo] = DefineInfoForBuildings()



% Pasted from Excel 4story_ID1009_v10 on 7-14-06 by Curt Haselton
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%% Design ID 1009 - Start %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% This code was pasted from the Excel Structural Design Sheet VB output (Dev. by C. Haselton, 6-13-06)
 
% Define General Geometry Information
      bldgID = 1009;
      buildingInfo{bldgID}.bayWidth = 360;
      buildingInfo{bldgID}.storyHeight_firstStory = 180;
      buildingInfo{bldgID}.storyHeight_upperStories = 156;
      buildingInfo{bldgID}.jointWidth = 30;
      buildingInfo{bldgID}.jointWidth = 30; % Just for plotting
      buildingInfo{bldgID}.jointHeight = 40; % Just for plotting
      buildingInfo{bldgID}.numBays = 3;
      buildingInfo{bldgID}.numStories = 4;
      buildingInfo{bldgID}.collapseDriftThreshold = 0.12;
 
% Define the plastic rotation capacities of the column materials
     plasticRotCapOfMaterialNum(304011) = 7.26112692523515E-02;
     plasticRotCapOfMaterialNum(304021) = 0.071367552477462;
     plasticRotCapOfMaterialNum(304031) = 0.071367552477462;
     plasticRotCapOfMaterialNum(304041) = 7.26112692523515E-02;
 
     plasticRotCapOfMaterialNum(303011) = 8.39210290827678E-02;
     plasticRotCapOfMaterialNum(303021) = 8.47361352195554E-02;
     plasticRotCapOfMaterialNum(303031) = 8.47361352195554E-02;
     plasticRotCapOfMaterialNum(303041) = 8.39210290827678E-02;
 
     plasticRotCapOfMaterialNum(302011) = 7.92315054450891E-02;
     plasticRotCapOfMaterialNum(302021) = 0.075536166536614;
     plasticRotCapOfMaterialNum(302031) = 0.075536166536614;
     plasticRotCapOfMaterialNum(302041) = 7.92315054450891E-02;
 
     plasticRotCapOfMaterialNum(301011) = 7.73977973319272E-02;
     plasticRotCapOfMaterialNum(301021) = 6.92348365608406E-02;
     plasticRotCapOfMaterialNum(301031) = 6.92348365608406E-02;
     plasticRotCapOfMaterialNum(301041) = 7.69463088953739E-02;
 
% Define the plastic rotation capacities of the beam materials - make all materials be positive (end in 1)
     plasticRotCapOfMaterialNum(205011) = 3.67717729277892E-02;
     plasticRotCapOfMaterialNum(205021) = 3.67717729277892E-02;
     plasticRotCapOfMaterialNum(205031) = 3.67717729277892E-02;
 
     plasticRotCapOfMaterialNum(204011) = 5.50738678356336E-02;
     plasticRotCapOfMaterialNum(204021) = 5.50738678356336E-02;
     plasticRotCapOfMaterialNum(204031) = 5.50738678356336E-02;
 
     plasticRotCapOfMaterialNum(203011) = 5.20008138420545E-02;
     plasticRotCapOfMaterialNum(203021) = 5.20008138420545E-02;
     plasticRotCapOfMaterialNum(203031) = 5.20008138420545E-02;
 
     plasticRotCapOfMaterialNum(202011) = 0.056240372537355;
     plasticRotCapOfMaterialNum(202021) = 0.056240372537355;
     plasticRotCapOfMaterialNum(202031) = 0.056240372537355;
 
% Define the plastic rotation capacities of shear panel material (40000) and the dummy material (49999) used in locations where no element connects to the joint
     plasticRotCapOfMaterialNum(40000) = 99;
     plasticRotCapOfMaterialNum(49999) = 999;
 
% Define the column base rotational spring PHR capacities
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(1, 1).node(1) = plasticRotCapOfMaterialNum(301011);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(1, 2).node(1) = plasticRotCapOfMaterialNum(301021);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(1, 3).node(1) = plasticRotCapOfMaterialNum(301031);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(1, 4).node(1) = plasticRotCapOfMaterialNum(301041);
 
% Define the PHR capacities at all 5 material locations of each joint (4 PHs and 1 shear panel).  When there is not an elements connected to a specific portion of a joint, I use the dummy material #49999.  Make all beam materials be positive (end in 1).
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(5, 1).node(1) = plasticRotCapOfMaterialNum(304011);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(5, 1).node(2) = plasticRotCapOfMaterialNum(205011);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(5, 1).node(3) = plasticRotCapOfMaterialNum(49999);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(5, 1).node(4) = plasticRotCapOfMaterialNum(49999);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(5, 1).node(5) = plasticRotCapOfMaterialNum(40000);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(5, 2).node(1) = plasticRotCapOfMaterialNum(304021);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(5, 2).node(2) = plasticRotCapOfMaterialNum(205021);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(5, 2).node(3) = plasticRotCapOfMaterialNum(49999);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(5, 2).node(4) = plasticRotCapOfMaterialNum(205011);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(5, 2).node(5) = plasticRotCapOfMaterialNum(40000);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(5, 3).node(1) = plasticRotCapOfMaterialNum(304031);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(5, 3).node(2) = plasticRotCapOfMaterialNum(205031);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(5, 3).node(3) = plasticRotCapOfMaterialNum(49999);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(5, 3).node(4) = plasticRotCapOfMaterialNum(205021);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(5, 3).node(5) = plasticRotCapOfMaterialNum(40000);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(5, 4).node(1) = plasticRotCapOfMaterialNum(304041);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(5, 4).node(2) = plasticRotCapOfMaterialNum(49999);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(5, 4).node(3) = plasticRotCapOfMaterialNum(49999);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(5, 4).node(4) = plasticRotCapOfMaterialNum(205031);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(5, 4).node(5) = plasticRotCapOfMaterialNum(40000);
 
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(4, 1).node(1) = plasticRotCapOfMaterialNum(303011);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(4, 1).node(2) = plasticRotCapOfMaterialNum(204011);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(4, 1).node(3) = plasticRotCapOfMaterialNum(304011);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(4, 1).node(4) = plasticRotCapOfMaterialNum(49999);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(4, 1).node(5) = plasticRotCapOfMaterialNum(40000);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(4, 2).node(1) = plasticRotCapOfMaterialNum(303021);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(4, 2).node(2) = plasticRotCapOfMaterialNum(204021);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(4, 2).node(3) = plasticRotCapOfMaterialNum(304021);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(4, 2).node(4) = plasticRotCapOfMaterialNum(204011);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(4, 2).node(5) = plasticRotCapOfMaterialNum(40000);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(4, 3).node(1) = plasticRotCapOfMaterialNum(303031);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(4, 3).node(2) = plasticRotCapOfMaterialNum(204031);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(4, 3).node(3) = plasticRotCapOfMaterialNum(304031);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(4, 3).node(4) = plasticRotCapOfMaterialNum(204021);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(4, 3).node(5) = plasticRotCapOfMaterialNum(40000);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(4, 4).node(1) = plasticRotCapOfMaterialNum(303041);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(4, 4).node(2) = plasticRotCapOfMaterialNum(49999);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(4, 4).node(3) = plasticRotCapOfMaterialNum(304041);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(4, 4).node(4) = plasticRotCapOfMaterialNum(204031);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(4, 4).node(5) = plasticRotCapOfMaterialNum(40000);
 
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(3, 1).node(1) = plasticRotCapOfMaterialNum(302011);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(3, 1).node(2) = plasticRotCapOfMaterialNum(203011);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(3, 1).node(3) = plasticRotCapOfMaterialNum(303011);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(3, 1).node(4) = plasticRotCapOfMaterialNum(49999);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(3, 1).node(5) = plasticRotCapOfMaterialNum(40000);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(3, 2).node(1) = plasticRotCapOfMaterialNum(302021);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(3, 2).node(2) = plasticRotCapOfMaterialNum(203021);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(3, 2).node(3) = plasticRotCapOfMaterialNum(303021);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(3, 2).node(4) = plasticRotCapOfMaterialNum(203011);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(3, 2).node(5) = plasticRotCapOfMaterialNum(40000);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(3, 3).node(1) = plasticRotCapOfMaterialNum(302031);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(3, 3).node(2) = plasticRotCapOfMaterialNum(203031);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(3, 3).node(3) = plasticRotCapOfMaterialNum(303031);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(3, 3).node(4) = plasticRotCapOfMaterialNum(203021);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(3, 3).node(5) = plasticRotCapOfMaterialNum(40000);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(3, 4).node(1) = plasticRotCapOfMaterialNum(302041);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(3, 4).node(2) = plasticRotCapOfMaterialNum(49999);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(3, 4).node(3) = plasticRotCapOfMaterialNum(303041);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(3, 4).node(4) = plasticRotCapOfMaterialNum(203031);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(3, 4).node(5) = plasticRotCapOfMaterialNum(40000);
 
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(2, 1).node(1) = plasticRotCapOfMaterialNum(301011);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(2, 1).node(2) = plasticRotCapOfMaterialNum(202011);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(2, 1).node(3) = plasticRotCapOfMaterialNum(302011);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(2, 1).node(4) = plasticRotCapOfMaterialNum(49999);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(2, 1).node(5) = plasticRotCapOfMaterialNum(40000);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(2, 2).node(1) = plasticRotCapOfMaterialNum(301021);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(2, 2).node(2) = plasticRotCapOfMaterialNum(202021);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(2, 2).node(3) = plasticRotCapOfMaterialNum(302021);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(2, 2).node(4) = plasticRotCapOfMaterialNum(202011);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(2, 2).node(5) = plasticRotCapOfMaterialNum(40000);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(2, 3).node(1) = plasticRotCapOfMaterialNum(301031);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(2, 3).node(2) = plasticRotCapOfMaterialNum(202031);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(2, 3).node(3) = plasticRotCapOfMaterialNum(302031);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(2, 3).node(4) = plasticRotCapOfMaterialNum(202021);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(2, 3).node(5) = plasticRotCapOfMaterialNum(40000);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(2, 4).node(1) = plasticRotCapOfMaterialNum(301041);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(2, 4).node(2) = plasticRotCapOfMaterialNum(49999);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(2, 4).node(3) = plasticRotCapOfMaterialNum(302041);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(2, 4).node(4) = plasticRotCapOfMaterialNum(202031);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(2, 4).node(5) = plasticRotCapOfMaterialNum(40000);
 
     % Define the joint numbers at each location in the frame
         for colLineNum = 1:4
             for floorNum = 2:5
                 buildingInfo{bldgID}.jointNumber(floorNum, colLineNum) = 40000 + (100.0 * floorNum) + colLineNum;
             end
         end
 
      % Define the hinge element numbers that are used at the base columns
         for colLineNum = 1:4
             buildingInfo{bldgID}.hingeElementNumAtColBase(colLineNum) = 6000 + colLineNum * 10 + 2; % The PH Spring at the column base
         end
 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%% Design ID 1009 - END %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


% Pasted from Excel 4story_ID1003_v.51 on 7-26-06 by Brian Dean
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%% Design ID 1003 - Start %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
 %%%% This code was pasted from the Excel Structural Design Sheet VB output (Dev. by C. Haselton, 6-13-06)
 
% Define General Geometry Information
      bldgID = 1003;
      buildingInfo{bldgID}.bayWidth = 240;
      buildingInfo{bldgID}.storyHeight_firstStory = 180;
      buildingInfo{bldgID}.storyHeight_upperStories = 156;
      buildingInfo{bldgID}.jointWidth = 30;
      buildingInfo{bldgID}.jointWidth = 30; % Just for plotting
      buildingInfo{bldgID}.jointHeight = 24; % Just for plotting
      buildingInfo{bldgID}.numBays = 3;
      buildingInfo{bldgID}.numStories = 4;
      buildingInfo{bldgID}.collapseDriftThreshold = 0.12;
 
% Define the plastic rotation capacities of the column materials
     plasticRotCapOfMaterialNum(304011) = 6.93918037455952E-02;
     plasticRotCapOfMaterialNum(304021) = 0.079635685287168;
     plasticRotCapOfMaterialNum(304031) = 0.079635685287168;
     plasticRotCapOfMaterialNum(304041) = 6.93918037455952E-02;
 
     plasticRotCapOfMaterialNum(303011) = 6.88806597308015E-02;
     plasticRotCapOfMaterialNum(303021) = 7.87114501172223E-02;
     plasticRotCapOfMaterialNum(303031) = 7.87114501172223E-02;
     plasticRotCapOfMaterialNum(303041) = 6.88806597308015E-02;
 
     plasticRotCapOfMaterialNum(302011) = 7.48818718459065E-02;
     plasticRotCapOfMaterialNum(302021) = 8.28022230451476E-02;
     plasticRotCapOfMaterialNum(302031) = 8.28022230451476E-02;
     plasticRotCapOfMaterialNum(302041) = 7.48818718459065E-02;
 
     plasticRotCapOfMaterialNum(301011) = 8.15165989660335E-02;
     plasticRotCapOfMaterialNum(301021) = 8.62545982482996E-02;
     plasticRotCapOfMaterialNum(301031) = 8.62545982482996E-02;
     plasticRotCapOfMaterialNum(301041) = 8.15165989660335E-02;
 
% Define the plastic rotation capacities of the beam materials - make all materials be positive (end in 1)
     plasticRotCapOfMaterialNum(205011) = 4.76285734927437E-02;
     plasticRotCapOfMaterialNum(205021) = 4.76285734927437E-02;
     plasticRotCapOfMaterialNum(205031) = 4.76285734927437E-02;
 
     plasticRotCapOfMaterialNum(204011) = 0.0572072090335;
     plasticRotCapOfMaterialNum(204021) = 5.74837683489086E-02;
     plasticRotCapOfMaterialNum(204031) = 0.0572072090335;
 
     plasticRotCapOfMaterialNum(203011) = 6.24180275536759E-02;
     plasticRotCapOfMaterialNum(203021) = 6.26713593202897E-02;
     plasticRotCapOfMaterialNum(203031) = 6.24180275536759E-02;
 
     plasticRotCapOfMaterialNum(202011) = 6.47211748758436E-02;
     plasticRotCapOfMaterialNum(202021) = 6.49697754254409E-02;
     plasticRotCapOfMaterialNum(202031) = 6.47211748758436E-02;
 
% Define the plastic rotation capacities of shear panel material (40000) and the dummy material (49999) used in locations where no element connects to the joint
     plasticRotCapOfMaterialNum(40000) = 99;
     plasticRotCapOfMaterialNum(49999) = 999;
 
% Define the column base rotational spring PHR capacities
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(1, 1).node(1) = plasticRotCapOfMaterialNum(301011);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(1, 2).node(1) = plasticRotCapOfMaterialNum(301021);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(1, 3).node(1) = plasticRotCapOfMaterialNum(301031);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(1, 4).node(1) = plasticRotCapOfMaterialNum(301041);
 
% Define the PHR capacities at all 5 material locations of each joint (4 PHs and 1 shear panel).  When there is not an elements connected to a specific portion of a joint, I use the dummy material #49999.  Make all beam materials be positive (end in 1).
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(5, 1).node(1) = plasticRotCapOfMaterialNum(304011);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(5, 1).node(2) = plasticRotCapOfMaterialNum(205011);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(5, 1).node(3) = plasticRotCapOfMaterialNum(49999);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(5, 1).node(4) = plasticRotCapOfMaterialNum(49999);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(5, 1).node(5) = plasticRotCapOfMaterialNum(40000);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(5, 2).node(1) = plasticRotCapOfMaterialNum(304021);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(5, 2).node(2) = plasticRotCapOfMaterialNum(205021);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(5, 2).node(3) = plasticRotCapOfMaterialNum(49999);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(5, 2).node(4) = plasticRotCapOfMaterialNum(205011);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(5, 2).node(5) = plasticRotCapOfMaterialNum(40000);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(5, 3).node(1) = plasticRotCapOfMaterialNum(304031);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(5, 3).node(2) = plasticRotCapOfMaterialNum(205031);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(5, 3).node(3) = plasticRotCapOfMaterialNum(49999);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(5, 3).node(4) = plasticRotCapOfMaterialNum(205021);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(5, 3).node(5) = plasticRotCapOfMaterialNum(40000);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(5, 4).node(1) = plasticRotCapOfMaterialNum(304041);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(5, 4).node(2) = plasticRotCapOfMaterialNum(49999);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(5, 4).node(3) = plasticRotCapOfMaterialNum(49999);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(5, 4).node(4) = plasticRotCapOfMaterialNum(205031);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(5, 4).node(5) = plasticRotCapOfMaterialNum(40000);
 
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(4, 1).node(1) = plasticRotCapOfMaterialNum(303011);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(4, 1).node(2) = plasticRotCapOfMaterialNum(204011);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(4, 1).node(3) = plasticRotCapOfMaterialNum(304011);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(4, 1).node(4) = plasticRotCapOfMaterialNum(49999);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(4, 1).node(5) = plasticRotCapOfMaterialNum(40000);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(4, 2).node(1) = plasticRotCapOfMaterialNum(303021);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(4, 2).node(2) = plasticRotCapOfMaterialNum(204021);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(4, 2).node(3) = plasticRotCapOfMaterialNum(304021);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(4, 2).node(4) = plasticRotCapOfMaterialNum(204011);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(4, 2).node(5) = plasticRotCapOfMaterialNum(40000);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(4, 3).node(1) = plasticRotCapOfMaterialNum(303031);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(4, 3).node(2) = plasticRotCapOfMaterialNum(204031);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(4, 3).node(3) = plasticRotCapOfMaterialNum(304031);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(4, 3).node(4) = plasticRotCapOfMaterialNum(204021);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(4, 3).node(5) = plasticRotCapOfMaterialNum(40000);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(4, 4).node(1) = plasticRotCapOfMaterialNum(303041);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(4, 4).node(2) = plasticRotCapOfMaterialNum(49999);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(4, 4).node(3) = plasticRotCapOfMaterialNum(304041);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(4, 4).node(4) = plasticRotCapOfMaterialNum(204031);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(4, 4).node(5) = plasticRotCapOfMaterialNum(40000);
 
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(3, 1).node(1) = plasticRotCapOfMaterialNum(302011);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(3, 1).node(2) = plasticRotCapOfMaterialNum(203011);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(3, 1).node(3) = plasticRotCapOfMaterialNum(303011);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(3, 1).node(4) = plasticRotCapOfMaterialNum(49999);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(3, 1).node(5) = plasticRotCapOfMaterialNum(40000);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(3, 2).node(1) = plasticRotCapOfMaterialNum(302021);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(3, 2).node(2) = plasticRotCapOfMaterialNum(203021);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(3, 2).node(3) = plasticRotCapOfMaterialNum(303021);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(3, 2).node(4) = plasticRotCapOfMaterialNum(203011);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(3, 2).node(5) = plasticRotCapOfMaterialNum(40000);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(3, 3).node(1) = plasticRotCapOfMaterialNum(302031);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(3, 3).node(2) = plasticRotCapOfMaterialNum(203031);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(3, 3).node(3) = plasticRotCapOfMaterialNum(303031);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(3, 3).node(4) = plasticRotCapOfMaterialNum(203021);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(3, 3).node(5) = plasticRotCapOfMaterialNum(40000);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(3, 4).node(1) = plasticRotCapOfMaterialNum(302041);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(3, 4).node(2) = plasticRotCapOfMaterialNum(49999);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(3, 4).node(3) = plasticRotCapOfMaterialNum(303041);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(3, 4).node(4) = plasticRotCapOfMaterialNum(203031);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(3, 4).node(5) = plasticRotCapOfMaterialNum(40000);
 
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(2, 1).node(1) = plasticRotCapOfMaterialNum(301011);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(2, 1).node(2) = plasticRotCapOfMaterialNum(202011);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(2, 1).node(3) = plasticRotCapOfMaterialNum(302011);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(2, 1).node(4) = plasticRotCapOfMaterialNum(49999);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(2, 1).node(5) = plasticRotCapOfMaterialNum(40000);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(2, 2).node(1) = plasticRotCapOfMaterialNum(301021);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(2, 2).node(2) = plasticRotCapOfMaterialNum(202021);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(2, 2).node(3) = plasticRotCapOfMaterialNum(302021);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(2, 2).node(4) = plasticRotCapOfMaterialNum(202011);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(2, 2).node(5) = plasticRotCapOfMaterialNum(40000);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(2, 3).node(1) = plasticRotCapOfMaterialNum(301031);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(2, 3).node(2) = plasticRotCapOfMaterialNum(202031);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(2, 3).node(3) = plasticRotCapOfMaterialNum(302031);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(2, 3).node(4) = plasticRotCapOfMaterialNum(202021);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(2, 3).node(5) = plasticRotCapOfMaterialNum(40000);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(2, 4).node(1) = plasticRotCapOfMaterialNum(301041);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(2, 4).node(2) = plasticRotCapOfMaterialNum(49999);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(2, 4).node(3) = plasticRotCapOfMaterialNum(302041);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(2, 4).node(4) = plasticRotCapOfMaterialNum(202031);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(2, 4).node(5) = plasticRotCapOfMaterialNum(40000);
 
     % Define the joint numbers at each location in the frame
         for colLineNum = 1:4
             for floorNum = 2:5
                 buildingInfo{bldgID}.jointNumber(floorNum, colLineNum) = 40000 + (100.0 * floorNum) + colLineNum;
             end
         end
 
      % Define the hinge element numbers that are used at the base columns
         for colLineNum = 1:4
             buildingInfo{bldgID}.hingeElementNumAtColBase(colLineNum) = 6000 + colLineNum * 10 + 2; % The PH Spring at the column base
         end
 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%% Design ID 1003 - END %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


% Pasted from Excel 12story_ID1014_v.61 on 7-20-06 by Brian Dean
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%% Design ID 1014 - Start %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
 %%%% This code was pasted from the Excel Structural Design Sheet VB output (Dev. by C. Haselton, 6-13-06)
 
% Define General Geometry Information
      bldgID = 1014;
      buildingInfo{bldgID}.bayWidth = 240;
      buildingInfo{bldgID}.storyHeight_firstStory = 180;
      buildingInfo{bldgID}.storyHeight_upperStories = 156;
      buildingInfo{bldgID}.jointWidth = 22;
      buildingInfo{bldgID}.jointWidth = 22; % Just for plotting
      buildingInfo{bldgID}.jointHeight = 28; % Just for plotting
      buildingInfo{bldgID}.numBays = 3;
      buildingInfo{bldgID}.numStories = 12;
      buildingInfo{bldgID}.collapseDriftThreshold = 0.12;
 
% Define the plastic rotation capacities of the column materials
     plasticRotCapOfMaterialNum(312011) = 6.79733629316178E-02;
     plasticRotCapOfMaterialNum(312021) = 6.76522372966836E-02;
     plasticRotCapOfMaterialNum(312031) = 6.76522372966836E-02;
     plasticRotCapOfMaterialNum(312041) = 6.79733629316178E-02;
 
     plasticRotCapOfMaterialNum(311011) = 6.60087316345229E-02;
     plasticRotCapOfMaterialNum(311021) = 6.37980530592333E-02;
     plasticRotCapOfMaterialNum(311031) = 6.37980530592333E-02;
     plasticRotCapOfMaterialNum(311041) = 6.60087316345229E-02;
 
     plasticRotCapOfMaterialNum(310011) = 6.48939794063516E-02;
     plasticRotCapOfMaterialNum(310021) = 6.14091850257371E-02;
     plasticRotCapOfMaterialNum(310031) = 6.14091850257371E-02;
     plasticRotCapOfMaterialNum(310041) = 6.48939794063516E-02;
 
     plasticRotCapOfMaterialNum(309011) = 6.30183514039088E-02;
     plasticRotCapOfMaterialNum(309021) = 5.87474537775237E-02;
     plasticRotCapOfMaterialNum(309031) = 5.87474537775237E-02;
     plasticRotCapOfMaterialNum(309041) = 6.30183514039088E-02;
 
     plasticRotCapOfMaterialNum(308011) = 6.24640752707776E-02;
     plasticRotCapOfMaterialNum(308021) = 5.49482735432998E-02;
     plasticRotCapOfMaterialNum(308031) = 5.49482735432998E-02;
     plasticRotCapOfMaterialNum(308041) = 6.24640752707776E-02;
 
     plasticRotCapOfMaterialNum(307011) = 6.04105537470377E-02;
     plasticRotCapOfMaterialNum(307021) = 5.17117516306078E-02;
     plasticRotCapOfMaterialNum(307031) = 5.17117516306078E-02;
     plasticRotCapOfMaterialNum(307041) = 6.04105537470377E-02;
 
     plasticRotCapOfMaterialNum(306011) = 5.86645100109692E-02;
     plasticRotCapOfMaterialNum(306021) = 4.83675681462289E-02;
     plasticRotCapOfMaterialNum(306031) = 4.83675681462289E-02;
     plasticRotCapOfMaterialNum(306041) = 5.86645100109692E-02;
 
     plasticRotCapOfMaterialNum(305011) = 5.69689321047792E-02;
     plasticRotCapOfMaterialNum(305021) = 4.56120418517255E-02;
     plasticRotCapOfMaterialNum(305031) = 4.56120418517255E-02;
     plasticRotCapOfMaterialNum(305041) = 5.69689321047792E-02;
 
     plasticRotCapOfMaterialNum(304011) = 5.48706937252772E-02;
     plasticRotCapOfMaterialNum(304021) = 4.24878140992795E-02;
     plasticRotCapOfMaterialNum(304031) = 4.24878140992795E-02;
     plasticRotCapOfMaterialNum(304041) = 5.48706937252772E-02;
 
     plasticRotCapOfMaterialNum(303011) = 5.32847683342614E-02;
     plasticRotCapOfMaterialNum(303021) = 4.00672605458616E-02;
     plasticRotCapOfMaterialNum(303031) = 4.00672605458616E-02;
     plasticRotCapOfMaterialNum(303041) = 5.32847683342614E-02;
 
     plasticRotCapOfMaterialNum(302011) = 5.17446808792203E-02;
     plasticRotCapOfMaterialNum(302021) = 3.77846072264089E-02;
     plasticRotCapOfMaterialNum(302031) = 3.77846072264089E-02;
     plasticRotCapOfMaterialNum(302041) = 5.17446808792203E-02;
 
     plasticRotCapOfMaterialNum(301011) = 5.02491065081866E-02;
     plasticRotCapOfMaterialNum(301021) = 3.56319978906433E-02;
     plasticRotCapOfMaterialNum(301031) = 3.56319978906433E-02;
     plasticRotCapOfMaterialNum(301041) = 5.02491065081866E-02;
 
% Define the plastic rotation capacities of the beam materials - make all materials be positive (end in 1)
     plasticRotCapOfMaterialNum(213011) = 5.63591612870268E-02;
     plasticRotCapOfMaterialNum(213021) = 5.63591612870268E-02;
     plasticRotCapOfMaterialNum(213031) = 5.63591612870268E-02;
 
     plasticRotCapOfMaterialNum(212011) = 5.84204726315364E-02;
     plasticRotCapOfMaterialNum(212021) = 5.84204726315364E-02;
     plasticRotCapOfMaterialNum(212031) = 5.84204726315364E-02;
 
     plasticRotCapOfMaterialNum(211011) = 5.89646785375059E-02;
     plasticRotCapOfMaterialNum(211021) = 5.89646785375059E-02;
     plasticRotCapOfMaterialNum(211031) = 5.89646785375059E-02;
 
     plasticRotCapOfMaterialNum(210011) = 5.95802274524219E-02;
     plasticRotCapOfMaterialNum(210021) = 5.95802274524219E-02;
     plasticRotCapOfMaterialNum(210031) = 5.95802274524219E-02;
 
     plasticRotCapOfMaterialNum(209011) = 4.59206865291606E-02;
     plasticRotCapOfMaterialNum(209021) = 4.59206865291606E-02;
     plasticRotCapOfMaterialNum(209031) = 4.59206865291606E-02;
 
     plasticRotCapOfMaterialNum(208011) = 4.59206865291606E-02;
     plasticRotCapOfMaterialNum(208021) = 4.59206865291606E-02;
     plasticRotCapOfMaterialNum(208031) = 4.59206865291606E-02;
 
     plasticRotCapOfMaterialNum(207011) = 5.86653353646343E-02;
     plasticRotCapOfMaterialNum(207021) = 5.86653353646343E-02;
     plasticRotCapOfMaterialNum(207031) = 5.86653353646343E-02;
 
     plasticRotCapOfMaterialNum(206011) = 0.059090571303219;
     plasticRotCapOfMaterialNum(206021) = 0.059090571303219;
     plasticRotCapOfMaterialNum(206031) = 0.059090571303219;
 
     plasticRotCapOfMaterialNum(205011) = 6.18048240827954E-02;
     plasticRotCapOfMaterialNum(205021) = 6.18048240827954E-02;
     plasticRotCapOfMaterialNum(205031) = 6.18048240827954E-02;
 
     plasticRotCapOfMaterialNum(204011) = 6.18048240827954E-02;
     plasticRotCapOfMaterialNum(204021) = 6.18048240827954E-02;
     plasticRotCapOfMaterialNum(204031) = 6.18048240827954E-02;
 
     plasticRotCapOfMaterialNum(203011) = 6.15255157112181E-02;
     plasticRotCapOfMaterialNum(203021) = 6.15255157112181E-02;
     plasticRotCapOfMaterialNum(203031) = 6.15255157112181E-02;
 
     plasticRotCapOfMaterialNum(202011) = 6.14877925577259E-02;
     plasticRotCapOfMaterialNum(202021) = 6.14877925577259E-02;
     plasticRotCapOfMaterialNum(202031) = 6.14877925577259E-02;
 
% Define the plastic rotation capacities of shear panel material (40000) and the dummy material (49999) used in locations where no element connects to the joint
     plasticRotCapOfMaterialNum(40000) = 99;
     plasticRotCapOfMaterialNum(49999) = 999;
 
% Define the column base rotational spring PHR capacities
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(1, 1).node(1) = plasticRotCapOfMaterialNum(301011);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(1, 2).node(1) = plasticRotCapOfMaterialNum(301021);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(1, 3).node(1) = plasticRotCapOfMaterialNum(301031);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(1, 4).node(1) = plasticRotCapOfMaterialNum(301041);
 
% Define the PHR capacities at all 5 material locations of each joint (4 PHs and 1 shear panel).  When there is not an elements connected to a specific portion of a joint, I use the dummy material #49999.  Make all beam materials be positive (end in 1).
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(13, 1).node(1) = plasticRotCapOfMaterialNum(312011);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(13, 1).node(2) = plasticRotCapOfMaterialNum(213011);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(13, 1).node(3) = plasticRotCapOfMaterialNum(49999);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(13, 1).node(4) = plasticRotCapOfMaterialNum(49999);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(13, 1).node(5) = plasticRotCapOfMaterialNum(40000);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(13, 2).node(1) = plasticRotCapOfMaterialNum(312021);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(13, 2).node(2) = plasticRotCapOfMaterialNum(213021);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(13, 2).node(3) = plasticRotCapOfMaterialNum(49999);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(13, 2).node(4) = plasticRotCapOfMaterialNum(213011);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(13, 2).node(5) = plasticRotCapOfMaterialNum(40000);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(13, 3).node(1) = plasticRotCapOfMaterialNum(312031);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(13, 3).node(2) = plasticRotCapOfMaterialNum(213031);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(13, 3).node(3) = plasticRotCapOfMaterialNum(49999);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(13, 3).node(4) = plasticRotCapOfMaterialNum(213021);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(13, 3).node(5) = plasticRotCapOfMaterialNum(40000);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(13, 4).node(1) = plasticRotCapOfMaterialNum(312041);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(13, 4).node(2) = plasticRotCapOfMaterialNum(49999);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(13, 4).node(3) = plasticRotCapOfMaterialNum(49999);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(13, 4).node(4) = plasticRotCapOfMaterialNum(213031);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(13, 4).node(5) = plasticRotCapOfMaterialNum(40000);
 
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(12, 1).node(1) = plasticRotCapOfMaterialNum(311011);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(12, 1).node(2) = plasticRotCapOfMaterialNum(212011);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(12, 1).node(3) = plasticRotCapOfMaterialNum(312011);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(12, 1).node(4) = plasticRotCapOfMaterialNum(49999);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(12, 1).node(5) = plasticRotCapOfMaterialNum(40000);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(12, 2).node(1) = plasticRotCapOfMaterialNum(311021);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(12, 2).node(2) = plasticRotCapOfMaterialNum(212021);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(12, 2).node(3) = plasticRotCapOfMaterialNum(312021);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(12, 2).node(4) = plasticRotCapOfMaterialNum(212011);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(12, 2).node(5) = plasticRotCapOfMaterialNum(40000);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(12, 3).node(1) = plasticRotCapOfMaterialNum(311031);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(12, 3).node(2) = plasticRotCapOfMaterialNum(212031);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(12, 3).node(3) = plasticRotCapOfMaterialNum(312031);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(12, 3).node(4) = plasticRotCapOfMaterialNum(212021);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(12, 3).node(5) = plasticRotCapOfMaterialNum(40000);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(12, 4).node(1) = plasticRotCapOfMaterialNum(311041);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(12, 4).node(2) = plasticRotCapOfMaterialNum(49999);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(12, 4).node(3) = plasticRotCapOfMaterialNum(312041);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(12, 4).node(4) = plasticRotCapOfMaterialNum(212031);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(12, 4).node(5) = plasticRotCapOfMaterialNum(40000);
 
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(11, 1).node(1) = plasticRotCapOfMaterialNum(310011);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(11, 1).node(2) = plasticRotCapOfMaterialNum(211011);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(11, 1).node(3) = plasticRotCapOfMaterialNum(311011);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(11, 1).node(4) = plasticRotCapOfMaterialNum(49999);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(11, 1).node(5) = plasticRotCapOfMaterialNum(40000);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(11, 2).node(1) = plasticRotCapOfMaterialNum(310021);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(11, 2).node(2) = plasticRotCapOfMaterialNum(211021);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(11, 2).node(3) = plasticRotCapOfMaterialNum(311021);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(11, 2).node(4) = plasticRotCapOfMaterialNum(211011);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(11, 2).node(5) = plasticRotCapOfMaterialNum(40000);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(11, 3).node(1) = plasticRotCapOfMaterialNum(310031);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(11, 3).node(2) = plasticRotCapOfMaterialNum(211031);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(11, 3).node(3) = plasticRotCapOfMaterialNum(311031);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(11, 3).node(4) = plasticRotCapOfMaterialNum(211021);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(11, 3).node(5) = plasticRotCapOfMaterialNum(40000);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(11, 4).node(1) = plasticRotCapOfMaterialNum(310041);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(11, 4).node(2) = plasticRotCapOfMaterialNum(49999);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(11, 4).node(3) = plasticRotCapOfMaterialNum(311041);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(11, 4).node(4) = plasticRotCapOfMaterialNum(211031);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(11, 4).node(5) = plasticRotCapOfMaterialNum(40000);
 
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(10, 1).node(1) = plasticRotCapOfMaterialNum(309011);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(10, 1).node(2) = plasticRotCapOfMaterialNum(210011);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(10, 1).node(3) = plasticRotCapOfMaterialNum(310011);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(10, 1).node(4) = plasticRotCapOfMaterialNum(49999);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(10, 1).node(5) = plasticRotCapOfMaterialNum(40000);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(10, 2).node(1) = plasticRotCapOfMaterialNum(309021);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(10, 2).node(2) = plasticRotCapOfMaterialNum(210021);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(10, 2).node(3) = plasticRotCapOfMaterialNum(310021);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(10, 2).node(4) = plasticRotCapOfMaterialNum(210011);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(10, 2).node(5) = plasticRotCapOfMaterialNum(40000);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(10, 3).node(1) = plasticRotCapOfMaterialNum(309031);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(10, 3).node(2) = plasticRotCapOfMaterialNum(210031);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(10, 3).node(3) = plasticRotCapOfMaterialNum(310031);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(10, 3).node(4) = plasticRotCapOfMaterialNum(210021);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(10, 3).node(5) = plasticRotCapOfMaterialNum(40000);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(10, 4).node(1) = plasticRotCapOfMaterialNum(309041);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(10, 4).node(2) = plasticRotCapOfMaterialNum(49999);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(10, 4).node(3) = plasticRotCapOfMaterialNum(310041);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(10, 4).node(4) = plasticRotCapOfMaterialNum(210031);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(10, 4).node(5) = plasticRotCapOfMaterialNum(40000);
 
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(9, 1).node(1) = plasticRotCapOfMaterialNum(308011);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(9, 1).node(2) = plasticRotCapOfMaterialNum(209011);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(9, 1).node(3) = plasticRotCapOfMaterialNum(309011);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(9, 1).node(4) = plasticRotCapOfMaterialNum(49999);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(9, 1).node(5) = plasticRotCapOfMaterialNum(40000);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(9, 2).node(1) = plasticRotCapOfMaterialNum(308021);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(9, 2).node(2) = plasticRotCapOfMaterialNum(209021);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(9, 2).node(3) = plasticRotCapOfMaterialNum(309021);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(9, 2).node(4) = plasticRotCapOfMaterialNum(209011);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(9, 2).node(5) = plasticRotCapOfMaterialNum(40000);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(9, 3).node(1) = plasticRotCapOfMaterialNum(308031);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(9, 3).node(2) = plasticRotCapOfMaterialNum(209031);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(9, 3).node(3) = plasticRotCapOfMaterialNum(309031);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(9, 3).node(4) = plasticRotCapOfMaterialNum(209021);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(9, 3).node(5) = plasticRotCapOfMaterialNum(40000);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(9, 4).node(1) = plasticRotCapOfMaterialNum(308041);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(9, 4).node(2) = plasticRotCapOfMaterialNum(49999);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(9, 4).node(3) = plasticRotCapOfMaterialNum(309041);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(9, 4).node(4) = plasticRotCapOfMaterialNum(209031);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(9, 4).node(5) = plasticRotCapOfMaterialNum(40000);
 
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(8, 1).node(1) = plasticRotCapOfMaterialNum(307011);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(8, 1).node(2) = plasticRotCapOfMaterialNum(208011);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(8, 1).node(3) = plasticRotCapOfMaterialNum(308011);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(8, 1).node(4) = plasticRotCapOfMaterialNum(49999);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(8, 1).node(5) = plasticRotCapOfMaterialNum(40000);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(8, 2).node(1) = plasticRotCapOfMaterialNum(307021);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(8, 2).node(2) = plasticRotCapOfMaterialNum(208021);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(8, 2).node(3) = plasticRotCapOfMaterialNum(308021);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(8, 2).node(4) = plasticRotCapOfMaterialNum(208011);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(8, 2).node(5) = plasticRotCapOfMaterialNum(40000);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(8, 3).node(1) = plasticRotCapOfMaterialNum(307031);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(8, 3).node(2) = plasticRotCapOfMaterialNum(208031);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(8, 3).node(3) = plasticRotCapOfMaterialNum(308031);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(8, 3).node(4) = plasticRotCapOfMaterialNum(208021);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(8, 3).node(5) = plasticRotCapOfMaterialNum(40000);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(8, 4).node(1) = plasticRotCapOfMaterialNum(307041);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(8, 4).node(2) = plasticRotCapOfMaterialNum(49999);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(8, 4).node(3) = plasticRotCapOfMaterialNum(308041);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(8, 4).node(4) = plasticRotCapOfMaterialNum(208031);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(8, 4).node(5) = plasticRotCapOfMaterialNum(40000);
 
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(7, 1).node(1) = plasticRotCapOfMaterialNum(306011);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(7, 1).node(2) = plasticRotCapOfMaterialNum(207011);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(7, 1).node(3) = plasticRotCapOfMaterialNum(307011);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(7, 1).node(4) = plasticRotCapOfMaterialNum(49999);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(7, 1).node(5) = plasticRotCapOfMaterialNum(40000);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(7, 2).node(1) = plasticRotCapOfMaterialNum(306021);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(7, 2).node(2) = plasticRotCapOfMaterialNum(207021);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(7, 2).node(3) = plasticRotCapOfMaterialNum(307021);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(7, 2).node(4) = plasticRotCapOfMaterialNum(207011);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(7, 2).node(5) = plasticRotCapOfMaterialNum(40000);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(7, 3).node(1) = plasticRotCapOfMaterialNum(306031);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(7, 3).node(2) = plasticRotCapOfMaterialNum(207031);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(7, 3).node(3) = plasticRotCapOfMaterialNum(307031);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(7, 3).node(4) = plasticRotCapOfMaterialNum(207021);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(7, 3).node(5) = plasticRotCapOfMaterialNum(40000);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(7, 4).node(1) = plasticRotCapOfMaterialNum(306041);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(7, 4).node(2) = plasticRotCapOfMaterialNum(49999);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(7, 4).node(3) = plasticRotCapOfMaterialNum(307041);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(7, 4).node(4) = plasticRotCapOfMaterialNum(207031);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(7, 4).node(5) = plasticRotCapOfMaterialNum(40000);
 
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(6, 1).node(1) = plasticRotCapOfMaterialNum(305011);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(6, 1).node(2) = plasticRotCapOfMaterialNum(206011);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(6, 1).node(3) = plasticRotCapOfMaterialNum(306011);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(6, 1).node(4) = plasticRotCapOfMaterialNum(49999);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(6, 1).node(5) = plasticRotCapOfMaterialNum(40000);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(6, 2).node(1) = plasticRotCapOfMaterialNum(305021);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(6, 2).node(2) = plasticRotCapOfMaterialNum(206021);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(6, 2).node(3) = plasticRotCapOfMaterialNum(306021);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(6, 2).node(4) = plasticRotCapOfMaterialNum(206011);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(6, 2).node(5) = plasticRotCapOfMaterialNum(40000);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(6, 3).node(1) = plasticRotCapOfMaterialNum(305031);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(6, 3).node(2) = plasticRotCapOfMaterialNum(206031);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(6, 3).node(3) = plasticRotCapOfMaterialNum(306031);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(6, 3).node(4) = plasticRotCapOfMaterialNum(206021);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(6, 3).node(5) = plasticRotCapOfMaterialNum(40000);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(6, 4).node(1) = plasticRotCapOfMaterialNum(305041);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(6, 4).node(2) = plasticRotCapOfMaterialNum(49999);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(6, 4).node(3) = plasticRotCapOfMaterialNum(306041);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(6, 4).node(4) = plasticRotCapOfMaterialNum(206031);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(6, 4).node(5) = plasticRotCapOfMaterialNum(40000);
 
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(5, 1).node(1) = plasticRotCapOfMaterialNum(304011);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(5, 1).node(2) = plasticRotCapOfMaterialNum(205011);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(5, 1).node(3) = plasticRotCapOfMaterialNum(305011);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(5, 1).node(4) = plasticRotCapOfMaterialNum(49999);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(5, 1).node(5) = plasticRotCapOfMaterialNum(40000);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(5, 2).node(1) = plasticRotCapOfMaterialNum(304021);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(5, 2).node(2) = plasticRotCapOfMaterialNum(205021);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(5, 2).node(3) = plasticRotCapOfMaterialNum(305021);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(5, 2).node(4) = plasticRotCapOfMaterialNum(205011);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(5, 2).node(5) = plasticRotCapOfMaterialNum(40000);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(5, 3).node(1) = plasticRotCapOfMaterialNum(304031);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(5, 3).node(2) = plasticRotCapOfMaterialNum(205031);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(5, 3).node(3) = plasticRotCapOfMaterialNum(305031);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(5, 3).node(4) = plasticRotCapOfMaterialNum(205021);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(5, 3).node(5) = plasticRotCapOfMaterialNum(40000);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(5, 4).node(1) = plasticRotCapOfMaterialNum(304041);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(5, 4).node(2) = plasticRotCapOfMaterialNum(49999);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(5, 4).node(3) = plasticRotCapOfMaterialNum(305041);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(5, 4).node(4) = plasticRotCapOfMaterialNum(205031);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(5, 4).node(5) = plasticRotCapOfMaterialNum(40000);
 
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(4, 1).node(1) = plasticRotCapOfMaterialNum(303011);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(4, 1).node(2) = plasticRotCapOfMaterialNum(204011);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(4, 1).node(3) = plasticRotCapOfMaterialNum(304011);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(4, 1).node(4) = plasticRotCapOfMaterialNum(49999);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(4, 1).node(5) = plasticRotCapOfMaterialNum(40000);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(4, 2).node(1) = plasticRotCapOfMaterialNum(303021);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(4, 2).node(2) = plasticRotCapOfMaterialNum(204021);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(4, 2).node(3) = plasticRotCapOfMaterialNum(304021);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(4, 2).node(4) = plasticRotCapOfMaterialNum(204011);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(4, 2).node(5) = plasticRotCapOfMaterialNum(40000);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(4, 3).node(1) = plasticRotCapOfMaterialNum(303031);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(4, 3).node(2) = plasticRotCapOfMaterialNum(204031);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(4, 3).node(3) = plasticRotCapOfMaterialNum(304031);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(4, 3).node(4) = plasticRotCapOfMaterialNum(204021);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(4, 3).node(5) = plasticRotCapOfMaterialNum(40000);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(4, 4).node(1) = plasticRotCapOfMaterialNum(303041);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(4, 4).node(2) = plasticRotCapOfMaterialNum(49999);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(4, 4).node(3) = plasticRotCapOfMaterialNum(304041);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(4, 4).node(4) = plasticRotCapOfMaterialNum(204031);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(4, 4).node(5) = plasticRotCapOfMaterialNum(40000);
 
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(3, 1).node(1) = plasticRotCapOfMaterialNum(302011);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(3, 1).node(2) = plasticRotCapOfMaterialNum(203011);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(3, 1).node(3) = plasticRotCapOfMaterialNum(303011);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(3, 1).node(4) = plasticRotCapOfMaterialNum(49999);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(3, 1).node(5) = plasticRotCapOfMaterialNum(40000);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(3, 2).node(1) = plasticRotCapOfMaterialNum(302021);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(3, 2).node(2) = plasticRotCapOfMaterialNum(203021);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(3, 2).node(3) = plasticRotCapOfMaterialNum(303021);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(3, 2).node(4) = plasticRotCapOfMaterialNum(203011);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(3, 2).node(5) = plasticRotCapOfMaterialNum(40000);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(3, 3).node(1) = plasticRotCapOfMaterialNum(302031);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(3, 3).node(2) = plasticRotCapOfMaterialNum(203031);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(3, 3).node(3) = plasticRotCapOfMaterialNum(303031);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(3, 3).node(4) = plasticRotCapOfMaterialNum(203021);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(3, 3).node(5) = plasticRotCapOfMaterialNum(40000);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(3, 4).node(1) = plasticRotCapOfMaterialNum(302041);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(3, 4).node(2) = plasticRotCapOfMaterialNum(49999);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(3, 4).node(3) = plasticRotCapOfMaterialNum(303041);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(3, 4).node(4) = plasticRotCapOfMaterialNum(203031);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(3, 4).node(5) = plasticRotCapOfMaterialNum(40000);
 
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(2, 1).node(1) = plasticRotCapOfMaterialNum(301011);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(2, 1).node(2) = plasticRotCapOfMaterialNum(202011);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(2, 1).node(3) = plasticRotCapOfMaterialNum(302011);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(2, 1).node(4) = plasticRotCapOfMaterialNum(49999);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(2, 1).node(5) = plasticRotCapOfMaterialNum(40000);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(2, 2).node(1) = plasticRotCapOfMaterialNum(301021);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(2, 2).node(2) = plasticRotCapOfMaterialNum(202021);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(2, 2).node(3) = plasticRotCapOfMaterialNum(302021);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(2, 2).node(4) = plasticRotCapOfMaterialNum(202011);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(2, 2).node(5) = plasticRotCapOfMaterialNum(40000);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(2, 3).node(1) = plasticRotCapOfMaterialNum(301031);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(2, 3).node(2) = plasticRotCapOfMaterialNum(202031);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(2, 3).node(3) = plasticRotCapOfMaterialNum(302031);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(2, 3).node(4) = plasticRotCapOfMaterialNum(202021);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(2, 3).node(5) = plasticRotCapOfMaterialNum(40000);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(2, 4).node(1) = plasticRotCapOfMaterialNum(301041);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(2, 4).node(2) = plasticRotCapOfMaterialNum(49999);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(2, 4).node(3) = plasticRotCapOfMaterialNum(302041);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(2, 4).node(4) = plasticRotCapOfMaterialNum(202031);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(2, 4).node(5) = plasticRotCapOfMaterialNum(40000);
 
     % Define the joint numbers at each location in the frame
         for colLineNum = 1:4
             for floorNum = 2:13
                 buildingInfo{bldgID}.jointNumber(floorNum, colLineNum) = 40000 + (100.0 * floorNum) + colLineNum;
             end
         end
 
      % Define the hinge element numbers that are used at the base columns
         for colLineNum = 1:4
             buildingInfo{bldgID}.hingeElementNumAtColBase(colLineNum) = 6000 + colLineNum * 10 + 2; % The PH Spring at the column base
         end
 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%% Design ID 1014 - END %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Pasted from Excel 12story_ID1013_v.32 on 7-20-06 by Brian Dean
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%% Design ID 1013 - Start %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
 %%%% This code was pasted from the Excel Structural Design Sheet VB output (Dev. by C. Haselton, 6-13-06)
 
% Define General Geometry Information
      bldgID = 1013;
      buildingInfo{bldgID}.bayWidth = 240;
      buildingInfo{bldgID}.storyHeight_firstStory = 180;
      buildingInfo{bldgID}.storyHeight_upperStories = 156;
      buildingInfo{bldgID}.jointWidth = 26;
      buildingInfo{bldgID}.jointWidth = 26; % Just for plotting
      buildingInfo{bldgID}.jointHeight = 38; % Just for plotting
      buildingInfo{bldgID}.numBays = 3;
      buildingInfo{bldgID}.numStories = 12;
      buildingInfo{bldgID}.collapseDriftThreshold = 0.12;
 
% Define the plastic rotation capacities of the column materials
     plasticRotCapOfMaterialNum(312011) = 7.13801397405108E-02;
     plasticRotCapOfMaterialNum(312021) = 8.51866567001815E-02;
     plasticRotCapOfMaterialNum(312031) = 8.51866567001815E-02;
     plasticRotCapOfMaterialNum(312041) = 7.13801397405108E-02;
 
     plasticRotCapOfMaterialNum(311011) = 7.05728377464472E-02;
     plasticRotCapOfMaterialNum(311021) = 8.78685091745188E-02;
     plasticRotCapOfMaterialNum(311031) = 8.78685091745188E-02;
     plasticRotCapOfMaterialNum(311041) = 7.05728377464472E-02;
 
     plasticRotCapOfMaterialNum(310011) = 7.79710024110551E-02;
     plasticRotCapOfMaterialNum(310021) = 7.80320086140285E-02;
     plasticRotCapOfMaterialNum(310031) = 7.80320086140285E-02;
     plasticRotCapOfMaterialNum(310041) = 7.79710024110551E-02;
 
     plasticRotCapOfMaterialNum(309011) = 7.26121959454982E-02;
     plasticRotCapOfMaterialNum(309021) = 7.56193663648017E-02;
     plasticRotCapOfMaterialNum(309031) = 7.56193663648017E-02;
     plasticRotCapOfMaterialNum(309041) = 7.26121959454982E-02;
 
     plasticRotCapOfMaterialNum(308011) = 7.38806423868342E-02;
     plasticRotCapOfMaterialNum(308021) = 8.39864316883686E-02;
     plasticRotCapOfMaterialNum(308031) = 8.39864316883686E-02;
     plasticRotCapOfMaterialNum(308041) = 7.38806423868342E-02;
 
     plasticRotCapOfMaterialNum(307011) = 7.50173451197883E-02;
     plasticRotCapOfMaterialNum(307021) = 8.26178415340476E-02;
     plasticRotCapOfMaterialNum(307031) = 8.26178415340476E-02;
     plasticRotCapOfMaterialNum(307041) = 7.50173451197883E-02;
 
     plasticRotCapOfMaterialNum(306011) = 8.42713460526133E-02;
     plasticRotCapOfMaterialNum(306021) = 9.14620955446696E-02;
     plasticRotCapOfMaterialNum(306031) = 9.14620955446696E-02;
     plasticRotCapOfMaterialNum(306041) = 8.42713460526133E-02;
 
     plasticRotCapOfMaterialNum(305011) = 8.55821630429235E-02;
     plasticRotCapOfMaterialNum(305021) = 9.05277224254164E-02;
     plasticRotCapOfMaterialNum(305031) = 9.05277224254164E-02;
     plasticRotCapOfMaterialNum(305041) = 8.55821630429235E-02;
 
     plasticRotCapOfMaterialNum(304011) = 0.084975920100401;
     plasticRotCapOfMaterialNum(304021) = 8.94194462581259E-02;
     plasticRotCapOfMaterialNum(304031) = 8.94194462581259E-02;
     plasticRotCapOfMaterialNum(304041) = 0.084975920100401;
 
     plasticRotCapOfMaterialNum(303011) = 8.50684953289299E-02;
     plasticRotCapOfMaterialNum(303021) = 8.86875152258036E-02;
     plasticRotCapOfMaterialNum(303031) = 8.86875152258036E-02;
     plasticRotCapOfMaterialNum(303041) = 8.50684953289299E-02;
 
     plasticRotCapOfMaterialNum(302011) = 8.44658910818475E-02;
     plasticRotCapOfMaterialNum(302021) = 8.77814871083975E-02;
     plasticRotCapOfMaterialNum(302031) = 8.77814871083975E-02;
     plasticRotCapOfMaterialNum(302041) = 8.44658910818475E-02;
 
     plasticRotCapOfMaterialNum(301011) = 8.38675555346779E-02;
     plasticRotCapOfMaterialNum(301021) = 8.97809951417866E-02;
     plasticRotCapOfMaterialNum(301031) = 8.97809951417866E-02;
     plasticRotCapOfMaterialNum(301041) = 8.38675555346779E-02;
 
% Define the plastic rotation capacities of the beam materials - make all materials be positive (end in 1)
     plasticRotCapOfMaterialNum(213011) = 4.30087859358609E-02;
     plasticRotCapOfMaterialNum(213021) = 4.30087859358609E-02;
     plasticRotCapOfMaterialNum(213031) = 4.30087859358609E-02;
 
     plasticRotCapOfMaterialNum(212011) = 4.30087859358609E-02;
     plasticRotCapOfMaterialNum(212021) = 4.30087859358609E-02;
     plasticRotCapOfMaterialNum(212031) = 4.30087859358609E-02;
 
     plasticRotCapOfMaterialNum(211011) = 4.43582254000758E-02;
     plasticRotCapOfMaterialNum(211021) = 4.43582254000758E-02;
     plasticRotCapOfMaterialNum(211031) = 4.43582254000758E-02;
 
     plasticRotCapOfMaterialNum(210011) = 0.044882569226174;
     plasticRotCapOfMaterialNum(210021) = 0.044882569226174;
     plasticRotCapOfMaterialNum(210031) = 0.044882569226174;
 
     plasticRotCapOfMaterialNum(209011) = 5.15651703715579E-02;
     plasticRotCapOfMaterialNum(209021) = 5.18057698129434E-02;
     plasticRotCapOfMaterialNum(209031) = 5.15651703715579E-02;
 
     plasticRotCapOfMaterialNum(208011) = 5.69050122840658E-02;
     plasticRotCapOfMaterialNum(208021) = 5.73827364733932E-02;
     plasticRotCapOfMaterialNum(208031) = 5.69050122840658E-02;
 
     plasticRotCapOfMaterialNum(207011) = 5.84208313961921E-02;
     plasticRotCapOfMaterialNum(207021) = 5.86552615823286E-02;
     plasticRotCapOfMaterialNum(207031) = 5.84208313961921E-02;
 
     plasticRotCapOfMaterialNum(206011) = 0.055172794500447;
     plasticRotCapOfMaterialNum(206021) = 5.55985688614399E-02;
     plasticRotCapOfMaterialNum(206031) = 0.055172794500447;
 
     plasticRotCapOfMaterialNum(205011) = 0.055726784738928;
     plasticRotCapOfMaterialNum(205021) = 5.61492522174939E-02;
     plasticRotCapOfMaterialNum(205031) = 0.055726784738928;
 
     plasticRotCapOfMaterialNum(204011) = 0.055726784738928;
     plasticRotCapOfMaterialNum(204021) = 5.61492522174939E-02;
     plasticRotCapOfMaterialNum(204031) = 0.055726784738928;
 
     plasticRotCapOfMaterialNum(203011) = 5.57346064477201E-02;
     plasticRotCapOfMaterialNum(203021) = 5.61571332230425E-02;
     plasticRotCapOfMaterialNum(203031) = 5.57346064477201E-02;
 
     plasticRotCapOfMaterialNum(202011) = 5.24754183411031E-02;
     plasticRotCapOfMaterialNum(202021) = 5.50300400132957E-02;
     plasticRotCapOfMaterialNum(202031) = 5.24754183411031E-02;
 
% Define the plastic rotation capacities of shear panel material (40000) and the dummy material (49999) used in locations where no element connects to the joint
     plasticRotCapOfMaterialNum(40000) = 99;
     plasticRotCapOfMaterialNum(49999) = 999;
 
% Define the column base rotational spring PHR capacities
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(1, 1).node(1) = plasticRotCapOfMaterialNum(301011);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(1, 2).node(1) = plasticRotCapOfMaterialNum(301021);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(1, 3).node(1) = plasticRotCapOfMaterialNum(301031);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(1, 4).node(1) = plasticRotCapOfMaterialNum(301041);
 
% Define the PHR capacities at all 5 material locations of each joint (4 PHs and 1 shear panel).  When there is not an elements connected to a specific portion of a joint, I use the dummy material #49999.  Make all beam materials be positive (end in 1).
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(13, 1).node(1) = plasticRotCapOfMaterialNum(312011);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(13, 1).node(2) = plasticRotCapOfMaterialNum(213011);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(13, 1).node(3) = plasticRotCapOfMaterialNum(49999);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(13, 1).node(4) = plasticRotCapOfMaterialNum(49999);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(13, 1).node(5) = plasticRotCapOfMaterialNum(40000);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(13, 2).node(1) = plasticRotCapOfMaterialNum(312021);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(13, 2).node(2) = plasticRotCapOfMaterialNum(213021);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(13, 2).node(3) = plasticRotCapOfMaterialNum(49999);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(13, 2).node(4) = plasticRotCapOfMaterialNum(213011);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(13, 2).node(5) = plasticRotCapOfMaterialNum(40000);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(13, 3).node(1) = plasticRotCapOfMaterialNum(312031);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(13, 3).node(2) = plasticRotCapOfMaterialNum(213031);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(13, 3).node(3) = plasticRotCapOfMaterialNum(49999);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(13, 3).node(4) = plasticRotCapOfMaterialNum(213021);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(13, 3).node(5) = plasticRotCapOfMaterialNum(40000);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(13, 4).node(1) = plasticRotCapOfMaterialNum(312041);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(13, 4).node(2) = plasticRotCapOfMaterialNum(49999);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(13, 4).node(3) = plasticRotCapOfMaterialNum(49999);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(13, 4).node(4) = plasticRotCapOfMaterialNum(213031);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(13, 4).node(5) = plasticRotCapOfMaterialNum(40000);
 
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(12, 1).node(1) = plasticRotCapOfMaterialNum(311011);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(12, 1).node(2) = plasticRotCapOfMaterialNum(212011);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(12, 1).node(3) = plasticRotCapOfMaterialNum(312011);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(12, 1).node(4) = plasticRotCapOfMaterialNum(49999);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(12, 1).node(5) = plasticRotCapOfMaterialNum(40000);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(12, 2).node(1) = plasticRotCapOfMaterialNum(311021);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(12, 2).node(2) = plasticRotCapOfMaterialNum(212021);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(12, 2).node(3) = plasticRotCapOfMaterialNum(312021);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(12, 2).node(4) = plasticRotCapOfMaterialNum(212011);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(12, 2).node(5) = plasticRotCapOfMaterialNum(40000);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(12, 3).node(1) = plasticRotCapOfMaterialNum(311031);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(12, 3).node(2) = plasticRotCapOfMaterialNum(212031);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(12, 3).node(3) = plasticRotCapOfMaterialNum(312031);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(12, 3).node(4) = plasticRotCapOfMaterialNum(212021);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(12, 3).node(5) = plasticRotCapOfMaterialNum(40000);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(12, 4).node(1) = plasticRotCapOfMaterialNum(311041);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(12, 4).node(2) = plasticRotCapOfMaterialNum(49999);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(12, 4).node(3) = plasticRotCapOfMaterialNum(312041);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(12, 4).node(4) = plasticRotCapOfMaterialNum(212031);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(12, 4).node(5) = plasticRotCapOfMaterialNum(40000);
 
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(11, 1).node(1) = plasticRotCapOfMaterialNum(310011);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(11, 1).node(2) = plasticRotCapOfMaterialNum(211011);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(11, 1).node(3) = plasticRotCapOfMaterialNum(311011);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(11, 1).node(4) = plasticRotCapOfMaterialNum(49999);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(11, 1).node(5) = plasticRotCapOfMaterialNum(40000);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(11, 2).node(1) = plasticRotCapOfMaterialNum(310021);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(11, 2).node(2) = plasticRotCapOfMaterialNum(211021);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(11, 2).node(3) = plasticRotCapOfMaterialNum(311021);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(11, 2).node(4) = plasticRotCapOfMaterialNum(211011);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(11, 2).node(5) = plasticRotCapOfMaterialNum(40000);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(11, 3).node(1) = plasticRotCapOfMaterialNum(310031);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(11, 3).node(2) = plasticRotCapOfMaterialNum(211031);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(11, 3).node(3) = plasticRotCapOfMaterialNum(311031);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(11, 3).node(4) = plasticRotCapOfMaterialNum(211021);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(11, 3).node(5) = plasticRotCapOfMaterialNum(40000);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(11, 4).node(1) = plasticRotCapOfMaterialNum(310041);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(11, 4).node(2) = plasticRotCapOfMaterialNum(49999);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(11, 4).node(3) = plasticRotCapOfMaterialNum(311041);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(11, 4).node(4) = plasticRotCapOfMaterialNum(211031);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(11, 4).node(5) = plasticRotCapOfMaterialNum(40000);
 
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(10, 1).node(1) = plasticRotCapOfMaterialNum(309011);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(10, 1).node(2) = plasticRotCapOfMaterialNum(210011);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(10, 1).node(3) = plasticRotCapOfMaterialNum(310011);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(10, 1).node(4) = plasticRotCapOfMaterialNum(49999);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(10, 1).node(5) = plasticRotCapOfMaterialNum(40000);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(10, 2).node(1) = plasticRotCapOfMaterialNum(309021);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(10, 2).node(2) = plasticRotCapOfMaterialNum(210021);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(10, 2).node(3) = plasticRotCapOfMaterialNum(310021);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(10, 2).node(4) = plasticRotCapOfMaterialNum(210011);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(10, 2).node(5) = plasticRotCapOfMaterialNum(40000);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(10, 3).node(1) = plasticRotCapOfMaterialNum(309031);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(10, 3).node(2) = plasticRotCapOfMaterialNum(210031);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(10, 3).node(3) = plasticRotCapOfMaterialNum(310031);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(10, 3).node(4) = plasticRotCapOfMaterialNum(210021);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(10, 3).node(5) = plasticRotCapOfMaterialNum(40000);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(10, 4).node(1) = plasticRotCapOfMaterialNum(309041);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(10, 4).node(2) = plasticRotCapOfMaterialNum(49999);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(10, 4).node(3) = plasticRotCapOfMaterialNum(310041);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(10, 4).node(4) = plasticRotCapOfMaterialNum(210031);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(10, 4).node(5) = plasticRotCapOfMaterialNum(40000);
 
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(9, 1).node(1) = plasticRotCapOfMaterialNum(308011);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(9, 1).node(2) = plasticRotCapOfMaterialNum(209011);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(9, 1).node(3) = plasticRotCapOfMaterialNum(309011);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(9, 1).node(4) = plasticRotCapOfMaterialNum(49999);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(9, 1).node(5) = plasticRotCapOfMaterialNum(40000);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(9, 2).node(1) = plasticRotCapOfMaterialNum(308021);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(9, 2).node(2) = plasticRotCapOfMaterialNum(209021);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(9, 2).node(3) = plasticRotCapOfMaterialNum(309021);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(9, 2).node(4) = plasticRotCapOfMaterialNum(209011);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(9, 2).node(5) = plasticRotCapOfMaterialNum(40000);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(9, 3).node(1) = plasticRotCapOfMaterialNum(308031);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(9, 3).node(2) = plasticRotCapOfMaterialNum(209031);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(9, 3).node(3) = plasticRotCapOfMaterialNum(309031);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(9, 3).node(4) = plasticRotCapOfMaterialNum(209021);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(9, 3).node(5) = plasticRotCapOfMaterialNum(40000);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(9, 4).node(1) = plasticRotCapOfMaterialNum(308041);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(9, 4).node(2) = plasticRotCapOfMaterialNum(49999);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(9, 4).node(3) = plasticRotCapOfMaterialNum(309041);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(9, 4).node(4) = plasticRotCapOfMaterialNum(209031);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(9, 4).node(5) = plasticRotCapOfMaterialNum(40000);
 
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(8, 1).node(1) = plasticRotCapOfMaterialNum(307011);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(8, 1).node(2) = plasticRotCapOfMaterialNum(208011);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(8, 1).node(3) = plasticRotCapOfMaterialNum(308011);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(8, 1).node(4) = plasticRotCapOfMaterialNum(49999);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(8, 1).node(5) = plasticRotCapOfMaterialNum(40000);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(8, 2).node(1) = plasticRotCapOfMaterialNum(307021);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(8, 2).node(2) = plasticRotCapOfMaterialNum(208021);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(8, 2).node(3) = plasticRotCapOfMaterialNum(308021);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(8, 2).node(4) = plasticRotCapOfMaterialNum(208011);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(8, 2).node(5) = plasticRotCapOfMaterialNum(40000);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(8, 3).node(1) = plasticRotCapOfMaterialNum(307031);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(8, 3).node(2) = plasticRotCapOfMaterialNum(208031);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(8, 3).node(3) = plasticRotCapOfMaterialNum(308031);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(8, 3).node(4) = plasticRotCapOfMaterialNum(208021);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(8, 3).node(5) = plasticRotCapOfMaterialNum(40000);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(8, 4).node(1) = plasticRotCapOfMaterialNum(307041);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(8, 4).node(2) = plasticRotCapOfMaterialNum(49999);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(8, 4).node(3) = plasticRotCapOfMaterialNum(308041);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(8, 4).node(4) = plasticRotCapOfMaterialNum(208031);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(8, 4).node(5) = plasticRotCapOfMaterialNum(40000);
 
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(7, 1).node(1) = plasticRotCapOfMaterialNum(306011);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(7, 1).node(2) = plasticRotCapOfMaterialNum(207011);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(7, 1).node(3) = plasticRotCapOfMaterialNum(307011);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(7, 1).node(4) = plasticRotCapOfMaterialNum(49999);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(7, 1).node(5) = plasticRotCapOfMaterialNum(40000);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(7, 2).node(1) = plasticRotCapOfMaterialNum(306021);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(7, 2).node(2) = plasticRotCapOfMaterialNum(207021);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(7, 2).node(3) = plasticRotCapOfMaterialNum(307021);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(7, 2).node(4) = plasticRotCapOfMaterialNum(207011);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(7, 2).node(5) = plasticRotCapOfMaterialNum(40000);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(7, 3).node(1) = plasticRotCapOfMaterialNum(306031);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(7, 3).node(2) = plasticRotCapOfMaterialNum(207031);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(7, 3).node(3) = plasticRotCapOfMaterialNum(307031);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(7, 3).node(4) = plasticRotCapOfMaterialNum(207021);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(7, 3).node(5) = plasticRotCapOfMaterialNum(40000);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(7, 4).node(1) = plasticRotCapOfMaterialNum(306041);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(7, 4).node(2) = plasticRotCapOfMaterialNum(49999);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(7, 4).node(3) = plasticRotCapOfMaterialNum(307041);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(7, 4).node(4) = plasticRotCapOfMaterialNum(207031);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(7, 4).node(5) = plasticRotCapOfMaterialNum(40000);
 
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(6, 1).node(1) = plasticRotCapOfMaterialNum(305011);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(6, 1).node(2) = plasticRotCapOfMaterialNum(206011);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(6, 1).node(3) = plasticRotCapOfMaterialNum(306011);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(6, 1).node(4) = plasticRotCapOfMaterialNum(49999);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(6, 1).node(5) = plasticRotCapOfMaterialNum(40000);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(6, 2).node(1) = plasticRotCapOfMaterialNum(305021);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(6, 2).node(2) = plasticRotCapOfMaterialNum(206021);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(6, 2).node(3) = plasticRotCapOfMaterialNum(306021);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(6, 2).node(4) = plasticRotCapOfMaterialNum(206011);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(6, 2).node(5) = plasticRotCapOfMaterialNum(40000);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(6, 3).node(1) = plasticRotCapOfMaterialNum(305031);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(6, 3).node(2) = plasticRotCapOfMaterialNum(206031);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(6, 3).node(3) = plasticRotCapOfMaterialNum(306031);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(6, 3).node(4) = plasticRotCapOfMaterialNum(206021);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(6, 3).node(5) = plasticRotCapOfMaterialNum(40000);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(6, 4).node(1) = plasticRotCapOfMaterialNum(305041);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(6, 4).node(2) = plasticRotCapOfMaterialNum(49999);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(6, 4).node(3) = plasticRotCapOfMaterialNum(306041);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(6, 4).node(4) = plasticRotCapOfMaterialNum(206031);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(6, 4).node(5) = plasticRotCapOfMaterialNum(40000);
 
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(5, 1).node(1) = plasticRotCapOfMaterialNum(304011);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(5, 1).node(2) = plasticRotCapOfMaterialNum(205011);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(5, 1).node(3) = plasticRotCapOfMaterialNum(305011);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(5, 1).node(4) = plasticRotCapOfMaterialNum(49999);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(5, 1).node(5) = plasticRotCapOfMaterialNum(40000);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(5, 2).node(1) = plasticRotCapOfMaterialNum(304021);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(5, 2).node(2) = plasticRotCapOfMaterialNum(205021);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(5, 2).node(3) = plasticRotCapOfMaterialNum(305021);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(5, 2).node(4) = plasticRotCapOfMaterialNum(205011);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(5, 2).node(5) = plasticRotCapOfMaterialNum(40000);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(5, 3).node(1) = plasticRotCapOfMaterialNum(304031);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(5, 3).node(2) = plasticRotCapOfMaterialNum(205031);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(5, 3).node(3) = plasticRotCapOfMaterialNum(305031);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(5, 3).node(4) = plasticRotCapOfMaterialNum(205021);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(5, 3).node(5) = plasticRotCapOfMaterialNum(40000);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(5, 4).node(1) = plasticRotCapOfMaterialNum(304041);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(5, 4).node(2) = plasticRotCapOfMaterialNum(49999);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(5, 4).node(3) = plasticRotCapOfMaterialNum(305041);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(5, 4).node(4) = plasticRotCapOfMaterialNum(205031);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(5, 4).node(5) = plasticRotCapOfMaterialNum(40000);
 
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(4, 1).node(1) = plasticRotCapOfMaterialNum(303011);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(4, 1).node(2) = plasticRotCapOfMaterialNum(204011);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(4, 1).node(3) = plasticRotCapOfMaterialNum(304011);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(4, 1).node(4) = plasticRotCapOfMaterialNum(49999);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(4, 1).node(5) = plasticRotCapOfMaterialNum(40000);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(4, 2).node(1) = plasticRotCapOfMaterialNum(303021);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(4, 2).node(2) = plasticRotCapOfMaterialNum(204021);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(4, 2).node(3) = plasticRotCapOfMaterialNum(304021);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(4, 2).node(4) = plasticRotCapOfMaterialNum(204011);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(4, 2).node(5) = plasticRotCapOfMaterialNum(40000);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(4, 3).node(1) = plasticRotCapOfMaterialNum(303031);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(4, 3).node(2) = plasticRotCapOfMaterialNum(204031);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(4, 3).node(3) = plasticRotCapOfMaterialNum(304031);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(4, 3).node(4) = plasticRotCapOfMaterialNum(204021);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(4, 3).node(5) = plasticRotCapOfMaterialNum(40000);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(4, 4).node(1) = plasticRotCapOfMaterialNum(303041);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(4, 4).node(2) = plasticRotCapOfMaterialNum(49999);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(4, 4).node(3) = plasticRotCapOfMaterialNum(304041);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(4, 4).node(4) = plasticRotCapOfMaterialNum(204031);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(4, 4).node(5) = plasticRotCapOfMaterialNum(40000);
 
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(3, 1).node(1) = plasticRotCapOfMaterialNum(302011);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(3, 1).node(2) = plasticRotCapOfMaterialNum(203011);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(3, 1).node(3) = plasticRotCapOfMaterialNum(303011);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(3, 1).node(4) = plasticRotCapOfMaterialNum(49999);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(3, 1).node(5) = plasticRotCapOfMaterialNum(40000);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(3, 2).node(1) = plasticRotCapOfMaterialNum(302021);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(3, 2).node(2) = plasticRotCapOfMaterialNum(203021);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(3, 2).node(3) = plasticRotCapOfMaterialNum(303021);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(3, 2).node(4) = plasticRotCapOfMaterialNum(203011);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(3, 2).node(5) = plasticRotCapOfMaterialNum(40000);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(3, 3).node(1) = plasticRotCapOfMaterialNum(302031);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(3, 3).node(2) = plasticRotCapOfMaterialNum(203031);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(3, 3).node(3) = plasticRotCapOfMaterialNum(303031);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(3, 3).node(4) = plasticRotCapOfMaterialNum(203021);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(3, 3).node(5) = plasticRotCapOfMaterialNum(40000);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(3, 4).node(1) = plasticRotCapOfMaterialNum(302041);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(3, 4).node(2) = plasticRotCapOfMaterialNum(49999);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(3, 4).node(3) = plasticRotCapOfMaterialNum(303041);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(3, 4).node(4) = plasticRotCapOfMaterialNum(203031);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(3, 4).node(5) = plasticRotCapOfMaterialNum(40000);
 
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(2, 1).node(1) = plasticRotCapOfMaterialNum(301011);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(2, 1).node(2) = plasticRotCapOfMaterialNum(202011);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(2, 1).node(3) = plasticRotCapOfMaterialNum(302011);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(2, 1).node(4) = plasticRotCapOfMaterialNum(49999);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(2, 1).node(5) = plasticRotCapOfMaterialNum(40000);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(2, 2).node(1) = plasticRotCapOfMaterialNum(301021);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(2, 2).node(2) = plasticRotCapOfMaterialNum(202021);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(2, 2).node(3) = plasticRotCapOfMaterialNum(302021);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(2, 2).node(4) = plasticRotCapOfMaterialNum(202011);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(2, 2).node(5) = plasticRotCapOfMaterialNum(40000);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(2, 3).node(1) = plasticRotCapOfMaterialNum(301031);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(2, 3).node(2) = plasticRotCapOfMaterialNum(202031);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(2, 3).node(3) = plasticRotCapOfMaterialNum(302031);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(2, 3).node(4) = plasticRotCapOfMaterialNum(202021);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(2, 3).node(5) = plasticRotCapOfMaterialNum(40000);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(2, 4).node(1) = plasticRotCapOfMaterialNum(301041);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(2, 4).node(2) = plasticRotCapOfMaterialNum(49999);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(2, 4).node(3) = plasticRotCapOfMaterialNum(302041);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(2, 4).node(4) = plasticRotCapOfMaterialNum(202031);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(2, 4).node(5) = plasticRotCapOfMaterialNum(40000);
 
     % Define the joint numbers at each location in the frame
         for colLineNum = 1:4
             for floorNum = 2:13
                 buildingInfo{bldgID}.jointNumber(floorNum, colLineNum) = 40000 + (100.0 * floorNum) + colLineNum;
             end
         end
 
      % Define the hinge element numbers that are used at the base columns
         for colLineNum = 1:4
             buildingInfo{bldgID}.hingeElementNumAtColBase(colLineNum) = 6000 + colLineNum * 10 + 2; % The PH Spring at the column base
         end
 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%% Design ID 1013 - END %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Pasted from Excel 20story_ID1020_v.31 on 7-20-06 by Brian Dean
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%% Design ID 1020 - Start %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
 %%%% This code was pasted from the Excel Structural Design Sheet VB output (Dev. by C. Haselton, 6-13-06)
 
% Define General Geometry Information
      bldgID = 1020;
      buildingInfo{bldgID}.bayWidth = 240;
      buildingInfo{bldgID}.storyHeight_firstStory = 180;
      buildingInfo{bldgID}.storyHeight_upperStories = 156;
      buildingInfo{bldgID}.jointWidth = 36;
      buildingInfo{bldgID}.jointWidth = 36; % Just for plotting
      buildingInfo{bldgID}.jointHeight = 44; % Just for plotting
      buildingInfo{bldgID}.numBays = 3;
      buildingInfo{bldgID}.numStories = 20;
      buildingInfo{bldgID}.collapseDriftThreshold = 0.12;
 
% Define the plastic rotation capacities of the column materials
     plasticRotCapOfMaterialNum(320011) = 7.54996698019792E-02;
     plasticRotCapOfMaterialNum(320021) = 7.76963145840367E-02;
     plasticRotCapOfMaterialNum(320031) = 7.76963145840367E-02;
     plasticRotCapOfMaterialNum(320041) = 7.54996698019792E-02;
 
     plasticRotCapOfMaterialNum(319011) = 7.50359387471023E-02;
     plasticRotCapOfMaterialNum(319021) = 8.76624602081481E-02;
     plasticRotCapOfMaterialNum(319031) = 8.76624602081481E-02;
     plasticRotCapOfMaterialNum(319041) = 7.50359387471023E-02;
 
     plasticRotCapOfMaterialNum(318011) = 7.45750560025798E-02;
     plasticRotCapOfMaterialNum(318021) = 7.58049369723312E-02;
     plasticRotCapOfMaterialNum(318031) = 7.58049369723312E-02;
     plasticRotCapOfMaterialNum(318041) = 7.45750560025798E-02;
 
     plasticRotCapOfMaterialNum(317011) = 7.41170040736337E-02;
     plasticRotCapOfMaterialNum(317021) = 8.06191997273827E-02;
     plasticRotCapOfMaterialNum(317031) = 8.06191997273827E-02;
     plasticRotCapOfMaterialNum(317041) = 7.41170040736337E-02;
 
     plasticRotCapOfMaterialNum(316011) = 7.42681118270486E-02;
     plasticRotCapOfMaterialNum(316021) = 7.59565801951186E-02;
     plasticRotCapOfMaterialNum(316031) = 7.59565801951186E-02;
     plasticRotCapOfMaterialNum(316041) = 7.42681118270486E-02;
 
     plasticRotCapOfMaterialNum(315011) = 0.073811945198352;
     plasticRotCapOfMaterialNum(315021) = 0.075026370799663;
     plasticRotCapOfMaterialNum(315031) = 0.075026370799663;
     plasticRotCapOfMaterialNum(315041) = 0.073811945198352;
 
     plasticRotCapOfMaterialNum(314011) = 7.44185786656387E-02;
     plasticRotCapOfMaterialNum(314021) = 7.59527059109734E-02;
     plasticRotCapOfMaterialNum(314031) = 7.59527059109734E-02;
     plasticRotCapOfMaterialNum(314041) = 7.44185786656387E-02;
 
     plasticRotCapOfMaterialNum(313011) = 7.39614878455388E-02;
     plasticRotCapOfMaterialNum(313021) = 7.50225439623026E-02;
     plasticRotCapOfMaterialNum(313031) = 7.50225439623026E-02;
     plasticRotCapOfMaterialNum(313041) = 7.39614878455388E-02;
 
     plasticRotCapOfMaterialNum(312011) = 7.50292410557852E-02;
     plasticRotCapOfMaterialNum(312021) = 7.64565974491391E-02;
     plasticRotCapOfMaterialNum(312031) = 7.64565974491391E-02;
     plasticRotCapOfMaterialNum(312041) = 7.50292410557852E-02;
 
     plasticRotCapOfMaterialNum(311011) = 7.45683994495547E-02;
     plasticRotCapOfMaterialNum(311021) = 7.56896498399584E-02;
     plasticRotCapOfMaterialNum(311031) = 7.56896498399584E-02;
     plasticRotCapOfMaterialNum(311041) = 7.45683994495547E-02;
 
     plasticRotCapOfMaterialNum(310011) = 7.51812499385446E-02;
     plasticRotCapOfMaterialNum(310021) = 7.50841191356101E-02;
     plasticRotCapOfMaterialNum(310031) = 7.50841191356101E-02;
     plasticRotCapOfMaterialNum(310041) = 7.51812499385446E-02;
 
     plasticRotCapOfMaterialNum(309011) = 7.47194746694286E-02;
     plasticRotCapOfMaterialNum(309021) = 7.43309390624739E-02;
     plasticRotCapOfMaterialNum(309031) = 7.43309390624739E-02;
     plasticRotCapOfMaterialNum(309041) = 7.47194746694286E-02;
 
     plasticRotCapOfMaterialNum(308011) = 7.54881174550965E-02;
     plasticRotCapOfMaterialNum(308021) = 7.34346592930522E-02;
     plasticRotCapOfMaterialNum(308031) = 7.34346592930522E-02;
     plasticRotCapOfMaterialNum(308041) = 7.54881174550965E-02;
 
     plasticRotCapOfMaterialNum(307011) = 7.50244573565829E-02;
     plasticRotCapOfMaterialNum(307021) = 7.28471689154468E-02;
     plasticRotCapOfMaterialNum(307031) = 7.28471689154468E-02;
     plasticRotCapOfMaterialNum(307041) = 7.50244573565829E-02;
 
     plasticRotCapOfMaterialNum(306011) = 7.57962375136425E-02;
     plasticRotCapOfMaterialNum(306021) = 7.22643785656907E-02;
     plasticRotCapOfMaterialNum(306031) = 7.22643785656907E-02;
     plasticRotCapOfMaterialNum(306041) = 7.57962375136425E-02;
 
     plasticRotCapOfMaterialNum(305011) = 7.53306848924178E-02;
     plasticRotCapOfMaterialNum(305021) = 7.15394837336031E-02;
     plasticRotCapOfMaterialNum(305031) = 7.15394837336031E-02;
     plasticRotCapOfMaterialNum(305041) = 7.53306848924178E-02;
 
     plasticRotCapOfMaterialNum(304011) = 7.51754979060744E-02;
     plasticRotCapOfMaterialNum(304021) = 7.08218604304211E-02;
     plasticRotCapOfMaterialNum(304031) = 7.08218604304211E-02;
     plasticRotCapOfMaterialNum(304041) = 7.51754979060744E-02;
 
     plasticRotCapOfMaterialNum(303011) = 7.50206306168207E-02;
     plasticRotCapOfMaterialNum(303021) = 7.01114357143465E-02;
     plasticRotCapOfMaterialNum(303031) = 7.01114357143465E-02;
     plasticRotCapOfMaterialNum(303041) = 7.50206306168207E-02;
 
     plasticRotCapOfMaterialNum(302011) = 7.45598418972843E-02;
     plasticRotCapOfMaterialNum(302021) = 6.95505317183478E-02;
     plasticRotCapOfMaterialNum(302031) = 6.95505317183478E-02;
     plasticRotCapOfMaterialNum(302041) = 7.45598418972843E-02;
 
     plasticRotCapOfMaterialNum(301011) = 8.20769089711473E-02;
     plasticRotCapOfMaterialNum(301021) = 7.07119517093384E-02;
     plasticRotCapOfMaterialNum(301031) = 7.07119517093384E-02;
     plasticRotCapOfMaterialNum(301041) = 8.20769089711473E-02;
 
% Define the plastic rotation capacities of the beam materials - make all materials be positive (end in 1)
     plasticRotCapOfMaterialNum(221011) = 4.21272869395471E-02;
     plasticRotCapOfMaterialNum(221021) = 4.21272869395471E-02;
     plasticRotCapOfMaterialNum(221031) = 4.21272869395471E-02;
 
     plasticRotCapOfMaterialNum(220011) = 4.21272869395471E-02;
     plasticRotCapOfMaterialNum(220021) = 4.21272869395471E-02;
     plasticRotCapOfMaterialNum(220031) = 4.21272869395471E-02;
 
     plasticRotCapOfMaterialNum(219011) = 4.21272869395471E-02;
     plasticRotCapOfMaterialNum(219021) = 4.21272869395471E-02;
     plasticRotCapOfMaterialNum(219031) = 4.21272869395471E-02;
 
     plasticRotCapOfMaterialNum(218011) = 4.21272869395471E-02;
     plasticRotCapOfMaterialNum(218021) = 4.21272869395471E-02;
     plasticRotCapOfMaterialNum(218031) = 4.21272869395471E-02;
 
     plasticRotCapOfMaterialNum(217011) = 4.57444924334181E-02;
     plasticRotCapOfMaterialNum(217021) = 4.57444924334181E-02;
     plasticRotCapOfMaterialNum(217031) = 4.57444924334181E-02;
 
     plasticRotCapOfMaterialNum(216011) = 4.98723539495666E-02;
     plasticRotCapOfMaterialNum(216021) = 4.98723539495666E-02;
     plasticRotCapOfMaterialNum(216031) = 4.98723539495666E-02;
 
     plasticRotCapOfMaterialNum(215011) = 4.78254814752465E-02;
     plasticRotCapOfMaterialNum(215021) = 4.78254814752465E-02;
     plasticRotCapOfMaterialNum(215031) = 4.78254814752465E-02;
 
     plasticRotCapOfMaterialNum(214011) = 5.12979275784525E-02;
     plasticRotCapOfMaterialNum(214021) = 5.12979275784525E-02;
     plasticRotCapOfMaterialNum(214031) = 5.12979275784525E-02;
 
     plasticRotCapOfMaterialNum(213011) = 5.53914606336921E-02;
     plasticRotCapOfMaterialNum(213021) = 5.56307083544481E-02;
     plasticRotCapOfMaterialNum(213031) = 5.53914606336921E-02;
 
     plasticRotCapOfMaterialNum(212011) = 5.31130067560957E-02;
     plasticRotCapOfMaterialNum(212021) = 5.35405426948821E-02;
     plasticRotCapOfMaterialNum(212031) = 5.31130067560957E-02;
 
     plasticRotCapOfMaterialNum(211011) = 5.41832855076877E-02;
     plasticRotCapOfMaterialNum(211021) = 5.43940292987171E-02;
     plasticRotCapOfMaterialNum(211031) = 5.41832855076877E-02;
 
     plasticRotCapOfMaterialNum(210011) = 5.41832855076877E-02;
     plasticRotCapOfMaterialNum(210021) = 5.43940292987171E-02;
     plasticRotCapOfMaterialNum(210031) = 5.41832855076877E-02;
 
     plasticRotCapOfMaterialNum(209011) = 5.72649264273825E-02;
     plasticRotCapOfMaterialNum(209021) = 5.76975382724358E-02;
     plasticRotCapOfMaterialNum(209031) = 5.72649264273825E-02;
 
     plasticRotCapOfMaterialNum(208011) = 5.72649264273825E-02;
     plasticRotCapOfMaterialNum(208021) = 5.76975382724358E-02;
     plasticRotCapOfMaterialNum(208031) = 5.72649264273825E-02;
 
     plasticRotCapOfMaterialNum(207011) = 5.72649264273825E-02;
     plasticRotCapOfMaterialNum(207021) = 5.76975382724358E-02;
     plasticRotCapOfMaterialNum(207031) = 5.72649264273825E-02;
 
     plasticRotCapOfMaterialNum(206011) = 5.72649264273825E-02;
     plasticRotCapOfMaterialNum(206021) = 5.76975382724358E-02;
     plasticRotCapOfMaterialNum(206031) = 5.72649264273825E-02;
 
     plasticRotCapOfMaterialNum(205011) = 0.05749234452375;
     plasticRotCapOfMaterialNum(205021) = 5.77081506412524E-02;
     plasticRotCapOfMaterialNum(205031) = 0.05749234452375;
 
     plasticRotCapOfMaterialNum(204011) = 5.69573713317441E-02;
     plasticRotCapOfMaterialNum(204021) = 5.71749683579411E-02;
     plasticRotCapOfMaterialNum(204031) = 5.69573713317441E-02;
 
     plasticRotCapOfMaterialNum(203011) = 5.41832855076877E-02;
     plasticRotCapOfMaterialNum(203021) = 5.43940292987171E-02;
     plasticRotCapOfMaterialNum(203031) = 5.41832855076877E-02;
 
     plasticRotCapOfMaterialNum(202011) = 5.31130067560957E-02;
     plasticRotCapOfMaterialNum(202021) = 5.35405426948821E-02;
     plasticRotCapOfMaterialNum(202031) = 5.31130067560957E-02;
 
% Define the plastic rotation capacities of shear panel material (40000) and the dummy material (49999) used in locations where no element connects to the joint
     plasticRotCapOfMaterialNum(40000) = 99;
     plasticRotCapOfMaterialNum(49999) = 999;
 
% Define the column base rotational spring PHR capacities
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(1, 1).node(1) = plasticRotCapOfMaterialNum(301011);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(1, 2).node(1) = plasticRotCapOfMaterialNum(301021);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(1, 3).node(1) = plasticRotCapOfMaterialNum(301031);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(1, 4).node(1) = plasticRotCapOfMaterialNum(301041);
 
% Define the PHR capacities at all 5 material locations of each joint (4 PHs and 1 shear panel).  When there is not an elements connected to a specific portion of a joint, I use the dummy material #49999.  Make all beam materials be positive (end in 1).
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(21, 1).node(1) = plasticRotCapOfMaterialNum(320011);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(21, 1).node(2) = plasticRotCapOfMaterialNum(221011);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(21, 1).node(3) = plasticRotCapOfMaterialNum(49999);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(21, 1).node(4) = plasticRotCapOfMaterialNum(49999);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(21, 1).node(5) = plasticRotCapOfMaterialNum(40000);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(21, 2).node(1) = plasticRotCapOfMaterialNum(320021);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(21, 2).node(2) = plasticRotCapOfMaterialNum(221021);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(21, 2).node(3) = plasticRotCapOfMaterialNum(49999);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(21, 2).node(4) = plasticRotCapOfMaterialNum(221011);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(21, 2).node(5) = plasticRotCapOfMaterialNum(40000);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(21, 3).node(1) = plasticRotCapOfMaterialNum(320031);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(21, 3).node(2) = plasticRotCapOfMaterialNum(221031);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(21, 3).node(3) = plasticRotCapOfMaterialNum(49999);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(21, 3).node(4) = plasticRotCapOfMaterialNum(221021);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(21, 3).node(5) = plasticRotCapOfMaterialNum(40000);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(21, 4).node(1) = plasticRotCapOfMaterialNum(320041);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(21, 4).node(2) = plasticRotCapOfMaterialNum(49999);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(21, 4).node(3) = plasticRotCapOfMaterialNum(49999);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(21, 4).node(4) = plasticRotCapOfMaterialNum(221031);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(21, 4).node(5) = plasticRotCapOfMaterialNum(40000);
 
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(20, 1).node(1) = plasticRotCapOfMaterialNum(319011);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(20, 1).node(2) = plasticRotCapOfMaterialNum(220011);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(20, 1).node(3) = plasticRotCapOfMaterialNum(320011);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(20, 1).node(4) = plasticRotCapOfMaterialNum(49999);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(20, 1).node(5) = plasticRotCapOfMaterialNum(40000);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(20, 2).node(1) = plasticRotCapOfMaterialNum(319021);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(20, 2).node(2) = plasticRotCapOfMaterialNum(220021);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(20, 2).node(3) = plasticRotCapOfMaterialNum(320021);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(20, 2).node(4) = plasticRotCapOfMaterialNum(220011);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(20, 2).node(5) = plasticRotCapOfMaterialNum(40000);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(20, 3).node(1) = plasticRotCapOfMaterialNum(319031);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(20, 3).node(2) = plasticRotCapOfMaterialNum(220031);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(20, 3).node(3) = plasticRotCapOfMaterialNum(320031);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(20, 3).node(4) = plasticRotCapOfMaterialNum(220021);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(20, 3).node(5) = plasticRotCapOfMaterialNum(40000);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(20, 4).node(1) = plasticRotCapOfMaterialNum(319041);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(20, 4).node(2) = plasticRotCapOfMaterialNum(49999);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(20, 4).node(3) = plasticRotCapOfMaterialNum(320041);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(20, 4).node(4) = plasticRotCapOfMaterialNum(220031);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(20, 4).node(5) = plasticRotCapOfMaterialNum(40000);
 
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(19, 1).node(1) = plasticRotCapOfMaterialNum(318011);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(19, 1).node(2) = plasticRotCapOfMaterialNum(219011);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(19, 1).node(3) = plasticRotCapOfMaterialNum(319011);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(19, 1).node(4) = plasticRotCapOfMaterialNum(49999);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(19, 1).node(5) = plasticRotCapOfMaterialNum(40000);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(19, 2).node(1) = plasticRotCapOfMaterialNum(318021);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(19, 2).node(2) = plasticRotCapOfMaterialNum(219021);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(19, 2).node(3) = plasticRotCapOfMaterialNum(319021);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(19, 2).node(4) = plasticRotCapOfMaterialNum(219011);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(19, 2).node(5) = plasticRotCapOfMaterialNum(40000);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(19, 3).node(1) = plasticRotCapOfMaterialNum(318031);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(19, 3).node(2) = plasticRotCapOfMaterialNum(219031);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(19, 3).node(3) = plasticRotCapOfMaterialNum(319031);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(19, 3).node(4) = plasticRotCapOfMaterialNum(219021);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(19, 3).node(5) = plasticRotCapOfMaterialNum(40000);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(19, 4).node(1) = plasticRotCapOfMaterialNum(318041);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(19, 4).node(2) = plasticRotCapOfMaterialNum(49999);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(19, 4).node(3) = plasticRotCapOfMaterialNum(319041);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(19, 4).node(4) = plasticRotCapOfMaterialNum(219031);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(19, 4).node(5) = plasticRotCapOfMaterialNum(40000);
 
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(18, 1).node(1) = plasticRotCapOfMaterialNum(317011);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(18, 1).node(2) = plasticRotCapOfMaterialNum(218011);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(18, 1).node(3) = plasticRotCapOfMaterialNum(318011);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(18, 1).node(4) = plasticRotCapOfMaterialNum(49999);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(18, 1).node(5) = plasticRotCapOfMaterialNum(40000);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(18, 2).node(1) = plasticRotCapOfMaterialNum(317021);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(18, 2).node(2) = plasticRotCapOfMaterialNum(218021);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(18, 2).node(3) = plasticRotCapOfMaterialNum(318021);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(18, 2).node(4) = plasticRotCapOfMaterialNum(218011);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(18, 2).node(5) = plasticRotCapOfMaterialNum(40000);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(18, 3).node(1) = plasticRotCapOfMaterialNum(317031);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(18, 3).node(2) = plasticRotCapOfMaterialNum(218031);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(18, 3).node(3) = plasticRotCapOfMaterialNum(318031);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(18, 3).node(4) = plasticRotCapOfMaterialNum(218021);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(18, 3).node(5) = plasticRotCapOfMaterialNum(40000);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(18, 4).node(1) = plasticRotCapOfMaterialNum(317041);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(18, 4).node(2) = plasticRotCapOfMaterialNum(49999);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(18, 4).node(3) = plasticRotCapOfMaterialNum(318041);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(18, 4).node(4) = plasticRotCapOfMaterialNum(218031);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(18, 4).node(5) = plasticRotCapOfMaterialNum(40000);
 
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(17, 1).node(1) = plasticRotCapOfMaterialNum(316011);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(17, 1).node(2) = plasticRotCapOfMaterialNum(217011);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(17, 1).node(3) = plasticRotCapOfMaterialNum(317011);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(17, 1).node(4) = plasticRotCapOfMaterialNum(49999);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(17, 1).node(5) = plasticRotCapOfMaterialNum(40000);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(17, 2).node(1) = plasticRotCapOfMaterialNum(316021);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(17, 2).node(2) = plasticRotCapOfMaterialNum(217021);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(17, 2).node(3) = plasticRotCapOfMaterialNum(317021);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(17, 2).node(4) = plasticRotCapOfMaterialNum(217011);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(17, 2).node(5) = plasticRotCapOfMaterialNum(40000);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(17, 3).node(1) = plasticRotCapOfMaterialNum(316031);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(17, 3).node(2) = plasticRotCapOfMaterialNum(217031);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(17, 3).node(3) = plasticRotCapOfMaterialNum(317031);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(17, 3).node(4) = plasticRotCapOfMaterialNum(217021);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(17, 3).node(5) = plasticRotCapOfMaterialNum(40000);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(17, 4).node(1) = plasticRotCapOfMaterialNum(316041);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(17, 4).node(2) = plasticRotCapOfMaterialNum(49999);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(17, 4).node(3) = plasticRotCapOfMaterialNum(317041);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(17, 4).node(4) = plasticRotCapOfMaterialNum(217031);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(17, 4).node(5) = plasticRotCapOfMaterialNum(40000);
 
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(16, 1).node(1) = plasticRotCapOfMaterialNum(315011);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(16, 1).node(2) = plasticRotCapOfMaterialNum(216011);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(16, 1).node(3) = plasticRotCapOfMaterialNum(316011);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(16, 1).node(4) = plasticRotCapOfMaterialNum(49999);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(16, 1).node(5) = plasticRotCapOfMaterialNum(40000);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(16, 2).node(1) = plasticRotCapOfMaterialNum(315021);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(16, 2).node(2) = plasticRotCapOfMaterialNum(216021);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(16, 2).node(3) = plasticRotCapOfMaterialNum(316021);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(16, 2).node(4) = plasticRotCapOfMaterialNum(216011);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(16, 2).node(5) = plasticRotCapOfMaterialNum(40000);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(16, 3).node(1) = plasticRotCapOfMaterialNum(315031);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(16, 3).node(2) = plasticRotCapOfMaterialNum(216031);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(16, 3).node(3) = plasticRotCapOfMaterialNum(316031);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(16, 3).node(4) = plasticRotCapOfMaterialNum(216021);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(16, 3).node(5) = plasticRotCapOfMaterialNum(40000);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(16, 4).node(1) = plasticRotCapOfMaterialNum(315041);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(16, 4).node(2) = plasticRotCapOfMaterialNum(49999);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(16, 4).node(3) = plasticRotCapOfMaterialNum(316041);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(16, 4).node(4) = plasticRotCapOfMaterialNum(216031);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(16, 4).node(5) = plasticRotCapOfMaterialNum(40000);
 
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(15, 1).node(1) = plasticRotCapOfMaterialNum(314011);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(15, 1).node(2) = plasticRotCapOfMaterialNum(215011);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(15, 1).node(3) = plasticRotCapOfMaterialNum(315011);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(15, 1).node(4) = plasticRotCapOfMaterialNum(49999);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(15, 1).node(5) = plasticRotCapOfMaterialNum(40000);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(15, 2).node(1) = plasticRotCapOfMaterialNum(314021);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(15, 2).node(2) = plasticRotCapOfMaterialNum(215021);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(15, 2).node(3) = plasticRotCapOfMaterialNum(315021);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(15, 2).node(4) = plasticRotCapOfMaterialNum(215011);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(15, 2).node(5) = plasticRotCapOfMaterialNum(40000);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(15, 3).node(1) = plasticRotCapOfMaterialNum(314031);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(15, 3).node(2) = plasticRotCapOfMaterialNum(215031);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(15, 3).node(3) = plasticRotCapOfMaterialNum(315031);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(15, 3).node(4) = plasticRotCapOfMaterialNum(215021);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(15, 3).node(5) = plasticRotCapOfMaterialNum(40000);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(15, 4).node(1) = plasticRotCapOfMaterialNum(314041);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(15, 4).node(2) = plasticRotCapOfMaterialNum(49999);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(15, 4).node(3) = plasticRotCapOfMaterialNum(315041);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(15, 4).node(4) = plasticRotCapOfMaterialNum(215031);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(15, 4).node(5) = plasticRotCapOfMaterialNum(40000);
 
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(14, 1).node(1) = plasticRotCapOfMaterialNum(313011);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(14, 1).node(2) = plasticRotCapOfMaterialNum(214011);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(14, 1).node(3) = plasticRotCapOfMaterialNum(314011);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(14, 1).node(4) = plasticRotCapOfMaterialNum(49999);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(14, 1).node(5) = plasticRotCapOfMaterialNum(40000);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(14, 2).node(1) = plasticRotCapOfMaterialNum(313021);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(14, 2).node(2) = plasticRotCapOfMaterialNum(214021);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(14, 2).node(3) = plasticRotCapOfMaterialNum(314021);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(14, 2).node(4) = plasticRotCapOfMaterialNum(214011);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(14, 2).node(5) = plasticRotCapOfMaterialNum(40000);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(14, 3).node(1) = plasticRotCapOfMaterialNum(313031);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(14, 3).node(2) = plasticRotCapOfMaterialNum(214031);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(14, 3).node(3) = plasticRotCapOfMaterialNum(314031);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(14, 3).node(4) = plasticRotCapOfMaterialNum(214021);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(14, 3).node(5) = plasticRotCapOfMaterialNum(40000);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(14, 4).node(1) = plasticRotCapOfMaterialNum(313041);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(14, 4).node(2) = plasticRotCapOfMaterialNum(49999);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(14, 4).node(3) = plasticRotCapOfMaterialNum(314041);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(14, 4).node(4) = plasticRotCapOfMaterialNum(214031);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(14, 4).node(5) = plasticRotCapOfMaterialNum(40000);
 
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(13, 1).node(1) = plasticRotCapOfMaterialNum(312011);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(13, 1).node(2) = plasticRotCapOfMaterialNum(213011);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(13, 1).node(3) = plasticRotCapOfMaterialNum(313011);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(13, 1).node(4) = plasticRotCapOfMaterialNum(49999);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(13, 1).node(5) = plasticRotCapOfMaterialNum(40000);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(13, 2).node(1) = plasticRotCapOfMaterialNum(312021);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(13, 2).node(2) = plasticRotCapOfMaterialNum(213021);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(13, 2).node(3) = plasticRotCapOfMaterialNum(313021);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(13, 2).node(4) = plasticRotCapOfMaterialNum(213011);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(13, 2).node(5) = plasticRotCapOfMaterialNum(40000);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(13, 3).node(1) = plasticRotCapOfMaterialNum(312031);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(13, 3).node(2) = plasticRotCapOfMaterialNum(213031);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(13, 3).node(3) = plasticRotCapOfMaterialNum(313031);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(13, 3).node(4) = plasticRotCapOfMaterialNum(213021);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(13, 3).node(5) = plasticRotCapOfMaterialNum(40000);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(13, 4).node(1) = plasticRotCapOfMaterialNum(312041);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(13, 4).node(2) = plasticRotCapOfMaterialNum(49999);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(13, 4).node(3) = plasticRotCapOfMaterialNum(313041);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(13, 4).node(4) = plasticRotCapOfMaterialNum(213031);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(13, 4).node(5) = plasticRotCapOfMaterialNum(40000);
 
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(12, 1).node(1) = plasticRotCapOfMaterialNum(311011);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(12, 1).node(2) = plasticRotCapOfMaterialNum(212011);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(12, 1).node(3) = plasticRotCapOfMaterialNum(312011);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(12, 1).node(4) = plasticRotCapOfMaterialNum(49999);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(12, 1).node(5) = plasticRotCapOfMaterialNum(40000);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(12, 2).node(1) = plasticRotCapOfMaterialNum(311021);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(12, 2).node(2) = plasticRotCapOfMaterialNum(212021);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(12, 2).node(3) = plasticRotCapOfMaterialNum(312021);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(12, 2).node(4) = plasticRotCapOfMaterialNum(212011);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(12, 2).node(5) = plasticRotCapOfMaterialNum(40000);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(12, 3).node(1) = plasticRotCapOfMaterialNum(311031);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(12, 3).node(2) = plasticRotCapOfMaterialNum(212031);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(12, 3).node(3) = plasticRotCapOfMaterialNum(312031);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(12, 3).node(4) = plasticRotCapOfMaterialNum(212021);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(12, 3).node(5) = plasticRotCapOfMaterialNum(40000);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(12, 4).node(1) = plasticRotCapOfMaterialNum(311041);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(12, 4).node(2) = plasticRotCapOfMaterialNum(49999);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(12, 4).node(3) = plasticRotCapOfMaterialNum(312041);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(12, 4).node(4) = plasticRotCapOfMaterialNum(212031);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(12, 4).node(5) = plasticRotCapOfMaterialNum(40000);
 
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(11, 1).node(1) = plasticRotCapOfMaterialNum(310011);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(11, 1).node(2) = plasticRotCapOfMaterialNum(211011);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(11, 1).node(3) = plasticRotCapOfMaterialNum(311011);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(11, 1).node(4) = plasticRotCapOfMaterialNum(49999);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(11, 1).node(5) = plasticRotCapOfMaterialNum(40000);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(11, 2).node(1) = plasticRotCapOfMaterialNum(310021);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(11, 2).node(2) = plasticRotCapOfMaterialNum(211021);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(11, 2).node(3) = plasticRotCapOfMaterialNum(311021);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(11, 2).node(4) = plasticRotCapOfMaterialNum(211011);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(11, 2).node(5) = plasticRotCapOfMaterialNum(40000);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(11, 3).node(1) = plasticRotCapOfMaterialNum(310031);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(11, 3).node(2) = plasticRotCapOfMaterialNum(211031);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(11, 3).node(3) = plasticRotCapOfMaterialNum(311031);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(11, 3).node(4) = plasticRotCapOfMaterialNum(211021);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(11, 3).node(5) = plasticRotCapOfMaterialNum(40000);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(11, 4).node(1) = plasticRotCapOfMaterialNum(310041);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(11, 4).node(2) = plasticRotCapOfMaterialNum(49999);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(11, 4).node(3) = plasticRotCapOfMaterialNum(311041);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(11, 4).node(4) = plasticRotCapOfMaterialNum(211031);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(11, 4).node(5) = plasticRotCapOfMaterialNum(40000);
 
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(10, 1).node(1) = plasticRotCapOfMaterialNum(309011);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(10, 1).node(2) = plasticRotCapOfMaterialNum(210011);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(10, 1).node(3) = plasticRotCapOfMaterialNum(310011);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(10, 1).node(4) = plasticRotCapOfMaterialNum(49999);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(10, 1).node(5) = plasticRotCapOfMaterialNum(40000);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(10, 2).node(1) = plasticRotCapOfMaterialNum(309021);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(10, 2).node(2) = plasticRotCapOfMaterialNum(210021);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(10, 2).node(3) = plasticRotCapOfMaterialNum(310021);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(10, 2).node(4) = plasticRotCapOfMaterialNum(210011);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(10, 2).node(5) = plasticRotCapOfMaterialNum(40000);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(10, 3).node(1) = plasticRotCapOfMaterialNum(309031);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(10, 3).node(2) = plasticRotCapOfMaterialNum(210031);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(10, 3).node(3) = plasticRotCapOfMaterialNum(310031);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(10, 3).node(4) = plasticRotCapOfMaterialNum(210021);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(10, 3).node(5) = plasticRotCapOfMaterialNum(40000);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(10, 4).node(1) = plasticRotCapOfMaterialNum(309041);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(10, 4).node(2) = plasticRotCapOfMaterialNum(49999);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(10, 4).node(3) = plasticRotCapOfMaterialNum(310041);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(10, 4).node(4) = plasticRotCapOfMaterialNum(210031);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(10, 4).node(5) = plasticRotCapOfMaterialNum(40000);
 
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(9, 1).node(1) = plasticRotCapOfMaterialNum(308011);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(9, 1).node(2) = plasticRotCapOfMaterialNum(209011);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(9, 1).node(3) = plasticRotCapOfMaterialNum(309011);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(9, 1).node(4) = plasticRotCapOfMaterialNum(49999);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(9, 1).node(5) = plasticRotCapOfMaterialNum(40000);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(9, 2).node(1) = plasticRotCapOfMaterialNum(308021);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(9, 2).node(2) = plasticRotCapOfMaterialNum(209021);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(9, 2).node(3) = plasticRotCapOfMaterialNum(309021);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(9, 2).node(4) = plasticRotCapOfMaterialNum(209011);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(9, 2).node(5) = plasticRotCapOfMaterialNum(40000);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(9, 3).node(1) = plasticRotCapOfMaterialNum(308031);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(9, 3).node(2) = plasticRotCapOfMaterialNum(209031);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(9, 3).node(3) = plasticRotCapOfMaterialNum(309031);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(9, 3).node(4) = plasticRotCapOfMaterialNum(209021);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(9, 3).node(5) = plasticRotCapOfMaterialNum(40000);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(9, 4).node(1) = plasticRotCapOfMaterialNum(308041);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(9, 4).node(2) = plasticRotCapOfMaterialNum(49999);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(9, 4).node(3) = plasticRotCapOfMaterialNum(309041);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(9, 4).node(4) = plasticRotCapOfMaterialNum(209031);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(9, 4).node(5) = plasticRotCapOfMaterialNum(40000);
 
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(8, 1).node(1) = plasticRotCapOfMaterialNum(307011);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(8, 1).node(2) = plasticRotCapOfMaterialNum(208011);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(8, 1).node(3) = plasticRotCapOfMaterialNum(308011);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(8, 1).node(4) = plasticRotCapOfMaterialNum(49999);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(8, 1).node(5) = plasticRotCapOfMaterialNum(40000);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(8, 2).node(1) = plasticRotCapOfMaterialNum(307021);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(8, 2).node(2) = plasticRotCapOfMaterialNum(208021);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(8, 2).node(3) = plasticRotCapOfMaterialNum(308021);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(8, 2).node(4) = plasticRotCapOfMaterialNum(208011);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(8, 2).node(5) = plasticRotCapOfMaterialNum(40000);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(8, 3).node(1) = plasticRotCapOfMaterialNum(307031);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(8, 3).node(2) = plasticRotCapOfMaterialNum(208031);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(8, 3).node(3) = plasticRotCapOfMaterialNum(308031);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(8, 3).node(4) = plasticRotCapOfMaterialNum(208021);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(8, 3).node(5) = plasticRotCapOfMaterialNum(40000);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(8, 4).node(1) = plasticRotCapOfMaterialNum(307041);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(8, 4).node(2) = plasticRotCapOfMaterialNum(49999);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(8, 4).node(3) = plasticRotCapOfMaterialNum(308041);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(8, 4).node(4) = plasticRotCapOfMaterialNum(208031);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(8, 4).node(5) = plasticRotCapOfMaterialNum(40000);
 
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(7, 1).node(1) = plasticRotCapOfMaterialNum(306011);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(7, 1).node(2) = plasticRotCapOfMaterialNum(207011);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(7, 1).node(3) = plasticRotCapOfMaterialNum(307011);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(7, 1).node(4) = plasticRotCapOfMaterialNum(49999);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(7, 1).node(5) = plasticRotCapOfMaterialNum(40000);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(7, 2).node(1) = plasticRotCapOfMaterialNum(306021);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(7, 2).node(2) = plasticRotCapOfMaterialNum(207021);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(7, 2).node(3) = plasticRotCapOfMaterialNum(307021);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(7, 2).node(4) = plasticRotCapOfMaterialNum(207011);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(7, 2).node(5) = plasticRotCapOfMaterialNum(40000);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(7, 3).node(1) = plasticRotCapOfMaterialNum(306031);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(7, 3).node(2) = plasticRotCapOfMaterialNum(207031);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(7, 3).node(3) = plasticRotCapOfMaterialNum(307031);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(7, 3).node(4) = plasticRotCapOfMaterialNum(207021);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(7, 3).node(5) = plasticRotCapOfMaterialNum(40000);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(7, 4).node(1) = plasticRotCapOfMaterialNum(306041);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(7, 4).node(2) = plasticRotCapOfMaterialNum(49999);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(7, 4).node(3) = plasticRotCapOfMaterialNum(307041);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(7, 4).node(4) = plasticRotCapOfMaterialNum(207031);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(7, 4).node(5) = plasticRotCapOfMaterialNum(40000);
 
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(6, 1).node(1) = plasticRotCapOfMaterialNum(305011);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(6, 1).node(2) = plasticRotCapOfMaterialNum(206011);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(6, 1).node(3) = plasticRotCapOfMaterialNum(306011);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(6, 1).node(4) = plasticRotCapOfMaterialNum(49999);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(6, 1).node(5) = plasticRotCapOfMaterialNum(40000);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(6, 2).node(1) = plasticRotCapOfMaterialNum(305021);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(6, 2).node(2) = plasticRotCapOfMaterialNum(206021);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(6, 2).node(3) = plasticRotCapOfMaterialNum(306021);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(6, 2).node(4) = plasticRotCapOfMaterialNum(206011);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(6, 2).node(5) = plasticRotCapOfMaterialNum(40000);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(6, 3).node(1) = plasticRotCapOfMaterialNum(305031);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(6, 3).node(2) = plasticRotCapOfMaterialNum(206031);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(6, 3).node(3) = plasticRotCapOfMaterialNum(306031);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(6, 3).node(4) = plasticRotCapOfMaterialNum(206021);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(6, 3).node(5) = plasticRotCapOfMaterialNum(40000);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(6, 4).node(1) = plasticRotCapOfMaterialNum(305041);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(6, 4).node(2) = plasticRotCapOfMaterialNum(49999);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(6, 4).node(3) = plasticRotCapOfMaterialNum(306041);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(6, 4).node(4) = plasticRotCapOfMaterialNum(206031);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(6, 4).node(5) = plasticRotCapOfMaterialNum(40000);
 
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(5, 1).node(1) = plasticRotCapOfMaterialNum(304011);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(5, 1).node(2) = plasticRotCapOfMaterialNum(205011);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(5, 1).node(3) = plasticRotCapOfMaterialNum(305011);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(5, 1).node(4) = plasticRotCapOfMaterialNum(49999);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(5, 1).node(5) = plasticRotCapOfMaterialNum(40000);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(5, 2).node(1) = plasticRotCapOfMaterialNum(304021);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(5, 2).node(2) = plasticRotCapOfMaterialNum(205021);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(5, 2).node(3) = plasticRotCapOfMaterialNum(305021);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(5, 2).node(4) = plasticRotCapOfMaterialNum(205011);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(5, 2).node(5) = plasticRotCapOfMaterialNum(40000);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(5, 3).node(1) = plasticRotCapOfMaterialNum(304031);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(5, 3).node(2) = plasticRotCapOfMaterialNum(205031);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(5, 3).node(3) = plasticRotCapOfMaterialNum(305031);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(5, 3).node(4) = plasticRotCapOfMaterialNum(205021);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(5, 3).node(5) = plasticRotCapOfMaterialNum(40000);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(5, 4).node(1) = plasticRotCapOfMaterialNum(304041);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(5, 4).node(2) = plasticRotCapOfMaterialNum(49999);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(5, 4).node(3) = plasticRotCapOfMaterialNum(305041);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(5, 4).node(4) = plasticRotCapOfMaterialNum(205031);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(5, 4).node(5) = plasticRotCapOfMaterialNum(40000);
 
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(4, 1).node(1) = plasticRotCapOfMaterialNum(303011);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(4, 1).node(2) = plasticRotCapOfMaterialNum(204011);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(4, 1).node(3) = plasticRotCapOfMaterialNum(304011);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(4, 1).node(4) = plasticRotCapOfMaterialNum(49999);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(4, 1).node(5) = plasticRotCapOfMaterialNum(40000);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(4, 2).node(1) = plasticRotCapOfMaterialNum(303021);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(4, 2).node(2) = plasticRotCapOfMaterialNum(204021);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(4, 2).node(3) = plasticRotCapOfMaterialNum(304021);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(4, 2).node(4) = plasticRotCapOfMaterialNum(204011);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(4, 2).node(5) = plasticRotCapOfMaterialNum(40000);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(4, 3).node(1) = plasticRotCapOfMaterialNum(303031);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(4, 3).node(2) = plasticRotCapOfMaterialNum(204031);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(4, 3).node(3) = plasticRotCapOfMaterialNum(304031);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(4, 3).node(4) = plasticRotCapOfMaterialNum(204021);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(4, 3).node(5) = plasticRotCapOfMaterialNum(40000);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(4, 4).node(1) = plasticRotCapOfMaterialNum(303041);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(4, 4).node(2) = plasticRotCapOfMaterialNum(49999);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(4, 4).node(3) = plasticRotCapOfMaterialNum(304041);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(4, 4).node(4) = plasticRotCapOfMaterialNum(204031);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(4, 4).node(5) = plasticRotCapOfMaterialNum(40000);
 
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(3, 1).node(1) = plasticRotCapOfMaterialNum(302011);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(3, 1).node(2) = plasticRotCapOfMaterialNum(203011);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(3, 1).node(3) = plasticRotCapOfMaterialNum(303011);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(3, 1).node(4) = plasticRotCapOfMaterialNum(49999);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(3, 1).node(5) = plasticRotCapOfMaterialNum(40000);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(3, 2).node(1) = plasticRotCapOfMaterialNum(302021);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(3, 2).node(2) = plasticRotCapOfMaterialNum(203021);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(3, 2).node(3) = plasticRotCapOfMaterialNum(303021);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(3, 2).node(4) = plasticRotCapOfMaterialNum(203011);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(3, 2).node(5) = plasticRotCapOfMaterialNum(40000);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(3, 3).node(1) = plasticRotCapOfMaterialNum(302031);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(3, 3).node(2) = plasticRotCapOfMaterialNum(203031);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(3, 3).node(3) = plasticRotCapOfMaterialNum(303031);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(3, 3).node(4) = plasticRotCapOfMaterialNum(203021);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(3, 3).node(5) = plasticRotCapOfMaterialNum(40000);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(3, 4).node(1) = plasticRotCapOfMaterialNum(302041);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(3, 4).node(2) = plasticRotCapOfMaterialNum(49999);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(3, 4).node(3) = plasticRotCapOfMaterialNum(303041);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(3, 4).node(4) = plasticRotCapOfMaterialNum(203031);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(3, 4).node(5) = plasticRotCapOfMaterialNum(40000);
 
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(2, 1).node(1) = plasticRotCapOfMaterialNum(301011);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(2, 1).node(2) = plasticRotCapOfMaterialNum(202011);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(2, 1).node(3) = plasticRotCapOfMaterialNum(302011);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(2, 1).node(4) = plasticRotCapOfMaterialNum(49999);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(2, 1).node(5) = plasticRotCapOfMaterialNum(40000);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(2, 2).node(1) = plasticRotCapOfMaterialNum(301021);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(2, 2).node(2) = plasticRotCapOfMaterialNum(202021);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(2, 2).node(3) = plasticRotCapOfMaterialNum(302021);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(2, 2).node(4) = plasticRotCapOfMaterialNum(202011);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(2, 2).node(5) = plasticRotCapOfMaterialNum(40000);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(2, 3).node(1) = plasticRotCapOfMaterialNum(301031);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(2, 3).node(2) = plasticRotCapOfMaterialNum(202031);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(2, 3).node(3) = plasticRotCapOfMaterialNum(302031);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(2, 3).node(4) = plasticRotCapOfMaterialNum(202021);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(2, 3).node(5) = plasticRotCapOfMaterialNum(40000);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(2, 4).node(1) = plasticRotCapOfMaterialNum(301041);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(2, 4).node(2) = plasticRotCapOfMaterialNum(49999);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(2, 4).node(3) = plasticRotCapOfMaterialNum(302041);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(2, 4).node(4) = plasticRotCapOfMaterialNum(202031);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(2, 4).node(5) = plasticRotCapOfMaterialNum(40000);
 
     % Define the joint numbers at each location in the frame
         for colLineNum = 1:4
             for floorNum = 2:21
                 buildingInfo{bldgID}.jointNumber(floorNum, colLineNum) = 40000 + (100.0 * floorNum) + colLineNum;
             end
         end
 
      % Define the hinge element numbers that are used at the base columns
         for colLineNum = 1:4
             buildingInfo{bldgID}.hingeElementNumAtColBase(colLineNum) = 6000 + colLineNum * 10 + 2; % The PH Spring at the column base
         end
 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%% Design ID 1020 - END %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Pasted from Excel 20story_ID1021_v.11 on 7-20-06 by Brian Dean
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%% Design ID 1021 - Start %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
 %%%% This code was pasted from the Excel Structural Design Sheet VB output (Dev. by C. Haselton, 6-13-06)
 
% Define General Geometry Information
      bldgID = 1021;
      buildingInfo{bldgID}.bayWidth = 240;
      buildingInfo{bldgID}.storyHeight_firstStory = 180;
      buildingInfo{bldgID}.storyHeight_upperStories = 156;
      buildingInfo{bldgID}.jointWidth = 30;
      buildingInfo{bldgID}.jointWidth = 30; % Just for plotting
      buildingInfo{bldgID}.jointHeight = 34; % Just for plotting
      buildingInfo{bldgID}.numBays = 3;
      buildingInfo{bldgID}.numStories = 20;
      buildingInfo{bldgID}.collapseDriftThreshold = 0.12;
 
% Define the plastic rotation capacities of the column materials
     plasticRotCapOfMaterialNum(320011) = 7.14003446760042E-02;
     plasticRotCapOfMaterialNum(320021) = 7.26832646729425E-02;
     plasticRotCapOfMaterialNum(320031) = 7.26832646729425E-02;
     plasticRotCapOfMaterialNum(320041) = 7.14003446760042E-02;
 
     plasticRotCapOfMaterialNum(319011) = 6.93366634673084E-02;
     plasticRotCapOfMaterialNum(319021) = 6.85424601079675E-02;
     plasticRotCapOfMaterialNum(319031) = 6.85424601079675E-02;
     plasticRotCapOfMaterialNum(319041) = 6.93366634673084E-02;
 
     plasticRotCapOfMaterialNum(318011) = 6.81657092892748E-02;
     plasticRotCapOfMaterialNum(318021) = 6.55715428449827E-02;
     plasticRotCapOfMaterialNum(318031) = 6.55715428449827E-02;
     plasticRotCapOfMaterialNum(318041) = 6.81657092892748E-02;
 
     plasticRotCapOfMaterialNum(317011) = 0.066195518613361;
     plasticRotCapOfMaterialNum(317021) = 6.18358968862227E-02;
     plasticRotCapOfMaterialNum(317031) = 6.18358968862227E-02;
     plasticRotCapOfMaterialNum(317041) = 0.066195518613361;
 
     plasticRotCapOfMaterialNum(316011) = 0.065211121984528;
     plasticRotCapOfMaterialNum(316021) = 5.91556701589933E-02;
     plasticRotCapOfMaterialNum(316031) = 5.91556701589933E-02;
     plasticRotCapOfMaterialNum(316041) = 0.065211121984528;
 
     plasticRotCapOfMaterialNum(315011) = 6.33263276232668E-02;
     plasticRotCapOfMaterialNum(315021) = 5.57855399076797E-02;
     plasticRotCapOfMaterialNum(315031) = 5.57855399076797E-02;
     plasticRotCapOfMaterialNum(315041) = 6.33263276232668E-02;
 
     plasticRotCapOfMaterialNum(314011) = 6.08617271727582E-02;
     plasticRotCapOfMaterialNum(314021) = 5.39606944182305E-02;
     plasticRotCapOfMaterialNum(314031) = 5.39606944182305E-02;
     plasticRotCapOfMaterialNum(314041) = 6.08617271727582E-02;
 
     plasticRotCapOfMaterialNum(313011) = 5.95970301072695E-02;
     plasticRotCapOfMaterialNum(313021) = 5.17414053522193E-02;
     plasticRotCapOfMaterialNum(313031) = 5.17414053522193E-02;
     plasticRotCapOfMaterialNum(313041) = 5.95970301072695E-02;
 
     plasticRotCapOfMaterialNum(312011) = 5.84783389260915E-02;
     plasticRotCapOfMaterialNum(312021) = 0.049208332932479;
     plasticRotCapOfMaterialNum(312031) = 0.049208332932479;
     plasticRotCapOfMaterialNum(312041) = 5.84783389260915E-02;
 
     plasticRotCapOfMaterialNum(311011) = 5.72631682914405E-02;
     plasticRotCapOfMaterialNum(311021) = 4.71844984282886E-02;
     plasticRotCapOfMaterialNum(311031) = 4.71844984282886E-02;
     plasticRotCapOfMaterialNum(311041) = 5.72631682914405E-02;
 
     plasticRotCapOfMaterialNum(310011) = 5.63035589891469E-02;
     plasticRotCapOfMaterialNum(310021) = 4.57099089862399E-02;
     plasticRotCapOfMaterialNum(310031) = 4.57099089862399E-02;
     plasticRotCapOfMaterialNum(310041) = 5.63035589891469E-02;
 
     plasticRotCapOfMaterialNum(309011) = 5.51335799376484E-02;
     plasticRotCapOfMaterialNum(309021) = 4.38299572488646E-02;
     plasticRotCapOfMaterialNum(309031) = 4.38299572488646E-02;
     plasticRotCapOfMaterialNum(309041) = 5.51335799376484E-02;
 
     plasticRotCapOfMaterialNum(308011) = 5.38773806643061E-02;
     plasticRotCapOfMaterialNum(308021) = 0.04134387894788;
     plasticRotCapOfMaterialNum(308031) = 0.04134387894788;
     plasticRotCapOfMaterialNum(308041) = 5.38773806643061E-02;
 
     plasticRotCapOfMaterialNum(307011) = 5.27578172147025E-02;
     plasticRotCapOfMaterialNum(307021) = 0.039643492778192;
     plasticRotCapOfMaterialNum(307031) = 0.039643492778192;
     plasticRotCapOfMaterialNum(307041) = 5.27578172147025E-02;
 
     plasticRotCapOfMaterialNum(306011) = 5.13448595480893E-02;
     plasticRotCapOfMaterialNum(306021) = 3.71656634873872E-02;
     plasticRotCapOfMaterialNum(306031) = 3.71656634873872E-02;
     plasticRotCapOfMaterialNum(306041) = 5.13448595480893E-02;
 
     plasticRotCapOfMaterialNum(305011) = 5.02779214867675E-02;
     plasticRotCapOfMaterialNum(305021) = 3.56371184696132E-02;
     plasticRotCapOfMaterialNum(305031) = 3.56371184696132E-02;
     plasticRotCapOfMaterialNum(305041) = 5.02779214867675E-02;
 
     plasticRotCapOfMaterialNum(304011) = 5.48575476241046E-02;
     plasticRotCapOfMaterialNum(304021) = 0.04195546420031;
     plasticRotCapOfMaterialNum(304031) = 0.04195546420031;
     plasticRotCapOfMaterialNum(304041) = 5.48575476241046E-02;
 
     plasticRotCapOfMaterialNum(303011) = 5.39990991637099E-02;
     plasticRotCapOfMaterialNum(303021) = 4.06526426575958E-02;
     plasticRotCapOfMaterialNum(303031) = 4.06526426575958E-02;
     plasticRotCapOfMaterialNum(303041) = 5.39990991637099E-02;
 
     plasticRotCapOfMaterialNum(302011) = 5.31540842925125E-02;
     plasticRotCapOfMaterialNum(302021) = 3.93902769650197E-02;
     plasticRotCapOfMaterialNum(302031) = 3.93902769650197E-02;
     plasticRotCapOfMaterialNum(302041) = 5.31540842925125E-02;
 
     plasticRotCapOfMaterialNum(301011) = 5.23222927925121E-02;
     plasticRotCapOfMaterialNum(301021) = 3.81671108677863E-02;
     plasticRotCapOfMaterialNum(301031) = 3.81671108677863E-02;
     plasticRotCapOfMaterialNum(301041) = 5.23222927925121E-02;
 
% Define the plastic rotation capacities of the beam materials - make all materials be positive (end in 1)
     plasticRotCapOfMaterialNum(221011) = 4.05123235780344E-02;
     plasticRotCapOfMaterialNum(221021) = 4.05123235780344E-02;
     plasticRotCapOfMaterialNum(221031) = 4.05123235780344E-02;
 
     plasticRotCapOfMaterialNum(220011) = 4.16539711274609E-02;
     plasticRotCapOfMaterialNum(220021) = 4.16539711274609E-02;
     plasticRotCapOfMaterialNum(220031) = 4.16539711274609E-02;
 
     plasticRotCapOfMaterialNum(219011) = 4.19427214685846E-02;
     plasticRotCapOfMaterialNum(219021) = 4.19427214685846E-02;
     plasticRotCapOfMaterialNum(219031) = 4.19427214685846E-02;
 
     plasticRotCapOfMaterialNum(218011) = 5.64290771534642E-02;
     plasticRotCapOfMaterialNum(218021) = 5.64290771534642E-02;
     plasticRotCapOfMaterialNum(218031) = 5.64290771534642E-02;
 
     plasticRotCapOfMaterialNum(217011) = 5.80942683267341E-02;
     plasticRotCapOfMaterialNum(217021) = 5.80942683267341E-02;
     plasticRotCapOfMaterialNum(217031) = 5.80942683267341E-02;
 
     plasticRotCapOfMaterialNum(216011) = 6.14799582411685E-02;
     plasticRotCapOfMaterialNum(216021) = 6.14799582411685E-02;
     plasticRotCapOfMaterialNum(216031) = 6.14799582411685E-02;
 
     plasticRotCapOfMaterialNum(215011) = 0.058201474946123;
     plasticRotCapOfMaterialNum(215021) = 0.058201474946123;
     plasticRotCapOfMaterialNum(215031) = 0.058201474946123;
 
     plasticRotCapOfMaterialNum(214011) = 5.30025972274481E-02;
     plasticRotCapOfMaterialNum(214021) = 5.30025972274481E-02;
     plasticRotCapOfMaterialNum(214031) = 5.30025972274481E-02;
 
     plasticRotCapOfMaterialNum(213011) = 5.53413086745422E-02;
     plasticRotCapOfMaterialNum(213021) = 5.53413086745422E-02;
     plasticRotCapOfMaterialNum(213031) = 5.53413086745422E-02;
 
     plasticRotCapOfMaterialNum(212011) = 5.57403332880476E-02;
     plasticRotCapOfMaterialNum(212021) = 5.57403332880476E-02;
     plasticRotCapOfMaterialNum(212031) = 5.57403332880476E-02;
 
     plasticRotCapOfMaterialNum(211011) = 5.80690339514022E-02;
     plasticRotCapOfMaterialNum(211021) = 5.80690339514022E-02;
     plasticRotCapOfMaterialNum(211031) = 5.80690339514022E-02;
 
     plasticRotCapOfMaterialNum(210011) = 5.76282101518949E-02;
     plasticRotCapOfMaterialNum(210021) = 5.76282101518949E-02;
     plasticRotCapOfMaterialNum(210031) = 5.76282101518949E-02;
 
     plasticRotCapOfMaterialNum(209011) = 5.76282101518949E-02;
     plasticRotCapOfMaterialNum(209021) = 5.76282101518949E-02;
     plasticRotCapOfMaterialNum(209031) = 5.76282101518949E-02;
 
     plasticRotCapOfMaterialNum(208011) = 5.76282101518949E-02;
     plasticRotCapOfMaterialNum(208021) = 5.76282101518949E-02;
     plasticRotCapOfMaterialNum(208031) = 5.76282101518949E-02;
 
     plasticRotCapOfMaterialNum(207011) = 5.76282101518949E-02;
     plasticRotCapOfMaterialNum(207021) = 5.76282101518949E-02;
     plasticRotCapOfMaterialNum(207031) = 5.76282101518949E-02;
 
     plasticRotCapOfMaterialNum(206011) = 5.71881658256711E-02;
     plasticRotCapOfMaterialNum(206021) = 5.71881658256711E-02;
     plasticRotCapOfMaterialNum(206031) = 5.71881658256711E-02;
 
     plasticRotCapOfMaterialNum(205011) = 5.34051199433492E-02;
     plasticRotCapOfMaterialNum(205021) = 5.34051199433492E-02;
     plasticRotCapOfMaterialNum(205031) = 5.34051199433492E-02;
 
     plasticRotCapOfMaterialNum(204011) = 5.34051199433492E-02;
     plasticRotCapOfMaterialNum(204021) = 5.34051199433492E-02;
     plasticRotCapOfMaterialNum(204031) = 5.34051199433492E-02;
 
     plasticRotCapOfMaterialNum(203011) = 5.28993033796732E-02;
     plasticRotCapOfMaterialNum(203021) = 5.28993033796732E-02;
     plasticRotCapOfMaterialNum(203031) = 5.28993033796732E-02;
 
     plasticRotCapOfMaterialNum(202011) = 5.29544739070435E-02;
     plasticRotCapOfMaterialNum(202021) = 5.29544739070435E-02;
     plasticRotCapOfMaterialNum(202031) = 5.29544739070435E-02;
 
% Define the plastic rotation capacities of shear panel material (40000) and the dummy material (49999) used in locations where no element connects to the joint
     plasticRotCapOfMaterialNum(40000) = 99;
     plasticRotCapOfMaterialNum(49999) = 999;
 
% Define the column base rotational spring PHR capacities
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(1, 1).node(1) = plasticRotCapOfMaterialNum(301011);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(1, 2).node(1) = plasticRotCapOfMaterialNum(301021);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(1, 3).node(1) = plasticRotCapOfMaterialNum(301031);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(1, 4).node(1) = plasticRotCapOfMaterialNum(301041);
 
% Define the PHR capacities at all 5 material locations of each joint (4 PHs and 1 shear panel).  When there is not an elements connected to a specific portion of a joint, I use the dummy material #49999.  Make all beam materials be positive (end in 1).
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(21, 1).node(1) = plasticRotCapOfMaterialNum(320011);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(21, 1).node(2) = plasticRotCapOfMaterialNum(221011);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(21, 1).node(3) = plasticRotCapOfMaterialNum(49999);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(21, 1).node(4) = plasticRotCapOfMaterialNum(49999);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(21, 1).node(5) = plasticRotCapOfMaterialNum(40000);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(21, 2).node(1) = plasticRotCapOfMaterialNum(320021);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(21, 2).node(2) = plasticRotCapOfMaterialNum(221021);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(21, 2).node(3) = plasticRotCapOfMaterialNum(49999);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(21, 2).node(4) = plasticRotCapOfMaterialNum(221011);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(21, 2).node(5) = plasticRotCapOfMaterialNum(40000);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(21, 3).node(1) = plasticRotCapOfMaterialNum(320031);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(21, 3).node(2) = plasticRotCapOfMaterialNum(221031);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(21, 3).node(3) = plasticRotCapOfMaterialNum(49999);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(21, 3).node(4) = plasticRotCapOfMaterialNum(221021);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(21, 3).node(5) = plasticRotCapOfMaterialNum(40000);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(21, 4).node(1) = plasticRotCapOfMaterialNum(320041);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(21, 4).node(2) = plasticRotCapOfMaterialNum(49999);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(21, 4).node(3) = plasticRotCapOfMaterialNum(49999);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(21, 4).node(4) = plasticRotCapOfMaterialNum(221031);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(21, 4).node(5) = plasticRotCapOfMaterialNum(40000);
 
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(20, 1).node(1) = plasticRotCapOfMaterialNum(319011);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(20, 1).node(2) = plasticRotCapOfMaterialNum(220011);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(20, 1).node(3) = plasticRotCapOfMaterialNum(320011);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(20, 1).node(4) = plasticRotCapOfMaterialNum(49999);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(20, 1).node(5) = plasticRotCapOfMaterialNum(40000);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(20, 2).node(1) = plasticRotCapOfMaterialNum(319021);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(20, 2).node(2) = plasticRotCapOfMaterialNum(220021);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(20, 2).node(3) = plasticRotCapOfMaterialNum(320021);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(20, 2).node(4) = plasticRotCapOfMaterialNum(220011);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(20, 2).node(5) = plasticRotCapOfMaterialNum(40000);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(20, 3).node(1) = plasticRotCapOfMaterialNum(319031);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(20, 3).node(2) = plasticRotCapOfMaterialNum(220031);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(20, 3).node(3) = plasticRotCapOfMaterialNum(320031);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(20, 3).node(4) = plasticRotCapOfMaterialNum(220021);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(20, 3).node(5) = plasticRotCapOfMaterialNum(40000);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(20, 4).node(1) = plasticRotCapOfMaterialNum(319041);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(20, 4).node(2) = plasticRotCapOfMaterialNum(49999);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(20, 4).node(3) = plasticRotCapOfMaterialNum(320041);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(20, 4).node(4) = plasticRotCapOfMaterialNum(220031);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(20, 4).node(5) = plasticRotCapOfMaterialNum(40000);
 
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(19, 1).node(1) = plasticRotCapOfMaterialNum(318011);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(19, 1).node(2) = plasticRotCapOfMaterialNum(219011);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(19, 1).node(3) = plasticRotCapOfMaterialNum(319011);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(19, 1).node(4) = plasticRotCapOfMaterialNum(49999);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(19, 1).node(5) = plasticRotCapOfMaterialNum(40000);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(19, 2).node(1) = plasticRotCapOfMaterialNum(318021);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(19, 2).node(2) = plasticRotCapOfMaterialNum(219021);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(19, 2).node(3) = plasticRotCapOfMaterialNum(319021);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(19, 2).node(4) = plasticRotCapOfMaterialNum(219011);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(19, 2).node(5) = plasticRotCapOfMaterialNum(40000);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(19, 3).node(1) = plasticRotCapOfMaterialNum(318031);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(19, 3).node(2) = plasticRotCapOfMaterialNum(219031);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(19, 3).node(3) = plasticRotCapOfMaterialNum(319031);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(19, 3).node(4) = plasticRotCapOfMaterialNum(219021);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(19, 3).node(5) = plasticRotCapOfMaterialNum(40000);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(19, 4).node(1) = plasticRotCapOfMaterialNum(318041);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(19, 4).node(2) = plasticRotCapOfMaterialNum(49999);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(19, 4).node(3) = plasticRotCapOfMaterialNum(319041);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(19, 4).node(4) = plasticRotCapOfMaterialNum(219031);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(19, 4).node(5) = plasticRotCapOfMaterialNum(40000);
 
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(18, 1).node(1) = plasticRotCapOfMaterialNum(317011);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(18, 1).node(2) = plasticRotCapOfMaterialNum(218011);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(18, 1).node(3) = plasticRotCapOfMaterialNum(318011);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(18, 1).node(4) = plasticRotCapOfMaterialNum(49999);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(18, 1).node(5) = plasticRotCapOfMaterialNum(40000);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(18, 2).node(1) = plasticRotCapOfMaterialNum(317021);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(18, 2).node(2) = plasticRotCapOfMaterialNum(218021);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(18, 2).node(3) = plasticRotCapOfMaterialNum(318021);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(18, 2).node(4) = plasticRotCapOfMaterialNum(218011);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(18, 2).node(5) = plasticRotCapOfMaterialNum(40000);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(18, 3).node(1) = plasticRotCapOfMaterialNum(317031);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(18, 3).node(2) = plasticRotCapOfMaterialNum(218031);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(18, 3).node(3) = plasticRotCapOfMaterialNum(318031);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(18, 3).node(4) = plasticRotCapOfMaterialNum(218021);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(18, 3).node(5) = plasticRotCapOfMaterialNum(40000);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(18, 4).node(1) = plasticRotCapOfMaterialNum(317041);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(18, 4).node(2) = plasticRotCapOfMaterialNum(49999);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(18, 4).node(3) = plasticRotCapOfMaterialNum(318041);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(18, 4).node(4) = plasticRotCapOfMaterialNum(218031);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(18, 4).node(5) = plasticRotCapOfMaterialNum(40000);
 
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(17, 1).node(1) = plasticRotCapOfMaterialNum(316011);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(17, 1).node(2) = plasticRotCapOfMaterialNum(217011);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(17, 1).node(3) = plasticRotCapOfMaterialNum(317011);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(17, 1).node(4) = plasticRotCapOfMaterialNum(49999);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(17, 1).node(5) = plasticRotCapOfMaterialNum(40000);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(17, 2).node(1) = plasticRotCapOfMaterialNum(316021);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(17, 2).node(2) = plasticRotCapOfMaterialNum(217021);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(17, 2).node(3) = plasticRotCapOfMaterialNum(317021);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(17, 2).node(4) = plasticRotCapOfMaterialNum(217011);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(17, 2).node(5) = plasticRotCapOfMaterialNum(40000);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(17, 3).node(1) = plasticRotCapOfMaterialNum(316031);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(17, 3).node(2) = plasticRotCapOfMaterialNum(217031);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(17, 3).node(3) = plasticRotCapOfMaterialNum(317031);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(17, 3).node(4) = plasticRotCapOfMaterialNum(217021);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(17, 3).node(5) = plasticRotCapOfMaterialNum(40000);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(17, 4).node(1) = plasticRotCapOfMaterialNum(316041);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(17, 4).node(2) = plasticRotCapOfMaterialNum(49999);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(17, 4).node(3) = plasticRotCapOfMaterialNum(317041);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(17, 4).node(4) = plasticRotCapOfMaterialNum(217031);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(17, 4).node(5) = plasticRotCapOfMaterialNum(40000);
 
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(16, 1).node(1) = plasticRotCapOfMaterialNum(315011);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(16, 1).node(2) = plasticRotCapOfMaterialNum(216011);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(16, 1).node(3) = plasticRotCapOfMaterialNum(316011);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(16, 1).node(4) = plasticRotCapOfMaterialNum(49999);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(16, 1).node(5) = plasticRotCapOfMaterialNum(40000);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(16, 2).node(1) = plasticRotCapOfMaterialNum(315021);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(16, 2).node(2) = plasticRotCapOfMaterialNum(216021);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(16, 2).node(3) = plasticRotCapOfMaterialNum(316021);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(16, 2).node(4) = plasticRotCapOfMaterialNum(216011);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(16, 2).node(5) = plasticRotCapOfMaterialNum(40000);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(16, 3).node(1) = plasticRotCapOfMaterialNum(315031);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(16, 3).node(2) = plasticRotCapOfMaterialNum(216031);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(16, 3).node(3) = plasticRotCapOfMaterialNum(316031);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(16, 3).node(4) = plasticRotCapOfMaterialNum(216021);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(16, 3).node(5) = plasticRotCapOfMaterialNum(40000);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(16, 4).node(1) = plasticRotCapOfMaterialNum(315041);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(16, 4).node(2) = plasticRotCapOfMaterialNum(49999);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(16, 4).node(3) = plasticRotCapOfMaterialNum(316041);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(16, 4).node(4) = plasticRotCapOfMaterialNum(216031);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(16, 4).node(5) = plasticRotCapOfMaterialNum(40000);
 
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(15, 1).node(1) = plasticRotCapOfMaterialNum(314011);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(15, 1).node(2) = plasticRotCapOfMaterialNum(215011);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(15, 1).node(3) = plasticRotCapOfMaterialNum(315011);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(15, 1).node(4) = plasticRotCapOfMaterialNum(49999);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(15, 1).node(5) = plasticRotCapOfMaterialNum(40000);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(15, 2).node(1) = plasticRotCapOfMaterialNum(314021);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(15, 2).node(2) = plasticRotCapOfMaterialNum(215021);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(15, 2).node(3) = plasticRotCapOfMaterialNum(315021);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(15, 2).node(4) = plasticRotCapOfMaterialNum(215011);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(15, 2).node(5) = plasticRotCapOfMaterialNum(40000);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(15, 3).node(1) = plasticRotCapOfMaterialNum(314031);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(15, 3).node(2) = plasticRotCapOfMaterialNum(215031);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(15, 3).node(3) = plasticRotCapOfMaterialNum(315031);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(15, 3).node(4) = plasticRotCapOfMaterialNum(215021);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(15, 3).node(5) = plasticRotCapOfMaterialNum(40000);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(15, 4).node(1) = plasticRotCapOfMaterialNum(314041);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(15, 4).node(2) = plasticRotCapOfMaterialNum(49999);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(15, 4).node(3) = plasticRotCapOfMaterialNum(315041);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(15, 4).node(4) = plasticRotCapOfMaterialNum(215031);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(15, 4).node(5) = plasticRotCapOfMaterialNum(40000);
 
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(14, 1).node(1) = plasticRotCapOfMaterialNum(313011);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(14, 1).node(2) = plasticRotCapOfMaterialNum(214011);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(14, 1).node(3) = plasticRotCapOfMaterialNum(314011);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(14, 1).node(4) = plasticRotCapOfMaterialNum(49999);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(14, 1).node(5) = plasticRotCapOfMaterialNum(40000);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(14, 2).node(1) = plasticRotCapOfMaterialNum(313021);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(14, 2).node(2) = plasticRotCapOfMaterialNum(214021);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(14, 2).node(3) = plasticRotCapOfMaterialNum(314021);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(14, 2).node(4) = plasticRotCapOfMaterialNum(214011);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(14, 2).node(5) = plasticRotCapOfMaterialNum(40000);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(14, 3).node(1) = plasticRotCapOfMaterialNum(313031);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(14, 3).node(2) = plasticRotCapOfMaterialNum(214031);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(14, 3).node(3) = plasticRotCapOfMaterialNum(314031);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(14, 3).node(4) = plasticRotCapOfMaterialNum(214021);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(14, 3).node(5) = plasticRotCapOfMaterialNum(40000);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(14, 4).node(1) = plasticRotCapOfMaterialNum(313041);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(14, 4).node(2) = plasticRotCapOfMaterialNum(49999);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(14, 4).node(3) = plasticRotCapOfMaterialNum(314041);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(14, 4).node(4) = plasticRotCapOfMaterialNum(214031);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(14, 4).node(5) = plasticRotCapOfMaterialNum(40000);
 
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(13, 1).node(1) = plasticRotCapOfMaterialNum(312011);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(13, 1).node(2) = plasticRotCapOfMaterialNum(213011);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(13, 1).node(3) = plasticRotCapOfMaterialNum(313011);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(13, 1).node(4) = plasticRotCapOfMaterialNum(49999);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(13, 1).node(5) = plasticRotCapOfMaterialNum(40000);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(13, 2).node(1) = plasticRotCapOfMaterialNum(312021);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(13, 2).node(2) = plasticRotCapOfMaterialNum(213021);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(13, 2).node(3) = plasticRotCapOfMaterialNum(313021);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(13, 2).node(4) = plasticRotCapOfMaterialNum(213011);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(13, 2).node(5) = plasticRotCapOfMaterialNum(40000);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(13, 3).node(1) = plasticRotCapOfMaterialNum(312031);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(13, 3).node(2) = plasticRotCapOfMaterialNum(213031);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(13, 3).node(3) = plasticRotCapOfMaterialNum(313031);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(13, 3).node(4) = plasticRotCapOfMaterialNum(213021);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(13, 3).node(5) = plasticRotCapOfMaterialNum(40000);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(13, 4).node(1) = plasticRotCapOfMaterialNum(312041);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(13, 4).node(2) = plasticRotCapOfMaterialNum(49999);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(13, 4).node(3) = plasticRotCapOfMaterialNum(313041);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(13, 4).node(4) = plasticRotCapOfMaterialNum(213031);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(13, 4).node(5) = plasticRotCapOfMaterialNum(40000);
 
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(12, 1).node(1) = plasticRotCapOfMaterialNum(311011);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(12, 1).node(2) = plasticRotCapOfMaterialNum(212011);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(12, 1).node(3) = plasticRotCapOfMaterialNum(312011);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(12, 1).node(4) = plasticRotCapOfMaterialNum(49999);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(12, 1).node(5) = plasticRotCapOfMaterialNum(40000);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(12, 2).node(1) = plasticRotCapOfMaterialNum(311021);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(12, 2).node(2) = plasticRotCapOfMaterialNum(212021);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(12, 2).node(3) = plasticRotCapOfMaterialNum(312021);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(12, 2).node(4) = plasticRotCapOfMaterialNum(212011);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(12, 2).node(5) = plasticRotCapOfMaterialNum(40000);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(12, 3).node(1) = plasticRotCapOfMaterialNum(311031);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(12, 3).node(2) = plasticRotCapOfMaterialNum(212031);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(12, 3).node(3) = plasticRotCapOfMaterialNum(312031);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(12, 3).node(4) = plasticRotCapOfMaterialNum(212021);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(12, 3).node(5) = plasticRotCapOfMaterialNum(40000);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(12, 4).node(1) = plasticRotCapOfMaterialNum(311041);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(12, 4).node(2) = plasticRotCapOfMaterialNum(49999);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(12, 4).node(3) = plasticRotCapOfMaterialNum(312041);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(12, 4).node(4) = plasticRotCapOfMaterialNum(212031);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(12, 4).node(5) = plasticRotCapOfMaterialNum(40000);
 
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(11, 1).node(1) = plasticRotCapOfMaterialNum(310011);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(11, 1).node(2) = plasticRotCapOfMaterialNum(211011);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(11, 1).node(3) = plasticRotCapOfMaterialNum(311011);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(11, 1).node(4) = plasticRotCapOfMaterialNum(49999);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(11, 1).node(5) = plasticRotCapOfMaterialNum(40000);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(11, 2).node(1) = plasticRotCapOfMaterialNum(310021);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(11, 2).node(2) = plasticRotCapOfMaterialNum(211021);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(11, 2).node(3) = plasticRotCapOfMaterialNum(311021);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(11, 2).node(4) = plasticRotCapOfMaterialNum(211011);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(11, 2).node(5) = plasticRotCapOfMaterialNum(40000);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(11, 3).node(1) = plasticRotCapOfMaterialNum(310031);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(11, 3).node(2) = plasticRotCapOfMaterialNum(211031);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(11, 3).node(3) = plasticRotCapOfMaterialNum(311031);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(11, 3).node(4) = plasticRotCapOfMaterialNum(211021);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(11, 3).node(5) = plasticRotCapOfMaterialNum(40000);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(11, 4).node(1) = plasticRotCapOfMaterialNum(310041);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(11, 4).node(2) = plasticRotCapOfMaterialNum(49999);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(11, 4).node(3) = plasticRotCapOfMaterialNum(311041);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(11, 4).node(4) = plasticRotCapOfMaterialNum(211031);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(11, 4).node(5) = plasticRotCapOfMaterialNum(40000);
 
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(10, 1).node(1) = plasticRotCapOfMaterialNum(309011);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(10, 1).node(2) = plasticRotCapOfMaterialNum(210011);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(10, 1).node(3) = plasticRotCapOfMaterialNum(310011);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(10, 1).node(4) = plasticRotCapOfMaterialNum(49999);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(10, 1).node(5) = plasticRotCapOfMaterialNum(40000);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(10, 2).node(1) = plasticRotCapOfMaterialNum(309021);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(10, 2).node(2) = plasticRotCapOfMaterialNum(210021);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(10, 2).node(3) = plasticRotCapOfMaterialNum(310021);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(10, 2).node(4) = plasticRotCapOfMaterialNum(210011);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(10, 2).node(5) = plasticRotCapOfMaterialNum(40000);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(10, 3).node(1) = plasticRotCapOfMaterialNum(309031);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(10, 3).node(2) = plasticRotCapOfMaterialNum(210031);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(10, 3).node(3) = plasticRotCapOfMaterialNum(310031);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(10, 3).node(4) = plasticRotCapOfMaterialNum(210021);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(10, 3).node(5) = plasticRotCapOfMaterialNum(40000);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(10, 4).node(1) = plasticRotCapOfMaterialNum(309041);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(10, 4).node(2) = plasticRotCapOfMaterialNum(49999);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(10, 4).node(3) = plasticRotCapOfMaterialNum(310041);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(10, 4).node(4) = plasticRotCapOfMaterialNum(210031);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(10, 4).node(5) = plasticRotCapOfMaterialNum(40000);
 
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(9, 1).node(1) = plasticRotCapOfMaterialNum(308011);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(9, 1).node(2) = plasticRotCapOfMaterialNum(209011);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(9, 1).node(3) = plasticRotCapOfMaterialNum(309011);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(9, 1).node(4) = plasticRotCapOfMaterialNum(49999);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(9, 1).node(5) = plasticRotCapOfMaterialNum(40000);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(9, 2).node(1) = plasticRotCapOfMaterialNum(308021);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(9, 2).node(2) = plasticRotCapOfMaterialNum(209021);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(9, 2).node(3) = plasticRotCapOfMaterialNum(309021);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(9, 2).node(4) = plasticRotCapOfMaterialNum(209011);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(9, 2).node(5) = plasticRotCapOfMaterialNum(40000);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(9, 3).node(1) = plasticRotCapOfMaterialNum(308031);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(9, 3).node(2) = plasticRotCapOfMaterialNum(209031);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(9, 3).node(3) = plasticRotCapOfMaterialNum(309031);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(9, 3).node(4) = plasticRotCapOfMaterialNum(209021);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(9, 3).node(5) = plasticRotCapOfMaterialNum(40000);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(9, 4).node(1) = plasticRotCapOfMaterialNum(308041);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(9, 4).node(2) = plasticRotCapOfMaterialNum(49999);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(9, 4).node(3) = plasticRotCapOfMaterialNum(309041);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(9, 4).node(4) = plasticRotCapOfMaterialNum(209031);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(9, 4).node(5) = plasticRotCapOfMaterialNum(40000);
 
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(8, 1).node(1) = plasticRotCapOfMaterialNum(307011);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(8, 1).node(2) = plasticRotCapOfMaterialNum(208011);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(8, 1).node(3) = plasticRotCapOfMaterialNum(308011);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(8, 1).node(4) = plasticRotCapOfMaterialNum(49999);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(8, 1).node(5) = plasticRotCapOfMaterialNum(40000);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(8, 2).node(1) = plasticRotCapOfMaterialNum(307021);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(8, 2).node(2) = plasticRotCapOfMaterialNum(208021);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(8, 2).node(3) = plasticRotCapOfMaterialNum(308021);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(8, 2).node(4) = plasticRotCapOfMaterialNum(208011);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(8, 2).node(5) = plasticRotCapOfMaterialNum(40000);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(8, 3).node(1) = plasticRotCapOfMaterialNum(307031);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(8, 3).node(2) = plasticRotCapOfMaterialNum(208031);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(8, 3).node(3) = plasticRotCapOfMaterialNum(308031);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(8, 3).node(4) = plasticRotCapOfMaterialNum(208021);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(8, 3).node(5) = plasticRotCapOfMaterialNum(40000);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(8, 4).node(1) = plasticRotCapOfMaterialNum(307041);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(8, 4).node(2) = plasticRotCapOfMaterialNum(49999);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(8, 4).node(3) = plasticRotCapOfMaterialNum(308041);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(8, 4).node(4) = plasticRotCapOfMaterialNum(208031);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(8, 4).node(5) = plasticRotCapOfMaterialNum(40000);
 
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(7, 1).node(1) = plasticRotCapOfMaterialNum(306011);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(7, 1).node(2) = plasticRotCapOfMaterialNum(207011);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(7, 1).node(3) = plasticRotCapOfMaterialNum(307011);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(7, 1).node(4) = plasticRotCapOfMaterialNum(49999);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(7, 1).node(5) = plasticRotCapOfMaterialNum(40000);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(7, 2).node(1) = plasticRotCapOfMaterialNum(306021);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(7, 2).node(2) = plasticRotCapOfMaterialNum(207021);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(7, 2).node(3) = plasticRotCapOfMaterialNum(307021);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(7, 2).node(4) = plasticRotCapOfMaterialNum(207011);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(7, 2).node(5) = plasticRotCapOfMaterialNum(40000);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(7, 3).node(1) = plasticRotCapOfMaterialNum(306031);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(7, 3).node(2) = plasticRotCapOfMaterialNum(207031);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(7, 3).node(3) = plasticRotCapOfMaterialNum(307031);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(7, 3).node(4) = plasticRotCapOfMaterialNum(207021);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(7, 3).node(5) = plasticRotCapOfMaterialNum(40000);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(7, 4).node(1) = plasticRotCapOfMaterialNum(306041);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(7, 4).node(2) = plasticRotCapOfMaterialNum(49999);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(7, 4).node(3) = plasticRotCapOfMaterialNum(307041);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(7, 4).node(4) = plasticRotCapOfMaterialNum(207031);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(7, 4).node(5) = plasticRotCapOfMaterialNum(40000);
 
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(6, 1).node(1) = plasticRotCapOfMaterialNum(305011);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(6, 1).node(2) = plasticRotCapOfMaterialNum(206011);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(6, 1).node(3) = plasticRotCapOfMaterialNum(306011);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(6, 1).node(4) = plasticRotCapOfMaterialNum(49999);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(6, 1).node(5) = plasticRotCapOfMaterialNum(40000);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(6, 2).node(1) = plasticRotCapOfMaterialNum(305021);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(6, 2).node(2) = plasticRotCapOfMaterialNum(206021);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(6, 2).node(3) = plasticRotCapOfMaterialNum(306021);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(6, 2).node(4) = plasticRotCapOfMaterialNum(206011);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(6, 2).node(5) = plasticRotCapOfMaterialNum(40000);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(6, 3).node(1) = plasticRotCapOfMaterialNum(305031);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(6, 3).node(2) = plasticRotCapOfMaterialNum(206031);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(6, 3).node(3) = plasticRotCapOfMaterialNum(306031);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(6, 3).node(4) = plasticRotCapOfMaterialNum(206021);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(6, 3).node(5) = plasticRotCapOfMaterialNum(40000);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(6, 4).node(1) = plasticRotCapOfMaterialNum(305041);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(6, 4).node(2) = plasticRotCapOfMaterialNum(49999);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(6, 4).node(3) = plasticRotCapOfMaterialNum(306041);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(6, 4).node(4) = plasticRotCapOfMaterialNum(206031);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(6, 4).node(5) = plasticRotCapOfMaterialNum(40000);
 
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(5, 1).node(1) = plasticRotCapOfMaterialNum(304011);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(5, 1).node(2) = plasticRotCapOfMaterialNum(205011);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(5, 1).node(3) = plasticRotCapOfMaterialNum(305011);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(5, 1).node(4) = plasticRotCapOfMaterialNum(49999);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(5, 1).node(5) = plasticRotCapOfMaterialNum(40000);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(5, 2).node(1) = plasticRotCapOfMaterialNum(304021);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(5, 2).node(2) = plasticRotCapOfMaterialNum(205021);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(5, 2).node(3) = plasticRotCapOfMaterialNum(305021);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(5, 2).node(4) = plasticRotCapOfMaterialNum(205011);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(5, 2).node(5) = plasticRotCapOfMaterialNum(40000);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(5, 3).node(1) = plasticRotCapOfMaterialNum(304031);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(5, 3).node(2) = plasticRotCapOfMaterialNum(205031);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(5, 3).node(3) = plasticRotCapOfMaterialNum(305031);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(5, 3).node(4) = plasticRotCapOfMaterialNum(205021);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(5, 3).node(5) = plasticRotCapOfMaterialNum(40000);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(5, 4).node(1) = plasticRotCapOfMaterialNum(304041);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(5, 4).node(2) = plasticRotCapOfMaterialNum(49999);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(5, 4).node(3) = plasticRotCapOfMaterialNum(305041);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(5, 4).node(4) = plasticRotCapOfMaterialNum(205031);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(5, 4).node(5) = plasticRotCapOfMaterialNum(40000);
 
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(4, 1).node(1) = plasticRotCapOfMaterialNum(303011);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(4, 1).node(2) = plasticRotCapOfMaterialNum(204011);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(4, 1).node(3) = plasticRotCapOfMaterialNum(304011);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(4, 1).node(4) = plasticRotCapOfMaterialNum(49999);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(4, 1).node(5) = plasticRotCapOfMaterialNum(40000);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(4, 2).node(1) = plasticRotCapOfMaterialNum(303021);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(4, 2).node(2) = plasticRotCapOfMaterialNum(204021);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(4, 2).node(3) = plasticRotCapOfMaterialNum(304021);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(4, 2).node(4) = plasticRotCapOfMaterialNum(204011);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(4, 2).node(5) = plasticRotCapOfMaterialNum(40000);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(4, 3).node(1) = plasticRotCapOfMaterialNum(303031);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(4, 3).node(2) = plasticRotCapOfMaterialNum(204031);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(4, 3).node(3) = plasticRotCapOfMaterialNum(304031);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(4, 3).node(4) = plasticRotCapOfMaterialNum(204021);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(4, 3).node(5) = plasticRotCapOfMaterialNum(40000);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(4, 4).node(1) = plasticRotCapOfMaterialNum(303041);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(4, 4).node(2) = plasticRotCapOfMaterialNum(49999);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(4, 4).node(3) = plasticRotCapOfMaterialNum(304041);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(4, 4).node(4) = plasticRotCapOfMaterialNum(204031);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(4, 4).node(5) = plasticRotCapOfMaterialNum(40000);
 
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(3, 1).node(1) = plasticRotCapOfMaterialNum(302011);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(3, 1).node(2) = plasticRotCapOfMaterialNum(203011);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(3, 1).node(3) = plasticRotCapOfMaterialNum(303011);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(3, 1).node(4) = plasticRotCapOfMaterialNum(49999);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(3, 1).node(5) = plasticRotCapOfMaterialNum(40000);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(3, 2).node(1) = plasticRotCapOfMaterialNum(302021);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(3, 2).node(2) = plasticRotCapOfMaterialNum(203021);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(3, 2).node(3) = plasticRotCapOfMaterialNum(303021);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(3, 2).node(4) = plasticRotCapOfMaterialNum(203011);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(3, 2).node(5) = plasticRotCapOfMaterialNum(40000);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(3, 3).node(1) = plasticRotCapOfMaterialNum(302031);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(3, 3).node(2) = plasticRotCapOfMaterialNum(203031);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(3, 3).node(3) = plasticRotCapOfMaterialNum(303031);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(3, 3).node(4) = plasticRotCapOfMaterialNum(203021);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(3, 3).node(5) = plasticRotCapOfMaterialNum(40000);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(3, 4).node(1) = plasticRotCapOfMaterialNum(302041);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(3, 4).node(2) = plasticRotCapOfMaterialNum(49999);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(3, 4).node(3) = plasticRotCapOfMaterialNum(303041);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(3, 4).node(4) = plasticRotCapOfMaterialNum(203031);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(3, 4).node(5) = plasticRotCapOfMaterialNum(40000);
 
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(2, 1).node(1) = plasticRotCapOfMaterialNum(301011);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(2, 1).node(2) = plasticRotCapOfMaterialNum(202011);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(2, 1).node(3) = plasticRotCapOfMaterialNum(302011);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(2, 1).node(4) = plasticRotCapOfMaterialNum(49999);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(2, 1).node(5) = plasticRotCapOfMaterialNum(40000);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(2, 2).node(1) = plasticRotCapOfMaterialNum(301021);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(2, 2).node(2) = plasticRotCapOfMaterialNum(202021);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(2, 2).node(3) = plasticRotCapOfMaterialNum(302021);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(2, 2).node(4) = plasticRotCapOfMaterialNum(202011);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(2, 2).node(5) = plasticRotCapOfMaterialNum(40000);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(2, 3).node(1) = plasticRotCapOfMaterialNum(301031);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(2, 3).node(2) = plasticRotCapOfMaterialNum(202031);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(2, 3).node(3) = plasticRotCapOfMaterialNum(302031);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(2, 3).node(4) = plasticRotCapOfMaterialNum(202021);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(2, 3).node(5) = plasticRotCapOfMaterialNum(40000);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(2, 4).node(1) = plasticRotCapOfMaterialNum(301041);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(2, 4).node(2) = plasticRotCapOfMaterialNum(49999);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(2, 4).node(3) = plasticRotCapOfMaterialNum(302041);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(2, 4).node(4) = plasticRotCapOfMaterialNum(202031);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(2, 4).node(5) = plasticRotCapOfMaterialNum(40000);
 
     % Define the joint numbers at each location in the frame
         for colLineNum = 1:4
             for floorNum = 2:21
                 buildingInfo{bldgID}.jointNumber(floorNum, colLineNum) = 40000 + (100.0 * floorNum) + colLineNum;
             end
         end
 
      % Define the hinge element numbers that are used at the base columns
         for colLineNum = 1:4
             buildingInfo{bldgID}.hingeElementNumAtColBase(colLineNum) = 6000 + colLineNum * 10 + 2; % The PH Spring at the column base
         end
 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%% Design ID 1021 - END %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Pasted from Excel 8story_ID1011_v.71 on 7-20-06 by Brian Dean
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%% Design ID 1011 - Start %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
 %%%% This code was pasted from the Excel Structural Design Sheet VB output (Dev. by C. Haselton, 6-13-06)
 
% Define General Geometry Information
      bldgID = 1011;
      buildingInfo{bldgID}.bayWidth = 240;
      buildingInfo{bldgID}.storyHeight_firstStory = 180;
      buildingInfo{bldgID}.storyHeight_upperStories = 156;
      buildingInfo{bldgID}.jointWidth = 26;
      buildingInfo{bldgID}.jointWidth = 26; % Just for plotting
      buildingInfo{bldgID}.jointHeight = 30; % Just for plotting
      buildingInfo{bldgID}.numBays = 3;
      buildingInfo{bldgID}.numStories = 8;
      buildingInfo{bldgID}.collapseDriftThreshold = 0.12;
 
% Define the plastic rotation capacities of the column materials
     plasticRotCapOfMaterialNum(308011) = 6.92140852122588E-02;
     plasticRotCapOfMaterialNum(308021) = 7.12944894243695E-02;
     plasticRotCapOfMaterialNum(308031) = 7.12944894243695E-02;
     plasticRotCapOfMaterialNum(308041) = 6.92140852122588E-02;
 
     plasticRotCapOfMaterialNum(307011) = 6.84312810707669E-02;
     plasticRotCapOfMaterialNum(307021) = 7.77948073839256E-02;
     plasticRotCapOfMaterialNum(307031) = 7.77948073839256E-02;
     plasticRotCapOfMaterialNum(307041) = 6.84312810707669E-02;
 
     plasticRotCapOfMaterialNum(306011) = 7.01998236094046E-02;
     plasticRotCapOfMaterialNum(306021) = 7.39433797168416E-02;
     plasticRotCapOfMaterialNum(306031) = 7.39433797168416E-02;
     plasticRotCapOfMaterialNum(306041) = 7.01998236094046E-02;
 
     plasticRotCapOfMaterialNum(305011) = 6.94058708686449E-02;
     plasticRotCapOfMaterialNum(305021) = 7.84994579261598E-02;
     plasticRotCapOfMaterialNum(305031) = 7.84994579261598E-02;
     plasticRotCapOfMaterialNum(305041) = 6.94058708686449E-02;
 
     plasticRotCapOfMaterialNum(304011) = 7.33845622108154E-02;
     plasticRotCapOfMaterialNum(304021) = 8.45277564088837E-02;
     plasticRotCapOfMaterialNum(304031) = 8.45277564088837E-02;
     plasticRotCapOfMaterialNum(304041) = 7.33845622108154E-02;
 
     plasticRotCapOfMaterialNum(303011) = 7.26922642876401E-02;
     plasticRotCapOfMaterialNum(303021) = 8.34384488334765E-02;
     plasticRotCapOfMaterialNum(303031) = 8.34384488334765E-02;
     plasticRotCapOfMaterialNum(303041) = 7.26922642876401E-02;
 
     plasticRotCapOfMaterialNum(302011) = 7.20064973895196E-02;
     plasticRotCapOfMaterialNum(302021) = 8.21945528156998E-02;
     plasticRotCapOfMaterialNum(302031) = 8.21945528156998E-02;
     plasticRotCapOfMaterialNum(302041) = 7.20064973895196E-02;
 
     plasticRotCapOfMaterialNum(301011) = 7.26550418083466E-02;
     plasticRotCapOfMaterialNum(301021) = 8.68124574341367E-02;
     plasticRotCapOfMaterialNum(301031) = 8.68124574341367E-02;
     plasticRotCapOfMaterialNum(301041) = 7.26550418083466E-02;
 
% Define the plastic rotation capacities of the beam materials - make all materials be positive (end in 1)
     plasticRotCapOfMaterialNum(209011) = 4.02144676057502E-02;
     plasticRotCapOfMaterialNum(209021) = 4.02144676057502E-02;
     plasticRotCapOfMaterialNum(209031) = 4.02144676057502E-02;
 
     plasticRotCapOfMaterialNum(208011) = 0.041443109599025;
     plasticRotCapOfMaterialNum(208021) = 0.041443109599025;
     plasticRotCapOfMaterialNum(208031) = 0.041443109599025;
 
     plasticRotCapOfMaterialNum(207011) = 0.045745581650275;
     plasticRotCapOfMaterialNum(207021) = 0.045745581650275;
     plasticRotCapOfMaterialNum(207031) = 0.045745581650275;
 
     plasticRotCapOfMaterialNum(206011) = 4.81728537742393E-02;
     plasticRotCapOfMaterialNum(206021) = 4.84033096513433E-02;
     plasticRotCapOfMaterialNum(206031) = 4.81728537742393E-02;
 
     plasticRotCapOfMaterialNum(205011) = 5.12887156868129E-02;
     plasticRotCapOfMaterialNum(205021) = 5.15095128250203E-02;
     plasticRotCapOfMaterialNum(205031) = 5.12887156868129E-02;
 
     plasticRotCapOfMaterialNum(204011) = 5.25829106862489E-02;
     plasticRotCapOfMaterialNum(204021) = 5.30170325944495E-02;
     plasticRotCapOfMaterialNum(204031) = 5.25829106862489E-02;
 
     plasticRotCapOfMaterialNum(203011) = 5.29270495581421E-02;
     plasticRotCapOfMaterialNum(203021) = 5.33598576250928E-02;
     plasticRotCapOfMaterialNum(203031) = 5.29270495581421E-02;
 
     plasticRotCapOfMaterialNum(202011) = 5.09889825948578E-02;
     plasticRotCapOfMaterialNum(202021) = 0.051210709238664;
     plasticRotCapOfMaterialNum(202031) = 5.09889825948578E-02;
 
% Define the plastic rotation capacities of shear panel material (40000) and the dummy material (49999) used in locations where no element connects to the joint
     plasticRotCapOfMaterialNum(40000) = 99;
     plasticRotCapOfMaterialNum(49999) = 999;
 
% Define the column base rotational spring PHR capacities
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(1, 1).node(1) = plasticRotCapOfMaterialNum(301011);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(1, 2).node(1) = plasticRotCapOfMaterialNum(301021);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(1, 3).node(1) = plasticRotCapOfMaterialNum(301031);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(1, 4).node(1) = plasticRotCapOfMaterialNum(301041);
 
% Define the PHR capacities at all 5 material locations of each joint (4 PHs and 1 shear panel).  When there is not an elements connected to a specific portion of a joint, I use the dummy material #49999.  Make all beam materials be positive (end in 1).
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(9, 1).node(1) = plasticRotCapOfMaterialNum(308011);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(9, 1).node(2) = plasticRotCapOfMaterialNum(209011);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(9, 1).node(3) = plasticRotCapOfMaterialNum(49999);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(9, 1).node(4) = plasticRotCapOfMaterialNum(49999);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(9, 1).node(5) = plasticRotCapOfMaterialNum(40000);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(9, 2).node(1) = plasticRotCapOfMaterialNum(308021);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(9, 2).node(2) = plasticRotCapOfMaterialNum(209021);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(9, 2).node(3) = plasticRotCapOfMaterialNum(49999);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(9, 2).node(4) = plasticRotCapOfMaterialNum(209011);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(9, 2).node(5) = plasticRotCapOfMaterialNum(40000);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(9, 3).node(1) = plasticRotCapOfMaterialNum(308031);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(9, 3).node(2) = plasticRotCapOfMaterialNum(209031);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(9, 3).node(3) = plasticRotCapOfMaterialNum(49999);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(9, 3).node(4) = plasticRotCapOfMaterialNum(209021);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(9, 3).node(5) = plasticRotCapOfMaterialNum(40000);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(9, 4).node(1) = plasticRotCapOfMaterialNum(308041);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(9, 4).node(2) = plasticRotCapOfMaterialNum(49999);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(9, 4).node(3) = plasticRotCapOfMaterialNum(49999);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(9, 4).node(4) = plasticRotCapOfMaterialNum(209031);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(9, 4).node(5) = plasticRotCapOfMaterialNum(40000);
 
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(8, 1).node(1) = plasticRotCapOfMaterialNum(307011);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(8, 1).node(2) = plasticRotCapOfMaterialNum(208011);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(8, 1).node(3) = plasticRotCapOfMaterialNum(308011);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(8, 1).node(4) = plasticRotCapOfMaterialNum(49999);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(8, 1).node(5) = plasticRotCapOfMaterialNum(40000);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(8, 2).node(1) = plasticRotCapOfMaterialNum(307021);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(8, 2).node(2) = plasticRotCapOfMaterialNum(208021);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(8, 2).node(3) = plasticRotCapOfMaterialNum(308021);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(8, 2).node(4) = plasticRotCapOfMaterialNum(208011);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(8, 2).node(5) = plasticRotCapOfMaterialNum(40000);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(8, 3).node(1) = plasticRotCapOfMaterialNum(307031);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(8, 3).node(2) = plasticRotCapOfMaterialNum(208031);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(8, 3).node(3) = plasticRotCapOfMaterialNum(308031);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(8, 3).node(4) = plasticRotCapOfMaterialNum(208021);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(8, 3).node(5) = plasticRotCapOfMaterialNum(40000);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(8, 4).node(1) = plasticRotCapOfMaterialNum(307041);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(8, 4).node(2) = plasticRotCapOfMaterialNum(49999);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(8, 4).node(3) = plasticRotCapOfMaterialNum(308041);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(8, 4).node(4) = plasticRotCapOfMaterialNum(208031);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(8, 4).node(5) = plasticRotCapOfMaterialNum(40000);
 
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(7, 1).node(1) = plasticRotCapOfMaterialNum(306011);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(7, 1).node(2) = plasticRotCapOfMaterialNum(207011);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(7, 1).node(3) = plasticRotCapOfMaterialNum(307011);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(7, 1).node(4) = plasticRotCapOfMaterialNum(49999);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(7, 1).node(5) = plasticRotCapOfMaterialNum(40000);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(7, 2).node(1) = plasticRotCapOfMaterialNum(306021);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(7, 2).node(2) = plasticRotCapOfMaterialNum(207021);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(7, 2).node(3) = plasticRotCapOfMaterialNum(307021);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(7, 2).node(4) = plasticRotCapOfMaterialNum(207011);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(7, 2).node(5) = plasticRotCapOfMaterialNum(40000);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(7, 3).node(1) = plasticRotCapOfMaterialNum(306031);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(7, 3).node(2) = plasticRotCapOfMaterialNum(207031);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(7, 3).node(3) = plasticRotCapOfMaterialNum(307031);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(7, 3).node(4) = plasticRotCapOfMaterialNum(207021);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(7, 3).node(5) = plasticRotCapOfMaterialNum(40000);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(7, 4).node(1) = plasticRotCapOfMaterialNum(306041);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(7, 4).node(2) = plasticRotCapOfMaterialNum(49999);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(7, 4).node(3) = plasticRotCapOfMaterialNum(307041);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(7, 4).node(4) = plasticRotCapOfMaterialNum(207031);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(7, 4).node(5) = plasticRotCapOfMaterialNum(40000);
 
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(6, 1).node(1) = plasticRotCapOfMaterialNum(305011);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(6, 1).node(2) = plasticRotCapOfMaterialNum(206011);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(6, 1).node(3) = plasticRotCapOfMaterialNum(306011);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(6, 1).node(4) = plasticRotCapOfMaterialNum(49999);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(6, 1).node(5) = plasticRotCapOfMaterialNum(40000);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(6, 2).node(1) = plasticRotCapOfMaterialNum(305021);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(6, 2).node(2) = plasticRotCapOfMaterialNum(206021);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(6, 2).node(3) = plasticRotCapOfMaterialNum(306021);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(6, 2).node(4) = plasticRotCapOfMaterialNum(206011);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(6, 2).node(5) = plasticRotCapOfMaterialNum(40000);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(6, 3).node(1) = plasticRotCapOfMaterialNum(305031);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(6, 3).node(2) = plasticRotCapOfMaterialNum(206031);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(6, 3).node(3) = plasticRotCapOfMaterialNum(306031);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(6, 3).node(4) = plasticRotCapOfMaterialNum(206021);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(6, 3).node(5) = plasticRotCapOfMaterialNum(40000);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(6, 4).node(1) = plasticRotCapOfMaterialNum(305041);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(6, 4).node(2) = plasticRotCapOfMaterialNum(49999);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(6, 4).node(3) = plasticRotCapOfMaterialNum(306041);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(6, 4).node(4) = plasticRotCapOfMaterialNum(206031);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(6, 4).node(5) = plasticRotCapOfMaterialNum(40000);
 
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(5, 1).node(1) = plasticRotCapOfMaterialNum(304011);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(5, 1).node(2) = plasticRotCapOfMaterialNum(205011);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(5, 1).node(3) = plasticRotCapOfMaterialNum(305011);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(5, 1).node(4) = plasticRotCapOfMaterialNum(49999);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(5, 1).node(5) = plasticRotCapOfMaterialNum(40000);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(5, 2).node(1) = plasticRotCapOfMaterialNum(304021);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(5, 2).node(2) = plasticRotCapOfMaterialNum(205021);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(5, 2).node(3) = plasticRotCapOfMaterialNum(305021);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(5, 2).node(4) = plasticRotCapOfMaterialNum(205011);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(5, 2).node(5) = plasticRotCapOfMaterialNum(40000);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(5, 3).node(1) = plasticRotCapOfMaterialNum(304031);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(5, 3).node(2) = plasticRotCapOfMaterialNum(205031);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(5, 3).node(3) = plasticRotCapOfMaterialNum(305031);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(5, 3).node(4) = plasticRotCapOfMaterialNum(205021);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(5, 3).node(5) = plasticRotCapOfMaterialNum(40000);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(5, 4).node(1) = plasticRotCapOfMaterialNum(304041);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(5, 4).node(2) = plasticRotCapOfMaterialNum(49999);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(5, 4).node(3) = plasticRotCapOfMaterialNum(305041);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(5, 4).node(4) = plasticRotCapOfMaterialNum(205031);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(5, 4).node(5) = plasticRotCapOfMaterialNum(40000);
 
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(4, 1).node(1) = plasticRotCapOfMaterialNum(303011);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(4, 1).node(2) = plasticRotCapOfMaterialNum(204011);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(4, 1).node(3) = plasticRotCapOfMaterialNum(304011);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(4, 1).node(4) = plasticRotCapOfMaterialNum(49999);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(4, 1).node(5) = plasticRotCapOfMaterialNum(40000);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(4, 2).node(1) = plasticRotCapOfMaterialNum(303021);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(4, 2).node(2) = plasticRotCapOfMaterialNum(204021);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(4, 2).node(3) = plasticRotCapOfMaterialNum(304021);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(4, 2).node(4) = plasticRotCapOfMaterialNum(204011);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(4, 2).node(5) = plasticRotCapOfMaterialNum(40000);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(4, 3).node(1) = plasticRotCapOfMaterialNum(303031);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(4, 3).node(2) = plasticRotCapOfMaterialNum(204031);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(4, 3).node(3) = plasticRotCapOfMaterialNum(304031);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(4, 3).node(4) = plasticRotCapOfMaterialNum(204021);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(4, 3).node(5) = plasticRotCapOfMaterialNum(40000);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(4, 4).node(1) = plasticRotCapOfMaterialNum(303041);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(4, 4).node(2) = plasticRotCapOfMaterialNum(49999);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(4, 4).node(3) = plasticRotCapOfMaterialNum(304041);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(4, 4).node(4) = plasticRotCapOfMaterialNum(204031);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(4, 4).node(5) = plasticRotCapOfMaterialNum(40000);
 
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(3, 1).node(1) = plasticRotCapOfMaterialNum(302011);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(3, 1).node(2) = plasticRotCapOfMaterialNum(203011);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(3, 1).node(3) = plasticRotCapOfMaterialNum(303011);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(3, 1).node(4) = plasticRotCapOfMaterialNum(49999);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(3, 1).node(5) = plasticRotCapOfMaterialNum(40000);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(3, 2).node(1) = plasticRotCapOfMaterialNum(302021);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(3, 2).node(2) = plasticRotCapOfMaterialNum(203021);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(3, 2).node(3) = plasticRotCapOfMaterialNum(303021);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(3, 2).node(4) = plasticRotCapOfMaterialNum(203011);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(3, 2).node(5) = plasticRotCapOfMaterialNum(40000);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(3, 3).node(1) = plasticRotCapOfMaterialNum(302031);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(3, 3).node(2) = plasticRotCapOfMaterialNum(203031);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(3, 3).node(3) = plasticRotCapOfMaterialNum(303031);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(3, 3).node(4) = plasticRotCapOfMaterialNum(203021);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(3, 3).node(5) = plasticRotCapOfMaterialNum(40000);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(3, 4).node(1) = plasticRotCapOfMaterialNum(302041);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(3, 4).node(2) = plasticRotCapOfMaterialNum(49999);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(3, 4).node(3) = plasticRotCapOfMaterialNum(303041);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(3, 4).node(4) = plasticRotCapOfMaterialNum(203031);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(3, 4).node(5) = plasticRotCapOfMaterialNum(40000);
 
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(2, 1).node(1) = plasticRotCapOfMaterialNum(301011);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(2, 1).node(2) = plasticRotCapOfMaterialNum(202011);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(2, 1).node(3) = plasticRotCapOfMaterialNum(302011);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(2, 1).node(4) = plasticRotCapOfMaterialNum(49999);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(2, 1).node(5) = plasticRotCapOfMaterialNum(40000);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(2, 2).node(1) = plasticRotCapOfMaterialNum(301021);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(2, 2).node(2) = plasticRotCapOfMaterialNum(202021);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(2, 2).node(3) = plasticRotCapOfMaterialNum(302021);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(2, 2).node(4) = plasticRotCapOfMaterialNum(202011);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(2, 2).node(5) = plasticRotCapOfMaterialNum(40000);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(2, 3).node(1) = plasticRotCapOfMaterialNum(301031);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(2, 3).node(2) = plasticRotCapOfMaterialNum(202031);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(2, 3).node(3) = plasticRotCapOfMaterialNum(302031);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(2, 3).node(4) = plasticRotCapOfMaterialNum(202021);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(2, 3).node(5) = plasticRotCapOfMaterialNum(40000);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(2, 4).node(1) = plasticRotCapOfMaterialNum(301041);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(2, 4).node(2) = plasticRotCapOfMaterialNum(49999);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(2, 4).node(3) = plasticRotCapOfMaterialNum(302041);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(2, 4).node(4) = plasticRotCapOfMaterialNum(202031);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(2, 4).node(5) = plasticRotCapOfMaterialNum(40000);
 
     % Define the joint numbers at each location in the frame
         for colLineNum = 1:4
             for floorNum = 2:9
                 buildingInfo{bldgID}.jointNumber(floorNum, colLineNum) = 40000 + (100.0 * floorNum) + colLineNum;
             end
         end
 
      % Define the hinge element numbers that are used at the base columns
         for colLineNum = 1:4
             buildingInfo{bldgID}.hingeElementNumAtColBase(colLineNum) = 6000 + colLineNum * 10 + 2; % The PH Spring at the column base
         end
 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%% Design ID 1011 - END %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Pasted from Excel 8story_ID1012_v.61 on 7-20-06 by Brian Dean
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%% Design ID 1012 - Start %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
 %%%% This code was pasted from the Excel Structural Design Sheet VB output (Dev. by C. Haselton, 6-13-06)
 
% Define General Geometry Information
      bldgID = 1012;
      buildingInfo{bldgID}.bayWidth = 240;
      buildingInfo{bldgID}.storyHeight_firstStory = 180;
      buildingInfo{bldgID}.storyHeight_upperStories = 156;
      buildingInfo{bldgID}.jointWidth = 22;
      buildingInfo{bldgID}.jointWidth = 22; % Just for plotting
      buildingInfo{bldgID}.jointHeight = 22; % Just for plotting
      buildingInfo{bldgID}.numBays = 3;
      buildingInfo{bldgID}.numStories = 8;
      buildingInfo{bldgID}.collapseDriftThreshold = 0.12;
 
% Define the plastic rotation capacities of the column materials
     plasticRotCapOfMaterialNum(308011) = 7.46483851854419E-02;
     plasticRotCapOfMaterialNum(308021) = 7.40502382784137E-02;
     plasticRotCapOfMaterialNum(308031) = 7.40502382784137E-02;
     plasticRotCapOfMaterialNum(308041) = 7.46483851854419E-02;
 
     plasticRotCapOfMaterialNum(307011) = 7.28460391979509E-02;
     plasticRotCapOfMaterialNum(307021) = 0.070517598190743;
     plasticRotCapOfMaterialNum(307031) = 0.070517598190743;
     plasticRotCapOfMaterialNum(307041) = 7.28460391979509E-02;
 
     plasticRotCapOfMaterialNum(306011) = 7.10872099061065E-02;
     plasticRotCapOfMaterialNum(306021) = 6.68787941874496E-02;
     plasticRotCapOfMaterialNum(306031) = 6.68787941874496E-02;
     plasticRotCapOfMaterialNum(306041) = 7.10872099061065E-02;
 
     plasticRotCapOfMaterialNum(305011) = 6.93708466221866E-02;
     plasticRotCapOfMaterialNum(305021) = 6.36882749554468E-02;
     plasticRotCapOfMaterialNum(305031) = 6.36882749554468E-02;
     plasticRotCapOfMaterialNum(305041) = 6.93708466221866E-02;
 
     plasticRotCapOfMaterialNum(304011) = 6.76959240267715E-02;
     plasticRotCapOfMaterialNum(304021) = 6.08990708756504E-02;
     plasticRotCapOfMaterialNum(304031) = 6.08990708756504E-02;
     plasticRotCapOfMaterialNum(304041) = 6.76959240267715E-02;
 
     plasticRotCapOfMaterialNum(303011) = 6.60614415562392E-02;
     plasticRotCapOfMaterialNum(303021) = 5.79938202771532E-02;
     plasticRotCapOfMaterialNum(303031) = 5.79938202771532E-02;
     plasticRotCapOfMaterialNum(303041) = 6.60614415562392E-02;
 
     plasticRotCapOfMaterialNum(302011) = 6.42027222491251E-02;
     plasticRotCapOfMaterialNum(302021) = 5.36650903596335E-02;
     plasticRotCapOfMaterialNum(302031) = 5.36650903596335E-02;
     plasticRotCapOfMaterialNum(302041) = 6.42027222491251E-02;
 
     plasticRotCapOfMaterialNum(301011) = 6.26525812977267E-02;
     plasticRotCapOfMaterialNum(301021) = 5.11049439790083E-02;
     plasticRotCapOfMaterialNum(301031) = 5.11049439790083E-02;
     plasticRotCapOfMaterialNum(301041) = 6.26525812977267E-02;
 
% Define the plastic rotation capacities of the beam materials - make all materials be positive (end in 1)
     plasticRotCapOfMaterialNum(209011) = 6.99831050880162E-02;
     plasticRotCapOfMaterialNum(209021) = 6.99831050880162E-02;
     plasticRotCapOfMaterialNum(209031) = 6.99831050880162E-02;
 
     plasticRotCapOfMaterialNum(208011) = 7.31908586072053E-02;
     plasticRotCapOfMaterialNum(208021) = 7.31908586072053E-02;
     plasticRotCapOfMaterialNum(208031) = 7.31908586072053E-02;
 
     plasticRotCapOfMaterialNum(207011) = 7.37675851514911E-02;
     plasticRotCapOfMaterialNum(207021) = 7.37675851514911E-02;
     plasticRotCapOfMaterialNum(207031) = 7.37675851514911E-02;
 
     plasticRotCapOfMaterialNum(206011) = 7.37675851514911E-02;
     plasticRotCapOfMaterialNum(206021) = 7.37675851514911E-02;
     plasticRotCapOfMaterialNum(206031) = 7.37675851514911E-02;
 
     plasticRotCapOfMaterialNum(205011) = 6.00705705222972E-02;
     plasticRotCapOfMaterialNum(205021) = 6.00705705222972E-02;
     plasticRotCapOfMaterialNum(205031) = 6.00705705222972E-02;
 
     plasticRotCapOfMaterialNum(204011) = 6.00705705222972E-02;
     plasticRotCapOfMaterialNum(204021) = 6.00705705222972E-02;
     plasticRotCapOfMaterialNum(204031) = 6.00705705222972E-02;
 
     plasticRotCapOfMaterialNum(203011) = 6.00705705222972E-02;
     plasticRotCapOfMaterialNum(203021) = 6.00705705222972E-02;
     plasticRotCapOfMaterialNum(203031) = 6.00705705222972E-02;
 
     plasticRotCapOfMaterialNum(202011) = 5.98980505347755E-02;
     plasticRotCapOfMaterialNum(202021) = 5.98980505347755E-02;
     plasticRotCapOfMaterialNum(202031) = 5.98980505347755E-02;
 
% Define the plastic rotation capacities of shear panel material (40000) and the dummy material (49999) used in locations where no element connects to the joint
     plasticRotCapOfMaterialNum(40000) = 99;
     plasticRotCapOfMaterialNum(49999) = 999;
 
% Define the column base rotational spring PHR capacities
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(1, 1).node(1) = plasticRotCapOfMaterialNum(301011);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(1, 2).node(1) = plasticRotCapOfMaterialNum(301021);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(1, 3).node(1) = plasticRotCapOfMaterialNum(301031);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(1, 4).node(1) = plasticRotCapOfMaterialNum(301041);
 
% Define the PHR capacities at all 5 material locations of each joint (4 PHs and 1 shear panel).  When there is not an elements connected to a specific portion of a joint, I use the dummy material #49999.  Make all beam materials be positive (end in 1).
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(9, 1).node(1) = plasticRotCapOfMaterialNum(308011);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(9, 1).node(2) = plasticRotCapOfMaterialNum(209011);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(9, 1).node(3) = plasticRotCapOfMaterialNum(49999);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(9, 1).node(4) = plasticRotCapOfMaterialNum(49999);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(9, 1).node(5) = plasticRotCapOfMaterialNum(40000);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(9, 2).node(1) = plasticRotCapOfMaterialNum(308021);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(9, 2).node(2) = plasticRotCapOfMaterialNum(209021);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(9, 2).node(3) = plasticRotCapOfMaterialNum(49999);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(9, 2).node(4) = plasticRotCapOfMaterialNum(209011);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(9, 2).node(5) = plasticRotCapOfMaterialNum(40000);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(9, 3).node(1) = plasticRotCapOfMaterialNum(308031);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(9, 3).node(2) = plasticRotCapOfMaterialNum(209031);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(9, 3).node(3) = plasticRotCapOfMaterialNum(49999);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(9, 3).node(4) = plasticRotCapOfMaterialNum(209021);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(9, 3).node(5) = plasticRotCapOfMaterialNum(40000);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(9, 4).node(1) = plasticRotCapOfMaterialNum(308041);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(9, 4).node(2) = plasticRotCapOfMaterialNum(49999);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(9, 4).node(3) = plasticRotCapOfMaterialNum(49999);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(9, 4).node(4) = plasticRotCapOfMaterialNum(209031);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(9, 4).node(5) = plasticRotCapOfMaterialNum(40000);
 
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(8, 1).node(1) = plasticRotCapOfMaterialNum(307011);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(8, 1).node(2) = plasticRotCapOfMaterialNum(208011);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(8, 1).node(3) = plasticRotCapOfMaterialNum(308011);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(8, 1).node(4) = plasticRotCapOfMaterialNum(49999);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(8, 1).node(5) = plasticRotCapOfMaterialNum(40000);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(8, 2).node(1) = plasticRotCapOfMaterialNum(307021);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(8, 2).node(2) = plasticRotCapOfMaterialNum(208021);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(8, 2).node(3) = plasticRotCapOfMaterialNum(308021);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(8, 2).node(4) = plasticRotCapOfMaterialNum(208011);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(8, 2).node(5) = plasticRotCapOfMaterialNum(40000);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(8, 3).node(1) = plasticRotCapOfMaterialNum(307031);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(8, 3).node(2) = plasticRotCapOfMaterialNum(208031);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(8, 3).node(3) = plasticRotCapOfMaterialNum(308031);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(8, 3).node(4) = plasticRotCapOfMaterialNum(208021);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(8, 3).node(5) = plasticRotCapOfMaterialNum(40000);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(8, 4).node(1) = plasticRotCapOfMaterialNum(307041);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(8, 4).node(2) = plasticRotCapOfMaterialNum(49999);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(8, 4).node(3) = plasticRotCapOfMaterialNum(308041);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(8, 4).node(4) = plasticRotCapOfMaterialNum(208031);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(8, 4).node(5) = plasticRotCapOfMaterialNum(40000);
 
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(7, 1).node(1) = plasticRotCapOfMaterialNum(306011);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(7, 1).node(2) = plasticRotCapOfMaterialNum(207011);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(7, 1).node(3) = plasticRotCapOfMaterialNum(307011);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(7, 1).node(4) = plasticRotCapOfMaterialNum(49999);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(7, 1).node(5) = plasticRotCapOfMaterialNum(40000);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(7, 2).node(1) = plasticRotCapOfMaterialNum(306021);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(7, 2).node(2) = plasticRotCapOfMaterialNum(207021);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(7, 2).node(3) = plasticRotCapOfMaterialNum(307021);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(7, 2).node(4) = plasticRotCapOfMaterialNum(207011);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(7, 2).node(5) = plasticRotCapOfMaterialNum(40000);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(7, 3).node(1) = plasticRotCapOfMaterialNum(306031);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(7, 3).node(2) = plasticRotCapOfMaterialNum(207031);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(7, 3).node(3) = plasticRotCapOfMaterialNum(307031);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(7, 3).node(4) = plasticRotCapOfMaterialNum(207021);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(7, 3).node(5) = plasticRotCapOfMaterialNum(40000);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(7, 4).node(1) = plasticRotCapOfMaterialNum(306041);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(7, 4).node(2) = plasticRotCapOfMaterialNum(49999);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(7, 4).node(3) = plasticRotCapOfMaterialNum(307041);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(7, 4).node(4) = plasticRotCapOfMaterialNum(207031);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(7, 4).node(5) = plasticRotCapOfMaterialNum(40000);
 
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(6, 1).node(1) = plasticRotCapOfMaterialNum(305011);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(6, 1).node(2) = plasticRotCapOfMaterialNum(206011);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(6, 1).node(3) = plasticRotCapOfMaterialNum(306011);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(6, 1).node(4) = plasticRotCapOfMaterialNum(49999);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(6, 1).node(5) = plasticRotCapOfMaterialNum(40000);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(6, 2).node(1) = plasticRotCapOfMaterialNum(305021);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(6, 2).node(2) = plasticRotCapOfMaterialNum(206021);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(6, 2).node(3) = plasticRotCapOfMaterialNum(306021);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(6, 2).node(4) = plasticRotCapOfMaterialNum(206011);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(6, 2).node(5) = plasticRotCapOfMaterialNum(40000);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(6, 3).node(1) = plasticRotCapOfMaterialNum(305031);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(6, 3).node(2) = plasticRotCapOfMaterialNum(206031);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(6, 3).node(3) = plasticRotCapOfMaterialNum(306031);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(6, 3).node(4) = plasticRotCapOfMaterialNum(206021);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(6, 3).node(5) = plasticRotCapOfMaterialNum(40000);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(6, 4).node(1) = plasticRotCapOfMaterialNum(305041);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(6, 4).node(2) = plasticRotCapOfMaterialNum(49999);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(6, 4).node(3) = plasticRotCapOfMaterialNum(306041);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(6, 4).node(4) = plasticRotCapOfMaterialNum(206031);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(6, 4).node(5) = plasticRotCapOfMaterialNum(40000);
 
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(5, 1).node(1) = plasticRotCapOfMaterialNum(304011);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(5, 1).node(2) = plasticRotCapOfMaterialNum(205011);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(5, 1).node(3) = plasticRotCapOfMaterialNum(305011);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(5, 1).node(4) = plasticRotCapOfMaterialNum(49999);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(5, 1).node(5) = plasticRotCapOfMaterialNum(40000);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(5, 2).node(1) = plasticRotCapOfMaterialNum(304021);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(5, 2).node(2) = plasticRotCapOfMaterialNum(205021);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(5, 2).node(3) = plasticRotCapOfMaterialNum(305021);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(5, 2).node(4) = plasticRotCapOfMaterialNum(205011);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(5, 2).node(5) = plasticRotCapOfMaterialNum(40000);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(5, 3).node(1) = plasticRotCapOfMaterialNum(304031);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(5, 3).node(2) = plasticRotCapOfMaterialNum(205031);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(5, 3).node(3) = plasticRotCapOfMaterialNum(305031);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(5, 3).node(4) = plasticRotCapOfMaterialNum(205021);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(5, 3).node(5) = plasticRotCapOfMaterialNum(40000);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(5, 4).node(1) = plasticRotCapOfMaterialNum(304041);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(5, 4).node(2) = plasticRotCapOfMaterialNum(49999);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(5, 4).node(3) = plasticRotCapOfMaterialNum(305041);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(5, 4).node(4) = plasticRotCapOfMaterialNum(205031);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(5, 4).node(5) = plasticRotCapOfMaterialNum(40000);
 
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(4, 1).node(1) = plasticRotCapOfMaterialNum(303011);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(4, 1).node(2) = plasticRotCapOfMaterialNum(204011);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(4, 1).node(3) = plasticRotCapOfMaterialNum(304011);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(4, 1).node(4) = plasticRotCapOfMaterialNum(49999);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(4, 1).node(5) = plasticRotCapOfMaterialNum(40000);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(4, 2).node(1) = plasticRotCapOfMaterialNum(303021);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(4, 2).node(2) = plasticRotCapOfMaterialNum(204021);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(4, 2).node(3) = plasticRotCapOfMaterialNum(304021);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(4, 2).node(4) = plasticRotCapOfMaterialNum(204011);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(4, 2).node(5) = plasticRotCapOfMaterialNum(40000);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(4, 3).node(1) = plasticRotCapOfMaterialNum(303031);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(4, 3).node(2) = plasticRotCapOfMaterialNum(204031);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(4, 3).node(3) = plasticRotCapOfMaterialNum(304031);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(4, 3).node(4) = plasticRotCapOfMaterialNum(204021);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(4, 3).node(5) = plasticRotCapOfMaterialNum(40000);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(4, 4).node(1) = plasticRotCapOfMaterialNum(303041);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(4, 4).node(2) = plasticRotCapOfMaterialNum(49999);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(4, 4).node(3) = plasticRotCapOfMaterialNum(304041);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(4, 4).node(4) = plasticRotCapOfMaterialNum(204031);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(4, 4).node(5) = plasticRotCapOfMaterialNum(40000);
 
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(3, 1).node(1) = plasticRotCapOfMaterialNum(302011);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(3, 1).node(2) = plasticRotCapOfMaterialNum(203011);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(3, 1).node(3) = plasticRotCapOfMaterialNum(303011);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(3, 1).node(4) = plasticRotCapOfMaterialNum(49999);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(3, 1).node(5) = plasticRotCapOfMaterialNum(40000);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(3, 2).node(1) = plasticRotCapOfMaterialNum(302021);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(3, 2).node(2) = plasticRotCapOfMaterialNum(203021);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(3, 2).node(3) = plasticRotCapOfMaterialNum(303021);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(3, 2).node(4) = plasticRotCapOfMaterialNum(203011);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(3, 2).node(5) = plasticRotCapOfMaterialNum(40000);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(3, 3).node(1) = plasticRotCapOfMaterialNum(302031);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(3, 3).node(2) = plasticRotCapOfMaterialNum(203031);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(3, 3).node(3) = plasticRotCapOfMaterialNum(303031);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(3, 3).node(4) = plasticRotCapOfMaterialNum(203021);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(3, 3).node(5) = plasticRotCapOfMaterialNum(40000);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(3, 4).node(1) = plasticRotCapOfMaterialNum(302041);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(3, 4).node(2) = plasticRotCapOfMaterialNum(49999);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(3, 4).node(3) = plasticRotCapOfMaterialNum(303041);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(3, 4).node(4) = plasticRotCapOfMaterialNum(203031);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(3, 4).node(5) = plasticRotCapOfMaterialNum(40000);
 
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(2, 1).node(1) = plasticRotCapOfMaterialNum(301011);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(2, 1).node(2) = plasticRotCapOfMaterialNum(202011);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(2, 1).node(3) = plasticRotCapOfMaterialNum(302011);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(2, 1).node(4) = plasticRotCapOfMaterialNum(49999);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(2, 1).node(5) = plasticRotCapOfMaterialNum(40000);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(2, 2).node(1) = plasticRotCapOfMaterialNum(301021);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(2, 2).node(2) = plasticRotCapOfMaterialNum(202021);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(2, 2).node(3) = plasticRotCapOfMaterialNum(302021);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(2, 2).node(4) = plasticRotCapOfMaterialNum(202011);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(2, 2).node(5) = plasticRotCapOfMaterialNum(40000);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(2, 3).node(1) = plasticRotCapOfMaterialNum(301031);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(2, 3).node(2) = plasticRotCapOfMaterialNum(202031);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(2, 3).node(3) = plasticRotCapOfMaterialNum(302031);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(2, 3).node(4) = plasticRotCapOfMaterialNum(202021);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(2, 3).node(5) = plasticRotCapOfMaterialNum(40000);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(2, 4).node(1) = plasticRotCapOfMaterialNum(301041);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(2, 4).node(2) = plasticRotCapOfMaterialNum(49999);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(2, 4).node(3) = plasticRotCapOfMaterialNum(302041);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(2, 4).node(4) = plasticRotCapOfMaterialNum(202031);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(2, 4).node(5) = plasticRotCapOfMaterialNum(40000);
 
     % Define the joint numbers at each location in the frame
         for colLineNum = 1:4
             for floorNum = 2:9
                 buildingInfo{bldgID}.jointNumber(floorNum, colLineNum) = 40000 + (100.0 * floorNum) + colLineNum;
             end
         end
 
      % Define the hinge element numbers that are used at the base columns
         for colLineNum = 1:4
             buildingInfo{bldgID}.hingeElementNumAtColBase(colLineNum) = 6000 + colLineNum * 10 + 2; % The PH Spring at the column base
         end
 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%% Design ID 1012 - END %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Pasted from Excel 4story_ID1010_v.13_Alt on 7-20-06 by Brian Dean
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%% Design ID 1010 - Start %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
 %%%% This code was pasted from the Excel Structural Design Sheet VB output (Dev. by C. Haselton, 6-13-06)
 
% Define General Geometry Information
      bldgID = 1010;
      buildingInfo{bldgID}.bayWidth = 360;
      buildingInfo{bldgID}.storyHeight_firstStory = 180;
      buildingInfo{bldgID}.storyHeight_upperStories = 156;
      buildingInfo{bldgID}.jointWidth = 30;
      buildingInfo{bldgID}.jointWidth = 30; % Just for plotting
      buildingInfo{bldgID}.jointHeight = 30; % Just for plotting
      buildingInfo{bldgID}.numBays = 3;
      buildingInfo{bldgID}.numStories = 4;
      buildingInfo{bldgID}.collapseDriftThreshold = 0.12;
 
% Define the plastic rotation capacities of the column materials
     plasticRotCapOfMaterialNum(304011) = 6.88916872180546E-02;
     plasticRotCapOfMaterialNum(304021) = 6.66261424841288E-02;
     plasticRotCapOfMaterialNum(304031) = 6.66261424841288E-02;
     plasticRotCapOfMaterialNum(304041) = 6.88916872180546E-02;
 
     plasticRotCapOfMaterialNum(303011) = 6.64897353919561E-02;
     plasticRotCapOfMaterialNum(303021) = 0.064657890146604;
     plasticRotCapOfMaterialNum(303031) = 0.064657890146604;
     plasticRotCapOfMaterialNum(303041) = 6.64897353919561E-02;
 
     plasticRotCapOfMaterialNum(302011) = 6.55002615970627E-02;
     plasticRotCapOfMaterialNum(302021) = 6.01045059014358E-02;
     plasticRotCapOfMaterialNum(302031) = 6.01045059014358E-02;
     plasticRotCapOfMaterialNum(302041) = 6.55002615970627E-02;
 
     plasticRotCapOfMaterialNum(301011) = 6.32165539495055E-02;
     plasticRotCapOfMaterialNum(301021) = 0.056101266140321;
     plasticRotCapOfMaterialNum(301031) = 0.056101266140321;
     plasticRotCapOfMaterialNum(301041) = 6.32165539495055E-02;
 
% Define the plastic rotation capacities of the beam materials - make all materials be positive (end in 1)
     plasticRotCapOfMaterialNum(205011) = 5.44623483432319E-02;
     plasticRotCapOfMaterialNum(205021) = 5.44623483432319E-02;
     plasticRotCapOfMaterialNum(205031) = 5.44623483432319E-02;
 
     plasticRotCapOfMaterialNum(204011) = 5.63116093985944E-02;
     plasticRotCapOfMaterialNum(204021) = 5.63116093985944E-02;
     plasticRotCapOfMaterialNum(204031) = 5.63116093985944E-02;
 
     plasticRotCapOfMaterialNum(203011) = 4.45826353043528E-02;
     plasticRotCapOfMaterialNum(203021) = 4.45826353043528E-02;
     plasticRotCapOfMaterialNum(203031) = 4.45826353043528E-02;
 
     plasticRotCapOfMaterialNum(202011) = 4.83558201135334E-02;
     plasticRotCapOfMaterialNum(202021) = 4.83558201135334E-02;
     plasticRotCapOfMaterialNum(202031) = 4.83558201135334E-02;
 
% Define the plastic rotation capacities of shear panel material (40000) and the dummy material (49999) used in locations where no element connects to the joint
     plasticRotCapOfMaterialNum(40000) = 99;
     plasticRotCapOfMaterialNum(49999) = 999;
 
% Define the column base rotational spring PHR capacities
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(1, 1).node(1) = plasticRotCapOfMaterialNum(301011);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(1, 2).node(1) = plasticRotCapOfMaterialNum(301021);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(1, 3).node(1) = plasticRotCapOfMaterialNum(301031);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(1, 4).node(1) = plasticRotCapOfMaterialNum(301041);
 
% Define the PHR capacities at all 5 material locations of each joint (4 PHs and 1 shear panel).  When there is not an elements connected to a specific portion of a joint, I use the dummy material #49999.  Make all beam materials be positive (end in 1).
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(5, 1).node(1) = plasticRotCapOfMaterialNum(304011);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(5, 1).node(2) = plasticRotCapOfMaterialNum(205011);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(5, 1).node(3) = plasticRotCapOfMaterialNum(49999);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(5, 1).node(4) = plasticRotCapOfMaterialNum(49999);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(5, 1).node(5) = plasticRotCapOfMaterialNum(40000);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(5, 2).node(1) = plasticRotCapOfMaterialNum(304021);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(5, 2).node(2) = plasticRotCapOfMaterialNum(205021);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(5, 2).node(3) = plasticRotCapOfMaterialNum(49999);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(5, 2).node(4) = plasticRotCapOfMaterialNum(205011);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(5, 2).node(5) = plasticRotCapOfMaterialNum(40000);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(5, 3).node(1) = plasticRotCapOfMaterialNum(304031);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(5, 3).node(2) = plasticRotCapOfMaterialNum(205031);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(5, 3).node(3) = plasticRotCapOfMaterialNum(49999);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(5, 3).node(4) = plasticRotCapOfMaterialNum(205021);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(5, 3).node(5) = plasticRotCapOfMaterialNum(40000);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(5, 4).node(1) = plasticRotCapOfMaterialNum(304041);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(5, 4).node(2) = plasticRotCapOfMaterialNum(49999);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(5, 4).node(3) = plasticRotCapOfMaterialNum(49999);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(5, 4).node(4) = plasticRotCapOfMaterialNum(205031);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(5, 4).node(5) = plasticRotCapOfMaterialNum(40000);
 
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(4, 1).node(1) = plasticRotCapOfMaterialNum(303011);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(4, 1).node(2) = plasticRotCapOfMaterialNum(204011);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(4, 1).node(3) = plasticRotCapOfMaterialNum(304011);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(4, 1).node(4) = plasticRotCapOfMaterialNum(49999);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(4, 1).node(5) = plasticRotCapOfMaterialNum(40000);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(4, 2).node(1) = plasticRotCapOfMaterialNum(303021);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(4, 2).node(2) = plasticRotCapOfMaterialNum(204021);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(4, 2).node(3) = plasticRotCapOfMaterialNum(304021);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(4, 2).node(4) = plasticRotCapOfMaterialNum(204011);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(4, 2).node(5) = plasticRotCapOfMaterialNum(40000);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(4, 3).node(1) = plasticRotCapOfMaterialNum(303031);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(4, 3).node(2) = plasticRotCapOfMaterialNum(204031);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(4, 3).node(3) = plasticRotCapOfMaterialNum(304031);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(4, 3).node(4) = plasticRotCapOfMaterialNum(204021);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(4, 3).node(5) = plasticRotCapOfMaterialNum(40000);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(4, 4).node(1) = plasticRotCapOfMaterialNum(303041);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(4, 4).node(2) = plasticRotCapOfMaterialNum(49999);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(4, 4).node(3) = plasticRotCapOfMaterialNum(304041);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(4, 4).node(4) = plasticRotCapOfMaterialNum(204031);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(4, 4).node(5) = plasticRotCapOfMaterialNum(40000);
 
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(3, 1).node(1) = plasticRotCapOfMaterialNum(302011);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(3, 1).node(2) = plasticRotCapOfMaterialNum(203011);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(3, 1).node(3) = plasticRotCapOfMaterialNum(303011);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(3, 1).node(4) = plasticRotCapOfMaterialNum(49999);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(3, 1).node(5) = plasticRotCapOfMaterialNum(40000);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(3, 2).node(1) = plasticRotCapOfMaterialNum(302021);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(3, 2).node(2) = plasticRotCapOfMaterialNum(203021);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(3, 2).node(3) = plasticRotCapOfMaterialNum(303021);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(3, 2).node(4) = plasticRotCapOfMaterialNum(203011);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(3, 2).node(5) = plasticRotCapOfMaterialNum(40000);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(3, 3).node(1) = plasticRotCapOfMaterialNum(302031);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(3, 3).node(2) = plasticRotCapOfMaterialNum(203031);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(3, 3).node(3) = plasticRotCapOfMaterialNum(303031);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(3, 3).node(4) = plasticRotCapOfMaterialNum(203021);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(3, 3).node(5) = plasticRotCapOfMaterialNum(40000);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(3, 4).node(1) = plasticRotCapOfMaterialNum(302041);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(3, 4).node(2) = plasticRotCapOfMaterialNum(49999);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(3, 4).node(3) = plasticRotCapOfMaterialNum(303041);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(3, 4).node(4) = plasticRotCapOfMaterialNum(203031);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(3, 4).node(5) = plasticRotCapOfMaterialNum(40000);
 
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(2, 1).node(1) = plasticRotCapOfMaterialNum(301011);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(2, 1).node(2) = plasticRotCapOfMaterialNum(202011);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(2, 1).node(3) = plasticRotCapOfMaterialNum(302011);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(2, 1).node(4) = plasticRotCapOfMaterialNum(49999);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(2, 1).node(5) = plasticRotCapOfMaterialNum(40000);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(2, 2).node(1) = plasticRotCapOfMaterialNum(301021);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(2, 2).node(2) = plasticRotCapOfMaterialNum(202021);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(2, 2).node(3) = plasticRotCapOfMaterialNum(302021);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(2, 2).node(4) = plasticRotCapOfMaterialNum(202011);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(2, 2).node(5) = plasticRotCapOfMaterialNum(40000);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(2, 3).node(1) = plasticRotCapOfMaterialNum(301031);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(2, 3).node(2) = plasticRotCapOfMaterialNum(202031);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(2, 3).node(3) = plasticRotCapOfMaterialNum(302031);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(2, 3).node(4) = plasticRotCapOfMaterialNum(202021);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(2, 3).node(5) = plasticRotCapOfMaterialNum(40000);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(2, 4).node(1) = plasticRotCapOfMaterialNum(301041);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(2, 4).node(2) = plasticRotCapOfMaterialNum(49999);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(2, 4).node(3) = plasticRotCapOfMaterialNum(302041);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(2, 4).node(4) = plasticRotCapOfMaterialNum(202031);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(2, 4).node(5) = plasticRotCapOfMaterialNum(40000);
 
     % Define the joint numbers at each location in the frame
         for colLineNum = 1:4
             for floorNum = 2:5
                 buildingInfo{bldgID}.jointNumber(floorNum, colLineNum) = 40000 + (100.0 * floorNum) + colLineNum;
             end
         end
 
      % Define the hinge element numbers that are used at the base columns
         for colLineNum = 1:4
             buildingInfo{bldgID}.hingeElementNumAtColBase(colLineNum) = 6000 + colLineNum * 10 + 2; % The PH Spring at the column base
         end
 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%% Design ID 1010 - END %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Pasted from Excel 4story_ID1010_v.13_Alt on 7-21-06 by Brian Dean
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%% Design ID 1019 - Start %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
 %%%% This code was pasted from the Excel Structural Design Sheet VB output (Dev. by C. Haselton, 6-13-06)
 
% Define General Geometry Information
      bldgID = 1019;
      buildingInfo{bldgID}.bayWidth = 360;
      buildingInfo{bldgID}.storyHeight_firstStory = 180;
      buildingInfo{bldgID}.storyHeight_upperStories = 156;
      buildingInfo{bldgID}.jointWidth = 30;
      buildingInfo{bldgID}.jointWidth = 30; % Just for plotting
      buildingInfo{bldgID}.jointHeight = 34; % Just for plotting
      buildingInfo{bldgID}.numBays = 3;
      buildingInfo{bldgID}.numStories = 12;
      buildingInfo{bldgID}.collapseDriftThreshold = 0.12;
 
% Define the plastic rotation capacities of the column materials
     plasticRotCapOfMaterialNum(312011) = 0.07359835389003;
     plasticRotCapOfMaterialNum(312021) = 0.072634860090155;
     plasticRotCapOfMaterialNum(312031) = 0.072634860090155;
     plasticRotCapOfMaterialNum(312041) = 0.07359835389003;
 
     plasticRotCapOfMaterialNum(311011) = 7.14536777771252E-02;
     plasticRotCapOfMaterialNum(311021) = 6.84633390997829E-02;
     plasticRotCapOfMaterialNum(311031) = 6.84633390997829E-02;
     plasticRotCapOfMaterialNum(311041) = 7.14536777771252E-02;
 
     plasticRotCapOfMaterialNum(310011) = 0.069371498111303;
     plasticRotCapOfMaterialNum(310021) = 6.45313943590452E-02;
     plasticRotCapOfMaterialNum(310031) = 6.45313943590452E-02;
     plasticRotCapOfMaterialNum(310041) = 0.069371498111303;
 
     plasticRotCapOfMaterialNum(309011) = 6.73499937290442E-02;
     plasticRotCapOfMaterialNum(309021) = 6.08252666708716E-02;
     plasticRotCapOfMaterialNum(309031) = 6.08252666708716E-02;
     plasticRotCapOfMaterialNum(309041) = 6.73499937290442E-02;
 
     plasticRotCapOfMaterialNum(308011) = 6.53873965360309E-02;
     plasticRotCapOfMaterialNum(308021) = 5.76855699597923E-02;
     plasticRotCapOfMaterialNum(308031) = 5.76855699597923E-02;
     plasticRotCapOfMaterialNum(308041) = 6.53873965360309E-02;
 
     plasticRotCapOfMaterialNum(307011) = 6.34819899606964E-02;
     plasticRotCapOfMaterialNum(307021) = 5.43726074837833E-02;
     plasticRotCapOfMaterialNum(307031) = 5.43726074837833E-02;
     plasticRotCapOfMaterialNum(307041) = 6.34819899606964E-02;
 
     plasticRotCapOfMaterialNum(306011) = 6.16321074528375E-02;
     plasticRotCapOfMaterialNum(306021) = 5.12499130483794E-02;
     plasticRotCapOfMaterialNum(306031) = 5.12499130483794E-02;
     plasticRotCapOfMaterialNum(306041) = 6.15059249027354E-02;
 
     plasticRotCapOfMaterialNum(305011) = 0.059836131025979;
     plasticRotCapOfMaterialNum(305021) = 4.83065592955023E-02;
     plasticRotCapOfMaterialNum(305031) = 4.83065592955023E-02;
     plasticRotCapOfMaterialNum(305041) = 0.059836131025979;
 
     plasticRotCapOfMaterialNum(304011) = 5.80924898422127E-02;
     plasticRotCapOfMaterialNum(304021) = 0.045532246440439;
     plasticRotCapOfMaterialNum(304031) = 0.045532246440439;
     plasticRotCapOfMaterialNum(304041) = 5.80924898422127E-02;
 
     plasticRotCapOfMaterialNum(303011) = 5.63996588382759E-02;
     plasticRotCapOfMaterialNum(303021) = 4.29172662294311E-02;
     plasticRotCapOfMaterialNum(303031) = 4.29172662294311E-02;
     plasticRotCapOfMaterialNum(303041) = 5.63996588382759E-02;
 
     plasticRotCapOfMaterialNum(302011) = 5.47561573916652E-02;
     plasticRotCapOfMaterialNum(302021) = 3.85898895775662E-02;
     plasticRotCapOfMaterialNum(302031) = 3.85898895775662E-02;
     plasticRotCapOfMaterialNum(302041) = 5.47561573916652E-02;
 
     plasticRotCapOfMaterialNum(301011) = 0.053160548025621;
     plasticRotCapOfMaterialNum(301021) = 3.63736185723058E-02;
     plasticRotCapOfMaterialNum(301031) = 3.63736185723058E-02;
     plasticRotCapOfMaterialNum(301041) = 0.053160548025621;
 
% Define the plastic rotation capacities of the beam materials - make all materials be positive (end in 1)
     plasticRotCapOfMaterialNum(213011) = 4.03914883771527E-02;
     plasticRotCapOfMaterialNum(213021) = 4.03914883771527E-02;
     plasticRotCapOfMaterialNum(213031) = 4.03914883771527E-02;
 
     plasticRotCapOfMaterialNum(212011) = 4.80812294854266E-02;
     plasticRotCapOfMaterialNum(212021) = 4.80812294854266E-02;
     plasticRotCapOfMaterialNum(212031) = 4.80812294854266E-02;
 
     plasticRotCapOfMaterialNum(211011) = 4.96810348746984E-02;
     plasticRotCapOfMaterialNum(211021) = 4.96810348746984E-02;
     plasticRotCapOfMaterialNum(211031) = 4.96810348746984E-02;
 
     plasticRotCapOfMaterialNum(210011) = 4.75415227847437E-02;
     plasticRotCapOfMaterialNum(210021) = 4.75415227847437E-02;
     plasticRotCapOfMaterialNum(210031) = 4.75415227847437E-02;
 
     plasticRotCapOfMaterialNum(209011) = 3.84419189959317E-02;
     plasticRotCapOfMaterialNum(209021) = 3.84419189959317E-02;
     plasticRotCapOfMaterialNum(209031) = 3.84419189959317E-02;
 
     plasticRotCapOfMaterialNum(208011) = 3.92218275071526E-02;
     plasticRotCapOfMaterialNum(208021) = 3.92218275071526E-02;
     plasticRotCapOfMaterialNum(208031) = 3.92218275071526E-02;
 
     plasticRotCapOfMaterialNum(207011) = 4.12820649235694E-02;
     plasticRotCapOfMaterialNum(207021) = 4.12820649235694E-02;
     plasticRotCapOfMaterialNum(207031) = 4.12820649235694E-02;
 
     plasticRotCapOfMaterialNum(206011) = 4.12820649235694E-02;
     plasticRotCapOfMaterialNum(206021) = 4.12820649235694E-02;
     plasticRotCapOfMaterialNum(206031) = 4.12820649235694E-02;
 
     plasticRotCapOfMaterialNum(205011) = 6.72120649065577E-02;
     plasticRotCapOfMaterialNum(205021) = 6.72120649065577E-02;
     plasticRotCapOfMaterialNum(205031) = 6.72120649065577E-02;
 
     plasticRotCapOfMaterialNum(204011) = 6.72120649065577E-02;
     plasticRotCapOfMaterialNum(204021) = 6.72120649065577E-02;
     plasticRotCapOfMaterialNum(204031) = 6.72120649065577E-02;
 
     plasticRotCapOfMaterialNum(203011) = 6.64733660329094E-02;
     plasticRotCapOfMaterialNum(203021) = 6.64733660329094E-02;
     plasticRotCapOfMaterialNum(203031) = 6.64733660329094E-02;
 
     plasticRotCapOfMaterialNum(202011) = 6.57149823743966E-02;
     plasticRotCapOfMaterialNum(202021) = 6.57149823743966E-02;
     plasticRotCapOfMaterialNum(202031) = 6.57149823743966E-02;
 
% Define the plastic rotation capacities of shear panel material (40000) and the dummy material (49999) used in locations where no element connects to the joint
     plasticRotCapOfMaterialNum(40000) = 99;
     plasticRotCapOfMaterialNum(49999) = 999;
 
% Define the column base rotational spring PHR capacities
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(1, 1).node(1) = plasticRotCapOfMaterialNum(301011);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(1, 2).node(1) = plasticRotCapOfMaterialNum(301021);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(1, 3).node(1) = plasticRotCapOfMaterialNum(301031);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(1, 4).node(1) = plasticRotCapOfMaterialNum(301041);
 
% Define the PHR capacities at all 5 material locations of each joint (4 PHs and 1 shear panel).  When there is not an elements connected to a specific portion of a joint, I use the dummy material #49999.  Make all beam materials be positive (end in 1).
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(13, 1).node(1) = plasticRotCapOfMaterialNum(312011);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(13, 1).node(2) = plasticRotCapOfMaterialNum(213011);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(13, 1).node(3) = plasticRotCapOfMaterialNum(49999);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(13, 1).node(4) = plasticRotCapOfMaterialNum(49999);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(13, 1).node(5) = plasticRotCapOfMaterialNum(40000);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(13, 2).node(1) = plasticRotCapOfMaterialNum(312021);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(13, 2).node(2) = plasticRotCapOfMaterialNum(213021);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(13, 2).node(3) = plasticRotCapOfMaterialNum(49999);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(13, 2).node(4) = plasticRotCapOfMaterialNum(213011);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(13, 2).node(5) = plasticRotCapOfMaterialNum(40000);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(13, 3).node(1) = plasticRotCapOfMaterialNum(312031);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(13, 3).node(2) = plasticRotCapOfMaterialNum(213031);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(13, 3).node(3) = plasticRotCapOfMaterialNum(49999);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(13, 3).node(4) = plasticRotCapOfMaterialNum(213021);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(13, 3).node(5) = plasticRotCapOfMaterialNum(40000);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(13, 4).node(1) = plasticRotCapOfMaterialNum(312041);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(13, 4).node(2) = plasticRotCapOfMaterialNum(49999);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(13, 4).node(3) = plasticRotCapOfMaterialNum(49999);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(13, 4).node(4) = plasticRotCapOfMaterialNum(213031);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(13, 4).node(5) = plasticRotCapOfMaterialNum(40000);
 
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(12, 1).node(1) = plasticRotCapOfMaterialNum(311011);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(12, 1).node(2) = plasticRotCapOfMaterialNum(212011);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(12, 1).node(3) = plasticRotCapOfMaterialNum(312011);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(12, 1).node(4) = plasticRotCapOfMaterialNum(49999);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(12, 1).node(5) = plasticRotCapOfMaterialNum(40000);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(12, 2).node(1) = plasticRotCapOfMaterialNum(311021);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(12, 2).node(2) = plasticRotCapOfMaterialNum(212021);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(12, 2).node(3) = plasticRotCapOfMaterialNum(312021);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(12, 2).node(4) = plasticRotCapOfMaterialNum(212011);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(12, 2).node(5) = plasticRotCapOfMaterialNum(40000);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(12, 3).node(1) = plasticRotCapOfMaterialNum(311031);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(12, 3).node(2) = plasticRotCapOfMaterialNum(212031);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(12, 3).node(3) = plasticRotCapOfMaterialNum(312031);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(12, 3).node(4) = plasticRotCapOfMaterialNum(212021);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(12, 3).node(5) = plasticRotCapOfMaterialNum(40000);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(12, 4).node(1) = plasticRotCapOfMaterialNum(311041);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(12, 4).node(2) = plasticRotCapOfMaterialNum(49999);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(12, 4).node(3) = plasticRotCapOfMaterialNum(312041);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(12, 4).node(4) = plasticRotCapOfMaterialNum(212031);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(12, 4).node(5) = plasticRotCapOfMaterialNum(40000);
 
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(11, 1).node(1) = plasticRotCapOfMaterialNum(310011);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(11, 1).node(2) = plasticRotCapOfMaterialNum(211011);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(11, 1).node(3) = plasticRotCapOfMaterialNum(311011);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(11, 1).node(4) = plasticRotCapOfMaterialNum(49999);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(11, 1).node(5) = plasticRotCapOfMaterialNum(40000);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(11, 2).node(1) = plasticRotCapOfMaterialNum(310021);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(11, 2).node(2) = plasticRotCapOfMaterialNum(211021);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(11, 2).node(3) = plasticRotCapOfMaterialNum(311021);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(11, 2).node(4) = plasticRotCapOfMaterialNum(211011);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(11, 2).node(5) = plasticRotCapOfMaterialNum(40000);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(11, 3).node(1) = plasticRotCapOfMaterialNum(310031);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(11, 3).node(2) = plasticRotCapOfMaterialNum(211031);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(11, 3).node(3) = plasticRotCapOfMaterialNum(311031);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(11, 3).node(4) = plasticRotCapOfMaterialNum(211021);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(11, 3).node(5) = plasticRotCapOfMaterialNum(40000);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(11, 4).node(1) = plasticRotCapOfMaterialNum(310041);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(11, 4).node(2) = plasticRotCapOfMaterialNum(49999);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(11, 4).node(3) = plasticRotCapOfMaterialNum(311041);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(11, 4).node(4) = plasticRotCapOfMaterialNum(211031);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(11, 4).node(5) = plasticRotCapOfMaterialNum(40000);
 
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(10, 1).node(1) = plasticRotCapOfMaterialNum(309011);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(10, 1).node(2) = plasticRotCapOfMaterialNum(210011);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(10, 1).node(3) = plasticRotCapOfMaterialNum(310011);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(10, 1).node(4) = plasticRotCapOfMaterialNum(49999);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(10, 1).node(5) = plasticRotCapOfMaterialNum(40000);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(10, 2).node(1) = plasticRotCapOfMaterialNum(309021);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(10, 2).node(2) = plasticRotCapOfMaterialNum(210021);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(10, 2).node(3) = plasticRotCapOfMaterialNum(310021);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(10, 2).node(4) = plasticRotCapOfMaterialNum(210011);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(10, 2).node(5) = plasticRotCapOfMaterialNum(40000);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(10, 3).node(1) = plasticRotCapOfMaterialNum(309031);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(10, 3).node(2) = plasticRotCapOfMaterialNum(210031);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(10, 3).node(3) = plasticRotCapOfMaterialNum(310031);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(10, 3).node(4) = plasticRotCapOfMaterialNum(210021);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(10, 3).node(5) = plasticRotCapOfMaterialNum(40000);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(10, 4).node(1) = plasticRotCapOfMaterialNum(309041);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(10, 4).node(2) = plasticRotCapOfMaterialNum(49999);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(10, 4).node(3) = plasticRotCapOfMaterialNum(310041);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(10, 4).node(4) = plasticRotCapOfMaterialNum(210031);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(10, 4).node(5) = plasticRotCapOfMaterialNum(40000);
 
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(9, 1).node(1) = plasticRotCapOfMaterialNum(308011);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(9, 1).node(2) = plasticRotCapOfMaterialNum(209011);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(9, 1).node(3) = plasticRotCapOfMaterialNum(309011);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(9, 1).node(4) = plasticRotCapOfMaterialNum(49999);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(9, 1).node(5) = plasticRotCapOfMaterialNum(40000);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(9, 2).node(1) = plasticRotCapOfMaterialNum(308021);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(9, 2).node(2) = plasticRotCapOfMaterialNum(209021);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(9, 2).node(3) = plasticRotCapOfMaterialNum(309021);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(9, 2).node(4) = plasticRotCapOfMaterialNum(209011);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(9, 2).node(5) = plasticRotCapOfMaterialNum(40000);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(9, 3).node(1) = plasticRotCapOfMaterialNum(308031);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(9, 3).node(2) = plasticRotCapOfMaterialNum(209031);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(9, 3).node(3) = plasticRotCapOfMaterialNum(309031);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(9, 3).node(4) = plasticRotCapOfMaterialNum(209021);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(9, 3).node(5) = plasticRotCapOfMaterialNum(40000);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(9, 4).node(1) = plasticRotCapOfMaterialNum(308041);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(9, 4).node(2) = plasticRotCapOfMaterialNum(49999);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(9, 4).node(3) = plasticRotCapOfMaterialNum(309041);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(9, 4).node(4) = plasticRotCapOfMaterialNum(209031);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(9, 4).node(5) = plasticRotCapOfMaterialNum(40000);
 
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(8, 1).node(1) = plasticRotCapOfMaterialNum(307011);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(8, 1).node(2) = plasticRotCapOfMaterialNum(208011);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(8, 1).node(3) = plasticRotCapOfMaterialNum(308011);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(8, 1).node(4) = plasticRotCapOfMaterialNum(49999);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(8, 1).node(5) = plasticRotCapOfMaterialNum(40000);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(8, 2).node(1) = plasticRotCapOfMaterialNum(307021);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(8, 2).node(2) = plasticRotCapOfMaterialNum(208021);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(8, 2).node(3) = plasticRotCapOfMaterialNum(308021);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(8, 2).node(4) = plasticRotCapOfMaterialNum(208011);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(8, 2).node(5) = plasticRotCapOfMaterialNum(40000);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(8, 3).node(1) = plasticRotCapOfMaterialNum(307031);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(8, 3).node(2) = plasticRotCapOfMaterialNum(208031);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(8, 3).node(3) = plasticRotCapOfMaterialNum(308031);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(8, 3).node(4) = plasticRotCapOfMaterialNum(208021);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(8, 3).node(5) = plasticRotCapOfMaterialNum(40000);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(8, 4).node(1) = plasticRotCapOfMaterialNum(307041);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(8, 4).node(2) = plasticRotCapOfMaterialNum(49999);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(8, 4).node(3) = plasticRotCapOfMaterialNum(308041);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(8, 4).node(4) = plasticRotCapOfMaterialNum(208031);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(8, 4).node(5) = plasticRotCapOfMaterialNum(40000);
 
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(7, 1).node(1) = plasticRotCapOfMaterialNum(306011);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(7, 1).node(2) = plasticRotCapOfMaterialNum(207011);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(7, 1).node(3) = plasticRotCapOfMaterialNum(307011);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(7, 1).node(4) = plasticRotCapOfMaterialNum(49999);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(7, 1).node(5) = plasticRotCapOfMaterialNum(40000);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(7, 2).node(1) = plasticRotCapOfMaterialNum(306021);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(7, 2).node(2) = plasticRotCapOfMaterialNum(207021);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(7, 2).node(3) = plasticRotCapOfMaterialNum(307021);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(7, 2).node(4) = plasticRotCapOfMaterialNum(207011);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(7, 2).node(5) = plasticRotCapOfMaterialNum(40000);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(7, 3).node(1) = plasticRotCapOfMaterialNum(306031);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(7, 3).node(2) = plasticRotCapOfMaterialNum(207031);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(7, 3).node(3) = plasticRotCapOfMaterialNum(307031);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(7, 3).node(4) = plasticRotCapOfMaterialNum(207021);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(7, 3).node(5) = plasticRotCapOfMaterialNum(40000);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(7, 4).node(1) = plasticRotCapOfMaterialNum(306041);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(7, 4).node(2) = plasticRotCapOfMaterialNum(49999);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(7, 4).node(3) = plasticRotCapOfMaterialNum(307041);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(7, 4).node(4) = plasticRotCapOfMaterialNum(207031);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(7, 4).node(5) = plasticRotCapOfMaterialNum(40000);
 
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(6, 1).node(1) = plasticRotCapOfMaterialNum(305011);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(6, 1).node(2) = plasticRotCapOfMaterialNum(206011);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(6, 1).node(3) = plasticRotCapOfMaterialNum(306011);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(6, 1).node(4) = plasticRotCapOfMaterialNum(49999);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(6, 1).node(5) = plasticRotCapOfMaterialNum(40000);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(6, 2).node(1) = plasticRotCapOfMaterialNum(305021);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(6, 2).node(2) = plasticRotCapOfMaterialNum(206021);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(6, 2).node(3) = plasticRotCapOfMaterialNum(306021);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(6, 2).node(4) = plasticRotCapOfMaterialNum(206011);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(6, 2).node(5) = plasticRotCapOfMaterialNum(40000);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(6, 3).node(1) = plasticRotCapOfMaterialNum(305031);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(6, 3).node(2) = plasticRotCapOfMaterialNum(206031);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(6, 3).node(3) = plasticRotCapOfMaterialNum(306031);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(6, 3).node(4) = plasticRotCapOfMaterialNum(206021);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(6, 3).node(5) = plasticRotCapOfMaterialNum(40000);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(6, 4).node(1) = plasticRotCapOfMaterialNum(305041);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(6, 4).node(2) = plasticRotCapOfMaterialNum(49999);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(6, 4).node(3) = plasticRotCapOfMaterialNum(306041);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(6, 4).node(4) = plasticRotCapOfMaterialNum(206031);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(6, 4).node(5) = plasticRotCapOfMaterialNum(40000);
 
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(5, 1).node(1) = plasticRotCapOfMaterialNum(304011);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(5, 1).node(2) = plasticRotCapOfMaterialNum(205011);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(5, 1).node(3) = plasticRotCapOfMaterialNum(305011);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(5, 1).node(4) = plasticRotCapOfMaterialNum(49999);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(5, 1).node(5) = plasticRotCapOfMaterialNum(40000);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(5, 2).node(1) = plasticRotCapOfMaterialNum(304021);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(5, 2).node(2) = plasticRotCapOfMaterialNum(205021);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(5, 2).node(3) = plasticRotCapOfMaterialNum(305021);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(5, 2).node(4) = plasticRotCapOfMaterialNum(205011);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(5, 2).node(5) = plasticRotCapOfMaterialNum(40000);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(5, 3).node(1) = plasticRotCapOfMaterialNum(304031);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(5, 3).node(2) = plasticRotCapOfMaterialNum(205031);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(5, 3).node(3) = plasticRotCapOfMaterialNum(305031);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(5, 3).node(4) = plasticRotCapOfMaterialNum(205021);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(5, 3).node(5) = plasticRotCapOfMaterialNum(40000);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(5, 4).node(1) = plasticRotCapOfMaterialNum(304041);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(5, 4).node(2) = plasticRotCapOfMaterialNum(49999);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(5, 4).node(3) = plasticRotCapOfMaterialNum(305041);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(5, 4).node(4) = plasticRotCapOfMaterialNum(205031);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(5, 4).node(5) = plasticRotCapOfMaterialNum(40000);
 
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(4, 1).node(1) = plasticRotCapOfMaterialNum(303011);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(4, 1).node(2) = plasticRotCapOfMaterialNum(204011);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(4, 1).node(3) = plasticRotCapOfMaterialNum(304011);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(4, 1).node(4) = plasticRotCapOfMaterialNum(49999);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(4, 1).node(5) = plasticRotCapOfMaterialNum(40000);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(4, 2).node(1) = plasticRotCapOfMaterialNum(303021);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(4, 2).node(2) = plasticRotCapOfMaterialNum(204021);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(4, 2).node(3) = plasticRotCapOfMaterialNum(304021);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(4, 2).node(4) = plasticRotCapOfMaterialNum(204011);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(4, 2).node(5) = plasticRotCapOfMaterialNum(40000);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(4, 3).node(1) = plasticRotCapOfMaterialNum(303031);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(4, 3).node(2) = plasticRotCapOfMaterialNum(204031);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(4, 3).node(3) = plasticRotCapOfMaterialNum(304031);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(4, 3).node(4) = plasticRotCapOfMaterialNum(204021);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(4, 3).node(5) = plasticRotCapOfMaterialNum(40000);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(4, 4).node(1) = plasticRotCapOfMaterialNum(303041);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(4, 4).node(2) = plasticRotCapOfMaterialNum(49999);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(4, 4).node(3) = plasticRotCapOfMaterialNum(304041);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(4, 4).node(4) = plasticRotCapOfMaterialNum(204031);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(4, 4).node(5) = plasticRotCapOfMaterialNum(40000);
 
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(3, 1).node(1) = plasticRotCapOfMaterialNum(302011);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(3, 1).node(2) = plasticRotCapOfMaterialNum(203011);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(3, 1).node(3) = plasticRotCapOfMaterialNum(303011);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(3, 1).node(4) = plasticRotCapOfMaterialNum(49999);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(3, 1).node(5) = plasticRotCapOfMaterialNum(40000);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(3, 2).node(1) = plasticRotCapOfMaterialNum(302021);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(3, 2).node(2) = plasticRotCapOfMaterialNum(203021);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(3, 2).node(3) = plasticRotCapOfMaterialNum(303021);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(3, 2).node(4) = plasticRotCapOfMaterialNum(203011);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(3, 2).node(5) = plasticRotCapOfMaterialNum(40000);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(3, 3).node(1) = plasticRotCapOfMaterialNum(302031);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(3, 3).node(2) = plasticRotCapOfMaterialNum(203031);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(3, 3).node(3) = plasticRotCapOfMaterialNum(303031);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(3, 3).node(4) = plasticRotCapOfMaterialNum(203021);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(3, 3).node(5) = plasticRotCapOfMaterialNum(40000);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(3, 4).node(1) = plasticRotCapOfMaterialNum(302041);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(3, 4).node(2) = plasticRotCapOfMaterialNum(49999);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(3, 4).node(3) = plasticRotCapOfMaterialNum(303041);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(3, 4).node(4) = plasticRotCapOfMaterialNum(203031);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(3, 4).node(5) = plasticRotCapOfMaterialNum(40000);
 
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(2, 1).node(1) = plasticRotCapOfMaterialNum(301011);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(2, 1).node(2) = plasticRotCapOfMaterialNum(202011);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(2, 1).node(3) = plasticRotCapOfMaterialNum(302011);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(2, 1).node(4) = plasticRotCapOfMaterialNum(49999);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(2, 1).node(5) = plasticRotCapOfMaterialNum(40000);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(2, 2).node(1) = plasticRotCapOfMaterialNum(301021);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(2, 2).node(2) = plasticRotCapOfMaterialNum(202021);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(2, 2).node(3) = plasticRotCapOfMaterialNum(302021);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(2, 2).node(4) = plasticRotCapOfMaterialNum(202011);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(2, 2).node(5) = plasticRotCapOfMaterialNum(40000);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(2, 3).node(1) = plasticRotCapOfMaterialNum(301031);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(2, 3).node(2) = plasticRotCapOfMaterialNum(202031);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(2, 3).node(3) = plasticRotCapOfMaterialNum(302031);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(2, 3).node(4) = plasticRotCapOfMaterialNum(202021);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(2, 3).node(5) = plasticRotCapOfMaterialNum(40000);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(2, 4).node(1) = plasticRotCapOfMaterialNum(301041);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(2, 4).node(2) = plasticRotCapOfMaterialNum(49999);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(2, 4).node(3) = plasticRotCapOfMaterialNum(302041);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(2, 4).node(4) = plasticRotCapOfMaterialNum(202031);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(2, 4).node(5) = plasticRotCapOfMaterialNum(40000);
 
     % Define the joint numbers at each location in the frame
         for colLineNum = 1:4
             for floorNum = 2:13
                 buildingInfo{bldgID}.jointNumber(floorNum, colLineNum) = 40000 + (100.0 * floorNum) + colLineNum;
             end
         end
 
      % Define the hinge element numbers that are used at the base columns
         for colLineNum = 1:4
             buildingInfo{bldgID}.hingeElementNumAtColBase(colLineNum) = 6000 + colLineNum * 10 + 2; % The PH Spring at the column base
         end
 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%% Design ID 1019 - END %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Pasted from Excel 4story_ID1008_v.13 on 7-21-06 by Brian Dean
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%% Design ID 1008 - Start %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
 %%%% This code was pasted from the Excel Structural Design Sheet VB output (Dev. by C. Haselton, 6-13-06)
 
% Define General Geometry Information
      bldgID = 1008;
      buildingInfo{bldgID}.bayWidth = 240;
      buildingInfo{bldgID}.storyHeight_firstStory = 180;
      buildingInfo{bldgID}.storyHeight_upperStories = 156;
      buildingInfo{bldgID}.jointWidth = 22;
      buildingInfo{bldgID}.jointWidth = 22; % Just for plotting
      buildingInfo{bldgID}.jointHeight = 24; % Just for plotting
      buildingInfo{bldgID}.numBays = 3;
      buildingInfo{bldgID}.numStories = 4;
      buildingInfo{bldgID}.collapseDriftThreshold = 0.12;
 
% Define the plastic rotation capacities of the column materials
     plasticRotCapOfMaterialNum(304011) = 6.75567211335751E-02;
     plasticRotCapOfMaterialNum(304021) = 6.73755051342885E-02;
     plasticRotCapOfMaterialNum(304031) = 6.73755051342885E-02;
     plasticRotCapOfMaterialNum(304041) = 6.75567211335751E-02;
 
     plasticRotCapOfMaterialNum(303011) = 6.56041320171346E-02;
     plasticRotCapOfMaterialNum(303021) = 6.35370864765282E-02;
     plasticRotCapOfMaterialNum(303031) = 6.35370864765282E-02;
     plasticRotCapOfMaterialNum(303041) = 6.56041320171346E-02;
 
     plasticRotCapOfMaterialNum(302011) = 0.064628529925815;
     plasticRotCapOfMaterialNum(302021) = 6.07831230682183E-02;
     plasticRotCapOfMaterialNum(302031) = 6.07831230682183E-02;
     plasticRotCapOfMaterialNum(302041) = 0.064628529925815;
 
     plasticRotCapOfMaterialNum(301011) = 6.27605741987279E-02;
     plasticRotCapOfMaterialNum(301021) = 0.057320275951941;
     plasticRotCapOfMaterialNum(301031) = 0.057320275951941;
     plasticRotCapOfMaterialNum(301041) = 6.27605741987279E-02;
 
% Define the plastic rotation capacities of the beam materials - make all materials be positive (end in 1)
     plasticRotCapOfMaterialNum(205011) = 5.15818446567227E-02;
     plasticRotCapOfMaterialNum(205021) = 5.15818446567227E-02;
     plasticRotCapOfMaterialNum(205031) = 5.15818446567227E-02;
 
     plasticRotCapOfMaterialNum(204011) = 5.26653791597246E-02;
     plasticRotCapOfMaterialNum(204021) = 5.26653791597246E-02;
     plasticRotCapOfMaterialNum(204031) = 5.26653791597246E-02;
 
     plasticRotCapOfMaterialNum(203011) = 5.34498635210628E-02;
     plasticRotCapOfMaterialNum(203021) = 5.34498635210628E-02;
     plasticRotCapOfMaterialNum(203031) = 5.34498635210628E-02;
 
     plasticRotCapOfMaterialNum(202011) = 0.053774936872057;
     plasticRotCapOfMaterialNum(202021) = 0.053774936872057;
     plasticRotCapOfMaterialNum(202031) = 0.053774936872057;
 
% Define the plastic rotation capacities of shear panel material (40000) and the dummy material (49999) used in locations where no element connects to the joint
     plasticRotCapOfMaterialNum(40000) = 99;
     plasticRotCapOfMaterialNum(49999) = 999;
 
% Define the column base rotational spring PHR capacities
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(1, 1).node(1) = plasticRotCapOfMaterialNum(301011);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(1, 2).node(1) = plasticRotCapOfMaterialNum(301021);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(1, 3).node(1) = plasticRotCapOfMaterialNum(301031);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(1, 4).node(1) = plasticRotCapOfMaterialNum(301041);
 
% Define the PHR capacities at all 5 material locations of each joint (4 PHs and 1 shear panel).  When there is not an elements connected to a specific portion of a joint, I use the dummy material #49999.  Make all beam materials be positive (end in 1).
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(5, 1).node(1) = plasticRotCapOfMaterialNum(304011);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(5, 1).node(2) = plasticRotCapOfMaterialNum(205011);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(5, 1).node(3) = plasticRotCapOfMaterialNum(49999);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(5, 1).node(4) = plasticRotCapOfMaterialNum(49999);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(5, 1).node(5) = plasticRotCapOfMaterialNum(40000);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(5, 2).node(1) = plasticRotCapOfMaterialNum(304021);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(5, 2).node(2) = plasticRotCapOfMaterialNum(205021);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(5, 2).node(3) = plasticRotCapOfMaterialNum(49999);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(5, 2).node(4) = plasticRotCapOfMaterialNum(205011);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(5, 2).node(5) = plasticRotCapOfMaterialNum(40000);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(5, 3).node(1) = plasticRotCapOfMaterialNum(304031);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(5, 3).node(2) = plasticRotCapOfMaterialNum(205031);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(5, 3).node(3) = plasticRotCapOfMaterialNum(49999);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(5, 3).node(4) = plasticRotCapOfMaterialNum(205021);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(5, 3).node(5) = plasticRotCapOfMaterialNum(40000);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(5, 4).node(1) = plasticRotCapOfMaterialNum(304041);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(5, 4).node(2) = plasticRotCapOfMaterialNum(49999);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(5, 4).node(3) = plasticRotCapOfMaterialNum(49999);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(5, 4).node(4) = plasticRotCapOfMaterialNum(205031);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(5, 4).node(5) = plasticRotCapOfMaterialNum(40000);
 
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(4, 1).node(1) = plasticRotCapOfMaterialNum(303011);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(4, 1).node(2) = plasticRotCapOfMaterialNum(204011);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(4, 1).node(3) = plasticRotCapOfMaterialNum(304011);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(4, 1).node(4) = plasticRotCapOfMaterialNum(49999);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(4, 1).node(5) = plasticRotCapOfMaterialNum(40000);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(4, 2).node(1) = plasticRotCapOfMaterialNum(303021);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(4, 2).node(2) = plasticRotCapOfMaterialNum(204021);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(4, 2).node(3) = plasticRotCapOfMaterialNum(304021);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(4, 2).node(4) = plasticRotCapOfMaterialNum(204011);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(4, 2).node(5) = plasticRotCapOfMaterialNum(40000);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(4, 3).node(1) = plasticRotCapOfMaterialNum(303031);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(4, 3).node(2) = plasticRotCapOfMaterialNum(204031);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(4, 3).node(3) = plasticRotCapOfMaterialNum(304031);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(4, 3).node(4) = plasticRotCapOfMaterialNum(204021);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(4, 3).node(5) = plasticRotCapOfMaterialNum(40000);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(4, 4).node(1) = plasticRotCapOfMaterialNum(303041);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(4, 4).node(2) = plasticRotCapOfMaterialNum(49999);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(4, 4).node(3) = plasticRotCapOfMaterialNum(304041);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(4, 4).node(4) = plasticRotCapOfMaterialNum(204031);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(4, 4).node(5) = plasticRotCapOfMaterialNum(40000);
 
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(3, 1).node(1) = plasticRotCapOfMaterialNum(302011);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(3, 1).node(2) = plasticRotCapOfMaterialNum(203011);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(3, 1).node(3) = plasticRotCapOfMaterialNum(303011);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(3, 1).node(4) = plasticRotCapOfMaterialNum(49999);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(3, 1).node(5) = plasticRotCapOfMaterialNum(40000);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(3, 2).node(1) = plasticRotCapOfMaterialNum(302021);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(3, 2).node(2) = plasticRotCapOfMaterialNum(203021);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(3, 2).node(3) = plasticRotCapOfMaterialNum(303021);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(3, 2).node(4) = plasticRotCapOfMaterialNum(203011);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(3, 2).node(5) = plasticRotCapOfMaterialNum(40000);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(3, 3).node(1) = plasticRotCapOfMaterialNum(302031);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(3, 3).node(2) = plasticRotCapOfMaterialNum(203031);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(3, 3).node(3) = plasticRotCapOfMaterialNum(303031);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(3, 3).node(4) = plasticRotCapOfMaterialNum(203021);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(3, 3).node(5) = plasticRotCapOfMaterialNum(40000);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(3, 4).node(1) = plasticRotCapOfMaterialNum(302041);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(3, 4).node(2) = plasticRotCapOfMaterialNum(49999);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(3, 4).node(3) = plasticRotCapOfMaterialNum(303041);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(3, 4).node(4) = plasticRotCapOfMaterialNum(203031);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(3, 4).node(5) = plasticRotCapOfMaterialNum(40000);
 
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(2, 1).node(1) = plasticRotCapOfMaterialNum(301011);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(2, 1).node(2) = plasticRotCapOfMaterialNum(202011);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(2, 1).node(3) = plasticRotCapOfMaterialNum(302011);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(2, 1).node(4) = plasticRotCapOfMaterialNum(49999);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(2, 1).node(5) = plasticRotCapOfMaterialNum(40000);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(2, 2).node(1) = plasticRotCapOfMaterialNum(301021);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(2, 2).node(2) = plasticRotCapOfMaterialNum(202021);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(2, 2).node(3) = plasticRotCapOfMaterialNum(302021);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(2, 2).node(4) = plasticRotCapOfMaterialNum(202011);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(2, 2).node(5) = plasticRotCapOfMaterialNum(40000);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(2, 3).node(1) = plasticRotCapOfMaterialNum(301031);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(2, 3).node(2) = plasticRotCapOfMaterialNum(202031);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(2, 3).node(3) = plasticRotCapOfMaterialNum(302031);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(2, 3).node(4) = plasticRotCapOfMaterialNum(202021);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(2, 3).node(5) = plasticRotCapOfMaterialNum(40000);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(2, 4).node(1) = plasticRotCapOfMaterialNum(301041);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(2, 4).node(2) = plasticRotCapOfMaterialNum(49999);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(2, 4).node(3) = plasticRotCapOfMaterialNum(302041);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(2, 4).node(4) = plasticRotCapOfMaterialNum(202031);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(2, 4).node(5) = plasticRotCapOfMaterialNum(40000);
 
     % Define the joint numbers at each location in the frame
         for colLineNum = 1:4
             for floorNum = 2:5
                 buildingInfo{bldgID}.jointNumber(floorNum, colLineNum) = 40000 + (100.0 * floorNum) + colLineNum;
             end
         end
 
      % Define the hinge element numbers that are used at the base columns
         for colLineNum = 1:4
             buildingInfo{bldgID}.hingeElementNumAtColBase(colLineNum) = 6000 + colLineNum * 10 + 2; % The PH Spring at the column base
         end
 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%% Design ID 1008 - END %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Pasted from Excel 4story_ID1009_v.11 on 7-21-06 by Brian Dean
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%% Design ID 1009 - Start %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
 %%%% This code was pasted from the Excel Structural Design Sheet VB output (Dev. by C. Haselton, 6-13-06)
 
% Define General Geometry Information
      bldgID = 1009;
      buildingInfo{bldgID}.bayWidth = 360;
      buildingInfo{bldgID}.storyHeight_firstStory = 180;
      buildingInfo{bldgID}.storyHeight_upperStories = 156;
      buildingInfo{bldgID}.jointWidth = 30;
      buildingInfo{bldgID}.jointWidth = 30; % Just for plotting
      buildingInfo{bldgID}.jointHeight = 40; % Just for plotting
      buildingInfo{bldgID}.numBays = 3;
      buildingInfo{bldgID}.numStories = 4;
      buildingInfo{bldgID}.collapseDriftThreshold = 0.12;
 
% Define the plastic rotation capacities of the column materials
     plasticRotCapOfMaterialNum(304011) = 7.26112692523515E-02;
     plasticRotCapOfMaterialNum(304021) = 0.071367552477462;
     plasticRotCapOfMaterialNum(304031) = 0.071367552477462;
     plasticRotCapOfMaterialNum(304041) = 7.26112692523515E-02;
 
     plasticRotCapOfMaterialNum(303011) = 8.39210290827678E-02;
     plasticRotCapOfMaterialNum(303021) = 8.47361352195554E-02;
     plasticRotCapOfMaterialNum(303031) = 8.47361352195554E-02;
     plasticRotCapOfMaterialNum(303041) = 8.39210290827678E-02;
 
     plasticRotCapOfMaterialNum(302011) = 7.92315054450891E-02;
     plasticRotCapOfMaterialNum(302021) = 0.075536166536614;
     plasticRotCapOfMaterialNum(302031) = 0.075536166536614;
     plasticRotCapOfMaterialNum(302041) = 7.92315054450891E-02;
 
     plasticRotCapOfMaterialNum(301011) = 7.73977973319272E-02;
     plasticRotCapOfMaterialNum(301021) = 6.92348365608406E-02;
     plasticRotCapOfMaterialNum(301031) = 6.92348365608406E-02;
     plasticRotCapOfMaterialNum(301041) = 7.69463088953739E-02;
 
% Define the plastic rotation capacities of the beam materials - make all materials be positive (end in 1)
     plasticRotCapOfMaterialNum(205011) = 3.67717729277892E-02;
     plasticRotCapOfMaterialNum(205021) = 3.67717729277892E-02;
     plasticRotCapOfMaterialNum(205031) = 3.67717729277892E-02;
 
     plasticRotCapOfMaterialNum(204011) = 5.50738678356336E-02;
     plasticRotCapOfMaterialNum(204021) = 5.50738678356336E-02;
     plasticRotCapOfMaterialNum(204031) = 5.50738678356336E-02;
 
     plasticRotCapOfMaterialNum(203011) = 5.20008138420545E-02;
     plasticRotCapOfMaterialNum(203021) = 5.20008138420545E-02;
     plasticRotCapOfMaterialNum(203031) = 5.20008138420545E-02;
 
     plasticRotCapOfMaterialNum(202011) = 0.056240372537355;
     plasticRotCapOfMaterialNum(202021) = 0.056240372537355;
     plasticRotCapOfMaterialNum(202031) = 0.056240372537355;
 
% Define the plastic rotation capacities of shear panel material (40000) and the dummy material (49999) used in locations where no element connects to the joint
     plasticRotCapOfMaterialNum(40000) = 99;
     plasticRotCapOfMaterialNum(49999) = 999;
 
% Define the column base rotational spring PHR capacities
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(1, 1).node(1) = plasticRotCapOfMaterialNum(301011);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(1, 2).node(1) = plasticRotCapOfMaterialNum(301021);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(1, 3).node(1) = plasticRotCapOfMaterialNum(301031);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(1, 4).node(1) = plasticRotCapOfMaterialNum(301041);
 
% Define the PHR capacities at all 5 material locations of each joint (4 PHs and 1 shear panel).  When there is not an elements connected to a specific portion of a joint, I use the dummy material #49999.  Make all beam materials be positive (end in 1).
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(5, 1).node(1) = plasticRotCapOfMaterialNum(304011);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(5, 1).node(2) = plasticRotCapOfMaterialNum(205011);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(5, 1).node(3) = plasticRotCapOfMaterialNum(49999);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(5, 1).node(4) = plasticRotCapOfMaterialNum(49999);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(5, 1).node(5) = plasticRotCapOfMaterialNum(40000);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(5, 2).node(1) = plasticRotCapOfMaterialNum(304021);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(5, 2).node(2) = plasticRotCapOfMaterialNum(205021);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(5, 2).node(3) = plasticRotCapOfMaterialNum(49999);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(5, 2).node(4) = plasticRotCapOfMaterialNum(205011);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(5, 2).node(5) = plasticRotCapOfMaterialNum(40000);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(5, 3).node(1) = plasticRotCapOfMaterialNum(304031);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(5, 3).node(2) = plasticRotCapOfMaterialNum(205031);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(5, 3).node(3) = plasticRotCapOfMaterialNum(49999);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(5, 3).node(4) = plasticRotCapOfMaterialNum(205021);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(5, 3).node(5) = plasticRotCapOfMaterialNum(40000);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(5, 4).node(1) = plasticRotCapOfMaterialNum(304041);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(5, 4).node(2) = plasticRotCapOfMaterialNum(49999);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(5, 4).node(3) = plasticRotCapOfMaterialNum(49999);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(5, 4).node(4) = plasticRotCapOfMaterialNum(205031);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(5, 4).node(5) = plasticRotCapOfMaterialNum(40000);
 
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(4, 1).node(1) = plasticRotCapOfMaterialNum(303011);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(4, 1).node(2) = plasticRotCapOfMaterialNum(204011);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(4, 1).node(3) = plasticRotCapOfMaterialNum(304011);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(4, 1).node(4) = plasticRotCapOfMaterialNum(49999);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(4, 1).node(5) = plasticRotCapOfMaterialNum(40000);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(4, 2).node(1) = plasticRotCapOfMaterialNum(303021);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(4, 2).node(2) = plasticRotCapOfMaterialNum(204021);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(4, 2).node(3) = plasticRotCapOfMaterialNum(304021);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(4, 2).node(4) = plasticRotCapOfMaterialNum(204011);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(4, 2).node(5) = plasticRotCapOfMaterialNum(40000);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(4, 3).node(1) = plasticRotCapOfMaterialNum(303031);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(4, 3).node(2) = plasticRotCapOfMaterialNum(204031);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(4, 3).node(3) = plasticRotCapOfMaterialNum(304031);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(4, 3).node(4) = plasticRotCapOfMaterialNum(204021);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(4, 3).node(5) = plasticRotCapOfMaterialNum(40000);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(4, 4).node(1) = plasticRotCapOfMaterialNum(303041);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(4, 4).node(2) = plasticRotCapOfMaterialNum(49999);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(4, 4).node(3) = plasticRotCapOfMaterialNum(304041);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(4, 4).node(4) = plasticRotCapOfMaterialNum(204031);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(4, 4).node(5) = plasticRotCapOfMaterialNum(40000);
 
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(3, 1).node(1) = plasticRotCapOfMaterialNum(302011);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(3, 1).node(2) = plasticRotCapOfMaterialNum(203011);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(3, 1).node(3) = plasticRotCapOfMaterialNum(303011);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(3, 1).node(4) = plasticRotCapOfMaterialNum(49999);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(3, 1).node(5) = plasticRotCapOfMaterialNum(40000);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(3, 2).node(1) = plasticRotCapOfMaterialNum(302021);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(3, 2).node(2) = plasticRotCapOfMaterialNum(203021);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(3, 2).node(3) = plasticRotCapOfMaterialNum(303021);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(3, 2).node(4) = plasticRotCapOfMaterialNum(203011);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(3, 2).node(5) = plasticRotCapOfMaterialNum(40000);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(3, 3).node(1) = plasticRotCapOfMaterialNum(302031);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(3, 3).node(2) = plasticRotCapOfMaterialNum(203031);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(3, 3).node(3) = plasticRotCapOfMaterialNum(303031);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(3, 3).node(4) = plasticRotCapOfMaterialNum(203021);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(3, 3).node(5) = plasticRotCapOfMaterialNum(40000);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(3, 4).node(1) = plasticRotCapOfMaterialNum(302041);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(3, 4).node(2) = plasticRotCapOfMaterialNum(49999);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(3, 4).node(3) = plasticRotCapOfMaterialNum(303041);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(3, 4).node(4) = plasticRotCapOfMaterialNum(203031);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(3, 4).node(5) = plasticRotCapOfMaterialNum(40000);
 
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(2, 1).node(1) = plasticRotCapOfMaterialNum(301011);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(2, 1).node(2) = plasticRotCapOfMaterialNum(202011);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(2, 1).node(3) = plasticRotCapOfMaterialNum(302011);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(2, 1).node(4) = plasticRotCapOfMaterialNum(49999);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(2, 1).node(5) = plasticRotCapOfMaterialNum(40000);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(2, 2).node(1) = plasticRotCapOfMaterialNum(301021);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(2, 2).node(2) = plasticRotCapOfMaterialNum(202021);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(2, 2).node(3) = plasticRotCapOfMaterialNum(302021);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(2, 2).node(4) = plasticRotCapOfMaterialNum(202011);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(2, 2).node(5) = plasticRotCapOfMaterialNum(40000);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(2, 3).node(1) = plasticRotCapOfMaterialNum(301031);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(2, 3).node(2) = plasticRotCapOfMaterialNum(202031);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(2, 3).node(3) = plasticRotCapOfMaterialNum(302031);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(2, 3).node(4) = plasticRotCapOfMaterialNum(202021);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(2, 3).node(5) = plasticRotCapOfMaterialNum(40000);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(2, 4).node(1) = plasticRotCapOfMaterialNum(301041);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(2, 4).node(2) = plasticRotCapOfMaterialNum(49999);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(2, 4).node(3) = plasticRotCapOfMaterialNum(302041);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(2, 4).node(4) = plasticRotCapOfMaterialNum(202031);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(2, 4).node(5) = plasticRotCapOfMaterialNum(40000);
 
     % Define the joint numbers at each location in the frame
         for colLineNum = 1:4
             for floorNum = 2:5
                 buildingInfo{bldgID}.jointNumber(floorNum, colLineNum) = 40000 + (100.0 * floorNum) + colLineNum;
             end
         end
 
      % Define the hinge element numbers that are used at the base columns
         for colLineNum = 1:4
             buildingInfo{bldgID}.hingeElementNumAtColBase(colLineNum) = 6000 + colLineNum * 10 + 2; % The PH Spring at the column base
         end
 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%% Design ID 1009 - END %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Pasted from Excel 2story_ID1001_v.11 on 7-21-06 by Brian Dean
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%% Design ID 1001 - Start %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
 %%%% This code was pasted from the Excel Structural Design Sheet VB output (Dev. by C. Haselton, 6-13-06)
 
% Define General Geometry Information
      bldgID = 1001;
      buildingInfo{bldgID}.bayWidth = 240;
      buildingInfo{bldgID}.storyHeight_firstStory = 180;
      buildingInfo{bldgID}.storyHeight_upperStories = 156;
      buildingInfo{bldgID}.jointWidth = 22;
      buildingInfo{bldgID}.jointWidth = 22; % Just for plotting
      buildingInfo{bldgID}.jointHeight = 18; % Just for plotting
      buildingInfo{bldgID}.numBays = 3;
      buildingInfo{bldgID}.numStories = 2;
      buildingInfo{bldgID}.collapseDriftThreshold = 0.12;
 
% Define the plastic rotation capacities of the column materials
     plasticRotCapOfMaterialNum(302011) = 6.74184088203754E-02;
     plasticRotCapOfMaterialNum(302021) = 6.84892722274857E-02;
     plasticRotCapOfMaterialNum(302031) = 6.84892722274857E-02;
     plasticRotCapOfMaterialNum(302041) = 6.74184088203754E-02;
 
     plasticRotCapOfMaterialNum(301011) = 6.54698173390021E-02;
     plasticRotCapOfMaterialNum(301021) = 6.45874016611658E-02;
     plasticRotCapOfMaterialNum(301031) = 6.45874016611658E-02;
     plasticRotCapOfMaterialNum(301041) = 6.54698173390021E-02;
 
% Define the plastic rotation capacities of the beam materials - make all materials be positive (end in 1)
     plasticRotCapOfMaterialNum(203011) = 7.16129852606202E-02;
     plasticRotCapOfMaterialNum(203021) = 7.16129852606202E-02;
     plasticRotCapOfMaterialNum(203031) = 7.16129852606202E-02;
 
     plasticRotCapOfMaterialNum(202011) = 7.25540756691155E-02;
     plasticRotCapOfMaterialNum(202021) = 7.25540756691155E-02;
     plasticRotCapOfMaterialNum(202031) = 7.25540756691155E-02;
 
% Define the plastic rotation capacities of shear panel material (40000) and the dummy material (49999) used in locations where no element connects to the joint
     plasticRotCapOfMaterialNum(40000) = 99;
     plasticRotCapOfMaterialNum(49999) = 999;
 
% Define the column base rotational spring PHR capacities
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(1, 1).node(1) = plasticRotCapOfMaterialNum(301011);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(1, 2).node(1) = plasticRotCapOfMaterialNum(301021);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(1, 3).node(1) = plasticRotCapOfMaterialNum(301031);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(1, 4).node(1) = plasticRotCapOfMaterialNum(301041);
 
% Define the PHR capacities at all 5 material locations of each joint (4 PHs and 1 shear panel).  When there is not an elements connected to a specific portion of a joint, I use the dummy material #49999.  Make all beam materials be positive (end in 1).
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(3, 1).node(1) = plasticRotCapOfMaterialNum(302011);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(3, 1).node(2) = plasticRotCapOfMaterialNum(203011);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(3, 1).node(3) = plasticRotCapOfMaterialNum(49999);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(3, 1).node(4) = plasticRotCapOfMaterialNum(49999);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(3, 1).node(5) = plasticRotCapOfMaterialNum(40000);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(3, 2).node(1) = plasticRotCapOfMaterialNum(302021);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(3, 2).node(2) = plasticRotCapOfMaterialNum(203021);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(3, 2).node(3) = plasticRotCapOfMaterialNum(49999);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(3, 2).node(4) = plasticRotCapOfMaterialNum(203011);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(3, 2).node(5) = plasticRotCapOfMaterialNum(40000);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(3, 3).node(1) = plasticRotCapOfMaterialNum(302031);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(3, 3).node(2) = plasticRotCapOfMaterialNum(203031);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(3, 3).node(3) = plasticRotCapOfMaterialNum(49999);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(3, 3).node(4) = plasticRotCapOfMaterialNum(203021);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(3, 3).node(5) = plasticRotCapOfMaterialNum(40000);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(3, 4).node(1) = plasticRotCapOfMaterialNum(302041);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(3, 4).node(2) = plasticRotCapOfMaterialNum(49999);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(3, 4).node(3) = plasticRotCapOfMaterialNum(49999);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(3, 4).node(4) = plasticRotCapOfMaterialNum(203031);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(3, 4).node(5) = plasticRotCapOfMaterialNum(40000);
 
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(2, 1).node(1) = plasticRotCapOfMaterialNum(301011);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(2, 1).node(2) = plasticRotCapOfMaterialNum(202011);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(2, 1).node(3) = plasticRotCapOfMaterialNum(302011);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(2, 1).node(4) = plasticRotCapOfMaterialNum(49999);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(2, 1).node(5) = plasticRotCapOfMaterialNum(40000);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(2, 2).node(1) = plasticRotCapOfMaterialNum(301021);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(2, 2).node(2) = plasticRotCapOfMaterialNum(202021);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(2, 2).node(3) = plasticRotCapOfMaterialNum(302021);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(2, 2).node(4) = plasticRotCapOfMaterialNum(202011);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(2, 2).node(5) = plasticRotCapOfMaterialNum(40000);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(2, 3).node(1) = plasticRotCapOfMaterialNum(301031);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(2, 3).node(2) = plasticRotCapOfMaterialNum(202031);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(2, 3).node(3) = plasticRotCapOfMaterialNum(302031);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(2, 3).node(4) = plasticRotCapOfMaterialNum(202021);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(2, 3).node(5) = plasticRotCapOfMaterialNum(40000);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(2, 4).node(1) = plasticRotCapOfMaterialNum(301041);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(2, 4).node(2) = plasticRotCapOfMaterialNum(49999);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(2, 4).node(3) = plasticRotCapOfMaterialNum(302041);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(2, 4).node(4) = plasticRotCapOfMaterialNum(202031);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(2, 4).node(5) = plasticRotCapOfMaterialNum(40000);
 
     % Define the joint numbers at each location in the frame
         for colLineNum = 1:4
             for floorNum = 2:3
                 buildingInfo{bldgID}.jointNumber(floorNum, colLineNum) = 40000 + (100.0 * floorNum) + colLineNum;
             end
         end
 
      % Define the hinge element numbers that are used at the base columns
         for colLineNum = 1:4
             buildingInfo{bldgID}.hingeElementNumAtColBase(colLineNum) = 6000 + colLineNum * 10 + 2; % The PH Spring at the column base
         end
 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%% Design ID 1001 - END %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Pasted from Excel 2story_ID1001a_v.11 on 7-21-06 by Brian Dean
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%% Design ID 1001a - Start %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
 %%%% This code was pasted from the Excel Structural Design Sheet VB output (Dev. by C. Haselton, 6-13-06)
 
% Define General Geometry Information
      bldgID = 1001a;
      buildingInfo{bldgID}.bayWidth = 240;
      buildingInfo{bldgID}.storyHeight_firstStory = 180;
      buildingInfo{bldgID}.storyHeight_upperStories = 156;
      buildingInfo{bldgID}.jointWidth = 22;
      buildingInfo{bldgID}.jointWidth = 22; % Just for plotting
      buildingInfo{bldgID}.jointHeight = 22; % Just for plotting
      buildingInfo{bldgID}.numBays = 3;
      buildingInfo{bldgID}.numStories = 2;
      buildingInfo{bldgID}.collapseDriftThreshold = 0.12;
 
% Define the plastic rotation capacities of the column materials
     plasticRotCapOfMaterialNum(302011) = 6.90970130578215E-02;
     plasticRotCapOfMaterialNum(302021) = 7.03385468372849E-02;
     plasticRotCapOfMaterialNum(302031) = 7.03385468372849E-02;
     plasticRotCapOfMaterialNum(302041) = 6.90970130578215E-02;
 
     plasticRotCapOfMaterialNum(301011) = 6.70999049476087E-02;
     plasticRotCapOfMaterialNum(301021) = 6.63313221047673E-02;
     plasticRotCapOfMaterialNum(301031) = 6.63313221047673E-02;
     plasticRotCapOfMaterialNum(301041) = 6.70999049476087E-02;
 
% Define the plastic rotation capacities of the beam materials - make all materials be positive (end in 1)
     plasticRotCapOfMaterialNum(203011) = 8.24740168861165E-02;
     plasticRotCapOfMaterialNum(203021) = 8.24740168861165E-02;
     plasticRotCapOfMaterialNum(203031) = 8.24740168861165E-02;
 
     plasticRotCapOfMaterialNum(202011) = 5.97373746681642E-02;
     plasticRotCapOfMaterialNum(202021) = 5.97373746681642E-02;
     plasticRotCapOfMaterialNum(202031) = 5.97373746681642E-02;
 
% Define the plastic rotation capacities of shear panel material (40000) and the dummy material (49999) used in locations where no element connects to the joint
     plasticRotCapOfMaterialNum(40000) = 99;
     plasticRotCapOfMaterialNum(49999) = 999;
 
% Define the column base rotational spring PHR capacities
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(1, 1).node(1) = plasticRotCapOfMaterialNum(301011);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(1, 2).node(1) = plasticRotCapOfMaterialNum(301021);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(1, 3).node(1) = plasticRotCapOfMaterialNum(301031);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(1, 4).node(1) = plasticRotCapOfMaterialNum(301041);
 
% Define the PHR capacities at all 5 material locations of each joint (4 PHs and 1 shear panel).  When there is not an elements connected to a specific portion of a joint, I use the dummy material #49999.  Make all beam materials be positive (end in 1).
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(3, 1).node(1) = plasticRotCapOfMaterialNum(302011);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(3, 1).node(2) = plasticRotCapOfMaterialNum(203011);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(3, 1).node(3) = plasticRotCapOfMaterialNum(49999);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(3, 1).node(4) = plasticRotCapOfMaterialNum(49999);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(3, 1).node(5) = plasticRotCapOfMaterialNum(40000);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(3, 2).node(1) = plasticRotCapOfMaterialNum(302021);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(3, 2).node(2) = plasticRotCapOfMaterialNum(203021);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(3, 2).node(3) = plasticRotCapOfMaterialNum(49999);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(3, 2).node(4) = plasticRotCapOfMaterialNum(203011);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(3, 2).node(5) = plasticRotCapOfMaterialNum(40000);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(3, 3).node(1) = plasticRotCapOfMaterialNum(302031);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(3, 3).node(2) = plasticRotCapOfMaterialNum(203031);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(3, 3).node(3) = plasticRotCapOfMaterialNum(49999);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(3, 3).node(4) = plasticRotCapOfMaterialNum(203021);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(3, 3).node(5) = plasticRotCapOfMaterialNum(40000);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(3, 4).node(1) = plasticRotCapOfMaterialNum(302041);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(3, 4).node(2) = plasticRotCapOfMaterialNum(49999);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(3, 4).node(3) = plasticRotCapOfMaterialNum(49999);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(3, 4).node(4) = plasticRotCapOfMaterialNum(203031);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(3, 4).node(5) = plasticRotCapOfMaterialNum(40000);
 
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(2, 1).node(1) = plasticRotCapOfMaterialNum(301011);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(2, 1).node(2) = plasticRotCapOfMaterialNum(202011);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(2, 1).node(3) = plasticRotCapOfMaterialNum(302011);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(2, 1).node(4) = plasticRotCapOfMaterialNum(49999);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(2, 1).node(5) = plasticRotCapOfMaterialNum(40000);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(2, 2).node(1) = plasticRotCapOfMaterialNum(301021);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(2, 2).node(2) = plasticRotCapOfMaterialNum(202021);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(2, 2).node(3) = plasticRotCapOfMaterialNum(302021);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(2, 2).node(4) = plasticRotCapOfMaterialNum(202011);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(2, 2).node(5) = plasticRotCapOfMaterialNum(40000);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(2, 3).node(1) = plasticRotCapOfMaterialNum(301031);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(2, 3).node(2) = plasticRotCapOfMaterialNum(202031);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(2, 3).node(3) = plasticRotCapOfMaterialNum(302031);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(2, 3).node(4) = plasticRotCapOfMaterialNum(202021);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(2, 3).node(5) = plasticRotCapOfMaterialNum(40000);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(2, 4).node(1) = plasticRotCapOfMaterialNum(301041);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(2, 4).node(2) = plasticRotCapOfMaterialNum(49999);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(2, 4).node(3) = plasticRotCapOfMaterialNum(302041);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(2, 4).node(4) = plasticRotCapOfMaterialNum(202031);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(2, 4).node(5) = plasticRotCapOfMaterialNum(40000);
 
     % Define the joint numbers at each location in the frame
         for colLineNum = 1:4
             for floorNum = 2:3
                 buildingInfo{bldgID}.jointNumber(floorNum, colLineNum) = 40000 + (100.0 * floorNum) + colLineNum;
             end
         end
 
      % Define the hinge element numbers that are used at the base columns
         for colLineNum = 1:4
             buildingInfo{bldgID}.hingeElementNumAtColBase(colLineNum) = 6000 + colLineNum * 10 + 2; % The PH Spring at the column base
         end
 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%% Design ID 1001a - END %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Pasted from Excel 2story_ID1002_v.11 on 7-21-06 by Brian Dean
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%% Design ID 1002 - Start %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
 %%%% This code was pasted from the Excel Structural Design Sheet VB output (Dev. by C. Haselton, 6-13-06)
 
% Define General Geometry Information
      bldgID = 1002;
      buildingInfo{bldgID}.bayWidth = 240;
      buildingInfo{bldgID}.storyHeight_firstStory = 180;
      buildingInfo{bldgID}.storyHeight_upperStories = 156;
      buildingInfo{bldgID}.jointWidth = 22;
      buildingInfo{bldgID}.jointWidth = 22; % Just for plotting
      buildingInfo{bldgID}.jointHeight = 18; % Just for plotting
      buildingInfo{bldgID}.numBays = 3;
      buildingInfo{bldgID}.numStories = 2;
      buildingInfo{bldgID}.collapseDriftThreshold = 0.12;
 
% Define the plastic rotation capacities of the column materials
     plasticRotCapOfMaterialNum(302011) = 6.70051686059644E-02;
     plasticRotCapOfMaterialNum(302021) = 6.62798500329048E-02;
     plasticRotCapOfMaterialNum(302031) = 6.62798500329048E-02;
     plasticRotCapOfMaterialNum(302041) = 6.70051686059644E-02;
 
     plasticRotCapOfMaterialNum(301011) = 6.50685209894145E-02;
     plasticRotCapOfMaterialNum(301021) = 6.25038514338176E-02;
     plasticRotCapOfMaterialNum(301031) = 6.25038514338176E-02;
     plasticRotCapOfMaterialNum(301041) = 6.50685209894145E-02;
 
% Define the plastic rotation capacities of the beam materials - make all materials be positive (end in 1)
     plasticRotCapOfMaterialNum(203011) = 0.070805090696057;
     plasticRotCapOfMaterialNum(203021) = 0.070805090696057;
     plasticRotCapOfMaterialNum(203031) = 0.070805090696057;
 
     plasticRotCapOfMaterialNum(202011) = 7.21715401615428E-02;
     plasticRotCapOfMaterialNum(202021) = 7.21715401615428E-02;
     plasticRotCapOfMaterialNum(202031) = 7.21715401615428E-02;
 
% Define the plastic rotation capacities of shear panel material (40000) and the dummy material (49999) used in locations where no element connects to the joint
     plasticRotCapOfMaterialNum(40000) = 99;
     plasticRotCapOfMaterialNum(49999) = 999;
 
% Define the column base rotational spring PHR capacities
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(1, 1).node(1) = plasticRotCapOfMaterialNum(301011);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(1, 2).node(1) = plasticRotCapOfMaterialNum(301021);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(1, 3).node(1) = plasticRotCapOfMaterialNum(301031);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(1, 4).node(1) = plasticRotCapOfMaterialNum(301041);
 
% Define the PHR capacities at all 5 material locations of each joint (4 PHs and 1 shear panel).  When there is not an elements connected to a specific portion of a joint, I use the dummy material #49999.  Make all beam materials be positive (end in 1).
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(3, 1).node(1) = plasticRotCapOfMaterialNum(302011);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(3, 1).node(2) = plasticRotCapOfMaterialNum(203011);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(3, 1).node(3) = plasticRotCapOfMaterialNum(49999);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(3, 1).node(4) = plasticRotCapOfMaterialNum(49999);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(3, 1).node(5) = plasticRotCapOfMaterialNum(40000);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(3, 2).node(1) = plasticRotCapOfMaterialNum(302021);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(3, 2).node(2) = plasticRotCapOfMaterialNum(203021);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(3, 2).node(3) = plasticRotCapOfMaterialNum(49999);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(3, 2).node(4) = plasticRotCapOfMaterialNum(203011);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(3, 2).node(5) = plasticRotCapOfMaterialNum(40000);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(3, 3).node(1) = plasticRotCapOfMaterialNum(302031);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(3, 3).node(2) = plasticRotCapOfMaterialNum(203031);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(3, 3).node(3) = plasticRotCapOfMaterialNum(49999);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(3, 3).node(4) = plasticRotCapOfMaterialNum(203021);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(3, 3).node(5) = plasticRotCapOfMaterialNum(40000);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(3, 4).node(1) = plasticRotCapOfMaterialNum(302041);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(3, 4).node(2) = plasticRotCapOfMaterialNum(49999);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(3, 4).node(3) = plasticRotCapOfMaterialNum(49999);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(3, 4).node(4) = plasticRotCapOfMaterialNum(203031);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(3, 4).node(5) = plasticRotCapOfMaterialNum(40000);
 
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(2, 1).node(1) = plasticRotCapOfMaterialNum(301011);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(2, 1).node(2) = plasticRotCapOfMaterialNum(202011);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(2, 1).node(3) = plasticRotCapOfMaterialNum(302011);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(2, 1).node(4) = plasticRotCapOfMaterialNum(49999);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(2, 1).node(5) = plasticRotCapOfMaterialNum(40000);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(2, 2).node(1) = plasticRotCapOfMaterialNum(301021);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(2, 2).node(2) = plasticRotCapOfMaterialNum(202021);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(2, 2).node(3) = plasticRotCapOfMaterialNum(302021);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(2, 2).node(4) = plasticRotCapOfMaterialNum(202011);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(2, 2).node(5) = plasticRotCapOfMaterialNum(40000);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(2, 3).node(1) = plasticRotCapOfMaterialNum(301031);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(2, 3).node(2) = plasticRotCapOfMaterialNum(202031);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(2, 3).node(3) = plasticRotCapOfMaterialNum(302031);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(2, 3).node(4) = plasticRotCapOfMaterialNum(202021);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(2, 3).node(5) = plasticRotCapOfMaterialNum(40000);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(2, 4).node(1) = plasticRotCapOfMaterialNum(301041);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(2, 4).node(2) = plasticRotCapOfMaterialNum(49999);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(2, 4).node(3) = plasticRotCapOfMaterialNum(302041);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(2, 4).node(4) = plasticRotCapOfMaterialNum(202031);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(2, 4).node(5) = plasticRotCapOfMaterialNum(40000);
 
     % Define the joint numbers at each location in the frame
         for colLineNum = 1:4
             for floorNum = 2:3
                 buildingInfo{bldgID}.jointNumber(floorNum, colLineNum) = 40000 + (100.0 * floorNum) + colLineNum;
             end
         end
 
      % Define the hinge element numbers that are used at the base columns
         for colLineNum = 1:4
             buildingInfo{bldgID}.hingeElementNumAtColBase(colLineNum) = 6000 + colLineNum * 10 + 2; % The PH Spring at the column base
         end
 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%% Design ID 1002 - END %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Pasted from Excel 4story_ID1004_v.51 on 7-26-06 by Brian Dean
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%% Design ID 1004 - Start %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
 %%%% This code was pasted from the Excel Structural Design Sheet VB output (Dev. by C. Haselton, 6-13-06)
 
% Define General Geometry Information
      bldgID = 1004;
      buildingInfo{bldgID}.bayWidth = 240;
      buildingInfo{bldgID}.storyHeight_firstStory = 180;
      buildingInfo{bldgID}.storyHeight_upperStories = 156;
      buildingInfo{bldgID}.jointWidth = 30;
      buildingInfo{bldgID}.jointWidth = 30; % Just for plotting
      buildingInfo{bldgID}.jointHeight = 24; % Just for plotting
      buildingInfo{bldgID}.numBays = 3;
      buildingInfo{bldgID}.numStories = 4;
      buildingInfo{bldgID}.collapseDriftThreshold = 0.12;
 
% Define the plastic rotation capacities of the column materials
     plasticRotCapOfMaterialNum(304011) = 8.21421842415638E-02;
     plasticRotCapOfMaterialNum(304021) = 8.77174246647755E-02;
     plasticRotCapOfMaterialNum(304031) = 8.77174246647755E-02;
     plasticRotCapOfMaterialNum(304041) = 8.21421842415638E-02;
 
     plasticRotCapOfMaterialNum(303011) = 8.17095394029177E-02;
     plasticRotCapOfMaterialNum(303021) = 8.69890486160127E-02;
     plasticRotCapOfMaterialNum(303031) = 8.69890486160127E-02;
     plasticRotCapOfMaterialNum(303041) = 8.17095394029177E-02;
 
     plasticRotCapOfMaterialNum(302011) = 8.12791733149298E-02;
     plasticRotCapOfMaterialNum(302021) = 0.086266720757452;
     plasticRotCapOfMaterialNum(302031) = 0.086266720757452;
     plasticRotCapOfMaterialNum(302041) = 8.12791733149298E-02;
 
     plasticRotCapOfMaterialNum(301011) = 8.08510739753661E-02;
     plasticRotCapOfMaterialNum(301021) = 8.55503908669522E-02;
     plasticRotCapOfMaterialNum(301031) = 8.55503908669522E-02;
     plasticRotCapOfMaterialNum(301041) = 8.08510739753661E-02;
 
% Define the plastic rotation capacities of the beam materials - make all materials be positive (end in 1)
     plasticRotCapOfMaterialNum(205011) = 6.48385686753031E-02;
     plasticRotCapOfMaterialNum(205021) = 6.50876201463047E-02;
     plasticRotCapOfMaterialNum(205031) = 6.48385686753031E-02;
 
     plasticRotCapOfMaterialNum(204011) = 6.48385686753031E-02;
     plasticRotCapOfMaterialNum(204021) = 6.50876201463047E-02;
     plasticRotCapOfMaterialNum(204031) = 6.48385686753031E-02;
 
     plasticRotCapOfMaterialNum(203011) = 6.48385686753031E-02;
     plasticRotCapOfMaterialNum(203021) = 6.50876201463047E-02;
     plasticRotCapOfMaterialNum(203031) = 6.48385686753031E-02;
 
     plasticRotCapOfMaterialNum(202011) = 6.48385686753031E-02;
     plasticRotCapOfMaterialNum(202021) = 6.50876201463047E-02;
     plasticRotCapOfMaterialNum(202031) = 6.48385686753031E-02;
 
% Define the plastic rotation capacities of shear panel material (40000) and the dummy material (49999) used in locations where no element connects to the joint
     plasticRotCapOfMaterialNum(40000) = 99;
     plasticRotCapOfMaterialNum(49999) = 999;
 
% Define the column base rotational spring PHR capacities
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(1, 1).node(1) = plasticRotCapOfMaterialNum(301011);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(1, 2).node(1) = plasticRotCapOfMaterialNum(301021);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(1, 3).node(1) = plasticRotCapOfMaterialNum(301031);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(1, 4).node(1) = plasticRotCapOfMaterialNum(301041);
 
% Define the PHR capacities at all 5 material locations of each joint (4 PHs and 1 shear panel).  When there is not an elements connected to a specific portion of a joint, I use the dummy material #49999.  Make all beam materials be positive (end in 1).
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(5, 1).node(1) = plasticRotCapOfMaterialNum(304011);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(5, 1).node(2) = plasticRotCapOfMaterialNum(205011);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(5, 1).node(3) = plasticRotCapOfMaterialNum(49999);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(5, 1).node(4) = plasticRotCapOfMaterialNum(49999);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(5, 1).node(5) = plasticRotCapOfMaterialNum(40000);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(5, 2).node(1) = plasticRotCapOfMaterialNum(304021);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(5, 2).node(2) = plasticRotCapOfMaterialNum(205021);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(5, 2).node(3) = plasticRotCapOfMaterialNum(49999);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(5, 2).node(4) = plasticRotCapOfMaterialNum(205011);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(5, 2).node(5) = plasticRotCapOfMaterialNum(40000);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(5, 3).node(1) = plasticRotCapOfMaterialNum(304031);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(5, 3).node(2) = plasticRotCapOfMaterialNum(205031);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(5, 3).node(3) = plasticRotCapOfMaterialNum(49999);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(5, 3).node(4) = plasticRotCapOfMaterialNum(205021);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(5, 3).node(5) = plasticRotCapOfMaterialNum(40000);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(5, 4).node(1) = plasticRotCapOfMaterialNum(304041);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(5, 4).node(2) = plasticRotCapOfMaterialNum(49999);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(5, 4).node(3) = plasticRotCapOfMaterialNum(49999);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(5, 4).node(4) = plasticRotCapOfMaterialNum(205031);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(5, 4).node(5) = plasticRotCapOfMaterialNum(40000);
 
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(4, 1).node(1) = plasticRotCapOfMaterialNum(303011);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(4, 1).node(2) = plasticRotCapOfMaterialNum(204011);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(4, 1).node(3) = plasticRotCapOfMaterialNum(304011);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(4, 1).node(4) = plasticRotCapOfMaterialNum(49999);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(4, 1).node(5) = plasticRotCapOfMaterialNum(40000);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(4, 2).node(1) = plasticRotCapOfMaterialNum(303021);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(4, 2).node(2) = plasticRotCapOfMaterialNum(204021);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(4, 2).node(3) = plasticRotCapOfMaterialNum(304021);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(4, 2).node(4) = plasticRotCapOfMaterialNum(204011);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(4, 2).node(5) = plasticRotCapOfMaterialNum(40000);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(4, 3).node(1) = plasticRotCapOfMaterialNum(303031);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(4, 3).node(2) = plasticRotCapOfMaterialNum(204031);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(4, 3).node(3) = plasticRotCapOfMaterialNum(304031);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(4, 3).node(4) = plasticRotCapOfMaterialNum(204021);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(4, 3).node(5) = plasticRotCapOfMaterialNum(40000);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(4, 4).node(1) = plasticRotCapOfMaterialNum(303041);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(4, 4).node(2) = plasticRotCapOfMaterialNum(49999);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(4, 4).node(3) = plasticRotCapOfMaterialNum(304041);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(4, 4).node(4) = plasticRotCapOfMaterialNum(204031);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(4, 4).node(5) = plasticRotCapOfMaterialNum(40000);
 
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(3, 1).node(1) = plasticRotCapOfMaterialNum(302011);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(3, 1).node(2) = plasticRotCapOfMaterialNum(203011);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(3, 1).node(3) = plasticRotCapOfMaterialNum(303011);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(3, 1).node(4) = plasticRotCapOfMaterialNum(49999);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(3, 1).node(5) = plasticRotCapOfMaterialNum(40000);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(3, 2).node(1) = plasticRotCapOfMaterialNum(302021);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(3, 2).node(2) = plasticRotCapOfMaterialNum(203021);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(3, 2).node(3) = plasticRotCapOfMaterialNum(303021);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(3, 2).node(4) = plasticRotCapOfMaterialNum(203011);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(3, 2).node(5) = plasticRotCapOfMaterialNum(40000);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(3, 3).node(1) = plasticRotCapOfMaterialNum(302031);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(3, 3).node(2) = plasticRotCapOfMaterialNum(203031);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(3, 3).node(3) = plasticRotCapOfMaterialNum(303031);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(3, 3).node(4) = plasticRotCapOfMaterialNum(203021);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(3, 3).node(5) = plasticRotCapOfMaterialNum(40000);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(3, 4).node(1) = plasticRotCapOfMaterialNum(302041);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(3, 4).node(2) = plasticRotCapOfMaterialNum(49999);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(3, 4).node(3) = plasticRotCapOfMaterialNum(303041);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(3, 4).node(4) = plasticRotCapOfMaterialNum(203031);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(3, 4).node(5) = plasticRotCapOfMaterialNum(40000);
 
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(2, 1).node(1) = plasticRotCapOfMaterialNum(301011);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(2, 1).node(2) = plasticRotCapOfMaterialNum(202011);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(2, 1).node(3) = plasticRotCapOfMaterialNum(302011);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(2, 1).node(4) = plasticRotCapOfMaterialNum(49999);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(2, 1).node(5) = plasticRotCapOfMaterialNum(40000);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(2, 2).node(1) = plasticRotCapOfMaterialNum(301021);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(2, 2).node(2) = plasticRotCapOfMaterialNum(202021);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(2, 2).node(3) = plasticRotCapOfMaterialNum(302021);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(2, 2).node(4) = plasticRotCapOfMaterialNum(202011);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(2, 2).node(5) = plasticRotCapOfMaterialNum(40000);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(2, 3).node(1) = plasticRotCapOfMaterialNum(301031);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(2, 3).node(2) = plasticRotCapOfMaterialNum(202031);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(2, 3).node(3) = plasticRotCapOfMaterialNum(302031);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(2, 3).node(4) = plasticRotCapOfMaterialNum(202021);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(2, 3).node(5) = plasticRotCapOfMaterialNum(40000);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(2, 4).node(1) = plasticRotCapOfMaterialNum(301041);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(2, 4).node(2) = plasticRotCapOfMaterialNum(49999);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(2, 4).node(3) = plasticRotCapOfMaterialNum(302041);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(2, 4).node(4) = plasticRotCapOfMaterialNum(202031);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(2, 4).node(5) = plasticRotCapOfMaterialNum(40000);
 
     % Define the joint numbers at each location in the frame
         for colLineNum = 1:4
             for floorNum = 2:5
                 buildingInfo{bldgID}.jointNumber(floorNum, colLineNum) = 40000 + (100.0 * floorNum) + colLineNum;
             end
         end
 
      % Define the hinge element numbers that are used at the base columns
         for colLineNum = 1:4
             buildingInfo{bldgID}.hingeElementNumAtColBase(colLineNum) = 6000 + colLineNum * 10 + 2; % The PH Spring at the column base
         end
 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%% Design ID 1004 - END %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


% Pasted from Excel 12story_ID1015_v.61 on 7-21-06 by Brian Dean
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%% Design ID 1015 - Start %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
 %%%% This code was pasted from the Excel Structural Design Sheet VB output (Dev. by C. Haselton, 6-13-06)
 
% Define General Geometry Information
      bldgID = 1015;
      buildingInfo{bldgID}.bayWidth = 240;
      buildingInfo{bldgID}.storyHeight_firstStory = 180;
      buildingInfo{bldgID}.storyHeight_upperStories = 156;
      buildingInfo{bldgID}.jointWidth = 22;
      buildingInfo{bldgID}.jointWidth = 22; % Just for plotting
      buildingInfo{bldgID}.jointHeight = 28; % Just for plotting
      buildingInfo{bldgID}.numBays = 3;
      buildingInfo{bldgID}.numStories = 12;
      buildingInfo{bldgID}.collapseDriftThreshold = 0.12;
 
% Define the plastic rotation capacities of the column materials
     plasticRotCapOfMaterialNum(312011) = 7.08174116988329E-02;
     plasticRotCapOfMaterialNum(312021) = 7.37335049139624E-02;
     plasticRotCapOfMaterialNum(312031) = 7.37335049139624E-02;
     plasticRotCapOfMaterialNum(312041) = 7.08174116988329E-02;
 
     plasticRotCapOfMaterialNum(311011) = 6.87705789778633E-02;
     plasticRotCapOfMaterialNum(311021) = 6.95328675992629E-02;
     plasticRotCapOfMaterialNum(311031) = 6.95328675992629E-02;
     plasticRotCapOfMaterialNum(311041) = 6.87705789778633E-02;
 
     plasticRotCapOfMaterialNum(310011) = 6.67829057783606E-02;
     plasticRotCapOfMaterialNum(310021) = 6.55715428449827E-02;
     plasticRotCapOfMaterialNum(310031) = 6.55715428449827E-02;
     plasticRotCapOfMaterialNum(310041) = 6.67829057783606E-02;
 
     plasticRotCapOfMaterialNum(309011) = 6.48526822151231E-02;
     plasticRotCapOfMaterialNum(309021) = 6.18358968862227E-02;
     plasticRotCapOfMaterialNum(309031) = 6.18358968862227E-02;
     plasticRotCapOfMaterialNum(309041) = 6.48526822151231E-02;
 
     plasticRotCapOfMaterialNum(308011) = 6.29782478236901E-02;
     plasticRotCapOfMaterialNum(308021) = 5.83130726809815E-02;
     plasticRotCapOfMaterialNum(308031) = 5.83130726809815E-02;
     plasticRotCapOfMaterialNum(308041) = 6.29782478236901E-02;
 
     plasticRotCapOfMaterialNum(307011) = 6.11579901319368E-02;
     plasticRotCapOfMaterialNum(307021) = 0.054990945659835;
     plasticRotCapOfMaterialNum(307031) = 0.054990945659835;
     plasticRotCapOfMaterialNum(307041) = 6.11579901319368E-02;
 
     plasticRotCapOfMaterialNum(306011) = 5.93903432729533E-02;
     plasticRotCapOfMaterialNum(306021) = 0.051858081996581;
     plasticRotCapOfMaterialNum(306031) = 0.051858081996581;
     plasticRotCapOfMaterialNum(306041) = 5.93903432729533E-02;
 
     plasticRotCapOfMaterialNum(305011) = 5.76737866380162E-02;
     plasticRotCapOfMaterialNum(305021) = 4.89036992562274E-02;
     plasticRotCapOfMaterialNum(305031) = 4.89036992562274E-02;
     plasticRotCapOfMaterialNum(305041) = 5.76737866380162E-02;
 
     plasticRotCapOfMaterialNum(304011) = 5.60068435684934E-02;
     plasticRotCapOfMaterialNum(304021) = 4.61176292848859E-02;
     plasticRotCapOfMaterialNum(304031) = 4.61176292848859E-02;
     plasticRotCapOfMaterialNum(304041) = 5.60068435684934E-02;
 
     plasticRotCapOfMaterialNum(303011) = 0.054388080085556;
     plasticRotCapOfMaterialNum(303021) = 4.34902832138478E-02;
     plasticRotCapOfMaterialNum(303031) = 4.34902832138478E-02;
     plasticRotCapOfMaterialNum(303041) = 0.054388080085556;
 
     plasticRotCapOfMaterialNum(302011) = 5.28161036566057E-02;
     plasticRotCapOfMaterialNum(302021) = 4.10126184573967E-02;
     plasticRotCapOfMaterialNum(302031) = 4.10126184573967E-02;
     plasticRotCapOfMaterialNum(302041) = 5.28161036566057E-02;
 
     plasticRotCapOfMaterialNum(301011) = 5.12895619973566E-02;
     plasticRotCapOfMaterialNum(301021) = 3.86761075907737E-02;
     plasticRotCapOfMaterialNum(301031) = 3.86761075907737E-02;
     plasticRotCapOfMaterialNum(301041) = 5.12895619973566E-02;
 
% Define the plastic rotation capacities of the beam materials - make all materials be positive (end in 1)
     plasticRotCapOfMaterialNum(213011) = 6.14615753543112E-02;
     plasticRotCapOfMaterialNum(213021) = 6.14615753543112E-02;
     plasticRotCapOfMaterialNum(213031) = 6.14615753543112E-02;
 
     plasticRotCapOfMaterialNum(212011) = 6.14615753543112E-02;
     plasticRotCapOfMaterialNum(212021) = 6.14615753543112E-02;
     plasticRotCapOfMaterialNum(212031) = 6.14615753543112E-02;
 
     plasticRotCapOfMaterialNum(211011) = 6.14615753543112E-02;
     plasticRotCapOfMaterialNum(211021) = 6.14615753543112E-02;
     plasticRotCapOfMaterialNum(211031) = 6.14615753543112E-02;
 
     plasticRotCapOfMaterialNum(210011) = 6.14615753543112E-02;
     plasticRotCapOfMaterialNum(210021) = 6.14615753543112E-02;
     plasticRotCapOfMaterialNum(210031) = 6.14615753543112E-02;
 
     plasticRotCapOfMaterialNum(209011) = 6.14615753543112E-02;
     plasticRotCapOfMaterialNum(209021) = 6.14615753543112E-02;
     plasticRotCapOfMaterialNum(209031) = 6.14615753543112E-02;
 
     plasticRotCapOfMaterialNum(208011) = 6.14615753543112E-02;
     plasticRotCapOfMaterialNum(208021) = 6.14615753543112E-02;
     plasticRotCapOfMaterialNum(208031) = 6.14615753543112E-02;
 
     plasticRotCapOfMaterialNum(207011) = 6.14615753543112E-02;
     plasticRotCapOfMaterialNum(207021) = 6.14615753543112E-02;
     plasticRotCapOfMaterialNum(207031) = 6.14615753543112E-02;
 
     plasticRotCapOfMaterialNum(206011) = 6.14615753543112E-02;
     plasticRotCapOfMaterialNum(206021) = 6.14615753543112E-02;
     plasticRotCapOfMaterialNum(206031) = 6.14615753543112E-02;
 
     plasticRotCapOfMaterialNum(205011) = 6.14615753543112E-02;
     plasticRotCapOfMaterialNum(205021) = 6.14615753543112E-02;
     plasticRotCapOfMaterialNum(205031) = 6.14615753543112E-02;
 
     plasticRotCapOfMaterialNum(204011) = 6.14615753543112E-02;
     plasticRotCapOfMaterialNum(204021) = 6.14615753543112E-02;
     plasticRotCapOfMaterialNum(204031) = 6.14615753543112E-02;
 
     plasticRotCapOfMaterialNum(203011) = 6.14615753543112E-02;
     plasticRotCapOfMaterialNum(203021) = 6.14615753543112E-02;
     plasticRotCapOfMaterialNum(203031) = 6.14615753543112E-02;
 
     plasticRotCapOfMaterialNum(202011) = 6.14615753543112E-02;
     plasticRotCapOfMaterialNum(202021) = 6.14615753543112E-02;
     plasticRotCapOfMaterialNum(202031) = 6.14615753543112E-02;
 
% Define the plastic rotation capacities of shear panel material (40000) and the dummy material (49999) used in locations where no element connects to the joint
     plasticRotCapOfMaterialNum(40000) = 99;
     plasticRotCapOfMaterialNum(49999) = 999;
 
% Define the column base rotational spring PHR capacities
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(1, 1).node(1) = plasticRotCapOfMaterialNum(301011);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(1, 2).node(1) = plasticRotCapOfMaterialNum(301021);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(1, 3).node(1) = plasticRotCapOfMaterialNum(301031);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(1, 4).node(1) = plasticRotCapOfMaterialNum(301041);
 
% Define the PHR capacities at all 5 material locations of each joint (4 PHs and 1 shear panel).  When there is not an elements connected to a specific portion of a joint, I use the dummy material #49999.  Make all beam materials be positive (end in 1).
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(13, 1).node(1) = plasticRotCapOfMaterialNum(312011);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(13, 1).node(2) = plasticRotCapOfMaterialNum(213011);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(13, 1).node(3) = plasticRotCapOfMaterialNum(49999);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(13, 1).node(4) = plasticRotCapOfMaterialNum(49999);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(13, 1).node(5) = plasticRotCapOfMaterialNum(40000);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(13, 2).node(1) = plasticRotCapOfMaterialNum(312021);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(13, 2).node(2) = plasticRotCapOfMaterialNum(213021);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(13, 2).node(3) = plasticRotCapOfMaterialNum(49999);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(13, 2).node(4) = plasticRotCapOfMaterialNum(213011);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(13, 2).node(5) = plasticRotCapOfMaterialNum(40000);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(13, 3).node(1) = plasticRotCapOfMaterialNum(312031);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(13, 3).node(2) = plasticRotCapOfMaterialNum(213031);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(13, 3).node(3) = plasticRotCapOfMaterialNum(49999);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(13, 3).node(4) = plasticRotCapOfMaterialNum(213021);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(13, 3).node(5) = plasticRotCapOfMaterialNum(40000);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(13, 4).node(1) = plasticRotCapOfMaterialNum(312041);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(13, 4).node(2) = plasticRotCapOfMaterialNum(49999);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(13, 4).node(3) = plasticRotCapOfMaterialNum(49999);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(13, 4).node(4) = plasticRotCapOfMaterialNum(213031);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(13, 4).node(5) = plasticRotCapOfMaterialNum(40000);
 
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(12, 1).node(1) = plasticRotCapOfMaterialNum(311011);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(12, 1).node(2) = plasticRotCapOfMaterialNum(212011);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(12, 1).node(3) = plasticRotCapOfMaterialNum(312011);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(12, 1).node(4) = plasticRotCapOfMaterialNum(49999);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(12, 1).node(5) = plasticRotCapOfMaterialNum(40000);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(12, 2).node(1) = plasticRotCapOfMaterialNum(311021);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(12, 2).node(2) = plasticRotCapOfMaterialNum(212021);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(12, 2).node(3) = plasticRotCapOfMaterialNum(312021);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(12, 2).node(4) = plasticRotCapOfMaterialNum(212011);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(12, 2).node(5) = plasticRotCapOfMaterialNum(40000);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(12, 3).node(1) = plasticRotCapOfMaterialNum(311031);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(12, 3).node(2) = plasticRotCapOfMaterialNum(212031);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(12, 3).node(3) = plasticRotCapOfMaterialNum(312031);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(12, 3).node(4) = plasticRotCapOfMaterialNum(212021);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(12, 3).node(5) = plasticRotCapOfMaterialNum(40000);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(12, 4).node(1) = plasticRotCapOfMaterialNum(311041);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(12, 4).node(2) = plasticRotCapOfMaterialNum(49999);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(12, 4).node(3) = plasticRotCapOfMaterialNum(312041);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(12, 4).node(4) = plasticRotCapOfMaterialNum(212031);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(12, 4).node(5) = plasticRotCapOfMaterialNum(40000);
 
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(11, 1).node(1) = plasticRotCapOfMaterialNum(310011);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(11, 1).node(2) = plasticRotCapOfMaterialNum(211011);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(11, 1).node(3) = plasticRotCapOfMaterialNum(311011);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(11, 1).node(4) = plasticRotCapOfMaterialNum(49999);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(11, 1).node(5) = plasticRotCapOfMaterialNum(40000);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(11, 2).node(1) = plasticRotCapOfMaterialNum(310021);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(11, 2).node(2) = plasticRotCapOfMaterialNum(211021);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(11, 2).node(3) = plasticRotCapOfMaterialNum(311021);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(11, 2).node(4) = plasticRotCapOfMaterialNum(211011);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(11, 2).node(5) = plasticRotCapOfMaterialNum(40000);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(11, 3).node(1) = plasticRotCapOfMaterialNum(310031);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(11, 3).node(2) = plasticRotCapOfMaterialNum(211031);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(11, 3).node(3) = plasticRotCapOfMaterialNum(311031);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(11, 3).node(4) = plasticRotCapOfMaterialNum(211021);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(11, 3).node(5) = plasticRotCapOfMaterialNum(40000);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(11, 4).node(1) = plasticRotCapOfMaterialNum(310041);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(11, 4).node(2) = plasticRotCapOfMaterialNum(49999);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(11, 4).node(3) = plasticRotCapOfMaterialNum(311041);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(11, 4).node(4) = plasticRotCapOfMaterialNum(211031);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(11, 4).node(5) = plasticRotCapOfMaterialNum(40000);
 
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(10, 1).node(1) = plasticRotCapOfMaterialNum(309011);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(10, 1).node(2) = plasticRotCapOfMaterialNum(210011);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(10, 1).node(3) = plasticRotCapOfMaterialNum(310011);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(10, 1).node(4) = plasticRotCapOfMaterialNum(49999);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(10, 1).node(5) = plasticRotCapOfMaterialNum(40000);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(10, 2).node(1) = plasticRotCapOfMaterialNum(309021);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(10, 2).node(2) = plasticRotCapOfMaterialNum(210021);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(10, 2).node(3) = plasticRotCapOfMaterialNum(310021);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(10, 2).node(4) = plasticRotCapOfMaterialNum(210011);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(10, 2).node(5) = plasticRotCapOfMaterialNum(40000);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(10, 3).node(1) = plasticRotCapOfMaterialNum(309031);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(10, 3).node(2) = plasticRotCapOfMaterialNum(210031);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(10, 3).node(3) = plasticRotCapOfMaterialNum(310031);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(10, 3).node(4) = plasticRotCapOfMaterialNum(210021);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(10, 3).node(5) = plasticRotCapOfMaterialNum(40000);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(10, 4).node(1) = plasticRotCapOfMaterialNum(309041);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(10, 4).node(2) = plasticRotCapOfMaterialNum(49999);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(10, 4).node(3) = plasticRotCapOfMaterialNum(310041);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(10, 4).node(4) = plasticRotCapOfMaterialNum(210031);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(10, 4).node(5) = plasticRotCapOfMaterialNum(40000);
 
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(9, 1).node(1) = plasticRotCapOfMaterialNum(308011);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(9, 1).node(2) = plasticRotCapOfMaterialNum(209011);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(9, 1).node(3) = plasticRotCapOfMaterialNum(309011);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(9, 1).node(4) = plasticRotCapOfMaterialNum(49999);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(9, 1).node(5) = plasticRotCapOfMaterialNum(40000);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(9, 2).node(1) = plasticRotCapOfMaterialNum(308021);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(9, 2).node(2) = plasticRotCapOfMaterialNum(209021);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(9, 2).node(3) = plasticRotCapOfMaterialNum(309021);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(9, 2).node(4) = plasticRotCapOfMaterialNum(209011);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(9, 2).node(5) = plasticRotCapOfMaterialNum(40000);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(9, 3).node(1) = plasticRotCapOfMaterialNum(308031);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(9, 3).node(2) = plasticRotCapOfMaterialNum(209031);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(9, 3).node(3) = plasticRotCapOfMaterialNum(309031);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(9, 3).node(4) = plasticRotCapOfMaterialNum(209021);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(9, 3).node(5) = plasticRotCapOfMaterialNum(40000);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(9, 4).node(1) = plasticRotCapOfMaterialNum(308041);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(9, 4).node(2) = plasticRotCapOfMaterialNum(49999);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(9, 4).node(3) = plasticRotCapOfMaterialNum(309041);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(9, 4).node(4) = plasticRotCapOfMaterialNum(209031);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(9, 4).node(5) = plasticRotCapOfMaterialNum(40000);
 
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(8, 1).node(1) = plasticRotCapOfMaterialNum(307011);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(8, 1).node(2) = plasticRotCapOfMaterialNum(208011);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(8, 1).node(3) = plasticRotCapOfMaterialNum(308011);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(8, 1).node(4) = plasticRotCapOfMaterialNum(49999);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(8, 1).node(5) = plasticRotCapOfMaterialNum(40000);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(8, 2).node(1) = plasticRotCapOfMaterialNum(307021);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(8, 2).node(2) = plasticRotCapOfMaterialNum(208021);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(8, 2).node(3) = plasticRotCapOfMaterialNum(308021);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(8, 2).node(4) = plasticRotCapOfMaterialNum(208011);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(8, 2).node(5) = plasticRotCapOfMaterialNum(40000);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(8, 3).node(1) = plasticRotCapOfMaterialNum(307031);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(8, 3).node(2) = plasticRotCapOfMaterialNum(208031);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(8, 3).node(3) = plasticRotCapOfMaterialNum(308031);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(8, 3).node(4) = plasticRotCapOfMaterialNum(208021);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(8, 3).node(5) = plasticRotCapOfMaterialNum(40000);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(8, 4).node(1) = plasticRotCapOfMaterialNum(307041);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(8, 4).node(2) = plasticRotCapOfMaterialNum(49999);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(8, 4).node(3) = plasticRotCapOfMaterialNum(308041);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(8, 4).node(4) = plasticRotCapOfMaterialNum(208031);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(8, 4).node(5) = plasticRotCapOfMaterialNum(40000);
 
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(7, 1).node(1) = plasticRotCapOfMaterialNum(306011);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(7, 1).node(2) = plasticRotCapOfMaterialNum(207011);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(7, 1).node(3) = plasticRotCapOfMaterialNum(307011);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(7, 1).node(4) = plasticRotCapOfMaterialNum(49999);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(7, 1).node(5) = plasticRotCapOfMaterialNum(40000);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(7, 2).node(1) = plasticRotCapOfMaterialNum(306021);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(7, 2).node(2) = plasticRotCapOfMaterialNum(207021);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(7, 2).node(3) = plasticRotCapOfMaterialNum(307021);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(7, 2).node(4) = plasticRotCapOfMaterialNum(207011);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(7, 2).node(5) = plasticRotCapOfMaterialNum(40000);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(7, 3).node(1) = plasticRotCapOfMaterialNum(306031);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(7, 3).node(2) = plasticRotCapOfMaterialNum(207031);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(7, 3).node(3) = plasticRotCapOfMaterialNum(307031);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(7, 3).node(4) = plasticRotCapOfMaterialNum(207021);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(7, 3).node(5) = plasticRotCapOfMaterialNum(40000);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(7, 4).node(1) = plasticRotCapOfMaterialNum(306041);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(7, 4).node(2) = plasticRotCapOfMaterialNum(49999);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(7, 4).node(3) = plasticRotCapOfMaterialNum(307041);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(7, 4).node(4) = plasticRotCapOfMaterialNum(207031);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(7, 4).node(5) = plasticRotCapOfMaterialNum(40000);
 
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(6, 1).node(1) = plasticRotCapOfMaterialNum(305011);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(6, 1).node(2) = plasticRotCapOfMaterialNum(206011);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(6, 1).node(3) = plasticRotCapOfMaterialNum(306011);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(6, 1).node(4) = plasticRotCapOfMaterialNum(49999);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(6, 1).node(5) = plasticRotCapOfMaterialNum(40000);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(6, 2).node(1) = plasticRotCapOfMaterialNum(305021);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(6, 2).node(2) = plasticRotCapOfMaterialNum(206021);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(6, 2).node(3) = plasticRotCapOfMaterialNum(306021);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(6, 2).node(4) = plasticRotCapOfMaterialNum(206011);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(6, 2).node(5) = plasticRotCapOfMaterialNum(40000);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(6, 3).node(1) = plasticRotCapOfMaterialNum(305031);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(6, 3).node(2) = plasticRotCapOfMaterialNum(206031);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(6, 3).node(3) = plasticRotCapOfMaterialNum(306031);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(6, 3).node(4) = plasticRotCapOfMaterialNum(206021);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(6, 3).node(5) = plasticRotCapOfMaterialNum(40000);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(6, 4).node(1) = plasticRotCapOfMaterialNum(305041);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(6, 4).node(2) = plasticRotCapOfMaterialNum(49999);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(6, 4).node(3) = plasticRotCapOfMaterialNum(306041);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(6, 4).node(4) = plasticRotCapOfMaterialNum(206031);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(6, 4).node(5) = plasticRotCapOfMaterialNum(40000);
 
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(5, 1).node(1) = plasticRotCapOfMaterialNum(304011);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(5, 1).node(2) = plasticRotCapOfMaterialNum(205011);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(5, 1).node(3) = plasticRotCapOfMaterialNum(305011);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(5, 1).node(4) = plasticRotCapOfMaterialNum(49999);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(5, 1).node(5) = plasticRotCapOfMaterialNum(40000);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(5, 2).node(1) = plasticRotCapOfMaterialNum(304021);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(5, 2).node(2) = plasticRotCapOfMaterialNum(205021);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(5, 2).node(3) = plasticRotCapOfMaterialNum(305021);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(5, 2).node(4) = plasticRotCapOfMaterialNum(205011);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(5, 2).node(5) = plasticRotCapOfMaterialNum(40000);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(5, 3).node(1) = plasticRotCapOfMaterialNum(304031);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(5, 3).node(2) = plasticRotCapOfMaterialNum(205031);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(5, 3).node(3) = plasticRotCapOfMaterialNum(305031);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(5, 3).node(4) = plasticRotCapOfMaterialNum(205021);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(5, 3).node(5) = plasticRotCapOfMaterialNum(40000);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(5, 4).node(1) = plasticRotCapOfMaterialNum(304041);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(5, 4).node(2) = plasticRotCapOfMaterialNum(49999);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(5, 4).node(3) = plasticRotCapOfMaterialNum(305041);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(5, 4).node(4) = plasticRotCapOfMaterialNum(205031);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(5, 4).node(5) = plasticRotCapOfMaterialNum(40000);
 
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(4, 1).node(1) = plasticRotCapOfMaterialNum(303011);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(4, 1).node(2) = plasticRotCapOfMaterialNum(204011);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(4, 1).node(3) = plasticRotCapOfMaterialNum(304011);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(4, 1).node(4) = plasticRotCapOfMaterialNum(49999);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(4, 1).node(5) = plasticRotCapOfMaterialNum(40000);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(4, 2).node(1) = plasticRotCapOfMaterialNum(303021);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(4, 2).node(2) = plasticRotCapOfMaterialNum(204021);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(4, 2).node(3) = plasticRotCapOfMaterialNum(304021);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(4, 2).node(4) = plasticRotCapOfMaterialNum(204011);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(4, 2).node(5) = plasticRotCapOfMaterialNum(40000);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(4, 3).node(1) = plasticRotCapOfMaterialNum(303031);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(4, 3).node(2) = plasticRotCapOfMaterialNum(204031);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(4, 3).node(3) = plasticRotCapOfMaterialNum(304031);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(4, 3).node(4) = plasticRotCapOfMaterialNum(204021);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(4, 3).node(5) = plasticRotCapOfMaterialNum(40000);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(4, 4).node(1) = plasticRotCapOfMaterialNum(303041);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(4, 4).node(2) = plasticRotCapOfMaterialNum(49999);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(4, 4).node(3) = plasticRotCapOfMaterialNum(304041);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(4, 4).node(4) = plasticRotCapOfMaterialNum(204031);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(4, 4).node(5) = plasticRotCapOfMaterialNum(40000);
 
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(3, 1).node(1) = plasticRotCapOfMaterialNum(302011);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(3, 1).node(2) = plasticRotCapOfMaterialNum(203011);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(3, 1).node(3) = plasticRotCapOfMaterialNum(303011);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(3, 1).node(4) = plasticRotCapOfMaterialNum(49999);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(3, 1).node(5) = plasticRotCapOfMaterialNum(40000);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(3, 2).node(1) = plasticRotCapOfMaterialNum(302021);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(3, 2).node(2) = plasticRotCapOfMaterialNum(203021);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(3, 2).node(3) = plasticRotCapOfMaterialNum(303021);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(3, 2).node(4) = plasticRotCapOfMaterialNum(203011);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(3, 2).node(5) = plasticRotCapOfMaterialNum(40000);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(3, 3).node(1) = plasticRotCapOfMaterialNum(302031);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(3, 3).node(2) = plasticRotCapOfMaterialNum(203031);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(3, 3).node(3) = plasticRotCapOfMaterialNum(303031);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(3, 3).node(4) = plasticRotCapOfMaterialNum(203021);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(3, 3).node(5) = plasticRotCapOfMaterialNum(40000);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(3, 4).node(1) = plasticRotCapOfMaterialNum(302041);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(3, 4).node(2) = plasticRotCapOfMaterialNum(49999);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(3, 4).node(3) = plasticRotCapOfMaterialNum(303041);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(3, 4).node(4) = plasticRotCapOfMaterialNum(203031);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(3, 4).node(5) = plasticRotCapOfMaterialNum(40000);
 
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(2, 1).node(1) = plasticRotCapOfMaterialNum(301011);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(2, 1).node(2) = plasticRotCapOfMaterialNum(202011);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(2, 1).node(3) = plasticRotCapOfMaterialNum(302011);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(2, 1).node(4) = plasticRotCapOfMaterialNum(49999);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(2, 1).node(5) = plasticRotCapOfMaterialNum(40000);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(2, 2).node(1) = plasticRotCapOfMaterialNum(301021);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(2, 2).node(2) = plasticRotCapOfMaterialNum(202021);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(2, 2).node(3) = plasticRotCapOfMaterialNum(302021);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(2, 2).node(4) = plasticRotCapOfMaterialNum(202011);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(2, 2).node(5) = plasticRotCapOfMaterialNum(40000);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(2, 3).node(1) = plasticRotCapOfMaterialNum(301031);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(2, 3).node(2) = plasticRotCapOfMaterialNum(202031);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(2, 3).node(3) = plasticRotCapOfMaterialNum(302031);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(2, 3).node(4) = plasticRotCapOfMaterialNum(202021);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(2, 3).node(5) = plasticRotCapOfMaterialNum(40000);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(2, 4).node(1) = plasticRotCapOfMaterialNum(301041);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(2, 4).node(2) = plasticRotCapOfMaterialNum(49999);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(2, 4).node(3) = plasticRotCapOfMaterialNum(302041);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(2, 4).node(4) = plasticRotCapOfMaterialNum(202031);
     buildingInfo{bldgID}.plastHingeRotCapAtJoint(2, 4).node(5) = plasticRotCapOfMaterialNum(40000);
 
     % Define the joint numbers at each location in the frame
         for colLineNum = 1:4
             for floorNum = 2:13
                 buildingInfo{bldgID}.jointNumber(floorNum, colLineNum) = 40000 + (100.0 * floorNum) + colLineNum;
             end
         end
 
      % Define the hinge element numbers that are used at the base columns
         for colLineNum = 1:4
             buildingInfo{bldgID}.hingeElementNumAtColBase(colLineNum) = 6000 + colLineNum * 10 + 2; % The PH Spring at the column base
         end
 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%% Design ID 1015 - END %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%#######################################################################################################################
%########### END of code pasted from Excel Structural Design Sheet output to DefineInfoForBuildings.m ##################
%#######################################################################################################################
%#######################################################################################################################
%#######################################################################################################################


