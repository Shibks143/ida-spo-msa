% This function opens the sorted EQ file and computes the Sa(T1),comp. for
% a given record.
% Curt Haselton
% 9-8-05
function[SaAbs] = ComputeSaTOneCompForASingleRecord(eqNum, T, dampRat, dT)

% Read the file that has the dT info. for each EQ
    %dT = dtForEQRecord(eqNum);

% Save the current folder location; to get back later
    currentFolderPath = [pwd];
    
% Go to Sorted_Eq_Files folder to get file (folder location is hard-coded)
    sortedEQFolderPath = 'C:\Benchmarking\Models\Sorted_EQ_Files';
    cd(sortedEQFolderPath)

% Create the file name and open the TH file (must be in the same folder)
    accelTHFile = sprintf('SortedEQFile_(%d).txt', eqNum);
    accelTH = load(accelTHFile);
   
% Call the function to compute Sa
    [SaAbs] = elastic_Sa(T, dampRat, accelTH, dT);

%     % Display the results for this record
%     result = sprintf('set saTOneForEQ(%d)  %.4f', currentEqNum, SaAbs(eqIndex));
%     disp(result);
    
% Go back to the original folder
    cd(currentFolderPath)



