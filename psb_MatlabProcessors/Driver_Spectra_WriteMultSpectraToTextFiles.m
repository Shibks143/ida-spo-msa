% This file opens the files for previously computed spectra and writes the spectra to
% text files.
% Curt Haselton
% 8-23-05






% Define list of EQs to compute spectra for 
%     % Bins 4A and 4C (4Extra)
%         eqNumberLIST = [941001, 941002, 941011, 941012, 941021, 941022, 941031, 941032, 941041, 941042, 941051, 941052, 941061, 941062, 941071, 941072, 941081, 941082, 941091, 941092, 943001, 943002, 943011, 943012, 943021, 943022, 943031, 943032, 943041, 943042, 943051, 943052, 943061, 943062, 943071, 943072, 943081, 943082, 943091, 943092, 943101, 943102, 943111, 943112, 943121, 943122, 943131, 943132, 943141, 943142, 943151, 943152, 943161, 943162, 943171, 943172, 943181, 943182, 943191, 943192, 943201, 943202, 943211, 943212, 943221, 943222, 943231, 943232, 943241, 943242, 943251, 943252];
% %     % Bin A for ATC-63
%             % Initial record set ONLY
%           eqNumberLIST = [11011,	11012,	11021,	11022,	11031,	11032,	11041,	11042,	11051,	11052,	11061,	11062,	11071,	11072,	11081,	11082,	11091,	11092,	11101,	11102,	11111,	11112,	11121,	11122,	11131,	11132];
            % Records added on 8-23-05
%           eqNumberLIST = [11141,	11142,	11151,	11152,	11161,	11162,	11171,	11172,	11181,	11182,	11191,	11192,	11201,	11202,	11211,	11212,	11221,	11222,	11231,	11232,	11241,	11242,	11251,	11252,	11261,	11262,	11271,	11272,	11281,	11282,	11291,	11292,	11301,	11302,	11311,	11312,	11321,	11322];


% Bins 4A, 4C, and ATC-63 Set A (newest)
        eqNumberLIST = [941001, 941002, 941011, 941012, 941021, 941022, 941031, 941032, 941041, 941042, 941051, 941052, 941061, 941062, 941071, 941072, 941081, 941082, 941091, 941092, 943001, 943002, 943011, 943012, 943021, 943022, 943031, 943032, 943041, 943042, 943051, 943052, 943061, 943062, 943071, 943072, 943081, 943082, 943091, 943092, 943101, 943102, 943111, 943112, 943121, 943122, 943131, 943132, 943141, 943142, 943151, 943152, 943161, 943162, 943171, 943172, 943181, 943182, 943191, 943192, 943201, 943202, 943211, 943212, 943221, 943222, 943231, 943232, 943241, 943242, 943251, 943252, 11011,	11012,	11021,	11022,	11031,	11032,	11041,	11042,	11051,	11052,	11061,	11062,	11071,	11072,	11081,	11082,	11091,	11092,	11101,	11102,	11111,	11112,	11121,	11122,	11131,	11132, 11141,	11142,	11151,	11152,	11161,	11162,	11171,	11172,	11181,	11182,	11191,	11192,	11201,	11202,	11211,	11212,	11221,	11222,	11231,	11232,	11241,	11242,	11251,	11252,	11261,	11262,	11271,	11272,	11281,	11282,	11291,	11292,	11301,	11302,	11311,	11312,	11321,	11322];



% Bin 5A - all record - selected for a 10% in 50 event (with
  %   epsilon) at 1.0 seconds period
%       eqNumberLIST = [951001, 951002, 951011, 951012, 951021, 951022, 951031, 951032, 951041, 951042, 951051, 951052, 951061, 951062, 951071, 951072, 951081, 951082, 951091, 951092];
          
%         % Single record
%         eqNumberLIST = [11011];
        
        
% Go to the spectra folder
cd ..;
cd EQ_Spectra_Saved;

% Loop and compute and save spectra for all EQ records
    for i = 1:length(eqNumberLIST)
        eqCompNum = eqNumberLIST(i);
        
        % Open the file for this spectrum
        fileName_input = sprintf('SaEQSpectrum_EQ_%d.mat', eqCompNum);
        load(fileName_input, 'SaAbs', 'dampRatioLIST', 'periodVector');
        
        % Create the matrix to output - take the Sa matrix and append the
        %   dampingRatio values and Period values as the top row and left
        %   column
            % Initialize a new zeros matrix
            saAbs_Size = size(SaAbs);
            matrixToOutput_Size = saAbs_Size + 1;
            matrixToOutput = zeros(matrixToOutput_Size);
            matrixToOutput_NumRows = matrixToOutput_Size(1);
            matrixToOutput_NumCols = matrixToOutput_Size(2);

            % Input periods, damping ratios, and Sa values
            matrixToOutput(2:matrixToOutput_NumRows, 1) = periodVector;
            matrixToOutput(1, 2:matrixToOutput_NumCols) = dampRatioLIST;
            matrixToOutput(2:matrixToOutput_NumRows, 2:matrixToOutput_NumCols) = SaAbs;
      
        % Write the specturm to a file.  Write it as space delimited.
            fileName_output = sprintf('SaEQSpectrum_EQ_%d.txt', eqCompNum);
            dlmwrite(fileName_output, matrixToOutput, ' ');
        
        % Clear the value opened
        clear SaAbs
        
        % Comment
        temp = sprintf('Spectrum written to text file for EQ: %d', eqCompNum);
        disp(temp);
        
    end


% Go back to the original folder
cd ..;
cd MatlabProcessors;













