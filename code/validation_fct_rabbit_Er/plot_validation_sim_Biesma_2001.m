function plot_validation_sim_Biesma_2001(data, figure_folder, N_cells, ...
    dilutions, ref_sim, D0_half_sim, D0_def_sim, ...
    D0_restoration_mgl, D0_restoration_sim, D0_mgL, subname)

%% plot settings
FS.axis   = 16;
FS.legend = 16;
FS.labels = 20;

%% Figure 3A
%%% lysis as function of dilutions
h = figure;
hold on
l1 = plot(data.Biesma.Fig_3A.Dilution, data.Biesma.Fig_3A.NHS, 'd', 'Color', [0 0.6 0]);
l2 = plot(data.Biesma.Fig_3A.Dilution, data.Biesma.Fig_3A.III_4, '^', 'Color', [0 0.6 0]);
l3 = plot(data.Biesma.Fig_3A.Dilution, data.Biesma.Fig_3A.V_9, '>', 'Color', [0 0 1]);
l4 = plot(data.Biesma.Fig_3A.Dilution, data.Biesma.Fig_3A.IV_8, 'o', 'Color', [1 0 0]);
l5 = plot(data.Biesma.Fig_3A.Dilution, data.Biesma.Fig_3A.V_7, 's', 'Color', [1 0 0]);
l6 = plot(dilutions, ref_sim.Lysis(:,1)',     '-',  'Color', [0 0.6 0], 'LineWidth', 2);
% plot(dilutions, ref_sim.Lysis(:,2)',     '--', 'Color', [0 0.6 0], 'LineWidth', 2);
l7 = plot(dilutions, D0_half_sim.Lysis(:,1)', '-',  'Color',  [0 0 1],  'LineWidth', 2);
% plot(dilutions, D0_half_sim.Lysis(:,2)', '--', 'Color',  [0 0 1],  'LineWidth', 2);
l8 = plot(dilutions, D0_def_sim.Lysis(:,1)',  '-',  'Color',  [1 0 0],  'LineWidth', 2);
% plot(dilutions, D0_def_sim.Lysis(:,2)',  '--', 'Color',  [1 0 0],  'LineWidth', 2);
set(gca, 'FontSize', FS.axis)
xlabel('Dilution', 'FontSize', FS.labels)
ylabel('% hemolysis', 'FontSize', FS.labels)
grid on
box on
ylim([0 110])
xlim([0 0.3])
saveas(h, [figure_folder, 'Biesma_2001_3A_', subname,'_woLegend.png'], 'png')
leg = legend([l1 l2 l3 l4 l5 l6 l7 l8], 'NHS', 'III_4 (NHS)', 'V_9 (reduced D)', 'IV_8 (D deficient)', 'V_7 (D deficient)',...
    'Model - NHS', 'Model - D0 halfed', 'Model - D deficient', 'Location', 'SouthEast');
set(leg, 'Interpreter', 'none', 'FontSize', FS.legend);
saveas(h, [figure_folder, 'Biesma_2001_3A_', subname,'.png'], 'png')

%% Figure 3B
%%% restoration with FD
h = figure;
hold on
plot(data.Biesma.Fig_3B.D_mgml, data.Biesma.Fig_3B.Lysis_percent, '--d', 'Color', [0 0 0])
plot(D0_restoration_mgl, D0_restoration_sim.Lysis(:,1)', '-',  'Color', [0.7 0 0], 'LineWidth', 2);
% plot(D0_restoration_mgl, D0_restoration_sim.Lysis(:,2)', '--', 'Color', [0.7 0 0], 'LineWidth', 2);
leg = legend('D deficicent serum', 'Model');
set(leg, 'Interpreter', 'none');
set(gca, 'FontSize', FS.axis)
xlabel('Concentration of factor D (mg/l)', 'FontSize', FS.labels)
ylabel('% hemolysis', 'FontSize', FS.labels)
grid on
box on
set(gca,'XScale','log')
ylim([0 100])
saveas(h, [figure_folder, 'Biesma_2001_3B_', subname,'.png'], 'png')
end