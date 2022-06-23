function REACTION_PARAMETER_UPDATES_FITTING(model, select_fit)
% Changes of "original" parameter values from Zewde, 2016
% Changes to fit validation simulations 

%% QC
if((select_fit.fit_manual + select_fit.fit_auto_Man_Selection + ...
        select_fit.fit_auto_Auto_Selection_Wo_Thanassi + ...
        select_fit.fit_auto_Auto_Selection_With_Thanassi) > 1)
    msg = ['You must not select more than one of the parameter sets. ', ...
        'Execution will stop now.'];
    error (msg)
end

%% Manual fits -  Updates of parameters to match validation simulations
if(select_fit.fit_manual == 1)
    % % % % set(sbioselect(model,'Type','species','Where','Name', '==', 'H'), 'InitialAmount', 0);
    % % % 
    % % % % set(sbioselect(model,'Type','parameter','Where','Name', '==', 'k_p_C3b_surface'),  'Value',4.2e8*1E5); %5E4
    % % % % set(sbioselect(model,'Type','parameter','Where','Name', '==', 'k_p_hC3b'),  'Value',4.2E8*1E4);
    % % % % 
    % % % % set(sbioselect(model,'Type','parameter','Where','Name', '==', 'k_p_C3bBbDAF'),  'Value', 2.0e3*1.5E5);%1E5 % determines degree of lysis in anti-CD59 AB case
    % % % % set(sbioselect(model,'Type','parameter','Where','Name', '==', 'k_p_CD59C5b9'),  'Value',1.0e6*2E5); % influences only lysis
    % % % 
    % % % set(sbioselect(model,'Type','parameter','Where','Name', '==', 'k_p_C3bBbDAF'),  'Value', 2.0e3*1.25E5);%1.5E5 % determines degree of lysis in anti-CD59 AB case
    % % % set(sbioselect(model,'Type','parameter','Where','Name', '==', 'k_p_CD59C5b9'),  'Value',1.0e6*2E5); % influences only lysis

    set(sbioselect(model,'Type','parameter','Where','Name', '==', 'k_p_C3b_surface'),  'Value',4.2e8*1E6  / 1.944250E6); %5E4
    set(sbioselect(model,'Type','parameter','Where','Name', '==', 'k_p_hC3b'),  'Value',4.2E8*1E4  / 1.944250E6); 
end


%% Automatic fit 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% MANUAL SELECTION OF FITTED PARAMETERS + AUTOMATIC FITTING 
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% x_optimal = [15.6168      10.7168      9.30233      12.2402     0.475774     -5.17861];
if(select_fit.fit_auto_Man_Selection == 1)
    set(sbioselect(model,'Type','parameter','Where','Name', '==', 'k_p_C3b_surface'),  'Value', 4.1381e+15) 
    set(sbioselect(model,'Type','parameter','Where','Name', '==', 'k_p_hC3b'),         'Value', 5.2095e+10); 

    set(sbioselect(model,'Type','parameter','Where','Name', '==', 'k_p_C3bBbDAF'),     'Value', 2.0060e+09); % determines degree of lysis in anti-CD59 AB case
    set(sbioselect(model,'Type','parameter','Where','Name', '==', 'k_p_CD59C5b9'),     'Value', 1.7386e+12); % influences only lysis

    set(sbioselect(model,'Type','parameter','Where','Name', '==', 'k_C5_cat_C3bBbC3b'),'Value', 2.9907);
    set(sbioselect(model,'Type','parameter','Where','Name', '==', 'K_C3_m_C3bBbP'),    'Value', 6.6281e-06);
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%% Step-wise selection of fitted parameters
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% EXCLUDING FITTING OF THANASSI 
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% fminbnd
if(select_fit.fit_auto_Auto_Selection_Wo_Thanassi == 1)
%     set(sbioselect(model,'Type','parameter','Where','Name', '==', 'k_p_C3b_surface'),  'Value', 4.2e+15) %
%     set(sbioselect(model,'Type','parameter','Where','Name', '==', 'k_p_hC3b'),         'Value', 5.2e+10); %
    set(sbioselect(model,'Type','parameter','Where','Name', '==', 'k_p_C3b_surface'),  'Value', 4.2e+15 / 1.944250E6) %
    set(sbioselect(model,'Type','parameter','Where','Name', '==', 'k_p_hC3b'),         'Value', 5.2e+10 / 1.944250E6); %
