function tableout = get_steady_state_prod_rates_MultipleEst_V2(orig_model, do_fit, save_on, plot_on, ObsLevels, subname, target_species_names, figure_folder_estimation, table_folder)
% do combined fits for multiple production rates at the same time
% uses inividual or previous fits as inital guess - i.e. run individual 
% fitting first to get csv table with inidivdual estimates - not mandatory
% 
% changes to V1: 
% - does not include reduced models -> can only be used with full model
%


%%
model = copyobj(orig_model);


%% Color definitions
h = figure;
colors = get(gca,'colororder');
colors = repmat(colors, 2, 1);
close(h)


%% Definitions
% time points to be fitted
TIME_FIT  = [21 28 126];


%% initial guess
% results from individual fits or from previous runs could be used here
IC = [];


%% define which species to fit
target_species_names = sort(target_species_names);


%% get ICs from model as data to be fitted
data_vec = zeros(length(TIME_FIT), length(target_species_names));
if(isempty(target_species_names))
    target_species = [];
else
    for i=1:length(target_species_names)
    target_species(i) = sbioselect(model.Species, 'Where', 'Name', '==', target_species_names(i));
    data_vec(:,i) = repmat(target_species(i).InitialAmount, length(TIME_FIT), 1);  
    end
end
  

%% define parameters to be estimated
paramsToEstimate = cell(length(target_species),1);
for i=1:length(target_species)
   paramsToEstimate{i}   = strcat('k_pr_', target_species_names{i});
end


%% Fix the other species to constant value 
% Set all the other original species to constant values
% all_source_species = sbioselect(model.Species, 'Where', 'InitialAmount', '>', 0);
% all_source_species_names = cell(length(all_source_species),1);
% for i=1:length(all_source_species)
%     all_source_species_names{i} = all_source_species(i).Name;
% end
% const_source_species_names = setdiff(all_source_species_names, target_species_names);
% const_source_species = sbioselect(model.Species, 'Where', 'Name', '==', const_source_species_names);
% const_source_species = sbioselect(const_source_species, 'Where', 'Name', '~=', 'Surface host'); % exclude surface
% const_source_species = sbioselect(const_source_species, 'Where', 'Name', '~=', {'CR1', 'DAF', 'CD59'}); % exclude surface proteins
% set(const_source_species, 'ConstantAmount', true);

% fix H2O to constant concentration
const_source_species = sbioselect(model.Species, 'Where', 'Name', '==', 'H2O');
set(const_source_species, 'ConstantAmount', true);

set(target_species, 'ConstantAmount', false);


%% Solver options
cs                                     = getconfigset(model);
cs.CompileOptions.UnitConversion       = true;
cs.SolverType                          = 'ode15s'; % stiff solver
cs.SolverOptions.AbsoluteTolerance     = 1e-20;
cs.TimeUnits                           = 'day';
cs.StopTime                            = TIME_FIT(end);
cs.SolverOptions.OutputTimes           = TIME_FIT;

    
%% Define initial guess ( = results of individual/previous fits)       
if(~isempty(IC))
    x0 = table2array(IC(target_species_names, 'Value'));
else
    x0 = repmat(1E-11, length(target_species_names), 1);
end


%% fitting
    if do_fit
        %%% do estimation in log10 space
        logx0 = log10(x0);
        
        %%% lower and upper bound (in log10 space)
        lb = repmat(-14, 1, length(x0));
        ub = [];

        %%% set options and run optimization
        options = optimoptions(@lsqnonlin,'Algorithm','trust-region-reflective'); % use with bounds
%         options = optimoptions(@lsqnonlin,'Algorithm','levenberg-marquardt');
        x = lsqnonlin(@(x)get_steady_state_prod_rates_objetive_function(x,data_vec, model, paramsToEstimate, target_species_names),...
                      logx0, lb, ub, options);

        %%% convert solution to linear space
        x = 10.^x;
    else 
        %%% if no fitting, use intitial guess to simulate
        x = x0;
    end
    

%% simulate with estimated/defined production rates
%%% define variant based on estimated production rates
variant_prod   = sbiovariant('Production rates');   
tmp = cell(length(paramsToEstimate),1);
for i=1:length(paramsToEstimate) 
    tmp{i} = {'parameter',  paramsToEstimate{i},...
              'Value',      x(i)};
end
variant_prod.Content = tmp;

%%% run simulations with fitted time points as output
% cs.SolverOptions.OutputTimes = TIME_FIT;
% fit_simdata    = sbiosimulate(model, [getvariant(model, 'turnover_var_erythrocyte_turnover'),  variant_prod]);
% fit_select     = selectbyname(fit_simdata, target_species_names);
        
%%% run simulations with more time points as output
cs.SolverOptions.OutputTimes = [];       
cs.StopTime    = TIME_FIT(end)*10;
sim_simdata    = sbiosimulate(model, [getvariant(model, 'turnover_var_erythrocyte_turnover'),  variant_prod]);
sim_select     = selectbyname(sim_simdata, target_species_names);


