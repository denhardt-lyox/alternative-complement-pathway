function plot_steady_state_full_model(simdata, ObsLevels, figure_folder, subname)

%% Color definitions
h = figure;
colors = get(gca,'colororder');
colors = repmat(colors, 3, 1);
close(h)


%%

sim_select	= selectbyname(simdata, {'B'});
h = figure;
hold on
l1 = plot(sim_select.Time, sim_select.Data(:,1), '-',  'LineWidth', 1.5, 'Color', colors(1,:));
xlabel(['Time (', sim_select.TimeUnits,')'], 'FontSize' ,14);
ylabel(['Concentration (uM)'], 'FontSize' ,14);
set(gca,'fontWeight','bold');
grid on
set(gca,'YScale', 'log')
ylim([1E-13 1E1])


sim_select	= selectbyname(simdata, {'Ba', 'Bb', 'C3a', 'C5a'});
h = figure;
hold on
l1 = plot(sim_select.Time, sim_select.Data(:,1), '-',  'LineWidth', 1.5, 'Color', colors(1,:));
l2 = plot(sim_select.Time, sim_select.Data(:,2), '--', 'LineWidth', 1.5, 'Color', colors(3,:));
l3 = plot(sim_select.Time, sim_select.Data(:,3), '-',  'LineWidth', 1.5, 'Color', colors(2,:));
l7 = plot(sim_select.Time, sim_select.Data(:,4), '-',  'LineWidth', 1.5, 'Color', colors(4,:));
l4 = plot(sim_select.Time(end), ObsLevels.Ba_uM, '.',  'MarkerSize', 25, 'Color', colors(1,:));
l5 = plot(sim_select.Time(end), ObsLevels.C3a_uM,'.',  'MarkerSize', 23, 'Color', colors(3,:));
l6 = plot(sim_select.Time(end), ObsLevels.Bb_uM, '.',  'MarkerSize', 23, 'Color', colors(2,:));
l8 = plot(sim_select.Time(end), ObsLevels.C5a_uM,'.',  'MarkerSize', 23, 'Color', colors(4,:));
xlabel(['Time (', sim_select.TimeUnits,')'], 'FontSize' ,14);
ylabel(['Concentration (uM)'], 'FontSize' ,14);
set(gca,'fontWeight','bold');
grid on
set(gca,'YScale', 'log')
ylim([1E-13 1E1])
legend([l1 l2 l3 l7 l4(1) l5(1) l6(1) l8(1)], 'Ba', 'Bb', 'C3a', 'C5a', 'Ba (obs. plasma)', ...
                                    'Bb (obs. plasma)', 'C3a (obs. plasma)', 'C5a (obs. plasma)', 'Location', 'SouthEast')
set(gca,'fontWeight','bold')
saveas(h, [figure_folder,'Multiple-Estimate_Full-Model', subname,'_Ba-Bb-C3a-C5a_DataComparison.png'], 'png')

sim_select	= selectbyname(simdata, {'Ba', 'Bb', 'C3a', 'C5a'});
h = figure;
hold on
plot(sim_select.Time, sim_select.Data(:,1), '-',  'LineWidth', 1.5, 'Color', colors(1,:));
plot(sim_select.Time, sim_select.Data(:,2), '--', 'LineWidth', 1.5, 'Color', colors(3,:));
plot(sim_select.Time, sim_select.Data(:,3), '-',  'LineWidth', 1.5, 'Color', colors(2,:));
plot(sim_select.Time, sim_select.Data(:,4), '-',  'LineWidth', 1.5, 'Color', colors(4,:));
xlabel(['Time (', sim_select.TimeUnits,')'], 'FontSize' ,14);
ylabel(['Concentration (uM)'], 'FontSize' ,14);
set(gca,'fontWeight','bold');
grid on
set(gca,'YScale', 'log')
ylim([1E-13 1E1])
legend('Ba', 'Bb', 'C3a', 'C5a', 'Location', 'SouthEast')
set(gca,'fontWeight','bold')
saveas(h, [figure_folder,'Multiple-Estimate_Full-Model', subname,'_Ba-Bb-C3a-C5a.png'], 'png')


