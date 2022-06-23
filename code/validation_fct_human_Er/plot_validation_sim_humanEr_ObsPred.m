function plot_validation_sim_humanEr_ObsPred(figure_folder, data, simdata)
%%% plot observed vs predicted for human Er assays
%%% includes and requires Ferreira 2007, Lesher 2013, Wilcox 1991

%% Plot settings
LW = 1.3; % LineWidth
MS = 8;   % MarkerSize
 

%% load data if not parsed
if(isempty(data))
    data = load_data_Ferreira_2007([]);
    data = load_data_Lesher_2013(data);
    data = load_data_Wilcox_1991(data);    
end

%% Comparison to data
h = figure;
hold on
%%%
plot(0:100, 0:100, '-', 'Color', [0 0 0] + 0.5)

%%% Ferreira
errorbar(simdata.Ferreira.DAF.Lysis(end,1),         data.Ferreira.Fig1B.E_H_avrge(end),         data.Ferreira.Fig1B.E_H_std(end),        'ko', 'LineWidth', LW, 'MarkerSize', MS)
errorbar(simdata.Ferreira.FH.Lysis(end,1),  mean([data.Ferreira.Fig1A.E_H_rH1920_avrge(1) data.Ferreira.Fig1B.E_H_rH1920_avrge(1)]), ...
    std([data.Ferreira.Fig1A.E_H_rH1920_avrge(1)    data.Ferreira.Fig1B.E_H_rH1920_avrge(1)]),                                           'ko', 'LineWidth', LW, 'MarkerSize', MS)
errorbar(simdata.Ferreira.CD59.Lysis(end,1),        data.Ferreira.Fig1A.E_H_avrge(end),         data.Ferreira.Fig1A.E_H_std(end),        'ko', 'LineWidth', LW, 'MarkerSize', MS)
errorbar(simdata.Ferreira.FH_DAF.Lysis(end,1),      data.Ferreira.Fig1B.E_H_rH1920_avrge(end),  data.Ferreira.Fig1B.E_H_rH1920_std(end), 'ko', 'LineWidth', LW, 'MarkerSize', MS)
errorbar(simdata.Ferreira.FH_CD59.Lysis(end,1),     data.Ferreira.Fig1A.E_H_rH1920_avrge(end),  data.Ferreira.Fig1A.E_H_rH1920_std(end), 'ko', 'LineWidth', LW, 'MarkerSize', MS)

%%% Lesher
errorbar(simdata.Lesher.DAF.Lysis(end,1),       data.Lesher.aDAF(1),        data.Lesher.aDAF_error(1),      'ks', 'LineWidth', LW+0.2, 'MarkerSize', MS+3)
errorbar(simdata.Lesher.FH.Lysis(end,1),        data.Lesher.control(end),   data.Lesher.control_err(end),   'ks', 'LineWidth', LW+0.2, 'MarkerSize', MS+3)
errorbar(simdata.Lesher.FH_DAF.Lysis(end,1),    data.Lesher.aDAF(end),      data.Lesher.aDAF_error(end),    'ks', 'LineWidth', LW+0.2, 'MarkerSize', MS+3)
errorbar(simdata.Lesher.FH_FP.Lysis(end,1),     data.Lesher.aP(end),        data.Lesher.aP_error(end),      'ks', 'LineWidth', LW+0.2, 'MarkerSize', MS+3)
errorbar(simdata.Lesher.FH_DAF_FP.Lysis(end,1), data.Lesher.aDAF_aP(end),   data.Lesher.aDAF_aP_error(end), 'ks', 'LineWidth', LW+0.2, 'MarkerSize', MS+3)

%%% Wilcox
plot(simdata.Wilcox.DAF.Lysis(end,1),       data.Wilcox.aDAF(end),       'kv', 'LineWidth', LW, 'MarkerSize', MS)
plot(simdata.Wilcox.CD59.Lysis(end,1),      data.Wilcox.aCD59(end),      'kv', 'LineWidth', LW, 'MarkerSize', MS)
plot(simdata.Wilcox.CD59_DAF.Lysis(end,1),  data.Wilcox.aCD59_aDAF(end), 'kv', 'LineWidth', LW, 'MarkerSize', MS)

%%%
set(gca, 'FontSize', 14)
xlabel('Predicted hemolysis (%)', 'FontSize', 16)
ylabel('Observed hemolysis (%)', 'FontSize', 16)
box on
grid on
% saveas(h, [figure_folder, 'Human_Er_ObsPred.png'], 'png')
print('-dpng','-r600',[figure_folder, 'Human_Er_ObsPred.png'])
end
