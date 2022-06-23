function simdata = validation_sim_Thanassi_2016(model, figure_folder, varargin)
%%% number of maximal produced amount of Bb is calculated from Ba as follows
%%% the same mol is produced -> mol/l is the same for both
%%% use conc(Ba) and convert to amount Bb by using MW.Bb

%% input parser
p = inputParser;

% StopTime of simulation
default.StopTime = 30; % 30 min
% TimeUnits of simulation
default.TimeUnits = 'minute';
% determine whether plots should be generated and saved
default.plot_on  = 1; 
% empty data - load data if not provided as input
default.Data  = struct(); 
% logical - if fitting_on == 1, output simulated dilutions are matched to data
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
if p.Results.plot_on  == 1
    if isempty(fields(p.Results.Data))
        data = load_data_Thanassi_2016();
  else 
        data = p.Results.Data;
    end
end

%% set and define variables
MW              = get_MW();
serum_dilution  = 0.083; % 8.3% serum

N_cells = 8.3E7 * 1E3; % cells/mL to cells/L
[Surf_0, cells_uM, ~, ] = get_surface_erythrocytes(N_cells);

%%% set inital concentration to 8.3% serum
init_default    = get_ICs(model);
% set_ICs(model, init_default, serum_dilution) 
% init_new.C5_0   = get(sbioselect(model,'Type','species','Where','Name', '==', 'C5'), 'InitialAmount'); % only for plotting

%%% set num. of erythrocytes and free surface to values from experiment
% set(sbioselect(model,'Type','species','Where','Name', '==', 'Surface host'), 'InitialAmount', Surf_0); 
% set(sbioselect(model,'Type','species','Where','Name', '==', 'Erythrocytes_uM'), 'InitialAmount', cells_uM); 

model           = set_ICs(model, init_default, serum_dilution, 'Surface', Surf_0); 
init_new.C5_0   = get(sbioselect(model,'Type','species','Where','Name', '==', 'C5'), 'InitialAmount'); % only for plotting

%%% define variant without surface regulation = rabbit erythrocytes
var = [getvariant(model, 'regulators_NoDAF_var'),...
                getvariant(model, 'regulators_NoCR1_var'),...
                getvariant(model, 'regulators_NoCD59_var'),...
                getvariant(model, 'regulators_no_H_binding_var')];

            
%% Reference simulation
% normalize observed lysis to lysis from reference case 
% changes result only if here lysis != 100%
var_simdata.ref     = sbiosimulate(model, var);
plot_var            = selectbyname(var_simdata.ref, {'Percent_Lysis_Takeda', 'Percent_Lysis_Kolb', 'MAC host', 'Ba', 'C5a', 'Bb'});
REF.Lysis           = plot_var.Data(end,1:2); 


%% FD titration experiment
% FD levels to be simulated
if p.Results.fitting_on == 0
    simdata.FD.ugml     = logspace(-5, 2, 50); %ug/mL
elseif p.Results.fitting_on == 1
    simdata.FD.ugml = [0.004, 0.008, 0.016, 0.032, 0.06, 0.12, 0.24, 0.5, 1, 2];
end
simdata.FD.uM       = simdata.FD.ugml .* 1000 ./ MW.D; %uM

% Preallocate readouts
simdata.FD.Lysis    = zeros(length(simdata.FD.uM),2);
simdata.FD.MAC      = zeros(length(simdata.FD.uM),1);
simdata.FD.Ba       = zeros(length(simdata.FD.uM),1);
simdata.FD.C5a      = zeros(length(simdata.FD.uM),1);
simdata.FD.Bb       = zeros(length(simdata.FD.uM),1);

% Simulate and get readouts
for n  = 1:length(simdata.FD.uM)  
    % set D IC
    set(sbioselect(model,'Type','species','Where','Name', '==', 'D'), 'InitialAmount', simdata.FD.uM(n));
    % simulate
    var_simdata.fd  = sbiosimulate(model, var);
    % get results
    plot_var        = selectbyname(var_simdata.fd, {'Percent_Lysis_Takeda', 'Percent_Lysis_Kolb', 'MAC host', 'Ba', 'C5a', 'Bb'});
    simdata.FD.Lysis(n,1:2) = plot_var.Data(end,1:2) ./ REF.Lysis .* 100;
    simdata.FD.MAC(n)       = plot_var.Data(end,3);
    simdata.FD.Ba(n)        = plot_var.Data(end,4); 
    simdata.FD.C5a(n)       = plot_var.Data(end,5); 
    simdata.FD.Bb(n)        = plot_var.Data(end,6); 
end
% Derived readouts
simdata.FD.C5a_ugml     = simdata.FD.C5a ./1000 .* MW.C5a;
simdata.FD.Ba_ugml      = simdata.FD.Ba  ./1000 .* MW.Ba;
simdata.FD.Bb_ugml      = simdata.FD.Bb  ./1000 .* MW.Bb;
simdata.FD.Bb_ugml_max  = simdata.FD.Ba  ./1000 .* MW.Bb;

% restore initial levels to experimental values
% set_ICs(model, init_default, serum_dilution)
% set(sbioselect(model,'Type','species','Where','Name', '==', 'Surface host'), 'InitialAmount', Surf_0); 
% set(sbioselect(model,'Type','species','Where','Name', '==', 'Erythrocytes_uM'), 'InitialAmount', cells_uM); 
model = set_ICs(model, init_default, serum_dilution, 'Surface', Surf_0); 


%% FB titration experiment
% FB levels to be simulated
if p.Results.fitting_on == 0
    simdata.FB.ugml = logspace(-3, 2, 50); %ug/mL
