function [Surface_0, cells_uM, C3b_bindingSites_uM, MAC_bindingSites_uM] = get_surface_erythrocytes(N_cells, r_erythrocyte)
% calculates initial surface, cell conc. in uM, Number of C3b and Mac
% binding sites
% takes the following inputs:
% N_cells:        optional input
%                 Number of cells in cells/liter, default: 5E12
% r_erythrocyte:  optional input
%                 radius of erythrocyte in meter, default: 3.4 um
% if only one input is given, the function assumes that N_cells has been
% given as input and r_erytrhocyte should be the standard value!

%% check how many inputs have been given and set to default value if missing 
if nargin == 1
    r_erythrocyte   = 3.4*10^-6;            % Erythrocyte radius in meter                 
elseif nargin == 0
    N_cells         = 5*10^12;              % Erythrocyte in blood  (cells/L), Zewde
    r_erythrocyte   = 3.4*10^-6;            % Erythrocyte radius in meter                 
end

%% calculate outputs
avogadro    = 6.022140857*10^23;                  
cells_uM    = N_cells * 10^6 / avogadro;

A_erythrocyte = 4*pi*r_erythrocyte^2; %  Square Meter
 
C3b_bindingSites_perCell = A_erythrocyte / (100*10^-10 *100*10^-10);         
MAC_bindingSites_perCell = C3b_bindingSites_perCell / 4; 

C3b_bindingSites_uM = C3b_bindingSites_perCell * cells_uM;
MAC_bindingSites_uM = MAC_bindingSites_perCell * cells_uM;

Surface_0 = C3b_bindingSites_uM;
end
