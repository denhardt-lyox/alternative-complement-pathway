function plot_validation_sim_Lesher_2013(figure_folder, data, Res)
%% Comparison to data
h = figure;
hold on
plot(1.15, Res.DAF.Lysis(end,1), 'sr', 'LineWidth', 1.75)
% errorbar(1-0.15, Res.DAF.Lysis(end,1), 3, 'sr', 'LineWidth', 1.75)
% errorbar(1+0.15, Res.DAF.Lysis(end,2), 3, 'db', 'LineWidth', 1.75)

plot(2.15, Res.FH.Lysis(end,1), 'sr', 'LineWidth', 1.75)
% errorbar(2-0.15, Res.FH.Lysis(end,1), 3, 'sr', 'LineWidth', 1.75)
% errorbar(2, Res.FH.Lysis(end,2), 3, 'db', 'LineWidth', 1.75)

plot(3.15, Res.FH_DAF.Lysis(end,1), 'sr', 'LineWidth', 1.75)
% errorbar(3-0.15, Res.FH_DAF.Lysis(end,1), 3, 'sr', 'LineWidth', 1.75)
% errorbar(3, Res.FH_DAF.Lysis(end,2), 3, 'db', 'LineWidth', 1.75)

plot(4.15, Res.FH_FP.Lysis(end,1), 'sr', 'LineWidth', 1.75)
% errorbar(4-0.15, Res.FH_FP.Lysis(end,1), 3, 'sr', 'LineWidth', 1.75)
% errorbar(4+0.15, Res.FH_FP.Lysis(end,2), 3, 'db', 'LineWidth', 1.75)

plot(5.15, Res.FH_DAF_FP.Lysis(end,1), 'sr', 'LineWidth', 1.75)
% errorbar(5-0.15, Res.FH_DAF_FP.Lysis(end,1), 3, 'sr', 'LineWidth', 1.75)
% errorbar(5+0.15, Res.FH_DAF_FP.Lysis(end,2), 3, 'db', 'LineWidth', 1.75)

errorbar(1,data.Lesher.aDAF(1),          data.Lesher.aDAF_error(1),      'ok', 'LineWidth', 1.75)
errorbar(2,data.Lesher.control(end),     data.Lesher.control_err(end),   'ok', 'LineWidth', 1.75)
errorbar(3,data.Lesher.aDAF(end),        data.Lesher.aDAF_error(end),    'ok', 'LineWidth', 1.75)
errorbar(4,data.Lesher.aP(end),          data.Lesher.aP_error(end),      'ok', 'LineWidth', 1.75)
errorbar(5,data.Lesher.aDAF_aP(end),     data.Lesher.aDAF_aP_error(end), 'ok', 'LineWidth', 1.75)
xlim([0.5 5.5])
xticks(1:5)
xticklabels({'a-DAF', 'a-FH', 'a-FH +\newlinea-DAF', 'a-FH +\newlinea-P', 'a-FH +\newlinea-DAF +\newlinea-P' })
ax = gca;
ax.XAxis.FontSize = 16;
ax.YAxis.FontSize = 14;
ylim([-5 105])
ylabel('Hemolysis (%)', 'FontSize', 16)
box on
grid on
% saveas(h, [figure_folder, 'Lesher_2013_Fig9A_Bar.png'], 'png')
print('-dpng','-r600',[figure_folder, 'Lesher_2013_Fig9A_Bar.png'])

%% Time course
% LW = 1.0; 
% h = figure;
% hold on
% ylim([0 110])
% l.a  = plot([0 120], [data.Lesher.aP(end)           data.Lesher.aP(end)], '--', 'Color', [0.8 0 0], 'LineWidth', LW);
% l.b  = plot([0 120], [data.Lesher.aDAF_aP(end)      data.Lesher.aDAF_aP(end)], '--', 'Color', [0 0.8 0], 'LineWidth', LW);
% l.c  = plot([0 120], [data.Lesher.control(end)      data.Lesher.control(end)], '--', 'Color', [0.8 0 0.8], 'LineWidth', LW);
% l.d  = plot([0 120], [data.Lesher.aDAF(end)         data.Lesher.aDAF(end)], '--', 'Color', [0 0.8 0.8], 'LineWidth', LW);
% l.e  = plot([0 120], [data.Lesher.aDAF(1)           data.Lesher.aDAF(1)], '--', 'Color', [0 0 0.8], 'LineWidth', LW); %a-DAF without FH inhibition
% 
% fill([Res.FH_FP.Time', fliplr(Res.FH_FP.Time')], [Res.FH_FP.Lysis(:,1)', fliplr(Res.FH_FP.Lysis(:,2)')], [1 0 0], 'FaceAlpha', 0.3, 'EdgeColor',[0.8 0 0]);
% 
% fill([Res.FH_DAF_FP.Time', fliplr(Res.FH_DAF_FP.Time')], [Res.FH_DAF_FP.Lysis(:,1)', fliplr(Res.FH_DAF_FP.Lysis(:,2)')], [0 1 0], 'FaceAlpha', 0.3, 'EdgeColor',[0 0.8 0]);
% 
% fill([Res.FH.Time', fliplr(Res.FH.Time')], [Res.FH.Lysis(:,1)', fliplr(Res.FH.Lysis(:,2)')], [0.9 0.1 0.9], 'FaceAlpha', 0.3, 'EdgeColor',[0.8 0 0.8]);
%     
% fill([Res.FH_DAF.Time', fliplr(Res.FH_DAF.Time')], [Res.FH_DAF.Lysis(:,1)', fliplr(Res.FH_DAF.Lysis(:,2)')], [0 1 1], 'FaceAlpha', 0.3, 'EdgeColor',[0 0.8 0.8]);
% 
% fill([Res.DAF.Time', fliplr(Res.DAF.Time')], [Res.DAF.Lysis(:,1)', fliplr(Res.DAF.Lysis(:,2)')], [0 0 1], 'FaceAlpha', 0.3, 'EdgeColor',[0 0 0.8]);
% 
% xlabel('Time (min)', 'FontSize' ,14)
% ylabel('Hemolysis (%)', 'FontSize' ,14)
% set(gca,'fontWeight','bold')
% grid on
% % xlim([0 30])
% % saveas(h, [figure_folder, 'Lesher_2013_Fig9A_Time-Course_woLegend.png'], 'png')
% leg = legend([l.a l.b l.c l.d l.e], 'a-FH + a-P', 'a-FH + a-DAF + a-P', 'a-FH', 'a-FH + a-DAF', 'a-DAF', 'Location', 'NorthWest');
% set(leg, 'Interpreter', 'none');
% saveas(h, [figure_folder, 'Lesher_2013_Fig9A_Time-Course.png'], 'png')
% clearvars l
end
