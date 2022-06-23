function model_PK = PK_fct_aux(model_In, drug_name, varargin)

p = inputParser;
addRequired(p, 'model_In');
addRequired(p, 'drug_name',     @(x) ischar(x)); % name of the drug to be added to model
% addRequired(p, 'dosing_Schedule',        isstruct(x) && isfield(x, 'single') && isfield(x, 'mltple') && isfield(x, 'drgs')); % dosing structure
addParameter(p, 'DOSE', 10,     @(x) isscalar(x) && (x > 0) ) % Dose (mg/kg)
addParameter(p, 'BW',   70,     @(x) isscalar(x) && (x > 0) ) % Body weight of individual to be simulated (kg)
addParameter(p, 'Vd',   7,      @(x) isscalar(x) && (x > 0) ) % Volume of distribution (L)
addParameter(p, 'MW',   150E3,  @(x) isscalar(x) && (x > 0) ) % Molecular weight (Da)
% addParameter(p, 'F',    1,       @(x) isscalar(x) && (x > 0) ) % Bioavailability
addParameter(p, 'T05',  28,     @(x) isscalar(x) && (x > 0) ) % Half life
addParameter(p, 'Kd',   1,      @(x) isscalar(x) && (x > 0) ) % Kd (uM)
addParameter(p, 'kon',  20,     @(x) isscalar(x) && (x > 0) ) % kon (1/day/nM)

% Use if you want to specfiy manually the treatment times:
% If amount is given, dose will be ignored as an input
addParameter(p, 'Time',  [],     @(x) isvector(x)) % Time(s) of treatment (day), can be a vector.
addParameter(p, 'Amount',  [],   @(x) isvector(x)) % Amount of drug (mg) to be given at times "Time"

% Use if you want to specfiy manually the treatment times + want to use two
% different amount at the times specified in "Time" and "Time_2"
addParameter(p, 'Time_2',  [],     @(x) isvector(x)) % Time(s) of treatment (day), can be a vector. 
addParameter(p, 'Amount_2', [],   @(x) isvector(x)) % Amount of drug (mg) to be given at times "Time_2"

parse(p,model_In, drug_name, varargin{:});


%%
model_PK = copyobj(model_In);


%% default dosing schedule to be used if no "Time" vector is given as input
% Administration - currently only bolus IV
dosing_Schedule.ADM         = 1; 
% Infusion time - non-functional as not yet implement, currently only bolus IV
dosing_Schedule.TINF        = 0; 
% Time between two doses (days)
dosing_Schedule.t_delta     = 14;
% Time of first dose (days)
dosing_Schedule.t_firstDose = 3*365;
% Number of doses to be simulated
dosing_Schedule.N_doses     = 200;


%% Check whether Amount or Dose was specified as input + and convert dose/amount
% to molar units
if(isempty(p.Results.Amount))
    % Convert dose to amount (g)
    Amt_g  = p.Results.DOSE * p.Results.BW * 1E-3;
else
   % Convert amount from mg to g
   Amt_g   = p.Results.Amount .* 1E-3;
   
   % If 2nd amount given, convert to g and to uM
    if(~isempty(p.Results.Amount_2))
     Amt_2_g   = p.Results.Amount_2 .* 1E-3; 
     Amt_2_uM = (Amt_2_g / p.Results.MW * 1E6) / p.Results.Vd; 
   end
end
    
% Convet to uM
Amt_uM = (Amt_g / p.Results.MW * 1E6) / p.Results.Vd; 

%% Calculate elimination rate (1/s) from half-life
k_el_Drug = log(2) / (p.Results.T05 * 24 * 60 * 60);


%% Binding parameters
% convert kon from 1/nM/day to 1/M/s
kon  = p.Results.kon / 24 / 60 / 60 * 1e9; % 1/s/M
% Calculate koff
koff = kon * p.Results.Kd * 10^-9;

binding_par.kon  = kon;
binding_par.koff = koff;


%% Add amounts to be used to model
paramObj   = addparameter(model_PK, 'Drug_Amt',   Amt_uM, 'ValueUnits', 'micromolarity');
if(~isempty(p.Results.Amount_2))
    paramObj2   = addparameter(model_PK, 'Drug_Amt_2', Amt_2_uM, 'ValueUnits', 'micromolarity');
end

%% Update drug eliminiation constant in model
par = sbioselect(model_PK.Parameters, 'Where', 'Name', '==', 'k_el_Drug'); 
par.Value = k_el_Drug;
    
%% Update binding parameters in model
binding_par.kon_name    = ['kon_', drug_name];
binding_par.koff_name   = ['koff_', drug_name];
    
%%% define which binding to activate
set(sbioselect(model_PK,'Type','parameter','Where','Name', '==', binding_par.kon_name),  'Value', binding_par.kon);
set(sbioselect(model_PK,'Type','parameter','Where','Name', '==', binding_par.koff_name), 'Value', binding_par.koff);


%% Dosing schedule

%%% If no times of treatment given, use dosing_Schedule.t_firstDose + dosing_Schedule.t_delta
if(isempty(p.Results.Time))
    for i = 1:dosing_Schedule.N_doses
        timeOfDose      = dosing_Schedule.t_firstDose + (i-1) * dosing_Schedule.t_delta;
        string_time     = ['time >= ', num2str(timeOfDose)];
        string_dosing	= [drug_name, ' = ', drug_name, ' + Drug_Amt'];
        eventObj = addevent(model_PK, string_time, string_dosing);
    end
else
    %%% If times of treatment given use Time + Amount
    for i = 1:length(p.Results.Time)
        timeOfDose      = p.Results.Time(i);
        string_time     = ['time >= ', num2str(timeOfDose)];
        string_dosing	= [drug_name, ' = ', drug_name, ' + Drug_Amt'];
        eventObj = addevent(model_PK, string_time, string_dosing);
    end
    
    %%% If times for second amount are given use Time_2 + Amount_2 
    if(~isempty(p.Results.Time_2))
        for i = 1:length(p.Results.Time_2)
            timeOfDose      = p.Results.Time_2(i);
            string_time     = ['time >= ', num2str(timeOfDose)];
            string_dosing	= [drug_name, ' = ', drug_name, ' + Drug_Amt_2'];
            eventObj = addevent(model_PK, string_time, string_dosing);
        end        
    end
end






end