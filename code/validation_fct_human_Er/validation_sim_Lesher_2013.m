function simdata = validation_sim_Lesher_2013(model, figure_folder, varargin)
%%% simulation of Lesher 2013 Fig. 9

%% input parser
p = inputParser;

% StopTime of simulation
default.StopTime = 120; % 30 min - assumed based on standard time used by others
% TimeUnits of simulation
default.TimeUnits = 'minute';
% determine whether plots should be generated and saved
default.plot_on  = 1; 
% empty data - load data if not provided as input
default.Data  = struct(); 

% add inputs and check validity of format
addRequired(p, 'model', @(x) strcmp(class(x), 'SimBiology.Model'));
addRequired(p, 'figure_folder', @ischar);
addParameter(p, 'StopTime', default.StopTime, @isnumeric)
addParameter(p, 'TimeUnits', default.TimeUnits, @ischar)
addParameter(p, 'plot_on', default.plot_on, @(x) (isnumeric(x) && x == 0 || x == 1))
addParameter(p, 'Data', default.Data, @isstruct)

% parse results
parse(p, model, figure_folder, varargin{:})

% extract frequently used variables for ease of handling
model           = p.Results.model;
figure_folder   = p.Results.figure_folder;

%%
cs           = getconfigset(model);
cs.StopTime  = p.Results.StopTime;
cs.TimeUnits = p.Results.TimeUnits;
        

%% load data
if p.Results.plot_on == 1
    if isempty(fields(p.Results.Data))
        data = load_data_Lesher_2013();
    else 
        data = p.Results.Data;
    end
end

%% set and define variables
init_default    = get_ICs(model);

% number of cells - unkown, guessed
N_cells = 1E11; % cells/L
[Surf_0, ~, ~, ~] = get_surface_erythrocytes(N_cells);

model = set_ICs(model, init_default, 0.5, 'Surface', Surf_0); % 50% serum


%% define variants
var_DAF         =  getvariant(model, 'regulators_NoDAF_var');
var_FH_DAF      = [getvariant(model, 'regulators_NoDAF_var'), getvariant(model, 'regulators_no_H_binding_var')];
var_FH          =  getvariant(model, 'regulators_no_H_binding_var');
var_FH_DAF_FP   = [getvariant(model, 'regulators_NoDAF_var'), getvariant(model, 'regulators_no_H_binding_var'), getvariant(model, 'regulators_NoP_var')];
var_FH_FP       = [getvariant(model, 'regulators_no_H_binding_var'), getvariant(model, 'regulators_NoP_var')];


%% simulate
var_simdata.Reference   = sbiosimulate(model);
var_simdata.DAF         = sbiosimulate(model, var_DAF);
var_simdata.FH_DAF      = sbiosimulate(model, var_FH_DAF);
var_simdata.FH          = sbiosimulate(model, var_FH);
var_simdata.FH_DAF_FP   = sbiosimulate(model, var_FH_DAF_FP);
var_simdata.FH_FP       = sbiosimulate(model, var_FH_FP);


%% collect results
plot_var                = selectbyname(var_simdata.DAF, {'Percent_Lysis_Takeda', 'Percent_Lysis_Kolb', 'MAC host', 'Ba', 'C5a', 'Bb'});
simdata.DAF.Time        = plot_var.Time;
simdata.DAF.Lysis       = plot_var.Data(:,1:2);

plot_var                = selectbyname(var_simdata.FH_DAF, {'Percent_Lysis_Takeda', 'Percent_Lysis_Kolb', 'MAC host', 'Ba', 'C5a', 'Bb'});
simdata.FH_DAF.Time     = plot_var.Time;
simdata.FH_DAF.Lysis    = plot_var.Data(:,1:2);

plot_var                = selectbyname(var_simdata.FH, {'Percent_Lysis_Takeda', 'Percent_Lysis_Kolb', 'MAC host', 'Ba', 'C5a', 'Bb'});
simdata.FH.Time         = plot_var.Time;
simdata.FH.Lysis        = plot_var.Data(:,1:2);

plot_var                = selectbyname(var_simdata.FH_DAF_FP, {'Percent_Lysis_Takeda', 'Percent_Lysis_Kolb', 'MAC host', 'Ba', 'C5a', 'Bb'});
simdata.FH_DAF_FP.Time  = plot_var.Time;
simdata.FH_DAF_FP.Lysis = plot_var.Data(:,1:2);

plot_var                = selectbyname(var_simdata.FH_FP, {'Percent_Lysis_Takeda', 'Percent_Lysis_Kolb', 'MAC host', 'Ba', 'C5a', 'Bb'});
simdata.FH_FP.Time      = plot_var.Time;
simdata.FH_FP.Lysis     = plot_var.Data(:,1:2);


%% plotting
if p.Results.plot_on == 1
    plot_validation_sim_Lesher_2013(figure_folder, data, simdata)
end

%% restore default ICs
model = set_ICs(model, init_default, 1);
end