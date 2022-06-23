function sim_intervention_plotting_dataComparison(ref, res, IC, Kd, subname)
% plot model to data comparison for hemolysis inhibition by
% S77, Lampalizumab, 3E7, Eculizumab


%% Define and generate folders for figures and tables
[~, figure_folder_summary_plots, ~] = ...
    sim_intervention_folder_definitions(Kd, subname);


%% Load data
data.Katschke_S77       = groupedData(readtable('../Data/Katschke_2009_Fig6A.csv', 'Delimiter', ','));

data.Loyet_Lmab         = groupedData(readtable('../Data/Loyet_2014_Fig2A.csv', 'Delimiter', ','));
data.Loyet_Lmab.Conc_uM = data.Loyet_Lmab.Conc_nM ./ 1E3;

data.DiLillo_3E7                 = groupedData(readtable('../Data/DiLillo_2006_Fig5A.csv', 'Delimiter', ','));
data.DiLillo_3E7.Conc_uM         = data.DiLillo_3E7.mAb_conc_ugml .* 1000 ./ 190E3; % assumed weight based on 3E7 http://www.merckmillipore.com/CH/de/product/Anti-Complement-C3b/iC3b-Antibody-clone-3E7-neutralizing
data.DiLillo_3E7.Degree_of_lysis = data.DiLillo_3E7.Degree_of_lysis .* 100; % scale to percent
data.DiLillo_3E7.Upper_error     = data.DiLillo_3E7.Upper_error     .* 100 - data.DiLillo_3E7.Degree_of_lysis; % scale to percent
% data.DiLillo_3E7.Lower_error     = data.DiLillo_3E7.Degree_of_lysis - (data.DiLillo_3E7.Upper_error - data.DiLillo_3E7.Degree_of_lysis ); % assuming symmetrical error
 
data.Harder_Ecu       = groupedData(readtable('../Data/Harder_2017_Fig1B.csv', 'Delimiter', ','));
data.Harder_Ecu_Human       = groupedData(readtable('../Data/Harder_2017_Fig2A.csv', 'Delimiter', ','));

%% Plot settings
FS.axis   = 16;
FS.legend = 16;
FS.labels = 20;

%% Plotting
% comparison to Harder 2017 Fig 2A (Human PNH cells)
h = figure;
hold on;
plot(res.drgs{8}.drug_uM(2:end), res.drgs{8}.lysis(1,2:end)./res.drgs{8}.lysis(1,1).*100, '-',  'Color', [0 0 0], 'LineWidth', 2);
errorbar(data.Harder_Ecu_Human.Conc_uM, data.Harder_Ecu_Human.Lysis_Percent, data.Harder_Ecu_Human.Error_Percent, 'o', 'Color', [0 0 0], 'LineWidth', 1.5, 'MarkerSize', 8);
set(gca,'FontSize', FS.axis)
set(gca,'XScale','log');
xlim([0.8E-2 3E0])
xticks([1E-2 3E-2 1E-1 3E-1 1E0 3E0])
ylim([0 110])
xlabel('Eculizumab (uM)', 'FontSize', FS.labels);
ylabel('Hemolysis (%)', 'FontSize', FS.labels);
grid on
box on
saveas(h, [figure_folder_summary_plots, 'Harder2017_PNH-cells_woLegend_woInfo.png'], 'png')
ylim([0 120])
txt = sprintf('Lysis in model w/o inhibitor: \nTakeda: %.3f%% \n     Kolb: %.3f%% ', res.drgs{8}.lysis(1,1), res.drgs{8}.lysis(2,1));
text(0.01,10,txt)
saveas(h, [figure_folder_summary_plots, 'Harder2017_PNH-cells_woLegend.png'], 'png')
legend({'Eculizumab - Harder, 2017', 'Eculizumab - model prediction'},...
        'Location','NorthEast');
saveas(h, [figure_folder_summary_plots, 'Harder2017_PNH-cells.png'], 'png')

