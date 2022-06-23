function sim_intervention_plotting(ref, res, IC, Kd, subname)
% Plotting of intervention simulations

%% Define and generate folders for figures and tables
[figure_folder, figure_folder_summary_plots, table_folder] = ...
    sim_intervention_folder_definitions(Kd, subname);

%% write IC50s and IC95s to table
fields_res = fields(res);
m = 1;
for i = 1:numel(fields_res)
    for ii = 1:length(res.(fields_res{i}))
        if ~isempty(res.(fields_res{i}){ii})
        drug_names{m,1}    = res.(fields_res{i}){ii}.target;
        C3a(m,:)           = IC.(fields_res{i}){ii}.C3a;
        C5a(m,:)           = IC.(fields_res{i}){ii}.C5a;
        MAC(m,:)           = IC.(fields_res{i}){ii}.MAC;
        Lysis(m,:)         = IC.(fields_res{i}){ii}.lysis(:)';
        end
        m = m + 1;
    end
end

ICtable.all = [C3a, C5a, MAC, Lysis];
ICtable.all = num2cell(ICtable.all);
IC_units = repmat({'micromolarity'}, length(drug_names), 1);
ICtable_out  = {drug_names, ICtable.all, IC_units};
ICtable_out  = cat(2,ICtable_out{:});
ICtable_out = cell2table(ICtable_out,...
    'VariableNames',{'Target' 'C3a_IC50' 'C3a_IC95', 'C5a_IC50' 'C5a_IC95', ...
    'MAC_IC50' 'MAC_IC95', 'Lysis_Takeda_IC50', 'Lysis_Kolb_IC50', 'Lysis_Takeda_IC95', 'Lysis_Kolb_IC95', 'Units'});
writetable(ICtable_out, [table_folder, 'IC_Kd-', num2str(Kd), subname,'.csv']);


%% Plotting 
color.drgs{2}   = [0.0 0.0 0.0];
color.drgs{1}   = [0.4 0.4 0.4];
color.drgs{4}   = [0.7 0.7 0.7];
color.mltple{3} = [0.0 0.0 1.0];
color.mltple{4} = [1.0 0.0 0.0];
color.mltple{7} = [1.0 0.0 1.0];
color.single{7} = [0.0 1.0 1.0];
color.single{10} = [0.9 0.9 0.0];
color.single{11} = [0.0 1.0 0.0];

h = figure;
hold on;
plot(res.drgs{2}.drug_uM,   res.drgs{2}.C3a,   '--',   'linewidth', 2, 'Color', color.drgs{2});
plot(res.drgs{1}.drug_uM,   res.drgs{1}.C3a,   '--',   'linewidth', 2, 'Color', color.drgs{1});
plot(res.drgs{4}.drug_uM,   res.drgs{4}.C3a,   '-.',   'linewidth', 2, 'Color', color.drgs{4});
plot(res.mltple{3}.drug_uM, res.mltple{3}.C3a, '-',    'linewidth', 2, 'Color', color.mltple{3});
plot(res.mltple{4}.drug_uM, res.mltple{4}.C3a, '-',    'linewidth', 2, 'Color', color.mltple{4});
plot(res.mltple{7}.drug_uM, res.mltple{7}.C3a, '-',    'linewidth', 2, 'Color', color.mltple{7});
plot(res.single{7}.drug_uM, res.single{7}.C3a, '-',    'linewidth', 2, 'Color', color.single{7});
plot(res.single{10}.drug_uM, res.single{10}.C3a, '-',    'linewidth', 2, 'Color', color.single{10});
% plot(res.single{11}.drug_uM, res.single{11}.C3a, '-',    'linewidth', 2, 'Color', color.single{11});
xlabel('Drug concentration (uM)',   'FontSize' ,14);
ylabel('C3a (uM)',                  'FontSize' ,14);
set(gca,'fontWeight','bold');
set(gca,'XScale','log');
xlim([1E-3 1E1])
limsy=get(gca,'YLim');
set(gca,'Ylim',[0 limsy(2)]);
grid on
saveas(h, [figure_folder_summary_plots, 'C3a_comparison_inhibition_C3convertases_woLegend.png'], 'png')
% legend({'FD (Lampalizumab)', 'S77', 'H17', target_101, target_102c, target_103c, target_7, target_8c, target_9c},...
%         'Location','southwest');
legend({res.drgs{2}.target, res.drgs{1}.target, res.drgs{4}.target,...
        res.mltple{3}.target, res.mltple{4}.target, res.mltple{7}.target, ...
        res.single{7}.target, res.single{10}.target, res.single{11}.target}, 'Location','southwest');
saveas(h, [figure_folder_summary_plots, 'C3a_comparison_inhibition_C3convertases.png'], 'png')

