function sim_intervention_driver(model)
% driver file for intervention simulations
% calls sim_intervention.m for the different simulated scenarios
% - unactivated, transient, readout after 4 hr
% - activated,   transient, readout after 4 hr
% - activated,   transient, readout after 30 (17) min, exp setup from
%   Katschke 2009
% 
% Args: 
%   model            - simbiology model object, do NOT apply changes to
%                      this model (instead generate a copy to which changes
%                      are applied)
% Outputs
%   none (figures and tables are saved on disk)

simID.single        = zeros(11, 1);
simID.mltple        = zeros(8, 1);
simID.drgs          = zeros(8, 1);

simID_default       = simID;


%%
    subname = '_DataComparisonExploratory';

    Kd = NaN;

    % Harder 2017 PNH cells, ACIDIFIED SERUM
    PNH_type = 2;
    
    simID.drgs(8)   = 1; % Eculizumab
    [model_Harder_PNH_humanER, cells_uM_Harder_PNH_humanER, stopTime_Harder_PNH_humanER] = sim_intervention_expSetup_Harder2017_humanPNHRBC(model, PNH_type);
    [ref_Harder_humanER, res_Harder_humanER, IC_Harder_humanER] = sim_intervention(model_Harder_PNH_humanER, Kd, subname, stopTime_Harder_PNH_humanER, simID);
    simID.drgs(8)   = 0;
    
    sim_intervention_plotting_dataComparison_Harder2017_PNH_cells([], res_Harder_humanER, [], Kd, subname)
    
    % % Patel 2017 PNH cells, ASH poster
    % PNH_type = 3;

    % simID.drgs(8)   = 1; % Eculizumab
    % [model_Patel_PNH_humanER, cells_uM_Patel_PNH_humanER, stopTime__Patel_PNH_humanER] = sim_intervention_expSetup_Patel2017_humanPNHRBC(model, PNH_type);
    % [ref_Patel_humanER, res_Patel_humanER, IC_Patel_humanER] = sim_intervention(model_Patel_PNH_humanER, Kd, subname, stopTime__Patel_PNH_humanER, simID);
    % simID.drgs(8)   = 0;
    
    % sim_intervention_plotting_dataComparison_Patel2017_PNH_cells([], res_Patel_humanER, [], Kd, subname)

    
end