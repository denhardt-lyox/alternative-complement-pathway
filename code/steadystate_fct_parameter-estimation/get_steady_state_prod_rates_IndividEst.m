function get_steady_state_prod_rates_IndividEst(model, do_fit, save_on, figure_folder_estimation, table_folder)
% function does inidividual fits for each production rate in the model
% while keeping the other species automatically fixed to their initial
% value
% surface turnover is not implemented in this model version!


%% definitions
TIME_FIT      = 126;
OUTPUT_TIMES  = [1 2 3 4 5 6 7 14 21 28 TIME_FIT];


%% Solver options
cs                               	= getconfigset(model);
cs.CompileOptions.UnitConversion  	= true;
cs.SolverType                     	= 'ode15s'; % stiff solver
cs.SolverOptions.AbsoluteTolerance	= 1e-18;
cs.TimeUnits                       	= 'day';
cs.StopTime                         = TIME_FIT;
    
    
%% define which species to fit
target_species_names = {'B', 'D', 'P', 'C3', 'C5', 'C6', 'C7', 'C8', 'C9'};
res                  = struct();


%% loop over all species to be fitted
t1 = tic;
for i = 1:length(target_species_names)
    % get IC from model as data to be fitted
    names           = target_species_names(i);
    target_species  = sbioselect(model.Species, 'Where', 'Name', '==', names);
    data_vec        = repmat(target_species.InitialAmount, length(OUTPUT_TIMES), 1);  
    

    %% define parameters to estimate
    paramsToEstimate        = cell(length(target_species),1);
    for j=1:length(target_species)
       paramsToEstimate{j}	= strcat('k_pr_', names{j});
    end
    
    
    %% Fix the non-fitted species to constant value
    % find all species with an IC > 0
    all_source_species          = sbioselect(model.Species, 'Where', 'InitialAmount', '>', 0);
    all_source_species_names    = cell(length(all_source_species),1);
    
    % get species names
    for j=1:length(all_source_species)
        all_source_species_names{j} = all_source_species(j).Name;
    end
    % get names from species that should be held constant and select
    const_source_species_names  = setdiff(all_source_species_names, names); 
    const_source_species        = sbioselect(model.Species, 'Where', 'Name', '==', const_source_species_names);
    % fix constant species to their constant amount while keeping fitted
    % species flexible
    set(const_source_species, 'ConstantAmount', true);
    set(target_species,       'ConstantAmount', false);

    % for stability reasons, set initial amount of fitted species to 0
    IA = get(target_species, 'InitialAmount');
    set(target_species,      'InitialAmount', 0);


    %% Optimization 
    if(do_fit)
        %%% initial guess
        x0          = repmat(8E-9,1,length(paramsToEstimate));
        x0_log10    = log10(x0); % do estimation in log10 space

        %%% unconstrained optimization
        LB = [];
        UB = []; 

        %%% optimization
        cs.SolverOptions.OutputTimes	= OUTPUT_TIMES;
        options                         = optimoptions(@lsqnonlin,'Algorithm','trust-region-reflective');
        x = lsqnonlin(@(x)get_steady_state_prod_rates_objetive_function_individual_estimates(x,data_vec, model, paramsToEstimate, names), x0_log10, LB, UB, options);  

        %%% convert solution to linear space 
        x = 10.^x;
        
    else
        x = table2array(IC.IndividEstimates(names, 'Value'));
    end
    
    %%% define a variant with the estimated production rates for simulations
    variant_prod	= sbiovariant('Production rates');   
    tmp             = cell(length(paramsToEstimate),1);
    for j=1:length(paramsToEstimate) 
        tmp{j} = {'parameter',  paramsToEstimate{j},...
                  'Value',      x(j)};
    end
    variant_prod.Content = tmp;
    
    %%% simulate and plot with estimated parameter
    cs.SolverOptions.OutputTimes	= OUTPUT_TIMES;
    fit_simdata                  = sbiosimulate(model, [getvariant(model, 'turnover_var_no_surface_turnover'),  variant_prod]);
    fit_select                   = selectbyname(fit_simdata, names);
    
    percent = 100 ./ data_vec(:)' .* fit_select.Data(:)';
    disp(['fit (%): ', num2str(percent)])

    cs.SolverOptions.OutputTimes = [];
    fit_simdata                  = sbiosimulate(model, [getvariant(model, 'turnover_var_no_surface_turnover'),  variant_prod]);
    fit_select                   = selectbyname(fit_simdata, names);
    
    %%% plotting
    h = figure;
    semilogy(fit_select.Time, fit_select.Data, 'LineWidth', 1.5, 'Color', [0 0 0])
    hold on
    semilogy(OUTPUT_TIMES, data_vec, '.', 'Color', [0 0 0], 'MarkerSize', 25)
    xlabel(['Time (', fit_select.TimeUnits,')'], 'FontSize' ,14);
    ylabel([target_species_names{i}, ' (uM)'], 'FontSize' ,14);
    set(gca,'fontWeight','bold');
    grid on
    ylim([1E-2 1E1])
    if(save_on)
        saveas(h, [figure_folder_estimation, 'Individ-Estimate_', target_species_names{i},'.png'], 'png')
    end
    drawnow

    sim_select                   = selectbyname(fit_simdata, {'C3a', 'C5a', 'Ba'});
    h = figure;
    hold on
    plot(sim_select.Time, sim_select.Data(:,1), 'LineWidth', 1.5, 'Color', [0 0 1])
    plot(sim_select.Time, sim_select.Data(:,2), 'LineWidth', 1.5, 'Color', [0 1 1])
    plot(sim_select.Time, sim_select.Data(:,3), 'LineWidth', 1.5, 'Color', [0 0.5 0.5])
    xlabel(['Time (', fit_select.TimeUnits,')'], 'FontSize' ,14);
    ylabel(['Concentration (uM)'], 'FontSize' ,14);
    set(gca,'fontWeight','bold');
    grid on
    set(gca,'YScale', 'log')
    ylim([1E-4 1E1])
    legend('C3a', 'C5a', 'Ba', 'Location', 'NorthWest')
    if(save_on)
        saveas(h, [figure_folder_estimation, 'Individ-Estimate_', target_species_names{i},'_C3a-C5a-Ba.png'], 'png')
    end
    
    sim_select                   = selectbyname(fit_simdata, {'Percent_Lysis_Takeda', 'Percent_Lysis_Kolb'});
    h = figure;
    hold on
    fill([sim_select.Time' fliplr(sim_select.Time')], [sim_select.Data(:,1)' fliplr(sim_select.Data(:,2)')],...
        [0 0 0], 'FaceAlpha', 0.4)
    xlabel(['Time (', fit_select.TimeUnits,')'], 'FontSize' ,14);
    ylabel(['Hemolysis (%)'], 'FontSize' ,14);
    set(gca,'fontWeight','bold');
    grid on
    xlim([0 10])
    ylim([0 100])
    if(save_on)
        saveas(h, [figure_folder_estimation, 'Individ-Estimate_', target_species_names{i},'_Lysis.png'], 'png')
    end
    
    %%%
    sim_select	= selectbyname(fit_simdata, {'B', 'Ba', 'C3', 'C3a', 'C5', 'C5a'});
    Percent.Ba  = 100/sim_select.Data(end,1) * sim_select.Data(end,2);
    Percent.C3a = 100/sim_select.Data(end,3) * sim_select.Data(end,4);
    Percent.C5a = 100/sim_select.Data(end,5) * sim_select.Data(end,6);
    disp(['Percent Ba of B: ', num2str(Percent.Ba)])
    disp(['Percent C3a of C3: ', num2str(Percent.C3a)])
    disp(['Percent C5a of C5: ', num2str(Percent.C5a)])
    
    %%% reset to original value
    set(target_species, 'InitialAmount', IA);

    %%% store estimates in output structure
    res.Name(i,1)    = names;
    res.Val(i,1)     = x;
    res.Percent(i,:) = percent;
    
    close all
end
toc(t1)

%% write estimates to csv table
if(do_fit)
    tableout = [res.Val, res.Percent];
    tableout = num2cell(tableout);
    tmp = repmat({'Percent_Match'}, 1, length(OUTPUT_TIMES));
    for i = 1:length(tmp)
        tmp{i} = [tmp{i}, '_tp', num2str(OUTPUT_TIMES(i))];
    end
    tableout = cell2table(tableout,...
        'VariableNames',{'Value', tmp{:}}, ...
        'RowNames', target_species_names(:));

    writetable(tableout, [table_folder, 'Production-Rates-Estimation_Individual-Estimates_', datestr(datetime('today')),'.csv'], 'WriteVariableNames', true, ...
        'WriteRowNames', true);
end

end