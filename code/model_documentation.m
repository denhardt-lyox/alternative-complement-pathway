function model_documentation(model)


% get(modelObj.Reactions, {'Reaction', 'ReactionRate'})
% ans =
% 
%   6x2 cell array
% 
%     {'L + R <-> RL'           }    {'kRL*L*R - kRLm*RL'}
%     {'Gd + Gbg -> G'          }    {'kG1*Gd*Gbg'       }
%     {'G + RL -> Ga + Gbg + RL'}    {'kGa*G*RL'         }
%     {'R <-> null'             }    {'kRdo*R - kRs'     }
%     {'RL -> null'             }    {'kRD1*RL'          }
%     {'Ga -> Gd'               }    {'kGd*Ga'           }
% 


% Display reactions, species and compartments
%model.Reactions.display
%model.Species.display
%model.Compartments.display

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Parameters
p_names = get(model.Parameters,  'Name');
p_value = get(model.Parameters,  'Value');
p_notes = get(model.Parameters,  'notes');
p_units = get(model.Parameters,  'ValueUnits');
par_inf = [p_names, p_value, p_units, p_notes];
par_inf_table = cell2table(par_inf,...
    'VariableNames',{'Parameter' 'Value' 'Units' 'Notes'});
writetable(par_inf_table,'../ModelStructure/parameters.csv');
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Elimination parameters
% variantObj = getvariant(model, 'turnover_var');
% a = get(variantObj,  'Content');
% b = cat(1, a{:});
% p_names = b(:, 2);
% p_value = b(:, 4);
% par_inf = [p_names, p_value];
% par_inf_table = cell2table(par_inf,...
%     'VariableNames',{'Parameter' 'Value'});
% writetable(par_inf_table,'../ModelStructure/turnover_var_parameters.csv');
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Species
species_inf = sbioselect(model.Species, 'Where', 'InitialAmount', '>', 0);
s_names = get(species_inf,  'Name');
s_value = get(species_inf,  'InitialAmount');
s_notes = get(species_inf,  'notes');
s_units = get(species_inf,  'InitialAmountUnits');
s_inf = [s_names, s_value, s_units, s_notes];
par_inf_table = cell2table(s_inf,...
    'VariableNames',{'Species' 'Value' 'Units' 'Notes'});
writetable(par_inf_table,'../ModelStructure/species.csv');
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Species
species_inf = sbioselect(model.Species, 'Where', 'InitialAmount', '==', 0);
s_names = get(species_inf,  'Name');
s_value = get(species_inf,  'InitialAmount');
s_notes = get(species_inf,  'notes');
s_units = get(species_inf,  'InitialAmountUnits');
s_inf = [s_names, s_value, s_units, s_notes];
par_inf_table = cell2table(s_inf,...
    'VariableNames',{'Species' 'Value' 'Units' 'Notes'});
writetable(par_inf_table,'../ModelStructure/species_implicit.csv');
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% All reactions
reactions_equ   = evalc('sbioselect(model.Reactions)');
reactions_equ   = regexprep(reactions_equ,'(\d+)\s\s\s+','$1,');
reaction_equ_txt= textscan(reactions_equ, '%u%s', 'Delimiter',',' , 'headerlines', 6);
reactions_inf   = sbioselect(model.Reactions);
r_names         = get(reactions_inf,  'Name');
r_reactionrate  = get(reactions_inf,  'ReactionRate');
r_notes         = get(reactions_inf,  'Notes');

r_inf           = [reaction_equ_txt{2}];
par_inf_table   = cell2table(r_inf,...
    'VariableNames',{'Reaction'});
writetable(par_inf_table,'../ModelStructure/reactions.csv');

r_inf           = [r_reactionrate];
par_inf_table   = cell2table(r_inf,...
    'VariableNames',{'ReactionRate'});
writetable(par_inf_table,'../ModelStructure/rates.csv');

r_inf           = [reaction_equ_txt{2}, r_reactionrate];
par_inf_table   = cell2table(r_inf,...
    'VariableNames',{'Reaction' 'ReactionRate'});
writetable(par_inf_table,'../ModelStructure/reaction_and_rates.csv');
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Get model ODE in text
ode_equations = getequations(model);
dlmwrite('../ModelStructure/ode.txt',ode_equations ,'delimiter','');
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


end