% comparison to Harder 2017 Fig 1B (Rabbit cells)
h = figure;
hold on;
plot(res.drgs{8}.drug_uM(2:end), res.drgs{8}.lysis(1,2:end)./res.drgs{8}.lysis(1,1).*100, '-',  'Color', [0 0 0], 'LineWidth', 2);
% plot(res.drgs{8}.drug_uM(2:end), res.drgs{8}.lysis(2,2:end)./res.drgs{8}.lysis(2,1).*100, '--', 'Color', [0 0 0], 'LineWidth', 2);
plot(data.Harder_Ecu.Conc_uM, data.Harder_Ecu.Total_Lysis_percent, 'o', 'Color', [0 0 0], 'LineWidth', 1.5, 'MarkerSize', 8);
set(gca,'FontSize', FS.axis)
set(gca,'XScale','log');
xlim([0.8E-2 3E0])
xticks([1E-2 3E-2 1E-1 3E-1 1E0 3E0])
ylim([0 105])
xlabel('Eculizumab (uM)', 'FontSize', FS.labels);
ylabel('Hemolysis (%)', 'FontSize', FS.labels);
grid on
box on
saveas(h, [figure_folder_summary_plots, 'Harder2017_woLegend_woInfo.png'], 'png')
ylim([0 120])
txt = sprintf('Lysis in model w/o inhibitor: \nTakeda: %.3f%% \n     Kolb: %.3f%% ', res.drgs{8}.lysis(1,1), res.drgs{8}.lysis(2,1));
text(1.2E-3,112,txt)
saveas(h, [figure_folder_summary_plots, 'Harder2017_woLegend.png'], 'png')
legend({'Eculizumab - Harder, 2017', 'Eculizumab - model prediction'},...
        'Location','NorthEast');
saveas(h, [figure_folder_summary_plots, 'Harder2017.png'], 'png')


% comparison to Katschke 2009
h = figure;
hold on;
plot(data.Katschke_S77.Inhibitor_uM, data.Katschke_S77.AP_Hemolysis_percentMax, '*k')
fill([res.drgs{1}.drug_uM(2:end), fliplr(res.drgs{1}.drug_uM(2:end))], ...
    [res.drgs{1}.lysis(1,2:end)./ref.Lysis_end(1).*100 fliplr(res.drgs{1}.lysis(2,2:end)./ref.Lysis_end(2).*100)], [0 0 0], 'FaceAlpha', 0.3, 'EdgeColor',[0.3 0.3 0.3]);
txt = sprintf('Lysis in model w/o inhibitor: \nTakeda: %.3f%% \n     Kolb: %.3f%% ', ref.Lysis_end(1), ref.Lysis_end(2));
text(1.2E-3,112,txt)
xlabel('Drug concentration (uM)', 'FontSize' ,14);
ylabel('Hemolysis (%, norm. to max. lysis)', 'FontSize' ,14);
set(gca,'fontWeight','bold');
set(gca,'XScale','log');
xlim([1E-3 1E1])
ylim([0 120])
limsy=get(gca,'YLim');
set(gca,'Ylim',[0 limsy(2)]);
grid on
saveas(h, [figure_folder_summary_plots, 'Katschke2009_woLegend.png'], 'png')
legend({'S77 - Katschke, 2009', 'S77 - model prediction'},...
        'Location','NorthEast');
saveas(h, [figure_folder_summary_plots, 'Katschke2009.png'], 'png')

% comparison to Katschke 2009 & Loyet 2014
h = figure;
hold on;
plot(data.Katschke_S77.Inhibitor_uM, data.Katschke_S77.AP_Hemolysis_percentMax, '*k')
fill([res.drgs{1}.drug_uM(2:end), fliplr(res.drgs{1}.drug_uM(2:end))], ...
    [res.drgs{1}.lysis(1,2:end)./ref.Lysis_end(1).*100 fliplr(res.drgs{1}.lysis(2,2:end)./ref.Lysis_end(2).*100)], [0 0 0], 'FaceAlpha', 0.3, 'EdgeColor',[0.3 0.3 0.3]);
errorbar(data.Loyet_Lmab.Conc_uM, data.Loyet_Lmab.Lysis_percent, data.Loyet_Lmab.LowerError, data.Loyet_Lmab.UpperError, '^', 'Color', [0 0.4 0.4])
fill([res.drgs{2}.drug_uM(2:end), fliplr(res.drgs{2}.drug_uM(2:end))], ...
    [res.drgs{2}.lysis(1,2:end)./ref.Lysis_end(1).*100 fliplr(res.drgs{2}.lysis(2,2:end)./ref.Lysis_end(2).*100)], [0 0.7 0.7], 'FaceAlpha', 0.3, 'EdgeColor',[0 0.6 0.6]);
