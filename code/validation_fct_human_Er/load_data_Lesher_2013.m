function data = load_data_Lesher_2013(data)
% load data for Lesher 2013 validation simulations
% if data is passed, new data is added to existing data structure

%%
data.Lesher = groupedData(readtable('../Data/Lesher_2013_Fig_9A.csv', 'Delimiter', ','));
end