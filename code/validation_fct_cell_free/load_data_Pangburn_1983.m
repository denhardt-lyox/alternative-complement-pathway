function data = load_data_Pangburn_1983(data)
% load data for Pangburn 1983 validation simulations
% if data is passed, new data is added to existing data structure

%%        
data.Pangburn1983.Fig2    = groupedData(readtable('../Data/Pangburn_1983_Fig2_normalized_baselineCorr.csv', 'Delimiter', ','));
end