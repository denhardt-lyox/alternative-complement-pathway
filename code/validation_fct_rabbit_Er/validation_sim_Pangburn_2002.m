function simdata = validation_sim_Pangburn_2002(model, figure_folder, varargin)
%%% simulation of Pangburn 2002
%%% simulate only rabbit erythrocyte lysis
%%% combine all rabbit data into one plot assuming complete FH surface
%%% inhibition in all cases


%% input parser
p = inputParser;

% StopTime of simulation
default.StopTime = 20;
% TimeUnits of simulation
default.TimeUnits = 'minute';
% determine whether plots should be generated and saved
default.plot_on  = 1; 
% empty data - load data if not provided as input
default.Data  = struct(); 
% logical - if fitting_on == 1, simulated dilutions are matched to data
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


%%
cs           = getconfigset(model);
cs.StopTime  = p.Results.StopTime;
cs.TimeUnits = p.Results.TimeUnits;


%% load data
if p.Results.plot_on == 1
    if isempty(fields(p.Results.Data))
        data = load_data_Pangburn_2002();
    else
        data = p.Results.Data;
    end
end

%% set and define variables
init_default    = get_ICs(model);

%%% number of cells, calculated from manuscript as follows:
% 1E7 cells/50 uL
% 2E5 cells/uL
% 2E11 cells/L
[Surf_0, ~, ~, ~] = get_surface_erythrocytes(2E11);

% define variant w/o surface regulation - rabbit erythrocytes
var =  [getvariant(model, 'regulators_NoDAF_var'),...
        getvariant(model, 'regulators_NoCR1_var'),...
        getvariant(model, 'regulators_NoCD59_var'),...
        getvariant(model, 'regulators_no_H_binding_var')];
            
            
%% simulate different dilutions
% dilutions in percent to be simulated
if p.Results.fitting_on     == 0
    dilutions = 0:1:50;    
elseif p.Results.fitting_on == 1
    dilutions = 0:5:50;
end

% Preallocate readouts
simdata.lysis    = zeros(length(dilutions),2);
simdata.dilution = zeros(length(dilutions),1);

%
for n = 1:length(dilutions)
    % set initial conditions for dilution and surface
    model = set_ICs(model, init_default, dilutions(n)/100, 'Surface', Surf_0);

    % simulate
    var_simdata.fd      = sbiosimulate(model, var);
    
    % get and store results
    plot_var            = selectbyname(var_simdata.fd, {'Percent_Lysis_Takeda', 'Percent_Lysis_Kolb', 'MAC host', 'Ba', 'C5a', 'Bb'});
    simdata.dilution(n)     = dilutions(n);
    simdata.lysis(n,1:2)    = plot_var.Data(end,1:2);
    
    % reset initial conditions (not mandatory as resetted in next iteration)
    model = set_ICs(model, init_default, 1);
end
            
            
%% plotting
if p.Results.plot_on == 1
    plot_validation_sim_Pangburn_2002(figure_folder, data, simdata)
end

%% restore default ICs
set_ICs(model, init_default, 1);
end