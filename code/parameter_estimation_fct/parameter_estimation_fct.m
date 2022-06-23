function obj_value = parameter_estimation_fct(model, run_argument, varargin)
% function to test feasibility of parameter sampling

%% input parser
p = inputParser;

% List with parameters to be estimated - currently used to loop over these
% parameters
default.ParList       = [];
default.loop_start    = 1;
default.loop_end      = 1;
default.Fit_Thanassi  = 0;
default.Fit_Schreiber = 0;
default.Fit_Lesavre   = 0;
default.Data          = [];

% add inputs and check validity of formats
addRequired(p,  'model',                                @(x) strcmp(class(x), 'SimBiology.Model'));
addRequired(p,  'run_argument',                         @(x) isstruct(x) & all(isfield(x, {'SimPlot', ...
                                                                              'IterEst', 'ParallelEst'})));
addParameter(p, 'ParList',       default.ParList,       @(x) strcmp(class(x), 'SimBiology.Parameter') | isempty(x));
addParameter(p, 'loop_start',    default.loop_start,    @(x) isnumeric(x));
addParameter(p, 'loop_end',      default.loop_end,      @(x) isnumeric(x));
addParameter(p, 'Fit_Thanassi',  default.Fit_Thanassi,  @(x) isnumeric(x));
addParameter(p, 'Fit_Schreiber', default.Fit_Schreiber, @(x) isnumeric(x));
addParameter(p, 'Fit_Lesavre',   default.Fit_Lesavre,   @(x) isnumeric(x));
addParameter(p, 'Data',          default.Data,          @(x) isstruct(x) | isempty(x));

% parse results
parse(p, model, run_argument, varargin{:})

% extract frequently used variables for ease of handling
model       = p.Results.model;
ParList     = p.Results.ParList;
Run_Arg     = p.Results.run_argument;
loop_start  = p.Results.loop_start;
loop_end    = p.Results.loop_end;
data        = p.Results.Data;

%% Determine which datasets to fit
settings.Fit_Thanassi  = p.Results.Fit_Thanassi;
settings.Fit_Schreiber = p.Results.Fit_Schreiber;
settings.Fit_Lesavre   = p.Results.Fit_Lesavre;


%% set default variables
%%% Identfiy whether iterative parameter estimation should be run
if(Run_Arg.IterEst.Fminbnd == 1 || Run_Arg.IterEst.Fminsearch == 1)
    Run_Arg.loop_logical = 1;
else 
    Run_Arg.loop_logical = 0;
end   
    
%%% Check that if iterative parameter est. should be run, a parameter list
%%% has been provided
if(Run_Arg.loop_logical == 1)
    if(isempty(ParList))
        msg = ['Error - you need to provide a parameter list to run the ',...
               'iterative parameter estimation loop'];
       error (msg)
    end
end

%%% Number of cores for parallel toolbox
n_cores  = 6;

%% QC
if Run_Arg.ParallelEst.PSO == 1 && Run_Arg.loop_logical == 1
    msg = ['Running PSO and parameter looping not implemented - ',...
         'One of the options has to be disabled. Function will stop now.'];
    error(msg)
end
    
%% load data
if(isempty(data))
    data = load_data_Ferreira_2007([]);
    data = load_data_Lesher_2013(data);
    data = load_data_Wilcox_1991(data);
    data = load_data_Pangburn_2002(data);
    data = load_data_Wu_2018(data);
    data = load_data_Thanassi_2016(data);
    data = load_data_Biesma_2001(data);
    data = load_data_Schreiber_1978(data);
    data = load_data_Lesavre_1978(data);
end


%% define which parameters to fit
if(Run_Arg.loop_logical == 0)
    %%%%%
%     settings.parameters_to_be_fitted = {
%         'k_p_C3b_surface',...
%         'k_p_hC3b',...
%         'k_p_C3bBbDAF',...
%         'k_p_CD59C5b9',...
%         'k_C5_cat_C3bBbC3b',...
%         'K_C3_m_C3bBbP'};

%     init_guess(1,1) = 4.2e8 * 1E6;
%     init_guess(1,2) = 4.2E8 * 1E4;
%     init_guess(1,3) = 2.0e3 * 1.25E5;
%     init_guess(1,4) = 1.0e6 * 2E5;
%     init_guess(1,5) = 0.003;
%     init_guess(1,6) = 1.8e-6;


    %%%%%
