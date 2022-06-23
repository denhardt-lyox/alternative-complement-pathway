function plot_validation_sim_Wilcox_1991(figure_folder, data, Res, simdata)
%% Comparison to data
h = figure; 
hold on
plot(1.15, Res.DAF.Lysis(end,1), 'sr', 'LineWidth', 1.75)
% errorbar(1-0.15, Res.DAF.Lysis(end,1), 3, 'sr', 'LineWidth', 1.75)
% errorbar(1+0.15, Res.DAF.Lysis(end,2), 3, 'db', 'LineWidth', 1.75)

plot(2.15, Res.CD59.Lysis(end,1), 'sr', 'LineWidth', 1.75)
% errorbar(2, Res.CD59.Lysis(end,1), 3, 'sr', 'LineWidth', 1.75)
% errorbar(2, Res.CD59.Lysis(end,2), 3, 'db', 'LineWidth', 1.75)

plot(3.15, Res.CD59_DAF.Lysis(end,1), 'sr', 'LineWidth', 1.75)
% errorbar(3, Res.CD59_DAF.Lysis(end,1), 3, 'sr', 'LineWidth', 1.75)
% errorbar(3, Res.CD59_DAF.Lysis(end,2), 3, 'db', 'LineWidth', 1.75)

plot(1, data.Wilcox.aDAF(end),       'ok', 'LineWidth', 1.75)
plot(2, data.Wilcox.aCD59(end),      'ok', 'LineWidth', 1.75)
plot(3, data.Wilcox.aCD59_aDAF(end), 'ok', 'LineWidth', 1.75)
xlim([0.5 3.5])
xticks(1:3)
xticklabels({'a-DAF', 'a-CD59', 'a-CD59 +\newlinea-DAF\newline '})
ylim([-5 105])
ax = gca;
ax.XAxis.FontSize = 16;
ax.YAxis.FontSize = 14;
ylabel('Hemolysis (%)', 'FontSize', 16)
box on
grid on
% saveas(h, [figure_folder, 'Wilcox_1991_7A_Hemolysis_Bar.png'], 'png')
print('-dpng','-r600',[figure_folder, 'Wilcox_1991_7A_Hemolysis_Bar.png'])


end