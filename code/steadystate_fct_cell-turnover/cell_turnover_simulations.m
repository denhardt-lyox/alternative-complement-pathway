function cell_turnover_simulations(model, production_rates, varargin)
%%% implementation and analysis of erythrocyte turnover as a function of
%%% hemolysis
%%% applied to test case: PNH type 2 and type 3 simulations

%% input parser
p = inputParser;

% Default values
%%% Plotting on or off
default.Plot_On       = 1;
%%% Fold-reduction of CD59 & DAF production rates in PNH type 2
% default.fold_red_PNH_T2 = 10;

% add inputs and check validity of formats
addRequired(p,  'model',                                     @(x) strcmp(class(x), 'SimBiology.Model'));
addRequired(p,  'production_rates',                          @(x) istable(x));
addParameter(p, 'Plot_On',          default.Plot_On,         @(x) isnumeric(x));
% addParameter(p, 'fold_red_PNH_T2',  default.fold_red_PNH_T2, @(x) isnumeric(x));

% parse results
parse(p, model, production_rates, varargin{:})

% extract frequently used variables for ease of handling
model            = p.Results.model;
production_rates = p.Results.production_rates;
Plot_On          = p.Results.Plot_On;
% fold_red_PNH_T2  = p.Results.fold_red_PNH_T2;

%% Plotting settings
FS.axis   = 16;
FS.legend = 16;
FS.labels = 20;

%% make and define figure folders for outputs
figure_folder = '../Figures/Figures_steadystate-model_cell-turnover-simulations_PNH/';
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

%%% Hematological levels for healthy and PNH
hematologyLevels.Healthy.Hemolgobin.min = 12;
hematologyLevels.Healthy.Hemolgobin.max = 17.5;
hematologyLevels.PNH.Hemolgobin.min     = 6;
hematologyLevels.PNH.Hemolgobin.max     = 10;

hematologyLevels.Healthy.LDH.min = 100;
hematologyLevels.Healthy.LDH.max = 190;
hematologyLevels.PNH.LDH.min     = 500;
hematologyLevels.PNH.LDH.max     = 5000;

hematologyLevels.Healthy.Hematocrit.min = 37;
hematologyLevels.Healthy.Hematocrit.max = 52;
hematologyLevels.PNH.Hematocrit.min     = 20;
hematologyLevels.PNH.Hematocrit.max     = 20;


%% set up steady state model
model_ss = prepare_steady_state_model(model, 'turnover_var_erythrocyte_turnover', ...
                                        production_rates);

%% Simulations
%%% simulate from steady state
StopTime    = 3*365; 

%%% select either Type 2 or Type 3 to 1 - defines which type to use for
%%% main plotting
PNH.Type2 = 0;
PNH.Type3 = 1;

%%% QC
if PNH.Type2 == 1 && PNH.Type3 == 1
    msg = 'you cannot select both PNH types 2 and 3 at the same time';
    error(msg)
end

%%% Solver Options
cs                                     = getconfigset(model_ss);
cs.CompileOptions.UnitConversion       = true;
cs.SolverType                          = 'ode15s'; % stiff solver
cs.SolverOptions.AbsoluteTolerance     = 1e-20;
cs.TimeUnits                           = 'day';
cs.StopTime                            = StopTime;

%%% reference simulation (= healthy)
simdata.ref = sbiosimulate(model_ss);

%%% Define/Get model variants
%%% PNH Type 2
PNH_T2  = sbioselect(model_ss.Variant, 'Where', 'Name', '==', 'PNH_Type_2');
%%% PNH Type 3
PNH_T3  = sbioselect(model_ss.Variant, 'Where', 'Name', '==', 'PNH_Type_3');

%%% PNH type 2 - simulate
simdata.PNH_T2 = sbiosimulate(model_ss, PNH_T2);

%%% PNH type 3 - simulate
simdata.PNH_T3 = sbiosimulate(model_ss, PNH_T3);

%%% select for which PNH type to do the main plotting
if(PNH.Type2)
    sim_simdata = simdata.PNH_T2;
elseif(PNH.Type3)
    sim_simdata = simdata.PNH_T3;
end


%% display hematological readouts
msg = 'Levels of hematological readouts in healthy and PNH type 2 and 3:';
disp(msg)