txt = sprintf('Lysis in model w/o inhibitor: \nTakeda: %.3f%% \n     Kolb: %.3f%% ', ref.Lysis_end(1), ref.Lysis_end(2));
text(1.2E-4,112,txt)
xlabel('Drug concentration (uM)', 'FontSize' ,14);
ylabel('Hemolysis (%, norm. to max. lysis)', 'FontSize' ,14);
set(gca,'fontWeight','bold');
set(gca,'XScale','log');
xlim([1E-4 1E1])
ylim([0 120])
limsy=get(gca,'YLim');
set(gca,'Ylim',[0 limsy(2)]);
grid on
saveas(h, [figure_folder_summary_plots, 'Katschke2009_Loyet2014_woLegend.png'], 'png')
legend({'S77 - Katschke, 2009', 'S77 - model prediction', 'Lmab - Loyet, 2014', 'Lmab - model prediction'},...
        'Location','NorthEast');
saveas(h, [figure_folder_summary_plots, 'Katschke2009_Loyet2014.png'], 'png')

% comparison to Katschke 2009 & Loyet 2014 & DiLillo 2006
h = figure;
hold on;
plot(data.Katschke_S77.Inhibitor_uM, data.Katschke_S77.AP_Hemolysis_percentMax, '*k')
fill([res.drgs{1}.drug_uM(2:end), fliplr(res.drgs{1}.drug_uM(2:end))], ...
    [res.drgs{1}.lysis(1,2:end)./ref.Lysis_end(1).*100 fliplr(res.drgs{1}.lysis(2,2:end)./ref.Lysis_end(2).*100)], [0 0 0], 'FaceAlpha', 0.3, 'EdgeColor',[0.3 0.3 0.3]);
errorbar(data.Loyet_Lmab.Conc_uM, data.Loyet_Lmab.Lysis_percent, data.Loyet_Lmab.LowerError, data.Loyet_Lmab.UpperError, '^', 'Color', [0 0.4 0.4])
fill([res.drgs{2}.drug_uM(2:end), fliplr(res.drgs{2}.drug_uM(2:end))], ...
    [res.drgs{2}.lysis(1,2:end)./ref.Lysis_end(1).*100 fliplr(res.drgs{2}.lysis(2,2:end)./ref.Lysis_end(2).*100)], [0 0.7 0.7], 'FaceAlpha', 0.3, 'EdgeColor',[0 0.6 0.6]);
errorbar(data.DiLillo_3E7.Conc_uM, data.DiLillo_3E7.Degree_of_lysis, data.DiLillo_3E7.Upper_error, data.DiLillo_3E7.Upper_error, 'o', 'Color', [1 0  0])
fill([res.drgs{5}.drug_uM(2:end)   fliplr(res.drgs{5}.drug_uM(2:end))],    [res.drgs{5}.lysis(1,2:end)./res.drgs{5}.lysis(1,1).*100,...
    fliplr(res.drgs{5}.lysis(2,2:end))./res.drgs{5}.lysis(2,1).*100], [0.7 0 0], 'FaceAlpha', 0.3, 'EdgeColor', [0.5 0 0]);
xlabel('Drug concentration (uM)', 'FontSize' ,14);
set(gca,'fontWeight','bold');
set(gca,'XScale','log');
xlim([1E-4 1E1])
ylim([0 120])
limsy=get(gca,'YLim');
set(gca,'Ylim',[0 limsy(2)]);
grid on
ylabel('Normalized Hemolysis (%)', 'FontSize' ,14);
saveas(h, [figure_folder_summary_plots, 'Katschke2009_Loyet2014_DiLillo2006_woInfo.png'], 'png')
ylabel('Hemolysis (%, norm. to max. lysis)', 'FontSize' ,14);
txt = sprintf('Lysis w/o inh.: Takeda: %.3f%%, Kolb: %.3f%% (Katschke, 2009) \nLysis w/o inh.: Takeda: %.3f%%, Kolb: %.3f%% (DiLillo, 2006) ', ...
            ref.Lysis_end(1), ref.Lysis_end(2), res.drgs{5}.lysis(1,1), res.drgs{5}.lysis(2,1));
