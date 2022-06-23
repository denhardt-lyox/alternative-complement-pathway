function [figure_folder, figure_folder_summary_plots, table_folder] = sim_intervention_folder_definitions(Kd, subname)
% Generate figure and table folders and pass handles 

%%
if isempty(Kd) || isnan(Kd) 
    figure_folder = ['../Figures/Figures_inhibitions', subname, '/'];
else
    figure_folder = ['../Figures/Figures_inhibitions_Kd-', num2str(Kd), subname, '/'];
end
mkdir(figure_folder)

figure_folder_summary_plots = [figure_folder, '00_Summary_Plots/'];
mkdir(figure_folder_summary_plots)

table_folder = '../Tables/';
mkdir(table_folder)
end