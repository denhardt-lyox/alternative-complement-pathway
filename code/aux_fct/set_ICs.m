function model = set_ICs(model, init, multiplier, varargin)
%% set initial concentration of all species
%%% use get_IC to get the vector with all initial concentrations init
%%% multiplier is a single numerical value by which all ICs are scaled

%%% Surface is an optional argument in uM(!). If passed, surface will be set to
%%% selected value and surface regulators will be adjusted accordingly

%%% H2O is not changed

%% input parser
p = inputParser;

% default inputs
default.Surface = [];

% add inputs and check validity of format
addRequired(p, 'model', @(x) strcmp(class(x), 'SimBiology.Model'));
addRequired(p, 'init', @isstruct);
addRequired(p, 'multiplier', @isnumeric);
addParameter(p, 'Surface', default.Surface, @isnumeric)

% parse results
parse(p, model, init, multiplier, varargin{:})

% extract frequently used variables for ease of handling
model = p.Results.model;


%% Fluid phase
set(sbioselect(model,'Type','species','Where','Name', '==', 'C3'), 'InitialAmount', p.Results.init.C3_0 * p.Results.multiplier);
set(sbioselect(model,'Type','species','Where','Name', '==', 'C5'), 'InitialAmount', p.Results.init.C5_0 * p.Results.multiplier); 
set(sbioselect(model,'Type','species','Where','Name', '==', 'C6'), 'InitialAmount', p.Results.init.C6_0 * p.Results.multiplier); 
set(sbioselect(model,'Type','species','Where','Name', '==', 'C7'), 'InitialAmount', p.Results.init.C7_0 * p.Results.multiplier); 
set(sbioselect(model,'Type','species','Where','Name', '==', 'C8'), 'InitialAmount', p.Results.init.C8_0 * p.Results.multiplier); 
set(sbioselect(model,'Type','species','Where','Name', '==', 'C9'), 'InitialAmount', p.Results.init.C9_0 * p.Results.multiplier); 

set(sbioselect(model,'Type','species','Where','Name', '==', 'B'), 'InitialAmount', p.Results.init.B_0 * p.Results.multiplier); 
set(sbioselect(model,'Type','species','Where','Name', '==', 'D'), 'InitialAmount', p.Results.init.D_0 * p.Results.multiplier); 
set(sbioselect(model,'Type','species','Where','Name', '==', 'I'), 'InitialAmount', p.Results.init.I_0 * p.Results.multiplier); 

set(sbioselect(model,'Type','species','Where','Name', '==', 'P'), 'InitialAmount', p.Results.init.Properdin_0 * p.Results.multiplier); 
set(sbioselect(model,'Type','species','Where','Name', '==', 'H'), 'InitialAmount', p.Results.init.H_0 * p.Results.multiplier); 
set(sbioselect(model,'Type','species','Where','Name', '==', 'Vn'), 'InitialAmount', p.Results.init.Vn_0 * p.Results.multiplier); 
set(sbioselect(model,'Type','species','Where','Name', '==', 'Cn'), 'InitialAmount', p.Results.init.Cn_0 * p.Results.multiplier); 


%% Cell bound species 
%%% if empty use the same multiplier as for the fluid phase
if isempty(p.Results.Surface)
    set(sbioselect(model,'Type','species','Where','Name', '==', 'Surface host'), 'InitialAmount', p.Results.init.Surface_0  * p.Results.multiplier); 

    set(sbioselect(model,'Type','species','Where','Name', '==', 'CD59'), 'InitialAmount',         p.Results.init.CD59_0     * p.Results.multiplier); 
    set(sbioselect(model,'Type','species','Where','Name', '==', 'CR1'), 'InitialAmount',          p.Results.init.CR1_0      * p.Results.multiplier); 
    set(sbioselect(model,'Type','species','Where','Name', '==', 'DAF'), 'InitialAmount',          p.Results.init.DAF_0      * p.Results.multiplier); 

%%% if not empty use passed surface in uM and adjust surface regulators
else
    %%% get suface proteins per surface
    CD59_per_Surface = get(sbioselect(model,'Type','parameter','Where','Name', '==', 'CD59_per_Surface'), 'Value');
    CR1_per_Surface  = get(sbioselect(model,'Type','parameter','Where','Name', '==', 'CR1_per_Surface'),  'Value');
    DAF_per_Surface  = get(sbioselect(model,'Type','parameter','Where','Name', '==', 'DAF_per_Surface'),  'Value');

    %%%
    set(sbioselect(model,'Type','species','Where','Name', '==', 'Surface host'), 'InitialAmount', p.Results.Surface); 
    
%     set(sbioselect(model,'Type','species','Where','Name', '==', 'CD59'), 'InitialAmount',         p.Results.init.CD59_0     * p.Results.multiplier); 
%     set(sbioselect(model,'Type','species','Where','Name', '==', 'CR1'), 'InitialAmount',          p.Results.init.CR1_0      * p.Results.multiplier); 
%     set(sbioselect(model,'Type','species','Where','Name', '==', 'DAF'), 'InitialAmount',          p.Results.init.DAF_0      * p.Results.multiplier); 
    
    set(sbioselect(model,'Type','species','Where','Name', '==', 'CD59'), 'InitialAmount',         p.Results.Surface * CD59_per_Surface); 
    set(sbioselect(model,'Type','species','Where','Name', '==', 'CR1'), 'InitialAmount',          p.Results.Surface * CR1_per_Surface); 
    set(sbioselect(model,'Type','species','Where','Name', '==', 'DAF'), 'InitialAmount',          p.Results.Surface * DAF_per_Surface); 
end


%% Generic
% set(sbioselect(model,'Type','species','Where','Name', '==', 'H2O'), 'InitialAmount', p.Results.init.H2O_0 * p.Results.multiplier);
set(sbioselect(model,'Type','species','Where','Name', '==', 'H2O'), 'InitialAmount', p.Results.init.H2O_0 * 1);


end