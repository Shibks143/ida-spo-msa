%
% Procedure: DefineVariantInfo.m
% -------------------
% This procedure simple defines the variant information for use with "CreateFileForCalTech.m"
% 
% Assumptions and Notices: 
%           - This must be run with the current directory started in the "MatlabProcessing" folder.
%
% Author: Curt Haselton 
% Date Written: 6-16-04
% Altered: 10-8-04
%
% Sources of Code: none
%
% Functions and Procedures called: none
%
% Variable definitions: not done
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%5

function V = DefineVariantInfo()

% Simple define the variant information here

% I updated these variant numbers and definitions on 2-16-06, for the final
% EDP transfers.

        % Define the number of variants used
        numVariants = 15;    % I am not sure what I am using this for!

        % Variant 1
        varNum = 1;
        V{varNum}.VID    = varNum;
        V{varNum}.Var    = 'Perimeter frame, mean design, nonlinearBeamColumn model (v.65); gravity frame attached; bond flexibility is captured and shear flexibility is included in a questionable manner; column bases have elastic base spring flexibility';
        V{varNum}.T1     = 1.00;
        V{varNum}.b      = 0.065;
        V{varNum}.eleName    = 'nonlinearBeamColumn';
        V{varNum}.modelName  = 'DesID1_v.65';
        V{varNum}.outputFolderName  = sprintf('(%s)_(AllVar)_(Mean)_(%s)', V{varNum}.modelName, V{varNum}.eleName);

        % Variant 2
        varNum = 2;
        V{varNum}.VID    = varNum;
        V{varNum}.Var    = 'Modeled in the same way as variant 1, but this is a different design, using the same beams and same columns throughout the structure.';
        V{varNum}.T1     = 1.00;
        V{varNum}.b      = 0.065;
        V{varNum}.eleName    = 'nonlinearBeamColumn';
        V{varNum}.modelName  = 'DesID2_v.6';        
        V{varNum}.outputFolderName  = sprintf('(%s)_(AllVar)_(Mean)_(%s)', V{varNum}.modelName, V{varNum}.eleName);
        
        % Variant 3
        varNum = 3;
        V{varNum}.VID    = varNum;
        V{varNum}.Var    = 'Perimeter frame.  Similar to variant 1, but this design is code minimum with respect to strength and stiffness provisions, and is modeled with a nonlinearBeamColumn model';
        V{varNum}.T1     = 1.00;
        V{varNum}.b      = 0.065;
        V{varNum}.eleName    = 'nonlinearBeamColumn';
        V{varNum}.modelName  = 'DesID3_v.11';
        V{varNum}.outputFolderName  = sprintf('(%s)_(AllVar)_(Mean)_(%s)', V{varNum}.modelName, V{varNum}.eleName);

        % Variant 5
        varNum = 5;
        V{varNum}.VID    = varNum;
        V{varNum}.Var    = 'Space frame design, design DOES include the slab steel in design; nonlinearBeamColumn model';
        V{varNum}.T1     = 1.00;
        V{varNum}.b      = 0.065;
        V{varNum}.eleName    = 'nonlinearBeamColumn';
        V{varNum}.modelName  = 'DesID5_v.4';
        V{varNum}.outputFolderName  = sprintf('(%s)_(AllVar)_(Mean)_(%s)', V{varNum}.modelName, V{varNum}.eleName);
        
        % Variant 6
        varNum = 6;
        V{varNum}.VID    = varNum;
        V{varNum}.Var    = 'Space frame design, like variant 5 but design DOES NOT include the slab steel in design; nonlinearBeamColumn model';
        V{varNum}.T1     = 1.00;
        V{varNum}.b      = 0.065;
        V{varNum}.eleName    = 'nonlinearBeamColumn';
        V{varNum}.modelName  = 'DesID6_v.6';
        V{varNum}.outputFolderName  = sprintf('(%s)_(AllVar)_(Mean)_(%s)', V{varNum}.modelName, V{varNum}.eleName);
        
        % Variant 9
        varNum = 9;
        V{varNum}.VID    = varNum;
        V{varNum}.Var    = 'Similar design to VarID3, but the SCWB provision was not used in the design and the columns were proportioned based on strength; nonlinearBeamColumn model with gravity frame';
        V{varNum}.T1     = 1.00;
        V{varNum}.b      = 0.065;
        V{varNum}.eleName    = 'nonlinearBeamColumn';
        V{varNum}.modelName  = 'DesID9_v.6';
        V{varNum}.outputFolderName  = sprintf('(%s)_(AllVar)_(Mean)_(%s)', V{varNum}.modelName, V{varNum}.eleName);
   
