function data = load_data_Thanassi_2016(data)
% load data for Thanassi 2016 validation simulations
% if data is passed, new data is added to existing data structure

%%
data.Thanassi.Hemolysis  = groupedData(readtable('../Data/Thanassi_2016_Fig1_Hemolysis.csv', 'Delimiter', ','));
data.Thanassi.fD         = groupedData(readtable('../Data/Thanassi_2016_Fig3_fD_corrected.csv', 'Delimiter', ',')); % corrected C5a levels based on mail by S. Podos
data.Thanassi.C5         = groupedData(readtable('../Data/Thanassi_2016_Fig3_C5_corrected.csv', 'Delimiter', ',')); % corrected C5a levels based on mail by S. Podos
end