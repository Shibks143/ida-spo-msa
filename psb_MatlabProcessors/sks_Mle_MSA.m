function [theta, beta] = sks_Mle_MSA(saLevelList, numOfGroundMotions, numOfCollapses)
% by Jack Baker, 10/9/2012

% Modified by Gemma Cremen, 1/25/2017, to avoid estimating negative median
% values for the fragility function

% Modified by Jack Baker, 1/25/2017, to update citation information

% Modified by Jaewon Saw and Adam Zsarnoczay, 2/10/2020, to improve initial 
% guess by method of moments; replace "theta" with "params" in mlefit function
% to avoid confusion with median "theta"; avoid negative beta values by
% applying penalty; remove check for negative theta in mlefit by using theta 
% in log space; and avoid zero likelihood values by replacing zeros with realmin


% This function fits a lognormal CDF to observed probability of collapse 
% data using optimization on the likelihood function for the data. 
% These calculations are based on equation 11 of the following paper:

% Baker, J. W. (2015). “Efficient analytical fragility function fitting 
% using dynamic structural analysis.” Earthquake Spectra, 31(1), 579-599.

% INPUTS:
% IM            1xn           IM levels of interest
% num_gms       1x1 or 1xn    number of ground motions used at each IM level
% num_collapse 	1xn           number of collapses observed at each IM level
% 
% OUTPUTS:
% theta         1x1           median of fragility function
% beta          1x1           lognormal standard deviation of fragility function


%% Initial guess for the fragility function parameters theta and beta
x0 = [sum(numOfCollapses .* log(saLevelList)) / sum(numOfCollapses), std(log(saLevelList))];

%% Run optimization 
options = optimset('MaxFunEvals',1000,'Display','off');
x = fminsearch(@negLogLik, x0, options, saLevelList, numOfGroundMotions, numOfCollapses);

theta = exp(x(1));   % return theta in linear space
beta  = x(2);

%% Objective function to be optimized
function nll = negLogLik(params, saLevelList, numOfGroundMotions, numOfCollapses)

    if params(2) <= 0
        nll = 1e10;
        return
    end

    % Force column vectors
    saLevelList     = saLevelList(:);      % x_j
    numOfCollapses  = numOfCollapses(:);   % z_j
    if isscalar(numOfGroundMotions)
        numOfGroundMotions = numOfGroundMotions * ones(size(numOfCollapses));
    else
        numOfGroundMotions = numOfGroundMotions(:);   % n_j
    end

    % Check consistency
    if ~isequal(length(saLevelList), length(numOfGroundMotions), length(numOfCollapses))
        error('Lengths: saLevelList=%d, numGM=%d, numCollapse=%d', length(saLevelList), length(numOfGroundMotions), length(numOfCollapses));
    end

    % Fragility model: p_j = normcdf( (log(xj/theta)) / beta )
    theta = exp(params(1));
    beta  = params(2);
    p     = normcdf( (log(saLevelList/theta)) / beta );

    % Avoid log(0)
    p = min(max(p, 1e-6), 1-1e-6);

    % Binomial NEGATIVE log-likelihood (Baker Eq. (10)/(11) 
    nll = -sum( numOfCollapses .* log(p) + (numOfGroundMotions - numOfCollapses) .* log(1 - p) );

end
end

