function F = get_steady_state_prod_rates_objetive_function(x, data_vec, model, paramsToEstimate, target_species_names)
% function calculates difference between expected and simulated level for 
% variable inputs of ACP species

%%
% define a simbiology variant with the corresponding procution rate(s) 
% that should be estimated

% new variant
variant_prod   = sbiovariant('Production rates');   

% define parameter name based on input and value based on current estimate
tmp = cell(length(paramsToEstimate),1);
for i=1:length(paramsToEstimate)
    tmp{i} = {'parameter',  paramsToEstimate{i},...
              'Value',      10^x(i)};
end
% assign content to variant
variant_prod.Content = tmp;


%% simulate
fit_simdata  = sbiosimulate(model, [getvariant(model, 'turnover_var_erythrocyte_turnover'),  variant_prod]);
fit_select   = selectbyname(fit_simdata, target_species_names);

%% compute difference between simulation and expected value 
F = data_vec - fit_select.Data;
F = F(:);

% display current deviation from data
disp(['F^2: ', num2str(F'*F)])

end
