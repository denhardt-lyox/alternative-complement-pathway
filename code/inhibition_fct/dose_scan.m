function [drug_uM, C3a_vec, C5a_vec, MAC_vec, C3dg_vec, target, lysis_vec] = dose_scan(model, drug, target, complex, binding_par, figure_folder)

%drug    = [target, 'drug'];
%complex = [drug, ' ', target];

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Simulation without any intervention
simdata_ref       = sbiosimulate(model);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Simulation with intervention at a single concentration
V_vitreous        = 0.004; % L
concentration_uM  = 10/150000*10^3/V_vitreous; % lampalizumab concentration after 10 mg intravitreal dose
concentration_uM = 0.1;
% concentration_uM = 1;

set(sbioselect(model,'Type','species','Where','Name', '==', drug), 'InitialAmount', concentration_uM);
set(sbioselect(model,'Type','parameter','Where','Name', '==', binding_par.kon_name),  'Value', binding_par.kon);
set(sbioselect(model,'Type','parameter','Where','Name', '==', binding_par.koff_name), 'Value', binding_par.koff);


simdata_inh       = sbiosimulate(model);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Plot time response
plot_ref        = selectbyname(simdata_ref, {'B'});
plot_inh        = selectbyname(simdata_inh, {'B'});

h = figure;
hold on;
plot(plot_ref.Time,  plot_ref.Data(:,1), 'k',   'linewidth', 1);
plot(plot_inh.Time,  plot_inh.Data(:,1), 'k--', 'linewidth', 1);
leg=legend('B reference', 'B intervention');
set(leg, 'Interpreter', 'none');
xlabel(['Time (',plot_ref.TimeUnits, ')'], 'FontSize' ,14)
ylabel('Concentration (uM)', 'FontSize' ,14)
limsy=get(gca,'YLim');
set(gca,'Ylim',[0 limsy(2)]);
set(gca,'fontWeight','bold')
set(gca,'FontSize',14)
grid on
saveas(h, [figure_folder, drug, '_time_response_B.png'], 'png')


plot_ref        = selectbyname(simdata_ref, {'C3a'});
plot_inh        = selectbyname(simdata_inh, {'C3a'});

plot_ref_TCD    = selectbyname(simdata_ref, {target, complex, drug});
plot_inh_TCD    = selectbyname(simdata_inh, {target, complex, drug});

h = figure;
hold on;
plot(plot_ref.Time,  plot_ref.Data(:,1), 'g',   'linewidth', 1);
plot(plot_inh.Time,  plot_inh.Data(:,1), 'g--', 'linewidth', 1);
plot(plot_inh_TCD.Time,  plot_inh_TCD.Data(:,2), 'k:',  'linewidth', 1);
leg=legend('C3a reference', 'C3a intervention', 'complex');
set(leg, 'Interpreter', 'none');
xlabel(['Time (',plot_ref.TimeUnits, ')'], 'FontSize' ,14)
ylabel('Concentration (uM)', 'FontSize' ,14)
limsy=get(gca,'YLim');
set(gca,'Ylim',[0 limsy(2)]);
set(gca,'fontWeight','bold')
set(gca,'FontSize',14)
grid on
saveas(h, [figure_folder, drug, '_time_response_C3a.png'], 'png')

h = figure;
hold on;
plot(plot_ref.Time,  plot_ref.Data(:,1), 'g',   'linewidth', 1);
plot(plot_inh.Time,  plot_inh.Data(:,1), 'g--', 'linewidth', 1);
plot(plot_inh_TCD.Time,  plot_inh_TCD.Data(:,2), 'k:',  'linewidth', 1);
plot(plot_inh_TCD.Time,  plot_inh_TCD.Data(:,3), 'k-.', 'linewidth', 1);
leg=legend('C3a reference', 'C3a intervention', 'complex', drug);
set(leg, 'Interpreter', 'none');
xlabel(['Time (',plot_ref.TimeUnits, ')'], 'FontSize' ,14)
ylabel('C3a (uM)', 'FontSize' ,14)
limsy=get(gca,'YLim');
set(gca,'Ylim',[0 limsy(2)]);
set(gca,'fontWeight','bold')
set(gca,'FontSize',14)
grid on
saveas(h, [figure_folder, drug, '_time_response.png'], 'png')

