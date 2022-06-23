function [model] = define_scenarios(model)

MW = get_MW();


%% Add a variant for fluid phase 
fluidPhase = sbiovariant('FluidPhase',...
     'Notes', 'This variant has the fluid phase only');
  
addcontent(fluidPhase, {'species', 'Surface host','InitialAmount', 0});
addvariant(model, fluidPhase);


%% Add a variant for Pangburn 1981 experiment (1/3)
% Units in paper are ug/mL
pangburn_var = sbiovariant('pangburn_var',...
     'Notes', 'This variant has the fluid phase only');
  
addcontent(pangburn_var, {'species', 'Surface host','InitialAmount', 0});
addcontent(pangburn_var, {'species', 'C3', 'InitialAmount', 1200/MW.C3*1000});
addcontent(pangburn_var, {'species', 'B',  'InitialAmount', 200 /MW.B *1000});
addcontent(pangburn_var, {'species', 'D',  'InitialAmount', 2   /MW.D *1000});
addcontent(pangburn_var, {'species', 'I',  'InitialAmount', 34  /MW.I *1000});
addcontent(pangburn_var, {'species', 'H',  'InitialAmount', 465 /MW.H *1000});
addcontent(pangburn_var, {'species', 'CR1','InitialAmount', 0});
addvariant(model, pangburn_var);


%% Add a variant for Pangburn 1981 experiment (2/3)
% Units in paper are ug/mL
pangburn_NoFIHBD_var = sbiovariant('pangburn_NoFIHBD_var',...
     'Notes', 'This variant has the fluid phase only without factors I, H, B, D, CR1');

addcontent(pangburn_NoFIHBD_var, {'species', 'Surface host','InitialAmount', 0});
addcontent(pangburn_NoFIHBD_var, {'species', 'C3',  'InitialAmount', 1200/MW.C3*1000});
addcontent(pangburn_NoFIHBD_var, {'species', 'B',   'InitialAmount', 0});
addcontent(pangburn_NoFIHBD_var, {'species', 'D',   'InitialAmount', 0});
addcontent(pangburn_NoFIHBD_var, {'species', 'I',   'InitialAmount', 0});
addcontent(pangburn_NoFIHBD_var, {'species', 'H',   'InitialAmount', 0});
addcontent(pangburn_NoFIHBD_var, {'species', 'CR1', 'InitialAmount', 0});
addvariant(model, pangburn_NoFIHBD_var);


%% Add a variant for Pangburn 1981 experiment (3/3)
% Units in paper are ug/mL
pangburn_NoFIH_var = sbiovariant('pangburn_NoFIH_var',...
     'Notes', 'This variant has the fluid phase only without factors I, H, CR1');

addcontent(pangburn_NoFIH_var, {'species', 'Surface host','InitialAmount', 0});
addcontent(pangburn_NoFIH_var, {'species', 'C3',  'InitialAmount', 1200/MW.C3*1000});
addcontent(pangburn_NoFIH_var, {'species', 'B',   'InitialAmount', 200 /MW.B *1000});
addcontent(pangburn_NoFIH_var, {'species', 'D',   'InitialAmount', 2   /MW.D *1000});
addcontent(pangburn_NoFIH_var, {'species', 'I',   'InitialAmount', 0});
addcontent(pangburn_NoFIH_var, {'species', 'H',   'InitialAmount', 0});
addcontent(pangburn_NoFIH_var, {'species', 'CR1', 'InitialAmount', 0});
addvariant(model, pangburn_NoFIH_var);


%% Add a variant for different initial conditions in the retina
% Initial conditions for RETINA in uM
C3_0_ret        =  0.5;
C5_0_ret        =  0.037;
C6_0_ret        =  0.05;
C7_0_ret        =  0.05;
C8_0_ret        =  0.036;
C9_0_ret        =  0.09;

B_0_ret         =  0.003;
D_0_ret         =  0.003;

I_0_ret         =  0.0013;
Properdin_0_ret =  0;
H_0_ret         =  0.0008;
CR1_0_ret       =  0.0083/10;
DAF_0_ret       =  0.027/10;
Vn_0_ret        =  6/10;
Cn_0_ret        =  0.43/10;
CD59_0_ret      =  0.21/10;

retina_var = sbiovariant('Retina',...
     'Notes', 'This is the variant for retina concentrations');
 
