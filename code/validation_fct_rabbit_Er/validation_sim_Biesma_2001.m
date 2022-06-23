function simdata = validation_sim_Biesma_2001(model, figure_folder, varargin)
%%% simulation of Fig. 3 from Biesma et al., 2001. A family with complement 
%%% factor D deficiency. The Journal of Clinical Investigation
%%% Approach and assumptions:
%%% -   read-out after 60 min
%%% -   rabbit erythrocytes -> disabled surface regulation, currently same
%%%         size as human assumed
%%% -   concentration of erythrocytes in assay used unknown, influences 
%%%         model predictions


%% input parser
p = inputParser;

% StopTime of simulation
default.StopTime = 60; % 60 min
% TimeUnits of simulation
default.TimeUnits = 'minute';
% default output times
default.OutputTimes = [20, 25, 30, 60];
% determine whether plots should be generated and saved
default.plot_on  = 1; 
% empty data - load data if not provided as input
default.Data  = struct(); 

% add inputs and check validity of format
addRequired(p,  'model', @(x) strcmp(class(x), 'SimBiology.Model'));
addRequired(p,  'figure_folder', @ischar);
addParameter(p, 'StopTime', default.StopTime, @isnumeric)
addParameter(p, 'OutputTimes', default.OutputTimes, @isnumeric)
addParameter(p, 'TimeUnits', default.TimeUnits, @ischar)
addParameter(p, 'plot_on', default.plot_on, @(x) (isnumeric(x) && x == 0 || x == 1))
addParameter(p, 'Data', default.Data, @isstruct)
% addParameter(p, 'fitting_on', default.fitting_on, @(x) (isnumeric(x) && x == 0 || x == 1))

% parse results
parse(p, model, figure_folder, varargin{:})

% extract frequently used variables for ease of handling
model           = p.Results.model;
figure_folder   = p.Results.figure_folder;


%% set solver options
cs                           = getconfigset(model);
cs.StopTime                  = p.Results.StopTime;
cs.TimeUnits                 = p.Results.TimeUnits;
cs.SolverOptions.OutputTimes = p.Results.OutputTimes;


%% load data
if p.Results.plot_on  == 1
    if isempty(fields(p.Results.Data))
        data = load_data_Biesma_2001();
  else 
        data = p.Results.Data;
    end
end

%%
% cells_uM_default    = get(sbioselect(model,'Type','parameter','Where','Name', '==', 'Erythrocytes_uM'), 'InitialAmount'); 
  

%% set variables
MW                  = get_MW();
init_default        = get_ICs(model);
D0_mgL              = Molar_To_Mass_Conversion(init_default.D_0, MW.D);

D0_half_mgL         = D0_mgL/2;
D0_half_uM          = Mass_To_Molar_Conversion(D0_half_mgL, MW.D);

D0_deficient_mgL    = 0;
D0_deficient_uM     = 0;

dilutions   = [1/100 1/95 1/90 1/85 1/80 1/75 1/70 1/65 1/60 1/55 1/50, ...
                                 1/33, 1/24, 1/16, 1/12, 1/8, 1/6, 1/4, 1];
n_dilutions = length(dilutions);


%%
N_cells = 6.67E7 * 1E3; % cells/mL to cells/L (concentration according to Klerx, 1983)
    

%% calculate surface and cells_uM for given cell concentration
[Surf_0, cells_uM, ~, ] = get_surface_erythrocytes(N_cells);


%% define variant - rabbit erythrocytes
var = [getvariant(model, 'regulators_NoDAF_var'),...
                getvariant(model, 'regulators_NoCR1_var'),...
                getvariant(model, 'regulators_NoCD59_var'),...
                getvariant(model, 'regulators_no_H_binding_var')];

            
%% reference simulation - fully working regulation
% preallocate readout
simdata.ref_sim.Lysis60 = zeros(n_dilutions, 2);
simdata.ref_sim.Lysis20 = simdata.ref_sim.Lysis60;
simdata.ref_sim.Lysis25 = simdata.ref_sim.Lysis60;
simdata.ref_sim.Lysis30 = simdata.ref_sim.Lysis60;

