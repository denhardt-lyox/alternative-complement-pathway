function [data] = loadData_Takeda1986(data_folder)
data.FigC8 = xlsread([data_folder,'Takeda1986.xlsx'], 'Fig2_C8');
data.FigC9 = xlsread([data_folder,'Takeda1986.xlsx'], 'Fig4_C9');

data.FigC8_PercentLysis = data.FigC8;
data.FigC9_PercentLysis = data.FigC9;
data.FigC8_PercentLysis(:,2:3) = data.FigC8(:,2:3)./data.FigC8(:,1).*100;
data.FigC9_PercentLysis(:,2:4) = data.FigC9(:,2:4)./data.FigC9(:,1).*100;

%% 
%%% Assuming 1.35E+07 molecues C8 for 1/9000 dilution which would
%%% correspond to 1 molecule C8/cell at 3rd measurement point
N_C8_1 = 1.35E+07;
N_C8_2 = 1.35E+07 * 3;

data.FigC8_C8perCell = data.FigC8;
data.FigC8_C8perCell(:,2) = N_C8_1./data.FigC8_C8perCell(:,1);
data.FigC8_C8perCell(:,3) = N_C8_2./data.FigC8_C8perCell(:,1);



end