sim_select	= selectbyname(simdata, {'B','C3', 'C5', 'C6', 'C7', 'C8', 'C9', 'D', 'I', 'H', 'P', 'Vn', 'Cn', 'CR1', 'CD59', 'DAF'});
h = figure;
hold on
plot(sim_select.Time, sim_select.Data(:,1),  '-',  'LineWidth', 1.5, 'Color', colors(1,:));
plot(sim_select.Time, sim_select.Data(:,2),  '-',  'LineWidth', 1.5, 'Color', colors(2,:));
plot(sim_select.Time, sim_select.Data(:,3),  '-',  'LineWidth', 1.5, 'Color', colors(3,:));
plot(sim_select.Time, sim_select.Data(:,4),  '-',  'LineWidth', 1.5, 'Color', colors(4,:));
plot(sim_select.Time, sim_select.Data(:,5),  '-',  'LineWidth', 1.5, 'Color', colors(5,:));
plot(sim_select.Time, sim_select.Data(:,6),  '-',  'LineWidth', 1.5, 'Color', colors(6,:));
plot(sim_select.Time, sim_select.Data(:,7),  '-',  'LineWidth', 1.5, 'Color', colors(7,:));
plot(sim_select.Time, sim_select.Data(:,8),  '--', 'LineWidth', 1.5, 'Color', colors(8,:));
plot(sim_select.Time, sim_select.Data(:,9),  '--', 'LineWidth', 1.5, 'Color', colors(9,:));
plot(sim_select.Time, sim_select.Data(:,10), '--', 'LineWidth', 1.5, 'Color', colors(10,:));
plot(sim_select.Time, sim_select.Data(:,11), '--', 'LineWidth', 1.5, 'Color', colors(11,:));
plot(sim_select.Time, sim_select.Data(:,12), '--', 'LineWidth', 1.5, 'Color', colors(12,:));
plot(sim_select.Time, sim_select.Data(:,13), '--', 'LineWidth', 1.5, 'Color', colors(13,:));
plot(sim_select.Time, sim_select.Data(:,14), '--', 'LineWidth', 1.5, 'Color', colors(14,:));
plot(sim_select.Time, sim_select.Data(:,15), '--', 'LineWidth', 1.5, 'Color', colors(15,:));
plot(sim_select.Time, sim_select.Data(:,16), '--', 'LineWidth', 1.5, 'Color', colors(16,:));
xlabel(['Time (', sim_select.TimeUnits,')'], 'FontSize' ,14);
ylabel(['Concentration (uM)'], 'FontSize' ,14);
set(gca,'fontWeight','bold');
grid on
set(gca,'YScale', 'log')
ylim([1E-4 1E2])
legend('B','C3', 'C5', 'C6', 'C7', 'C8', 'C9', 'D', 'I', 'H', 'P', 'Vn', 'Cn', 'CR1', 'CD59', 'DAF', 'Location', 'SouthEast')
saveas(h, [figure_folder,'Multiple-Estimate_Full-Model', subname,'_all-produced.png'], 'png')


sim_select	= selectbyname(simdata, {'C3', 'C5', 'C6', 'C7', 'C8', 'C9'});
h = figure;
hold on
plot(sim_select.Time, sim_select.Data(:,1),  '-',  'LineWidth', 1.5, 'Color', colors(1,:));
plot(sim_select.Time, sim_select.Data(:,2),  '-',  'LineWidth', 1.5, 'Color', colors(2,:));
plot(sim_select.Time, sim_select.Data(:,3),  '-',  'LineWidth', 1.5, 'Color', colors(3,:));
plot(sim_select.Time, sim_select.Data(:,4),  '-',  'LineWidth', 1.5, 'Color', colors(4,:));
plot(sim_select.Time, sim_select.Data(:,5),  '-',  'LineWidth', 1.5, 'Color', colors(5,:));
plot(sim_select.Time, sim_select.Data(:,6),  '-',  'LineWidth', 1.5, 'Color', colors(6,:));
xlabel(['Time (', sim_select.TimeUnits,')'], 'FontSize' ,14);
ylabel(['Concentration (uM)'], 'FontSize' ,14);
set(gca,'fontWeight','bold');
grid on
set(gca,'YScale', 'log')
ylim([1E-4 1E2])
legend('C3', 'C5', 'C6', 'C7', 'C8', 'C9', 'Location', 'SouthEast')
saveas(h, [figure_folder,'Multiple-Estimate_Full-Model', subname,'_all-produced-Cx.png'], 'png')


sim_select	= selectbyname(simdata, {'B', 'D', 'I', 'H', 'P', 'Vn', 'Cn', 'CR1', 'CD59', 'DAF'});
h = figure;
hold on
plot(sim_select.Time, sim_select.Data(:,1),  '-',  'LineWidth', 1.5, 'Color', colors(1,:));
plot(sim_select.Time, sim_select.Data(:,2),  '-',  'LineWidth', 1.5, 'Color', colors(2,:));
plot(sim_select.Time, sim_select.Data(:,3),  '-',  'LineWidth', 1.5, 'Color', colors(3,:));
plot(sim_select.Time, sim_select.Data(:,4),  '-',  'LineWidth', 1.5, 'Color', colors(4,:));
plot(sim_select.Time, sim_select.Data(:,5),  '-',  'LineWidth', 1.5, 'Color', colors(5,:));
plot(sim_select.Time, sim_select.Data(:,6),  '-',  'LineWidth', 1.5, 'Color', colors(6,:));
plot(sim_select.Time, sim_select.Data(:,7),  '-',  'LineWidth', 1.5, 'Color', colors(7,:));
plot(sim_select.Time, sim_select.Data(:,8),  '--', 'LineWidth', 1.5, 'Color', colors(8,:));
plot(sim_select.Time, sim_select.Data(:,9),  '--', 'LineWidth', 1.5, 'Color', colors(9,:));
plot(sim_select.Time, sim_select.Data(:,10),  '--', 'LineWidth', 1.5, 'Color', colors(10,:));
xlabel(['Time (', sim_select.TimeUnits,')'], 'FontSize' ,14);
ylabel(['Concentration (uM)'], 'FontSize' ,14);
set(gca,'fontWeight','bold');
grid on
set(gca,'YScale', 'log')
ylim([1E-4 1E2])
legend('B', 'D', 'I', 'H', 'P', 'Vn', 'Cn', 'CR1', 'CD59', 'DAF', 'Location', 'SouthEast')
saveas(h, [figure_folder,'Multiple-Estimate_Full-Model', subname,'_all-produced-Rest.png'], 'png')



