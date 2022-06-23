function k_hemolysis = calculate_k_hemolysis(k_hemolysis_max, Percent_Lysis_Kolb, Percent_Lysis_Takeda, k_hemolysis_on, k_hemolysis_typical_T)
% function calculates rate of hemolysis as a function of predicted
% hemolysis based on Kolb and Takeda
% Inputs:
%   k_hemolysis_max - max rate of hemolysis, not used, can be removed
%   Percent_Lysis_Kolb - predicted hemolysis in % according to Kolb
%   Percent_Lysis_Takeda - predicted hemolysis in % according to Takeda
%   k_hemolysis_on - 0 or 1; determines wheter hemolysis rate should be calculated or not
%   k_hemolysis_typical_T - Parameter used to scale percent hemolysis to a
%                           rate; based on
%                           PNH type 3 patients

if k_hemolysis_on == 1

    if Percent_Lysis_Takeda == 100 && Percent_Lysis_Kolb == 100
        Percent_Lysis_Takeda = 99.999999;
    end

%     k_hemolysis = -log(1 - ((Percent_Lysis_Kolb + Percent_Lysis_Takeda) / 2 / 100)) / k_hemolysis_typical_T;
    k_hemolysis = -log(1 - (Percent_Lysis_Takeda / 100)) / k_hemolysis_typical_T;
    
    %%% for debugging
%     disp(k_hemolysis)
%     k_hemolysis = 1.8850E-7 * 60 *60 *24;
    
elseif k_hemolysis_on == 0
    k_hemolysis = 0;
end

end