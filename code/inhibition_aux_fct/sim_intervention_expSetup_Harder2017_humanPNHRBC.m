function [model_Harder, cells_uM_Harder, stopTime_Harder] = sim_intervention_expSetup_Harder2017_humanPNHRBC(model_In, PNH_type)
% experimental setup of Harder 2017 - Fig. 2A
% model gets changed! 
% 
% Args:
%   model_In  -  unchanged, default model
%   PNH_type  - 2 or 3, defines which PNH type is assumed for the cells
%
% Outputs
%   model_Harder    -  modified model with changed parameters according 
%                        to Harder 2017 
%   cells_uM_Harder - cells_uM in Harder model
%   stopTime_Harder - time of readout in model according to Harder

model_Harder = copyobj(model_In);

stopTime_Harder = 24*60; % original readout time 24h!

serum_dilution  = 0.75; % 75% serum
N_cells_Harder = 0.75E8 * 1E3; % cells/mL to cells/L; unkown, guessed from protocol and conc of stock solution from Complement Tech
[Surf_0, cells_uM_Harder, ~, ] = get_surface_erythrocytes(N_cells_Harder);

%%% set inital concentration to 25% serum
init_default    = get_ICs(model_In);
set_ICs(model_Harder, init_default, serum_dilution) 

%%% set num. of erythrocytes and free surface to values from experiment
set(sbioselect(model_Harder,'Type','species','Where','Name', '==', 'Surface host'), 'InitialAmount', Surf_0); 
set(sbioselect(model_Harder,'Type','species','Where','Name', '==', 'Erythrocytes_uM'), 'InitialAmount', cells_uM_Harder);

if PNH_type == 2
    set(sbioselect(model_Harder,'Type','species','Where','Name', '==', 'DAF'), 'InitialAmount', 0.0203/10); 
    set(sbioselect(model_Harder,'Type','species','Where','Name', '==', 'CD59'), 'InitialAmount', 0.1575/10); 
elseif PNH_type == 3
    set(sbioselect(model_Harder,'Type','species','Where','Name', '==', 'DAF'), 'InitialAmount', 0); 
    set(sbioselect(model_Harder,'Type','species','Where','Name', '==', 'CD59'), 'InitialAmount', 0); 
else
    error('No correct PNH type defined')
end
end