sim_select	= selectbyname(simdata, {'B', 'C3'});
h = figure;
hold on
l1 = plot(sim_select.Time, sim_select.Data(:,1), 'LineWidth', 1.5, 'Color', colors(1,:));
l2 = plot(sim_select.Time, sim_select.Data(:,2), 'LineWidth', 1.5, 'Color', colors(2,:));
xlabel(['Time (', sim_select.TimeUnits,')'], 'FontSize' ,14);
ylabel(['Concentration (uM)'], 'FontSize' ,14);
set(gca,'fontWeight','bold');
grid on
set(gca,'YScale', 'log')
ylim([1E-4 1E1])
legend([l1 l2], 'B', 'C3', 'Location', 'SouthEast')
saveas(h, [figure_folder,'Multiple-Estimate_Full-Model', subname,'_B-C3.png'], 'png')


sim_select	= selectbyname(simdata, {'B', 'C3', 'C5', 'P'});
h = figure;
hold on
plot(sim_select.Time, sim_select.Data(:,1), 'LineWidth', 1.5, 'Color', colors(1,:));
plot(sim_select.Time, sim_select.Data(:,2), 'LineWidth', 1.5, 'Color', colors(2,:));
plot(sim_select.Time, sim_select.Data(:,3), 'LineWidth', 1.5, 'Color', colors(4,:));
plot(sim_select.Time, sim_select.Data(:,4), 'LineWidth', 1.5, 'Color', colors(5,:));
xlabel(['Time (', sim_select.TimeUnits,')'], 'FontSize' ,14);
ylabel(['Concentration (uM)'], 'FontSize' ,14);
set(gca,'fontWeight','bold');
grid on
set(gca,'YScale', 'log')
ylim([1E-4 1E1])
legend('B', 'C3', 'C5', 'P', 'Location', 'SouthEast')
saveas(h, [figure_folder,'Multiple-Estimate_Full-Model', subname,'_B-C3-C5-P.png'], 'png')

sim_select	= selectbyname(simdata, {'B', 'C3', 'C5', 'P', 'I'});
h = figure;
hold on
plot(sim_select.Time, sim_select.Data(:,1), 'LineWidth', 1.5, 'Color', colors(1,:));
plot(sim_select.Time, sim_select.Data(:,2), 'LineWidth', 1.5, 'Color', colors(2,:));
plot(sim_select.Time, sim_select.Data(:,3), 'LineWidth', 1.5, 'Color', colors(4,:));
plot(sim_select.Time, sim_select.Data(:,4), 'LineWidth', 1.5, 'Color', colors(5,:));
plot(sim_select.Time, sim_select.Data(:,5), 'LineWidth', 1.5, 'Color', colors(7,:));
xlabel(['Time (', sim_select.TimeUnits,')'], 'FontSize' ,14);
ylabel(['Concentration (uM)'], 'FontSize' ,14);
set(gca,'fontWeight','bold');
grid on
set(gca,'YScale', 'log')
ylim([1E-4 1E1])
legend('B', 'C3', 'C5', 'P', 'I', 'Location', 'SouthEast')
saveas(h, [figure_folder,'Multiple-Estimate_Full-Model', subname,'_B-C3-C5-I-P.png'], 'png')


sim_select	= selectbyname(simdata, {'Percent_Lysis_Takeda', 'Percent_Lysis_Kolb'});
h = figure;
hold on
fill([sim_select.Time', fliplr(sim_select.Time')],...
            [sim_select.Data(:,1)', fliplr(sim_select.Data(:,2)')],...
            colors(1,:), 'FaceAlpha', 0.3, 'EdgeColor', colors(1,:));
xlabel(['Time (', sim_select.TimeUnits,')'], 'FontSize' ,14);
ylabel(['Hemolysis (%)'], 'FontSize' ,14);
set(gca,'fontWeight','bold');
grid on
ylim([0 100])
set(gca,'fontWeight','bold')
saveas(h, [figure_folder,'Multiple-Estimate_Full-Model', subname,'_Lysis.png'], 'png')

end