%%% step 03
    set(sbioselect(model,'Type','parameter','Where','Name', '==', 'k_p_CD59C5b9'),     'Value', 6.028e+11); 
%%% step 04
    set(sbioselect(model,'Type','parameter','Where','Name', '==', 'k_p_C3bP'),     'Value', 1.237e+08); 
%%% step 05
%     set(sbioselect(model,'Type','parameter','Where','Name', '==', 'k_p_C3bBbDAF'),     'Value', 1.007e+10); 
%%% step 06
    set(sbioselect(model,'Type','parameter','Where','Name', '==', 'K_C3_m_C3(H2O)Bb'),     'Value', 4.191e-06); 
%%% step 07
%   no new parameters
%     set(sbioselect(model,'Type','parameter','Where','Name', '==', 'k_p_C3bBbDAF'),     'Value', 1.8363e+10); 
%%% step 08
    set(sbioselect(model,'Type','parameter','Where','Name', '==', 'k_m_C3bBbDAF decay'),     'Value', 2.2756e-03); 
%%% step 09
    set(sbioselect(model,'Type','parameter','Where','Name', '==', 'k_p_C3bBbC3bC5bC6'),     'Value', 7.7436e+04); 
%%% step 10
    set(sbioselect(model,'Type','parameter','Where','Name', '==', 'k_p_C3bBbDAF'),     'Value', 2.5295e+10); 
    
% %%% step 11
    set(sbioselect(model,'Type','parameter','Where','Name', '==', 'k_p_C3bB'),     'Value', 2.2259e+05); 
    
% %%% step 12
%     set(sbioselect(model,'Type','parameter','Where','Name', '==', 'k_p_C3bBbDAF'),     'Value', 2.9030e+10); 
% %%% step 13
%     set(sbioselect(model,'Type','parameter','Where','Name', '==', 'k_p_C3bH_surf'),     'Value', 1.0345e+06); 
% %%% step 14
%     set(sbioselect(model,'Type','parameter','Where','Name', '==', 'k_m_C3bBbC3b'),     'Value', 2.5386e+01 ); 
% %%% step 15
%     set(sbioselect(model,'Type','parameter','Where','Name', '==', 'k_m_CD59C5b9'),     'Value', 5.3416e-04); 







% starting from the middle of the earlier estimate
% %%% step 00
%     set(sbioselect(model,'Type','parameter','Where','Name', '==', 'k_p_hC3b'),         'Value', 4.2e+13 / 1.944250E6); 
% %%% step 01
%     set(sbioselect(model,'Type','parameter','Where','Name', '==', 'k_p_CD59C5b9'),     'Value', 5.5893e+12);    
% %%% step 02
%     set(sbioselect(model,'Type','parameter','Where','Name', '==', 'k_p_C3bH'),     'Value', 3.2759e+05); 
% %%% step 03
%     set(sbioselect(model,'Type','parameter','Where','Name', '==', 'k_p_CD59C5b9'),     'Value', 3.0960e+12); 
% %%% step 04
%     set(sbioselect(model,'Type','parameter','Where','Name', '==', 'k_p_C3bBbDAF'),     'Value', 1.0062e+09); 
% %%% step 05
%     set(sbioselect(model,'Type','parameter','Where','Name', '==', 'k_p_C3bH_surf'),     'Value', 8.5835e+05); 
% %     set(sbioselect(model,'Type','parameter','Where','Name', '==', 'k_p_C3bH'),     'Value', 8.5835e+05); 
% %%% step 06
%     set(sbioselect(model,'Type','parameter','Where','Name', '==', 'k_p_C3bBbDAF'),     'Value', 1.6365e+09); 
% %%% step 07
%     set(sbioselect(model,'Type','parameter','Where','Name', '==', 'k_p_C5b7 surface'),     'Value', 1.1728e+09); 
% %%% step 08
%     set(sbioselect(model,'Type','parameter','Where','Name', '==', 'k_p_C3bBbDAF'),     'Value', 2.2647e+09); 
% %%% step 09
%     set(sbioselect(model,'Type','parameter','Where','Name', '==', 'k_m_C3bBbC3b'),     'Value', 1.0750e+00); 


