            


% This is just a quick driver to save and export the active figure as
% temp.fig and temp.emf
% Curt Haselton
% 11-08-07


            plotName = sprintf('temp.fig');
            hgsave(plotName);
            % Export the plot as a .emf file (Matlab book page 455)
            exportName = sprintf('temp.emf');
            print('-dmeta', exportName);