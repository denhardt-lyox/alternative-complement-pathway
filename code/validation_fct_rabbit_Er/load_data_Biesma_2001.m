function data = load_data_Biesma_2001(data)
% load data for Biesma 2001 validation simulations
% if data is passed, new data is added to existing data structure

%%        
data.Biesma.Fig_3A    = groupedData(readtable('../Data/Biesma_2001_CFD_3a.csv', 'Delimiter', ','));
data.Biesma.Fig_3B    = groupedData(readtable('../Data/Biesma_2001_CFD_3b.csv', 'Delimiter', ','));
end