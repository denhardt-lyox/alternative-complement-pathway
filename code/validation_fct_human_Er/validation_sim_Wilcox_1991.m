function simdata = validation_sim_Wilcox_1991(model, figure_folder, varargin)
%%% simulation of Fig. 3 from Biesma et al., 2001. A family with complement 
%%% factor D deficiency. The Journal of Clinical Investigation
%%% Approach and assumptions:
%%% -   read-out after 30 min
%%% -   human erythrocytes -> partially disabled surface regulation
%%% -   5E8 cells/mL - stock solution!


%% input parser
p = inputParser;

% StopTime of simulation
default.StopTime = 30;  % 30 min - original time
% TimeUnits of simulation
default.TimeUnits = 'minute';
% determine whether plots should be generated and saved
default.plot_on  = 1; 
% empty data - load data if not provided as input
default.Data  = struct(); 

% add inputs and check validity of format
addRequired(p,  'model',         @(x) strcmp(class(x), 'SimBiology.Model'));
addRequired(p,  'figure_folder', @ischar);
addParameter(p, 'StopTime',      default.StopTime, @isnumeric)
addParameter(p, 'TimeUnits',     default.TimeUnits, @ischar)
addParameter(p, 'plot_on',       default.plot_on, @(x) (isnumeric(x) && x == 0 || x == 1))
addParameter(p, 'Data',          default.Data, @isstruct)

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
        data = load_data_Wilcox_1991();
    else
        data = p.Results.Data;
    end
end


%% set variables
init_default    = get_ICs(model);

% number of cells 
N_cells = 5E8 * 1E3 * 1/4; %cells/L, assumed dilution according to protocol
[Surf_0, cells_uM, ~, ] = get_surface_erythrocytes(N_cells);

model = set_ICs(model, init_default, 0.9 * 0.5, 'Surface', Surf_0); % assumed dilution of NHS based on protocol


%% define inhibition variants
var_NoSurfReg       = [getvariant(model, 'regulators_NoDAF_var'),...
                            getvariant(model, 'regulators_NoCR1_var'),...
                            getvariant(model, 'regulators_NoCD59_var'),...
                            getvariant(model, 'regulators_no_H_binding_var')];
var_NoCD59_DAF      = [getvariant(model, 'regulators_NoCD59_var'),...
                            getvariant(model, 'regulators_NoDAF_var')];
var_NoCD59          = getvariant(model, 'regulators_NoCD59_var');
var_NoDAF           = getvariant(model, 'regulators_NoDAF_var');


%% simulate
var_simdata.reference   = sbiosimulate(model);   
var_simdata.NoSurfReg   = sbiosimulate(model, var_NoSurfReg); 
var_simdata.CD59        = sbiosimulate(model, var_NoCD59);
var_simdata.DAF         = sbiosimulate(model, var_NoDAF);
var_simdata.CD59_DAF    = sbiosimulate(model, var_NoCD59_DAF);


%% collect results
plot_var                        = selectbyname(var_simdata.reference, {'Percent_Lysis_Takeda', 'Percent_Lysis_Kolb', 'C3d_Ab_Wilcox'}); 
simdata.reference.Time          = plot_var.Time;
simdata.reference.Lysis         = plot_var.Data(:,1:2);
simdata.reference.C3d_Ab_Wilcox = plot_var.Data(:,3);

plot_var                        = selectbyname(var_simdata.NoSurfReg, {'Percent_Lysis_Takeda', 'Percent_Lysis_Kolb', 'C3d_Ab_Wilcox'});
simdata.NoSurfReg.Time          = plot_var.Time;
simdata.NoSurfReg.Lysis         = plot_var.Data(:,1:2);
simdata.NoSurfReg.C3d_Ab_Wilcox = plot_var.Data(:,3);

plot_var                        = selectbyname(var_simdata.CD59, {'Percent_Lysis_Takeda', 'Percent_Lysis_Kolb', 'C3d_Ab_Wilcox'});
simdata.CD59.Time               = plot_var.Time;
simdata.CD59.Lysis              = plot_var.Data(:,1:2);
simdata.CD59.C3d_Ab_Wilcox      = plot_var.Data(:,3);

plot_var                        = selectbyname(var_simdata.DAF, {'Percent_Lysis_Takeda', 'Percent_Lysis_Kolb', 'C3d_Ab_Wilcox'});
simdata.DAF.Time                = plot_var.Time;
simdata.DAF.Lysis               = plot_var.Data(:,1:2);
simdata.DAF.C3d_Ab_Wilcox       = plot_var.Data(:,3);

plot_var                        = selectbyname(var_simdata.CD59_DAF, {'Percent_Lysis_Takeda', 'Percent_Lysis_Kolb', 'C3d_Ab_Wilcox'});
simdata.CD59_DAF.Time           = plot_var.Time;
simdata.CD59_DAF.Lysis          = plot_var.Data(:,1:2);
simdata.CD59_DAF.C3d_Ab_Wilcox  = plot_var.Data(:,3);


%% Plotting
if p.Results.plot_on == 1
    plot_validation_sim_Wilcox_1991(figure_folder, data, simdata, var_simdata)
end

%% Restore default initial conditions
model = set_ICs(model, init_default, 1);
end
