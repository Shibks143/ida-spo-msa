%% Resilience curve Q(t): robustness, rapidity, resilience R and resilience loss R_L
% Plain MATLAB only (no toolboxes needed). Requires R2016b or newer.
clear; clc; close all;

%% ---------------- Parameters (edit these) ----------------
t0   = 2.0;          % time of the event
tr   = 7.5;          % recovery time
th   = 6.5;          % control (horizon) time  -> t0 + th
Q0   = 0.45;         % residual functionality right after the event (robustness)
xlim_ = [0 10];
ylim_ = [0 1.2];

redC  = [0.93 0.45 0.52];   % R_L hatch colour
blueC = [0.55 0.62 0.90];   % R hatch colour
hatchGap = 0.22;            % spacing between hatch lines (data units along x)
lwThick  = 2.2;             % thick black lines

%% ---------------- Recovery path (smooth curve) ----------------
% Control points shaped like the figure: small rise, dip, then S-shaped recovery
tp = [t0  2.5   3.0   3.8   4.6   5.6   6.6   7.1   tr];
qp = [Q0  0.55  0.545 0.50  0.60  0.84  0.965 0.993 1.0];
tc = linspace(t0, tr, 400);
Qc = pchip(tp, qp, tc);          % shape-preserving interpolation

%% ---------------- Figure / axes ----------------
fig = figure('Color','w','Units','centimeters','Position',[3 3 16 12]);
ax  = axes(fig); hold(ax,'on'); box(ax,'on');
set(ax,'XLim',xlim_,'YLim',ylim_,'FontSize',13,'LineWidth',0.8, ...
    'TickLabelInterpreter','latex','Layer','top');
drawnow;   % needed so the axes size is known for 45-degree hatching

