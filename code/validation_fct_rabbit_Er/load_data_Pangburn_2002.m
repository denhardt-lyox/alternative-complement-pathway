function data = load_data_Pangburn_2002(data)
% load data for Pangburn 2002 validation simulations
% if data is passed, new data is added to existing data structure

%%
data.Pangburn.Fig2   = groupedData(readtable('../Data/Pangburn_2002_Fig_2.csv', 'Delimiter', ','));
data.Pangburn.Fig3   = groupedData(readtable('../Data/Pangburn_2002_Fig_3.csv', 'Delimiter', ','));
end