function [FSR, rate_mg_kg_day] = get_FSR(model, production_rates)
%%% Function to calculate fractional synthetic rate (FSR) in percent from 
%%% estimated production rates, molecular weights and inital conditions

%% Assumed parameter values
V_Plasma = 3;  % liter
BW_kg    = 70; % kg

%% get initial conditions
IC = get_ICs(model);

%% get molecular weights
MW = get_MW;

%% Function for calulcation of FSR
function [FSR_percent, rate_mg_kg_day] = FSR_percent(rate_in, MW, IC, V_Plasma, BW_kg)
    %%% inputs
    % rate_in:  Synthesis rate in M/s
    % MW:       Molecular weight in Dalton
    % IC:       inital concentration (=steady state concentration) in uM
    % V_Plasma: Plasma volume in liter
    % BW_kg:    BW in kg
    
    % convert rate from M/s to mg/kg/day
    rate_mg_kg_day = rate_in * MW * 86400 * V_Plasma * 1E3 / BW_kg;
        
    % Calculate amount of protein in mg/kg  
    amount = IC * 1E-6 * MW * V_Plasma  * 1E3 / BW_kg;

    % Calculate FSR in percent
    FSR_percent =  100 / amount *( rate_mg_kg_day / 24);
end

%% Calculate FSR for each species
% FB
rate_in = production_rates.Value(strcmp(production_rates.Row,'B'));
[FSR.B, rate_mg_kg_day.B]   = FSR_percent(rate_in, MW.B, IC.B_0,  V_Plasma, BW_kg);
% C3
rate_in = production_rates.Value(strcmp(production_rates.Row,'C3'));
[FSR.C3, rate_mg_kg_day.C3] = FSR_percent(rate_in,MW.C3, IC.C3_0, V_Plasma, BW_kg);
% C5
rate_in = production_rates.Value(strcmp(production_rates.Row,'C5'));
[FSR.C5, rate_mg_kg_day.C5] = FSR_percent(rate_in,MW.C5, IC.C5_0, V_Plasma, BW_kg);
% C6
rate_in = production_rates.Value(strcmp(production_rates.Row,'C6'));
[FSR.C6, rate_mg_kg_day.C6] = FSR_percent(rate_in,MW.C6, IC.C6_0, V_Plasma, BW_kg);
% C7
rate_in = production_rates.Value(strcmp(production_rates.Row,'C7'));
[FSR.C7, rate_mg_kg_day.C7] = FSR_percent(rate_in,MW.C7, IC.C7_0, V_Plasma, BW_kg);
% C8
rate_in = production_rates.Value(strcmp(production_rates.Row,'C8'));
[FSR.C8, rate_mg_kg_day.C8] = FSR_percent(rate_in,MW.C8, IC.C8_0, V_Plasma, BW_kg);
% C9
rate_in = production_rates.Value(strcmp(production_rates.Row,'C9'));
[FSR.C9, rate_mg_kg_day.C9] = FSR_percent(rate_in,MW.C9, IC.C9_0, V_Plasma, BW_kg);
% Cn
rate_in = production_rates.Value(strcmp(production_rates.Row,'Cn'));
[FSR.Cn, rate_mg_kg_day.Cn] = FSR_percent(rate_in,MW.Cn, IC.Cn_0, V_Plasma, BW_kg);
% FD
rate_in = production_rates.Value(strcmp(production_rates.Row,'D'));
[FSR.D, rate_mg_kg_day.D]   = FSR_percent(rate_in,MW.D, IC.D_0,   V_Plasma, BW_kg);
% FH
rate_in = production_rates.Value(strcmp(production_rates.Row,'H'));
[FSR.H, rate_mg_kg_day.H]   = FSR_percent(rate_in,MW.H, IC.H_0,   V_Plasma, BW_kg);
% FI
rate_in = production_rates.Value(strcmp(production_rates.Row,'I'));
[FSR.I, rate_mg_kg_day.I]   = FSR_percent(rate_in,MW.I, IC.I_0,   V_Plasma, BW_kg);
% P
rate_in = production_rates.Value(strcmp(production_rates.Row,'P'));
[FSR.P, rate_mg_kg_day.P]   = FSR_percent(rate_in,MW.P, IC.Properdin_0, V_Plasma, BW_kg);
% Vn
rate_in = production_rates.Value(strcmp(production_rates.Row,'Vn'));
[FSR.Vn, rate_mg_kg_day.Vn] = FSR_percent(rate_in,MW.Vn, IC.Vn_0, V_Plasma, BW_kg);

%% Output
disp('Calcualted fractional synthetic rates (FSR):')
disp('(Calcualted from IC and synthesis rates)')
disp(FSR)
end
