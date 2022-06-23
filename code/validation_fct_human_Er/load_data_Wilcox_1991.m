function data = load_data_Wilcox_1991(data)
% load data for Wilcox 1991 validation simulations
% if data is passed, new data is added to existing data structure

%%
data.Wilcox              = groupedData(readtable('../Data/Wilcox_1991_Fig7A.csv', 'Delimiter', ','));
data.Wilcox_Readout_Time = 30; % original readout time according to manuscript
end