h = figure;
hold on;
plot(plot_ref.Time,  plot_ref_TCD.Data(:,1), 'k',   'linewidth', 1);
plot(plot_inh.Time,  plot_inh_TCD.Data(:,1), 'k--', 'linewidth', 1);
leg=legend([target, ' reference'], [target, ' intervention']);
set(leg, 'Interpreter', 'none');
xlabel(['Time (',plot_ref.TimeUnits, ')'], 'FontSize' ,14)
ylabel('Conc (uM)', 'FontSize' ,14)
% ylim([0 10^ceil(log10(max(max(plot_ref.Data(:,2)),max(plot_inh.Data(:,2)))))])
limsy=get(gca,'YLim');
set(gca,'Ylim',[0 limsy(2)]);
set(gca,'fontWeight','bold')
set(gca,'FontSize',14)
% set(gca,'YScale','log');
grid on
saveas(h, [figure_folder, drug, '_time_response_Target.png'], 'png')
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Simulation for concentration effect analysis
drug_uM = [0, 10^(-4), logspace(-3, 0, 100), 10^1];
clear target_vec  complex_vec  drug_vec

for n=1:length(drug_uM)
    


%     copiedModel = copyobj(model);
%       cs                                  = getconfigset(copiedModel);
%     cs.StopTime                         = 2;
%     
%     init = get_ICs(copiedModel);
%     set_ICs(copiedModel, init, 0)
%     set(sbioselect(copiedModel,'Type','species',  'Where','Name', '==', drug), 'InitialAmount', drug_uM(n));
%     set(sbioselect(copiedModel,'Type','species',  'Where','Name', '==', 'C5'), 'InitialAmount', init.C5_0);
%     simdata_ss = sbiosimulate(copiedModel);
%     ss     = selectbyname(simdata_ss, {'C5'});
%     C5_ss = ss.Data(end);
%     
%     C5_0 = C5_ss;
%     drug_ss = drug_uM(n) - (init.C5_0 - C5_ss);
%     complex_ss = (init.C5_0 - C5_ss);
%     
%     set(sbioselect(model,'Type','species',  'Where','Name', '==', drug), 'InitialAmount', drug_ss);
%     set(sbioselect(model,'Type','species',  'Where','Name', '==', complex), 'InitialAmount', complex_ss);
%     set(sbioselect(model,'Type','species',  'Where','Name', '==', 'C5'), 'InitialAmount', C5_ss);

    set(sbioselect(model,'Type','species',  'Where','Name', '==', drug), 'InitialAmount', drug_uM(n));
    simdata_inh = sbiosimulate(model);

    inh     = selectbyname(simdata_inh, {'C3a', 'C5a', '[MAC host]', '[C3dg fluid]', 'Percent_Lysis_Takeda', 'Percent_Lysis_Kolb'});
    inh_TCD = selectbyname(simdata_inh, {target, complex, drug});
    
    C3a_vec(n)      = inh.Data(end,1);
    C5a_vec(n)      = inh.Data(end,2);
    MAC_vec(n)      = inh.Data(end,3);
    C3dg_vec(n)     = inh.Data(end,4);
    lysis_vec(1:2,n)= inh.Data(end,5:6);
    target_vec(n)   = inh_TCD.Data(end,1);
    complex_vec(n)  = inh_TCD.Data(end,2);
    drug_vec(n)     = inh_TCD.Data(end,3);
end



h = figure;
%plot(drug_uM, target_vec, 'g--', drug_uM, complex_vec, 'k:', drug_uM, drug_vec, 'k-.');
%leg=legend(target, complex, 'Free drug');
plot(drug_uM, C3a_vec, 'g', drug_uM, target_vec, 'k-', drug_uM, complex_vec, 'k:', drug_uM, drug_vec, 'k-.');
leg=legend('C3a', target, complex, 'Free drug');
set(gca,'XScale','log');
set(gca,'FontSize',14)
set(leg, 'Interpreter', 'none');
xlabel([drug, '  concentration (uM)'], 'FontSize' ,14);
ylabel('C3a (uM)', 'FontSize' ,14);
%line([concentration_uM concentration_uM], get(gca,'XLim'), 'Color', [0 0 0 ]);
%ylim([0 1.5e-1])
saveas(h, [figure_folder, drug, '_conc_response.png'], 'png')
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


set(sbioselect(model,'Type','species','Where','Name', '==', drug), 'InitialAmount', 0);
set(sbioselect(model,'Type','parameter','Where','Name', '==', binding_par.kon_name),  'Value', 0);
set(sbioselect(model,'Type','parameter','Where','Name', '==', binding_par.koff_name), 'Value', 0);


set(sbioselect(model,'Type','species','Where','Name', '==', drug), 'InitialAmount', 0);
set(sbioselect(model,'Type','parameter','Where','Name', '==', binding_par.kon_name),  'Value', 0);
set(sbioselect(model,'Type','parameter','Where','Name', '==', binding_par.koff_name), 'Value', 0);

close all
end