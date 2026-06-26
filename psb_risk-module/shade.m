function h = shade(x1,y1,x2,y2,varargin)

% force column vectors
x1 = x1(:);
x2 = x2(:);
y1 = y1(:);
y2 = y2(:);

% make same length
n = min([length(x1), length(x2), length(y1), length(y2)]);

x1 = x1(1:n);
x2 = x2(1:n);
y1 = y1(1:n);
y2 = y2(1:n);

% remove NaNs
idx = ~(isnan(x1) | isnan(x2) | isnan(y1) | isnan(y2));
x1 = x1(idx);
x2 = x2(idx);
y1 = y1(idx);
y2 = y2(idx);

x = [x1; flipud(x2)];
y = [y1; flipud(y2)];

h = fill(x, y, [0.85 0.85 0.85], 'LineStyle','none');

if ~isempty(varargin)
    set(h, varargin{:});
end

end