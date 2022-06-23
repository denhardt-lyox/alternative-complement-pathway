function tableout = get_steady_state_prod_rates_MultipleEst_V2(orig_model, do_fit, save_on, plot_on, ObsLevels, subname, target_species_names)
% do combined fits for multiple production rates at the same time
% uses inividual or previous fits as inital guess - i.e. run individual 
% fitting first to get csv table with inidivdual estimates
% 
% changes to V1: 
% - does not include reduced models -> can only be used with full model
% 
% changes to V2:
% - includes estimation of surface species

%%
model = copyobj(orig_model);


%% Table folder - output of Tables with estimated production rates
table_folder  = '../Tables/';
mkdir(table_folder)


%% Color definitions
h = figure;
colors = get(gca,'colororder');
colors = repmat(colors, 3, 1);
close(h)


%% Definitions
% TIME_FIT  = [21 28 126];
TIME_FIT  = [21 28 53];


 %% load results of inidividual/previous fits for usage as initial guesses
% try
%     IC = readtable('../Tables/ParamEst_ProdRates_Multiple-Est_B-C3-C5-C6-C7-C8-C9-Cn-D-H-I-P-Vn_Full-Model_Reduced-Tickover_Reduced-SurfAssociation.csv',...
%         'ReadVariableNames',true,...
%         'ReadRowNames',true);
% catch
    IC = [];
% end
% 
% k_el_erythrocyte = log(2) / (60 * 24 * 60 * 60); % in 1/second
% 
% ICnew = IC(1:3,1);
% ICnew.Row{1} = 'CR1';
% ICnew.Row{2} = 'CD59';
% ICnew.Row{3} = 'DAF';
% 
% ICnew.Value(1) = k_el_erythrocyte * 0.0083*1E-6;
% ICnew.Value(2) = k_el_erythrocyte * 0.21*1E-6;
% ICnew.Value(3) = k_el_erythrocyte * 0.027*1E-6;
% 
% par = sbioselect(model.Parameters, 'Where', 'Name', '==', 'k_el_SurfaceProtein'); 
% par.Value = k_el_erythrocyte;
% par = sbioselect(model.Parameters, 'Where', 'Name', '==', 'k_el_CR1');
% par.Value = k_el_erythrocyte;
% par = sbioselect(model.Parameters, 'Where', 'Name', '==', 'k_el_CD59');
% par.Value = k_el_erythrocyte;
% par = sbioselect(model.Parameters, 'Where', 'Name', '==', 'k_el_DAF'); 
% par.Value = k_el_erythrocyte;
% 
% IC = [IC;ICnew];
    
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

% following code in principle not needed anymore - kept for debugging:
% data        = array2table(data_vec);
% for i=1:length(target_species)
%     data.Properties.VariableNames(i) = cellstr(target_species(i).Name);
% end
  

%% define parameters to estimate
paramsToEstimate = cell(length(target_species),1);
for i=1:length(target_species)
   paramsToEstimate{i}   = strcat('k_pr_', target_species_names{i});
end


%% Fix the other species to constant value 
% Set concentration of H2O as constant
const_source_species = sbioselect(model.Species, 'Where', 'Name', '==', 'H2O');
set(const_source_species, 'ConstantAmount', true);



% all_source_species = sbioselect(model.Species, 'Where', 'InitialAmount', '>', 0);
% all_source_species_names = cell(length(all_source_species),1);
% for i=1:length(all_source_species)
%     all_source_species_names{i} = all_source_species(i).Name;
% end
% const_source_species_names = setdiff(all_source_species_names, target_species_names);
% const_source_species = sbioselect(model.Species, 'Where', 'Name', '==', const_source_species_names);
% const_source_species = sbioselect(const_source_species, 'Where', 'Name', '~=', 'Surface host'); % exclude surface
% % const_source_species = sbioselect(const_source_species, 'Where', 'Name', '~=', {'CR1', 'DAF', 'CD59'}); % exclude surface proteins
% set(const_source_species, 'ConstantAmount', true);
% set(target_species, 'ConstantAmount', false);


    
% set(target_species, 'InitialAmount', 0);
% set(target_species, 'InitialAmount', 100);


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
    
    
%% if production rates should be set manually
% if(~do_fit && reduced_model == 1)
%     x = table2array(IC2.B_C3_Estimates(target_species_names, 'Value'));
%     % x(1) = 7.083386773889963e-09;
%     % x(2) = 1.766630414387007e-09;
% end

