function simdata = simulate_human_Er_impact_regulators(model, figure_folder, varargin)
%%% simulation of impact of the different regulators on human Er lysis
%%% Approach and assumptions:
%%% -   read-out after 30 min
%%% -   human erythrocytes -> partially disabled surface regulation
%%% -   1E11 cells/L
%%%
%%% This is a simulation of a generic experiment inspried by Ferreira 2007,
%%% Lesher 2013, Wilcox 1991, but does not compare the simulations to data


%% input parser
p = inputParser;

% StopTime of simulation
default.StopTime = 30;  % 30 min
% TimeUnits of simulation
default.TimeUnits = 'minute';
% determine whether plots should be generated and saved
default.plot_on  = 1; 

% add inputs and check validity of format
addRequired(p,  'model',         @(x) strcmp(class(x), 'SimBiology.Model'));
addRequired(p,  'figure_folder', @ischar);
addParameter(p, 'StopTime',      default.StopTime, @isnumeric)
addParameter(p, 'TimeUnits',     default.TimeUnits, @ischar)
addParameter(p, 'plot_on',       default.plot_on, @(x) (isnumeric(x) && x == 0 || x == 1))

% parse results
parse(p, model, figure_folder, varargin{:})

% extract frequently used variables for ease of handling
model           = p.Results.model;
figure_folder   = p.Results.figure_folder;


%% set stop time and time units
cs           = getconfigset(model);
cs.StopTime  = p.Results.StopTime;
cs.TimeUnits = p.Results.TimeUnits;


%% set variables
init_default    = get_ICs(model);

%%% Ferreira 2007
% number of cells 
N_cells = 2.08E11; % cells/L
[Surf_0, ~, ~, ~] = get_surface_erythrocytes(N_cells);
model = set_ICs(model, init_default, 0.4, 'Surface', Surf_0); % 40% serum

%%% Lesher 2013
% % number of cells - unkown, guessed
% N_cells = 1E11; % cells/L
% [Surf_0, ~, ~, ~] = get_surface_erythrocytes(N_cells);
% model = set_ICs(model, init_default, 0.5, 'Surface', Surf_0); % 50% serum



%% define inhibition variants
var.FH     = getvariant(model, 'regulators_NoH_var');
var.FI     = getvariant(model, 'regulators_NoI_var');
var.FHb    = getvariant(model, 'regulators_no_H_binding_var');
var.CD59   = getvariant(model, 'regulators_NoCD59_var');
var.DAF    = getvariant(model, 'regulators_NoDAF_var');
var.CR1    = getvariant(model, 'regulators_NoCR1_var');
var.VnCn   = getvariant(model, 'regulators_NoVnCn_var');
var.P      = getvariant(model, 'regulators_NoP_var');

% FH combinations
var.FH_FI = [getvariant(model, 'regulators_NoH_var'),...
                getvariant(model, 'regulators_NoI_var')];
var.FH_FHb = [getvariant(model, 'regulators_NoH_var'),...
                getvariant(model, 'regulators_no_H_binding_var')];
var.FH_CD59 = [getvariant(model, 'regulators_NoH_var'),...
                getvariant(model, 'regulators_NoCD59_var')];
var.FH_DAF = [getvariant(model, 'regulators_NoH_var'),...
                getvariant(model, 'regulators_NoDAF_var')];
var.FH_CR1 = [getvariant(model, 'regulators_NoH_var'),...
                getvariant(model, 'regulators_NoCR1_var')];
var.FH_VnCn = [getvariant(model, 'regulators_NoH_var'),...
                getvariant(model, 'regulators_NoVnCn_var')];
var.FH_P = [getvariant(model, 'regulators_NoH_var'),...
                getvariant(model, 'regulators_NoP_var')];

% FI combinations
var.FI_FHb = [getvariant(model, 'regulators_NoI_var'),...
                getvariant(model, 'regulators_no_H_binding_var')];
var.FI_CD59 = [getvariant(model, 'regulators_NoI_var'),...
                getvariant(model, 'regulators_NoCD59_var')];
var.FI_DAF = [getvariant(model, 'regulators_NoI_var'),...
                getvariant(model, 'regulators_NoDAF_var')];
