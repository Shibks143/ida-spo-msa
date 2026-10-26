function robRapRes = sks_ComputeRobRapRes(timeArray, Qt, pcLIST, maximumHousingCapacity, daysLIST, buildingID, doPrint)
% Recovery metrics from the expected recovery curve Q(t):
%   - days to recover a given percentage of housing capacity
%   - robustness  : Q(t) right after the earthquake, Q(0)
%   - rapidity    : average recovery rate up to each control time (year^-1)
%   - resilience  : normalized area under Q(t) up to each control time
%
% timeArray  - time (days), from fun3expctedRecovery_v1
% Qt         - meanExpectedHousingFunction (normalized, max capacity = 1)
% pcLIST     - percent recovery levels, e.g. [75, 80, 90, 95, 99]
% daysLIST   - control times (days), e.g. [30, 180, 365, 545, 730]
% buildingID - building name, used in the printout
% doPrint    - 1 to print the results, 0 otherwise

timeArray = timeArray(:)'; Qt = Qt(:)'; % row vectors


%% 1. days to recover certain percentages of the housing capacity
daysForRecovery = zeros(1, length(pcLIST));
for k = 1:length(pcLIST)
    xq = pcLIST(k)/100 * maximumHousingCapacity;
    ix = find(Qt >= xq, 1);
    if isempty(ix)      % never reaches this level within timeArray
        daysForRecovery(k) = NaN;
    elseif ix == 1      % already above this level right after the earthquake
        daysForRecovery(k) = 0;
    else
        daysForRecovery(k) = interp1([Qt(ix-1), Qt(ix)], [timeArray(ix-1), timeArray(ix)], xq, 'pchip');
    end
end

%% 2. robustness
robustness = Qt(1);

%% 3. rapidity (year^-1)
QtAfterDaysLIST = interp1(timeArray, Qt, daysLIST, 'pchip');
rapidity = (QtAfterDaysLIST - robustness) ./ (daysLIST/365);

%% 4. resilience
resilience = zeros(1, length(daysLIST));
for k = 1:length(daysLIST)
    t0_plus_th = daysLIST(k);
    timeArrayForInteg = [timeArray(timeArray < t0_plus_th), t0_plus_th];
    housingForInteg = [Qt(timeArray < t0_plus_th), QtAfterDaysLIST(k)];
    resilience(k) = trapz(timeArrayForInteg, housingForInteg)/t0_plus_th;
end

%% outputs
robRapRes.buildingID = buildingID;
robRapRes.pcLIST = pcLIST;           robRapRes.daysForRecovery = daysForRecovery;
robRapRes.robustness = robustness;
robRapRes.daysLIST = daysLIST;       robRapRes.QtAfterDays = QtAfterDaysLIST;
robRapRes.rapidity = rapidity;       robRapRes.resilience = resilience;

%% print
if doPrint == 1
    fprintf('------------------------------------------------\n');
    fprintf('For building ID- %s,\t robustness- %g%%\n', buildingID, robustness*100);
    for k = 1:length(pcLIST)
        fprintf('Days required to recover %i%% of the housing capacity- %i.\n', pcLIST(k), round(daysForRecovery(k)));
    end
    daysLIST = daysLIST'; Rapidity = rapidity'; RES = resilience';
    disp(table(daysLIST, Rapidity, RES));
    fprintf('Units of rapidity are year^(-1).\n');
    fprintf('------------------------------------------------\n');
end
end