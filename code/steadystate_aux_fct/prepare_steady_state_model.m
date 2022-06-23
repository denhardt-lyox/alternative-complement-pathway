function [model_ss, sim_simdata_to_SS] = prepare_steady_state_model(model_in, turnover_variant_name, production_rates_table)
% takes an simbiology model as input and makes a steady state model out of
% it
% - applies turnover variant defined by "turnover_variant_name"
% - sets production rates for steady state model
% - production rates need to be in table format with row name = ACP species
% and a column "Value" with the production rate in uM/s
% - runs model for 20 days to get to steady state and defines new ICs based
%   on concentrations after 20 days

model_ss  = copyobj(model_in);

%% Solver options
cs                                     = getconfigset(model_ss);

%%
StopTime_SteadyState = 20;
In.StopTime          = cs.StopTime;
In.TimeUnits         = cs.TimeUnits;

%% Solver options
cs.CompileOptions.UnitConversion       = true;
cs.SolverType                          = 'ode15s'; % stiff solver
cs.SolverOptions.AbsoluteTolerance     = 1e-20;
cs.TimeUnits                           = 'day';
cs.StopTime                            = StopTime_SteadyState;

%% Commit turnover variant
variantObj = getvariant(model_ss, turnover_variant_name);
commit (variantObj, model_ss);

%% Apply production rates
model_ss = set_production_rates_steady_state_model_TableFormat(model_ss, production_rates_table);

%% simulate first 20 days and set final concentrations as new IC
sim_simdata_to_SS = sbiosimulate(model_ss);

for i = 1:length(model_ss.Species)
    set(model_ss.Species(i), 'InitialAmount', sim_simdata_to_SS.Data(end,i))
end

%% reset StopTime
cs                                     = getconfigset(model_ss);
cs.CompileOptions.UnitConversion       = true;
cs.SolverType                          = 'ode15s'; % stiff solver
cs.SolverOptions.AbsoluteTolerance     = 1e-20;
cs.TimeUnits                           = In.TimeUnits;
cs.StopTime                            = In.StopTime;

%% get ICs of original model for plotting comparison
initcond = get_ICs(model_in);

%% Control plot
%%% Color definitions
h = figure;
colors = get(gca,'colororder');
colors = repmat(colors, 3, 1);
close(h)

%%%
h = figure;
subplot(2,2,1)

%%% subplot 1 - kinetics proteins
sim_select	= selectbyname(sim_simdata_to_SS, {'B','C3', 'C5', 'C6', 'C7', 'C8', 'C9', 'D', 'I', 'H', 'P', 'Vn', 'Cn', 'CR1', 'CD59', 'DAF'});
subplot(2,2,1)
hold on
plot(sim_select.Time, sim_select.Data(:,1),  '-',  'LineWidth', 1.5, 'Color', colors(1,:));
plot(sim_select.Time, sim_select.Data(:,2),  '-',  'LineWidth', 1.5, 'Color', colors(2,:));
plot(sim_select.Time, sim_select.Data(:,3),  '-',  'LineWidth', 1.5, 'Color', colors(3,:));
plot(sim_select.Time, sim_select.Data(:,4),  '-',  'LineWidth', 1.5, 'Color', colors(4,:));
plot(sim_select.Time, sim_select.Data(:,5),  '-',  'LineWidth', 1.5, 'Color', colors(5,:));
plot(sim_select.Time, sim_select.Data(:,6),  '-',  'LineWidth', 1.5, 'Color', colors(6,:));
plot(sim_select.Time, sim_select.Data(:,7),  '-',  'LineWidth', 1.5, 'Color', colors(7,:));
plot(sim_select.Time, sim_select.Data(:,8),  '--', 'LineWidth', 1.5, 'Color', colors(8,:));
plot(sim_select.Time, sim_select.Data(:,9),  '--', 'LineWidth', 1.5, 'Color', colors(9,:));
plot(sim_select.Time, sim_select.Data(:,10), '--', 'LineWidth', 1.5, 'Color', colors(10,:));
plot(sim_select.Time, sim_select.Data(:,11), '--', 'LineWidth', 1.5, 'Color', colors(11,:));
plot(sim_select.Time, sim_select.Data(:,12), '--', 'LineWidth', 1.5, 'Color', colors(12,:));
plot(sim_select.Time, sim_select.Data(:,13), '--', 'LineWidth', 1.5, 'Color', colors(13,:));
plot(sim_select.Time, sim_select.Data(:,14), '--', 'LineWidth', 1.5, 'Color', colors(14,:));
plot(sim_select.Time, sim_select.Data(:,15), '--', 'LineWidth', 1.5, 'Color', colors(15,:));
plot(sim_select.Time, sim_select.Data(:,16), '--', 'LineWidth', 1.5, 'Color', colors(16,:));
xlabel(['Time (', sim_select.TimeUnits,')'], 'FontSize' ,14);
ylabel(['Concentration (uM)'], 'FontSize' ,14);
set(gca,'fontWeight','bold');
grid on
set(gca,'YScale', 'log')
ylim([1E-4 1E2])
% legend('B','C3', 'C5', 'C6', 'C7', 'C8', 'C9', 'D', 'I', 'H', 'P', 'Vn', 'Cn', 'CR1', 'CD59', 'DAF', 'Location', 'SouthEast')

%%% subplot 2 - erythrocytes conc
subplot(2,2,2)
sim_select	= selectbyname(sim_simdata_to_SS, 'Erythrocytes_uM');
hold on
plot(sim_select.Time, sim_select.Data(:,1),  '-',  'LineWidth', 1.5, 'Color', colors(1,:));
title('Erythrocytes uM')
xlabel('Time', 'FontSize' ,14);
ylabel('Concentration (uM)', 'FontSize' ,14);
set(gca,'fontWeight','bold');
grid on
ylim([3E-6 9E-6])

%%% subplot 3 - IC vs SS-conc
subplot(2,2,[3,4])
sim_select	= selectbyname(sim_simdata_to_SS, {'C3', 'C5', 'C6', 'C7', 'C8', 'C9', 'B', 'D', 'P', 'I', 'H', 'Vn', 'Cn', 'CR1', 'DAF', 'CD59'});
hold on
bar(1:16, sim_select.Data(end,:), 'FaceColor', [0.75 0.75 0.75])
xticks(1:16)
xticklabels({'C3', 'C5', 'C6', 'C7', 'C8', 'C9', 'B', 'D', 'P', 'I', 'H', 'Vn', 'Cn', 'CR1', 'DAF', 'CD59'})
set(gca,'YScale', 'log')
ylim([1E-3 1E1])
plot(1:16, [initcond.C3_0, initcond.C5_0, initcond.C6_0,         initcond.C7_0, initcond.C8_0, initcond.C9_0,...
            initcond.B_0,  initcond. D_0, initcond.Properdin_0,  initcond.I_0,  initcond.H_0,  initcond.Vn_0,...
            initcond.Cn_0, initcond.CR1_0, initcond.DAF_0,       initcond.CD59_0],  'k*', 'MarkerSize', 10)
title('Concentration of free species')
xlabel('Complement component', 'FontSize' ,14);
ylabel('Concentration (uM)', 'FontSize' ,14);
xlim([0.5 16.5])
set(gca,'fontWeight','bold');
grid on

%%% output
drawnow
wait.sec = 3;
msg = ['Pausing to check to-steady-state-simulation. Will continue in ',...
    num2str(wait.sec), ' seconds.'];
disp(msg)
pause(wait.sec)
close all
end
