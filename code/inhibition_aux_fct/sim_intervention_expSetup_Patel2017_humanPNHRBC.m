function [model_Patel, cells_uM_Patel, stopTime_Patel] = sim_intervention_expSetup_Patel2017_humanPNHRBC(model_In, PNH_type)
% experimental setup of Patel 2017 - Fig. 2(A)
% model gets changed! 
% 
% Args:
%   model_In  - unchanged, default model
%   PNH_type  - 2 or 3, defines which PNH type is assumed for the cells
%
% Outputs
%   model_Patel    -  modified model with changed parameters according 
%                        to Patel 2017
%   cells_uM_Patel - cells_uM in Patel model
%   stopTime_Patel - time of readout in model according to Patel

model_Patel = copyobj(model_In);

stopTime_Patel = 60; % unknown

serum_dilution  = 0.20; % 20% serum
N_cells_Patel = 5E7 * 1E3; % cells/mL to cells/L; unkown, guessed from other experiment on poster
[Surf_0, cells_uM_Patel, ~, ] = get_surface_erythrocytes(N_cells_Patel);

%%% set inital concentration to serum dilution
init_default    = get_ICs(model_In);
set_ICs(model_Patel, init_default, serum_dilution) 

%%% set num. of erythrocytes and free surface to values from experiment
set(sbioselect(model_Patel,'Type','species','Where','Name', '==', 'Surface host'), 'InitialAmount', Surf_0); 
set(sbioselect(model_Patel,'Type','species','Where','Name', '==', 'Erythrocytes_uM'), 'InitialAmount', cells_uM_Patel); 

if PNH_type == 2
    set(sbioselect(model_Patel,'Type','species','Where','Name', '==', 'DAF'), 'InitialAmount', 0.0203/10); 
    set(sbioselect(model_Patel,'Type','species','Where','Name', '==', 'CD59'), 'InitialAmount', 0.1575/10); 
elseif PNH_type == 3
    set(sbioselect(model_Patel,'Type','species','Where','Name', '==', 'DAF'), 'InitialAmount', 0); 
    set(sbioselect(model_Patel,'Type','species','Where','Name', '==', 'CD59'), 'InitialAmount', 0); 
else
    error('No correct PNH type defined')
end
end