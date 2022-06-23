function DERIVED_PARAMETER(model)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%      
% Derived values from original species 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% Misc
% 
Host_compl_deposit = addspecies(model, 'Host compl deposit');
c1 = '[Host compl deposit] = [C3b host] + [iC3b host]  + [C3dg host] + [C3bBb host]';
c2 = '+ [C3bBbC3b host] + [MAC host] + [C3bB host] + [C3bBbC3bC5bC6 host]';
c3 = '+ [C5b7 host]  + [C5b8 host]';
c4 = '+ [C5b9_1 host]+[C5b9_2 host]+[C5b9_3 host]+[C5b9_4 host]+[C5b9_5 host]';
c5 = '+ [C5b9_6 host]+[C5b9_7 host]+[C5b9_8 host]+[C5b9_9 host]+[C5b9_10 host]';
c6 = '+ [C5b9_11 host]+[C5b9_12 host]+[C5b9_13 host]+[C5b9_14 host]+[C5b9_15 host]+[C5b9_16 host]';
Host_comp_deposit_rule   = [c1, c2, c3, c4, c5];
Host_compl_deposit.Notes = Host_comp_deposit_rule;
h_rule                   = addrule(model, Host_comp_deposit_rule, 'repeatedAssignment'); 

% 
Terminal_fluid_phase = addspecies(model, 'Terminal_fluid_phase');
c1 = '[Terminal_fluid_phase] = [hC5b7 fluid] + [C5b8 fluid] + [C5b7 micelle]';
c2 = '+                                [VnC5b7 fluid] + [VnC5b8 fluid] + [VnC5b9_1 fluid]';
c3 = '+                                [CnC5b7 fluid] + [CnC5b8 fluid] + [CnC5b9_1 fluid]';
c4 = '+                                [C5b9_1 fluid]';
Terminal_fluid_phase_rule  = [c1, c2, c3, c4];
Terminal_fluid_phase.Notes = Terminal_fluid_phase_rule;
tfp_rule                   = addrule(model, Terminal_fluid_phase_rule, 'repeatedAssignment'); 

%     
addspecies(model, 'sC5b9');
c1 = '[sC5b9] = [VnC5b9_1 fluid] + [CnC5b9_1 fluid] + [C5b9_1 fluid]';
sC5b9_rule  = c1;
addrule(model, sC5b9_rule, 'repeatedAssignment'); 

% C3b Antibody - according to Wilcox, 1991, Blood
C3d_Ab      = addspecies(model, 'C3d_Ab_Wilcox');
C3d_Ab_c1   = '[C3d_Ab_Wilcox] = [C3b host] + [iC3b host] + [iC3bP host] + [C3bBb host] + [C3bBbC3b host]';
C3d_Ab_c2   = '+ [C3bBbC3bCR1 host] + [C3bBbC3bDAF host] + [C3bBbC3bH host] + [C3bBbP host]';
C3d_Ab_c3   = '+ [C3bBbC3bP host] + [C3bBP host] + [C3bBbC3bPC5 host] + [C3bBbC3bC5 host] ';
C3d_Ab_c4   = '+ [C3bBbC3bPC5b host] + [C3bBbC3bC5b host] + [C3bBbC3bPC5bC6 host] + [C3bBbC3bC5bC6 host]';
C3d_Ab_c5   = '+ [C3bCR1 host] + [C3bH host] + [C3bB host] + [C3bBbH host] ';
C3d_Ab_c6   = '+ [C3bBbCR1 host] + [C3bBbDAF host] + [iC3bCR1 host] + [C3dg host]';
C3d_Ab_rule = [C3d_Ab_c1, C3d_Ab_c2, C3d_Ab_c3, C3d_Ab_c4, C3d_Ab_c5, C3d_Ab_c6];
C3dAb_rule  = addrule(model, C3d_Ab_rule, 'repeatedAssignment'); 

