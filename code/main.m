% Main driver file, options currently set to reproduce publication figures

%% add paths
restoredefaultpath
clear all
close all

sbioreset

addpath(genpath('aux_fct'));
addpath('aux_matlab_fct');
addpath('fit_takeda');
addpath('inhibition_fct');
addpath('inhibition_aux_fct');
addpath('scenario_fct');
addpath('MODEL_DEFINITION');
addpath('hemolysis-fct');
addpath('validation_fct_cell_free');
addpath('validation_fct_human_Er');
addpath('validation_fct_rabbit_Er');
addpath('steadystate_aux_fct');
addpath('steadystate_fct_parameter-estimation');
addpath('steadystate_fct_cell-turnover');
addpath('steadystate_sim_fct');

addpath('parameter_estimation_fct');


%% define which simulations to run

%%% Parameter estimation + control simulations for in-vitro model
run.parameter_estimation_fct    = 0;

%%% validation experiments with and w/o cells
run.sim_val_cellFreeAssays      = 1; %1
run.sim_val_cellBasedAssays     = 1; %1

%%% drug interventions
run.sim_intervention            = 1; %1;

%%% In-vivo (= steady-state) model
% estimation of production terms
  run.sim_ss_prodTerms          = 0; 
% implementation of cell turnover
  run.sim_ss_cellTurnover       = 1; %1 
% Plotting of healthy conditions
  run.sim_ss_healthy            = 1; %1
% PNH + treatment
  run.sim_ss_PK                 = 1; %1

% fit Takeda data, MAC vs hemolysis %
run.fit_takeda                  = 1;

%%% Define which parameter set to use - select one of them
select_fit.fit_manual                            = 0;
select_fit.fit_auto_Man_Selection                = 0;
select_fit.fit_auto_Auto_Selection_Wo_Thanassi   = 1; %1
select_fit.fit_auto_Auto_Selection_With_Thanassi = 0;

