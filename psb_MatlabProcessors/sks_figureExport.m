function sks_figureExport(exportName)

% ===============================================
% Generating on 22-Feb-2026 by Shivakumar K S at IIT Madras
% Saves: .fig, .eps, .pdf, .png (600 dpi), .tiff (600 dpi), .emf
% ===============================================

fig = gcf;   % Current figure handle

% ---- Ensure folder exists (safe version) ----
[folderPath,~,~] = fileparts(exportName);
if ~isempty(folderPath) && ~exist(folderPath,'dir')
    mkdir(folderPath);
end

% ---- Force vector-safe rendering ----
set(fig,'Color','w');
set(fig,'Renderer','painters');      % Vector-safe rendering
set(fig,'PaperPositionMode','auto');


% ---- Save MATLAB editable ----
savefig(fig, [exportName '.fig']);

% ---- EPS (Journal-quality vector) ----
print(fig, [exportName '.eps'], '-depsc2', '-painters');

% ---- PDF (Journal-quality vector) ----
print(fig, [exportName '.pdf'], '-dpdf', '-painters');

% ---- High-resolution PNG (600 dpi) ----
print(fig, [exportName '.png'], '-dpng', '-r600');

% ---- High-resolution TIFF (600 dpi) ----
print(fig, [exportName '.tiff'], '-dtiff', '-r600');

% ---- EMF (Word/PowerPoint vector) ----
print(fig, [exportName '.emf'], '-dmeta');

% ---- Close figure to free memory ----
close(fig);

end