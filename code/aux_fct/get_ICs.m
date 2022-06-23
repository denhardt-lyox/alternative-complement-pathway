function init = get_ICs(model)
%% Get initial concentration of all species
init.C3_0        =  get(sbioselect(model,'Type','species','Where','Name', '==', 'C3'), 'InitialAmount');
init.C5_0        =  get(sbioselect(model,'Type','species','Where','Name', '==', 'C5'), 'InitialAmount'); 
init.C6_0        =  get(sbioselect(model,'Type','species','Where','Name', '==', 'C6'), 'InitialAmount'); 
init.C7_0        =  get(sbioselect(model,'Type','species','Where','Name', '==', 'C7'), 'InitialAmount'); 
init.C8_0        =  get(sbioselect(model,'Type','species','Where','Name', '==', 'C8'), 'InitialAmount'); 
init.C9_0        =  get(sbioselect(model,'Type','species','Where','Name', '==', 'C9'), 'InitialAmount'); 

init.B_0         =  get(sbioselect(model,'Type','species','Where','Name', '==', 'B'), 'InitialAmount'); 
init.D_0         =  get(sbioselect(model,'Type','species','Where','Name', '==', 'D'), 'InitialAmount'); 
init.I_0         =  get(sbioselect(model,'Type','species','Where','Name', '==', 'I'), 'InitialAmount'); 

% Plasma properdin
init.Properdin_0 =  get(sbioselect(model,'Type','species','Where','Name', '==', 'P'), 'InitialAmount'); 
init.H_0         =  get(sbioselect(model,'Type','species','Where','Name', '==', 'H'), 'InitialAmount'); 
init.CR1_0       =  get(sbioselect(model,'Type','species','Where','Name', '==', 'CR1'), 'InitialAmount'); 
init.DAF_0       =  get(sbioselect(model,'Type','species','Where','Name', '==', 'DAF'), 'InitialAmount'); 
init.Vn_0        =  get(sbioselect(model,'Type','species','Where','Name', '==', 'Vn'), 'InitialAmount'); 
init.Cn_0        =  get(sbioselect(model,'Type','species','Where','Name', '==', 'Cn'), 'InitialAmount'); 
init.CD59_0      =  get(sbioselect(model,'Type','species','Where','Name', '==', 'CD59'), 'InitialAmount'); 
init.Surface_0   =  get(sbioselect(model,'Type','species','Where','Name', '==', 'Surface host'), 'InitialAmount');
init.H2O_0       =  get(sbioselect(model,'Type','species','Where','Name', '==', 'H2O'), 'InitialAmount');

end