% % starting from the original publication
% %%% step 01
%     set(sbioselect(model,'Type','parameter','Where','Name', '==', 'k_p_hC3b'),         'Value', 2.317e+7); 
% %%% step 02
%     set(sbioselect(model,'Type','parameter','Where','Name', '==', 'k_p_CD59C5b9'),         'Value', 9.7154e+12); 
% %%% step 03
% %     set(sbioselect(model,'Type','parameter','Where','Name', '==', 'k_p_C3bH'),         'Value', 3.3342e+05); 
%     set(sbioselect(model,'Type','parameter','Where','Name', '==', 'k_p_fC3b'),         'Value', 5.2175e+00); 
% %%% step 04
%     set(sbioselect(model,'Type','parameter','Where','Name', '==', 'k_p_C5b9'),         'Value', 5.4145e+10); 


end

%%% fminserch
% if(1)
%     set(sbioselect(model,'Type','parameter','Where','Name', '==', 'k_p_C3b_surface'),  'Value', 4.2e+15) 
%     set(sbioselect(model,'Type','parameter','Where','Name', '==', 'k_p_hC3b'),         'Value', 5.2e+10); 
% 
% %%% step 03
%     set(sbioselect(model,'Type','parameter','Where','Name', '==', 'k_p_CD59C5b9'),     'Value', 6.028e+11); 
% %%% step 04
%      set(sbioselect(model,'Type','parameter','Where','Name', '==', 'k_p_C3bP'),     'Value', 1.237e+08); 
% %%% step 05
% 
% end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% WITH FITTING OF THANASSI 
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% fminbnd
if(select_fit.fit_auto_Auto_Selection_With_Thanassi == 1)
    set(sbioselect(model,'Type','parameter','Where','Name', '==', 'k_p_C3b_surface'),  'Value', 4.2e+15) 
    set(sbioselect(model,'Type','parameter','Where','Name', '==', 'k_p_hC3b'),         'Value', 5.2e+10); 
    
%%% step 03
    set(sbioselect(model,'Type','parameter','Where','Name', '==', 'K_C3_m_C3bBb'),     'Value', 4.8e-07); 
%%% step 04
    set(sbioselect(model,'Type','parameter','Where','Name', '==', 'k_p_CD59C5b9'),  'Value',9.89e+12);
%%% step 05
    set(sbioselect(model,'Type','parameter','Where','Name', '==', 'k_m_C5b'),  'Value',0.04803);
%%% step 06
    set(sbioselect(model,'Type','parameter','Where','Name', '==', 'k_p_C3bP'),  'Value',7.7124e+06);
%%% step 07
%     set(sbioselect(model,'Type','parameter','Where','Name', '==', 'k_p_C3bBbDAF'),  'Value', 1.0720e+09);
%%% step 08
    set(sbioselect(model,'Type','parameter','Where','Name', '==', 'k_p_C3bBbC3b'),  'Value', 4.7912e+06);
%%% step 09
    set(sbioselect(model,'Type','parameter','Where','Name', '==', 'k_m_C3bBbDAF decay'),  'Value', 5.4673e-03);
%%% step 10
    set(sbioselect(model,'Type','parameter','Where','Name', '==', 'k_p_C3bBbDAF'),  'Value', 1.5577e+09);
%%% step 11

end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

end