text(1.2E-4,112,txt) 
saveas(h, [figure_folder_summary_plots, 'Katschke2009_Loyet2014_DiLillo2006_woLegend.png'], 'png')
legend({'S77 - Katschke, 2009', 'S77 - model prediction', 'Lmab - Loyet, 2014', 'Lmab - model prediction', ...
        '3E7 - DiLillo, 2006', '3E7 - model prediction'},...
        'Location','SouthWest');
saveas(h, [figure_folder_summary_plots, 'Katschke2009_Loyet2014_DiLillo2006.png'], 'png')


% comparison to Katschke 2009 & Loyet 2014 & DiLillo 2006 & Harder 2017
h = figure;
hold on;
plot(data.Katschke_S77.Inhibitor_uM, data.Katschke_S77.AP_Hemolysis_percentMax, '*k')
fill([res.drgs{1}.drug_uM(2:end), fliplr(res.drgs{1}.drug_uM(2:end))], ...
    [res.drgs{1}.lysis(1,2:end)./ref.Lysis_end(1).*100 fliplr(res.drgs{1}.lysis(2,2:end)./ref.Lysis_end(2).*100)], [0 0 0], 'FaceAlpha', 0.3, 'EdgeColor',[0.3 0.3 0.3]);
errorbar(data.Loyet_Lmab.Conc_uM, data.Loyet_Lmab.Lysis_percent, data.Loyet_Lmab.LowerError, data.Loyet_Lmab.UpperError, '^', 'Color', [0 0.4 0.4])
fill([res.drgs{2}.drug_uM(2:end), fliplr(res.drgs{2}.drug_uM(2:end))], ...
    [res.drgs{2}.lysis(1,2:end)./ref.Lysis_end(1).*100 fliplr(res.drgs{2}.lysis(2,2:end)./ref.Lysis_end(2).*100)], [0 0.7 0.7], 'FaceAlpha', 0.3, 'EdgeColor',[0 0.6 0.6]);
errorbar(data.DiLillo_3E7.Conc_uM, data.DiLillo_3E7.Degree_of_lysis, data.DiLillo_3E7.Upper_error, data.DiLillo_3E7.Upper_error, 'o', 'Color', [1 0  0])
fill([res.drgs{5}.drug_uM(2:end)   fliplr(res.drgs{5}.drug_uM(2:end))],    [res.drgs{5}.lysis(1,2:end)./res.drgs{5}.lysis(1,1).*100,...
    fliplr(res.drgs{5}.lysis(2,2:end))./res.drgs{5}.lysis(2,1).*100], [0.7 0 0], 'FaceAlpha', 0.3, 'EdgeColor', [0.5 0 0]);
plot(data.Harder_Ecu.Conc_uM, data.Harder_Ecu.Total_Lysis_percent, '.', 'Color', [0.6 0.2 1], 'MarkerSize', 20)
fill([res.drgs{8}.drug_uM(2:end), fliplr(res.drgs{8}.drug_uM(2:end))], ...
    [res.drgs{8}.lysis(1,2:end)./res.drgs{8}.lysis(1,1).*100 fliplr(res.drgs{8}.lysis(2,2:end)./res.drgs{8}.lysis(2,1).*100)], [0.6 0.2 1], 'FaceAlpha', 0.3, 'EdgeColor',[0.6 0.2 1]-0.2);
xlabel('Drug concentration (uM)', 'FontSize' ,14);
set(gca,'fontWeight','bold');
set(gca,'XScale','log');
xlim([1E-4 1E1])
ylim([0 120])
limsy=get(gca,'YLim');
set(gca,'Ylim',[0 limsy(2)]);
grid on
ylabel('Normalized Hemolysis (%)', 'FontSize' ,14);
saveas(h, [figure_folder_summary_plots, 'Katschke2009_Loyet2014_DiLillo2006_Harder2017_woInfo.png'], 'png')
ylabel('Hemolysis (%, norm. to max. lysis)', 'FontSize' ,14);
txt = sprintf('Lysis w/o inh.: Takeda: %.3f%%, Kolb: %.3f%% (Katschke, 2009) \nLysis w/o inh.: Takeda: %.3f%%, Kolb: %.3f%% (DiLillo, 2006)\nLysis w/o inh.: Takeda: %.3f%%, Kolb: %.3f%% (Harder, 2017) ', ...
            ref.Lysis_end(1), ref.Lysis_end(2), res.drgs{5}.lysis(1,1), res.drgs{5}.lysis(2,1), res.drgs{8}.lysis(1,1), res.drgs{8}.lysis(2,1));
