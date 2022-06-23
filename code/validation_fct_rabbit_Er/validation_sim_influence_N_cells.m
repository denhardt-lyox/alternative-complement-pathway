function validation_sim_influence_N_cells(model, figure_folder)
%%% simulate the activated model with various number of erythrocytes and
%%% get influence on % lysis


%% 
N_cells.vec = logspace(8.5, 15, 50);
N_cells.default = 5*10^12;
N_cells.Hemolysis_Assays_min = 1E10;
N_cells.Hemolysis_Assays_max = 1E11;

var = [getvariant(model, 'regulators_NoDAF_var'),...
                getvariant(model, 'regulators_NoCR1_var'),...
                getvariant(model, 'regulators_NoCD59_var'),...
                getvariant(model, 'regulators_no_H_binding_var')];
init_default = get_ICs(model);

res_sim.Lysis = nan(length(N_cells.vec), 2);
%%

for n = 1:length(N_cells.vec)
    [Surf_0, cells_uM, ~, ~] = get_surface_erythrocytes(N_cells.vec(n));
    set(sbioselect(model,'Type','species','Where','Name', '==', 'Surface host'), 'InitialAmount', Surf_0); 
%     set(sbioselect(model,'Type','species','Where','Name', '==', 'Erythrocytes_uM'), 'InitialAmount', cells_uM); 

    % simulate
    disp(num2str(n))
    disp(num2str(N_cells.vec(n)))
    res_sim.n_cells(n)          = sbiosimulate(model, var);
    % get results
    get_var                 = selectbyname(res_sim.n_cells(n), {'Percent_Lysis_Takeda', 'Percent_Lysis_Kolb', 'Surface host', 'MAC host'});
    res_sim.Lysis(n,:)      = get_var.Data(end,1:2);
    res_sim.Surface(n,:)    = get_var.Data(end,3);
    res_sim.MACperCell(n,:) = get_var.Data(end,4)/cells_uM;
end

%% Plot
h = figure;
set(h,'defaultAxesColorOrder',[[0 0.6 0]; [0.8500 0.3250 0.0980]]);
yyaxis left
hold on
l1 = fill([N_cells.Hemolysis_Assays_min, N_cells.Hemolysis_Assays_max, N_cells.Hemolysis_Assays_max N_cells.Hemolysis_Assays_min],...
        [0 0 120 120], [0 0 0]+0.6, 'FaceAlpha', 0.3, 'EdgeColor',[0 0 0]);
l2 = fill([N_cells.vec, fliplr(N_cells.vec)], [res_sim.Lysis(:,1)', fliplr(res_sim.Lysis(:,2)')], [0 0.6 0], 'FaceAlpha', 0.3, 'EdgeColor',[0 0.5 0]);
l3 = plot([N_cells.default N_cells.default], [0 120], '--', 'Color', [0 0 0]+0.3);

yyaxis right
plot(N_cells.vec, res_sim.MACperCell)
set(gca,'YScale','log')
ylabel('MAC (number/cell)', 'FontSize' ,14)

yyaxis left
leg = legend([l2 l3 l1], 'Model prediction', 'ER conc. in NHS', 'ER conc. used in hemolysis assays', 'Location', 'SouthEast');
set(leg, 'Interpreter', 'none');
xlabel('Conc. of erythrocytes (cells/L)', 'FontSize' ,14)
ylabel('Hemolysis (%)', 'FontSize' ,14)
set(gca,'fontWeight','bold')
grid on
ylim([0 110])
% xlim([1E8 1E20])
set(gca,'XScale','log')
saveas(h, [figure_folder, 'Influence_N_cells.png'], 'png')


% h = figure;
% hold on
% plot(N_cells.vec, res_sim.Surface)
% leg = legend([l2 l3 l1], 'Model prediction', 'ER conc. in NHS', 'ER conc. used in hemolysis assays', 'Location', 'SouthEast');
% set(leg, 'Interpreter', 'none');
% xlabel('Conc. of erythrocytes (cells/L)', 'FontSize' ,14)
% ylabel('% hemolysis', 'FontSize' ,14)
% set(gca,'fontWeight','bold')
% grid on
% ylim([0 110])
% % xlim([1E8 1E20])
% set(gca,'XScale','log')


%% restore default
set_ICs(model, init_default, 1)
end