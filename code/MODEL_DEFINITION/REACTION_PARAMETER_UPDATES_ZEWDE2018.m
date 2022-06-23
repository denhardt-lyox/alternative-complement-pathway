function REACTION_PARAMETER_UPDATES_ZEWDE2018(model)
% Changes of "original" parameter values from Zewde, 2016
% Changes according to Zewde 2018

%% Updates of parameters according to Zewde 2017

% set(sbioselect(model,'Type','parameter','Where','Name', '==', 'k_p_C3(H20)B'),  'Value', 1.10E+04);
% set(sbioselect(model,'Type','parameter','Where','Name', '==', 'k_m_C3(H20)B'),  'Value', 1.40E-03);
set(sbioselect(model,'Type','parameter','Where','Name', '==', 'k_p_C3bH'),      'Value', 1.10E+06);
set(sbioselect(model,'Type','parameter','Where','Name', '==', 'k_p_C3bH_surf'), 'Value', 1.10E+06);
set(sbioselect(model,'Type','parameter','Where','Name', '==', 'k_m_C3bH'),      'Value', 5.90E-02);
set(sbioselect(model,'Type','parameter','Where','Name', '==', 'k_p_C3bCR1'),    'Value', 4.40E+06);
set(sbioselect(model,'Type','parameter','Where','Name', '==', 'k_m_C3bCR1'),    'Value', 5.70E-02);

end