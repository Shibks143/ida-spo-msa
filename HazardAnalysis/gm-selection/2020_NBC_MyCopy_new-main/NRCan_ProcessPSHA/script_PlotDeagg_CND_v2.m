clear; tic; %close all; 

baseFolder = pwd;
% oqOutpDirDis = '..\AllOpenQuakeOutputs\Van_Dis_Sa1p68_coarse_for_coding';
oqOutpDirDis = '..\AllOpenQuakeOutputs\Van_Dis_SaMult';

% hazard
oqOutpDirHaz = '..\AllOpenQuakeOutputs\Van_Haz_SaMult';

lonLat = [-123.12 49.25]; % lonLat = [-123.37, 48.43];
imString = 'SA(1.68)'; % 'SA(2.0)' 'SA(1.0)'; 'PGA'; 
returnP = 2475; % 475 (corresponding results from OpenQuake deagg must be available)
deaggType = 'MagDistEps'; % 'MagDist';

doSave = 0;
exportName = regexprep(regexprep(sprintf('Van_dis_%s%s', imString, num2str(returnP)), '(\(|\))', '_'), '\.', 'p'); % a name without special chars Van_dis_SA_1p68_2475
dirFig = 'Overleaf_Van_figs';
extensions = {'epsc'}; % {'fig', 'epsc', 'png', 'jpeg', 'emf'};

%% define poeT, poe target. Manual conversion to match with input to deagg 
if returnP == 2475;    poeT = 0.02; elseif returnP == 475;    poeT = 0.10;
elseif returnP == 975;    poeT = 0.05; end

%% program for hazard calculation starts
cd(oqOutpDirHaz); fullOqOutpDirHaz = pwd;
cd(baseFolder); % cd ..; % back to the hazard firectory for hazard processing
[imVals, afeVals, poeVals50y] = fun_returnHazCurFromPSHAFiles_v2(fullOqOutpDirHaz, lonLat, imString);
saT1Tr = interp1(poeVals50y, imVals, poeT);
textStr = ['$ T_r = $ ', num2str(returnP), ' years', newline, '$ ', upper(imString(1)), lower(imString(2:end)), ' = $ ', num2str(saT1Tr, '%.3f'), ' g'];

%% program for deaggregation starts
cd(baseFolder); cd(oqOutpDirDis);

% delete the temp directory if exists
if exist('tempDir', 'dir')
    rmdir('tempDir', 's'); 
end
mkdir('tempDir');

zipfileName = dir('*-disagg-csv.zip'); 
unzip(zipfileName.name, 'tempDir');
cd tempDir

switch deaggType
    case 'MagDist' % M-R plot (ignore eps ranges)
        deaggFileName = sprintf('Mag_Dist-*.csv');
        fileWithData = dir(deaggFileName);
        allData = readcell(fileWithData.name);
        imt	= allData(3:end, 1)'; poe	= cell2mat(allData(3:end, 2)'); 
        mag	= cell2mat(allData(3:end, 3)'); dist = cell2mat(allData(3:end, 4)'); 
        rlz = cell2mat(allData(3:end, 5)');
    case 'MagDistEps'
        deaggFileName = sprintf('Mag_Dist_Eps-*.csv');
        fileWithData = dir(deaggFileName);
        allData = readcell(fileWithData.name);
        imt	= allData(3:end, 1)'; poe	= cell2mat(allData(3:end, 2)'); 
        mag	= cell2mat(allData(3:end, 3)'); dist = cell2mat(allData(3:end, 4)'); 
        eps	= cell2mat(allData(3:end, 5)'); rlz = cell2mat(allData(3:end, 6)');
end

% find matching data for imString AND return period of interest
indexMatchingIm_Tr = find(strcmp(imt, imString) & abs(poe - poeT) < 1e-4);
% indexMatchingIM = find(strcmp(imt, imString)); 
% indexMatchingTr = find(abs(poe - poeT) < 1e-4);

% filter the corresponding data for imString and Tr of interest
imt = imt(indexMatchingIm_Tr);  poe	= poe(indexMatchingIm_Tr);	  
mag	= mag(indexMatchingIm_Tr);	dist =dist(indexMatchingIm_Tr); 
rlz = rlz(indexMatchingIm_Tr);  sumRlz = sum(rlz);
if strcmp(deaggType, 'MagDistEps');  eps	= eps(indexMatchingIm_Tr); end

% find grid points for mag, dist, and eps
Mi = unique(mag); Rj = unique(dist); 
if strcmp(deaggType, 'MagDistEps');  epsk = unique(eps); end