addcontent(retina_var, {'species', 'C3', 'InitialAmount', C3_0_ret});
addcontent(retina_var, {'species', 'C5', 'InitialAmount', C5_0_ret});
addcontent(retina_var, {'species', 'C6', 'InitialAmount', C6_0_ret});
addcontent(retina_var, {'species', 'C7', 'InitialAmount', C7_0_ret});
addcontent(retina_var, {'species', 'C8', 'InitialAmount', C8_0_ret});
addcontent(retina_var, {'species', 'C9', 'InitialAmount', C9_0_ret});

addcontent(retina_var, {'species', 'B', 'InitialAmount', B_0_ret});
addcontent(retina_var, {'species', 'D', 'InitialAmount', D_0_ret});
addcontent(retina_var, {'species', 'I', 'InitialAmount', I_0_ret});
addcontent(retina_var, {'species', 'Properdin', 'InitialAmount', 0});
addcontent(retina_var, {'species', 'H', 'InitialAmount', H_0_ret});
addcontent(retina_var, {'species', 'CR1', 'InitialAmount', CR1_0_ret});
addcontent(retina_var, {'species', 'DAF', 'InitialAmount', DAF_0_ret});
addcontent(retina_var, {'species', 'Vn', 'InitialAmount',  Vn_0_ret});
addcontent(retina_var, {'species', 'Cn', 'InitialAmount',  Cn_0_ret});
addcontent(retina_var, {'species', 'CD59', 'InitialAmount', CD59_0_ret});


% Half life (s)
half_life = 5*24*60*60;
k_el = log(2)/half_life;

addcontent(retina_var, {'parameter', 'k_el_C3', 'Value', k_el});
addcontent(retina_var, {'parameter', 'k_el_C5', 'Value', k_el});
addcontent(retina_var, {'parameter', 'k_el_C6', 'Value', k_el});
addcontent(retina_var, {'parameter', 'k_el_C7', 'Value', k_el});
addcontent(retina_var, {'parameter', 'k_el_C8', 'Value', k_el});
addcontent(retina_var, {'parameter', 'k_el_C9', 'Value', k_el});

addcontent(retina_var, {'parameter', 'k_el_D',  'Value', k_el});
addcontent(retina_var, {'parameter', 'k_el_B',  'Value', k_el});

addcontent(retina_var, {'parameter', 'k_el_I',  'Value', k_el});
addcontent(retina_var, {'parameter', 'k_el_H',  'Value', k_el});
addcontent(retina_var, {'parameter', 'k_el_CR1','Value', k_el});
addcontent(retina_var, {'parameter', 'k_el_CD59','Value', k_el});

addcontent(retina_var, {'parameter', 'k_el_Cn', 'Value', k_el});
addcontent(retina_var, {'parameter', 'k_el_Vn', 'Value', k_el});

addvariant(model, retina_var);


%% Add a variant without C3bBbh Complex decay - for analysis of Bb binder
No_C3bBbH_CmplxDecay_var = sbiovariant('No_C3bBbH_CmplxDecay_var',...
     'Notes', 'This variant has diasbled C3bBbH complex decay');
addcontent(No_C3bBbH_CmplxDecay_var, {'parameter', 'k_m_C3bBbH decay',  'Value', 0});
addvariant(model, No_C3bBbH_CmplxDecay_var);


%% Add a variant with different ICs for C3 - for analysis of Bb binder
Increased_C3_2_var = sbiovariant('Increased_C3_2_var',...
     'Notes', 'This variant has 2-fold increased inital levels of C3');
addcontent(Increased_C3_2_var, {'species', 'C3', 'InitialAmount', 5.4*2});
addvariant(model, Increased_C3_2_var);

Increased_C3_3_var = sbiovariant('Increased_C3_3_var',...
     'Notes', 'This variant has 3-fold increased inital levels of C3');
addcontent(Increased_C3_3_var, {'species', 'C3', 'InitialAmount', 5.4*3});
addvariant(model, Increased_C3_3_var);

Increased_C3_5_var = sbiovariant('Increased_C3_5_var',...
     'Notes', 'This variant has 10-fold increased inital levels of C3');
addcontent(Increased_C3_5_var, {'species', 'C3', 'InitialAmount', 5.4*10});
addvariant(model, Increased_C3_5_var);



%% Regulation variants
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Add a variant without DAF
regulators_NoDAF_var = sbiovariant('regulators_NoDAF_var',...
     'Notes', 'This variant has IC for DAF set to 0');
