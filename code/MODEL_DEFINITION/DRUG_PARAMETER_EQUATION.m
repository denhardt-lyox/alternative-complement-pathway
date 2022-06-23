function DRUG_PARAMETER_EQUATION(model)
       
        
%% C5 drug
kon_C5drug  = addparameter(model, 'kon_C5drug', 0,...
                            'notes', 'kon of C5 therapeutic binder', 'ValueUnits', '1/molarity/second');                     
koff_C5drug  = addparameter(model, 'koff_C5drug', 0,...
                            'notes', 'koff of C5 therapeutic binder', 'ValueUnits', '1/second');

iC5 = addreaction(model, 'C5 + C5drug <-> [C5drug C5]',...
            'ReactionRate', 'C5 * C5drug * kon_C5drug    - [C5drug C5] * koff_C5drug', 'Name', 'iC5');
        
%% C5 drug as Eculizumab (two molecules can be bound)
kon_Ecu  = addparameter(model, 'kon_Ecu', 0,...
                            'notes', 'kon of C5 therapeutic binder', 'ValueUnits', '1/molarity/second');                     
koff_Ecu  = addparameter(model, 'koff_Ecu', 0,...
                            'notes', 'koff of C5 therapeutic binder', 'ValueUnits', '1/second');

iC5 = addreaction(model, 'C5 + Ecu <-> [Ecu C5]',...
            'ReactionRate', 'C5 * Ecu * kon_Ecu    - [Ecu C5] * koff_Ecu', 'Name', 'iEcu1');
        