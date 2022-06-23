function plot_validation_sim_Lesavre_1978(figure_folder, data, res)

%% plot settings
FS.axis   = 16;
FS.legend = 16;
FS.labels = 20;

%% FD dilution - Fig 4
h = figure;
hold on
plot(data.Lesavre.Fig_4.FD_conc_uM, data.Lesavre.Fig_4.Lysis_Percent, 'o', 'Color', [0 0 0], 'LineWidth', 1.25);
plot(res.Fig_4.FD_conc,             res.Fig_4.lysis(:,1),             '-', 'Color', [0 0 0], 'LineWidth', 2);
% plot(res.Fig_4.FD_conc,             res.Fig_4.lysis(:,2),             '-', 'Color', [0 0 0], 'LineWidth', 2);
set(gca,'FontSize', FS.axis)
xlabel('FD concentration (uM)', 'FontSize', FS.labels)
ylabel('Hemolysis (%)', 'FontSize', FS.labels)
set(gca,'Xscale', 'log')
ylim([0 100])
grid on
box on
saveas(h, [figure_folder, 'Lesavre_1978_Fig4_FD-dilution.png'], 'png')

end