%     settings.parameters_to_be_fitted = {
%         'k_p_C3b_surface',...
%         'k_p_hC3b',...
%         'k_p_C3bBbDAF',...
%         'k_p_CD59C5b9',...
%         'k_C5_cat_C3bBbC3b',...
%         'K_C3_m_C3bBbP',...
%         'K_C5_m_C3bBbC3b'};
%     
%     % init_guess(1,1) = 4.2e8 * 1E6;
%     % init_guess(1,2) = 4.2E8 * 1E4;
%     % init_guess(1,3) = 2.0e3 * 1.25E5;
%     % init_guess(1,4) = 1.0e6 * 2E5;
%     % init_guess(1,5) = 0.003;
%     % init_guess(1,6) = 1.8e-6;
%     % init_guess(1,7) = 0.016e-6;
%     init_guess(1,:) = [4.2E15, 5.2E10, 2E9, 1.7E12, 3, 6.6E-6, 0.016e-6];

   if(isempty(ParList))
        settings.parameters_to_be_fitted = {
            'k_p_C3b_surface',...
            'k_p_hC3b',...
            'k_p_CD59C5b9',...
            'k_p_C3bP',...
            'k_p_C3bBbDAF',...
            'K_C3_m_C3(H2O)Bb'};
   else
       settings.parameters_to_be_fitted = get(ParList, 'Name');
   end

elseif(Run_Arg.loop_logical == 1)
    for i = 1:length(ParList)
        ParList_Names{i} = ParList(i).Name;
        ParList_Values(i) = ParList(i).Value;
    end
    
   loop_res.iRun    = nan(1,length(ParList_Values));
   loop_res.par     = cell(1,length(ParList_Values));
   loop_res.fval    = nan(1,length(ParList_Values));
   loop_res.parval  = nan(1,length(ParList_Values));
   loop_res.parinit = nan(1,length(ParList_Values));
   loop_res.ub      = nan(1,length(ParList_Values));
   loop_res.lb      = nan(1,length(ParList_Values));
end

      

for iloop = loop_start:loop_end
    if Run_Arg.loop_logical == 1
        %%% get parameter to be estimated + its inital guess
        settings.parameters_to_be_fitted = {};
        settings.parameters_to_be_fitted = {ParList_Names{iloop}};           
        init_guess                       =  ParList_Values(iloop);      
        
        %%% display current status
        disp(['Parameter Name :', settings.parameters_to_be_fitted])
        disp(['iloop:', num2str(iloop)])
    end

    
    %% if no initial guess provided, get current model parameters as initial guess
    if ~exist('init_guess','var')
        init_guess = nan(1, length(settings.parameters_to_be_fitted));
        for i = 1:length(settings.parameters_to_be_fitted)
            init_guess(1,i) = get(sbioselect(model,'Type','parameter','Where','Name', '==', settings.parameters_to_be_fitted{i}),  'Value');
        end
    end

    %% take log10 of initial guesses
    init_guess = log10(init_guess);

    %% bounds for parameters estimation - in log space
    if Run_Arg.ParallelEst.PSO == 1
%         lb = init_guess(1,:) - 2;
%         ub = init_guess(1,:) + 3;
        lb = init_guess(1,:) - 1;
        ub = init_guess(1,:) + 1;
    elseif Run_Arg.loop_logical == 1
        lb = init_guess(1,:) - 7;
        ub = init_guess(1,:) + 7;
    else 
        lb = [];
        ub = [];
    end

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %% Options for PSO
    if Run_Arg.ParallelEst.PSO == 1
        %%% num of swarm particles for optimization and max stall iterations
        SwarmSize          = 50;
        MaxStallIterations = 20;
        FunctionTolerance  = 1E-6;
    
        pso.options = optimoptions('particleswarm',...
            'SwarmSize',            SwarmSize,...
            'InitialSwarmMatrix',   init_guess,... %pso.parameters,...
            'Display',              'iter',...
            'FunctionTolerance',    0.1,...
            'UseParallel',          true,...
            'MaxIterations',        50,...
            'MaxStallIterations',   MaxStallIterations,...
            'FunctionTolerance',    FunctionTolerance); 
    end   

    
    %% Additional options to be passed
    % figure folder
    settings.fig_folder = '../Figures/Figures_Param-Est_Temp/';
    mkdir(settings.fig_folder)
    % Plotting
    settings.plot_on    = 0; % no plotting during parameter estimation
    % Fitting
    settings.fitting_on = 1; % logical, fitting on or off
    % which hemolysis to fit - Takeda = 1, Kolb = 2
    settings.idx        = 1;
    % use parallel computing toolbox?
    settings.ParallelOn = 0;
    if Run_Arg.ParallelEst.PSO == 1
        if pso.options.UseParallel == 1
            settings.ParallelOn = 1;
        end
    end

    
    %% StopTimes for human Er assays
    settings.StopTime.Ferreira = 30;
    settings.StopTime.Lesher   = 30;
    settings.StopTime.Wilcox   = 30;


    %% Suppress all warnings during parameter estimation
    warning('off','all')

    
    %% Save model to be loaded from within parameter estimation loop
    if iloop == loop_start
        model_saved  = copyobj(model);
        model_name   = "Roche-ACP_temporary_model_for_param_est.sbproj";
        sbiosaveproject(model_name, 'model_saved')
    end
    
    % reset sbimbiology
    sbioreset


    %% optimization - call PSO or parameter looping
    if(Run_Arg.ParallelEst.PSO)
        % start parallel pool if requested
        if(settings.ParallelOn == 1)
            % check if parallel pool already exists
            poolobj = gcp('nocreate');
            if(isempty(poolobj)) poolobj = parpool(n_cores); end
            % start simbiology on all workers
            pctRunOnAll('sbioroot')
        end

        % optimization
        t1 = tic;
        [x_optimal,fval,~,~] = particleswarm(@(x) pso_fun(x, model_name, ...
            settings, data), length(lb), lb, ub, pso.options);
        toc(t1);
        disp(['fval: ', num2str(fval)]);
        disp(['x_optimal: ', num2str(x_optimal)]);

        % close parallel pool
        delete(poolobj);

        
    elseif(Run_Arg.ParallelEst.SA)
        lb = init_guess(1,:) - 7;
        ub = init_guess(1,:) + 7;
        