% C3b fluid species
C3b_fluid       = addspecies(model, 'C3b_fluid_sum');
C3b_fluid_c1    = '[C3b_fluid_sum] = nfC3b + nhC3b + [C3b fluid] + [C3bB fluid]';
C3b_fluid_c2    = '+ [C3bH fluid] + [C3bCR1 fluid] + [C3bBb fluid] + [C3bBbH fluid]';
C3b_fluid_c3    = '+ [C3bBbCR1 fluid] + [iC3b fluid] + [iC3bCR1 fluid] + [C3dg fluid]';
C3b_fluid_rule  = [C3b_fluid_c1, C3b_fluid_c2, C3b_fluid_c3];
C3bfluid_rule   = addrule(model, C3b_fluid_rule, 'repeatedAssignment'); 

% C3b surface deposition
C3b_surf_deposit        = addspecies(model, 'C3b_surf_deposit');
C3b_surf_deposit_c1     = '[C3b_surf_deposit] = [C3b host] + [iC3b host] + [iC3bP host] + [C3bBb host] + [C3bBbC3b host]';
C3b_surf_deposit_c2     = '+ [C3bBbC3bCR1 host] + [C3bBbC3bDAF host] + [C3bBbC3bH host] + [C3bBbP host]';
C3b_surf_deposit_c3     = '+ [C3bBbC3bP host] + [C3bBP host] + [C3bBbC3bPC5 host] + [C3bBbC3bC5 host] ';
C3b_surf_deposit_c4     = '+ [C3bBbC3bPC5b host] + [C3bBbC3bC5b host] + [C3bBbC3bPC5bC6 host] + [C3bBbC3bC5bC6 host]';
C3b_surf_deposit_c5     = '+ [C3bCR1 host] + [C3bH host] + [C3bB host] + [C3bBbH host] ';
C3b_surf_deposit_c6     = '+ [C3bBbCR1 host] + [C3bBbDAF host] + [iC3bCR1 host]';
C3b_surf_deposit_rule   = [C3b_surf_deposit_c1, C3b_surf_deposit_c2, C3b_surf_deposit_c3, C3b_surf_deposit_c4, C3b_surf_deposit_c5, C3b_surf_deposit_c6];
C3b_surf_deposit.Notes  = C3b_surf_deposit_rule;
c3bs_rule = addrule(model, C3b_surf_deposit_rule, 'repeatedAssignment'); 


% total surface
Total_surface        = addspecies(model, 'Total_surface', 'InitialAmountUnits', 'micromolarity');
Total_surface_c1     = '[Total_surface] = [Surface host] + [C3bBb host] + [C3bBbC3b host] + [C3bBbC3bCR1 host] + [C3b host]';
Total_surface_c2     = '+ [C3bBbC3bDAF host] + [C3bBbC3bH host] + [C3bBbP host] + [C3bBbC3bP host] + [C3bBP host]';
Total_surface_c3     = '+ [iC3b host] + [iC3bP host] + [C3bBbC3bPC5 host] + [C3bBbC3bC5 host] + [C3bBbC3bPC5b host]';
Total_surface_c4     = '+ [C3bBbC3bC5b host] + [C3bBbC3bPC5bC6 host] + [C3bBbC3bC5bC6 host] + 4 * [C5b7 host] + [C3bCR1 host]';
Total_surface_c5     = '+ [C3bH host] + [C3bB host] + [C3bBbH host] + [C3bBbCR1 host] + [C3bBbDAF host]';
Total_surface_c6     = '+ [iC3bCR1 host] + [C3dg host] + 4 * [C5b8 host] + 4 * [C5b9_1 host] + 4 * [C5b9_2 host]';
Total_surface_c7     = '+ 4 * [C5b9_3 host] + 4 * [C5b9_4 host] + 4 * [C5b9_5 host] + 4 * [C5b9_6 host] + 4 * [C5b9_7 host]';
Total_surface_c8     = '+ 4 * [C5b9_8 host] + 4 * [C5b9_9 host] + 4 * [C5b9_10 host] + 4 * [C5b9_11 host] + 4 * [C5b9_12 host]';
Total_surface_c9     = '+ 4 * [C5b9_13 host] + 4 * [C5b9_14 host] + 4 * [C5b9_15 host] + 4 * [C5b9_16 host] + 4 * [C5b9_17 host]';
Total_surface_c10     = '+ 4 * [MAC host] + 4 * [CD59C5b9_1 host]';
Total_surface_rule   = [Total_surface_c1, Total_surface_c2, Total_surface_c3, Total_surface_c4, Total_surface_c5, Total_surface_c6, Total_surface_c7, Total_surface_c8, Total_surface_c9, Total_surface_c10];
Total_surface.Notes  = Total_surface_rule;
TS_rule = addrule(model, Total_surface_rule, 'repeatedAssignment'); 



