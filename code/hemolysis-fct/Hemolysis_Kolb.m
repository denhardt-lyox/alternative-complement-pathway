function Percent_Hemolysis = Hemolysis_Kolb(Conc_C8, Conc_C9, Total_surface, Surface_per_cell)
%%%% calculates percent hemolysis as a function of number of C8 and C9
%%%% molecules per cell
%%%% EC50 is determined by number of C8 molecules - linear dependence
%%%% Calculated EC50 and fixed gamma are then used to calculate hemolysis
%%%% as a function of number of C9 molecules per cell

par.UB = 100; % fixed parameter
par.LB = 0; % fixed parameter
gamma = 1.16;

Conc_C8    = abs(Conc_C8);
Conc_C9    = abs(Conc_C9);
Conc_Cells = Total_surface ./ Surface_per_cell;

Num_C8_Per_Cell = Conc_C8 / Conc_Cells;
Num_C9_Per_Cell = Conc_C9 / Conc_Cells;

% calculate EC50
EC50 = Hemolysis_Kolb_calculate_EC50(Num_C8_Per_Cell);
% calculate lysis
for i = 1:length(EC50)
    % sigmoidal_fun does not take arrays of EC50 right now, so looping is
    % needed
    Percent_Hemolysis(i) = sigmoidal_fun([EC50(i) gamma], Num_C9_Per_Cell(i), par);
end

%%% debugging
% % disp(Num_C9_Per_Cell)
% disp([num2str(time), ': ', num2str(Percent_Hemolysis), '%'])
% % disp(Percent_Hemolysis)
% if(~isreal(Percent_Hemolysis))
%     Percent_Hemolysis;
%     disp('imaginary')
% end

end

function EC50 = Hemolysis_Kolb_calculate_EC50(C8perCell)
%%%% calculate EC50 as a function of num. of C8 molecules per cell
    par(1) = -0.0084;
    par(2) = 7.7452;
    EC50 = exp( par(1).* C8perCell + par(2) ) * 0.06;    
end