%         [x,fval,exitFlag,output] = simulannealbnd(@(x) pso_fun(x, model_name, ...
%             settings, data), init_guess, lb, ub); %
%         x = 10.^x;
%         save(['Parameter_estimation_xoptim_GA_2020-05-11.mat'],'x')
        
        [x,fval,exitFlag,output] = ga(@(x) pso_fun(x, model_name, ...
            settings, data), length(init_guess), [], [], [], [], lb, ub); %

        x = 10.^x;
        save(['Parameter_estimation_xoptim_GA_2020-05-11.mat'],'x')

        fval
    
    elseif(Run_Arg.loop_logical == 1)
        t1 = tic;  
        options = optimset('TolX',0.01, 'TolFun', 0.5); %, 'Display','iter'
        if Run_Arg.IterEst.Fminbnd == 1
            [x_optimal,fval,~,~] = fminbnd(@(x) pso_fun(x, model_name, ...
                settings, data),lb,ub,options);
        elseif Run_Arg.IterEst.Fminsearch == 1
            [x_optimal,fval,~,~] = fminsearch(@(x) pso_fun(x, model_name, ...
                settings, data),init_guess,options);
        end
        toc(t1);

        disp(['fval: ', num2str(fval)]);
        disp(['x_optimal: ', num2str(x_optimal)]);
        
    elseif(Run_Arg.SimPlot == 1 || Run_Arg.SensitivityAnalysis == 1) %%% if no fitting
        %%% take inital guess to simulate
        x_optimal = init_guess(1,:);

        %%% take previous estimates to simulate
        % x_optimal = [15.6168      10.7168      9.30233      12.2402     0.475774     -5.17861];
    end


    %% Reset model 
    sbioreset    
    clear loadSimBiologyModel_Persistent

    %% store looping results
    if Run_Arg.loop_logical == 1
       loop_res.iRun(iloop)   = iloop;
       loop_res.par{iloop}    = settings.parameters_to_be_fitted{1};
       loop_res.fval(iloop)   = fval;
       loop_res.parval(iloop) = 10.^x_optimal;
       loop_res.parinit(iloop) = 10.^init_guess;
       loop_res.ub(iloop)      = 10.^ub;
       loop_res.lb(iloop)      = 10.^lb;
       clearvars fval x_optimal 
    end
    
end

%% save looping results
if Run_Arg.loop_logical == 1
    save(['Parameter_estimation_Results-Looping_Par_', num2str(loop_start), ...
        '_to_', num2str(loop_end),'.mat'],'loop_res')
end

    
%% wait for input before going on
if Run_Arg.loop_logical == 1
    msg = ['Iterative parameter estimation has finished. ',...
           'Function execution will stop here. Press a button to continue.'];
   disp(msg)
   pause
   return   
elseif Run_Arg.ParallelEst.PSO == 1
    msg = 'Pparameter estimation has finished. Press a button to continue.';
    disp(msg)
    pause
elseif Run_Arg.SimPlot == 1
    msg = 'No parameter estimation done. Will now simulate.';
    disp(msg)
%     pause
end
    

%% Reset options for simulations
% turn off parallel toolbox - not needed for simulations
settings.ParallelOn = 0;

% Turn warnings on again
warning('on','all')

%% Calculate objective function value with resetted model for QC
%%% check that objective function value from optimization can be reproduced
settings.plot_on    = 0; 
settings.fitting_on = 1;
obj_value = pso_fun(x_optimal, model_name, settings, data);

% display results
if settings.Fit_Thanassi == 1
    msg = 'Objective function value has been calculated WITH Thanassi';
elseif settings.Fit_Thanassi == 0
    msg = 'Objective function value has been calculated WITHOUT Thanassi';
end
disp(msg)
disp(['objective function value - check:          ', num2str(obj_value)])

if(Run_Arg.ParallelEst.PSO == 1)  
    disp(['objective function value - optimization:   ', num2str(fval)])
    disp(['similiarity objective function values (%): ', num2str(100/fval * obj_value)])
end

if(Run_Arg.SensitivityAnalysis ~= 1) 
    msg = 'Press a button to continue';
    disp(msg)
    pause

    %% Simulate and generte plots
    clear loadSimBiologyModel_Persistent
    settings.plot_on    = 1; 
    settings.fitting_on = 0;
    pso_fun(x_optimal, model_name, settings, data)
