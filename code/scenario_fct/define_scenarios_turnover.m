function [model] = define_scenarios_turnover(model)


%%
% CR1_correction_factor = 1; %1.5
scaling_Tyical_T = 2.2;
% scaling_Tyical_T = 2 / 3;

%% general definitions
%%% changed parameters for in-vivo model wrt to in-vitro model
new.k_p_C3_H20      = get(sbioselect(model,'Type','parameter','Where','Name', '==', 'k_p_C3(H20)'),  'Value') / 1E2 ; % 100 fold reduced 
new.k_p_C3b_surface = get(sbioselect(model,'Type','parameter','Where','Name', '==', 'k_p_C3b_surface'),  'Value') / 1E5 ; % 1000 fold reduced 
% new.k_p_hC3b        = 4.2e+10; % 100 fold reduced 

%%% Eliminiations, 1/second
k_el.C3   = log(2) / (41.7 * 3600); % 
k_el.C5   = log(2) / (43.0 * 3600); %  
k_el.C6   = log(2) / (20.2 * 3600); % 
k_el.C7   = log(2) / (16.8 * 3600); % 
k_el.C8   = log(2) / (32.8 * 3600); % 
k_el.C9   = log(2) / (11.6 * 3600); % 
k_el.D    = log(2) / ( 3.0 * 3600); % 
k_el.B    = log(2) / (17.0 * 3600); % 
k_el.I    = log(2) / (15.7 * 3600); % 
k_el.P    = log(2) / ( 7.6 * 3600); % 
k_el.H    = log(2) / (33.8 * 3600); % 6 days, https://www.ncbi.nlm.nih.gov/pmc/articles/PMC2276938/
k_el.Vn   = log(2) / (12.5 * 3600); % 8 h (rabbit), https://www.ncbi.nlm.nih.gov/pubmed/8918593
k_el.Cn   = log(2) / (12.5 * 3600); % 2 h, https://www.ncbi.nlm.nih.gov/pubmed/19137541

k_el.iC3b = log(2) / (39.4 * 3600); % 

k_el.Ba   = log(2) / ( 4.1 * 3600); % (0.0333  * 3600); % 2 minutes   Assume T1/2 of 3 minutes
k_el.Bb   = log(2) / ( 9.1 * 3600); % (0.0333  * 3600); % 2 minutes   Assume T1/2 of 3 minutes

k_el.C3a  = log(2) / (0.5   * 3600); %
k_el.C5a  = log(2) / (0.017 * 3600); %
k_el.C3dg = log(2) / (0.067 * 3600); %

k_el.C5b_species = ...
            log(2) / (43.0 * 3600); %

k_el_erythrocyte = ...
            log(2) / (1440    * 3600); % 60 days

%%% Productions, uM/s
k_pr.CR1 = k_el_erythrocyte * 0.0083*1E-6;
k_pr.CD59 = k_el_erythrocyte * 0.21*1E-6;
k_pr.DAF  = k_el_erythrocyte * 0.027*1E-6;