% Free C3bBbC3b + C3bBbC3bP on surface
C3bBbC3b_P_sum        = addspecies(model, 'C3bBbC3b_P_sum');
C3bBbC3b_P_sum_rule   = '[C3bBbC3b_P_sum] = [C3bBbC3b host] + [C3bBbC3bP host]';
addrule(model, C3bBbC3b_P_sum_rule, 'repeatedAssignment'); 



%% ugml species
C3_MW     = addparameter(model, 'C3_MW',   185000,...
            'notes', 'Molecular weight of C3', 'ValueUnits', 'dimensionless'); 
C3a_MW    = addparameter(model, 'C3a_MW',  9000,...
            'notes', 'Molecular weight of C3a',   'ValueUnits', 'dimensionless'); 
C3b_MW    = addparameter(model, 'C3b_MW',  176000,...
            'notes', 'Molecular weight of C33', 'ValueUnits', 'dimensionless'); 
iC3b_MW   = addparameter(model, 'iC3b_MW', 67000+45000+75000,...
            'notes', 'Molecular weight of iC3b', 'ValueUnits', 'dimensionless'); 
C3dg_MW   = addparameter(model, 'C3dg_MW', 38000,...
            'notes', 'Molecular weight of C3dg',  'ValueUnits', 'dimensionless'); 

C5_MW     = addparameter(model, 'C5_MW',  191000,...
            'notes', 'Molecular weight of C5',  'ValueUnits', 'dimensionless'); 
C5a_MW    = addparameter(model, 'C5a_MW', 11200,...
            'notes', 'Molecular weight of C5a',   'ValueUnits', 'dimensionless'); 
C5b_MW    = addparameter(model, 'C5b_MW', 180000,...
            'notes', 'Molecular weight of C5b',  'ValueUnits', 'dimensionless'); 

C6_MW     = addparameter(model, 'C6_MW', 120000,...
            'notes', 'Molecular weight of C6', 'ValueUnits', 'dimensionless'); 
C7_MW     = addparameter(model, 'C7_MW', 110000,...
            'notes', 'Molecular weight of C7', 'ValueUnits', 'dimensionless'); 
C8_MW     = addparameter(model, 'C8_MW', 151000,...
            'notes', 'Molecular weight of C8', 'ValueUnits', 'dimensionless'); 
C9_MW     = addparameter(model, 'C9_MW', 71000,...
            'notes', 'Molecular weight of C9',  'ValueUnits', 'dimensionless'); 

Ba_MW     = addparameter(model, 'Ba_MW', 30000,...
            'notes', 'Molecular weight of Ba',  'ValueUnits', 'dimensionless'); 
Bb_MW     = addparameter(model, 'Bb_MW', 63000,...
            'notes', 'Molecular weight of Bb',  'ValueUnits', 'dimensionless'); 
B_MW      = addparameter(model, 'B_MW',  93000,...
            'notes', 'Molecular weight of B',  'ValueUnits', 'dimensionless'); 
D_MW      = addparameter(model, 'D_MW',  24000,...
            'notes', 'Molecular weight of D',  'ValueUnits', 'dimensionless'); 

I_MW      = addparameter(model, 'I_MW',   88000,...
            'notes', 'Molecular weight of I', 'ValueUnits', 'dimensionless'); 
P_MW      = addparameter(model, 'P_MW',   53000,...
            'notes', 'Molecular weight of P', 'ValueUnits', 'dimensionless'); 
H_MW      = addparameter(model, 'H_MW',   155000,...
            'notes', 'Molecular weight of H','ValueUnits', 'dimensionless'); 
CR1_MW    = addparameter(model, 'CR1_MW', 190000,...
            'notes', 'Molecular weight of CR1','ValueUnits', 'dimensionless'); 