end

end


%% objective functions
function obj_value = pso_fun(x, model_name, settings, data)
% convert parameter vector to linear space
x = 10.^x;
t2 = tic;

if settings.ParallelOn == 0
    model = loadSimBiologyModel_Persistent(model_name);
% elseif settings.ParallelOn == 1
%     model_temp = loadSimBiologyModel_Persistent(model_name);
end

if settings.ParallelOn == 1
    warning('off','all')
end

try
    %% simulate Ferreira 2007      
    if(settings.ParallelOn == 0) 
        model_temp   = copyobj(model); 
    elseif(settings.ParallelOn == 1)
        model_temp   = loadSimBiologyModel_Persistent(model_name);
    end
    model_temp       = set_parameters(model_temp, x, settings);
    pso_sim.Ferreira =  validation_sim_Ferreira_2007(model_temp, ...
                                    settings.fig_folder, ...
                                    'plot_on', settings.plot_on,...
                                    'StopTime', settings.StopTime.Ferreira, ...
                                    'TimeUnits', 'minute');
    if(settings.ParallelOn == 0) 
        clear_memory(); % delete latest version of model
    elseif(settings.ParallelOn == 1)
        clear loadSimBiologyModel_Persistent
    end

    %%% simulate Lesher 2013
    if(settings.ParallelOn == 0) 
        model_temp   = copyobj(model); 
    elseif(settings.ParallelOn == 1)
        model_temp   = loadSimBiologyModel_Persistent(model_name);
    end
    model_temp       = set_parameters(model_temp, x, settings);
    pso_sim.Lesher   =  validation_sim_Lesher_2013(model_temp, ...
                                    settings.fig_folder, ...
                                    'plot_on', settings.plot_on,...
                                    'StopTime', settings.StopTime.Lesher, ...
                                    'TimeUnits', 'minute');
    if(settings.ParallelOn == 0) 
        clear_memory(); % delete latest version of model
    elseif(settings.ParallelOn == 1)
        clear loadSimBiologyModel_Persistent
    end
    
    %%% simulate Wilcox 1991
    if(settings.ParallelOn == 0) 
        model_temp   = copyobj(model);
    elseif(settings.ParallelOn == 1)
        model_temp   = loadSimBiologyModel_Persistent(model_name); 
    end
    model_temp       = set_parameters(model_temp, x, settings);
    pso_sim.Wilcox   =  validation_sim_Wilcox_1991(model_temp, settings.fig_folder, ...
                                    'plot_on', settings.plot_on,...
                                    'StopTime', settings.StopTime.Wilcox, ...
                                    'TimeUnits', 'minute');
    if(settings.ParallelOn == 0) 
        clear_memory(); % delete latest version of model
    elseif(settings.ParallelOn == 1)
        clear loadSimBiologyModel_Persistent
    end
    
    %%% simulate Pangburn 2002
    if(settings.ParallelOn == 0) 
        model_temp   = copyobj(model); 
    elseif(settings.ParallelOn == 1)
        model_temp   = loadSimBiologyModel_Persistent(model_name);
    end
    model_temp       = set_parameters(model_temp, x, settings);
    pso_sim.Pangburn =  validation_sim_Pangburn_2002(model_temp, ...
                                    settings.fig_folder, ...
                                    'plot_on', settings.plot_on, ...
                                    'fitting_on', settings.fitting_on);
    if(settings.ParallelOn == 0) 
        clear_memory(); % delete latest version of model
    elseif(settings.ParallelOn == 1)
        clear loadSimBiologyModel_Persistent
    end
    
    %%% simulate Wu 2018
    if(settings.ParallelOn == 0) 
        model_temp   = copyobj(model); 
    elseif(settings.ParallelOn == 1)
        model_temp   = loadSimBiologyModel_Persistent(model_name);
    end
    model_temp       = set_parameters(model_temp, x, settings);
    pso_sim.Wu       =  validation_sim_Wu_2018(model_temp, ...
                                    settings.fig_folder, ...
                                    'plot_on', settings.plot_on, ...
                                    'fitting_on', settings.fitting_on);
    if(settings.ParallelOn == 0) 
        clear_memory(); % delete latest version of model
    elseif(settings.ParallelOn == 1)
        clear loadSimBiologyModel_Persistent
    end
    
    %%% simulate Thanassi 2016
    if settings.Fit_Thanassi == 1 || settings.plot_on == 1
        if(settings.ParallelOn == 0) 
            model_temp   = copyobj(model); 
        elseif(settings.ParallelOn == 1)
            model_temp   = loadSimBiologyModel_Persistent(model_name);
        end
        model_temp       = set_parameters(model_temp, x, settings);
        pso_sim.Thanassi =  validation_sim_Thanassi_2016(model_temp, ...
                                        settings.fig_folder, ...
                                        'plot_on', settings.plot_on, ...
                                        'fitting_on', settings.fitting_on);
        if(settings.ParallelOn == 0) 
            clear_memory(); % delete latest version of model
        elseif(settings.ParallelOn == 1)
            clear loadSimBiologyModel_Persistent
        end
    end
    
    %%% simulate Schreiber 1978
    if settings.Fit_Schreiber == 1
        if(settings.ParallelOn == 0) 
            model_temp    = copyobj(model); 
        elseif(settings.ParallelOn == 1)
            model_temp   = loadSimBiologyModel_Persistent(model_name);
        end
        model_temp        = set_parameters(model_temp, x, settings);
        pso_sim.Schreiber =  validation_sim_Schreiber_1978(model_temp, ...
                                settings.fig_folder, ...
                                'plot_on', settings.plot_on, ...
                                'fitting_on', settings.fitting_on, ...
                                'Data', data);
        if(settings.ParallelOn == 0) 
            clear_memory(); % delete latest version of model
        elseif(settings.ParallelOn == 1)
            clear loadSimBiologyModel_Persistent
        end
    end
    
    %%% simulate Lesavre 1978
    if settings.Fit_Lesavre == 1
        if(settings.ParallelOn == 0) 
            model_temp    = copyobj(model); 
        elseif(settings.ParallelOn == 1)
            model_temp   = loadSimBiologyModel_Persistent(model_name);
        end
        model_temp        = set_parameters(model_temp, x, settings);
        pso_sim.Lesavre   =  validation_sim_Lesavre_1978(model_temp, ...
                                settings.fig_folder, ...
                                'plot_on', settings.plot_on,  ...
                                'fitting_on', settings.fitting_on, ...
                                'Data', data);
        if(settings.ParallelOn == 0) 
            clear_memory(); % delete latest version of model
        elseif(settings.ParallelOn == 1)
            clear loadSimBiologyModel_Persistent
        end
    end
    
    %%% simulate but do not fit the following
    if settings.fitting_on == 0 && settings.plot_on == 1
        %%% simulate Biesma 2001
        if(settings.ParallelOn == 0) 
            model_temp  = copyobj(model); 
        elseif(settings.ParallelOn == 1)
            model_temp   = loadSimBiologyModel_Persistent(model_name);
        end
        model_temp      = set_parameters(model_temp, x, settings);
        validation_sim_Biesma_2001(model_temp, settings.fig_folder, ...
            'plot_on', settings.plot_on);
        if(settings.ParallelOn == 0) 
            clear_memory(); % delete latest version of model
        elseif(settings.ParallelOn == 1)
            clear loadSimBiologyModel_Persistent
        end        
        
        %%% plot human Er observed vs predicted
        plot_validation_sim_humanEr_ObsPred(settings.fig_folder, data, pso_sim)

        %%% simulate impact of regulators on human Er lysis
        if(settings.ParallelOn == 0) 
            model_temp  = copyobj(model); 
        elseif(settings.ParallelOn == 1)
            model_temp   = loadSimBiologyModel_Persistent(model_name);
        end
        model_temp       = set_parameters(model_temp, x, settings);
        simulate_human_Er_impact_regulators(model_temp, settings.fig_folder, ...
                                    'plot_on', settings.plot_on,...
                                    'StopTime', settings.StopTime.Lesher, ...
                                    'TimeUnits', 'minute');
        if(settings.ParallelOn == 0) 
            clear_memory(); % delete latest version of model
        elseif(settings.ParallelOn == 1)
            clear loadSimBiologyModel_Persistent
        end        
        
        %%% fluid phase simulations
        if(settings.ParallelOn == 0) 
            model_temp  = copyobj(model); 
        elseif(settings.ParallelOn == 1)
            model_temp   = loadSimBiologyModel_Persistent(model_name);
        end
        model_temp      = set_parameters(model_temp, x, settings);
        sim_val_cellFreeAssays(model_temp, 'figure_folder', settings.fig_folder)
        if(settings.ParallelOn == 0) 
            clear_memory(); % delete latest version of model
        elseif(settings.ParallelOn == 1)
            clear loadSimBiologyModel_Persistent
        end
    end

    if settings.fitting_on == 1
        %%% calculate deviation between simulations and data
        %%% Ferreira
        dev_temp      = calc_deviation_Ferreira(data, pso_sim.Ferreira, settings.idx);
        devN.Ferreira = dev_temp' * dev_temp / length(dev_temp);

        %%% Lesher
        dev_temp      = calc_deviation_Lesher(data, pso_sim.Lesher, settings.idx);
        devN.Lesher   = dev_temp' * dev_temp / length(dev_temp);

        %%% Wilcox
        dev_temp      = calc_deviation_Wilcox(data, pso_sim.Wilcox, settings.idx);
        devN.Wilcox   = dev_temp' * dev_temp / length(dev_temp);

        %%% Pangburn
        dev_temp      = calc_deviation_Pangburn(data, pso_sim.Pangburn, settings.idx);
        devN.Pangburn = dev_temp * dev_temp' / length(dev_temp); %nnz(dev_temp);

        %%% Wu
        dev_temp      = calc_deviation_Wu(data, pso_sim.Wu, settings.idx);       
        temp_length   = sum(sum(~isnan(dev_temp))); % count the number of non-nan elements
        dev_temp(isnan(dev_temp)) = 0; % set NaNs to 0
        dev_temp      = dev_temp(:)'; % unroll matrix
        devN.Wu       = dev_temp * dev_temp' / temp_length;
        
        %%% Thanassi
        if settings.Fit_Thanassi == 1
            dev_temp      = calc_deviation_Thanassi(data, pso_sim.Thanassi, settings.idx);
            temp_length   = sum(sum(~isnan(dev_temp))); % count the number of non-nan elements
            dev_temp(isnan(dev_temp)) = 0; % set NaNs to 0
            dev_temp      = dev_temp(:)'; % unroll matrix
            devN.Thanassi = dev_temp * dev_temp' / temp_length;
        else
            devN.Thanassi = 0;
        end
        
        %%% Schreiber
        if settings.Fit_Schreiber == 1
            dev_temp      = calc_deviation_Schreiber(data, pso_sim.Schreiber, settings.idx);
            temp_length   = sum(sum(~isnan(dev_temp))); % count the number of non-nan elements
            dev_temp(isnan(dev_temp)) = 0; % set NaNs to 0
            dev_temp      = dev_temp(:)'; % unroll matrix
            devN.Schreiber = dev_temp * dev_temp' / temp_length;
        else
            devN.Schreiber = 0;
        end
        
        %%% Lesavre
        if settings.Fit_Lesavre == 1
            dev_temp      = calc_deviation_Lesavre(data, pso_sim.Lesavre, settings.idx);
            devN.Lesavre = dev_temp * dev_temp' / length(dev_temp);
        else
            devN.Lesavre = 0;
        end
        
        %%% sum deviations to get objective function value
        obj_value    = devN.Ferreira + devN.Lesher + devN.Wilcox + ...
                       devN.Pangburn + devN.Wu + devN.Thanassi + ...
                       devN.Schreiber + devN.Lesavre;

    elseif settings.fitting_on == 0
        % cannot be computed due to mismatch between simulation and observation time points
        obj_value = NaN; 
    end
    
