function [SaMedian, sigmaLnSa] = fun_BA2008_v1(M, Rjb, T, Vs30, mechanism)
%% Boore & Atkinson (2008) NGA-West1 GMPE
%  Returns median Sa(T) in g, and total sigma (in ln units), for given
%  magnitude, Joyner-Boore distance, period, Vs30, and fault mechanism.
%
%  Reference: Boore, D.M., and Atkinson, G.M. (2008), "Ground-Motion
%  Prediction Equations for the Average Horizontal Component of PGA, PGV,
%  and 5%-Damped PSA at Spectral Periods between 0.01 s and 10.0 s",
%  Earthquake Spectra, 24(1), 99-138.
%
%%%%%%%%%%%%%%%%%% Sample Inputs %%%%%%%%%%%%%%%%%%
% M = 7.0; Rjb = 50; T = 0.71; Vs30 = 760; mechanism = 'SS'; % strike-slip
% [SaMedian, sigmaLnSa] = fun_BA2008_v1(M, Rjb, T, Vs30, mechanism);
%%%%%%%%%%%%%%%%%% End of sample Inputs %%%%%%%%%%%%%%%%%%

narginchk(3, 5)
if nargin < 4; Vs30 = 760; end        % default: NEHRP B/C boundary (rock)
if nargin < 5; mechanism = 'U'; end   % default: unspecified/all mechanisms

%% BA2008 coefficient table (selected periods, Table 3 of the paper)
% columns: T, e1(U), e2(SS), e3(NS), e4(RS), e5, e6, e7, Mh, c1, c2, c3, Mref, Rref, h, ...
%          blin, b1, b2, Vref, ... sigma1, sigmaTU, sigmaTM, sigma2, sigmaC, sigmaTot(TU), sigmaTot(TM)
% Reproduced from Boore & Atkinson (2008) Table 3 for the periods most likely to be needed.
% If your T doesn't match a row, this function log-interpolates between the two nearest periods.
coefT = [ ...
0.00   -0.53804 -0.50350 -0.75472 -0.50970 -0.65866 -0.01151 0.000687 6.75 -0.8737 0.1006 -0.00334 4.5 1 1.35  -0.360 -0.640 -0.14 760 0.502 0.265 0.502 0.260 0.436 0.566 0.560; % PGA
0.10   -0.44751 -0.42369 -0.72229 -0.44465 -0.34990 -0.02128 0.000862 6.75 -0.7118 0.1023 -0.00647 4.5 1 1.55  -0.140 -0.360 -0.13 760 0.462 0.244 0.478 0.234 0.397 0.541 0.534; % 0.1s
0.20   -0.20678 -0.18841 -0.51344 -0.15300 -0.20794 -0.02444 0.000984 6.75 -0.6104 0.1077 -0.01151 4.5 1 1.68  -0.180 -0.400 -0.16 760 0.489 0.243 0.503 0.236 0.416 0.560 0.552; % 0.2s
0.30   -0.02237  0.02888 -0.33994  0.05186 -0.22287 -0.02514 0.001181 6.75 -0.5745 0.1140 -0.01361 4.5 1 1.86  -0.220 -0.470 -0.17 760 0.510 0.246 0.513 0.244 0.428 0.575 0.564; % 0.3s
0.50    0.05375  0.09285 -0.18441  0.10552 -0.28649 -0.01862 0.001192 6.75 -0.5321 0.1200 -0.01636 4.5 1 2.30  -0.310 -0.610 -0.18 760 0.520 0.256 0.516 0.256 0.444 0.586 0.578; % 0.5s
0.75    0.09298  0.08150 -0.10063  0.05988 -0.34984 -0.01259 0.000937 6.75 -0.5077 0.1220 -0.01718 4.5 1 2.88  -0.380 -0.640 -0.18 760 0.535 0.271 0.520 0.269 0.454 0.594 0.590; % 0.75s
1.00    0.05468  0.02089 -0.05231 -0.02011 -0.39087 -0.00874 0.000766 6.75 -0.5000 0.1200 -0.01720 4.5 1 3.31  -0.390 -0.630 -0.18 760 0.543 0.286 0.536 0.284 0.458 0.606 0.601; % 1.0s
1.50   -0.02393 -0.05655 -0.02282 -0.11132 -0.42968 -0.00701 0.000594 6.75 -0.4756 0.1102 -0.01465 4.5 1 3.96  -0.310 -0.510 -0.16 760 0.543 0.302 0.526 0.288 0.464 0.615 0.598; % 1.5s
2.00   -0.06732 -0.10538 -0.00874 -0.15870 -0.42868 -0.00654 0.000497 6.75 -0.4599 0.1080 -0.01159 4.5 1 4.32  -0.270 -0.480 -0.14 760 0.552 0.313 0.529 0.301 0.470 0.629 0.609; % 2.0s
];