DAF_MW    = addparameter(model, 'DAF_MW', 70000,...
            'notes', 'Molecular weight of DAF', 'ValueUnits', 'dimensionless'); 
Vn_MW     = addparameter(model, 'Vn_MW',  83000,...
            'notes', 'Molecular weight of Vn', 'ValueUnits', 'dimensionless'); 
Cn_MW     = addparameter(model, 'Cn_MW',  80000,...
            'notes', 'Molecular weight of Cn', 'ValueUnits', 'dimensionless'); 
CD59_MW   = addparameter(model, 'CD59_MW',18000,...
            'notes', 'Molecular weight of CD59', 'ValueUnits', 'dimensionless'); 

% uM = umole/L -- ug/L 
C3_ugmL = addspecies(model, 'C3_ugmL');
addrule(model, 'C3_ugmL = C3 * C3_MW / 1000', 'repeatedAssignment'); 
C3a_ugmL = addspecies(model, 'C3a_ugmL');
addrule(model, 'C3a_ugmL = C3a * C3a_MW / 1000', 'repeatedAssignment');
C3b_fluid_ugmL = addspecies(model, 'C3b_fluid_ugmL');
addrule(model, 'C3b_fluid_ugmL = [C3b fluid] * C3b_MW / 1000', 'repeatedAssignment');
C3b_host_ugmL = addspecies(model, 'C3b_host_ugmL');
addrule(model, 'C3b_host_ugmL = [C3b host] * C3b_MW / 1000', 'repeatedAssignment');
iC3b_fluid_ugmL = addspecies(model, 'iC3b_fluid_ugmL');
addrule(model, 'iC3b_fluid_ugmL = [iC3b fluid] * iC3b_MW / 1000', 'repeatedAssignment');
iC3b_host_ugmL = addspecies(model, 'iC3b_host_ugmL');
addrule(model, 'iC3b_host_ugmL = [iC3b host] * iC3b_MW / 1000', 'repeatedAssignment');

C3dg_host_ugmL = addspecies(model, 'C3dg_host_ugmL');
addrule(model, 'C3dg_host_ugmL = [C3dg host] * C3dg_MW / 1000', 'repeatedAssignment');
C3dg_fluid_ugmL = addspecies(model, 'C3dg_fluid_ugmL');
addrule(model, 'C3dg_fluid_ugmL = [C3dg fluid] * C3dg_MW / 1000', 'repeatedAssignment');

C5_ugmL = addspecies(model, 'C5_ugmL');
addrule(model, 'C5_ugmL = C5 * C5_MW / 1000', 'repeatedAssignment');
C5a_ugmL = addspecies(model, 'C5a_ugmL');
addrule(model, 'C5a_ugmL = C5a * C5a_MW / 1000', 'repeatedAssignment');

C6_ugmL = addspecies(model, 'C6_ugmL');
addrule(model, 'C6_ugmL = C6 * C6_MW / 1000', 'repeatedAssignment');
C7_ugmL = addspecies(model, 'C7_ugmL');
addrule(model, 'C7_ugmL = C7 * C7_MW / 1000', 'repeatedAssignment');
C8_ugmL = addspecies(model, 'C8_ugmL');
addrule(model, 'C8_ugmL = C8 * C8_MW / 1000', 'repeatedAssignment');
C9_ugmL = addspecies(model, 'C9_ugmL');
addrule(model, 'C9_ugmL = C9 * C9_MW / 1000', 'repeatedAssignment');

%Ba_ugmL = addspecies(model, 'Ba_ugmL');
%addrule(model, 'Ba_ugmL = Ba * Ba_MW / 1000', 'repeatedAssignment');
Bb_ugmL = addspecies(model, 'Bb_ugmL');
addrule(model, 'Bb_ugmL = Bb * Bb_MW / 1000', 'repeatedAssignment');
B_ugmL = addspecies(model, 'B_ugmL');
addrule(model, 'B_ugmL = B * B_MW / 1000', 'repeatedAssignment');
D_ugmL = addspecies(model, 'D_ugmL');
addrule(model, 'D_ugmL = D * D_MW / 1000', 'repeatedAssignment');

