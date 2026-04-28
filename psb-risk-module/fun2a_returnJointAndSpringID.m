function [endIJointID, endISpringID, endJJointID, endJSpringID] = fun2a_returnJointAndSpringID(eleID)

% gg- grid number expressed as two digits (e.g., 02 for grid-2)
% bb- bay number expressed as two digits (e.g., 02 for bay-2)
% ll- level number expressed as two digits (e.g., 01 for foundation level)
% ff- floor number expressed as two digits (e.g., 01 for ground floor)

if floor(eleID/10000) == 2
    % 'Tis a beam (2llbb)
    ll = mod(floor(eleID/100), 100); % level number
    bb = mod(eleID, 100); % bay number
    
    endIJointID = 4e4 + ll * 100 + bb; % left end
    endISpringID = 2;
    endJJointID = 4e4 + (ll + 1) * 100 + bb; % right end
    endJSpringID = 4;
    
elseif floor(eleID/10000) == 3
    % 'Tis a column (3ffgg)
    ff = mod(floor(eleID/100), 100); % floor number
    gg = mod(eleID, 100); % grid number
    
    if ff == 1
        endIJointID = 6e3 + gg * 10 + 2; % bottom end (Hinge)
        endISpringID = 0; % this works a proxy to indicate that Hinge data should be retrieved
    else
        endIJointID = 4e4 + ff * 100 + gg; % bottom end
        endISpringID = 3;
    end
        
    endJJointID = 4e4 + (ff + 1) * 100 + gg; % top end
    endJSpringID = 1;    
end

