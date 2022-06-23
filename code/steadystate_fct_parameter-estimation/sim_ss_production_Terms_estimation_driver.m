function x = sim_ss_production_Terms_estimation_driver(model)
% parmeter (production rates) estimation for steady state version of ACP model
% 
% includes degradation of ACP species as defined in turnover_var
% (define_scenarios_turnover.m)
% estimation rates are either estimated one by one (while the non-fitted
% species are kept automatically constant) or all at the same time
% 
% 
% 
% only the complete model is implemented 
% for older version with submodel implementations (only tick-over, only
% fluid phase) see subfolder "v1.35-and-previous" in same directory
% 
% a few control cases are simulated after the paramter estimation

%%% inputs:
% model - SimBiology model, pass only a copy of the model! model gets
%         changed
% 
%%% outputs:
% none  - parameter estimates are stored in csv file



%% make and define figure folders for outputs
figure_folder_estimation = '../Figures/Figures_steadystate-model_Estimation-production-terms/';
mkdir(figure_folder_estimation)

figure_folder_simulations = '../Figures/Figures_steadystate-model_Estimation-production-terms_simulations/';
mkdir(figure_folder_simulations)

table_folder  = '../Tables/';
mkdir(table_folder)


%% Observed levels for C3a, C5a, Ba and Bb for model to data comparison
MW = get_MW;

% Observed levels of C3a, C5a, Ba and Bb
ObsLevels.C3a_ngml = [129.6	32.1 52.0 449.4 11.95 0.05 86.4 14.3 63.7];
ObsLevels.C5a_ngml = [20.65	1.03 4.0  15.94 8.34  0.16 1.67 0.21];
ObsLevels.Ba_ngml  = [658 1000];
ObsLevels.Bb_ngml  = [960 650];

% convert ng/ml to ug/ml and then to uM
ObsLevels.C3a_uM   = ObsLevels.C3a_ngml .* 1E-3 .* 1E3 ./ MW.C3a;
ObsLevels.C5a_uM   = ObsLevels.C5a_ngml .* 1E-3 .* 1E3 ./ MW.C5a;
ObsLevels.Ba_uM    = ObsLevels.Ba_ngml  .* 1E-3 .* 1E3 ./ MW.Ba;
ObsLevels.Bb_uM    = ObsLevels.Bb_ngml  .* 1E-3 .* 1E3 ./ MW.Bb;


%% individual estimates for fluid phase proteins, w/o surface turnover
if(0)
    do_fit  = 1;
    save_on = 1;
    get_steady_state_prod_rates_IndividEst(copyobj(model), do_fit, save_on, figure_folder_estimation, table_folder)
end


%% surface turnover, multiple estimates - full model, get_steady_state_prod_rates_MultipleEst_V2
if(1)
    copiedModel  = copyobj(model);

    %%% estimation 
    if(1)
%         subname = '_Reduced-Tickover_Reduced-SurfAssociation';
        subname = '';
        do_fit  = 1;
        save_on = 1;
        plot_on = 1;
        x       = get_steady_state_prod_rates_MultipleEst_V2(copiedModel, do_fit, save_on, plot_on, ObsLevels, subname,...
                  {'B','C3', 'C5', 'C7', 'C9', 'D', 'P', 'C6', 'C8', 'I', 'H', 'Vn', 'Cn'}, figure_folder_estimation, table_folder);
              
 
    end
    
    %%% simulate to steady state to obtain ICs for further simulations    
    StopTime = 20;
    subname  = '_sim-to-steady-state';
    
    [model_ss, sim_simdata_to_SS] = prepare_steady_state_model(copiedModel, 'turnover_var_erythrocyte_turnover', x);
    
    plot_steady_state_full_model(sim_simdata_to_SS, ObsLevels, figure_folder_estimation, subname)  
    close all    
end
end