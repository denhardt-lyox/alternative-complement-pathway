function fit_takeda

%%
data_folder =  '../Data/';
figure_folder = '../Figures/Figures_Takeda/';
mkdir(figure_folder);

%% get data
[Takeda_Data] = loadData_Takeda1986(data_folder);

%% Takeda - fit parameters
Takeda_Data.sorted = [Takeda_Data.FigC8_PercentLysis(2:end,2); Takeda_Data.FigC8_PercentLysis(2:end,3)];
[Takeda_Data.sorted, idx] = sort(Takeda_Data.sorted);
Takeda_Data.sorted_C8 = [Takeda_Data.FigC8_C8perCell(2:end,2); Takeda_Data.FigC8_C8perCell(2:end,3)];
Takeda_Data.sorted_C8 = Takeda_Data.sorted_C8(idx);

par.UB = 100;
par.LB = 0;
temp = Takeda_Data.sorted;
temp_C8 = Takeda_Data.sorted_C8;
parameters_Takeda = lsqcurvefit(@(parameter,temp)sigmoidal_fun(parameter,temp_C8,par),[1 0.5],temp_C8,temp,[],[]);
Takeda_sim.xsim = logspace(-1,3,200);
Takeda_sim.ysim = sigmoidal_fun(parameters_Takeda, Takeda_sim.xsim, par);


%%%
plot_Takeda1986(Takeda_Data, Takeda_sim, figure_folder)
