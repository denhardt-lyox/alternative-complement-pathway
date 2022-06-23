function plot_validation_sim_Wu_2018(figure_folder, data, res, D_0_20percent, C3_0_20percent)

%%
MW = get_MW();

%% plot settings
FS.axis   = 16;
FS.legend = 16;
FS.labels = 20;

%% FD- or C3-depleted serum mixing with WT serum experiment
h = figure;
hold on
l.a = plot(data.Wu.Fig10D.WT_Serum_FD, data.Wu.Fig10D.Lysis_FD, '^', 'Color', [0 0 0], 'LineWidth', 1.2);
l.b = plot(data.Wu.Fig10D.WT_Serum_C3, data.Wu.Fig10D.Lysis_C3, 'o', 'Color', [1 0 0], 'LineWidth', 1.2);
plot(res.fd.dilution, res.fd.lysis(:,1), '-', 'Color', [0 0 0], 'LineWidth', 1.2)
% plot(res.fd.dilution, res.fd.lysis(:,2), '--', 'Color', [0 0 0], 'LineWidth', 1.2)
plot(res.c3.dilution, res.c3.lysis(:,1), '-', 'Color', [1 0 0], 'LineWidth', 1.2)
% plot(res.c3.dilution, res.c3.lysis(:,2), '--', 'Color', [1 0 0], 'LineWidth', 1.2)
set(gca,'XScale','log', 'FontSize', FS.axis)
leg = legend([l.a l.b], 'FD', 'C3', 'Location', 'NorthWest');
set(leg, 'Interpreter', 'none', 'FontSize', FS.legend);
xlabel('WT serum (%)', 'FontSize', FS.labels)
ylabel('Hemolysis (%)', 'FontSize', FS.labels)
grid on
box on
xticks(logspace(-2, 2, 5));
% saveas(h, [figure_folder, 'Wu_2018_Fig10D.png'], 'png')
print('-dpng','-r600',[figure_folder, 'Wu_2018_Fig10D.png'])
clearvars l

%% FD- or C3-depleted serum mixing with WT serum experiment - concentration on x-axis
h = figure;
hold on
l.a = plot(data.Wu.Fig10D.WT_Serum_FD ./ 100 .* D_0_20percent, data.Wu.Fig10D.Lysis_FD, '^', 'Color', [0 0 0], 'LineWidth', 1.2);
l.b = plot(data.Wu.Fig10D.WT_Serum_C3 ./ 100 .* C3_0_20percent, data.Wu.Fig10D.Lysis_C3, 'o', 'Color', [1 0 0], 'LineWidth', 1.2);
plot(res.fd.FD_conc, res.fd.lysis(:,1), '-', 'Color', [0 0 0], 'LineWidth', 1.2)
plot(res.c3.C3_conc, res.c3.lysis(:,1), '-', 'Color', [1 0 0], 'LineWidth', 1.2)
set(gca,'XScale','log', 'FontSize', FS.axis)
leg = legend([l.a l.b], 'FD', 'C3', 'Location', 'NorthWest');
set(leg, 'Interpreter', 'none', 'FontSize', FS.legend);
xlabel('FD or C3 (uM)', 'FontSize', FS.labels)
ylabel('Norm. hemolysis (%)', 'FontSize', FS.labels)
grid on
box on
xticks(logspace(-6, 0, 4));
ylim([-2 120])
% saveas(h, [figure_folder, 'Wu_2018_Fig10D-conc.png'], 'png')
print('-dpng','-r600',[figure_folder, 'Wu_2018_Fig10D-conc.png'])
clearvars l