%% turnover variant without surface turnover - surface proteins accumulate
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% turnover_var_No_Surface_Turnover = sbiovariant('turnover_var_no_surface_turnover',...
%      'Notes', 'This variant is with turnover of complement w/o surface turnover as initially implemented');
% 
% % Units in 1/seconds
% %%% surface proteins
% addcontent(turnover_var_No_Surface_Turnover, {'parameter', 'k_el_CR1',             'Value', 0}); % surface protein
% addcontent(turnover_var_No_Surface_Turnover, {'parameter', 'k_el_CD59',            'Value', 0}); % surface protein
% addcontent(turnover_var_No_Surface_Turnover, {'parameter', 'k_el_DAF',             'Value', 0}); % surface protein.
% 
% addcontent(turnover_var_No_Surface_Turnover, {'parameter', 'k_el_SurfaceProtein',  'Value', 0}); % generic surface protein
% 
% %%% Fluid phase proteins
% addcontent(turnover_var_No_Surface_Turnover, {'parameter', 'k_el_C3', 'Value', k_el.C3}); 
% addcontent(turnover_var_No_Surface_Turnover, {'parameter', 'k_el_C5', 'Value', k_el.C5});
% addcontent(turnover_var_No_Surface_Turnover, {'parameter', 'k_el_C6', 'Value', k_el.C6});
% addcontent(turnover_var_No_Surface_Turnover, {'parameter', 'k_el_C7', 'Value', k_el.C7});
% addcontent(turnover_var_No_Surface_Turnover, {'parameter', 'k_el_C8', 'Value', k_el.C8}); 
% addcontent(turnover_var_No_Surface_Turnover, {'parameter', 'k_el_C9', 'Value', k_el.C9});
% addcontent(turnover_var_No_Surface_Turnover, {'parameter', 'k_el_D',  'Value', k_el.D});
% addcontent(turnover_var_No_Surface_Turnover, {'parameter', 'k_el_B',  'Value', k_el.B});
% addcontent(turnover_var_No_Surface_Turnover, {'parameter', 'k_el_I',  'Value', k_el.I});
% addcontent(turnover_var_No_Surface_Turnover, {'parameter', 'k_el_P',  'Value', k_el.P});
% 
% addcontent(turnover_var_No_Surface_Turnover, {'parameter', 'k_el_H',  'Value', k_el.H});
% addcontent(turnover_var_No_Surface_Turnover, {'parameter', 'k_el_Vn', 'Value', k_el.Vn});
% addcontent(turnover_var_No_Surface_Turnover, {'parameter', 'k_el_Cn', 'Value', k_el.Cn});
% 
% %%% more fluid phase proteins
% addcontent(turnover_var_No_Surface_Turnover, {'parameter', 'k_el_Ba',    'Value', k_el.Ba});
% addcontent(turnover_var_No_Surface_Turnover, {'parameter', 'k_el_Bb',    'Value', k_el.Bb});
% addcontent(turnover_var_No_Surface_Turnover, {'parameter', 'k_el_C3a',   'Value', k_el.C3a});
% addcontent(turnover_var_No_Surface_Turnover, {'parameter', 'k_el_C5a',   'Value', k_el.C5a});
% addcontent(turnover_var_No_Surface_Turnover, {'parameter',  'k_el_C5b_species',  'Value', k_el.C5b_species});
% addcontent(turnover_var_No_Surface_Turnover, {'parameter',  'k_el_iC3b', 'Value', k_el.iC3b});
% addcontent(turnover_var_No_Surface_Turnover, {'parameter',  'k_el_C3dg', 'Value',  k_el.C3dg});
% 
% %%%
% addvariant(model, turnover_var_No_Surface_Turnover);