%% Plotting
if(plot_on)
    if(~isempty(target_species_names))
        h = figure;
        h2 = plot(sim_select.Time, sim_select.Data, 'LineWidth', 1.5);
        set(h2, {'color'}, num2cell(colors(1:length(target_species_names),:), 2))
        hold on
        h3 = plot(TIME_FIT, data_vec, '.', 'MarkerSize', 25);
        set(h3, {'color'}, num2cell(colors(1:length(target_species_names),:), 2))
        disp(['species: ', target_species_names])
        grid on
        legend(h2, target_species_names, 'Location', 'EastOutside')
        xlabel('Time (days)',        'FontSize' ,14);
        ylabel('Concentration (uM)', 'FontSize' ,14);
        set(gca,'fontWeight','bold');
        set(gca,'YScale','log');
        set(gca,'Ylim',[1E-2 1E1]);
        set(gca,'fontWeight','bold')    
        if(save_on) 
            NameFile = '';
            for j = 1:length(target_species_names)
                NameFile = [NameFile, '-', target_species_names{j}];
            end
            NameFile = NameFile(2:end);
            NameFile = [NameFile, '_Full-Model'];
            saveas(h, [figure_folder_estimation,'Multiple-Estimate_Full-Model_turnover-var-with-surface-turnover_Fit.png'], 'png')
        end
    end
    
    sim_select	= selectbyname(sim_simdata, {'Ba', 'C3a', 'Bb'});
    h = figure;
    hold on
    l1 = plot(sim_select.Time, sim_select.Data(:,1), 'LineWidth', 1.5, 'Color', colors(1,:));
    l2 = plot(sim_select.Time, sim_select.Data(:,2), 'LineWidth', 1.5, 'Color', colors(2,:));
    l3 = plot(sim_select.Time, sim_select.Data(:,3), '--', 'LineWidth', 1.5, 'Color', colors(3,:));
    l4 = plot(sim_select.Time(end), ObsLevels.Ba_uM, '.', 'MarkerSize', 25, 'Color', colors(1,:));
    l5 = plot(sim_select.Time(end), ObsLevels.C3a_uM,   '.', 'MarkerSize', 23, 'Color', colors(2,:));
    l6 = plot(sim_select.Time(end), ObsLevels.Bb_uM,   '.', 'MarkerSize', 23, 'Color', colors(3,:));
    xlabel(['Time (', sim_select.TimeUnits,')'], 'FontSize' ,14);
    ylabel(['Concentration (uM)'], 'FontSize' ,14);
    set(gca,'fontWeight','bold');
    grid on
    set(gca,'YScale', 'log')
    ylim([1E-4 1E1])
    legend([l1 l2 l3 l4(1) l5(1) l6(1)], 'Ba', 'C3a', 'Bb', 'Ba (obs. plasma)', 'C3a (obs. plasma)',...
                                        'Bb (obs. plasma)','Location', 'NorthWest')
    set(gca,'fontWeight','bold')
    if(save_on) 
        saveas(h, [figure_folder_estimation,'Multiple-Estimate_Full-Model_turnover-var-with-surface-turnover_Ba-C3a-Bb.png'], 'png')
    end
    
   sim_select	= selectbyname(sim_simdata, {'Percent_Lysis_Takeda', 'Percent_Lysis_Kolb'});
    h = figure;
    hold on
    l1 = plot(sim_select.Time, sim_select.Data(:,1), 'LineWidth', 1.5, 'Color', colors(1,:));
    l2 = plot(sim_select.Time, sim_select.Data(:,2), 'LineWidth', 1.5, 'Color', colors(2,:));
    xlabel(['Time (', sim_select.TimeUnits,')'], 'FontSize' ,14);
    ylabel(['Hemolysis (%)'], 'FontSize' ,14);
    set(gca,'fontWeight','bold');
    grid on
    ylim([0 100])
    set(gca,'fontWeight','bold')
    if(save_on) 
        saveas(h, [figure_folder_estimation,'Multiple-Estimate_Full-Model_turnover-var-with-surface-turnover_Lysis.png'], 'png')
    end
    
    sim_select	= selectbyname(sim_simdata, {'Erythrocytes_uM'});
    h = figure;
    hold on
    l1 = plot(sim_select.Time, sim_select.Data(:,1), 'LineWidth', 1.5, 'Color', colors(1,:));
    xlabel(['Time (', sim_select.TimeUnits,')'], 'FontSize' ,14);
    ylabel(['Er (uM)'], 'FontSize' ,14);
    set(gca,'fontWeight','bold');
    grid on
    set(gca,'fontWeight','bold')
    
    
    sim_select	= selectbyname(sim_simdata, {'Erythrocytes_uM', 'MAC host'});
    h = figure;
    hold on
    l1 = plot(sim_select.Time, sim_select.Data(:,2) ./ sim_select.Data(:,1), 'LineWidth', 1.5, 'Color', colors(1,:));
    xlabel(['Time (', sim_select.TimeUnits,')'], 'FontSize' ,14);
    ylabel(['MAC (per cell)'], 'FontSize' ,14);
    set(gca,'fontWeight','bold');
    grid on
    set(gca,'fontWeight','bold')
    if(save_on) 
        saveas(h, [figure_folder_estimation,'Multiple-Estimate_Full-Model_turnover-var-with-surface-turnover_MACperCell.png'], 'png')
    end    
end

%% write estimates to csv table
tableout = x;
tableout = num2cell(tableout);
tableout = cell2table(tableout,...
    'VariableNames',{'Value'}, ...
    'RowNames', target_species_names(:));
if(do_fit && save_on)
    writetable(tableout, [table_folder, 'Production-Rates-Estimation_Full-Model_turnover-var-with-surface-turnover_', datestr(datetime('today')),'.csv'], 'WriteVariableNames', true, ...
        'WriteRowNames', true);
end
end