elseif p.Results.fitting_on == 1
    simdata.FB.ugml = [0.4, 0.8, 1.6, 3.2, 6.3, 12.3, 24.5, 50, 100, 200];
end
simdata.FB.uM       = simdata.FB.ugml .* 1000 ./ MW.B; %uM

% Preallocate readouts
simdata.FB.Lysis    = zeros(length(simdata.FB.ugml),2);
simdata.FB.MAC      = zeros(length(simdata.FB.ugml),1);
simdata.FB.Ba       = zeros(length(simdata.FB.ugml),1);
simdata.FB.C5a      = zeros(length(simdata.FB.ugml),1);
simdata.FB.Bb       = zeros(length(simdata.FB.ugml),1);

% Simulate and get readouts
for n  = 1:length(simdata.FB.uM)  
    % set B IC
    set(sbioselect(model,'Type','species','Where','Name', '==', 'B'), 'InitialAmount', simdata.FB.uM(n));
    % simulate
    var_simdata.fb  = sbiosimulate(model, var);
    % get results
    plot_var        = selectbyname(var_simdata.fb, {'Percent_Lysis_Takeda', 'Percent_Lysis_Kolb', 'MAC host', 'Ba', 'C5a', 'Bb'});
    simdata.FB.Lysis(n,1:2) = plot_var.Data(end,1:2) ./ REF.Lysis .* 100;
    simdata.FB.MAC(n)       = plot_var.Data(end,3);    
    simdata.FB.Ba(n)        = plot_var.Data(end,4); 
    simdata.FB.C5a(n)       = plot_var.Data(end,5); 
    simdata.FB.Bb(n)        = plot_var.Data(end,6); 
end
% Derived readouts
simdata.FB.C5a_ugml     = simdata.FB.C5a ./1000 .* MW.C5a;
simdata.FB.Ba_ugml      = simdata.FB.Ba  ./1000 .* MW.Ba;
simdata.FB.Bb_ugml      = simdata.FB.Bb  ./1000 .* MW.Bb;
simdata.FB.Bb_ugml_max  = simdata.FB.Ba  ./1000 .* MW.Bb;

% restore initial levels to experimental values
% set_ICs(model, init_default, serum_dilution)
% set(sbioselect(model,'Type','species','Where','Name', '==', 'Surface host'), 'InitialAmount', Surf_0); 
% set(sbioselect(model,'Type','species','Where','Name', '==', 'Erythrocytes_uM'), 'InitialAmount', cells_uM); 
model = set_ICs(model, init_default, serum_dilution, 'Surface', Surf_0); 


%% C5 titration experiment
% C5 levels to be simulated
if p.Results.fitting_on == 0
    simdata.C5.ugml = logspace(-6, 2, 50); % ug/mL
elseif p.Results.fitting_on == 1
    simdata.C5.ugml = [1E-6, 1E-5, 1E-4, 1E-3, 1E-2, 1E-1, 1E0, 1E1, 1E2];
end
simdata.C5.uM           = simdata.C5.ugml .* 1000 ./ MW.C5; % uM
simdata.C5.maxC5a_uM    = simdata.C5.uM; % maximum uM of C5a that can be generated given C5 input
simdata.C5.maxC5a_ugml  = simdata.C5.maxC5a_uM ./1000 .* MW.C5a; % conversion of maximum amount to ug/mL

% Preallocate readouts
simdata.C5.Lysis    = zeros(length(simdata.C5.uM) ,2);
simdata.C5.MAC      = zeros(length(simdata.C5.uM) ,1);
simdata.C5.Ba       = zeros(length(simdata.C5.uM),1);
simdata.C5.C5a      = zeros(length(simdata.C5.uM),1);
simdata.C5.Bb       = zeros(length(simdata.C5.uM),1);

% Simulate and get readouts
for n  = 1:length(simdata.C5.uM)  
    % set C5 IC
    set(sbioselect(model,'Type','species','Where','Name', '==', 'C5'), 'InitialAmount', simdata.C5.uM(n));
    % simulate
    var_simdata.C5  = sbiosimulate(model, var);
    % get results
    plot_var        = selectbyname(var_simdata.C5, {'Percent_Lysis_Takeda', 'Percent_Lysis_Kolb', 'MAC host', 'Ba', 'C5a', 'Bb'});
    simdata.C5.Lysis(n,:)   = plot_var.Data(end,1:2) ./ REF.Lysis .* 100;
    simdata.C5.MAC(n)       = plot_var.Data(end,3);
    simdata.C5.Ba(n)        = plot_var.Data(end,4); 
    simdata.C5.C5a(n)       = plot_var.Data(end,5); 
    simdata.C5.Bb(n)        = plot_var.Data(end,6); 
end
% Derived readouts
simdata.C5.C5a_ugml     = simdata.C5.C5a ./ 1000 .* MW.C5a;
simdata.C5.Ba_ugml      = simdata.C5.Ba  ./ 1000 .* MW.Ba;
simdata.C5.Bb_ugml      = simdata.C5.Bb  ./ 1000 .* MW.Bb;
simdata.C5.Bb_ugml_max  = simdata.C5.Ba  ./ 1000 .* MW.Bb;

% restore initial levels to experimental values
model = set_ICs(model, init_default, serum_dilution, 'Surface', Surf_0); 

%% Plotting
if p.Results.plot_on == 1
    plot_validation_sim_Thanassi_2016(figure_folder, data, init_default, init_new, MW, simdata.FD, simdata.FB, simdata.C5)
end

%% restore default ICs
model = set_ICs(model, init_default, 1);
end