h = figure;
hold on;
plot(res.drgs{2}.drug_uM,   res.drgs{2}.C5a,   '--',   'linewidth', 2, 'Color', color.drgs{2});
plot(res.drgs{1}.drug_uM,   res.drgs{1}.C5a,   '--',   'linewidth', 2, 'Color', color.drgs{1});
plot(res.drgs{4}.drug_uM,   res.drgs{4}.C5a,   '-.',   'linewidth', 2, 'Color', color.drgs{4});
plot(res.mltple{3}.drug_uM, res.mltple{3}.C5a, '-',    'linewidth', 2, 'Color', color.mltple{3});
plot(res.mltple{4}.drug_uM, res.mltple{4}.C5a, '-',    'linewidth', 2, 'Color', color.mltple{4});
plot(res.mltple{7}.drug_uM, res.mltple{7}.C5a, '-',    'linewidth', 2, 'Color', color.mltple{7});
plot(res.single{7}.drug_uM, res.single{7}.C5a, '-',    'linewidth', 2, 'Color', color.single{7});
plot(res.single{10}.drug_uM, res.single{10}.C5a, '-',    'linewidth', 2, 'Color', color.single{10});
% plot(res.single{11}.drug_uM, res.single{11}.C4a, '-',    'linewidth', 2, 'Color', color.single{11});
xlabel('Drug concentration (uM)',   'FontSize' ,14);
ylabel('C5a (uM)',                  'FontSize' ,14);
set(gca,'fontWeight','bold');
set(gca,'XScale','log');
xlim([1E-3 1E1])
limsy=get(gca,'YLim');
set(gca,'Ylim',[0 limsy(2)]);
grid on
saveas(h, [figure_folder_summary_plots, 'C5a_comparison_inhibition_C3convertases_woLegend.png'], 'png')
legend({res.drgs{2}.target, res.drgs{1}.target, res.drgs{4}.target,...
        res.mltple{3}.target, res.mltple{4}.target, res.mltple{7}.target, ...
        res.single{7}.target, res.single{10}.target, res.single{11}.target}, 'Location','southwest');
saveas(h, [figure_folder_summary_plots, 'C5a_comparison_inhibition_C3convertases.png'], 'png')


h = figure;
hold on;
plot(res.drgs{2}.drug_uM,   res.drgs{2}.MAC   ./res.drgs{2}.cells_uM,   '--',	'linewidth', 2, 'Color', color.drgs{2});
plot(res.drgs{1}.drug_uM,   res.drgs{1}.MAC   ./res.drgs{1}.cells_uM,   '--',   'linewidth', 2, 'Color', color.drgs{1});
plot(res.drgs{4}.drug_uM,   res.drgs{4}.MAC   ./res.drgs{4}.cells_uM,   '-.',   'linewidth', 2, 'Color', color.drgs{4});
plot(res.mltple{3}.drug_uM, res.mltple{3}.MAC ./res.mltple{2}.cells_uM, '-',    'linewidth', 2, 'Color', color.mltple{3});
plot(res.mltple{4}.drug_uM, res.mltple{4}.MAC ./res.mltple{3}.cells_uM, '-',    'linewidth', 2, 'Color', color.mltple{4});
plot(res.mltple{7}.drug_uM, res.mltple{7}.MAC ./res.mltple{4}.cells_uM, '-',    'linewidth', 2, 'Color', color.mltple{7});
plot(res.single{7}.drug_uM, res.single{7}.MAC ./res.single{7}.cells_uM, '-',    'linewidth', 2, 'Color', color.single{7});
plot(res.single{10}.drug_uM, res.single{10}.MAC ./res.single{8}.cells_uM, '-',    'linewidth', 2, 'Color', color.single{10});
% plot(res.single{11}.drug_uM, res.single{11}.MAC ./res.single{9}.cells_uM, '-',    'linewidth', 2, 'Color', color.single{11});
xlabel('Drug concentration (uM)',   'FontSize' ,14);
ylabel('MAC per cell',              'FontSize' ,14);
set(gca,'fontWeight','bold');
set(gca,'XScale','log');
xlim([1E-3 1E1])
limsy=get(gca,'YLim');
set(gca,'Ylim',[0 limsy(2)]);
grid on
saveas(h, [figure_folder_summary_plots, 'MAC_comparison_inhibition_C3convertases_woLegend.png'], 'png')
legend({res.drgs{2}.target, res.drgs{1}.target, res.drgs{4}.target,...
        res.mltple{3}.target, res.mltple{4}.target, res.mltple{7}.target, ...
        res.single{7}.target, res.single{10}.target, res.single{11}.target}, 'Location','southwest');
