function validation_sim_Pangburn_1983(model, figure_folder)
%%% simulation of Pangburn 1986 Fig 3 and 6

%% load data
data = load_data_Pangburn_1983();

%%
cs                                  = getconfigset(model);
cs.CompileOptions.UnitConversion    = true;
cs.SolverType                       = 'ode15s'; % stiff solver
cs.SolverOptions.AbsoluteTolerance  = 1e-18;
cs.SolverOptions.SensitivityAnalysis= false;
    

%%  
OutputTimes = 0:10:300;

FH_nM = [790, 393, 197, 98.5, 49.3, 12.4, 4.5];
simdata.FH = nan(1, length(FH_nM));
simdata.C3b = nan(length(OutputTimes),length(FH_nM));

n=1;
for fh = FH_nM
    StopTime     = 35;
    cs.TimeUnits = 'second';
    cs.StopTime  = StopTime; 
    cs.SolverOptions.OutputTimes = [];

    set(model.Species, 'InitialAmount', 0)
    set(sbioselect(model,'Type','Species','Where','Name', '==', 'C3b fluid'),  'InitialAmount', 3.7);
    set(sbioselect(model,'Type','Species','Where','Name', '==', 'H'),  'InitialAmount', fh*1E-3);

    simdata_init    = sbiosimulate(model);
    plot_var_init   = selectbyname(simdata_init, {'C3b fluid', 'H', 'C3bH fluid', 'iC3b fluid'});


    set(sbioselect(model,'Type','Species','Where','Name', '==', 'C3b fluid'),  'InitialAmount', plot_var_init.Data(end,1));
    set(sbioselect(model,'Type','Species','Where','Name', '==', 'H'),  'InitialAmount', plot_var_init.Data(end,2));
    set(sbioselect(model,'Type','Species','Where','Name', '==', 'C3bH fluid'),  'InitialAmount', plot_var_init.Data(end,3));

    set(sbioselect(model,'Type','Species','Where','Name', '==', 'I'),  'InitialAmount', 4.8E-2);

    StopTime     = 300;
    cs.TimeUnits = 'second';
    cs.StopTime  = StopTime; 
    cs.SolverOptions.OutputTimes = OutputTimes;
    
    simdata_final  = sbiosimulate(model);
    plot_var_final = selectbyname(simdata_final, {'C3b fluid', 'H', 'C3bH fluid', 'iC3b fluid'});

    simdata.FH(n) = fh;
    simdata.C3b(:,n)   = plot_var_final.Data(:,1);
    simdata.C3bH(:,n)  = plot_var_final.Data(:,3);
    n=n+1;
end
    

%% Plotting
plot_validation_sim_Pangburn_1983(figure_folder, data, simdata)
    
end