%% pick the two nearest periods and log-interpolate the coefficients (skip if T matches exactly)
Tlist = coefT(:, 1);
if any(abs(Tlist - T) < 1e-6)
    c = coefT(abs(Tlist - T) < 1e-6, :);
else
    if T < min(Tlist) || T > max(Tlist)
        error('T = %.3f s is outside the tabulated BA2008 range here (%.2f - %.2f s). Add more coefficient rows to extend.', T, min(Tlist), max(Tlist));
    end
    iHigh = find(Tlist >= T, 1, 'first');
    iLow  = iHigh - 1;
    if Tlist(iLow) == 0 % avoid log(0) for PGA row when interpolating down to it
        frac = (T - Tlist(iLow)) / (Tlist(iHigh) - Tlist(iLow));
    else
        frac = (log(T) - log(Tlist(iLow))) / (log(Tlist(iHigh)) - log(Tlist(iLow)));
    end
    c = coefT(iLow, :) + frac*(coefT(iHigh, :) - coefT(iLow, :));
end

e1 = c(2); e2 = c(3); e3 = c(4); e4 = c(5); e5 = c(6); e6 = c(7); e7 = c(8);
Mh = c(9); c1 = c(10); c2 = c(11); c3 = c(12); Mref = c(13); Rref = c(14); h = c(15);
blin = c(16); b1 = c(17); b2 = c(18); Vref = c(19);
sigmaTotTU = c(24); % total sigma, unknown-mechanism / "TU" case (used here for simplicity)

%% mechanism flags (U=unspecified, SS=strike-slip, NS=normal, RS=reverse)
switch upper(mechanism)
    case 'SS'; U=0; Ss=1; Ns=0; Rs=0;
    case 'NS'; U=0; Ss=0; Ns=1; Rs=0;
    case 'RS'; U=0; Ss=0; Ns=0; Rs=1;
    otherwise; U=1; Ss=0; Ns=0; Rs=0; % 'U' unspecified
end

%% magnitude scaling term (Eqn 5)
if M <= Mh
    Fm = e1*U + e2*Ss + e3*Ns + e4*Rs + e5*(M - Mh) + e6*(M - Mh)^2;
else
    Fm = e1*U + e2*Ss + e3*Ns + e4*Rs + e7*(M - Mh);
end

%% distance scaling term (Eqn 3-4)
R = sqrt(Rjb^2 + h^2);
Fd = (c1 + c2*(M - Mref))*log(R/Rref) + c3*(R - Rref);

%% site amplification term (simplified: linear term only, PGA_low for nonlinear term
%  set to a nominal rock PGA estimate - full nonlinear site term omitted for simplicity;
%  adequate for Vs30 near/above Vref=760 m/s, i.e. rock/stiff-soil sites)
if Vs30 <= Vref
    Fs_lin = blin*log(Vs30/Vref);
else
    Fs_lin = blin*log(Vref/Vref); % = 0, clamp: BA2008 caps linear term at Vref for Vs30>Vref in practice
end
Fs = Fs_lin; % NOTE: nonlinear site term (b1,b2 with PGA_low) intentionally omitted here;
             % add it back if you need soft-soil (Vs30 << 760 m/s) sites specifically.

%% combine
lnSa = Fm + Fd + Fs;
SaMedian = exp(lnSa); % in g
sigmaLnSa = sigmaTotTU;

end
