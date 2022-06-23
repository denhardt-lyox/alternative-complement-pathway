function validation_sim_Volokhina_2015(model, figure_folder)
%%% simulation of Volokhina 2015, Fig. 1 B & D
%%% assumed 1:1 conversion of measured activity and # of MAC


%% load data
data.Volokhina_1B           = groupedData(readtable('../Data/Volokhina_2015_Fig1B.csv', 'Delimiter', ','));
data.Volokhina_1D           = groupedData(readtable('../Data/Volokhina_2015_Fig1D.csv', 'Delimiter', ','));
data.Volokhina_2_C5defSerum = groupedData(readtable('../Data/Volokhina_2015_Fig2_C5defSerum.csv', 'Delimiter', ','));


%% set and define variables
% Molecular Weights - needed for mass to molar concentration conversion
MW = get_MW;

% dilution - 1/18 standard Wieslab AP protocol
dilution  = 1/18; 

% get default initial conditions 
init_default    = get_ICs(model);
% set IC to dilution used in Wieslab AP protocol
set_ICs(model, init_default, dilution)

% get C5 conc in NHS, needed for reference simulation
C5_default      = init_default.C5_0;
C5_default_ugmL = C5_default * MW.C5 / 1000;

% number of cells - does not apply here, cell-free assay
N_cells = 0; % no cells in assay
Surf_0  = 12.0611; % to be determined

% set surface parameters
% [Surf_0, cells_uM, ~, ] = get_surface_erythrocytes(N_cells);
set(sbioselect(model,'Type','species','Where','Name', '==', 'Surface host'), 'InitialAmount', Surf_0); 
% set(sbioselect(model,'Type','parameter','Where','Name', '==', 'cells_uM'), 'Value', N_cells); 
set(sbioselect(model,'Type','species','Where','Name', '==', 'Erythrocytes_uM'), 'InitialAmount', N_cells); 

% no surface regulation, LPS based assay
var = [getvariant(model, 'regulators_NoDAF_var'),...
                getvariant(model, 'regulators_NoCR1_var'),...
                getvariant(model, 'regulators_NoCD59_var'),...
                getvariant(model, 'regulators_no_H_binding_var')];


%% reference simulation - needed for scaling to % activity
%%% all complement components at default concentrations
%%% same dilution as other experiments
set(sbioselect(model,'Type','species','Where','Name', '==', 'C5'), 'InitialAmount', C5_default * dilution);
var_simdata.reference       = sbiosimulate(model, var);
plot_var.ref                = selectbyname(var_simdata.reference, {'MAC host'});


%% Fig. 1D - supplementation of C5-def. serum with NHS
%%% C5 deficient serum is mixed with NHS to reconstitute C5
%%% 1-100% of total serum used is NHS
%%% assume constant concentration of all species except C5
%%% set C5 to 1 - 100% of NHS conc 
%%% used Wieslab assay dilution
set(sbioselect(model,'Type','species','Where','Name', '==', 'C5'), 'InitialAmount', 0); %C5 deficient serum

% define ranges of NHS to be simulated - percent NHS of total serum
C5_NHS_array = [1 2 4 8 16 32 64 100]; % 
% preallocate readouts
percent_activity.NHS = zeros(size(C5_NHS_array)); 

% loop over NHS percentages
for n = 1:length(C5_NHS_array)
    % set C5 concentration
    set(sbioselect(model,'Type','species','Where','Name', '==', 'C5'), 'InitialAmount', C5_NHS_array(n)/100 * C5_default * dilution); %C5 supplementation
    % simulate
    var_simdata.NHS         = sbiosimulate(model, var);

    % store readouts
    plot_var.temp               = selectbyname(var_simdata.NHS, {'MAC host', 'C5', 'C5b'});
    percent_activity.MAC(n)     = plot_var.temp.Data(end,1);
    % activity = defined as amount of MAC normalized to reference simulation
    percent_activity.NHS(n)     = plot_var.temp.Data(end,1)/plot_var.ref.Data(end,1) * 100; 
end
% remove variables for safety reasons, will be redefined in next experiment
clearvars var_simdata plot_var.temp


%% Fig. 1B - supplementation of C5-def. serum with C5
%%% C5 deficient serum is reconstituted with purified C5
%%% assumed C5 concentrations given in manuscript to be concentrations
%%% prior to dilution of serum for Wieslab assay 

% C5 concentrations in ug/mL to be simulated
C5_ugmL = [1 2 4 8 16 32 64 128 256 512];
% convert to uM
C5_uM   = C5_ugmL .* 1000 ./ MW.C5;

% preallocate readouts
percent_activity.C5 = zeros(size(C5_uM));

% loop over C5 concentrations
for n = 1:length(C5_uM)
    % set C5 conc, use dilution for Wieslab AP assay
    set(sbioselect(model,'Type','species','Where','Name', '==', 'C5'), 'InitialAmount', C5_uM(n) * dilution); 
    % simulate
    var_simdata.c5         = sbiosimulate(model, var);

    % store readouts
    plot_var.temp               = selectbyname(var_simdata.c5, {'MAC host'});
    % activity = defined as amount of MAC normalized to reference simulation
    percent_activity.C5(n)      = plot_var.temp.Data(end,1)/plot_var.ref.Data(end,1) * 100; 
end
clearvars var_simdata plot_var.temp 


%% plotting - to be moved to seperate file
h = figure;
hold on
plot(C5_NHS_array, percent_activity.NHS, '-k', 'LineWidth', 1.5)
plot(data.Volokhina_1D.NHS_percent, data.Volokhina_1D.AP_activity_percent, '*k', 'MarkerSize', 9)
% plot(data.Volokhina_2_C5defSerum.NHS_percent, data.Volokhina_2_C5defSerum.AP_Activity_C5def_serum, '.')
% set(gca, 'XScale', 'log')
xlabel('NHS (%)', 'FontSize' ,14)
ylabel('AP activity (%)', 'FontSize' ,14)
set(gca,'fontWeight','bold')
grid on
saveas(h, [figure_folder, 'Volokhina_2015_1D.png'], 'png')


h = figure;
hold on
plot(C5_ugmL, percent_activity.C5, '-k', 'LineWidth', 1.5)
plot(data.Volokhina_1B.C5_ug_ml, data.Volokhina_1B.AP_activity_percent, '*k', 'MarkerSize', 9)
% plot([C5_default_ugmL C5_default_ugmL], [0 300], '--k')
xlabel('C5 (ug/mL)', 'FontSize' ,14)
ylabel('AP activity (%)', 'FontSize' ,14)
set(gca,'fontWeight','bold')
set(gca, 'XScale', 'log')
grid on
saveas(h, [figure_folder, 'Volokhina_2015_1B.png'], 'png')   

%% restore default
set_ICs(model, init_default, 1)
end