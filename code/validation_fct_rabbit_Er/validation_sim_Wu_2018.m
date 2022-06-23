function res = validation_sim_Wu_2018(model, figure_folder, varargin)
%%% simulation of Wu 2018, Fig 10 and 11

%% input parser
p = inputParser;

% StopTime of simulation
default.StopTime = 120; % 120 min - assumed based on other experiments in publication
% TimeUnits of simulation
default.TimeUnits = 'minute';
% determine whether plots should be generated and saved
default.plot_on  = 1; 
% empty data - load data if not provided as input
default.Data  = struct(); 
% logical - if fitting_on == 1, output times and simulated conc. are matched to data
default.fitting_on = 0; 

% add inputs and check validity of format
addRequired(p,  'model', @(x) strcmp(class(x), 'SimBiology.Model'));
addRequired(p,  'figure_folder', @ischar);
addParameter(p, 'StopTime', default.StopTime, @isnumeric)
addParameter(p, 'TimeUnits', default.TimeUnits, @ischar)
addParameter(p, 'plot_on', default.plot_on, @(x) (isnumeric(x) && x == 0 || x == 1))
addParameter(p, 'Data', default.Data, @isstruct)
addParameter(p, 'fitting_on', default.fitting_on, @(x) (isnumeric(x) && x == 0 || x == 1))

% parse results
parse(p, model, figure_folder, varargin{:})

% extract frequently used variables for ease of handling
model           = p.Results.model;
figure_folder   = p.Results.figure_folder;


%% set solver options
cs           = getconfigset(model);
cs.StopTime  = p.Results.StopTime;
cs.TimeUnits = p.Results.TimeUnits;


%% load data
if p.Results.plot_on == 1
    if isempty(fields(p.Results.Data))
        data = load_data_Wu_2018();
    else
        data = p.Results.Data; 
    end
end

%% set and define variables
% get default initial conditions 
init_default    = get_ICs(model);

% number of cells - unkown, guessed
N_cells = 1E11; % cells/L

% get surface parameters
[Surf_0, ~, ~, ~] = get_surface_erythrocytes(N_cells);

% set IC to 20% serum
model = set_ICs(model, init_default, 0.2, 'Surface', Surf_0); % 20% serum

% define variant w/o surface regulation - rabbit erythrocytes
var = [getvariant(model, 'regulators_NoDAF_var'),...
                getvariant(model, 'regulators_NoCR1_var'),...
                getvariant(model, 'regulators_NoCD59_var'),...
                getvariant(model, 'regulators_no_H_binding_var')];

% Molecular Weights - needed for mass to molar conc calculation
MW = get_MW;
            

%% reference simulation for mixing experiments - NHS at 20%
var_simdata.ref         = sbiosimulate(model, var);
plot_var                = selectbyname(var_simdata.ref, {'Percent_Lysis_Takeda', 'Percent_Lysis_Kolb'});
res.ref.lysis(1,1:2)    = plot_var.Data(end,1:2);


%% simulate FD mixing
% orig_model = copyobj(model);
% clearvars model
% model = copyobj(orig_model);

% generate vector with WT serum in %
if p.Results.fitting_on == 0
    wt_serum_array = logspace(-2, 2, 50); %0.01 - 100%
elseif p.Results.fitting_on == 1
    wt_serum_array = [0.05, 0.5, 2.5, 5, 10, 25, 50, 100]; 
end

% concentration of FD at 20% NHS
D_0_20percent = get(sbioselect(model,'Type','species','Where','Name', '==', 'D'), 'InitialAmount');

% Preallocate readouts
res.fd.lysis    = zeros(length(wt_serum_array),2);
res.fd.dilution = zeros(length(wt_serum_array),1);
res.fd.FD_conc  = zeros(length(wt_serum_array),1);

% simulate with different ratios of FD-depleted and WT serum
for n = 1:length(wt_serum_array)
    FD_conc                 = D_0_20percent * wt_serum_array(n) / 100;
    set(sbioselect(model,'Type','species','Where','Name', '==', 'D'), 'InitialAmount', FD_conc) 
    var_simdata.fd          = sbiosimulate(model, var);
    
    % store readouts
    plot_var                = selectbyname(var_simdata.fd, {'Percent_Lysis_Takeda', 'Percent_Lysis_Kolb'});
    res.fd.FD_conc(n)       = FD_conc;
    res.fd.dilution(n)      = wt_serum_array(n);
    res.fd.lysis(n,1:2)     = plot_var.Data(end,1:2) ./ res.ref.lysis .* 100; % normalize to ref sim and scale to 100%
end

% restore default model
model = set_ICs(model, init_default, 0.2, 'Surface', Surf_0); % 20% serum


%% simulate C3 mixing
% clearvars model
% model = copyobj(orig_model);

% generate vector with WT serum in %
if p.Results.fitting_on == 0
    wt_serum_array = logspace(-2, 2, 50);
elseif p.Results.fitting_on == 1
    wt_serum_array = [0.05, 2.5, 5, 12.5, 25, 50, 100]; 
end
    
C3_0_20percent = get(sbioselect(model,'Type','species','Where','Name', '==', 'C3'), 'InitialAmount');

