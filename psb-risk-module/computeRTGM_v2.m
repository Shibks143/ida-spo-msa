function riskTargetedMedianCap = computeRTGM_v2(lambda_tar, hazardData, betaTot, imOrAfeBound, boundRange)
% boundRange(1) = boundRange(1)*0.75;

% % targeted risk value
% lambda_tar = 5e-4;
%
% % The first row with IM values in arbitrary units (say, g) and second row with PoE
% hazardData = [
%     0.01	0.011591858	0.013384985	0.015217026	0.018409986	0.019975905	0.024073649	0.027797565	0.032600521	0.036632933	0.03990368	0.044839432	0.049801514	0.060017513	0.069571451	0.080021678	0.089570825	0.10025949	0.117126465	0.132126653	0.150796252	0.172103879	0.199500379	0.232158736	0.27016329	0.297736653	0.339807073	0.37158819	0.412709385	0.472860128	0.54388776	0.599397946	0.660573604	0.74228105	0.837343726	0.926398779	1.032924682	1.151699918	1.304256384	1.437371192	1.577926111	1.725504717	1.98469027	2.265128545	2.467368991
%     0.255939962	0.228463211	0.171993373	0.137046536	0.115580702	0.092096193	0.069332541	0.058472866	0.041589998	0.033139447	0.031310092	0.023571096	0.019879115	0.011924738	0.008481709	0.006032785	0.004807001	0.003419076	0.002297642	0.001729728	0.001162389	0.000781133	0.000555597	0.000362345	0.000221587	0.00013435	8.53E-05	6.07E-05	3.64E-05	2.18E-05	1.24E-05	8.31E-06	4.71E-06	2.83E-06	1.60E-06	9.61E-07	5.77E-07	3.46E-07	1.75E-07	8.85E-08	5.31E-08	3.01E-08	1.36E-08	6.10E-09	3.70E-09];
%
% % log-dispersion in fragility
% betaTot = 0.280;

doPrint = 0;
% tolerance
tolReqdInRTGM = 1e-6; % acceptable tolerance in IM value; we are now targeting precision in IM value itself rather than the achieved risk

switch nargin
    case 3 % no bound
        imOrAfeBound = 0; boundRange = [min(hazardData(1, :)), max(hazardData(1, :))];
    case 4
        if imOrAfeBound == 1 % bound over im
            boundRange = [min(hazardData(1, :)), max(hazardData(1, :))];
        elseif imOrAfeBound == 2 % bound over AFE
            boundRange = [min(hazardData(2, :)), max(hazardData(2, :))];
        end
end

if imOrAfeBound == 0; boundRange = [min(hazardData(1, :)), max(hazardData(1, :))]; end

%% The following strategy does not seem to be working, so I am now resorting to binary search as implemented below
% while relErr> tol
%     revisedRTGM = revisedRTGM * lambda_curr / lambda_tar; % update the median (this does not seem to be working, so I am now resorting to binary search as implemented below)
%     fragilityData = [revisedRTGM betaTot]; % update the fragility data
%     [lambda_curr , ~, ~] = computeRiskSingleSite_v1(hazardData, fragilityData, imMin, imMax);
% 	relErr = abs(lambda_curr - lambda_tar)/lambda_tar;
%     fprintf('Revised RTGM = %fg \t|\t Target risk = %f \t|\t actual risk = %f \t|\t relative error = %f \n', revisedRTGM, lambda_tar, lambda_curr, relErr);
% end

%% set the initial guess to a small value, more like a lower bound
%     guessedRTGM = 0.01; % results in error when imMin is > this value
%     guessedRTGM = min(hazardData(1, :));
guessedRTGM = boundRange(1);
guessedRTGM = ceil(guessedRTGM*1000)/1000; % round up to third decimal place

tolCurr = 0.1; % we sweep the IM value coarsely in the beginning
if doPrint == 1; fprintf('RTGM value lambda_tar  lambda_curr \n'); end

counterOnWhile = 0;
while guessedRTGM < 12.00  % just a random stopping criteria, to stop if something goes wrong
    counterOnWhile = counterOnWhile + 1;
    %         [lambda_curr, ~, ~] = computeRiskSingleSite_v1(hazardData, [guessedRTGM betaTot], imMin, imMax);
    [lambda_curr, ~, ~] = computeRiskSingleSite_v3(hazardData, [guessedRTGM betaTot], imOrAfeBound, boundRange);
    if counterOnWhile == 1 && lambda_curr < lambda_tar
        convergedRTGM = 0; break; % we wouldn't get a convergence because even the smallest im value results in less than target risk
    end
    
    %     relErr = abs(lambda_curr - lambda_tar)/lambda_tar ;
    if doPrint == 1;  fprintf('Initial RTGM = %fg \t|\t Target risk = %f \t|\t actual risk = %f \n', guessedRTGM, lambda_tar, lambda_curr); end
    if (lambda_curr < lambda_tar) && (tolCurr <= tolReqdInRTGM) % used to break the iteration
        convergedRTGM = guessedRTGM;
        if doPrint == 1
            fprintf('--------------------------------------------- \n');
            fprintf('----- RISK-TARGETED GM VALUE CALCULATED ----- \n');
            fprintf('--------------------------------------------- \n');
            fprintf('%f \t %f \t %f \n', guessedRTGM, lambda_tar, lambda_curr);
            fprintf('Final tolerance achieved = %e \n', tolCurr);
            fprintf('--------------------------------------------- \n');
        end
        break
    elseif lambda_curr < lambda_tar % we have crossed "lambda_tar" once.
        % reset guess to the last value, since we update the guessedRTGM by reducing it
        if doPrint == 1
            fprintf('%f \t %f \t %f \n', guessedRTGM, lambda_tar, lambda_curr);
            fprintf('Achieved tolerance = %f > Reqd tolerance = %f \n', tolCurr, tolReqdInRTGM);
        end
        guessedRTGM = guessedRTGM - tolCurr;
        tolCurr = tolCurr /10;
    end
    guessedRTGM = guessedRTGM + tolCurr;
end % end of the while loop used for zeroing in on guessedRTGM

riskTargetedMedianCap = convergedRTGM;


%     idealizedCurvePoints = [pointA; pointB; pointC];
%     xCoords = idealizedCurvePoints(:, 1);     yCoords = idealizedCurvePoints(:, 2);












