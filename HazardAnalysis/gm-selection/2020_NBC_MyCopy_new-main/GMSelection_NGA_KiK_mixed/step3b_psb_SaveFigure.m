
function step3b_psb_SaveFigure(folderNameForSaving, exportName)
% helps with parfor
    try 
        cd(folderNameForSaving)
    catch
        mkdir(folderNameForSaving)
        cd(folderNameForSaving)
    end
        extensions = {'fig', 'epsc', 'png', 'meta'};
        for k = 1:length(extensions)
	        saveas(gcf, exportName, extensions{k})
        end
%     display(pwd); 
    cd ..
end