catch % if one simulation fails assign large objective function value
    obj_value = 1E20;
end
        
% check if sbioroot has been resetted
% sbroot = sbioroot;
% if length(sbroot.Models) == settings.sbroot_N_models + 1
%     clear_memory(settings);
% elseif length(sbroot.Models) > settings.sbroot_N_models + 1
%     disp('sbioroot is bigger than +1 add start of iteration - paused!')
%     pause
%     sbroot.Models
% end

% display iteration results 
t2 = toc(t2);
if settings.fitting_on == 1
    disp(['obj_value: ', num2str(obj_value), ' ; time (sec): ', num2str(t2), ...
        ' ; x (log10): ', num2str(log10(x))])
elseif settings.fitting_on == 0
   disp(['time (sec): ', num2str(t2)])
end
end


%% clear memory - if not done memory consumption accumulates
function clear_memory()
    sbroot = sbioroot;
    delete(sbroot.Models(length(sbroot.Models)));
end
            
%% deviation functions
function deviation = calc_deviation_Ferreira(data, sim_Ferreira, idx)
    deviation = [data.Ferreira.DAF.avrge      - sim_Ferreira.DAF.Lysis(end,idx);
                 data.Ferreira.FH.avrge       - sim_Ferreira.FH.Lysis(end,idx);
                 data.Ferreira.CD59.avrge     - sim_Ferreira.CD59.Lysis(end,idx);
                 data.Ferreira.FH_DAF.avrge   - sim_Ferreira.FH_DAF.Lysis(end,idx);
                 data.Ferreira.FH_CD59.avrge  - sim_Ferreira.FH_CD59.Lysis(end,idx)];
