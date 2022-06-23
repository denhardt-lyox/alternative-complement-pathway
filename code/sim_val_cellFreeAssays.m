function sim_val_cellFreeAssays(model, varargin)
% driver file for validation simulations - cell free assays
% simulated:
% Fluid phase - Morad 2015, Berseth 2013, Sagar 2016, Pangburn 1981
% Pangburn 1986 Fig 6 & Fig 3
% Pangburn 1983 Fig 2
% 
% Args: 
%   model            - simbiology model object
% Outputs
%   none (figures are saved on disk)


%% input parser
p = inputParser;

% Folder for figures
default.figure_folder = '../Figures/Figures_validation_cell-free-assays/';

% add inputs and check validity of format
addRequired(p,  'model', @(x) strcmp(class(x), 'SimBiology.Model'));
addParameter(p, 'figure_folder', default.figure_folder, @ischar);

% parse results
parse(p, model, varargin{:})

% extract frequently used variables for ease of handling
model           = p.Results.model;
figure_folder   = p.Results.figure_folder;


%% Determine which simulations to run
run.Morad_Sagar_Bergseth_Pangburn = 1;
run.Pangburn_1986                 = 1;
run.Pangburn_1983                 = 1;

%% Folder for figures
mkdir(figure_folder)

%% Load data
load_exp_data_plot_on = 0;
[data.bergseth, data.morad, data.bexbornC3H2O, data.bexbornC3b, data.pangburn, data.sagar] = load_data_fluid_phase(load_exp_data_plot_on);
% data = load_data_Bergseth_2013();
% data = load_data_Morad_2015(data);
% data = load_data_Bexborn(data);
% data = load_data_Pangburn_1981(data);
% data = load_data_Sagar_2016(data);

%% Solver settings
cs                                  = getconfigset(model);
cs.CompileOptions.UnitConversion    = true;
cs.SolverType                       = 'ode15s'; % stiff solver
cs.SolverOptions.AbsoluteTolerance  = 1e-18;
cs.SolverOptions.SensitivityAnalysis= false;
    

%% Morad 2015, Sagar 2016, Bergeseth 2013, Pangburn 1981
if(run.Morad_Sagar_Bergseth_Pangburn)
    cs.TimeUnits  = 'hour';
    cs.StopTime   = 24;

    fluidPhase_simdata            = sbiosimulate(model, getvariant(model, 'FluidPhase'));
    pangburn_var_simdata          = sbiosimulate(model, getvariant(model, 'pangburn_var'));
    pangburn_NoFIH_var_simdata    = sbiosimulate(model, getvariant(model, 'pangburn_NoFIH_var'));
    pangburn_NoFIHBD_var_simdata  = sbiosimulate(model, getvariant(model, 'pangburn_NoFIHBD_var'));

    plot_validation_sim_fluid_phase(figure_folder,...
                    fluidPhase_simdata,... 
                    pangburn_var_simdata,...
                    pangburn_NoFIH_var_simdata,...
                    pangburn_NoFIHBD_var_simdata,...
                    data.bergseth, data.morad, data.sagar, data.pangburn);
end


%% Pangburn 1986
if(run.Pangburn_1986)
    copiedModel = copyobj(model);
    validation_sim_Pangburn_1986(copiedModel, figure_folder);
    delete(copiedModel); close all;
end

%% Pangburn 1983
if(run.Pangburn_1983)
    copiedModel = copyobj(model);
    validation_sim_Pangburn_1983(copiedModel, figure_folder);
    delete(copiedModel); close all;
end

end

