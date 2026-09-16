
load('NGA_W2_meta_data.mat');

% Set row 5663 of Sa_1 and Sa_2 to zero
Sa_1(5663,:) = 0;
Sa_2(5663,:) = 0;

% Save only the modified variables back to the same MAT-file
save('NGA_W2_meta_data.mat', 'Sa_1', 'Sa_2', '-append');