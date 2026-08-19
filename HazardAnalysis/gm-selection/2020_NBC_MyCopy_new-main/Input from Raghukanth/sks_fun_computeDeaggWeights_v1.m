function [mag, dist, eps, weight] = sks_fun_computeDeaggWeights_v1(magBins, distBins, epsBins, ...
    imTarget, T1, Vs30, mechanism, GRparams)
%% Computes physically-based (M, R, eps) deaggregation rate-contribution tuples
%  for a target IM level, using:
%    - Truncated Gutenberg-Richter magnitude recurrence (source rate model)
%    - An area-source distance distribution (f_R(R) ~ R, i.e. uniform seismicity
%      density over area - standard simplification when explicit fault/zone
%      geometry isn't available)
%    - Boore & Atkinson (2008) GMPE (fun_BA2008_v1) for median Sa(T) and sigma
%    - Proper epsilon-tail partitioning (Bazzurro & Cornell-style): for each
%      (M,R) bin, the exceedance probability P(IM>imTarget | M,R) is split
%      across epsilon bins according to how much of the standard-normal tail
%      beyond eps*(M,R) = [ln(imTarget)-ln(SaMedian(M,R))]/sigma falls in each bin.
%
%  This produces WEIGHT values that genuinely depend on epsilon, so the resulting weighted-mean tuple (Mbar,
%  Rbar, epsBar) will be physically meaningful.


b = GRparams.b; 
Mmin = GRparams.Mmin; 
Mmax = GRparams.Mmax; 
nu_Mmin = GRparams.nu_Mmin;
beta = b*log(10);

%% bin edges (assume uniform spacing per dimension; extend half-spacing at ends)
magEdges  = localBinEdges(magBins);
distEdges = localBinEdges(distBins);
epsEdges  = localBinEdges(epsBins);

numM = length(magBins); numR = length(distBins); numEps = length(epsBins);

%% Step 1: magnitude bin probability masses (truncated G-R)
% CDF (fraction of events with magnitude >= m, normalized to [Mmin,Mmax]):
%   N(>=m)/N(>=Mmin) = (10^(-b*(m-Mmin)) - 10^(-b*(Mmax-Mmin))) / (1 - 10^(-b*(Mmax-Mmin)))
GRsurvival = @(m) (10.^(-b*(max(min(m,Mmax),Mmin)-Mmin)) - 10^(-b*(Mmax-Mmin))) / (1 - 10^(-b*(Mmax-Mmin)));
pMag = zeros(1, numM);
for i = 1:numM
    pMag(i) = GRsurvival(magEdges(i)) - GRsurvival(magEdges(i+1)); % probability mass in this bin
end
pMag = max(pMag, 0); pMag = pMag/sum(pMag); % renormalize (guards against edge rounding)

%% Step 2: distance bin probability masses (area-source assumption: f_R(R) ~ R)
% CDF ~ R^2 (integral of R dR), normalized to [min(distEdges), max(distEdges)]
Rlo = distEdges(1); Rhi = distEdges(end);
distCDF = @(R) (min(max(R,Rlo),Rhi).^2 - Rlo^2) / (Rhi^2 - Rlo^2);
pDist = zeros(1, numR);
for j = 1:numR
    pDist(j) = distCDF(distEdges(j+1)) - distCDF(distEdges(j));
end
pDist = max(pDist, 0); pDist = pDist/sum(pDist);

%% Step 3-5: for each (M,R) bin, get eps*(M,R) from BA2008, then split the
%  exceedance tail across epsilon bins
mag = []; dist = []; eps = []; weight = [];
for i = 1:numM
    Mi = magBins(i);
    for j = 1:numR
        Rj = distBins(j);
        [SaMedian, sigmaLnSa] = sks_fun_BA2008_v1(Mi, Rj, T1, Vs30, mechanism);
        epsStar = (log(imTarget) - log(SaMedian)) / sigmaLnSa; % eps needed to exactly reach imTarget

        rateMR = nu_Mmin * pMag(i) * pDist(j); % annual rate of events in this (M,R) bin
        pExceed = 1 - normcdf(epsStar);        % P(IM > imTarget | this M,R), i.e. P(Z > epsStar)

        for k = 1:numEps
            lo = max(epsEdges(k), epsStar);
            hi = epsEdges(k+1);
            if hi <= lo
                fracInBin = 0; % this eps bin lies entirely below epsStar - can't produce exceedance
            else
                if pExceed > 1e-12
                    fracInBin = (normcdf(hi) - normcdf(lo)) / pExceed;
                else
                    fracInBin = 0;
                end
            end
            mag(end+1)    = Mi; %#ok<AGROW>
            dist(end+1)   = Rj; %#ok<AGROW>
            eps(end+1)    = epsBins(k); %#ok<AGROW>
            weight(end+1) = rateMR * pExceed * fracInBin; %#ok<AGROW>
        end
    end
end

end

function edges = localBinEdges(centers)
%% Derive bin edges from bin centers
centers = sort(centers(:)');
if isscalar(centers)
    edges = [centers-0.5, centers+0.5]; 
    return
end
d = diff(centers);
edges = zeros(1, length(centers)+1);
edges(2:end-1) = centers(1:end-1) + d/2;
edges(1) = centers(1) - d(1)/2;
edges(end) = centers(end) + d(end)/2;
end
