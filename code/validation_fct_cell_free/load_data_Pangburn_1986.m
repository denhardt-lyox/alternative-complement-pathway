function data = load_data_Pangburn_1986(data)
% load data for Pangburn 1986 validation simulations
% if data is passed, new data is added to existing data structure

%%        
data.Pangburn1986.Fig3    = groupedData(readtable('../Data/Pangburn_1986_Fig3.csv', 'Delimiter', ','));
data.Pangburn1986.Fig6    = groupedData(readtable('../Data/Pangburn_1986_Fig6.csv', 'Delimiter', ','));
end