function plot_validation_sim_Pangburn_2002(figure_folder, data, res)

%% plot settings
FS.axis   = 16;
FS.legend = 16;
FS.labels = 20;

%%
h = figure;
hold on
plot(data.Pangburn.Fig2.Serum_conc, data.Pangburn.Fig2.Lysis_Er_FH, '^', 'Color', [0 0 0]);
plot(data.Pangburn.Fig2.Serum_conc, data.Pangburn.Fig2.Lysis_Er_rH, 'v', 'Color', [0 0 0]);
plot(data.Pangburn.Fig2.Serum_conc, data.Pangburn.Fig2.Lysis_Er_rH1120, 'd', 'Color', [0 0 0]);
plot(data.Pangburn.Fig3.Serum_conc, data.Pangburn.Fig3.Lysis_Er_rH610, 's', 'Color', [0 0 0]);
plot(data.Pangburn.Fig3.Serum_conc, data.Pangburn.Fig3.Lysis_Er_rH1115, 'o', 'Color', [0 0 0]);
plot(data.Pangburn.Fig3.Serum_conc, data.Pangburn.Fig3.Lysis_Er_rH1620, '<', 'Color', [0 0 0]);
% fill([res.dilution', fliplr(res.dilution')], [res.lysis(:,1)', fliplr(res.lysis(:,2)')], [0 0 0]+0.1, 'FaceAlpha', 0.4, 'EdgeColor',[0 0 0]+0.1);
plot(res.dilution, res.lysis(:,1), '-', 'Color', [0 0 0], 'LineWidth', 2);
% plot(res.dilution, res.lysis(:,2), '--', 'Color', [0 0 0], 'LineWidth', 2);
ylim([-2 105])
% leg = legend([l.a l.b l.c], 'C5', 'B', 'D', 'Location', 'NorthWest');
% set(leg, 'Interpreter', 'none', 'FontSize', FS.legend);
set(gca,'FontSize', FS.axis)
xlabel('Serum concentration (%)', 'FontSize', FS.labels)
ylabel('Norm. hemolysis (%)', 'FontSize', FS.labels)
% set(gca,'fontWeight','bold')
grid on
box on
% saveas(h, [figure_folder, 'Pangburn_2002_Fig1A.png'], 'png')
print('-dpng','-r600',[figure_folder, 'Pangburn_2002_Fig1A.png'])
% clearvars l

end