function plot_validation_sim_Ferreira_2007(figure_folder, data, Res)


%% alternative representation - as bars
h = figure;
hold on
plot(1.15, Res.DAF.Lysis(end,1), 'sr', 'LineWidth', 1.75)
% errorbar(1.15, Res.DAF.Lysis(end,1), 3, 'sr', 'LineWidth', 1.75)
% errorbar(1+0.15, Res.DAF.Lysis(end,2), 3, 'db', 'LineWidth', 1.75)

plot(2.15, Res.FH.Lysis(end,1), 'sr', 'LineWidth', 1.75)
% errorbar(2.15, Res.FH.Lysis(end,1), 3, 'sr', 'LineWidth', 1.75)
% errorbar(2, Res.FH.Lysis(end,2), 3, 'db', 'LineWidth', 1.75)

plot(3.15, Res.CD59.Lysis(end,1), 'sr', 'LineWidth', 1.75)
% errorbar(3.15, Res.CD59.Lysis(end,1), 3, 'sr', 'LineWidth', 1.75)
% errorbar(3, Res.CD59.Lysis(end,2), 3, 'db', 'LineWidth', 1.75)

plot(4.15, Res.FH_DAF.Lysis(end,1), 'sr', 'LineWidth', 1.75)
% errorbar(4.15, Res.FH_DAF.Lysis(end,1), 3, 'sr', 'LineWidth', 1.75)
% errorbar(4, Res.FH_DAF.Lysis(end,2), 3, 'db', 'LineWidth', 1.75)

plot(5.15, Res.FH_CD59.Lysis(end,1), 'sr', 'LineWidth', 1.75)
% errorbar(5.15, Res.FH_CD59.Lysis(end,1), 3, 'sr', 'LineWidth', 1.75)
% errorbar(5+0.15, Res.FH_CD59.Lysis(end,2), 3, 'db', 'LineWidth', 1.75)

errorbar(1,data.Ferreira.Fig1B.E_H_avrge(end),data.Ferreira.Fig1B.E_H_std(end),               'ok', 'LineWidth', 1.75)
errorbar(2,mean([data.Ferreira.Fig1A.E_H_rH1920_avrge(1) data.Ferreira.Fig1B.E_H_rH1920_avrge(1)]), ...
    std([data.Ferreira.Fig1A.E_H_rH1920_avrge(1) data.Ferreira.Fig1B.E_H_rH1920_avrge(1)]),   'ok', 'LineWidth', 1.75)
errorbar(3,data.Ferreira.Fig1A.E_H_avrge(end),data.Ferreira.Fig1A.E_H_std(end),               'ok', 'LineWidth', 1.75)
errorbar(4,data.Ferreira.Fig1B.E_H_rH1920_avrge(end),data.Ferreira.Fig1B.E_H_rH1920_std(end), 'ok', 'LineWidth', 1.75)
errorbar(5,data.Ferreira.Fig1A.E_H_rH1920_avrge(end),data.Ferreira.Fig1A.E_H_rH1920_std(end), 'ok', 'LineWidth', 1.75)
xlim([0.5 5.5])
xticks(1:5)
xticklabels({'a-DAF', 'a-FH', 'a-CD59',  'a-FH +\newlinea-DAF', 'a-FH +\newlinea-CD59\newline '})
xlim([0.5 5.5])
ylim([-5 105])
ax = gca;
ax.XAxis.FontSize = 16;
ax.YAxis.FontSize = 14;
ylabel('Hemolysis (%)', 'FontSize', 16)
box on
grid on
% saveas(h, [figure_folder, 'Ferreira_2007_Fig1AB_Bar.png'], 'png')
print('-dpng','-r600',[figure_folder, 'Ferreira_2007_Fig1AB_Bar.png'])


%% Time course
% LW = 1.0; 
% h = figure;
% hold on
% ylim([0 110])
% l.a  = plot([0 120], [data.Ferreira.Fig1A.E_H_avrge(end)          data.Ferreira.Fig1A.E_H_avrge(end)], '--', 'Color', [0 0.8 0], 'LineWidth', LW);
% l.b  = plot([0 120], [data.Ferreira.Fig1A.E_H_rH1920_avrge(end)   data.Ferreira.Fig1A.E_H_rH1920_avrge(end)], '--', 'Color', [0.8 0 0], 'LineWidth', LW);
% l.c  = plot([0 120], [data.Ferreira.Fig1B.E_H_avrge(end)          data.Ferreira.Fig1B.E_H_avrge(end)], '--', 'Color', [0 0 0.8], 'LineWidth', LW);
% l.d  = plot([0 120], [data.Ferreira.Fig1B.E_H_rH1920_avrge(end)   data.Ferreira.Fig1B.E_H_rH1920_avrge(end)], '--', 'Color', [0 0.8 0.8], 'LineWidth', LW);
% l.e  = plot([0 120], [mean([data.Ferreira.Fig1A.E_H_rH1920_avrge(1) data.Ferreira.Fig1B.E_H_rH1920_avrge(1)]), ...
%                         mean([data.Ferreira.Fig1A.E_H_rH1920_avrge(1) data.Ferreira.Fig1B.E_H_rH1920_avrge(1)])], '--', 'Color', [0.8 0 0.8], 'LineWidth', LW);
% 
% fill([Res.CD59.Time', fliplr(Res.CD59.Time')], [Res.CD59.Lysis(:,1)', fliplr(Res.CD59.Lysis(:,2)')], [0 0.6 0], 'FaceAlpha', 0.3, 'EdgeColor',[0 0.8 0]);
% fill([Res.FH_CD59.Time', fliplr(Res.FH_CD59.Time')], [Res.FH_CD59.Lysis(:,1)', fliplr(Res.FH_CD59.Lysis(:,2)')], [1 0 0], 'FaceAlpha', 0.3, 'EdgeColor',[0.8 0 0]);
% 
% fill([Res.DAF.Time', fliplr(Res.DAF.Time')], [Res.DAF.Lysis(:,1)', fliplr(Res.DAF.Lysis(:,2)')], [0 0 1], 'FaceAlpha', 0.3, 'EdgeColor',[0 0 0.8]);
% fill([Res.FH_DAF.Time', fliplr(Res.FH_DAF.Time')], [Res.FH_DAF.Lysis(:,1)', fliplr(Res.FH_DAF.Lysis(:,2)')], [0 1 1], 'FaceAlpha', 0.3, 'EdgeColor',[0 0.8 0.8]);
% 
% fill([Res.FH.Time', fliplr(Res.FH.Time')], [Res.FH.Lysis(:,1)', fliplr(Res.FH.Lysis(:,2)')], [0.9 0.1 0.9], 'FaceAlpha', 0.3, 'EdgeColor',[0.8 0 0.8]);
% 
% plot([data.Ferreira.Readout_Time data.Ferreira.Readout_Time], [0 120], '--', 'Color', [0 0 0]+0.3)
% 
% xlabel('Time (min)', 'FontSize' ,14)
% ylabel('Hemolysis (%)', 'FontSize' ,14)
% set(gca,'fontWeight','bold')
% grid on
% % xlim([0 20])
% saveas(h, [figure_folder, 'Ferreira_2007_Fig1AB_woLegend.png'], 'png')
% leg = legend([l.a l.b l.c l.d l.e], 'a-CD59', 'a-CD59 + a-FH', 'a-DAF', 'a-DAF + a-FH', 'a-FH', 'Location', 'NorthWest');
% set(leg, 'Interpreter', 'none');
% saveas(h, [figure_folder, 'Ferreira_2007_Fig1AB.png'], 'png')
% clearvars l

end