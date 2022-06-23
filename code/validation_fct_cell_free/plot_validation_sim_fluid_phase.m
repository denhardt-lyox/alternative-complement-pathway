function plot_validation_sim_fluid_phase(figure_folder,...
                        fluidPhase_simdata,... 
                        pangburn_var_simdata,...
                        pangburn_NoFIH_var_simdata,...
                        pangburn_NoFIHBD_var_simdata,...
                        data_bergseth,...
                        data_morad, ...
                        data_sagar, ...
                        data_pangburn)
% plot simulation to data comparison for fluid phase (= cell-free)
% experiments
% Data that simulations are compared to
% - Bergseth 2013
% - Morad 2015
% - Sagar 2016
% - Pangburn 1981

% Bergseth data was partially removed becausced it contaiend classical 
% complement pathway activation 

%% figure folder
% figure_folder = '../Figures/Figures_validation_simulations/';
% mkdir(figure_folder)


%% load molecular weights
MW = get_MW;

%% plot settings
FS.axis   = 16;
FS.legend = 16;
FS.labels = 20;

%% Morad Sagar
%%% C3a ug/mL
sel = {'C3a_ugmL'};
selSims = selectbyname(fluidPhase_simdata, sel);
h=figure;
plot(selSims.Time,       selSims.Data, '-k','Linewidth', 2),
hold on
plot(data_morad.TIME,    data_morad.C3a,    '--ok',...
     data_sagar.TIME,    data_sagar.C3a,    '--dk')
set(gca,'fontsize',FS.axis)
l = legend('Simulated C3a', 'Morad', 'Sagar');
set(l, 'FontSize', FS.legend)
xlabel('Time (hours)', 'FontSize', FS.labels);
ylabel('ug/mL', 'FontSize', FS.labels);
ylim([0 20])
% saveas(h, , 'png')
print('-dpng','-r600',[figure_folder, 'Fluid-Phase_Morad-Sagar_C3a.png'])

%%% C3a ug/mL - baseline corrected
sel = {'C3a_ugmL'};
selSims = selectbyname(fluidPhase_simdata, sel);
h=figure;
p1 = plot(selSims.Time,       selSims.Data, '-k','Linewidth', 2);
hold on
p2 = plot(data_morad.TIME,         data_morad.C3a - data_morad.C3a(1),    'ok',...
          data_sagar.TIME,         data_sagar.C3a - data_sagar.C3a(1),    'vk',...
          'LineWidth', 1.3, 'MarkerSize', 8);
set(gca,'fontsize',FS.axis)
xlabel('Time (h)',   'fontsize',FS.labels)
ylabel('C3a (ug/mL)','fontsize',FS.labels)
ylim([0 10])
l = legend(p2, 'Morad 2015', 'Sagar 2016');
set(l, 'fontsize',FS.legend, 'Location', 'SouthEast', 'box', 'on')
box on
grid on
% saveas(h, [figure_folder, 'Fluid-Phase_Morad-Sagar_C3a_baseline_corrected.png'], 'png')
print('-dpng','-r600',[figure_folder, 'Fluid-Phase_Morad-Sagar_C3a_baseline_corrected.png'])

%%% C3a uM - baseline corrected
sel = {'C3a'};
selSims = selectbyname(fluidPhase_simdata, sel);
h=figure;
p1 = plot(selSims.Time,       selSims.Data, '-k','Linewidth', 2);
hold on
p2 = plot(data_morad.TIME,         (data_morad.C3a - data_morad.C3a(1)) .* 1E3 ./ MW.C3a,    'ok',...
          data_sagar.TIME,         (data_sagar.C3a - data_sagar.C3a(1)) .* 1E3 ./ MW.C3a,    'vk',...
          'LineWidth', 1.3, 'MarkerSize', 8);
set(gca,'fontsize',FS.axis)
xlabel('Time (h)',   'fontsize',FS.labels)
ylabel('C3a (uM)','fontsize',FS.labels)
ylim([0 1])
l = legend(p2, 'Morad 2015', 'Sagar 2016');
set(l, 'fontsize',FS.legend, 'Location', 'SouthEast', 'box', 'on')
box on
grid on
% saveas(h, [figure_folder, 'Fluid-Phase_Morad-Sagar_C3a_baseline_corrected_uM.png'], 'png')
print('-dpng','-r600',[figure_folder, 'Fluid-Phase_Morad-Sagar_C3a_baseline_corrected_uM.png'])

