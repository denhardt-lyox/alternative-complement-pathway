function simdata = validation_sim_Ferreira_2007(model, figure_folder, varargin)
%%% simulation of Ferreira 2007, Fig. 1

%% input parser
p = inputParser;

% StopTime of simulation
default.StopTime = 120; % 20 min - original time
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
if p.Results.plot_on  == 1
    if isempty(fields(p.Results.Data))
        data = load_data_Ferreira_2007();
    else 
        data = p.Results.Data;
    end
end

%% set and define variables
init_default    = get_ICs(model);

% number of cells, calculated as follows based on publication:
% 5E6 cells/24 uL - given in publication
% 2.08E5 cells/uL
% 2.08E11 cells/L
N_cells = 2.08E11; % cells/L
[Surf_0, ~, ~, ~] = get_surface_erythrocytes(N_cells);
% set(sbioselect(model,'Type','species','Where','Name', '==', 'Surface host'), 'InitialAmount', Surf_0); 
% set(sbioselect(model,'Type','species','Where','Name', '==', 'Erythrocytes_uM'), 'InitialAmount', cells_uM); 

model = set_ICs(model, init_default, 0.4, 'Surface', Surf_0); % 40% serum


%% define variants
var_DAF     = getvariant(model, 'regulators_NoDAF_var');
var_CD59    = getvariant(model, 'regulators_NoCD59_var');
var_FH_DAF  = [getvariant(model, 'regulators_NoDAF_var'), getvariant(model, 'regulators_no_H_binding_var')];
var_FH_CD59 = [getvariant(model, 'regulators_NoCD59_var'), getvariant(model, 'regulators_no_H_binding_var')];
var_FH      = getvariant(model, 'regulators_no_H_binding_var');


%% simulate
var_simdata.DAF         = sbiosimulate(model, var_DAF);
var_simdata.CD59        = sbiosimulate(model, var_CD59);
var_simdata.FH_DAF      = sbiosimulate(model, var_FH_DAF);
var_simdata.FH_CD59     = sbiosimulate(model, var_FH_CD59);
var_simdata.FH          = sbiosimulate(model, var_FH);


%% collect results
plot_var              = selectbyname(var_simdata.DAF, {'Percent_Lysis_Takeda', 'Percent_Lysis_Kolb'}); %, 'MAC host', 'Ba', 'C5a', 'Bb'});
simdata.DAF.Time      = plot_var.Time;
simdata.DAF.Lysis     = plot_var.Data(:,1:2);

plot_var              = selectbyname(var_simdata.CD59, {'Percent_Lysis_Takeda', 'Percent_Lysis_Kolb'});
simdata.CD59.Time     = plot_var.Time;
simdata.CD59.Lysis    = plot_var.Data(:,1:2);

plot_var              = selectbyname(var_simdata.FH_DAF, {'Percent_Lysis_Takeda', 'Percent_Lysis_Kolb'});
simdata.FH_DAF.Time   = plot_var.Time;
simdata.FH_DAF.Lysis  = plot_var.Data(:,1:2);

plot_var              = selectbyname(var_simdata.FH_CD59, {'Percent_Lysis_Takeda', 'Percent_Lysis_Kolb'});
simdata.FH_CD59.Time  = plot_var.Time;
simdata.FH_CD59.Lysis = plot_var.Data(:,1:2);

plot_var              = selectbyname(var_simdata.FH, {'Percent_Lysis_Takeda', 'Percent_Lysis_Kolb'});
simdata.FH.Time       = plot_var.Time;
simdata.FH.Lysis      = plot_var.Data(:,1:2);

            
%% plotting
if p.Results.plot_on == 1
    plot_validation_sim_Ferreira_2007(figure_folder, data, simdata)
end

%% restore default ICs
model = set_ICs(model, init_default, 1);
end