% Preallocate readouts
res.c3.lysis    = zeros(length(wt_serum_array),2);
res.c3.dilution = zeros(length(wt_serum_array),1);
res.c3.C3_conc  = zeros(length(wt_serum_array),1);

% simulate with different ratios of C3-depleted and WT serum
for n = 1:length(wt_serum_array)
    C3_conc                = C3_0_20percent * wt_serum_array(n) / 100;
    set(sbioselect(model,'Type','species','Where','Name', '==', 'C3'), 'InitialAmount', C3_conc) 
    var_simdata.c3         = sbiosimulate(model, var);
    
    % get readouts
    plot_var               = selectbyname(var_simdata.c3, {'Percent_Lysis_Takeda', 'Percent_Lysis_Kolb'});
    res.c3.C3_conc(n)      = C3_conc;
    res.c3.dilution(n)     = wt_serum_array(n);
    res.c3.lysis(n,1:2)    = plot_var.Data(end,1:2) ./ res.ref.lysis .* 100; % normalize to ref sim and scale to 100%
end

% restore default model
model = set_ICs(model, init_default, 0.2, 'Surface', Surf_0); % 20% serum


%% simulate FD replenishment, readout at 5 min or 30 min
% clearvars model
% model = copyobj(orig_model);

% number of simulations
n_simulations = 30;

% concentrations of FD to be simulated
if p.Results.fitting_on == 0
    hFD_ngml = logspace(1, 4, n_simulations);
elseif p.Results.fitting_on == 1
    hFD_ngml = [0, 25, 50, 100, 200, 400, 800, 1600, 3000, 6000];
end
hFD_uM = hFD_ngml .* 1E-3 .* 1E3 ./ MW.D ;

% Preallocate readouts
res.min5.hFD_ngml   = zeros(length(hFD_ngml),1);
res.min5.hFD_uM     = zeros(length(hFD_ngml),1);
res.min5.lysis      = zeros(length(hFD_ngml),2);
res.min30.hFD_ngml  = zeros(length(hFD_ngml),1);
res.min30.hFD_uM    = zeros(length(hFD_ngml),1);
res.min30.lysis     = zeros(length(hFD_ngml),2);

% set stoptime and output times
cs                           = getconfigset(model);
cs.StopTime                  = 30;
cs.TimeUnits                 = 'minute';
cs.SolverOptions.OutputTimes = [5 30];

% set ICs to 20% serum
model = set_ICs(model, init_default, 0.2, 'Surface', Surf_0);

% loop over FD concentrations, simulate and read out lysis at 5 and 30
% minutes
for n = 1:length(hFD_uM)
    % set FD and simulate
    set(sbioselect(model,'Type','species','Where','Name', '==', 'D'), 'InitialAmount', hFD_uM(n)) 
    temp_simdata            = sbiosimulate(model, var);
    % get readouts
    plot_var                = selectbyname(temp_simdata, {'Percent_Lysis_Takeda', 'Percent_Lysis_Kolb', 'Total_surface'});
    res.min5.hFD_ngml(n)    = hFD_ngml(n);
    res.min5.hFD_uM(n)      = hFD_uM(n);
    res.min5.lysis(n,1:2)   = plot_var.Data(1,1:2);
    
    res.min30.hFD_ngml(n)    = hFD_ngml(n);
    res.min30.hFD_uM(n)      = hFD_uM(n);
    res.min30.lysis(n,1:2)   = plot_var.Data(2,1:2);
end

% restore default model
model = set_ICs(model, init_default, 0.2, 'Surface', Surf_0); % 20% serum
cs.SolverOptions.OutputTimes = [];

%% Time course at 400 ng/ml FD
% clearvars model
% model = copyobj(orig_model);

% set solver options
cs                           = getconfigset(model);
cs.StopTime                  = 120;
cs.TimeUnits                 = 'minute';

if p.Results.fitting_on == 0
    cs.SolverOptions.OutputTimes = [];
elseif p.Results.fitting_on == 1
    cs.SolverOptions.OutputTimes = [0.15, 5, 10, 20, 30, 60, 120];
end

% set ICs to 20% serum
model = set_ICs(model, init_default, 0.2, 'Surface', Surf_0);

% define FD conc. to be used
hFD_400_ngml        = 400;
hFD_400_uM          = hFD_400_ngml .* 1E-3 .* 1E3 ./ MW.D ;
set(sbioselect(model,'Type','species','Where','Name', '==', 'D'), 'InitialAmount', hFD_400_uM) 
% simulate
temp_simdata        = sbiosimulate(model, var);
% get readouts
plot_var            = selectbyname(temp_simdata, {'Percent_Lysis_Takeda', 'Percent_Lysis_Kolb'});
res.hFD400.lysis    = plot_var.Data(:,1:2);
res.hFD400.time     = plot_var.Time;
   
% restore default model
model = set_ICs(model, init_default, 0.2, 'Surface', Surf_0); % 20% serum
cs.SolverOptions.OutputTimes = [];


%% plotting
if p.Results.plot_on == 1
    plot_validation_sim_Wu_2018(figure_folder, data, res, D_0_20percent, C3_0_20percent)
end

%% restore default ICs
model = set_ICs(model, init_default, 1);
% reset stoptime to default value as was at start of this function
% cs.StopTime         = StopTime_default;
end