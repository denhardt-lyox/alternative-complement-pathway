function data = load_data_Lesavre_1978(data)
% load data for Lesavre 1978 validation simulations
% if data is passed, new data is added to existing data structure

%%        
data.Lesavre.Fig_4    = groupedData(readtable('../Data/Lesavre_1978_Fig4.csv', 'Delimiter', ','));
end