function TURNOVER_PARAMETER(model)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Synthesis (input) and elimination of complement to simulated steady 
% state scenario. All clerance and production rates are defined but set 
% to 0. This gives the original Zewde model.
% Clearances are defined as a model variant.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% Erythrocyte turnover parameter
k_pr_erythrocytes = addparameter(model, 'k_pr_erythrocytes', 0,...
    'notes', 'Production of eryhtrocytes', 'ValueUnits', 'molarity/second');

k_el_erythrocytes = addparameter(model, 'k_el_erythrocytes', 0,...
    'notes', 'Degradation of eryhtrocytes', 'ValueUnits', '1/second');

k_pr_erythrocytes = addparameter(model, 'k_pr_surface', 0,...
    'notes', 'Production of eryhtrocytes surface', 'ValueUnits', 'molarity/second');


k_hemolysis_max =  addparameter(model, 'k_hemolysis_max', 0,...
    'notes', 'Max rate of lysis of eryhtrocytes', 'ValueUnits', '1/second'); % not used anywhere, eventually remove? if so, remover from input as function "calculate_k_hemolysis.m"

k_hemolysis_on = addparameter(model, 'k_hemolysis_on', 0,...
    'notes', 'Logic indicator whether k_hemolysis should be calculated or not', 'ValueUnits', 'dimensionless');

k_hemolysis_typical_T = addparameter(model, 'k_hemolysis_typical_T', 0,...
    'notes', 'Typical time used to scale between percentage hemolysis and k_hemolysis', 'ValueUnits', 'second');


k_hemolysis =  addparameter(model, 'k_hemolysis', 0,...
    'notes', 'Actual rate of lysis of eryhtrocytes', 'ValueUnits', '1/second');
set(sbioselect(model, 'Where', 'Name', '==', 'k_hemolysis'), 'ConstantValue', false);

k_hemolysis_rule = 'k_hemolysis = calculate_k_hemolysis(k_hemolysis_max, Percent_Lysis_Kolb, Percent_Lysis_Takeda, k_hemolysis_on, k_hemolysis_typical_T)';
addrule(model, k_hemolysis_rule, 'repeatedAssignment');

% k_hemolysis = 'k_hemolysis = k_hemolysis_max * (Percent_Lysis_Mean / 100)';
% k_rule1 = addrule(model, k_hemolysis, 'repeatedAssignment');


%% Eliminiation constants
%%% fluid phase ACP components
k_el_C3 = addparameter(model, 'k_el_C3', 0,...
    'notes', 'Elimination of C3', 'ValueUnits', '1/second');
k_el_C5 = addparameter(model, 'k_el_C5', 0,...
    'notes', 'Elimination of C5', 'ValueUnits', '1/second');
k_el_C6 = addparameter(model, 'k_el_C6', 0,...
    'notes', 'Elimination of C6', 'ValueUnits', '1/second');
k_el_C7 = addparameter(model, 'k_el_C7', 0,...
    'notes', 'Elimination of C7', 'ValueUnits', '1/second');
k_el_C8 = addparameter(model, 'k_el_C8', 0,...
    'notes', 'elimnation of C8', 'ValueUnits', '1/second');
k_el_C9 = addparameter(model, 'k_el_C9', 0,...
    'notes', 'Elimination of C9', 'ValueUnits', '1/second');
k_el_D = addparameter(model, 'k_el_D', 0,...
    'notes', 'Elimination of D', 'ValueUnits', '1/second');
k_el_B = addparameter(model, 'k_el_B', 0,...
    'notes', 'Elimination of B', 'ValueUnits', '1/second');
k_el_I = addparameter(model, 'k_el_I', 0,...
    'notes', 'Elimination of I', 'ValueUnits', '1/second');
k_el_H = addparameter(model, 'k_el_H', 0,...
    'notes', 'Elimination of H', 'ValueUnits', '1/second');
k_el_Vn = addparameter(model, 'k_el_Vn', 0,...
    'notes', 'Elimination of Vn', 'ValueUnits', '1/second');
k_el_Cn = addparameter(model, 'k_el_Cn', 0,...
    'notes', 'Elimination of Cn', 'ValueUnits', '1/second');
k_el_P = addparameter(model, 'k_el_P', 0,...
    'notes', 'Elimination of Properdin', 'ValueUnits', '1/second');

