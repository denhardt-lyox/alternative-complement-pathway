function data = load_data_Schreiber_1978(data)
% load data for Schreiber 1978 validation simulations
% if data is passed, new data is added to existing data structure

%%        
data.Schreiber.Fig_2    = groupedData(readtable('../Data/Schreiber_1978_Fig_2.csv', 'Delimiter', ','));
data.Schreiber.Fig_3    = groupedData(readtable('../Data/Schreiber_1978_Fig_3_Properdin.csv', 'Delimiter', ','));
end