I_ugmL = addspecies(model, 'I_ugmL');
addrule(model, 'I_ugmL = I * I_MW / 1000', 'repeatedAssignment');
%P_ugmL = addspecies(model, 'P_ugmL');
%addrule(model, 'P_ugmL = P * D_MW / 1000', 'repeatedAssignment');
H_ugmL = addspecies(model, 'H_ugmL');
addrule(model, 'H_ugmL = H * H_MW / 1000', 'repeatedAssignment');
CR1_ugmL = addspecies(model, 'CR1_ugmL');
addrule(model, 'CR1_ugmL = CR1 * CR1_MW / 1000', 'repeatedAssignment');
DAF_ugmL = addspecies(model, 'DAF_ugmL');
addrule(model, 'DAF_ugmL = DAF * DAF_MW / 1000', 'repeatedAssignment');
Vn_ugmL = addspecies(model, 'Vn_ugmL');
addrule(model, 'Vn_ugmL = Vn * Vn_MW / 1000', 'repeatedAssignment');
Cn_ugmL = addspecies(model, 'Cn_ugmL');
addrule(model, 'Cn_ugmL = Cn * Cn_MW / 1000', 'repeatedAssignment');
CD59_ugmL = addspecies(model, 'CD59_ugmL');
addrule(model, 'CD59_ugmL = CD59 * CD59_MW / 1000', 'repeatedAssignment');



%% Hemolysis
% Hemolysis - Takeda
% s1 = addspecies(model, 'Percent_Lysis_Takeda');
s1 =  addparameter(model, 'Percent_Lysis_Takeda', 0,...
    'notes', 'Lyis in percent based on Takeda', 'ValueUnits', 'dimensionless');
set(s1, 'ConstantValue', false);

% rule1 = addrule(model, 'Percent_Lysis_Takeda = Hemolysis_Takeda([MAC host]/cells_uM)',...
%                 'repeatedAssignment'); 
% rule1 = addrule(model, 'Percent_Lysis_Takeda = Hemolysis_Takeda([MAC host], cells_uM)',...
%                 'repeatedAssignment');      
% rule1 = addrule(model, 'Percent_Lysis_Takeda = Hemolysis_Takeda([MAC host], Erythrocytes_uM)',...
%                 'repeatedAssignment');      
rule1 = addrule(model, 'Percent_Lysis_Takeda = Hemolysis_Takeda([MAC host], Total_surface, Surface_per_cell)',...
                'repeatedAssignment');     
            
% Hemoplysis - Kolb
NumC8 = addspecies(model, 'NumC8 host');
NumC8_c1 = '[NumC8 host] = [C5b8 host] + [C5b9_1 host] + [C5b9_2 host] + [C5b9_3 host] + [C5b9_4 host]';
NumC8_c2 = '+ [C5b9_5 host] + [C5b9_6 host] + [C5b9_7 host] + [C5b9_8 host] + [C5b9_9 host] + [C5b9_10 host] ';
NumC8_c3 = '+ [C5b9_11 host] + [C5b9_12 host] + [C5b9_13 host] + [C5b9_14 host] + [C5b9_15 host] + [C5b9_16 host] ';
NumC8_c4 = '+ [C5b9_17 host] + [MAC host] ';
NumC8_rule = [NumC8_c1, NumC8_c2, NumC8_c3, NumC8_c4];
nc8_rule = addrule(model, NumC8_rule, 'repeatedAssignment'); 

NumC9 = addspecies(model, 'NumC9 host');
NumC9_c1 = '[NumC9 host] = [C5b9_1 host] * 1 + [C5b9_2 host] * 2 + [C5b9_3 host] * 3 + [C5b9_4 host] * 4';
NumC9_c2 = '+ [C5b9_5 host] * 5 + [C5b9_6 host] * 6 + [C5b9_7 host] * 7 + [C5b9_8 host] * 8 + [C5b9_9 host] * 9 + [C5b9_10 host] * 10';
NumC9_c3 = '+ [C5b9_11 host] * 11 + [C5b9_12 host] * 12 + [C5b9_13 host] * 13 + [C5b9_14 host] * 14 + [C5b9_15 host] * 15 + [C5b9_16 host] * 16 ';
NumC9_c4 = '+ [C5b9_17 host] * 17 + [MAC host] * 18';
NumC9_rule = [NumC9_c1 ,NumC9_c2, NumC9_c3, NumC9_c4];
nc8_rule = addrule(model, NumC9_rule, 'repeatedAssignment'); 

