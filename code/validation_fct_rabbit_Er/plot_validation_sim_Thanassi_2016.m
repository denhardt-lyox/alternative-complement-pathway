function plot_validation_sim_Thanassi_2016(figure_folder, data, init_default, init_new, MW, FD, FB, C5)
%% ASSUMPTION FOR FIG 3A: total Bb is measured (not only free)!

%%
MW = get_MW;


%% plot settings
FS.axis   = 16;
FS.legend = 16;
FS.labels = 20;

%% Fig. 1 - titration of C5, FB, FD -> lysis 
%%% x axis in uM
h = figure;
hold on
l.a = plot(data.Thanassi.Hemolysis.C5,   data.Thanassi.Hemolysis.HEMOLYSIS_C5, '^', 'Color', [0 0.6 0]    , 'LineWidth', 1.2);
      plot(data.Thanassi.C5.Hemolysis_x, data.Thanassi.C5.Hemolysis_y,         '^', 'Color', [0 0.6 0]    , 'LineWidth', 1.2);
l.b = plot(data.Thanassi.Hemolysis.fB,   data.Thanassi.Hemolysis.HEMOLYSIS_fB, 'o', 'Color',   [0.4 0.4 1]  , 'LineWidth', 1.2);
l.c = plot(data.Thanassi.Hemolysis.fD,   data.Thanassi.Hemolysis.HEMOLYSIS_fD, 's', 'Color', [0 0 0]      , 'LineWidth', 1.2);
      plot(data.Thanassi.fD.Hemolysis_x, data.Thanassi.fD.Hemolysis_y,         's', 'Color', [0 0 0]      , 'LineWidth', 1.2);
