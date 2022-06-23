function validation_sim_Pangburn_1986(model, figure_folder)
%%% simulation of Pangburn 1986 Fig 3 and 6

%% load data
data = load_data_Pangburn_1986();

%%
cs                                  = getconfigset(model);
cs.CompileOptions.UnitConversion    = true;
cs.SolverType                       = 'ode15s'; % stiff solver
cs.SolverOptions.AbsoluteTolerance  = 1e-18;
cs.SolverOptions.SensitivityAnalysis= false;
    

%% Fig 6
StopTime     = 450;
cs.TimeUnits = 'second';
cs.StopTime  = StopTime; % 450 seconds
    
copiedModel = copyobj(model);

%%%
set(copiedModel.Species, 'InitialAmount', 0)
set(sbioselect(copiedModel,'Type','Species','Where','Name', '==', 'C3'),  'InitialAmount', 1);

%%%
set(sbioselect(copiedModel,'Type','Species','Where','Name', '==', 'C3bBb fluid'),  'InitialAmount', 7.87E-3);
sim_Fig6.simdata_7     = sbiosimulate(copiedModel);

%%%
set(sbioselect(copiedModel,'Type','Species','Where','Name', '==', 'C3bBb fluid'),  'InitialAmount', 15.7E-3);
sim_Fig6.simdata_15     = sbiosimulate(copiedModel);
    
delete(copiedModel)

%% Fig 3 
cs.StopTime                         = 60;
cs.TimeUnits                        = 'second';
cs.SolverOptions.OutputTimes        = 0:1:cs.StopTime;
    
Readout  = 10; % use first x seconds to calculate the slope; not given in protocol;
               % has a strong influence on model to data fit

copiedModel = copyobj(model);

%%%
set(copiedModel.Species, 'InitialAmount', 0)
set(sbioselect(copiedModel,'Type','Species','Where','Name', '==', 'C3bBb fluid'),  'InitialAmount', 63E-3);

%%%
sim_Fig3.C3_0 = [1 2 3 4 6 8 10 13 16 20 24 28 32];

for i = 1:length(sim_Fig3.C3_0)
    set(sbioselect(copiedModel,'Type','Species','Where','Name', '==', 'C3'),  'InitialAmount', sim_Fig3.C3_0(i));
    sim_Fig3.simdata    = sbiosimulate(copiedModel);
    plot_var            = selectbyname(sim_Fig3.simdata, {'C3', 'C3b fluid'});
    sim_Fig3.v_0(i) = plot_var.Data(Readout,2)/plot_var.Time(Readout);
end

delete(copiedModel)

%% Plotting
plot_validation_sim_Pangburn_1986(figure_folder, data, sim_Fig6, sim_Fig3)
    
end