% if(~do_fit && ~reduced_model)
%     x = table2array(IC1.B_C3_Estimates(target_species_names, 'Value'));
% %     x(1) =  9.366610032887420e-11 * 2; 
% %     x(2) = 2.124158101552332e-09;
% end


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
% fit_simdata    = sbiosimulate(model, [getvariant(model, 'turnover_var_with_surface_turnover'),  variant_prod]);
% fit_select     = selectbyname(fit_simdata, target_species_names);
        
%%% run simulations with more time points as output
cs.SolverOptions.OutputTimes = [];       
cs.StopTime    = TIME_FIT(end);
sim_simdata    = sbiosimulate(model, [getvariant(model, 'turnover_var_with_surface_turnover'),  variant_prod]);
sim_select     = selectbyname(sim_simdata, target_species_names);


%% Plotting - full model
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
        set(gca,'Ylim',[1E-3 1E1]);
        set(gca,'fontWeight','bold')    
        if(save_on) 
            NameFile = '';
            for j = 1:length(target_species_names)
                NameFile = [NameFile, '-', target_species_names{j}];
            end
            NameFile = NameFile(2:end);
            NameFile = [NameFile, '_Full-Model'];
            saveas(h, ['../Figures/Figures_steadystate-model-prodTerms/Multiple_Estimates/Full-Model',subname,'_Fit.png'], 'png')
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
        saveas(h, ['../Figures/Figures_steadystate-model-prodTerms/Multiple_Estimates/Full-Model',subname,'_Ba-C3a-Bb.png'], 'png')
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
        saveas(h, ['../Figures/Figures_steadystate-model-prodTerms/Multiple_Estimates/Full-Model',subname,'_Lysis.png'], 'png')
    end
    
    cells_uM = get(sbioselect(model,'Type','Species','Where','Name', '==', 'Erythrocytes_uM'), 'InitialAmount');    

    sim_select	= selectbyname(sim_simdata, {'MAC host'});
    h = figure;
    hold on
    l1 = plot(sim_select.Time, sim_select.Data(:,1) ./ cells_uM, 'LineWidth', 1.5, 'Color', colors(1,:));
    xlabel(['Time (', sim_select.TimeUnits,')'], 'FontSize' ,14);
    ylabel(['MAC (per cell)'], 'FontSize' ,14);
    set(gca,'fontWeight','bold');
    grid on
    set(gca,'fontWeight','bold')
    if(save_on) 
        saveas(h, ['../Figures/Figures_steadystate-model-prodTerms/Multiple_Estimates/Full-Model',subname,'_MACperCell.png'], 'png')
    end
    
%     sim_select	= selectbyname(sim_simdata, {'CD59C5b9_1 host'});
%     h = figure;
%     hold on
%     l1 = plot(sim_select.Time, sim_select.Data(:,1), 'LineWidth', 1.5, 'Color', [0 0 1]);
% %     l2 = plot(sim_select.Time, sim_select.Data(:,2), 'LineWidth', 1.5, 'Color', [0 1 1]);
%     xlabel(['Time (', sim_select.TimeUnits,')'], 'FontSize' ,14);
%     ylabel(['Conc fluid (uM)'], 'FontSize' ,14);
%     set(gca,'fontWeight','bold');
%     grid on
%     set(gca,'fontWeight','bold')
    
    
%     sim_select	= selectbyname(sim_simdata, {'Surface host'});
%     h = figure;
%     hold on
%     l1 = plot(sim_select.Time, sim_select.Data(:,1), 'LineWidth', 1.5, 'Color', [0 0 1]);
%     xlabel(['Time (', sim_select.TimeUnits,')'], 'FontSize' ,14);
%     ylabel(['Surface'], 'FontSize' ,14);
%     set(gca,'fontWeight','bold');
%     grid on
%     set(gca,'fontWeight','bold')
    