%% turnover variant with surface turnover and altered paramerization (reduced activation) - No erythrocyte dependcy on hemolysis, assuming total constant surface!
%%% used for model versions <= V1.35
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% turnover_var_cst_total_surface = sbiovariant('turnover_var_cst_total_surface',...
%      'Notes', ['This variant is with turnover of complement including surface turnover ',...
%      '(assuming total surface constant! No impact from hemolysis on cell concentration). ',...
%      'This variant has an altered parameterization!']);
% 
% % Change paramterization
% addcontent(turnover_var_cst_total_surface, {'parameter', 'k_p_C3(H20)',     'Value', new.k_p_C3_H20}); % 100 fold reduced   
% addcontent(turnover_var_cst_total_surface, {'parameter', 'k_p_C3b_surface', 'Value', new.k_p_C3b_surface}); % 1000 fold reduced   
% % addcontent(turnover_var_cst_total_surface, {'parameter', 'k_p_hC3b',        'Value', new.k_p_hC3b}); % 100 fold reduced   
% 
%     
% addcontent(turnover_var_cst_total_surface, {'parameter', 'k_pr_CR1',  'Value', k_pr.CR1}); % will have to be estimated eventually
% addcontent(turnover_var_cst_total_surface, {'parameter', 'k_pr_CD59', 'Value', k_pr.CD59}); % will have to be estimated eventually
% addcontent(turnover_var_cst_total_surface, {'parameter', 'k_pr_DAF',  'Value', k_pr.DAF}); % will have to be estimated eventually
%     
% % Units in 1/seconds
% %%% surface proteins
% addcontent(turnover_var_cst_total_surface, {'parameter', 'k_el_CR1',             'Value', k_el_erythrocyte}); % surface protein
% addcontent(turnover_var_cst_total_surface, {'parameter', 'k_el_CD59',            'Value', k_el_erythrocyte}); % surface protein
% addcontent(turnover_var_cst_total_surface, {'parameter', 'k_el_DAF',             'Value', k_el_erythrocyte}); % surface protein.
% 
% addcontent(turnover_var_cst_total_surface, {'parameter', 'k_el_SurfaceProtein',  'Value', k_el_erythrocyte}); % generic surface protein
% 
% %%% Fluid phase proteins
% addcontent(turnover_var_cst_total_surface, {'parameter', 'k_el_C3', 'Value', k_el.C3}); 
% addcontent(turnover_var_cst_total_surface, {'parameter', 'k_el_C5', 'Value', k_el.C5});
% addcontent(turnover_var_cst_total_surface, {'parameter', 'k_el_C6', 'Value', k_el.C6});
% addcontent(turnover_var_cst_total_surface, {'parameter', 'k_el_C7', 'Value', k_el.C7});
% addcontent(turnover_var_cst_total_surface, {'parameter', 'k_el_C8', 'Value', k_el.C8}); 
% addcontent(turnover_var_cst_total_surface, {'parameter', 'k_el_C9', 'Value', k_el.C9});
% addcontent(turnover_var_cst_total_surface, {'parameter', 'k_el_D',  'Value', k_el.D});
% addcontent(turnover_var_cst_total_surface, {'parameter', 'k_el_B',  'Value', k_el.B});
% addcontent(turnover_var_cst_total_surface, {'parameter', 'k_el_I',  'Value', k_el.I});
% addcontent(turnover_var_cst_total_surface, {'parameter', 'k_el_P',  'Value', k_el.P});
% 
% addcontent(turnover_var_cst_total_surface, {'parameter', 'k_el_H',  'Value', k_el.H});
% addcontent(turnover_var_cst_total_surface, {'parameter', 'k_el_Vn', 'Value', k_el.Vn});
% addcontent(turnover_var_cst_total_surface, {'parameter', 'k_el_Cn', 'Value', k_el.Cn});
% 
% %%% more fluid phase proteins
% addcontent(turnover_var_cst_total_surface, {'parameter', 'k_el_Ba',    'Value', k_el.Ba});
% addcontent(turnover_var_cst_total_surface, {'parameter', 'k_el_Bb',    'Value', k_el.Bb});
% addcontent(turnover_var_cst_total_surface, {'parameter', 'k_el_C3a',   'Value', k_el.C3a});
% addcontent(turnover_var_cst_total_surface, {'parameter', 'k_el_C5a',   'Value', k_el.C5a});
% addcontent(turnover_var_cst_total_surface, {'parameter',  'k_el_C5b_species',  'Value', k_el.C5b_species});
% addcontent(turnover_var_cst_total_surface, {'parameter',  'k_el_iC3b', 'Value', k_el.iC3b});
% addcontent(turnover_var_cst_total_surface, {'parameter',  'k_el_C3dg', 'Value',  k_el.C3dg});
% 
% %%%
% addvariant(model, turnover_var_cst_total_surface);



%% turnover variant with surface turnover and altered paramerization (reduced activation) - WITH ERYTHROCYTE dependency on hemolysis
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
turnover_var_erythrocyte_turnover = sbiovariant('turnover_var_erythrocyte_turnover',...
     'Notes', ['This variant is with turnover of complement including ',...
     'erythrocyte turnover with depency on predicted hemolysis. ',...
     'This variant has an altered parameterization!']);

% Erythrocyte turnover as a function of hemolysis
addcontent(turnover_var_erythrocyte_turnover, {'parameter', 'k_el_erythrocytes',  'Value', k_el_erythrocyte});

addcontent(turnover_var_erythrocyte_turnover, {'parameter', 'k_pr_erythrocytes',  'Value', 1.1101e-18});
addcontent(turnover_var_erythrocyte_turnover, {'parameter', 'k_pr_surface',  'Value', 1.1101e-18 * 1.4527e+06});

addcontent(turnover_var_erythrocyte_turnover, {'parameter', 'k_hemolysis_on',     'Value', 1});
addcontent(turnover_var_erythrocyte_turnover, {'parameter', 'k_hemolysis_typical_T', 'Value', 7*24*60*60 * scaling_Tyical_T}); % from days to seconds
% addcontent(turnover_var_erythrocyte_turnover, {'parameter', 'k_hemolysis_typical_T', 'Value', 7*24*60*60 * 1/3.3}); % from days to seconds

