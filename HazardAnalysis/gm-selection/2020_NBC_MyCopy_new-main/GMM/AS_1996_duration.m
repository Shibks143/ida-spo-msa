function [sd, sigma] = AS_1996_duration(M, R, is_soil, dur_type)

% by Jack Baker, 9/26/2009
% bakerjw@stanford.edu
%
% Compute the Abrahamson and Silva attenuation prediction of significant 
% duration. The original citation for this model is 
%
% Abrahamson, N. A., and Silva, W. J. (1996). “Empirical ground motion 
% models, report prepared for Brookhaven National Laboratory.” New York, NY.
%
% and the model is reported in the publically accessible report
%
% Stewart, J. P., Chiou, S. J., Bray, J. D., Graves, R. W., Somerville, 
% P. G., and Abrahamson, N. A. (2002). “Ground motion evaluation procedures 
% for performance-based design.” Soil Dynamics and Earthquake Engineering, 
% 22(9-12), 765-772.
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% INPUT
%
%   M               = earthquake magnitude
%   R               = distance (defined generically)
%   is_soil         = 1 for soil prediction
%                   = 0 for rock
%   dur_type        = 1 for 5-75% horizontal significant duration
%                   = 2 for 5-75% vertical significant duration
%                   = 3 for 5-95% horizontal significant duration
%                   = 4 for 5-95% vertical significant duration
% OUTPUT   
%
%   sd              = median significant duration prediction
%   sigma           = logarithmic standard deviation of significant
%                     duration
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


% parameter values for duration (4 values for the 4 duration types)
beta = [3.2	3.2	3.2	3.2];
b1 = [5.204	4.61	5.204	4.61];
b2 = [0.851	1.536	0.851	1.536];
m_star = [6	6	6	6];
c1 = [0.805	1.076	0.805	1.076];
c2 = [0.063	0.107	0.063	0.107];
rc = [10	10	10	10];
Drat = [0	0	0.845	0.646];
sigma = [0.55	0.46	0.49	0.45];
i = dur_type; % make it a short name for ease of reference below

if R >= rc(i)
    sd = exp( log(( exp(b1(i) + b2(i)*(M - m_star(i)))/(10^(1.5*M+16.05)))^(-1/3) / (4.9e6*beta(i)) ...
         + is_soil*c1(i) + c2(i)*(R-rc(i))) + Drat(i));
else
    sd = exp( log(( exp(b1(i) + b2(i)*(M - m_star(i)))/(10^(1.5*M+16.05)))^(-1/3) / (4.9e6*beta(i)) ...
         + is_soil*c1(i)) + Drat(i));
end

sigma = sigma(i);

end


