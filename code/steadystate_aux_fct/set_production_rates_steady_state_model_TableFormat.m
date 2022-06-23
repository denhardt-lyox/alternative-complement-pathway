function model_ss = set_production_rates_steady_state_model_TableFormat(model_in, production_rates_table)
% set production rates for steady state model
% Inputs:
%    model_in - simbiology model
%    production_rates_table - production rates; need to be in table format with row name = ACP species
%                             and a column "Value" with the production rate in uM/s

model_ss  = copyobj(model_in);

%% 
% sort based on row names = Variable names
production_rates_table = sortrows(production_rates_table, 'RowNames');

% define parameters to be set
target_species_names = {production_rates_table.Row{:}};
paramsToSet = cell(length(target_species_names),1);
for i=1:length(target_species_names)
   paramsToSet{i}   = strcat('k_pr_', target_species_names{i});
end

%
const_source_species = sbioselect(model_ss.Species, 'Where', 'Name', '==', 'H2O');
set(const_source_species, 'ConstantAmount', true);

%
production_rates = table2array(production_rates_table(target_species_names, 'Value'));

%
variant_prod   = sbiovariant('Production rates');   
tmp = cell(length(paramsToSet),1);
for i=1:length(paramsToSet) 
    tmp{i} = {'parameter',  paramsToSet{i},...
              'Value',      production_rates(i)};
end
variant_prod.Content = tmp;


%% apply variant
commit(variant_prod, model_ss);

end
