function sim_intervention_plotting_dataComparison_Harder2017_PNH_cells(ref, res, IC, Kd, subname)
% plot model to data comparison for hemolysis inhibition by
% S77, Lampalizumab, 3E7, Eculizumab


%% Define and generate folders for figures and tables
[~, figure_folder_summary_plots, ~] = ...
    sim_intervention_folder_definitions(Kd, subname);


%% Load data
data.Harder_Ecu_Human       = groupedData(readtable('../Data/Harder_2017_Fig2A.csv', 'Delimiter', ','));

%% Plot settings
FS.axis   = 16;
FS.legend = 16;
FS.labels = 20;

%% Plotting
% comparison to Harder 2017 Fig 2A (Human PNH cells)
h = figure;
hold on;
plot(res.drgs{8}.drug_uM(2:end), res.drgs{8}.lysis(1,2:end)./res.drgs{8}.lysis(1,1).*100, '-',  'Color', [0 0 0], 'LineWidth', 2);
errorbar(data.Harder_Ecu_Human.Conc_uM, data.Harder_Ecu_Human.Lysis_Percent, data.Harder_Ecu_Human.Error_Percent, 'o', 'Color', [0 0 0], 'LineWidth', 1.5, 'MarkerSize', 8);
set(gca,'FontSize', FS.axis)
set(gca,'XScale','log');
xlim([0.8E-2 3E0])
xticks([1E-2 3E-2 1E-1 3E-1 1E0 3E0])
ylim([0 110])
xlabel('Eculizumab (uM)', 'FontSize', FS.labels);
ylabel('Hemolysis (%)', 'FontSize', FS.labels);
grid on
box on
% saveas(h, [figure_folder_summary_plots, 'Harder2017_PNH-cells_woLegend_woInfo.png'], 'png')
print('-dpng','-r600',[figure_folder_summary_plots, 'Harder2017_PNH-cells_woLegend_woInfo.png'])
ylim([0 120])
txt = sprintf('Lysis in model w/o inhibitor: \nTakeda: %.3f%% \n     Kolb: %.3f%% ', res.drgs{8}.lysis(1,1), res.drgs{8}.lysis(2,1));
text(0.01,10,txt)
% saveas(h, [figure_folder_summary_plots, 'Harder2017_PNH-cells_woLegend.png'], 'png')
print('-dpng','-r600',[figure_folder_summary_plots, 'Harder2017_PNH-cells_woLegend.png'])
legend({'Eculizumab - Harder, 2017', 'Eculizumab - model prediction'},...
        'Location','NorthEast');
% saveas(h, [figure_folder_summary_plots, 'Harder2017_PNH-cells.png'], 'png')
print('-dpng','-r600',[figure_folder_summary_plots, 'Harder2017_PNH-cells.png'])
end