%       names = {'C3bBb host', 'C3bBbC3b host', 'C3bBbC3bCR1 host', 'C3b host', 'C3bBbC3bDAF host',...
%         'C3bBbC3bH host', 'C3bBbP host', 'C3bBbC3bP host', 'C3bBP host', 'iC3b host',...
%         'iC3bP host', 'C3bBbC3bPC5 host', 'C3bBbC3bC5 host', 'C3bBbC3bPC5b host', 'C3bBbC3bC5b host',...
%         'C3bBbC3bPC5bC6 host', 'C3bBbC3bC5bC6 host', 'C5b7 host', 'C3bCR1 host',...
%         'C3bH host', 'C3bB host', 'C3bBbH host', 'C3bBbCR1 host', 'C3bBbDAF host'...
%         'iC3bCR1 host', 'C3dg host', 'C5b8 host', 'C5b9_1 host', 'C5b9_2 host'...
%         'C5b9_3 host', 'C5b9_4 host', 'C5b9_5 host', 'C5b9_6 host', 'C5b9_7 host'...
%         'C5b9_8 host', 'C5b9_9 host', 'C5b9_10 host', 'C5b9_11 host', 'C5b9_12 host'...
%         'C5b9_13 host', 'C5b9_14 host', 'C5b9_15 host', 'C5b9_16 host', 'C5b9_17 host'...
%         'MAC host', 'CD59C5b9_1 host'};
%     sim_select	= selectbyname(sim_simdata, names);
%     endvalues = sim_select.Data(end,:);
%     [maxv1, index1] = max(endvalues);
%     endvalues(index1) = -inf;
%     [maxv2, index2] = max(endvalues);
%     endvalues(index2) = -inf;
%     [maxv3, index3] = max(endvalues);
% %     names{[index1, index2, index3]}
%     disp([names{index1}, ', ', names{index2}, ', ', names{index3}])
%     disp([num2str(maxv1), ', ', num2str(maxv2), ', ', num2str(maxv3)])
%     sim_select	= selectbyname(sim_simdata, {'Surface host', names{:}});
%     h = figure;
%     hold on
%     l1 = plot(sim_select.Time, sim_select.Data);
%     xlabel(['Time (', sim_select.TimeUnits,')'], 'FontSize' ,14);
%     ylabel(['Concentration (uM)'], 'FontSize' ,14);
%     set(gca,'fontWeight','bold');
%     grid on
%     set(gca,'fontWeight','bold')
        
%         sim_select	= selectbyname(sim_simdata, {'hC5b7 fluid', 'C5b7 host'});
%     h = figure;
%     hold on
%     l1 = plot(sim_select.Time, sim_select.Data(:,1), 'LineWidth', 1.5, 'Color', [0 0 1]);
%     l1 = plot(sim_select.Time, sim_select.Data(:,2), '--', 'LineWidth', 1.5, 'Color', [0 1 1]);
%     xlabel(['Time (', sim_select.TimeUnits,')'], 'FontSize' ,14);
%     ylabel(['Conc fluid (uM)'], 'FontSize' ,14);
%     set(gca,'fontWeight','bold');
%     grid on
%     set(gca,'fontWeight','bold')
       
%         sim_select	= selectbyname(sim_simdata, {'C3dg host', 'C3dg fluid'});
%     h = figure;
%     hold on
%     l1 = plot(sim_select.Time, sim_select.Data(:,1), 'LineWidth', 1.5, 'Color', [0 0 1]);
%     l2 = plot(sim_select.Time, sim_select.Data(:,2), 'LineWidth', 1.5, 'Color', [0 1 1]);    
%     xlabel(['Time (', sim_select.TimeUnits,')'], 'FontSize' ,14);
%     ylabel(['Concentration (uM)'], 'FontSize' ,14);
%     set(gca,'fontWeight','bold');
%     grid on
%     set(gca,'YScale', 'log')
%     ylim([1E-4 1E1])
%     set(gca,'fontWeight','bold')
%     leg = legend('C3dg host', 'C3dg fluid', 'Location', 'SouthEast');
%     set(leg, 'Interpreter', 'none')
        
