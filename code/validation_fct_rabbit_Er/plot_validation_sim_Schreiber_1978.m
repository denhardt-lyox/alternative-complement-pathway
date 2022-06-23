function plot_validation_sim_Schreiber_1978(figure_folder, data, res)

%% plot settings
FS.axis   = 16;
FS.legend = 16;
FS.labels = 20;

%% Serum dilution vs complement mix dilution - Fig 2
h = figure;
hold on
plot(data.Schreiber.Fig_2.Dilution, data.Schreiber.Fig_2.Lysis_Serum,      '^', 'Color', [0 0 0]);
plot(data.Schreiber.Fig_2.Dilution, data.Schreiber.Fig_2.Lysis_Components, 'o', 'Color', [0 0 0]);
plot(res.Fig2.dilution, res.Fig2.lysis_Serum(:,1), '-', 'Color', [0 0 0], 'LineWidth', 2);
% plot(res.Fig2.dilution, res.lysis_Serum(:,2), '--', 'Color', [0 0 0], 'LineWidth', 2);
plot(res.Fig2.dilution, res.Fig2.lysis_Components(:,1), '--', 'Color', [0 0 0], 'LineWidth', 2);
% plot(res.Fig2.dilution, res.lysis_Components(:,1), '-', 'Color', [0 0 0], 'LineWidth', 2);
set(gca,'FontSize', FS.axis)
xlabel('Dilution', 'FontSize' , FS.labels)
ylabel('Hemolysis (%)', 'FontSize' , FS.labels)
grid on
box on
leg = legend('Serum', 'Components', 'Model - Serum', 'Model - Components', 'Location', 'SouthEast');
set(leg, 'Interpreter', 'none', 'FontSize', FS.legend);
saveas(h, [figure_folder, 'Schreiber_1978_Fig2_Serum-Components.png'], 'png')

%% Serum dilution with and without Properdin - Fig 3
h = figure;
hold on
plot(data.Schreiber.Fig_3.Dilution, data.Schreiber.Fig_3.Lysis_W_P,  '^', 'Color', [0 0 0]);
plot(data.Schreiber.Fig_3.Dilution, data.Schreiber.Fig_3.Lysis_WO_P, 'o', 'Color', [0 0 0]);
plot(res.Fig3.dilution, res.Fig3.lysis_with_P(:,1), '-', 'Color', [0 0 0], 'LineWidth', 2);
% plot(res.Fig3.dilution, res.lysis_Serum(:,2), '--', 'Color', [0 0 0], 'LineWidth', 2);
plot(res.Fig3.dilution, res.Fig3.lysis_w0_P(:,1), '--', 'Color', [0 0 0], 'LineWidth', 2);
% plot(res.Fig2.dilution, res.lysis_Components(:,1), '-', 'Color', [0 0 0], 'LineWidth', 2);
set(gca,'FontSize', FS.axis)
xlabel('Dilution', 'FontSize', FS.labels)
ylabel('Hemolysis (%)', 'FontSize', FS.labels)
grid on
box on
leg = legend('+P', '-P', 'Model +P', 'Model -P', 'Location', 'SouthEast');
set(leg, 'Interpreter', 'none', 'FontSize', FS.legend);
saveas(h, [figure_folder, 'Schreiber_1978_Fig3_Properdin.png'], 'png')
end