% define IC, simulate and get readouts
for n = 1:n_dilutions
%     set_ICs(model, init_default, dilutions(n))
%     set(sbioselect(model,'Type','species','Where','Name', '==', 'Surface host'), 'InitialAmount', Surf_0); 
%     set(sbioselect(model,'Type','species','Where','Name', '==', 'Erythrocytes_uM'), 'InitialAmount', cells_uM); 
    model                   = set_ICs(model, init_default, dilutions(n), 'Surface', Surf_0); 

    simdata.ref_sim.dil(n)          = sbiosimulate(model, var);
    get_var                 = selectbyname(simdata.ref_sim.dil(n), {'Percent_Lysis_Takeda', 'Percent_Lysis_Kolb'});
    
    iT20                    = get_var.Time == 20;
    iT25                    = get_var.Time == 25;
    iT30                    = get_var.Time == 30;    
    iT60                    = get_var.Time == 60;    

    simdata.ref_sim.Lysis20(n,:)      = get_var.Data(iT20,1:2);
    simdata.ref_sim.Lysis25(n,:)      = get_var.Data(iT25,1:2);
    simdata.ref_sim.Lysis30(n,:)      = get_var.Data(iT30,1:2);
    simdata.ref_sim.Lysis60(n,:)      = get_var.Data(iT60,1:2);
end

% reset initial concentrations
% set_ICs(model, init_default, 1)
model = set_ICs(model, init_default, 1);


%% reduced/halfed D concentration
% preallocate readout
simdata.D0_half_sim.Lysis60 = zeros(n_dilutions, 2);
simdata.D0_half_sim.Lysis20 = simdata.D0_half_sim.Lysis60;
simdata.D0_half_sim.Lysis25 = simdata.D0_half_sim.Lysis60;
simdata.D0_half_sim.Lysis30 = simdata.D0_half_sim.Lysis60;

% define IC, simulate and get readouts
for n = 1:n_dilutions
%     set_ICs(model, init_default, dilutions(n))
%     set(sbioselect(model,'Type','species','Where','Name', '==', 'Surface host'), 'InitialAmount', Surf_0); 
%     set(sbioselect(model,'Type','species','Where','Name', '==', 'Erythrocytes_uM'), 'InitialAmount', cells_uM); 
%     set(sbioselect(model,'Type','species','Where','Name', '==', 'D'), 'InitialAmount', D0_half_uM * dilutions(n)); 
    model                   = set_ICs(model, init_default, dilutions(n), 'Surface', Surf_0); 
    set(sbioselect(model,'Type','species','Where','Name', '==', 'D'), 'InitialAmount', D0_half_uM * dilutions(n)); 

    simdata.D0_half_sim.dil(n)      = sbiosimulate(model, var);
    get_var                 = selectbyname(simdata.D0_half_sim.dil(n), {'Percent_Lysis_Takeda', 'Percent_Lysis_Kolb'});
    
    iT20                    = get_var.Time == 20;
    iT25                    = get_var.Time == 25;
    iT30                    = get_var.Time == 30;    
    iT60                    = get_var.Time == 60;    
    
    simdata.D0_half_sim.Lysis20(n,:)      = get_var.Data(iT20,1:2);
    simdata.D0_half_sim.Lysis25(n,:)    = get_var.Data(iT25,1:2);
    simdata.D0_half_sim.Lysis30(n,:)    = get_var.Data(iT30,1:2);
    simdata.D0_half_sim.Lysis60(n,:)    = get_var.Data(iT60,1:2);
end

% reset initial concentrations
% set_ICs(model, init_default, 1)
model = set_ICs(model, init_default, 1);


%% D deficient
% preallocate readout
simdata.D0_def_sim.Lysis60 = zeros(n_dilutions, 2);
simdata.D0_def_sim.Lysis20 = simdata.D0_def_sim.Lysis60;
simdata.D0_def_sim.Lysis25 = simdata.D0_def_sim.Lysis60;
simdata.D0_def_sim.Lysis30 = simdata.D0_def_sim.Lysis60;