%         % Variant 10
%         varNum = 10;
%         V{varNum}.VID    = varNum;
%         V{varNum}.Var    = 'Similar to VarID11, but the 1997 UBC SCWB provision was used instead of that from the 2003 IBC';
%         V{varNum}.T1     = 1.00;
%         V{varNum}.b      = 0.02;
%         V{varNum}.eleName    = 'clough';
%         V{varNum}.modelName  = 'DesID10_v.3';
%         V{varNum}.outputFolderName  = sprintf('(%s)_(AllVar)_(Mean)_(%s)', V{varNum}.modelName, V{varNum}.eleName);
        
        
%         % Variant 11
%         varNum = 11;
%         V{varNum}.VID    = varNum;
%         V{varNum}.Var    = 'Same as VarID1, but lumped plasticity model; no gravity frame; bond flexibility is captured and shear flexibility is included, but the nonlinearity before yielding is excluded; column bases have elastic base spring flexibility';
%         V{varNum}.T1     = 1.00;
%         V{varNum}.b      = 0.02;
%         V{varNum}.eleName    = 'clough';
%         V{varNum}.modelName  = 'DesID1_v.63';

        % Variant 11
        varNum = 11;
        V{varNum}.VID    = varNum;
        V{varNum}.Var    = 'Same as VarID1, but Conc01 for concrete model (no tensile strength)';
        V{varNum}.T1     = 1.00;
        V{varNum}.b      = 0.065;
        V{varNum}.eleName    = 'nonlinearBeamColumn';
        V{varNum}.modelName  = 'DesID1_v.65conc01';  
        V{varNum}.outputFolderName  = sprintf('(%s)_(AllVar)_(Mean)_(%s)', V{varNum}.modelName, V{varNum}.eleName);
        
        % Variant 12
        varNum = 12;
        V{varNum}.VID    = varNum;
        V{varNum}.Var    = 'Same as VarID1, but NO gravity frame attached; bond flexibility is captured and shear flexibility is included in a questionable manner; column bases have elastic base spring flexibility';
        V{varNum}.T1     = 1.00;
        V{varNum}.b      = 0.065;
        V{varNum}.eleName    = 'nonlinearBeamColumn';
        V{varNum}.modelName  = 'DesID1_v.65noGFrm';
        V{varNum}.outputFolderName  = sprintf('(%s)_(AllVar)_(Mean)_(%s)', V{varNum}.modelName, V{varNum}.eleName);
  
        % Variant 13
        varNum = 13;
        V{varNum}.VID    = varNum;
        V{varNum}.Var    = 'Same as VarID1, but using a lumped plasticity model.  Element initial stiffness is secant through the yield point.';
        V{varNum}.T1     = 1.00;
        V{varNum}.b      = 0.065;
        V{varNum}.eleName    = 'clough';
        V{varNum}.modelName  = 'DesID1_v.65';
        V{varNum}.outputFolderName  = sprintf('(%s)_(AllVar)_(Mean)_(%s)', V{varNum}.modelName, V{varNum}.eleName);

        % Variant 14
        varNum = 14;
        V{varNum}.VID    = varNum;
        V{varNum}.Var    = 'Same as VarID1, but using a lumped plasticity model.  Element initial stiffness goes through the point of 60% of yield force (initKF = 1.3).';
        V{varNum}.T1     = 1.00;
        V{varNum}.b      = 0.065;
        V{varNum}.eleName    = 'clough';
        V{varNum}.modelName  = 'DesID1_v.65';
        V{varNum}.outputFolderName  = sprintf('(%s)_(initKF)_(1.30)_(%s)', V{varNum}.modelName, V{varNum}.eleName);
        
        % Variant 15
        varNum = 15;
        V{varNum}.VID    = varNum;
        V{varNum}.Var    = 'Same as VarID1, but using a lumped plasticity model.  Element initial stiffness goes through the point of 40% of yield force (initKF = 2.2).';
        V{varNum}.T1     = 1.00;
        V{varNum}.b      = 0.065;
        V{varNum}.eleName    = 'clough';
        V{varNum}.modelName  = 'DesID1_v.65';
        V{varNum}.outputFolderName  = sprintf('(%s)_(initKF)_(2.20)_(%s)', V{varNum}.modelName, V{varNum}.eleName);
        
        
        
        
%         % Variant 14
%         varNum = 14;
%         V{varNum}.VID    = varNum;
%         V{varNum}.Var    = 'Same as VarID11, it is linear elastic';
%         V{varNum}.T1     = 1.00;
%         V{varNum}.b      = 0.02;
%         V{varNum}.eleName    = 'clough';
%         V{varNum}.modelName  = 'DesID1_v.63Elastic';
%         
%         % Variant 16
%         varNum = 16;
%         V{varNum}.VID    = varNum;
%         V{varNum}.Var    = 'Space frame design, design does not include the slab steel in design; lumped plasticity model with no gravity frame';
%         V{varNum}.T1     = 1.00;
%         V{varNum}.b      = 0.02;
%         V{varNum}.eleName    = 'clough';
%         V{varNum}.modelName  = 'DesID6_v.4';
%         
%         % Variant 110
%         varNum = 110;
%         V{varNum}.VID    = varNum;
%         V{varNum}.Var    = 'Similar to VarID10, but I simply added more slab steel do make the balance between column and beam strengths be worst';
%         V{varNum}.T1     = 1.00;
%         V{varNum}.b      = 0.02;
%         V{varNum}.eleName    = 'clough';
%         V{varNum}.modelName  = 'DesID11_v.1';
        
        
        
        disp('Variants defined.')