%% FD dose response curve at 5 and 30 min
h = figure;
hold on
l.a = errorbar(data.Wu.Fig11A.hFD_ngml ./ 1E3, data.Wu.Fig11A.RBC_lysis_Mean_percent, data.Wu.Fig11A.RBC_lysis_Error_percent, '^', 'Color', [1 0 0], 'LineWidth', 1.2);
l.b = errorbar(data.Wu.Fig11C.hFD_ngml ./ 1E3, data.Wu.Fig11C.RBC_lysis_Mean_percent, data.Wu.Fig11C.RBC_lysis_Error_percent , 'o', 'Color', [0 0 0],    'LineWidth', 1.2);
plot(res.min5.hFD_ngml ./ 1E3, res.min5.lysis(:,1), '-', 'Color', [1 0 0], 'LineWidth', 1.2)
% plot(res.min5.hFD_ngml ./ 1E3, res.min5.lysis(:,2), '--', 'Color', [0 0 0]+0.5, 'LineWidth', 1.2)
plot(res.min30.hFD_ngml ./ 1E3, res.min30.lysis(:,1), '-', 'Color', [0 0 0], 'LineWidth', 1.2)
% plot(res.min30.hFD_ngml ./ 1E3, res.min30.lysis(:,2), '--', 'Color', [0 0 0], 'LineWidth', 1.2)
set(gca,'XScale','log','FontSize', FS.axis)
leg = legend([l.a l.b], '5 min', '30 min');
set(leg, 'Interpreter', 'none', 'FontSize', FS.legend);
xlabel('FD (ug/mL)', 'FontSize', FS.labels)
ylabel('Norm. hemolysis (%)', 'FontSize', FS.labels)
ylim([-2 125])
grid on
box on
% saveas(h, [figure_folder, 'Wu_2018_Fig11AC.png'], 'png')
print('-dpng','-r600',[figure_folder, 'Wu_2018_Fig11AC.png'])
clearvars l

%%% x-axis in uM instead of ug/mL
h = figure;
hold on
l.a = errorbar(data.Wu.Fig11A.hFD_ngml ./ 1E3 .*1E3 ./ MW.D, data.Wu.Fig11A.RBC_lysis_Mean_percent, data.Wu.Fig11A.RBC_lysis_Error_percent, '^', 'Color', [1 0 0], 'LineWidth', 1.2);
l.b = errorbar(data.Wu.Fig11C.hFD_ngml ./ 1E3 .*1E3 ./ MW.D, data.Wu.Fig11C.RBC_lysis_Mean_percent, data.Wu.Fig11C.RBC_lysis_Error_percent , 'o', 'Color', [0 0 0],    'LineWidth', 1.2);
plot(res.min5.hFD_ngml ./ 1E3 .*1E3 ./ MW.D, res.min5.lysis(:,1), '-', 'Color', [1 0 0], 'LineWidth', 1.2)
% plot(res.min5.hFD_ngml ./ 1E3 .*1E3 ./ MW.D, res.min5.lysis(:,2), '--', 'Color', [0 0 0]+0.5, 'LineWidth', 1.2)
plot(res.min30.hFD_ngml ./ 1E3 .*1E3 ./ MW.D, res.min30.lysis(:,1), '-', 'Color', [0 0 0], 'LineWidth', 1.2)
% plot(res.min30.hFD_ngml ./ 1E3 .*1E3 ./ MW.D, res.min30.lysis(:,2), '--', 'Color', [0 0 0], 'LineWidth', 1.2)
set(gca,'XScale','log', 'FontSize', FS.axis)
leg = legend([l.a l.b], '5 min', '30 min');
set(leg, 'Interpreter', 'none', 'FontSize', FS.legend);
xlabel('FD (uM)', 'FontSize', FS.labels)
ylabel('Norm. hemolysis (%)', 'FontSize', FS.labels)
xlim([5E-4 1E0])
ylim([-2 125])
grid on
box on
% saveas(h, [figure_folder, 'Wu_2018_Fig11AC_uM.png'], 'png')
print('-dpng','-r600',[figure_folder, 'Wu_2018_Fig11AC_uM.png'])
clearvars l


%% Time course with 400 ng/ml FD
h = figure;
hold on
l.a = errorbar(data.Wu.Fig11B.Time_min, data.Wu.Fig11B.Lysis_Mean_percent, data.Wu.Fig11B.Lysis_Error_percent, '^', 'Color', [0 0 0], 'LineWidth', 1.2);
plot(res.hFD400.time, res.hFD400.lysis(:,1), '-', 'Color', [0 0 0], 'LineWidth', 1.5);
% plot(res.hFD400.time, res.hFD400.lysis(:,2), '--', 'Color', [0 0 0], 'LineWidth', 1.5);
xlim([0 125])
ylim([-2 105])
set(gca,'FontSize', FS.axis)
xlabel('Time (min)', 'FontSize', FS.labels)
ylabel('Norm. hemolysis (%)', 'FontSize', FS.labels)
grid on
box on
% saveas(h, [figure_folder, 'Wu_2018_Fig11B.png'], 'png')
print('-dpng','-r600',[figure_folder, 'Wu_2018_Fig11B.png'])
clearvars l
end