%%% Surface proteins
k_el_CR1 = addparameter(model, 'k_el_CR1', 0,...
    'notes', 'Elimination of CR1', 'ValueUnits', '1/second');
k_el_CD59 = addparameter(model, 'k_el_CD59', 0,...
    'notes', 'Elimination of CD59', 'ValueUnits', '1/second');
k_el_DAF = addparameter(model, 'k_el_DAF', 0,...
    'notes', 'Elimination of DAF', 'ValueUnits', '1/second');

k_el_SurfaceProtein = addparameter(model, 'k_el_SurfaceProtein', 0,...
    'notes', 'Elimination of generic surface protein', 'ValueUnits', '1/second');

%%% other proteins
k_el_Ba = addparameter(model, 'k_el_Ba', 0,...
    'notes', 'Elimination of Ba', 'ValueUnits', '1/second');
k_el_Bb = addparameter(model, 'k_el_Bb', 0,...
    'notes', 'Elimination of Bb', 'ValueUnits', '1/second');

k_el_C3a = addparameter(model, 'k_el_C3a', 0,...
    'notes', 'Elimination of C3a', 'ValueUnits', '1/second');
k_el_C5a = addparameter(model, 'k_el_C5a', 0,...
    'notes', 'Elimination of C5a', 'ValueUnits', '1/second');

k_el_C5b_species = addparameter(model, 'k_el_C5b_species', 0,...
    'notes', 'Elimination of C5b_species', 'ValueUnits', '1/second');
k_el_iC3b = addparameter(model, 'k_el_iC3b', 0,...
    'notes', 'Elimination of iC3b', 'ValueUnits', '1/second');
k_el_C3dg = addparameter(model, 'k_el_C3dg', 0,...
    'notes', 'Elimination of C3dg', 'ValueUnits', '1/second');


%%% generic drug species
k_el_Drug = addparameter(model, 'k_el_Drug', 0,...
    'notes', 'Elimination of generic drug', 'ValueUnits', '1/second');

%% Production constants
k_pr_C3 = addparameter(model, 'k_pr_C3', 0,...
    'notes', 'Production of C3', 'ValueUnits', 'molarity/second');
k_pr_C5 = addparameter(model, 'k_pr_C5', 0,...
    'notes', 'Production of C5', 'ValueUnits', 'molarity/second');
k_pr_C6 = addparameter(model, 'k_pr_C6', 0,...
    'notes', 'Production of C6', 'ValueUnits', 'molarity/second');
k_pr_C7 = addparameter(model, 'k_pr_C7', 0,...
    'notes', 'Production of C7', 'ValueUnits', 'molarity/second');
k_pr_C8 = addparameter(model, 'k_pr_C8', 0,...
    'notes', 'elimnation of C8', 'ValueUnits', 'molarity/second');
k_pr_C9 = addparameter(model, 'k_pr_C9', 0,...
    'notes', 'Production of C9', 'ValueUnits', 'molarity/second');
k_pr_D = addparameter(model, 'k_pr_D', 0,...
    'notes', 'Production of D', 'ValueUnits', 'molarity/second');
k_pr_B = addparameter(model, 'k_pr_B', 0,...
    'notes', 'Production of B', 'ValueUnits', 'molarity/second');
k_pr_P = addparameter(model, 'k_pr_P', 0,...
    'notes', 'Production of P', 'ValueUnits', 'molarity/second');

k_pr_I = addparameter(model, 'k_pr_I', 0,...
    'notes', 'Production of I', 'ValueUnits', 'molarity/second');
k_pr_H = addparameter(model, 'k_pr_H', 0,...
    'notes', 'Production of H', 'ValueUnits', 'molarity/second');
k_pr_Vn = addparameter(model, 'k_pr_Vn', 0,...
    'notes', 'Production of Vn', 'ValueUnits', 'molarity/second');
k_pr_Cn = addparameter(model, 'k_pr_Cn', 0,...
    'notes', 'Production of Cn', 'ValueUnits', 'molarity/second');

k_pr_CR1 = addparameter(model, 'k_pr_CR1', 0,...
    'notes', 'Production of CR1', 'ValueUnits', 'molarity/second');
k_pr_DAF = addparameter(model, 'k_pr_DAF', 0,...
    'notes', 'Production of DAF', 'ValueUnits', 'molarity/second');
k_pr_CD59 = addparameter(model, 'k_pr_CD59', 0,...
    'notes', 'Production of CD59', 'ValueUnits', 'molarity/second');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%