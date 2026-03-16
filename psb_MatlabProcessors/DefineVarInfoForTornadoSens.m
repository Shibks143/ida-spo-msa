%
% Procedure: DefineVariableInfoForSens.m
% -------------------
% This procedure simple defines the variable information for the sensitivity study.
% 
% Assumptions and Notices: 
%           - This must be run with the current directory started in the "MatlabProcessing" folder.
%
% Author: Curt Haselton 
% Date Written: 9-29-04
%
% Sources of Code: none
%
% Functions and Procedures called: none
%
% Variable definitions: not done
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%5

% function VariableLIST = DefineVariableInfo()

   


        numRVs = 4;     % Just for one-sided sens.

   
        
        % Only sensitivity variables
            variableNum = 1;
            VariableLIST{variableNum}.Variable    = 'useGravFrmS';
            VariableLIST{variableNum}.Definition  = '';
            VariableLIST{variableNum}.Units       = '';
            VariableLIST{variableNum}.Mean        = -1;
            VariableLIST{variableNum}.COV         = -1;
            VariableLIST{variableNum}.HighValue   = -1;
            VariableLIST{variableNum}.LowValue    = -1; 
            VariableLIST{variableNum}.PertValOneSide     = 0.00;

            variableNum = 2;
            VariableLIST{variableNum}.Variable    = 'useJointsS';
            VariableLIST{variableNum}.Definition  = '';
            VariableLIST{variableNum}.Units       = '';
            VariableLIST{variableNum}.Mean        = -1;
            VariableLIST{variableNum}.COV         = -1;
            VariableLIST{variableNum}.HighValue   = -1;
            VariableLIST{variableNum}.LowValue    = -1; 
            VariableLIST{variableNum}.PertValOneSide     = 0.00;
        
            variableNum = 3;
            VariableLIST{variableNum}.Variable    = 'useNoPinch';
            VariableLIST{variableNum}.Definition  = '';
            VariableLIST{variableNum}.Units       = '';
            VariableLIST{variableNum}.Mean        = -1;
            VariableLIST{variableNum}.COV         = -1;
            VariableLIST{variableNum}.HighValue   = -1;
            VariableLIST{variableNum}.LowValue    = -1; 
            VariableLIST{variableNum}.PertValOneSide     = 1.00;     
        
            variableNum = 4;
            VariableLIST{variableNum}.Variable    = 'useCrackedConc';
            VariableLIST{variableNum}.Definition  = '';
            VariableLIST{variableNum}.Units       = '';
            VariableLIST{variableNum}.Mean        = -1;
            VariableLIST{variableNum}.COV         = -1;
            VariableLIST{variableNum}.HighValue   = -1;
            VariableLIST{variableNum}.LowValue    = -1; 
            VariableLIST{variableNum}.PertValOneSide     = 1.00;                
            
%             variableNum = 5;
%             VariableLIST{variableNum}.Variable    = 'useNoGravFrmUseLnColS';
%             VariableLIST{variableNum}.Definition  = '';
%             VariableLIST{variableNum}.Units       = '';
%             VariableLIST{variableNum}.Mean        = -1;
%             VariableLIST{variableNum}.COV         = -1;
%             VariableLIST{variableNum}.HighValue   = -1;
%             VariableLIST{variableNum}.LowValue    = -1; 
%             VariableLIST{variableNum}.PertValOneSide     = 1.00;   
            
            
        
        

        disp('Variables defined.')
        
        