% s2 = addspecies(model, 'Percent_Lysis_Kolb');
s2 =  addparameter(model, 'Percent_Lysis_Kolb', 0,...
    'notes', 'Lyis in percent based on Kolb', 'ValueUnits', 'dimensionless');
set(s2, 'ConstantValue', false);

% rule2 = addrule(model, 'Percent_Lysis_Kolb = Hemolysis_Kolb( [NumC8 host]/cells_uM, [NumC9 host]/cells_uM)',...
%                 'repeatedAssignment');
% rule2 = addrule(model, 'Percent_Lysis_Kolb = Hemolysis_Kolb( [NumC8 host], [NumC9 host], cells_uM)',...
%                 'repeatedAssignment');
% rule2 = addrule(model, 'Percent_Lysis_Kolb = Hemolysis_Kolb( [NumC8 host], [NumC9 host], Erythrocytes_uM)',...
%                 'repeatedAssignment');
rule2 = addrule(model, 'Percent_Lysis_Kolb = Hemolysis_Kolb( [NumC8 host], [NumC9 host], Total_surface, Surface_per_cell)',...
                'repeatedAssignment');
            
% Hemolysis - average
s3 =  addparameter(model, 'Percent_Lysis_Mean', 0,...
    'notes', 'Lyis in percent as mean from lysis based on Takeda and Kolb', 'ValueUnits', 'dimensionless');
set(s3, 'ConstantValue', false);
rule3 = addrule(model, 'Percent_Lysis_Mean = (Percent_Lysis_Kolb + Percent_Lysis_Takeda) / 2',...
                'repeatedAssignment');
            


%% Hematological readouts
addspecies(model, 'Erythrocytes_uM');    
addrule(model, 'Erythrocytes_uM = Total_surface / Surface_per_cell', 'repeatedAssignment');
     
Hemoglobin_MW      = addparameter(model, 'Hemoglobin_MW',   64500,...
            'notes', 'Molecular weight of hemoglobin', 'ValueUnits', 'dimensionless'); 
Hemoglobin_Per_RBC = addparameter(model, 'Hemoglobin_Per_RBC',   270E6,...
            'notes', 'Number of hemoglobin molecules per cell', 'ValueUnits', 'dimensionless'); 
        
Hemoglobin_g_dL      = addspecies(model, 'Hemoglobin_g_dL');                                   
Hemoglobin_g_dL_rule = 'Hemoglobin_g_dL = Erythrocytes_uM * 1E-6 * Hemoglobin_Per_RBC * Hemoglobin_MW / 10';
addrule(model, Hemoglobin_g_dL_rule, 'repeatedAssignment');


Avogadro      = addparameter(model, 'Avogadro',   6.022140857*10^23,...
            'notes', 'Avogadro constant [1/mol]', 'ValueUnits', 'dimensionless'); 

Erythrocytes_N_L   = addspecies(model, 'Erythrocytes_N_L');

Erythrocytes_N_L_rule = 'Erythrocytes_N_L = Erythrocytes_uM / 1E6 * Avogadro';
addrule(model, Erythrocytes_N_L_rule, 'repeatedAssignment');

Volume_RBC      = addparameter(model, 'Volume_RBC',   90E-15,...
            'notes', 'Volume of a single eryhthrocyte', 'ValueUnits', 'dimensionless');        

Hematocrit_Percent      = addspecies(model, 'Hematocrit_Percent');
                               
Hematocrit_Percent_rule = 'Hematocrit_Percent = Erythrocytes_N_L * Volume_RBC * 100';
addrule(model, Hematocrit_Percent_rule, 'repeatedAssignment');


LDH_U_L   = addspecies(model, 'LDH_U_L');
LDH_U_L_rule = 'LDH_U_L = calculate_LDH(Hemoglobin_g_dL)';
addrule(model, LDH_U_L_rule, 'repeatedAssignment');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%