sim_select	= selectbyname(simdata.ref, {'Hemoglobin_g_dL'});
sim_select1	= selectbyname(simdata.PNH_T2, {'Hemoglobin_g_dL'});
sim_select2	= selectbyname(simdata.PNH_T3, {'Hemoglobin_g_dL'});
disp(['Hemoglobin (g/dL): ', num2str(sim_select.Data(end)), ', ' , num2str(sim_select1.Data(end)), ', ' , num2str(sim_select2.Data(end))])

sim_select	= selectbyname(simdata.ref, {'LDH_U_L'});
sim_select1	= selectbyname(simdata.PNH_T2, {'LDH_U_L'});
sim_select2	= selectbyname(simdata.PNH_T3, {'LDH_U_L'});
disp(['LDH (U/L): ', num2str(sim_select.Data(end)), ', ' , num2str(sim_select1.Data(end)), ', ' , num2str(sim_select2.Data(end))])

% sim_select	= selectbyname(sim_simdata, {'Haptoglobin'});
disp('Haptoglobin(mg/dL): -')

sim_select	= selectbyname(simdata.ref, {'Hematocrit_Percent'});
sim_select1	= selectbyname(simdata.PNH_T2, {'Hematocrit_Percent'});
sim_select2	= selectbyname(simdata.PNH_T3, {'Hematocrit_Percent'});
disp(['Hematocrit (%): ', num2str(sim_select.Data(end)), ', ' , num2str(sim_select1.Data(end)), ', ' , num2str(sim_select2.Data(end))])


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Plotting
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if (Plot_On)
    %% color definitions
    h = figure;
    colors = get(gca,'colororder');
    colors = repmat(colors, 3, 1);
    close(h)

    %% Summary plots
    %%% Final Ba, Bb, C3a, C5a and comparison to observationsrng(1231561)
    sim_select	= selectbyname(simdata.ref, {'Ba', 'Bb', 'C3a', 'C5a'});
    h = figure;
    hold on
    bar([1,2,3,4], [sim_select.Data(end,1), sim_select.Data(end,2), ...
        sim_select.Data(end,3), sim_select.Data(end,4)] .* 1E3, 'FaceColor', [0.75 0.75 0.75])
    plot(randn(length(ObsLevels.Ba_uM),1)/10 + 1,   ObsLevels.Ba_uM  .* 1E3,  'ko', 'MarkerSize', 8, 'LineWidth', 1.1)
    plot(randn(length(ObsLevels.Bb_uM),1)/10 + 2,   ObsLevels.Bb_uM  .* 1E3,  'ko', 'MarkerSize', 8, 'LineWidth', 1.1)
    plot(randn(length(ObsLevels.C3a_uM),1)/10 + 3,  ObsLevels.C3a_uM .* 1E3, 'ko', 'MarkerSize', 8, 'LineWidth', 1.1)
    plot(randn(length(ObsLevels.C5a_uM),1)/10 + 4,  ObsLevels.C5a_uM .* 1E3, 'ko', 'MarkerSize', 8, 'LineWidth', 1.1)
    xticks([1 2 3 4])
    xticklabels({'Ba', 'Bb', 'C3a', 'C5a'})
    xlim([0.5 4.5])
    set(gca,'FontSize', FS.axis);
    ylabel('Concentration (nM)', 'FontSize', FS.labels);
    ylim([1E-3 1E2])
    yticks([1E-3 1E-2 1E-1 1E0 1E1 1E2 1E3])
    set(gca,'YScale', 'log')
    grid on
    box on
    saveas(h, [figure_folder,'Ba-Bb-C3a-C5a_DataComparison.png'], 'png')

    %%% Final levels of ACP species and comparison to initial values
    initcond = get_ICs(model);

    sim_select	= selectbyname(sim_simdata, {'C3', 'C5', 'C6', 'C7', 'C8', ...
        'C9', 'B', 'D', 'P', 'I', 'H', 'Vn', 'Cn', 'CR1', 'DAF', 'CD59'});
    h = figure;
    hold on
    bar(1:16, sim_select.Data(end,:), 'FaceColor', [0.75 0.75 0.75])
    xticks(1:16)
    xticklabels({'C3', 'C5', 'C6', 'C7', 'C8', 'C9', 'B', 'D', 'P', 'I', 'H', 'Vn', 'Cn', 'CR1', 'DAF', 'CD59'})
    set(gca,'YScale', 'log')
    ylim([1E-3 1E1])
    plot(1:16, [initcond.C3_0, initcond.C5_0, initcond.C6_0,         initcond.C7_0, initcond.C8_0, initcond.C9_0,...
                initcond.B_0,  initcond. D_0, initcond.Properdin_0,  initcond.I_0,  initcond.H_0,  initcond.Vn_0,...
                initcond.Cn_0, initcond.CR1_0, initcond.DAF_0,       initcond.CD59_0],  'k*', 'MarkerSize', 10)
    set(gca,'FontSize', FS.axis-3);
    xtickangle(40)
    title('Concentration of free species')
    xlabel('Complement component', 'FontSize', FS.labels);
    ylabel('Concentration (uM)', 'FontSize', FS.labels);
    xlim([0.5 16.5])
    grid on
    saveas(h, [figure_folder,'All-synthesized-species_Ic-Comparison.png'], 'png')


    %% Hematological markers in steady state
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Hemoglobin
    h = figure;
    size = get(gcf, 'PaperPosition');
    set(gcf, 'PaperPositionMode', 'manual');
    set(gcf, 'PaperPosition', size ./ [1 1 3 1])
    hold on
    sim_select	= selectbyname(simdata.ref, {'Hemoglobin_g_dL'});
    bar(1, sim_select.Data(end,1), 'FaceColor', [0.75 0.75 0.75]) %[0.75 0 0]
    sim_select	= selectbyname(simdata.PNH_T2, {'Hemoglobin_g_dL'});
    bar(2, sim_select.Data(end,1), 'FaceColor', [0.75 0.75 0.75]) %[0.875 0.125 0]
    sim_select	= selectbyname(simdata.PNH_T3, {'Hemoglobin_g_dL'});
    bar(3, sim_select.Data(end,1), 'FaceColor', [0.75 0.75 0.75]) %[1 0.25 0]
    xticks([1,2,3])
    xticklabels({'H', 'T2', 'T3'})
    set(gca, 'FontSize', FS.axis);
    ylabel('Hemoglobin (g/dL)', 'FontSize', FS.labels);
    grid on
    box on
    ylim([0 20])
    xlim([0.5 3.5])
    % comparison to obs levels
    % healthy
    xpos    = 1;
    xlength = 0.1;
    LW = 1.5; 
    plot([xpos xpos],                 [hematologyLevels.Healthy.Hemolgobin.min,...
        hematologyLevels.Healthy.Hemolgobin.max], '-k', 'LineWidth', LW)
    plot([xpos-xlength xpos+xlength], [hematologyLevels.Healthy.Hemolgobin.min,...
        hematologyLevels.Healthy.Hemolgobin.min], '-k', 'LineWidth', LW)
    plot([xpos-xlength xpos+xlength], [hematologyLevels.Healthy.Hemolgobin.max,....
        hematologyLevels.Healthy.Hemolgobin.max], '-k', 'LineWidth', LW)
    % PNH
    xpos    = 2.5;
    xlength = 0.1;
    plot([xpos xpos],                 [hematologyLevels.PNH.Hemolgobin.min,...
        hematologyLevels.PNH.Hemolgobin.max], '-k', 'LineWidth', LW)
    plot([xpos-xlength xpos+xlength], [hematologyLevels.PNH.Hemolgobin.min,...
        hematologyLevels.PNH.Hemolgobin.min], '-k', 'LineWidth', LW)
    plot([xpos-xlength xpos+xlength], [hematologyLevels.PNH.Hemolgobin.max,...
        hematologyLevels.PNH.Hemolgobin.max], '-k', 'LineWidth', LW)
    saveas(h, [figure_folder,'PNH_Hemoglobin_comparison-bar.png'], 'png')
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Hematocrit
    h = figure;
    size = get(gcf, 'PaperPosition');
    set(gcf, 'PaperPositionMode', 'manual');
    set(gcf, 'PaperPosition', size ./ [1 1 3 1])
    hold on
    sim_select	= selectbyname(simdata.ref, {'Hematocrit_Percent'});
    bar(1, sim_select.Data(end,1), 'FaceColor', [0.75 0.75 0.75])
    sim_select	= selectbyname(simdata.PNH_T2, {'Hematocrit_Percent'});
    bar(2, sim_select.Data(end,1), 'FaceColor', [0.75 0.75 0.75])
    sim_select	= selectbyname(simdata.PNH_T3, {'Hematocrit_Percent'});
    bar(3, sim_select.Data(end,1), 'FaceColor', [0.75 0.75 0.75])
    xticks([1,2,3])
    xticklabels({'H', 'T2', 'T3'})
    set(gca, 'FontSize', FS.axis);
    ylabel('Hematocrit (%)', 'FontSize', FS.labels);
    grid on
    box on
    ylim([0 55])
    xlim([0.5 3.5])
    % comparison to obs levels
    % healthy
    xpos    = 1;
    xlength = 0.1;
    LW = 1.5; 
    plot([xpos xpos],                 [hematologyLevels.Healthy.Hematocrit.min,...
         hematologyLevels.Healthy.Hematocrit.max], '-k', 'LineWidth', LW)
    plot([xpos-xlength xpos+xlength], [hematologyLevels.Healthy.Hematocrit.min,...
         hematologyLevels.Healthy.Hematocrit.min], '-k', 'LineWidth', LW)
    plot([xpos-xlength xpos+xlength], [hematologyLevels.Healthy.Hematocrit.max,...
         hematologyLevels.Healthy.Hematocrit.max], '-k', 'LineWidth', LW)
    % PNH
    xpos    = 2.5;
    xlength = 0.1;
    % plot([xpos xpos], [hematologyLevels.PNH.Hematocrit.min, hematologyLevels.PNH.Hematocrit.max], '-k', 'LineWidth', LW)
    plot([xpos-xlength xpos+xlength], [hematologyLevels.PNH.Hematocrit.min,...
         hematologyLevels.PNH.Hematocrit.min], '-k', 'LineWidth', LW+2)
    plot([xpos-xlength xpos+xlength], [hematologyLevels.PNH.Hematocrit.max,...
         hematologyLevels.PNH.Hematocrit.max], '-k', 'LineWidth', LW+2)
    saveas(h, [figure_folder,'PNH_Hematocrit_comparison-bar.png'], 'png')
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % LDH
    h = figure;
    size = get(gcf, 'PaperPosition');
    set(gcf, 'PaperPositionMode', 'manual');
    set(gcf, 'PaperPosition', size ./ [1 1 3 1])
    hold on
    sim_select	= selectbyname(simdata.ref, {'LDH_U_L'});
    bar(1, sim_select.Data(end,1), 'FaceColor', [0.75 0.75 0.75])
    sim_select	= selectbyname(simdata.PNH_T2, {'LDH_U_L'});
    bar(2, sim_select.Data(end,1), 'FaceColor', [0.75 0.75 0.75])
    sim_select	= selectbyname(simdata.PNH_T3, {'LDH_U_L'});
    bar(3, sim_select.Data(end,1), 'FaceColor', [0.75 0.75 0.75])
    yticks([1E1 1E2 1E3 1E4])
    ylim([3E1 1E4])
    xlim([0.5 3.5])
    set(gca,'FontSize', FS.axis);
    xticks([1,2,3])
    xticklabels({'H', 'T2', 'T3'})
    ylabel('LDH (U/L)', 'FontSize', FS.labels);
    grid on
    box on
    set(gca,'YScale', 'log')
    % comparison to obs levels
    % healthy
    xpos    = 1;
    xlength = 0.1;
    LW = 1.5; 
    plot([xpos xpos],                 [hematologyLevels.Healthy.LDH.min,...
         hematologyLevels.Healthy.LDH.max], '-k', 'LineWidth', LW)
    plot([xpos-xlength xpos+xlength], [hematologyLevels.Healthy.LDH.min,...
         hematologyLevels.Healthy.LDH.min], '-k', 'LineWidth', LW)
    plot([xpos-xlength xpos+xlength], [hematologyLevels.Healthy.LDH.max,...
         hematologyLevels.Healthy.LDH.max], '-k', 'LineWidth', LW)
    % PNH
    xpos    = 2.5;
    xlength = 0.1;
    plot([xpos xpos],                 [hematologyLevels.PNH.LDH.min,...
         hematologyLevels.PNH.LDH.max], '-k', 'LineWidth', LW)
    plot([xpos-xlength xpos+xlength], [hematologyLevels.PNH.LDH.min,...
         hematologyLevels.PNH.LDH.min], '-k', 'LineWidth', LW)
    plot([xpos-xlength xpos+xlength], [hematologyLevels.PNH.LDH.max,...
         hematologyLevels.PNH.LDH.max], '-k', 'LineWidth', LW)
    saveas(h, [figure_folder,'PNH_LDH_comparison-bar.png'], 'png')
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 


    %% Kinetics of hematological markers
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%% Predicted hemolysis
    sim_select	= selectbyname(sim_simdata, {'Percent_Lysis_Takeda', 'Percent_Lysis_Kolb', 'Percent_Lysis_Mean'});
    h = figure;
    hold on
    fill([sim_select.Time' / 365, fliplr(sim_select.Time' / 365)],...
                [sim_select.Data(:,1)', fliplr(sim_select.Data(:,2)')],...
                 [1 0 0], 'FaceAlpha', 0.3, 'EdgeColor',  [1 0 0]);
    plot(sim_select.Time / 365, sim_select.Data(:,3), 'Color', [1 0 0])
    set(gca,'FontSize', FS.axis)
    xlabel('Time (years)',  'FontSize', FS.labels);
    ylabel('Hemolysis (%)', 'FontSize', FS.labels);
    grid on
    ylim([0 100])
    saveas(h, [figure_folder,'PNH_Lysis.png'], 'png')
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%% Hemoglobin 
    % lines are colored by hemoglobin levels using path instead of plot
    % nan at end of each vector is needed because otherwise patch closes the
    % curve 
    h = figure;
    % define color map
    colorMap = [linspace(1,0.75,256)', linspace(0.25,0,256)', zeros(256,1)];
    colormap(colorMap);
    % colorbar
    hold on
    caxis([4 15])
    % Reference
    sim_select	= selectbyname(simdata.ref, {'Hemoglobin_g_dL'});
    patch( [sim_select.Time/365; nan], [sim_select.Data(:,1); nan],...
         [sim_select.Data(:,1); nan], 'FaceColor', 'none', 'EdgeColor', 'interp', 'LineWidth', 3);
    %  PNH type 2
    sim_select	= selectbyname(simdata.PNH_T2, {'Hemoglobin_g_dL'});
    patch( [sim_select.Time/365; nan], [sim_select.Data(:,1); nan],...
         [sim_select.Data(:,1); nan], 'FaceColor', 'none', 'EdgeColor', 'interp', 'LineWidth', 3);
    % PNH type 3
    sim_select	= selectbyname(simdata.PNH_T3, {'Hemoglobin_g_dL'});
    patch( [sim_select.Time/365; nan], [sim_select.Data(:,1); nan],...
         [sim_select.Data(:,1); nan], 'FaceColor', 'none', 'EdgeColor', 'interp', 'LineWidth', 3);
    % plot settings
    set(gca, 'FontSize', FS.axis);
    xlabel('Time (years)',      'FontSize', FS.labels);
    ylabel('Hemoglobin (g/dL)', 'FontSize', FS.labels);
    grid on
    % set(gca,'YScale', 'log')
    ylim([0 20])
    % comparison to obs levels
    xpos    = 2.95;
    xlength = 0.05;
    LW = 1.5; 
    % healthy
    plot([xpos xpos],                 [hematologyLevels.Healthy.Hemolgobin.min,...
         hematologyLevels.Healthy.Hemolgobin.max], '-k', 'LineWidth', LW)
    plot([xpos-xlength xpos+xlength], [hematologyLevels.Healthy.Hemolgobin.min,...
         hematologyLevels.Healthy.Hemolgobin.min], '-k', 'LineWidth', LW)
    plot([xpos-xlength xpos+xlength], [hematologyLevels.Healthy.Hemolgobin.max,...
         hematologyLevels.Healthy.Hemolgobin.max], '-k', 'LineWidth', LW)
    % PNH
    plot([xpos xpos],                 [hematologyLevels.PNH.Hemolgobin.min,...
         hematologyLevels.PNH.Hemolgobin.max], '-k', 'LineWidth', LW)
    plot([xpos-xlength xpos+xlength], [hematologyLevels.PNH.Hemolgobin.min,...
         hematologyLevels.PNH.Hemolgobin.min], '-k', 'LineWidth', LW)
    plot([xpos-xlength xpos+xlength], [hematologyLevels.PNH.Hemolgobin.max,...
         hematologyLevels.PNH.Hemolgobin.max], '-k', 'LineWidth', LW)
    % saving
    saveas(h, [figure_folder,'PNH_Hemoglobin_comparison.png'], 'png')
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%% LDH 
    h = figure;
    hold on
    % Reference
    sim_select	= selectbyname(simdata.ref, {'LDH_U_L'});
    plot(sim_select.Time / 365, sim_select.Data(:,1), '-',  'LineWidth', 1.5, 'Color', [0 0 0]);
    % PNH Type 2
    sim_select	= selectbyname(simdata.PNH_T2, {'LDH_U_L'});
    plot(sim_select.Time / 365, sim_select.Data(:,1), '-.', 'LineWidth', 1.5, 'Color', [0 0 0]);
    % PNH Type 3
    sim_select	= selectbyname(simdata.PNH_T3, {'LDH_U_L'});
    plot(sim_select.Time / 365, sim_select.Data(:,1), '--',  'LineWidth', 1.5, 'Color', [0 0 0]);
    % plot settgins
    yticks([1E1 1E2 1E3 1E4])
    ylim([50 1E4])
    set(gca,'YScale', 'log')
    set(gca, 'FontSize', FS.axis);
    xlabel('Time (years)', 'FontSize', FS.labels);
    ylabel('LDH (U/L)',    'FontSize', FS.labels);
    grid on
    % comparison to obs levels
    xpos    = 2.95;
    xlength = 0.05;
    LW = 1.5; 
    % Healthy
    plot([xpos xpos],                 [hematologyLevels.Healthy.LDH.min,...
         hematologyLevels.Healthy.LDH.max], '-k', 'LineWidth', LW)
    plot([xpos-xlength xpos+xlength], [hematologyLevels.Healthy.LDH.min,...
         hematologyLevels.Healthy.LDH.min], '-k', 'LineWidth', LW)
    plot([xpos-xlength xpos+xlength], [hematologyLevels.Healthy.LDH.max,...
         hematologyLevels.Healthy.LDH.max], '-k', 'LineWidth', LW)
    % PNH
    plot([xpos xpos],                 [hematologyLevels.PNH.LDH.min,...
         hematologyLevels.PNH.LDH.max], '-k', 'LineWidth', LW)
    plot([xpos-xlength xpos+xlength], [hematologyLevels.PNH.LDH.min,...
         hematologyLevels.PNH.LDH.min], '-k', 'LineWidth', LW)
    plot([xpos-xlength xpos+xlength], [hematologyLevels.PNH.LDH.max,...
         hematologyLevels.PNH.LDH.max], '-k', 'LineWidth', LW)
    % saving
    saveas(h, [figure_folder,'PNH_LDH_comparison.png'], 'png')
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    %% QC Plots
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%% Erythrocyte conc. over time
    sim_select	= selectbyname(sim_simdata, {'Erythrocytes_uM'});
    h = figure;
    hold on
    plot(sim_select.Time / 365, sim_select.Data(:,1), '-',  'LineWidth', 1.5, 'Color', colors(1,:));
    ylim([3E-6 9E-6])
    set(gca,'FontSize', FS.axis);
    xlabel('Time (years)',       'FontSize', FS.labels);
    ylabel('Concentration (uM)', 'FontSize', FS.labels);
    grid on
    legend('Erythrocytes uM', 'Location', 'NorthEast', 'FontSize', FS.legend)
    saveas(h, [figure_folder,'QC_PNH_Erythrocytes_uM.png'], 'png')
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%% Total surface per erythrocyte over time
    sim_select	= selectbyname(sim_simdata, {'Erythrocytes_uM', 'Total_surface'});
    h = figure;
    hold on
    plot(sim_select.Time / 365, ...
        100/(sim_select.Data(1,2)./sim_select.Data(1,1)) .*...
        (sim_select.Data(:,2)./sim_select.Data(:,1)), '-', ...
        'LineWidth', 1.5, 'Color', colors(1,:));
    ylim([90 110])
    set(gca, 'FontSize', FS.axis)
    xlabel('Time (years)', 'FontSize', FS.labels);
    ylabel('Tot. surf per cell (% of IC)', 'FontSize', FS.labels)
    grid on
    box on
    saveas(h, [figure_folder,'QC_PNH_Surface-per-Erythrocyte.png'], 'png')
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%% Absolute levels of erhytrocyte concentration and total surfae over time
    sim_select	= selectbyname(sim_simdata, {'Erythrocytes_uM', 'Total_surface'});
    h = figure;
    hold on
    plot(sim_select.Time ./ 365, sim_select.Data(:,1) ./ sim_select.Data(1,1) ,...
        '-',  'LineWidth', 1.5, 'Color', colors(1,:));
    plot(sim_select.Time ./ 365, sim_select.Data(:,2) ./ sim_select.Data(1,2),...
        '--',  'LineWidth', 1.5, 'Color', colors(2,:));
    set(gca,'YScale','log')
    ylim([0 1])
    set(gca, 'FontSize', FS.axis)
    xlabel('Time (years)',                 'FontSize', FS.labels);
    ylabel('Concentration relative to IC', 'FontSize', FS.labels)
    grid on
    box on
    legend('Erythrocytes uM', 'Total surface', 'Location', 'NorthEast', ...
        'FontSize', FS.legend)
    saveas(h, [figure_folder,'QC_PNH_Surface_Erythrocyte.png'], 'png')
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%% rate of k_hemolysis over time
    sim_select	= selectbyname(sim_simdata, {'k_hemolysis'});
    h = figure;
    hold on
    plot(sim_select.Time / 365, sim_select.Data(:,1) *  60 *60 *24, 'Color', colors(1,:))
    set(gca, 'FontSize', FS.axis);
    xlabel('Time (years)',        'FontSize', FS.labels);
    ylabel('k_hemolysis (1/day)', 'FontSize', FS.labels, 'Interpreter', 'none');
    grid on
    saveas(h, [figure_folder,'QC_PNH_k_hemolysis.png'], 'png')
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%% Hemoglobin levels over time
    sim_select	= selectbyname(sim_simdata, {'Hemoglobin_g_dL'});
    h = figure;
    hold on
    plot(sim_select.Time, sim_select.Data(:,1), 'Color', colors(1,:))
    ylim([0 20])
    set(gca, 'FontSize', FS.axis);
    xlabel(['Time (', sim_select.TimeUnits,')'], 'FontSize', FS.labels);
    ylabel('Hemoglobin (g/dL)',                  'FontSize', FS.labels);
    grid on
    saveas(h, [figure_folder,'QC_PNH_hemoglobin.png'], 'png')
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%% Erhytrocyte concentration in N/L over time
    sim_select	= selectbyname(sim_simdata, {'Erythrocytes_N_L'});
    h = figure;
    hold on
    plot(sim_select.Time, sim_select.Data(:,1), 'Color', colors(1,:))
    set(gca, 'FontSize', FS.axis);
    xlabel(['Time (', sim_select.TimeUnits,')'], 'FontSize', FS.labels);
    ylabel('Erythrocytes [cells/L]',             'FontSize', FS.labels);
    grid on
    ylim([0 6E12])
    saveas(h, [figure_folder,'QC_PNH_erythrocytes_NL.png'], 'png')
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%% Hematocrit over time
    sim_select	= selectbyname(sim_simdata, {'Hematocrit_Percent'});
    h = figure;
    hold on
    plot(sim_select.Time, sim_select.Data(:,1), 'Color', colors(1,:))
    set(gca, 'FontSize', FS.axis);
    xlabel(['Time (', sim_select.TimeUnits,')'], 'FontSize', FS.labels);
    ylabel('Hematocrit (%)',                     'FontSize', FS.labels);
    grid on
    ylim([0 100])
    saveas(h, [figure_folder,'QC_PNH_hematocrit.png'], 'png')
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%% LDH in U/L over time
    sim_select	= selectbyname(sim_simdata, {'LDH_U_L'});
    h = figure;
    hold on
    plot(sim_select.Time, sim_select.Data(:,1), 'Color', colors(1,:))
    set(gca, 'FontSize', FS.axis);
    xlabel(['Time (', sim_select.TimeUnits,')'], 'FontSize', FS.labels);
    ylabel('LDH (U/L)',                          'FontSize', FS.labels);
    grid on
    saveas(h, [figure_folder,'QC_PNH_LDH.png'], 'png')
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
end
end