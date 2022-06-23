function sim_val_cellBasedAssays(model)
% driver file for validation simulations - cell based assays
% simulated:
%     human ER experiments
%         Ferreira 2007
%         Lesher 2013
%         Wilcox 1991
%     rabbit ER experiments
%         Biesma 2001
%         Pangburn 2002
%         Thanassi 2016
%         Wu 2018
% 
% Args: 
%   model - simbiology model object
% Outputs
%   none (figures and tables are saved on disk)


%% define which experiments to run
%%%
run.Volokhina_Wieslab   = 0;
run.Influence_Ncells    = 0;

%%% human ER
run.Ferreira_2007       = 1; %1
run.Lesher_2013         = 1; %1
run.Wilcox_1991         = 1; %1
run.impactRegulators    = 1;

%%% rabbit ER
run.Biesma_2001         = 0;
run.Pangburn_2002       = 1; %1    
run.Thanassi_2016       = 1;
run.Wu_2018             = 1;



%% output folders
figure_folder_humanER  = '../Figures/Figures_validation_activatedState-humanER/';
figure_folder_rabbitER = '../Figures/Figures_validation_activatedState-rabbitER/';
mkdir(figure_folder_humanER)
mkdir(figure_folder_rabbitER)


%% set solver options for all simulations - done in main driver file
cs                                  = getconfigset(model);
cs.CompileOptions.UnitConversion    = true;
cs.SolverType                       = 'ode15s'; % stiff solver
cs.SolverOptions.AbsoluteTolerance  = 1e-18;
cs.SolverOptions.SensitivityAnalysis= false;


%% Wieslab - move to sepearate file
%%%%%%%%%%% Volokhina et al. 2015, Clinical Immunology
% if(run.Volokhina_Wieslab)
%     cs.TimeUnits                        = 'minute';
%     cs.StopTime                         = 60; % 60 min - standard Wieslab protocol
% 
%     copiedModel = copyobj(model);
%     validation_sim_Volokhina_2015(copiedModel, '../Figures/Figures_validation_activatedState-Wieslab/')
%     delete(copiedModel); close all;
% end


%% Influence of number of cells on model predictions
% if(run.Influence_Ncells)
%     cs.TimeUnits                        = 'minute';
%     cs.StopTime                         = 60;
% 
%     copiedModel = copyobj(model);
%     validation_sim_influence_N_cells(copiedModel, figure_folder_rabbitER)
%     delete(copiedModel); close all;
% end


%% human ER       
        
%%%%%%%%%%% Ferreira 2007
if(run.Ferreira_2007)
    copiedModel = copyobj(model);
    simdata.Ferreira = validation_sim_Ferreira_2007(copiedModel, figure_folder_humanER, 'StopTime', 30, 'TimeUnits', 'minute');
    delete(copiedModel); close all;
end  

%%%%%%%%%%% Lesher 2013
if(run.Lesher_2013)
    copiedModel = copyobj(model);
    simdata.Lesher = validation_sim_Lesher_2013(copiedModel, figure_folder_humanER, 'StopTime', 30, 'TimeUnits', 'minute');
    delete(copiedModel); close all;
end

%%%%%%%%%%% Wilcox 1991
if(run.Wilcox_1991)
    copiedModel = copyobj(model);
    simdata.Wilcox = validation_sim_Wilcox_1991(copiedModel, figure_folder_humanER);
    delete(copiedModel); close all;
end

%%%%%%%%%%% Plot combined figure with observed vs predicted for all three
%%%%%%%%%%% publication
if(run.Wilcox_1991 && run.Lesher_2013 && run.Ferreira_2007)
    plot_validation_sim_humanEr_ObsPred(figure_folder_humanER, [], simdata)
    close all;
end

%%%%%%%%%%% simulate different combination of regulators and their impact
%%%%%%%%%%% on predicted lysis
if(run.impactRegulators)
    copiedModel = copyobj(model);
    simulate_human_Er_impact_regulators(copiedModel, figure_folder_humanER)
    delete(copiedModel); close all;
end





%% rabbit ER
%%%%%%%%%%% Biesma 2001
if(run.Biesma_2001)
    copiedModel = copyobj(model);
    validation_sim_Biesma_2001(copiedModel, figure_folder_rabbitER)
    delete(copiedModel); close all;
    cs.SolverOptions.OutputTimes        = [];
end

%%%%%%%%%%% Pangburn 2002
if(run.Pangburn_2002)
    copiedModel = copyobj(model);
    validation_sim_Pangburn_2002(copiedModel, figure_folder_rabbitER)
    delete(copiedModel); close all;
end

%%%%%%%%%%% Thanassi 2016
if(run.Thanassi_2016)
    copiedModel = copyobj(model);
    validation_sim_Thanassi_2016(copiedModel, figure_folder_rabbitER)
    delete(copiedModel); close all;
end

%%%%%%%%%%% Wu 20108
if(run.Wu_2018)
    copiedModel = copyobj(model);
    validation_sim_Wu_2018(copiedModel, figure_folder_rabbitER)
    delete(copiedModel); close all;
end  

end