% Change paramterization
addcontent(turnover_var_erythrocyte_turnover, {'parameter', 'k_p_C3(H20)',     'Value', new.k_p_C3_H20}); % 100 fold reduced   
addcontent(turnover_var_erythrocyte_turnover, {'parameter', 'k_p_C3b_surface', 'Value', new.k_p_C3b_surface}); % 1000 fold reduced   
% addcontent(turnover_var_erythrocyte_turnover, {'parameter', 'k_p_hC3b',        'Value', new.k_p_hC3b}); % 100 fold reduced   

    
addcontent(turnover_var_erythrocyte_turnover, {'parameter', 'k_pr_CR1',  'Value', k_pr.CR1}); % will have to be estimated eventually
addcontent(turnover_var_erythrocyte_turnover, {'parameter', 'k_pr_CD59', 'Value', k_pr.CD59}); % will have to be estimated eventually
addcontent(turnover_var_erythrocyte_turnover, {'parameter', 'k_pr_DAF',  'Value', k_pr.DAF}); % will have to be estimated eventually
    
% Units in 1/seconds
%%% surface proteins
addcontent(turnover_var_erythrocyte_turnover, {'parameter', 'k_el_CR1',             'Value', k_el_erythrocyte}); % surface protein
addcontent(turnover_var_erythrocyte_turnover, {'parameter', 'k_el_CD59',            'Value', k_el_erythrocyte}); % surface protein
addcontent(turnover_var_erythrocyte_turnover, {'parameter', 'k_el_DAF',             'Value', k_el_erythrocyte}); % surface protein.

addcontent(turnover_var_erythrocyte_turnover, {'parameter', 'k_el_SurfaceProtein',  'Value', k_el_erythrocyte}); % generic surface protein

%%% Fluid phase proteins
addcontent(turnover_var_erythrocyte_turnover, {'parameter', 'k_el_C3', 'Value', k_el.C3}); 
addcontent(turnover_var_erythrocyte_turnover, {'parameter', 'k_el_C5', 'Value', k_el.C5});
addcontent(turnover_var_erythrocyte_turnover, {'parameter', 'k_el_C6', 'Value', k_el.C6});
addcontent(turnover_var_erythrocyte_turnover, {'parameter', 'k_el_C7', 'Value', k_el.C7});
addcontent(turnover_var_erythrocyte_turnover, {'parameter', 'k_el_C8', 'Value', k_el.C8}); 
addcontent(turnover_var_erythrocyte_turnover, {'parameter', 'k_el_C9', 'Value', k_el.C9});
addcontent(turnover_var_erythrocyte_turnover, {'parameter', 'k_el_D',  'Value', k_el.D});
addcontent(turnover_var_erythrocyte_turnover, {'parameter', 'k_el_B',  'Value', k_el.B});
addcontent(turnover_var_erythrocyte_turnover, {'parameter', 'k_el_I',  'Value', k_el.I});
addcontent(turnover_var_erythrocyte_turnover, {'parameter', 'k_el_P',  'Value', k_el.P});

addcontent(turnover_var_erythrocyte_turnover, {'parameter', 'k_el_H',  'Value', k_el.H});
addcontent(turnover_var_erythrocyte_turnover, {'parameter', 'k_el_Vn', 'Value', k_el.Vn});
addcontent(turnover_var_erythrocyte_turnover, {'parameter', 'k_el_Cn', 'Value', k_el.Cn});

%%% more fluid phase proteins
addcontent(turnover_var_erythrocyte_turnover, {'parameter', 'k_el_Ba',    'Value', k_el.Ba});
addcontent(turnover_var_erythrocyte_turnover, {'parameter', 'k_el_Bb',    'Value', k_el.Bb});
addcontent(turnover_var_erythrocyte_turnover, {'parameter', 'k_el_C3a',   'Value', k_el.C3a});
addcontent(turnover_var_erythrocyte_turnover, {'parameter', 'k_el_C5a',   'Value', k_el.C5a});
addcontent(turnover_var_erythrocyte_turnover, {'parameter',  'k_el_C5b_species',  'Value', k_el.C5b_species});
addcontent(turnover_var_erythrocyte_turnover, {'parameter',  'k_el_iC3b', 'Value', k_el.iC3b});
addcontent(turnover_var_erythrocyte_turnover, {'parameter',  'k_el_C3dg', 'Value',  k_el.C3dg});

%%%
addvariant(model, turnover_var_erythrocyte_turnover);

end