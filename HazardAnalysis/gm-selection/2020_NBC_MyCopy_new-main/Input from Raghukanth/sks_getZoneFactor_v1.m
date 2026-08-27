function Zone_factor = sks_getZoneFactor_v1(earthquakeZone, returnPeriod)

% from Table 3 (Clause 6.2.2.2) -- "Earthquake Zone Factor (Z) for
% Different Return Periods (T_R) in Different Earthquake Zones".
%
% INPUT:
%   earthquakeZone - zone string, one of 'II', 'III', 'IV', 'V', 'VI'
%   returnPeriod   - scalar or vector of return periods (years). If a
%                    value is one of the 9 tabulated return periods, the
%                    tabulated Z is returned exactly; otherwise Z is
%                    interpolated log-linearly between the two nearest
%                    tabulated return periods. Values outside
%                    [75, 9975] years throw an error (no extrapolation).
%
% OUTPUT:
%   Z              - zone factor(s), same size as returnPeriod
%

% Table 3 -- rows = zones (VI down to II, as printed), columns = return periods (years)
returnPeriodsTab = [75 175 275 475 975 1275 2475 4975 9975];
zonesTab = {'VI', 'V', 'IV', 'III', 'II'};

ZTab = [
    0.3000  0.3750  0.4500  0.5000  0.6000  0.6250  0.7500  0.9400  1.1250;  % Zone VI
    0.2000  0.2500  0.3000  0.3330  0.4000  0.4167  0.5000  0.6250  0.7500;  % Zone V
    0.1400  0.1750  0.2100  0.2330  0.2800  0.2917  0.3500  0.4400  0.5250;  % Zone IV
    0.0625  0.0850  0.1000  0.1250  0.1670  0.1875  0.2500  0.3330  0.4500;  % Zone III
    0.0375  0.0500  0.0600  0.0750  0.1000  0.1125  0.1500  0.2000  0.2700]; % Zone II

rowIdx = find(strcmpi(zonesTab, earthquakeZone), 1);
if isempty(rowIdx)
    error('sks_getZoneFactor_v1:unknownZone', 'Unknown earthquake zone: %s (expected one of II, III, IV, V, VI).', earthquakeZone);
end

if any(returnPeriod < min(returnPeriodsTab)) || any(returnPeriod > max(returnPeriodsTab))
    error('sks_getZoneFactor_v1:outOfRange', ...
        'Requested return period is outside the tabulated range [%d %d] years -- extrapolation not supported.', ...
        min(returnPeriodsTab), max(returnPeriodsTab));
end

Zone_factor = interp1(log(returnPeriodsTab), ZTab(rowIdx, :), log(returnPeriod), 'linear');

end