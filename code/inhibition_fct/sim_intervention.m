function [ref, res, IC] = sim_intervention(model_In, Kd, subname, StopTime, varargin)
%% Kd must be given in nM  !!!!!!!!!!!!
% 
% simulate interventions (=drugs) and plot dose response curves
% implemented drugs: see below
% 
% Args:
% Required:
%   model_In -  a simbiology model object, gets copied to prevent unwanted
%               changes to this model; copied version is deleted at the end
%   Kd       -  Kd (in nM) to be used
%   subname  -  subname used for subsorting into Fig. folders to distinguish
%               different experimental set ups that are simulated
% 	StopTime -  time of readout in minutes
% Optional:
%   simID    -  logical indexing whether drug should be simulated or not
%               (if not specified, no drug is simulated)
% 
% Outputs
%   ref      -  reference simulation without any drug
%   res      -  results cell with fields 
%               	single - for drugs with single target
%                   mltple - for drugs with multiple targets
%                   drgs   - for existing drugs with defined KDs
%   IC       -  cell of same format as res with inhibition coeff.
% 
% 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%% input parser 
% check for validity of inputs and add default values for optional inputs if not passed
default.simID        = struct();
default.simID.single = zeros(11,1);
default.simID.mltple = zeros(8,1);
default.simID.drgs   = zeros(8,1);

p = inputParser;
addRequired(p, 'model_In');
addRequired(p, 'Kd',       @(x)(isnumeric(x) && isscalar(x) && (x > 0)) || isnan(x) );
addRequired(p, 'subname',  @(x) ischar(x));
addRequired(p, 'StopTime', @(x) isnumeric(x) && isscalar(x) && (x > 0));
addOptional(p, 'simID',    default.simID,@(x) isstruct(x) && isfield(x, 'single') && isfield(x, 'mltple') && isfield(x, 'drgs') ...
                                           && length(x.single) == length(default.simID.single) ...
                                           && length(x.mltple) == length(default.simID.mltple) ...
                                           && length(x.drgs) == length(default.simID.drgs));                                       
parse(p,model_In, Kd, subname, StopTime, varargin{:});
 
% unpack results to abbreviate code below
model_In = p.Results.model_In;
Kd       = p.Results.Kd;
subname  = p.Results.subname;
StopTime = p.Results.StopTime;
simID    = p.Results.simID;

 
%% copy model for QC reasons
model = copyobj(model_In);


%%
cells_uM = get(sbioselect(model,'Type','Species','Where','Name', '==', 'Erythrocytes_uM'), 'InitialAmount');

    
%% Define and generate folders for figures and tables
[figure_folder, figure_folder_summary_plots, table_folder] = ...
    sim_intervention_folder_definitions(Kd, subname);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Define output variables
single     = cell(1,11);
mltple     = cell(1,8);
drgs  	   = cell(1,6);


IC.single = single;
IC.mltple = mltple;
IC.drgs   = drgs;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% % Define Eculizumab specificity - uses equations for C5-drug
% drug_Eculizumab       = 'C5drug';
% targets_Eculizumab    = 'C5';
% complexes_Eculizumab  = 'C5drug C5';
% 
% % Use Compstatin binding properties
% Kd_Eculizumab = 0.120; % 120 pM - Rother 2007; kon off rates? only info on scFV (Thomas 1996)
% 
% kon = 20;               % 1/day/nM 
% kon = kon/24/60/60*1e9; % 1/s/M
% koff = kon*Kd_Eculizumab*10^-9;
% 
% binding_par_Eculizumab.kon          = kon;
% binding_par_Eculizumab.koff         = koff;
% binding_par_Eculizumab.kon_name     = 'kon_C5drug';
% binding_par_Eculizumab.koff_name    = 'koff_C5drug';

% Define Eculizumab specificity - uses equations for C5-drug
drug_Eculizumab       = 'Ecu';
targets_Eculizumab    = 'C5';
complexes_Eculizumab  = 'Ecu C5';

% Use Compstatin binding properties
Kd_Eculizumab = 0.120; % 120 pM - Rother 2007; kon off rates? only info on scFV (Thomas 1996)

kon = 20;               % 1/day/nM 
kon = kon/24/60/60*1e9; % 1/s/M
koff = kon*Kd_Eculizumab*10^-9;

binding_par_Eculizumab.kon          = kon;
binding_par_Eculizumab.koff         = koff;
binding_par_Eculizumab.kon_name     = 'kon_Ecu';
binding_par_Eculizumab.koff_name    = 'koff_Ecu';


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%% Simulate with interventions
% set solver options
cs                                  = getconfigset(model);
cs.CompileOptions.UnitConversion    = true;
cs.SolverType                       = 'ode15s'; % stiff solver
% cs.SolverOptions.AbsoluteTolerance  = 1e-18;
cs.SolverOptions.AbsoluteTolerance  = 1e-20; % preventing negative values
cs.SolverOptions.SensitivityAnalysis= false;

cs.TimeUnits                        = 'minute';
cs.StopTime                         = StopTime;

%% Reference simulation
ref.simdata     = sbiosimulate(model);
ref.temp        = selectbyname(ref.simdata, {'C3a', 'C5a', '[MAC host]', 'Percent_Lysis_Takeda', 'Percent_Lysis_Kolb'});
ref.C3a_end     = ref.temp.Data(end,1);
ref.C5a_end     = ref.temp.Data(end,2);
ref.MAC_end     = ref.temp.Data(end,3);
ref.Lysis_end   = ref.temp.Data(end,4:5);


%%% Eculizumab
[drgs{8}.drug_uM, drgs{8}.C3a, drgs{8}.C5a, drgs{8}.MAC, drgs{8}.C3dg, drgs{8}.targets, drgs{8}.lysis] = ...
    dose_scan(model, drug_Eculizumab, targets_Eculizumab, complexes_Eculizumab, binding_par_Eculizumab, [figure_folder, 'Eculizumab_']);
drgs{8}.cells_uM      = cells_uM;
drgs{8}.target        = 'Eculizumab';
IC.drgs{8}.C3a        = sim_intervention_find_InhCoeff(drgs{8}.drug_uM, drgs{8}.C3a,          drgs{8}.C3a(1),     [50 95]);
IC.drgs{8}.C5a        = sim_intervention_find_InhCoeff(drgs{8}.drug_uM, drgs{8}.C5a,          drgs{8}.C5a(1),     [50 95]);
IC.drgs{8}.MAC        = sim_intervention_find_InhCoeff(drgs{8}.drug_uM, drgs{8}.MAC,          drgs{8}.MAC(1),     [50 95]);
IC.drgs{8}.lysis(1,:) = sim_intervention_find_InhCoeff(drgs{8}.drug_uM, drgs{8}.lysis(1,:),   drgs{8}.lysis(1,1), [50 95]);
IC.drgs{8}.lysis(2,:) = sim_intervention_find_InhCoeff(drgs{8}.drug_uM, drgs{8}.lysis(2,:),   drgs{8}.lysis(2,1), [50 95]);


%% merge output variables
res.single  = single;
res.mltple  = mltple;
res.drgs    = drgs;
if exist('Vrs','var')
    res.Vrs     = Vrs;
end


delete(model)
end