function PK_fct(model, production_rates, varargin)
%%% Implementation of treatment simulations = Recovery of hemoglobin levels
%%% in PNH patients upon eculizumab ACP inhibition 

%% input parser
p = inputParser;


% add inputs and check validity of formats
addRequired(p,  'model',                              @(x) isa(x, 'SimBiology.Model'));
addRequired(p,  'production_rates',                   @(x) istable(x));

% parse results
parse(p, model, production_rates, varargin{:})

% extract frequently used variables for ease of handling
model            = p.Results.model;
production_rates = p.Results.production_rates;


%% Plot settings
FS.axis   = 16;
FS.legend = 16;
FS.labels = 20;


%% make and define figure folders for outputs
figure_folder = '../Figures/Figures_steadystate-model_PK-simulations/';
mkdir(figure_folder)


%% Hemoglobin levels Eculizumab Choi 2017
data.Choi = groupedData(readtable('../Data/Choi_2017_Fig2.csv', 'Delimiter', ','));


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
            
            
%% Solver Options
%%% time span to simulate
StopTime = 6 * 365; % 6 years

%%% set solver options
cs                                     = getconfigset(model_ss);
cs.CompileOptions.UnitConversion       = true;
cs.SolverType                          = 'ode15s'; % stiff solver
cs.SolverOptions.AbsoluteTolerance     = 1e-10;
cs.TimeUnits                           = 'day';
cs.StopTime                            = StopTime;


%% Define/Get model variants
%%% PNH Type 2
PNH_T2  = sbioselect(model_ss.Variant, 'Where', 'Name', '==', 'PNH_Type_2');
%%% PNH Type 3
PNH_T3  = sbioselect(model_ss.Variant, 'Where', 'Name', '==', 'PNH_Type_3');
%%% PNH Type 2 and 3 mix
PNH_Mix = sbioselect(model_ss.Variant, 'Where', 'Name', '==', 'PNH_Type_Mix');


%% Reference simulations without treatment
%%% Reference (= healthy inidividual)
simref.ref    = sbiosimulate(model_ss);
%%% PNH Type 2
simref.PNH_T2 = sbiosimulate(model_ss, PNH_T2);
%%% PNH Type 3
simref.PNH_T3 = sbiosimulate(model_ss, PNH_T3);


%% Simulate treatments
%%% C5 Drug = Eculizumab
    %%% Choi 2017 schedule + correct drug parameters
    Choi.times = [1 2 3 4] .* 7 - 7 + 3*12*4*7;
    Choi.amts  = 600;
           
    Choi.times_2 = (5:2:150) .* 7 - 7 + 3*12*4*7;
    Choi.amts_2  = 900;


    % 2019 FDA package insert https://www.accessdata.fda.gov/drugsatfda_docs/label/2019/125166s431lbl.pdf
    model_C5_Choi = PK_fct_aux(model_ss, 'C5drug', 'Kd', 0.120, 'kon', 20, 'T05', 14.3, 'Vd', 6.5, 'MW', 148E3,  ...
        'Time', Choi.times, 'Amount', Choi.amts,  ...
        'Time_2', Choi.times_2, 'Amount_2', Choi.amts_2);
    %%% simulate
    simC5.PNH_Mix_Choi = sbiosimulate(model_C5_Choi, PNH_Mix);    
    
    
    %%%% generic schedule + generic mAb parameters
    %%% set up model
    model_C5 = PK_fct_aux(model_ss, 'C5drug', 'DOSE', 13, 'Kd', 0.120, 'kon', 20, 'T05', 28);
    %%% simulate
    simC5.PNH_Mix = sbiosimulate(model_C5, PNH_Mix);


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Plotting
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% Eculizumab - Comparison to Choi 2017

    h = figure;
    hold on
    colorMap = [linspace(1,0.75,256)', linspace(0.25,0,256)', zeros(256,1)];
    colormap(colorMap);
    
    %%% generic treatment
%     sim_select	= selectbyname(simC5.PNH_Mix, {'Hemoglobin_g_dL'});
%     plot(sim_select.Time/7/4/12 - 3, sim_select.Data(:,1), '-', 'Color', [0 0 0], 'LineWidth', 2);
    
    % range of normal hemoglobin levels
    hf = fill([-4 4 4 -4], [12 12 17 17], [0 0 0]+0.6);
    set(hf,'EdgeColor','none')
    set(hf,'facealpha',.5)
    
    %%% treatment according to Choi 2017
    sim_select	= selectbyname(simC5.PNH_Mix_Choi, {'Hemoglobin_g_dL'});
    plot(sim_select.Time/7/4/12 - 3, sim_select.Data(:,1), '-', 'Color', [0  0 0], 'LineWidth', 2);
    
    %%%
    plot(data.Choi.Time_Months/12, data.Choi.ClassicPnh_Hemoglob_gdL, 'o', ...
        'Color', [0 0 0], 'LineWidth', 1.5, 'MarkerSize', 8);
    
    set(gca, 'FontSize', FS.axis);
    xlabel('Time since start of treatment (years)', 'FontSize', FS.labels);
    ylabel('Hemoglobin (g/dL)',                     'FontSize', FS.labels);
    grid on
    box on
%     saveas(h, [figure_folder,'PNH_Drugs-Comparison_Time-Course_Eculizumab-complete.png'], 'png')
    print('-dpng','-r600',[figure_folder,'PNH_Drugs-Comparison_Time-Course_Eculizumab-complete.png'])
    xlim([-0.1 3])
    ylim([8 12])
%     saveas(h, [figure_folder,'PNH_Drugs-Comparison_Time-Course_Eculizumab-treatment.png'], 'png')
    print('-dpng','-r600',[figure_folder,'PNH_Drugs-Comparison_Time-Course_Eculizumab-treatment.png'])
