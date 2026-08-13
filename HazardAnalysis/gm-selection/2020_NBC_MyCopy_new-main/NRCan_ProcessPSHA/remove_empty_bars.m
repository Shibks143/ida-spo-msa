function remove_empty_bars(hBars, tol)
% If your vector of bin counts is N-by-1, then bar3 will plot 6*N rectangular
% patches (i.e. the 6 faces of a cuboid for each bin). The 'ZData' property for
% each set of patch objects in h will therefore be (6*N)-by-4, since there are
% 4 corners for each rectangular face. Each cluster of 6 rows of the 'ZData'
% property is therefore a set of z-coordinates for the 6 faces of one bin.

% The above code first creates a logical vector with ones everywhere the bin 
% count equals 0, then replicates each element of this vector 6 times using 
% the kron function. This becomes an index for the rows of the 'ZData' property, 
% and this index is used to set the z-coordinates to nan for the patches of empty
% bins. This will cause the patches to not be rendered.

% source- https://stackoverflow.com/questions/2050367/how-to-hide-zero-values-in-bar3-plot-in-matlab

for iSeries = 1:numel(hBars)
    zData = get(hBars(iSeries), 'ZData');  % Get the z data
    index = logical(kron(zData(2:6:end, 2) < tol, ones(6, 1)));  % Find empty bars
    zData(index, :) = nan;                 % Set the z data for empty bars to nan
    set(hBars(iSeries), 'ZData', zData);   % Update the graphics objects
end
