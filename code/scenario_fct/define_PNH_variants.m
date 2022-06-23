function model = define_PNH_variants(model, fold_red_PNH_Type2, fold_red_PNH_Mix)

%% Get production rates of DAF and CD59
% Make a copy of the original model
copiedModel = copyobj(model);

% Extract and apply turnover variant
variant = sbioselect(copiedModel, 'Where', 'Name', '==', 'turnover_var_erythrocyte_turnover');
commit(variant, copiedModel);

% Extract production rates
pr.DAF  = get(sbioselect(copiedModel.Parameters, 'Where', 'Name', '==', 'k_pr_DAF'), 'Value');
pr.CD59 = get(sbioselect(copiedModel.Parameters, 'Where', 'Name', '==', 'k_pr_CD59'), 'Value');

% Delete changed model
delete(copiedModel)

%% Define PNH variants
% Add a variant for PNH type 2
PNH_Type_2 = sbiovariant('PNH_Type_2',...
     'Notes', 'PNH Type 2 - This variant has reduced production rates for DAF and CD59');
addcontent(PNH_Type_2, {'parameter', 'k_pr_CD59', 'Value', pr.CD59 / fold_red_PNH_Type2});
addcontent(PNH_Type_2, {'parameter', 'k_pr_DAF',  'Value', pr.DAF / fold_red_PNH_Type2});
addvariant(model, PNH_Type_2);

% Type 3
PNH_Type_3 = sbiovariant('PNH_Type_3',...
     'Notes', 'PNH Type 3 - This variant has disabled production rates for DAF and CD59');
addcontent(PNH_Type_3, {'parameter', 'k_pr_CD59', 'Value', 0});
addcontent(PNH_Type_3, {'parameter', 'k_pr_DAF',  'Value', 0});
addvariant(model, PNH_Type_3);

% Mix
PNH_Type_Mix = sbiovariant('PNH_Type_Mix',...
     'Notes', 'PNH Type 2 & 3 mix');
addcontent(PNH_Type_Mix, {'parameter', 'k_pr_CD59', 'Value', pr.CD59 / fold_red_PNH_Mix});
addcontent(PNH_Type_Mix, {'parameter', 'k_pr_DAF',  'Value', pr.DAF / fold_red_PNH_Mix});
addvariant(model, PNH_Type_Mix);

end