% data slope that looks like 45 degrees on screen (descending, "\\\" hatch)
pos = getpixelposition(ax);
k45 = -(diff(ylim_)/pos(4)) / (diff(xlim_)/pos(3));

%% ---------------- Hatched regions ----------------
% R_L : between Q = 1 and the recovery path
xRL = [tc, fliplr(tc)];
yRL = [Qc, ones(size(tc))];
hatchFill(ax, xRL, yRL, k45, hatchGap, redC);

% R : below the recovery path, plus the full rectangle from tr to t0+th
xR = [tc, t0+th, t0+th, t0];
yR = [Qc, 1,     0,     0 ];
hatchFill(ax, xR, yR, k45, hatchGap, blueC);

%% ---------------- Reference / guide lines ----------------
plot(ax, [t0 t0],       [0 Q0], 'k--', 'LineWidth', 0.8);   % robustness line
plot(ax, [tr tr],       [0 1],  '--', 'Color',[0.5 0.5 0.5], 'LineWidth', 0.6);
plot(ax, [t0+th t0+th], [0 1],  '--', 'Color',[0.5 0.5 0.5], 'LineWidth', 0.6);

% Full functionality before and after, and the drop at t0
plot(ax, [xlim_(1) t0], [1 1],  'k-', 'LineWidth', lwThick);
plot(ax, [t0 t0],       [1 Q0], 'k-', 'LineWidth', lwThick);
plot(ax, [tr xlim_(2)], [1 1],  'k-', 'LineWidth', lwThick);
plot(ax, [t0 tr],       [1 1],  'k--','LineWidth', lwThick);   % target level

% Approximate (linear) recovery path and the actual recovery path
plot(ax, [t0 tr], [Q0 1], 'k--', 'LineWidth', 1.8);
plot(ax, tc, Qc, 'k-', 'LineWidth', lwThick);

%% ---------------- Event marker (star burst at t0, Q = 1) ----------------
eventStar(ax, t0, 1, 22, 5, [0.90 0.10 0.10], [0.60 0 0]);
text(ax, t0-0.35, 1.09, 'Event', 'FontSize',12, 'FontWeight','bold', ...
     'Color',[0.75 0 0], 'HorizontalAlignment','center');   % delete if not wanted

%% ---------------- Rapidity marker ----------------
yRap = 0.69;
xRap = t0 + (yRap - Q0)/(1 - Q0)*(tr - t0);     % point on the dashed line
plot(ax, [xRap xRap+1.25], [yRap yRap], 'k-', 'LineWidth', 1.6);
plot(ax, [xRap xRap], [yRap-0.035 yRap], 'k-', 'LineWidth', 1.6);
text(ax, xRap+1.3, yRap-0.08, '$rapidity$', 'Interpreter','latex', ...
     'FontSize',14, 'BackgroundColor','w', 'Margin',1);

%% ---------------- Labels inside the plot ----------------
text(ax, t0+0.25, 0.94, '$R_L$', 'Interpreter','latex','FontSize',16);
text(ax, t0+1.9,  0.17, '$R$',   'Interpreter','latex','FontSize',16);
text(ax, t0-0.25, 0.22, '$robustness$', 'Interpreter','latex', ...
     'FontSize',14, 'Rotation',90, 'HorizontalAlignment','center');

% "Recovery Path" with a curved arrow to the solid curve
xa = 6.75; ya = interp1(tc, Qc, xa);
text(ax, 5.6, 1.13, {'Recovery','Path'}, 'FontSize',11, ...
     'HorizontalAlignment','center', 'BackgroundColor','w','Margin',1);
curvedArrow(ax, [6.15 1.12], [6.75 1.12], [xa ya+0.005], k45);

% "Approximate Recovery Path" with a curved arrow to the dashed line
xb = 3.6; yb = Q0 + (xb - t0)/(tr - t0)*(1 - Q0);
text(ax, 3.4, 0.31, {'Approximate','Recovery Path'}, 'FontSize',11, ...
     'HorizontalAlignment','center', 'BackgroundColor','w','Margin',1);
curvedArrow(ax, [3.0 0.39], [2.9 0.55], [xb-0.05 yb-0.01], k45);

%% ---------------- Axes labels / ticks ----------------
set(ax, 'XTick', [t0 tr t0+th], ...
        'XTickLabel', {'$t_0$','$t_r$','$t_0+t_h$'}, ...
        'YTick', [0 1]);
xlabel(ax, '$t$ (days)', 'Interpreter','latex', 'FontSize',15);
ylabel(ax, '$Q(t)$',     'Interpreter','latex', 'FontSize',15);

% Save (uncomment as needed)
% exportgraphics(fig, 'resilience_plot.pdf', 'ContentType','vector');
% exportgraphics(fig, 'resilience_plot.png', 'Resolution', 600);

%% ======================= Local functions =======================
function hatchFill(ax, xp, yp, k, gap, col)
% Draws parallel hatch lines y = k*x + c clipped to polygon (xp, yp).
    xs = linspace(min(xp), max(xp), 1500);
    % range of intercepts that can intersect the polygon
    cAll = yp - k*xp;
    dc = gap*abs(k);                 % vertical spacing that gives 'gap' along x
    cVals = (min(cAll)-dc):dc:(max(cAll)+dc);
    X = []; Y = [];
    for ci = cVals
        ys = k*xs + ci;
        in = inpolygon(xs, ys, xp, yp);
        ys(~in) = NaN;
        X = [X, xs, NaN]; %#ok<AGROW>
        Y = [Y, ys, NaN]; %#ok<AGROW>
    end
    plot(ax, X, Y, '-', 'Color', col, 'LineWidth', 1.1);
end

function eventStar(ax, xc, yc, Rpx, nSpk, faceC, edgeC)
% Filled star burst centred at (xc, yc). Rpx = outer radius in pixels,
% nSpk = number of spikes. Drawn in screen units so it is not distorted.
    pos = getpixelposition(ax);
    sx = pos(3)/diff(get(ax,'XLim'));  sy = pos(4)/diff(get(ax,'YLim'));
    th = linspace(0, 2*pi, 600);
    rIn = 0.38*Rpx;
    spike = (cos(nSpk*(th - pi/2)/2).^2).^6;          % sharp spikes
    irreg = 1 + 0.15*sin(3*th + 0.7);                  % hand-drawn look
    r = rIn + (Rpx - rIn)*spike.*irreg;
    xs = xc + r.*cos(th)/sx;
    ys = yc + r.*sin(th)/sy;
    patch(ax, xs, ys, faceC, 'EdgeColor', edgeC, 'LineWidth', 1.2);
end

function curvedArrow(ax, p0, pc, p1, ~)
% Quadratic Bezier arrow from p0 to p1 (control point pc), with a filled head.
    s  = linspace(0, 1, 60)';
    B  = (1-s).^2.*p0 + 2*(1-s).*s.*pc + s.^2.*p1;
    plot(ax, B(:,1), B(:,2), 'k-', 'LineWidth', 1.0);

    % arrow head computed in screen units so it is not distorted
    pos = getpixelposition(ax);
    sx = pos(3)/diff(get(ax,'XLim'));  sy = pos(4)/diff(get(ax,'YLim'));
    d  = [(B(end,1)-B(end-3,1))*sx, (B(end,2)-B(end-3,2))*sy];
    d  = d/norm(d);  n = [-d(2) d(1)];
    L = 9; W = 3.5;                         % head length/half-width in pixels
    tip  = [p1(1)*sx, p1(2)*sy];
    base = tip - L*d;
    P = [tip; base + W*n; base - W*n];
    patch(ax, P(:,1)/sx, P(:,2)/sy, 'k', 'EdgeColor','k');
end