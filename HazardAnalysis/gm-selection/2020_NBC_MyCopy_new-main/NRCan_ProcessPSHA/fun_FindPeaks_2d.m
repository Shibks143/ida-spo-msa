function peakdata = fun_FindPeaks_2d(griddedData)

x = griddedData.x;
y = griddedData.y;
z = griddedData.z;

% Some dummy data for an example surface
% [x,y,z] = peaks; 

% Find dimensions to set up loop
xdim = size(x,1);
ydim = size(x,2);

% Loop through x dimension to find peaks of each row
xpeaks = zeros(size(z));
xwidths = NaN(size(z));
for i = 1:xdim
    [~,locs,w] = findpeaks(z(i,:));
    xpeaks(i,locs) = 1;
    xwidths(i,locs) = w;
end

% Loop through y dimension to find peaks of each row
ypeaks = zeros(size(z));
ywidths = NaN(size(z));
for i = 1:ydim
    [~,locs,w] = findpeaks(z(:,i));
    ypeaks(locs,i) = 1;
    ywidths(locs,i) = w;
end

% Find indices that were peaks in both x and y
peak_inds = xpeaks+ypeaks == 2;

% Plot
% figure
% peaks
% hold on
% plot3(x(peak_inds),y(peak_inds),z(peak_inds),'r*','MarkerSize',24)

% Save data to sruct
peakdata = struct;
peakdata.peakZ = z(peak_inds);
peakdata.peakX = x(peak_inds);
peakdata.peakY = y(peak_inds);
peakdata.peakXWidth = xwidths(peak_inds);
peakdata.peakYWidth = ywidths(peak_inds);