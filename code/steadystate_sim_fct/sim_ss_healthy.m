function sim_ss_healthy(model, production_rates)
%%% simulate steady-state model for healthy individual
% -> plotting


%% make and define figure folders for outputs
figure_folder = '../Figures/Figures_steadystate-model_healthy-individual/';
mkdir(figure_folder)


%% Observed levels for C3a, C5a, Ba and Bb for model to data comparison
MW = get_MW;

% Observed levels of C3a, C5a, Ba and Bb
ObsLevels.C3a_ngml = [129.6	32.1 52.0 449.4 11.95 0.05 86.4 14.3 63.7];
ObsLevels.C5a_ngml = [20.65	1.03 4.0  15.94 8.34  0.16 1.67 0.21];
ObsLevels.Ba_ngml  = [658 1000];
ObsLevels.Bb_ngml  = [960 650];

% convert ng/ml to ug/ml and then to uM
ObsLevels.C3a_uM   = ObsLevels.C3a_ngml .* 1E-3 .* 1E3 ./ MW.C3a;
ObsLevels.C5a_uM   = ObsLevels.C5a_ngml .* 1E-3 .* 1E3 ./ MW.C5a;
ObsLevels.Ba_uM    = ObsLevels.Ba_ngml  .* 1E-3 .* 1E3 ./ MW.Ba;
ObsLevels.Bb_uM    = ObsLevels.Bb_ngml  .* 1E-3 .* 1E3 ./ MW.Bb;

                       
%% set up steady state model
model_ss = prepare_steady_state_model(model, 'turnover_var_erythrocyte_turnover', ...
                                        production_rates);
            
            
%% Solver Options
StopTime = 10 * 365; % 1 year

cs                                     = getconfigset(model_ss);
cs.CompileOptions.UnitConversion       = true;
cs.SolverType                          = 'ode15s'; % stiff solver
cs.SolverOptions.AbsoluteTolerance     = 1e-10;
cs.TimeUnits                           = 'day';
cs.StopTime                            = StopTime;


%% Reference simulations without treatment
simdata.ref    = sbiosimulate(model_ss);

initcond = get_ICs(model_ss);


%% Plot settings
FS.axis   = 16;
FS.legend = 16;
FS.labels = 20;

%% Plotting
%%% Color definitions
h = figure;
colors = get(gca,'colororder');
colors = repmat(colors, 3, 1);
close(h)

%%% Basic proteins - estimates vs IC
sim_select	= selectbyname(simdata.ref, {'C3', 'C5', 'C6', 'C7', 'C8', 'C9', 'B', 'D', 'P', 'I', 'H', 'Vn', 'Cn', 'CR1', 'DAF', 'CD59'});
h = figure;
hold on
bar(1:16, sim_select.Data(end,:), 'FaceColor', [0.75 0.75 0.75])
plot(1:16, [initcond.C3_0, initcond.C5_0, initcond.C6_0,         initcond.C7_0, initcond.C8_0, initcond.C9_0,...
            initcond.B_0,  initcond. D_0, initcond.Properdin_0,  initcond.I_0,  initcond.H_0,  initcond.Vn_0,...
            initcond.Cn_0, initcond.CR1_0, initcond.DAF_0,       initcond.CD59_0],  'kd', 'MarkerSize', 7, 'MarkerFaceColor', [0 0 0])
xlim([0.25 16.75])
xticks(1:16)
xticklabels({'C3', 'C5', 'C6', 'C7', 'C8', 'C9', 'B', 'D', 'P', 'I', 'H', 'Vn', 'Cn', 'CR1', 'DAF', 'CD59'})
xtickangle(45)
set(gca,'YScale', 'log')
ylim([1E-3 1E1])
set(gca,'FontSize', 14)
ylabel('Concentration (uM)', 'FontSize', FS.labels);
grid off
box on
saveas(h, [figure_folder, 'Basic-proteins.png'], 'png')

%%% Activation markers - Ba, Bb, C3a, C5a
rng(1231561)
sim_select	= selectbyname(simdata.ref, {'Ba', 'Bb', 'C3a', 'C5a'});
h = figure;
hold on
bar([1,2,3,4], [sim_select.Data(end,1), sim_select.Data(end,2), sim_select.Data(end,3), sim_select.Data(end,4)] .* 1E3, 'FaceColor', [0.75 0.75 0.75])
plot(randn(length(ObsLevels.Ba_uM),1)/10 + 1,   ObsLevels.Ba_uM  .* 1E3,  'ko', 'MarkerSize', 8, 'LineWidth', 1.1)
plot(randn(length(ObsLevels.Bb_uM),1)/10 + 2,   ObsLevels.Bb_uM  .* 1E3,  'ko', 'MarkerSize', 8, 'LineWidth', 1.1)
plot(randn(length(ObsLevels.C3a_uM),1)/10 + 3,  ObsLevels.C3a_uM .* 1E3, 'ko', 'MarkerSize', 8, 'LineWidth', 1.1)
plot(randn(length(ObsLevels.C5a_uM),1)/10 + 4,  ObsLevels.C5a_uM .* 1E3, 'ko', 'MarkerSize', 8, 'LineWidth', 1.1)
xticks([1 2 3 4])
xticklabels({'Ba', 'Bb', 'C3a', 'C5a'})
xlim([0.5 4.5])
set(gca,'FontSize', FS.axis);
ylabel('Concentration (nM)', 'FontSize', FS.labels);
ylim([1E-3 5E2])
yticks([1E-3 1E-2 1E-1 1E0 1E1 1E2 1E3])
set(gca,'YScale', 'log')
grid on
box on
saveas(h, [figure_folder,'Act-Markers_DataComparison.png'], 'png')

end