function LDH_U_L = calculate_LDH(Hemoglobin_g_dL)
% calculate levels of lactate dehydrogenase as a function of hemolglobin
% levels in blood
% uses LDH - hemoolglobin relationship followed from data from DeZern, 
% Dorr, Brodsky, 2013. Eur J Haematol (Table 3)
% 
% Input:
%       Hemolgobin levels in g/dL
% Output:
%       LDH levels in U/L

%%
% if Hemoglobin_g_dL >= 11
%     LDH_U_L = 150;
% else
%     LDH_U_L = -622.73 * Hemoglobin_g_dL + 7000;
% end

% gamma = 1;
% LDH_U_L = 6E3/(1+(exp(gamma*(Hemoglobin_g_dL - 6.75)))) + 200;

gamma = 1;
a = 1495;
b = 7.94;
c = 296;
LDH_U_L = a./(1+(exp(gamma.*(Hemoglobin_g_dL - b)))) + c;

end
