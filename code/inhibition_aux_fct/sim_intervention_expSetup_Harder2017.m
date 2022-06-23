function [model_Harder, cells_uM_Harder, stopTime_Harder] = sim_intervention_expSetup_Harder2017(model_In, activated)
% experimental setup of Harder 2017
% model gets changed! 
% 
% Args:
%   model_In  -  unchanged, default model
%   activated -  logical, indicate whether activated state should be
%                generated
% Outputs
%   model_Harder    -  modified model with changed parameters according 
%                        to Harder 2009 and activated state or not 
%                        (depending on activated var)
%   cells_uM_Harder - cells_uM in Harder model
%   stopTime_Harder - time of readout in model according to Harder

model_Harder = copyobj(model_In);

stopTime_Harder = 30; % original readout time 30 min!

serum_dilution  = 0.25; % 25% serum
N_cells_Harder = 0.75E8 * 1E3; % cells/mL to cells/L; unkown, guessed from protocol and conc of stock solution from Complement Tech
[Surf_0, cells_uM_Harder, ~, ] = get_surface_erythrocytes(N_cells_Harder);

%%% set inital concentration to 25% serum
init_default    = get_ICs(model_In);
set_ICs(model_Harder, init_default, serum_dilution) 

%%% set num. of erythrocytes and free surface to values from experiment
set(sbioselect(model_Harder,'Type','species','Where','Name', '==', 'Surface host'), 'InitialAmount', Surf_0); 
set(sbioselect(model_Harder,'Type','species','Where','Name', '==', 'Erythrocytes_uM'), 'InitialAmount', cells_uM_Harder); 

if activated == 1
    % commit variants to copied model w/o changing original model
    % this is simpler than calling the variants in each simulation in the
    % subfunctions
    commit(getvariant(model_Harder, 'regulators_NoDAF_var'), model_Harder)
    commit(getvariant(model_Harder, 'regulators_NoCR1_var'), model_Harder)
    commit(getvariant(model_Harder, 'regulators_NoCD59_var'), model_Harder)
    commit(getvariant(model_Harder, 'regulators_no_H_binding_var'), model_Harder)
end
end