addcontent(regulators_NoDAF_var, {'species', 'DAF', 'InitialAmount', 0});
addvariant(model, regulators_NoDAF_var);


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Add a variant without CR1
regulators_NoCR1_var = sbiovariant('regulators_NoCR1_var',...
     'Notes', 'This variant has IC for CR1 set to 0');
addcontent(regulators_NoCR1_var, {'species', 'CR1', 'InitialAmount', 0});
addvariant(model, regulators_NoCR1_var);


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Add a variant without FH
regulators_NoH_var = sbiovariant('regulators_NoH_var',...
     'Notes', 'This variant has IC for H set to 0');
addcontent(regulators_NoH_var, {'species', 'H', 'InitialAmount', 0});
% addcontent(regulators_NoH_var, {'parameter', 'k_p_C3bH',  'Value', 0});
% addcontent(regulators_NoH_var, {'parameter', 'k_p_C3bH_surf',  'Value', 0});
addvariant(model, regulators_NoH_var);


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Add a variant without CD59
regulators_NoCD59_var = sbiovariant('regulators_NoCD59_var',...
     'Notes', 'This variant has IC for CD59 set to 0');
addcontent(regulators_NoCD59_var, {'species', 'CD59', 'InitialAmount', 0});
addvariant(model, regulators_NoCD59_var);


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Add a variant without VN & CN
regulators_NoVnCn_var = sbiovariant('regulators_NoVnCn_var',...
     'Notes', 'This variant has IC for Vn & Cn set to 0');
addcontent(regulators_NoVnCn_var, {'species', 'Vn', 'InitialAmount', 0});
addcontent(regulators_NoVnCn_var, {'species', 'Cn', 'InitialAmount', 0});
addvariant(model, regulators_NoVnCn_var);

regulators_NoVn_var = sbiovariant('regulators_NoVn_var',...
     'Notes', 'This variant has IC for Vn & Cn set to 0');
addcontent(regulators_NoVn_var, {'species', 'Vn', 'InitialAmount', 0});
addvariant(model, regulators_NoVn_var);

regulators_NoCNn_var = sbiovariant('regulators_NoCn_var',...
     'Notes', 'This variant has IC for Vn & Cn set to 0');
addcontent(regulators_NoCNn_var, {'species', 'Cn', 'InitialAmount', 0});
addvariant(model, regulators_NoCNn_var);

    
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Add a variant with reduced binding of FH to surface bound proteins
regulators_reduced_H_binding_var = sbiovariant('regulators_reduced_H_binding_var',...
     'Notes', 'This variant has reduced binding of H to surface proteins');
addcontent(regulators_reduced_H_binding_var, {'parameter', 'k_p_C3bH_surf',  'Value', 5.2e6/10});
addvariant(model, regulators_reduced_H_binding_var);


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Add a variant with no binding of FH to surface bound proteins
regulators_no_H_binding_var = sbiovariant('regulators_no_H_binding_var',...
     'Notes', 'This variant has disabled binding of H to surface proteins');
addcontent(regulators_no_H_binding_var, {'parameter', 'k_p_C3bH_surf',  'Value', 0});
addvariant(model, regulators_no_H_binding_var);


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Add a variant with increased C3b surface binding rate
increased_C3_surf_binding_var = sbiovariant('increased_C3_surf_binding_var',...
     'Notes', 'This variant has increased binding of C3b to the surface');
addcontent(increased_C3_surf_binding_var, {'parameter', 'k_p_C3b_surface',  'Value', 4.2e8*50});
addcontent(increased_C3_surf_binding_var, {'parameter', 'k_p_hC3b',  'Value', 4.2e8*50});
addvariant(model, increased_C3_surf_binding_var);


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Add a variant without Properdim
regulators_NoP_var = sbiovariant('regulators_NoP_var',...
     'Notes', 'This variant has IC for P set to 0');
addcontent(regulators_NoP_var, {'species', 'P', 'InitialAmount', 0});
addvariant(model, regulators_NoP_var);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Add a variant without FI
regulators_NoI_var = sbiovariant('regulators_NoI_var',...
     'Notes', 'This variant has IC for I set to 0');
addcontent(regulators_NoI_var, {'species', 'I', 'InitialAmount', 0});
addvariant(model, regulators_NoI_var);
end