text(1.2E-4,112,txt) 
saveas(h, [figure_folder_summary_plots, 'Katschke2009_Loyet2014_DiLillo2006_Harder2017_woLegend.png'], 'png')
legend({'S77 - Katschke, 2009', 'S77 - model prediction', 'Lmab - Loyet, 2014', 'Lmab - model prediction', ...
        '3E7 - DiLillo, 2006', '3E7 - model prediction', 'Ecu - Harder, 2017', 'Ecu - model prediction'},...
        'Location','SouthWest');
saveas(h, [figure_folder_summary_plots, 'Katschke2009_Loyet2014_DiLillo2006_Harder2017.png'], 'png')
close all



h = figure;
hold on;
plot(data.Katschke_S77.Inhibitor_uM, data.Katschke_S77.AP_Hemolysis_percentMax, '*k')
fill([res.drgs{1}.drug_uM(2:end), fliplr(res.drgs{1}.drug_uM(2:end))], ...
    [res.drgs{1}.lysis(1,2:end)./ref.Lysis_end(1).*100 fliplr(res.drgs{1}.lysis(2,2:end)./ref.Lysis_end(2).*100)], [0 0 0], 'FaceAlpha', 0.3, 'EdgeColor',[0.3 0.3 0.3]);
errorbar(data.Loyet_Lmab.Conc_uM, data.Loyet_Lmab.Lysis_percent, data.Loyet_Lmab.LowerError, data.Loyet_Lmab.UpperError, '^', 'Color', [0 0.4 0.4])
fill([res.drgs{2}.drug_uM(2:end), fliplr(res.drgs{2}.drug_uM(2:end))], ...
    [res.drgs{2}.lysis(1,2:end)./ref.Lysis_end(1).*100 fliplr(res.drgs{2}.lysis(2,2:end)./ref.Lysis_end(2).*100)], [0 0.7 0.7], 'FaceAlpha', 0.3, 'EdgeColor',[0 0.6 0.6]);
errorbar(data.DiLillo_3E7.Conc_uM, data.DiLillo_3E7.Degree_of_lysis, data.DiLillo_3E7.Upper_error, data.DiLillo_3E7.Upper_error, 'o', 'Color', [1 0  0])
fill([res.drgs{5}.drug_uM(2:end)   fliplr(res.drgs{5}.drug_uM(2:end))],    [res.drgs{5}.lysis(1,2:end)./res.drgs{5}.lysis(1,1).*100,...
    fliplr(res.drgs{5}.lysis(2,2:end))./res.drgs{5}.lysis(2,1).*100], [0.7 0 0], 'FaceAlpha', 0.3, 'EdgeColor', [0.5 0 0]);
plot(data.Harder_Ecu.Conc_uM, data.Harder_Ecu.Total_Lysis_percent, '.', 'Color', [0.3 0.3 1], 'MarkerSize', 20)
fill([res.drgs{8}.drug_uM(2:end), fliplr(res.drgs{8}.drug_uM(2:end))], ...
    [res.drgs{8}.lysis(1,2:end)./res.drgs{8}.lysis(1,1).*100 fliplr(res.drgs{8}.lysis(2,2:end)./res.drgs{8}.lysis(2,1).*100)], [0 0.2 0.8], 'FaceAlpha', 0.3, 'EdgeColor',[0.2 0.4 0.8]-0.2);
