%
% -------------------
% This finds the area under a numerical values x vs y curve upto a value of x = xev.
%
% Assumptions and Notices: 
%   - Input for xev can be an array and returned value will be an array as well!
%   - y must be a function of x i.e. many to one functions won't work
% 
% Author: Prakash S Badal, IIT Bombay
%
% -------------------

function splineArea = fun3a_findAreaUsingSpline(x, y, xev)

% Sample Input
% x = 0:.1:2;
% y = exp(x); % can be numerical valued function or array
% xev = linspace(0,1,100); % xev can be a subset of x on continuous scale.


try 
    spl = spline(x,y);
catch 
% (9-26-20, PSB) added the catch condition, for spline was throwing error for repeated defovalues in pushover 
% curve in highly nonlinear region, specifically towards the ultimate failure. 
    [x, id_x_unique, ~] = unique(x);
    y = y(id_x_unique);
    spl = spline(x,y);
end
%  plot(x, ppval(spl, x), 'r--'); 
% integrate the spline
spl.coefs = spl.coefs*[diag(1./[4 3 2 1]'),zeros(4,1)];
spl.order = 5;
dx = diff(spl.breaks)';
C = spl.coefs(:,1);
for i = 1:4
  C = C.*dx + spl.coefs(:,i+1);
end
spl.coefs(2:end,5) = cumsum(C(1:(end-1)));

% xev = linspace(0,1,100);
% splint = ppval(spl,xev);
% plot(xev,splint)

splineArea = ppval(spl, xev);
% plot(xev,splint)