% M-R plot (ignore eps ranges)
    % epsVal = 3; %[0, 0.5, 1, 1.5, 2, 2.5, 3];
    % [~, ~, ~, ~, ~, ~, Mi, Rj, lambda_ij] = fun1ExtractDataFromDesFile_v1(mainDir, locDir, imDir, TrDir, epsVal);
    % lambda_ijNorm = lambda_ij/sum(lambda_ij, 'all');
    % bar3(lambda_ijNorm);
    % set(gca,'XTickLabel', round(Mi, 2));
    % set(gca,'YTickLabel', round(Rj, 1));
    % hx = xlabel('Magnitude'); hy = ylabel('Distance (km)'); hz = zlabel('Contribution to Hazard');
    % psb_FigureFormatScript_paper
    % cd(baseFolder)
    
%% stacked for each eps
    cd(baseFolder);

% fixed colors
%     colorLIST = {'b', 'c', 'y', 'g', 'm', 'r', [139, 0, 0]};
%     colorLIST = {'b', 'c', 'y', 'g', 'm', 'r', 'k'};

    % hot to cool gradual colors (courtesy- colorbrewer.org)
    numEpsBins = size(epsk, 2);
    colorLIST = hotToCoolColorMap(numEpsBins); fprintf('We got % i epsilon-bins. Assigning hot-to-cool color map accordingly.\n ', numEpsBins);

% fixed legend
%     legList = {'$ \varepsilon = (-\infty, -2.5)  $', '$ \varepsilon = [-2.5, -2.0)  $', '$ \varepsilon = [-2.0, -1.5)  $', '$ \varepsilon = [-1.5, -1.0)  $', ...
%                '$ \varepsilon = [-1.0, -0.5)  $', '$ \varepsilon = [-0.5, 0.0)  $', '$ \varepsilon = [0.0, 0.5)  $', '$ \varepsilon = [0.5, 1.0)  $', ...
%                '$ \varepsilon = [1.0, 1.5)  $', '$ \varepsilon = [1.5, 2.0)  $', '$ \varepsilon = [2.0, 2.5)  $', '$ \varepsilon = [2.5, \infty)  $'};

% create a list of legends
    legList = cell(1, numEpsBins); 
    epskForLeg = (epsk(1:end-1) + epsk(2:end))/2; % eps bin range values for legend
    legList{1, 1} = sprintf('$ \\varepsilon = (-\\infty, %.2f)  $', epskForLeg(1));
    
    for i = 2:numEpsBins-1
        legList{1, i} = sprintf('$ \\varepsilon = [%.2f, %.2f)  $', epskForLeg(i-1), epskForLeg(i));
    end
        legList{1, numEpsBins} = sprintf('$ \\varepsilon = [%.2f, \\infty)  $', epskForLeg(end));

%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                                    % FOR NEW FIGURE        
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%     figh = figure('units','normalized','outerposition',[0.5 0.25 0.5 0.55]);
    figh = figure('units','normalized','outerposition',[0.5 0.25 0.4 0.45]);
