function simdata = validation_sim_Schreiber_1978(model, figure_folder, varargin)
%%% simulation of Schreiber 1978

%% input parser
p = inputParser;

% StopTime of simulation
default.StopTime = 10;
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
        data = load_data_Schreiber_1978();
    else
        data = p.Results.Data;
    end
end

if p.Results.fitting_on == 1 && ~isempty(fields(p.Results.Data))
    data = p.Results.Data;
end

%% Molecular weight
MW = get_MW;

%% set and define variables
init_default    = get_ICs(model);

%%% number of cells, calculated from manuscript as follows:
% 1E7 cells/160 uL
% 62500 cells/uL
% 6.25E10 cells/L
[Surf_0, ~, ~, ~] = get_surface_erythrocytes(6.25E10);

% define variant w/o surface regulation - rabbit erythrocytes
var =  [getvariant(model, 'regulators_NoDAF_var'),...
        getvariant(model, 'regulators_NoCR1_var'),...
        getvariant(model, 'regulators_NoCD59_var'),...
        getvariant(model, 'regulators_no_H_binding_var')];
            
            
%% simulate NHS or complement protein mix dilution
% dilutions to be simulated
if p.Results.fitting_on     == 0
    dilutions = 0:0.05:0.3;
elseif p.Results.fitting_on == 1
    dilutions = data.Schreiber.Fig_2.Dilution;    
    dilutions = dilutions(1:2:end);
end

% Preallocate readouts
simdata.Fig2.dilution         = zeros(length(dilutions),1);
simdata.Fig2.lysis_Serum      = zeros(length(dilutions),2);
simdata.Fig2.lysis_Components = zeros(length(dilutions),2);

% dilution of serum
for n = 1:length(dilutions)
    % set initial conditions for dilution and surface
    model = set_ICs(model, init_default, dilutions(n), 'Surface', Surf_0);

    % simulate
    var_simdata_temp      = sbiosimulate(model, var);
    
    % get and store results
    plot_var                        = selectbyname(var_simdata_temp, {'Percent_Lysis_Takeda', 'Percent_Lysis_Kolb'});
    simdata.Fig2.dilution(n)        = dilutions(n);
    simdata.Fig2.lysis_Serum(n,1:2) = plot_var.Data(end,1:2);
    
    % generate complement mix
    model = set_ICs(model, init_default, 0, 'Surface', Surf_0);
    model = generate_complement_mix(model, MW, dilutions(n));

    % simulate
    var_simdata_temp      = sbiosimulate(model, var);
        
    % get and store results
    plot_var                             = selectbyname(var_simdata_temp, {'Percent_Lysis_Takeda', 'Percent_Lysis_Kolb'});
    simdata.Fig2.lysis_Components(n,1:2) = plot_var.Data(end,1:2);
    
    % reset initial conditions (not mandatory as resetted in next iteration)
    model = set_ICs(model, init_default, 1);
end
            

%% simulate complement protein mix dilution with and without Properdin
% dilutions to be simulated
if p.Results.fitting_on     == 0
    dilutions = 0:0.05:0.8;
elseif p.Results.fitting_on == 1
    dilutions = data.Schreiber.Fig_3.Dilution;    
    dilutions = dilutions(1:2:end);
end

% Preallocate readouts
simdata.Fig3.dilution     = zeros(length(dilutions),1);
simdata.Fig3.lysis_with_P = zeros(length(dilutions),2);
simdata.Fig3.lysis_w0_P   = zeros(length(dilutions),2);

% dilution of serum
for n = 1:length(dilutions)
    % generate complement mix
%     model = set_ICs(model, init_default, dilutions(n), 'Surface', Surf_0);
    model = set_ICs(model, init_default, 0, 'Surface', Surf_0);
    model = generate_complement_mix(model, MW, dilutions(n));
    
    % simulate
    var_simdata_temp      = sbiosimulate(model, var);
        
    % get and store results
    plot_var                         = selectbyname(var_simdata_temp, {'Percent_Lysis_Takeda', 'Percent_Lysis_Kolb'});
    simdata.Fig3.dilution(n)         = dilutions(n);
    simdata.Fig3.lysis_with_P(n,1:2) = plot_var.Data(end,1:2);
    
    % remove Properdin
    set(sbioselect(model,'Type','species','Where','Name', '==', 'P'), 'InitialAmount', 0);
    
    % simulate
    var_simdata_temp      = sbiosimulate(model, var);
    
    % get and store results
    plot_var                       = selectbyname(var_simdata_temp, {'Percent_Lysis_Takeda', 'Percent_Lysis_Kolb'});
    simdata.Fig3.lysis_w0_P(n,1:2) = plot_var.Data(end,1:2);
end
            
%% plotting
if p.Results.plot_on == 1
    plot_validation_sim_Schreiber_1978(figure_folder, data, simdata)
end

%% restore default ICs
set_ICs(model, init_default, 1);
end

function model = generate_complement_mix(model, MW, dil)
    set(sbioselect(model,'Type','species','Where','Name', '==', 'C3'), 'InitialAmount', 1200 * 1000 / MW.C3 * dil);
    set(sbioselect(model,'Type','species','Where','Name', '==', 'B'), 'InitialAmount', 200 * 1000 / MW.B * dil);
    set(sbioselect(model,'Type','species','Where','Name', '==', 'D'), 'InitialAmount', 2 * 1000 / MW.D * dil);
    set(sbioselect(model,'Type','species','Where','Name', '==', 'H'), 'InitialAmount', 470 * 1000 / MW.H * dil);
    set(sbioselect(model,'Type','species','Where','Name', '==', 'I'), 'InitialAmount', 34 * 1000 / MW.I * dil);
    set(sbioselect(model,'Type','species','Where','Name', '==', 'P'), 'InitialAmount', 20 * 1000 / MW.P * dil);
    set(sbioselect(model,'Type','species','Where','Name', '==', 'C5'), 'InitialAmount', 72 * 1000 / MW.C5 * dil);
    set(sbioselect(model,'Type','species','Where','Name', '==', 'C6'), 'InitialAmount', 64 * 1000 / MW.C6 * dil);
    set(sbioselect(model,'Type','species','Where','Name', '==', 'C7'), 'InitialAmount', 54 * 1000 / MW.C7 * dil);
    set(sbioselect(model,'Type','species','Where','Name', '==', 'C8'), 'InitialAmount', 54 * 1000 / MW.C8 * dil);
    set(sbioselect(model,'Type','species','Where','Name', '==', 'C9'), 'InitialAmount', 58 * 1000 / MW.C9 * dil);
end