% define IC, simulate and get readouts
for n = 1:n_dilutions
%     set_ICs(model, init_default, dilutions(n))
%     set(sbioselect(model,'Type','species','Where','Name', '==', 'Surface host'), 'InitialAmount', Surf_0); 
%     set(sbioselect(model,'Type','species','Where','Name', '==', 'Erythrocytes_uM'), 'InitialAmount', cells_uM); 
%     set(sbioselect(model,'Type','species','Where','Name', '==', 'D'), 'InitialAmount', D0_deficient_uM); 
    model                   = set_ICs(model, init_default, dilutions(n), 'Surface', Surf_0); 
    set(sbioselect(model,'Type','species','Where','Name', '==', 'D'), 'InitialAmount', D0_deficient_uM); 

    simdata.D0_def_sim.dil(n)       = sbiosimulate(model, var);
    get_var                 = selectbyname(simdata.D0_def_sim.dil(n), {'Percent_Lysis_Takeda', 'Percent_Lysis_Kolb'});
    
    iT20                    = get_var.Time == 20;
    iT25                    = get_var.Time == 25;
    iT30                    = get_var.Time == 30;    
    iT60                    = get_var.Time == 60;    
    
    simdata.D0_def_sim.Lysis20(n,:) = get_var.Data(iT20,1:2);
    simdata.D0_def_sim.Lysis25(n,:) = get_var.Data(iT25,1:2);
    simdata.D0_def_sim.Lysis30(n,:) = get_var.Data(iT30,1:2);
    simdata.D0_def_sim.Lysis60(n,:) = get_var.Data(iT60,1:2);
end

% reset initial concentrations
% set_ICs(model, init_default, 1)
model = set_ICs(model, init_default, 1);


%% restoration with Factor D
D0_restoration_mgl          = [0.0001 0.00025 0.0005 0.00075 0.001 0.01 0.1 0.25 0.5 1 2 4];
D0_restoration_uM           = Mass_To_Molar_Conversion(D0_restoration_mgl, MW.D);

% preallocate readout
simdata.D0_restoration_sim.Lysis60    = zeros(length(D0_restoration_uM), 2);
simdata.D0_restoration_sim.Lysis20    = simdata.D0_restoration_sim.Lysis60;
simdata.D0_restoration_sim.Lysis25    = simdata.D0_restoration_sim.Lysis60;
simdata.D0_restoration_sim.Lysis30    = simdata.D0_restoration_sim.Lysis60;

% define IC, simulate and get readouts
for n = 1:length(D0_restoration_uM)
%     set_ICs(model, init_default, 1)
%     set(sbioselect(model,'Type','species','Where','Name', '==', 'Surface host'), 'InitialAmount', Surf_0); 
%     set(sbioselect(model,'Type','species','Where','Name', '==', 'Erythrocytes_uM'), 'InitialAmount', cells_uM); 
%     set(sbioselect(model,'Type','species','Where','Name', '==', 'D'), 'InitialAmount', D0_restoration_uM(n));
    model                   = set_ICs(model, init_default, 1, 'Surface', Surf_0); 
    set(sbioselect(model,'Type','species','Where','Name', '==', 'D'), 'InitialAmount', D0_restoration_uM(n));

    simdata.D0_restoration_sim.restoration(n)   = sbiosimulate(model, var);
    get_var                             = selectbyname(simdata.D0_restoration_sim.restoration(n), {'Percent_Lysis_Takeda', 'Percent_Lysis_Kolb'});
    
    iT20                    = get_var.Time == 20;
    iT25                    = get_var.Time == 25;
    iT30                    = get_var.Time == 30;    
    iT60                    = get_var.Time == 60;  
    
    simdata.D0_restoration_sim.Lysis20(n,:) = get_var.Data(iT20,1:2);
    simdata.D0_restoration_sim.Lysis25(n,:) = get_var.Data(iT25,1:2);
    simdata.D0_restoration_sim.Lysis30(n,:) = get_var.Data(iT30,1:2);
    simdata.D0_restoration_sim.Lysis60(n,:) = get_var.Data(iT60,1:2);