var.FI_CR1 = [getvariant(model, 'regulators_NoI_var'),...
                getvariant(model, 'regulators_NoCR1_var')];
var.FI_VnCn = [getvariant(model, 'regulators_NoI_var'),...
                getvariant(model, 'regulators_NoVnCn_var')];
var.FI_P = [getvariant(model, 'regulators_NoI_var'),...
                getvariant(model, 'regulators_NoP_var')];
            
% FH binding combinations
var.FHb_CD59 = [getvariant(model, 'regulators_no_H_binding_var'),...
                getvariant(model, 'regulators_NoCD59_var')];
var.FHb_DAF = [getvariant(model, 'regulators_no_H_binding_var'),...
                getvariant(model, 'regulators_NoDAF_var')];
var.FHb_CR1 = [getvariant(model, 'regulators_no_H_binding_var'),...
                getvariant(model, 'regulators_NoCR1_var')];
var.FHb_VnCn = [getvariant(model, 'regulators_no_H_binding_var'),...
                getvariant(model, 'regulators_NoVnCn_var')];
var.FHb_P = [getvariant(model, 'regulators_no_H_binding_var'),...
                getvariant(model, 'regulators_NoP_var')];
            
% CD59 combinations
var.CD59_DAF = [getvariant(model, 'regulators_NoCD59_var'),...
                getvariant(model, 'regulators_NoDAF_var')];
var.CD59_CR1 = [getvariant(model, 'regulators_NoCD59_var'),...
                getvariant(model, 'regulators_NoCR1_var')];
var.CD59_VnCn = [getvariant(model, 'regulators_NoCD59_var'),...
                getvariant(model, 'regulators_NoVnCn_var')];
var.CD59_P = [getvariant(model, 'regulators_NoCD59_var'),...
                getvariant(model, 'regulators_NoP_var')];
            
% DAF combinations
var.DAF_CR1 = [getvariant(model, 'regulators_NoDAF_var'),...
                getvariant(model, 'regulators_NoCR1_var')];
var.DAF_VnCn = [getvariant(model, 'regulators_NoDAF_var'),...
                getvariant(model, 'regulators_NoVnCn_var')];
var.DAF_P = [getvariant(model, 'regulators_NoDAF_var'),...
                getvariant(model, 'regulators_NoP_var')];
            
% CR1 combinations
var.CR1_VnCn = [getvariant(model, 'regulators_NoCR1_var'),...
                getvariant(model, 'regulators_NoVnCn_var')];
var.CR1_P = [getvariant(model, 'regulators_NoCR1_var'),...
                getvariant(model, 'regulators_NoP_var')];
            
% CnVn combinations
var.VnCn_P = [getvariant(model, 'regulators_NoVnCn_var'),...
                getvariant(model, 'regulators_NoP_var')];
                        
% extract fieldnames to acess them later
fns = fieldnames(var);

%% simulate
% number of unique variants
n_singleVar = 8;
% empty matrix for storing results
M = nan(n_singleVar,n_singleVar);

% diagonal elements
for i = 1:n_singleVar
    var_simdata = sbiosimulate(model, var.(fns{i}));
    plot_var          = selectbyname(var_simdata, {'Percent_Lysis_Takeda', 'Percent_Lysis_Kolb'}); 
    simdata.Time      = plot_var.Time;
    simdata.Lysis     = plot_var.Data(:,1:2);
    M(i,i) = simdata.Lysis(end,1);
end

% FH combinations
for i = 2:n_singleVar
    var_simdata = sbiosimulate(model, var.(fns{i + n_singleVar - 1}));
    plot_var          = selectbyname(var_simdata, {'Percent_Lysis_Takeda', 'Percent_Lysis_Kolb'}); 
    simdata.Time      = plot_var.Time;
    simdata.Lysis     = plot_var.Data(:,1:2);
    M(i,1) = simdata.Lysis(end,1);
    M(1,i) = simdata.Lysis(end,1);
end

% FI combinations
for i = 3:n_singleVar
    var_simdata = sbiosimulate(model, var.(fns{i + n_singleVar*2 - 3}));
    plot_var          = selectbyname(var_simdata, {'Percent_Lysis_Takeda', 'Percent_Lysis_Kolb'}); 
    simdata.Time      = plot_var.Time;
    simdata.Lysis     = plot_var.Data(:,1:2);
    M(i,2) = simdata.Lysis(end,1);
    M(2,i) = simdata.Lysis(end,1);