end

function deviation = calc_deviation_Lesher(data, sim_Lesher, idx)
    deviation = [data.Lesher.aDAF(1)      - sim_Lesher.DAF.Lysis(end,idx);
                 data.Lesher.control(end) - sim_Lesher.FH.Lysis(end,idx);
                 data.Lesher.aDAF(end)    - sim_Lesher.FH_DAF.Lysis(end,idx);
                 data.Lesher.aP(end)      - sim_Lesher.FH_FP.Lysis(end,idx);
                 data.Lesher.aDAF_aP(end) - sim_Lesher.FH_DAF_FP.Lysis(end,idx)];
end

function deviation = calc_deviation_Wilcox(data, sim_Wilcox, idx)
    deviation = [data.Wilcox.aDAF(end)       - sim_Wilcox.DAF.Lysis(end,idx);
                 data.Wilcox.aCD59(end)      - sim_Wilcox.CD59.Lysis(end,idx);
                 data.Wilcox.aCD59_aDAF(end) - sim_Wilcox.CD59_DAF.Lysis(end,idx)];
end

function deviation = calc_deviation_Pangburn(data, sim_Pangburn, idx)
    deviation = data.Pangburn.Fig2.Lysis_Er_FH(1:5)' - sim_Pangburn.lysis(1:5,idx)';