%     sim_select	= selectbyname(sim_simdata, {'C3b_nfC3b_host', 'C3b_nfC3b_H2O'});
%     h = figure;
%     hold on
%     l1 = plot(sim_select.Time, sim_select.Data(:,1), 'LineWidth', 1.5, 'Color', [0 0 1]);
%     l2 = plot(sim_select.Time, sim_select.Data(:,2), 'LineWidth', 1.5, 'Color', [0 1 1]);    
%     xlabel(['Time (', sim_select.TimeUnits,')'], 'FontSize' ,14);
%     ylabel(['Concentration (uM)'], 'FontSize' ,14);
%     set(gca,'fontWeight','bold');
%     grid on
%     set(gca,'YScale', 'log')
%     ylim([1E-2 1E3])
%     set(gca,'fontWeight','bold')
%     leg = legend('C3b_nfC3b_host', 'C3b_nfC3b_H2O', 'Location', 'SouthEast');
%     set(leg, 'Interpreter', 'none')
%         sim_select.Data(end,2) / sim_select.Data(end,1)
        
%    sim_select	= selectbyname(sim_simdata, {'C3b_nfC3b_host', 'C3b_nhC3b_host'});
%     h = figure;
%     hold on
%     l1 = plot(sim_select.Time, sim_select.Data(:,1), 'LineWidth', 1.5, 'Color', [0 0 1]);
%     l2 = plot(sim_select.Time, sim_select.Data(:,2), 'LineWidth', 1.5, 'Color', [0 1 1]);    
%     xlabel(['Time (', sim_select.TimeUnits,')'], 'FontSize' ,14);
%     ylabel(['Concentration (uM)'], 'FontSize' ,14);
%     set(gca,'fontWeight','bold');
%     grid on
%     set(gca,'YScale', 'log')
%     ylim([1E-2 1E3])
%     set(gca,'fontWeight','bold')
%     leg = legend('C3b_nfC3b_host', 'C3b_nhC3b_host', 'Location', 'SouthEast');
%     set(leg, 'Interpreter', 'none')
% %     if(save_on) 
% %         saveas(h, '../Figures/Figures_steadystate-model-prodTerms/Multiple_Estimates/B-C3_Full-Model_Lysis.png', 'png')
% %     end
%         sim_select.Data(end,2) / sim_select.Data(end,1)

%     sim_select	= selectbyname(sim_simdata, {'C3bBbP host'});
%     h = figure;
%     hold on
%     plot(sim_select.Time, sim_select.Data(:,1), 'LineWidth', 1.5, 'Color', [0 0 1])
%     xlabel(['Time (', sim_select.TimeUnits,')'], 'FontSize' ,14);
%     ylabel(['Concentration (uM)'], 'FontSize' ,14);
%     set(gca,'fontWeight','bold');
%     grid on
%     set(gca,'YScale', 'log')
%     ylim([1E-10 1E1])
      
%     sim_select	= selectbyname(sim_simdata, {'iC3bCR1 fluid'});
%     h = figure;
%     hold on
%     plot(sim_select.Time, sim_select.Data(:,1), 'LineWidth', 1.5, 'Color', [0 0 1])
% %     plot(sim_select.Time, sim_select.Data(:,2), 'LineWidth', 1.5, 'Color', [0 1 1])
% %     plot(sim_select.Time(end), 0.97E-3, '.', 'MarkerSize', 25, 'Color', [0 0 1])
% %     plot(sim_select.Time(end), 17E-3,   '.', 'MarkerSize', 25, 'Color', [0 1 1])
%     xlabel(['Time (', sim_select.TimeUnits,')'], 'FontSize' ,14);
%     ylabel(['Concentration (uM)'], 'FontSize' ,14);
%     set(gca,'fontWeight','bold');
%     grid on
%     set(gca,'YScale', 'log')
%     ylim([1E-4 1E1])
    
end

%% write estimates to csv table
if(do_fit && save_on)
    tableout = x;
    tableout = num2cell(tableout);
    tableout = cell2table(tableout,...
        'VariableNames',{'Value'}, ...
        'RowNames', target_species_names(:));
    writetable(tableout, [table_folder, 'ParamEst_ProdRates_Full-Model', subname,'.csv'], 'WriteVariableNames', true, ...
        'WriteRowNames', true);
end
end