function [ PGA_g, PGV, PGD] = ComputeGMProperties_singleRecord( ag, dtg)
   
% Extract GM parameters, PGA, PGV, PGD 

% Author: Polsak Tothong, 05/16/2006
% Work address:
% email: ptothong@stanford.edu
% Website: http://www.stanford.edu/~ptothong
% May 16 2006; Last revision: May 16 2006
%
% Variables:
%   - ag is a vector of the GM acceleration time history
%   - dtg is the time step
%   - PGA_g is the PGA in g units
%   - PGV is in in/s
%   - PGD is in inches
%
%------------- BEGIN CODE --------------
g    = 386.4; % in/s^2
ag   = reshape( ag, [], 1);
NPTS = length( ag);
velo = zeros( NPTS, 1);
displacement = zeros( NPTS, 1);
for ij = 1:NPTS-1
    velo(ij +1)           = ag(ij)* g *dtg + velo( ij ); % for g
    displacement( ij + 1) = velo(ij)*dtg + displacement( ij );
end
PGA_g = max( abs(ag  ));
PGV   = max( abs(velo) );
PGD   = max( abs(displacement) );
   