%% set up of model
%%% C5 CONVERTASE
% Implemention of the C5 convertase function (Equation 28 (59)
% C5_concvertase_original = 1; % mass-action
C5_concvertase_original = 0; % michaelis-menten  

% sbioshowunits
% simbiology(model)
% Initialize model
model = sbiomodel('acp_model');

%%% COMPARTMENT
% Define compartment properties
% retina = addcompartment(model, 'Retina', 0.1, 'CapacityUnits', 'microliter');
%model.Compartments.Name = 'testTube';
%model.Compartments.CapacityUnits = 'microliter';    
retina = addcompartment(model, 'Retina', 3, 'CapacityUnits', 'liter');


%% ERYTHROCYTE PROPERTIES
% define erythrocyte properties and calculate initial conditions
N_cells         = 5*10^12;              % Erythrocyte in blood  (cells/L), Zewde
r_erythrocyte   = 3.4*10^-6;            % Erythrocyte radius in meter                 
[Surface_0, cells_uM_0, C3b_bindingSites_uM, MAC_bindingSites_uM] = get_surface_erythrocytes(N_cells, r_erythrocyte);

%% Initial conditions and assignment to simbiology species
% Original Zewde baseline values in uM

%%% Fluid phase
init.C3_0        =  5.4;
init.C5_0        =  0.37; 
init.C6_0        =  0.5;
init.C7_0        =  0.5;
init.C8_0        =  0.36;
init.C9_0        =  0.9;

init.B_0         =  2.2;
init.D_0         =  0.083;
init.I_0         =  0.4;

init.Properdin_0 =  0.47;
init.H_0         =  3.2;
init.Vn_0        =  6;
init.Cn_0        =  0.43;

%%% Surface
init.CR1_0       =  0.0083;
init.DAF_0       =  0.027;
init.CD59_0      =  0.21;
init.Surface_0   =  Surface_0; %C3b_bindingSites_uM;

%%% H2O
init.H2O_0       =  0; %(1e6) * 55.55;

% Species. All units in uM
C3        = addspecies(model, 'C3', 'InitialAmount',        init.C3_0);
C5        = addspecies(model, 'C5', 'InitialAmount',        init.C5_0);
C6        = addspecies(model, 'C6', 'InitialAmount',        init.C6_0);
C7        = addspecies(model, 'C7', 'InitialAmount',        init.C7_0);
C8        = addspecies(model, 'C8', 'InitialAmount',        init.C8_0);
C9        = addspecies(model, 'C9', 'InitialAmount',        init.C9_0);

B         = addspecies(model, 'B', 'InitialAmount',         init. B_0);
D         = addspecies(model, 'D', 'InitialAmount',         init.D_0);
I         = addspecies(model, 'I', 'InitialAmount',         init.I_0);
P         = addspecies(model, 'P', 'InitialAmount',         init.Properdin_0);
H         = addspecies(model, 'H', 'InitialAmount',         init.H_0);
CR1       = addspecies(model, 'CR1','InitialAmount',        init.CR1_0);
DAF       = addspecies(model, 'DAF','InitialAmount',        init.DAF_0);
Vn        = addspecies(model, 'Vn','InitialAmount',         init.Vn_0);
Cn        = addspecies(model, 'Cn','InitialAmount',         init.Cn_0);
CD59      = addspecies(model, 'CD59','InitialAmount',       init.CD59_0);
Surface   = addspecies(model, 'Surface host','InitialAmount', init.Surface_0);
H2O       = addspecies(model, 'H2O','InitialAmount',        init.H2O_0);

drug      = addspecies(model, 'drug','InitialAmount',       0);


%% Model definition
%%% Parameters
REACTION_PARAMETER(model, C5_concvertase_original) % basic parameters
REACTION_PARAMETER_EXT(model) % added parameters

%%% Parameter Updates!!!
REACTION_PARAMETER_UPDATES_ZEWDE2018(model) % updates to parameters based on Zewde 2018
%%% Fitted parameters
REACTION_PARAMETER_UPDATES_FITTING(model,select_fit)   % updates to parameters to fit observations/validations

if run.parameter_estimation_fct
    parameter_list = get(model, 'Parameters');
end
TURNOVER_PARAMETER(model)                          % turnover parameters (prod. & elimination)

% parameter_list = get(model, 'Parameters');


%%% Derived parameters
addparameter(model, 'cells_uM', NaN,...
                    'notes','Concentrations of cells with ACP active surface',... 
                    'ValueUnits', 'micromolarity');
                           
addparameter(model, 'Surface_per_cell', Surface_0/cells_uM_0,...
                    'notes','Concentrations of cells with ACP active surface at t = 0',... 
                    'ValueUnits', 'dimensionless');
                
% Derived parameters
addparameter(model, 'DAF_per_Surface', init.DAF_0 / init.Surface_0,...
                    'notes','DAF per cell',... 
                    'ValueUnits', 'dimensionless');
                
addparameter(model, 'CR1_per_Surface', init.CR1_0 / init.Surface_0,...
                    'notes','CR1 per cell',... 
                    'ValueUnits', 'dimensionless');
                
addparameter(model, 'CD59_per_Surface', init.CD59_0 / init.Surface_0,...
                    'notes','CD59 per cell',... 
                    'ValueUnits', 'dimensionless');



%%% Derived parameters
DERIVED_PARAMETER(model) % derived parameters that need to be calculated  

%%% Equations
REACTION_EQUATIONS(model, C5_concvertase_original) % basic reactions
REACTION_EQUATIONS_EXT(model)                      % reaction equations added based on Zewde 2018
% REACTION_EQUATIONS_MOCK_SPECIES(model)             % reaction equations that produce mock species for readout only
TURNOVER_EQUATIONS(model)                          % turnover reactions  (prod. & elimination)

%%% Drug equations
DRUG_PARAMETER_EQUATION(model)  % drug equations and corresponding parameters


%% Define and add simulation scenarios
% Define and add simulation scenarios to the model
[model] = define_scenarios(model);

% Define and add simulation scenarios with turnover to the model
[model] = define_scenarios_turnover(model);

% Add genetic variants
[factorB_R32Q_var, factorH_R1210C_var, factorH_I62V_var] = define_genetic_variants(model);


%% UNIT Definition
% Need to define units of all implicit defined species 
% This command will set the units of ALL species
set(model.Species,  'InitialAmountUnits', 'micromolarity');

% Model ANALYSIS
% Determine conserved moieties
% sbioconsmoiety(model, 'semipos', 'p')
unused_species  = findUnusedComponents(model);
unitlessObjects = sbioselect(model, '*Units', '');


%% Some more defintions
% Model Documentation
model_documentation(model)

% Determine production rates for steady state
%get_steady_state_production_rates(model)

% Export to SBML
xml.file = '../ModelStructure/acp_model.xml';
sbmlexport(model, xml.file);


%% set solver options
cs                                     = getconfigset(model);
cs.CompileOptions.UnitConversion       = true;
cs.SolverType                          = 'ode15s'; % stiff solver
cs.SolverOptions.AbsoluteTolerance     = 1e-18;
cs.SolverOptions.SensitivityAnalysis   = false;


%% paramter estimation / parameter sampling
if run.parameter_estimation_fct
    %%% User defined options for function
    Fit.Thanassi = 0;

    %%% Run iterative parameter estimation (one parameter at a time)?
    Run.IterEst.Fminbnd    = 0; %1
    Run.IterEst.Fminsearch = 0;   
    %%% Run parallel estimation of multiple parmeters?
    Run.ParallelEst.PSO    = 0;
    Run.ParallelEst.SA     = 1;
    %%% Run Simulations without fitting
    Run.SimPlot            = 0; %1
    %%% Run sensitvity analysis
    Run.SensitivityAnalysis  = 0; %1
    
    %%% QC that passed arguments are correct
    if (sum(Run.SimPlot + Run.IterEst.Fminbnd + Run.IterEst.Fminsearch + ...
           Run.ParallelEst.PSO + Run.SensitivityAnalysis + Run.ParallelEst.SA) == 0)
        msg = ['You must select exactly one of the options when running ',... 
              '"parameter_estimation_fct"'];
        error(msg)
    elseif (sum(Run.SimPlot + Run.IterEst.Fminbnd + Run.IterEst.Fminsearch + ...
               Run.ParallelEst.PSO + Run.SensitivityAnalysis + Run.ParallelEst.SA) > 1)
        msg = ['You must NOT select more than one(1!) of the options ',...
              'when running "parameter_estimation_fct"'];
        error(msg)
    end
    
    %%%% Run selected option
    if Run.IterEst.Fminbnd == 1 || Run.IterEst.Fminsearch == 1
        %%% User input required for running iterative parameter estimation
%         prompt     = 'Give starting index for looping over parameters: ';
%         loop_start = input(prompt); 
%         prompt     = ['Give ending index for looping over parameters ',...
%                      '(length of parameter list: ', num2str(length(parameter_list)), '): '];
%         loop_end   = input(prompt); 

%         loop_start = 1;
%         loop_end   = 9;
        
        copiedModel = copyobj(model);
        parameter_estimation_fct(copiedModel, Run, 'ParList', parameter_list, ...
                                'loop_start', loop_start, 'loop_end', loop_end, ...
                                'Fit_Thanassi', Fit.Thanassi)
        delete(copiedModel)
    elseif Run.ParallelEst.PSO == 1 || Run.SimPlot == 1
        %%% if Run.SimPlot or Run.ParallelEst.PSO
        copiedModel = copyobj(model);
        parameter_estimation_fct(copiedModel, Run, 'Fit_Thanassi', Fit.Thanassi)
        delete(copiedModel)
        
    elseif Run.ParallelEst.SA == 1 
        %%% if Run.SimPlot or Run.ParallelEst.PSO
        copiedModel = copyobj(model);
        parameter_estimation_fct(copiedModel, Run, 'Fit_Thanassi', Fit.Thanassi, 'ParList', parameter_list)
        delete(copiedModel)
        

    elseif Run.SensitivityAnalysis == 1
        
        
        data = load_data_Ferreira_2007([]);
        data = load_data_Lesher_2013(data);
        data = load_data_Wilcox_1991(data);
        data = load_data_Pangburn_2002(data);
        data = load_data_Wu_2018(data);
        data = load_data_Thanassi_2016(data);
        data = load_data_Biesma_2001(data);
        data = load_data_Schreiber_1978(data);
        data = load_data_Lesavre_1978(data);


        model_saved  = copyobj(model);
        model_name   = "Roche-ACP_temporary_model_for_sensitivity.sbproj";
        sbiosaveproject(model_name, 'model_saved')
        
        save('parameter_list_temp.mat','parameter_list')
        
        jmax = 6;
        obj_value_incr = nan(length(parameter_list),jmax);
        obj_value_decr = nan(length(parameter_list),jmax);
        
        for  j = 1:jmax
            if j == 1
                sensitvity_factor = 0.01;
            elseif j == 2
                sensitvity_factor = 0.05;
            elseif j == 3 
                sensitvity_factor = 0.10;
            elseif j == 4
                sensitvity_factor = 0.20;
            elseif j == 5
                sensitvity_factor = 0.50;
            elseif j == 6
                sensitvity_factor = 0.99;
            else
                error('error in sensitvitiy analysis')
            end
            
            for iter = 1:length(parameter_list)
                if(j == 1 && iter == 1)
                    load('parameter_list_temp.mat')
                    sbioloadproject(model_name);
                    copiedModel = copyobj(model_saved);
                    obj_value_default = parameter_estimation_fct(copiedModel, Run, 'Fit_Thanassi', Fit.Thanassi);
                end               
                disp([num2str(j), ' - ', num2str(iter)])

                load('parameter_list_temp.mat')
                sbioloadproject(model_name);
                copiedModel = copyobj(model_saved);
                set(sbioselect(copiedModel,'Type','parameter','Where','Name', '==', parameter_list(iter).Name),  'Value',parameter_list(iter).Value * (1 + sensitvity_factor));
                obj_value_incr(iter,j) = parameter_estimation_fct(copiedModel, Run, 'Fit_Thanassi', Fit.Thanassi, 'Data', data);

                load('parameter_list_temp.mat')
                sbioloadproject(model_name);
                copiedModel = copyobj(model_saved);
                set(sbioselect(copiedModel,'Type','parameter','Where','Name', '==', parameter_list(iter).Name),  'Value',parameter_list(iter).Value * (1 - sensitvity_factor));
                obj_value_decr(iter,j) = parameter_estimation_fct(copiedModel, Run, 'Fit_Thanassi', Fit.Thanassi, 'Data', data);

            end
        end
        
         save('Obj_value_sensitivity_analysis_obj_value_default.mat','obj_value_default')
         save('Obj_value_sensitivity_analysis_obj_value_incr.mat','obj_value_incr')
         save('Obj_value_sensitivity_analysis_obj_value_decr.mat','obj_value_decr')

         load('parameter_list_temp.mat')

         obj_value_matrix = [flip(obj_value_decr,2), obj_value_incr];
%         figure()
%         hold on
%         plot(1:68, obj_value_sens(:,1), '*r')
%         plot(1:68, obj_value_sens(:,2), '*b')
%         plot([1 68], [obj_value_default, obj_value_default], '-k')
        
        names = cell(length(parameter_list),1);
        for i = 1:length(parameter_list)
        names{i} = parameter_list(i).Name;
        end
        
        h = figure;
        hold on
        b = bar(100/obj_value_default * obj_value_matrix(:,3:10)-100);

        b(1).FaceColor = [0.0    0.0    0.4];
        b(2).FaceColor = [0.0    0.0    0.7];
        b(3).FaceColor = [0.0    0.0    0.9];
        b(4).FaceColor = [0.0    0.0    1];
        b(5).FaceColor = [1      0.0    0.0];
        b(6).FaceColor = [0.9    0.0    0.0];
        b(7).FaceColor = [0.7    0.0    0.0];
        b(8).FaceColor = [0.4    0.0    0.0];
        
        xticks(1:length(parameter_list))
        xticklabels(names)
        xtickangle(45)
        set(gca,'TickLabelInterpreter','none')
        grid on
        box on
        set(gcf, 'Units', 'Normalized', 'OuterPosition', [0, 0.3, 0.99, 0.5]);
        ylabel('% change of SSRsum', 'FontSize', 20)
        set(gca, 'FontSize', 12)
        
        figure_folder = '../Figures/Figures_SensitivityAnalysis/';
        mkdir(figure_folder)
        print(h,[figure_folder, 'SensitivityAnalysis_ObjValue.png'],'-dpng','-r600');
%         saveas(h, [figure_folder, 'SensitivityAnalysis_ObjValue.png'], 'png')
    end
end


%% Simulate validation experiments - cell free assays
if run.sim_val_cellFreeAssays
    copiedModel = copyobj(model);
    sim_val_cellFreeAssays(copiedModel)
    delete(copiedModel)
end


%% Simulate validation experiments - with rabbit and human erythrocytes
if run.sim_val_cellBasedAssays  
    copiedModel = copyobj(model);
    sim_val_cellBasedAssays(copiedModel)
    delete(copiedModel)
end


%% Simulate with intervention - in-vitro model, lysis of rabbit RBC as a 
%  function of exisiting inhibitors such as Eculizumab, or of potential
%  inhibitors
if run.sim_intervention  
    copiedModel = copyobj(model);
    sim_intervention_driver(copiedModel)
    delete(copiedModel)
end


%% steady state simulations - fit(ted) production terms
% ESTIMATION of production terms & 1st try of PK simulations
if run.sim_ss_prodTerms 
    copiedModel = copyobj(model);
    production_rates = sim_ss_production_Terms_estimation_driver(copiedModel);
    delete(copiedModel)
else
    production_rates = readtable(['../Tables/',...
        'Production-Rates-Estimation_Full-Model_turnover-var-with-surface-turnover_15-Jul-2019.csv'],...
        'ReadVariableNames',true,...
        'ReadRowNames',     true);                 
end

% get fractional synthetic rates
[FSR, rate_mg_kg_day] = get_FSR(model, production_rates);

% define PNH variants
fold_red_PNH_Type2 = 10;
fold_red_PNH_Mix   = 13.75; %20; 300
model = define_PNH_variants(model, fold_red_PNH_Type2, fold_red_PNH_Mix);

% Implementation and analysis of cell turnover as a function of hemolysis
if run.sim_ss_cellTurnover 
    Plot_On = 0;
    copiedModel = copyobj(model);
    cell_turnover_simulations(copiedModel, production_rates,...
        'Plot_On', Plot_On) 
    delete(copiedModel)
end

% steady state model in healthy indivdual (for plotting only)
if run.sim_ss_healthy
    copiedModel = copyobj(model);
    sim_ss_healthy(copiedModel, production_rates) 
    delete(copiedModel)
end

% PK simulations
if run.sim_ss_PK    
    copiedModel = copyobj(model);
    PK_fct(copiedModel, production_rates) 
    delete(copiedModel)    
end

% Fit and plot Takeda. MAC/cell vs Hemolysis
if run.fit_takeda    
    fit_takeda()
end