saveas(h, [figure_folder_summary_plots, 'MAC_comparison_inhibition_C3convertases.png'], 'png')


val_FaceAlpha = 0.4;
h = figure;
hold on;
fill([res.drgs{2}.drug_uM(2:end)                            fliplr(res.drgs{2}.drug_uM(2:end))], ...
     [res.drgs{2}.lysis(1,2:end)./ref.Lysis_end(1).*100     fliplr(res.drgs{2}.lysis(2,2:end))./ref.Lysis_end(2).*100], ...
        color.drgs{2},      'FaceAlpha', val_FaceAlpha); 
fill([res.drgs{1}.drug_uM(2:end)                            fliplr(res.drgs{1}.drug_uM(2:end))], ...
     [res.drgs{1}.lysis(1,2:end)./ref.Lysis_end(1).*100     fliplr(res.drgs{1}.lysis(2,2:end))./ref.Lysis_end(2).*100], ...
        color.drgs{1},      'FaceAlpha', val_FaceAlpha); 
fill([res.drgs{4}.drug_uM(2:end)                            fliplr(res.drgs{4}.drug_uM(2:end))], ...
     [res.drgs{4}.lysis(1,2:end)./ref.Lysis_end(1).*100     fliplr(res.drgs{4}.lysis(2,2:end))./ref.Lysis_end(2).*100], ...
        color.drgs{4},      'FaceAlpha', val_FaceAlpha); 
fill([res.mltple{3}.drug_uM(2:end)                          fliplr(res.mltple{3}.drug_uM(2:end))], ...
     [res.mltple{3}.lysis(1,2:end)./ref.Lysis_end(1).*100   fliplr(res.mltple{3}.lysis(2,2:end))./ref.Lysis_end(2).*100], ...
        color.mltple{3},    'FaceAlpha', val_FaceAlpha); 
fill([res.mltple{4}.drug_uM(2:end)                          fliplr(res.mltple{4}.drug_uM(2:end))], ...
     [res.mltple{4}.lysis(1,2:end)./ref.Lysis_end(1).*100   fliplr(res.mltple{4}.lysis(2,2:end))./ref.Lysis_end(2).*100], ...
        color.mltple{4},    'FaceAlpha', val_FaceAlpha); 
fill([res.mltple{7}.drug_uM(2:end)                          fliplr(res.mltple{7}.drug_uM(2:end))], ...
     [res.mltple{7}.lysis(1,2:end)./ref.Lysis_end(1).*100   fliplr(res.mltple{7}.lysis(2,2:end))./ref.Lysis_end(2).*100], ...
        color.mltple{7},    'FaceAlpha', val_FaceAlpha); 
fill([res.single{7}.drug_uM(2:end)                          fliplr(res.single{7}.drug_uM(2:end))], ...
     [res.single{7}.lysis(1,2:end)./ref.Lysis_end(1).*100   fliplr(res.single{7}.lysis(2,2:end))./ref.Lysis_end(2).*100], ...
        color.single{7},    'FaceAlpha', val_FaceAlpha); 
fill([res.single{10}.drug_uM(2:end)                          fliplr(res.single{10}.drug_uM(2:end))], ...
     [res.single{10}.lysis(1,2:end)./ref.Lysis_end(1).*100   fliplr(res.single{10}.lysis(2,2:end))./ref.Lysis_end(2).*100], ...
        color.single{10},    'FaceAlpha', val_FaceAlpha); 
xlabel('Drug concentration (uM)',   'FontSize' ,14);
set(gca,'fontWeight','bold');
set(gca,'XScale','log');
grid on
xlim([1E-3 1E1])
ylim([0    110]);
ylabel('Normalized Hemolysis (%)', 'FontSize' ,14);
saveas(h, [figure_folder_summary_plots, 'LysisNormalized_comparison_inhibition_C3convertases_woInfo.png'], 'png')
ylim([0    120]);
ylabel('Lysis (%, norm. to lysis w/o drug)', 'FontSize' ,14);
txt = sprintf('Lysis in model w/o inhibitor: \nTakeda: %.3f%% \n     Kolb: %.3f%% ', ref.Lysis_end(1), ref.Lysis_end(2));
text(1.2E-3,110,txt)
saveas(h, [figure_folder_summary_plots, 'LysisNormalized_comparison_inhibition_C3convertases_woLegend.png'], 'png')
legend({res.drgs{2}.target, res.drgs{1}.target, res.drgs{4}.target,...
        res.mltple{3}.target, res.mltple{4}.target, res.mltple{7}.target, ...
        res.single{7}.target, res.single{10}.target, res.single{11}.target}, 'Location','northeast');
saveas(h, [figure_folder_summary_plots, 'LysisNormalized_comparison_inhibition_C3convertases.png'], 'png')


close all
end