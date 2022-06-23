function data = load_data_Ferreira_2007(data)
% load data for Ferreira 2007 validation simulations
% if data is passed, new data is added to existing data structure

%%
data.Ferreira.Fig1A         = groupedData(readtable('../Data/Ferreira_2007_Fig_1A.csv', 'Delimiter', ','));
data.Ferreira.Fig1B         = groupedData(readtable('../Data/Ferreira_2007_Fig_1B.csv', 'Delimiter', ','));
data.Ferreira.Readout_Time  = 20; % Readout time according to manuscript

data.Ferreira.DAF.avrge     = data.Ferreira.Fig1B.E_H_avrge(end);
data.Ferreira.DAF.std       = data.Ferreira.Fig1B.E_H_std(end);

data.Ferreira.FH.avrge      = mean([data.Ferreira.Fig1A.E_H_rH1920_avrge(1) data.Ferreira.Fig1B.E_H_rH1920_avrge(1)]);
data.Ferreira.FH.std        = std([data.Ferreira.Fig1A.E_H_rH1920_avrge(1) data.Ferreira.Fig1B.E_H_rH1920_avrge(1)]);

data.Ferreira.CD59.avrge    = data.Ferreira.Fig1A.E_H_avrge(end);
data.Ferreira.CD59.std      = data.Ferreira.Fig1A.E_H_std(end);

data.Ferreira.FH_DAF.avrge  = data.Ferreira.Fig1B.E_H_rH1920_avrge(end);
data.Ferreira.FH_DAF.std    = data.Ferreira.Fig1B.E_H_rH1920_std(end);

data.Ferreira.FH_CD59.avrge = data.Ferreira.Fig1A.E_H_rH1920_avrge(end);
data.Ferreira.FH_CD59.std   = data.Ferreira.Fig1A.E_H_rH1920_std(end);
end