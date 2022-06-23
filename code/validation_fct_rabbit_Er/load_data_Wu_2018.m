function data = load_data_Wu_2018(data)
% load data for Wu 2018 validation simulations
% if data is passed, new data is added to existing data structure

%%
data.Wu.Fig10D = groupedData(readtable('../Data/Wu_2018_Fig_10D.csv', 'Delimiter', ','));
data.Wu.Fig11A = groupedData(readtable('../Data/Wu_2018_Fig_11A.csv', 'Delimiter', ','));
data.Wu.Fig11B = groupedData(readtable('../Data/Wu_2018_Fig_11B.csv', 'Delimiter', ','));
data.Wu.Fig11C = groupedData(readtable('../Data/Wu_2018_Fig_11C.csv', 'Delimiter', ','));
end