plot(FD.ugml, FD.Lysis(:,1)', '-',  'Color', [0 0 0],       'LineWidth', 2);
% plot(FD.ugml, FD.Lysis(:,2)', '--', 'Color', [0 0 0],       'LineWidth', 1.5);
plot(C5.ugml, C5.Lysis(:,1)', '-',  'Color', [0 0.6 0],     'LineWidth', 2);
% plot(C5.ugml, C5.Lysis(:,2)', '--', 'Color', [0 0.6 0],     'LineWidth', 1.5);
plot(FB.ugml, FB.Lysis(:,1)', '-',  'Color', [0.4 0.4 1],   'LineWidth', 2);
% plot(FB.ugml, FB.Lysis(:,2)', '--', 'Color', [0.4 0.4 1],   'LineWidth', 1.5);
set(gca, 'FontSize', FS.axis)
set(gca, 'xscale','log')
xticks(logspace(-6,2,5))
yticks(0:50:400)
ylim([-5 250])
xlabel('FB, FD or C5 (ug/mL)', 'FontSize', FS.labels)
ylabel('Norm. hemolysis (%)',        'FontSize', FS.labels)
grid on
box on
saveas(h, [figure_folder, 'Thanassi_2016_Fig1A_woLegend.png'], 'png')
leg = legend([l.a l.b l.c], 'C5', 'FB', 'FD', 'Location', 'NorthWest');
set(leg, 'Interpreter', 'none', 'FontSize', FS.legend);
% saveas(h, [figure_folder, 'Thanassi_2016_Fig1A.png'], 'png')
print('-dpng','-r600',[figure_folder, 'Thanassi_2016_Fig1A.png'])
clearvars l

%%% x axis in uM
h = figure;
hold on
l.a = plot(data.Thanassi.Hemolysis.C5   .* 1E3 ./ MW.C5, data.Thanassi.Hemolysis.HEMOLYSIS_C5, '^', 'Color', [0 0.6 0]    , 'LineWidth', 1.2);
      plot(data.Thanassi.C5.Hemolysis_x .* 1E3 ./ MW.C5, data.Thanassi.C5.Hemolysis_y,         '^', 'Color', [0 0.6 0]    , 'LineWidth', 1.2);

l.b = plot(data.Thanassi.Hemolysis.fB   .* 1E3 ./ MW.B,  data.Thanassi.Hemolysis.HEMOLYSIS_fB, 'o', 'Color', [0.4 0.4 1]  , 'LineWidth', 1.2);
l.c = plot(data.Thanassi.Hemolysis.fD   .* 1E3 ./ MW.D,  data.Thanassi.Hemolysis.HEMOLYSIS_fD, 's', 'Color', [0 0 0]      , 'LineWidth', 1.2);
      plot(data.Thanassi.fD.Hemolysis_x .* 1E3 ./ MW.D,  data.Thanassi.fD.Hemolysis_y,         's', 'Color', [0 0 0]      , 'LineWidth', 1.2);

plot(FD.ugml .* 1E3 ./ MW.D, FD.Lysis(:,1)', '-',  'Color', [0 0 0],       'LineWidth', 2);
% plot(FD.ugml .* 1E3 ./ MW.D, FD.Lysis(:,2)', '--', 'Color', [0 0 0],       'LineWidth', 1.5);
plot(C5.ugml .* 1E3 ./ MW.C5, C5.Lysis(:,1)', '-',  'Color', [0 0.6 0],     'LineWidth', 2);
% plot(C5.ugml .* 1E3 ./ MW.C5, C5.Lysis(:,2)', '--', 'Color', [0 0.6 0],     'LineWidth', 1.5);
plot(FB.ugml .* 1E3 ./ MW.B, FB.Lysis(:,1)', '-',  'Color', [0.4 0.4 1],   'LineWidth', 2);
% plot(FB.ugml .* 1E3 ./ MW.B, FB.Lysis(:,2)', '--', 'Color', [0.4 0.4 1],   'LineWidth', 1.5);
set(gca, 'FontSize', FS.axis)
set(gca, 'xscale','log')
xlim([1E-10 1E1])
xticks(logspace(-10,2,5))
yticks(0:50:500)
ylim([-5 250])
xlabel('FB, FD or C5 (uM)', 'FontSize', FS.labels)
ylabel('Norm. hemolysis (%)',        'FontSize', FS.labels)
grid on
box on
leg = legend([l.a l.b l.c], 'C5', 'FB', 'FD', 'Location', 'NorthWest');
set(leg, 'Interpreter', 'none', 'FontSize', FS.legend);
% saveas(h, [figure_folder, 'Thanassi_2016_Fig1A_uM.png'], 'png')
print('-dpng','-r600',[figure_folder, 'Thanassi_2016_Fig1A_uM.png'])
clearvars l


%% Fig. 3A - titration of FD -> lysis, C5a, Bb
% h = figure;
% left_color = [0.9 0 0]; %[0 0 0]
% right_color = [0 0 0];
% set(h,'defaultAxesColorOrder',[left_color; right_color]);
% hold on
% yyaxis left
% l.a = plot(data.Thanassi.fD.Hemolysis_x, data.Thanassi.fD.Hemolysis_y, '-o', 'Color', [1 0 0]);
% ylabel('Normalized Hemolysis', 'FontSize' ,14)
% yyaxis right
% l.b = plot(data.Thanassi.fD.Bb_x, data.Thanassi.fD.Bb_y, '-s', 'Color', [0 0.6 0]);
% l.c = plot(data.Thanassi.fD.C5a_x, data.Thanassi.fD.C5a_y, '-^', 'Color', [0 0 0]);
% yyaxis left
% fill([FD.ugml, fliplr(FD.ugml)], [FD.Lysis(:,1)', fliplr(FD.Lysis(:,2)')], [1 0 0], 'FaceAlpha', 0.3, 'EdgeColor',[0.7 0 0]); %xscale  .* 1E3
% yyaxis right
% plot(FD.ugml, FD.C5a_ugml, '-', 'Color', [0 0 0]);
% l.d = plot(FD.ugml, FD.Bb_ugml, '-', 'Color', [0 1 0]);
% ylabel('Bb or C5a (ug/mL)', 'FontSize' ,14)
% set(gca,'xscale','log')
% xlim([1E-6 1E2])
% leg = legend([l.a l.b l.c l.d], 'Hem', 'Bb', 'C5a', 'Bb incl. complexes', 'Location', 'NorthWest');
% set(leg, 'Interpreter', 'none');
% xlabel('FD (ug/mL)', 'FontSize' ,14)
% set(gca,'fontWeight','bold')
% grid on
% saveas(h, [figure_folder, 'Thanassi_2016_Fig3A.png'], 'png')
% clearvars l

%% Fig. 3A - titration of FD -> C5a, Bb (w/o lysis)
%%% x-axis in ug/mL
h = figure;
left_color =  [0.4 0.4 1];
right_color = [0 0.6 0];
set(h,'defaultAxesColorOrder',[left_color; right_color]);
hold on
set(gca, 'FontSize', FS.axis)

yyaxis left
l.b = plot(data.Thanassi.fD.Bb_x, data.Thanassi.fD.Bb_y, 's', 'Color', left_color, 'LineWidth', 1.2);
% plot(FD.ugml, FD.Bb_ugml, '-', 'Color', left_color, 'LineWidth',2);
% l.d = plot(FD.ugml, FD.Bb_ugml_max, '--', 'Color', left_color, 'LineWidth',2);
plot(FD.ugml, FD.Bb_ugml_max, '-', 'Color', left_color, 'LineWidth',2);
ylabel('Bb (ug/mL)', 'FontSize', FS.labels)

yyaxis right
l.c = plot(data.Thanassi.fD.C5a_x, data.Thanassi.fD.C5a_y, '^', 'Color', right_color, 'LineWidth', 1.2);
plot(FD.ugml, FD.C5a_ugml, '-', 'Color', right_color, 'LineWidth',2);
ylabel('C5a (ug/mL)', 'FontSize', FS.labels)

set(gca,'xscale','log')
xlim([1E-2 1E1])
% leg = legend([l.c l.b l.d], 'C5a', 'Bb', 'Bb incl. complexes', 'Location', 'NorthWest');
leg = legend([l.c l.b], 'C5a', 'Bb', 'Location', 'NorthWest');
set(leg, 'Interpreter', 'none', 'FontSize', FS.legend);
xlabel('FD (ug/mL)', 'FontSize', FS.labels)
% set(gca,'fontWeight','bold')
grid on
box on
% saveas(h, [figure_folder, 'Thanassi_2016_Fig3A_woLysis.png'], 'png')
print('-dpng','-r600',[figure_folder, 'Thanassi_2016_Fig3A_woLysis.png'])
clearvars l

%%% x-axis in uM
h = figure;
left_color =  [0.4 0.4 1];
right_color = [0 0.6 0];
set(h,'defaultAxesColorOrder',[left_color; right_color]);
hold on
set(gca, 'FontSize', FS.axis)

yyaxis left
l.b = plot(data.Thanassi.fD.Bb_x .* 1E3 ./ MW.D, data.Thanassi.fD.Bb_y .* 1E3 ./ MW.Bb, 's', 'Color', left_color, 'LineWidth', 1.2);
% plot(FD.ugml .* 1E3 ./ MW.D, FD.Bb_ugml .* 1E3 ./ MW.Bb, '-', 'Color', left_color, 'LineWidth',2);
% l.d = plot(FD.ugml .* 1E3 ./ MW.D, FD.Bb_ugml_max .* 1E3 ./ MW.Bb, '--', 'Color', left_color, 'LineWidth',2);
plot(FD.ugml .* 1E3 ./ MW.D, FD.Bb_ugml_max .* 1E3 ./ MW.Bb, '-', 'Color', left_color, 'LineWidth',2);
ylabel('Bb (uM)', 'FontSize', FS.labels)
ylim([-0.001 0.05])

yyaxis right
l.c = plot(data.Thanassi.fD.C5a_x .* 1E3 ./ MW.D, data.Thanassi.fD.C5a_y .* 1E3 ./ MW.C5a, '^', 'Color', right_color, 'LineWidth', 1.2);
plot(FD.ugml .* 1E3 ./ MW.D, FD.C5a_ugml .* 1E3 ./ MW.C5a, '-', 'Color', right_color, 'LineWidth',2);
ylabel('C5a (uM)', 'FontSize', FS.labels)
ylim([-0.0004 0.02])

set(gca,'xscale','log')
% ylim([0 0.25])
xlim([1E-4 1E-1])
xticks([1E-5 1E-4 1E-3 1E-2 1E-1 1E0])
yticks([0 0.005 0.01 0.015 0.02])
yticklabels({'0' '0.005' '0.01' '0.015' '0.02'})
% leg = legend([l.c l.b l.d], 'C5a', 'Bb', 'Bb+complexes', 'Location', 'NorthWest');
leg = legend([l.c l.b], 'C5a', 'Bb', 'Location', 'NorthWest');
set(leg, 'Interpreter', 'none', 'FontSize', FS.legend);
xlabel('FD (uM)', 'FontSize', FS.labels)
% set(gca,'fontWeight','bold')
grid on
box on
% saveas(h, [figure_folder, 'Thanassi_2016_Fig3A_woLysis_uM.png'], 'png')
print('-dpng','-r600',[figure_folder, 'Thanassi_2016_Fig3A_woLysis_uM.png'])
clearvars l


%% Fig. 3B
%%% Fig. 3B - titration of C5 -> lysis, C5a, Bb
% h = figure;
% left_color = [0.9 0 0]; %[0 0 0]
% right_color = [0 0 0];
% set(h,'defaultAxesColorOrder',[left_color; right_color]);
% hold on
% yyaxis left
% l.a = plot(data.Thanassi.C5.Hemolysis_x, data.Thanassi.C5.Hemolysis_y, '-o', 'Color', [1 0 0]);
% ylabel('Normalized Hemolysis', 'FontSize' ,14)
% yyaxis right
% l.b = plot(data.Thanassi.C5.Bb_x, data.Thanassi.C5.Bb_y, '-s', 'Color', [0 0.6 0]);
% l.c = plot(data.Thanassi.C5.C5a_x, data.Thanassi.C5.C5a_y, '-^', 'Color', [0 0 0]);
% yyaxis left
% fill([C5.ugml, fliplr(C5.ugml)], [C5.Lysis(:,1)', fliplr(C5.Lysis(:,2)')], [1 0 0], 'FaceAlpha', 0.3, 'EdgeColor',[0.7 0 0]); %xscale  .* 1E3
% yyaxis right
% plot(C5.ugml, C5.C5a_ugml, '-', 'Color', [0 0 0]);
% l.d = plot(C5.ugml, C5.Bb_ugml, '-', 'Color', [0 1 0]);
% ylabel('Bb or C5a (ug/mL)', 'FontSize' ,14)
% set(gca,'xscale','log')
% xlim([1E-6 3E2])
% leg = legend([l.a l.b l.c l.d], 'Hem', 'Bb', 'C5a', 'Bb incl. complexes', 'Location', 'NorthWest');
% set(leg, 'Interpreter', 'none');
% xlabel('ug/mL C5', 'FontSize' ,14)
% set(gca,'fontWeight','bold')
% grid on
% saveas(h, [figure_folder, 'Thanassi_2016_Fig3B.png'], 'png')
% clearvars l

%%% Fig. 3B - titration of FB -> C5a, Bb (w/o lysis)
% h = figure;
% left_color = [0 0.6 0]; %[0 0 0]
% right_color = [0 0 0];
% set(h,'defaultAxesColorOrder',[left_color; right_color]);
% hold on
% yyaxis left
% l.b = plot(data.Thanassi.C5.Bb_x, data.Thanassi.C5.Bb_y, '-s', 'Color', [0 0.6 0]);
% yyaxis right
% l.c = plot(data.Thanassi.C5.C5a_x, data.Thanassi.C5.C5a_y, '-^', 'Color', [0 0 0]);
% l.e = plot(C5.ugml, C5.maxC5a_ugml, '--r', 'LineWidth',1);
% yyaxis left
% plot(C5.ugml, C5.Bb_ugml, '-', 'Color', [0 0.6 0], 'LineWidth',1);
% l.d = plot(C5.ugml, C5.Bb_ugml_max, '--', 'Color', [0 0.6 0], 'LineWidth',2);
% ylabel('Bb (ug/mL)', 'FontSize' ,14)
% ylim([0 5])
% yyaxis right
% plot(C5.ugml, C5.C5a_ugml, '-', 'Color', [0 0 0], 'LineWidth',2);
% ylabel('C5a (ug/mL)', 'FontSize' ,14)
% ylim([0 0.25])
% set(gca,'xscale','log')
% xlim([1E-6 3E2])
% leg = legend([l.c l.b l.d l.e], 'C5a', 'Bb', 'Bb incl. complexes', 'max possible C5a', 'Location', 'NorthWest');
% set(leg, 'Interpreter', 'none');
% xlabel('ug/mL C5', 'FontSize' ,14)
% set(gca,'fontWeight','bold')
% grid on
% saveas(h, [figure_folder, 'Thanassi_2016_Fig3B_woLysis.png'], 'png')
% clearvars l
end