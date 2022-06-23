function Percent_Hemolysis = Hemolysis_Takeda(Conc_MAC, Total_surface, Surface_per_cell)
%%%% calculates percent hemolysis as a function of number of MAC complexes
%%%% i.e. number of fully saturated C8 molecules per cell
par.UB = 100; % fixed parameter
par.LB = 0; % fixed parameter
    

Conc_MAC   = abs(Conc_MAC);
Conc_Cells = Total_surface ./ Surface_per_cell;

Num_MAC_Per_Cell = Conc_MAC / Conc_Cells;

par.EC50 = 1.1457; % EC50
par.gamma = 1.5992; % gamma
Percent_Hemolysis = sigmoidal_fun([par.EC50 par.gamma], Num_MAC_Per_Cell, par);
end
 