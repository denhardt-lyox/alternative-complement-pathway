function plot_validation_sim_Pangburn_1986(figure_folder, data, sim_Fig6, sim_Fig3)

%% plot settings
FS.axis   = 16;
FS.legend = 16;
FS.labels = 20;

%% Fig 6
    h = figure;
    hold on
    plot_var = selectbyname(sim_Fig6.simdata_7, {'C3', 'C3b fluid'});
    l1 = plot(plot_var.Time, 100/plot_var.Data(1,1) .* plot_var.Data(:,2), '-', 'Color', [0 0 0]+0.5, 'LineWidth', 1.75);
    plot_var = selectbyname(sim_Fig6.simdata_15, {'C3', 'C3b fluid'});
    l2 = plot(plot_var.Time, 100/plot_var.Data(1,1) .* plot_var.Data(:,2), '-', 'Color', [0 0 0], 'LineWidth', 1.75);
    l3 = plot(data.Pangburn1986.Fig6.Time_s, data.Pangburn1986.Fig6.C3_converted_C3bBb_7_87nM, 'v', 'Color', [0 0 0]+0.5, 'LineWidth', 1.3, 'MarkerSize', 8);
    l4 = plot(data.Pangburn1986.Fig6.Time_s, data.Pangburn1986.Fig6.C3_converted_C3bBb_15_7nM, 'o', 'Color', [0 0 0],     'LineWidth', 1.3, 'MarkerSize', 8);
    set(gca,'fontsize', FS.axis)
    yticks(0:15:50)
    ylim([0 50])
    xlabel('Time (s)',                  'FontSize', FS.labels);
    ylabel('C3 converted into C3b (%)', 'FontSize', FS.labels);
    box on
    grid on
    l = legend([l4 l3], {'[C3bBb] = 15.7 nM', '[C3bBb] = 7.87 nM'}, 'Location', 'SouthEast');
    set(l, 'fontsize', FS.legend, 'Location', 'SouthEast', 'box', 'on')
%     saveas(h, [figure_folder, 'Pangburn_1986_Fig6.png'], 'png')
    print('-dpng','-r600',[figure_folder, 'Pangburn_1986_Fig6.png'])

    
%% Fig 3
    v_0  = sim_Fig3.v_0;
    C3_0 = sim_Fig3.C3_0;
    
    %%% original figure
    h = figure;
    plot(v_0./C3_0, v_0, '-', 'Color', [0 0 0])
    hold on
    l2 = plot(data.Pangburn1986.Fig3.v_S, data.Pangburn1986.Fig3.v * 1E6, '^', 'Color', [0 0 0], 'MarkerFaceColor', [0 0 0]);
    set(gca,'fontsize', FS.axis)
    xlabel('v0/[C3] (1/s)',                             'FontSize', FS.labels);
    ylabel('Initial velocity v0 of C3 cleavage (uM/s)', 'FontSize', FS.labels);
    box on
    grid on
    l = legend(l2, '[C3bBb] = 63 nM');
    set(l, 'FontSize', FS.legend);    
%     saveas(h, [figure_folder, 'Pangburn_1986_Fig3.png'], 'png')
    print('-dpng','-r600',[figure_folder, 'Pangburn_1986_Fig3.png'])
  
    %%% converted x-axis - easier to interpret
    h = figure;
    plot(C3_0, v_0, '-', 'Color', [0 0 0])
    hold on
    l2 = plot(data.Pangburn1986.Fig3.S * 1E6, data.Pangburn1986.Fig3.v * 1E6, '^', 'Color', [0 0 0], 'MarkerFaceColor', [0 0 0]);
    set(gca,'fontsize', FS.axis)
    xlabel('C3 [uM]',                                   'FontSize', FS.labels);
    ylabel('Initial velocity v0 of C3 cleavage (uM/s)', 'FontSize', FS.labels);
    box on
    grid on
    l = legend(l2, '[C3bBb] = 63 nM', 'Location', 'SouthEast');
    set(l, 'FontSize', FS.legend);    
%     saveas(h, [figure_folder, 'Pangburn_1986_Fig3_converted.png'], 'png')
    print('-dpng','-r600',[figure_folder, 'Pangburn_1986_Fig3_converted.png'])
end