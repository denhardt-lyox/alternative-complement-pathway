function plot_validation_sim_Pangburn_1983(figure_folder, data, simdata)

%% plot settings
FS.axis   = 16;
FS.legend = 16;
FS.labels = 20;

%% Fig 2
    h = figure;
    hold on
    plot(data.Pangburn1983.Fig2.H_790_x - 35,  data.Pangburn1983.Fig2.H_790_y_Percent, '--', 'Color', [0 0 0]+0.3, 'LineWidth', 1)
    plot(data.Pangburn1983.Fig2.H_393_x - 35,  data.Pangburn1983.Fig2.H_393_y_Percent, '--', 'Color', [0 0 0]+0.3, 'LineWidth', 1)
    plot(data.Pangburn1983.Fig2.H_197_x - 35,  data.Pangburn1983.Fig2.H_197_y_Percent, '--', 'Color', [0 0 0]+0.3, 'LineWidth', 1)
    plot(data.Pangburn1983.Fig2.H_98_5_x - 35, data.Pangburn1983.Fig2.H_98_5_y_Percent, '--', 'Color', [0 0 0]+0.3, 'LineWidth', 1)
    plot(data.Pangburn1983.Fig2.H_49_3_x - 35, data.Pangburn1983.Fig2.H_49_3_y_Percent, '--', 'Color', [0 0 0]+0.3, 'LineWidth', 1)
    plot(data.Pangburn1983.Fig2.H_12_4_x - 35, data.Pangburn1983.Fig2.H_12_4_y_Percent, '--', 'Color', [0 0 0]+0.3, 'LineWidth', 1)
    plot(data.Pangburn1983.Fig2.H_4_5_x - 35,  data.Pangburn1983.Fig2.H_4_5_y_Percent, '--', 'Color', [0 0 0]+0.3, 'LineWidth', 1)
    
    plot(0:10:300, (simdata.C3b(:,1) + simdata.C3bH(:,1)) ./ 3.7 .*100, '-', 'Color', [0 0 0], 'LineWidth', 1.3)
    plot(0:10:300, (simdata.C3b(:,2) + simdata.C3bH(:,2)) ./ 3.7 .*100, '-', 'Color', [0 0 0], 'LineWidth', 1.3)
    plot(0:10:300, (simdata.C3b(:,3) + simdata.C3bH(:,3)) ./ 3.7 .*100, '-', 'Color', [0 0 0], 'LineWidth', 1.3)
    plot(0:10:300, (simdata.C3b(:,4) + simdata.C3bH(:,4)) ./ 3.7 .*100, '-', 'Color', [0 0 0], 'LineWidth', 1.3)
    plot(0:10:300, (simdata.C3b(:,5) + simdata.C3bH(:,5)) ./ 3.7 .*100, '-', 'Color', [0 0 0], 'LineWidth', 1.3)
    plot(0:10:300, (simdata.C3b(:,6) + simdata.C3bH(:,6)) ./ 3.7 .*100, '-', 'Color', [0 0 0], 'LineWidth', 1.3)
    plot(0:10:300, (simdata.C3b(:,7) + simdata.C3bH(:,7)) ./ 3.7 .*100, '-', 'Color', [0 0 0], 'LineWidth', 1.3)
   
    set(gca,'fontsize', FS.axis)
    xlabel('Time (s)',               'FontSize', FS.labels);
    ylabel('C3b (% of initial C3b)', 'FontSize', FS.labels);
    box on
    grid on
    ylim([0 100])
%     l = legend('', 'Location', 'SouthEast');
%     set(l, 'fontsize', FS.legend, 'Location', 'SouthEast', 'box', 'off')
%     saveas(h, [figure_folder, 'Pangburn_1983_Fig2.png'], 'png')
    print('-dpng','-r600',[figure_folder, 'Pangburn_1983_Fig2.png'])
    
end