set(gca,'fontWeight','bold', 'FontSize', 14);
xlabel('Drug concentration (uM)', 'FontSize' ,16);
set(gca,'XScale','log');
xticks([1E-4, 1E-3, 1E-2, 1E-1, 1E0, 1E1])
xlim([1E-4 1E1])
ylim([0 120])
limsy=get(gca,'YLim');
set(gca,'Ylim',[0 limsy(2)]);
grid on
ylabel('% Hemolysis', 'FontSize' ,16);
saveas(h, [figure_folder_summary_plots, 'Katschke2009_Loyet2014_DiLillo2006_Harder2017_woInfo_Bigger-Font-Size.png'], 'png')


h = figure;
hold on;
plot(data.Katschke_S77.Inhibitor_uM, data.Katschke_S77.AP_Hemolysis_percentMax, '*k')
fill([res.drgs{1}.drug_uM(2:end), fliplr(res.drgs{1}.drug_uM(2:end))], ...
    [res.drgs{1}.lysis(1,2:end)./ref.Lysis_end(1).*100 fliplr(res.drgs{1}.lysis(2,2:end)./ref.Lysis_end(2).*100)], [0 0 0], 'FaceAlpha', 0.3, 'EdgeColor',[0.3 0.3 0.3]);
errorbar(data.Loyet_Lmab.Conc_uM, data.Loyet_Lmab.Lysis_percent, data.Loyet_Lmab.LowerError, data.Loyet_Lmab.UpperError, '^', 'Color', [0 0.4 0.4])
fill([res.drgs{2}.drug_uM(2:end), fliplr(res.drgs{2}.drug_uM(2:end))], ...
    [res.drgs{2}.lysis(1,2:end)./ref.Lysis_end(1).*100 fliplr(res.drgs{2}.lysis(2,2:end)./ref.Lysis_end(2).*100)], [0 0.7 0.7], 'FaceAlpha', 0.3, 'EdgeColor',[0 0.6 0.6]);
errorbar(data.DiLillo_3E7.Conc_uM, data.DiLillo_3E7.Degree_of_lysis, data.DiLillo_3E7.Upper_error, data.DiLillo_3E7.Upper_error, 'o', 'Color', [1 0  0])
fill([res.drgs{5}.drug_uM(2:end)   fliplr(res.drgs{5}.drug_uM(2:end))],    [res.drgs{5}.lysis(1,2:end)./res.drgs{5}.lysis(1,1).*100,...
    fliplr(res.drgs{5}.lysis(2,2:end))./res.drgs{5}.lysis(2,1).*100], [0.7 0 0], 'FaceAlpha', 0.3, 'EdgeColor', [0.5 0 0]);
plot(data.Harder_Ecu.Conc_uM, data.Harder_Ecu.Total_Lysis_percent, '.', 'Color', [0.3 0.3 1], 'MarkerSize', 20)
fill([res.drgs{8}.drug_uM(2:end), fliplr(res.drgs{8}.drug_uM(2:end))], ...
    [res.drgs{8}.lysis(1,2:end)./res.drgs{8}.lysis(1,1).*100 fliplr(res.drgs{8}.lysis(2,2:end)./res.drgs{8}.lysis(2,1).*100)], [0 0.2 0.8], 'FaceAlpha', 0.3, 'EdgeColor',[0.2 0.4 0.8]-0.2);

fill([res.mltple{7}.drug_uM(2:end), fliplr(res.mltple{7}.drug_uM(2:end))], ...
    [res.mltple{7}.lysis(1,2:end)./res.mltple{7}.lysis(1,1).*100 fliplr(res.mltple{7}.lysis(2,2:end)./res.mltple{7}.lysis(2,1).*100)], [1 0.5 0], 'FaceAlpha', 0.3, 'EdgeColor',[1 0.5 0.2]-0.2);

set(gca,'fontWeight','bold', 'FontSize', 14);
xlabel('Drug concentration (uM)', 'FontSize' ,16);
set(gca,'XScale','log');
xticks([1E-4, 1E-3, 1E-2, 1E-1, 1E0, 1E1])
xlim([1E-4 1E1])
ylim([0 120])
limsy=get(gca,'YLim');
set(gca,'Ylim',[0 limsy(2)]);
grid on
ylabel('% Hemolysis', 'FontSize' ,16);
saveas(h, [figure_folder_summary_plots, 'Katschke2009_Loyet2014_DiLillo2006_Harder2017_woInfo_Bigger-Font-Size_C3bBb-comparison.png'], 'png')

end