end

function deviation = calc_deviation_Wu(data, sim_Wu, idx)
    % FD titration; C3 titration; time course; FD titration at 5 and 30 minutes
    deviation = NaN(5,8);
    deviation(1,:)   = data.Wu.Fig10D.Lysis_FD'                - sim_Wu.fd.lysis(:,idx)';
    deviation(2,:)   = data.Wu.Fig10D.Lysis_C3'                - [sim_Wu.c3.lysis(:,idx)', NaN];
    deviation(3,1:7) = data.Wu.Fig11B.Lysis_Mean_percent'      - sim_Wu.hFD400.lysis(:,idx)';
    deviation(4,1:6) = data.Wu.Fig11A.RBC_lysis_Mean_percent'  - sim_Wu.min5.lysis([1,6:10],idx)';
    deviation(5,1:6) = data.Wu.Fig11C.RBC_lysis_Mean_percent'  - sim_Wu.min30.lysis(1:6,idx)';
%     deviation(isnan(deviation)) = 0;
    % ignore last two OBS from FD titration
    deviation(1,7:8) = NaN;
    % ignore last three OBS from time course
    deviation(3,5:7) = NaN;
    % ignore last two OBS from FD titration at 30 minutes
    deviation(5,5:6) = NaN;
end

function deviation = calc_deviation_Thanassi(data, sim_Thanassi, idx)
deviation = NaN(5,10);
deviation(1,:)   = data.Thanassi.Hemolysis.HEMOLYSIS_C5' - ...
    [sim_Thanassi.C5.Lysis(:,idx)', NaN]; %% Hemolysis C5
deviation(2,:)   = data.Thanassi.Hemolysis.HEMOLYSIS_fB' - ...
    sim_Thanassi.FB.Lysis(:,idx)'; %% Hemolysis FB
deviation(3,:)   = data.Thanassi.Hemolysis.HEMOLYSIS_fD' - ...
    sim_Thanassi.FD.Lysis(:,idx)'; %% Hemolysis FD
deviation(4,1:8) = (data.Thanassi.fD.C5a_y'              - ...
    sim_Thanassi.FD.C5a_ugml(3:end)') ./ max(data.Thanassi.fD.C5a_y') .* 100; % C5a, FD titration; bring them on a scale from 0 to 100
deviation(5,1:8) = (data.Thanassi.fD.Bb_y'               - ...
    sim_Thanassi.FD.Bb_ugml(3:end)')  ./ max(data.Thanassi.fD.Bb_y')  .* 100; % Bb, FD titration; bring them on a scale from 0 to 100
end

function deviation = calc_deviation_Schreiber(data, sim_Schreiber, idx)
deviation = ...
    [[data.Schreiber.Fig_2.Lysis_Components(1:2:end)' -  sim_Schreiber.Fig2.lysis_Components(:,idx)', NaN];
    [data.Schreiber.Fig_2.Lysis_Serum(1:2:end)'       -  sim_Schreiber.Fig2.lysis_Serum(:,idx)', NaN];
    data.Schreiber.Fig_3.Lysis_W_P(1:2:end)'         -  sim_Schreiber.Fig3.lysis_with_P(:,idx)';
    data.Schreiber.Fig_3.Lysis_WO_P(1:2:end)'        -  sim_Schreiber.Fig3.lysis_w0_P(:,idx)'];
end

function deviation = calc_deviation_Lesavre(data, sim_Lesavre, idx)
deviation = data.Lesavre.Fig_4.Lysis_Percent' - sim_Lesavre.Fig_4.lysis(:,idx)';
end

%% function to set parameters according to current iteration
function model = set_parameters(model, x, settings)   
    for i = 1:length(settings.parameters_to_be_fitted)
        set(sbioselect(model,'Type','parameter','Where','Name', '==', settings.parameters_to_be_fitted{i}),  'Value',x(i));
    end
end







%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% OLD CODE PIECES
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% function to set parameters according to current iteration
% function model = set_parameters(model, x, settings)
% %     set(sbioselect(model,'Type','parameter','Where','Name', '==', 'k_p_C3b_surface'),  'Value',x(1)); %5E4
% %     set(sbioselect(model,'Type','parameter','Where','Name', '==', 'k_p_hC3b'),  'Value',x(2)); 
% % 
% %     set(sbioselect(model,'Type','parameter','Where','Name', '==', 'k_p_C3bBbDAF'),  'Value', x(3));%1.5E5 % determines degree of lysis in anti-CD59 AB case
% %     set(sbioselect(model,'Type','parameter','Where','Name', '==', 'k_p_CD59C5b9'),  'Value', x(4)); % influences only lysis
% % 
% %     set(sbioselect(model,'Type','parameter','Where','Name', '==', 'k_C5_cat_C3bBbC3b'),  'Value', x(5));
% %     set(sbioselect(model,'Type','parameter','Where','Name', '==', 'K_C3_m_C3bBbP'),  'Value', x(6));
%     
%     for i = 1:length(settings.parameters_to_be_fitted)
%         set(sbioselect(model,'Type','parameter','Where','Name', '==', settings.parameters_to_be_fitted{i}),  'Value',x(i));
%     end
% end


%% inital swarm - parse initial guesses and fill with uniform sampling
%%%%%% Not needed: Also done by PSO algorithm automatically
%%%%%% Only needed if you want to define the sampling used for filling the 
%%%%%% initial swarm
%     %%% generate empty matrix
%     pso.parameters = nan(SwarmSize,size(init_guess,2));
% 
%     %%% parse inital guess
%     pso.parameters(1:size(init_guess,1),:) = init_guess;
% 
%     %%% fill remaining matrix by uniform sampling
%     for irow = 1:size(pso.parameters,1)
%         if logical(sum(isnan(pso.parameters(irow,:))))
%             pso.parameters(irow,:) = unifrnd(lb, ub);
%         end
%     end



%% VIRTUAL POPULATION - random sampling
%% maximum number of iterations for virtual populations
% max_iter = 2E4;
% 
% %% generate empty parameter matrix
% VP_parameters      = nan(max_iter,6);
% 
% for irow = 1:size(init_guess,1)
%     VP_parameters(irow,:) = init_guess(irow,:);
% end
% 
% %%
% tic
% % rng(5)
% for n = 5 %1:max_iter
%     disp(n)
%     
%     if n > size(init_guess,1)
% %         parameters(n,:) = unifrnd(lb, ub);
%         VP_parameters(n,:) = unifrnd(lb, ub);
%         VP_parameters(n,:) = 10.^VP_parameters(n,:);
%     end
%     
% %     x_optimal = [17.0166   10.7055    8.2677   10.6394   -4.1718   -4.0799];
% %     VP_parameters(n,:) = [758720956012894,42378301577.4196,160026131.734541,2000000000.00000,0.00202129446804976,0.000262099724610813];
% %     x_optimal = 10.^[17.2732   13.1696    9.6801   11.1455   -3.4860   -7.2527];
%     
%     x_optimal = 10.^x_optimal;
%     model = set_parameters(model, x_optimal);
% 
%     try
%     sim.Ferreira =  validation_sim_Ferreira_2007(model, settings.fig_folder, ...
%                                             'plot_on', 1);
%                         
%      validation_sim_Pangburn_2002(model, settings.fig_folder, ...
%                                             'plot_on', 1)
%                                         
%     simdata.Lesher = validation_sim_Lesher_2013(model, '../Figures/Figures_Param-Est_Temp/');
% 
%     dev2 = calc_deviation(sim.Ferreira, data.Ferreira);
%     deviation.Ferreira.Takeda(n,:) = dev2.Ferreira.Takeda;
%     deviation.Ferreira.Kolb(n,:)   = dev2.Ferreira.Kolb;
% 
% %     deviation.Ferreira.Takeda(n,:) = [data.Ferreira.DAF.avrge - sim.Ferreira.DAF.Lysis(end,1),...
% %                                  data.Ferreira.FH.avrge - sim.Ferreira.FH.Lysis(end,1),...
% %                                  data.Ferreira.CD59.avrge - sim.Ferreira.CD59.Lysis(end,1),...
% %                                  data.Ferreira.FH_DAF.avrge - sim.Ferreira.FH_DAF.Lysis(end,1),...
% %                                  data.Ferreira.FH_CD59.avrge - sim.Ferreira.FH_CD59.Lysis(end,1)];
% % 
% %     deviation.Ferreira.Kolb(n,:) = [data.Ferreira.DAF.avrge - sim.Ferreira.DAF.Lysis(end,2),...
% %                                  data.Ferreira.FH.avrge - sim.Ferreira.FH.Lysis(end,2),...
% %                                  data.Ferreira.CD59.avrge - sim.Ferreira.CD59.Lysis(end,2),...
% %                                  data.Ferreira.FH_DAF.avrge - sim.Ferreira.FH_DAF.Lysis(end,2),...
% %                                  data.Ferreira.FH_CD59.avrge - sim.Ferreira.FH_CD59.Lysis(end,2)];
%     catch
%         deviation.Ferreira.Takeda(n,:) = NaN;
%         deviation.Ferreira.Kolb(n,:) = NaN;
%     end
%     disp(['dev(Takeda) = ', num2str(sum(deviation.Ferreira.Takeda(n,:).^2))])
%     disp(['dev(Kolb) = ', num2str(sum(deviation.Ferreira.Kolb(n,:).^2))])
% end
% rowsum.Takeda = sum(deviation.Ferreira.Takeda.^2,2);
% rowsum.Kolb   = sum(deviation.Ferreira.Kolb.^2,2);
% 
% figure()
% plot(rowsum.Takeda, 'r')
% hold on
% plot(rowsum.Kolb, 'b')
% toc