%%% C5a ug/mL
sel = {'C5a_ugmL'};
selSims = selectbyname(fluidPhase_simdata, sel);
h=figure; hold on
p1 = plot(selSims.Time,    selSims.Data, '-k',  'linewidth', 2);
p2 = plot(data_morad.TIME,      data_morad.C5a, 'ok',...
          data_sagar.TIME,      data_sagar.C5a, 'vk',...
          'LineWidth', 1.3, 'MarkerSize', 8);
set(gca,'fontsize',FS.axis)
xlabel('Time (h)',   'fontsize',FS.labels)
ylabel('C5a (ug/mL)','fontsize',FS.labels)
l = legend(p2, 'Morad 2015', 'Sagar 2016');
set(l, 'fontsize',FS.legend, 'Location', 'SouthEast', 'box', 'on')
box on
grid on
% saveas(h, [figure_folder, 'Fluid-Phase_Morad-Sagar_C5a.png'], 'png')
print('-dpng','-r600',[figure_folder, 'Fluid-Phase_Morad-Sagar_C5a.png'])

%%% C5a uM
sel = {'C5a'};
selSims = selectbyname(fluidPhase_simdata, sel);
h=figure; hold on
p1 = plot(selSims.Time,    selSims.Data, '-k',  'linewidth', 2);
p2 = plot(data_morad.TIME,      (data_morad.C5a) .* 1E3 ./ MW.C5a, 'ok',...
          data_sagar.TIME,      (data_sagar.C5a) .* 1E3 ./ MW.C5a, 'vk',...
          'LineWidth', 1.3, 'MarkerSize', 8);
set(gca,'fontsize',FS.axis)
xlabel('Time (h)',   'fontsize',FS.labels)
ylabel('C5a (uM)','fontsize',FS.labels)
l = legend(p2, 'Morad 2015', 'Sagar 2016');
set(l, 'fontsize',FS.legend, 'Location', 'SouthEast', 'box', 'on')
box on
grid on
% saveas(h, [figure_folder, 'Fluid-Phase_Morad-Sagar_C5a_uM.png'], 'png')
print('-dpng','-r600',[figure_folder, 'Fluid-Phase_Morad-Sagar_C5a_uM.png'])


%% Bergseth
sel = {'C3dg_fluid_ugmL'};
selSims = selectbyname(fluidPhase_simdata, sel);
h=figure; hold on
p1 = plot(selSims.Time,    selSims.Data, '-k',  'linewidth', 2);
p2 = plot(data_bergseth.TIME,   data_bergseth.C3dg, 'ok', 'linewidth', 1.3, 'MarkerSize', 8);
set(gca,'fontsize',FS.axis)
xlabel('Time (h)',    'fontsize',FS.labels)
ylabel('C3dg (ug/mL)','fontsize',FS.labels)
% l = legend(p2, 'Bergseth 2013');
% set(l, 'fontsize',FS.legend, 'Location', 'NorthWest', 'box', 'on')
box on
grid on
% saveas(h, [figure_folder, 'Fluid-Phase_Bergseth_C3dg.png'], 'png')
print('-dpng','-r600',[figure_folder, 'Fluid-Phase_Bergseth_C3dg.png'])

sel = {'[C3dg fluid]'};
selSims = selectbyname(fluidPhase_simdata, sel);
h=figure; hold on
p1 = plot(selSims.Time,    selSims.Data, '-k',  'linewidth', 2);
p2 = plot(data_bergseth.TIME,   data_bergseth.C3dg .* 1E3 ./ MW.C3dg, 'ok', 'linewidth', 1.3, 'MarkerSize', 8);
set(gca,'fontsize',FS.axis)
xlabel('Time (h)',    'fontsize',FS.labels)
ylabel('C3dg (uM)','fontsize',FS.labels)
% l = legend(p2, 'Bergseth 2013');
% set(l, 'fontsize',FS.legend, 'Location', 'NorthWest', 'box', 'on')
box on
grid on
% saveas(h, [figure_folder, 'Fluid-Phase_Bergseth_C3dg_uM.png'], 'png')
print('-dpng','-r600',[figure_folder, 'Fluid-Phase_Bergseth_C3dg_uM.png'])