end
    

% FH bind combinations
for i = 4:n_singleVar
    var_simdata = sbiosimulate(model, var.(fns{i + n_singleVar*3 - 6}));
    plot_var          = selectbyname(var_simdata, {'Percent_Lysis_Takeda', 'Percent_Lysis_Kolb'}); 
    simdata.Time      = plot_var.Time;
    simdata.Lysis     = plot_var.Data(:,1:2);
    M(i,3) = simdata.Lysis(end,1);
    M(3,i) = simdata.Lysis(end,1);
end    

% CD59 combinations
for i = 5:n_singleVar
    var_simdata = sbiosimulate(model, var.(fns{i + n_singleVar*4 - 10}));
    plot_var          = selectbyname(var_simdata, {'Percent_Lysis_Takeda', 'Percent_Lysis_Kolb'}); 
    simdata.Time      = plot_var.Time;
    simdata.Lysis     = plot_var.Data(:,1:2);
    M(i,4) = simdata.Lysis(end,1);
    M(4,i) = simdata.Lysis(end,1);
end   

% DAF combinations
for i = 6:n_singleVar
    var_simdata = sbiosimulate(model, var.(fns{i + n_singleVar*5 - 15}));
    plot_var          = selectbyname(var_simdata, {'Percent_Lysis_Takeda', 'Percent_Lysis_Kolb'}); 
    simdata.Time      = plot_var.Time;
    simdata.Lysis     = plot_var.Data(:,1:2);
    M(i,5) = simdata.Lysis(end,1);
    M(5,i) = simdata.Lysis(end,1);
end  

% CR1 combinations
for i = 7:n_singleVar
    var_simdata = sbiosimulate(model, var.(fns{i + n_singleVar*6 - 21}));
    plot_var          = selectbyname(var_simdata, {'Percent_Lysis_Takeda', 'Percent_Lysis_Kolb'}); 
    simdata.Time      = plot_var.Time;
    simdata.Lysis     = plot_var.Data(:,1:2);
    M(i,6) = simdata.Lysis(end,1);
    M(6,i) = simdata.Lysis(end,1);
end  


% VnCn combinations
for i = 8:n_singleVar
    var_simdata = sbiosimulate(model, var.(fns{i + n_singleVar*7 - 28}));
    plot_var          = selectbyname(var_simdata, {'Percent_Lysis_Takeda', 'Percent_Lysis_Kolb'}); 
    simdata.Time      = plot_var.Time;
    simdata.Lysis     = plot_var.Data(:,1:2);
    M(i,7) = simdata.Lysis(end,1);
    M(7,i) = simdata.Lysis(end,1);
end  


    
%% Plotting
% color bar/scale
c = flipud(autumn(100));
c = c(20:end,:);

% plot the matrix
h = figure;
imagesc(M,'AlphaData',~isnan(M))
% add colormap
colormap(c)
hc = colorbar;
% labeling
xticks(1:8) 
xticklabels({'FH tot', 'FI', 'FH surf', 'CD59', 'DAF', 'CR1', 'Vn+Cn', 'P'})
yticks(1:8)
yticklabels({'FH tot', 'FI', 'FH surf', 'CD59', 'DAF', 'CR1', 'Vn+Cn', 'P'})
set(gca, 'FontSize',11)
set(gca,'XAxisLocation','top','YAxisLocation','left');
% x and ylabel
xlabel('Suppressed regulator', 'FontSize', 16)
ylabel('Suppressed regulator', 'FontSize', 16)
% label for bar
ylabel(hc, 'Hemolysis (%)', 'FontSize', 16)
hc.Limits = [0 100];
set(hc,'YTick',0:10:100)
% add numeric values to figure
Mround = round(M,0);
for i = 1:size(Mround,1)
    for j = i:size(Mround,2)
        text(i-0.25,j,num2str(Mround(i,j)))
    end
end
% save
% saveas(h, [figure_folder, 'Human_Er_Regulators.png'], 'png')
print('-dpng','-r600',[figure_folder, 'Human_Er_Regulators.png'])


%% Restore default initial conditions
model = set_ICs(model, init_default, 1);
end
