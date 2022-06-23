function plot_Takeda1986(Takeda_Data, Takeda_sim, figure_folder)

%% plot settings
FS.axis   = 16;
FS.legend = 16;
FS.labels = 20;

%% Data
h = figure;
hold on
plot(Takeda_Data.FigC8(:,1), Takeda_Data.FigC8(:,2), 'o', 'Color', [0 0 0], 'MarkerSize', 8, 'LineWidth', 1.2);
plot(Takeda_Data.FigC8(:,1), Takeda_Data.FigC8(:,3), '^', 'Color', [0 0 0], 'MarkerSize', 8, 'LineWidth', 1.2);
set(gca,'FontSize', FS.axis)
xlabel('EAC1-7 cells', 'FontSize', FS.labels)
ylabel('Lysed cells',  'FontSize', FS.labels)
grid on
box on
% saveas(h, [figure_folder, 'Takeda_1986_Fig-2_Data.png'], 'png')
print('-dpng','-r600',[figure_folder, 'Takeda_1986_Fig-2_Data.png'])

%% Fit
h = figure;
hold on
plot(Takeda_sim.xsim, Takeda_sim.ysim, '-', 'Color', [0 0 0], 'LineWidth', 2)
plot(Takeda_Data.sorted_C8(:), Takeda_Data.sorted(:), 'o', 'Color', [0 0 0], 'MarkerSize', 8, 'LineWidth', 1.2);
set(gca,'XScale','log')
set(gca,'Xlim', [1E-1 1E2])
set(gca,'Ylim',[0 100])
set(gca,'FontSize',FS.axis)
xlabel('MAC/cell',  'FontSize', FS.labels)
ylabel('Hemolysis (%)',         'FontSize', FS.labels)
grid on
box on
% saveas(h, [figure_folder, 'Takeda_1986_Fig-2_Fit.png'], 'png')
print('-dpng','-r600',[figure_folder, 'Takeda_1986_Fig-2_Fit.png'])











end