%
% Procedure: DefineVariableInfo.m
% -------------------
% This procedure simple defines the variable information for use with "CreateFileForCalTech.m"
% 
% Assumptions and Notices: 
%           - This must be run with the current directory started in the "MatlabProcessing" folder.
%
% Author: Curt Haselton 
% Date Written: 6-16-04
%
% Sources of Code: none
%
% Functions and Procedures called: none
%
% Variable definitions: not done
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%5

function VariableLIST = DefineVariableInfo()

    % Define the variable list - when inputting the .Variable, be sure to use the name that i used in OpenSees.  Also, when entering the .HighValue and .LowValue,
    %   be sure to use the same % of sig. figs. (hopefully 2 decimal places) that I used in the analyses.

    
        numRVs = 9;    % Just two sided tornado

    
        variableNum = 1;
        VariableLIST{variableNum}.Variable    = 'cappingRotationF';
        VariableLIST{variableNum}.VariableDescr    = 'cappingRotationF';
        VariableLIST{variableNum}.Definition  = 'Factor on the capping rotation in in the model.  When this is 1.00, the capping rotation is the value computed using Fardis work. (applies to all elements of the frame, so perfect correlation is assumed)';
        VariableLIST{variableNum}.Units       = 'ratio';
        VariableLIST{variableNum}.Mean        = 1.00;
        VariableLIST{variableNum}.COV         = 0.50;
        VariableLIST{variableNum}.HighValue   = 1.87;
        VariableLIST{variableNum}.LowValue    = 0.13;
        VariableLIST{variableNum}.PertValOneSide     = 0.13;
        
        variableNum = 2;
        VariableLIST{variableNum}.Variable    = 'lambdaFactor';
        VariableLIST{variableNum}.VariableDescr    = 'lambdaF';
        VariableLIST{variableNum}.Definition  = 'Factor on the energy dissipation capacity of each element. (applies to all elements of the frame, so perfect correlation is assumed)';
        VariableLIST{variableNum}.Units       = 'ratio';
        VariableLIST{variableNum}.Mean        = 1.00;
        VariableLIST{variableNum}.COV         = 0.50;
        VariableLIST{variableNum}.HighValue   = 1.87;
        VariableLIST{variableNum}.LowValue    = 0.13;
        VariableLIST{variableNum}.PertValOneSide     = 0.13;
        
        variableNum = 3;
        VariableLIST{variableNum}.Variable    = 'postCapStiffRatF';
        VariableLIST{variableNum}.VariableDescr    = 'postCapStiffRatF';
        VariableLIST{variableNum}.Definition  = 'Factor on the post-capping stiffness of each element. (applies to all elements of the frame, so perfect correlation is assumed)';
        VariableLIST{variableNum}.Units       = 'ratio';
        VariableLIST{variableNum}.Mean        = 1.00;
        VariableLIST{variableNum}.COV         = 0.50;
        VariableLIST{variableNum}.HighValue   = 1.87;
        VariableLIST{variableNum}.LowValue    = 0.13;
        VariableLIST{variableNum}.PertValOneSide     = 1.87;

        variableNum = 4;
        VariableLIST{variableNum}.Variable    = 'hingeStrF';
        VariableLIST{variableNum}.VariableDescr    = 'eleStrF';
        VariableLIST{variableNum}.Definition  = 'Factor on the strength of all elements in the frame.  This can be used to capture most modelling strength variability and design strength variability (now it is for modeling strength). (applies to all elements of the frame, so perfect correlation is assumed)';
        VariableLIST{variableNum}.Units       = 'ratio';
        VariableLIST{variableNum}.Mean        = 1.00;
        VariableLIST{variableNum}.COV         = 0.12;
        VariableLIST{variableNum}.HighValue   = 1.21;
        VariableLIST{variableNum}.LowValue    = 0.79;
        VariableLIST{variableNum}.PertValOneSide     = 0.79;

        variableNum = 5;
        VariableLIST{variableNum}.Variable    = 'hingeStrColF';
        VariableLIST{variableNum}.VariableDescr    = 'SCWBRatF';
        VariableLIST{variableNum}.Definition  = 'Factor on the strength of columns.  This is do capture the variability in the SCWB ratio used in design (applies to all elements of the frame, so perfect correlation is assumed)';
        VariableLIST{variableNum}.Units       = 'ratio';
        VariableLIST{variableNum}.Mean        = 1.00;
        VariableLIST{variableNum}.COV         = 0.15;
        VariableLIST{variableNum}.HighValue   = 1.26;
        VariableLIST{variableNum}.LowValue    = 0.74;
        VariableLIST{variableNum}.PertValOneSide     = 0.74;
        
        variableNum = 6;
        VariableLIST{variableNum}.Variable    = 'elaElementStfRatio';
        VariableLIST{variableNum}.VariableDescr    = 'elaElementStfF';
        VariableLIST{variableNum}.Definition  = 'Factor on the elastic stiffness (applies to all elements of the frame, so perfect correlation is assumed)';
        VariableLIST{variableNum}.Units       = 'ratio';
        VariableLIST{variableNum}.Mean        = 1.00;
        VariableLIST{variableNum}.COV         = 0.36;
        VariableLIST{variableNum}.HighValue   = 1.62;
        VariableLIST{variableNum}.LowValue    = 0.38;
        VariableLIST{variableNum}.PertValOneSide     = 0.38;
        
        variableNum = 7;
        VariableLIST{variableNum}.Variable    = 'yieldedPHStiffF';
        VariableLIST{variableNum}.VariableDescr    = 'yieldedPHStiffF';
        VariableLIST{variableNum}.Definition  = 'Factor on the post-yield stiffness of each element. (applies to all elements of the frame, so perfect correlation is assumed)';
        VariableLIST{variableNum}.Units       = 'ratio';
        VariableLIST{variableNum}.Mean        = 1.00;
        VariableLIST{variableNum}.COV         = 0.50;
        VariableLIST{variableNum}.HighValue   = 1.87;
        VariableLIST{variableNum}.LowValue    = 0.13;
        VariableLIST{variableNum}.PertValOneSide     = 0.13;
        
        
        variableNum = 8;
        VariableLIST{variableNum}.Variable    = 'dampRatF';
        VariableLIST{variableNum}.VariableDescr    = 'dampRatF';
        VariableLIST{variableNum}.Definition  = 'Factor on the damping ratio.';
        VariableLIST{variableNum}.Units       = 'ratio';
        VariableLIST{variableNum}.Mean        = 1.00;
        VariableLIST{variableNum}.COV         = 0.40;
        VariableLIST{variableNum}.HighValue   = 1.69;
        VariableLIST{variableNum}.LowValue    = 0.31;
        VariableLIST{variableNum}.PertValOneSide     = 0.31;

        variableNum = 9;
        VariableLIST{variableNum}.Variable    = 'DLF';
        VariableLIST{variableNum}.VariableDescr    = 'DLF';
        VariableLIST{variableNum}.Definition  = 'Factor on the dead load and mass.';
        VariableLIST{variableNum}.Units       = 'ratio';
        VariableLIST{variableNum}.Mean        = 1.00;
        VariableLIST{variableNum}.COV         = 0.13;
        VariableLIST{variableNum}.HighValue   = 1.22;
        VariableLIST{variableNum}.LowValue    = 0.89;
        VariableLIST{variableNum}.PertValOneSide     = 1.22;
        
        % This is just the same as the other variable for beam strength, so
        % I don't replicate the runs
