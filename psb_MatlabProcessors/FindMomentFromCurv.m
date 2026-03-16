%
% Procedure: FindMomentFromCurv.m
% -------------------
% This procedure computes the moment associated with the input curvature (it just looks though the M-Curv output and find the moment at that curvature).  It does this for negative moment, to be consistent with the otehr processor to fins ultimate curvatures (based on the hoop fracture).
% 
% Assumptions and Notices: 
%           - dofNum can be either 1 or 2 (only 2D)
%
% Author: Curt Haselton 
% Date Written: 7-16-04
%
% Sources of Code: none
%
% Functions and Procedures called: none
%
% Variable definitions: 
%           - axialLoad - integer value
%
%
% Units: Whatever OpenSees is using - just be consistent!
%
% -------------------
%function[void] = ComputeStirrupFractureCurv(analysisType, sectionNum, axialLoad, curvature)

% First change the directory to get into the correct folder for processing
cd ..;
cd Output;
cd(analysisType);
cd MCurvOutput;

% Create filename strings
% negMCurvFileName = sprintf('Mcurv_Sec_(%d)_(neg)_Axial_(%d).out', sectionNum, axialLoad)
negMCurvFileName = sprintf('Mcurv_Sec_(%d)_(neg)_Axial_(%d).out', sectionNum, axialLoad);
% coreConrFileName = sprintf('CoreConcStrain_Sec_(%d)_(neg)_Axial_(%d).out', sectionNum, axialLoad);


% Load files
% negMCurv = load(negMCurvFileName);
negMCurv = load(negMCurvFileName);
% coreConcr = load(coreConrFileName);

% Pull out the vector of core concrete strains
% concrStrainVector = coreConcr(:, 3);

% Find the line that the ultimate strain is on
    lineNum = 1;
    while (abs(negMCurv(lineNum, 2)) < abs(curvature))
        lineNum = lineNum + 1;    
        
        % If the next line is past the end of the vector, then return an error
        if(lineNum > length(negMCurv(:, 1)))
            ERROR('The input strain is greater than any strain in the output (i.e. output does not go far enough');
        end
    end
    
    
    
    
    

% Pull out the curvature and moment at this maximum strain
% ultCurv = negMCurv(lineNum, 2);
resultMoment = negMCurv(lineNum, 1);

% Output the results
temp = sprintf('For section %d at axial load of %d: ', sectionNum, axialLoad);
disp(temp)
temp = sprintf('Moment is: %.2f, at a curvature of %.5f ', resultMoment, curvature);
disp(temp)
% temp = sprintf('Ultimate curvature: %.5f ', ultCurv);
% disp(temp)
disp('')















% 
% % Plot
% hold on
% plot(negMCurv(:,2), negMCurv(:, 1), markerType);
% plot(posMCurv(:,2), posMCurv(:, 1), markerType);
%     
% 
%     titleText = sprintf('Moment Curvature of Section %d at Axial Load of %d kips, for %s', sectionNum, axialLoad, analysisType);
%     title(titleText);
%     grid on
%     yLabel = sprintf('Moment');
%     ylabel(yLabel);
%     xlabel('Curvature');
%     hold off

% Get back to the MatlabProcessors folder where we started
cd ..;
cd ..;
cd ..;
cd MatlabProcessors;