%     figure('units','normalized','position',[0.25 0.25 0.45 0.50])
    set(gcf,'renderer','Painters'); % matlab wants to render using opengl and hence pixeated figures due to complex nature of deagg plots

    % calculate the cumulative lambda 
    lambdaCum = zeros(size(Mi, 2), size(Rj, 2), numEpsBins+1); % extra dimension with all zeros

    for k = 1:numEpsBins
        epsCurr = epsk(1, k);
        lambdaCurr = rlz(abs(eps - epsCurr) < 1e-10)/sumRlz*100; % sum(lambdaCurr)
        lambdaCurr = reshape(lambdaCurr, [size(Rj, 2), size(Mi, 2)])'; % resizing cross-checked with excel data. All okay!
        lambdaCum(:, :, k + 1) = lambdaCum(:, :, k) + lambdaCurr; 
    end
    
    tol = 0.05;     cd(baseFolder); % remove contributions less than tol
    for k = numEpsBins:-1:1
        barHandleId = k; % numEpsBins + 1 - k; % Index of handle to bar. Reverse of k.
        h{barHandleId} = bar3(lambdaCum(:, :, k + 1)', 0.4); hold on;
        set(h{barHandleId}, 'faceColor', colorLIST(barHandleId, :)); % sweep from hot colors to cooler ones
        remove_empty_bars(h{barHandleId}, tol);
    end

%     h = bar3(lambdaCum(:, :, k+1)); hold on; 
%     remove_empty_bars(h, tol);
    
    % define and move legend entries
    hBarForLeg = []; for j = 1:size(h, 2); hBarForLeg = [hBarForLeg, h{j}(1)]; end
    legh1 = legend(hBarForLeg, legList, 'Interpreter', 'latex'); %hold off;
%     set(legh, 'location', 'northeast'); % move legend
%     set(legh, 'position', [0.8 0.55 0 0.25]); % L-B-dx-dy
    set(legh1, 'position', [0.50 0.85 0 0], 'FontSize', 10, 'NumColumns', 3); % L-B-dx-dy
%     set(legh, 'location', 'north', 'FontSize', 10, 'NumColumns', 3); % L-B-dx-dy
    ax = gca; ax.Projection = 'orthographic'; % 'perspective'

% change scaling of axes (data or plot box)
%     daspect([2.5 1 0.75]); 
%     pbaspect([2.4 4.5 1]); 
%     pbaspect([2.5 3.0 1]); 
    pbaspect([2.0 3.75 1]); 

% change the view of the plot (update azimuth-elevation. Default values are -37.5, 30)
%     azNew = -37.5; elNew = 30; 
%     azNew = -60; elNew = 20; 
    azNew = -60; elNew = 25; 
    
    view([azNew, elNew]); % change the plot box

% % adjust the ticks and their labels
 
% This block automates the tick marks so as to correspond to the actual (M, R) value
% (user-input) user to enter the desired ticks (following lines autocalculate the tick location and set them)
    magTick = 5:1:9; distTick = 0:50:300; contTick = 0:5:25;
    
    magTickIndex = interp1(Mi, 1:length(Mi), magTick, 'pchip');
    distTickIndex = interp1(Rj, 1:length(Rj), distTick, 'pchip');
    
    set(gca,'XTick', magTickIndex); set(gca,'XTickLabel', magTick);
    set(gca,'YTick', distTickIndex); set(gca,'YTickLabel', distTick);
    set(gca,'ZTick', contTick);

% Matlab imposes axis limits for focus on actual plot. Change limits to user-inputs 
    xlim([min(magTickIndex) max(magTickIndex)]); ylim([min(distTickIndex) max(distTickIndex)]);

% define axis lables, adjust their position and rotation
    hx = xlabel('Magnitude'); hy = ylabel('Distance (km)'); hz = zlabel('Contribution to Hazard (%)');
    posx = hx.Position; posy = hy.Position; 

% move and rotate axis labels depending on az, el, and pbaspect
    if abs(sum(azNew - (-37.5))) + abs (elNew - 30) < 1e-2
        set(hx, 'Position', posx.*[1.1,1,0.85],'Rotation', 22.5); 
        set(hy, 'Position', posy.*[1,0.75,0.95],'Rotation', -37.5); 
    elseif abs(sum(azNew - (-60))) + abs (elNew - 20) < 1e-2 && sum(abs(pbaspect - [2.0 3.75 1])) < 1e-2
        set(hx, 'Position', posx.*[1.0,1,0.95],'Rotation', 35); 
        set(hy, 'Position', posy.*[1.3,0.8,1.35],'Rotation', -11);
    elseif abs(sum(azNew - (-60))) + abs (elNew - 20) < 1e-2 && sum(abs(pbaspect - [2.4 4.5 1])) < 1e-2
        set(hx, 'Position', posx.*[1.1,1,1],'Rotation', 35); 
        set(hy, 'Position', posy.*[1.2,0.8,1.1],'Rotation', -35);
    elseif abs(sum(azNew - (-60))) + abs (elNew - 25) < 1e-2 && sum(abs(pbaspect - [2.0 3.75 1])) < 1e-2
        set(hx, 'Position', posx.*[1.0,1,1.1],'Rotation', 40); 
        set(hy, 'Position', posy.*[1.3,0.8,1.35],'Rotation', -11);
    end
    
    zMax = zlim; zMax = zMax(2); zMax = 5*ceil(zMax/5);
    zlim([0 zMax]);
%     htext = text(13, -4, 1.4 * zMax, textStr, 'Interpreter', 'latex', 'FontSize', 14, 'FontWeight', 'bold', 'HorizontalAlignment','left', 'EdgeColor', 'k');
    htext = text(40, 20, 0.15 * zMax, textStr, 'Interpreter', 'latex', 'FontSize', 14, 'FontWeight', 'bold', 'HorizontalAlignment','left', 'EdgeColor', 'k');
%     set(htext, 'Position', [40, 20, 0.15 * zMax]);

    psb_FigureFormatScript_paper

if doSave == 1
    cd(baseFolder); cd ..;
	if ~exist(dirFig, 'dir'); mkdir(dirFig); end 
	cd(dirFig);
    for k = 1:length(extensions)
        set(gcf,'renderer','Painters');
    	saveas(gcf, exportName, extensions{k})
    end
    fprintf('Figure(s) saved in %s\n', pwd);
end
%%
cd(baseFolder); toc;