%         variableNum = 10;
%         VariableLIST{variableNum}.Variable    = 'BeamDesStr';
%         VariableLIST{variableNum}.VariableDescr    = 'BeamDesStr';
%         VariableLIST{variableNum}.Definition  = 'Factor on the beam strength (design variable)';
%         VariableLIST{variableNum}.Units       = 'ratio';
%         VariableLIST{variableNum}.Mean        = 1.00;
%         VariableLIST{variableNum}.COV         = 0.13;
%         VariableLIST{variableNum}.HighValue   = 1.22;
%         VariableLIST{variableNum}.LowValue    = 0.89;
%         VariableLIST{variableNum}.PertValOneSide     = 1.22;
        
        
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Old as of 3-3-05   
%
%         % Define the number of variables used
%         numVariables = 12;  
%         
%         variableNum = 1;
%         VariableLIST{variableNum}.Variable    = 'SCWBDesF';
%         VariableLIST{variableNum}.Definition  = 'Factor on the SCWB ratio used in design.  When this factor is 1.00, then the SCWB ratio is 1.30.';
%         VariableLIST{variableNum}.Units       = 'ratio';
%         VariableLIST{variableNum}.Mean        = 1.00;
%         VariableLIST{variableNum}.COV         = 0.15;
%         VariableLIST{variableNum}.HighValue   = 1.26;
%         VariableLIST{variableNum}.LowValue    = 0.74;
%         
%         variableNum = 2;
%         VariableLIST{variableNum}.Variable    = 'bmDesStrF';
%         VariableLIST{variableNum}.Definition  = 'Factor on the beam design strength (at a constant SCWB ratio, so it scales all element strengths).  Factor of 1.0, gives the mean 25% above the code required strength';
%         VariableLIST{variableNum}.Units       = 'ratio';
%         VariableLIST{variableNum}.Mean        = 1.00;
%         VariableLIST{variableNum}.COV         = 0.20;
%         VariableLIST{variableNum}.HighValue   = 1.35;
%         VariableLIST{variableNum}.LowValue    = 0.65;
%         
%         variableNum = 3;
%         VariableLIST{variableNum}.Variable    = 'steelHardF';
%         VariableLIST{variableNum}.Definition  = 'Ratio on the strain hardeing modulus of the steel';
%         VariableLIST{variableNum}.Units       = 'ratio';
%         VariableLIST{variableNum}.Mean        = 1.00;
%         VariableLIST{variableNum}.COV         = 0.25;
%         VariableLIST{variableNum}.HighValue   = 1.43;
%         VariableLIST{variableNum}.LowValue    = 0.57;   
%         
%         variableNum = 4;
%         VariableLIST{variableNum}.Variable    = 'bondHardSlopeF';
%         VariableLIST{variableNum}.Definition  = 'Ratio on the hardening slope of the bond-slip springs';
%         VariableLIST{variableNum}.Units       = 'ratio';
%         VariableLIST{variableNum}.Mean        = 1.00;
%         VariableLIST{variableNum}.COV         = -1.0;
%         VariableLIST{variableNum}.HighValue   = 1.62;   % Note that this really should be 1.38, to have the correct mapping from the concrete strength to bond hardening strength, but it's not important enough to run again!
%         VariableLIST{variableNum}.LowValue    = 0.38;   
%         
%         variableNum = 5;
%         VariableLIST{variableNum}.Variable    = 'eleStrengthF';
%         VariableLIST{variableNum}.Definition  = 'Ratio on the element strengths';
%         VariableLIST{variableNum}.Units       = 'ratio';
%         VariableLIST{variableNum}.Mean        = 1.00;
%         VariableLIST{variableNum}.COV         = 0.12;
%         VariableLIST{variableNum}.HighValue   = 1.21;
%         VariableLIST{variableNum}.LowValue    = 0.79;   
%         
%         variableNum = 6;
%         VariableLIST{variableNum}.Variable    = 'jointStrengthF';
%         VariableLIST{variableNum}.Definition  = 'Ratio on the joint shear panel strength';
%         VariableLIST{variableNum}.Units       = 'ratio';
%         VariableLIST{variableNum}.Mean        = 1.00;
%         VariableLIST{variableNum}.COV         = 0.18;
%         VariableLIST{variableNum}.HighValue   = 1.72;
%         VariableLIST{variableNum}.LowValue    = 1.08;   
%         
%         variableNum = 7;
%         VariableLIST{variableNum}.Variable    = 'DLF';
%         VariableLIST{variableNum}.Definition  = 'Ratio on the dead loads and masses';
%         VariableLIST{variableNum}.Units       = 'ratio';
%         VariableLIST{variableNum}.Mean        = 1.05;
%         VariableLIST{variableNum}.COV         = 0.10;
%         VariableLIST{variableNum}.HighValue   = 1.23;
%         VariableLIST{variableNum}.LowValue    = 0.87;           
%         
%         variableNum = 8;
%         VariableLIST{variableNum}.Variable    = 'dampRatF';
%         VariableLIST{variableNum}.Definition  = 'Ratio on the damping ratio';
%         VariableLIST{variableNum}.Units       = 'ratio';
%         VariableLIST{variableNum}.Mean        = 1.00;
%         VariableLIST{variableNum}.COV         = 0.40;
%         VariableLIST{variableNum}.HighValue   = 1.69;
%         VariableLIST{variableNum}.LowValue    = 0.31;           
%         
%         variableNum = 9;
%         VariableLIST{variableNum}.Variable    = 'colBaseRotStiffF';
%         VariableLIST{variableNum}.Definition  = 'Ratio on the column base rotational stiffnesses, for columns of the mean frame and the gravity frame';
%         VariableLIST{variableNum}.Units       = 'ratio';
%         VariableLIST{variableNum}.Mean        = 1.00;
%         VariableLIST{variableNum}.COV         = 0.30;
%         VariableLIST{variableNum}.HighValue   = 1.52;
%         VariableLIST{variableNum}.LowValue    = 0.48;   
%         
%         variableNum = 10;
%         VariableLIST{variableNum}.Variable    = 'slabHingeStrF';
%         VariableLIST{variableNum}.Definition  = 'Ratio on the strength of the slab hinge (strength at the yield point)';
%         VariableLIST{variableNum}.Units       = 'ratio';
%         VariableLIST{variableNum}.Mean        = 1.00;
%         VariableLIST{variableNum}.COV         = 0.20;
%         VariableLIST{variableNum}.HighValue   = 1.35;
%         VariableLIST{variableNum}.LowValue    = 0.65;           
%         
%         variableNum = 11;
%         VariableLIST{variableNum}.Variable    = 'slabHingeCapRotF';
%         VariableLIST{variableNum}.Definition  = 'Ratio on the plastic rotation capacity of the slab, before deterioration due to punching shear deterioration';
%         VariableLIST{variableNum}.Units       = 'ratio';
%         VariableLIST{variableNum}.Mean        = 1.00;
%         VariableLIST{variableNum}.COV         = 0.30;
%         VariableLIST{variableNum}.HighValue   = 1.52;
%         VariableLIST{variableNum}.LowValue    = 0.48;           
%         
%         variableNum = 12;
%         VariableLIST{variableNum}.Variable    = 'EtsF';
%         VariableLIST{variableNum}.Definition  = 'Factor on the tension stiffening slope of the concrete (i.e. the slope tensile capacity after the concrete cracks)';
%         VariableLIST{variableNum}.Units       = 'ratio';
%         VariableLIST{variableNum}.Mean        = 1.00;
%         VariableLIST{variableNum}.COV         = 0.25;
%         VariableLIST{variableNum}.HighValue   = 1.43;
%         VariableLIST{variableNum}.LowValue    = 0.57;    
%         
%         variableNum = 13;
%         VariableLIST{variableNum}.Variable    = 'hingeStrF';
%         VariableLIST{variableNum}.Definition  = 'Ratio on the element strengths - used for collapse analysis';
%         VariableLIST{variableNum}.Units       = 'ratio';
%         VariableLIST{variableNum}.Mean        = 1.00;
%         VariableLIST{variableNum}.COV         = 0.12;
%         VariableLIST{variableNum}.HighValue   = 1.21;
%         VariableLIST{variableNum}.LowValue    = 0.79;  
%         
%         variableNum = 14;
%         VariableLIST{variableNum}.Variable    = 'cappingRotationF';
%         VariableLIST{variableNum}.Definition  = 'Ratio on the capping point, which is a function of the monotonic plastic rotation capacity';
%         VariableLIST{variableNum}.Units       = 'ratio';
%         VariableLIST{variableNum}.Mean        = 1.00;
%         VariableLIST{variableNum}.COV         = 0.50;
%         VariableLIST{variableNum}.HighValue   = 1.87;
%         VariableLIST{variableNum}.LowValue    = 0.13;     
%         
%         variableNum = 15;
%         VariableLIST{variableNum}.Variable    = 'lambdaFactor';
%         VariableLIST{variableNum}.Definition  = 'Ratio on the cyclic energy dissipation capacity';
%         VariableLIST{variableNum}.Units       = 'ratio';
%         VariableLIST{variableNum}.Mean        = 1.00;
%         VariableLIST{variableNum}.COV         = 0.45;
%         VariableLIST{variableNum}.HighValue   = 1.78;
%         VariableLIST{variableNum}.LowValue    = 0.22;   
%         
%         variableNum = 16;
%         VariableLIST{variableNum}.Variable    = 'postCapStiffRatF';
%         VariableLIST{variableNum}.Definition  = 'Ratio on the post-capping stiffness ratio, which is the negative stiffness after the element starts to soften';
%         VariableLIST{variableNum}.Units       = 'ratio';
%         VariableLIST{variableNum}.Mean        = 1.00;
%         VariableLIST{variableNum}.COV         = 0.50;
%         VariableLIST{variableNum}.HighValue   = 1.87;
%         VariableLIST{variableNum}.LowValue    = 0.13;   
%         
%         variableNum = 17;
%         VariableLIST{variableNum}.Variable    = 'elaElementStfRatio';
%         VariableLIST{variableNum}.Definition  = 'Ratio on the elastic element stiffness = EIeff';
%         VariableLIST{variableNum}.Units       = 'ratio';
%         VariableLIST{variableNum}.Mean        = 1.00;
%         VariableLIST{variableNum}.COV         = 0.36;
%         VariableLIST{variableNum}.HighValue   = 1.62;
%         VariableLIST{variableNum}.LowValue    = 0.38;   
        
        
        
        
        % Define a variable for the mean analysis - note that this is not really a variable, be I need to define it so that the processors will 
        %   work without errors
        variableNum = 99;
        VariableLIST{variableNum}.Variable    = 'AllVarMean';
        VariableLIST{variableNum}.Definition  = 'analyses with all variables set to thier mean values';
        VariableLIST{variableNum}.Units       = 'none';
        VariableLIST{variableNum}.Mean        = -1;
        VariableLIST{variableNum}.COV         = -1;
        VariableLIST{variableNum}.HighValue   = -1;
        VariableLIST{variableNum}.LowValue    = -1;

        disp('Variables defined.')
        
        