sel = {'Bb_ugmL'};
selSims = selectbyname(fluidPhase_simdata, sel);
h=figure; hold on
p1 = plot(selSims.Time,    selSims.Data, '-k', 'linewidth', 2);
p2 = plot(data_bergseth.TIME,   data_bergseth.Bb, 'ok',  'linewidth', 1.3, 'MarkerSize', 8);
set(gca,'fontsize',FS.axis)
xlabel('Time (h)',  'fontsize',FS.labels)
ylabel('Bb (ug/mL)','fontsize',FS.labels)
ylim([0 150])
% l = legend(p2, 'Bergseth 2013');
% set(l, 'fontsize',FS.legend, 'Location', 'NorthWest', 'box', 'on')
box on
grid on
% saveas(h, [figure_folder, 'Fluid-Phase_Bergseth_Bb.png'], 'png')
print('-dpng','-r600',[figure_folder, 'Fluid-Phase_Bergseth_Bb.png'])

sel = {'Bb'};
selSims = selectbyname(fluidPhase_simdata, sel);
h=figure; hold on
p1 = plot(selSims.Time,    selSims.Data, '-k', 'linewidth', 2);
p2 = plot(data_bergseth.TIME,   data_bergseth.Bb .* 1E3 ./ MW.Bb, 'ok',  'linewidth', 1.3, 'MarkerSize', 8);
set(gca,'fontsize',FS.axis)
xlabel('Time (h)',  'fontsize',FS.labels)
ylabel('Bb (uM)','fontsize',FS.labels)
% l = legend(p2, 'Bergseth 2013');
% set(l, 'fontsize',FS.legend, 'Location', 'NorthWest', 'box', 'on')
box on
grid on
% saveas(h, [figure_folder, 'Fluid-Phase_Bergseth_Bb_uM.png'], 'png')
print('-dpng','-r600',[figure_folder, 'Fluid-Phase_Bergseth_Bb_uM.png'])



%% Comparison of C3 hydrolysis with Pangburn 1981
sel = {'C3_ugmL'};
selSims = selectbyname([pangburn_NoFIHBD_var_simdata,...
                        pangburn_NoFIH_var_simdata,...
                        pangburn_var_simdata], sel);
h=figure; hold on;
p1 = plot(selSims(1).Time, selSims(1).Data / selSims(1).Data(1)*100 , '-', 'Color', [0 0 0] + 0.7, 'linewidth', 2);
p2 = plot(selSims(3).Time, selSims(3).Data / selSims(3).Data(1)*100 , '-', 'Color', [0 0 0] + 0.4, 'linewidth', 2);
p3 = plot(selSims(2).Time, selSims(2).Data / selSims(2).Data(1)*100 , '-', 'Color', [0 0 0] + 0.0, 'linewidth', 2);
p4(1) = plot(data_pangburn.TIME, data_pangburn.C3 ,      'o', 'MarkerEdgeColor', [0 0 0] + 0.7, 'linewidth', 1.3, 'MarkerSize', 8);
p4(2) = plot(data_pangburn.TIME, data_pangburn.C3IHBD ,  'v', 'MarkerEdgeColor', [0 0 0] + 0.4, 'linewidth', 1.3, 'MarkerSize', 8);
p4(3) = plot(data_pangburn.TIME, data_pangburn.C3BD ,    'd', 'MarkerEdgeColor', [0 0 0] + 0.0, 'linewidth', 1.3, 'MarkerSize', 8);
set(gca,'fontsize',FS.axis)
yticks(0:25:125)
xlabel('Time (h)',    'fontsize',FS.labels)
ylabel('Active C3 (%)', 'fontsize',FS.labels)
l = legend(p4, 'C3', 'C3+FI+FH+FB+FD', 'C3+FB+FD');
set(l, 'fontsize',FS.legend, 'Location', 'SouthEast', 'box', 'on')
xlim([-0.5 25])
ylim([-2.5 105])
box on
grid on
% saveas(h, [figure_folder, 'Fluid-Phase_Pangburn_C3_hydrolysis.png'], 'png')
print('-dpng','-r600',[figure_folder, 'Fluid-Phase_Pangburn_C3_hydrolysis.png'])



end