




% Define plot options
    markerTypeSideswayCollapse = 'bo-';
    markerTypeLocalCollapse = 'rs--';
    markerTypeTotalCollapse = 'kd-';
    
    lineWidth = 2;








% Go to the folder and open the file with the sidesway and LVCC data (saved
% while processing the data) - MOVE THIS LATER
    cd DataLVCCShearProcessing;
    % Open file
    load('PlotLVCCData.mat');

% The file that we opened has the probabilities of sidesway collapse and
% the probability of local collapse conditioned on no sidesway collapse, so
% compute the total probability of collapse (including both types).
%   Note that the final.probLocalCollapse is already conditioned on no
%   sidesway collapse (i.e. it is only computed based on the EQs that did not
%   cause sidesway collapse).
    % Do this!!!!
    % Probability of no sidesway collapse...
    final.probNoSideswayCollapse = 1 - final.probSideswayCollapse;
    % Total probability of collapse
    for i = 1:length(final.saBin)
        final.totalProbOfCollapse(i) = final.probSideswayCollapse(i) + (final.probLocalCollapse(i)) * (final.probNoSideswayCollapse(i));    
    end

% Now assume that we call shear failure to be local collapse...do the same
% calculation.  Loop and do this for all Sa levels...
%   Note that the final.probShearFailure is already conditioned on no
%   sidesway collapse (i.e. it is only computed based on the EQs that did not
%   cause sidesway collapse).
    for i = 1:length(final.saBin)
        final.totalProbOfCollapseIfShearFailureIsCalledCollapse(i) = final.probSideswayCollapse(i) + (final.probShearFailure(i)) * (final.probNoSideswayCollapse(i));    
    end

% Plot the total probability of collapse
    figure
    hold on
    plot(final.saBin, final.probSideswayCollapse, markerTypeSideswayCollapse, 'LineWidth', lineWidth);
    plot(final.saBin, final.probLocalCollapse, markerTypeLocalCollapse, 'LineWidth', lineWidth);
    plot(final.saBin, final.totalProbOfCollapse, markerTypeTotalCollapse, 'LineWidth', lineWidth);

    % Plot details
    grid on
    box on
    hx = xlabel('Sa_{code scaling} (T=1.0s) [g]');
    hy = ylabel('P[collapse]');
    legh = legend('Sidesway Collape Probability', 'Column Vert. Col. Prob. (given no SS)', 'Total Probability of Collapse', 'Location', 'NorthWest');
    
    % Format the figure
    cd ..; 
    FigureFormatScript   
    hold off
    
    
% Plot the total probability of collapse, assuming that shear failure
%   caused local collapse (not correct, but done for illustration)
    figure
    hold on
    plot(final.saBin, final.probSideswayCollapse, markerTypeSideswayCollapse, 'LineWidth', lineWidth);
    plot(final.saBin, final.probShearFailure, markerTypeLocalCollapse, 'LineWidth', lineWidth);
    plot(final.saBin, final.totalProbOfCollapseIfShearFailureIsCalledCollapse, markerTypeTotalCollapse, 'LineWidth', lineWidth);

    % Plot details
    grid on
    box on
    hx = xlabel('Sa_{code scaling} (T=1.0s) [g]');
    hy = ylabel('P[collapse]');
    legh = legend('Sidesway Collape Probability', 'Shear Failure "Coll." Prob. (given no SS)', 'Total Probability of Collapse', 'Location', 'NorthWest');
    
    % Format the figure 
    FigureFormatScript
    hold off

    
    












   % Go back to Matlab processors folder
%     cd ..;


    
    
    
    