end

% reset initial concentrations
% set_ICs(model, init_default, 1)
model = set_ICs(model, init_default, 1);


%% Plotting
if p.Results.plot_on == 1
    %%% plot 60 min data - readout time according to manuscript
    ref_sim.Lysis            = simdata.ref_sim.Lysis60;
    D0_half_sim.Lysis        = simdata.D0_half_sim.Lysis60;
    D0_def_sim.Lysis         = simdata.D0_def_sim.Lysis60;
    D0_restoration_sim.Lysis = simdata.D0_restoration_sim.Lysis60;

    plot_validation_sim_Biesma_2001(data, figure_folder, N_cells,...
                    dilutions, ref_sim, D0_half_sim, D0_def_sim, ...
                    D0_restoration_mgl, D0_restoration_sim, D0_mgL, '60min')
    clearvars ref_sim.Lysis D0_half_sim.Lysis D0_def_sim.Lysis D0_restoration_sim.Lysis

    %%% plot 20 min data
    ref_sim.Lysis            = simdata.ref_sim.Lysis20;
    D0_half_sim.Lysis        = simdata.D0_half_sim.Lysis20;
    D0_def_sim.Lysis         = simdata.D0_def_sim.Lysis20;
    D0_restoration_sim.Lysis = simdata.D0_restoration_sim.Lysis20;

    plot_validation_sim_Biesma_2001(data, figure_folder, N_cells,...
                    dilutions, ref_sim, D0_half_sim, D0_def_sim, ...
                    D0_restoration_mgl, D0_restoration_sim, D0_mgL, '20min')
    clearvars ref_sim.Lysis D0_half_sim.Lysis D0_def_sim.Lysis D0_restoration_sim.Lysis

    %%% plot 25 min data
    ref_sim.Lysis            = simdata.ref_sim.Lysis25;
    D0_half_sim.Lysis        = simdata.D0_half_sim.Lysis25;
    D0_def_sim.Lysis         = simdata.D0_def_sim.Lysis25;
    D0_restoration_sim.Lysis = simdata.D0_restoration_sim.Lysis25;

    plot_validation_sim_Biesma_2001(data, figure_folder, N_cells,...
                    dilutions, ref_sim, D0_half_sim, D0_def_sim, ...
                    D0_restoration_mgl, D0_restoration_sim, D0_mgL, '25min')
    clearvars ref_sim.Lysis D0_half_sim.Lysis D0_def_sim.Lysis D0_restoration_sim.Lysis

    %%% plot 30 min data
    ref_sim.Lysis            = simdata.ref_sim.Lysis30;
    D0_half_sim.Lysis        = simdata.D0_half_sim.Lysis30;
    D0_def_sim.Lysis         = simdata.D0_def_sim.Lysis30;
    D0_restoration_sim.Lysis = simdata.D0_restoration_sim.Lysis30;

    plot_validation_sim_Biesma_2001(data, figure_folder, N_cells,...
                    dilutions, ref_sim, D0_half_sim, D0_def_sim, ...
                    D0_restoration_mgl, D0_restoration_sim, D0_mgL, '30min')
    clearvars ref_sim.Lysis D0_half_sim.Lysis D0_def_sim.Lysis D0_restoration_sim.Lysis
end

%% restore default initial concentrations
% set_ICs(model, init_default, 1)
model                        = set_ICs(model, init_default, 1);
cs.SolverOptions.OutputTimes = [];
end

function mgL = Molar_To_Mass_Conversion(uMol, MW)
% convert concentrations from mg/L to uM
   mgL =  uMol .* MW ./ 1000;
end

function uMol = Mass_To_Molar_Conversion(mgL, MW)
% convert concentrations from uM to mg/L
    uMol = mgL .* 1000 ./ MW;
end