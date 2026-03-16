


% Junk
maxNumPoints = 100000000;
eleNum = 1;
eleDofNum = 2;
nodeNum = 72;
dofNum = 1;
jointNum = 622;
jointNodeNum = 3;

% Define parallel lists of EQ's and Sa levels for which to compare drifts...set up for comparing one EQ per Sa level.
    saTOneForRunLIST = [0.10, 0.19, 0.26, 0.33, 0.44, 0.55, 0.82];
%     eqNumberLIST = [300, 200, 100, 700, 600, 500, 400];
    eqNumberLIST = [300, 200, 100, 700, 600, 500, 400];
    numStripes = 7;


% Loop to do all plots
figureNum = 1;
for stripeNum = 1:numStripes

    figure(figureNum)
    
    % NlBmCol
    analysisType = '(DesID1_v.47nlBmCol)_(AllVar)_(Mean)_(nonlinearBeamColumn)';
    markerType = 'b';
    saTOneForRun = saTOneForRunLIST(stripeNum);
    eqNumber = eqNumberLIST(stripeNum);
    PlotMaxDriftLevel

    hold on

    % NlBmCol
    analysisType = '(DesID1_v.47pinchDmg)_(AllVar)_(Mean)_(pinchDmgHinge)';
    markerType = 'r--';
    saTOneForRun = saTOneForRunLIST(stripeNum);
    eqNumber = eqNumberLIST(stripeNum);
    PlotMaxDriftLevel

    titleString = sprintf('Comparison of Drift Responses, EQ %d, Sa %.2f', eqNumber, saTOneForRun)
    title(titleString);
    
    legend('nonlinearBeamColumn - Solid Line', 'Lumped Plasticity - Dashed Line')

    hold off
    
    figureNum = figureNum + 1;
    
end







% saTOneForRun = 0.10;
% saTOneForRun = 0.19;
% saTOneForRun = 0.26;
% saTOneForRun = 0.33;
% saTOneForRun = 0.44;
% saTOneForRun = 0.55;
% saTOneForRun = 0.82;

% eqNumber = 300;
% eqNumber = 200;
% eqNumber = 100;
% eqNumber = 700;
% eqNumber = 600;
% eqNumber = 500;
% eqNumber = 400;






