function [factorB_R32Q_var, factorH_R1210C_var, factorH_I62V_var] = define_genetic_variants(model)


% Kd = koff/kon
% koff = Kd * kon


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Factor B
% 
% Original values
% k_p_C3bB    = 21.3e4;   % Association of Factor B to C3b (1/molarity/second)
% k_m_C3bB    = 15.5e-2;  % Dissociation of complex C3bB   (1/second)                    
% Kd_C3bB     = k_m_C3bB/k_p_C3bB *1e6; % 0.7277 uM

% Variant R32Q
% Binding of fB on C3b without fD (proenzyme formation) performed at 
% physiologic salt conc..  KD calculated by using ?2-state reaction? model: 
% Slow variant: fB32R, 0.43 ? 0.25 uM
% Fast variant: fB32Q, 1.4 ? 0.28 uM

k_p_C3bB = get(sbioselect(model, 'Name', 'k_p_C3bB'), 'Value');

factorB_R32Q_var = sbiovariant('factorB_R32Q_var',...
         'Notes', 'Lower affinity of B to C3b');

addcontent(factorB_R32Q_var, {'parameter', 'k_m_C3bB','Value', 1.4e-6 * k_p_C3bB});
addvariant(model, factorB_R32Q_var);



%%%% Version 2
% 

k_p_C3bB    = get(sbioselect(model, 'Name', 'k_p_C3bB'),     'Value');
k_p_C3H2OB  = get(sbioselect(model, 'Name', 'k_p_C3(H20)B'), 'Value');

factorB_R32Q_var_V2 = sbiovariant('factorB_R32Q_var_V2',...
         'Notes', 'Lower affinity of B to C3b, also applied to C3(H2O)');

% addcontent(factorB_R32Q_var_V2, {'parameter', 'k_m_C3bB',    'Value', 1.4e-6 * k_p_C3bB});
% addcontent(factorB_R32Q_var_V2, {'parameter', 'k_m_C3(H20)B','Value', 1.4e-6 * k_p_C3H2OB});
addcontent(factorB_R32Q_var_V2, {'parameter', 'k_m_C3bB',    'Value', 2.8e-6 * k_p_C3bB});
addcontent(factorB_R32Q_var_V2, {'parameter', 'k_m_C3(H20)B','Value', 2.8e-6 * k_p_C3H2OB});
addvariant(model, factorB_R32Q_var_V2);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Factor H
% Variant Y402H
%
% Original values
% k_p_C3bH  = 5.2e6; % Association of Factor H to C3(H2O)  1/molarity/second
% k_m_C3bH  = 32.5;  % 1/second
% Kd_C3bH   = k_m_C3bH/k_p_C3bH * 1e6; % 6.25 uM

k_p_C3bH = get(sbioselect(model, 'Name', 'k_p_C3bH'), 'Value');

% Clark et al
% Tissue-Specific Host Recognition by Complement Factor H Is Mediated by 
% Differential Activities of Its Glycosaminoglycan-Binding Regions
% J Immunol 2013; 190:2049-2057
%
% Decreased (approx. 4-fold) binding of 402H to eye bruch's membrane as compare to 402Y

% Variant R1210C
%
% Ferreira et al
% The Binding of Factor H to a Complex of PhysiologicalPolyanions and C3b on 
% cells Is Impaired in Atypical Hemolytic Uremic Syndrome1
% J Immunol 2009; 182:7009-7018;
% Kd = 5- 9;      % uM wildtype 
% Kd = 9 - 14;    % uM R1210C  USE AVERAGE = 11.5
factorH_R1210C_var = sbiovariant('factorH_R1210C_var',...
         'Notes', 'Lower affinity of H to C3b');

addcontent(factorH_R1210C_var, {'parameter', 'k_m_C3bH','Value', 11.5e-6 * k_p_C3bH});
addvariant(model, factorH_R1210C_var);


% Variant I62V
%
% Kd = 1.04; % uM for fH-Ile62 
% Kd = 1.33; % uM for fH-Val62
factorH_I62V_var = sbiovariant('factorH_I62V_var',...
         'Notes', 'Higher affinity of H to C3b');

addcontent(factorH_I62V_var, {'parameter', 'k_m_C3bH','Value', 1.04e-6 * k_p_C3bH});
addvariant(model, factorH_I62V_var);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


% Variant R1210C



end